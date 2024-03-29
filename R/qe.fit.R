#' Quantile estimation fitting
#'
#' This function fits several parametric families of distributions from summary data in the following forms: \itemize{
#' \item S1: median, minimum and maximum values, and sample size
#' \item S2: median, first and third quartiles, and sample size
#' \item S3: median, minimum and maximum values, first and third quartiles, and sample size
#'  }
#'
#' Distributions are fit by minimizing the distance between observed and distribution quantiles in the L2-norm. The limited-memory Broyden-Fletcher-Goldfarb-Shanno (L-BFGS-M) algorithm implemented in the \code{\link[stats]{optim}} function is used for minimization.
#'
#' Two different conventions may be used for setting the candidate distributions, parameter starting values, and parameter constraints, which is controlled by the \code{two.sample.default} argument. If the convention of McGrath et al. (2020a) is used, the candidate distributions are the normal, log-normal, gamma, and Weibull distributions. If the convention of McGrath et al. (2020b) is used, the beta distribution is also included. In either case, if a negative value is provided (e.g., for the minimum value or the first quartile value), only the normal distribution is fit.
#'
#' @param min.val numeric value giving the sample minimum.
#' @param q1.val numeric value giving the sample first quartile.
#' @param med.val numeric value giving the sample median.
#' @param q3.val numeric value giving the sample third quartile.
#' @param max.val numeric value giving the sample maximum.
#' @param n numeric value giving the sample size.
#' @param two.sample.default logical scalar. If set to \code{TRUE}, the candidate distributions, initial values, and box constraints are set to that of McGrath et al. (2020a). If set to \code{FALSE}, the candidate distributions, initial values, and box constraints are set to that of McGrath et al. (2020b). The default is \code{FALSE}.
#' @param qe.fit.control optional list of control parameters for the minimization algorithm. \tabular{ll}{
#' \code{norm.mu.start} \tab numeric value giving the starting value for the \eqn{\mu} parameter of the normal distribution. \cr
#' \code{norm.sigma.start} \tab numeric value giving the starting value for the \eqn{\sigma} parameter of the normal distribution. \cr
#' \code{lnorm.mu.start} \tab numeric value giving the starting value for the \eqn{\mu} parameter of the log-normal distribution. \cr
#' \code{lnorm.sigma.start} \tab numeric value giving the starting value for the \eqn{\sigma} parameter of the log-normal distribution. \cr
#' \code{gamma.shape.start} \tab numeric value giving the starting value for the shape parameter of the gamma distribution. \cr
#' \code{gamma.rate.start} \tab numeric value giving the starting value for the rate parameter of the gamma distribution. \cr
#' \code{weibull.shape.start} \tab numeric value giving the starting value for the shape parameter of the Weibull distribution. \cr
#' \code{weibull.scale.start} \tab numeric value giving the starting value for the scale parameter of the Weibull distribution. \cr
#' \code{beta.shape1.start} \tab numeric value giving the starting value for the shape1 (i.e., \eqn{\alpha}) parameter of the beta distribution. \cr
#' \code{beta.shape2.start} \tab numeric value giving the starting value for the shape2 (i.e., \eqn{\beta}) parameter of the beta distribution. \cr
#' \code{norm.mu.bounds} \tab vector giving the bounds on the \eqn{\mu} parameter of the normal distribution. \cr
#' \code{norm.sigma.bounds} \tab vector giving the bounds on the \eqn{\sigma} parameter of the normal distribution. \cr
#' \code{lnorm.mu.bounds} \tab vector giving the bounds on the \eqn{\mu} parameter of the the log-normal distribution. \cr
#' \code{lnorm.sigma.bounds} \tab vector giving the bounds on the \eqn{\sigma} parameter of the log-normal distribution. \cr
#' \code{gamma.shape.bounds} \tab vector giving the bounds on the shape parameter of the gamma distribution. \cr
#' \code{gamma.rate.bounds} \tab vector giving the bounds on the rate parameter of the gamma distribution. \cr
#' \code{weibull.shape.bounds} \tab vector giving the bounds on the shape parameter of the Weibull distribution. \cr
#' \code{weibull.scale.bounds} \tab vector giving the bounds on the scale parameter of the Weibull distribution. \cr
#' \code{beta.shape1.bounds} \tab vector giving the bounds on the shape1 (i.e., \eqn{\alpha}) parameter of the beta distribution. \cr
#' \code{beta.shape2.bounds} \tab vector giving the bounds on the shape2 (i.e., \eqn{\beta}) parameter of the beta distribution. \cr}
#'
#' @return A object of class \code{qe.fit}. The object is a list with the following components:
#' \item{norm.par}{Estimated parameters of the normal distribution.}
#' \item{lnorm.par}{Estimated parameters of the log-normal distribution.}
#' \item{gamma.par}{Estimated parameters of the gamma distribution.}
#' \item{weibull.par}{Estimated parameters of the Weibull distribution.}
#' \item{beta.par}{Estimated parameters of the beta distribution.}
#' \item{values}{Values of the objective functions evaluated at the estimated paramters of each candidate distribution.}
#' \item{...}{Other elements.}
#'
#' The results are printed with the \code{\link{print.qe.fit}} function. The results can be visualized by using the \code{\link{plot.qe.fit}} function.
#'
#' @references McGrath S., Sohn H., Steele R., and Benedetti A. (2020a). Meta-analysis of the difference of medians. \emph{Biometrical Journal}, \strong{62}, 69-98.
#' @references McGrath S., Zhao X., Steele R., Thombs B.D., Benedetti A., and the DEPRESsion Screening Data (DEPRESSD) Collaboration. (2020b). Estimating the sample mean and standard deviation from commonly reported quantiles in meta-analysis. \emph{Statistical Methods in Medical Research}. \strong{29}(9):2520-2537.
#'
#' @examples
#' ## Generate S2 summary data
#' set.seed(1)
#' n <- 100
#' x <- stats::rlnorm(n, 2.5, 1)
#' quants <- stats::quantile(x, probs = c(0.25, 0.5, 0.75))
#'
#' ## Fit distributions
#' qe.fit(q1.val = quants[1], med.val = quants[2], q3.val = quants[3], n = n)
#'
#' @export

qe.fit <- function(min.val, q1.val, med.val, q3.val, max.val, n,
                   two.sample.default = FALSE, qe.fit.control = list()) {

  scenario <- get.scenario(min.val, q1.val, med.val, q3.val, max.val)
  check_errors(min.val = min.val, q1.val = q1.val, med.val = med.val,
               q3.val = q3.val, max.val = max.val, n = n, scenario = scenario)

  if (scenario == "S1") {
    probs <- c(1 / n, 0.5, 1 - 1 / n)
    quants <- c(min.val, med.val, max.val)
  } else if (scenario == "S2") {
    probs <- c(0.25, 0.5, 0.75)
    quants <- c(q1.val, med.val, q3.val)
  } else if (scenario == "S3") {
    probs <- c(1 / n, 0.25, 0.5, 0.75, 1 - 1 / n)
    quants <- c(min.val, q1.val, med.val, q3.val, max.val)
  }

  if (min(quants == 0)) {
    quants[quants == 0] <- 10^(-2)
  }

  con <-  set.qe.fit.control(quants, n, scenario, two.sample.default)
  con[names(qe.fit.control)] <- qe.fit.control

  S.theta.norm <- function(theta) {
    summand <- sum((stats::qnorm(p = probs, mean = theta[1],
                                 sd = theta[2]) - quants)^2)
  }
  S.theta.lnorm <- function(theta) {
    summand <- sum((stats::qlnorm(p = probs, meanlog = theta[1],
                                  sdlog = theta[2]) - quants)^2)
  }
  S.theta.gamma <- function(theta) {
    summand <- sum((stats::qgamma(p = probs, shape = theta[1],
                                  rate = theta[2]) - quants)^2)
  }
  S.theta.weibull <- function(theta) {
    summand <- sum((stats::qweibull(p = probs, shape = theta[1],
                                    scale = theta[2]) - quants)^2)
  }
  S.theta.beta <- function(theta) {
    summand <- sum((stats::qbeta(p = probs, shape1 = theta[1],
                                 shape2 = theta[2]) - quants)^2)
  }

  no.fit <- function(e) {
    return(list(par = NA, value = NA))
  }

  fit.norm <- tryCatch({
    stats::optim(par = c(con$norm.mu.start, con$norm.sigma.start),
                 S.theta.norm, method = "L-BFGS-B",
                 lower = c(con$norm.mu.bound[1], con$norm.sigma.bound[1]),
                 upper = c(con$norm.mu.bound[2], con$norm.sigma.bound[2]))
  },
  error = no.fit
  )

  if (min(quants) < 0) {
    message("Only fit the normal distribution because of negative quantiles.")
    fit.lnorm <- fit.gamma <- fit.weibull <- fit.beta <- no.fit()
  } else {
    fit.lnorm <- tryCatch({
      stats::optim(par = c(con$lnorm.mu.start, con$lnorm.sigma.start),
                   S.theta.lnorm, method = "L-BFGS-B",
                   lower = c(con$lnorm.mu.bound[1], con$lnorm.sigma.bound[1]),
                   upper = c(con$lnorm.mu.bound[2], con$lnorm.sigma.bound[2]))
    },
    error = no.fit
    )
    fit.gamma <- tryCatch({
      stats::optim(par = c(con$gamma.shape.start, con$gamma.rate.start),
                   S.theta.gamma, method = "L-BFGS-B",
                   lower = c(con$gamma.shape.bound[1], con$gamma.rate.bound[1]),
                   upper = c(con$gamma.shape.bound[2], con$gamma.rate.bound[2]))
    },
    error = no.fit
    )
    fit.weibull <- tryCatch({
      stats::optim(par = c(con$weibull.shape.start, con$weibull.scale.start),
                   S.theta.weibull, method = "L-BFGS-B",
                   lower = c(con$weibull.shape.bound[1],
                             con$weibull.scale.bound[1]),
                   upper = c(con$weibull.shape.bound[2],
                             con$weibull.scale.bound[2]))
    },
    error = no.fit
    )
    if (two.sample.default){
      fit.beta <- no.fit(1)
    } else {
      fit.beta <- tryCatch({
        stats::optim(par = c(con$beta.shape1.start, con$beta.shape2.start),
                     S.theta.beta, method = "L-BFGS-B",
                     lower = c(con$beta.shape1.bound[1],
                               con$beta.shape2.bound[1]),
                     upper = c(con$beta.shape1.bound[2],
                               con$beta.shape2.bound[2]))
      },
      error = no.fit,
      warning = no.fit
      )
    }
  }

  values <- c(fit.norm$value, fit.lnorm$value, fit.gamma$value,
              fit.weibull$value, fit.beta$value)
  names(values) <- c("normal", "log-normal", "gamma", "weibull", "beta")
  norm.par <- fit.norm$par
  lnorm.par <- fit.lnorm$par
  gamma.par <- fit.gamma$par
  weibull.par <- fit.weibull$par
  beta.par <- fit.beta$par
  if (length(norm.par) != 1) {
    names(norm.par) <- c("mu", "sigma")
  }
  if (length(lnorm.par) != 1) {
    names(lnorm.par) <- c("mu", "sigma")
  }
  if (length(gamma.par) != 1) {
    names(gamma.par) <- c("shape", "rate")
  }
  if (length(weibull.par) != 1) {
    names(weibull.par) <- c("shape", "scale")
  }
  if (length(beta.par) != 1) {
    names(beta.par) <- c("shape1", "shape2")
  }

  num.input <- get.num.input(min.val, q1.val, med.val, q3.val, max.val, n)
  output <- list(norm.par = norm.par, lnorm.par = lnorm.par,
                 gamma.par = gamma.par, weibull.par = weibull.par,
                 beta.par = beta.par, values = values,
                 num.input = num.input, scenario = scenario)
  class(output) <- "qe.fit"
  return(output)
}

