# CONSTANTS ----
EDISH <- pack_of_constants(
  PLOT_OPTIONS_ID = "plot_options",
  PLOT_OPTIONS_LABEL = "Plot Options",
  ARM_ID = "arm_id",
  ARM_LABEL = "Select arms:",
  X_AXIS_HEADER = "Specify x-axis",
  Y_AXIS_HEADER = "Specify y-axis",
  X_AXIS_ID = "x_axis",
  AXIS_LABEL = "Parameter:",
  X_REF_ID = "x_ref",
  Y_REF_ID = "y_ref",
  REF_LABEL = "Threshold / Reference line:",
  X_RNG_ID = "x_rng",
  Y_RNG_ID = "y_rng",
  RNG_LABEL = "Range:",
  BY_VISIT_ID = "by_visit",
  BY_VISIT_LABEL = "By visit",
  BY_VISIT_INFO = "Aminotransferase values will be plotted for each visit",
  PLOT_TYPE_ID = "plot_type",
  PLOT_TYPE_LABEL = "Plot type:",
  PLOT_TYPE_CHOICES = c("eDISH (\u00d7 ULN)" = "ULN",
                        "mDISH (\u00d7 Baseline)" = "Baseline"),
  PLOT_ID = "plot",
  WINDOW_DAYS_ID = "window_days",
  WINDOW_DAYS_LABEL = "Max. days between peaks:",
  BASE_INCL_ID = "base_incl",
  BASE_INCL_LABEL = "Baseline inclusions:",
  BASE_INCL_CHOICES = c("All" = "ALL",
                        "Baseline within threshold" = "LO",
                        "Baseline exceeds threshold" = "HI")
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
#' @inheritParams mod_edish
#'
#' @seealso [mod_edish()] and [edish_server()]
#' @export
edish_UI <- function(module_id,
                     arm_default_vals,
                     at_choices,
                     at_default_val,
                     tbili_choice,
                     default_by_visit,
                     window_days) {

  ns <- shiny::NS(module_id)

  drop_menu <- shinyWidgets::dropMenu(
    tag = shiny::actionButton(
      inputId = ns(EDISH$PLOT_OPTIONS_ID),
      label = EDISH$PLOT_OPTIONS_LABEL,
      icon = shiny::icon("gear")
    ),
    shiny::radioButtons(
      inputId = ns(EDISH$PLOT_TYPE_ID),
      label = EDISH$PLOT_TYPE_LABEL,
      choices = EDISH$PLOT_TYPE_CHOICES
    ),
    shiny::selectInput(
      inputId = ns(EDISH$ARM_ID),
      label = EDISH$ARM_LABEL,
      choices = arm_default_vals,
      selected = arm_default_vals,
      multiple = TRUE
    ),
    shiny::hr(),
    shiny::fluidRow(
      shiny::column(
        6,
        shiny::div(
          shiny::h4(EDISH$X_AXIS_HEADER),
          shiny::checkboxInput(
            ns(EDISH$BY_VISIT_ID),
            label = shiny::span(EDISH$BY_VISIT_LABEL,
                                shiny::icon("circle-info",
                                            title = EDISH$BY_VISIT_INFO)),
            value = default_by_visit
          ),
          shiny::selectInput(
            inputId = ns(EDISH$X_AXIS_ID),
            label = EDISH$AXIS_LABEL,
            choices = at_choices,
            selected = at_default_val
          ),
          shiny::numericInput(
            inputId = ns(EDISH$X_REF_ID),
            label = EDISH$REF_LABEL,
            value = 3,
            min = 0,
            max = 100,
            step = 0.5
          ),
          shinyWidgets::numericRangeInput(
            inputId = ns(EDISH$X_RNG_ID),
            label = EDISH$RNG_LABEL,
            value = c(NA, NA),
            min = 0,
            max = 100,
            step = 0.1
          ),
          shiny::radioButtons(
            inputId = ns(EDISH$BASE_INCL_ID),
            label = EDISH$BASE_INCL_LABEL,
            choices = EDISH$BASE_INCL_CHOICES
          ),
          style = "border: 1px solid grey; padding-left: 15px; padding-right: 15px"
        ),
        style = "padding-left: 10px; padding-right: 5px"
      ),
      shiny::column(
        6,
        shiny::div(
          shiny::h4(EDISH$Y_AXIS_HEADER),
          shiny::numericInput(
            inputId = ns(EDISH$Y_REF_ID),
            label = EDISH$REF_LABEL,
            value = 2,
            min = 0,
            max = 100,
            step = 0.5
          ),
          shinyWidgets::numericRangeInput(
            inputId = ns(EDISH$Y_RNG_ID),
            label = EDISH$RNG_LABEL,
            value = c(NA, NA),
            min = 0,
            max = 100,
            step = 0.1
          ),
          style = "border: 1px solid grey; padding-left: 15px; padding-right: 15px"
        ),
        style = "padding-left: 5px; padding-right: 10px"
      )
    ),
    shiny::hr(),
    shiny::numericInput(
      inputId = ns(EDISH$WINDOW_DAYS_ID),
      label = EDISH$WINDOW_DAYS_LABEL,
      value = window_days,
      min = 0,
      max = 100,
      step = 1
    ),
    style = "max-height: 85vh; overflow-y: auto; overflow-x: hidden; padding: 10px;"
  )

  ui <- shiny::tagList(
    drop_menu,
    gdtools::liberationsansHtmlDependency(),
    ggiraph::girafeOutput(outputId = ns(EDISH$PLOT_ID), width = "100%", height = "600px")
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
#'
#' @param dataset_list `[shiny::reactive(list(data.frame))]`
#'
#' A reactive list of named datasets.
#'
#' @param on_sbj_click `[function() | NULL]`
#'
#' Function to invoke when a subject is clicked on the plot. If `NULL`, no action is taken.
#'
#' @inheritParams mod_edish
#'
#' @return A reactive value containing the list of subjects in the clicked point, if applicable.
#'
#' @seealso [mod_edish()] and [edish_UI()]
#' @export
edish_server <- function(
    module_id,
    dataset_list,
    subjectid_var = "USUBJID",
    arm_var = "ACTARM",
    visit_var = "VISIT",
    baseline_visit_val = "VISIT 01",
    lb_test_var = "LBTEST",
    at_choices = NULL,
    tbili_choice = NULL,
    alp_choice = NULL,
    lb_date_var = NULL,
    lb_result_var = "LBSTRESN",
    ref_range_upper_lim_var = "LBSTNRHI",
    on_sbj_click = NULL) {

  ##### THESE CHECKS DO NOT GET REPORTED TO THE CONSOLE!!!!

  # Check validity of arguments
  ac <- checkmate::makeAssertCollection()
  checkmate::assert_multi_class(dataset_list, c("reactive", "shinymeta_reactive"), add = ac)
  checkmate::assert_string(subjectid_var, min.chars = 1, add = ac)
  checkmate::assert_string(arm_var, min.chars = 1, add = ac)
  checkmate::assert_string(visit_var, min.chars = 1, add = ac)
  checkmate::assert_string(baseline_visit_val, min.chars = 1, add = ac)
  checkmate::assert_string(lb_test_var, min.chars = 1, add = ac)
  checkmate::assert_character(at_choices, min.chars = 1, any.missing = FALSE, all.missing = FALSE,
                              unique = TRUE, min.len = 1, add = ac)
  checkmate::assert_string(tbili_choice, min.chars = 1, add = ac)
  checkmate::assert_string(alp_choice, min.chars = 1, null.ok = TRUE, add = ac)
  checkmate::assert_string(lb_date_var, min.chars = 1, add = ac)
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

    # Ensure font "Liberation Sans" is registered, so it can be used by {{ggiraph}}
    gdtools::register_liberationsans()

    # Disable baseline inclusions option for mDISH plot (only relevant to eDISH plot)
    shiny::observeEvent(input[[EDISH$PLOT_TYPE_ID]], {
      if (input[[EDISH$PLOT_TYPE_ID]] == "Baseline") {
        shinyjs::disable(EDISH$BASE_INCL_ID)
      } else {
        shinyjs::enable(EDISH$BASE_INCL_ID)
      }
    })

    # Ensure window is a positive integer
    shiny::observeEvent(input[[EDISH$WINDOW_DAYS_ID]], ignoreInit = TRUE, {
      window_val <- input[[EDISH$WINDOW_DAYS_ID]]

      if (!is.null(window_val) && !is.na(window_val)) {
        new_val <- abs(as.integer(window_val))

        if (!identical(new_val, window_val)) {
          shiny::updateNumericInput(session, EDISH$WINDOW_DAYS_ID, value = new_val)
        }
      }
    })

    work_data <- shiny::reactive({

      # Wait for processing that converts window days from float to integer
      shiny::req(checkmate::test_integer(input[[EDISH$WINDOW_DAYS_ID]]))

      init_data <- prepare_initial_data(
        dataset_list = v_dataset_list(),
        subjectid_var = subjectid_var,
        arm_var = arm_var,
        visit_var = visit_var,
        lb_test_var = lb_test_var,
        at_choices = at_choices,
        tbili_choice = tbili_choice,
        alp_choice = alp_choice,
        lb_date_var = lb_date_var,
        lb_result_var = lb_result_var,
        ref_range_upper_lim_var = ref_range_upper_lim_var
      )

      ref_types <- c("ULN", "Baseline")

      do.call(rbind, lapply(ref_types, function(nrt) {
        derive_req_vars(
          dataset = init_data,
          subjectid_var = subjectid_var,
          arm_var = arm_var,
          visit_var = visit_var,
          baseline_visit_val = baseline_visit_val,
          lb_test_var = lb_test_var,
          at_choices = at_choices,
          tbili_choice = tbili_choice,
          norm_ref_type = nrt,
          alp_choice = alp_choice,
          lb_date_var = lb_date_var,
          lb_result_var = lb_result_var,
          ref_range_upper_lim_var = ref_range_upper_lim_var,
          by_visit = input[[EDISH$BY_VISIT_ID]],
          window_days = input[[EDISH$WINDOW_DAYS_ID]]
        )
      }))
    })

    # Storage for restored values from a bookmarked state
    r_values <- shiny::reactiveValues()

    # Store arm selections from restored bookmarked state, to be applied after work data has been created
    shiny::onRestore(function(state) {
      if (length(state$input) > 0) {
        r_values[[EDISH$ARM_ID]] <- state$input[[EDISH$ARM_ID]]
      }
    })

    # Update arm choices based on work data; if appropriate, apply selections from restored bookmarked state
    shiny::observeEvent(work_data(), {
      choices_arm <- levels(work_data()[[arm_var]])
      if (is.null(r_values[[EDISH$ARM_ID]])) {
        sel_arm <- input[[EDISH$ARM_ID]]
      } else {
        sel_arm <- r_values[[EDISH$ARM_ID]]
        r_values[[EDISH$ARM_ID]] <- NULL
      }

      shiny::updateSelectInput(inputId = EDISH$ARM_ID, choices = choices_arm, selected = sel_arm)
    })

    plot_data <- shiny::reactive({
      filtered_data <- filter_data(
        dataset = work_data(),
        norm_ref_type = input[[EDISH$PLOT_TYPE_ID]],
        arm_var = arm_var,
        sel_arm = input[[EDISH$ARM_ID]],
        lb_test_var = lb_test_var,
        sel_lb_test = input[[EDISH$X_AXIS_ID]],
        x_ref = input[[EDISH$X_REF_ID]],
        base_incl = input[[EDISH$BASE_INCL_ID]]
      )
    })

    output[[EDISH$PLOT_ID]] <- ggiraph::renderGirafe({
      shiny::validate(shiny::need(nrow(plot_data()) > 0, "No data available."))

      plt_obj <- generate_plot(
        dataset = plot_data(),
        subjectid_var = subjectid_var,
        arm_var = arm_var,
        sel_x = input[[EDISH$X_AXIS_ID]],
        sel_y = tbili_choice,
        norm_ref_type = input[[EDISH$PLOT_TYPE_ID]],
        x_ref_line_num = input[[EDISH$X_REF_ID]],
        y_ref_line_num = input[[EDISH$Y_REF_ID]],
        x_rng_lower = input[[EDISH$X_RNG_ID]][1],
        x_rng_upper = input[[EDISH$X_RNG_ID]][2],
        y_rng_lower = input[[EDISH$Y_RNG_ID]][1],
        y_rng_upper = input[[EDISH$Y_RNG_ID]][2],
        alp_flag = !is.null(alp_choice)
      )

      ggiraph::girafe(
        ggobj = plt_obj,
        width_svg = 8,
        height_svg = 5.33,
        options = list(
          ggiraph::opts_sizing(rescale = TRUE),
          ggiraph::opts_hover(css = "stroke: blue; stroke-width: 1px; fill-opacity: 0.8;"),
          ggiraph::opts_selection(type = "single", css = "stroke: black; stroke-width: 1px;")
        )
      )
    })

    # Jumping feature
    mod_return_value <- NULL
    if (!is.null(on_sbj_click)) {
      return_value_content <- shiny::eventReactive(input[[paste0(EDISH$PLOT_ID, "_selected")]], {
        on_sbj_click() # reactive side effect to be able to jump to another module
        input[[paste0(EDISH$PLOT_ID, "_selected")]]
      })
      mod_return_value <- list(
        subj_id = return_value_content
      )
    }

    return(mod_return_value)
  })
}

#' eDISH module
#'
#' `mod_edish()` displays the (modified) evaluation of Drug-Induced Serious Hepatotoxicity (eDISH/mDISH) plot
#' to support the assessment of drug-induced liver injury (DILI). The scatter plot depicts the correlation
#' between peak values of an aminotransferase parameter and total bilirubin on a subject level.
#'
#' @param module_id `[character(1)]`
#'
#' A unique module ID.
#'
#' @param subject_level_dataset_name `[character(1)]`
#'
#' Name of the subject-level dataset to be used.
#'
#' @param lab_dataset_name `[character(1)]`
#'
#' Name of the laboratory results dataset to be used.
#'
#' @param subjectid_var `[character(1)]`
#'
#' Name of the variable containing the unique subject IDs.
#'
#' @param arm_var `[character(1)]`
#'
#' Name of the variable containing the arm/treatment information.
#'
#' @param arm_default_vals `[character(1+) | NULL]`
#'
#' Vector specifying the default value(s) for the arm selector.
#'
#' @param visit_var `[character(1)]`
#'
#' Name of the variable containing the visit information.
#'
#' @param baseline_visit_val `[character(1)]`
#'
#' Character indicating which visit should be used as baseline visit.
#'
#' @param lb_test_var `[character(1)]`
#'
#' Name of the variable containing the laboratory test information.
#'
#' @param at_choices `[character(1+)]`
#'
#' Character vector specifying the possible choices of the x-axis aminotransferase laboratory test.
#'
#' @param at_default_val `[character(1)]`
#'
#' Character specifying the default x-axis aminotransferase laboratory test choice.
#'
#' @param tbili_choice `[character(1)]`
#'
#' Character vector specifying the y-axis total bilirubin laboratory test choice.
#'
#' @param alp_choice `[character(1) | NULL]`
#'
#' Character vector specifying the alkaline phosphatase laboratory test choice.
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
#' @param default_by_visit `[logical(1)]`
#'
#' A flag to indicate the default of whether or not to plot aminotransferase values for each visit.
#'
#' @param window_days `[integer(1) | NULL]`
#'
#' Window of the number of days considered between peaks.
#'
#' @param receiver_id `[character(1) | NULL]`
#'
#' Character string defining the ID of the module to which to send a subject ID. The
#' module must exist in the module list. The default is NULL which disables communication.
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
    at_choices = c("Alanine Aminotransferase", "Aspartate Aminotransferase"),
    at_default_val = "Aspartate Aminotransferase",
    tbili_choice = "Bilirubin",
    alp_choice = "Alkaline Phosphatase",
    lb_date_var = NULL,
    lb_result_var = "LBSTRESN",
    ref_range_upper_lim_var = "LBSTNRHI",
    default_by_visit = FALSE,
    window_days = NULL,
    receiver_id = NULL) {

  mod <- list(
    ui = function(module_id) {
      edish_UI(module_id = module_id,
               arm_default_vals = arm_default_vals,
               at_choices = at_choices,
               at_default_val = at_default_val,
               tbili_choice = tbili_choice,
               default_by_visit = default_by_visit,
               window_days = window_days)
    },
    server = function(afmm) {
      dataset_list <- shiny::reactive({
        afmm$filtered_dataset()[c(subject_level_dataset_name, lab_dataset_name)]
      })

      on_sbj_click_fun <- NULL
      if (!is.null(receiver_id)) {
        on_sbj_click_fun <- function() {
          if (!receiver_id %in% names(afmm[["module_names"]])) {
            shiny::showNotification(
              paste0("Can't find receiver module with ID ", receiver_id, "."),
              type = "message"
            )
          } else {
            afmm[["utils"]][["switch2mod"]](receiver_id)
          }
        }
      }

      edish_server(
        module_id = module_id,
        dataset_list = dataset_list,
        subjectid_var = subjectid_var,
        arm_var = arm_var,
        visit_var = visit_var,
        baseline_visit_val = baseline_visit_val,
        lb_test_var = lb_test_var,
        at_choices = at_choices,
        tbili_choice = tbili_choice,
        alp_choice = alp_choice,
        lb_date_var = lb_date_var,
        lb_result_var = lb_result_var,
        ref_range_upper_lim_var = ref_range_upper_lim_var,
        on_sbj_click = on_sbj_click_fun
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
  at_choices = list(""),
  at_default_val = list(""),
  tbili_choice = list(""),
  alp_choice = list(""),
  lb_date_var = list(""),
  lb_result_var = list(""),
  ref_range_upper_lim_var = list(""),
  default_by_visit = list(""),
  window_days = list(""),
  receiver_id = list("")
)

mod_edish_API_spec <- TC$group(
  module_id = TC$mod_ID(),
  subject_level_dataset_name = TC$dataset_name() |> TC$flag("subject_level_dataset_name"),
  lab_dataset_name = TC$dataset_name(),
  subjectid_var = TC$col("subject_level_dataset_name", TC$or(TC$character(), TC$factor())) |> TC$flag("subjid_var"),
  arm_var = TC$col("subject_level_dataset_name", TC$or(TC$character(), TC$factor())),
  arm_default_vals = TC$choice_from_col_contents("arm_var") |> TC$flag("one_or_more", "optional", "manual_check"),
  visit_var = TC$col("lab_dataset_name", TC$or(TC$character(), TC$factor())),
  baseline_visit_val = TC$choice_from_col_contents("visit_var"),
  lb_test_var = TC$col("lab_dataset_name", TC$or(TC$character(), TC$factor())),
  at_choices = TC$choice_from_col_contents("lb_test_var") |> TC$flag("one_or_more"),
  at_default_val = TC$choice_from_col_contents("lb_test_var") |> TC$flag("optional"),
  tbili_choice = TC$choice_from_col_contents("lb_test_var"),
  alp_choice = TC$choice_from_col_contents("lb_test_var") |> TC$flag("optional"),
  lb_date_var = TC$col("lab_dataset_name", TC$or(TC$date(), TC$datetime())),
  lb_result_var = TC$col("lab_dataset_name", TC$numeric()),
  ref_range_upper_lim_var = TC$col("lab_dataset_name", TC$numeric()) |> TC$flag("optional"),
  default_by_visit = TC$logical() |> TC$flag("manual_check"),
  window_days = TC$integer() |> TC$flag("optional", "manual_check"),
  receiver_id = TC$character() |> TC$flag("optional")
) |> TC$attach_docs(mod_edish_API_docs)

check_mod_edish <- function(
    afmm, datasets, module_id, subject_level_dataset_name, lab_dataset_name, subjectid_var, arm_var, arm_default_vals,
    visit_var, baseline_visit_val, lb_test_var,
    at_choices, at_default_val, tbili_choice, alp_choice,
    lb_date_var, lb_result_var, ref_range_upper_lim_var, default_by_visit, window_days, receiver_id
  ) {
  warn <- CM$container()
  err <- CM$container()

  OK <- check_mod_edish_auto(
    afmm, datasets,
    module_id, subject_level_dataset_name, lab_dataset_name, subjectid_var, arm_var, arm_default_vals,
    visit_var, baseline_visit_val, lb_test_var,
    at_choices, at_default_val, tbili_choice, alp_choice,
    lb_date_var, lb_result_var, ref_range_upper_lim_var, window_days, default_by_visit, receiver_id,
    warn, err
  )

  # Check only if `arm_default_vals` is a character vector
  # Reason: Arbitrary values allowed in case multiple studies are included with different arm values
  CM$assert(
    container = err,
    cond = checkmate::test_character(
      arm_default_vals,
      min.chars = 1, any.missing = FALSE,
      all.missing = FALSE, unique = TRUE,
      min.len = 1, null.ok = TRUE
    ),
    msg = sprintf(
      "The values assigned to `arm_default_vals` are of type %s, but must be of type character.",
      typeof(arm_default_vals)
    )
  )

  # Check that `default_by_visit` is a logical scalar
  CM$assert(
    container = err,
    cond = checkmate::test_logical(default_by_visit, len = 1, any.missing = FALSE, null.ok = FALSE),
    msg = sprintf(
      "The value assigned to `default_by_visit` must be a non-missing logical, either TRUE or FALSE."
    )
  )

  # Check that `window_days` is an integer scalar
  CM$assert(
    container = err,
    cond = checkmate::test_integerish(window_days, len = 1, any.missing = TRUE, null.ok = TRUE),
    msg = sprintf(
      "The value assigned to `window_days` is of type %s, but should be of type integer.",
      typeof(window_days)
    )
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
  if (all(OK[c("lab_dataset_name", "lb_test_var", "at_choices", "at_default_val")])) {
    CM$assert(
      container = err,
      cond = at_default_val %in% at_choices,
      msg = sprintf(
        'The value assigned to `at_default_val` ("%s") should be among the ones provided by `at_choices` (%s).',
        at_default_val, paste(sprintf('"%s"', at_choices), collapse = ", ")
      )
    )
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
