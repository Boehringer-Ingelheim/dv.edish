# Initialize test app
app <- shinytest2::AppDriver$new(
  app_dir = "./apps/simple_app",
  name = "test_mod_edish"
)
app_url <- app$get_url()

# Tests
test_that("the default values are correct at app launch" %>%
  vdoc[["add_spec"]](c(specs$input_menu_specs$default_vals$arm, specs$input_menu_specs$default_vals$param)), {
  app <- shinytest2::AppDriver$new(
    app_dir = app_url, name = "test_defaults"
  )
  app$wait_for_idle()

  actual_arm_vals <- app$get_value(input = "edish-arm_id")
  expected_arm_vals <- "arm1"
  expect_identical(actual_arm_vals, expected_arm_vals)

  actual_x_sel <- app$get_value(input = "edish-x_axis")
  expected_x_sel <- "test 1"
  expect_identical(actual_x_sel, expected_x_sel)

  actual_y_sel <- app$get_value(input = "edish-y_axis")
  expected_y_sel <- "test 2"
  expect_identical(actual_y_sel, expected_y_sel)

  app$stop()
})

test_that("the app displays the correct plot at app launch (snapshot test)" %>%
  vdoc[["add_spec"]](specs$plot_specs$data), {
  app <- shinytest2::AppDriver$new(
    app_dir = app_url, name = "test_snapshot"
  )
  app$wait_for_idle()

  expect_snapshot(
    app$get_values(input = TRUE, output = TRUE),
    cran = TRUE
  )

  app$stop()
})

test_that("default settings are visible after Single-Sign-On redirect", {
  skip("Cannot integrate SSO within unit tests, i.e., this test has to be performed manually.")
})



# Test bookmarking
test_that("the app's state is restored when bookmarking" %>%
  vdoc[["add_spec"]](specs$framework_specs$bookmarking), {
  # Initialize test app
  app_bmk <- shinytest2::AppDriver$new(
    app_dir = "./apps/bookmarking_app", name = "test_bookmarking"
  )
    
  app_bmk$wait_for_idle()

  # Update values
  app_bmk$set_inputs(`edish-arm_id` = c("arm1", "arm2"))
  app_bmk$set_inputs(`edish-x_axis` = "test 2")
  app_bmk$set_inputs(`edish-x_ref` = 3.5)
  app_bmk$set_inputs(`edish-x_plot_type` = "Baseline")

  # It is not possible to set shinyWidgets::numericalRangeInput using shinytest2
  # We use an alternative approach by setting the url query part manually
  # nolint start
  # app_bmk$set_inputs(`edish-x_rng` = c(0.1, 5.1))
  # app_bmk$set_inputs(`edish-y_rng` = c(0.1, 7.1))
  # nolint end
  range_url_part <- "&edish-x_rng=%5B0.1%2C5.1%5D&edish-y_rng=%5B0.1%2C7.1%5D"

  # Bookmark
  app_bmk$set_inputs(!!"._bookmark_" := "click") # nolint

  # Initialize bookmarked app
  bmk_url <- app_bmk$get_value(export = "url")  

  bmk_url_with_range <- paste0(bmk_url, range_url_part)
  app_rst <- shinytest2::AppDriver$new(app_dir = bmk_url_with_range, name = "test_restoring")

  app_rst$wait_for_idle()

  # Get values and test
  actual <- app_rst$get_values(input = c("edish-arm_id", "edish-x_axis", "edish-x_plot_type", "edish-x_ref",
                                         "edish-x_rng", "edish-y_rng"))
  expected <- list(
    input = list(
      `edish-arm_id` = c("arm1", "arm2"),
      `edish-x_axis` = "test 2",
      `edish-x_plot_type` = "Baseline",
      `edish-x_ref` = 3.5,
      `edish-x_rng` = c(0.1, 5.1),
      `edish-y_rng` = c(0.1, 7.1)
    )
  )
  testthat::expect_identical(actual, expected)

  # Stop apps
  app_bmk$stop()
  app_rst$stop()
})
