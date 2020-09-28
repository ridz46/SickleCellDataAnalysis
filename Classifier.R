# Description: This piece of code evaluates all the 16 possible combinations of P1,P2, by moving a
# Created by Riddha Manna
# Last edit by Riddha Manna on 2020-09-28

library(readxl)
library(e1071)

data <- read_excel("~/Code for generating classifier/example_input.xlsx", #change to your path
                   col_types = c("skip", "text", "numeric",
                                 "text", "numeric", "numeric", "numeric",
                                 "numeric", "numeric", "numeric",
                                 "numeric", "numeric", "numeric",
                                 "numeric", "numeric"))

# Uncomment this section for P1 = 0.2-0.5, P2 = 0.5-0.8; Comment this section for any other value of P1, P2
p1 = apply(data[,7:9],1,sum)
p2 = apply(data[,10:12],1,sum)


# # Uncomment this section for P1 = 0.4-0.7, P2 = 0.7-1.0; Comment this section for any other value of P1, P2
# p1 = apply(data[,9:11],1,sum)
# p2 = apply(data[,12:14],1,sum)

# k-means clustering
d=cbind(p1,p2)
clusters=kmeans(d,2)
clus=clusters$cluster

# Applying support vector machine model to get the equation of the classifier (y = mx + c)
d = data.frame(cbind(p2,p1),y=as.factor(clus))
svmfit = svm(y ~ ., data = d, kernel = "linear", cost = 10, scale = FALSE)
beta = drop(t(svmfit$coefs)%*%cbind(p1,p2)[svmfit$index,])
beta0 = svmfit$rho
m=-beta[1]/beta[2] # slope of the classifier
c=beta0/beta[2] # intercept of the classifier
paste0("classifier: y = ", m,"x + ",c)

# Uncomment this section for P1 = 0.2-0.5, P2 = 0.5-0.8; Comment this section for any other value of P1, P2
title = paste(0.5,"-",0.8,"vs",0.2,"-",0.5)
xlabel = paste(0.2,"-",0.5)
ylabel = paste(0.5,"-",0.8)

# # Uncomment this section for P1 = 0.4-0.7, P2 = 0.7-1.0; Comment this section for any other value of P1, P2
# title = paste(0.7,"-",1.0,"vs",0.4,"-",0.7)
# xlabel = paste(0.4,"-",0.7)
# ylabel = paste(0.7,"-",1.0)

# plotting the known datapoints
plot(p1,p2,col=clusters$cluster, main  = title, xlab=xlabel, ylab = ylabel)
# marking the centroids of the identified clusters
points(clusters$centers,col=c('green','blue'))
# drawing the classifier
abline(c,m)

