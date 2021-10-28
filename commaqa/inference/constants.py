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

