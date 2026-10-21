## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE
)

## ----install------------------------------------------------------------------
# install.packages(c("rmarkdown", "knitr"))

## ----basic--------------------------------------------------------------------
# library(EventStudy)
# 
# # Run a complete event study
# task <- EventStudyTask$new(firm_data, index_data, request)
# ps <- ParameterSet$new()
# task <- run_event_study(task, ps)
# 
# # Generate report
# generate_report(task, output_file = "my_report.html")

## ----title--------------------------------------------------------------------
# generate_report(
#   task,
#   output_file = "report.html",
#   title = "Earnings Announcement Event Study",
#   author = "John Doe"
# )

## ----sections-----------------------------------------------------------------
# generate_report(
#   task,
#   output_file = "report.html",
#   sections = c("exec_summary", "data_methods", "diagnostics",
#                "results", "robustness", "appendix")
# )

## ----summary-only-------------------------------------------------------------
# generate_report(
#   task,
#   output_file = "summary.html",
#   sections = c("exec_summary", "results")
# )

## ----cross-sectional----------------------------------------------------------
# # Run cross-sectional regression first
# cs_result <- cross_sectional_regression(
#   task,
#   formula = ~ size + leverage,
#   data = firm_chars
# )
# 
# generate_report(
#   task,
#   output_file = "report.html",
#   sections = c("exec_summary", "results", "diagnostics"),
#   cross_sectional = cs_result
# )

## ----pdf----------------------------------------------------------------------
# generate_report(
#   task,
#   output_file = "report.pdf",
#   format = "pdf"
# )

## ----panel--------------------------------------------------------------------
# panel_task <- PanelEventStudyTask$new(
#   panel_data = panel_data,
#   unit_id = "unit_id",
#   time_id = "time_id",
#   outcome = "outcome",
#   treatment = "treatment",
#   treatment_time = "treatment_time"
# )
# panel_task <- estimate_panel_event_study(panel_task, method = "dynamic_twfe")
# 
# generate_report(
#   panel_task,
#   output_file = "panel_report.html",
#   sections = c("exec_summary", "results")
# )

## ----batch--------------------------------------------------------------------
# models <- list(
#   MarketModel$new(),
#   MarketAdjustedModel$new(),
#   FamaFrench3FactorModel$new()
# )
# 
# for (i in seq_along(models)) {
#   ps <- ParameterSet$new(return_model = models[[i]])
#   task <- run_event_study(EventStudyTask$new(firm_data, index_data, request), ps)
# 
#   generate_report(
#     task,
#     output_file = sprintf("report_%s.html", class(models[[i]])[1]),
#     title = paste("Event Study:", class(models[[i]])[1])
#   )
# }

