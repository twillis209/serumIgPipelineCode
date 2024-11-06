test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})
# Write a unit test of the meta-analysis function
test_that("effect estimates are updated for a single step", {
  # Create a data.table with a single row
  dat <- data.table::data.table(beta = 1, se = 0.1)
  # Add a study to the data.table
  add_study(dat, "study1")
  # Check that the effect estimate has been updated
  expect_equal(dat$beta, 1)
  # Check that the standard error has been updated
  expect_equal(dat$se, 0.1)
  # Check that the z-score has been calculated
  expect_equal(dat$z2, 100)
  # Check that the p-value has been calculated
  expect_equal(dat$p, 0)
})