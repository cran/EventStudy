# Extracted from test_reeval_statistical_fixes.R:417

# prequel ----------------------------------------------------------------------
.me_fixture <- function(event_ids, firm_symbols = NULL, n_est = 30,
                         event_window = -5:5, seed = 1001,
                         sigma_by_event = NULL, n_params_by_event = NULL,
                         all_na_event_ids = integer(0), ar_gen = NULL) {
  set.seed(seed)
  if (is.null(firm_symbols)) firm_symbols <- paste0("F", event_ids)
  n_ew <- length(event_window)

  data_tbl <- purrr::map2_dfr(event_ids, firm_symbols, function(eid, fs) {
    est_idx <- seq(-(n_est + 5), -6)
    if (!is.null(ar_gen)) {
      vals <- ar_gen(eid)
      ar_est <- vals$est
      ar_evt <- vals$evt
    } else {
      ar_est <- rnorm(n_est, sd = 0.01)
      ar_evt <- rnorm(n_ew, sd = 0.01)
    }
    if (eid %in% all_na_event_ids) ar_evt <- rep(NA_real_, n_ew)
    tibble::tibble(
      event_id = eid, firm_symbol = fs, group = "g",
      relative_index = c(est_idx, event_window),
      estimation_window = c(rep(1L, n_est), rep(0L, n_ew)),
      event_window = c(rep(0L, n_est), rep(1L, n_ew)),
      abnormal_returns = c(ar_est, ar_evt)
    )
  })

  model_tbl <- tibble::tibble(
    event_id = event_ids,
    model = purrr::map(event_ids, function(eid) {
      sg <- if (!is.null(sigma_by_event)) sigma_by_event[[as.character(eid)]] else 0.01
      kp <- if (!is.null(n_params_by_event)) n_params_by_event[[as.character(eid)]] else 2
      list(statistics = list(
        sigma = sg,
        degree_of_freedom = n_est - 2,
        residuals = rnorm(n_est, sd = sg),
        n_params = kp,
        forecast_error_corrected_sigma = rep(sg, n_ew)
      ))
    })
  )
  list(data = data_tbl, model = model_tbl)
}
.count_warnings <- function(expr) {
  n <- 0L
  result <- withCallingHandlers(
    expr,
    warning = function(w) { n <<- n + 1L; invokeRestart("muffleWarning") }
  )
  list(result = result, n = n)
}

# test -------------------------------------------------------------------------
set.seed(6001)
n_est <- 100
index_returns <- rnorm(n_est, sd = 0.01)
firm_returns <- 0.001 + 1.1 * index_returns + rnorm(n_est, sd = 0.005)
extreme <- order(abs(index_returns), decreasing = TRUE)[1:10]
firm_returns[extreme] <- NA_real_
n_event <- 5
event_index <- rnorm(n_event, sd = 0.01)
d <- tibble::tibble(
    firm_returns = c(firm_returns, rep(NA_real_, n_event)),
    index_returns = c(index_returns, event_index),
    estimation_window = c(rep(1L, n_est), rep(0L, n_event)),
    event_window = c(rep(0L, n_est), rep(1L, n_event)),
    relative_index = c(seq(-n_est, -1), seq(0, n_event - 1))
  )
m <- MarketModel$new()
expect_no_warning(m$fit(d))
