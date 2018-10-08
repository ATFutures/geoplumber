#' Explore an sf R object on a leaflet map.
#'
#' The function (for now) takes one parameter to bounce back
#' to the backend. For now just a dropdown list.
#' The slider only works with circles.
#'
#' @param sf a valid sf object that can be converted to geojson
#' @param props_list one named list of menuitmes to explore sf object with.
#' @param with_slider WIP example might be removed anytime.
#'
#' @examples \dontrun{
#' gp_sf()
#' }
#' @export
gp_sf <- function(sf = geoplumber::traffic,
                  props_list = list(road = geoplumber::traffic$road),
                  with_slider = FALSE) {
  # no more than one param for now
  if(length(props_list) != 1)
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
  # variable name here "road" must be used in the React component.
  # flexible variable names
  server$handle("GET", endpoint, function(res, req, ...){
    qs <- c(...) # named vector
    res$headers$`Content-type` <- "application/json"
    if(length(names(qs)) == 1){
      # names(props_list) == names(qs)
      # qs[[names(qs)]] == "some value" if length is 1 of course
      geojson <- geojsonsf::sf_geojson(sf[sf[[names(props_list)]] == qs[[names(qs)]], ])
    }
    res$body <- geojson
    res
  })
  # prepare frontend
  # must be done on clean Welcome.js
  # 1. add a GeoJSONComponent
  # 2. dropdown menu items
  parent <- readLines(system.file(paste0("js/src/Welcome.js"), package = "geoplumber"))
  # import first
  component.name <- "RBDropdownComponent"
  component.path <- paste0("components/", component.name, ".jsx")
  component2.name <- "GeoJSONComponent"
  component2.path <- paste0("components/", component2.name, ".jsx")
  parent <- add_import_component(parent, component.name, component.path)
  parent <- add_import_component(parent, component2.name, component2.path)
  # add component 1
  parent <- add_lines(
    parent,          # target
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
  parent <- add_lines(
    parent,
    "</Map>",         # pattern
    c(
      paste0('<', component2.name),
      'circle={true}',                   # connecting GeoJSON with slider
      # easy way would be spreading, for now doing it the harder way
      # '...this.state' # and all state would be passed to child.
      'radius={this.state.sliderInput}', # connecting GeoJSON with slider
      'map={this.state.map}',            # get the map from parent
      paste0('fetchURL={"http://localhost:8000', endpoint,'" +'), #
      '    (this.state.sfParam ?',
      '       //encode the spaces.',
      '     "?road=" + this.state.sfParam.split(" ").join("%20") : "")}',
      '/>'
    )
  )
  menuitems.index <- grep("menuitems=", parent) # TODO: HARDcoded.
  menuitems.line <- paste0("menuitems={[", # TODO: HARDcoded.
                           # using " quotes means we can avoid apostrophe wreck
                           paste(paste0('"', sf[[names(props_list)]], '"'), collapse = ", ")
                           , "]}")
  parent[menuitems.index] <- menuitems.line
  # change url based on the variable passed back to plumber
  param.index <- grep("?road=", parent) # TODO: HARDcoded.
  param.line <- parent[param.index]
  # skip sf's default values
  # replace road with appropriate name given from props_list
  if(!identical("road", names(props_list))) {
    param.line <- sub("road=", paste0(names(props_list), "="), param.line)
    parent[param.index] <- param.line
  }
  # we could pass min max from sf object
  # TODO: WIP and no package strategy.
  if(with_slider)
    parent <- gp_add_slider(to_vector = parent)
  # finally write before building
  write(parent, "src/Welcome.js")
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
