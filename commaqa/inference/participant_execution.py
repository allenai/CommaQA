import json
import logging
import re

from commaqa.configs.predicate_language_config import ModelQuestionConfig
from commaqa.dataset.utils import valid_answer, nonempty_answer
from commaqa.execution.operation_executer import OperationExecuter
from commaqa.execution.utils import build_models
from commaqa.inference.model_search import ParticipantModel

logger = logging.getLogger(__name__)


class ExecutionParticipant(ParticipantModel):
    def __init__(self, remodel_file, next_model="gen", skip_empty_answers=False):
        self.next_model = next_model
        self.skip_empty_answers = skip_empty_answers
        if remodel_file:
            with open(remodel_file, "r") as input_fp:
                input_json = json.load(input_fp)
            self.kb_lang_groups = []
            self.qid_to_kb_lang_idx = {}
            for input_item in input_json:
                kb = input_item["kb"]
                pred_lang = input_item["pred_lang_config"]
                idx = len(self.kb_lang_groups)
                self.kb_lang_groups.append((kb, pred_lang))
                for qa_pair in input_item["qa_pairs"]:
                    qid = qa_pair["id"]
                    self.qid_to_kb_lang_idx[qid] = idx
            self.operation_regex = re.compile("\((.+)\) \[([^\]]+)\] (.*)")

    def query(self, state, debug=False):
        """The main function that interfaces with the overall search and
        model controller, and manipulates the incoming data.

        :param state: the state of controller and model flow.
        :type state: launchpadqa.question_search.model_search.SearchState
        :rtype: list
        """
        ## the data
        data = state._data
        question = data["question_seq"][-1]
        qid = data["qid"]
        (kb, pred_lang) = self.kb_lang_groups[self.qid_to_kb_lang_idx[qid]]
        model_configurations = {}
        for model_name, configs in pred_lang.items():
            model_configurations[model_name] = [ModelQuestionConfig(config) for config in configs]
        model_lib = build_models(model_configurations, kb, ignore_input_mismatch=True)
        ### run the model (as before)
        if debug: print("<OPERATION>: %s, qid=%s" % (question, qid))
        m = self.operation_regex.match(question)
        if m is None:
            logger.debug("No match for {}".format(question))
            return []
        assignment = {}
        for ans_idx, ans in enumerate(data["answer_seq"]):
            assignment["#" + str(ans_idx + 1)] = json.loads(ans)
        executer = OperationExecuter(model_library=model_lib, ignore_input_mismatch=True)
        answers, facts_used = executer.execute_operation(operation=m.group(1),
                                                         model=m.group(2),
                                                         question=m.group(3),
                                                         assignments=assignment)
        if not valid_answer(answers):
            logger.debug("Invalid answer!", qid, question, ", ".join(data["question_seq"]))
            return []
        if self.skip_empty_answers and not nonempty_answer(answers):
            logger.debug("Empty answer", qid, question, ", ".join(data["question_seq"]))
            return []

        # copy state
        new_state = state.copy()

        ## add answer
        new_state.data["answer_seq"].append(json.dumps(answers))
        new_state.data["para_seq"].append("")
        new_state.data["command_seq"].append("qa")
        new_state.data["model_seq"].append(m.group(2))
        new_state.data["operation_seq"].append(m.group(1))
        new_state.data["subquestion_seq"].append(m.group(3))
        ## change output
        new_state.last_output = answers
        new_state.next = self.next_model

        return [new_state]
