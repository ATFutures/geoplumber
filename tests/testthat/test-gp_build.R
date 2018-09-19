context("test-gp_build")

testthat::skip_on_cran()

test_that("full create", {
              expect_message (gp_create ("junk"))
              proj_dir <- read_tempfile ()
              expect_true (file.exists (proj_dir))
              js_file <- file.path (proj_dir, "package.json")
              expect_true (file.exists (js_file))
})

test_that ("full build", {
              expect_message (gp_build ())
              build_dir <- file.path (read_tempfile(), "build")
              expect_true (file.exists (build_dir))
})

test_that ("full plumb", {
               #gp_plumb() # MP: dunno how to test this?
})

test_that ("full erase", {
               expect_silent (gp_erase ())
})

test_that("build fails for non geoplumber path", {
  # expect_message takes character vector.
  #expect_message(gp_build(), "Geoplumber failed to identify a package.json in working directory: ",
  #               getwd(), "\nRun gp_create() to create a geoplumber app.")
})
