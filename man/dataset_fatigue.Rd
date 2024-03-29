% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/datasets.R
\docType{data}
\name{dataset_fatigue}
\alias{dataset_fatigue}
\alias{itempool_fatigue_data}
\alias{itemattrib_fatigue_data}
\alias{itemtext_fatigue_data}
\alias{constraints_fatigue_data}
\alias{resp_fatigue_data}
\alias{itempool_fatigue}
\alias{itemattrib_fatigue}
\alias{constraints_fatigue}
\title{Fatigue dataset}
\description{
Item-based example pool with item contents (95 items).
}
\details{
This pool is associated with the following objects:
\itemize{
  \item \code{itempool_fatigue} an \code{\linkS4class{item_pool}} object containing 95 items.
  \item \code{itemattrib_fatigue} an \code{\linkS4class{item_attrib}} object containing 7 item-level attributes.
  \item \code{constraints_fatigue} a \code{\linkS4class{constraints}} object containing 111 constraints.
}

Also, the following objects are intended for illustrating expected data structures.
\itemize{
  \item \code{itempool_fatigue_data} a \code{\link{data.frame}} containing item parameters.
  \item \code{itemattrib_fatigue_data} a \code{\link{data.frame}} containing item attributes.
  \item \code{itemtext_fatigue_data} a \code{\link{data.frame}} containing item texts.
  \item \code{constraints_fatigue_data} a \code{\link{data.frame}} containing constraint specifications.
  \item \code{resp_fatigue_data} a \code{\link{data.frame}} containing raw response data.
}
}
\examples{
itempool_fatigue   <- loadItemPool(itempool_fatigue_data)
itemattrib_fatigue <- loadItemAttrib(itemattrib_fatigue_data, itempool_fatigue)
constraints_fatigue <- loadConstraints(constraints_fatigue_data,
  itempool_fatigue, itemattrib_fatigue)

}
\keyword{datasets}
