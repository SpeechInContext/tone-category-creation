t.test(subset(metrics, DistType == 'normal')$Skews, mu = 0)

t.test(subset(metrics, DistType == 'normal')$Skews, subset(metrics, DistType == 'skewed')$Skews)
t.test(subset(metrics, DistType == 'normal')$Kurtosises, subset(metrics, DistType == 'skewed')$Kurtosises)



t.test(subset(metrics, TrialType == 'lower' & DistType == 'normal')$Skews, subset(metrics, DistType == 'skewed')$Skews)

summary(aov(Skews ~ TrialType * DistType,data=metrics))
summary(aov(Mean ~ TrialType * DistType,data=metrics))

write.table(metrics, file = 'metrics.txt',quote = F, row.names = F, sep = '\t')
library(plyr)
ddply(metrics, ~TrialType*DistType, summarise, mean(Skews))

t.test(subset(metrics, DistType == 'skewed')$Mean, subset(metrics, DistType == 'skewed')$Mode,pair=T)
#t.test(subset(metrics, DistType == 'skewed')$Mean, subset(metrics, DistType == 'skewed')$Mode)
