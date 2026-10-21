## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment  = "#>"
)
# Keep this vignette offline and API-key-free at build time. The deterministic
# advisor chunks below evaluate live against the bundled `dieselgate` data; the
# LLM chunk is eval = FALSE and its output is shown as a static captured block.
Sys.setenv(EVENTSTUDY_NO_NETWORK = "1")

## ----load-data----------------------------------------------------------------
library(EventStudy)
data(dieselgate)

names(dieselgate)
dieselgate$request[, c("event_id", "firm_symbol", "group",
                       "event_window_start", "event_window_end",
                       "estimation_window_length")]

## ----run-pipeline-------------------------------------------------------------
task <- EventStudyTask$new(
  dieselgate$firm,
  dieselgate$index,
  dieselgate$request
)
task <- run_event_study(task, ParameterSet$new())

## ----show-ar-car--------------------------------------------------------------
ar  <- task$get_ar(1L)   # event_id 1 = VOW.DE
car <- task$get_car(1L)

# Abnormal returns on the event day (0) and the first three days after
ar[ar$relative_index %in% c(0, 1, 2, 3), c("relative_index", "abnormal_returns")]

# Cumulative abnormal return at the end of the event window
tail(car[, c("relative_index", "car")], 1L)

## ----plot-ar, fig.alt = "Volkswagen abnormal returns across the [-10, +10] event window shown as points with a 95% confidence band around zero; the first two days after the event fall far below the band.", fig.width = 7, fig.height = 4----
plot_event_study(task, type = "ar", event_id = 1L, confidence_level = 0.95,
                 title = "Volkswagen: abnormal returns with 95% confidence band")

## ----plot-car, fig.alt = "VW cumulative abnormal return path across the [-10, +10] window with a 95% confidence band, sliding to roughly -35 percent after the event.", fig.width = 7, fig.height = 4----
plot_event_study(task, type = "car", event_id = 1L, confidence_level = 0.95,
                 title = "VW Group: CAR with 95% confidence band")

## ----show-caar----------------------------------------------------------------
vw_caar    <- task$aar_caar_tbl[task$aar_caar_tbl$group == "VW Group", ]$CSectT[[1]]
other_caar <- task$aar_caar_tbl[task$aar_caar_tbl$group == "Other", ]$CSectT[[1]]

# VW Group CAAR at end of event window
tail(vw_caar[, c("relative_index", "aar", "caar", "caar_t")], 1L)

# Other CAAR at end of event window
tail(other_caar[, c("relative_index", "aar", "caar", "caar_t")], 1L)

## ----plot-caar-comparison, fig.alt = "Multi-group CAAR comparison: VW Group CAAR slides to roughly -39 percent while Other automakers stay near zero, with 95% confidence bands for each group.", fig.width = 7, fig.height = 4----
# Build a combined CAAR comparison with CI ribbons using the computed stats.
# VW Group
vw_plt    <- vw_caar
other_plt <- other_caar

# Compute 95% CI half-width from caar / caar_t
z_val <- stats::qnorm(0.975)
vw_plt$se    <- ifelse(vw_plt$caar_t != 0,
                       abs(vw_plt$caar / vw_plt$caar_t), NA_real_)
other_plt$se <- ifelse(other_plt$caar_t != 0,
                       abs(other_plt$caar / other_plt$caar_t), NA_real_)

vw_plt$ci_lower    <- vw_plt$caar    - z_val * vw_plt$se
vw_plt$ci_upper    <- vw_plt$caar    + z_val * vw_plt$se
other_plt$ci_lower <- other_plt$caar - z_val * other_plt$se
other_plt$ci_upper <- other_plt$caar + z_val * other_plt$se

vw_plt$group    <- "VW Group"
other_plt$group <- "Other"

combined <- dplyr::bind_rows(
  vw_plt[, c("relative_index", "caar", "ci_lower", "ci_upper", "group")],
  other_plt[, c("relative_index", "caar", "ci_lower", "ci_upper", "group")]
)
group_colours <- c("VW Group" = "firebrick", "Other" = "steelblue")

ggplot2::ggplot(combined,
                ggplot2::aes(x = relative_index, colour = group, fill = group)) +
  ggplot2::geom_ribbon(ggplot2::aes(ymin = ci_lower, ymax = ci_upper),
                       alpha = 0.15, colour = NA) +
  ggplot2::geom_line(ggplot2::aes(y = caar), linewidth = 0.9) +
  ggplot2::geom_point(ggplot2::aes(y = caar), size = 1.2) +
  ggplot2::geom_hline(yintercept = 0, linetype = "dashed", colour = "grey40",
                      linewidth = 0.3) +
  ggplot2::geom_vline(xintercept = 0, linetype = "dotted", colour = "grey60",
                      linewidth = 0.3) +
  ggplot2::scale_colour_manual(values = group_colours) +
  ggplot2::scale_fill_manual(values = group_colours) +
  ggplot2::labs(
    title    = "CAAR by group: VW Group vs. peer automakers",
    subtitle = "Shaded bands = 95% CI; event day at dashed vertical line",
    x        = "Trading days relative to event",
    y        = "Cumulative average abnormal return",
    colour   = "Group",
    fill     = "Group"
  ) +
  ggplot2::theme_minimal() +
  ggplot2::theme(legend.position = "bottom")

## ----diagnostics--------------------------------------------------------------
diag <- es_diagnostics(task)
diag

## ----recommend-stat-----------------------------------------------------------
recommend_stat(diag)

## ----flag-robustness----------------------------------------------------------
flag_robustness(diag)

## ----llm-call, eval = FALSE---------------------------------------------------
# # Requires an LLM provider and, for Anthropic/OpenAI-compatible providers,
# # the optional `httr2` + `jsonlite` Suggests and an API key in the environment.
# p      <- provider("anthropic")                 # or provider("openai_compatible", ...)
# advice <- es_advise(diag, task_type = "recommend_stat", provider = p)
# print(advice)

