context("test-gp-react-comp")
library(R6)
test_that("gp_react_comp works", {
  r <- gp_react_comp()
  expect_equal(identical(r$name,"R"), TRUE)
  expect_gt(length(r$out), 6)
  expect_true(identical(r$print(), r))
  expect_gte(length(r$constructor()), 3)
})
