# CONSTANTS ----
EDISH <- pack_of_constants(
  ARM_ID = "arm_id",
  ARM_LABEL = "Select arm:",
  X_AXIS_HEADER = "Specify x-axis",
  Y_AXIS_HEADER = "Specify y-axis",
  X_AXIS_ID = "x_axis",
  Y_AXIS_ID = "y_axis",
  AXIS_LABEL = "Parameter:",
  X_REF_ID = "x_ref",
  Y_REF_ID = "y_ref",
  REF_LABEL = "Reference line:",
  X_PLOT_TYPE_ID = "x_plot_type",
  Y_PLOT_TYPE_ID = "y_plot_type",
  PLOT_TYPE_CHOICES = c("x ULN (eDISH)", "x Baseline (mDISH)"),
  PLOT_ID = "plot",
  NO_PLOT = "noplot"
)


#' User Interface of the `dv.edish` module
#'
#' `edish_UI()` contains the UI of the `dv.edish` module.
#'
#' @param module_id `[character(1)]`
#'
#' A unique ID string to create a namespace. Must match the ID of `edish_server()`.
#'
#' @return A shiny \code{uiOutput} element.
#'
#' @seealso [mod_edish()] and [edish_server()]
#' @export
edish_UI <- function(module_id) {

  ns <- shiny::NS(module_id)

  ui <- shiny::tagList(
    shiny::sidebarLayout(
      shiny::sidebarPanel(
        width = 2,
        shiny::selectInput(
          inputId = ns(EDISH$ARM_ID),
          label = EDISH$ARM_LABEL,
          choices = NULL,
          multiple = TRUE
        ),
        shiny::hr(),
        shiny::h4(EDISH$X_AXIS_HEADER),
        shiny::selectInput(
          inputId = ns(EDISH$X_AXIS_ID),
          label = EDISH$AXIS_LABEL,
          choices = NULL
        ),
        shiny::numericInput(
          inputId = ns(EDISH$X_REF_ID),
          label = EDISH$REF_LABEL,
          value = 3,
          min = 0,
          max = 100,
          step = 0.5
        ),
        shiny::radioButtons(
          inputId = ns(EDISH$X_PLOT_TYPE_ID),
          label = NULL,
          choices = EDISH$PLOT_TYPE_CHOICES
        ),
        shiny::hr(),
        shiny::h4(EDISH$Y_AXIS_HEADER),
        shiny::selectInput(
          inputId = ns(EDISH$Y_AXIS_ID),
          label = EDISH$AXIS_LABEL,
          choices = NULL
        ),
        shiny::numericInput(
          inputId = ns(EDISH$Y_REF_ID),
          label = EDISH$REF_LABEL,
          value = 2,
          min = 0,
          max = 100,
          step = 0.5
        ),
        shiny::radioButtons(
          inputId = ns(EDISH$Y_PLOT_TYPE_ID),
          label = NULL,
          choices = EDISH$PLOT_TYPE_CHOICES
        )
      ),
      shiny::mainPanel(
        plotly::plotlyOutput(outputId = ns(EDISH$PLOT_ID)),
        shiny::plotOutput(outputId = ns(EDISH$NO_PLOT))
      )
    )
  )

  return(ui)
}

#' Server of the `dv.edish` module
#'
#' `edish_server()` contains the server of the `dv.edish` module.
#'
#' @param module_id `[character(1)]`
#'
#' A unique ID string to create a namespace. Must match the ID of `edish_UI()`.
#' @param dataset_list `[shiny::reactive(list(data.frame))]`
#'
#' A reactive list of named datasets.
#' @param subjectid_var `[character(1)]`
#'
#' Name of the variable containing the unique subject IDs.
#' @param arm_var `[character(1)]`
#'
#' Name of the variable containing the arm/treatment information.
#' @param arm_default_vals `[character(1+)]`
#'
#' Vector specifying the default value(s) for the arm selector.
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
#' @param lb_test_default_x_val `[character(1)]`
#'
#' Character specifying the default laboratory test choice for the plot's x-axis.
#' @param lb_test_default_y_val `[character(1)]`
#'
#' Character specifying the default laboratory test choice for the plot's y-axis.
#' @param lb_result_var `[character(1)]`
#'
#' Name of the variable containing results of the laboratory test.
#' @param ref_range_upper_lim_var `[character(1)]`
#'
#' Name of the variable containing the reference range upper limits.
#'
#' @seealso [mod_edish()] and [edish_UI()]
#' @export
edish_server <- function(
    module_id,
    dataset_list,
    subjectid_var = "USUBJID",
    arm_var = "ACTARM",
    arm_default_vals = NULL,
    visit_var = "VISIT",
    baseline_visit_val = "VISIT 01",
    lb_test_var = "LBTEST",
    lb_test_choices = c(
      "Alkaline Phosphatase",
      "Alanine Aminotransferase",
      "Aspartate Aminotransferase",
      "Bilirubin"
    ),
    lb_test_default_x_val = "Aspartate Aminotransferase",
    lb_test_default_y_val = "Bilirubin",
    lb_result_var = "LBSTRESN",
    ref_range_upper_lim_var = "LBSTNRHI") {
  # Check validity of arguments
  ac <- checkmate::makeAssertCollection()
  checkmate::assert_multi_class(dataset_list, c("reactive", "shinymeta_reactive"), add = ac)
  checkmate::assert_string(subjectid_var, min.chars = 1, add = ac)
  checkmate::assert_string(arm_var, min.chars = 1, add = ac)
  checkmate::assert_character(
    arm_default_vals,
    min.chars = 1,
    any.missing = FALSE,
    all.missing = FALSE,
    unique = TRUE,
    min.len = 1,
    null.ok = TRUE,
    add = ac
  )
  checkmate::assert_string(visit_var, min.chars = 1, add = ac)
  checkmate::assert_string(baseline_visit_val, min.chars = 1, add = ac)
  checkmate::assert_string(lb_test_var, min.chars = 1, add = ac)
  checkmate::assert_character(
    lb_test_choices,
    min.chars = 1,
    any.missing = FALSE,
    all.missing = FALSE,
    unique = TRUE,
    min.len = 1,
    add = ac
  )
  checkmate::assert_string(lb_test_default_x_val, min.chars = 1, add = ac)
  checkmate::assert_string(lb_test_default_y_val, min.chars = 1, add = ac)
  checkmate::assert_string(lb_result_var, min.chars = 1, add = ac)
  checkmate::assert_string(ref_range_upper_lim_var, min.chars = 1, add = ac)
  checkmate::reportAssertions(ac)


  # Initiate module server
  shiny::moduleServer(module_id, function(input, output, session) {
    # Dataset validation
    v_dataset_list <- shiny::reactive({
      checkmate::assert_list(dataset_list(), types = "data.frame", null.ok = TRUE, names = "named")
      dataset_list()
    })

    work_data <- shiny::reactive({
      prepare_initial_data(
        dataset_list = v_dataset_list(),
        subjectid_var = subjectid_var,
        arm_var = arm_var,
        visit_var = visit_var,
        baseline_visit_val = baseline_visit_val,
        lb_test_var = lb_test_var,
        lb_test_choices = lb_test_choices,
        lb_result_var = lb_result_var,
        ref_range_upper_lim_var = ref_range_upper_lim_var
      )
    })

    # Store default values as reactive values in order to restore them correctly after bookmarking
    r_values <- shiny::reactiveValues(
      x_axis = lb_test_default_x_val,
      y_axis = lb_test_default_y_val,
      arm_id = arm_default_vals
    )

    # To make bookmarking work also for r_values
    shiny::onRestore(function(state) {
      if (length(state$input) > 0) { # makes sure that the default_vars are displayed at app launch with SSO
        r_values$x_axis <- state$input$x_axis
        r_values$y_axis <- state$input$y_axis
        r_values$arm_id <- state$input$arm_id
      }
    })

    shiny::observeEvent(work_data(), {
      choices_lb_test <- unique(stats::na.omit(work_data()[[lb_test_var]]))
      choices_arm <- unique(stats::na.omit(work_data()[[arm_var]]))
      sel_arm <- if (is.null(r_values$arm_id)) choices_arm else r_values$arm_id

      shiny::updateSelectInput(inputId = EDISH$X_AXIS_ID, choices = choices_lb_test, selected = r_values$x_axis)
      shiny::updateSelectInput(inputId = EDISH$Y_AXIS_ID, choices = choices_lb_test, selected = r_values$y_axis)
      shiny::updateSelectInput(inputId = EDISH$ARM_ID, choices = choices_arm, selected = sel_arm)
    })

    plot_data <- shiny::reactive({
      filtered_data <- filter_data(
        dataset = work_data(),
        arm_var = arm_var,
        sel_arm = input[[EDISH$ARM_ID]],
        lb_test_var = lb_test_var,
        sel_lb_test = c(input[[EDISH$X_AXIS_ID]], input[[EDISH$Y_AXIS_ID]])
      )

      derive_req_vars(
        dataset = filtered_data,
        subjectid_var = subjectid_var,
        arm_var = arm_var,
        visit_var = visit_var,
        lb_test_var = lb_test_var,
        lb_result_var = lb_result_var,
        ref_range_upper_lim_var = ref_range_upper_lim_var,
        sel_x = shiny::req(input[[EDISH$X_AXIS_ID]]),
        sel_y = shiny::req(input[[EDISH$Y_AXIS_ID]])
      )
    })

    output[[EDISH$PLOT_ID]] <- plotly::renderPlotly(
      generate_plot(
        dataset = plot_data(),
        subjectid_var = subjectid_var, arm_var = arm_var, visit_var = visit_var,
        sel_x = input[[EDISH$X_AXIS_ID]], sel_y = input[[EDISH$Y_AXIS_ID]],
        x_plot_type = ifelse(grepl("eDISH", input[[EDISH$X_PLOT_TYPE_ID]]), "ULN", "Baseline"),
        y_plot_type = ifelse(grepl("eDISH", input[[EDISH$Y_PLOT_TYPE_ID]]), "ULN", "Baseline"),
        x_ref_line_num = input[[EDISH$X_REF_ID]], y_ref_line_num = input[[EDISH$Y_REF_ID]]
      )
    )

    output[[EDISH$NO_PLOT]] <- shiny::renderPlot({
      if (is.null(plot_data())) {
        shiny::validate(shiny::need(!is.null(plot_data()), "No data available."))
      }
    })
  })
}

#' eDISH module
#'
#' `mod_edish()` displays the (modified) evaluation of Drug-Induced Serious Hepatotoxicity (eDISH/mDISH) plot
#' to support the assessment of drug-induced liver injury (DILI).
#'
#' @param module_id `[character(1)]`
#'
#' A unique module ID.
#' @param subject_level_dataset_name,lab_dataset_name `[character(1)]`
#'
#' Name(s) of the dataset(s) that will be displayed.
#' @param subjectid_var `[character(1)]`
#'
#' Name of the variable containing the unique subject IDs. Defaults to `"USUBJID"`.
#' @param arm_var `[character(1)]`
#'
#' Name of the variable containing the arm/treatment information. Defaults to `"ACTARM"`.
#' @param arm_default_vals `[character(1+)]`
#'
#' Vector specifying the default value(s) for the arm selector. Defaults to `NULL`.
#' @param visit_var `[character(1)]`
#'
#' Name of the variable containing the visit information. Defaults to `"VISIT"`.
#' @param baseline_visit_val `[character(1)]`
#'
#' Character indicating which visit should be used as baseline visit. Defaults to `"VISIT 01"`.
#' @param lb_test_var `[character(1)]`
#'
#' Name of the variable containing the laboratory test information. Defaults to `"LBTEST"`.
#' @param lb_test_choices `[character(1+)]`
#'
#' Character vector specifying the possible choices of the laboratory test. Defaults to
#' `c("Alkaline Phosphatase", "Alanine Aminotransferase", "Aspartate Aminotransferase", "Bilirubin")`
#' @param lb_test_default_x_val `[character(1)]`
#'
#' Character specifying the default laboratory test choice for the plot's x-axis.
#' Defaults to `"Aspartate Aminotransferase"`.
#' @param lb_test_default_y_val `[character(1)]`
#'
#' Character specifying the default laboratory test choice for the plot's y-axis.
#' Defaults to `"Bilirubin"`.
#' @param lb_result_var `[character(1)]`
#'
#' Name of the variable containing results of the laboratory test. Defaults to `"LBSTRESN"`.
#' In case of multiple values in `lb_result_var` per `subjectid_var`, `visit_var`, and
#' `lb_test_var`, only the maximum value will be used. Note that a NA value in the considered values
#' will cause a value of NA to be returned as maximum value.
#' @param ref_range_upper_lim_var `[character(1)]`
#'
#' Name of the variable containing the reference range upper limits.
#' Defaults to `"LBSTNRHI"`.
#'
#' @return A list containing the following elements to be used by the
#' \pkg{dv.manager}:
#' \itemize{
#' \item{\code{ui}: A UI function of the \pkg{dv.edish} module.}
#' \item{\code{server}: A server function of the \pkg{dv.edish} module.}
#' \item{\code{module_id}: A unique identifier.}
#' }
#'
#' @export
mod_edish <- function(
    module_id,
    subject_level_dataset_name,
    lab_dataset_name,
    subjectid_var = "USUBJID",
    arm_var = "ACTARM",
    arm_default_vals = NULL,
    visit_var = "VISIT",
    baseline_visit_val = "VISIT 01",
    lb_test_var = "LBTEST",
    lb_test_choices = c(
      "Alkaline Phosphatase",
      "Alanine Aminotransferase",
      "Aspartate Aminotransferase",
      "Bilirubin"
    ),
    lb_test_default_x_val = "Aspartate Aminotransferase",
    lb_test_default_y_val = "Bilirubin",
    lb_result_var = "LBSTRESN",
    ref_range_upper_lim_var = "LBSTNRHI") {

  mod <- list(
    ui = function(module_id) {
      edish_UI(module_id = module_id)
    },
    server = function(afmm) {
      dataset_list <- shiny::reactive({
        afmm$filtered_dataset()[c(subject_level_dataset_name, lab_dataset_name)]
      })

      edish_server(
        module_id = module_id,
        dataset_list = dataset_list,
        subjectid_var = subjectid_var,
        arm_var = arm_var,
        arm_default_vals = arm_default_vals,
        visit_var = visit_var,
        baseline_visit_val = baseline_visit_val,
        lb_test_var = lb_test_var,
        lb_test_choices = lb_test_choices,
        lb_test_default_x_val = lb_test_default_x_val,
        lb_test_default_y_val = lb_test_default_y_val,
        lb_result_var = lb_result_var,
        ref_range_upper_lim_var = ref_range_upper_lim_var
      )
    },
    module_id = module_id
  )

  return(mod)
}

# EDISH module interface description ----
# TODO: Fill in
mod_edish_API_docs <- list(
  "Edish",
  module_id = list(""),
  subject_level_dataset_name = list(""),
  lab_dataset_name = list(""),
  subjectid_var = list(""),
  arm_var = list(""),
  arm_default_vals = list(""),
  visit_var = list(""),
  baseline_visit_val = list(""),
  lb_test_var = list(""),
  lb_test_choices = list(""),
  lb_test_default_x_val = list(""),
  lb_test_default_y_val = list(""),
  lb_result_var = list(""),
  ref_range_upper_lim_var = list("")
)

mod_edish_API_spec <- TC$group(
  module_id = TC$mod_ID(),
  subject_level_dataset_name = TC$dataset_name() |> TC$flag("subject_level_dataset_name"),
  lab_dataset_name = TC$dataset_name(),
  subjectid_var = TC$col("subject_level_dataset_name", TC$or(TC$character(), TC$factor())) |> TC$flag("subjid_var"),
  arm_var = TC$col("subject_level_dataset_name", TC$or(TC$character(), TC$factor())),
  arm_default_vals = TC$choice_from_col_contents("arm_var") |> TC$flag("one_or_more", "optional"),
  visit_var = TC$col("lab_dataset_name", TC$or(TC$character(), TC$factor())),
  baseline_visit_val = TC$choice_from_col_contents("visit_var"),
  lb_test_var = TC$col("lab_dataset_name", TC$or(TC$character(), TC$factor())),
  lb_test_choices = TC$choice_from_col_contents("lb_test_var") |> TC$flag("one_or_more", "optional"),
  lb_test_default_x_val = TC$choice_from_col_contents("lb_test_var") |> TC$flag("optional"),
  lb_test_default_y_val = TC$choice_from_col_contents("lb_test_var") |> TC$flag("optional"),
  lb_result_var = TC$col("lab_dataset_name", TC$or(TC$numeric())),
  ref_range_upper_lim_var = TC$col("lab_dataset_name", TC$numeric()) |> TC$flag("optional")
) |> TC$attach_docs(mod_edish_API_docs)

check_mod_edish <- function(
    afmm, datasets, module_id, subject_level_dataset_name, lab_dataset_name, subjectid_var, arm_var, arm_default_vals, 
    visit_var, baseline_visit_val, lb_test_var, lb_test_choices, lb_test_default_x_val, lb_test_default_y_val, 
    lb_result_var, ref_range_upper_lim_var
  ) {
  warn <- CM$container()
  err <- CM$container()
  
  OK <- check_mod_edish_auto(
    afmm, datasets, 
    module_id, subject_level_dataset_name, lab_dataset_name, subjectid_var, arm_var, arm_default_vals, 
    visit_var, baseline_visit_val, lb_test_var, lb_test_choices, lb_test_default_x_val, lb_test_default_y_val, 
    lb_result_var, ref_range_upper_lim_var,
    warn, err
  )
 
  # NOTE: Prevents dplyr from exploding inside `prepare_initial_data`
  var_parameters <- c("subjectid_var", "arm_var", "visit_var", "lb_test_var", "lb_result_var")
  if (all(OK[var_parameters])) {
    all_vars <- c(subjectid_var, arm_var, visit_var, lb_test_var, lb_result_var)
    CM$assert(
      container = err, 
      cond = !any(duplicated(all_vars)),
      msg = sprintf(
        "This modules expects the following variables to refer to unique columns:<br><pre>%s</pre>",
        paste(capture.output(setNames(all_vars, var_parameters)), collapse = "\n")
      )
    )
  }

  # NOTE: Ensures that `lb_test_default_{x,y}_val` are a subset of the available `lb_test_choices`
  if (all(OK[c("lab_dataset_name", "lb_test_var", "lb_test_choices", "lb_test_default_x_val")])) {
    if (OK["lb_test_default_x_val"]) {
      CM$assert(
        container = err,
        cond = lb_test_default_x_val %in% lb_test_choices,
        msg = sprintf(
          'The value assigned to `lb_test_default_x_val` ("%s") should be among the ones provided by `lb_test_choices` (%s).',
          lb_test_default_x_val, paste(sprintf('"%s"', lb_test_choices), collapse = ", ")
        )
      )
    }
    if (OK["lb_test_default_y_val"]) {
      CM$assert(
        container = err,
        cond = lb_test_default_y_val %in% lb_test_choices,
        msg = sprintf(
          'The value assigned to `lb_test_default_y_val` ("%s") should be among the ones provided by `lb_test_choices` (%s).',
          lb_test_default_y_val, paste(sprintf('"%s"', lb_test_choices), collapse = ", ")
        )
      )
    }
  }
  
  res <- list(warnings = warn[["messages"]], errors = err[["messages"]])
  return(res)
}

dataset_info_edish <- function(subject_level_dataset_name, lab_dataset_name, ...) {
  # TODO: Replace this function with a generic one that builds the list based on mod_edish_API_spec.
  # Something along the lines of CM$dataset_info(mod_boxplot_API_spec, args = match.call())
  return(
    list(
      all = unique(c(subject_level_dataset_name, lab_dataset_name)),
      subject_level = subject_level_dataset_name
    )
  )
}

mod_edish <- CM$module(mod_edish, check_mod_edish, dataset_info_edish)
