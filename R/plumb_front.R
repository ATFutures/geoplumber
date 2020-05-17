#' Wrapper function to view front end using dev server.
#'
#'
#' Currently geoplumber only works with React,
#' create-react-app comes with a dev server to view the front end..
#' This function must be called from a geoplumber app.
#'
#'
#' @param background run the command in the background, default `TRUE`
#'
#' @examples
#' \dontrun{
#' gp_plumb_front()
#' }
#' @export
gp_plumb_front <- function(background = TRUE) {
  stop_ifnot_geoplumber()

  message("Attempting: ", "npm start")
  if(is_port_engated()) {
    # TODO: choice of different port
    stop("Something is running on port 3000.")
  }
  if(background) {
    ps <- callr::r_bg(system, list("npm start"))
    return(ps)
  }
  system("npm start")
  # if(r) utils::browseURL("http://localhost:3000")
}
