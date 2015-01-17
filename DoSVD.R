library(RODBC)
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

print("Creating Directory...")
dirname <- format(Sys.time(), "%Y-%m-%d-%k%M%S")
dir.create(dirname, showWarnings = TRUE, recursive = FALSE)
setwd(dirname)

logfunc("log.txt", "Connecting Database...")

server <- args[1]
uid <- args[2]
pwd <- args[3]
dbname <- args[4]
conn <- odbcDriverConnect(paste("driver={SQL Server};server=", server, ";database=", dbname, ";uid=", uid, ";pwd=", pwd, ";", sep=""))
sqlcmd <- paste("select Row, Term from ", args[6], sep=" ")
# conn <- odbcDriverConnect("driver={SQL Server};server=;database=;uid=;pwd=")
# sqlcmd <- "select Row, Term from "
res <- sqlQuery(conn, sqlcmd)
# sqlcmd <- "select Doc from "
sqlcmd <- paste("select Doc from ", args[5], sep=" ")
docnames <- sqlQuery(conn, sqlcmd)
odbcClose(conn)

datarows <- res[,1]
termnames <- res[,2]
docnames <- docnames[,1]


logfunc("log.txt", "Matrix Building...")

datarow <- datarows[1]
mx <- read.table(text = toString(datarow))
rownames(mx)[1] <- toString(termnames[1])

for(n in 2:length(datarows))
{
	mxtmp <- read.table(text = toString(datarows[n]))
	mx <- rbind(mx, mxtmp)
}

for(n in 1:length(docnames))
{
	colnames(mx)[n] <- paste(toString(n), toString(docnames[n]), sep=".")
}

for(n in 1:length(termnames))
{
	rownames(mx)[n] <- paste(toString(n), toString(termnames[n]), sep=".")
}


# X = T S D'
# s$u %*% D %*% t(s$v) #  X = U D V'

logfunc("log.txt", "SVD Calculating...")

s <- svd(mx)
svd_T <- s$u
svd_S <- diag(s$d)
svd_d <- t(s$v)


# mmx <- Mx_Convert_Double(as.matrix(mx))
# logfunc("log.txt", "Document Comparing...")
# svd_docCp <- t(mmx) %*% mmx
# logfunc("log.txt", "Term Comparing...")
# svd_termCp <- mmx %*% t(mmx)

# svd_docCp <- as.table(svd_docCp)
# svd_termCp <- as.table(svd_termCp)

# for(n in 1:length(docnames))
# {
# 	colnames(svd_docCp)[n] <- paste(toString(n), toString(docnames[n]), sep=".")
# 	rownames(svd_docCp)[n] <- paste(toString(n), toString(docnames[n]), sep=".")
# }

# for(n in 1:length(termnames))
# {
# 	colnames(svd_termCp)[n] <- paste(toString(n), toString(termnames[n]), sep=".")
# 	rownames(svd_termCp)[n] <- paste(toString(n), toString(termnames[n]), sep=".")
# }

logfunc("log.txt", "Result Saving...")

# write.table(termnames, file = "Termnames.csv", sep = ",", col.names = NA, qmethod = "double")
# write.table(docnames, file = "Docnames.csv", sep = ",", col.names = NA, qmethod = "double")
write.table(mx, file = "X.csv", sep = ",", col.names = NA, qmethod = "double")
write.table(svd_T, file = "T.csv", sep = ",", col.names = NA, qmethod = "double")
write.table(svd_S, file = "S.csv", sep = ",", col.names = NA, qmethod = "double")
write.table(svd_d, file = "t(D).csv", sep = ",", col.names = NA, qmethod = "double")
write.table(svd_docCp, file = "DocComparison.csv", sep = ",", col.names = NA, qmethod = "double")
write.table(svd_termCp, file = "TermComparison.csv", sep = ",", col.names = NA, qmethod = "double")

logfunc("log.txt", "Program Complete...")

