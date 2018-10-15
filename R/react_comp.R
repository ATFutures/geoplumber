#' Creates an R6 R represetnation of a ReactJS component
#'
#'
#' WIP
#'
#' @param name React component name
#' @param props a named R list of React props for the component.
#'
#' @examples {
#' library(R6)
#' r <- gp_react_comp("helloworld")
#' r
#'# React Component:
#'# import React, { Component } from 'react';
#'# export default class helloworld extends Component {
#'#   render() {
#'#     return(
#'#       <p>
#'#         I am helloworld.
#'#       </p>
#'#     )
#'#   }
#'# }
#' }
#' @export
gp_react_comp <- function(name = "R", props = list(r = "R6")) {
  React <- R6::R6Class("React", list(
    name =  NULL,    # NOT assignment
    out = c("init"), # NOT assignment
    imports = c("import React, { Component } from 'react';"),
    render_top = c(paste0(next_spaces("next"), "render() {"),
                   paste0(next_spaces("    next"), "return(")),
    render_cont = c(paste0(next_spaces("        next"), "<p>"),
                    paste0(next_spaces("            next"), "I am ", name,"."),
                    paste0(next_spaces("        next"), "</p>")),
    render_bot = c(paste0(next_spaces("    next"), ")", sep = ""),
                   paste0(next_spaces("next"), "}")),
    render = NULL,
    props = list(),
    # state = list(),
    initialize = function(name, props) {
      self$name <- name
      # TODO: refactor and generate from all instance variables
      # not just props and see how "state" could come to play.
      # think about inheritnace, React children.
      self$out <- c(self$imports,
                    paste0("export default class ", self$name, " extends Component {"),
                    self$render_top,
                    self$render_cont,
                    self$render_bot,
                    "}" # end
                    )
      self$props <- props
    },
    print = function(...) {
      cat(self$out, sep = "\n")
      invisible(self)
    },
    constructor = function() {
      const <- c(paste0(next_spaces("next"), "constructor(props) {"),
                 paste0(next_spaces("    next"), "super(props)"),paste0(next_spaces("    next"), "//empty"),
                 paste0(next_spaces("next"), "}")
      )
      cat(const, sep = "\n")
    },
    set_state = function() {
      cat("state should be set from functions called.")
    }
  ))
  r <- React$new(name, props)
  r
}
