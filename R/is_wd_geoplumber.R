#' Helper function to determin if working dir is a geoplumber app.
#'
#' Conditions for a geoplumber app (at least initiated with)
#' 1. An 'R' directory with R/plumber.R file
#' 2. A 'src' directory
#' 3. A 'package.json' file at root.
#'
#' @param path check particular path
#' @return `TRUE` or `FALSE`
#'
#' @examples {
#' gp_is_wd_geoplumber()
#' }
#'
#' @export
gp_is_wd_geoplumber <- function(path = ".") {
  # be functional
  the_path <- path

  if(identical(path, ".")) {
    # just remove it
    the_path <- ""
  }
  if(!exists(path))
    the_path = getwd()
  dir_r <- dir.exists(file.path(the_path, "R"))
  dir_src <- dir.exists(file.path(the_path, "src"))
  package.json <- file.exists(file.path(the_path, "package.json"))
  if(dir_r && dir_src && package.json) {
    return(TRUE)
  }
  FALSE
}

stop_ifnot_geoplumber <- function() {
  if(!gp_is_wd_geoplumber()) {
    stop("Is working directory a geoplumber app? ",
        getwd(), "\nEither change directory or run gp_create() to create one.")
  }
}
