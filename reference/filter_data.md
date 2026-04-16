# Filter data prior to plotting

Filter data on selected normalization reference type, arms/treatments
and aminotransferase laboratory test.

## Usage

``` r
filter_data(
  dataset,
  norm_ref_type,
  arm_var,
  sel_arm,
  lb_test_var,
  sel_lb_test,
  x_ref,
  base_incl
)
```

## Arguments

- dataset:

  `[data.frame]`

  A data frame containing the columns specified by `lb_test_var` and
  `arm_var`.

- norm_ref_type:

  `[character(1)]`

  String indicating normalization reference type, either `"ULN"` or
  `"Baseline"`.

- arm_var:

  `[character(1)]`

  Name of the variable containing the arm/treatment information.

- sel_arm:

  `[character(1+)]`

  Character vector specifying a selection of arms/treatments.

- lb_test_var:

  `[character(1)]`

  Name of the variable containing the laboratory test parameter.

- sel_lb_test:

  `[character(1)]`

  String specifying a selected aminotransferase laboratory test.

- x_ref:

  `[numeric(1)]`

  Numeric normalized x-axis threshold reference.

- base_incl:

  `[character(1)]`

  String specifying the selected baseline inclusion choice, either
  `"LO"` (baseline within threshold), `"HI"` (baseline exceeds
  threshold), or `"ALL"` (all).

## Value

A data frame.
