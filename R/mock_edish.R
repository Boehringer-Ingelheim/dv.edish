#' Plain mock app without specific layout
#'
#' `mock_edish_app()` launches a mock app containing the dv.edish shiny module.
#'
#' @keywords internal
mock_edish_app <- function() {
  dm <- pharmaverseadam::adsl |> dplyr::mutate(dplyr::across(dplyr::where(is.character), as.factor))
  lb <- pharmaverseadam::adlb |> dplyr::mutate(dplyr::across(dplyr::where(is.character), as.factor))

  mock_edish_UI <- function() { # nolint
    shiny::fluidPage(edish_UI(
      module_id = "edish",
      arm_default_vals = "Xanomeline High Dose",
      at_choices = c("Alanine Aminotransferase", "Aspartate Aminotransferase"),
      at_default_val = "Alanine Aminotransferase",
      tbili_choice = "Bilirubin",
      default_by_visit = FALSE,
      window_days = NULL
    ))
  }

  mock_edish_server <- function(input, output, session) {
    edish_server(
      module_id = "edish",
      dataset_list = shiny::reactive({
        list("dm" = dm, "lb" = lb)
      }),
      lb_date_var = "ADT",
      baseline_visit_val = "SCREENING 1",
      at_choices = c("Alanine Aminotransferase", "Aspartate Aminotransferase"),
      tbili_choice = "Bilirubin",
      alp_choice = "Alkaline Phosphatase"
    )
  }

  shiny::shinyApp(mock_edish_UI, mock_edish_server)
}


#' Mock app integrated in the module manager framework
#'
#' `mock_edish_mm()` launches a mock app containing the dv.edish shiny module by means of the `dv.manager`.
#'
#' @keywords internal
mock_edish_mm <- function() {
  dm <- pharmaverseadam::adsl
  lb <- pharmaverseadam::adlb

  module_list <- list(
    "eDISH Demo" = mod_edish(
      module_id = "edish",
      subject_level_dataset_name = "dm",
      lab_dataset_name = "lb",
      lb_date_var = "ADT",
      arm_default_vals = c("Xanomeline Low Dose", "Placebo"),
      baseline_visit_val = "SCREENING 1",
      default_by_visit = FALSE,
      window_days = 30L,
      receiver_id = "papo"
    ),
    "Patient Profile" = dv.papo::mod_patient_profile(
      module_id = "papo",
      subject_level_dataset_name = "dm",
      subjid_var = "USUBJID",
      sender_ids = c("edish"),
      summary = list(vars = c("AGE", "SEX", "RACE", "ETHNIC", "ARM"),
                     column_count = 1)
    )
  )

  dv.manager::run_app(
    data = list("demo" = list("dm" = dm, "lb" = lb)),
    module_list = module_list,
    filter_data = "dm"
  )
}
