library(svd)

logfunc <- function(filename, logtext)
{
	print(logtext)
	logcont <- paste(format(Sys.time(), "%Y-%m-%d %X"),":", logtext)
	write( logcont, file=filename, append=TRUE)						
}

Mx_Convert_Double <- function(mx)
{
	dmx <- as.double(mx) 
	dmx <- matrix(dmx, nrow=nrow(mx), ncol=ncol(mx))	
	return(dmx)				
}

args <- commandArgs(trailingOnly = TRUE)

setwd(args[2])
# setwd("")

print("Creating Directory...")
dirname <- args[1]
# dirname <- ""

dir.create(dirname, showWarnings = TRUE, recursive = FALSE)


tb_Dnames <- read.csv("Docnames.csv", header = FALSE)
tb_Tnames <- read.csv("Termnames.csv", header = FALSE)
logfunc(paste(dirname,"\\log.txt",sep=""), "Reading T.csv ...")
tb_T <- read.csv("T.csv", header = FALSE)
logfunc(paste(dirname,"\\log.txt",sep=""), "Reading S.csv ...")
tb_S <- read.csv("S.csv", header = FALSE)
logfunc(paste(dirname,"\\log.txt",sep=""), "Reading t(D).csv ...")
tb_d <- read.csv("t(D).csv", header = FALSE)

docnames <- tb_Dnames[2:nrow(tb_Dnames),2:ncol(tb_Dnames)]
termnames <- tb_Tnames[2:nrow(tb_Tnames),2:ncol(tb_Tnames)]

mx_T <- Mx_Convert_Double(as.matrix(tb_T[2:nrow(tb_T),2:ncol(tb_T)]))
mx_S <- Mx_Convert_Double(as.matrix(tb_S[2:nrow(tb_S),2:ncol(tb_S)]))
mx_d <- Mx_Convert_Double(as.matrix(tb_d[2:nrow(tb_d),2:ncol(tb_d)]))

logfunc(paste(dirname,"\\log.txt",sep=""), "Comparing...")
dim <- args[3]
# dim <- 

mx_X <- mx_T[,1:dim] %*% mx_S[1:dim,1:dim] %*% mx_d[1:dim,]
mx_X <- as.table(mx_X)
for(n in 1:length(docnames))
{
	colnames(mx_X)[n] <- paste(toString(n), toString(docnames[n]), sep=".")
}

for(n in 1:length(termnames))
{
	rownames(mx_X)[n] <- paste(toString(n), toString(termnames[n]), sep=".")
}

mx_DocCp <- t(mx_X) %*% mx_X
mx_TermCp <- mx_X %*% t(mx_X)
# eapply(.GlobalEnv,typeof)


setwd(dirname)

logfunc("log.txt", "Result Saving...")
write.table(mx_X, file = "X.csv", sep = ",", col.names = NA, qmethod = "double")
write.table(mx_DocCp, file = "DocComparison.csv", sep = ",", col.names = NA, qmethod = "double")
write.table(mx_TermCp, file = "TermComparison.csv", sep = ",", col.names = NA, qmethod = "double")

