## generalizes version of `QuestionSearch.py` in this directory
import copy
import heapq
import json
import logging


## THE BASIC MODEL

class BasicDataInstance(dict):
    _REQUIRED_ATTRS = set([])

    def __init__(self, input_data):
        dict.__init__({})
        self.update(input_data)
        for item in type(self)._REQUIRED_ATTRS:
            if item not in self:
                self[item] = []


class QuestionGeneratorData(BasicDataInstance):
    _REQUIRED_ATTRS = set([
        "question_seq",
        "answer_seq",
        "command_seq",
        "model_seq",
        "score_seq",
        "para_seq"
    ])


class ParticipantModel(object):
    """Base model in this case for coordinating different models. Provides a general
    class to structure all contributing models (in this case, by defining a single
    function `query`, which is the single method that is called for each model).

    """

    def query(self, state, debug=False):
        """The main function that interfaces with the overall search and
        model controller, and manipulates the incoming data.

        :param state: the state of controller and model flow.
        :type state: launchpadqa.question_search.model_search.SearchState
        :rtype: list
        """
        raise NotImplementedError("Must implement to work inside of controller!")


class ModelController(object):
    """This class is a `ModelController` that takes multiple (arbitrary)
    models and a control specification of how to interface the different
    models (which can be thought of as a kind of state graph). For example

    """

    def __init__(self, model_list,
                 data_class=BasicDataInstance):
        """Create an instance of a ComplexModel

        :param model_list: a list of models with identifiers and
          control flow.
        :type model_list: dict
        """
        if "start_state" not in model_list:
            raise ValueError('Must specify start state')
        if "end_state" not in model_list:
            raise ValueError('Must specify end state')
        self.model_list = model_list
        self.data_class = data_class

    def execute(self, state, debug=False):
        """Executes a command and query

        :param state: a given state in search
        :type state: SearchState (defined here)
        :returns: a list of output
        :rtype: list
        """
        if state.next not in self.model_list:
            self.logger.error("Can not handle next state: " + state.next)
            return []
        try:
            model_func = self.model_list[state.next]

            model_output = model_func(state, debug=debug)

            if not isinstance(model_output, list):
                return [model_output]
            return model_output
        except Exception as e:
            self.logger.error(e, exc_info=True)
            raise ValueError('Error caught during model execution:  %s' % e)

    def init_data(self, data_instance):
        """Create an initialized version of the data object
        that will get through around.

        :param data_instance: any arbitrary piece of data.
        :rtype: self.data_class
        """
        return self.data_class(data_instance)

    def command_model(self, command):
        return "command := %s" % \
               (self.model_list[command].__name__)

    def key_val(self, key):
        return self.model_list["keys"][key]

    @property
    def start_state(self):
        return self.model_list["start_state"]

    @property
    def end_state(self):
        return self.model_list["end_state"]

    @property
    def logger(self):
        """Returns a logger instance
        """
        level = '.'.join([__name__, type(self).__name__])
        return logging.getLogger(level)


## utility class for controlling and recording search state

class SearchState(object):
    """Tracks and records the state of a given search.

    """

    def __init__(self, json_data,
                 command,
                 score=0.0,
                 last_output='UNKNOWN',
                 ):
        """Keep track of different stages in the state

        :param json_data: some basic, json represntation of data
        """
        self._data = json_data
        self._score = score
        self._next = command
        self._last_output = last_output

    def copy(self):
        """Does a deep copy of the state

        :returns: new search state
        """
        new_data = copy.deepcopy(self._data)
        new_score = copy.deepcopy(self._score)
        new_next = copy.deepcopy(self._next)

        return SearchState(
            new_data,
            new_next,
            new_score,
            last_output="UNKNOWN",
        )

    @property
    def last_output(self):
        return self._last_output

    @last_output.setter
    def last_output(self, new_output):
        self._last_output = new_output

    ## important to implement to work
    ## with the heap datastructures
    def __lt__(self, other):
        if self.score < other.score:
            return True
        return False

    def __eq__(self, other):
        if self.score == other.score:
            return True
        return False

    @property
    def data(self):
        return self._data

    @property
    def score(self):
        return self._score

    @property
    def next(self):
        return self._next

    @next.setter
    def next(self, value):
        self._next = value

    @data.setter
    def data(self, value):
        self._data = value

    ## string method (especially for debugging)
    def __str__(self):
        return "[OUTPUT] val=%s [SCORE] %s" % (self._last_output,
                                               str(self._score))


## THE BASIC SEARCH STRATEGIES (largely from the other code)

class QuestionSearchBase(object):

    def __init__(self, model_controller):
        """Create a `QuestionDecomposer instance`

        :param model_ensemble: a collection of models with control instructions
        """
        self.controller = model_controller

    def find_answer_decomp(self, json_input, debug=False):
        """Main question decomposition function

        :param json_input: the input to all of the models.
        """
        raise NotImplementedError

    @classmethod
    def from_config(cls, config):
        """Load a model from configuration

        :param config: the global configuration
        """
        pass

    def return_qid_prediction(self, example, debug=False):
        final_state, other_states = self.find_answer_decomp(example, debug=debug)
        if final_state is None:
            print(example["question"] + " FAILED!")
            chain = example["qid"] + "\t" + example["question"]
            return (example["qid"], "", chain)
        else:
            data = final_state._data
            chain = example["qid"] + "\t" + example["question"]
            for m, q, a in zip(data["model_seq"], data["question_seq"], data["answer_seq"]):
                chain += "\tQ: ({}) {} A: {}".format(m, q, a)
            chain += "\tS: " + str(final_state._score)
            print(chain)
            final_answer = data["answer_seq"][-1]
            try:
                json_answer = json.loads(final_answer)
                # use this only if list (ignore numbers, etc)
                if isinstance(json_answer, list):
                    final_answer = json_answer
            except ValueError:
                # Not a valid json ignore
                pass
            return (example["qid"], final_answer, chain)


class BestFirstDecomposer(QuestionSearchBase):

    def find_answer_decomp(self, json_input, debug=False):
        """Run the question decomposer. The main function here is to use
        the controller to pass around inputs to the different models, then
        keep a track of the search state and terminate when the shortest path
        has been found.

        :param json_input: some input to the model
        """
        ## start state of controller : e.g., generate
        start_command = self.controller.start_state
        start_data = self.controller.init_data(json_input)

        ## min-heap
        heap = []
        init_input = json_input["question"] if json_input["question"] else "UNKNOWN"
        if debug: print("[START QUERY] : %s" % init_input)

        init_state = SearchState(start_data,  ## initial input
                                 start_command,  ## starting point
                                 score=0.0,  ## starting score
                                 )

        ## push it to heap
        heapq.heappush(heap, init_state)
        max_step = 0

        ## todo : add constraints on search (e.g., beam sizes, etc..)

        ## start the main search
        while True:
            if len(heap) == 0:
                if debug: print("[FAILED]: %s" % init_input)
                return None, []

            ## pop from heap
            current_state = heapq.heappop(heap)

            if debug:
                print("[MIN_STATE] command=%s" % (current_state.next))

            ## end state
            if current_state.next == self.controller.end_state:
                if debug: print("[TERMINATED]\n%s" % current_state)
                return current_state, heap

                ## generate output and new stated
            for new_state in self.controller.execute(current_state, debug=debug):
                ## debug view
                if debug: print("\t%s" % new_state)

                ## push onto heap
                heapq.heappush(heap, new_state)
