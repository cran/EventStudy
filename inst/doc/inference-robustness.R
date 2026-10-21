## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE
)

## ----hac----------------------------------------------------------------------
# library(EventStudy)
# 
# task <- EventStudyTask$new(firm_data, index_data, request)
# 
# # Enable HAC SEs on the MarketModel
# ps <- ParameterSet$new(
#   return_model = MarketModel$new(use_hac = TRUE)
# )
# task <- run_event_study(task, ps)

## ----hac-lag------------------------------------------------------------------
# ps <- ParameterSet$new(
#   return_model = MarketModel$new(use_hac = TRUE, hac_lag = 5)
# )

## ----hac-factor---------------------------------------------------------------
# ps <- ParameterSet$new(
#   return_model = FamaFrench3FactorModel$new(use_hac = TRUE)
# )

## ----kp-----------------------------------------------------------------------
# ps <- ParameterSet$new(
#   multi_event_statistics = MultiEventStatisticsSet$new(
#     tests = list(
#       BMPTest$new(),
#       KolariPynnonenTest$new()
#     )
#   )
# )
# task <- run_event_study(task, ps)

## ----bootstrap----------------------------------------------------------------
# task <- create_fitted_mock_task()
# 
# # Run bootstrap with 999 replications
# boot_result <- bootstrap_test(
#   task,
#   n_boot = 999,
#   weight_type = "rademacher",
#   seed = 42
# )
# 
# boot_result
# #> # A tibble: 11 x 5
# #>    relative_index observed_aar observed_caar boot_p_aar boot_p_caar
# #>             <int>        <dbl>         <dbl>      <dbl>       <dbl>
# #>  1             -5      0.00123       0.00123      0.842       0.842
# #>  ...

## ----bootstrap-stat-----------------------------------------------------------
# boot_aar <- bootstrap_test(task, n_boot = 499, statistic = "aar")
# boot_caar <- bootstrap_test(task, n_boot = 499, statistic = "caar")

## ----p-adjust-----------------------------------------------------------------
# task <- create_fitted_mock_task()
# 
# # Benjamini-Hochberg (controls FDR)
# result_bh <- adjust_p_values(task, method = "BH", stat_name = "CSectT")
# 
# # Bonferroni (controls FWER)
# result_bonf <- adjust_p_values(task, method = "bonferroni", stat_name = "CSectT")
# 
# # Holm (less conservative than Bonferroni)
# result_holm <- adjust_p_values(task, method = "holm", stat_name = "CSectT")

## ----p-adjust-result----------------------------------------------------------
# result_bh
# #> # A tibble: 11 x 8+
# #>    relative_index   aar  caar p_raw_aar p_adj_aar p_raw_caar p_adj_caar ...

## ----p-adjust-group-----------------------------------------------------------
# result <- adjust_p_values(task, method = "BH", stat_name = "CSectT",
#                            group = "MyGroup")

## ----combined-----------------------------------------------------------------
# # 1. Use HAC SEs in the model
# ps <- ParameterSet$new(
#   return_model = MarketModel$new(use_hac = TRUE),
#   multi_event_statistics = MultiEventStatisticsSet$new(
#     tests = list(
#       CSectTTest$new(),
#       KolariPynnonenTest$new()
#     )
#   )
# )
# task <- run_event_study(task, ps)
# 
# # 2. Apply multiple testing correction
# adjusted <- adjust_p_values(task, method = "BH", stat_name = "CSectT")
# 
# # 3. Validate with bootstrap
# boot <- bootstrap_test(task, n_boot = 999, seed = 42)

