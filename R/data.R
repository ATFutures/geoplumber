#' Traffic data from CDRC data sets
#'
#' See [data.cdrc.ac.uk/dataset/southwark-traffic-counts](https://data.cdrc.ac.uk/dataset/southwark-traffic-counts)
#'
#' @examples
#' \dontrun{
#' # dataset was stored as follows (from CDRC):
#' u = paste0("https://data.cdrc.ac.uk/dataset/",
#'   "c90eee49-6f92-4508-ac36-6df56853f817/resource/",
#'   "d39d9d89-0478-4f75-a166-1a445bf42f9c/download/metadata.json")
#' download.file(u, "inst/extdata/traffic.geojson")
#' traffic <- sf::read_sf("inst/extdata/traffic.geojson")
#' sf:::plot.sf(traffic)
#' # mapview::mapview(traffic)
#' usethis::use_data(traffic, overwrite = TRUE)
#' }
"traffic"

#' Geographic data representing the university of Leeds
#'
#' From OpenStreetMap
#'
#' @aliases uni_poly
#' @examples
#' # library(osmdata)
#' # osm_list <- opq("leeds") %>%
#' #   add_osm_feature("name", "University of Leeds") %>%
#' #   osmdata_sf()
#' # uni_poly = osm_list$osm_polygons
#' # mapview::mapview(uni_poly)
#' # uni_point <- sf::st_centroid(osm_list$osm_polygons)
"uni_point"
