% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/solver_functions.R
\docType{methods}
\name{detectBestSolver}
\alias{detectBestSolver}
\title{Detect best solver}
\usage{
detectBestSolver()
}
\value{
the package name of the best available solver on the system.
}
\description{
Detect best solver
}
\examples{
solver <- detectBestSolver()
cfg <- createStaticTestConfig(MIP = list(solver = solver))
cfg <- createShadowTestConfig(MIP = list(solver = solver))

}
