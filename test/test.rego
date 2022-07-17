package test

import data.rules.get_mark
import data.rules.contains_unused_letter
import data.rules.guess_result

test_multiple_letters_correct_position {
  r := guess_result with input.word as 0 with input.guesses as ["lllll"] with data.words.used as ["hello"]
  r[0][0] == "-"
  r[0][1] == "-"
  r[0][2] == "l"
  r[0][3] == "l"
  r[0][4] == "-"
}

test_multiple_letters_incorrect_positions {
  r := guess_result with input.word as 0 with input.guesses as ["llxxl"] with data.words.used as ["hello"]
  r[0][0] == "*"
  r[0][1] == "*"
  r[0][2] == "-"
  r[0][3] == "-"
  r[0][4] == "-"
}

test_multiple_letters_correct_and_incorrect_position {
  r := guess_result with input.word as 0 with input.guesses as ["lxlxl"] with data.words.used as ["hello"]
  r[0][0] == "*"
  r[0][1] == "-"
  r[0][2] == "l"
  r[0][3] == "-"
  r[0][4] == "-"
}

test_one_out_of_place {
  r := guess_result with input.word as 0 with input.guesses as ["saree","reney", "eider"] with data.words.used as ["greet"]
  print("result: ", r)
  r[0][0] == "-"
  r[0][1] == "-"
  r[0][2] == "*"
  r[0][3] == "e"
  r[0][4] == "*"
}

