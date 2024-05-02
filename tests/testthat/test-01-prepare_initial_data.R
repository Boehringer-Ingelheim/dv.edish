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
lb_test_choices <- lbtest[c(1, 2)]

# Invoke the function
res <- prepare_initial_data(
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

# Tests
test_that("the function returns a single dataset with the expected variables" %>%
  vdoc[["add_spec"]](specs$plot_specs$data), {

  expect_s3_class(res, "data.frame")
  
  actual <- names(res)
  expected <- c("USUBJID", "ARM", "VISIT", "LBTEST", "LBSTRESN", "LBSTNRHI", "BASE")
  expect_identical(actual, expected)
  
})

test_that("the kept variables are taken over correctly" %>%
  vdoc[["add_spec"]](c(specs$plot_specs$arm, specs$plot_specs$param, specs$plot_specs$normalization)), {
  
  remaining_vars <- c("USUBJID", "ARM", "VISIT", "LBTEST", "LBSTRESN", "LBSTNRHI")
  actual <- res[remaining_vars]
  expected <- tibble::as_tibble(merge(lb[lb$LBTEST %in% lb_test_choices, ], dm)[remaining_vars])
  expect_identical(actual, expected)
  
})

test_that("the new BASE variable contains the correct baseline values" %>%
  vdoc[["add_spec"]](specs$plot_specs$normalization), {
  
  actual <- res[res$VISIT == baseline_visit_val, c("USUBJID", "LBTEST", "LBSTRESN")]
  colnames(actual) <- NULL
  rownames(actual) <- NULL
  # expected calculated from res since the used variables in res are already tested and should be correct
  expected <- unique(res[, c("USUBJID", "LBTEST", "BASE")]) 
  colnames(expected) <- NULL
  rownames(expected) <- NULL
  expect_identical(actual, expected)
  
})

test_that("the maximum values are used in case of multiple values" %>%
            vdoc[["add_spec"]](specs$plot_specs$multiple_vals), {
  
  # Add additional row to the lb dataset
  add_usubjid <- lb$USUBJID[1]
  add_lbtest <- lb$LBTEST[1]
  add_visit <- lb$VISIT[1]
  lb <- lb %>% 
    dplyr::add_row(USUBJID = add_usubjid, LBTEST = add_lbtest, VISIT = add_visit, LBSTRESN = 20, LBSTNRHI = 22)
  
  # Invoke the function
  res_extra_row <- prepare_initial_data(
    dataset_list = list(dm, lb),
    subjectid_var = "USUBJID",
    arm_var = "ARM",
    visit_var = "VISIT",
    baseline_visit_val = baseline_visit_val,
    lb_test_var = "LBTEST",
    lb_test_choices = lb_test_choices,
    lb_result_var = "LBSTRESN",
    ref_range_upper_lim_var = "LBSTNRHI"
  ) %>% dplyr::filter(USUBJID == add_usubjid, LBTEST == add_lbtest, VISIT == add_visit)
  
  # Test if only maximum value remains
  expect_identical(res_extra_row$LBSTRESN, 20)
  
})
