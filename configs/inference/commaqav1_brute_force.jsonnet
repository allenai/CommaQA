{
  "start_state": "gen",
  "end_state": "[EOQ]",
  "models": {
    "gen": {
      "name": "randgen",
      "next_model": "execute",
      "end_state": "[EOQ]",
      "operations_file": std.extVar("lang_path") + "/operations.txt",
      "model_questions_file": std.extVar("lang_path") + "/model_questions.tsv",
      "sample_operations": std.parseInt(std.extVar("sample_operations_percent")) / 100,
      "sample_questions": std.parseInt(std.extVar("num_questions")),
      "max_steps": std.parseInt(std.extVar("max_steps")),
      "topk_questions": std.extVar("topk_questions")
    },
    "execute": {
      "name": "operation_executer",
      "remodel_file": std.extVar("remodel_path") + "/" + std.extVar("filename"),
      "next_model": "chains",
      "skip_empty_answers": true
    },
    "chains": {
        "name": "dump_chains",
        "output_file": std.extVar("output_dir") + "/all_chains.tsv",
        "next_model": "gen"
    }
  }
}
