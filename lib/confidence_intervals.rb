# Calculate the confidence interval for a samples from a binonial
# distribution using Wilson's score interval.  For more theoretical
# details, please see:
#
#  http://en.wikipedia.org/wiki/Binomial_proportion_confidence_interval#Wilson%20score%20interval
#
# This is a variant of the function suggested here:
#
#  http://www.evanmiller.org/how-not-to-sort-by-average-rating.html
#
# total: the total number of observations
# successes: the subset of those observations that were "successes"
# power: for a 95% confidence interval, this should be 0.05
#
# The naive proportion is (successes / total).  This returns an array
# with the proportions that represent the lower and higher confidence
# intervals around that.

# The inverse of the standard normal distribution (probit function),
# used to find the z-score for a given confidence level. This is the
# pure-Ruby rational approximation from the statistics2/statistics3
# gems, inlined here to avoid pulling in statistics3, whose gemspec
# pins psych (~> 2) and downgrades the whole bundle's YAML parser.
def pnormaldist(qn)
  b = [1.570796288, 0.03706987906, -0.8364353589e-3,
       -0.2250947176e-3, 0.6841218299e-5, 0.5824238515e-5,
       -0.104527497e-5, 0.8360937017e-7, -0.3231081277e-8,
       0.3657763036e-10, 0.6936233982e-12]

  raise "qn must be between 0 and 1" if qn < 0.0 || qn > 1.0
  return 0.0 if qn == 0.5

  w1 = qn
  w1 = 1.0 - w1 if qn > 0.5
  w3 = -Math.log(4.0 * w1 * (1.0 - w1))
  w1 = b[0]
  1.upto(10) { |i| w1 += b[i] * w3**i }
  qn > 0.5 ? Math.sqrt(w1 * w3) : -Math.sqrt(w1 * w3)
end

def ci_bounds(successes, total, power)
  raise "Can't calculate the CI for 0 observations" if total == 0
  z = pnormaldist(1 - power/2)
  phat = successes.to_f/total
  offset = z*Math.sqrt((phat*(1 - phat) + z*z/(4*total))/total)
  denominator = 1 + z*z/total
  [(phat + z*z/(2*total) - offset)/denominator,
   (phat + z*z/(2*total) + offset)/denominator]
end
