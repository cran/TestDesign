% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RcppExports.R
\name{calc_posterior_function}
\alias{calc_posterior_function}
\title{Calculate a posterior distribution of theta}
\usage{
calc_posterior_function(
  theta_grid,
  item_parm,
  resp,
  ncat,
  model,
  prior,
  prior_parm
)
}
\arguments{
\item{theta_grid}{An equi-spaced grid of theta values.}

\item{item_parm}{A numeric matrix of item parameters.}

\item{resp}{a numeric vector containing item responses.}

\item{ncat}{A numeric vector of the number of response categories by item.}

\item{model}{A numeric vector indicating the IRT models of each item (1: 1PL, 2: 2PL, 3: 3PL, 4: PC, 5: GPC, 6: GR).}

\item{prior}{The type of prior distribution (1: normal, 2: uniform).}

\item{prior_parm}{A numeric vector of hyperparameters for the prior distribution, c(mu, sigma) or c(ll, ul).}
}
\description{
Calculate a posterior distribution of theta.
}
