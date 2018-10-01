#' Initialize a new create-react-app and add add required packages.
#'
#'
#' Warning: may take several minutes depending on system and internet connection.
#'
#' @param project_name path of the new app, will be passed to `npx create-react-app `
#' TODO: allow current directory, with `.Rproj` for example.
#'
#' @export
#' @examples \dontrun{
#' gp_create()
#' }
gp_create <- function(project_name = "geoplumber") {
  if(!gp_npm_exists()) {
    msg <- paste0 ("geoplumber requires node and npm to work.\n",
                   gp_install_node_instructions()) # UNIX only
    stop (msg)
  }
  dir_name <- project_name
  if(project_name == ".") {
    dir_name <- getwd()
  }
  if (!file.exists (dirname (dir_name)))
      stop ("The path ", dirname (dir_name), "does not exist")

  project_name <- basename(dir_name)
  if (identical (basename(dir_name), dir_name))
      dir_name <- file.path(getwd(), dir_name)

  # project_name is the single name passed to npm;
  # dir_name is the full expanded name of the directory holding the project

  # check if create-react-app package is installed.
  npmList <- "npm list create-react-app"
  check <- system(paste0(npmList, " -g"))
  if(check != 0) {
    craMissing <- "create-react-app is not available globally"
    # check if it has been created locally, just in case.
    check <- system(npmList)
    if(check == 0) {
      # cra IS available locally
      message("create-react-app is installed locally.")
    } else {
      stop(paste0(craMissing, " or locally.\n", "Please install it globally using: \n",
                  "sudo npm i -g create-react-app\n",
                  "Then rerun gp_create()"))
    }
  }
  # TODO: manage project path along with npm
  # for now let npm do the lifting
  message(paste0("Initializing project at: ", dir_name))
  # TODO: give geoplumber failed message
  # TODO: (MP) Make directory construction more flexible
  # For now npm gives an error if dir exists.
  npx.cmd <- paste0("npx create-react-app ", project_name)
  npx.result <- system(npx.cmd)
  if(npx.result != 0) {
    # fialed stop and provide the error
    stop("Please refer to the ", npx.cmd, " error above.")
  }
  system(paste0("cd ", dir_name))
  wd_old <- setwd(dir_name)
  # copy plumber.R
  system("mkdir R")
  # cp plumber.R R
  system(paste0("cp ", system.file("plumber.R", package = "geoplumber"), " R"))
  # cp -r inst/js .
  system(paste0("cp -R ", system.file("js", package = "geoplumber"), "/* ."))
  pkg_json <- readLines("package.json")
  pkg_json[2] <- sub("geoplumber", project_name, pkg_json[2]) # as it could be path or .
  write(pkg_json, "package.json") # project name reset.
  # setwd("~/code/geoplumber/") # comment out!
  message(paste0("To build/run app, set working directory to: ", project_name))
  message("Standard output from create-react-app above works.\n",
          "You can run gp_ functions from directory: ", project_name,
          "\nTo build the front end run: gp_build()\n",
          "To run the geoplumber app: gp_plumb()\n",
          "Happy coding.")
  setwd(wd_old)

  # write dir_name to `tempfile_name()`
  write_tempfile(dir_name)
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
