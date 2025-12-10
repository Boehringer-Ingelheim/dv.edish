set.seed(20251210)

# Prepare data to pass to function ----

usubjid <- c("01", "02")
arm <- c("arm1", "arm2")
lbdtc <- c("visit 1" = "2025-01-24", "visit 2" = "2025-02-14", "visit 3" = "2025-03-04")
visit <- names(lbdtc)
lbtest <- c("alt", "ast", "tbili", "alp", "xyz")

lb <- tidyr::expand_grid(
  "USUBJID" = usubjid,
  "LBTEST" = lbtest,
  "VISIT" = visit
)
lb$LBDT <- as.Date(unname(lbdtc[lb$VISIT]))
lb$LBSTRESN <- stats::runif(nrow(lb), min = 0, max = 10)
lb$LBSTNRHI <- stats::runif(nrow(lb), min = 5, max = 15)
lb$LBFAST <- NA  # Extra unused variable to test var selection

dm <- data.frame("USUBJID" = usubjid, "ARM" = arm)
dm$SEX <- "M"  # Extra unused variable to test var selection

baseline_visit_val <- visit[1]
at_choices <- lbtest[1:2]
tbili_choice <- lbtest[3]
alp_choice <- lbtest[4]

# Invoke the function ----

res <- prepare_initial_data(
  dataset_list = list(dm, lb),
  subjectid_var = "USUBJID",
  arm_var = "ARM",
  visit_var = "VISIT",
  lb_test_var = "LBTEST",
  at_choices = at_choices,
  tbili_choice = tbili_choice,
  alp_choice = alp_choice,
  lb_date_var = "LBDT",
  lb_result_var = "LBSTRESN",
  ref_range_upper_lim_var = "LBSTNRHI"
)

# Tests ----

test_that("the function returns a single dataset with the expected variables" |>
  vdoc[["add_spec"]](specs$plot_specs$data), {
  expect_s3_class(res, "data.frame")

  actual <- names(res)
  expected <- c("USUBJID", "ARM", "VISIT", "LBTEST", "LBDT", "LBSTRESN", "LBSTNRHI")
  expect_identical(actual, expected)
})

test_that("the kept variables are taken over correctly" |>
  vdoc[["add_spec"]](c(specs$plot_specs$arm, specs$plot_specs$param, specs$plot_specs$normalization)), {
  remaining_vars <- c("USUBJID", "ARM", "VISIT", "LBTEST", "LBDT", "LBSTRESN", "LBSTNRHI")
  actual <- res[remaining_vars]
  expected <- dm |>
    dplyr::left_join(lb[lb$LBTEST %in% lbtest[1:4], ], by = "USUBJID") |>
    dplyr::select(dplyr::all_of(remaining_vars)) |>
    dplyr::arrange(dplyr::across(dplyr::all_of(c("USUBJID", "ARM", "LBTEST", "VISIT")))) |>
    tibble::as_tibble()
  expect_identical(actual, expected)
})

# test_that("the new BASE variable contains the correct baseline values" |>
#   vdoc[["add_spec"]](specs$plot_specs$normalization), {
#   actual <- res[res$VISIT == baseline_visit_val, c("USUBJID", "LBTEST", "LBSTRESN")]
#   colnames(actual) <- NULL
#   rownames(actual) <- NULL
#   # expected calculated from res since the used variables in res are already tested and should be correct
#   expected <- unique(res[, c("USUBJID", "LBTEST", "BASE")])
#   colnames(expected) <- NULL
#   rownames(expected) <- NULL
#   expect_identical(actual, expected)
# })

test_that("the maximum values are used in case of multiple values" |>
  vdoc[["add_spec"]](specs$plot_specs$multiple_vals), {
  # Add additional row to the lb dataset
  add_usubjid <- lb$USUBJID[1]
  add_lbtest <- lb$LBTEST[1]
  add_visit <- lb$VISIT[1]
  add_date <- lb$LBDT[1]
  lb <- lb |>
    dplyr::add_row(USUBJID = add_usubjid,
                   LBTEST = add_lbtest,
                   VISIT = add_visit,
                   LBDT = add_date,
                   LBSTRESN = 20,
                   LBSTNRHI = 22)

  # Invoke the function
  res_extra_row <- prepare_initial_data(
    dataset_list = list(dm, lb),
    subjectid_var = "USUBJID",
    arm_var = "ARM",
    visit_var = "VISIT",
    lb_test_var = "LBTEST",
    at_choices = at_choices,
    tbili_choice = tbili_choice,
    alp_choice = alp_choice,
    lb_date_var = "LBDT",
    lb_result_var = "LBSTRESN",
    ref_range_upper_lim_var = "LBSTNRHI"
  ) |> dplyr::filter(USUBJID == add_usubjid, LBTEST == add_lbtest, VISIT == add_visit)

  # Test if only maximum value remains
  expect_identical(res_extra_row$LBSTRESN, 20)
})
