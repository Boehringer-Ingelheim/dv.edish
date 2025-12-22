# Data ----

lb <- tibble::tribble(
  ~USUBJID, ~LBTEST, ~VISIT, ~ARM,        ~LBDT, ~LBSTRESN, ~LBSTNRHI,
  "01",       "alt",  "BL1", "a1", "2025-01-24",       3.1,         5,
  "01",       "alt",   "V1", "a1", "2025-02-14",       9.2,         5,   # max ALT at V1
  "01",       "alt",   "V2", "a1", "2025-03-04",       4.3,         5,
  "01",     "tbili",  "BL1", "a1", "2025-01-24",       1.1,         9,
  "01",     "tbili",   "V1", "a1", "2025-02-14",       8.9,         9,
  "01",     "tbili",   "V2", "a1", "2025-03-04",      17.3,         9,   # max TBILI at V2
  "01",       "alp",  "BL1", "a1", "2025-01-24",       3.4,         3,
  "01",       "alp",   "V1", "a1", "2025-02-14",       2.3,         3,
  "01",       "alp",   "V2", "a1", "2025-03-04",       1.2,         3,
  "02",       "alt",  "BL1", "a2", "2025-07-24",       3.1,         5,
  "02",       "alt",   "V1", "a2", "2025-08-14",       4.2,         5,
  "02",       "alt",   "V2", "a2", "2025-09-04",       9.3,         5,   # max ALT at V2
  "02",       "ast",  "BL1", "a2", "2025-07-24",       6.2,         5,
  "02",       "ast",   "V1", "a2", "2025-08-14",       6.2,         5,   # max AST at V1
  "02",       "ast",   "V2", "a2", "2025-09-04",       6.2,         5,
  "02",     "tbili",  "BL1", "a2", "2025-07-24",       1.1,         9,
  "02",     "tbili",   "V1", "a2", "2025-08-14",       17.9,        9,   # max TBILI at V1
  "02",     "tbili",   "V2", "a2", "2025-09-04",       8.3,         9
) |>
  dplyr::mutate(LBDT = as.Date(.data$LBDT)) |>
  as.data.frame()

# Tests ----

test_that("normalization using ULN reference type" |>
  vdoc[["add_spec"]](specs$plot_specs$normalization), {

  observed <- derive_req_vars(dataset = lb,
                              subjectid_var = "USUBJID",
                              arm_var = "ARM",
                              visit_var = "VISIT",
                              baseline_visit_val = "BL1",
                              lb_test_var = "LBTEST",
                              at_choices = c("alt", "ast"),
                              tbili_choice = "tbili",
                              norm_ref_type = "ULN",
                              alp_choice = "alp",
                              lb_date_var = "LBDT",
                              lb_result_var = "LBSTRESN",
                              ref_range_upper_lim_var = "LBSTNRHI",
                              by_visit = FALSE,
                              window_days = NULL)

  expected <- data.frame(
    USUBJID = c("01", "02", "02"),
    ARM = c("a1", "a2", "a2"),
    LBTEST = c("alt", "alt", "ast"),
    .visit_at = c("V1", "V2", "V1"),
    .date_at = as.Date(c("2025-02-14", "2025-09-04", "2025-08-14")),
    .norm_at = c(1.84, 1.86, 1.24),
    .norm_base = c(3.1, 3.1, 6.2) / 5,
    .visit_tbili = c("V2", "V1", "V1"),
    .date_tbili = as.Date(c("2025-03-04", "2025-08-14", "2025-08-14")),
    .norm_tbili = c(1.92222222222222, 1.98888888888889, 1.98888888888889),
    .offset_days = c(18L, -21L, 0L),
    .norm_alp = c(0.766666666666667, NA, NA),
    .r_ratio = c(2.4, NA, NA),
    .norm_ref_type = "ULN"
  ) |> tibble::as_tibble()

  testthat::expect_equal(observed, expected)
})

test_that("normalization using Baseline reference type" |>
  vdoc[["add_spec"]](specs$plot_specs$normalization), {

  observed <- derive_req_vars(dataset = lb,
                              subjectid_var = "USUBJID",
                              arm_var = "ARM",
                              visit_var = "VISIT",
                              baseline_visit_val = "BL1",
                              lb_test_var = "LBTEST",
                              at_choices = c("alt", "ast"),
                              tbili_choice = "tbili",
                              norm_ref_type = "Baseline",
                              alp_choice = "alp",
                              lb_date_var = "LBDT",
                              lb_result_var = "LBSTRESN",
                              ref_range_upper_lim_var = "LBSTNRHI",
                              by_visit = FALSE,
                              window_days = NULL)

  expected <- data.frame(
    USUBJID = c("01", "02", "02"),
    ARM = c("a1", "a2", "a2"),
    LBTEST = c("alt", "alt", "ast"),
    .visit_at = c("V1", "V2", "V1"),
    .date_at = as.Date(c("2025-02-14", "2025-09-04", "2025-08-14")),
    .norm_at = c(2.96774193548387, 3, 1),
    .norm_base = 1,
    .visit_tbili = c("V2", "V1", "V1"),
    .date_tbili = as.Date(c("2025-03-04", "2025-08-14", "2025-08-14")),
    .norm_tbili = c(15.7272727272727, 16.2727272727273, 16.2727272727273),
    .offset_days = c(18L, -21L, 0L),
    .norm_alp = c(0.676470588235294, NA, NA),
    .r_ratio = c(4.38709677419355, NA, NA),
    .norm_ref_type = "Baseline"
  ) |> tibble::as_tibble()

  testthat::expect_equal(observed, expected)
})

test_that("window selection" |>
  vdoc[["add_spec"]](specs$plot_specs$window), {

  observed <- derive_req_vars(dataset = lb,
                              subjectid_var = "USUBJID",
                              arm_var = "ARM",
                              visit_var = "VISIT",
                              baseline_visit_val = "BL1",
                              lb_test_var = "LBTEST",
                              at_choices = c("alt", "ast"),
                              tbili_choice = "tbili",
                              norm_ref_type = "ULN",
                              alp_choice = "alp",
                              lb_date_var = "LBDT",
                              lb_result_var = "LBSTRESN",
                              ref_range_upper_lim_var = "LBSTNRHI",
                              by_visit = FALSE,
                              window_days = 10L)

  expected <- data.frame(
    USUBJID = c("01", "02", "02"),
    ARM = c("a1", "a2", "a2"),
    LBTEST = c("alt", "alt", "ast"),
    .visit_at = c("V1", "V2", "V1"),
    .date_at = as.Date(c("2025-02-14", "2025-09-04", "2025-08-14")),
    .norm_at = c(1.84, 1.86, 1.24),
    .norm_base = c(3.1, 3.1, 6.2) / 5,
    .visit_tbili = c("V1", "V2", "V1"),
    .date_tbili = as.Date(c("2025-02-14", "2025-09-04", "2025-08-14")),
    .norm_tbili = c(0.988888888888889, 0.922222222222222, 1.98888888888889),
    .offset_days = c(0L, 0L, 0L),
    .norm_alp = c(0.766666666666667, NA, NA),
    .r_ratio = c(2.4, NA, NA),
    .norm_ref_type = "ULN"
  ) |> tibble::as_tibble()

  testthat::expect_equal(observed, expected)
})

test_that("display by visit" |>
  vdoc[["add_spec"]](specs$plot_specs$by_visit), {

  observed <- derive_req_vars(dataset = lb,
                              subjectid_var = "USUBJID",
                              arm_var = "ARM",
                              visit_var = "VISIT",
                              baseline_visit_val = "BL1",
                              lb_test_var = "LBTEST",
                              at_choices = c("alt", "ast"),
                              tbili_choice = "tbili",
                              norm_ref_type = "ULN",
                              alp_choice = "alp",
                              lb_date_var = "LBDT",
                              lb_result_var = "LBSTRESN",
                              ref_range_upper_lim_var = "LBSTNRHI",
                              by_visit = TRUE,
                              window_days = NULL)

  expected <- data.frame(
    USUBJID = c("01", "01", "02", "02", "02", "02"),
    ARM = c("a1", "a1", "a2", "a2", "a2", "a2"),
    LBTEST = c("alt", "alt", "alt", "alt", "ast", "ast"),
    .visit_at = c("V1", "V2", "V1", "V2", "V1", "V2"),
    .date_at = as.Date(c("2025-02-14","2025-03-04",
                         "2025-08-14","2025-09-04","2025-08-14","2025-09-04")),
    .norm_at = c(1.84, 0.86, 0.84, 1.86, 1.24, 1.24),
    .norm_base = c(3.1, 3.1, 3.1, 3.1, 6.2, 6.2) / 5,
    .visit_tbili = c("V2", "V2", "V1", "V1", "V1", "V1"),
    .date_tbili = as.Date(c("2025-03-04","2025-03-04",
                            "2025-08-14","2025-08-14","2025-08-14","2025-08-14")),
    .norm_tbili = c(1.92222222222222,
                    1.92222222222222,1.98888888888889,1.98888888888889,1.98888888888889,
                    1.98888888888889),
    .offset_days = c(18L, 0L, 0L, -21L, 0L, -21L),
    .norm_alp = c(0.766666666666667, 0.4, NA, NA, NA, NA),
    .r_ratio = c(2.4, 2.15, NA, NA, NA, NA),
    .norm_ref_type = "ULN"
  ) |> tibble::as_tibble()

  testthat::expect_equal(observed, expected)
})
