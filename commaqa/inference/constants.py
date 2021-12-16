from typing import Dict

from commaqa.inference.dataset_readers import HotpotQAReader, DatasetReader, DropReader
from commaqa.inference.participant_execution import ExecutionParticipant
from commaqa.inference.participant_qgen import LMGenParticipant, RandomGenParticipant
from commaqa.inference.participant_util import DumpChainsParticipant

MODEL_NAME_CLASS = {
    "lmgen": LMGenParticipant,
    "randgen": RandomGenParticipant,
    "dump_chains": DumpChainsParticipant,
    "operation_executer": ExecutionParticipant
}

READER_NAME_CLASS: Dict[str, DatasetReader] = {
    "hotpot": HotpotQAReader,
    "drop": DropReader
}
