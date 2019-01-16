#' Wrapper function to view front end using dev server.
#'
#'
#' Currently geoplumber only works with React,
#' create-react-app comes with a dev server to view the front end..
#' This function must be called from a geoplumber app.
#'
#' @section TODO:
#' Solve the Linux ctrl+c to kill npm start
#'
#'
#' @examples
#' \dontrun{
#' # WARNING: to exit pluse ctrl+c twice to exit on Linux machines.
#' gp_plumb_front()
#' #> geoplumber@0.1.0 start /tmp/geoplumber
#' #> react-scripts start
#' # Starting the development server...
#' }
#' @export
gp_plumb_front <- function() {
  if(!gp_is_wd_geoplumber()) {
    stop("Is current dir a geoplumber app? \nTry geoplumber::gp_create() first.\n")
  }

  message("Running: ", "npm start")

  v <- npm_start()

  # if v is resolved, then it failed?
  # TODO: this _might_ not work, it needs a slight delay
  if(future::resolved(v)) {
    message("There was an error running npm start.")
  }
  # start_attempt <- system("npm start", ignore.stderr = TRUE)
  # TODO: could be other reason for failing.
  # if(start_attempt != 0) {
  #   # run gp_build()
  #   message("Looks like first run, installing npm packages...")
  #   message("Running: ", "gp_npm_install()")
  #   gp_npm_install()
  #   # back on to start
  #   message("Now starting React front end: ", "npm start")
  #   system("npm start") # keep outputs as default
  # }
}
