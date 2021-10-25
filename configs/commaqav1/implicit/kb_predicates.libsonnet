{
  kb_studied_f: {
    args: ["occupation2", "field"],
    nary: ["1", "n"],
    language: ["Study $2 | MotivatedByGoal | Work as $1", "Working as $1 | HasPrerequisite | Studying $2"],
  },
  kb_graduate_o: {
    args: ["field2", "occupation"],
    nary: ["1", "n"],
    language: ["Study $1 | MotivatedByGoal | Work as $2)", "Working as $2 | HasPrerequisite | Studying $1"],
  },
  kb_isa: {
    args: ["device", "obj"],
    nary: ["n", "1"],
    language: ["$1 | Isa | $2", "$1 device | Isa | $2 object"],
  },
}
