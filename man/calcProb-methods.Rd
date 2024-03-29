% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calc_prob_functions.r
\docType{methods}
\name{calcProb-methods}
\alias{calcProb-methods}
\alias{calcProb}
\alias{calcProb,item_1PL,numeric-method}
\alias{calcProb,item_2PL,numeric-method}
\alias{calcProb,item_3PL,numeric-method}
\alias{calcProb,item_PC,numeric-method}
\alias{calcProb,item_GPC,numeric-method}
\alias{calcProb,item_GR,numeric-method}
\alias{calcProb,item_pool,numeric-method}
\alias{calcProb,item_1PL,matrix-method}
\alias{calcProb,item_2PL,matrix-method}
\alias{calcProb,item_3PL,matrix-method}
\alias{calcProb,item_PC,matrix-method}
\alias{calcProb,item_GPC,matrix-method}
\alias{calcProb,item_GR,matrix-method}
\alias{calcProb,item_pool,matrix-method}
\alias{calcProb,item_pool_cluster,numeric-method}
\title{Calculate item response probabilities}
\usage{
calcProb(object, theta)

\S4method{calcProb}{item_1PL,numeric}(object, theta)

\S4method{calcProb}{item_2PL,numeric}(object, theta)

\S4method{calcProb}{item_3PL,numeric}(object, theta)

\S4method{calcProb}{item_PC,numeric}(object, theta)

\S4method{calcProb}{item_GPC,numeric}(object, theta)

\S4method{calcProb}{item_GR,numeric}(object, theta)

\S4method{calcProb}{item_pool,numeric}(object, theta)

\S4method{calcProb}{item_1PL,matrix}(object, theta)

\S4method{calcProb}{item_2PL,matrix}(object, theta)

\S4method{calcProb}{item_3PL,matrix}(object, theta)

\S4method{calcProb}{item_PC,matrix}(object, theta)

\S4method{calcProb}{item_GPC,matrix}(object, theta)

\S4method{calcProb}{item_GR,matrix}(object, theta)

\S4method{calcProb}{item_pool,matrix}(object, theta)

\S4method{calcProb}{item_pool_cluster,numeric}(object, theta)
}
\arguments{
\item{object}{an \code{\link{item}} or an \code{\linkS4class{item_pool}} object.}

\item{theta}{theta values to use.}
}
\value{
\describe{
  \item{\code{\link{item}} object:}{\code{\link{calcProb}} returns a (\emph{nq}, \emph{ncat}) matrix of probability values.}
  \item{\code{\linkS4class{item_pool}} object:}{\code{\link{calcProb}} returns a length \emph{ni} list, each containing a matrix of probability values.}
}
\describe{
  \item{\emph{notations}}{\itemize{
    \item{\emph{nq} denotes the number of theta values.}
    \item{\emph{ncat} denotes the number of response categories.}
    \item{\emph{ni} denotes the number of items in the \code{\linkS4class{item_pool}} object.}
  }}
}
}
\description{
\code{\link{calcProb}} is a function to calculate item response probabilities.
}
\examples{
item_1      <- new("item_1PL", difficulty = 0.5)
item_2      <- new("item_2PL", slope = 1.0, difficulty = 0.5)
item_3      <- new("item_3PL", slope = 1.0, difficulty = 0.5, guessing = 0.2)
item_4      <- new("item_PC", threshold = c(-1, 0, 1), ncat = 4)
item_5      <- new("item_GPC", slope = 1.2, threshold = c(-0.8, -1.0, 0.5), ncat = 4)
item_6      <- new("item_GR", slope = 0.9, category = c(-1, 0, 1), ncat = 4)

prob_item_1 <- calcProb(item_1, seq(-3, 3, 1))
prob_item_2 <- calcProb(item_2, seq(-3, 3, 1))
prob_item_3 <- calcProb(item_3, seq(-3, 3, 1))
prob_item_4 <- calcProb(item_4, seq(-3, 3, 1))
prob_item_5 <- calcProb(item_5, seq(-3, 3, 1))
prob_item_6 <- calcProb(item_6, seq(-3, 3, 1))
prob_pool   <- calcProb(itempool_science, seq(-3, 3, 1))

}
\references{
Rasch, G. (1960). \emph{Probabilistic models for some intelligence and attainment tests.}
Copenhagen: Danish Institute for Educational Research.

Lord, F. M. (1952). A theory of test scores (Psychometric Monograph No. 7). Richmond, VA: Psychometric Corporation.

Birnbaum, A. (1957). \emph{Efficient design and use of tests of mental ability for various decision-making problems}
(Series Report No. 58-16. Project No. 7755-23).
Randolph Air Force Base, TX: USAF School of Aviation Medicine.

Birnbaum, A. (1958). \emph{On the estimation of mental ability}
(Series Report No. 15. Project No. 7755-23).
Randolph Air Force Base, TX: USAF School of Aviation Medicine.

Birnbaum, A. (1958). \emph{Further considerations of efficiency in tests of a mental ability}
(Series Report No. 17. Project No. 7755-23).
Randolph Air Force Base, TX: USAF School of Aviation Medicine.

Birnbaum, A. (1968). Some latent trait models and their use in inferring an examinee's ability.
In Lord, F. M., Novick, M. R. (eds.), \emph{Statistical Theories of Mental Test Scores}, 397-479.
Reading, MA: Addison-Wesley.

Masters, G. N. (1982). A Rasch model for partial credit scoring.
\emph{Psychometrika, 47}(2), 149-174.

Andrich, D. (1978). A rating formulation for ordered response categories.
\emph{Psychometrika, 43}(4), 561-573.

Muraki, E. (1992). A generalized partial credit model: Application of an EM algorithm.
\emph{Applied Psychological Measurement, 16}(2), 159-176.

Samejima, F. (1969). Estimation of latent ability using a response pattern of graded scores.
\emph{Psychometrika Monograph, 17}.
}
