# Use a list to declare the specs

specs_list <- list

input_menu_specs <- specs_list(
  default_vals = specs_list(
    arm = "The input menu shows the pre-specified arm values at app launch.",
    param = "The input menu shows the pre-specified parameter values at app launch."
  )
)

plot_specs <- specs_list(
  data = "The plot displays the underlying data.",
  arm = "The plot displays data only of subjects corresponding to the selected arm(s).",
  arm_coloring = "The plot shows data coloring according to arm information.",
  param = "The plot displays data according to the parameter selection.",
  normalization = "The plot displays data normalized according to the selected method.",
  axis_labels = "The plot's axis are labelled according to the parameter selection and normalization method.",
  ref_lines = "The plot displays the specified reference lines.",
  hovering = "The plot shows details when hovering over a data point.",
  multiple_vals = "In case of multiple values per subject, visit, and lab test, only the maximum value should be shown."
)

framework_specs <- specs_list(
  bookmarking = "The app's state gets restored correctly after bookmarking."
)

specs <- specs_list(
  input_menu_specs = input_menu_specs,
  plot_specs = plot_specs,
  framework_specs = framework_specs
)
