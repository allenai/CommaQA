import json



class DatasetReader:

    def read_examples(self, file):
        return NotImplementedError("read_examples not implemented by " + self.__class__.__name__)


class HotpotQAReader(DatasetReader):

    def read_examples(self, file):
        with open(file, 'r') as input_fp:
            input_json = json.load(input_fp)

        for entry in input_json:
            yield {
                "qid": entry["_id"],
                "query": entry["question"],
                # metadata
                "answer": entry["answer"],
                "question": entry["question"],
                "type": entry.get("type", ""),
                "level": entry.get("level", "")
            }


def format_drop_answer(answer_json):
    if answer_json["number"]:
        return answer_json["number"]
    if len(answer_json["spans"]):
        return answer_json["spans"]
    # only date possible
    date_json = answer_json["date"]
    if not (date_json["day"] or date_json["month"] or date_json["year"]):
        print("Number, Span or Date not set in {}".format(answer_json))
        return None
    return date_json["day"] + "-" + date_json["month"] + "-" + date_json["year"]


class DropReader(DatasetReader):

    def read_examples(self, file):
        with open(file, 'r') as input_fp:
            input_json = json.load(input_fp)

        for paraid, item in input_json.items():
            para = item["passage"]
            for qa_pair in item["qa_pairs"]:
                question = qa_pair["question"]
                qid = qa_pair["query_id"]
                answer = format_drop_answer(qa_pair["answer"])
                yield {
                    "qid": qid,
                    "query": question,
                    # metadata
                    "answer": answer,
                    "question": question
                }
