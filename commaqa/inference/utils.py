from typing import List

QUESTION_MARKER = " Q: "
COMPQ_MARKER = " QC: "
SIMPQ_MARKER = " QS: "
INTERQ_MARKER = " QI: "
ANSWER_MARKER = " A: "
LIST_JOINER = " + "


def get_sequence_representation(origq: str, question_seq: List[str], answer_seq: List[str],
                                model_seq: List[str] = None,
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
        if model_seq is not None and len(model_seq):
            ret_seq += "(" + model_seq[aidx] + ")"
        ret_seq += question_seq[aidx]
        ret_seq += ANSWER_MARKER + answer_seq[aidx]

    if for_generation:
        ret_seq += SIMPQ_MARKER
    else:
        ret_seq += SIMPQ_MARKER + question_seq[-1]

    return ret_seq
