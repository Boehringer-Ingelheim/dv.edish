# Specify function arguments for tests
dataset <- data.frame(
  "USUBJID" = c("01", "02", "02", "03", "03", "04"),
  "ARM"     = c("arm1", "arm2", "arm2", "arm3", "arm3", NA),
  "LBTEST"  = c("test1", "test2", "test3", "test2", "test2", "test1")
)
arm_var <- names(dataset)[2]
lb_test_var <- names(dataset)[3]
arm_vals <- unique(dataset[[arm_var]])
lb_test_vals <- unique(dataset[[lb_test_var]])

# Tests
test_that("the resulting dataset contains only data corresponding to the desired lab tests" %>%
  vdoc[["add_spec"]](specs$plot_specs$param), {
  # No lab test
  res <- filter_data(
    dataset = dataset,
    arm_var = arm_var,
    sel_arm = arm_vals,
    lb_test_var = lb_test_var,
    sel_lb_test = NULL
  )
  exp <- dataset[0, ]
  rownames(exp) <- NULL
  expect_identical(res, exp)

  # One lab test
  res <- filter_data(
    dataset = dataset,
    arm_var = arm_var,
    sel_arm = arm_vals,
    lb_test_var = lb_test_var,
    sel_lb_test = lb_test_vals[2]
  )
  exp <- dataset[dataset[[lb_test_var]] %in% lb_test_vals[2], ]
  rownames(exp) <- NULL
  expect_identical(res, exp)

  # Several lab tests
  res <- filter_data(
    dataset = dataset,
    arm_var = arm_var,
    sel_arm = arm_vals,
    lb_test_var = lb_test_var,
    sel_lb_test = lb_test_vals[c(1, 2)]
  )
  exp <- dataset[dataset[[lb_test_var]] %in% lb_test_vals[c(1, 2)], ]
  rownames(exp) <- NULL
  expect_identical(res, exp)

  # All lab tests
  res <- filter_data(
    dataset = dataset,
    arm_var = arm_var,
    sel_arm = arm_vals,
    lb_test_var = lb_test_var,
    sel_lb_test = lb_test_vals
  )
  exp <- dataset
  rownames(exp) <- NULL
  expect_identical(res, exp)
})


test_that("the resulting dataset contains only data corresponding to the desired arms" %>%
  vdoc[["add_spec"]](specs$plot_specs$arm), {
  # No arm
  res <- filter_data(
    dataset = dataset,
    arm_var = arm_var,
    sel_arm = NULL,
    lb_test_var = lb_test_var,
    sel_lb_test = lb_test_vals
  )
  exp <- dataset[0, ]
  rownames(exp) <- NULL
  expect_identical(res, exp)

  # One arm
  res <- filter_data(
    dataset = dataset,
    arm_var = arm_var,
    sel_arm = arm_vals[2],
    lb_test_var = lb_test_var,
    sel_lb_test = lb_test_vals
  )
  exp <- dataset[dataset[[arm_var]] %in% arm_vals[2], ]
  rownames(exp) <- NULL
  expect_identical(res, exp)

  # Several arms
  res <- filter_data(
    dataset = dataset,
    arm_var = arm_var,
    sel_arm = arm_vals[c(1, 2)],
    lb_test_var = lb_test_var,
    sel_lb_test = lb_test_vals
  )
  exp <- dataset[dataset[[arm_var]] %in% arm_vals[c(1, 2)], ]
  rownames(exp) <- NULL
  expect_identical(res, exp)

  # All arms
  res <- filter_data(
    dataset = dataset,
    arm_var = arm_var,
    sel_arm = arm_vals,
    lb_test_var = lb_test_var,
    sel_lb_test = lb_test_vals
  )
  exp <- dataset
  rownames(exp) <- NULL
  expect_identical(res, exp)
})


test_that("the resulting dataset contains only data corresponding to the desired arms and lab tests" %>%
  vdoc[["add_spec"]](c(specs$plot_specs$arm, specs$plot_specs$param)), {
  res <- filter_data(
    dataset = dataset,
    arm_var = arm_var,
    sel_arm = arm_vals[c(1, 2)],
    lb_test_var = lb_test_var,
    sel_lb_test = lb_test_vals[c(1, 2)]
  )
  arm_cond <- dataset[[arm_var]] %in% arm_vals[c(1, 2)]
  lb_test_cond <- dataset[[lb_test_var]] %in% lb_test_vals[c(1, 2)]
  exp <- dataset[arm_cond & lb_test_cond, ]
  rownames(exp) <- NULL
  expect_identical(res, exp)
})
