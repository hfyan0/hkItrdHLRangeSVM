args <- commandArgs(trailingOnly = TRUE)

data<-read.csv(args[1], header=F, sep=",")[1]
nobs=length(data)

# x<-diff(data[,1])
# acf(x)
# pacf(x)

aa<-arima(data, order = c(3,1,3))
# aa
aa$coef[1]
aa$coef[2]
aa$coef[3]
aa$coef[4]
aa$coef[5]
aa$coef[6]

fore2=predict(aa, n.ahead = 1)
fore2$pred[1]
