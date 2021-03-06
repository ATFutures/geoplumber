% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{add_import_component}
\alias{add_import_component}
\title{takes a vector of strings, adds a Babel style import statement}
\usage{
add_import_component(
  target,
  component.name,
  component.path,
  keyword = "export default",
  package = FALSE
)
}
\arguments{
\item{target}{vector to add import statement in.}

\item{component.name}{name of component to import.}

\item{component.path}{path to "import" from.}

\item{keyword}{to use as anchor to add import statement.}

\item{package}{is the import statement for a package?
TODO: multiple or \verb{const \{\}} JS way of importing.}
}
\description{
takes a vector of strings, adds a Babel style import statement
}
