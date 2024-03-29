% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dataHandling.R
\name{checkFiles}
\alias{checkFiles}
\title{Check EventStudy input files}
\usage{
checkFiles(
  dataFiles = c(request_file = "01_RequestFile.csv", firm_data = "02_firmData.csv",
    market_data = "03_MarketData.csv"),
  returnData = F
)
}
\arguments{
\item{dataFiles}{A named character vector. The names must be request_file, 
firm_data, and market_data}

\item{returnData}{returns the data as list of data.frames}
}
\description{
Check each input file plus inter file relations, whether market
index and firm identifier in request file match market index in market_data and firm identifier in 
in firm_data file.
}
\examples{
\dontrun{
# save example files to current working directory
getSP500ExampleFiles()

dataFiles <- c("request_file" = "01_RequestFile.csv", 
               "firm_data"    = "02_firmData.csv", 
               "market_data"  = "03_MarketData.csv")
               
checkFiles(dataFiles)
}

}
