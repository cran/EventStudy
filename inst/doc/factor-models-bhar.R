## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE
)

## ----load-packages------------------------------------------------------------
# library(EventStudy)
# library(dplyr)
# library(tibble)
# library(ggplot2)

## ----factor-source------------------------------------------------------------
# # Example: constructing a factor_tbl manually
# # In practice, download from Kenneth French's data library
# set.seed(42)
# n <- 300
# dates <- format(seq(as.Date("2014-06-01"), by = "day", length.out = n),
#                 "%d.%m.%Y")
# 
# factor_tbl <- tibble(
#   date           = dates,
#   smb            = rnorm(n, 0, 0.005),     # Small Minus Big
#   hml            = rnorm(n, 0, 0.005),     # High Minus Low
#   rmw            = rnorm(n, 0, 0.004),     # Robust Minus Weak
#   cma            = rnorm(n, 0, 0.004),     # Conservative Minus Aggressive
#   mom            = rnorm(n, 0, 0.006),     # Momentum
#   risk_free_rate = rep(0.0001, n)          # Daily risk-free rate
# )

## ----ff3-run------------------------------------------------------------------
# set.seed(42)
# n <- 300
# dates <- format(seq(as.Date("2014-06-01"), by = "day", length.out = n),
#                 "%d.%m.%Y")
# 
# firm_tbl <- tibble(
#   symbol   = "FIRM_A",
#   date     = dates,
#   adjusted = 100 * cumprod(1 + rnorm(n, 0.0003, 0.015))
# )
# 
# index_tbl <- tibble(
#   symbol   = "INDEX_1",
#   date     = dates,
#   adjusted = 1000 * cumprod(1 + rnorm(n, 0.0002, 0.012))
# )
# 
# request_tbl <- tibble(
#   event_id = 1L, firm_symbol = "FIRM_A", index_symbol = "INDEX_1",
#   event_date = dates[200], group = "Test",
#   event_window_start = -10L, event_window_end = 10L,
#   shift_estimation_window = -11L, estimation_window_length = 150L
# )
# 
# # Pass factor_tbl to the task
# task <- EventStudyTask$new(firm_tbl, index_tbl, request_tbl,
#                             factor_tbl = factor_tbl)
# 
# params <- ParameterSet$new(
#   return_calculation = LogReturn$new(),
#   return_model       = FamaFrench3FactorModel$new()
# )
# 
# task <- task |>
#   prepare_event_study(params) |>
#   fit_model(params) |>
#   calculate_statistics(params)

## ----ff3-results--------------------------------------------------------------
# # Model statistics for event 1
# stats <- task$data_tbl$model[[1]]$statistics
# 
# # Factor loadings
# stats$alpha              # Intercept (Jensen's alpha)
# stats$beta               # Market beta (same as `market_excess`)
# stats$smb                # SMB loading
# stats$hml                # HML loading
# stats$r2                 # R-squared
# stats$sigma              # Residual standard error
# 
# # Full coefficient table
# task$get_model_stats(event_id = 1)

## ----ff5-run------------------------------------------------------------------
# task_ff5 <- EventStudyTask$new(firm_tbl, index_tbl, request_tbl,
#                                 factor_tbl = factor_tbl)
# 
# params_ff5 <- ParameterSet$new(
#   return_calculation = LogReturn$new(),
#   return_model       = FamaFrench5FactorModel$new()
# )
# 
# task_ff5 <- task_ff5 |>
#   prepare_event_study(params_ff5) |>
#   fit_model(params_ff5) |>
#   calculate_statistics(params_ff5)

## ----carhart-run--------------------------------------------------------------
# task_c4 <- EventStudyTask$new(firm_tbl, index_tbl, request_tbl,
#                                factor_tbl = factor_tbl)
# 
# params_c4 <- ParameterSet$new(
#   return_calculation = LogReturn$new(),
#   return_model       = Carhart4FactorModel$new()
# )
# 
# task_c4 <- task_c4 |>
#   prepare_event_study(params_c4) |>
#   fit_model(params_c4) |>
#   calculate_statistics(params_c4)

## ----garch-install------------------------------------------------------------
# install.packages("rugarch")

## ----garch-run----------------------------------------------------------------
# task_garch <- EventStudyTask$new(firm_tbl, index_tbl, request_tbl)
# 
# params_garch <- ParameterSet$new(
#   return_model = GARCHModel$new()
# )
# 
# task_garch <- task_garch |>
#   prepare_event_study(params_garch) |>
#   fit_model(params_garch) |>
#   calculate_statistics(params_garch)

## ----garch-results------------------------------------------------------------
# stats <- task_garch$data_tbl$model[[1]]$statistics
# 
# stats$alpha          # Mean equation intercept
# stats$beta           # Market beta
# stats$sigma          # Average conditional sigma
# stats$garch_sigma    # Time series of conditional sigmas

## ----bhar-run-----------------------------------------------------------------
# task_bhar <- EventStudyTask$new(firm_tbl, index_tbl, request_tbl)
# 
# params_bhar <- ParameterSet$new(
#   return_model            = BHARModel$new(),
#   single_event_statistics = SingleEventStatisticsSet$new(
#     tests = list(BHARTTest$new())
#   )
# )
# 
# task_bhar <- task_bhar |>
#   prepare_event_study(params_bhar) |>
#   fit_model(params_bhar) |>
#   calculate_statistics(params_bhar)

## ----bhar-results-------------------------------------------------------------
# # Tidy output
# tidy.EventStudyTask(task_bhar, type = "ar")
# 
# # BHAR test statistic
# task_bhar$data_tbl$BHART[[1]]

## ----bhar-vs-car--------------------------------------------------------------
# # Short window: CAR and BHAR are nearly identical
# task_short <- EventStudyTask$new(firm_tbl, index_tbl, request_tbl)
# params_short <- ParameterSet$new(return_model = MarketModel$new())
# task_short <- run_event_study(task_short)
# 
# car_short  <- tidy.EventStudyTask(task_short, type = "car")
# bhar_short <- tidy.EventStudyTask(task_bhar, type = "ar")

## ----model-comparison---------------------------------------------------------
# models <- list(
#   "Market Model"     = MarketModel$new(),
#   "FF3"              = FamaFrench3FactorModel$new(),
#   "FF5"              = FamaFrench5FactorModel$new(),
#   "Carhart"          = Carhart4FactorModel$new()
# )
# 
# results <- purrr::imap_dfr(models, function(model, name) {
#   t <- EventStudyTask$new(firm_tbl, index_tbl, request_tbl,
#                            factor_tbl = factor_tbl)
#   p <- ParameterSet$new(
#     return_calculation = LogReturn$new(),
#     return_model       = model
#   )
#   t <- t |>
#     prepare_event_study(p) |>
#     fit_model(p) |>
#     calculate_statistics(p)
# 
#   tidy.EventStudyTask(t, type = "car") |>
#     mutate(model = name)
# })
# 
# # Plot CARs across models
# ggplot(results, aes(x = relative_index, y = car, color = model)) +
#   geom_line(linewidth = 0.8) +
#   geom_hline(yintercept = 0, linetype = "dashed", color = "grey40") +
#   geom_vline(xintercept = 0, linetype = "dotted", color = "red", alpha = 0.6) +
#   labs(
#     title = "CAR Comparison Across Models",
#     x     = "Relative Time to Event",
#     y     = "Cumulative Abnormal Return",
#     color = "Model"
#   ) +
#   theme_minimal()

