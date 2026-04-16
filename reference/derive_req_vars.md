# Derive required variables for plotting

Derive required variables for plotting

## Usage

``` r
derive_req_vars(
  dataset,
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
  window_days
)
```

## Arguments

- dataset:

  `[data.frame]`

  A data frame containing the data from
  [`prepare_initial_data()`](prepare_initial_data.md).

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

  String indicating which visit should be used as baseline visit.

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

- norm_ref_type:

  `[character(1)]`

  String indicating normalization reference type, either `"ULN"` or
  `"Baseline"`.

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

- by_visit:

  `[logical(1)]`

  A flag to indicate whether to plot aminotransferase values for each
  visit.

- window_days:

  `[integer(1) | NULL]`

  Window of the number of days considered between peaks.

## Value

A data frame with the following derived variables:

- `.ref_val`: ULN or baseline as the reference value for normalization.

- `.visit_at`: Visit of peak aminotransferase value.

- `.date_at`: Date of peak aminotransferase value.

- `.norm_at`: Normalized peak aminotransferase value.

- `.visit_tbili`: Visit of peak total bilirubin value.

- `.date_tbili`: Date of peak total bilirubin value.

- `.norm_tbili`: Normalized peak total bilirubin value.

- `.norm_alp`: Normalized alkaline phosphotase value at same visit as
  aminotransferase value.

- `.offset_days`: Number of days from aminotransferase visit to total
  bilirubin visit.

- `.norm_ref_type`: Normalization reference type, copied from
  `norm_ref_type` argument.
