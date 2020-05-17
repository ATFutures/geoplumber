#' Explore an sf R object using Turing eAtlas.
#'
#'
#' @param sf a valid sf object that can be converted to geojson
#' @param build if `TRUE` build the front-end.
#' @param run if `TRUE` run geoplumber
#'
#' @examples \dontrun{
#' gp_explore()
#' }
#' @export
gp_explore <- function(sf = geoplumber::traffic,
                       build = FALSE,
                       run = TRUE) {
  # gp_plumb checks project availability
  server <- gp_plumb(run = FALSE)
  # convert sf to geojson
  # TODO stop if not valid sf or geojsonsf cannot deal with it.
  # TODO try catch?
  geojson <- geojsonsf::sf_geojson(sf, factors_as_string=FALSE)

  # prepare backend
  # TODO: reserve api url for this or generate temp one.
  endpoint <- "/api/explore"
  # variable name here "road" must be used in the React component.
  # flexible variable names
  server$handle("GET", endpoint, function(res, req, ...){
    qs <- c(...) # named vector
    res$headers$`Content-type` <- "application/json"
    res$body <- geojson
    res
  })
  # prepare frontend
  # must be done on clean Welcome.js
  # 1. import eAtlas/kepler
  # 2. install it
  # 3. add to file
  parent <- readLines(system.file(paste0("js/src/App.js"), package = "geoplumber"))
  # import first
  # TODO: cannot use such magical strings in code.
  component.name <- "Eatlas"
  parent <- add_import_component(parent,
                                 component.name,
                                 tolower(component.name),
                                 keyword="class App",
                                 package = TRUE)
  # add component
  parent <- add_lines(
    parent,   # target
    "<Route", # pattern
    c(        # what
      # <Route exact path="/" component={
      paste0('<Route exact path="/explore" component={'),
      # () => <Eatlas defaultURL="http://localhost:8000/api/explore"/>
      paste0('() => <Eatlas defaultURL="http://localhost:8000', endpoint,'"/>'),
      '}/>'
    )
  )
  # finally write before building
  write(parent, "src/App.js")
  # build & serve
  if(run) {
    gp_install_npm_package(tolower(component.name))
    if(build) {
      # TODO: gp_build is not made for this or refactor it.
      gp_build()
    } else {
      gp_plumb_front()
    }
    # TODO: is it free?
    # is_port_engated(port = 8000)
    # attempt starting backend in any case
    message("Serving data on at ", "http://localhost:8000/api/gp")
    f <- function(s, p) s$run(port = p)
    ps <- callr::r_bg(f, list(s = server, p = 8000))
    openURL(path = "explore")
    return(ps)
  }
}

