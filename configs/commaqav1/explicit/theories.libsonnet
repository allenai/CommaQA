[
  {
    init: {
      "$1": "nation",
    },
    questions: [
      "What movies have people from the country $1 acted in?",
    ],
    steps: [
      {
        operation: "select",
        question: "nation_p($1, ?)",
        answer: "#1",
      },
      {
        operation: "project_values_flat_unique",
        question: "acted_m(#1, ?)",
        answer: "#2",
      },
    ],
  },
  {
    init: {
      "$1": "nation",
    },
    questions: [
      "What movies have the directors from $1 directed?",
    ],
    steps: [
      {
        operation: "select",
        question: "nation_p($1, ?)",
        answer: "#1",
      },
      {
        operation: "project_values_flat_unique",
        question: "directed_m(#1, ?)",
        answer: "#2",
      },
    ],
  },
  {
    init: {
      "$1": "b_year",
    },
    questions: [
      "What awards have movies produced by people born in $1 won?",
    ],
    steps: [
      {
        operation: "select",
        question: "dob_p($1, ?)",
        answer: "#1",
      },
      {
        operation: "project_values_flat_unique",
        question: "produced_m(#1, ?)",
        answer: "#2",
      },
      {
        operation: "project_values_flat_unique",
        question: "maward_a(#2, ?)",
        answer: "#3",
      },
    ],
  },
  {
    init: {
      "$1": "b_year",
    },
    questions: [
      "What awards have movies written by people born in $1 won?",
    ],
    steps: [
      {
        operation: "select",
        question: "dob_p($1, ?)",
        answer: "#1",
      },
      {
        operation: "project_values_flat_unique",
        question: "wrote_m(#1, ?)",
        answer: "#2",
      },
      {
        operation: "project_values_flat_unique",
        question: "maward_a(#2, ?)",
        answer: "#3",
      },
    ],
  },
  {
    init: {
      "$1": "p_award",
    },
    questions: [
      "What awards did the movies directed by the $1 winners receive?",
    ],
    steps: [
      {
        operation: "select",
        question: "paward_p($1, ?)",
        answer: "#1",
      },
      {
        operation: "project_values_flat_unique",
        question: "directed_m(#1, ?)",
        answer: "#2",
      },
      {
        operation: "project_values_flat_unique",
        question: "maward_a(#2, ?)",
        answer: "#3",
      },
    ],
  },
  {
    init: {
      "$1": "m_award",
    },
    questions: [
      "What awards have the actors of the $1 winning movies received?",
    ],
    steps: [
      {
        operation: "select",
        question: "maward_m($1, ?)",
        answer: "#1",
      },
      {
        operation: "project_values_flat_unique",
        question: "acted_a(#1, ?)",
        answer: "#2",
      },
      {
        operation: "project_values_flat_unique",
        question: "paward_a(#2, ?)",
        answer: "#3",
      },
    ],
  },
]
