#!/bin/bash
set -e

echo "Building CommaQA-E"
bash scripts/build_datasets.sh \
  configs/commaqav1/explicit/movies1.jsonnet,configs/commaqav1/explicit/movies2.jsonnet \
  output/commaqav1/explicit

echo "Building CommaQA-I"
bash scripts/build_datasets.sh \
  configs/commaqav1/implicit/items0.jsonnet,configs/commaqav1/implicit/items1.jsonnet,configs/commaqav1/implicit/items2.jsonnet,configs/commaqav1/implicit/items3.jsonnet,configs/commaqav1/implicit/items4.jsonnet,configs/commaqav1/implicit/items5.jsonnet \
  output/commaqav1/implicit

echo "Building CommaQA-N"
bash scripts/build_datasets.sh \
  configs/commaqav1/numeric/sports.jsonnet \
  output/commaqav1/numeric