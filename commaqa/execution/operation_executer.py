import json
import logging

from commaqa.dataset.utils import flatten_list, get_predicate_args, get_answer_indices


logger = logging.getLogger(__name__)

class OperationExecuter:

    def __init__(self, model_library, ignore_input_mismatch=False):
        self.model_library = model_library
        self.ignore_input_mismatch = ignore_input_mismatch

    def execute_sub_operations(self, answers, operation):
        operation_seq = operation.split("_")
        for op in operation_seq[1:]:
            if op == "flat":
                answers = flatten_list(answers)
            elif op == "unique":
                answers = list(set(answers))
            elif op == "keys":
                answers = [x[0] for x in answers]
            elif op == "values":
                answers = [x[1] for x in answers]
            else:
                raise ValueError("SUBOP: Unknown sub-operation: {}".format(op))
        return answers

    def execute_select(self, operation, model, question, assignments):
        assert model in self.model_library, "Model: {} not found in model library!".format(
            model)
        indices = get_answer_indices(question)
        for index in indices:
            idx_str = "#" + str(index)
            if idx_str not in assignments:
                raise ValueError("SELECT: Can not perform select operation with input arg: {}"
                                 " No assignments yet!".format(idx_str))
            question = question.replace(idx_str, json.dumps(assignments[idx_str]))
        answers, facts_used = self.model_library[model].ask_question(question)
        answers = self.execute_sub_operations(answers, operation)
        return answers, facts_used

    def execute_project(self, operation, model, question, assignments):
        # print(question, assignments)
        assert model in self.model_library,\
            "Model: {} not found in model library!".format(model)
        indices = get_answer_indices(question)
        if len(indices) > 1:
            raise ValueError("PROJECT: Can not handle more than one answer idx: {} "
                             "for project: {}".format(indices, question))
        if len(indices) == 0:
            raise ValueError("PROJECT: Did not find any indices to project on " + str(question))
        idx_str = "#" + str(indices[0])
        if idx_str not in assignments:
            raise ValueError("PROJECT: Can not perform project operation with input arg: {}"
                             " No assignments yet!".format(idx_str))
        answers = []
        facts_used = []
        operation_seq = operation.split("_")
        first_op = operation_seq[0]
        if not isinstance(assignments[idx_str], list):
            raise ValueError("PROJECT: Can not perform project operation on a non-list input: {}"
                             " Operation: {} Question: {}".format(assignments[idx_str],
                                                                  operation, question))
        for item in assignments[idx_str]:
            # print(idx_str, item, assignments)
            if first_op == "projectValues":
                # item should be a tuple
                if not isinstance(item, tuple):
                    raise ValueError("PROJECT: Item: {} is not a tuple in assignments: {}. "
                                     "Expected for projectValues".format(item,
                                                                         assignments[idx_str]))
                new_question = question.replace(idx_str, json.dumps(item[1]))
            elif first_op == "projectKeys":
                # item should be a tuple
                if not isinstance(item, tuple):
                    raise ValueError("PROJECT: Item: {} is not a tuple in assignments: {}. "
                                     "Expected for projectKeys".format(item,
                                                                       assignments[idx_str]))
                new_question = question.replace(idx_str, json.dumps(item[0]))
            else:
                if not isinstance(item, str):
                    raise ValueError("PROJECT: Item: {} is not a string in assigments: {}. "
                                     "Expected for project".format(item, assignments[idx_str]))
                new_question = question.replace(idx_str, item)
            curr_answers, curr_facts = self.model_library[model].ask_question(new_question)
            facts_used.extend(curr_facts)

            if first_op == "projectValues":
                answers.append((item[0], curr_answers))
            elif first_op == "projectKeys":
                answers.append((curr_answers, item[1]))
            elif first_op == "project":
                answers.append((item, curr_answers))

        answers = self.execute_sub_operations(answers, operation)
        return answers, facts_used

    def execute_filter(self, operation, model, question, assignments):
        assert model in self.model_library, "Model: {} not found in model library!".format(
            model)
        indices = get_answer_indices(question)
        if len(indices) > 1:
            # check which index is mentioned in the operation
            question_indices = indices
            indices = get_answer_indices(operation)
            if len(indices) > 1:
                raise NotImplementedError("Can not handle more than one answer idx for filter!"
                                          "Operation: {} Question: {}".format(operation, question))
            else:
                for idx in question_indices:
                    # modify question directly to include the other question indices
                    if idx not in indices:
                        idx_str = "#" + str(idx)
                        if idx_str not in assignments:
                            raise ValueError("FILTER: Can not perform filter operation with input arg: {} "
                                             "No assignments yet!".format(idx_str))
                        # print(question, idx_str, assignments)
                        question = question.replace(idx_str, json.dumps(assignments[idx_str]))

        idx_str = "#" + str(indices[0])
        if idx_str not in assignments:
            raise ValueError("FILTER: Can not perform filter operation with input arg: {}"
                             " No assignments yet!".format(idx_str))
        if not isinstance(assignments[idx_str], list):
            raise ValueError("FILTER: Can not perform filter operation on a non-list input: {}"
                             " Operation: {} Question: {}".format(assignments[idx_str],
                                                                  operation, question))
        answers = []
        facts_used = []
        operation_seq = operation.split("_")
        first_op = operation_seq[0]
        for item in assignments[idx_str]:
            if first_op.startswith("filterKeys"):
                # item should be a tuple
                if not isinstance(item, tuple):
                    raise ValueError("FILTER: Item: {} is not a tuple in assignments: {}. "
                                     "Expected for filterKeys".format(item, assignments[idx_str]))
                (key, value) = item
                new_question = question.replace(idx_str, json.dumps(value))
            elif first_op.startswith("filterValues"):
                if not isinstance(item, tuple):
                    raise ValueError("FILTER: Item: {} is not a tuple in assignments: {}. "
                                      "Expected for filterValues".format(item,
                                                                         assignments[idx_str]))
                (key, value) = item
                new_question = question.replace(idx_str, json.dumps(key))
            else:
                if not isinstance(item, str):
                    raise ValueError("FILTER: Item: {} is not a string in assigments: {}. "
                                     "Expected for filter".format(item, assignments[idx_str]))
                new_question = question.replace(idx_str, item)

            answer, curr_facts = self.model_library[model].ask_question(new_question)
            if not isinstance(answer, str):
                raise ValueError("FILTER: Incorrect question type for filter. Returned answer: {}"
                                 " for question: {}".format(answer, new_question))
            answer = answer.lower()
            if answer == "yes" or answer == "1" or answer == "true":
                answers.append(item)
            facts_used.extend(curr_facts)
        answers = self.execute_sub_operations(answers, operation)
        return answers, facts_used

    def execute_operation(self, operation, model, question, assignments):
        try:
            if operation.startswith("select"):
                return self.execute_select(operation, model, question, assignments)
            elif operation.startswith("project"):
                return self.execute_project(operation, model, question, assignments)
            elif operation.startswith("filter"):
                return self.execute_filter(operation, model, question, assignments)
            else:
                logger.debug("Can not execute operation: {}. Returning empty list".format(operation))
                return [], []
        except ValueError as e:
            if self.ignore_input_mismatch:
                logger.debug("Can not execute operation: {} question: {} "
                             "with assignments: {}".format(operation, question, assignments))
                logger.debug(str(e))
                return [], []
            else:
                raise e
