{
  table_year: {
    args: ["movie", "r_year"],
    nary: ["1", "n"],
    language: ["movie: $1 ; year: $2", "movie: $1 ; release year: $2"],
  },
  table_directed: {
    args: ["movie", "person"],
    nary: ["1", "n"],
    language: ["movie: $1 ; director: $2", "movie: $1 ; directed by: $2"],
  },
  table_actor: {
    args: ["movie", "person"],
    nary: ["n", "n"],
    language: ["movie: $1 ; actor: $2", "actor: $2 ; movie: $1"],
  },
  table_writer: {
    args: ["movie", "person"],
    nary: ["n", "n"],
    language: ["movie: $1 ; writer: $2", "movie: $1 ; written by: $2"],
  },
  table_produced: {
    args: ["movie", "person"],
    nary: ["n", "n"],
    language: ["movie: $1 ; producer: $2", "producer: $1 ; movie: $1"],
  },
  table_maward: {
    args: ["movie", "m_award"],
    nary: ["1", "n"],
    language: ["movie: $1 ; award: $2", "movie: $1 ; awarded: $2"],
  },
  table_paward: {
    args: ["person", "p_award"],
    nary: ["1", "n"],
    language: ["person: $1 ; award: $2", "award: $2 ; winner: $1"],
  },
}
