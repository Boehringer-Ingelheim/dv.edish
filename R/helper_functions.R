utils::globalVariables(".")

#' Prepare initial data
#'
#' `prepare_initial_data()` prepares data initially by restructuring
#' and joining DM and LB dataset into one.
#'
#' @param dataset_list `[list(data.frame))]`
#'
#' A list of datasets, containing a Demographics and a Lab Value dataset.
#' @param subjectid_var `[character(1)]`
#'
#' Name of the variable containing the unique subject IDs.
#' @param arm_var `[character(1)]`
#'
#' Name of the variable containing the arm/treatment information.
#' @param visit_var `[character(1)]`
#'
#' Name of the variable containing the visit information.
#' @param lb_test_var `[character(1)]`
#'
#' Name of the variable containing the laboratory test information.
#' @param lb_test_choices `[character(1+)]`
#'
#' Character vector specifying the possible choices of the laboratory test.
#' @param lb_result_var `[character(1)]`
#'
#' Name of the variable containing results of the laboratory test.
#' @param ref_range_upper_lim_var `[character(1)]`
#'
#' Name of the variable containing the reference range upper limits.
#'
#' @return A single data frame including columns defined by `subjectid_var`,
#' `arm_var`, `visit_var`, `lb_test_var`, `lb_result_var`, and `ref_range_upper_lim_var`,
#' as well as the column "BASE" containing the corresponding baseline values.
#' In case of multiple values in `lb_result_var` per `subjectid_var`, `visit_var`, and
#' `lb_test_var`, only the maximum value will be used. Note that NA values will not be considered.
#'
#' @importFrom rlang .data
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

  return(combined_dataset)
}

#' Derive required variables for plotting
#'
#' @param dataset `[data.frame]`
#'
#' A data frame containing the data from `prepare_initial_data()`.
#' @param baseline_visit_val `[character(1)]`
#'
#' String indicating which visit should be used as baseline visit.
#' @param norm_ref_type `[character(1)]`
#'
#' String indicating normalization reference type, either `ULN` or `Baseline`.
#' @param window_days `[integer(1)]`
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
                            window_days) {

  # If window not specified then ensure all data are included in peak comparisons
  if (is.na(window_days)) window_days <- Inf

  #browser()
  ## !!! What if date is NA? Should such rows be dropped with warning?
  ## ! Need tests for this function
  ## ! Do not forget: POSIXct needs to be converted to Date

  ref_dataset <- dataset

  # Set either ULN or baseline as the reference value for normalization
  if (norm_ref_type == "ULN") {
    ref_dataset[[".ref_val"]] <- ref_dataset[[ref_range_upper_lim_var]]
  } else {
    # Process baseline data
    base_data <- ref_dataset[ref_dataset[[visit_var]] == baseline_visit_val, ]
    base_data[[".ref_val"]] <- base_data[[lb_result_var]]
    base_data <- base_data[, c(subjectid_var, arm_var, lb_test_var, ".ref_val")]

    # Merge on baseline values
    ref_dataset <- ref_dataset |>
      dplyr::left_join(base_data, by = c(subjectid_var, arm_var, lb_test_var))
  }

  # Normalize lab values
  ref_dataset[[".norm_val"]] <- ref_dataset[[lb_result_var]] / ref_dataset[[".ref_val"]]

  # Get peak values of post-baseline aminotransferase (AT) rows
  peak_at_data <- ref_dataset |>
    dplyr::filter(.data[[lb_test_var]] %in% at_choices,
                  .data[[visit_var]] != baseline_visit_val) |>
    dplyr::group_by(.data[[subjectid_var]], .data[[arm_var]], .data[[lb_test_var]]) |>
    dplyr::slice_max(.data[[lb_result_var]], with_ties = TRUE) |>
    dplyr::slice_min(.data[[lb_date_var]], n = 1, with_ties = FALSE) |>
    dplyr::ungroup() |>
    dplyr::select(subjectid_var, arm_var, lb_test_var,
                  .visit_at = "VISIT",
                  .date_at = dplyr::all_of(lb_date_var),
                  .norm_at = ".norm_val")

  # Get post-baseline total bilirubin (TBILI) rows
  tbili_data <- ref_dataset |>
    dplyr::filter(.data[[lb_test_var]] == tbili_choice,
                  .data[[visit_var]] != baseline_visit_val) |>
    dplyr::select(subjectid_var, arm_var,
                  .visit_tbili = "VISIT",
                  .date_tbili = dplyr::all_of(lb_date_var),
                  .norm_tbili = ".norm_val")

  # Merge TBILI rows with peak AT values, keeping only those with offset days within window
  xy_data <- peak_at_data |>
    dplyr::left_join(tbili_data, by = c(subjectid_var, arm_var)) |>
    dplyr::filter(!is.na(.data[[".norm_tbili"]])) |>
    dplyr::mutate(.offset_days = .data[[".date_tbili"]] - .data[[".date_at"]]) |>
    dplyr::filter(abs(.data[[".offset_days"]]) <= window_days)

  # Get peak TBILI values
  peak_xy_data <- xy_data |>
    dplyr::group_by(.data[[subjectid_var]], .data[[arm_var]], .data[[lb_test_var]]) |>
    dplyr::slice_max(.data[[".norm_tbili"]], with_ties = TRUE) |>
    dplyr::slice_min(.data[[".date_tbili"]], n = 1, with_ties = FALSE) |>
    dplyr::ungroup()

  # Get alkaline phosphatase (ALP) values
  alp_data <- ref_dataset |>
    dplyr::filter(.data[[lb_test_var]] == alp_choice) |>
    dplyr::select(subjectid_var, arm_var, visit_var, .norm_alp = ".norm_val")

  # Merge on ALP values occurring at same visit as AT values
  final_dataset <- peak_xy_data |>
    dplyr::left_join(alp_data, by = c(subjectid_var, arm_var, ".visit_at" = visit_var))

  # Set plot type
  final_dataset[[".norm_ref_type"]] <- norm_ref_type

  return(final_dataset)
}

#' Filter data
#'
#' `filter_data()` filters `dataset` to only contain the values of `sel_lb_test`
#' in the `lb_test_var` column and the values of `sel_arm` in the `arm_var` column.
#'
#' @param dataset `[data.frame]`
#'
#' A data frame containing the columns specified by `lb_test_var` and `arm_var`.
#' @param sel_arm `[character(1+)]`
#'
#' Character vector specifying a selection of arms/treatments.
#' @param sel_lb_test `[character(1+)]`
#'
#' Character vector specifying a selection of laboratory tests.
#'
#' @return A data frame.
#'
#' @inheritParams prepare_initial_data
#' @keywords internal
filter_data <- function(dataset, norm_ref_type, arm_var, sel_arm, lb_test_var, sel_lb_test) {
  dataset <- dataset |>
    dplyr::filter(
      .data[[".norm_ref_type"]] == norm_ref_type,
      .data[[lb_test_var]] == sel_lb_test,
      .data[[arm_var]] %in% sel_arm
    )
  return(dataset)
}

#' #' Identify data related to a single axis
#' #'
#' #' @return A data frame.
#' #'
#' #' @inheritParams prepare_initial_data
#' #' @keywords internal
#' identify_axis_data <- function(dataset, arm_var, visit_var, lb_test_var, lb_test, lb_date_var, lb_result_var,
#'                                ref_range_upper_lim_var, suffix) {
#'
#'   axis_data <- dataset |>
#'     dplyr::filter(.data[[lb_test_var]] == lb_test) |>
#'     dplyr::mutate(
#'       !!paste0("r_ULN_", suffix) := .data[[lb_result_var]] / .data[[ref_range_upper_lim_var]],
#'       !!paste0("r_Baseline_", suffix) := .data[[lb_result_var]] / .data[["BASE"]],
#'       !!paste0("BASE_", suffix) := .data[["BASE"]],
#'       !!paste0("BASEDT_", suffix) := .data[["BASEDT"]],
#'       !!paste0("VISIT_", suffix) := .data[[visit_var]],
#'       !!paste0("DATE_", suffix) := .data[[lb_date_var]],
#'       !!paste0("LBTEST_", suffix) := lb_test
#'     )
#'
#'   drop_vars <- c(visit_var, lb_test_var, lb_date_var, lb_result_var, ref_range_upper_lim_var, "BASE", "BASEDT")
#'   axis_data <- axis_data[, setdiff(names(axis_data), drop_vars)]
#'
#'   return(axis_data)
#' }

#' #' Derive required variables
#' #'
#' #' `derive_req_vars()` restructures the stated dataset to include variables containing
#' #' the ratio of a lab result divided by ULN or the baseline value. The corresponding variable
#' #' names are shaped as follows: "r_<ULN or Baseline>_<selected lab test>.
#' #'
#' #' @param dataset `[data.frame]`
#' #'
#' #' A data frame containing the variables listed below as columns.
#' #' @param subjectid_var `[character(1)]`
#' #'
#' #' Name of the variable containing the unique subject IDs.
#' #' @param arm_var `[character(1)]`
#' #'
#' #' Name of the variable containing the arm/treatment information.
#' #' @param visit_var `[character(1)]`
#' #'
#' #' Name of the variable containing the visit information.
#' #' @param lb_test_var `[character(1)]`
#' #'
#' #' Name of the variable containing the laboratory test information.
#' #' @param lb_result_var `[character(1)]`
#' #'
#' #' Name of the variable containing results of the laboratory test.
#' #' @param ref_range_upper_lim_var `[character(1)]`
#' #'
#' #' Name of the variable containing the reference range upper limits.
#' #' @param sel_x `[character(1)]`
#' #'
#' #' Character specifying the laboratory test selected for the x-axis.
#' #' @param sel_y `[character(1)]`
#' #'
#' #' Character specifying the laboratory test selected for the y-axis.
#' #'
#' #' @return The restructured dataset.
#' #'
#' #' @keywords internal
#' derive_req_vars <- function(
#'     dataset,
#'     subjectid_var,
#'     arm_var,
#'     visit_var,
#'     lb_test_var,
#'     lb_date_var,
#'     lb_result_var,
#'     ref_range_upper_lim_var,
#'     sel_x,
#'     sel_y) {
#'
#'   # the following check is needed in case global or local filter is used to deselect all
#'   if (is.null(dataset) || nrow(dataset) == 0) {
#'     return(NULL)
#'   }
#'
#'   dataset_x <- identify_axis_data(dataset, arm_var, visit_var, lb_test_var, sel_x, lb_date_var, lb_result_var,
#'                                   ref_range_upper_lim_var, "{{sel_x}}")
#'   dataset_y <- identify_axis_data(dataset, arm_var, visit_var, lb_test_var, sel_y, lb_date_var, lb_result_var,
#'                                   ref_range_upper_lim_var, "{{sel_y}}")
#'
#'   # Merge x-axis data with y-axis data dropping ALP/ULN and ALP/Baseline associated to y-axis
#'   merged_data <- dataset_x |>
#'     dplyr::full_join(dataset_y[, !names(dataset_y) %in% c("ALP_ULN", "ALP_Baseline")])
#'
#'   # # Get the data frame in required structure (Pivot wider grouped by certain variables)
#'   # dataset <- dataset %>%
#'   #   dplyr::filter(.data[[lb_test_var]] %in% c(sel_x, sel_y)) %>%
#'   #   dplyr::mutate(
#'   #     r_ULN = .data[[lb_result_var]] / .data[[ref_range_upper_lim_var]],
#'   #     r_Baseline = .data[[lb_result_var]] / .data[["BASE"]]
#'   #   ) %>%
#'   #   dplyr::select(dplyr::all_of(c(subjectid_var, arm_var, lb_test_var, visit_var, "r_ULN", "r_Baseline"))) %>%
#'   #   dplyr::group_by(.data[[subjectid_var]], .data[[arm_var]], .data[[lb_test_var]], .data[[visit_var]]) %>%
#'   #   dplyr::mutate(row = dplyr::row_number()) %>%
#'   #   tidyr::pivot_wider(names_from = tidyr::all_of(lb_test_var), values_from = c("r_ULN", "r_Baseline")) %>%
#'   #   dplyr::select(-dplyr::all_of("row")) %>%
#'   #   dplyr::mutate(
#'   #     "r_ULN_{{sel_x}}" = as.numeric(.data[[paste0("r_ULN_", sel_x)]]),
#'   #     "r_ULN_{{sel_y}}" = as.numeric(.data[[paste0("r_ULN_", sel_y)]]),
#'   #     "r_Baseline_{{sel_x}}" = as.numeric(.data[[paste0("r_Baseline_", sel_x)]]),
#'   #     "r_Baseline_{{sel_y}}" = as.numeric(.data[[paste0("r_Baseline_", sel_y)]])
#'   #   )
#'
#'   return(merged_data)
#' }



#' #' Generate plot
#' #'
#' #' `generate_plot()` generates an eDISH plot by means of the \pkg{plotly} package.
#' #'
#' #' @param dataset `[data.frame]`
#' #'
#' #' A data frame containing the variables listed below as columns.
#' #' @param subjectid_var `[character(1)]`
#' #'
#' #' Name of the variable containing the unique subject IDs.
#' #' @param arm_var `[character(1)]`
#' #'
#' #' Name of the variable containing the arm/treatment information.
#' #' @param visit_var `[character(1)]`
#' #'
#' #' Name of the variable containing the visit information.
#' #' @param sel_x `[character(1)]`
#' #'
#' #' Character specifying the laboratory test to be displayed on the x-axis.
#' #' @param sel_y `[character(1)]`
#' #'
#' #' Character specifying the laboratory test to be displayed on the y-axis.
#' #' @param x_plot_type `[character(1)]`
#' #'
#' #' Character specifying the plot type for the x-axis. This leads to
#' #' using the `dataset`'s column "r_<x_plot_type>_<x_sel>" for the x-values.
#' #' @param y_plot_type `[character(1)]`
#' #'
#' #' Character specifying the plot type for the y-axis. This leads to
#' #' using the `dataset`'s column "r_<y_plot_type>_<y_sel>" for the y-values.
#' #' @param x_ref_line_num `[numeric(1)]`
#' #'
#' #' Numeric specifying the reference line for the x-axis.
#' #' @param y_ref_line_num `[numeric(1)]`
#' #'
#' #' Numeric specifying the reference line for the y-axis.
#' #' @param x_rng_lower `[numeric(1)]`
#' #'
#' #' Numeric specifying the lower limit in the x-axis range.
#' #' @param x_rng_upper `[numeric(1)]`
#' #'
#' #' Numeric specifying the upper limit in the x-axis range.
#' #' @param y_rng_lower `[numeric(1)]`
#' #'
#' #' Numeric specifying the lower limit in the y-axis range.
#' #' @param y_rng_upper `[numeric(1)]`
#' #'
#' #' Numeric specifying the upper limit in the y-axis range.
#' #'
#' #' @return A plotly object specifying the generated eDISH plot.
#' #'
#' #' @keywords internal
#' generate_plot <- function(
#'     dataset,
#'     subjectid_var,
#'     arm_var,
#'     visit_var,
#'     sel_x,
#'     sel_y,
#'     # x_plot_type,
#'     # y_plot_type,
#'     plot_type,
#'     x_ref_line_num,
#'     y_ref_line_num,
#'     x_rng_lower,
#'     x_rng_upper,
#'     y_rng_lower,
#'     y_rng_upper,
#'     source = NULL) {
#'
#'   if (is.null(dataset)) {
#'     return(NULL)
#'   }
#'
#'   # Prepare x-axis layout based on whether range has been specified
#'   layout_xaxis <- list(title = paste0(sel_x, "/", plot_type), type = "log")
#'   if (!is.null(x_rng_lower) && !is.null(x_rng_upper)) {
#'     layout_xaxis <- c(layout_xaxis,
#'                       list(range = c(x_rng_lower, x_rng_upper)))
#'   }
#'
#'   # Prepare y-axis layout based on whether range has been specified
#'   layout_yaxis <- list(title = paste0(sel_y, "/", plot_type), type = "log")
#'   if (!is.null(y_rng_lower) && !is.null(y_rng_upper)) {
#'     layout_yaxis <- c(layout_yaxis,
#'                       list(range = c(y_rng_lower, y_rng_upper)))
#'   }
#'
#'   #browser()
#'
#'   dataset[["hover_date_x"]] <- gsub(
#'     "NA", "",
#'     paste0(dataset[["DATE_{{sel_x}}"]],
#'            ifelse(dataset[["DATE_{{sel_x}}"]] <= dataset[["DATE_{{sel_y}}"]],
#'                   " (1st)", " (2nd)"))
#'   )
#'
#'   dataset[["hover_date_y"]] <- gsub(
#'     "NA", "",
#'     paste0(dataset[["DATE_{{sel_y}}"]],
#'            ifelse(dataset[["DATE_{{sel_y}}"]] < dataset[["DATE_{{sel_x}}"]],
#'                   " (1st)", " (2nd)"))
#'   )
#'
#'   dataset[["hover_alp"]] <- gsub(
#'     "NA", "",
#'     paste(sprintf("%.3f", dataset[[paste0("ALP_", plot_type)]]),
#'           ifelse(dataset[[paste0("ALP_", plot_type)]] <= 2, " (<= 2)", " (> 2)"))
#'   )
#'
#'   plt_obj <- dataset %>%
#'     plotly::plot_ly(
#'       type = "scatter",
#'       mode = "markers",
#'       color = .[[arm_var]],
#'       key = .[[subjectid_var]],
#'       source = source
#'     ) %>%
#'     plotly::add_trace(
#'       x = ~ .data[[paste0("r_", plot_type, "_{{sel_x}}")]],
#'       y = ~ .data[[paste0("r_", plot_type, "_{{sel_y}}")]],
#'       hovertext = ~ paste0(
#'         "Subject: ", .data[[subjectid_var]],
#'         "<br>Arm: ", .data[[arm_var]],
#'         "<br>---<br>", .data[["LBTEST_{{sel_x}}"]], ": ", sprintf("%.3f", .data[[paste0("r_", plot_type, "_{{sel_x}}")]]),
#'         "<br>  Visit: ", .data[["VISIT_{{sel_x}}"]],
#'         "<br>  Date: ", .data[["hover_date_x"]],
#'         "<br>  ALP/", plot_type, ": ", .data[["hover_alp"]],
#'         "<br>---<br>", .data[["LBTEST_{{sel_y}}"]], ": ", sprintf("%.3f", .data[[paste0("r_", plot_type, "_{{sel_y}}")]]),
#'         "<br>  Visit: ", .data[["VISIT_{{sel_y}}"]],
#'         "<br>  Date: ", .data[["hover_date_y"]],
#'         "<br>---<br>Time between peaks: ", abs(.data[["DATE_{{sel_y}}"]] - .data[["DATE_{{sel_x}}"]]), " days"
#'       ),
#'       hoverinfo = "text"
#'     ) %>%
#'     plotly::layout(
#'       xaxis = layout_xaxis,
#'       yaxis = layout_yaxis,
#'       shapes = list(
#'         list( # vline
#'           type = "line",
#'           y0 = 0,
#'           y1 = 1,
#'           yref = "paper",
#'           x0 = x_ref_line_num,
#'           x1 = x_ref_line_num,
#'           line = list(color = "gray", dash = "dot")
#'         ),
#'         list( # hline
#'           type = "line",
#'           x0 = 0,
#'           x1 = 1,
#'           xref = "paper",
#'           y0 = y_ref_line_num,
#'           y1 = y_ref_line_num,
#'           line = list(color = "gray", dash = "dot")
#'         )
#'       )
#'     )
#'
#'   plotly::event_register(plt_obj, "plotly_click")
#'
#'   return(plt_obj)
#' }

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
                          y_rng_upper) {

  dataset[["hover_date_x"]] <- gsub(
    "NA", "",
    paste0(dataset[[".date_at"]],
           ifelse(dataset[[".date_at"]] <= dataset[[".date_tbili"]],
                  " (1st)", " (2nd)"))
  )

  dataset[["hover_date_y"]] <- gsub(
    "NA", "",
    paste0(dataset[[".date_tbili"]],
           ifelse(dataset[[".date_tbili"]] < dataset[[".date_at"]],
                  " (1st)", " (2nd)"))
  )

  dataset[["hover_alp"]] <- gsub(
    "NA", "",
    paste(sprintf("%.3f", dataset[[".norm_alp"]]),
          ifelse(dataset[[".norm_alp"]] <= 2, " (<= 2)", " (> 2)"))
  )

  dataset[["tooltip"]] <- paste0(
    "Subject: ", dataset[[subjectid_var]],
    "<br>Arm: ", dataset[[arm_var]],
    "<br>---<br>", sel_x, ": ", sprintf("%.3f", dataset[[".norm_at"]]),
    "<br>  Visit: ", dataset[[".visit_at"]],
    "<br>  Date: ", dataset[["hover_date_x"]],
    "<br>  ALP/", norm_ref_type, ": ", dataset[["hover_alp"]],
    "<br>---<br>", sel_y, ": ", sprintf("%.3f", dataset[[".norm_tbili"]]),
    "<br>  Visit: ", dataset[[".visit_tbili"]],
    "<br>  Date: ", dataset[["hover_date_y"]],
    "<br>---<br>Time between peaks: ", dataset[[".offset_days"]], " days"
  )

  # Define log axis breaks
  exponents <-  -1:2   # adjust according to your axis range
  major_breaks <- unlist(lapply(exponents, function(k) (1:9) * 10^k))

  if (!is.null(x_rng_lower) && !is.null(x_rng_upper)) {
    #if (!is.null(x_rng_lower) && !is.null(x_rng_upper) && !is.na(x_rng_lower) && !is.na(x_rng_upper)) {
    x_limits <- c(x_rng_lower, x_rng_upper)
  } else {
    x_limits <- NULL
  }

  if (!is.null(y_rng_lower) && !is.null(y_rng_upper)) {
    #if (!is.null(y_rng_lower) && !is.null(y_rng_upper) && !is.na(y_rng_lower) && !is.na(y_rng_upper)) {
    y_limits <- c(y_rng_lower, y_rng_upper)
  } else {
    y_limits <- NULL
  }

  plt_obj <- dataset |>
    ggplot2::ggplot(ggplot2::aes(x = .data[[".norm_at"]],
                                 y = .data[[".norm_tbili"]],
                                 color = .data[[arm_var]],
                                 tooltip = .data[["tooltip"]])) +
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
    ggiraph::geom_point_interactive(ggplot2::aes(data_id = .data[[subjectid_var]]),
                                    size = 2,
                                    alpha = 0.8,
                                    stroke = 0) +
    ggplot2::labs(x = paste0(sel_x, "/", norm_ref_type),
                  y = paste0(sel_y, "/", norm_ref_type),
                  color = "") +
    ggplot2::theme_minimal(base_family = "Arial",
                           base_size = 9)

  plt_obj <- ggiraph::girafe(ggobj = plt_obj,
                             width_svg = 8,
                             height_svg = 5.33,
                             options = list(
                               ggiraph::opts_sizing(rescale = TRUE),
                               ggiraph::opts_hover(css = "stroke: blue; stroke-width: 1px; fill-opacity: 0.8;"),
                               ggiraph::opts_selection(type = "single", css = "stroke: black; stroke-width: 1px;")
                             ))

  return(plt_obj)
}
