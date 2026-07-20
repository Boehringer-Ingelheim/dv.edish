# eDISH module

`mod_edish()` displays the (modified) evaluation of Drug-Induced Serious
Hepatotoxicity (eDISH/mDISH) plot to support the assessment of
drug-induced liver injury (DILI). The scatter plot depicts the
correlation between peak values of an aminotransferase parameter and a
liver function parameter on a subject level.

## Usage

``` r
mod_edish(
  module_id,
  subject_level_dataset_name,
  lab_dataset_name,
  lb_date_var = "LBDT",
  subjectid_var = "USUBJID",
  arm_var = "ACTARM",
  arm_default_vals = NULL,
  visit_var = "VISIT",
  baseline_visit_val = "VISIT 01",
  lb_test_var = "LBTEST",
  at_choices = c("Alanine Aminotransferase", "Aspartate Aminotransferase"),
  at_default_val = "Aspartate Aminotransferase",
  tbili_choices = "Bilirubin",
  tbili_default_val = "Bilirubin",
  alp_choice = "Alkaline Phosphatase",
  lb_result_var = "LBSTRESN",
  lb_unit_var = "LBSTRESU",
  ref_range_upper_lim_var = "LBSTNRHI",
  default_by_visit = FALSE,
  default_show_table = FALSE,
  window_days = NULL,
  norm_ref_lines = c(`Alanine Aminotransferase` = 3, `Aspartate Aminotransferase` = 3,
    Bilirubin = 2),
  abs_ref_lines = c(`Alanine Aminotransferase` = 300, `Aspartate Aminotransferase` = 300),
  uln_multiples = c(`Alanine Aminotransferase` = 1.5, `Aspartate Aminotransferase` = 1.5),
  receiver_id = NULL
)
```

## Arguments

- module_id:

  `[character(1)]`

  A unique module ID.

- subject_level_dataset_name:

  `[character(1)]`

  Name of the subject-level dataset to be used.

- lab_dataset_name:

  `[character(1)]`

  Name of the laboratory results dataset to be used.

- lb_date_var:

  `[character(1)]`

  Name of the variable (`Date` or `POSIXt` class) containing the
  laboratory test date.

- subjectid_var:

  `[character(1)]`

  Name of the variable containing the unique subject IDs.

- arm_var:

  `[character(1)]`

  Name of the variable containing the arm/treatment information.

- arm_default_vals:

  `[character(1+) | NULL]`

  Vector specifying the default value(s) for the arm selector.

- visit_var:

  `[character(1)]`

  Name of the variable containing the visit information.

- baseline_visit_val:

  `[character(1)]`

  Character indicating which visit should be used as baseline visit.

- lb_test_var:

  `[character(1)]`

  Name of the variable containing the laboratory test information.

- at_choices:

  `[character(1+)]`

  Character vector specifying the possible choices of the x-axis
  aminotransferase laboratory test.

- at_default_val:

  `[character(1) | NULL]`

  Character specifying the default x-axis aminotransferase laboratory
  test choice.

- tbili_choices:

  `[character(1+)]`

  Character vector specifying the possible choices of the y-axis liver
  function laboratory test (e.g. "Bilirubin", "Prothrombin Intl.
  Normalized Ratio", etc.).

- tbili_default_val:

  `[character(1) | NULL]`

  Character specifying the default y-axis liver function laboratory test
  choice.

- alp_choice:

  `[character(1) | NULL]`

  Character vector specifying the alkaline phosphatase laboratory test
  choice.

- lb_result_var:

  `[character(1)]`

  Name of the variable containing results of the laboratory test.

- lb_unit_var:

  `[character(1)] | NULL`

  Name of variable containing the laboratory test unit. If not NULL then
  unit will be included in the axis labels. Only specify this if unit is
  not already included in `lb_test_var`.

- ref_range_upper_lim_var:

  `[character(1)]`

  Name of the variable containing the reference range upper limits.

- default_by_visit:

  `[logical(1)]`

  A flag to indicate the default of whether or not to plot
  aminotransferase values for each visit.

- default_show_table:

  `[logical(1)]`

  A flag to indicate whether or not to display a table of plot point
  frequencies delimited by reference lines.

- window_days:

  `[integer(1) | NULL]`

  Window of the number of days considered between peaks.

- norm_ref_lines:

  `[numeric(1+) | NULL]`

  A named numeric vector of reference line values corresponding to
  normalized value laboratory tests. Each value should be named with a
  value from `at_choices` or `tbili_choices`.

- abs_ref_lines:

  `[numeric(1+) | NULL]`

  A named numeric vector of reference line values corresponding to
  absolute value laboratory tests. Each value should be named with a
  value from `at_choices` or `tbili_choices`.

- uln_multiples:

  `[numeric(1+) | NULL]`

  A named numeric vector of ULN multiples corresponding to normalized
  value laboratory tests. Each value should be named with a value from
  `at_choices`.

- receiver_id:

  `[character(1) | NULL]`

  Character string defining the ID of the module to which to send a
  subject ID. The module must exist in the module list. The default is
  NULL which disables communication.

## Value

A list containing the following elements to be used by the dv.manager:

- `ui`: A UI function of the dv.edish module.

- `server`: A server function of the dv.edish module.

- `module_id`: A unique identifier.
