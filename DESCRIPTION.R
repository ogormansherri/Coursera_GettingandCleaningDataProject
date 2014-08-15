#codebook generation for cleaning
results.new <- as.data.frame(results)
table(results.new$subjects)
table(results.new$activities)

library(psych)
describe(results.new$tBodyAccMeanX)
describe(results.new)
