{
  table_nationj: {
    "nationj_p($1, ?)": {
      model: "table",
      init: { "$1": "nation" },
      questions: ["Who are the javelin throwers from $1?", "Which javelin throwers are from the country $1?"],
      steps: [
        {
          operation: "select",
          question: "table_nationj(?, $1)",
          answer: "#1",
        },
      ],
    },
    "nationj_n($1, ?)": {
      model: "table",
      init: { "$1": "personj" },
      questions: ["Which country does $1 play for?", "Which country is $1 from?"],
      steps: [
        {
          operation: "select",
          question: "table_nationj($1, ?)",
          answer: "#1",
        },
      ],
    },
  },
  table_nationd: {
    "nationd_p($1, ?)": {
      model: "table",
      init: { "$1": "nation" },
      questions: ["Who are the discus throwers from $1?", "Which discus throwers are from the country $1?"],
      steps: [
        {
          operation: "select",
          question: "table_nationd(?, $1)",
          answer: "#1",
        },
      ],
    },
    "nationd_n($1, ?)": {
      model: "table",
      init: { "$1": "persond" },
      questions: ["Which country does $1 play for?", "Which country is $1 from?"],
      steps: [
        {
          operation: "select",
          question: "table_nationd($1, ?)",
          answer: "#1",
        },
      ],
    },
  },
  text_jthrow: {
    "jthrow_l($1, ?)": {
      model: "text",
      init: { "$1": "personj" },
      questions: ["What were the lengths of the javelin throws by $1?", "What lengths were $1's javelin throws?"],
      steps: [
        {
          operation: "select",
          question: "text_jthrow($1, ?)",
          answer: "#1",
        },
      ],
    },
    "jthrow_p($1, ?)": {
      model: "text",
      init: { "$1": "jlength" },
      questions: ["Who threw the javelin for $1?", "Who was a javelin thrower for $1?"],
      steps: [
        {
          operation: "select",
          question: "text_jthrow(?, $1)",
          answer: "#1",
        },
      ],
    },
    "jthrows(?)": {
      model: "text",
      init: {},
      questions: ["Who performed javelin throws?", "Who threw javelins?"],
      steps: [
        {
          operation: "select_unique",
          question: "text_jthrow(?, _)",
          answer: "#1",
        },
      ],
    },
  },
  text_dthrow: {
    "dthrow_l($1, ?)": {
      model: "text",
      init: { "$1": "personj" },
      questions: ["What were the lengths of the discus throws by $1?", "What lengths were $1's discus throws?"],
      steps: [
        {
          operation: "select",
          question: "text_dthrow($1, ?)",
          answer: "#1",
        },
      ],
    },
    "dthrow_p($1, ?)": {
      model: "text",
      init: { "$1": "dlength" },
      questions: ["Who threw the discus for $1?", "Who was a discus thrower for $1?"],
      steps: [
        {
          operation: "select",
          question: "text_dthrow(?, $1)",
          answer: "#1",
        },
      ],
    },
    "dthrows(?)": {
      model: "text",
      init: {},
      questions: ["Who performed discus throws?", "Who threw discus?"],
      steps: [
        {
          operation: "select_unique",
          question: "text_dthrow(?, _)",
          answer: "#1",
        },
      ],
    },
  },
  math_predicates: {
    "max($1)": {
      model: "math_special",
      init: { "$1": "list(dlength)" },
      questions: ["Which is the largest value in $1?", "What is the largest value among $1?"],
    },
    "min($1)": {
      model: "math_special",
      init: { "$1": "list(jlength)" },
      questions: ["Which is the smallest value in $1?", "What is the smallest value among $1?"],
    },
    "count($1)": {
      model: "math_special",
      init: { "$1": "list(dlength)" },
      questions: ["How many items are there in $1?", "What is the length of $1?"],
    },
    "is_smaller($1 | $2)": {
      model: "math_special",
      init: { "$1": "dlength", "$2": "dlength" },
      questions: ["Is $1 smaller than $2?", "Is $1 less in value than $2?"],
    },
    "is_greater($1 | $2)": {
      model: "math_special",
      init: { "$1": "jlength", "$2": "jlength" },
      questions: ["Is $1 greater than $2?", "Is $1 higher in value than $2?"],
    },
    "diff($1 | $2)": {
      model: "math_special",
      init: { "$1": "dlength", "$2": "jlength" },
      questions: ["What is the difference between $1 and $2?", "What is the difference in values between $1 and $2?"],
    },
  },
}
