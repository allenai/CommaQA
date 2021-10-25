import json

from commaqa.dataset.utils import flatten_list, get_predicate_args, get_answer_indices


class OperationExecuter:

    def __init__(self, model_library):
        self.model_library = model_library

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
                raise ValueError("Unknown sub-operation: {}".format(op))
        return answers

    def execute_select(self, operation, model, question, assignments):
        assert model in self.model_library, "Model: {} not found in model library!".format(
            model)
        indices = get_answer_indices(question)
        for index in indices:
            idx_str = "#" + str(index)
            if idx_str not in assignments:
                raise ValueError("Can not perform project operation with input arg: {}"
                                 " No assignments yet!".format(idx_str))
            question = question.replace(idx_str, json.dumps(assignments[idx_str]))
        answers, facts_used = self.model_library[model].ask_question(question)
        answers = self.execute_sub_operations(answers, operation)
        return answers, facts_used

    def execute_project(self, operation, model, question, assignments):
        # print(question, assignments)
        assert model in self.model_library, "Model: {} not found in model library!".format(
            model)
        indices = get_answer_indices(question)
        if len(indices) > 1:
            raise NotImplementedError("Can not handle more than one answer idx for project!")
        if len(indices) == 0:
            raise ValueError("Did not find any indices to project on " + str(question))
        idx_str = "#" + str(indices[0])
        if idx_str not in assignments:
            raise ValueError("Can not perform project operation with input arg: {}"
                             " No assignments yet!".format(idx_str))
        answers = []
        facts_used = []
        operation_seq = operation.split("_")
        first_op = operation_seq[0]
        for item in assignments[idx_str]:
            # print(idx_str, item, assignments)
            if first_op == "projectValues":
                new_question = question.replace(idx_str, json.dumps(item[1]))
            elif first_op == "projectKeys":
                new_question = question.replace(idx_str, json.dumps(item[0]))
            else:
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
                            raise ValueError("Can not perform filter operation with input arg: {} "
                                             "No assignments yet!".format(idx_str))
                        # print(question, idx_str, assignments)
                        question = question.replace(idx_str, json.dumps(assignments[idx_str]))

        idx_str = "#" + str(indices[0])
        if idx_str not in assignments:
            raise ValueError("Can not perform filter operation with input arg: {}"
                             " No assignments yet!".format(idx_str))
        answers = []
        facts_used = []
        operation_seq = operation.split("_")
        first_op = operation_seq[0]
        for item in assignments[idx_str]:
            if first_op.startswith("filterKeys"):
                # item should be a tuple
                (key, value) = item
                new_question = question.replace(idx_str, json.dumps(value))
            elif first_op.startswith("filterValues"):
                (key, value) = item
                new_question = question.replace(idx_str, json.dumps(key))
            else:
                new_question = question.replace(idx_str, item)

            answer, curr_facts = self.model_library[model].ask_question(new_question)
            answer = answer.lower()
            if answer == "yes" or answer == "1" or answer == "true":
                answers.append(item)
            facts_used.extend(curr_facts)
        answers = self.execute_sub_operations(answers, operation)
        return answers, facts_used

    def execute_operation(self, operation, model, question, assignments):
        if operation.startswith("select"):
            return self.execute_select(operation, model, question, assignments)
        elif operation.startswith("project"):
            return self.execute_project(operation, model, question, assignments)
        elif operation.startswith("filter"):
            return self.execute_filter(operation, model, question, assignments)
        else:
            print("Can not execute operation: {}. Returning empty list".format(operation))
            return [], []
