# CommaQA: *Comm*unicating with *A*gents for *QA*

CommaQA Dataset is a QA benchmark for learning to communicate with agents. It consists of three
datasets capturing three forms of multi-hop reasoning -- explicit(CommaQA-E), implicit(CommaQA-I),
and numeric(CommaQA-N).

**Paper Link**:
[Semantic Scholar](https://api.semanticscholar.org/CorpusID:239016681)

**Citation**:
```
@article{Khot2021LearningTS,
  title={Learning to Solve Complex Tasks by Talking to Agents},
  author={Tushar Khot and Kyle Richardson and Daniel Khashabi and Ashish Sabharwal},
  journal={ArXiv},
  year={2021},
  volume={abs/2110.08542}
}
```


Table of Contents
===============

* [Dataset](#Dataset)
    * [Download](#Download)
    * [Formats](#Formats)
* [Code](#Code)

## Dataset

### Download

Download the datasets:

* [Explicit](https://ai2-public-datasets.s3.amazonaws.com/commaqa/v1/commaqa_explicit.zip)
* [Implicit](https://ai2-public-datasets.s3.amazonaws.com/commaqa/v1/commaqa_implicit.zip)
* [Numeric](https://ai2-public-datasets.s3.amazonaws.com/commaqa/v1/commaqa_numeric.zip)
* [Compositional Generalization (test only)](https://ai2-public-datasets.s3.amazonaws.com/commaqa/v1/commaqa_compgen.zip)

### Formats

Each dataset contains three formats:

* commaqa/: This is default CommaQA format that contains the raw facts, verbalized sentences,
 agent language specification, QA pairs and associated theories. Each JSON file consists of list of
 items with each item containing a KB and a group of questions. The JSON file uses the following
 key structure:

    * `kb`: a map between predicate names and the facts associated with each predicate
    * `context`: verbalized context used by black-box models
    * `per_fact_context`: map between the facts in the `kb` and the corresponding verbalized
       sentence in `context`
    * `pred_lang_config`: map between the agent name and the questions answerable by this agent
     (see [ModelQuestionConfig](commaqa/configs/predicate_language_config.py) for more details)
    * `qa_pairs`: list of QA pairs associated with this context using the keys:
        * `id`: question id
        * `question`: question
        * `answer`: numeric or list answer
        * `config`: specific theory config used to construct this example (see
          [TheoryConfig](commaqa/configs/theory_config.py) for more details)
        * `assignment`: assignment to the variables in the theory
        * `decomposition`: agent-based decomposition to answer this question
        * `facts_used`: facts needed to answer this question

* drop/: This contains the dataset in the default [DROP dataset](https://allennlp.org/drop) format
by converting the `context` and `qa_pairs` from the commaqa/ format.

* seq2seq/: This contains the dataset in a simple text format (one example per line) by converting
the `context` and `qa_pairs` from the commaqa/ format into `<context> Q: <question> A: <answer>`.


### Additional Datasets

* Decompositions: The training data for the decomposer can be downloaded from
[here](https://ai2-public-datasets.s3.amazonaws.com/commaqa/v1/commaqa_decompositions.zip).
The data uses the JSONL format with `train_seqs` field containing the decompositions for each
question. Each entry in the `train_seqs` array corresponds to one step in the decomposition chain.
E.g.
  ```
  QC: What awards have the actors of the Hallowcock winning movies received?
  QI: (select) [table] The award Hallowcock has been awarded to which movies? A: [\"Clenestration\"]
  QS: (project_values_flat_unique) [text] Who all acted in the movie #1?
  ```
can be used to train a model to generate the question
`(project_values_flat_unique) [text] Who all acted in the movie #1?` (string following `QS:`) given
the previous questions and answers.

* Language: The language specification for agents in each dataset can be downloaded from
[here](https://ai2-public-datasets.s3.amazonaws.com/commaqa/v1/commaqa_language.zip). It contains
to files:
  * `operations.txt`: File containing the list of operations for CommaQA
  * `model_questions.tsv`: A TSV file where the first field corresponds to the model name and all
  the subsequent fields contain valid questions that can be asked to this model.


## Code

Refer to the individual READMEs in each package for instructions on:

  * [Config Format](commaqa/configs/README.md)
  * [Building Datasets](commaqa/dataset/README.md)
  * [Building Agents/Operations](commaqa/execution/README.md)
  * [Running Inference](commaqa/inference/README.md)
