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
#' @param baseline_visit_val `[character(1)]`
#'
#' Character indicating which visit should be used as baseline visit.
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
#' @return A single dataframe including columns defined by `subjectid_var`, 
#' `arm_var`, `visit_var`, `lb_test_var`, `lb_result_var`, and `ref_range_upper_lim_var`,
#' as well as the column "BASE" containing the corresponding baseline values. 
#' In case of multiple values in `lb_result_var` per `subjectid_var`, `visit_var`, and 
#' `lb_test_var`, only the maximum value will be used. Note that a NA value in the considered values
#' will cause a value of NA to be returned as maximum value.
#'
#' @importFrom rlang .data
#' @keywords internal
prepare_initial_data <- function(
    dataset_list, 
    subjectid_var, 
    arm_var, 
    visit_var, 
    baseline_visit_val,
    lb_test_var, 
    lb_test_choices, 
    lb_result_var, 
    ref_range_upper_lim_var
) {
  
  sel_dataset_list <- lapply(dataset_list, function(x) {
    x %>% 
      dplyr::select(
        dplyr::any_of(
          c(
            subjectid_var, 
            arm_var, 
            visit_var, 
            lb_test_var, 
            lb_result_var, 
            ref_range_upper_lim_var
          )
        )
      )
  })
  
  dataset <- Reduce(dplyr::full_join, sel_dataset_list) %>%
    dplyr::filter(.data[[lb_test_var]] %in% lb_test_choices) %>%
    dplyr::group_by(.data[[subjectid_var]], .data[[arm_var]], .data[[lb_test_var]], .data[[visit_var]]) %>%
    dplyr::filter(.data[[lb_result_var]] == max(.data[[lb_result_var]])) %>%
    dplyr::distinct() %>%
    dplyr::ungroup()
    
  base_data <- dataset %>%
    dplyr::filter(.data[[visit_var]] == baseline_visit_val) %>% 
    dplyr::mutate(BASE = .data[[lb_result_var]]) %>%
    dplyr::select(dplyr::all_of(c(subjectid_var, lb_test_var, arm_var, "BASE")))
  
  dataset <- dataset %>%
    dplyr::left_join(base_data, by = c(subjectid_var, lb_test_var, arm_var))
  
  return(dataset)
}



#' Filter data
#' 
#' `filter_data()` filters `dataset` to only contain the values of `sel_lb_test` 
#' in the `lb_test_var` column and the values of `sel_arm` in the `arm_var` column.
#'
#' @param dataset `[data.frame]` 
#' 
#' A dataframe containing the columns specified by `lb_test_var` and `arm_var`.
#' @param arm_var `[character(1)]`
#'
#' Name of the variable containing the arm/treatment information.
#' @param sel_arm `[character(1+)]`
#'
#' Character vector specifying a selection of arms/treatments.
#' @param lb_test_var `[character(1)]`
#'
#' Name of the variable containing the laboratory test information.
#' @param sel_lb_test `[character(1+)]`
#'
#' Character vector specifying a selection of laboratory tests.
#'
#' @return The filtered dataset.
#'
#' @keywords internal
filter_data <- function(dataset, arm_var, sel_arm, lb_test_var, sel_lb_test) { 
  dataset <- dataset %>%
    dplyr::filter(
      .data[[lb_test_var]] %in% sel_lb_test, 
      .data[[arm_var]] %in% sel_arm
    ) 
  
  return(dataset)
}



#' Derive required variables
#' 
#' `derive_req_vars()` restructures the stated dataset to include variables containing
#' the ratio of a lab result divided by ULN or the baseline value. The corresponding variable
#' names are shaped as follows: "r_<ULN or Baseline>_<selected lab test>.
#'
#' @param dataset `[data.frame]` 
#' 
#' A dataframe containing the variables listed below as columns.
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
#' @param lb_result_var `[character(1)]`
#'
#' Name of the variable containing results of the laboratory test.
#' @param ref_range_upper_lim_var `[character(1)]`
#'
#' Name of the variable containing the reference range upper limits.
#' @param sel_x `[character(1)]`
#'
#' Character specifying the laboratory test selected for the x-axis.
#' @param sel_y `[character(1)]`
#'
#' Character specifying the laboratory test selected for the y-axis.
#'
#' @return The restructured dataset.
#'
#' @keywords internal
derive_req_vars <- function(
    dataset, 
    subjectid_var, 
    arm_var, 
    visit_var, 
    lb_test_var, 
    lb_result_var, 
    ref_range_upper_lim_var, 
    sel_x, 
    sel_y
) {
  
  if (nrow(dataset) == 0) return(NULL)
  
  # Get the data-frame in required structure (Pivot wider grouped by certain variables)
  dataset <- dataset %>%
    dplyr::filter(.data[[lb_test_var]] %in% c(sel_x, sel_y)) %>%
    dplyr::mutate(
      r_ULN = .data[[lb_result_var]] / .data[[ref_range_upper_lim_var]],
      r_Baseline = .data[[lb_result_var]] / .data[["BASE"]]) %>% 
    dplyr::select(dplyr::all_of(c(subjectid_var, arm_var, lb_test_var, visit_var, "r_ULN", "r_Baseline"))) %>%
    dplyr::group_by(.data[[subjectid_var]], .data[[arm_var]], .data[[lb_test_var]], .data[[visit_var]]) %>%
    dplyr::mutate(row = dplyr::row_number()) %>%
    tidyr::pivot_wider(names_from = lb_test_var, values_from = c("r_ULN", "r_Baseline")) %>%
    dplyr::select(-dplyr::all_of("row")) %>%
    dplyr::mutate(
      "r_ULN_{{sel_x}}" = as.numeric(.data[[paste0("r_ULN_", sel_x)]]),
      "r_ULN_{{sel_y}}" = as.numeric(.data[[paste0("r_ULN_", sel_y)]]),
      "r_Baseline_{{sel_x}}" = as.numeric(.data[[paste0("r_Baseline_", sel_x)]]),
      "r_Baseline_{{sel_y}}" = as.numeric(.data[[paste0("r_Baseline_", sel_y)]])
    )
  
  return(dataset)
}



#' Generate plot
#' 
#' `generate_plot()` generates an eDISH plot by means of the \pkg{plotly} package.
#'
#' @param dataset `[data.frame]` 
#' 
#' A dataframe containing the variables listed below as columns.
#' @param subjectid_var `[character(1)]`
#'
#' Name of the variable containing the unique subject IDs.
#' @param arm_var `[character(1)]`
#'
#' Name of the variable containing the arm/treatment information.
#' @param visit_var `[character(1)]`
#'
#' Name of the variable containing the visit information.
#' @param sel_x `[character(1)]`
#'
#' Character specifying the laboratory test to be displayed on the x-axis.
#' @param sel_y `[character(1)]`
#'
#' Character specifying the laboratory test to be displayed on the y-axis.
#' @param x_plot_type `[character(1)]`
#'
#' Character specifying the plot type for the x-axis. This leads to 
#' using the `dataset`'s column "r_<x_plot_type>_<x_sel>" for the x-values.
#' @param y_plot_type `[character(1)]`
#'
#' Character specifying the plot type for the y-axis. This leads to 
#' using the `dataset`'s column "r_<y_plot_type>_<y_sel>" for the y-values.
#'
#' @return A plotly object specifying the generated eDISH plot.
#'
#' @keywords internal
generate_plot <- function(
    dataset, 
    subjectid_var, 
    arm_var, 
    visit_var, 
    sel_x, 
    sel_y, 
    x_plot_type, 
    y_plot_type, 
    x_ref_line_num, 
    y_ref_line_num
) {
  
  if (is.null(dataset)) return(dataset)
  
  plt_obj <- dataset %>%
    plotly::plot_ly(type = "scatter", mode = "markers", color = .[[arm_var]]) %>%
    plotly::add_trace(
      x = ~ .data[[paste0("r_", x_plot_type, "_", sel_x)]],
      y = ~ .data[[paste0("r_", y_plot_type, "_", sel_y)]],
      hovertext = ~ paste0(
        "Subject: ", .data[[subjectid_var]], 
        "<br>Arm: ", .data[[arm_var]], 
        "<br>Visit: ", .data[[visit_var]], 
        "<br>x-axis: ", round(.data[[paste0("r_", x_plot_type, "_", sel_x)]], digits = 3),
        "<br>y-axis: ", round(.data[[paste0("r_", y_plot_type, "_", sel_y)]], digits = 3)
      ),
      hoverinfo = "text"
    ) %>%
    plotly::layout(
      xaxis = list(title = paste0(sel_x, "/", x_plot_type)),
      yaxis = list(title = paste0(sel_y, "/", y_plot_type)),
      shapes = list(
        list( #vline
          type = "line", 
          y0 = 0, 
          y1 = 1, 
          yref = "paper", 
          x0 = x_ref_line_num, 
          x1 = x_ref_line_num,
          line = list(color = "gray", dash = "dot")
        ),
        list( #hline
          type = "line", 
          x0 = 0, 
          x1 = 1, 
          xref = "paper", 
          y0 = y_ref_line_num, 
          y1 = y_ref_line_num,
          line = list(color = "gray", dash = "dot")
        )
      )
    )
  
  return(plt_obj)
}
