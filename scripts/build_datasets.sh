#!/bin/bash
set -e
# FORMAT: sh build_dataset.sh json_files output_directory
json_files=$1
output_dir=$2
ent_per=${ent_per-0.2}
groups=${groups-2000}
egs=${egs-5}

export PYTHONPATH="."

mkdir -p ${output_dir}

python commaqa/dataset/build_dataset.py \
  --input_json ${json_files} \
  --output ${output_dir} --entity_percent ${ent_per} \
  --num_groups ${groups} --num_examples_per_group ${egs}



