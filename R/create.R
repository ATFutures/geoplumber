#' Simulate CRA without create-react-app
#'
#' This function assembles the required npm package files to then build from.
#'
#' @param path character: new/existing path of the target gp app.
#'
#' @export
#' @examples
#' p = file.path(tempdir(), "gp_app")
#' gp_create(p)
#' gp_erase()
gp_create <- function(path = getwd()) {
  if(gp_is_wd_geoplumber())
    stop("Directory seems to be a gp app already.")
  if(!dir.exists(path)) {
    message("Creating directory: ", path)
    dir.create(path)
  } else {
    # check to proceed if other files exist
    if(length(dir(path)) !=0) {
      if(interactive()) {
        message("Path: ", path)
        message(list.files(path))
        reply = utils::menu(c("Yes", "No"),
                            title="Directory not empty, proceed?")
        if(reply == 2) {
          stop("OK leaving '", path, "' untouched.")
        }
      } else {
        # TODO: could use force=TRUE param
        stop("Directory '", path, "' not empty.")
      }
    }
  }
  # simulate an app
  dir.create(file.path(path, "R"))
  # copy CRA files over
  gp_temp_files <- list.files(
    system.file("js", package="geoplumber"))
  sapply(gp_temp_files, function(x){
    file.copy(system.file(file.path("js", x), package = "geoplumber"),
              path, recursive = TRUE)
  })
  file.copy(system.file("plumber.R", package = "geoplumber")
            , file.path(path, "R"))
  ow <- setwd(path)
  rename_package.json(basename(path))
  setwd(ow)
  # we are done
  message(paste0("To build/run app, set working directory to: ", path))
  message("Standard output from create-react-app works.\n",
          "You can run gp_ functions from directory: ", path,
          "\nTo build the front end run: gp_build()\n",
          "To run the geoplumber app: gp_plumb()\n",
          "Happy coding.")
  # write path to `tempfile_name()`
  write_tempfile(path)
}


#' Remove a geoplumber project and clean associated directories
#'
#' @param dir_name name of gp project directory (if NULL, previously-built
#' directory will be erased)
#'
#' @export
gp_erase <- function(dir_name = NULL) {
  if (is.null(dir_name))
    dir_name <- read_tempfile() # from R/utils.R
  wd <- getwd()
  # only a gp directory, could check with user
  # if not interactive, wont be so useful
  if(gp_is_wd_geoplumber(dir_name)) {
    setwd (dir_name)
    setwd ("..")
    message("Erasing '", dir_name, "' ...")
    unlink (dir_name, recursive = TRUE)
    if (file.exists(tempfile_name()))
      invisible(file.remove(tempfile_name()))
    if (file.exists(wd)) # dir_name might have been wd itself
      setwd(wd)
  }
}

#' Essential checks for certain functions of geoplumber.
#'
#' gp_build, gp_create and others rely on npm/node being present
#' on the system and might be used in future so refactoring a helper function
#' is good.
#'
#' @return TRUE/FALSE
#' @examples {
#' gp_npm_exists()
#' }
#' @export
gp_npm_exists <- function() {
  # TODO: hide system errors.
  check_node <- system("node -v", ignore.stdout = TRUE, ignore.stderr = TRUE)
  check_npm <- system("npm -v", ignore.stdout = TRUE, ignore.stderr = TRUE)
  check_npm == 0 && check_node == 0
}
