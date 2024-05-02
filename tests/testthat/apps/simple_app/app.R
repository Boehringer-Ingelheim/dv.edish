use_load_all <- isTRUE(as.logical(Sys.getenv("TEST_LOCAL")))
if (use_load_all) {
  pkg_path <- "."
  prev_path <- ""
  while (!length(list.files(pkg_path, pattern = "^DESCRIPTION$")) == 1) {
    if (normalizePath(pkg_path) == prev_path) rlang::abort("root folder reached and no DESCRIPTION file found")
    prev_path <- normalizePath(pkg_path)
    pkg_path <- file.path("..", pkg_path)
  }
  devtools::load_all(pkg_path, quiet = TRUE)
}


test_ui <- function() {
  shiny::fluidPage(dv.edish::edish_UI("edish"))
}

test_server <- function(input, output, session) {
  usubjid <- c("01", "02")
  arm <- c("arm1", "arm2")
  visit <- c("visit 1", "visit 2", "visit 3")
  lbtest <- c("test 1", "test 2", "test 3")

  set.seed(123) # needs to be set due to snapshot test

  lb <- tidyr::expand_grid(
    "USUBJID" = usubjid,
    "LBTEST" = lbtest,
    "VISIT" = visit
  )
  lb$LBSTRESN <- runif(nrow(lb), min = 0, max = 10)
  lb$LBSTNRHI <- runif(nrow(lb), min = 5, max = 15)

  dm <- data.frame("USUBJID" = usubjid, "ARM" = arm)

  dv.edish::edish_server(
    module_id = "edish",
    dataset_list = shiny::reactive({
      list("dm" = dm, "lb" = lb)
    }),
    subjectid_var = "USUBJID",
    arm_var = "ARM",
    arm_default_vals = arm[1],
    visit_var = "VISIT",
    baseline_visit_val = visit[1],
    lb_test_var = "LBTEST",
    lb_test_choices = lbtest[c(1, 2)],
    lb_test_default_x_val = lbtest[1],
    lb_test_default_y_val = lbtest[2],
    lb_result_var = "LBSTRESN",
    ref_range_upper_lim_var = "LBSTNRHI"
  )
}

shiny::shinyApp(test_ui, test_server)
