## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE
)

## ----load-packages------------------------------------------------------------
# library(EventStudy)
# library(dplyr)
# library(ggplot2)

## ----run-study----------------------------------------------------------------
# set.seed(42)
# 
# n <- 300
# dates <- format(seq(as.Date("2014-06-01"), by = "day", length.out = n),
#                 "%d.%m.%Y")
# 
# # Four firms, two groups
# firms <- c("FIRM_A", "FIRM_B", "FIRM_C", "FIRM_D")
# firm_tbl <- purrr::map_dfr(firms, function(sym) {
#   tibble(
#     symbol   = sym,
#     date     = dates,
#     adjusted = 100 * cumprod(1 + rnorm(n, 0.0003, 0.015))
#   )
# })
# 
# index_tbl <- tibble(
#   symbol   = "INDEX_1",
#   date     = dates,
#   adjusted = 1000 * cumprod(1 + rnorm(n, 0.0002, 0.012))
# )
# 
# request_tbl <- tibble(
#   event_id                = 1:4,
#   firm_symbol             = firms,
#   index_symbol            = rep("INDEX_1", 4),
#   event_date              = rep(dates[200], 4),
#   group                   = c("Large", "Large", "Small", "Small"),
#   event_window_start      = rep(-10L, 4),
#   event_window_end        = rep(10L, 4),
#   shift_estimation_window = rep(-11L, 4),
#   estimation_window_length = rep(150L, 4)
# )
# 
# task <- EventStudyTask$new(firm_tbl, index_tbl, request_tbl)
# task <- run_event_study(task)

## ----csreg-basic--------------------------------------------------------------
# firm_chars <- tibble(
#   event_id       = 1:4,
#   log_market_cap = c(10.2, 11.5, 8.3, 9.1),
#   leverage       = c(0.3, 0.5, 0.2, 0.4),
#   r_and_d        = c(0.05, 0.02, 0.08, 0.06)
# )
# 
# result <- cross_sectional_regression(
#   task,
#   formula = ~ log_market_cap + leverage,
#   data    = firm_chars
# )
# 
# print(result)
# #> Cross-Sectional Regression of CARs
# #> ===================================
# #> N: 4
# #> R-squared: 0.85
# #> Adj. R-squared: 0.55
# #>
# #> Coefficients:
# #>                 estimate std.error statistic p.value
# #> (Intercept)      0.1234    0.0567     2.178  0.1615
# #> log_market_cap  -0.0123    0.0054    -2.278  0.1500
# #> leverage        -0.0456    0.0321    -1.421  0.2912

## ----csreg-robust-------------------------------------------------------------
# # HC1 robust standard errors (default)
# result_robust <- cross_sectional_regression(
#   task, formula = ~ log_market_cap + leverage,
#   data = firm_chars, robust = TRUE
# )
# 
# # Plain OLS standard errors
# result_ols <- cross_sectional_regression(
#   task, formula = ~ log_market_cap + leverage,
#   data = firm_chars, robust = FALSE
# )

## ----csreg-window-------------------------------------------------------------
# result_3day <- cross_sectional_regression(
#   task,
#   formula    = ~ log_market_cap + leverage,
#   data       = firm_chars,
#   car_window = c(-1, 1)  # relative indices
# )

## ----csreg-data---------------------------------------------------------------
# # Merged data with CARs and firm characteristics
# result$car_data
# #> # A tibble: 4 x 6
# #>   event_id firm_symbol group   car log_market_cap leverage
# #>      <int> <chr>       <chr> <dbl>          <dbl>    <dbl>
# #> ...
# 
# # The fitted lm object
# summary(result$model)

## ----group-comparison---------------------------------------------------------
# group_result <- car_by_group(task)
# 
# # Summary statistics by group
# group_result$summary
# #> # A tibble: 2 x 7
# #>   group     n mean_car  sd_car median_car min_car max_car
# #>   <chr> <int>    <dbl>   <dbl>      <dbl>   <dbl>   <dbl>
# #>   Large     2   0.012   0.008      0.012   0.006   0.018
# #>   Small     2  -0.005   0.003     -0.005  -0.007  -0.003
# 
# # Test result
# group_result$test_name
# #> [1] "Welch Two-Sample t-test"
# 
# group_result$test

## ----group-window-------------------------------------------------------------
# group_3day <- car_by_group(task, car_window = c(-1, 1))
# group_3day$summary

## ----quantiles----------------------------------------------------------------
# car_quantiles(task)
# #>    5%   25%   50%   75%   95%
# #> -0.02  0.00  0.01  0.02  0.03
# 
# # Custom quantiles
# car_quantiles(task, probs = c(0.01, 0.1, 0.5, 0.9, 0.99))
# 
# # Quantiles for a specific CAR window
# car_quantiles(task, car_window = c(0, 5))

## ----plot-histogram, fig.width=7, fig.height=4--------------------------------
# plot_car_distribution(task)

## ----plot-histogram-group, fig.width=7, fig.height=4--------------------------
# plot_car_distribution(task, by_group = TRUE,
#                       title = "CAR Distribution by Firm Size")

## ----plot-histogram-window, fig.width=7, fig.height=4-------------------------
# plot_car_distribution(task, car_window = c(-1, 1),
#                       title = "3-Day CAR Distribution")

## ----complete-workflow--------------------------------------------------------
# # 1. Run the event study
# task <- EventStudyTask$new(firm_tbl, index_tbl, request_tbl)
# task <- run_event_study(task)
# 
# # 2. Summary statistics
# car_quantiles(task)
# 
# # 3. Group comparison
# group_result <- car_by_group(task)
# print(group_result$summary)
# 
# # 4. Visual exploration
# plot_car_distribution(task, by_group = TRUE)
# 
# # 5. Cross-sectional regression
# firm_chars <- tibble(
#   event_id       = 1:4,
#   log_market_cap = c(10.2, 11.5, 8.3, 9.1),
#   leverage       = c(0.3, 0.5, 0.2, 0.4)
# )
# 
# result <- cross_sectional_regression(
#   task,
#   formula = ~ log_market_cap + leverage,
#   data    = firm_chars
# )
# print(result)
# 
# # 6. Robustness: different CAR windows
# windows <- list(c(-1, 1), c(-5, 5), c(0, 10))
# purrr::walk(windows, function(w) {
#   r <- cross_sectional_regression(
#     task, formula = ~ log_market_cap + leverage,
#     data = firm_chars, car_window = w
#   )
#   cat("\nCAR window [", w[1], ",", w[2], "]:\n")
#   print(r$coefficients)
# })

