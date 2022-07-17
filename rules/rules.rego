package rules

import future.keywords.in
import future.keywords.every

default correct := false

main["message"] := message
main["guesses"] := formatted_result 
main["correct"] := correct {
  not invalid
}

message[m] {
  correct
  not invalid
  m := sprintf("You got the correct answer in %v tries", [count(input.guesses)])
}

message["Add your guess to the guesses property one at a time"] {
  count(input.guesses) = 0
}

message["That's not how the game works, you only get 6 tries"] {
  count(input.guesses) > 6
}

message[`Use the following object format -d '{"word": 999, "guess": ["guess"]'`] {
  not has_required_input
}

message[m] {
  not valid_word_index
  m := sprintf("Word index needs to be between 0 and %v", [count(words)-1])
}

invalid {
  not has_required_input
}

invalid {
  count(input.guesses) > 6
}

invalid {
  not valid_word_index
}

valid_word_index {
  input.word >=0 
  input.word < count(words)
}

has_required_input {

  every p in ["guesses","word"] {
    input[p]
  }
}

import data.words.used as words
import data.words.unused

positions := [0,1,2,3,4]

daily_word := words[input.word]
daily_word_chars := split(daily_word, "")

all_words := array.concat(words, unused)

invalid_guess[w] {
  some w in input.guesses
  not w in all_words
}

invalid {
  count(invalid_guess) > 0
}

correct {
  not invalid
  daily_word == input.guesses[count(input.guesses)-1]
}

message[m] {
  not correct
  not invalid
  m := sprintf("Good guess.  But %v is not the word", [input.guesses[count(input.guesses) -1]])
}

message[m] {
  count(invalid_guess) > 0
  m := sprintf("%v is not a valid word", [concat(", ", invalid_guess)])	
}

formatted_result = r {
  r := [f | 
          g := input.guesses[p]
          g in all_words
          f := sprintf("%v -> %v%v%v%v%v", array.concat([g], guess_result[p]))
        ]
}

guess_result[t] = p {
  w := input.guesses[t]
  p := [x | some i in positions; x := get_mark(i, w)]
}

get_mark(pos, w) := m {
  daily_word_chars[pos] == split(w, "")[pos]
  m := daily_word_chars[pos]
} else := m {
  some c in daily_word_chars
  c == split(w, "")[pos]
  total_in_daily(c) - correct_chars(w, c) - previous_chars(w, pos) > 0
  m := "*"
} else := "-"

correct_chars(w, c) := n {
  chars := split(w, "")
  n := count([p | daily_word_chars[p] == chars[p]; chars[p] == c])
}

previous_chars(w,p) = n {
  chars := split(w, "")
  n := count([i | 
                chars[i] == chars[p]
                not daily_word_chars[i] == chars[i]
                i < p
             ]) 
}

total_in_daily(c) = n {
  n := count([i | daily_word_chars[i] == c])
}

