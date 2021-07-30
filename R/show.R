
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' show a single palette with a title
#'
#' @param colours character vector of hex colours
#' @param title title
#' @param labels colour labels. if null then use colour names as-is, otherwise
#'        use these labels given as a character vector
#' @param show_labels default: TRUE
#' @param borders set borders
#' @param cex_label size for colour label
#' @param ncol number of colums. id NULL (the default), then make the result
#'        as square as possible
#'
#' @import graphics
#' @import farver
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
show_palette <- function (colours, title = NULL, labels = NULL, show_labels = TRUE,
                          borders = NULL, cex_label = 1,
                          ncol = NULL) {
  n <- length(colours)
  ncol <- ncol %||% ceiling(sqrt(length(colours)))
  nrow <- ceiling(n/ncol)
  colours <- c(colours, rep(NA, nrow * ncol - length(colours)))
  colours <- matrix(colours, ncol = ncol, byrow = TRUE)
  if (is.null(title)) {
    old <- par(pty = "s", mar = c(0, 0, 0, 0))
  } else {
    old <- par(pty = "s", mar = c(0, 0, 5, 0))
  }
  on.exit(par(old))
  size <- max(dim(colours))
  plot(c(0, size), c(0, -size), type = "n", xlab = "", ylab = "", axes = FALSE)

  rect(
    xleft   =  col(colours) - 1,
    ybottom = -row(colours) + 1,
    xright  =  col(colours),
    ytop    = -row(colours),
    col     = colours,
    border  = borders
  )

  if (is.null(labels)) {
    words <- colours_to_words(colours)
    labels <- paste0(colours, "\n(", words, ")")
    labels[is.na(colours)] <- ""
  }

  if (show_labels) {
    hcl       <- farver::decode_colour(colours, "rgb", "hcl")
    label_col <- ifelse(hcl[, "l"] > 50, "black", "white")
    text(
      x      =  col(colours) - 0.5,
      y      = -row(colours) + 0.5,
      labels = labels,
      cex    = cex_label,
      col    = label_col
    )
  }

  if (!is.null(title)) {
    title(title)
  }

  invisible(NULL)
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Side-by-side comparison of 2 palettes
#'
#' @param colours1,colours2 character vector of hex colours
#' @param title1,title2 title
#' @param labels1,labels2 colour labels. if null then use colour names as-is, otherwise
#'        use these labels given as a character vector
#' @param ... other arguments forwarded to show_palette
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
compare_palettes <- function(colours1, colours2, title1 = NULL, title2 = NULL, labels1 = NULL, labels2 = NULL, ...) {

  oldpar <- par(mfrow = c(1, 2))
  on.exit(par(oldpar))

  show_palette(colours = colours1, title = title1, labels = labels1, ...)
  show_palette(colours = colours2, title = title2, labels = labels2, ...)

  invisible(NULL)
}


