context("test-gp_endpoint_from_clip")

if(clipr::clipr_available()) {
  test_that("gp_endpoint_from_clip fails on empty clip", {
    clip <- clipr::read_clip()
    clipr::clear_clip()
    expect_error(gp_endpoint_from_clip())
    clipr::write_clip(clip)
  })
}

test_that("gp_endpoint_from_clip works", {
  temp.dir <- tolower(tempdir())
  # gp_create(temp.dir) # to create a new app and change dir into it.
  # above would be too slow just simulate
  system(paste0("mkdir -p ", temp.dir, "/R")) # no harm in -p
  system(paste0("cd ", temp.dir))
  old_wd <- setwd(temp.dir)
  system(paste0("cp ", system.file("plumber.R", package = "geoplumber"), " R"))
  endpoint <- c(
    "#' comment for a new endpoint",
    "#' @get /api/test",
    "function(){",
    "  cat('test')",
    "}"
  )
  m <- "Success.\nPlease restart your server: gp_plumb()"
  if(clipr::clipr_available()) {
    old_clip <- clipr::read_clip()
    clipr::write_clip(endpoint, breaks = "\n")

    expect_message(gp_endpoint_from_clip(), m)
    expect_error(gp_endpoint_from_clip(evaluate = TRUE), NA)
    clipr::write_clip(old_clip)
  }
  # reset
  setwd(old_wd)
  unlink (temp.dir, recursive = TRUE)
})
