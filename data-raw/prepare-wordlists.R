


# Words from: https://github.com/dwyl/english-words/
colour_words <- system('grep -i -E "^[abcdef]{6}$" ../colourmebad-annexe/working/english-words/words_alpha.txt', intern = TRUE)

colour_words <- colourmebad::words_to_colours(colour_words)
# show_palette(colours)



colour_words_with_substitutions <- system('grep -i -E "^[abcdeflsotgz]{6}$" ../colourmebad-annexe/working/english-words/words_alpha.txt', intern = TRUE)

# c(o = 0, l = 1, z = 2, s = 5, t = 7, g = 9, e = 3)
# show_palette(colours, show_labels = FALSE)


source(here::here("data-raw", "prepare-nonsense.R"))

nonsense_words <- sort(unique(c(colour_words_with_substitutions, nonsense)))
nonsense_words <- colourmebad::words_to_colours(nonsense_words)

colour_words_with_substitutions <- colourmebad::words_to_colours(colour_words_with_substitutions)

usethis::use_data(colour_words, colour_words_with_substitutions, nonsense_words, compress = TRUE, overwrite = TRUE)
