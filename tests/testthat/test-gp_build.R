context("test-gp_build")

test_that("build fails for non geoplumber path", {
  # expect_message takes character vector.
  expect_message(gp_build(), "Geoplumber failed to identify a package.json in working directory: ",
                 getwd(), "\nRun gp_create() to create a geoplumber app.")
})
