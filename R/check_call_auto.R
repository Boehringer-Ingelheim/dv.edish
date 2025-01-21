# Automatically generated module API check functions. Think twice before editing them manually.
({
# styler: off

# dv.edish::mod_edish
check_mod_edish_auto <- function(afmm, datasets, module_id, dataset_names, subjectid_var, arm_var, arm_default_vals,
    visit_var, baseline_visit_val, lb_test_var, lb_test_choices, lb_test_default_x_val, lb_test_default_y_val,
    lb_result_var, ref_range_upper_lim_var, warn, err) {
    OK <- logical(0)
    used_dataset_names <- new.env(parent = emptyenv())
    OK[["module_id"]] <- CM$check_module_id("module_id", module_id, warn, err)
    flags <- list(one_or_more = TRUE)
    OK[["dataset_names"]] <- CM$check_dataset_name("dataset_names", dataset_names, flags, datasets, used_dataset_names,
        warn, err)
    "TODO: subjectid_var (group)"
    "TODO: arm_var (group)"
    "TODO: arm_default_vals (group)"
    "TODO: visit_var (group)"
    "TODO: baseline_visit_val (group)"
    "TODO: lb_test_var (group)"
    "TODO: lb_test_choices (group)"
    "TODO: lb_test_default_x_val (group)"
    "TODO: lb_test_default_y_val (group)"
    "TODO: lb_result_var (group)"
    "TODO: ref_range_upper_lim_var (group)"
    return(OK)
}

})
# styler: on
