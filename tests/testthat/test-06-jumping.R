data_list <- list(
  dm  = pharmaverseadam::adsl,
  lb  = pharmaverseadam::adlb
)

mod <- dv.edish::mod_edish(
  module_id = "mod",
  subject_level_dataset_name = "dm",
  lab_dataset_name = "lb",
  arm_default_vals = unique(pharmaverseadam::adsl$ACTARM),
  baseline_visit_val = "SCREENING 1",
  lb_date_var = "ADT",
  receiver_id = "papo"
)

trigger_input_id <- "mod-plot_selected"
test_communication_with_papo(mod, data_list, trigger_input_id)



foo <- function() {
  dv.manager::run_app(
    data = list("demo" = list("dm" = pharmaverseadam::adsl, "lb" = pharmaverseadam::adlb)),
    module_list = list("edish" = mod),
    filter_type = "datasets",
    filter_data = "dm"
  )
}
