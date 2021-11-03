[
  {
    init: {
      "$1": "nation",
    },
    questions: [
      "What was the gap between the longest and shortest discus throws by athletes from $1?",
    ],
    steps: [
      {
        operation: "select",
        question: "nationd_p($1, ?)",
        answer: "#1",
      },
      {
        operation: "project_values_flat",
        question: "dthrow_l(#1, ?)",
        answer: "#2",
      },
      {
        operation: "select",
        question: "max(#2)",
        answer: "#3",
      },
      {
        operation: "select",
        question: "min(#2)",
        answer: "#4",
      },
      {
        operation: "select",
        question: "diff(#3 | #4)",
        answer: "#5",
      },
    ],
  },
  {
    init: {
      "$1": "personj",
    },
    questions: [
      "What was the gap between the longest and shortest javelin throws by $1?",
    ],
    steps: [
      {
        operation: "select",
        question: "jthrow_l($1, ?)",
        answer: "#1",
      },
      {
        operation: "select",
        question: "max(#1)",
        answer: "#2",
      },
      {
        operation: "select",
        question: "min(#1)",
        answer: "#3",
      },
      {
        operation: "select",
        question: "diff(#2 | #3)",
        answer: "#4",
      },
    ],
  },
  {
    init: {
      "$1": "nation",
      "$2": "nation",
    },
    questions: [
      "What was the gap between the best discus throws from $1 and $2?",
    ],
    steps: [
      {
        operation: "select",
        question: "nationd_p($1, ?)",
        answer: "#1",
      },
      {
        operation: "project_values_flat",
        question: "dthrow_l(#1, ?)",
        answer: "#2",
      },
      {
        operation: "select",
        question: "max(#2)",
        answer: "#3",
      },
      {
        operation: "select",
        question: "nationd_p($2, ?)",
        answer: "#4",
      },
      {
        operation: "project_values_flat",
        question: "dthrow_l(#4, ?)",
        answer: "#5",
      },
      {
        operation: "select",
        question: "max(#5)",
        answer: "#6",
      },
      {
        operation: "select",
        question: "diff(#3 | #6)",
        answer: "#7",
      },
    ],
  },
  {
    init: {
      "$1": "jlength",
    },
    questions: [
      "Who threw discus throws longer than $1?",
    ],
    steps: [
      {
        operation: "select",
        question: "dthrows(?)",
        answer: "#1",
      },
      {
        operation: "project",
        question: "dthrow_l(#1, ?)",
        answer: "#2",
      },
      {
        operation: "projectValues",
        question: "max(#2)",
        answer: "#3",
      },
      {
        operation: "filterValues_keys",
        question: "is_greater(#3 | $1)",
        answer: "#4",
      },
    ],
  },
  {
    init: {
      "$1": "dlength",
    },
    questions: [
      "Who threw javelins shorter than $1?",
    ],
    steps: [
      {
        operation: "select",
        question: "jthrows(?)",
        answer: "#1",
      },
      {
        operation: "project",
        question: "jthrow_l(#1, ?)",
        answer: "#2",
      },
      {
        operation: "projectValues",
        question: "min(#2)",
        answer: "#3",
      },
      {
        operation: "filterValues_keys",
        question: "is_smaller(#3 | $1)",
        answer: "#4",
      },
    ],
  },
  {
    init: {
      "$1": "jlength",
    },
    questions: [
      "How many javelin throws were shorter than $1?",
    ],
    steps: [
      {
        operation: "select",
        question: "jthrows(?)",
        answer: "#1",
      },
      {
        operation: "project_values_flat",
        question: "jthrow_l(#1, ?)",
        answer: "#2",
      },
      {
        operation: "filter(#2)",
        question: "is_smaller(#2 | $1)",
        answer: "#3",
      },
      {
        operation: "select",
        question: "count(#3)",
        answer: "#4",
      },
    ],
  },
]
