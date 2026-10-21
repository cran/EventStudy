## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval=FALSE---------------------------------------------------------------
# library(EventStudy)
# 
# # Create task with synthetic data
# task <- create_mock_task(n_firms = 5)  # helper for testing
# params <- ParameterSet$new()
# task <- run_event_study(task, params)

## ----eval=FALSE---------------------------------------------------------------
# # Get AR for a specific event
# ar <- task$get_ar(event_id = 1)
# ar
# # # A tibble: 11 x 2
# #    relative_index abnormal_returns
# #             <dbl>            <dbl>
# #  1             -5         0.00234
# #  ...

## ----eval=FALSE---------------------------------------------------------------
# # Get CAR for a specific event
# car <- task$get_car(event_id = 1)
# car
# # # A tibble: 11 x 3
# #    relative_index abnormal_returns      car
# #             <dbl>            <dbl>    <dbl>
# #  1             -5         0.00234  0.00234
# #  ...

## ----eval=FALSE---------------------------------------------------------------
# # Get AAR/CAAR from multi-event statistics
# aar <- task$get_aar(stat_name = "CSectT")
# aar
# # Returns the cross-sectional t-test results tibble

## ----eval=FALSE---------------------------------------------------------------
# # Get model fit statistics for a specific event
# stats <- task$get_model_stats(event_id = 1)
# stats$alpha
# stats$beta
# stats$sigma
# stats$r2

## ----eval=FALSE---------------------------------------------------------------
# tidy_ar <- tidy.EventStudyTask(task, type = "ar")
# tidy_ar
# # # A tibble: 55 x 7
# #    event_id group     firm_symbol term  estimate std.error statistic
# #       <int> <chr>     <chr>       <chr>    <dbl>     <dbl>     <dbl>
# #  1        1 TestGroup FIRM_A      -5     0.00234   0.0102     0.229
# #  ...

## ----eval=FALSE---------------------------------------------------------------
# tidy_car <- tidy.EventStudyTask(task, type = "car")
# # Includes cumulative AR with window labels as terms

## ----eval=FALSE---------------------------------------------------------------
# tidy_aar <- tidy.EventStudyTask(task, type = "aar")
# # Includes AAR, CAAR, and their test statistics with p-values

## ----eval=FALSE---------------------------------------------------------------
# tidy_model <- tidy.EventStudyTask(task, type = "model")
# # Returns alpha, beta, sigma, r.squared for each event

## ----eval=FALSE---------------------------------------------------------------
# # Export all results (creates separate files: results_ar.csv, results_car.csv, etc.)
# export_results(task, "results.csv")
# 
# # Export specific results
# export_results(task, "model_stats.csv", which = "model")

## ----eval=FALSE---------------------------------------------------------------
# # Requires the openxlsx package
# # Each result type gets its own worksheet
# export_results(task, "results.xlsx")

## ----eval=FALSE---------------------------------------------------------------
# # Produces publication-ready LaTeX tables
# # Requires the knitr package
# export_results(task, "results.tex", which = c("model", "aar"))

## ----eval=FALSE---------------------------------------------------------------
# # Extract CARs for all events
# all_cars <- purrr::map2_dfr(
#   task$data_tbl$event_id,
#   task$data_tbl$firm_symbol,
#   function(eid, sym) {
#     car <- task$get_car(event_id = eid)
#     tibble::tibble(
#       event_id = eid,
#       firm_symbol = sym,
#       car_total = tail(car$car, 1)
#     )
#   }
# )
# 
# # Now you can regress CARs on firm characteristics
# # (see the cross_sectional_regression() function)

## ----eval=FALSE---------------------------------------------------------------
# # Single-event plots
# plot_event_study(task, type = "ar", event_id = 1)
# plot_event_study(task, type = "car", event_id = 1)
# 
# # Multi-event plots
# plot_event_study(task, type = "aar")
# plot_event_study(task, type = "caar")
# 
# # Model diagnostics
# plot_diagnostics(task, event_id = 1)

