% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mln.mean.sd.R
\name{mln.mean.sd}
\alias{mln.mean.sd}
\title{Method for unknown non-normal distributions (MLN) approach for estimating the sample mean and standard deviation}
\usage{
mln.mean.sd(min.val, q1.val, med.val, q3.val, max.val, n)
}
\arguments{
\item{min.val}{numeric value giving the sample minimum.}

\item{q1.val}{numeric value giving the sample first quartile.}

\item{med.val}{numeric value giving the sample median.}

\item{q3.val}{numeric value giving the sample third quartile.}

\item{max.val}{numeric value giving the sample maximum.}

\item{n}{numeric value giving the sample size.}
}
\value{
A object of class \code{mln.mean.sd}. The object is a list with the following components:
\item{est.mean}{Estimated sample mean.}
\item{est.sd}{Estimated sample standard deviation.}
\item{location}{Estimated mean of the Box-Cox transformed data.}
\item{scale}{Estimated standard deviation of the Box-Cox transformed data.}
\item{shape}{Estimated transformation parameter \eqn{\lambda}.}
\item{bc.norm.rvs}{The random variables generated by the Box-Cox (or, equivalently, power-normal) distribution during the Monte Carlo simulation.}
\item{...}{Some additional elements.}

The results are printed with the \code{\link{print.mln.mean.sd}} function.
}
\description{
This function applies the Method for Unknown Non-Normal Distributions (MLN) approach to estimate the sample mean and standard deviation from a study that presents one of the following sets of summary statistics: \itemize{
\item S1: median, minimum and maximum values, and sample size
\item S2: median, first and third quartiles, and sample size
\item S3: median, minimum and maximum values, first and third quartiles, and sample size
 }
}
\details{
Like the Box-Cox method of McGrath et al. (2020), the MLN method of Cai et al. (2021) assumes that the underlying distribution is normal after applying a suitable Box-Cox transformation with power parameter \eqn{\lambda}. Specifically, the MLN method consists of the following steps, outlined below.

First, a maximum likelihood approach is used to estimate the power parameter \eqn{\lambda}, where the methods of Luo et al. (2016) and Wan et al. (2014) are applied to estimate the mean and standard deviation of the distribution of the transformed data. Then, a second round estimate of the mean and standard deviation of the distribution of the transformed data is obtained by maximum likelihood estimation conditional on the estimated power parameter. Finally, the inverse transformation is applied to estimate the sample mean and standard deviation of the original, untransformed data.
}
\examples{
## Generate S2 summary data
set.seed(1)
n <- 100
x <- stats::rlnorm(n, 2.5, 1)
quants <- stats::quantile(x, probs = c(0.25, 0.5, 0.75))
obs.mean <- mean(x)
obs.sd <- stats::sd(x)

## Estimate the sample mean and standard deviation using the MLN method
mln.mean.sd(q1.val = quants[1], med.val = quants[2], q3.val = quants[3],
    n = n)

}
\references{
Cai S., Zhou J., and Pan J. (2021). Estimating the sample mean and standard deviation from order statistics and sample size in meta-analysis. \emph{Statistical Methods in Medical Research}. \strong{30}(12):2701-2719.

McGrath S., Zhao X., Steele R., Thombs B.D., Benedetti A., and the DEPRESsion Screening Data (DEPRESSD) Collaboration. (2020). Estimating the sample mean and standard deviation from commonly reported quantiles in meta-analysis. \emph{Statistical Methods in Medical Research}. \strong{29}(9):2520-2537.

Box G.E.P., and D.R. Cox. (1964). An analysis of transformations. \emph{Journal of the Royal Statistical Society Series B}. \strong{26}(2):211-52.

Luo D., Wan X., Liu J., and Tong T. (2016). Optimally estimating the sample mean from the sample size, median, mid-range, and/or mid-quartile range. \emph{Statistical Methods in Medical Research}. \strong{27}(6):1785-805

Wan X., Wang W., Liu J., and Tong T. (2014). Estimating the sample mean and standard deviation from the sample size, median, range and/or interquartile range. \emph{BMC Medical Research Methodology}. \strong{14}:135.
}
