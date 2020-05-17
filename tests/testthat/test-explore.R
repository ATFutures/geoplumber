test_that("import added", {
  gp <- tolower(tempdir())
  # dir.create(gp) less covr if used
  expect_message(gp_create(gp))
  proj_dir <- read_tempfile()
  od <- setwd(proj_dir)
  # check import in ther
  gp_explore(run = FALSE)
  cont <- readLines("src/App.js")
  expect_true(any(grepl("Eatlas", cont)))
  expect_true(any(grepl("eatlas", cont)))
  expect_true(any(grepl("<Route", cont)))
  expect_true(any(grepl("defaultURL=", cont)))
  # run = TRUE
  gp_explore(build = TRUE)
  teardown({
    gp_erase() # should do it
    setwd(od)
    gp_kill_process
  })
})

