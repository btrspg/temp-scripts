
args<-commandArgs(T)

if(length(args)<2){
	print("error")
	q()
}

dat <- read.table ( args[1], header = T)
pdf(args[2])
pop <- dat[ ,1]
mds1 <- dat[ ,4]
mds2 <- dat[ ,5]
plot (mds1, mds2, col = as.factor(pop), xlab = "C1", ylab = "C2", pch = 20, main = "MDS plot")
legend("bottomleft", bty = "n", cex = 0.8, legend = unique(pop), border = F, fill = unique(as.factor(pop)))

dev.off()
