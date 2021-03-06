% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/shadow_functions.R
\docType{methods}
\name{plotExposure}
\alias{plotExposure}
\alias{plotExposure,list-method}
\alias{plotExposure,output_Shadow_all-method}
\title{(deprecated) Plot item exposure rates}
\usage{
plotExposure(
  object,
  max_rate = 0.25,
  theta_segment = "Estimated",
  color = "blue",
  color_final = "blue",
  file_pdf = NULL,
  ...
)

\S4method{plotExposure}{list}(
  object,
  max_rate = 0.25,
  theta_segment = "estimated",
  color = "blue",
  color_final = "blue",
  file_pdf = NULL,
  ...
)

\S4method{plotExposure}{output_Shadow_all}(
  object,
  max_rate = 0.25,
  theta_segment = "estimated",
  color = "blue",
  color_final = "blue",
  file_pdf = NULL,
  ...
)
}
\arguments{
\item{object}{an output object generated by \code{\link{Shadow}}.}

\item{max_rate}{the target exposure rate.}

\item{theta_segment}{the type of theta to use to create segments. Accepts \code{"estimated"} or \code{"true"}. (default = \code{"estimated"})}

\item{color}{Color of item-wise exposure rates.}

\item{color_final}{Color of item-wise exposure rates, only counting the items while in the final theta segment as exposed.}

\item{file_pdf}{If supplied a filename, save as a PDF file.}

\item{...}{Additional options to be passed on to \code{pdf()}.}
}
\description{
(deprecated) Use \code{\link[TestDesign:plot-methods]{plot}} with \code{type = 'exposure'} instead.
}
\examples{
\dontrun{
true_theta <- runif(10, min = -3.5, max = 3.5)
resp_science <- simResp(itempool_science, true_theta)
constraints_science2 <- updateConstraints(constraints_science, off = c(14:20, 32:36))
config_science <- createShadowTestConfig(
  MIP = list(solver = "lpSolve"),
  exposure_control = list(method = "ELIGIBILITY")
)
solution <- Shadow(config_science, constraints_science2, true_theta, data = resp_science)
p <- plotExposure(solution)
}
}
