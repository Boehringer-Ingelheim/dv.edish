# Automatically generated module API check functions. Think twice before editing them manually.
({
# styler: off

# dv.edish::mod_edish
check_mod_edish_auto <- function(afmm, datasets, module_id, subject_level_dataset_name, lab_dataset_name,
    subjectid_var, arm_var, arm_default_vals, visit_var, baseline_visit_val, lb_test_var, lb_test_choices,
    lb_test_default_x_val, lb_test_default_y_val, lb_result_var, ref_range_upper_lim_var, warn, err) {
    OK <- logical(0)
    used_dataset_names <- new.env(parent = emptyenv())
    OK[["module_id"]] <- CM$check_module_id("module_id", module_id, warn, err)
    flags <- list(subject_level_dataset_name = TRUE)
    OK[["subject_level_dataset_name"]] <- CM$check_dataset_name("subject_level_dataset_name", subject_level_dataset_name,
        flags, datasets, used_dataset_names, warn, err)
    flags <- structure(list(), names = character(0))
    OK[["lab_dataset_name"]] <- CM$check_dataset_name("lab_dataset_name", lab_dataset_name, flags, datasets,
        used_dataset_names, warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- list(subjid_var = TRUE)
    OK[["subjectid_var"]] <- OK[["subject_level_dataset_name"]] && CM$check_dataset_colum_name("subjectid_var",
        subjectid_var, subkind, flags, subject_level_dataset_name, datasets[[subject_level_dataset_name]],
        warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- structure(list(), names = character(0))
    OK[["arm_var"]] <- OK[["subject_level_dataset_name"]] && CM$check_dataset_colum_name("arm_var", arm_var,
        subkind, flags, subject_level_dataset_name, datasets[[subject_level_dataset_name]], warn, err)
    flags <- list(one_or_more = TRUE, optional = TRUE)
    OK[["arm_default_vals"]] <- OK[["arm_var"]] && CM$check_choice_from_col_contents("arm_default_vals",
        arm_default_vals, flags, "subject_level_dataset_name", datasets[[subject_level_dataset_name]],
        arm_var, warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- structure(list(), names = character(0))
    OK[["visit_var"]] <- OK[["lab_dataset_name"]] && CM$check_dataset_colum_name("visit_var", visit_var,
        subkind, flags, lab_dataset_name, datasets[[lab_dataset_name]], warn, err)
    flags <- structure(list(), names = character(0))
    OK[["baseline_visit_val"]] <- OK[["visit_var"]] && CM$check_choice_from_col_contents("baseline_visit_val",
        baseline_visit_val, flags, "lab_dataset_name", datasets[[lab_dataset_name]], visit_var, warn,
        err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- structure(list(), names = character(0))
    OK[["lb_test_var"]] <- OK[["lab_dataset_name"]] && CM$check_dataset_colum_name("lb_test_var", lb_test_var,
        subkind, flags, lab_dataset_name, datasets[[lab_dataset_name]], warn, err)
    flags <- list(one_or_more = TRUE, optional = TRUE)
    OK[["lb_test_choices"]] <- OK[["lb_test_var"]] && CM$check_choice_from_col_contents("lb_test_choices",
        lb_test_choices, flags, "lab_dataset_name", datasets[[lab_dataset_name]], lb_test_var, warn,
        err)
    flags <- list(optional = TRUE)
    OK[["lb_test_default_x_val"]] <- OK[["lb_test_var"]] && CM$check_choice_from_col_contents("lb_test_default_x_val",
        lb_test_default_x_val, flags, "lab_dataset_name", datasets[[lab_dataset_name]], lb_test_var,
        warn, err)
    flags <- list(optional = TRUE)
    OK[["lb_test_default_y_val"]] <- OK[["lb_test_var"]] && CM$check_choice_from_col_contents("lb_test_default_y_val",
        lb_test_default_y_val, flags, "lab_dataset_name", datasets[[lab_dataset_name]], lb_test_var,
        warn, err)
    subkind <- list(kind = "or", options = list(list(kind = "numeric", min = NA, max = NA)))
    flags <- structure(list(), names = character(0))
    OK[["lb_result_var"]] <- OK[["lab_dataset_name"]] && CM$check_dataset_colum_name("lb_result_var",
        lb_result_var, subkind, flags, lab_dataset_name, datasets[[lab_dataset_name]], warn, err)
    subkind <- list(kind = "numeric", min = NA, max = NA)
    flags <- list(optional = TRUE)
    OK[["ref_range_upper_lim_var"]] <- OK[["lab_dataset_name"]] && CM$check_dataset_colum_name("ref_range_upper_lim_var",
        ref_range_upper_lim_var, subkind, flags, lab_dataset_name, datasets[[lab_dataset_name]], warn,
        err)
    for (ds_name in names(used_dataset_names)) {
        OK[["subjectid_var"]] <- OK[["subjectid_var"]] && CM$check_subjid_col(datasets, ds_name, get(ds_name),
            "subjectid_var", subjectid_var, warn, err)
    }
    return(OK)
}

})
# styler: on
