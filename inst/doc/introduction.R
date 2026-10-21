## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = TRUE
)

# Vignette-only helper: render a flat tibble/data.frame as a styled HTML table.
# Uses tinytable when available (bold header, right-aligned numerics), falls back
# to knitr::kable() otherwise.  Return the table object so knitr::knit_print()
# renders it -- do NOT call print() inside.
es_tt <- function(x, caption = NULL, digits = 4, bar_cols = c("aar", "caar")) {
  if (requireNamespace("tinytable", quietly = TRUE)) {
    # Identify bar target columns: bar_cols that exist in x and are numeric
    target_cols <- intersect(bar_cols, names(x)[vapply(x, is.numeric, logical(1L))])

    # Local helper: convert a numeric vector to HTML diverging-bar cell strings
    make_bar_html <- function(vals, m, digs) {
      vapply(vals, function(val) {
        num_str <- if (is.na(val)) {
          formatC(NA_real_, digits = digs, format = "f")
        } else {
          formatC(val, digits = digs, format = "f")
        }
        if (is.na(val) || !is.finite(val) || val == 0) {
          paste0(
            '<div style="display:inline-block;position:relative;width:70px;height:0.9em;vertical-align:middle;">',
            '<div style="position:absolute;left:50%;top:0;width:1px;height:100%;background:#9ca3af;"></div>',
            '</div>',
            '<span style="font-variant-numeric:tabular-nums;">', num_str, '</span>'
          )
        } else {
          bar_pct <- round(50 * abs(val) / m, 2)
          bar_pct <- min(bar_pct, 50)
          if (val < 0) {
            bar_style <- paste0(
              'position:absolute;right:50%;top:0;height:100%;',
              'width:', bar_pct, '%;background:#dc2626;'
            )
          } else {
            bar_style <- paste0(
              'position:absolute;left:50%;top:0;height:100%;',
              'width:', bar_pct, '%;background:#16a34a;'
            )
          }
          paste0(
            '<div style="display:inline-block;position:relative;width:70px;height:0.9em;vertical-align:middle;">',
            '<div style="position:absolute;left:50%;top:0;width:1px;height:100%;background:#9ca3af;"></div>',
            '<div style="', bar_style, '"></div>',
            '</div>',
            '<span style="font-variant-numeric:tabular-nums;">', num_str, '</span>'
          )
        }
      }, character(1L))
    }

    # Replace target columns with HTML strings; track which were replaced
    x_out <- x
    for (col in target_cols) {
      m <- max(abs(x_out[[col]]), na.rm = TRUE)
      if (length(m) == 0L || is.na(m) || !is.finite(m) || m == 0) next
      x_out[[col]] <- make_bar_html(x_out[[col]], m, digits)
    }

    # Compute align on the modified frame (bar cols are now character -> "l")
    align <- ifelse(vapply(x_out, is.numeric, logical(1L)), "r", "l")
    tbl <- tinytable::tt(x_out, caption = caption, digits = digits)
    tbl <- tinytable::style_tt(tbl, i = 0L, bold = TRUE)
    for (j_idx in seq_along(align)) {
      tbl <- tinytable::style_tt(tbl, j = j_idx, align = align[[j_idx]])
    }
    tbl
  } else {
    args <- list(x = x, caption = caption)
    if (!is.null(digits)) args$digits <- digits
    do.call(knitr::kable, args)
  }
}

## ----quick-start, eval = FALSE------------------------------------------------
# # Preview of the full pipeline — data objects are loaded and unpacked step-by-step below.
# library(EventStudy)
# 
# # One-call shortcut: prepare -> fit -> calculate, in one step
# est_task <- run_event_study(
#   EventStudyTask$new(firm_tbl, index_tbl, request_tbl),
#   ParameterSet$new(
#     return_calculation      = LogReturn$new(),
#     return_model            = MarketModel$new(),
#     single_event_statistics = SingleEventStatisticsSet$new(),
#     multi_event_statistics  = MultiEventStatisticsSet$new()
#   )
# )
# 
# est_task$aar_caar_tbl

## ----warning=FALSE, message=FALSE---------------------------------------------
library(EventStudy)

# Load the bundled frozen Dieselgate dataset (replaces a live network download via
# tidyquant so this vignette builds fully offline and reproducibly on CRAN/pkgdown).
data(dieselgate)

firm_tbl    <- dieselgate$firm     # symbol / date / adjusted (4 firms, DD-MM-YYYY dates)
index_tbl   <- dieselgate$index    # symbol / date / adjusted (^GDAXI)
request_tbl <- dieselgate$request  # event_id / firm_symbol / index_symbol / event_date /
                                   # group / event_window_start / event_window_end /
                                   # shift_estimation_window / estimation_window_length

## -----------------------------------------------------------------------------
es_tt(head(firm_tbl))

## -----------------------------------------------------------------------------
# Parametrization of the Event Study
log_return = LogReturn$new()
market_model = MarketModel$new()

## -----------------------------------------------------------------------------
# Define single event test statistics
# Per default AR and CAR T-Tests are applied
single_event_tests = SingleEventStatisticsSet$new()

# Per default CSEct T Test is applied (AAR & CAAR)
multiple_event_tests = MultiEventStatisticsSet$new()

## -----------------------------------------------------------------------------
# Setup parameter set
param_set = ParameterSet$new(return_calculation      = log_return,
                             return_model            = market_model,
                             single_event_statistics = single_event_tests,
                             multi_event_statistics  = multiple_event_tests)

## -----------------------------------------------------------------------------
est_task = EventStudyTask$new(firm_tbl, index_tbl, request_tbl)

## -----------------------------------------------------------------------------
head(est_task$data_tbl)

## -----------------------------------------------------------------------------
es_tt(head(est_task$data_tbl$data[[1]]))

## -----------------------------------------------------------------------------
es_tt(est_task$data_tbl$request[[1]])

## -----------------------------------------------------------------------------
est_task = prepare_event_study(est_task, param_set)

## -----------------------------------------------------------------------------
es_tt(head(est_task$data_tbl$data[[1]]))

## -----------------------------------------------------------------------------
est_task = fit_model(est_task, param_set)

## -----------------------------------------------------------------------------
head(est_task$data_tbl)

## -----------------------------------------------------------------------------
est_task$data_tbl$model[[1]]

## -----------------------------------------------------------------------------
est_task = calculate_statistics(est_task, param_set)

## -----------------------------------------------------------------------------
head(est_task$data_tbl)

## -----------------------------------------------------------------------------
es_tt(est_task$data_tbl$ART[[1]])

## -----------------------------------------------------------------------------
es_tt(est_task$data_tbl$CART[[1]])

## -----------------------------------------------------------------------------
est_task$aar_caar_tbl

## -----------------------------------------------------------------------------
es_tt(est_task$aar_caar_tbl$CSectT[[1]])

## ----plot-car-----------------------------------------------------------------
plotly::ggplotly(plot_event_study(est_task, type = "car"))

## ----plot-caar----------------------------------------------------------------
plotly::ggplotly(plot_event_study(est_task, type = "caar"))

