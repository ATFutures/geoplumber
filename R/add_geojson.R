#' For now, views a geojson served from an endpoint on leafletjs.
#'
#' Assumes there is a valid geoplumber app at wd
#' TODO: work with valid paths too
#' TODO: either here, or separate function, add my own component.
#' 1. Add a component with ability to fetch geojson from an endpoint to /components
#' 2. Import it into the App.js (TODO: into any other component)
#' Errors: stop execution if either React 'src' folder or for now "Welcome.js" component
#' does not exist. This is because for now we are adding the ready to use GeoJSONComponent component
#' into src/Welcome.js
#'
#' @param endpoint where to fetch the geojson from
#' @param color for now color value for all geojson
#' @param line_weight worded carefully for leaflet geojson lineweight.
#' @param properties logical, by default `FALSE`. If TRUE `color` and `line_weight` will
#' be obtained from properties/columns from corresponding data served via `endpoint`
#'
#' @export
#' @examples \dontrun{
#' if(gp_is_wd_geoplumber()) {
#'  gp_add_geojson()
#' }
#' }
#'
gp_add_geojson <- function(endpoint = "/api/data",
                           color = "#3388ff",
                           line_weight = NA,
                           properties = FALSE){
  check_welcome <- file.exists("src/Welcome.js")
  if(!check_welcome) {
    stop("Is current dir a geoplumber app?
         \nTry geoplumber::gp_create() first.")
    # no point going any further
  }
  # Read the template
  component.name <- "GeoJSONComponent"
  component.path <- paste0("components/", component.name, ".jsx")
  component <- system.file(paste0("js/src/", component.path), package = "geoplumber")
  component <- readLines(component)
  # Add component to Welcome.js
  welcome <- readLines("src/Welcome.js")
  # read welcome compoennt, if not, stop
  if(length(welcome) < 10) { # TODO: much better check than this
    stop("geoplumber could not insert component into Welcome.js")
  }
  # import component
  welcome <- add_import_component(welcome, component.name, component.path)

  # find end map component tag
  map.end.index <- grep(pattern = "</Map>", x = welcome)
  # TODO: more checks as file could be corrupt
  style <- paste0("{color:'", color, "'")
  if(!is.na(line_weight)){
    style <- paste0(style, ", ",
               "weight:'", line_weight, "'}"
               )
  } else {
    style <- paste0(style, "}")
  }
  style <- paste0(" style={", style, "}")
  if(properties) {
    if(!is.na(line_weight) &
       !startsWith(color, "#") & # in case deafult is left int
       is.character(color)) {
      # get the values from gejoson features
      # style is a function
      style <- paste0(" style={(feature) => ({color: feature.", color, ",",
                    "line_weight: feature.", line_weight,"})}")
    } else {
      stop("Please provide correct parameters to add a GeoJSON component.")
    }
  }
  # insert line
  welcome <- c(welcome[1:map.end.index - 1],
               # add two spaces
               paste0(next_spaces(welcome[map.end.index]),
                      "<", component.name,
                      style,
                      " fetchURL='http://localhost:8000", endpoint, "'",
                      " map={ this.state.map } />"), #TODO: HARDcoded url port etc.
               welcome[map.end.index:length(welcome)]
               )
  # now write to project
  write(component, file = paste0("src/", component.path))
  write(welcome, "src/Welcome.js")
  message("Remember to rebuild frontend: gp_build()")
  message("Success. ")
}
