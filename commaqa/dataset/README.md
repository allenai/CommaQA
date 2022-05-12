# Building Datasets

### Building QA Dataset
To build the CommaQA dataset, you can use the script [build_commaqav1](../../scripts/build_commaqav1.sh)
script. It will generate the dataset in `output/commaqav1` folder using the configs from
`configs/commaqav1` directory. Note that this is will be a different sample of the synthetic
dataset and won't be exactly same as the dataset used in our paper. Use the dataset links
provided in the [main README](../../README.md) to get the same dataset as the one used in the paper.


To build your own dataset, create the configuration file as per the specifications described in
[configs README](../configs/README.md). You can then use the `build_dataset` script with your
new configuration file:
```shell
sh scripts/build_datasets.sh \
  [YOUR NEW CONFIG FILE].jsonnet \
  [OUTPUT DIRECTORY]
```
The script will generate JSON files in CommaQA format with train/dev/test splits in the output
directory.

### Generating Decompositions
To produce the decompositions for any generated dataset in CommaQA format, you can use the
[build_decompositions](../../scripts/build_decompositions.sh) script. e.g.
```shell
sh scripts/build_decompositions.sh \
  output/commaqav1/explicit \
  output/commaqav1/explicit_decomp
```
will generate the decompositions for the CommaQA-E dataset. For each train/dev/test.json file in the
input, there is a corresponding file in the output folder (`output/commaqav1/explicit_decomp` here).
The decompositions are added as new keys: `train_seqs` for each example in the JSON. E.g.
```jsonnet
{
  "train_seqs": [
    " QC: What awards have the actors of the Hallowcock winning movies received? QS: (select) [table] The award Hallowcock has been awarded to which movies?",
    " QC: What awards have the actors of the Hallowcock winning movies received? QI: (select) [table] The award Hallowcock has been awarded to which movies? A: [\"Clenestration\"] QS: (project_values_flat_unique) [text] Who all acted in the movie #1?",
    " QC: What awards have the actors of the Hallowcock winning movies received? QI: (select) [table] The award Hallowcock has been awarded to which movies? A: [\"Clenestration\"] QI: (project_values_flat_unique) [text] Who all acted in the movie #1? A: [\"Huckberryberry\", \"Sapien\"] QS: (project_values_flat_unique) [table] #2 has been awarded which awards?",
    " QC: What awards have the actors of the Hallowcock winning movies received? QI: (select) [table] The award Hallowcock has been awarded to which movies? A: [\"Clenestration\"] QI: (project_values_flat_unique) [text] Who all acted in the movie #1? A: [\"Huckberryberry\", \"Sapien\"] QI: (project_values_flat_unique) [table] #2 has been awarded which awards? A: [\"Custodio\", \"Lameze\"] QS: [EOQ]"
  ]
}
```
captures the decomposition of "What awards have the actors of the Hallowcock winning movies
received?". Each entry in `train_seqs` captures the next question to be generated given the previous
decomposition history. This format can be used to train a `NextGen` model for TMNs which is also
trained to generate the next question given the history.
