#!/bin/bash
set -e
#
echo "Building CommaQA-E"
bash scripts/build_datasets.sh \
  configs/commaqav1/explicit/movies1.jsonnet,configs/commaqav1/explicit/movies2.jsonnet \
  output/commaqav1/explicit/commaqa

echo "Building CommaQA-I"
bash scripts/build_datasets.sh \
  configs/commaqav1/implicit/items0.jsonnet,configs/commaqav1/implicit/items1.jsonnet,configs/commaqav1/implicit/items2.jsonnet,configs/commaqav1/implicit/items3.jsonnet,configs/commaqav1/implicit/items4.jsonnet,configs/commaqav1/implicit/items5.jsonnet \
  output/commaqav1/implicit/commaqa

echo "Building CommaQA-N"
bash scripts/build_datasets.sh \
  configs/commaqav1/numeric/sports.jsonnet \
  output/commaqav1/numeric/commaqa


echo "Building decompositions"
bash scripts/build_decompositions.sh \
  output/commaqav1/numeric/commaqa \
  output/commaqav1/numeric/decomp

bash scripts/build_decompositions.sh \
  output/commaqav1/implicit/commaqa \
  output/commaqav1/implicit/decomp

bash scripts/build_decompositions.sh \
  output/commaqav1/explicit/commaqa \
  output/commaqav1/explicit/decomp


echo "Create language"

for d in explicit implicit numeric;
do
  mkdir -p output/commaqav1/${d}/language
  jq -r ".predicate_language[]|[.model, .questions[]]|@tsv" \
    output/commaqav1/${d}/commaqa/source*.json |  sed 's/$[0-9]/__/g' | sort -u >  \
    output/commaqav1/${d}/language/model_questions.tsv
done


for f in explicit implicit numeric;
do
    mkdir -p output/commaqav1/${f}/restricted_language
    jq -r ".[].qa_pairs[].decomposition[]|[.m, .q]|@tsv" \
      output/commaqav1/${f}/train.json | \
      sed 's/[$#][0-9]/__/g' | sort -u > \
      output/commaqav1/${f}/restricted_language/model_questions.tsv
  jq -r ".[].qa_pairs[].decomposition[].op" \
    output/commaqav1/${f}/train.json | \
    sed 's/[$#][0-9]/__/g' | sort -u > \
    output/commaqav1/${f}/restricted_language/operations.txt
done

mkdir -p output/commaqav1/compgen/
python commaqa/dataset/build_dataset.py \
  --input_json   configs/commaqav1/numeric/sports_compgen.jsonnet \
  --output output/commaqav1/compgen/numeric_test.json --entity_percent 0.2 \
  --num_groups 100 --num_examples_per_group 5

python commaqa/dataset/build_dataset.py \
  --input_json configs/commaqav1/explicit/movies1_compgen.jsonnet,configs/commaqav1/explicit/movies2_compgen.jsonnet \
  --output output/commaqav1/compgen/explicit_test.json --entity_percent 0.2 \
  --num_groups 100 --num_examples_per_group 5