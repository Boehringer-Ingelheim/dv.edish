# Prepare initial data

Join DM and LB datasets into one, and filter on specified laboratory
test parameters, and maximum values for each subject/arm/test/visit
group.

## Usage

``` r
prepare_initial_data(
  dataset_list,
  subjectid_var,
  arm_var,
  visit_var,
  lb_test_var,
  at_choices,
  tbili_choice,
  alp_choice,
  lb_date_var,
  lb_result_var,
  ref_range_upper_lim_var
)
```

## Arguments

- dataset_list:

  `[list(data.frame))]`

  A list of datasets, containing a Demographics and a Lab Value dataset.

  \[list(data.frame))\]: R:list(data.frame))

- subjectid_var:

  `[character(1)]`

  Name of the variable containing the unique subject IDs.

- arm_var:

  `[character(1)]`

  Name of the variable containing the arm/treatment information.

- visit_var:

  `[character(1)]`

  Name of the variable containing the visit information.

- lb_test_var:

  `[character(1)]`

  Name of the variable containing the laboratory test parameter.

- at_choices:

  `[character(1+)]`

  Character vector specifying the possible choices of the
  aminotransferase laboratory test parameter for the x-axis.

- tbili_choice:

  `[character(1)]`

  Character vector specifying the choice of the total bilirubin
  laboratory test parameter for the y-axis.

- alp_choice:

  `[character(1) | NULL]`

  Character vector specifying the choice of the alkaline phosphatase
  laboratory test parameter.

- lb_date_var:

  `[character(1)]`

  Name of the variable (`Date` or `POSIXt` class) containing the
  laboratory test date.

- lb_result_var:

  `[character(1)]`

  Name of the variable containing results of the laboratory test.

- ref_range_upper_lim_var:

  `[character(1)]`

  Name of the variable containing the reference range upper limits.

## Value

A data frame with the variables specified by the function arguments,
`subjectid_var`, `arm_var`, `visit_var`, `lb_test_var`, `lb_date_var`,
`lb_result_var` and `ref_range_upper_lim_var`. Only rows for laboratory
test parameters specified by `at_choices`, `tbili_choice` and
`alp_choice` are kept.
