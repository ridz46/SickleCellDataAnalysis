# Description: This piece of code evaluates all the 16 possible combinations of P1,P2, by moving a window through the roundness distribution plots of the
#              known samples and outputs the connectivity and Dunn indices of all the 16 possible combinations as described in the supplementary information.
# Created by Riddha Manna
# Last edit by Riddha Manna on 2020-09-28

library(readxl)
library(xlsx)
library(clValid)
library(cluster)

data <- read_excel("~/Code for cluster evaluation/example_input.xlsx", # change to your path
                   col_types = c("skip", "text", "numeric",
                                 "text", "numeric", "numeric", "numeric",
                                 "numeric", "numeric", "numeric",
                                 "numeric", "numeric", "numeric",
                                 "numeric", "numeric"))
output = matrix(nrow=16,ncol=2) # initialising the output matrix having the connectivity and Dunn indices of all the 16 P1,P2 combination
P2_vs_P1 = matrix(nrow=16, ncol=1)
count = 1
for(j in 2:5){ # loop specifying the window size
  for(i in 5:(14-2*j+1)){ #loop specifying the starting index of the window
    # calculating P1 and P2 values 
    p1 = apply(data[,i:(i+j-1)],1,sum)
    p2 = apply(data[,(i+j):(i+2*j-1)],1,sum)
    
    # cluster evaluation
    d=cbind(p1,p2)
    cv=clValid(d, nClust=2, clMethods = "kmeans",validation="internal",neighbSize = 10)

    title = paste((i+j-5)/10,"-",(i+2*j-5)/10,"vs",(i-5)/10,"-",(i+j-5)/10)
    
    # saving the conectivity and Dunn index
    output[count,] = c(optimalScores(cv)[1,1],optimalScores(cv)[2,1])
    P2_vs_P1[count] = title
    count = count+1
    
  }
}
# preparing the final putput file
d=as.data.frame(output)
dimnames(d)[[1]]=P2_vs_P1
dimnames(d)[[2]]=c("Connectivity","Dunn_index")

# saving the output file
write.xlsx(d,'output.xlsx')

# plotting the Dunn index vs connectivity plot for all 16 P1,P2 combinations.
# A low connectivity and a high Dunn index (top-right section in the plot) usually means better clustering.
dat <- read_excel("~/Desktop/Code for cluster evaluation/output.xlsx")
plot(dat$Connectivity,dat$Dunn_index,xlim=rev(range(dat$Connectivity)))
abline(v=3,lty=2)
abline(h=0.35,lty=2)

