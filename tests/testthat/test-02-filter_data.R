# Specify function arguments for tests ----

dataset <- data.frame(
  "USUBJID" = c("01", "02", "02", "03", "03", "04"),
  "ARM"     = c("arm1", "arm2", "arm2", "arm3", "arm3", "screenfail"),
  "LBTEST"  = c("test1", "test2", "test3", "test2", "test2", "test1")
)
arm_var <- names(dataset)[2]
lb_test_var <- names(dataset)[3]
arm_vals <- unique(dataset[[arm_var]])
lb_test_vals <- unique(dataset[[lb_test_var]])

# Duplicate rows for normalization reference types ULN and Baseline
dataset <- dplyr::bind_rows(
  dataset |> dplyr::mutate(.norm_ref_type = "ULN"),
  dataset |> dplyr::mutate(.norm_ref_type = "Baseline")
)

# Tests ----

test_that("the resulting dataset contains only data corresponding to the desired lab test" |>
  vdoc[["add_spec"]](specs$plot_specs$param), {
  # One lab test
  res <- filter_data(
    dataset = dataset,
    norm_ref_type = "ULN",
    arm_var = arm_var,
    sel_arm = arm_vals,
    lb_test_var = lb_test_var,
    sel_lb_test = lb_test_vals[2]
  )
  exp <- dataset[dataset[[lb_test_var]] %in% lb_test_vals[2] &
                   dataset[[".norm_ref_type"]] == "ULN", ]
  rownames(exp) <- NULL
  expect_identical(res, exp)
})

test_that("the resulting dataset contains only data corresponding to the desired arms" |>
  vdoc[["add_spec"]](specs$plot_specs$arm), {
  # No arm
  res <- filter_data(
    dataset = dataset,
    norm_ref_type = "ULN",
    arm_var = arm_var,
    sel_arm = NULL,
    lb_test_var = lb_test_var,
    sel_lb_test = lb_test_vals[2]
  )
  exp <- dataset[0, ]
  rownames(exp) <- NULL
  expect_identical(res, exp)

  # One arm
  res <- filter_data(
    dataset = dataset,
    norm_ref_type = "ULN",
    arm_var = arm_var,
    sel_arm = arm_vals[3],
    lb_test_var = lb_test_var,
    sel_lb_test = lb_test_vals[2]
  )
  exp <- dataset[dataset[[arm_var]] %in% arm_vals[3] &
                   dataset[[lb_test_var]] == lb_test_vals[2] &
                   dataset[[".norm_ref_type"]] == "ULN", ]
  rownames(exp) <- NULL
  expect_identical(res, exp)

  # Several arms
  res <- filter_data(
    dataset = dataset,
    norm_ref_type = "Baseline",
    arm_var = arm_var,
    sel_arm = arm_vals[c(2, 3)],
    lb_test_var = lb_test_var,
    sel_lb_test = lb_test_vals[2]
  )
  exp <- dataset[dataset[[arm_var]] %in% arm_vals[c(2, 3)] &
                   dataset[[lb_test_var]] == lb_test_vals[2] &
                   dataset[[".norm_ref_type"]] == "Baseline", ]
  rownames(exp) <- NULL
  expect_identical(res, exp)

  # All arms
  res <- filter_data(
    dataset = dataset,
    norm_ref_type = "ULN",
    arm_var = arm_var,
    sel_arm = arm_vals,
    lb_test_var = lb_test_var,
    sel_lb_test = lb_test_vals[1]
  )
  exp <- dataset[dataset[[lb_test_var]] == lb_test_vals[1] &
                   dataset[[".norm_ref_type"]] == "ULN", ]
  rownames(exp) <- NULL
  expect_identical(res, exp)
})
