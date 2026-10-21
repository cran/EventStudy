## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE
)

## ----data---------------------------------------------------------------------
# library(EventStudy)
# library(tibble)
# 
# # Create panel data
# panel_data <- tibble(
#   unit_id = rep(1:100, each = 20),
#   time_id = rep(1:20, times = 100),
#   # Units 1-50 are first treated in period 11; units 51-100 are never treated.
#   treatment_time = ifelse(unit_id <= 50, 11, NA_integer_),
#   treatment = ifelse(unit_id <= 50 & time_id >= 11, 1, 0),
#   outcome = rnorm(2000) + 2 * treatment  # true effect = 2
# )
# 
# task <- PanelEventStudyTask$new(
#   panel_data = panel_data,
#   unit_id = "unit_id",
#   time_id = "time_id",
#   outcome = "outcome",
#   treatment = "treatment",
#   treatment_time = "treatment_time"
# )

## ----twfe---------------------------------------------------------------------
# result <- estimate_panel_event_study(task, method = "static_twfe", leads = 5, lags = 5)
# result$results$coefficients

## ----sun-abraham--------------------------------------------------------------
# result <- estimate_panel_event_study(
#   task,
#   method = "sun_abraham",
#   leads = 5,
#   lags = 5
# )
# plot_panel_event_study(result)

## ----callaway-----------------------------------------------------------------
# result <- estimate_panel_event_study(
#   task,
#   method = "callaway_santanna",
#   leads = 5,
#   lags = 5
# )
# plot_panel_event_study(result)

## ----dechaisemartin-----------------------------------------------------------
# result <- estimate_panel_event_study(
#   task,
#   method = "dechaisemartin_dhaultfoeuille",
#   leads = 5,
#   lags = 5
# )
# plot_panel_event_study(result)

## ----borusyak-----------------------------------------------------------------
# result <- estimate_panel_event_study(
#   task,
#   method = "borusyak_jaravel_spiess",
#   leads = 5,
#   lags = 5
# )
# plot_panel_event_study(result)

## ----compare------------------------------------------------------------------
# methods <- c("static_twfe", "sun_abraham", "callaway_santanna")
# 
# results <- lapply(methods, function(m) {
#   tryCatch(
#     estimate_panel_event_study(task, method = m, leads = 5, lags = 5),
#     error = function(e) NULL
#   )
# })
# names(results) <- methods

