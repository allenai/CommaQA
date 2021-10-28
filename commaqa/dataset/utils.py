import itertools
import re

pred_match = re.compile("(.*)\((.*)\)$")


def get_answer_indices(question_str):
    return [int(m.group(1)) for m in re.finditer("#(\d)", question_str)]


def get_question_indices(question_str):
    return [int(m.group(1)) for m in re.finditer("\$(\d)", question_str)]


def is_question_var(var_name):
    return var_name.startswith("$")


def get_predicate_args(predicate_str):
    mat = pred_match.match(predicate_str)
    if mat is None:
        return None, None
    predicate = mat.group(1)
    pred_args = mat.group(2).split(", ") if " | " not in mat.group(2) else mat.group(2).split(" | ")
    return predicate, pred_args


def flatten_list(input_list):
    output_list = []
    for item in input_list:
        if isinstance(item, list):
            output_list.extend(flatten_list(item))
        else:
            output_list.append(item)
    return output_list


def align_assignments(target_predicate, source_predicate, source_assignments):
    """
    Returns a (map from target_predicate arg name to the assignment in source_assignments),
              (map from target_predicate arg name to the source predicate arg)
    """
    target_pred, target_args = get_predicate_args(target_predicate)
    source_pred, source_args = get_predicate_args(source_predicate)
    assert target_pred == source_pred, "Predicates should match for alignment"
    assert len(target_args) == len(source_args), "Number of arguments should match for alignment"
    target_assignment = {}
    target_assignment_map = {}
    for target_arg, source_arg in zip(target_args, source_args):
        if source_arg == "?":
            assert target_arg == "?", "Source ({}) and Target ({}) predicates have mismatch" \
                                      " on '?'".format(source_predicate, target_predicate)
            continue
        if source_arg not in source_assignments:
            raise ValueError("No assignment for {} in input assignments: {}".format(
                source_arg, source_assignments
            ))
        target_assignment[target_arg] = source_assignments[source_arg]
        target_assignment_map[target_arg] = source_arg
    return target_assignment, target_assignment_map


def dict_product(dicts):
    return (dict(zip(dicts, x)) for x in itertools.product(*dicts.values()))


def valid_answer(answer):
    if isinstance(answer, list) and len(answer) == 0:
        return False
    if isinstance(answer, str) and answer == "":
        return False
    if isinstance(answer, float) and answer == 0.0:
        return False
    return True
