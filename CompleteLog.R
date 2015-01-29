logfunc <- function(filename, logtext)
{
	print(logtext)
	logcont <- paste(format(Sys.time(), "%Y-%m-%d %X"),":", logtext)
	write( logcont, file=filename, append=TRUE)						
}

args <- commandArgs(trailingOnly = TRUE)
# 取得實驗名稱
exprname <- args[1]
# 取得實驗路徑
workdir <- args[2]
# 設定Log路徑
logpath <- paste(workdir, "\\",exprname, "\\log.txt",sep="")

logfunc(logpath, "Experiment Complete !!")