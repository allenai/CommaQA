local entities = import "entities.libsonnet";
local table_predicate = import "table_predicates.libsonnet";
local text_predicate = import "text_predicates.libsonnet";
local combined_predicates = table_predicate + text_predicate;
local predicate_languages = import "predicate_language.libsonnet";
local theories = import "theories_compgen.libsonnet";
local predicate_names = ["table_nationj", "table_nationd", "text_dthrow", "text_jthrow"];
local predicates = { [p]: combined_predicates[p] for p in predicate_names };
local predicate_language = { [key]: predicate_languages[p][key] for p in predicate_names + ["math_special"] for key in std.objectFields(predicate_languages[p]) };
{
  version: 3.0,
  entities: entities,
  predicates: predicates,
  predicate_language: predicate_language,
  theories: theories,
}
