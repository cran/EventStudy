## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)
Sys.setenv(event_study_api_key = "0245ed2e1d5011d8b87ba116f06e36ea")

## ---- message=F, echo=T, eval=FALSE-------------------------------------------
#  library(tidyquant)
#  library(dplyr)
#  library(readr)

## ---- eval=FALSE--------------------------------------------------------------
#  startDate <- "2014-05-01"
#  endDate <- "2015-12-31"

## ---- eval=FALSE--------------------------------------------------------------
#  # Firm Data
#  firmSymbols <- c("VOW.DE", "AUDVF", "PAH3.DE", "BMW.DE", "MBG.DE")
#  firmNames <- c("VW preferred", "Audi", "Porsche Automobil Hld", "BMW", "Daimler")
#  firmSymbols %>%
#    tidyquant::tq_get(from = startDate, to = endDate) %>%
#    dplyr::mutate(date = format(date, "%d.%m.%Y")) -> firmData
#  knitr::kable(head(firmData), pad=0)

## ---- eval=FALSE--------------------------------------------------------------
#  # Index Data
#  indexSymbol <- c("^GDAXI")
#  indexName <- c("^GDAXI")
#  indexSymbol %>%
#    tidyquant::tq_get(from = startDate, to = endDate) %>%
#    dplyr::mutate(date = format(date, "%d.%m.%Y")) -> indexData
#  knitr::kable(head(indexData), pad=0)

## ---- eval=FALSE--------------------------------------------------------------
#  # Price files for firms and market
#  firmData %>%
#    dplyr::select(symbol, date, adjusted) %>%
#    readr::write_delim(file      = "02_firmDataPrice.csv",
#                       delim     = ";",
#                       col_names = F)
#  
#  indexData %>%
#    dplyr::select(symbol, date, adjusted) %>%
#    readr::write_delim(file      = "03_marketDataPrice.csv",
#                       delim     = ";",
#                       col_names = F)
#  
#  # Volume files for firms and market
#  firmData %>%
#    dplyr::select(symbol, date, volume) %>%
#    readr::write_delim(file      = "02_firmDataVolume.csv",
#                       delim     = ";",
#                       col_names = F)
#  
#  indexData %>%
#    dplyr::select(symbol, date, volume) %>%
#    readr::write_delim(file      = "03_marketDataVolume.csv",
#                       delim     = ";",
#                       col_names = F)

## ---- eval=FALSE--------------------------------------------------------------
#  group <- c(rep("VW Group", 3), rep("Other", 2))
#  request <- cbind(c(1:5), firmSymbols, rep(indexName, 5), rep("18.09.2015", 5), group, rep(-10, 5), rep(10, 5), rep(-11, 5), rep(250, 5))
#  request %>%
#    as.data.frame() %>%
#    readr::write_delim("01_requestFile.csv", delim = ";", col_names = F)

## ---- message=F, eval=F-------------------------------------------------------
#  event_study_api_key = Sys.getenv("event_study_api_key")
#  
#  library(EventStudy)
#  est <- EventStudyAPI$new()
#  est$authentication(apiKey = event_study_api_key)
#  
#  # get & set parameters for abnormal return Event Study
#  # we use a garch model and csv as return
#  # Attention: fitting a GARCH(1, 1) model is compute intensive
#  esaParams <- EventStudy::ARCApplicationInput$new()
#  esaParams$setResultFileType("csv")
#  esaParams$setBenchmarkModel("garch")
#  
#  dataFiles <- c("request_file" = "01_requestFile.csv",
#                 "firm_data"    = "02_firmDataPrice.csv",
#                 "market_data"  = "03_marketDataPrice.csv")
#  
#  # check data files, you can do it also in our R6 class
#  checkFiles(dataFiles)
#  
#  # now let us perform the Event Study
#  est$performEventStudy(estParams     = esaParams,
#                        dataFiles     = dataFiles,
#                        downloadFiles = T)

## ---- message=F, eval=F-------------------------------------------------------
#  estParser <- ResultParser$new()
#  analysis_report = estParser$get_analysis_report("results/analysis_report.csv")
#  ar_result = estParser$get_ar("results/ar_results.csv", analysis_report)
#  aar_result = estParser$get_aar("results/aar_results.csv")

## ---- eval=F------------------------------------------------------------------
#  knitr::kable(head(ar_result$ar_tbl))

## ---- eval=F------------------------------------------------------------------
#  knitr::kable(head(aar_result$aar_tbl))

## ---- eval=F------------------------------------------------------------------
#  knitr::kable(head(aar_result$statistics_tbl))

## ---- eval=F------------------------------------------------------------------
#  aar_result$plot_test_statistics()

## ---- eval=F------------------------------------------------------------------
#  aar_result$plot(ci_statistics = "Patell Z")

## ---- eval=F------------------------------------------------------------------
#  aar_result$plot_cumulative()

## ---- message=F, eval=F-------------------------------------------------------
#  event_study_api_key = Sys.getenv("event_study_api_key")
#  est <- EventStudyAPI$new()
#  est$authentication(apiKey = event_study_api_key)
#  
#  # get & set parameters for abnormal return Event Study
#  esaParams <- EventStudy::AVyCApplicationInput$new()
#  esaParams$setResultFileType("csv")
#  
#  est$performEventStudy(estParams     = esaParams,
#                        dataFiles     = dataFiles,
#                        downloadFiles = T)

## ---- message=F, eval=F-------------------------------------------------------
#  estParser <- ResultParser$new()
#  analysis_report = estParser$get_analysis_report("results/analysis_report.csv")
#  ar_result = estParser$get_ar("results/ar_results.csv", analysis_report)
#  aar_result = estParser$get_aar("results/aar_results.csv")

## ---- eval=F------------------------------------------------------------------
#  aar_result$plot_cumulative()

## ---- message=F, eval=F-------------------------------------------------------
#  event_study_api_key = Sys.getenv("event_study_api_key")
#  est <- EventStudyAPI$new()
#  est$authentication(apiKey = event_study_api_key)
#  
#  # get & set parameters for abnormal return Event Study
#  esaParams <- EventStudy::AVyCApplicationInput$new()
#  esaParams$setResultFileType("csv")
#  
#  est$performEventStudy(estParams     = esaParams,
#                        dataFiles     = dataFiles,
#                        downloadFiles = T)

