#' Build npm packages
#'
#' This function must be called to build
#' React build for online front-end.
#'
#' Runs npm run build. This creates an optimized, production and minified JS front end
#' which is ready to be deployed anywhere.
#'
#' @section TODO: this function will be used less and less during development.
#' For now geoplumber does not have a development function. Once this becomes available,
#' the two functions will work together but do totally different tasks.
#'
#' @param clean clean build TODO
#'
#' @export
gp_build <- function(clean = FALSE) {
  if (!gp_npm_exists()) {
    msg <- paste0 ("geoplumber failed to identify a version of node ",
                   "on this system:\n", Sys.info()["sysname"], "\n",
                   gp_install_node_instructions())
    stop (msg)
  }

  if (!(file.exists ("package.json") | file.exists (tempfile_name ())))
    stop("Geoplumber failed to identify a package.json in working directory:\n",
         getwd(), "\nEither change to directory of previously-created ",
         "geoplumger app,\nor run gp_create() to create one.")

  wd <- change_to_proj_dir ()

  # TODO: do more checks before actually running the command
  build_attempt <- try({
    message("Running: ", "npm run build")
    result <- system("npm run build", ignore.stderr = TRUE)
    result
  })
  if(build_attempt != 0) {
    # run gp_build()
    message("Looks like first run, installing npm packages...")
    message("Running: ", "gp_npm_install()")
    gp_npm_install()
    # back on to build
    message("Now trying to build: ", "npm run build")
    system("npm run build") # we wont filter ignore.stdout or ignore.stderr
  }
  # in both cases.
  message("Standard output from create-react-app above works.\n",
          "To run the geoplumber app: gp_plumb()\n")
  setwd (wd)
}
