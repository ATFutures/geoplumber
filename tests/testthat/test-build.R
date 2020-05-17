context("test-gp_build")
# all tests run from clean package env

skip_build <- function() {
  # set GP_LOCAL_INCLUDE_BUILD in ~/.Renviron as
  # GP_LOCAL_INCLUDE_BUILD = false for skipping test.
  if(identical(Sys.getenv("GP_LOCAL_INCLUDE_BUILD"), "false"))
    skip("Not running full test.")
}

testthat::skip_on_cran()
#' Few different tests are included in this file.
#' The reason is gp_create takes a while and it is best to do all the tests in the same repo.
#' The alternative is to move gp_erase or unlink commands into the last running test.
#' for `now` perhaps a big test file would cause no damage.

test_that("gp_build errs for non geoplumber path", {
  # runs from a clean env so gp_is_wd_geoplumber == FALSE
  expect_error(gp_build())
})

test_that("full create", {
  # tolower is used to respect CRA rules.
  gp <- tolower(tempdir())
  expect_error(gp_rstudio())
  expect_error(gp_rstudio("NOT_GP_DIR"))
  f <- file.path(gp, "test.txt")
  dir.create(gp) # must create in test before file.create
  file.create(f)
  expect_error(gp_create (gp))
  unlink(gp, recursive = TRUE) # so that gp_create does it
  # create full
  # dir.create(gp) less covr if used
  expect_message(gp_create (gp))
  proj_dir <- read_tempfile ()
  expect_true(file.exists (proj_dir))
  js_file <- file.path (proj_dir, "package.json")
  expect_true(file.exists (js_file))
  old <- setwd(proj_dir) # we are in the new app dir
  expect_false(rproj_file_exists(""))
  expect_true(gp_is_wd_geoplumber())
  gp_rstudio()
  expect_error(gp_rstudio(""))
  expect_error(gp_rstudio(c(NA,NA)))
  # expect_true(rproj_file_exists())
  teardown(unlink(gp, recursive = TRUE))
  teardown(setwd(old))
  # rproj before create
  tmp <- file.path(tolower(tempdir()), "my_app")
  dir.create(tmp)
  file.create(file.path(tmp, "my_app.Rproj"))
  expect_error(gp_create (tmp))
  teardown(unlink(tmp, recursive = TRUE))
})

# test before build test
test_that("gp_plumb can serve API only", {
  # needs to skip as gp_is_wd_geoplumber == FALSE
  # skip_build()
  expect_message(gp_plumb(run = FALSE, file = "R/plumber.R"))
  r <- gp_plumb(run = FALSE, file = "R/plumber.R")
  expect_equal(length(r$endpoints[[1]]), 5) # added extra endpoint
  # print(gp_is_wd_geoplumber())
  ps <- gp_plumb()
  expect_true(inherits(ps, "r_process"))
  # require(RCurl)
  # webpage <- getURL("http://localhost:8000")
  # webpage <- readLines(tc <- textConnection(webpage)); close(tc)
  # print(tail(webpage))
  ps$kill()
  on.exit(tryCatch(ps$kill, error = function(e) NULL), add = TRUE)
})

test_that ("full build", {
  skip_build()
  expect_message (gp_build ())
  build_dir <- file.path (read_tempfile(), "build")
  expect_true(file.exists (build_dir))
})

test_that("npm start works", {
  skip_build()
  setup({
    gp_kill_process() # no harm
  })
  expect_false(is_port_engated())
  expect_message(gp_plumb_front())
  expect_message(gp_clean())
  teardown(
    gp_kill_process()
  )
})

test_that ("default endpoints", {
  skip_build()
  r <- gp_plumb(run = FALSE, file = "R/plumber.R",
                front = TRUE)
  expect_equal(length(r$endpoints[[1]]), 4)
  expect_equal(r$endpoints[[1]][[1]]$exec(),
               list(msg="The message is: 'nothing given'"))
})

context("test-gp_sf")

test_that ("gp_sf can serve default sf object", {
  Sys.setenv(DO_NOT_PLUMB = 'false')
  on.exit(Sys.unsetenv("DO_NOT_PLUMB"))
  expect_equal(gp_sf(), TRUE)
  Sys.unsetenv("DO_NOT_PLUMB")
})

context("test-gp_erase")

test_that ("full erase", {
  skip_build()
  expect_message (gp_erase ())
})
