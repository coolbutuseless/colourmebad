

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Cnvert words to colours using the given number to letter subsitituions
#'
#' @param words character vector of words which can be represented as colours
#' @param colours character vector of colours
#' @param substitutions number-to-letter substitutions substituions
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
words_to_colours <- function(words, substitutions = c(o = 0, l = 1, z = 2, s = 5, t = 7, g = 9)) {

  colours <- tolower(words)

  for (i in seq_along(substitutions)) {
    colours <- gsub(names(substitutions)[i], substitutions[i], colours)
  }

  good <- !is.na(colours) & grepl("^[a-f0-9]{6}$", colours)

  if (any(!good)) {
    stop("The following words are not convertible to hex colours with the given substituions:\n", dput(words[!good]))
  }

  paste0('#', colours)
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' @rdname words_to_colours
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
colours_to_words <- function(colours, substitutions = c(o = 0, l = 1, z = 2, s = 5, t = 7, g = 9)) {

  colours <- rgb(t(col2rgb(colours))/255)
  words  <- substr(tolower(colours), 2, 7)

  for (i in seq_along(substitutions)) {
    words <- gsub(substitutions[i], names(substitutions)[i], words)
  }

  words
}
