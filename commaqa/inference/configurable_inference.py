import argparse
import json
import logging

import _jsonnet

from commaqa.inference.constants import MODEL_NAME_CLASS, READER_NAME_CLASS
from commaqa.inference.dataset_readers import DatasetReader
from commaqa.inference.model_search import (
    ModelController,
    BestFirstDecomposer, QuestionGeneratorData)


def parse_arguments():
    arg_parser = argparse.ArgumentParser(description='Convert HotPotQA dataset into SQUAD format')
    arg_parser.add_argument('--input', type=str, required=True, help="Input QA file")
    arg_parser.add_argument('--output', type=str, required=True, help="Output file")
    arg_parser.add_argument('--config', type=str, required=True, help="Model configs")
    arg_parser.add_argument('--reader', type=str, required=True, help="Dataset reader",
                            choices=READER_NAME_CLASS.keys())
    arg_parser.add_argument('--debug', action='store_true', default=False,
                            help="Debug output")
    arg_parser.add_argument('--demo', action='store_true', default=False,
                            help="Demo mode")
    arg_parser.add_argument('--threads', default=1, type=int,
                            help="Number of threads (use MP if set to >1)")
    return arg_parser.parse_args()


def load_decomposer(config_map):
    print("loading participant models (might take a while)...")
    model_map = {}
    for key, value in config_map["models"].items():
        class_name = value.pop("name")
        if class_name not in MODEL_NAME_CLASS:
            raise ValueError("No class mapped to model name: {} in MODEL_NAME_CLASS:{}".format(
                class_name, MODEL_NAME_CLASS))
        model = MODEL_NAME_CLASS[class_name](**value)
        if key in config_map:
            raise ValueError("Overriding key: {} with value: {} using instantiated model of type:"
                             " {}".format(key, config_map[key], class_name))
        config_map[key] = model.query
        model_map[key] = model
    ## instantiating
    controller = ModelController(config_map, QuestionGeneratorData)
    decomposer = BestFirstDecomposer(controller)
    return decomposer, model_map


if __name__ == "__main__":
    logging.basicConfig(level=logging.ERROR)
    args = parse_arguments()

    if args.config.endswith(".jsonnet"):
        config_map = json.loads(_jsonnet.evaluate_file(args.config))
    else:
        with open(args.config, "r") as input_fp:
            config_map = json.load(input_fp)

    decomposer, model_map = load_decomposer(config_map)
    reader: DatasetReader = READER_NAME_CLASS[args.reader]()

    print("Running decomposer on examples")
    qid_answer_chains = []

    if args.demo:
        while True:
            qid = input("QID: ")
            question = input("Question: ")
            example = {
                "qid": qid,
                "query": question,
                "question": question
            }
            final_state, other_states = decomposer.find_answer_decomp(example, debug=args.debug)
            if final_state is None:
                print("FAILED!")
            else:
                if args.debug:
                    for other_state in other_states:
                        data = other_state.data
                        for q, a, s in zip(data["question_seq"], data["answer_seq"],
                                           data["score_seq"]):
                            print("Q: {} A: {} S:{}".format(q, a, s), end='\t')
                        print("Score: " + str(other_state._score))
                data = final_state._data
                chain = example["question"]
                for q, a in zip(data["question_seq"], data["answer_seq"]):
                    chain += " Q: {} A: {}".format(q, a)
                chain += " S: " + str(final_state._score)
                print(chain)
    else:
        if args.threads > 1:
            import multiprocessing as mp

            mp.set_start_method("spawn")
            with mp.Pool(args.threads) as p:
                qid_answer_chains = p.map(decomposer.return_qid_prediction,
                                          reader.read_examples(args.input))
        else:
            for example in reader.read_examples(args.input):
                qid_answer_chains.append(
                    decomposer.return_qid_prediction(example, debug=args.debug))

        predictions = {x[0]: x[1] for x in qid_answer_chains}
        with open(args.output, "w") as output_fp:
            json.dump(predictions, output_fp)

        chains = [x[2] for x in qid_answer_chains]
        ext_index = args.output.rfind(".")
        chain_tsv = args.output[:ext_index] + "_chains.tsv"
        with open(chain_tsv, "w") as output_fp:
            for chain in chains:
                output_fp.write(chain + "\n")
