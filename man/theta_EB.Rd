% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RcppExports.R, R/cpp_theta_documents.r
\name{theta_EB}
\alias{theta_EB}
\alias{theta_EB_single}
\title{(C++) Calculate a theta estimate using EB (Empirical Bayes) method}
\usage{
theta_EB(
  nx,
  theta_init,
  theta_prop,
  item_parm,
  resp,
  ncat,
  model,
  prior,
  prior_parm
)

theta_EB_single(
  nx,
  theta_init,
  theta_prop,
  item_parm,
  resp,
  ncat,
  model,
  prior,
  prior_parm
)
}
\arguments{
\item{nx}{the number of MCMC draws.}

\item{theta_init}{the initial estimate to use.}

\item{theta_prop}{the SD of the proposal distribution.}

\item{item_parm}{a matrix containing item parameters. Each row should represent an item.}

\item{resp}{a vector containing responses on each item.}

\item{ncat}{a vector containing the number of response categories of each item.}

\item{model}{a vector indicating item models of each item, using \itemize{
  \item{\code{1}}: 1PL model
  \item{\code{2}}: 2PL model
  \item{\code{3}}: 3PL model
  \item{\code{4}}: PC model
  \item{\code{5}}: GPC model
  \item{\code{6}}: GR model
}}

\item{prior}{an integer indicating the type of prior distribution, using \itemize{
  \item{\code{1}}: normal distribution
  \item{\code{2}}: uniform distribution
}}

\item{prior_parm}{a vector containing parameters for the prior distribution.}
}
\description{
\code{theta_EB_single()} and \code{theta_EB()} are functions to calculate a theta estimate using EB (Empirical Bayes) method.
}
\details{
\code{theta_EB_single()} is designed for one item, and \code{theta_EB()} is designed for multiple items.

Currently supports unidimensional models.
}
\examples{
# item parameters
item_parm <- matrix(c(
  1, NA,   NA,
  1,  2,   NA,
  1,  2, 0.25,
  0,  1,   NA,
  2,  0,    1,
  2,  0,    2),
  nrow = 6,
  byrow = TRUE
)

ncat  <- c(2, 2, 2, 3, 3, 3)
model <- c(1, 2, 3, 4, 5, 6)
resp  <- c(0, 1, 0, 1, 0, 1)

nx <- 100
theta_init <- 0
theta_prop <- 1.0
set.seed(1)
theta_EB_single(nx, theta_init, theta_prop, item_parm[1, ], resp[1], ncat[1], model[1], 1, c(0, 1))
theta_EB(nx, theta_init, theta_prop, item_parm, resp, ncat, model, 1, c(0, 1))

}
