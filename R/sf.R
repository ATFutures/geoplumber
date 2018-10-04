#' Explore an sf R object on a leaflet map.
#'
#' The function (for now) takes one parameter to bounce back
#' to the backend. For now just a dropdown list.
#'
#' @param sf a valid sf object that can be converted to geojson
#' @param a_list one named list of menuitmes to explore sf object with.
#'
#' @examples \dontrun{
#' gp_sf()
#' }
#' @export
gp_sf <- function(sf = geoplumber::traffic,
                  a_list = list(road = geoplumber::traffic$road)) {
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
  # dropdown menu items
  welcome <- readLines(system.file(paste0("js/src/Welcome.js"), package = "geoplumber"))
  # add the component.
  # import first
  # check for duplicate
  component.name <- "RBDropdownComponent"
  component.name.added <- grepl(paste0("import ", component.name), welcome)
  export.index <- grep("export default", welcome)
  component.path <- paste0("components/", component.name, ".jsx")
  if(!any(component.name.added)) {
    welcome <- c(welcome[1:export.index - 1],
                 # import GeoJSONComponent from '/components/GeoJSONComponent.jsx';
                 paste0("import ", component.name, " from './", component.path, "';"),
                 welcome[export.index:length(welcome)]
    )
  }
  # add content
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
  # finally write before buildingı
  write(welcome, "src/Welcome.js")
  # build & serve
  if(!identical(Sys.getenv("DO_NOT_PLUMB"), "false")) {

    gp_build()
    message("Serving data on at ", "http://localhost:8000", "/api/gp")
    server$run(port = 8000)
  } else {
    return(TRUE)
  }
}
