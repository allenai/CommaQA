[
  {
    init: {
      "$1": "person",
    },
    questions: [
      "What objects has $1 likely used?",
    ],
    steps: [
      {
        operation: "select",
        question: "died_y($1, ?)",
        answer: "#1",
      },
      {
        operation: "select",
        question: "invented(?)",
        answer: "#2",
      },
      {
        operation: "project",
        question: "invent_y(#2, ?)",
        answer: "#3",
      },
      {
        operation: "filterKeys(#3)",
        question: "is_smaller(#3 | #1)",
        answer: "#4",
      },
    ],
  },
  {
    init: {
      "$1": "person",
    },
    questions: [
      "What objects has $1 likely used?",
    ],
    steps: [
      {
        operation: "select",
        question: "works_o($1, ?)",
        answer: "#1",
      },
      {
        operation: "project_values_flat_unique",
        question: "graduate_f2(#1, ?)",
        answer: "#2",
      },
      {
        operation: "project_values_flat_unique",
        question: "usedf_ob(#2, ?)",
        answer: "#3",
      },
    ],
  },
  {
    init: {
      "$1": "person",
    },
    questions: [
      "What objects has $1 likely used?",
    ],
    steps: [
      {
        operation: "select",
        question: "field_f($1, ?)",
        answer: "#1",
      },
      {
        operation: "project_values_flat_unique",
        question: "study_o2(#1, ?)",
        answer: "#2",
      },
      {
        operation: "project_values_flat_unique",
        question: "usedo_ob(#2, ?)",
        answer: "#3",
      },
    ],
  },
  {
    init: {
      "$1": "person",
    },
    questions: [
      "What objects has $1 helped to make?",
    ],
    steps: [
      {
        operation: "select",
        question: "founded_c($1, ?)",
        answer: "#1",
      },
      {
        operation: "project_values_flat_unique",
        question: "developed_d(#1, ?)",
        answer: "#2",
      },
      {
        operation: "project_values_flat_unique",
        question: "isa_o(#2, ?)",
        answer: "#3",
      },
    ],
  },
  {
    init: {
      "$1": "person",
    },
    questions: [
      "What objects has $1 helped to make?",
    ],
    steps: [
      {
        operation: "select",
        question: "invented_t($1, ?)",
        answer: "#1",
      },
      {
        operation: "project_values_flat_unique",
        question: "usedin_d(#1, ?)",
        answer: "#2",
      },
      {
        operation: "project_values_flat_unique",
        question: "isa_o(#2, ?)",
        answer: "#3",
      },
    ],
  },
  {
    init: {
      "$1": "person",
    },
    questions: [
      "What objects has $1 helped to make?",
    ],
    steps: [
      {
        operation: "select",
        question: "founded_c($1, ?)",
        answer: "#1",
      },
      {
        operation: "project_values_flat_unique",
        question: "makes_m(#1, ?)",
        answer: "#2",
      },
      {
        operation: "project_values_flat_unique",
        question: "contains_o(#2, ?)",
        answer: "#3",
      },
    ],
  },
]
