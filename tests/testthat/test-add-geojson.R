context("test-gp_add_geojson")
test_that("gp_add_geojson fails on no geoplumber app path", {
  expect_error(gp_add_geojson("/dev/null"))
})

test_that("gp_add_geojson works on a geoplumber app path", {
  # create app at /tmp then delete
  # wd = /tests/testthat
  temp.dir <- tolower(tempdir())
  # cat(temp.dir)
  system(paste0("mkdir ", temp.dir))
  oldwd <- setwd(temp.dir)
  on.exit(oldwd)
  system(paste0("cp -R ", system.file("js", package = "geoplumber"), "/* ."))
  cat("\n.......\n", "Mocking a geoplumber app\n", list.files(), "\n......\n")
  # run tests here
  expect_message(gp_add_geojson(line_weight = 1), "Success. ")
  # end tests
  # clean up
  setwd(oldwd)
  unlink (temp.dir, recursive = TRUE)
})
