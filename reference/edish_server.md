# Server of the `dv.edish` module

`edish_server()` contains the server of the `dv.edish` module.

## Usage

``` r
edish_server(
  module_id,
  dataset_list,
  lb_date_var,
  subjectid_var = "USUBJID",
  arm_var = "ACTARM",
  visit_var = "VISIT",
  baseline_visit_val = "VISIT 01",
  lb_test_var = "LBTEST",
  at_choices = NULL,
  alp_choice = NULL,
  lb_result_var = "LBSTRESN",
  lb_unit_var = NULL,
  ref_range_upper_lim_var = "LBSTNRHI",
  norm_ref_lines = NULL,
  abs_ref_lines = NULL,
  uln_multiples = NULL,
  on_sbj_click = NULL
)
```

## Arguments

- module_id:

  `[character(1)]`

  A unique ID string to create a namespace. Must match the ID of
  [`edish_UI()`](https://boehringer-ingelheim.github.io/dv.edish/reference/edish_UI.md).

- dataset_list:

  `[shiny::reactive(list(data.frame))]`

  A reactive list of named datasets.

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

- on_sbj_click:

  `[function() | NULL]`

  Function to invoke when a subject is clicked on the plot. If `NULL`,
  no action is taken.

## Value

A reactive value containing the list of subjects in the clicked point,
if applicable.

## See also

[`mod_edish()`](https://boehringer-ingelheim.github.io/dv.edish/reference/mod_edish.md)
and
[`edish_UI()`](https://boehringer-ingelheim.github.io/dv.edish/reference/edish_UI.md)
