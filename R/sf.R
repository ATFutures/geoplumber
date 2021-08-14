#' Explore an sf R object on a leaflet map.
#'
#' The function (for now) takes one parameter to bounce back
#' to the backend. For now just a dropdown list.
#' The slider only works with circles.
#'
#' @param sf a valid sf object that can be converted to geojson
#' @param props_list one named list of menuitmes to explore sf object with.
#'
#' @examples \dontrun{
#' gp_sf()
#' }
#' @export
gp_sf <- function(sf = geoplumber::traffic,
                  props_list = list(road = geoplumber::traffic$road)) {
  # no more than one param for now
  if(length(props_list) > 1)
    stop("gp_sf is young, can only take one variable. WIP.")
  # print(list)
  # gp_plumb checks project availability
  server <- gp_plumb(run = FALSE)
  # convert sf to geojson
  # TODO stop if not valid sf or geojsonsf cannot deal with it.
  # TODO try catch?
  geojson <- geojsonsf::sf_geojson(sf, factors_as_string=FALSE)

  # prepare backend
  # TODO: reserve api url for this or generate temp one.
  endpoint <- "/api/gp"
  # variable name here "road" must be used in the React component.
  # flexible variable names
  server$handle("GET", endpoint, function(res, req, ...){
    qs <- c(...) # named vector
    res$headers$`Content-type` <- "application/json"
    if(length(props_list) == 1 && length(names(qs)) == 1){
      # names(props_list) == names(qs)
      # qs[[names(qs)]] == "some value" if length is 1 of course
      geojson <- geojsonsf::sf_geojson(sf[sf[[names(props_list)]] == qs[[names(qs)]], ],
                                       factors_as_string=FALSE)
    }
    res$body <- geojson
    res
  })
  # prepare frontend
  # must be done on clean Home.js
  # 1. add a GeoJSONComponent
  # 2. dropdown menu items
  parent <- readLines(system.file(paste0("js/src/Home.js"), package = "geoplumber"))
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
      'radius={this.state.sliderInput}', # connecting GeoJSON with slider
      'map={this.state.map}',            # get the map from parent
      paste0('fetchURL={"http://localhost:8000', endpoint,'" +'), #
      '    (this.state.sfParam ?',
      '       //encode the spaces.',
      '     "?road=" + this.state.sfParam.split(" ").join("%20") : "")}',
      '/>'
    )
  )

  # only if we have a property list to filter the data from client
  if(length(props_list) == 1) {
    menuitems.index <- grep("menuitems=", parent) # TODO: HARDcoded.
    menuitems.line <- paste0("menuitems={[", # TODO: HARDcoded.
                             # using " quotes means we can avoid apostrophe wreck
                             paste(paste0('"', unique(sf[[names(props_list)]]), '"'), collapse = ", ")
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
  }
  # finally write before building
  write(parent, "src/Home.js")
  # build & serve
  if(!identical(Sys.getenv("DO_NOT_PLUMB"), "false")) {
    # TODO: gp_build is not made for this or refactor it.
    gp_build()
    openURL()
    # TODO: is it free?
    # is_port_engated(port = 8000)
    # attempt starting backend in any case
    message("Serving data on at ", "http://localhost:8000/api/gp")
    server$run(port = 8000)
  } else {
    return(TRUE)
  }
}


