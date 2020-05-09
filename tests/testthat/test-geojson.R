context("test-geojson")

test_that("geojson fails on missing path", {
  expect_error(gp_geojson())
})

test_that("geojson fails on no geoplumber app path", {
  expect_error(gp_geojson("/dev/null"))
})

test_that("geojson works on a geoplumber app path", {
  # wd = /tests/testthat
  temp.dir <- file.path(tempdir(), "foo")
  dir.create(temp.dir, recursive = TRUE)
  oldwd <- setwd(temp.dir)
  on.exit(oldwd)
  cat("\n.......\n", "Mocking a geoplumber app\n", list.files(), "\n......\n")
  gp_create()
  expect_true(gp_is_wd_geoplumber())
  Sys.setenv(DO_NOT_PLUMB = 'false')
  # run tests
  geojson_url = paste0("http://opendata.canterburymaps.govt.nz/datasets/",
                       "fb00b553120b4f2fac49aa76bc8d82aa_26.geojson")
  expect_equal(gp_geojson(geojson_url = geojson_url, colour_pal = "mock"),
               TRUE)
  # we should now have a 'style={(feature) => ({fillColor:feature.properties.'
  # section in the Welcome.js
  expect_true(any(grepl("fillColor:feature.properties.",
                        readLines(file.path(
                          temp.dir, "src/Welcome.js"
                        )))))
  Sys.unsetenv("DO_NOT_PLUMB")
  setwd(oldwd)
  unlink (temp.dir, recursive = TRUE)
})
