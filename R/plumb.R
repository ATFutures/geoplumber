#' Launch a webserver via plumber to serve data
#'
#' @param port to serve from
#' @param file location of plumber.R file used by plumber
#' @param run should plumber run the server or return it as an object
#' @param front should geoplumber start the front dev server? Defaults
#' @param host host to pass to plumber default `http://127.0.0.1`
#' to `FALSE`.
#' @param background run the R process in the background using callr,
#' defaults to `TRUE`.
#'
#' @seealso [gp_plumb_front()]
#'
#' @return an instance of plumber::plumb if `run` is set to `FALSE`,
#' a process id from `callr::r_bg` to easily destroy if parameter
#' `background` is default `TRUE`.
#'
#' @export
#' @examples {
#' d <- file.path(tempdir(), "gp")
#' gp_create(d)
#' old <- setwd(d)
#' ps <- gp_plumb()
#' ps
#' Sys.sleep(1) # just in case
#' ps
#' require(RCurl)
#' webpage <- getURL("http://localhost:8000")
#' webpage <- readLines(tc <- textConnection(webpage)); close(tc)
#' tail(webpage)
#' ps$kill()
#' setwd(old)
#' unlink(d, recursive = TRUE)
#' }
gp_plumb <- function(run = TRUE,
                     port = 8000,
                     file = "R/plumber.R",
                     front = FALSE,
                     host = "127.0.0.1",
                     background = TRUE) {
  stop_ifnot_geoplumber()

  # todo: when initiating project copy plumber.R file to somewhere sensible
  # e.g. in newly created plumber/ directory (the code should also create this)
  # todo: create @parm new_session which serves from a new R session by default
  # (checkout out future pkg for this)

  server <- plumber::plumb(file = file)
  #plumber works without a frontend
  if(!dir.exists("build")){
    message("WARNING:\n",
            "Looks like geoplumber was not built, serveing API only.\n",
            "To serve the front end run gp_build() first.")
    server$handle("GET", "/", function(res){
      fname <- system.file("build.missing.html", package = "geoplumber")
      plumber::include_html(fname, res)
    })
  }
  # run front
  # TODO: specify front port
  if(front) {
    gp_plumb_front()
  }
  # run plumb
  if(run) {
    openURL(host, port)
    if(background) {
      f <- function(s, p, h) {s$setDocs(FALSE); s$run(port = p, host = h)}
      ps <- callr::r_bg(f, list(s = server, p = port, h = host))
      return(ps)
    }
    server$run(port = port, host = host)
  } else {
    return(server)
  }
}
