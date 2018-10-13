context("data provided")

test_that("traffic exists", {
  # just check traffic exists
  expect_equal(!is.null(traffic), TRUE)
  # expect_equal(length(traffic), length(readLines(system.file("extdata/traffic.json", package = "geoplumber"))))
})

test_that("traffic_network exists", {
  # just check traffic_network exists
  expect_equal(!is.null(traffic_network), TRUE)
})
