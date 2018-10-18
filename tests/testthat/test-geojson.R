context("test-geojson")

test_that("geojson fails on no geoplumber app path", {
  expect_error(gp_geojson("/dev/null"))
})

test_that("geojson works on a geoplumber app path", {
  # wd = /tests/testthat
  temp.dir <- tolower(tempdir())
  # cat(temp.dir)
  system(paste0("mkdir ", temp.dir))
  oldwd <- setwd(temp.dir)
  system(paste0("mkdir ", "R")) # simulate an app
  on.exit(oldwd)
  system(paste0("cp -R ", system.file("js", package = "geoplumber"), "/* ."))
  system(paste0("cp ", system.file("plumber.R", package = "geoplumber"), " R"))
  cat("\n.......\n", "Mocking a geoplumber app\n", list.files(), "\n......\n")

  Sys.setenv(DO_NOT_PLUMB = 'false')
  # run tests
  expect_equal(gp_geojson("http://opendata.canterburymaps.govt.nz/datasets/fb00b553120b4f2fac49aa76bc8d82aa_26.geojson"), TRUE)
  Sys.unsetenv("DO_NOT_PLUMB")
  setwd(oldwd)
  unlink (temp.dir, recursive = TRUE)
})
