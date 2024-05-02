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

dataset_tmp <- prepare_initial_data(
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

dataset <- derive_req_vars(
  dataset = dataset_tmp, 
  subjectid_var = "USUBJID",
  arm_var = "ARM",
  visit_var = "VISIT",
  lb_test_var = "LBTEST",
  lb_result_var = "LBSTRESN",
  ref_range_upper_lim_var = "LBSTNRHI",
  sel_x = sel_x, 
  sel_y = sel_y
)

x_plot_type <- "ULN"
y_plot_type <- "Baseline"
x_ref_line_num <- 3
y_ref_line_num <- 2

# Invoke the function
plt_obj <- generate_plot(
  dataset = dataset,
  subjectid_var = "USUBJID",
  arm_var = "ARM",
  visit_var = "VISIT",
  sel_x = sel_x,
  sel_y = sel_y,
  x_plot_type = x_plot_type, 
  y_plot_type = y_plot_type, 
  x_ref_line_num = x_ref_line_num, 
  y_ref_line_num = y_ref_line_num
) 

# Tests
test_that("the resulting plot object includes the correct data" %>%
  vdoc[["add_spec"]](specs$plot_specs$data), {
  
  # correct dataset
  actual <- plt_obj$x$visdat[[1]]()
  expected <- dataset
  expect_identical(actual, expected)
  
  # correct x and y selection
  tmp_x <- as.character(plt_obj$x$attrs[[2]]$x)[2]
  tmp_x <- substr(tmp_x, 8, nchar(tmp_x) - 2) # remove .data[[...]]
  actual_x <- eval(parse(text = tmp_x))
  tmp_y <- as.character(plt_obj$x$attrs[[2]]$y)[2]
  tmp_y <- substr(tmp_y, 8, nchar(tmp_y) - 2) # remove .data[[...]]
  actual_y <- eval(parse(text = tmp_y))
  expected_x <- paste0("r_", x_plot_type, "_", sel_x)
  expected_y <- paste0("r_", y_plot_type, "_", sel_y)
  expect_identical(actual_x, expected_x)
  expect_identical(actual_y, expected_y)
  
})

test_that("the resulting plot object includes the correct axis labels" %>%
  vdoc[["add_spec"]](specs$plot_specs$axis_labels), {
  
  actual_x <- plt_obj$x$layoutAttrs[[1]]$xaxis$title
  actual_y <- plt_obj$x$layoutAttrs[[1]]$yaxis$title
  expected_x <- paste0(sel_x, "/", x_plot_type)
  expected_y <- paste0(sel_y, "/", y_plot_type)
  expect_identical(actual_x, expected_x)
  expect_identical(actual_y, expected_y)
  
})

test_that("the resulting plot object includes the correct reference lines" %>%
  vdoc[["add_spec"]](specs$plot_specs$ref_lines), {
  
  actual_x_type <- plt_obj$x$layoutAttrs[[1]]$shapes[[1]]$type
  actual_x0 <- plt_obj$x$layoutAttrs[[1]]$shapes[[1]]$x0
  actual_x1 <- plt_obj$x$layoutAttrs[[1]]$shapes[[1]]$x1
  actual_y_type <- plt_obj$x$layoutAttrs[[1]]$shapes[[2]]$type
  actual_y0 <- plt_obj$x$layoutAttrs[[1]]$shapes[[2]]$y0
  actual_y1 <- plt_obj$x$layoutAttrs[[1]]$shapes[[2]]$y1
  
  expect_identical(actual_x_type, "line")
  expect_identical(actual_x0, x_ref_line_num)
  expect_identical(actual_x1, x_ref_line_num)
  expect_identical(actual_y0, y_ref_line_num)
  expect_identical(actual_y1, y_ref_line_num)
  
})

test_that("the resulting plot object includes the correct coloring" %>%
  vdoc[["add_spec"]](specs$plot_specs$arm_coloring), {
  
  actual <- plt_obj$x$attrs[[1]]$color
  expected <- dataset$ARM
  expect_identical(actual, expected)
  
})

test_that("the resulting plot object includes the correct hovertext (snapshot test)" %>%
  vdoc[["add_spec"]](specs$plot_specs$hovering), {
  
  actual <- as.character(plt_obj$x$attrs[[2]]$hovertext)[2]
  expect_snapshot(actual, cran = TRUE)
  
})
