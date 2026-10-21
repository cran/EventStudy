## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval=FALSE---------------------------------------------------------------
# library(EventStudy)
# library(dplyr)
# library(ggplot2)

## ----eval=FALSE---------------------------------------------------------------
# set.seed(42)
# n_units <- 30
# n_periods <- 20
# treat_period <- 10
# true_effect <- 2.0
# 
# dataset_a <- tibble(
#   unit_id = rep(1:n_units, each = n_periods),
#   time_id = rep(1:n_periods, n_units)
# ) %>%
#   mutate(
#     # First 15 units are treated at period 10
#     treatment_time = ifelse(unit_id <= 15, treat_period, NA_integer_),
#     treated = ifelse(!is.na(treatment_time) & time_id >= treatment_time, 1, 0),
#     # Unit and time fixed effects + treatment effect + noise
#     unit_fe = rep(rnorm(n_units, 0, 1), each = n_periods),
#     time_fe = rep(rnorm(n_periods, 0, 0.5), n_units),
#     outcome = unit_fe + time_fe + true_effect * treated + rnorm(n() , 0, 1)
#   )

## ----eval=FALSE---------------------------------------------------------------
# set.seed(123)
# n_units_b <- 50
# n_periods_b <- 20
# 
# dataset_b <- tibble(
#   unit_id = rep(1:n_units_b, each = n_periods_b),
#   time_id = rep(1:n_periods_b, n_units_b)
# ) %>%
#   mutate(
#     # Assign cohorts: units 1-12 at t=8, 13-25 at t=12, 26-37 at t=16, rest never
#     treatment_time = case_when(
#       unit_id <= 12             ~ 8L,
#       unit_id > 12 & unit_id <= 25 ~ 12L,
#       unit_id > 25 & unit_id <= 37 ~ 16L,
#       TRUE                      ~ NA_integer_
#     ),
#     treated = ifelse(!is.na(treatment_time) & time_id >= treatment_time, 1, 0),
#     # Heterogeneous effects: early adopters have larger effects
#     true_te = case_when(
#       treatment_time == 8  ~ 3.0,
#       treatment_time == 12 ~ 2.0,
#       treatment_time == 16 ~ 1.0,
#       TRUE                 ~ 0
#     ),
#     unit_fe = rep(rnorm(n_units_b, 0, 1), each = n_periods_b),
#     time_fe = rep(rnorm(n_periods_b, 0, 0.5), n_units_b),
#     outcome = unit_fe + time_fe + true_te * treated + rnorm(n(), 0, 1)
#   )

## ----eval=FALSE---------------------------------------------------------------
# task_a <- PanelEventStudyTask$new(
#   dataset_a,
#   unit_id        = "unit_id",
#   time_id        = "time_id",
#   outcome        = "outcome",
#   treatment      = "treated",
#   treatment_time = "treatment_time"
# )
# task_a
# #> PanelEventStudyTask
# #>   Units:    30
# #>   Periods:  20
# #>   Treated:  1 cohort(s)
# #>   Outcome:  outcome
# #>   Estimated: FALSE
# 
# task_b <- PanelEventStudyTask$new(
#   dataset_b,
#   unit_id        = "unit_id",
#   time_id        = "time_id",
#   outcome        = "outcome",
#   treatment      = "treated",
#   treatment_time = "treatment_time"
# )

## ----eval=FALSE---------------------------------------------------------------
# task_a <- estimate_panel_event_study(task_a, method = "static_twfe")
# task_a$results$coefficients
# #>   term  estimate std.error statistic  p.value
# #>   ATT   2.01     0.15      13.4      <0.001

## ----eval=FALSE---------------------------------------------------------------
# task_a <- estimate_panel_event_study(
#   task_a,
#   method      = "dynamic_twfe",
#   leads       = 5,
#   lags        = 5,
#   base_period = -1
# )
# 
# task_a$results$coefficients
# #>   relative_time estimate std.error statistic p.value
# #>              -5    0.02     0.30      0.07    0.95
# #>              -4   -0.10     0.28     -0.36    0.72
# #>              ...
# #>              -1    0.00     0.00        NA      NA
# #>               0    1.95     0.22      8.86   <0.001
# #>               1    2.03     0.23      8.83   <0.001
# #>              ...

## ----eval=FALSE---------------------------------------------------------------
# plot_panel_event_study(task_a, title = "Dynamic TWFE - Single Cohort")

## ----eval=FALSE---------------------------------------------------------------
# # Normalize to two periods before treatment
# task_a <- estimate_panel_event_study(
#   task_a,
#   method      = "dynamic_twfe",
#   leads       = 5,
#   lags        = 5,
#   base_period = -2
# )

## ----eval=FALSE---------------------------------------------------------------
# # Narrow window: leads = 3, lags = 3
# task_a_narrow <- estimate_panel_event_study(
#   task_a,
#   method = "dynamic_twfe",
#   leads  = 3,
#   lags   = 3
# )
# task_a_narrow$results$coefficients
# 
# # Wider window: leads = 8, lags = 8
# task_a_wide <- estimate_panel_event_study(
#   task_a,
#   method = "dynamic_twfe",
#   leads  = 8,
#   lags   = 8
# )
# task_a_wide$results$coefficients

## ----eval=FALSE---------------------------------------------------------------
# task_b <- estimate_panel_event_study(
#   task_b,
#   method = "sun_abraham",
#   leads  = 5,
#   lags   = 5
# )
# 
# task_b$results$coefficients

## ----eval=FALSE---------------------------------------------------------------
# # TWFE on staggered data (potentially biased)
# task_b_twfe <- PanelEventStudyTask$new(
#   dataset_b,
#   unit_id = "unit_id", time_id = "time_id",
#   outcome = "outcome", treatment = "treated",
#   treatment_time = "treatment_time"
# )
# task_b_twfe <- estimate_panel_event_study(
#   task_b_twfe,
#   method = "dynamic_twfe",
#   leads = 5, lags = 5
# )
# 
# # Sun & Abraham on the same data
# task_b_sa <- PanelEventStudyTask$new(
#   dataset_b,
#   unit_id = "unit_id", time_id = "time_id",
#   outcome = "outcome", treatment = "treated",
#   treatment_time = "treatment_time"
# )
# task_b_sa <- estimate_panel_event_study(
#   task_b_sa,
#   method = "sun_abraham",
#   leads = 5, lags = 5
# )
# 
# # Side-by-side comparison
# coefs_comparison <- bind_rows(
#   task_b_twfe$results$coefficients %>% mutate(method = "Dynamic TWFE"),
#   task_b_sa$results$coefficients   %>% mutate(method = "Sun & Abraham")
# )
# 
# ggplot(coefs_comparison, aes(x = relative_time, y = estimate, color = method)) +
#   geom_hline(yintercept = 0, linetype = "dashed", color = "grey40") +
#   geom_vline(xintercept = -0.5, linetype = "dotted", color = "red", alpha = 0.6) +
#   geom_point(position = position_dodge(width = 0.3), size = 2) +
#   geom_line(position = position_dodge(width = 0.3), linewidth = 0.8) +
#   labs(
#     title = "TWFE vs Sun & Abraham: Staggered Adoption",
#     x     = "Relative Time to Treatment",
#     y     = "Estimate",
#     color = "Method"
#   ) +
#   theme_minimal()

## ----eval=FALSE---------------------------------------------------------------
# coefs <- task_a$results$coefficients
# pre_treatment <- coefs %>%
#   filter(relative_time < 0, relative_time != -1)  # exclude base period
# 
# if (nrow(pre_treatment) > 0) {
#   f_stat <- sum(pre_treatment$estimate^2 / pre_treatment$std.error^2) /
#     nrow(pre_treatment)
#   p_value <- pf(f_stat, df1 = nrow(pre_treatment),
#                 df2 = task_a$results$model$df.residual,
#                 lower.tail = FALSE)
#   cat("Joint pre-trend F-stat:", round(f_stat, 3), "\n")
#   cat("p-value:               ", round(p_value, 4), "\n")
# }

## ----eval=FALSE---------------------------------------------------------------
# # Construct counterfactual for treated units
# coef_lookup <- task_a$results$coefficients %>%
#   select(relative_time, estimate) %>%
#   deframe()
# 
# counterfactual <- dataset_a %>%
#   filter(!is.na(treatment_time)) %>%
#   mutate(
#     rel_time = time_id - treatment_time,
#     delta_hat = coef_lookup[as.character(rel_time)],
#     delta_hat = ifelse(is.na(delta_hat), 0, delta_hat),
#     outcome_counterfactual = outcome - delta_hat
#   )
# 
# # Plot observed vs counterfactual
# counterfactual_summary <- counterfactual %>%
#   group_by(time_id) %>%
#   summarise(
#     observed       = mean(outcome),
#     counterfactual = mean(outcome_counterfactual),
#     .groups = "drop"
#   )
# 
# ggplot(counterfactual_summary, aes(x = time_id)) +
#   geom_line(aes(y = observed, color = "Observed"), linewidth = 0.8) +
#   geom_line(aes(y = counterfactual, color = "Counterfactual"),
#             linetype = "dashed", linewidth = 0.8) +
#   geom_vline(xintercept = 10, linetype = "dotted", color = "red") +
#   labs(
#     title = "Observed vs Counterfactual Outcomes (Treated Units)",
#     x     = "Time Period",
#     y     = "Mean Outcome",
#     color = NULL
#   ) +
#   theme_minimal()

## ----eval=FALSE---------------------------------------------------------------
# # Cluster-robust SEs at the unit level (the default)
# task_a <- estimate_panel_event_study(
#   task_a,
#   method  = "dynamic_twfe",
#   leads   = 5,
#   lags    = 5,
#   cluster = "unit_id"
# )
# 
# # Cluster at a different level (e.g., state)
# task_a <- estimate_panel_event_study(
#   task_a,
#   method  = "dynamic_twfe",
#   leads   = 5,
#   lags    = 5,
#   cluster = "state_id"
# )

