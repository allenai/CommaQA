# Operations and Agents

## Building a new agent
Currently our agents are purely defined by the dataset configuration. Specifically, the
[Predicate Language](../configs/README.md#predicate-language) configuration defines the class of
questions answerable by each agent. Internally, the configuration is used to create a
[Model Executer](model_executer.py) that can answer questions matching the language (specified in
the config) by executing the steps (specified in the config).

## Using agents in your code
Agents have to be built for each example since each example has a different world context. To
build an agent for a given question in your code, refer to code in
[participant_execution.py](../inference/participant_execution.py#L55-L59)


## Defining a new operation
The operations (as shown in Table 1 and Table 2) are implemented in `operation_executer.py`. You can
add more operations to this class by modifying the [execute_operation](operation_executer.py#L190)
function.
