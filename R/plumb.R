#' Launch a webserver via plumber to serve data
#'
#' @param port to serve from
#' @param file location of plumber.R file used by plumber
#'
#' @export
#' @examples \dontrun{
#' gp_install_react() # install react
#' gp_build() # build frond-end
#' gp_plumb()
#' }
gp_plumb <- function(port = 8000, file = "R/plumber.R") {
  wd <- change_to_proj_dir ()
  if(!gp_is_wd_geoplumber()) {
    stop("Is working directory a geoplumber app? ",
            getwd(), "\nEither change directory or run gp_create() to create one.")
  }

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

  viewer <- getOption("viewer")
  if(identical(.Platform$GUI, "RStudio") && !is.null(viewer)) {
    viewer(paste0("http://localhost:", port))
  } else {
    utils::browseURL(paste0("http://localhost:", port))
  }

  server$run(port = port, swagger = TRUE)
}
