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

usubjid <- c("01", "02") |> as.factor()
arm <- c("arm1", "arm2") |> as.factor()
lbdtc <- c("visit 1" = "2025-01-24", "visit 2" = "2025-02-14", "visit 3" = "2025-03-04")
visit <- names(lbdtc) |> as.factor()
lbtest <- c("alt", "ast", "tbili", "alp") |> as.factor()

set.seed(20251217) # needs to be set due to snapshot test

lb <- expand.grid(
  "USUBJID" = usubjid,
  "LBTEST" = lbtest,
  "VISIT" = visit
)
lb$LBDT <- as.Date(unname(lbdtc[lb$VISIT]))
lb$LBSTRESN <- runif(nrow(lb), min = 0, max = 10)
lb$LBSTNRHI <- runif(nrow(lb), min = 5, max = 15)

dm <- data.frame("USUBJID" = usubjid, "ARM" = arm)

test_ui <- function() {
  shiny::fluidPage(
    shiny::bookmarkButton(),
    dv.edish::edish_UI(
      module_id = "edish",
      arm_default_vals = "arm1",
      at_choices = c("alt", "ast"),
      at_default_val = "alt",
      tbili_choices = "tbili",
      tbili_default_val = "tbili",
      default_by_visit = FALSE,
      window_days = NULL
    )
  )
}

test_server <- function(input, output, session) {
  dv.edish::edish_server(
    module_id = "edish",
    dataset_list = shiny::reactive({
      list("dm" = dm, "lb" = lb)
    }),
    lb_date_var = "LBDT",
    subjectid_var = "USUBJID",
    arm_var = "ARM",
    visit_var = "VISIT",
    baseline_visit_val = "visit 1",
    lb_test_var = "LBTEST",
    at_choices = c("alt", "ast"),
    alp_choice = "alp",
    lb_result_var = "LBSTRESN",
    ref_range_upper_lim_var = "LBSTNRHI"
  )

  exported_url <- shiny::reactiveVal(NULL)
  shiny::onBookmarked(function(url) exported_url(url))
  shiny::exportTestValues(url = exported_url())
}

shiny::shinyApp(test_ui, test_server, enableBookmarking = "url")
