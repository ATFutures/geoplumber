
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
