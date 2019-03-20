context("test-map")

test_that("gp_map works", {
  url = "https://docs.mapbox.com/help/data/stations.geojson"
  path = file.path(tempdir(), basename(url))
  result <- gp_map(geojson_url = url, browse_map = FALSE)
  found <- grepl(pattern = "const geojson = null;",
                 x = result)
  expect_false(found)
})
