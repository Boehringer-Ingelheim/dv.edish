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
  ref_range_upper_lim_var = "LBSTNRHI",
  on_sbj_click = NULL
)
```

## Arguments

- module_id:

  `[character(1)]`

  A unique ID string to create a namespace. Must match the ID of
  [`edish_UI()`](edish_UI.md).

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

- ref_range_upper_lim_var:

  `[character(1)]`

  Name of the variable containing the reference range upper limits.

- on_sbj_click:

  `[function() | NULL]`

  Function to invoke when a subject is clicked on the plot. If `NULL`,
  no action is taken.

## Value

A reactive value containing the list of subjects in the clicked point,
if applicable.

## See also

[`mod_edish()`](mod_edish.md) and [`edish_UI()`](edish_UI.md)
