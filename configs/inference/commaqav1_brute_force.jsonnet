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
      "sample_operations": 0.999,
      "sample_questions": 5,
      "max_steps": std.parseInt(std.extVar("max_steps"))
    },
    "execute": {
      "name": "operation_executer",
      "remodel_file": std.extVar("remodel_path") + "/" + std.extVar("filename"),
      "next_model": "chains",
      "skip_empty_answers": true
    },
    "chains": {
        "name": "dump_chains",
        "output_file": std.extVar("output_dir") + "/chains.tsv",
        "next_model": "gen"
    }
  }
}
