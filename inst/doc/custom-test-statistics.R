## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval=FALSE---------------------------------------------------------------
# library(EventStudy)
# 
# WilcoxonARTest <- R6::R6Class("WilcoxonARTest",
#   inherit = TestStatisticBase,
#   public = list(
#     name = "WilcoxonAR",
# 
#     compute = function(data_tbl, model) {
#       event_data <- data_tbl %>%
#         dplyr::filter(event_window == 1)
# 
#       ar <- event_data$abnormal_returns
# 
#       # Wilcoxon signed-rank test against 0
#       test_result <- wilcox.test(ar, mu = 0, conf.int = TRUE)
# 
#       tibble::tibble(
#         n_obs        = length(ar),
#         V_statistic  = test_result$statistic,
#         p_value      = test_result$p.value,
#         median_ar    = median(ar, na.rm = TRUE),
#         conf_low     = test_result$conf.int[1],
#         conf_high    = test_result$conf.int[2]
#       )
#     }
#   )
# )

## ----eval=FALSE---------------------------------------------------------------
# KSTest <- R6::R6Class("KSTest",
#   inherit = TestStatisticBase,
#   public = list(
#     name = "KS",
# 
#     compute = function(data_tbl, model) {
#       aar_stats <- data_tbl %>%
#         dplyr::filter(event_window == 1) %>%
#         dplyr::group_by(relative_index) %>%
#         dplyr::summarise(
#           aar        = mean(abnormal_returns, na.rm = TRUE),
#           n_events   = dplyr::n(),
#           n_pos      = sum(abnormal_returns > 0, na.rm = TRUE),
#           n_neg      = sum(abnormal_returns <= 0, na.rm = TRUE),
#           .groups    = "drop"
#         ) %>%
#         dplyr::mutate(caar = cumsum(aar))
# 
#       # KS test of AARs against normal
#       ks <- ks.test(aar_stats$aar, "pnorm",
#                     mean = 0, sd = sd(aar_stats$aar))
# 
#       aar_stats %>%
#         dplyr::mutate(
#           ks_D      = ks$statistic,
#           ks_pvalue = ks$p.value
#         )
#     }
#   )
# )

## ----eval=FALSE---------------------------------------------------------------
# # Single-event: add to SingleEventStatisticsSet
# single_stats <- SingleEventStatisticsSet$new()
# single_stats$add_test(WilcoxonARTest$new())
# 
# # Multi-event: add to MultiEventStatisticsSet
# multi_stats <- MultiEventStatisticsSet$new()
# multi_stats$add_test(KSTest$new())
# 
# # Or create a custom set from scratch
# custom_single <- StatisticsSetBase$new(
#   tests = list(ARTTest$new(), CARTTest$new(), WilcoxonARTest$new())
# )

## ----eval=FALSE---------------------------------------------------------------
# params <- ParameterSet$new(
#   single_event_statistics = single_stats,
#   multi_event_statistics = multi_stats
# )
# 
# task <- EventStudyTask$new(firm_data, index_data, request_data)
# task <- run_event_study(task, params)
# 
# # Results appear as columns in the task data
# task$data_tbl$WilcoxonAR  # single-event results
# task$aar_caar_tbl$KS       # multi-event results

