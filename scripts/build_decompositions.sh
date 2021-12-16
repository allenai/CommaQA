#!/bin/bash
set -e

input_dir=$1
output_dir=$2

if [ "$input_dir" = "$output_dir" ]; then
  echo "Same directory specified as input and output directory. Will overwrite files!"
  exit 1
fi

mkdir -p $2

export PYTHONPATH="."

for f in train dev test;
do
  python commaqa/dataset/generate_decomposition_predictions.py \
  --input_json ${input_dir}/${f}.json --decomp_json ${output_dir}/${f}.json
done
