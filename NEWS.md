# dv.edish 1.3.0

- Add jumping feature.
- Arm default values can be arbitrarily specified as long as they are character strings. This supports including multiple studies with different arm values.

# dv.edish 1.2.0

- The user can now specify the x- and y-axis range limits, or go with the default `{plotly}` ranges.

# dv.edish 1.1.0

- Remove support for data dispatchers.
- Split `mod_edish()` `dataset_names` parameter into subject-level and laboratory datasets.
- Provide early feedback of `mod_edish()` misconfiguration.

# dv.edish 1.0.4

- The module ignores now NA values when calculating the maximum value.

# dv.edish 1.0.3

- Initial release of dv.edish package to GitHub.

# dv.edish 1.0.2

- The module is now able to deal with multiple values per subject, visit, and lab test by using the maximum value.
- When there is no data to display, e.g., due to filter settings, the module will provide a meaningful output.
- The module has been updated to show commonly used default values for reference lines. For the x-axis, the default value is 3, and for the y-axis, the default value is 2.

# dv.edish 1.0.1

- Bugfix: Bookmarking the app's state failed for arm and parameter selection but is fixed now.

# dv.edish 1.0.0

- Initial version of dv.edish.
