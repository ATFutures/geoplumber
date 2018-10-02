context("test-gp_build")
# all tests run from clean package env

skip_build <- function() {
  # set RUN_FULL_TEST in ~/.Renviron as
  # RUN_FULL_TEST = true for full test.
  if(identical(Sys.getenv("RUN_FULL_TEST"), "false"))
    skip("Not running full test.")
}

testthat::skip_on_cran()

test_that("gp_build errs for non geoplumber path", {
  # runs from a clean env so gp_is_wd_geoplumber == FALSE
  expect_error(gp_build())
})

test_that("full create", {
  skip_build()
  expect_message (gp_create ("junk"))
  proj_dir <- read_tempfile ()
  expect_true (file.exists (proj_dir))
  js_file <- file.path (proj_dir, "package.json")
  expect_true (file.exists (js_file))
})

# test before build test
test_that("gp_plumb can serve API only", {
  # needs to skip as gp_is_wd_geoplumber == FALSE
  skip_build()
  expect_message(gp_plumb(run = FALSE, file = "R/plumber.R"))
  r <- gp_plumb(run = FALSE, file = "R/plumber.R")
  expect_equal(length(r$endpoints[[1]]), 5) # added extra endpoint
})

test_that ("full build", {
  skip_build()
  expect_message (gp_build ())
  build_dir <- file.path (read_tempfile(), "build")
  expect_true (file.exists (build_dir))
})

test_that ("default endpoints", {
  skip_build()
  r <- gp_plumb(run = FALSE, file = "R/plumber.R")
  expect_equal(length(r$endpoints[[1]]), 4)
  expect_equal(r$endpoints[[1]][[1]]$exec(), list(msg="The message is: 'nothing given'"))
})

test_that ("full plumb", {
  # LH: last test is the only way, we dont need to check port availability etc.
  #gp_plumb() # MP: dunno how to test this?
})

context("test-gp_sf")

test_that ("gp_sf can serve default sf object", {
  skip_build()
  expect_message (gp_build ())
  Sys.setenv(DO_NOT_PLUMB = 'false')
  on.exit(Sys.unsetenv("DO_NOT_PLUMB"))
  expect_equal(gp_sf(), TRUE)
  Sys.unsetenv("DO_NOT_PLUMB")
})

context("test-gp_erase")

test_that ("full erase", {
  skip_build()
  expect_silent (gp_erase ())
})
