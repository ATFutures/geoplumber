#' Launch a webserver via plumber to serve data
#'
#' @param port to serve from
#' @param file location of plumber.R file used by plumber
#' @param run should plumber run the server or return it as an object
#' @param front should geoplumber start the front dev server? Defaults
#' to `FALSE`.
#' @seealso [gp_plumb_front()]
#'
#' @export
#' @examples \dontrun{
#' gp_install_react() # install react
#' gp_build() # build frond-end
#' gp_plumb()
#' }
gp_plumb <- function(run = TRUE,
                     port = 8000,
                     file = "R/plumber.R",
                     front = FALSE) {
  wd <- change_to_proj_dir ()
  stop_ifnot_geoplumber()

  # todo: when initiating project copy plumber.R file to somewhere sensible
  # e.g. in newly created plumber/ directory (the code should also create this)
  # todo: create @parm new_session which serves from a new R session by default
  # (checkout out future pkg for this)

  server <- plumber::plumb(file = file)
  #plumber works without a frontend
  if(!dir.exists("build")){
    message("WARNING:\n",
            "Looks like geoplumber was not build, serveing API only.\n",
            "To serve the front end run gp_build() first.")
    server$handle("GET", "/", function(res){
      fname <- system.file("build.missing.html", package = "geoplumber")
      plumber::include_html(fname, res)
    })
  }
  # run the front in future
  if(front) {
    v <- npm_start()

    # if v is resolved, then it failed?
    if(future::resolved(v)) {
      message("There was an error running npm start.")
    }
  }
  # run plumb without future for now
  if(run) {
    viewer <- getOption("viewer")
    if(identical(.Platform$GUI, "RStudio") && !is.null(viewer)) {
      viewer(paste0("http://localhost:", port))
    } else {
      utils::browseURL(paste0("http://localhost:", port))
    }
    server$run(port = port, swagger = TRUE)
  } else {
    return(server)
  }
}


