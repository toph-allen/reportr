require(lubridate)
require(ggplot2)

report <- read.csv("inst/exports/reporter-export-2014-03-18-10-01.csv", stringsAsFactors = FALSE)

gmtformat <- "%Y-%m-%dT%H:%M:%SZ"
report$posixtime <- strptime(report$Timestamp.of.Report..GMT., format = gmtformat, tz = "GMT")

with_tz(report$posixtime[1], tz = "America/New_York")

report$localtime <- with_tz(report$posixtime, tz = "America/New_York")

report$hour <- hour(report$localtime)

qplot(hour, How.happy.are.you., data = report, geom = "smooth")

gghourhappy <- ggplot(data = report, mapping = aes(x = hour, y = How.happy.are.you.))
gghourhappy + stat_quantile(method = "rqss") + geom_jitter()
gghourhappy + stat_quantile(method = "rqss", lambda = 5) + geom_jitter()
gghourhappy + stat_smooth() + geom_jitter(aes(color = How.happy.are.you.))

library(splines) # From the ggplot2 website
library(MASS)
gghourhappy + stat_smooth(method = "lm", formula = y ~ ns(x,3)) +
  geom_jitter()
