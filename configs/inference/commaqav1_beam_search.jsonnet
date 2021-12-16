{
  "start_state": "gen",
  "end_state": "[EOQ]",
  "models": {
    "gen": {
      "name": "lmgen",
      "model_path": std.extVar("model_path"),
      "generation_args": {
        "max_length": 40,
        "num_return_sequences": 5,
        "top_p": 0.95,
        "top_k": 10,
        "do_sample": false,
        "num_beams": 10
      },
      "encoder_args": {
        "add_special_tokens": false,
        "return_tensors": "pt"
      },
      "decoder_args": {
        "clean_up_tokenization_spaces": true,
        "skip_special_tokens": true
      },
      "next_model": "execute",
      "end_state": "[EOQ]"
    },
    "execute": {
      "name": "operation_executer",
      "remodel_file": std.extVar("remodel_path") + "/" + std.extVar("filename"),
      "next_model": "gen"
    }
  }
}