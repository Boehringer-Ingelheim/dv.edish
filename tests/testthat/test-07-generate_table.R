# Data ----

edish_data <- data.frame(
  USUBJID = as.character(c(c(1:5, 1:5), c(6:10, 6:10))),
  ARM = c(rep("A", 10), rep("B", 10)),
  LBTEST = rep("alt", 20),
  .visit_at = rep(c(rep("V1", 5), rep("V2", 5)), 2),
  .date_at = as.Date(c(rep("2025-02-10", 10), rep("2025-02-20", 10))),
  .norm_at = c(1:5, 4:8, 2:6, 5:9),   # Normalised value used
  .abs_at = rep(99, 20),              # Dummy value not used
  .visit_tbili = rep("V2", 20),
  .date_tbili = as.Date(rep("2025-02-20", 20)),
  .norm_tbili = rep(99, 20),          # Dummy value not used
  .abs_tbili = c(4:8, 1:5, 5:9, 2:6), # Absolute value used
  .offset_days = rep(10L, 20),
  .norm_alp = rep(0.2, 20),
  .r_ratio = rep(5.5, 20),
  .norm_ref_type = "ULN"
)

# Tests ----

test_that("the resulting quadrant table correctly summarises the data" |>
  vdoc[["add_spec"]](specs$table_specs$data), {

  quad_tbl_df <- generate_table(
    dataset = edish_data,
    subjectid_var = "USUBJID",
    sel_x = "Alanine Aminotransferase",
    sel_y = "Total Bilirubin",
    x_abs = FALSE,
    y_abs = TRUE,
    x_ref_line_num = 5.5,
    y_ref_line_num = 5.5
  )

  actual <- quad_tbl_df
  expected <- data.frame("Alanine Aminotransferase" = factor(c("Normal", "Normal", "Elevated", "Elevated"),
                                                             levels = c("Normal", "Elevated")),
                         "Total Bilirubin" = factor(c("Normal", "Elevated", "Normal", "Elevated"),
                                                    levels = c("Normal", "Elevated")),
                         n = c(3L, 6L, 6L, 1L),
                         "%" = c("30.0", "60.0", "60.0", "10.0"),
                         Quadrant = c(EDISH$LOW_LFT_QUAD, EDISH$UPP_LFT_QUAD, EDISH$LOW_RGT_QUAD, EDISH$UPP_RGT_QUAD),
                         check.names = FALSE)

  expect_identical(actual, expected)
})

test_that("the resulting half-half table correctly summarises the data" |>
  vdoc[["add_spec"]](specs$table_specs$data), {

  half_tbl_df <- generate_table(
    dataset = edish_data,
    subjectid_var = "USUBJID",
    sel_x = "Alanine Aminotransferase",
    sel_y = "Total Bilirubin",
    x_abs = FALSE,
    y_abs = TRUE,
    x_ref_line_num = NA, # No x-axis reference line
    y_ref_line_num = 5.5
  )

  actual <- half_tbl_df
  expected <- data.frame("Alanine Aminotransferase" = factor(EDISH$EM_DASH,
                                                             levels = EDISH$EM_DASH),
                         "Total Bilirubin" = factor(c("Normal", "Elevated"),
                                                    levels = c("Normal", "Elevated")),
                         n = c(9L, 7L),
                         "%" = c("90.0", "70.0"),
                         Quadrant = c(EDISH$LOW_HALF, EDISH$UPP_HALF),
                         check.names = FALSE)

  expect_identical(actual, expected)
})
