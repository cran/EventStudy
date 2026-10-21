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
# # Treated unit
# treated_data <- tibble(
#   time = 1:100,
#   outcome = cumsum(rnorm(100, mean = 0.1, sd = 0.5))
# )
# # Inject treatment effect after period 60
# treated_data$outcome[61:100] <- treated_data$outcome[61:100] + 5
# 
# # Donor pool (long format)
# donor_data <- do.call(rbind, lapply(paste0("D", 1:10), function(u) {
#   tibble(
#     unit = u,
#     time = 1:100,
#     outcome = cumsum(rnorm(100, mean = 0.1, sd = 0.5))
#   )
# }))

## ----task---------------------------------------------------------------------
# task <- SyntheticControlTask$new(
#   treated_data = treated_data,
#   donor_data = donor_data,
#   treatment_time = 61
# )
# print(task)
# #> SyntheticControlTask
# #>   Donors:      10
# #>   Periods:     100
# #>   Pre-treat:   60
# #>   Post-treat:  40
# #>   Treatment:   61
# #>   Estimated:   FALSE

## ----quadprog-----------------------------------------------------------------
# task <- estimate_synthetic_control(task, method = "quadprog")

## ----optim--------------------------------------------------------------------
# task <- estimate_synthetic_control(task, method = "optim")

## ----results------------------------------------------------------------------
# # Donor weights (sum to 1, all >= 0)
# task$results$weights
# #>     D1     D2     D3     D4     D5 ...
# #>  0.312  0.000  0.188  0.000  0.500 ...
# 
# # Average treatment effect on the treated
# task$results$att
# #> [1] 4.87
# 
# # Pre- and post-treatment mean squared prediction error
# task$results$pre_mspe
# task$results$post_mspe
# 
# # Full trajectory
# task$results$trajectory
# #> # A tibble: 100 x 4
# #>     time treated synthetic   gap
# #>    <int>   <dbl>     <dbl> <dbl>
# #>  1     1   0.234     0.289 -0.0547
# #>  ...

## ----plot-trajectory----------------------------------------------------------
# plot_synthetic_control(task, type = "trajectory")

## ----plot-gap-----------------------------------------------------------------
# plot_synthetic_control(task, type = "gap")

## ----plot-placebo-------------------------------------------------------------
# task <- sc_placebo_test(task)
# plot_synthetic_control(task, type = "placebo")

## ----placebo------------------------------------------------------------------
# task <- sc_placebo_test(task)
# 
# # p-value
# task$results$placebo$p_value
# 
# # RMSPE ratios for all donor units
# task$results$placebo$rmspe_ratios

## ----placebo-subset-----------------------------------------------------------
# task <- sc_placebo_test(task, n_placebo = 5)

