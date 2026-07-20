# Generate a table of subject counts and percentages in areas delimited by reference lines

Generate a table of subject counts and percentages in areas delimited by
reference lines

## Usage

``` r
generate_table(
  dataset,
  subjectid_var,
  sel_x,
  sel_y,
  x_abs,
  y_abs,
  x_ref_line_num,
  y_ref_line_num
)
```

## Arguments

- dataset:

  `[data.frame]`

  A data frame containing the variables listed below as columns.

- subjectid_var:

  `[character(1)]`

  Name of the variable containing the unique subject IDs.

- sel_x:

  `[character(1)]`

  String specifying the laboratory test to be displayed on the x-axis.

- sel_y:

  `[character(1)]`

  String specifying the laboratory test to be displayed on the y-axis.

- x_abs:

  `[logical(1)]`

  Logical indicating if absolute value should be plotted on x-axis.

- y_abs:

  `[logical(1)]`

  Logical indicating if absolute value should be plotted on y-axis.

- x_ref_line_num:

  `[numeric(1)]`

  Numeric specifying the reference line for the x-axis.

- y_ref_line_num:

  `[numeric(1)]`

  Numeric specifying the reference line for the y-axis.

## Value

A data frame of subject counts and percentages categorized by
normal/elevated laboratory tests.
