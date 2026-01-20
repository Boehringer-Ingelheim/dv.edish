# Data ----

edish_data <- data.frame(
  USUBJID = c("01", "02", "03"),
  ARM = c("a1", "a2", "a1"),
  LBTEST = c("alt", "alt", "alt"),
  .visit_at = c("V1", "V2", "V1"),
  .date_at = as.Date(c("2025-02-10", "2025-02-20", "2025-02-10")),
  .norm_at = c(1.1, 2.2, 3.3),
  .visit_tbili = c("V2", "V1", "V1"),
  .date_tbili = as.Date(c("2025-02-20", "2025-02-10", "2025-02-10")),
  .norm_tbili = c(0.1, 0.2, 0.3),
  .offset_days = c(10L, -10L, 0L),
  .norm_alp = c(0.2, 0.9, 5.3),
  .r_ratio = c(5.5, 2.4, 0.6),
  .norm_ref_type = "ULN"
)

# Tests ----

plt_obj <- generate_plot(dataset = edish_data,
                         subjectid_var = "USUBJID",
                         arm_var = "ARM",
                         sel_x = "Alanine Aminotransferase",
                         sel_y = "Total Bilirubin",
                         norm_ref_type = "ULN",
                         x_ref_line_num = 3,
                         y_ref_line_num = 2,
                         x_rng_lower = 0,
                         x_rng_upper = NA,
                         y_rng_lower = 0.01,
                         y_rng_upper = 4.5,
                         alp_flag = TRUE)

test_that("the resulting plot object includes the correct data" |>
  vdoc[["add_spec"]](specs$plot_specs$data), {

  # correct dataset (exclude tooltip)
  actual <- plt_obj$data
  expected <- edish_data
  expect_identical(actual[, names(actual) != "tooltip"], expected)
})

test_that("the resulting plot object includes the correct axis labels" |>
  vdoc[["add_spec"]](specs$plot_specs$axis_labels), {

  actual_x <- plt_obj[["labels"]][["x"]]
  actual_y <- plt_obj[["labels"]][["y"]]
  expected_x <- "Alanine Aminotransferase (\u00d7 ULN)"
  expected_y <- "Total Bilirubin (\u00d7 ULN)"
  expect_identical(actual_x, expected_x)
  expect_identical(actual_y, expected_y)
})

test_that("the resulting plot object includes the correct reference lines" |>
  vdoc[["add_spec"]](specs$plot_specs$ref_lines), {

  actual_x <- plt_obj[["layers"]][[1]][["data"]][["xintercept"]]
  actual_y <- plt_obj[["layers"]][[2]][["data"]][["yintercept"]]

  expect_identical(actual_x, 3)
  expect_identical(actual_y, 2)
})

test_that("the resulting plot object includes the correct axis range" |>
  vdoc[["add_spec"]](specs$plot_specs$axis_ranges), {

  actual_x <- plt_obj[["scales"]][["scales"]][[1]][["limits"]]
  actual_y <- plt_obj[["scales"]][["scales"]][[2]][["limits"]]

  expected_x <- c(log10(0.001), NA)
  expected_y <- c(log10(0.01), log10(4.5))

  expect_identical(actual_x, expected_x)
  expect_identical(actual_y, expected_y)
})

test_that("the resulting plot object includes the correct coloring" |>
  vdoc[["add_spec"]](specs$plot_specs$arm_coloring), {

  actual <- rlang::quo_get_expr(plt_obj[["mapping"]][["colour"]])[[3]]
  expected <- "ARM"
  expect_identical(actual, expected)
})

test_that("the resulting plot object includes the correct hovertext" |>
  vdoc[["add_spec"]](specs$plot_specs$hovering), {

  actual <- plt_obj[["data"]][["tooltip"]][1]
  expected <- paste0("Subject: 01<br>Arm: a1",
                     "<br>---<br>Alanine Aminotransferase: 1.100<br>&nbsp;&nbsp;Visit: V1<br>&nbsp;&nbsp;Date: 2025-02-10 (1st)",
                     "<br>&nbsp;&nbsp;ALP/ULN ≤ 2 (0.200)<br>&nbsp;&nbsp;R ≥ 5 (5.50)",
                     "<br>---<br>Total Bilirubin: 0.100<br>&nbsp;&nbsp;Visit: V2<br>&nbsp;&nbsp;Date: 2025-02-20 (2nd)",
                     "<br>---<br>Time between peaks: 10 days")
  expect_identical(actual, expected)
})
