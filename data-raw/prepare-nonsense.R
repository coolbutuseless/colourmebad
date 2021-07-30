
set.seed(2021)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# All the letters possible
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
letters <- c("a", "b", "c", "d", "e", "f", "g", "l", "o", "s", "t", "z")

dictionary_words_with_substitutions <- system('grep -i -E "^[abcdeflsotgz]{6}$" ../colourmebad-annexe/working/english-words/words_alpha.txt', intern = TRUE)

words <- dictionary_words_with_substitutions



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Initialise an empty structure to hold bigrams and trigrams
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
bicount <- list()
for (l1 in letters) {
  bicount[[l1]] <- list()
  for (l2 in letters) {
    bicount[[l1]][[l2]] <- 0L
  }
}

tricount <- list()
for (l1 in letters) {
  for (l2 in letters) {
    key <- paste(l1, l2, sep = '')
    tricount[[key]] <- list()
    for (l3 in letters) {
      tricount[[key]][[l3]] <- 0L
    }
  }
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Count bi-grams
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
for (chars in strsplit(words, "")) {
  for (i in 1:5) {
    c1 <- chars[[i     ]]
    c2 <- chars[[i + 1L]]
    bicount[[c1]][[c2]] <- bicount[[c1]][[c2]] + 1L
  }
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Count tri-grams
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
for (chars in strsplit(words, "")) {
  for (i in 3:6) {
    c1 <- chars[[i - 1L]]
    c2 <- chars[[i - 2L]]
    c3 <- chars[[i     ]]
    key <- paste(c1, c2, sep = '')
    tricount[[key]][[c3]] <- tricount[[key]][[c3]] + 1L
  }
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Calculated 'weight' i.e. probability that one character is followed by another
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
biweights <- lapply(bicount, function(x) {
  unlist(x) / sum(unlist(x))
})

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Calculate prob that a character follows 2 prior characters.
# it is possible that some of these are empty. e.g. impossible to
# have 'tt' followed by 't'
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
triweights <- lapply(tricount, function(x) {
  res <- unlist(x) / sum(unlist(x))
  res
})

all_good <- function(x) {
  !anyNA(x) && !any(is.nan(x))
}
triweights <- Filter(all_good, triweights)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Create some nonsense words from these bi-grams and tri-grams
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
N <- 100000
set.seed(2)
nonsense <- character(N)
for (idx in seq(N)) {
  chars <- character(6)
  chars[1] <- sample(letters, 1)
  chars[2] <- sample(letters, size = 1, prob = biweights[[chars[1L]]])
  for (i in 3:6) {
    key <- paste(chars[[i-2]], chars[[i-1]], sep="")
    if (!key %in% names(triweights)) break
    # print(key)
    chars[i] <- sample(letters, size = 1, prob = triweights[[key]])
  }
  if (any(chars == "")) {
    # not valid
  } else {
    nonsense[idx] <- paste(chars, collapse = "")
  }
}

nonsense <- nonsense[nonsense!=""]
nonsense <- unique(nonsense)
length(nonsense)
head(nonsense, 50)
