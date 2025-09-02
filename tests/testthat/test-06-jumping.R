data_list <- list(
  dm  = pharmaverseadam::adsl,
  lb  = pharmaverseadam::adlb
)

mod <- dv.edish::mod_edish(
  module_id = "mod",
  subject_level_dataset_name = "dm",
  lab_dataset_name = "lb",
  baseline_visit_val = "SCREENING 1",
  receiver_id = "papo"
)

trigger_input_id <- "plotly_click-mod-plot"
test_communication_with_papo(mod, data_list, trigger_input_id)
