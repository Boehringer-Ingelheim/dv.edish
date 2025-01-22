#' Plain mock app without specific layout
#'
#' `mock_edish_app()` launches a mock app containing the dv.edish shiny module.
#'
#' @keywords internal
mock_edish_app <- function() {
  dm <- pharmaverseadam::adsl
  lb <- pharmaverseadam::adlb

  mock_edish_UI <- function() { # nolint
    shiny::fluidPage(edish_UI("edish"))
  }

  mock_edish_server <- function(input, output, session) {
    edish_server(
      module_id = "edish",
      dataset_list = shiny::reactive({
        list("dm" = dm, "lb" = lb)
      }),
      baseline_visit_val = "SCREENING 1"
    )
  }

  shiny::shinyApp(mock_edish_UI, mock_edish_server)
}


#' Mock app integrated in the module manager framework
#'
#' `mock_table_mm()` launches a mock app containing the dv.edish shiny module by means of the `dv.manager`.
#'
#' @keywords internal
mock_edish_mm <- function() {
  dm <- pharmaverseadam::adsl
  lb <- pharmaverseadam::adlb

  module_list <- list(
    "edish demo" = mod_edish(
      module_id = "edish",
      subject_level_dataset_name = "dm",
      lab_dataset_name = "lb",
      arm_default_vals = c("Xanomeline Low Dose", "Placebo"),
      baseline_visit_val = "SCREENING 1"
    )
  )

  dv.manager::run_app(
    data = list("demo" = list("dm" = dm, "lb" = lb)),
    module_list = module_list,
    filter_data = "dm"
  )
}
