% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/static_class.R
\docType{class}
\name{output_Static-class}
\alias{output_Static-class}
\title{Class 'output_Static': fixed-form assembly solution}
\description{
\code{\linkS4class{output_Static}} is an S4 class for representing a fixed-form assembly solution.
}
\section{Slots}{

\describe{
\item{\code{call}}{the function call used for obtaining this object.}

\item{\code{MIP}}{a list containing the result from MIP solver.}

\item{\code{selected}}{a \code{\link{data.frame}} containing the selected items and their attributes.}

\item{\code{obj_value}}{the objective value of the solution.}

\item{\code{solve_time}}{the elapsed time in running the solver.}

\item{\code{achieved}}{a \code{\link{data.frame}} containing attributes of the assembled test, by each constraint.}

\item{\code{pool}}{the \code{\linkS4class{item_pool}} used in the assembly.}

\item{\code{config}}{the \code{\linkS4class{config_Static}} used in the assembly.}

\item{\code{constraints}}{the \code{\linkS4class{constraints}} used in the assembly.}
}}

