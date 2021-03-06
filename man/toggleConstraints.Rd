% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/loading_functions.R
\name{toggleConstraints}
\alias{toggleConstraints}
\title{Toggle constraints}
\usage{
toggleConstraints(object, on = NULL, off = NULL)
}
\arguments{
\item{object}{a \code{\linkS4class{constraints}} object from \code{\link{loadConstraints}}.}

\item{on}{constraint indices to mark as active.}

\item{off}{constraint indices to mark as inactive.}
}
\value{
\code{\link{toggleConstraints}} returns the updated \code{\linkS4class{constraints}} object.
}
\description{
\code{\link{toggleConstraints}} is a function to toggle individual constraints in a \code{\linkS4class{constraints}} object.
}
\examples{
constraints_science2 <- toggleConstraints(constraints_science, off = 32:36)
constraints_science3 <- toggleConstraints(constraints_science, on = 32:36)

}
