local entities = import "entities.libsonnet";
local kb_predicate = import "kb_predicates.libsonnet";
local text_predicate = import "text_predicates.libsonnet";
local combined_predicates = text_predicate + kb_predicate;
local predicate_languages = import "predicate_language.libsonnet";
local all_theories = import "theories.libsonnet";
local predicate_names = ["text_dob", "text_dod", "text_occupation", "text_field", "text_used_f", "text_founded", "text_inventor", "text_developed", "text_makes", "text_usedin", "text_contains", "kb_studied_f", "kb_graduate_o", "kb_isa"];
local theories = [all_theories[1]];
local predicates = { [p]: combined_predicates[p] for p in predicate_names };
local predicate_language = { [key]: predicate_languages[p][key] for p in predicate_names + ["math_predicates"] for key in std.objectFields(predicate_languages[p]) };
{
  version: 3.0,
  entities: entities,
  predicates: predicates,
  predicate_language: predicate_language,
  theories: theories,
}
