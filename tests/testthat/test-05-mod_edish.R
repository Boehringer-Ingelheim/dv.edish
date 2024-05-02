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

test_that("default settigns are visible after Single-Sign-On redirect", {
  skip("Cannot integrate SSO within unit tests, i.e., this test has to be performed manually.")
})



# Test bookmarking
test_that("the app's state is restored when bookmarking" %>%
            vdoc[["add_spec"]](specs$framework_specs$bookmarking), {
  
  # Initialize test app
  app_bmk <- shinytest2::AppDriver$new(
    app_dir = "./apps/bookmarking_app", name = "test_bookmarking"
  )
  
  app$wait_for_idle()
  
  # Update values
  app_bmk$set_inputs(`edish-arm_id` = c("arm1", "arm2"))
  app_bmk$set_inputs(`edish-x_axis` = "test 2")
  app_bmk$set_inputs(`edish-x_ref` = 3)
  app_bmk$set_inputs(`edish-x_plot_type` = "x Baseline (mDISH)")
  
  # Bookmark
  app_bmk$set_inputs(!!"._bookmark_" := "click") #nolint
  
  # Initialize bookmarked app
  bmk_url <- app_bmk$get_value(export = "url")
  app_rst <- shinytest2::AppDriver$new(app_dir = bmk_url, name = "test_restoring")
  
  # Get values and test
  actual <- app_rst$get_values(input = c("edish-arm_id", "edish-x_axis", "edish-x_plot_type", "edish-x_ref"))
  expected <- list(
    input = list(
      `edish-arm_id` = c("arm1", "arm2"),
      `edish-x_axis` = "test 2",
      `edish-x_plot_type` = "x Baseline (mDISH)",
      `edish-x_ref` = 3
    )
  )
  testthat::expect_equal(actual, expected)
  
  # Stop apps
  app_bmk$stop()
  app_rst$stop()
  
})
