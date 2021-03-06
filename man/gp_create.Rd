% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/create.R
\name{gp_create}
\alias{gp_create}
\title{Simulate CRA without create-react-app}
\usage{
gp_create(path = getwd())
}
\arguments{
\item{path}{character: new/existing path of the target gp app.}
}
\description{
This function assembles the required npm package files to then build from.
}
\examples{
p = file.path(tempdir(), "gp_app")
gp_create(p)
gp_erase()
}
