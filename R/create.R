#' Simulate CRA without create-react-app
#'
#' This function assembles the required npm package files to then build from.
#'
#' @param path character: existing path of the target gp app.
#'
#' @export
#' @examples
#' gp_create(tempdir()) # it would simulate an app in tempdir()
gp_create <- function(path = getwd()) {
  if(gp_is_wd_geoplumber())
    stop("Directory seems to be a gp app already.")
  if(!dir.exists(path))
    stop(paste0('Directory ', path, "' does not exist."))
  # simulate an app
  dir.create(file.path(path, "R"))
  # cross platform of doing:
  # system(paste0("cp -R ", system.file("js", package = "geoplumber"), "/* ", path))
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
}


#' Remove a plumber project and clean associated directories
#'
#' @param dir_name Name of project directory (if NULL, previously-built
#' directory will be erased)
#'
#' @export
gp_erase <- function(dir_name = NULL) {
  if (is.null (dir_name))
    dir_name <- read_tempfile() # from R/utils.R
  wd <- getwd ()
  setwd (dir_name)
  setwd ("..")
  unlink (dir_name, recursive = TRUE)
  if (file.exists (tempfile_name ()))
    invisible (file.remove (tempfile_name ()))
  if (file.exists (wd))
    setwd (wd)
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
