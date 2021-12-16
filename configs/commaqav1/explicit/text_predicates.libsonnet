{
  text_directed: {
    args: ["movie", "person"],
    nary: ["1", "n"],
    language: ["$1 was a movie directed by $2", "$1 directed the movie $2"],
  },
  text_actor: {
    args: ["movie", "person"],
    nary: ["n", "n"],
    language: ["$2 acted in the movie $1", "$2 was an actor in the movie $1"],
  },
  text_writer: {
    args: ["movie", "person"],
    nary: ["n", "n"],
    language: ["$2 was one of the writers for the movie $1", "$2 wrote for the movie $1"],
  },
  text_produced: {
    args: ["movie", "person"],
    nary: ["n", "n"],
    language: ["$2 was one of the producers of the movie $1", "$2 produced the movie $1 with others"],
  },
  text_paward: {
    args: ["person", "p_award"],
    nary: ["1", "n"],
    language: ["$1 won the $2 award", "$2 was awarded to $1"],
  },
  text_dob: {
    args: ["person", "b_year"],
    nary: ["1", "n"],
    language: ["$1 was born in $2", "$1 was born in the year $2"],
  },
  text_nation: {
    args: ["person", "nation"],
    nary: ["1", "n"],
    language: ["$1 is from the country of $2", "$1 grew up in the nation of $2"],
  },
}
