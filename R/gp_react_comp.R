#' Creates an R6 R represetnation of a ReactJS component
#'
#'
#' WIP
#'
#' @param name React component name
#' @param props a named R list of React props for the component.
#'
#' @examples {
#' r <- gp_react_comp("helloworld")
#' r
#' }
#' @export
gp_react_comp <- function(name = "R", props = list(r = "R6Class")) {
  React <- R6Class("React", list(
    name =  NULL,    # NOT assignment
    out = c("init"), # NOT assignment
    props = list(),
    # state = list(),
    initialize = function(name, props) {
      self$name <- name
      # TODO: refactor and generate from all instance variables
      # not just props and see how "state" could come to play.
      # think about inheritnace, React children.
      self$out <- c("React Component: ",
                    "import React, { Component } from 'react';",
                    paste0("export default class ", self$name, " extends Component {"),
                    paste0(next_spaces("next"), "render() {"),
                    paste0(next_spaces("    next"), "return("),
                    paste0(next_spaces("        next"), "<p>"),
                    paste0(next_spaces("            next"), "I am ", self$name,"."),
                    paste0(next_spaces("        next"), "</p>"),
                    paste0(next_spaces("    next"), ")", sep = ""),
                    paste0(next_spaces("next"), "}"),
                    "}"
                    )
      self$props <- props
    },
    print = function(...) {
      cat(self$out, sep = "\n")
      invisible(self)
    }
  ))
  r <- React$new(name, props)
  r
}
