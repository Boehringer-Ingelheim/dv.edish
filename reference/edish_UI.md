# User Interface of the `dv.edish` module

`edish_UI()` contains the UI of the `dv.edish` module.

## Usage

``` r
edish_UI(
  module_id,
  arm_default_vals,
  at_choices,
  at_default_val,
  tbili_choices,
  tbili_default_val,
  default_by_visit,
  window_days
)
```

## Arguments

- module_id:

  `[character(1)]`

  A unique ID string to create a namespace. Must match the ID of
  [`edish_server()`](edish_server.md).

- arm_default_vals:

  `[character(1+) | NULL]`

  Vector specifying the default value(s) for the arm selector.

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

- default_by_visit:

  `[logical(1)]`

  A flag to indicate the default of whether or not to plot
  aminotransferase values for each visit.

- window_days:

  `[integer(1) | NULL]`

  Window of the number of days considered between peaks.

## Value

A shiny `uiOutput` element.

## See also

[`mod_edish()`](mod_edish.md) and [`edish_server()`](edish_server.md)
