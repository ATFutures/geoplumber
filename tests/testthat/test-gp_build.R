context("test-gp_build")

testthat::skip_on_cran()

test_that("gp_build errs for non geoplumber path", {
  expect_error(gp_build())
})

test_that("full create", {
              expect_message (gp_create ("junk"))
              proj_dir <- read_tempfile ()
              expect_true (file.exists (proj_dir))
              js_file <- file.path (proj_dir, "package.json")
              expect_true (file.exists (js_file))
})

# test before build test
test_that("gp_plumb can serve API only", {
  expect_message(gp_plumb(run = FALSE, file = "R/plumber.R"))
})

test_that ("full build", {
              expect_message (gp_build ())
              build_dir <- file.path (read_tempfile(), "build")
              expect_true (file.exists (build_dir))
})

test_that ("default endpoints", {
  r <- gp_plumb(run = FALSE, file = "R/plumber.R")
  expect_equal(length(r$endpoints[[1]]), 4)
  expect_equal(r$endpoints[[1]][[1]]$exec(), list(msg="The message is: 'nothing given'"))
})

test_that ("full plumb", {
  # LH: last test is the only way, we dont need to check port availability etc.
  #gp_plumb() # MP: dunno how to test this?
})

test_that ("full erase", {
  expect_silent (gp_erase ())
})

test_that("gp_plumb errs for non geoplumber path", {
  expect_error(gp_plumb())
})
