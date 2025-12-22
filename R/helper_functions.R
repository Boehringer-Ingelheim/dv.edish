#' Prepare initial data
#'
#' Join DM and LB datasets into one, and filter on specified laboratory test
#' parameters, and maximum values for each subject/arm/test/visit group.
#'
#' @param dataset_list `[list(data.frame))]`
#'
#' A list of datasets, containing a Demographics and a Lab Value dataset.
#'
#' @param subjectid_var `[character(1)]`
#'
#' Name of the variable containing the unique subject IDs.
#'
#' @param arm_var `[character(1)]`
#'
#' Name of the variable containing the arm/treatment information.
#'
#' @param visit_var `[character(1)]`
#'
#' Name of the variable containing the visit information.
#'
#' @param lb_test_var `[character(1)]`
#'
#' Name of the variable containing the laboratory test parameter.
#'
#' @param at_choices `[character(1+)]`
#'
#' Character vector specifying the possible choices of the aminotransferase
#' laboratory test parameter for the x-axis.
#'
#' @param tbili_choice `[character(1)]`
#'
#' Character vector specifying the choice of the total bilirubin laboratory
#' test parameter for the y-axis.
#'
#' @param alp_choice `[character(1) | NULL]`
#'
#' Character vector specifying the choice of the alkaline phosphatase
#' laboratory test parameter.
#'
#' @param lb_date_var `[character(1)]`
#'
#' Name of the variable (`Date` or `POSIXt` class) containing the laboratory test date.
#'
#' @param lb_result_var `[character(1)]`
#'
#' Name of the variable containing results of the laboratory test.
#'
#' @param ref_range_upper_lim_var `[character(1)]`
#'
#' Name of the variable containing the reference range upper limits.
#'
#' @return A data frame with the variables specified by the function arguments,
#' `subjectid_var`, `arm_var`, `visit_var`, `lb_test_var`, `lb_date_var`,
#' `lb_result_var` and `ref_range_upper_lim_var`. Only rows for laboratory test
#' parameters specified by `at_choices`, `tbili_choice` and `alp_choice` are
#' kept.
#'
#' @keywords internal
prepare_initial_data <- function(dataset_list,
                                 subjectid_var,
                                 arm_var,
                                 visit_var,
                                 lb_test_var,
                                 at_choices,
                                 tbili_choice,
                                 alp_choice,
                                 lb_date_var,
                                 lb_result_var,
                                 ref_range_upper_lim_var) {

  ac <- checkmate::makeAssertCollection()
  checkmate::assert_string(subjectid_var, min.chars = 1, add = ac)
  checkmate::assert_string(arm_var, min.chars = 1, add = ac)
  checkmate::assert_string(visit_var, min.chars = 1, add = ac)
  checkmate::assert_string(lb_test_var, min.chars = 1, add = ac)
  checkmate::assert_character(at_choices, min.chars = 1, any.missing = FALSE, all.missing = FALSE,
                              unique = TRUE, min.len = 1, null.ok = FALSE, add = ac)
  checkmate::assert_string(tbili_choice, min.chars = 1, add = ac)
  checkmate::assert_string(alp_choice, min.chars = 1, null.ok = TRUE, add = ac)
  checkmate::assert_string(lb_date_var, min.chars = 1, add = ac)
  checkmate::assert_string(lb_result_var, min.chars = 1, add = ac)
  checkmate::assert_string(ref_range_upper_lim_var, min.chars = 1, add = ac)
  checkmate::reportAssertions(ac)

  # Keep only the necessary variables
  sel_dataset_list <- lapply(dataset_list, function(x) {
    vars <- c(
      subjectid_var,
      arm_var,
      visit_var,
      lb_test_var,
      lb_date_var,
      lb_result_var,
      ref_range_upper_lim_var
    )
    x[intersect(vars, names(x))]
  })

  # Join subject-level dataset with lab dataset keeping only max value at each visit
  combined_dataset <- Reduce(dplyr::full_join, sel_dataset_list) |>
    dplyr::filter(.data[[lb_test_var]] %in% c(at_choices, tbili_choice, alp_choice)) |>
    dplyr::group_by(.data[[subjectid_var]], .data[[arm_var]], .data[[lb_test_var]], .data[[visit_var]]) |>
    dplyr::filter(!all(is.na(.data[[lb_result_var]]))) |>  # Filter out groups with all NA to avoid warning
    dplyr::slice_max(.data[[lb_result_var]], n = 1, with_ties = FALSE) |>
    dplyr::ungroup()

  # Ensure lab date variable is converted to "Date" class
  combined_dataset[[lb_date_var]] <- as.Date(combined_dataset[[lb_date_var]])

  return(combined_dataset)
}

#' Derive required variables for plotting
#'
#' @param dataset `[data.frame]`
#'
#' A data frame containing the data from `prepare_initial_data()`.
#'
#' @param baseline_visit_val `[character(1)]`
#'
#' String indicating which visit should be used as baseline visit.
#'
#' @param norm_ref_type `[character(1)]`
#'
#' String indicating normalization reference type, either `"ULN"` or `"Baseline"`.
#'
#' @param by_visit `[logical(1)]`
#'
#' A flag to indicate whether to plot aminotransferase values for each visit.
#'
#' @param window_days `[integer(1) | NULL]`
#'
#' Window of the number of days considered between peaks.
#'
#' @return A data frame with the following derived variables:
#' - `.ref_val`: ULN or baseline as the reference value for normalization.
#' - `.visit_at`: Visit of peak aminotransferase value.
#' - `.date_at`: Date of peak aminotransferase value.
#' - `.norm_at`: Normalized peak aminotransferase value.
#' - `.visit_tbili`: Visit of peak total bilirubin value.
#' - `.date_tbili`: Date of peak total bilirubin value.
#' - `.norm_tbili`: Normalized peak total bilirubin value.
#' - `.norm_alp`: Normalized alkaline phosphotase value at same visit as aminotransferase value.
#' - `.offset_days`: Number of days from aminotransferase visit to total bilirubin visit.
#' - `.norm_ref_type`: Normalization reference type, copied from `norm_ref_type` argument.
#'
#' @inheritParams prepare_initial_data
#' @keywords internal
derive_req_vars <- function(dataset,
                            subjectid_var,
                            arm_var,
                            visit_var,
                            baseline_visit_val,
                            lb_test_var,
                            at_choices,
                            tbili_choice,
                            norm_ref_type,
                            alp_choice,
                            lb_date_var,
                            lb_result_var,
                            ref_range_upper_lim_var,
                            by_visit,
                            window_days) {

  ac <- checkmate::makeAssertCollection()
  checkmate::assert_string(subjectid_var, min.chars = 1, add = ac)
  checkmate::assert_string(arm_var, min.chars = 1, add = ac)
  checkmate::assert_string(visit_var, min.chars = 1, add = ac)
  checkmate::assert_string(baseline_visit_val, min.chars = 1, add = ac)
  checkmate::assert_string(lb_test_var, min.chars = 1, add = ac)
  checkmate::assert_character(at_choices, min.chars = 1, any.missing = FALSE, all.missing = FALSE,
                              unique = TRUE, min.len = 1, null.ok = FALSE, add = ac)
  checkmate::assert_string(tbili_choice, min.chars = 1, add = ac)
  checkmate::assert_string(norm_ref_type, min.chars = 1, add = ac)
  checkmate::assert_string(alp_choice, min.chars = 1, null.ok = TRUE, add = ac)
  checkmate::assert_string(lb_date_var, min.chars = 1, add = ac)
  checkmate::assert_string(lb_result_var, min.chars = 1, add = ac)
  checkmate::assert_string(ref_range_upper_lim_var, min.chars = 1, add = ac)
  checkmate::assert_logical(by_visit, len = 1, any.missing = FALSE, add = ac)
  checkmate::assert_integer(window_days, len = 1, any.missing = TRUE, null.ok = TRUE, add = ac)
  checkmate::reportAssertions(ac)

  # If window days not specified, then set as missing (NA)
  if (is.null(window_days)) window_days <- NA

  ref_dataset <- dataset

  # Process baseline data
  base_data <- ref_dataset |>
    dplyr::filter(.data[[visit_var]] == baseline_visit_val) |>
    dplyr::select(dplyr::all_of(c(subjectid_var, arm_var, lb_test_var)),
                  .base_val = dplyr::all_of(lb_result_var))

  # Merge on baseline values
  ref_dataset <- ref_dataset |>
    dplyr::left_join(base_data, by = c(subjectid_var, arm_var, lb_test_var))

  # Normalize lab values according to ULN or baseline reference values
  if (norm_ref_type == "ULN") {
    ref_dataset[[".norm_val"]] <- ref_dataset[[lb_result_var]] / ref_dataset[[ref_range_upper_lim_var]]
    ref_dataset[[".norm_base"]] <- ref_dataset[[".base_val"]] / ref_dataset[[ref_range_upper_lim_var]]
  } else {
    ref_dataset[[".norm_val"]] <- ref_dataset[[lb_result_var]] / ref_dataset[[".base_val"]]
    ref_dataset[[".norm_base"]] <- 1
  }

  # Initialise base group variables for calculating peak values
  base_group_vars <- c(subjectid_var, arm_var, lb_test_var)

  # Get peak values of post-baseline aminotransferase (AT) rows
  peak_at_data <- ref_dataset |>
    dplyr::filter(.data[[lb_test_var]] %in% at_choices,
                  .data[[visit_var]] != baseline_visit_val) |>
    dplyr::group_by(dplyr::across(dplyr::all_of(
      if (by_visit) c(base_group_vars, visit_var)
      else base_group_vars
    ))) |>
    dplyr::slice_max(.data[[lb_result_var]], with_ties = TRUE) |>
    dplyr::slice_min(.data[[lb_date_var]], n = 1, with_ties = FALSE) |>
    dplyr::ungroup() |>
    dplyr::select(dplyr::all_of(c(subjectid_var, arm_var, lb_test_var)),
                  .visit_at = dplyr::all_of(visit_var),
                  .date_at = dplyr::all_of(lb_date_var),
                  .norm_at = ".norm_val", ".norm_base")

  # Get post-baseline total bilirubin (TBILI) rows
  tbili_data <- ref_dataset |>
    dplyr::filter(.data[[lb_test_var]] == tbili_choice,
                  .data[[visit_var]] != baseline_visit_val) |>
    dplyr::select(dplyr::all_of(c(subjectid_var, arm_var)),
                  .visit_tbili = dplyr::all_of(visit_var),
                  .date_tbili = dplyr::all_of(lb_date_var),
                  .norm_tbili = ".norm_val")

  # Merge TBILI rows with peak AT values,
  xy_data <- peak_at_data |>
    dplyr::left_join(tbili_data, by = c(subjectid_var, arm_var), relationship = "many-to-many") |>
    dplyr::filter(!is.na(.data[[".norm_tbili"]]))

  # Calculate offset days
  xy_data[[".offset_days"]] <- as.integer(xy_data[[".date_tbili"]] - xy_data[[".date_at"]])

  # If window specified then keep only those rows with offset days within window
  if (!is.na(window_days)) {
    xy_data <- xy_data[abs(xy_data[[".offset_days"]]) <= window_days, ]
  }

  # Get peak TBILI values
  peak_xy_data <- xy_data |>
    dplyr::group_by(dplyr::across(dplyr::all_of(
      if (by_visit) c(base_group_vars, ".visit_at")
      else base_group_vars
    ))) |>
    dplyr::slice_max(.data[[".norm_tbili"]], with_ties = TRUE) |>
    dplyr::slice_min(.data[[".date_tbili"]], n = 1, with_ties = FALSE) |>
    dplyr::ungroup()

  # Get alkaline phosphatase (ALP) values
  alp_data <- ref_dataset |>
    dplyr::filter(if (!is.null(alp_choice)) .data[[lb_test_var]] == alp_choice
                  else FALSE) |>
    dplyr::select(dplyr::all_of(c(subjectid_var, arm_var, visit_var)), .norm_alp = ".norm_val")

  # Merge on ALP values occurring at same visit as AT values, and calculate R ratio
  final_dataset <- peak_xy_data |>
    dplyr::left_join(alp_data, by = c(subjectid_var, arm_var, ".visit_at" = visit_var)) |>
    dplyr::mutate(.r_ratio = .data[[".norm_at"]] / .data[[".norm_alp"]])

  # Set plot type
  final_dataset[[".norm_ref_type"]] <- norm_ref_type

  return(final_dataset)
}

#' Filter data prior to plotting
#'
#' Filter data on selected normalization reference type, arms/treatments and
#' aminotransferase laboratory test.
#'
#' @param dataset `[data.frame]`
#'
#' A data frame containing the columns specified by `lb_test_var` and `arm_var`.
#'
#' @param sel_arm `[character(1+)]`
#'
#' Character vector specifying a selection of arms/treatments.
#'
#' @param sel_lb_test `[character(1)]`
#'
#' String specifying a selected aminotransferase laboratory test.
#'
#' @param x_ref `[numeric(1)]`
#'
#' Numeric normalized x-axis threshold reference.
#'
#' @param base_incl `[character(1)]`
#'
#' String specifying the selected baseline inclusion choice, either `"LO"` (baseline within threshold),
#' `"HI"` (baseline exceeds threshold), or `"ALL"` (all).
#'
#' @return A data frame.
#'
#' @inheritParams prepare_initial_data
#' @inheritParams derive_req_vars
#'
#' @keywords internal
filter_data <- function(dataset,
                        norm_ref_type,
                        arm_var,
                        sel_arm,
                        lb_test_var,
                        sel_lb_test,
                        x_ref,
                        base_incl) {

  ac <- checkmate::makeAssertCollection()
  checkmate::assert_string(norm_ref_type, min.chars = 1, add = ac)
  checkmate::assert_string(arm_var, min.chars = 1, add = ac)
  checkmate::assert_character(sel_arm, min.chars = 1, any.missing = FALSE, all.missing = FALSE,
                              unique = TRUE, min.len = 1, null.ok = TRUE, add = ac)
  checkmate::assert_string(lb_test_var, min.chars = 1, add = ac)
  checkmate::assert_string(sel_lb_test, min.chars = 1, add = ac)
  checkmate::assert_numeric(x_ref, len = 1, any.missing = TRUE, add = ac)
  checkmate::assert_string(base_incl, pattern = "LO|HI|ALL", add = ac)
  checkmate::reportAssertions(ac)

  dataset <- dataset |>
    dplyr::filter(.data[[".norm_ref_type"]] == norm_ref_type,
                  .data[[lb_test_var]] == sel_lb_test,
                  .data[[arm_var]] %in% sel_arm)

  # Apply baseline inclusions for ULN data
  if (norm_ref_type == "ULN") {
    if (base_incl == "LO") {
      dataset <- dataset[which(dataset[[".norm_base"]] <= x_ref), ]
    } else if (base_incl == "HI") {
      dataset <- dataset[which(dataset[[".norm_base"]] > x_ref), ]
    }
  }

  return(dataset)
}

#' Generate an eDISH plot
#'
#' @param dataset `[data.frame]`
#'
#' A data frame containing the variables listed below as columns.
#'
#' @param subjectid_var `[character(1)]`
#'
#' Name of the variable containing the unique subject IDs.
#'
#' @param arm_var `[character(1)]`
#'
#' Name of the variable containing the arm/treatment information.
#'
#' @param visit_var `[character(1)]`
#'
#' Name of the variable containing the visit information.
#'
#' @param sel_x `[character(1)]`
#'
#' String specifying the laboratory test to be displayed on the x-axis.
#'
#' @param sel_y `[character(1)]`
#'
#' String specifying the laboratory test to be displayed on the y-axis.
#'
#' @param norm_ref_type `[character(1)]`
#'
#' String indicating normalization reference type, either `"ULN"` or `"Baseline"`.
#'
#' @param x_ref_line_num `[numeric(1)]`
#'
#' Numeric specifying the reference line for the x-axis.
#'
#' @param y_ref_line_num `[numeric(1)]`
#'
#' Numeric specifying the reference line for the y-axis.
#'
#' @param x_rng_lower `[numeric(1) | NULL]`
#'
#' Numeric specifying the lower limit in the x-axis range.
#'
#' @param x_rng_upper `[numeric(1) | NULL]`
#'
#' Numeric specifying the upper limit in the x-axis range.
#'
#' @param y_rng_lower `[numeric(1) | NULL]`
#'
#' Numeric specifying the lower limit in the y-axis range.
#'
#' @param y_rng_upper `[numeric(1) | NULL]`
#'
#' Numeric specifying the upper limit in the y-axis range.
#'
#' @param alp_flag `[logical(1)]`
#'
#' Logical indicating if ALP data was requested.
#'
#' @return An object specifying the generated eDISH plot.
#'
#' @keywords internal
generate_plot <- function(dataset,
                          subjectid_var,
                          arm_var,
                          sel_x,
                          sel_y,
                          norm_ref_type,
                          x_ref_line_num,
                          y_ref_line_num,
                          x_rng_lower,
                          x_rng_upper,
                          y_rng_lower,
                          y_rng_upper,
                          alp_flag) {

  hover_date_x <- gsub("NA", "",
                       paste0(dataset[[".date_at"]],
                              ifelse(dataset[[".date_at"]] <= dataset[[".date_tbili"]],
                                     " (1st)", " (2nd)")))

  hover_date_y <- gsub("NA", "",
                       paste0(dataset[[".date_tbili"]],
                              ifelse(dataset[[".date_tbili"]] < dataset[[".date_at"]],
                                     " (1st)", " (2nd)")))

  if (alp_flag) {
    if (norm_ref_type == "ULN") {
      hover_alp <- sprintf("<br>  ALP/ULN %s (%.3f) %s (%.2f)",
                           ifelse(dataset[[".norm_alp"]] <= 2, "≤ 2", "> 2"),
                           dataset[[".norm_alp"]],
                           ifelse(dataset[[".r_ratio"]] <= 2, "R ≤ 2",
                                  ifelse(dataset[[".r_ratio"]] >= 5, "R ≥ 5", "2 < R < 5")),
                           dataset[[".r_ratio"]])
    } else {
      hover_alp <- sprintf("<br>  ALP/Baseline %s (%.3f)",
                           ifelse(dataset[[".norm_alp"]] <= 2, "≤ 2", "> 2"),
                           dataset[[".norm_alp"]])
    }
    hover_alp <- sub("(NA \\(NA\\) ?)+", "missing data", hover_alp)
  } else {
    hover_alp <- ""
  }

  hover_offset <- ifelse(!is.na(dataset[[".offset_days"]]),
                         paste(dataset[[".offset_days"]], "days"),
                         "missing dates")

  dataset[["tooltip"]] <- paste0(
    "Subject: ", dataset[[subjectid_var]],
    "<br>Arm: ", dataset[[arm_var]],
    "<br>---<br>", sel_x, ": ", sprintf("%.3f", dataset[[".norm_at"]]),
    "<br>  Visit: ", dataset[[".visit_at"]],
    "<br>  Date: ", hover_date_x,
    hover_alp,
    "<br>---<br>", sel_y, ": ", sprintf("%.3f", dataset[[".norm_tbili"]]),
    "<br>  Visit: ", dataset[[".visit_tbili"]],
    "<br>  Date: ", hover_date_y,
    "<br>---<br>Time between peaks: ", hover_offset
  )

  # Define log axis breaks
  exponents <- -1:2
  major_breaks <- unlist(lapply(exponents, function(k) (1:9) * 10^k))

  if (!is.null(x_rng_lower) && !is.null(x_rng_upper)) {
    x_limits <- c(max(x_rng_lower, 1e-3), x_rng_upper)
  } else {
    x_limits <- NULL
  }

  if (!is.null(y_rng_lower) && !is.null(y_rng_upper)) {
    y_limits <- c(max(y_rng_lower, 1e-3), y_rng_upper)
  } else {
    y_limits <- NULL
  }

  plt_obj <- dataset |>
    ggplot2::ggplot(ggplot2::aes(x = .data[[".norm_at"]],
                                 y = .data[[".norm_tbili"]],
                                 color = .data[[arm_var]])) +
    ggplot2::scale_x_log10(breaks = major_breaks,
                           minor_breaks = NULL,
                           labels = function(x) sub("\\.0$", "", x),
                           limits = x_limits) +
    ggplot2::scale_y_log10(breaks = major_breaks,
                           minor_breaks = NULL,
                           labels = function(x) sub("\\.0$", "", x),
                           limits = y_limits) +
    ggplot2::geom_vline(xintercept = x_ref_line_num,
                        color = "black",
                        linetype = "dotted") +
    ggplot2::geom_hline(yintercept = y_ref_line_num,
                        color = "black",
                        linetype = "dotted") +
    ggplot2::labs(x = paste0(sel_x, " (\u00d7 ", norm_ref_type, ")"),
                  y = paste0(sel_y, " (\u00d7 ", norm_ref_type, ")"),
                  color = "") +
    ggplot2::theme_minimal(base_family = "Liberation Sans",
                           base_size = 9) +
    ggiraph::geom_point_interactive(ggplot2::aes(tooltip = .data[["tooltip"]],
                                                 data_id = .data[[subjectid_var]]),
                                    size = 2,
                                    alpha = 0.8,
                                    stroke = 0)

  return(plt_obj)
}
