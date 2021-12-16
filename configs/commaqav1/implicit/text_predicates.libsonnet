{
  text_dob: {
    args: ["person", "b_year"],
    nary: ["1", "n"],
    language: ["$1 was born in the year $2", "$1 was born in $2"],
  },
  text_dod: {
    args: ["person", "d_year"],
    nary: ["1", "n"],
    language: ["$1 died in $2", "$1 died in the year $2"],
  },
  text_occupation: {
    args: ["person", "occupation"],
    nary: ["n", "1"],
    language: ["$1 works as a $2", "$1's occupation is $2"],
  },
  text_field: {
    args: ["person", "field"],
    nary: ["n", "1"],
    language: ["$1 studied $2 in college", "$1's field of study was $2"],
  },
  text_invent: {
    args: ["obj", "year"],
    nary: ["1", "n"],
    language: ["$1 was first invented in the year $2", "$1 was invented in $2"],
  },
  text_used_o: {
    args: ["obj", "occupation2"],
    nary: ["1", "n"],
    language: ["$1 is often used by people working as $2", "A $2 would often use a $1"],
  },
  text_used_f: {
    args: ["obj", "field2"],
    nary: ["1", "n"],
    language: ["$1 is commonly used in the field of $2", "When studying $2, $1 would be used"],
  },
  text_founded: {
    args: ["person", "company"],
    nary: ["n", "1"],
    language: ["$1 founded the company $2", "$1 was the founder of the company $2"],
  },
  text_inventor: {
    args: ["person", "tech"],
    nary: ["n", "1"],
    language: ["$1 invented the technology of $2", "$1 was the inventor of $2 technology"],
  },
  text_developed: {
    args: ["company", "device"],
    nary: ["n", "1"],
    language: ["The $2 was developed at $1", "$2 was developed by the $1 company"],
  },
  text_makes: {
    args: ["company", "material"],
    nary: ["n", "1"],
    language: ["$1 is a provider of the material $2", "$2 is produced by the company $1"],
  },
  text_usedin: {
    args: ["tech", "device"],
    nary: ["n", "1"],
    language: ["The $1 technology was instrumental in the development of $1", "$2 device was developed based on the $1 technology"],
  },
  text_contains: {
    args: ["material", "obj"],
    nary: ["n", "1"],
    language: ["$2 is made using $1 material", "$1 material is needed to make $2"],
  },
}
