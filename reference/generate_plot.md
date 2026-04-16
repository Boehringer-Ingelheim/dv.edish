# Generate an eDISH plot

Generate an eDISH plot

## Usage

``` r
generate_plot(
  dataset,
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
  y_rng_upper,
  alp_flag,
  by_visit
)
```

## Arguments

- dataset:

  `[data.frame]`

  A data frame containing the variables listed below as columns.

- subjectid_var:

  `[character(1)]`

  Name of the variable containing the unique subject IDs.

- arm_var:

  `[character(1)]`

  Name of the variable containing the arm/treatment information.

- sel_x:

  `[character(1)]`

  String specifying the laboratory test to be displayed on the x-axis.

- sel_y:

  `[character(1)]`

  String specifying the laboratory test to be displayed on the y-axis.

- norm_ref_type:

  `[character(1)]`

  String indicating normalization reference type, either `"ULN"` or
  `"Baseline"`.

- x_ref_line_num:

  `[numeric(1)]`

  Numeric specifying the reference line for the x-axis.

- y_ref_line_num:

  `[numeric(1)]`

  Numeric specifying the reference line for the y-axis.

- x_rng_lower:

  `[numeric(1) | NULL]`

  Numeric specifying the lower limit in the x-axis range.

- x_rng_upper:

  `[numeric(1) | NULL]`

  Numeric specifying the upper limit in the x-axis range.

- y_rng_lower:

  `[numeric(1) | NULL]`

  Numeric specifying the lower limit in the y-axis range.

- y_rng_upper:

  `[numeric(1) | NULL]`

  Numeric specifying the upper limit in the y-axis range.

- alp_flag:

  `[logical(1)]`

  Logical indicating if ALP data was requested.

- by_visit:

  `[logical(1)]`

  A flag to indicate whether to plot aminotransferase values for each
  visit.

## Value

An object specifying the generated eDISH plot.
