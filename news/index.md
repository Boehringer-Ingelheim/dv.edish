# Changelog

## dv.edish 2.0.2

- \[NOT USER-FACING\] Update early error feedback snippets,
  communication with papo test snippet and test snapshot.

## dv.edish 2.0.1

- Reinstate UI selection of liver function parameter on y-axis.
- Convert [`mod_edish()`](../reference/mod_edish.md) `lb_date_var` to a
  mandatory argument removing the `NULL` default.

## dv.edish 2.0.0

- Refactor code to use {ggiraph} instead of {plotly}.
- Move options from a sidebar layout to a drop menu.
- For each subject, plot normalized peak TBILI against normalized peak
  ALT/AST values, with the option to plot aminotransferase values for
  each visit.
- Implement spider/path lines when aminotransferase values plotted for
  each visit.
- Apply log value to axes.
- Mixing ULN for ALT/AST and baseline for TBILI (or vice versa) is not
  standard and generally does not make scientific sense in DILI
  analysis, but the previous eDISH plot allowed control of ULN/baseline
  for each axis. Update to use only one selector for ULN/baseline that
  applies to both axes.
- Update tooltip/hover text:
  - Show the time between peaks.
  - Show the sequence (peak ALT/AST on or before peak TBILI most
    concerning).
  - Show value of ALP (Alkaline Phosphatase) at the time of peak ALT/AST
    value, flagged ≤ 2 x ULN or \> 2 x ULN (or baseline).

## dv.edish 1.3.0

- Add jumping feature.
- Arm default values can be arbitrarily specified as long as they are
  character strings. This supports including multiple studies with
  different arm values.

## dv.edish 1.2.0

- The user can now specify the x- and y-axis range limits, or go with
  the default plotly ranges.

## dv.edish 1.1.0

- Remove support for data dispatchers.
- Split [`mod_edish()`](../reference/mod_edish.md) `dataset_names`
  parameter into subject-level and laboratory datasets.
- Provide early feedback of [`mod_edish()`](../reference/mod_edish.md)
  misconfiguration.

## dv.edish 1.0.4

- The module ignores now NA values when calculating the maximum value.

## dv.edish 1.0.3

- Initial release of dv.edish package to GitHub.

## dv.edish 1.0.2

- The module is now able to deal with multiple values per subject,
  visit, and lab test by using the maximum value.
- When there is no data to display, e.g., due to filter settings, the
  module will provide a meaningful output.
- The module has been updated to show commonly used default values for
  reference lines. For the x-axis, the default value is 3, and for the
  y-axis, the default value is 2.

## dv.edish 1.0.1

- Bugfix: Bookmarking the app’s state failed for arm and parameter
  selection but is fixed now.

## dv.edish 1.0.0

- Initial version of dv.edish.
