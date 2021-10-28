import re
from math import ceil

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
        gen_seq = get_sequence_representation(origq=data["query"], question_seq=question_seq,
                                              answer_seq=answer_seq, model_seq=model_seq,
                                              for_generation=True)
        if self.add_prefix:
            gen_seq = self.add_prefix + gen_seq
        if self.add_eos:
            gen_seq = gen_seq + "</s>"

        if debug: print("<GEN>: %s" % gen_seq)

        ## eventual output
        new_states = []
        ## go through generated questions
        output_seqs, output_scores = self.lmgen.generate_sequences(gen_seq)
        for output in list(set(output_seqs)):
            output = output.strip()
            # copy state
            new_state = state.copy()
            ## add new question to question_seq
            new_state.data["question_seq"].append(output)
            if output == self.end_state:
                new_state.next = self.end_state
            else:
                new_state.next = self.next_model
            ## maniuplate score (e.g., add)
            # new_state._score += score
            new_state.data["command_seq"].append("gen")
            ## mark the last output
            new_state.last_output = output
            new_states.append(new_state)
        ##
        return new_states
