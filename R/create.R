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
    stop("geoplumber requires node and npm to work.")
    # show UNIX instructions.
    gp_install_node_instructions()
  }
  dir_name <- project_name
  if(project_name == ".") {
    # stop("Sorry! Current version does not support creating within existing directory.")
    dir_name <- basename(getwd())
  }
  if(grepl("/", project_name)) {
    # path given
    # TODO: check if path exists
    dir_name <- basename(project_name)
  }
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
  message(paste0("Initializing project at: ", project_name))
  # TODO: give geoplumber failed message
  # For now npm gives an error if dir exists.
  system(paste0("npx create-react-app ", project_name))
  system(paste0("cd ", project_name))
  wd_old <- setwd(project_name)
  # copy plumber.R
  system("mkdir R")
  # cp plumber.R R
  system(paste0("cp ", system.file("plumber.R", package = "geoplumber"), " R"))
  # cp -r inst/js .
  system(paste0("cp -R ", system.file("js", package = "geoplumber"), "/* ."))
  pkg_json <- readLines("package.json")
  pkg_json[2] <- sub("geoplumber", dir_name, pkg_json[2]) # as it could be path or .
  write(pkg_json, "package.json") # project name reset.
  # setwd("~/code/geoplumber/") # comment out!
  message(paste0("Ready to build app in directory: ", project_name))
  message("Standard output from create-react-app above works.\n",
          "You can run gp_ functions from directory: ", project_name,
          "\nTo build the front end run: gp_build()\n",
          "To run the geoplumber app: gp_plumb()\n",
          "Happy coding.")
  setwd(wd_old)
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
