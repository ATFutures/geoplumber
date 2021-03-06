#' Explore a geojson object from a remote URL on a map.
#'
#'
#' @param geojson_url URL or path to read geojson from
#' @param colour_pal the value to use when colouring each feature
#' @param build whether to build React front-end, defaults to `TRUE`.
#'
#' @examples \dontrun{
#' gp_geojson(paste0("http://opendata.canterburymaps.govt.nz/datasets/",
#' "fb00b553120b4f2fac49aa76bc8d82aa_26.geojson"))
#' }
#' @export
gp_geojson <- function(geojson_url,
                       colour_pal = "",
                       build = TRUE) {
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
    if(build) gp_build()
    message("Serving data on at ", "http://localhost:8000/api/gp")
    openURL()
    # blocking by design
    server$run(port = 8000)
  } else {
    return(TRUE)
  }
}

#' Export geojson object on a map.
#'
#'
#' @param x character or sf object: URL or sf object to view on map
#' @param browse_map logical: should the outcome be viewed in a browser?
#' defaults to `TRUE`
#' @param dest_path character: write output to `tempdir` (default).
#' @param height character: css compatible option for map height.
#' @param width character: css compatible option for map width.
#' @return path character of path that html file was written to.
#'
#' @examples \dontrun{
#' gp_map(paste0("http://opendata.canterburymaps.govt.nz/datasets/",
#' "fb00b553120b4f2fac49aa76bc8d82aa_26.geojson"), browse_map = FALSE)
#' }
#' @export
gp_map <- function(x,
                   browse_map = TRUE,
                   dest_path = tempdir(),
                   height = NULL,
                   width = NULL) {
  if(missing(x))
    stop("gp_map needs either a URL or sf object to pull data from.")
  gv <- "geojson: null // anchor"
  result <- readLines(system.file("geoplumber.html", package = "geoplumber"))
  geojson <- x
  geojson_name <- deparse(substitute(x)) # provisional
  prefix <- "gp_map_"
  # file or object?
  if(!inherits(x, "sf")) {
    # superficial test
    if(!endsWith(x, ".geojson"))
      stop("Is given x a json or geojson file?")
    geojson <- geojsonsf::geojson_sf(x)
    geojson_name <- basename(x)
  }
  if(!nrow(geojson) > 0)
    stop("Invalid object given or file is corrupt.")
  geojson <- geojsonsf::sf_geojson(geojson)
  # increment
  list <- list.files(dest_path, pattern = prefix)
  n <- length(list)
  path <- file.path(dest_path,
                    paste0(prefix, geojson_name, n,".html"))
  # add description
  result <- gsub("dataDescription: null",
                 paste0("dataDescription: '", geojson_name, "'"),
                 result)
  # replace placeholder
  result <- gsub(gv, paste0("geojson: ",geojson, collapse = ""), result)
  # edit map height and width
  if(!is.null(height)) {
    result <- gsub("height: 100vh", paste0("height: ", height), result)
  }
  if(!is.null(width)) {
    result <- gsub("width: 100%", paste0("width: ", width), result)
  }
  # finally
  write(result, path)
  if(browse_map) {
    utils::browseURL(path)
  } else {
    return (path)
  }
}
