## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE
)

## ----rolling-basic------------------------------------------------------------
# library(EventStudy)
# 
# task <- EventStudyTask$new(firm_data, index_data, request)
# 
# ps <- ParameterSet$new(
#   return_model = RollingWindowModel$new(window_size = 60)
# )
# task <- run_event_study(task, ps)

## ----rolling-params-----------------------------------------------------------
# # Shorter window: more responsive but noisier
# rw_short <- RollingWindowModel$new(window_size = 30, min_obs = 20)
# 
# # Longer window: smoother but slower to adapt
# rw_long <- RollingWindowModel$new(window_size = 120, min_obs = 60)

## ----rolling-diagnostics------------------------------------------------------
# ps <- ParameterSet$new(
#   return_model = RollingWindowModel$new(window_size = 60)
# )
# task <- run_event_study(task, ps)
# 
# # Access rolling parameters from the fitted model
# model_data <- task$data_tbl$data[[1]]
# model_obj <- task$data_tbl$model[[1]]
# stats <- model_obj$statistics
# 
# # Rolling betas over the estimation window
# plot(stats$rolling_betas, type = "l",
#      main = "Rolling Beta over Estimation Window",
#      xlab = "Window Index", ylab = "Beta")
# abline(h = stats$beta, lty = 2, col = "red")  # final beta

## ----dcc-install--------------------------------------------------------------
# install.packages("rmgarch")

## ----dcc-basic----------------------------------------------------------------
# ps <- ParameterSet$new(
#   return_model = DCCGARCHModel$new()
# )
# task <- run_event_study(task, ps)

## ----dcc-orders---------------------------------------------------------------
# # GARCH(2,1) with DCC(1,2)
# dcc <- DCCGARCHModel$new(
#   garch_order = c(2, 1),
#   dcc_order = c(1, 2)
# )
# 
# ps <- ParameterSet$new(return_model = dcc)

