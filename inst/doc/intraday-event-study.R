## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE
)

## ----data-structure-----------------------------------------------------------
# library(tibble)
# 
# # Estimation window: 20 days x 50 bars per day
# estimation_window <- tibble(
#   day  = rep(1:20, each = 50),
#   time = rep(sprintf("%02d:%02d", 10L + 1:50 %/% 60L, 1:50 %% 60L), 20),
#   abnormalReturn = rnorm(1000, 0, 0.001)
# )
# 
# # Event window: single day, same 50 bars
# event_window <- tibble(
#   time = sprintf("%02d:%02d", 10L + 1:50 %/% 60L, 1:50 %% 60L),
#   abnormalReturn = rnorm(50, 0, 0.001)
# )
# 
# # Event times to test
# event_times <- c("10:10", "10:30")

## ----task-workflow------------------------------------------------------------
# library(EventStudy)
# 
# # Firm intraday data
# firm_data <- tibble(
#   symbol    = "FIRM_A",
#   timestamp = seq(as.POSIXct("2020-06-15 09:30:00", tz = "UTC"),
#                   by = "1 min", length.out = 500),
#   price     = 100 * cumprod(1 + rnorm(500, 0, 0.001))
# )
# 
# # Index intraday data
# index_data <- tibble(
#   symbol    = "INDEX_1",
#   timestamp = seq(as.POSIXct("2020-06-15 09:30:00", tz = "UTC"),
#                   by = "1 min", length.out = 500),
#   price     = 1000 * cumprod(1 + rnorm(500, 0, 0.0008))
# )
# 
# # Request table
# request <- tibble(
#   event_id                 = 1L,
#   firm_symbol              = "FIRM_A",
#   index_symbol             = "INDEX_1",
#   event_timestamp          = as.POSIXct("2020-06-15 14:30:00", tz = "UTC"),
#   group                    = "Earnings",
#   event_window_start       = -30L,
#   event_window_end         = 30L,
#   shift_estimation_window  = -31L,
#   estimation_window_length = 120L
# )
# 
# # Create task and prepare
# task <- IntradayEventStudyTask$new(firm_data, index_data, request)
# ps   <- ParameterSet$new()
# task <- prepare_intraday_event_study(task, ps)

## ----run-test-----------------------------------------------------------------
# results <- nonparametric_intraday_test(
#   estimation_window = estimation_window,
#   event_window      = event_window,
#   event_times       = event_times,
#   p                 = 0.05,
#   init_window       = 5L,
#   upper             = FALSE
# )

## ----inspect-results----------------------------------------------------------
# results[["10:10"]]
# #> # A tibble: 12 x 4
# #>       id      CAR       CI    fitCI
# #>    <int>    <dbl>    <dbl>    <dbl>
# #>  1     1 -0.00823 -0.00654 -0.00671
# #>  2     2 -0.00912 -0.00701 -0.00698
# #>  ...

## ----non-significant----------------------------------------------------------
# results[["10:30"]]
# #> # A tibble: 1 x 4
# #>      id   CAR    CI fitCI
# #>   <int> <dbl> <dbl> <dbl>
# #> 1     1     0     0     0

## ----plot-results, fig.width=7, fig.height=4----------------------------------
# library(ggplot2)
# 
# plot_np_result <- function(result_tbl, event_time) {
#   if (nrow(result_tbl) <= 1 && result_tbl$CAR[1] == 0) {
#     message("Event at ", event_time, " is not significant.")
#     return(invisible(NULL))
#   }
# 
#   ggplot(result_tbl, aes(x = id)) +
#     geom_line(aes(y = CAR), colour = "steelblue", linewidth = 1) +
#     geom_line(aes(y = fitCI), colour = "firebrick", linetype = "dashed",
#               linewidth = 0.8) +
#     geom_ribbon(aes(ymin = fitCI, ymax = 0), alpha = 0.1, fill = "firebrick") +
#     labs(
#       title = paste("Non-Parametric Intraday CAR — Event at", event_time),
#       x     = "Bars after event",
#       y     = "Cumulative Abnormal Return"
#     ) +
#     theme_minimal()
# }
# 
# # Plot the first significant event
# plot_np_result(results[["10:10"]], "10:10")

