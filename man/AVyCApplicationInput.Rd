% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/AVyCApplicationInput.R
\name{AVyCApplicationInput}
\alias{AVyCApplicationInput}
\title{Abnormal Volatility Calculation Parameters}
\format{
\code{\link[R6]{R6Class}} object.
}
\value{
a ESTParameters R6 object
}
\description{
This R6 class defines the parameters for the Abnormal Volatility Volume Event 
Study. We recommend to use the \code{set} functionality to setup your Event  
Study, as we check input parameters.

For more details see the help vignette:
\code{vignette("parameters_eventstudy", package = "EventStudy")}
}
\section{Methods}{


\describe{
  \item{\code{$new()}}{Constructor for AVyCApplicationInput}
  \item{\code{$setEMail(eMail)}}{Set the e-Mail address for reporting. This 
  functionality is currently not working.}
  \item{\code{$setBenchmarkModel(model = 'mm')}}{Setter for the benchmark
  models}
  \item{\code{$setReturnType(returnType)}}{Setter for the return type (log 
  or simple)}
  \item{\code{$setTestStatistics(testStatistics)}}{Setter for the test 
  statistics. Per default all available test statistics are applied. You may
  find all test statistics in the vignette 'parameter_eventstudy'}
}
}

\section{Arguments}{

\describe{
 \item{AVyCApplicationInput}{An \code{AVyCApplicationInput} object}
 \item{eMail}{An E-Mail address in \code{String} format}
 \item{model}{A benchmark model in \code{String} format}
 \item{returnType}{A return type in \code{String} format}
 \item{testStatistics}{A \code{String} vector with test statistics}
}
}

\examples{
\dontrun{
# get files for our S&P500 example; 3 files are written in the current 
# working directory
getSP500ExampleFiles()

# Generate a new parameter object
avycParams <- AVyCApplicationInput$new()

# set test statistics
avycParams$setTestStatistics(c("aarptlz", "aarrankz"))

# Setup API object
apiKey <- "{Your API key}"
estSetup <- EventStudyAPI$new()
estSetup$authentication(apiKey)

# Perform Event Study
estSetup$performEventStudy(estParams = avycParams, 
                           dataFiles = c("request_file" = "01_RequestFile.csv",
                                         "firm_data"    = "02_firmData.csv",
                                         "market_data"  = "03_marketData.csv"))

# Download task results and save them in the actiual working directory
estSetup$getTaskResults()
}

}
\section{Super classes}{
\code{\link[EventStudy:ApplicationInputInterface]{EventStudy::ApplicationInputInterface}} -> \code{\link[EventStudy:EventStudyApplicationInput]{EventStudy::EventStudyApplicationInput}} -> \code{AVyCApplicationInput}
}
\section{Public fields}{
\if{html}{\out{<div class="r6-fields">}}
\describe{
\item{\code{key}}{Key of the Parameter set.}

\item{\code{test_statistics}}{Available test statistics.}
}
\if{html}{\out{</div>}}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-AVyCApplicationInput-clone}{\code{AVyCApplicationInput$clone()}}
}
}
\if{html}{\out{
<details open><summary>Inherited methods</summary>
<ul>
<li><span class="pkg-link" data-pkg="EventStudy" data-topic="ApplicationInputInterface" data-id="serialize"><a href='../../EventStudy/html/ApplicationInputInterface.html#method-ApplicationInputInterface-serialize'><code>EventStudy::ApplicationInputInterface$serialize()</code></a></span></li>
<li><span class="pkg-link" data-pkg="EventStudy" data-topic="ApplicationInputInterface" data-id="serializeToJson"><a href='../../EventStudy/html/ApplicationInputInterface.html#method-ApplicationInputInterface-serializeToJson'><code>EventStudy::ApplicationInputInterface$serializeToJson()</code></a></span></li>
<li><span class="pkg-link" data-pkg="EventStudy" data-topic="ApplicationInputInterface" data-id="setNamedList"><a href='../../EventStudy/html/ApplicationInputInterface.html#method-ApplicationInputInterface-setNamedList'><code>EventStudy::ApplicationInputInterface$setNamedList()</code></a></span></li>
<li><span class="pkg-link" data-pkg="EventStudy" data-topic="ApplicationInputInterface" data-id="setResultFileType"><a href='../../EventStudy/html/ApplicationInputInterface.html#method-ApplicationInputInterface-setResultFileType'><code>EventStudy::ApplicationInputInterface$setResultFileType()</code></a></span></li>
<li><span class="pkg-link" data-pkg="EventStudy" data-topic="EventStudyApplicationInput" data-id="setup"><a href='../../EventStudy/html/EventStudyApplicationInput.html#method-EventStudyApplicationInput-setup'><code>EventStudy::EventStudyApplicationInput$setup()</code></a></span></li>
</ul>
</details>
}}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-AVyCApplicationInput-clone"></a>}}
\if{latex}{\out{\hypertarget{method-AVyCApplicationInput-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{AVyCApplicationInput$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
