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
#'
#' @export
#' @examples \dontrun{
#' gp_add_geojson()
#' # Error in gp_add_geojson() : Is current dir a geoplumber app?
#' # Try geoplumber::gp_create()
#' }
#'
gp_add_geojson <- function(endpoint = "/api/data"){
  # Check getwd() for src/ folder & Welcome.js file exists as both will be written to.
  check_src <- dir.exists("src")
  check_welcome <- file.exists("src/Welcome.js")
  if(!check_src || !check_welcome) {
    is.current.dir <- "Is current dir a geoplumber app? \nTry geoplumber::gp_create() first.\n"
    stop(is.current.dir)
    # no point going any further
  }
  # Read the template
  component.name <- "GeoJSONComponent"
  component.path <- paste0("components/", component.name, ".jsx")
  component <- system.file(paste0("js/src/", component.path), package = "geoplumber")
  component <- readLines(component)
  # hold on writing file
  # Add component to Welcome.js
  welcome <- readLines("src/Welcome.js")
  # read welcome compoennt, if not, stop
  if(length(welcome) < 10) { # TODO: much better check than this
    stop("geoplumber could not insert component into Welcome.js")
  }
  # Import new component
  # Above 'export default'
  export.index <- grep("export default", welcome)
  # check for duplicate
  component.name.added <- grepl(paste0("import ", component.name), welcome)
  if(!any(component.name.added)) {
    welcome <- c(welcome[1:export.index - 1],
                 # import GeoJSONComponent from '/components/GeoJSONComponent.jsx';
                 paste0("import ", component.name, " from './", component.path, "';"),
                 welcome[export.index:length(welcome)]
    )
  }
  # find end map component tag
  map.end.index <- grep(pattern = "</Map>", x = welcome)
  # TODO: more checks as file could be corrupt
  # insert line
  # TODO: insert at right tab count :)
  welcome <- c(welcome[1:map.end.index - 1],
               paste0("<", component.name, " fetchURL=",
                      paste0("'http://localhost:8000", endpoint, "'"),
                      " map={map} />"), #TODO: HARDcoded.
               welcome[map.end.index:length(welcome)]
               )
  # now write to project
  write(component, file = paste0("src/", component.path))
  write(welcome, "src/Welcome.js")
  message("Remember to rebuild frontend: gp_build()")
  message("Success. ")
}
