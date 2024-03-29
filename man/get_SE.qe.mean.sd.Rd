% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/boot.R
\name{get_SE.qe.mean.sd}
\alias{get_SE.qe.mean.sd}
\title{Parametric bootstrap standard error estimation for the quantile estimation approach}
\usage{
\method{get_SE}{qe.mean.sd}(x, nboot = 1000, shift.when.negative = TRUE, shift.val = 0.5, ...)
}
\arguments{
\item{x}{object of class "qe.mean.sd".}

\item{nboot}{numeric value giving the number of bootstrap replicates. The default is \code{1000}.}

\item{shift.when.negative}{logical scalar indicating whether to add a constant to the generated sample quantiles if the smallest quantile (i.e., the minimum value in scenarios S1 and S3, the first quartile in scenario S2) is negative. When this argument is set to \code{TRUE}, a constant is added such that the smallest quantile equals \code{shift.val}. The default is \code{TRUE}.}

\item{shift.val}{numeric value to which the smallest quantile should be shifted to if it is negative (see argument \code{shift.when.negative}). This argument is only applicable when \code{shift.when.negative} is set to \code{TRUE}. The default is \code{0.5}.}

\item{...}{other arguments.}
}
\value{
A list with the following components:
\item{est.se}{Estimated standard error of the mean estimator.}
\item{boot.means}{Bootstrap replicates of the mean estimates.}
\item{boot.sds}{Bootstrap replicates of the standard deviation estimates.}
}
\description{
Computes a parametric bootstrap standard error estimate for the quantile estimation approach.
}
\examples{
## Generate S2 summary data
set.seed(1)
n <- 250
x <- stats::rlnorm(n, 5, 0.25)
quants <- stats::quantile(x, probs = c(0, 0.5, 1))

## Estimate the mean and its standard error
res <- qe.mean.sd(min.val = quants[1], med.val = quants[2], max.val = quants[3],
                  n = n)
get_SE(res)$est.se
}
\references{
McGrath S., Katzenschlager S., Zimmer A.J., Seitel A., Steele R., and Benedetti A. (2023). Standard error estimation in meta-analysis of studies reporting medians. \emph{Statistical Methods in Medical Research}. \strong{32}(2):373-388.

McGrath S., Zhao X., Steele R., Thombs B.D., Benedetti A., and the DEPRESsion Screening Data (DEPRESSD) Collaboration. (2020). Estimating the sample mean and standard deviation from commonly reported quantiles in meta-analysis. \emph{Statistical Methods in Medical Research}. \strong{29}(9):2520-2537.
}
\seealso{
\code{\link{qe.mean.sd}}
}
