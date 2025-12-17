# Initialize test app ----

app <- shinytest2::AppDriver$new(
  app_dir = "./apps/simple_app",
  name = "test_mod_edish"
)
app_url <- app$get_url()

# Tests ----

test_that("the default values are correct at app launch" |>
  vdoc[["add_spec"]](c(specs$input_menu_specs$default_vals$arm, specs$input_menu_specs$default_vals$param)), {

  app <- shinytest2::AppDriver$new(
    app_dir = app_url, name = "test_defaults"
  )
  app$wait_for_idle()

  actual_arm_vals <- app$get_value(input = "edish-arm_id")
  expected_arm_vals <- "arm1"
  expect_identical(actual_arm_vals, expected_arm_vals)

  actual_x_sel <- app$get_value(input = "edish-x_axis")
  expected_x_sel <- "alt"
  expect_identical(actual_x_sel, expected_x_sel)

  actual_x_ref <- app$get_value(input = "edish-x_ref")
  expected_x_ref <- 3L
  expect_identical(actual_x_ref, expected_x_ref)

  actual_y_ref <- app$get_value(input = "edish-y_ref")
  expected_y_ref <- 2L
  expect_identical(actual_y_ref, expected_y_ref)

  actual_x_rng <- app$get_value(input = "edish-x_rng")
  expected_x_rng <- NULL
  expect_identical(actual_x_rng, expected_x_rng)

  actual_y_rng <- app$get_value(input = "edish-y_rng")
  expected_y_rng <- NULL
  expect_identical(actual_y_rng, expected_y_rng)

  actual_by_visit <- app$get_value(input = "edish-by_visit")
  expected_by_visit <- FALSE
  expect_identical(actual_by_visit, expected_by_visit)

  actual_plot_type <- app$get_value(input = "edish-plot_type")
  expected_plot_type <- "ULN"
  expect_identical(actual_plot_type, expected_plot_type)

  app$stop()
})

test_that("the app displays the correct plot at app launch (snapshot test)" |>
  vdoc[["add_spec"]](specs$plot_specs$data), {

  app <- shinytest2::AppDriver$new(
    app_dir = app_url,
    name = "test_snapshot"
  )
  app$wait_for_idle()

  app_vals <- app$get_values(input = TRUE, output = TRUE)

  app_vals$output$`edish-plot` <- gsub("svg_[a-z0-9_]{10,}", "svg_CONST",
                                       app_vals$output$`edish-plot`)

  expect_snapshot(app_vals, cran = TRUE)

  app$stop()
})

test_that("default settings are visible after Single-Sign-On redirect", {
  skip("Cannot integrate SSO within unit tests, i.e., this test has to be performed manually.")
})

test_that("the app's state is restored when bookmarking" |>
  vdoc[["add_spec"]](specs$framework_specs$bookmarking), {

  # Initialize test app
  app_bmk <- shinytest2::AppDriver$new(
    app_dir = "./apps/bookmarking_app",
    name = "test_bookmarking"
  )
  app_bmk$wait_for_idle()

  # Update values
  app_bmk$set_inputs(`edish-plot_type` = "Baseline")
  app_bmk$set_inputs(`edish-arm_id` = c("arm1", "arm2"))
  app_bmk$set_inputs(`edish-x_axis` = "ast")
  app_bmk$set_inputs(`edish-x_ref` = 3.5)
  app_bmk$set_inputs(`edish-by_visit` = TRUE)

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
  actual <- app_rst$get_values(input = c("edish-plot_type", "edish-arm_id", "edish-x_axis", "edish-x_ref",
                                         "edish-x_rng", "edish-y_rng", "edish-by_visit"))
  expected <- list(
    input = list(
      `edish-arm_id` = c("arm1", "arm2"),
      `edish-by_visit` = TRUE,
      `edish-plot_type` = "Baseline",
      `edish-x_axis` = "ast",
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
