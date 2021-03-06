% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/show.R
\name{compare_palettes}
\alias{compare_palettes}
\title{Side-by-side comparison of 2 palettes}
\usage{
compare_palettes(
  colours1,
  colours2,
  title1 = NULL,
  title2 = NULL,
  labels1 = NULL,
  labels2 = NULL,
  ...
)
}
\arguments{
\item{colours1, colours2}{character vector of hex colours}

\item{title1, title2}{title}

\item{labels1, labels2}{colour labels. if null then use colour names as-is, otherwise
use these labels given as a character vector}

\item{...}{other arguments forwarded to show_palette}
}
\description{
Side-by-side comparison of 2 palettes
}
