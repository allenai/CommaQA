local entities = import "entities.libsonnet";
local table_predicate = import "table_predicates.libsonnet";
local text_predicate = import "text_predicates.libsonnet";
local combined_predicates = table_predicate + text_predicate;
local predicate_languages = import "predicate_language.libsonnet";
local theories = import "theories.libsonnet";
local predicate_names = ["table_year", "table_directed", "table_maward", "table_writer", "text_actor", "text_produced", "text_paward", "text_dob", "text_nation"];
local predicates = { [p]: combined_predicates[p] for p in predicate_names };
local predicate_language = { [key]: predicate_languages[p][key] for p in predicate_names for key in std.objectFields(predicate_languages[p]) };
{
  version: 3.0,
  entities: entities,
  predicates: predicates,
  predicate_language: predicate_language,
  theories: theories,
}
