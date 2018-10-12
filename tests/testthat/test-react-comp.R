context("test-gp-react-comp")
library(R6)
test_that("gp_react_comp works", {
  r <- gp_react_comp()
  expect_equal(identical(r$name,"R"), TRUE)
})
