## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE
)

## ----stock-basic--------------------------------------------------------------
# library(EventStudy)
# 
# # Download a single stock
# aapl <- download_stock_data("AAPL", from = "2023-01-01", to = "2024-12-31")
# head(aapl)
# #> # A tibble: 6 x 3
# #>   symbol date       adjusted
# #>   <chr>  <chr>         <dbl>
# #> 1 AAPL   02.01.2023     130.
# #> 2 AAPL   03.01.2023     126.
# #> ...

## ----stock-multiple-----------------------------------------------------------
# stocks <- download_stock_data(
#   c("AAPL", "MSFT", "GOOGL", "AMZN"),
#   from = "2023-01-01",
#   to = "2024-12-31"
# )

## ----stock-format-------------------------------------------------------------
# # Formatted for direct use
# firm_data <- download_stock_data(
#   c("AAPL", "MSFT"),
#   from = "2022-01-01",
#   format_for_task = TRUE
# )
# 
# # Download index data
# index_data <- download_stock_data(
#   "^GSPC",  # S&P 500
#   from = "2022-01-01",
#   format_for_task = TRUE
# )
# 
# # Create the task directly
# request <- tibble::tibble(
#   event_id = 1:2,
#   firm_symbol = c("AAPL", "MSFT"),
#   index_symbol = "^GSPC",
#   event_date = c("15.06.2023", "15.06.2023"),
#   group = "Tech",
#   event_window_start = -5,
#   event_window_end = 5,
#   shift_estimation_window = -6,
#   estimation_window_length = 120
# )
# 
# task <- EventStudyTask$new(firm_data, index_data, request)

## ----stock-raw----------------------------------------------------------------
# raw_data <- download_stock_data("AAPL", from = "2023-01-01",
#                                   format_for_task = FALSE)

## ----ff3----------------------------------------------------------------------
# ff3 <- download_factor_data(model = "ff3", frequency = "daily")
# head(ff3)
# #> # A tibble: 6 x 5
# #>   date       market_excess     smb     hml risk_free_rate
# #>   <chr>              <dbl>   <dbl>   <dbl>          <dbl>
# #> 1 03.01.2023        0.0112  0.0023 -0.0045         0.0002
# #> ...

## ----ff5----------------------------------------------------------------------
# ff5 <- download_factor_data(model = "ff5", frequency = "daily")
# # Includes: market_excess, smb, hml, rmw, cma, risk_free_rate

## ----monthly------------------------------------------------------------------
# ff3_monthly <- download_factor_data(model = "ff3", frequency = "monthly")

## ----factor-task--------------------------------------------------------------
# # Download data
# firm_data <- download_stock_data(c("AAPL", "MSFT"), from = "2022-01-01")
# index_data <- download_stock_data("^GSPC", from = "2022-01-01")
# factor_tbl <- download_factor_data(model = "ff3", frequency = "daily")
# 
# # Create task with factor data
# task <- EventStudyTask$new(firm_data, index_data, request,
#                             factor_tbl = factor_tbl)
# 
# # Use a factor model
# ps <- ParameterSet$new(
#   return_model = FamaFrench3FactorModel$new()
# )
# task <- run_event_study(task, ps)

## ----rf-----------------------------------------------------------------------
# rf <- download_risk_free_rate(frequency = "daily")
# head(rf)
# #> # A tibble: 6 x 2
# #>   date       risk_free_rate
# #>   <chr>               <dbl>
# #> 1 03.01.2023         0.0002
# #> ...

