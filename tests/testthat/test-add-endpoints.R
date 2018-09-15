context("test-gp_endpoint_from_clip")
if(clipr::clipr_available()) {
  test_that("gp_endpoint_from_clip fails on empty clip", {
    clip <- clipr::read_clip()
    clipr::clear_clip()
    expect_error(gp_endpoint_from_clip())
    clipr::write_clip(clip)
  })
}
# test_that("gp_endpoint_from_clip works", {
  # gp_create() # to create a new app and change dir into it.
  # above would be too slow just simulate
  # project_name <- "geoplumber-test"
  # system(paste0("mkdir ", project_name, "/R -p"))
  # system(paste0("cd ", project_name))
  # system(paste0("cp ", system.file("plumber.R", package = "geoplumber"), " R"))
  # before <- length(readLines("R/plumber.R"))
  # clipr::write_clip(c(
  #   "# comment for a new endpoint",
  #   "@get /api/test",
  #   "function(){",
  #   "  cat('test')",
  #   "}"
  # ), breaks = "\n")
  # read from clip
  # write to plumber.R file
  # we add two line \n # endpoint -----
  # added <- length(clipr::read_clip()) + 2
  # after <- length(readLines("R/plumber.R"))
  # compare before after
  # expect_equal(before + added, after)
# })
