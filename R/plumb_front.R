#' Wrapper function to view front end using dev server.
#'
#'
#' Currently geoplumber only works with React,
#' create-react-app comes with a dev server to view the front end..
#' This function must be called from a geoplumber app.
#'
#'
#' @param background run the command in the background, default `TRUE`
#' @examples
#' \dontrun{
#' # WARNING: to exit pluse ctrl+c twice to exit on Linux machines.
#' gp_plumb_front()
#' #> geoplumber@0.1.0 start /tmp/geoplumber
#' #> react-scripts start
#' # Starting the development server...
#' }
#' @export
gp_plumb_front <- function(background = TRUE) {
  stop_ifnot_geoplumber()

  message("Attempting: ", "npm start")
  npm_start(background = background)
  # start_attempt <- system("npm start", ignore.stderr = TRUE)
  # TODO: could be other reason for failing.
  # if(start_attempt != 0) {
  #   # run gp_build()
  #   message("Looks like first run, installing npm packages...")
  #   message("Running: ", "gp_npm_install()")
  #   system("npm install")
  #   # back on to start
  #   message("Now starting React front end: ", "npm start")
  #   system("npm start") # keep outputs as default
  # }
}
