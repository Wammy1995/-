library(MASS)

num_samples <- c(30,50,100,500,1000,5000)
rs <- c(0.9,0.7,0.5,0.3)
ms <- c(50,80,150)
sds <- c(225,100,25)
num = length(num_samples)*length(rs)*length(ms)*length(sds)
count <- 1
tm <- matrix(0,num,1);ts <- matrix(0,num,1);tabm <- matrix(0,num,1);tabs <- matrix(0,num,1)
nos <- matrix(0,num,1)
noc <- matrix(0,num,1)
nom <- matrix(0,num,1)
nosd <- matrix(0,num,1)

# spearman等级相关自建方法
# SPRM <- function(dat1,dat2){
#   n <- 1
#   m <- 1
#   r1 <- rank(dat1)
#   r2 <- rank(dat2)
#   for (o in r1){
#     dat1[n] <- o
#     n <- n+1
#   }
#   for (j in r2){
#     dat2[m] <- j
#     m <- m+1
#   }
#   t <- 1 - (6 * sum((dat1-dat2)^2)) / ((length(dat1))^3 - length(dat1))
#   return(t)
# }


for (V in sds) {
  for (r in rs) {
    cov<-matrix(c(V,r*V,V*r,V),nrow=2,byrow=TRUE)
    for (Mean in ms) {
      for (N in num_samples) {
        resW <- matrix(0,500,1)
        res <- matrix(0,500,1)
        for (i in 1:500){
          data=mvrnorm(n=N,mu=c(Mean,Mean),cov,empirical=TRUE)
          dat1 <- data[,1]
          dat2 <-data[,2]
          Rpearson=cor(dat1,dat2,method="pearson")
          Rspearman=cor(dat1,dat2,method="spearman")
          resW[i,]<-abs(Rpearson-Rspearman)
          res[i,]<- Rpearson-Rspearman
        }
        # name <- paste('C:/Users/林崎/Desktop/aa/trial/',paste(paste(N,V,r,Mean,collapse =","),'.csv',collapse = ''),collapse = "")
        # trial <- data.frame(num_samples=N,R=r,sd=V,Mean=Mean,P_Sdiff=res)
        # #输出每个试次的数据的500组数据，共num个试次
        # write.csv(trial,file=name)
        # 只取一个试次的数据
        # if (trial){
        #   stop("get one")
        # }
        tm[count,]=mean(res)
        tabm[count,]=mean(resW)
        ts[count,]=sd(res)
        tabs[count,]=mean(resW)
        nosd[count,]=V
        nos[count,]=N
        noc[count,]=r
        nom[count,]=Mean
        count <- count+1
        
      }  
    }  
  }
}
goal = data.frame(num_sample=nos,pearsonR=noc,mean_sample=nom,var_sample=nosd,diff=tm,sd_diff=ts,diffabs=tabm,sd_diffabs=tabs)
#输出num个试次每个试次的平均数
write.csv(goal,file='C:/Users/林崎/Desktop/aa/trial/goal_BIGnum.csv')
cat("done!!!")


###############只变样本容量和相关系数#########################
library(MASS)
num_samples <- c(30,50,100,500,1000,5000)
rs <- c(0.9,0.8,0.7,0.6,0.5,0.4,0.3,0.2)
num = length(rs)*length(num_samples)
count <- 1
tm <- matrix(0,num,1);ts <- matrix(0,num,1);tabm <- matrix(0,num,1);tabs <- matrix(0,num,1)
nos <- matrix(0,num,1)
noc <- matrix(0,num,1)
for (r in rs) {
  cov<-matrix(c(225,r*225,r*225,225),nrow=2,byrow=TRUE)
  for (n in num_samples) {
    resW <- matrix(0,200,1)
    res <- matrix(0,200,1)
    for (i in 1:200){
      data=mvrnorm(n=n,mu=c(40,20),cov,empirical=TRUE)
      dat1 <- data[,1]
      dat2 <-data[,2]
      Rpearson=cor(dat1,dat2,method="pearson")
      Rspearman=cor(dat1,dat2,method="spearman")
      resW[i,]<-abs(Rpearson-Rspearman)
      res[i,]<- Rpearson-Rspearman
    }
    # name <- paste('C:/Users/林崎/Desktop/aa/simple_trial/',paste(paste(n,r,collapse =","),'.csv',collapse = ''),collapse = "")
    # trial <- data.frame(num_samples=N,R=r,P_Sdiff=res,P_Sabs=resW)
    # #输出每个试次的数据的500组数据，共num个试次
    # write.csv(trial,file=name)
    tm[count,]=mean(res)
    tabm[count,]=mean(resW)
    ts[count,]=sd(res)
    tabs[count,]=sd(resW)
    nos[count,]=n
    noc[count,]=r
    count <- count+1
  }
}
goal = data.frame(num_sample=nos,pearsonR=noc,diff=tm,sd_diff=ts,diffabs=tabm,sd_diffabs=tabs)
#输出num个试次每个试次的平均数
write.csv(goal,file='C:/Users/林崎/Desktop/aa/simple_trial/goal_BIGnum.csv')
cat("done!!!")






