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
exprname <- args[1]
# exprname <- ""
logpath <- paste(args[2], "\\",exprname, "\\log.txt",sep="")
dir.create(exprname, showWarnings = TRUE, recursive = FALSE)


tb_Dnames <- read.csv("Docnames.csv", header = FALSE)
tb_Tnames <- read.csv("Termnames.csv", header = FALSE)
logfunc(logpath, "Reading T.csv ...")
tb_T <- read.csv("T.csv", header = FALSE)
logfunc(logpath, "Reading S.csv ...")
tb_S <- read.csv("S.csv", header = FALSE)
logfunc(logpath, "Reading t(D).csv ...")
tb_d <- read.csv("t(D).csv", header = FALSE)

docnames <- tb_Dnames[2:nrow(tb_Dnames),2:ncol(tb_Dnames)]
termnames <- tb_Tnames[2:nrow(tb_Tnames),2:ncol(tb_Tnames)]

mx_T <- Mx_Convert_Double(as.matrix(tb_T[2:nrow(tb_T),2:ncol(tb_T)]))
mx_S <- Mx_Convert_Double(as.matrix(tb_S[2:nrow(tb_S),2:ncol(tb_S)]))
mx_d <- Mx_Convert_Double(as.matrix(tb_d[2:nrow(tb_d),2:ncol(tb_d)]))

setwd(exprname)
division <- as.integer(args[3])
# division <- 
range <- as.integer(nrow(mx_S)/division)


for(t in 1:division)
{
	
	if(t == division)
		dim <- nrow(mx_S)
	else
		dim <- t * range

	dirname <- paste(exprname, "_", t, "of", division, "_Dim(", dim, ")", sep="")
	dir.create(dirname, showWarnings = TRUE, recursive = FALSE)
	setwd(dirname)
	logfunc(logpath, paste("Calculating", dirname, "..."))
	
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
	
	logfunc(logpath, "Result Saving...")
	write.table(mx_X, file = "X.csv", sep = ",", col.names = NA, qmethod = "double")
	write.table(mx_DocCp, file = "DocComparison.csv", sep = ",", col.names = NA, qmethod = "double")
	write.table(mx_TermCp, file = "TermComparison.csv", sep = ",", col.names = NA, qmethod = "double")

	setwd("..")	
}

logfunc(logpath, "Done !!")