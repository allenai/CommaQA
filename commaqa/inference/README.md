# Running Inference
There are two modes of inference as described in our paper.

## Greedy Search
Greedy Search selects the most likely question decomposition at each step rather than considering
multiple decomposition strategies. This is much faster than beam search but can not recover from any
failures, e.g. if the most likely decomposition at a given step asks a question to the textqa agent
but it can not answer it.

To run inference using greedy search, run
```shell
model_path=[PATH TO DECOMPOSER MODEL] \
remodel_path=[PATH TO DATASET FOLDER IN COMMAQA FORMAT] \
filename=[FILENAME, e.g., train/dev/test.json] \
python commaqa/inference/configurable_inference.py \
  --input [FILE IN DROP FORMAT] \
  --config configs/inference/commaqav1_greedy_search.jsonnet \
  --reader drop \
   --output predictions.json
```


## Beam Search
Since our dataset (and other tasks in general) don't always have a pre-determined strategy to answer
a question, we may need to consider multiple question decompositions at each step and then select
the ones that do succeed. We use beam search to consider multiple decompositions at each step. To
run inference in this mode, use:

```shell
model_path=[PATH TO DECOMPOSER MODEL] \
remodel_path=[PATH TO DATASET FOLDER IN COMMAQA FORMAT] \
filename=[FILENAME, e.g., train/dev/test.json] \
python commaqa/inference/configurable_inference.py \
  --input [FILE IN DROP FORMAT] \
  --config configs/inference/commaqav1_beam_search.jsonnet \
  --reader drop \
   --output predictions.json
```


## Inference using provided dataset and models
For example, to run inference on CommaQA-E using the provided [datasets](../../README.md#Dataset)
and [models](../../README.md#Models),
1. Unzip the dataset `commaqa_explicit.zip` into `commaqa_explicit`
2. Unzip the model `commaqa_e_oracle_model.zip` into `commaqa_explicit_oracle_model`
3. Call inference:
```shell
model_path=commaqa_explicit_oracle_model/ \
remodel_path=commaqa_explicit/commaqa/ \
filename=test.json \
python commaqa/inference/configurable_inference.py \
  --input commaqa_explicit/drop/${filename} \
  --config configs/inference/commaqav1_beam_search.jsonnet \
  --reader drop \
   --output predictions.json
```

You can change the dataset and model paths to run inference on a different split. You can run greedy
inference by changing the config file to `commaqav1_greedy_search.jsonnet`.