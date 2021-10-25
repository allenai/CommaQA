{
  table_year: {
    "released_m($1, ?)": {
      model: "table",
      init: { "$1": "r_year" },
      questions: [
        "Which movies were released in $1?",
        "What movies were released in the year $1?",
      ],
      steps: [
        {
          operation: "select",
          question: "table_year(?, $1)",
          answer: "#1",
        },
      ],
    },
    "released_y($1, ?)": {
      model: "table",
      init: { "$1": "movie" },
      questions: [
        "When was the movie $1 released?",
        "Which year was the movie $1 released in?",
      ],
      steps: [
        {
          operation: "select",
          question: "table_year($1, ?)",
          answer: "#1",
        },
      ],
    },
  },
  table_directed: {
    "directed_d($1, ?)": {
      model: "table",
      init: { "$1": "movie" },
      questions: [
        "Who directed $1?",
        "Who was the director of $1?",
      ],
      steps: [
        {
          operation: "select",
          question: "table_directed($1, ?)",
          answer: "#1",
        },
      ],
    },
    "directed_m($1, ?)": {
      model: "table",
      init: { "$1": "person" },
      questions: [
        "Which movies has $1 directed?",
        "What movies has $1 been the director of?",
      ],
      steps: [
        {
          operation: "select",
          question: "table_directed(?, $1)",
          answer: "#1",
        },
      ],
    },
  },
  text_directed: {
    "directed_d($1, ?)": {
      model: "text",
      init: { "$1": "movie" },
      questions: [
        "Who directed $1?",
        "Who was the director of the movie $1?",
      ],
      steps: [
        {
          operation: "select",
          question: "text_directed($1, ?)",
          answer: "#1",
        },
      ],
    },
    "directed_m($1, ?)": {
      model: "text",
      init: { "$1": "person" },
      questions: [
        "What movies has $1 directed?",
        "Which movies has $1 been the director of?",
      ],
      steps: [
        {
          operation: "select",
          question: "text_directed(?, $1)",
          answer: "#1",
        },
      ],
    },
  },
  table_actor: {
    "acted_a($1, ?)": {
      model: "table",
      init: { "$1": "movie" },
      questions: [
        "Who all have acted in the movie $1?",
        "Who are the actors in the movie $1?",
      ],
      steps: [
        {
          operation: "select",
          question: "table_actor($1, ?)",
          answer: "#1",
        },
      ],
    },
    "acted_m($1, ?)": {
      model: "table",
      init: { "$1": "person" },
      questions: [
        "Which movies did $1 act in?",
        "Which movies has $1 been an actor in?",
      ],
      steps: [
        {
          operation: "select",
          question: "table_actor(?, $1)",
          answer: "#1",
        },
      ],
    },
  },
  text_actor: {
    "acted_a($1, ?)": {
      model: "text",
      init: { "$1": "movie" },
      questions: [
        "Who all acted in the movie $1?",
        "Who are the actors in the movie $1?",
      ],
      steps: [
        {
          operation: "select",
          question: "text_actor($1, ?)",
          answer: "#1",
        },
      ],
    },
    "acted_m($1, ?)": {
      model: "text",
      init: { "$1": "person" },
      questions: [
        "Which movies did $1 act in?",
        "Which movies has $1 been an actor in?",
      ],
      steps: [
        {
          operation: "select",
          question: "text_actor(?, $1)",
          answer: "#1",
        },
      ],
    },
  },
  table_writer: {
    "wrote_w($1, ?)": {
      model: "table",
      init: { "$1": "movie" },
      questions: [
        "Who are the writers of the movie $1?",
        "Which writers wrote $1?",
      ],
      steps: [
        {
          operation: "select",
          question: "table_writer($1, ?)",
          answer: "#1",
        },
      ],
    },
    "wrote_m($1, ?)": {
      model: "table",
      init: { "$1": "person" },
      questions: [
        "What movies has $1 written?",
        "Which movies has $1 been a writer for?",
      ],
      steps: [
        {
          operation: "select",
          question: "table_writer(?, $1)",
          answer: "#1",
        },
      ],
    },
  },
  text_writer: {
    "wrote_w($1, ?)": {
      model: "text",
      init: { "$1": "movie" },
      questions: [
        "Who wrote $1?",
        "Which writers wrote the movie $1?",
      ],
      steps: [
        {
          operation: "select",
          question: "text_writer($1, ?)",
          answer: "#1",
        },
      ],
    },
    "wrote_m($1, ?)": {
      model: "text",
      init: { "$1": "person" },
      questions: [
        "What movies has $1 written?",
        "Which movies has $1 been a writer for?",
      ],
      steps: [
        {
          operation: "select",
          question: "text_writer(?, $1)",
          answer: "#1",
        },
      ],
    },
  },
  table_produced: {
    "produced_c($1, ?)": {
      model: "table",
      init: { "$1": "movie" },
      questions: [
        "Who were the producers of the movie $1?",
        "Who all produced the movie $1?",
      ],
      steps: [
        {
          operation: "select",
          question: "table_produced($1, ?)",
          answer: "#1",
        },
      ],
    },
    "produced_m($1, ?)": {
      model: "table",
      init: { "$1": "person" },
      questions: [
        "For which movies was $1 the producer?",
        "$1 produced which movies?",
      ],
      steps: [
        {
          operation: "select",
          question: "table_produced(?, $1)",
          answer: "#1",
        },
      ],
    },
  },
  text_produced: {
    "produced_c($1, ?)": {
      model: "text",
      init: { "$1": "movie" },
      questions: [
        "Who were the producers in the movie $1?",
        "Who all produced the movie $1?",
      ],
      steps: [
        {
          operation: "select",
          question: "text_produced($1, ?)",
          answer: "#1",
        },
      ],
    },
    "produced_m($1, ?)": {
      model: "text",
      init: { "$1": "person" },
      questions: [
        "For which movies was $1 the producer?",
        "$1 produced which movies?",
      ],
      steps: [
        {
          operation: "select",
          question: "text_produced(?, $1)",
          answer: "#1",
        },
      ],
    },
  },
  table_maward: {
    "maward_a($1, ?)": {
      model: "table",
      init: { "$1": "movie" },
      questions: [
        "Which awards were given to $1?",
        "Which awards did the movie $1 win?",
      ],
      steps: [
        {
          operation: "select",
          question: "table_maward($1, ?)",
          answer: "#1",
        },
      ],
    },
    "maward_m($1, ?)": {
      model: "table",
      init: { "$1": "m_award" },
      questions: [
        "Which movies were given the $1 award?",
        "The award $1 has been awarded to which movies?",
      ],
      steps: [
        {
          operation: "select",
          question: "table_maward(?, $1)",
          answer: "#1",
        },
      ],
    },
  },
  table_paward: {
    "paward_a($1, ?)": {
      model: "table",
      init: { "$1": "person" },
      questions: [
        "Which awards has $1 won?",
        "$1 has been awarded which awards?",
      ],
      steps: [
        {
          operation: "select",
          question: "table_paward($1, ?)",
          answer: "#1",
        },
      ],
    },
    "paward_p($1, ?)": {
      model: "table",
      init: { "$1": "p_award" },
      questions: [
        "Who have won the $1 award?",
        "Who has been awarded the $1 award?",
      ],
      steps: [
        {
          operation: "select",
          question: "table_paward(?, $1)",
          answer: "#1",
        },
      ],
    },
  },
  text_paward: {
    "paward_a($1, ?)": {
      model: "text",
      init: { "$1": "person" },
      questions: [
        "Which awards were given to $1?",
        "What awards have $1 won?",
      ],
      steps: [
        {
          operation: "select",
          question: "text_paward($1, ?)",
          answer: "#1",
        },
      ],
    },
    "paward_p($1, ?)": {
      model: "text",
      init: { "$1": "p_award" },
      questions: [
        "Who have been given the $1 award?",
        "Who have been awarded the $1 award?",
      ],
      steps: [
        {
          operation: "select",
          question: "text_paward(?, $1)",
          answer: "#1",
        },
      ],
    },
  },
  text_dob: {
    "dob_y($1, ?)": {
      model: "text",
      init: { "$1": "person" },
      questions: [
        "In which year was $1 born in?",
        "When was $1 born",
      ],
      steps: [
        {
          operation: "select",
          question: "text_dob($1, ?)",
          answer: "#1",
        },
      ],
    },
    "dob_p($1, ?)": {
      model: "text",
      init: { "$1": "b_year" },
      questions: [
        "Who were born in the year $1?",
        "Who were born in $1?",
      ],
      steps: [
        {
          operation: "select",
          question: "text_dob(?, $1)",
          answer: "#1",
        },
      ],
    },
  },
  text_nation: {
    "nation_n($1, ?)": {
      model: "text",
      init: { "$1": "person" },
      questions: [
        "From which country is $1?",
        "Where is $1 from?",
      ],
      steps: [
        {
          operation: "select",
          question: "text_nation($1, ?)",
          answer: "#1",
        },
      ],
    },
    "nation_p($1, ?)": {
      model: "text",
      init: { "$1": "nation" },
      questions: [
        "Who are from $1?",
        "Who is from the country $1?",
      ],
      steps: [
        {
          operation: "select",
          question: "text_nation(?, $1)",
          answer: "#1",
        },
      ],
    },
  },
}
