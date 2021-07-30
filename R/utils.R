
'%||%' <- function(x, y) if (is.null(x)) y else x




#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Find best matches for a set of reference colours
#'
#' @param reference_colours original colours
#' @param candidate_colours large list of possible candidate colours. In this
#'        case these are colours possibly generated from words
#'
#' @return character vector of colours in \code{candidate_colours} which best
#'         match the colours in \code{reference_colours}
#'
#' @import grDevices
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
find_best_colour_match <- function(reference_colours, candidate_colours) {

  candidate_rgb <- as.data.frame(t(col2rgb(candidate_colours)/ 255))
  candidate_lab <- as.data.frame(grDevices::convertColor(candidate_rgb, 'sRGB', 'Lab'))

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Convert reference colours to Lab colourspace
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ref_lab <- as.data.frame(grDevices::convertColor(t(col2rgb(reference_colours))/255, 'sRGB', 'Lab'))

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Calculate the index of the closest candidae colour for each reference colour
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  matches <- integer(nrow(ref_lab))
  for (idx in seq(nrow(ref_lab))) {
    ref <- ref_lab[idx, ]
    dists <-
      (candidate_lab$L - ref$L)^2 +
      (candidate_lab$a - ref$a)^2 +
      (candidate_lab$b - ref$b)^2

    matches[idx] <- which.min(dists)
  }

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # data.frame of best colour matches for each of the reference colours
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  candidate_colours[matches]
}




