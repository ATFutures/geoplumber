#' Install react npm package
#'
#' Installs the stack of npm packages needed for building the react app.
#' Warning: may take several minutes depending on system and internet connection.
#'
#' @param local should the node modules be installed locally (the default, `TRUE`)
#' or globally (`FALSE`)
#' @export
#' @examples \dontrun{
#' gp_install_react()
#' }
gp_install_react <- function(local = TRUE) {

  # todo: add packages arg + generalise
  if(local) {
    system("npm i create-react-app")
  } else {
    system("npm i -g create-react-app")
  }

}
