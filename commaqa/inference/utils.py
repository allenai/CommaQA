import os
from typing import List, Dict

QUESTION_MARKER = " Q: "
COMPQ_MARKER = " QC: "
SIMPQ_MARKER = " QS: "
INTERQ_MARKER = " QI: "
ANSWER_MARKER = " A: "
LIST_JOINER = " + "


def get_sequence_representation(origq: str, question_seq: List[str], answer_seq: List[str],
                                # model_seq: List[str] = None, operation_seq: List[str] = None,
                                for_generation=True):
    ret_seq = COMPQ_MARKER + origq
    if for_generation and len(question_seq) != len(answer_seq):
        raise ValueError("Number of generated questions and answers should match before"
                         "question generation. Qs: {} As: {}".format(question_seq, answer_seq))
    elif not for_generation and len(question_seq) != len(answer_seq) + 1:
        raise ValueError("One extra question should be generated than answers"
                         " Qs: {} As: {}".format(question_seq, answer_seq))

    for aidx in range(len(answer_seq)):
        ret_seq += INTERQ_MARKER
        # if operation_seq is not None and len(operation_seq):
        #     ret_seq += "(" + model_seq[aidx] + ")"
        # if model_seq is not None and len(model_seq):
        #     ret_seq += "[" + model_seq[aidx] + "]"
        ret_seq += question_seq[aidx]
        ret_seq += ANSWER_MARKER + answer_seq[aidx]

    if for_generation:
        ret_seq += SIMPQ_MARKER
    else:
        ret_seq += SIMPQ_MARKER + question_seq[-1]

    return ret_seq


# functions borrowed from AllenNLP to parse JSONNET with env vars
def get_environment_variables() -> Dict[str, str]:
    """
    Wraps `os.environ` to filter out non-encodable values.
    """
    return {key: value for key, value in os.environ.items() if _is_encodable(value)}


def _is_encodable(value: str) -> bool:
    """
    We need to filter out environment variables that can't
    be unicode-encoded to avoid a "surrogates not allowed"
    error in jsonnet.
    """
    # Idiomatically you'd like to not check the != b""
    # but mypy doesn't like that.
    return (value == "") or (value.encode("utf-8", "ignore") != b"")