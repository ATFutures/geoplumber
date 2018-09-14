#' Adds an endpoint function to the plumber.R from clipboard.
#'
#' To use this function, write the endpoint somewhere and then copy it into clipboard.
#' Then call this function.
#' This function uses `clipr` to write it to the 'plumber.R' file.
#' For now only file will be plumber.R
#'
#'
#' TODO:
#' add silent param, write to other .R files.
#'
#' @param evaluate extra check on clipboard content
#' @return None
#'
#' @examples \dontrun{
#'# Following is a valid endpoint to serve geoplumber::traffic dataset:
#'# = begin ===>
#'# Serve geoplumber::traffic from /api/data
#'
#'# @get /api/data
#'# get_traffic <- function(res) {
#'#   geojson <- geojsonio::geojson_json(geoplumber::traffic)
#'#   res$body <- geojson
#'#   res
#'# }
#'# <==== end =
#'# holindg current clipboard
#' old_clip <- clipr::read_clip()
#'# adding above to clipboard
#' clipr::write_clip(c(
#' "#' Serve geoplumber::traffic from /api/data",
#' "@get /api/data",
#' "get_traffic <- function(res) {",
#' "geojson <- geojsonio::geojson_json(geoplumber::traffic)",
#'  "res$body <- geojson",
#'  "res",
#' "}"
#' ))
#' # clipr::read_clip()
#' gp_endpoint_from_clip()
#' clipr::write_clip(old_clip)
#' }
#'
#' @export
gp_endpoint_from_clip <- function(evaluate = FALSE) {
  # next call reads and checks clip emptyness.
  # sanity check
  gp_check_clip_endpoint(evaluate = evaluate)
  # if there is no plumber.R we must stop
  plumberR <- "R/plumber.R"
  if(!file.exists(plumberR)) {
    stop("Error: cannot find R/plumber.R file.")
  }
  clip <- suppressWarnings(clipr::read_clip())
  # write
  write(c("\n# endoint -----------------------------------",
          clip),
        file = plumberR, append = TRUE)
  message(
    "Success.\n",
    "Please restart your server: gp_plumb()"
  )
}

#' Basic sanity check of the plumber endpiont
#'
#' Use this function to check that:
#'
#' 1. There is an endpoint "/api/test" etc.
#' 2. There is a "tag" such as @get/@post
#' 3. Defines a function with/without params
#' 4. Serves a content-type https://www.w3.org/TR/html4/types.html#h-6.7.
#' No specific checks on the return for now just !is.null()
#' 5. TODO: content-type matches
#'
#' using clipr we read from the clipboard
#'
#' @param evaluate should clipboard function be evaulated? Default is (`FALSE`)
#'
#' @return number of warnings
#'
#' @examples \dontrun{
#' gp_check_clip_endpoint()
#' }
#' @export
gp_check_clip_endpoint <- function(evaluate = FALSE) {
  warningCount <- 0
  # silence clipr::read_clip temp
  # https://stackoverflow.com/a/32719422/2332101
  # oldw <- getOption("warn")
  # options(warn = -1)
  clip <- suppressWarnings(clipr::read_clip())
  # options(warn = oldw)
  if(is.null(clip)) {
    # should not be adding empty lines
    stop("Error: Clipboard empty. Please copy a valid endpoint to clipboard first.")
  }
  if(grepl("gp_endpoint_from_clip", clip) ||
     grepl("gp_check_clip_endpoint", clip)) {
    stop(paste0("Clipboard: \n",
                clip, "\n",
                " was going to be an infinite loop. Stopping.")
         )
  }
  message("Clipboard contents: \n",
          "------begin----\n",
          paste(clip,collapse="\n"),
          "\n-----end-----\n")
  # 1. is there an endooint /api/data?
  matches <- grep("/[[:alpha:]]+", clip, value = TRUE)
  if(identical(matches, character(0))) {
    warning("Function does not seem to define an endpoint, e.g: /api/data")
    warningCount <- warningCount + 1
  }
  # 2. is there an api verb?
  # https://github.com/trestletech/plumber/blob/1332047d57242404c6ccb2ba5a28bd1255b8d2bd/R/plumber.R#L6
  verbs <- c("GET", "PUT", "POST", "DELETE", "HEAD", "OPTIONS", "PATCH")
  matches <- unique (grep(paste(verbs, collapse="|"), clip, value = TRUE, ignore.case=TRUE))
  # above would return character(0) if none of the verbs can be found.
  if(identical(matches, character(0))) {
    warning("Functiond does not contain any of the API verbs: ",
            paste(verbs, collapse = ", "))
    warningCount <- warningCount + 1
  }
  # 3. defines a function?
  if(class(eval(parse(text = clip))) != 'function') {
    warning("Endpoint doesnt seem to be a function.")
    warningCount <- warningCount + 1
  }

  # 4. using eval(parse(text=clip)) returns something?
  if(evaluate){
    evalClip <- try({
      # keep it inside try as it might be an expression rather than a function
      ret <- eval(parse(text = clip)) # the function
      if(class(ret) == 'function') {
        ret <- ret()
      }
      # if runs fine but returns nothing.
      if (is.null(ret)) {
        # stop?
        warning("Function seems to be returning nothing.")
        warningCount <- warningCount + 1
      }
      ret
    }) # TODO: could be silenced.
    # http://adv-r.had.co.nz/Exceptions-Debugging.html#debugging-tools
    if(class(evalClip) == "try-error") {
      warning("Clipboard content failed to parse")
      warningCount <- warningCount + 1
    }
  }
  # successful checks should get some feedback.
  if(warningCount == 0) {
    message("No warnings given.")
  }
  warningCount
}
