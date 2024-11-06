# Write a unit test of the meta-analysis function
test_that("effect estimates are updated for a two-study analysis", {
  dat <- data.table::data.table(
    BETA = 1, SE = 0.1,
    BETA.study1 = 1, SE.study1 = 0.1,
    BETA.study2 = 1.1, SE.study2 = 0.2
  )
  update_meta_analysis_estimates(dat, "study1")
  expect_equal(dat$BETA, 1)
  expect_equal(dat$SE, 0.0707, tolerance = 1e-3)
  expect_equal(dat$Z2, 200.0604, tolerance = 1e-3)
  expect_equal(dat$P, 2.03e-45)

  update_meta_analysis_estimates(dat, "study2")
  expect_equal(dat$BETA, 1.0111, tolerance = 1e-3)
  expect_equal(dat$SE, 0.0667, tolerance = 1e-3)
  expect_equal(dat$Z2, 230.0278, tolerance = 1e-3)
  expect_equal(dat$P, 5.88e-52)
})

test_that("effect estimates are updated for a three-study analysis", {
  dat <- data.table::data.table(
    BETA = 1, SE = 0.1,
    BETA.study1 = 1, SE.study1 = 0.1,
    BETA.study2 = 1.1, SE.study2 = 0.2
  )
  update_meta_analysis_estimates(dat, "study1")
  update_meta_analysis_estimates(dat, "study2")
  expect_equal(dat$BETA, 1.0111, tolerance = 1e-3)
  expect_equal(dat$SE, 0.0667, tolerance = 1e-3)
  expect_equal(dat$Z2, 230.0278, tolerance = 1e-3)
  expect_equal(dat$P, 5.88e-52)
})

test_that("effect estimates are updated for a three-study analysis with no initial estimates", {
  dat <- data.table::data.table(
    BETA.study1 = 1, SE.study1 = 0.1,
    BETA.study2 = 1.1, SE.study2 = 0.2,
    BETA.study3 = 1, SE.study3 = 0.1
  )
  update_meta_analysis_estimates(dat, "study1")
  update_meta_analysis_estimates(dat, "study2")
  update_meta_analysis_estimates(dat, "study3")
  expect_equal(dat$BETA, 1.0111, tolerance = 1e-3)
  expect_equal(dat$SE, 0.0667, tolerance = 1e-3)
  expect_equal(dat$Z2, 230.0278, tolerance = 1e-3)
  expect_equal(dat$P, 5.88e-52)
})