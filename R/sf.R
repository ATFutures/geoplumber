#' Explore an sf R object on a leaflet map.
#'
#' The function (for now) takes one parameter to bounce back
#' to the backend. For now just a dropdown list.
#'
#' @param sf a valid sf object that can be converted to geojson
#' @param a_list one named list of menuitmes to explore sf object with.
#' @param with_slider WIP example might be removed anytime.
#'
#' @examples \dontrun{
#' gp_sf()
#' }
#' @export
gp_sf <- function(sf = geoplumber::traffic,
                  a_list = list(road = geoplumber::traffic$road),
                  with_slider = FALSE) {
  # no more than one param for now
  if(length(a_list) != 1)
    stop("gp_sf is young, can only take one variable. WIP.")
  # print(list)
  # gp_plumb checks project availability
  server <- gp_plumb(run = FALSE)
  # convert sf to geojson
  # TODO stop if not valid sf or geojsonsf cannot deal with it.
  geojson <- geojsonsf::sf_geojson(sf)

  # prepare backend
  # TODO: reserve api url for this or generate temp one.
  endpoint <- "/api/gp"
  server$handle("GET", endpoint, function(res, road){
    res$headers$`Content-type` <- "application/json"
    if(!missing(road))
      geojson <- geojsonsf::sf_geojson(sf[sf[[names(a_list)]] == road, ])
    res$body <- geojson
    res
  })
  # prepare frontend
  # must be done on clean Welcome.js
  # 1. add a GeoJSONComponent
  # 2. dropdown menu items
  welcome <- readLines(system.file(paste0("js/src/Welcome.js"), package = "geoplumber"))
  # import first
  component.name <- "RBDropdownComponent"
  component.path <- paste0("components/", component.name, ".jsx")
  component2.name <- "GeoJSONComponent"
  component2.path <- paste0("components/", component2.name, ".jsx")
  welcome <- add_import_component(welcome, component.name, component.path)
  welcome <- add_import_component(welcome, component2.name, component2.path)
  # add component 1
  welcome <- add_lines(
    welcome,          # target
    "</Map>",         # pattern
    c(                # what
      paste0('<', component.name), # one line
      'position="topright"',
      'menuitems={[]}',
      'onSelectCallback={(sfParam) => this.setState({sfParam})}',
      '/>'
    )
  )
  # add component 2
  welcome <- add_lines(
    welcome,
    "</Map>",         # pattern
    c(
      paste0('<', component2.name),
      'circle={true}',                   # connecting GeoJSON with slider
      'radius={this.state.sliderInput}', # connecting GeoJSON with slider
      'map={this.state.map}',            # get the map from parent
      paste0('fetchURL={"http://localhost:8000', endpoint,'" +'), #
      '    (this.state.sfParam ?',
      '       //encode the spaces.',
      '     "?road=" + this.state.sfParam.split(" ").join("%20") : "")}',
      '/>'
    )
  )
  menuitems.index <- grep("menuitems=", welcome) # TODO: HARDcoded.
  menuitems.line <- paste0("menuitems={[", # TODO: HARDcoded.
                           # using " quotes means we can avoid apostrophe wreck
                           paste(paste0('"', sf[[names(a_list)]], '"'), collapse = ", ")
                           , "]}")
  welcome[menuitems.index] <- menuitems.line
  # change url based on the variable passed back to plumber
  param.index <- grep("?road=", welcome) # TODO: HARDcoded.
  param.line <- welcome[param.index]
  # skip sf default
  if(!identical("road", names(a_list))) {
    param.line <- sub("road=", paste0(names(a_list), "="), param.line)
    welcome[param.index] <- param.line
  }
  # we could pass min max from sf object
  # TODO: WIP and no package strategy.
  if(with_slider)
    welcome <- gp_add_slider(to_vector = welcome)
  # finally write before building
  write(welcome, "src/Welcome.js")
  # build & serve
  if(!identical(Sys.getenv("DO_NOT_PLUMB"), "false")) {
    # TODO: gp_build is not made for this or refactor it.
    gp_build()
    message("Serving data on at ", "http://localhost:8000", "/api/gp")
    server$run(port = 8000)
  } else {
    return(TRUE)
  }
}
