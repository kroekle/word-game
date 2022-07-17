package rules

import future.keywords.in
import future.keywords.every
import data.words.scores
import data.rules.invalid

main["jarvis"] := jarvis {
  input.jarvis
}

jarvis[m] {
  count(input.guesses) == 0
  m := sprintf("What's the issue, are you waiting for me to give you a word?  Try %v", [scores[0].word])
}

jarvis[m] {
  count(input.guesses) == 6
  not correct
  m := "I failed you, next time you might not want to listen to me"
}

jarvis[m] {
  not input.guesses
  years := count(data.words.used)/365.25
  best_used_word := [b | w := scores[_]; w.used; b := w.word][0]
  m := sprintf("I like starting with %v, but if you like the feeling of getting the word in one try every %1.3F years then you can try %v", [scores[0].word, years, best_used_word])
}

jarvis["You couldn't have done it without me"] {
  correct
}

jarvis[m] {
  not correct
  m := sprintf("I think you should try %v", [best_word])
}

best_word_list := scores {
  count(input.guesses) < 4
}

best_word_list := l {
  count(input.guesses) >= 4
  l := [w | some w in scores; w.used]
}

best_word := w {
  not invalid
  w := [wrd| 
    some wrd in best_word_list
    
    word_chars := split(wrd.word, "")

    count({i|known_letters[i] == word_chars[i]}) == count(known_letters)
    
    count({c| cnt := number_of_letters[c]; count([c|  word_chars[_] == c]) >= cnt}) == count(number_of_letters)
    
    count({c| cnt := exact_number_of_letters[c]; count([c|  word_chars[_] == c]) == cnt}) == count(exact_number_of_letters)

    every p in unknown_pos {
      not word_chars[p] in not_char[p]
    }
  ][0].word
}

exact_number_of_letters[c] := n {
	cnt := result_letters[i][c]
    count([c| char := split(input.guesses[i], "")[_]; char == c]) > cnt 
    n := array.reverse(sort([n| n := result_letters[_][c]]))[0]
}

number_of_letters[c] := n {
	result_letters[_][c]
    n := array.reverse(sort([n| n := result_letters[_][c]]))[0]
}

result_letters[i] := l {
	word := split(input.guesses[i], "")
	l := {c:n | 
    		c := word[_] 
       		n := count([c|word[j] == c; guess_result[i][j] in [c, "*"]])
        }
}

unknown_pos[i] {
	positions[i]
    not known_letters[i]
}

not_char[i] := c {
	positions[i]
	c := {c | guess_result[j][i] in ["-","*"]; c := split(input.guesses[j], "")[i]}
}

known_letters[p] := l {
  some r in guess_result
  l := r[p]
  not l in ["*", "-"]
}

