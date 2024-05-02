is_CI <- isTRUE(as.logical(Sys.getenv("CI"))) # nolint

package_name <- "dv.edish"

# validation (S)
vdoc <- source(
  system.file("validation", "utils-validation.R", package = package_name, mustWork = TRUE),
  local = TRUE
)[["value"]]
specs <- vdoc[["specs"]]
# validation (F)
