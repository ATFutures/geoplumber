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
