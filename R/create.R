#' Initialize a new create-react-app and add add required packages.
#'
#'
#' Warning: may take several minutes depending on system and internet connection.
#'
#' @param path path of the new app, will be passed to `npx create-react-app `
#'
#' @export
#' @examples \dontrun{
#' gp_create()
#' }
gp_create <- function(path = "geoplumber") {
  if(rproj_file_exists(path)) {
    print(list.files(path))
    stop ("create-react-app requires a clean directory.\n",
          "You can use gp_rstudio() function to crate an Rstudio project.")
  }
  if(!gp_npm_exists()) {
    msg <- paste0 ("geoplumber requires node and npm to work.\n",
                   gp_install_node_instructions()) # UNIX only
    stop (msg)
  }
  # TODO: is this allowed? or should we respect /tmp?
  if(identical(tolower(tempdir()), path)) {
    unlink(path, recursive = TRUE)
  }
  # separate path from project name
  # project_name is the single name used for package.json etc.
  # dir_name is the full expanded name of the directory holding the project
  # also used for npx commands
  dir_name <- path
  if(path == ".") {
    dir_name <- getwd()
  }
  if (!file.exists (dirname (dir_name)))
      stop ("The path ", dirname (dir_name), "does not exist")

  project_name <- basename(dir_name)
  # if either . or dirname given make it a path for write_tempfile and other use.
  if (identical (basename(dir_name), dir_name)) # dir_name here is == path except for "."
      dir_name <- file.path(getwd(), dir_name)

  # check if create-react-app package is installed.
  npmList <- "npm list create-react-app"
  check <- system(paste0(npmList, " -g"))
  if(check != 0) {
    craMissing <- "create-react-app is not available globally"
    # check if it has been created locally, just in case.
    check <- system(npmList)
    if(check == 0) {
      # cra IS available locally let CRA decide.
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
  npx.cmd <- paste0("npx create-react-app ", dir_name)
  npx.result <- system(npx.cmd)
  if(npx.result != 0) {
    # fialed stop and provide the error
    stop("Please refer to the ", npx.cmd, " error above.")
  }
  # proceed to init geoplumber app
  wd_old <- setwd(dir_name)
  # copy plumber.R
  dir.create("R")
  file.copy(system.file("plumber.R", package = "geoplumber"), "R")
  # get the templates in
  gp_temp_files <- list.files(
    system.file("js", package="geoplumber"))
  # following copies in package.json, too
  # TODO: ideally we want npm to do npm i jobs
  # TODO: by removing package.json from inst/js and using:
  # install_npm_dependencies()
  # TODO: this for now not possible/easy see
  # https://github.com/ATFutures/geoplumber/issues/61#issuecomment-458128969
  sapply(gp_temp_files, function(x){
    file.copy(system.file(file.path("js", x), package = "geoplumber"),
              getwd(), recursive = TRUE)
    })
  rename_package.json(project_name)
  # we are done
  message(paste0("To build/run app, set working directory to: ", path))
  message("Standard output from create-react-app above works.\n",
          "You can run gp_ functions from directory: ", path,
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

#' Simulate CRA without create-react-app
#'
#' Because `[gp_create()]` uses the underlying CRA npm package, it is slow.
#' This function assembles the required npm package files to then build from.
#'
#' @param path character: existing path of the target gp app.
#'
#' @export
#' @examples
#' gp_cra_init(tempdir()) # it would simulate an app in tempdir()
gp_cra_init <- function(path = getwd()) {
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
