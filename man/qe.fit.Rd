% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/qe.fit.R
\name{qe.fit}
\alias{qe.fit}
\title{Quantile estimation fitting}
\usage{
qe.fit(
  min.val,
  q1.val,
  med.val,
  q3.val,
  max.val,
  n,
  two.sample.default = FALSE,
  qe.fit.control = list()
)
}
\arguments{
\item{min.val}{numeric value giving the sample minimum.}

\item{q1.val}{numeric value giving the sample first quartile.}

\item{med.val}{numeric value giving the sample median.}

\item{q3.val}{numeric value giving the sample third quartile.}

\item{max.val}{numeric value giving the sample maximum.}

\item{n}{numeric value giving the sample size.}

\item{two.sample.default}{logical scalar. If set to \code{TRUE}, the candidate distributions, initial values, and box constraints are set to that of McGrath et al. (2020a). If set to \code{FALSE}, the candidate distributions, initial values, and box constraints are set to that of McGrath et al. (2020b). The default is \code{FALSE}.}

\item{qe.fit.control}{optional list of control parameters for the minimization algorithm. \tabular{ll}{
\code{norm.mu.start} \tab numeric value giving the starting value for the \eqn{\mu} parameter of the normal distribution. \cr
\code{norm.sigma.start} \tab numeric value giving the starting value for the \eqn{\sigma} parameter of the normal distribution. \cr
\code{lnorm.mu.start} \tab numeric value giving the starting value for the \eqn{\mu} parameter of the log-normal distribution. \cr
\code{lnorm.sigma.start} \tab numeric value giving the starting value for the \eqn{\sigma} parameter of the log-normal distribution. \cr
\code{gamma.shape.start} \tab numeric value giving the starting value for the shape parameter of the gamma distribution. \cr
\code{gamma.rate.start} \tab numeric value giving the starting value for the rate parameter of the gamma distribution. \cr
\code{weibull.shape.start} \tab numeric value giving the starting value for the shape parameter of the Weibull distribution. \cr
\code{weibull.scale.start} \tab numeric value giving the starting value for the scale parameter of the Weibull distribution. \cr
\code{beta.shape1.start} \tab numeric value giving the starting value for the shape1 (i.e., \eqn{\alpha}) parameter of the beta distribution. \cr
\code{beta.shape2.start} \tab numeric value giving the starting value for the shape2 (i.e., \eqn{\beta}) parameter of the beta distribution. \cr
\code{norm.mu.bounds} \tab vector giving the bounds on the \eqn{\mu} parameter of the normal distribution. \cr
\code{norm.sigma.bounds} \tab vector giving the bounds on the \eqn{\sigma} parameter of the normal distribution. \cr
\code{lnorm.mu.bounds} \tab vector giving the bounds on the \eqn{\mu} parameter of the the log-normal distribution. \cr
\code{lnorm.sigma.bounds} \tab vector giving the bounds on the \eqn{\sigma} parameter of the log-normal distribution. \cr
\code{gamma.shape.bounds} \tab vector giving the bounds on the shape parameter of the gamma distribution. \cr
\code{gamma.rate.bounds} \tab vector giving the bounds on the rate parameter of the gamma distribution. \cr
\code{weibull.shape.bounds} \tab vector giving the bounds on the shape parameter of the Weibull distribution. \cr
\code{weibull.scale.bounds} \tab vector giving the bounds on the scale parameter of the Weibull distribution. \cr
\code{beta.shape1.bounds} \tab vector giving the bounds on the shape1 (i.e., \eqn{\alpha}) parameter of the beta distribution. \cr
\code{beta.shape2.bounds} \tab vector giving the bounds on the shape2 (i.e., \eqn{\beta}) parameter of the beta distribution. \cr}}
}
\value{
A object of class \code{qe.fit}. The object is a list with the following components:
\item{norm.par}{Estimated parameters of the normal distribution.}
\item{lnorm.par}{Estimated parameters of the log-normal distribution.}
\item{gamma.par}{Estimated parameters of the gamma distribution.}
\item{weibull.par}{Estimated parameters of the Weibull distribution.}
\item{beta.par}{Estimated parameters of the beta distribution.}
\item{values}{Values of the objective functions evaluated at the estimated paramters of each candidate distribution.}
\item{...}{Other elements.}

The results are printed with the \code{\link{print.qe.fit}} function. The results can be visualized by using the \code{\link{plot.qe.fit}} function.
}
\description{
This function fits several parametric families of distributions from summary data in the following forms: \itemize{
\item S1: median, minimum and maximum values, and sample size
\item S2: median, first and third quartiles, and sample size
\item S3: median, minimum and maximum values, first and third quartiles, and sample size
 }
}
\details{
Distributions are fit by minimizing the distance between observed and distribution quantiles in the L2-norm. The limited-memory Broyden-Fletcher-Goldfarb-Shanno (L-BFGS-M) algorithm implemented in the \code{\link[stats]{optim}} function is used for minimization.

Two different conventions may be used for setting the candidate distributions, parameter starting values, and parameter constraints, which is controlled by the \code{two.sample.default} argument. If the convention of McGrath et al. (2020a) is used, the candidate distributions are the normal, log-normal, gamma, and Weibull distributions. If the convention of McGrath et al. (2020b) is used, the beta distribution is also included. In either case, if a negative value is provided (e.g., for the minimum value or the first quartile value), only the normal distribution is fit.
}
\examples{
## Generate S2 summary data
set.seed(1)
n <- 100
x <- stats::rlnorm(n, 2.5, 1)
quants <- stats::quantile(x, probs = c(0.25, 0.5, 0.75))

## Fit distributions
qe.fit(q1.val = quants[1], med.val = quants[2], q3.val = quants[3], n = n)

}
\references{
McGrath S., Sohn H., Steele R., and Benedetti A. (2020a). Meta-analysis of the difference of medians. \emph{Biometrical Journal}, \strong{62}, 69-98.

McGrath S., Zhao X., Steele R., Thombs B.D., Benedetti A., and the DEPRESsion Screening Data (DEPRESSD) Collaboration. (2020b). Estimating the sample mean and standard deviation from commonly reported quantiles in meta-analysis. \emph{Statistical Methods in Medical Research}. \strong{29}(9):2520-2537.
}
