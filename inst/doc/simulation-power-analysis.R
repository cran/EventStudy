## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE
)

## ----basic--------------------------------------------------------------------
# library(EventStudy)
# 
# # Size analysis: no abnormal return injected
# size_result <- simulate_event_study(
#   n_events = 20,
#   event_window = c(-5, 5),
#   estimation_window_length = 120,
#   abnormal_return = 0,        # H0 is true
#   n_simulations = 1000,
#   seed = 42
# )
# print(size_result)
# #> Event Study Simulation
# #>   N events:        20
# #>   Event window:   [ -5 , 5 ]
# #>   Abnormal return: 0
# #>   Test statistic:  CSectT
# #>   Alpha:           0.05
# #>   N simulations:   1000
# #>   Power (day 0):   0.048

## ----power--------------------------------------------------------------------
# # Power analysis: 2% abnormal return on event day
# power_result <- simulate_event_study(
#   n_events = 20,
#   event_window = c(-5, 5),
#   estimation_window_length = 120,
#   abnormal_return = 0.02,     # 2% effect
#   n_simulations = 1000,
#   seed = 42
# )
# print(power_result)
# #> Power (day 0):   0.723

## ----effect-sizes-------------------------------------------------------------
# effects <- c(0, 0.005, 0.01, 0.02, 0.05)
# power_curve <- sapply(effects, function(ar) {
#   res <- simulate_event_study(
#     n_events = 20,
#     abnormal_return = ar,
#     n_simulations = 500,
#     seed = 42
#   )
#   res$power
# })
# 
# plot(effects, power_curve, type = "b",
#      xlab = "Abnormal Return", ylab = "Power",
#      main = "Power Curve")
# abline(h = 0.05, lty = 2, col = "grey")

## ----sample-sizes-------------------------------------------------------------
# sample_sizes <- c(5, 10, 20, 50, 100)
# power_by_n <- sapply(sample_sizes, function(n) {
#   res <- simulate_event_study(
#     n_events = n,
#     abnormal_return = 0.01,
#     n_simulations = 500,
#     seed = 42
#   )
#   res$power
# })
# 
# plot(sample_sizes, power_by_n, type = "b",
#      xlab = "Number of Events", ylab = "Power",
#      main = "Power vs Sample Size (AR = 1%)")

## ----dgp----------------------------------------------------------------------
# result <- simulate_event_study(
#   n_events = 20,
#   abnormal_return = 0.01,
#   n_simulations = 500,
#   dgp_params = list(
#     alpha = 0.0001,         # drift
#     beta = 1.2,             # market exposure
#     sigma_firm = 0.015,     # idiosyncratic volatility
#     sigma_market = 0.02     # market volatility
#   ),
#   seed = 42
# )

## ----test-stats---------------------------------------------------------------
# tests <- c("CSectT", "PatellZ", "BMP", "SignT", "RankT")
# power_by_test <- sapply(tests, function(ts) {
#   res <- simulate_event_study(
#     n_events = 20,
#     abnormal_return = 0.01,
#     test_statistic = ts,
#     n_simulations = 500,
#     seed = 42
#   )
#   res$power
# })
# 
# barplot(power_by_test, main = "Power by Test Statistic (AR = 1%)",
#         ylab = "Power", las = 2)
# abline(h = 0.05, lty = 2, col = "grey")

## ----rejection-by-day---------------------------------------------------------
# result <- simulate_event_study(
#   n_events = 20,
#   abnormal_return = 0.02,
#   n_simulations = 500,
#   seed = 42
# )
# 
# result$rejection_by_day
# #> # A tibble: 11 x 2
# #>    relative_index rejection_rate
# #>             <int>          <dbl>
# #>  1             -5         0.048
# #>  2             -4         0.052
# #>  ...
# #>  6              0         0.723   <-- event day
# #>  ...

## ----seed---------------------------------------------------------------------
# r1 <- simulate_event_study(n_events = 10, n_simulations = 100, seed = 42)
# r2 <- simulate_event_study(n_events = 10, n_simulations = 100, seed = 42)
# identical(r1$power, r2$power)  # TRUE

