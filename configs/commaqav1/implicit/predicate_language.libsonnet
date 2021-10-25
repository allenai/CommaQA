{
  text_dob: {
    "born_p($1, ?)": {
      model: "text",
      init: { "$1": "b_year" },
      questions: ["Who were born in $1?", "Which people were born in the year $1?"],
      steps: [
        {
          operation: "select",
          question: "text_dob(?, $1)",
          answer: "#1",
        },
      ],
    },
    "born_y($1, ?)": {
      model: "text",
      init: { "$1": "person" },
      questions: ["When was $1 born?", "Which year was $1 born in?"],
      steps: [
        {
          operation: "select",
          question: "text_dob($1, ?)",
          answer: "#1",
        },
      ],
    },
  },
  text_dod: {
    "died_p($1, ?)": {
      model: "text",
      init: { "$1": "d_year" },
      questions: ["Who died in the year $1?", "Which people died in the year $1?"],
      steps: [
        {
          operation: "select",
          question: "text_dod(?, $1)",
          answer: "#1",
        },
      ],
    },
    "died_y($1, ?)": {
      model: "text",
      init: { "$1": "person" },
      questions: ["Which year did $1 die?", "When did $1 die?"],
      steps: [
        {
          operation: "select",
          question: "text_dod($1, ?)",
          answer: "#1",
        },
      ],
    },
  },
  text_occupation: {
    "works_o($1, ?)": {
      model: "text",
      init: { "$1": "person" },
      questions: ["What does $1 work as?", "What is $1's occupation?"],
      steps: [
        {
          operation: "select",
          question: "text_occupation($1, ?)",
          answer: "#1",
        },
      ],
    },
    "works_p($1, ?)": {
      model: "text",
      init: { "$1": "occupation" },
      questions: ["Who all work as $2?", "Which people work as a $2?"],
      steps: [
        {
          operation: "select",
          question: "text_occupation(?, $1)",
          answer: "#1",
        },
      ],
    },
  },
  text_field: {
    "field_f($1, ?)": {
      model: "text",
      init: { "$1": "person" },
      questions: ["What fields have $1 studied?", "What is $1's field of study?"],
      steps: [
        {
          operation: "select",
          question: "text_field($1, ?)",
          answer: "#1",
        },
      ],
    },
    "field_p($1, ?)": {
      model: "text",
      init: { "$1": "field" },
      questions: ["Who all have studied $1?", "Which people have studied $1?"],
      steps: [
        {
          operation: "select",
          question: "text_field(?, $1)",
          answer: "#1",
        },
      ],
    },
  },
  kb_studied_f: {
    "study_f($1, ?)": {
      model: "kb",
      init: { "$1": "occupation2" },
      questions: ["What field would someone working as $1 study?", "What would be the field of study for someone working as a $1?"],
      steps: [
        {
          operation: "select",
          question: "kb_studied_f($1, ?)",
          answer: "#1",
        },
      ],
    },
    "study_o2($1, ?)": {
      model: "kb",
      init: { "$1": "field" },
      questions: ["What occupation do people who study $1 work in?", "What is the occupation of people who study $1?"],
      steps: [
        {
          operation: "select",
          question: "kb_studied_f(?, $1)",
          answer: "#1",
        },
      ],
    },
  },
  kb_graduate_o: {
    "graduate_o($1, ?)": {
      model: "kb",
      init: { "$1": "field2" },
      questions: ["What occupation would you work as after studying $1?", "After studying $1, what occupation would you be in?"],
      steps: [
        {
          operation: "select",
          question: "kb_graduate_o($1, ?)",
          answer: "#1",
        },
      ],
    },
    "graduate_f2($1, ?)": {
      model: "kb",
      init: { "$1": "occupation" },
      questions: ["Which field have people working as $1 graduated from?", "What fields does a $1 study?"],
      steps: [
        {
          operation: "select",
          question: "kb_graduate_o(?, $1)",
          answer: "#1",
        },
      ],
    },
  },
  text_invent: {
    "invented(?)": {
      model: "text",
      init: {},
      questions: ["Which objects were invented?", "Which invented objects are mentioned?"],
      steps: [
        {
          operation: "select",
          question: "text_invent(?, _)",
          answer: "#1",
        },
      ],
    },
    "invent_y($1, ?)": {
      model: "text",
      init: { "$1": "obj" },
      questions: ["When was $1 invented?", "Which year was $1 invented?"],
      steps: [
        {
          operation: "select",
          question: "text_invent($1, ?)",
          answer: "#1",
        },
      ],
    },
    "invent_o($1, ?)": {
      model: "text",
      init: { "$1": "year" },
      questions: ["Which objects were invented in $1?", "What objects were invented in the year $1?"],
      steps: [
        {
          operation: "select",
          question: "text_invent(?, $1)",
          answer: "#1",
        },
      ],
    },
  },
  text_used_o: {
    "usedo_ob($1, ?)": {
      model: "text",
      init: { "$1": "occupation2" },
      questions: ["Which objects are used by a $1?", "What objects would a $1 use?"],
      steps: [
        {
          operation: "select",
          question: "text_used_o(?, $1)",
          answer: "#1",
        },
      ],
    },
    "usedo_oc($1, ?)": {
      model: "text",
      init: { "$1": "obj" },
      questions: ["$1 is used by people working as what?", "What would be the occupation of someone using $1?"],
      steps: [
        {
          operation: "select",
          question: "text_used_o($1, ?)",
          answer: "#1",
        },
      ],
    },
  },
  text_used_f: {
    "usedf_ob($1, ?)": {
      model: "text",
      init: { "$1": "field2" },
      questions: ["What objects are used in the study of $1?", "Which objects would someone studying $1 use?"],
      steps: [
        {
          operation: "select",
          question: "text_used_f(?, $1)",
          answer: "#1",
        },
      ],
    },
    "usedf_f($1, ?)": {
      model: "text",
      init: { "$1": "obj" },
      questions: ["Which fields of study use $1?", "$1 is used by people in which field of study?"],
      steps: [
        {
          operation: "select",
          question: "text_used_f($1, ?)",
          answer: "#1",
        },
      ],
    },
  },
  text_founded: {
    "founded_p($1, ?)": {
      model: "text",
      init: { "$1": "company" },
      questions: ["Who have founded the company $1?", "Who were the founders of $1?"],
      steps: [
        {
          operation: "select",
          question: "text_founded(?, $1)",
          answer: "#1",
        },
      ],
    },
    "founded_c($1, ?)": {
      model: "text",
      init: { "$1": "person" },
      questions: ["Which companies has $1 founded?", "$1 is the founder of which companies?"],
      steps: [
        {
          operation: "select",
          question: "text_founded($1, ?)",
          answer: "#1",
        },
      ],
    },
  },
  text_inventor: {
    "invented_p($1, ?)": {
      model: "text",
      init: { "$1": "tech" },
      questions: ["Who have developed the technology $1?", "Who were the developers of $1?"],
      steps: [
        {
          operation: "select",
          question: "text_inventor(?, $1)",
          answer: "#1",
        },
      ],
    },
    "invented_t($1, ?)": {
      model: "text",
      init: { "$1": "person" },
      questions: ["Which technologies has $1 developed?", "$1 is the inventor of which technologies?"],
      steps: [
        {
          operation: "select",
          question: "text_inventor($1, ?)",
          answer: "#1",
        },
      ],
    },
  },
  text_developed: {
    "developed_c($1, ?)": {
      model: "text",
      init: { "$1": "device" },
      questions: ["Which company has developed the device $1?", "$1 was produced by which company?"],
      steps: [
        {
          operation: "select",
          question: "text_developed(?, $1)",
          answer: "#1",
        },
      ],
    },
    "developed_d($1, ?)": {
      model: "text",
      init: { "$1": "company" },
      questions: ["Which devices has $1 developed?", "$1 has developed which devices?"],
      steps: [
        {
          operation: "select",
          question: "text_developed($1, ?)",
          answer: "#1",
        },
      ],
    },
  },
  text_makes: {
    "makes_c($1, ?)": {
      model: "text",
      init: { "$1": "material" },
      questions: ["Which company produces the material $1?", "$1 is produced by which company?"],
      steps: [
        {
          operation: "select",
          question: "text_makes(?, $1)",
          answer: "#1",
        },
      ],
    },
    "makes_m($1, ?)": {
      model: "text",
      init: { "$1": "company" },
      questions: ["Which materials does $1 produce?", "$1 produces which materials?"],
      steps: [
        {
          operation: "select",
          question: "text_makes($1, ?)",
          answer: "#1",
        },
      ],
    },
  },
  text_usedin: {
    "usedin_t($1, ?)": {
      model: "text",
      init: { "$1": "device" },
      questions: ["Which technology is used to develop $1?", "$1 relies on which technology?"],
      steps: [
        {
          operation: "select",
          question: "text_usedin(?, $1)",
          answer: "#1",
        },
      ],
    },
    "usedin_d($1, ?)": {
      model: "text",
      init: { "$1": "tech" },
      questions: ["Which devices depend on the $1 technology?", "$1 technology is used in which devices?"],
      steps: [
        {
          operation: "select",
          question: "text_usedin($1, ?)",
          answer: "#1",
        },
      ],
    },
  },
  text_contains: {
    "contains_m($1, ?)": {
      model: "text",
      init: { "$1": "obj" },
      questions: ["Which material is used to make $1?", "$1 uses what material?"],
      steps: [
        {
          operation: "select",
          question: "text_contains(?, $1)",
          answer: "#1",
        },
      ],
    },
    "contains_o($1, ?)": {
      model: "text",
      init: { "$1": "material" },
      questions: ["Which objects use $1 as a material?", "$1 material is used in which objects?"],
      steps: [
        {
          operation: "select",
          question: "text_contains($1, ?)",
          answer: "#1",
        },
      ],
    },
  },
  kb_isa: {
    "isa_d($1, ?)": {
      model: "kb",
      init: { "$1": "obj" },
      questions: ["Which devices are of the type $1?", "What devices are types of $1?"],
      steps: [
        {
          operation: "select",
          question: "kb_isa(?, $1)",
          answer: "#1",
        },
      ],
    },
    "isa_o($1, ?)": {
      model: "kb",
      init: { "$1": "device" },
      questions: ["What is the device $1 a type of?", "What object is $1 a type of?"],
      steps: [
        {
          operation: "select",
          question: "kb_isa($1, ?)",
          answer: "#1",
        },
      ],
    },
  },
  math_predicates: {
    "is_smaller($1 | $2)": {
      model: "math_special",
      init: { "$1": "year", "$2": "d_year" },
      questions: ["Is $1 smaller than $2?", "Is $1 less in value than $2?"],
    },
  },
}
