% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/geojson.R
\name{gp_map}
\alias{gp_map}
\title{Export geojson object on a map.}
\usage{
gp_map(
  x,
  browse_map = TRUE,
  dest_path = tempdir(),
  height = NULL,
  width = NULL
)
}
\arguments{
\item{x}{character or sf object: URL or sf object to view on map}

\item{browse_map}{logical: should the outcome be viewed in a browser?
defaults to \code{TRUE}}

\item{dest_path}{character: write output to \code{tempdir} (default).}

\item{height}{character: css compatible option for map height.}

\item{width}{character: css compatible option for map width.}
}
\value{
path character of path that html file was written to.
}
\description{
Export geojson object on a map.
}
\examples{
\dontrun{
gp_map(paste0("http://opendata.canterburymaps.govt.nz/datasets/",
"fb00b553120b4f2fac49aa76bc8d82aa_26.geojson"), browse_map = FALSE)
}
}
