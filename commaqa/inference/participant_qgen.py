import random
from itertools import product

from commaqa.inference.model_search import ParticipantModel
from commaqa.inference.utils import get_sequence_representation
from commaqa.models.generator import LMGenerator


class LMGenParticipant(ParticipantModel):

    def __init__(self, scale_by_step=1, add_eos=False, add_prefix="", next_model="execute",
                 end_state="[EOQ]", **kwargs):
        self.scale_by_step = scale_by_step
        self.add_eos = add_eos
        self.add_prefix = add_prefix
        self.next_model = next_model
        self.end_state = end_state
        self.lmgen = LMGenerator(**kwargs)

    def query(self, state, debug=False):
        """The main function that interfaces with the overall search and
        model controller, and manipulates the incoming data.

        :param data: should have a dictionary as input containing
          mutable data
        :type data: dict
        :param state: the state of controller and model flow.
        :type state: launchpadqa.question_search.model_search.SearchState
        :rtype: list
        :raises: ValueError
        """
        ## first checks state of `json_input` to figure out how to format things
        ## the first question
        data = state.data
        question_seq = data["question_seq"]
        answer_seq = data["answer_seq"]
        model_seq = data["model_seq"]
        operation_seq = data["operation_seq"]
        gen_seq = get_sequence_representation(origq=data["query"], question_seq=question_seq,
                                              answer_seq=answer_seq,
                                              # model_seq=model_seq,
                                              # operation_seq=operation_seq,
                                              for_generation=True)
        if self.add_prefix:
            gen_seq = self.add_prefix + gen_seq
        if self.add_eos:
            gen_seq = gen_seq + "</s>"

        if debug: print("<GEN>: %s" % gen_seq)

        ## eventual output
        new_states = []
        ## go through generated questions
        output_seq_scores = self.lmgen.generate_text_sequence(gen_seq)

        observed_outputs = set()
        for (output_seq, score) in output_seq_scores:
            output = output_seq.strip()
            # catch potentially spurious duplicates
            if output in observed_outputs:
                continue
            else:
                observed_outputs.add(output)
            # copy state
            new_state = state.copy()
            ## add new question to question_seq
            new_state.data["question_seq"].append(output)
            if output == self.end_state:
                new_state.next = self.end_state
            else:
                new_state.next = self.next_model
            # lower is better, same as the scores returned by generate_text_sequence
            assert score >= 0, "Score from generation assumed to be +ve. Got: {}! Needs to be " \
                               "+ve to ensure monotonically increasing scores as expected by the" \
                               " search.".format(score)
            new_state._score += score
            new_state.data["score_seq"].append(score)
            new_state.data["command_seq"].append("gen")
            ## mark the last output
            new_state.last_output = output
            new_states.append(new_state)
        ##
        return new_states


class RandomGenParticipant(ParticipantModel):

    def __init__(self, operations_file, model_questions_file, sample_operations, sample_questions,
                 next_model="execute", end_state="[EOQ]"):
        self.operations = self.load_operations(operations_file)
        self.model_questions = self.load_model_questions(model_questions_file)
        self.sample_operations = sample_operations
        self.sample_questions = sample_questions
        self.end_state = end_state
        self.next_model = next_model

    def load_operations(self, operations_file):
        with open(operations_file, "r") as input_fp:
            ops = [x.strip() for x in input_fp.readlines()]
        return ops

    def load_model_questions(self, model_questions_file):
        model_questions = []
        with open(model_questions_file, "r") as input_fp:
            for line in input_fp:
                fields = line.strip().split("\t")
                model_questions.append((fields[0], fields[1]))
        return model_questions

    def sample(self, population, sample_size_or_prop):
        if sample_size_or_prop >= 1:
            return random.sample(population, k=sample_size_or_prop)
        else:
            return random.sample(population, k=sample_size_or_prop * len(population))

    def build_end_state(self, state):
        new_state = state.copy()
        output = self.end_state
        new_state.data["question_seq"].append(output)
        new_state.next = self.end_state
        new_state.data["score_seq"].append(0)
        new_state.data["command_seq"].append("gen")
        ## mark the last output
        new_state.last_output = output
        return new_state

    def query(self, state, debug=False):
        data = state.data
        if len(data["question_seq"]) > 5:
            return [self.build_end_state(state)]

        ops = self.sample(self.operations, self.sample_operations)
        model_questions = self.sample(self.model_questions, self.sample_questions)
        op_model_qs_prod = product(ops, model_questions)
        ## eventual output
        new_states = []
        for (op, model_qs) in op_model_qs_prod:
            (model, question) = model_qs
            # copy state
            new_state = state.copy()
            output = "({}) [{}] {}".format(op, model, question)

            ## add new question to question_seq
            new_state.data["question_seq"].append(output)
            new_state.next = self.next_model
            new_state.data["score_seq"].append(0)
            new_state.data["command_seq"].append("gen")
            ## mark the last output
            new_state.last_output = output
            new_states.append(new_state)
        ##
        # if len(data["question_seq"]) > 0:
        #     new_states.append(self.build_end_state(state))
        return new_states
