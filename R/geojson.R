#' Explore a geojson object from a remote URL on a map.
#'
#'
#' @param geojson_url URL or path to read geojson from
#' @param colour_pal the value to use when colouring each feature
#'
#' @examples \dontrun{
#' gp_geojson(paste0("http://opendata.canterburymaps.govt.nz/datasets/",
#' "fb00b553120b4f2fac49aa76bc8d82aa_26.geojson"))
#' }
#' @export
gp_geojson <- function(geojson_url, colour_pal = "") {
  stop_ifnot_geoplumber()
  if(missing(geojson_url))
    stop("gp_geojson needs a geojson_url to pull .geojson from.")
  endpoint <- "/api/gp"
  component_name <- "GeoJSONComponent"
  component_path <- paste0("components/", component_name, ".jsx")
  parent <- readLines(system.file(paste0("js/src/Welcome.js"), package = "geoplumber"))
  parent <- add_import_component(parent, component_name, component_path)

  colour_function <-  ""
  if(exists("colour_pal") && length(colour_pal) == 1L &&
     !is.na(colour_pal) && colour_pal != "") {
    colour_function <-
      paste0('style={(feature) => ({fillColor:feature.properties.',
             colour_pal,
             '})}')
  } else {
    message("colour_pal should be column name, colouring ignored.")
  }
  parent <- add_lines(
    parent,           # target
    "map: null",      # pattern
    c(paste0("label: 'gp_geojson: ", geojson_url,"',"))
  )
  parent <- add_lines(
    parent,           # target
    "</Map>",         # pattern
    c(                # what
      paste0('<', component_name),
      'map={this.state.map}',
      paste0('fetchURL={"http://localhost:8000',
             endpoint,'"}'),
      # get color from pallete if given
      colour_function,
      '/>'
    )
  )

  # prep the data from geojson_url
  geojson <- geojsonsf::geojson_sf(geojson_url)
  geojson <- geojsonsf::sf_geojson(geojson)
  # add it to the endpoint
  server <- gp_plumb(run = FALSE)
  server$handle("GET", endpoint, function(res){
    res$headers$`Content-type` <- "application/json"
    res$body <- geojson
    res
  })

  # finally write before building
  write(parent, "src/Welcome.js")
  # build & serve
  if(!identical(Sys.getenv("DO_NOT_PLUMB"), "false")) {
    gp_build()
    message("Serving data on at ", "http://localhost:8000/api/gp")
    server$run(port = 8000)
  } else {
    return(TRUE)
  }
}

#' Export geojson object on a map.
#'
#'
#' @param geojson_url character: URL or path to read geojson from
#' @param browse_map logical: should the outcome be viewed in a browser?
#' defaults to `TRUE`
#'
#' @examples \dontrun{
#' gp_map(paste0("http://opendata.canterburymaps.govt.nz/datasets/",
#' "fb00b553120b4f2fac49aa76bc8d82aa_26.geojson"), browse_map = FALSE)
#' }
#' @export
gp_map <- function(geojson_url, browse_map = TRUE) {
  if(missing(geojson_url))
    stop("gp_map needs a geojson_url to pull data from.")
  result <- readLines(system.file("geoplumber.html", package = "geoplumber"))
  geojson <- "null"
  # superficial test
  if(!endsWith(geojson_url, ".geojson"))
    stop("Is given geojson_url a json or geojson file?")
  geojson <- geojsonsf::geojson_sf(geojson_url)
  if(!nrow(geojson) > 0)
    stop("Invalid geojson_url given or file is corrupt.")
  geojson <- geojsonsf::sf_geojson(geojson)
  path <- file.path(tempdir(),
                    paste0("gp_", basename(geojson_url), ".html"))
  result <- add_lines(
    result,                  # target
    "const geojson = null;", # pattern
    paste0(                       # what
      "const geojson = ",
      geojson, collapse = ""
    )
  )
  index <- grep(pattern = "const geojson = null;", x = result)
  result <- c(
    result[1L:(index - 1L)], # to line before pattern
    result[(index + 1L):length(result)]
  )
  write(result, path)
  if(browse_map) {
    utils::browseURL(path)
  } else {
    return (path)
  }
}
