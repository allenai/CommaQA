from typing import Dict

from commaqa.inference.dataset_readers import HotpotQAReader, DatasetReader, DropReader
from commaqa.inference.participant_qgen import LMGenParticipant
from commaqa.inference.routers import ExecutionRouter

MODEL_NAME_CLASS = {
    "lmgen": LMGenParticipant,
    "operation_executer": ExecutionRouter
}

READER_NAME_CLASS: Dict[str, DatasetReader] = {
    "hotpot": HotpotQAReader,
    "drop": DropReader
}

QUESTION_MARKER = " Q: "
COMPQ_MARKER = " QC: "
SIMPQ_MARKER = " QS: "
INTERQ_MARKER = " QI: "
EOQ_MARKER = "[EOQ]"
ANSWER_MARKER = " A: "
HINT_MARKER = " H: "
HINTS_DELIM = "; "
NOANS_MARKER = "N/A"
LIST_JOINER = " + "
TITLE_DELIM = " || "

# Model Names
SQUAD_MODEL = "squad"
IF_THEN_MODEL = "if_then"
MATH_MODEL = "math"
BOOLQ_MODEL = "math"
SQUAD_LIST_MODEL = "squad_list"
