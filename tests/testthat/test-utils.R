context("test-utils")


test_that("change_to_proj_dir needs a dir", {
  expect_error(change_to_proj_dir())
})

test_that("!gp_is_wd_geoplumber", {
  expect_equal(gp_is_wd_geoplumber(), FALSE)
})

test_that("gp_install_npm_package fails on empty", {
  expect_error(gp_install_npm_package())
})

test_that("gp_install_npm_package fails on no package.json", {
  expect_message(gp_install_npm_package("testpackage"))
})

test_that("prints npm install instructions", {
  out <- gp_install_node_instructions()
  expect_equal(any(grepl(pattern = "NodeJS", out)), TRUE)
})

test_that("add_lines adds line at correct location", {
  v <- readLines(system.file("js/src/App.js", package = "geoplumber"))
  # </main> is at 25
  v <- add_lines(v, "</main>", "<DummyComp />")
  # <DummyComp /> should be at 25
  dummy <- grep(pattern = "<DummyComp />", v)
  main <- grep(pattern = "</main>", v)
  expect_equal(dummy, main - 1)
})

test_that("add_import_component adds one line", {
  v <- readLines(system.file("js/src/App.js", package = "geoplumber"))
  v.length <- length(v)
  v <- add_import_component(v, "<DummyComp>", "")
  expect_equal(v.length + 1, length(v))
})

test_that("gp_change_file adds one line", {
  v <- readLines(system.file("js/src/App.js", package = "geoplumber"))
  v.length <- length(v)
  index.main <- grep("</main>", v)
  temp.file <- "temp.js"
  write(v, temp.file)
  on.exit(file.remove(temp.file))
  v <- gp_change_file(temp.file, what = "# dummy __comment__ line",
                      pattern = "</main>")
  v <- readLines(temp.file)
  index <- grep("# dummy __comment__ line", v)
  expect_equal(index.main, index) # added before
  expect_equal(v.length + 1, length(v)) # ony one line added
  file.remove(temp.file)
})
