#' Traffic data from CDRC data sets
#'
#' See [data.cdrc.ac.uk/dataset/southwark-traffic-counts](https://data.cdrc.ac.uk/dataset/southwark-traffic-counts)
#' This dataset represents point locations where traffic
#' is measured.
#'
#' @examples
#' \dontrun{
#' # dataset was stored as follows (from CDRC):
#' u = paste0("https://data.cdrc.ac.uk/dataset/",
#'   "c90eee49-6f92-4508-ac36-6df56853f817/resource/",
#'   "d39d9d89-0478-4f75-a166-1a445bf42f9c/download/metadata.json")
#' download.file(u, "inst/extdata/traffic.geojson")
#' traffic <- sf::read_sf("inst/extdata/traffic.geojson")
#' # sf:::plot.sf(traffic)
#' # mapview::mapview(traffic)
#' usethis::use_data(traffic, overwrite = TRUE)
#' }
"traffic"

#' Traffic data from CDRC data sets
#'
#' See [data.cdrc.ac.uk/dataset/southwark-traffic-counts](https://data.cdrc.ac.uk/dataset/southwark-traffic-counts)
#' This dataset represents travel levels at the point locations stored in
#' `traffic`
#'
#' @examples
#' \dontrun{
#' f = "/tmp/2010-2016-allaveragedailytrafficflowcdrcmapreducedfile.xlsx"
#' traffic_volumes = readxl::read_excel(f)
#' summary(traffic_volumes$ID %in% traffic$cp)
#' pryr::object_size(traffic_volumes)
#' usethis::use_data(traffic_volumes)
#' library(dplyr)
#' traffic_agg = traffic_volumes %>%
#'   group_by(cp = ID) %>%
#'   summarise(
#'     total = sum(`TOTAL FLOW`),
#'     cycle_or_motorcycle = sum(`ARX PEDAL-MOTORCYCLE`),
#'     av_speed = mean(AVERAGE_SPEED),
#'     year = mean(YEAR)
#'     )
#' if(ncol(traffic) < 8) {
#'   traffic = left_join(traffic, traffic_agg)
#'   usethis::use_data(traffic, overwrite = TRUE)
#' }
#' mapview::mapview(traffic, zcol = "total")
#' sf:::plot.sf(traffic)
#' }
#' summary(traffic_volumes)
#' plot(traffic$total, traffic$cycle_or_motorcycle)
"traffic_volumes"

#' Road traffic casualties
#'
#' From OpenStreetMap
#'
#' @examples
#' \dontrun{
#' stplanr::dl_stats19()
#' ac = stplanr::read_stats19_ac() # 214 mb compressed data
#' ac = ac[!is.na(ac$Latitude), ]
#' ac_few_cols = ac[ c("Accident_Severity", "Longitude", "Latitude", "Date")]
#' ac_sf = sf::st_as_sf(ac_few_cols, coords = c("Longitude", "Latitude"))
#' sf::st_crs(ac_sf) = 4326
#' bb = stplanr::bb2poly(bb = sf::as_Spatial(traffic))
#' bb_sf = sf::st_as_sf(bb)
#' traffic_casualties = ac_sf[bb_sf, ]
#' pryr::object_size(traffic_casualties) # 2 MB
#' traffic_casualties_2014 = traffic_casualties[
#'   traffic_casualties$Date > "2014-01-01",
#' ]
#' pryr::object_size(traffic_casualties_2014) # 200 kB
#' usethis::use_data(traffic_casualties_2014)
#' }
#' plot(traffic_casualties_2014$Date, traffic_casualties_2014$Accident_Severity)
"traffic_casualties_2014"

#' sf object representing the university of Leeds
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
