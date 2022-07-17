package transform

import future.keywords.in

letters = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]

positions = [0,1,2,3,4]

out["used"] = input.used
out["unused"] = input.unused
out["scores"] = array.reverse(sort(array.concat(unused_scores, used_scores)))

stats[p] = s {
  some p in positions
  s := {l:count(wds) | some l in letters; wds := [w|some w in input.used; split(w, "")[p] == l ]}
}

letter_adjustment[c] = n {
  some c in letters
  n := sum([s| s := stats[_][c]])/max_letter_score/10
}

max_letter_score := max([n | some c in letters; n:= sum([s| s := stats[_][c]])])

unused_scores = [x | 
  some w in input.unused; 
  x := {
    "word": w,
    "score": score_word(w),
    "used": false
  }
]

used_scores = [x | 
  some w in input.used; 
  x := {
    "word": w,
    "score": score_word(w),
    "used": true
  }
]

score_word(word) = s {
  values := [v| c = split(word, "")[p]; v := stats[p][c]]
  s := sum(values) * duplicate_letter_adjustment(word) * letter_adjust(word)
}

duplicate_letter_adjustment(word) = .5 {
  c := split(word, "")[_]
  count([c| split(word, "")[_] == c]) > 1
} else = 1

letter_adjust(word) = a {
  a := 1 + sum([a| c := split(word, "")[_]; a := letter_adjustment[c]])
} else = 1
