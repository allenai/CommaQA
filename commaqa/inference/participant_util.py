from commaqa.inference.model_search import ParticipantModel
from commaqa.inference.utils import get_sequence_representation


class DumpChainsParticipant(ParticipantModel):

    def __init__(self, output_file, next_model="gen"):
        self.output_file = output_file
        self.next_model = next_model
        self.num_calls = 0

    def return_model_calls(self):
        return {"dumpchains": self.num_calls}

    def dump_chain(self, state):
        data = state.data
        origq = data["query"]
        qchain = data["question_seq"]
        achain = data["answer_seq"]
        sequence = get_sequence_representation(origq=origq, question_seq=qchain, answer_seq=achain)
        ans = achain[-1]
        with open(self.output_file, 'a') as chains_fp:
            chains_fp.write(data["qid"] + "\t" + sequence + "\t" + ans + "\n")

    def query(self, state, debug=False):
        self.num_calls += 1
        if len(state.data["question_seq"]) > 0:
            self.dump_chain(state)
        new_state = state.copy()
        new_state.next = self.next_model
        return new_state
