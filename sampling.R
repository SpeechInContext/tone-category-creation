

library(timeDate)

Mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

is_kurtosis_okay <- function (data, norm_kurtosis){
  v <- kurtosis(data)
  z <- (v - mean(norm_kurtosis))/ sd(norm_kurtosis)
  if (abs(z) < 1){
    return(T)
  }
  return(F)
}


is_okay <- function (data) {
  prev = 0
  count = 1
  if (data[1] == data[2]){
    return(F)
  }
  if (data[length(data)-1] == data[length(data)]){
    return(F)
  }
  for (i in 1:length(data)){
    if (prev != data[i]){
      count = 0
    }
    count = count + 1
    if (count > 4){
      return(F)
    }
    prev = data[i]
  }
  return(T)
}

num_trials = 20
num_samples = 20
x = 1:6

use_lnorm = F

distribution_types = c('normal','skewed')
trial_types = c('lower','higher')

metrics <- data.frame(Skews=numeric(0), Kurtosises = numeric(0), Mean = numeric(0), Median = numeric(0), SD = numeric(0), Mode = numeric(0), Min = numeric(0), Max = numeric(0), Center = numeric(0), Range = numeric(0), End = numeric(0), Penult = numeric(0), DistType=character(0),TrialType=character(0), Trial=numeric(0))

step_size_hz = 4

norm_kurtosis <- numeric(0)

for (dt in 1:length(distribution_types)){
  type = distribution_types[dt]
  m = 3.5
  
  if (type == 'skewed'){
    m = 2.5 #skewed would be 5 or 2?
    
  }
  for (tt in 1:length(trial_types)){
    trial_type = trial_types[tt]
    
    begin_step_hz = 288-step_size_hz
    
    if (trial_type == 'higher'){
      begin_step_hz = 327-step_size_hz
    }
    for (i in 1:num_trials)
    {
      if (use_lnorm&& type == 'skewed'){
        #y = dbeta(x/6,2,2)
        y = dlnorm(x, log(m), log(1.5))
      }
      else {
      
        y = dnorm(x,mean=m,sd=1)}
      while (T){
        samp = sample(1:6, size=num_samples, replace=TRUE, prob=y)
        samp_hz = samp * step_size_hz + begin_step_hz
        s = skewness(samp_hz)
        m1 = mean(samp_hz)
        m2 = Mode(samp_hz)
        if ( type == 'normal' && is_okay(samp_hz) && s > -0.25 && s < 0.25){
          break
        }
        else if (type == 'skewed' && is_kurtosis_okay(samp_hz, norm_kurtosis) && is_okay(samp_hz) &&  ( s > 0.35) && abs(m1 - m2) > 3){
          break
        }
        
      }
      hist(samp_hz)
      minhz = min(samp_hz)
      maxhz = max(samp_hz)
      range = maxhz - minhz
      center = minhz + (range/2)
      if (type == 'normal'){
        norm_kurtosis <- c(norm_kurtosis, kurtosis(samp_hz))
      }
      
      metrics = rbind(metrics,data.frame(Skews = skewness(samp_hz), Kurtosises = kurtosis(samp_hz), Mean = mean(samp_hz), Median = median(samp_hz), SD = sd(samp_hz), Mode = Mode(samp_hz), Min = minhz, Max = maxhz, Center = center, Range = range, End = samp_hz[num_samples], Penult = samp_hz[num_samples-1], DistType = type, TrialType = trial_type,Trial = i))
      write.table(samp_hz,paste('samples/',type,'/',trial_type,'/',i,'.txt',sep=''), col.names=F,row.names=F)
    }
  }
}

