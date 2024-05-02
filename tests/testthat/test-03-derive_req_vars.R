# Specify function arguments for tests
usubjid <- c("01", "02")
arm <- c("arm1", "arm2")
visit <- c("visit 1", "visit 2", "visit 3")
lbtest <- c("test 1", "test 2", "test 3")

lb <- tidyr::expand_grid(
  "USUBJID" = usubjid,
  "LBTEST" = lbtest,
  "VISIT" = visit
)
lb$LBSTRESN <- runif(nrow(lb), min = 0, max = 10)
lb$LBSTNRHI <- runif(nrow(lb), min = 5, max = 15)

dm <- data.frame("USUBJID" = usubjid, "ARM" = arm)

baseline_visit_val <- visit[1]
lb_test_choices <- lbtest

dataset <- prepare_initial_data(
  dataset_list = list(dm, lb),
  subjectid_var = "USUBJID",
  arm_var = "ARM",
  visit_var = "VISIT",
  baseline_visit_val = baseline_visit_val,
  lb_test_var = "LBTEST",
  lb_test_choices = lb_test_choices,
  lb_result_var = "LBSTRESN",
  ref_range_upper_lim_var = "LBSTNRHI"
)

sel_x <- "test 2"
sel_y <- "test 1"

# Invoke the function
res <- derive_req_vars(
  dataset = dataset,
  subjectid_var = "USUBJID",
  arm_var = "ARM",
  visit_var = "VISIT",
  lb_test_var = "LBTEST",
  lb_result_var = "LBSTRESN",
  ref_range_upper_lim_var = "LBSTNRHI",
  sel_x = sel_x,
  sel_y = sel_y
)

# Tests
test_that("the function returns a single dataset with the expected variables" %>%
  vdoc[["add_spec"]](specs$plot_specs$data), {
  expect_s3_class(res, "data.frame")

  actual <- names(res)
  kept_vars <- c("USUBJID", "ARM", "VISIT")
  new_vars <- as.vector(t(outer(c("r_ULN_", "r_Baseline_"), c(sel_x, sel_y), paste0)))
  expected <- c(kept_vars, new_vars)
  expect_contains(sort(actual), sort(expected))
})

test_that("the kept variables are taken over correctly" %>%
  vdoc[["add_spec"]](specs$plot_specs$data), {
  kept_vars <- c("USUBJID", "ARM", "VISIT")
  actual <- tibble::as_tibble(res[, kept_vars])
  expected <- unique(dataset[, kept_vars])
  rownames(expected) <- NULL
  expect_identical(actual, expected)
})

test_that("the new variables contain the correct normalized values" %>%
  vdoc[["add_spec"]](specs$plot_specs$normalization), {
  plot_type_choices <- c("ULN", "Baseline")
  test_choices <- c(sel_x, sel_y)
  combo <- tidyr::expand_grid(plot_type_choices, test_choices)

  mapply(function(plot_type, test_sel) {
    combo_name <- paste0("r_", plot_type, "_", test_sel)
    filtered_dataset <- dataset[dataset$LBTEST == test_sel, ]
    divisor <- ifelse(plot_type == "ULN", "LBSTNRHI", "BASE")
    expected <- filtered_dataset$LBSTRESN / filtered_dataset[[divisor]]
    actual <- res[[combo_name]]
    expect_identical(actual, expected)

    return(NULL)
  }, combo$plot_type_choices, combo$test_choices)
})
