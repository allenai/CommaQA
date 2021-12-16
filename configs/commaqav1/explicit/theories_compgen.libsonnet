[
  {
    init: {
      "$1": "nation",
    },
    questions: [
      "What movies have the people from $1 written?",
    ],
    steps: [
      {
        operation: "select",
        question: "nation_p($1, ?)",
        answer: "#1",
      },
      {
        operation: "project_values_flat_unique",
        question: "wrote_m(#1, ?)",
        answer: "#2",
      },
    ],
  },
  {
    init: {
      "$1": "b_year",
    },
    questions: [
      "What movies have people born in $1 acted in?",
    ],
    steps: [
      {
        operation: "select",
        question: "dob_p($1, ?)",
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
      "What awards have movies produced by people from $1 won?",
    ],
    steps: [
      {
        operation: "select",
        question: "nation_p($1, ?)",
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
      "What awards have movies directed by people born in $1 won?",
    ],
    steps: [
      {
        operation: "select",
        question: "dob_p($1, ?)",
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
      "$1": "nation",
    },
    questions: [
      "What awards have movies written by people from $1 won?",
    ],
    steps: [
      {
        operation: "select",
        question: "nation_p($1, ?)",
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
      "$1": "m_award",
    },
    questions: [
      "What awards have the directors of the $1 winning movies received?",
    ],
    steps: [
      {
        operation: "select",
        question: "maward_m($1, ?)",
        answer: "#1",
      },
      {
        operation: "project_values_flat_unique",
        question: "directed_d(#1, ?)",
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
