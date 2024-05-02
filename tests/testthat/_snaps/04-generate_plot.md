# the resulting plot object includes the correct hovertext (snapshot test)

    Code
      actual
    Output
      [1] "paste0(\"Subject: \", .data[[subjectid_var]], \"<br>Arm: \", .data[[arm_var]], \"<br>Visit: \", .data[[visit_var]], \"<br>x-axis: \", round(.data[[paste0(\"r_\", x_plot_type, \"_\", sel_x)]], digits = 3), \"<br>y-axis: \", round(.data[[paste0(\"r_\", y_plot_type, \"_\", sel_y)]], digits = 3))"

