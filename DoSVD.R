# 引用 Library
library(RODBC)
library(svd)

# Log 紀錄專用函式
logfunc <- function(filename, logtext)
{
	print(logtext)
	#記下每個步驟執行的時間以便觀察
	logcont <- paste(format(Sys.time(), "%Y-%m-%d %X"),":", logtext)
	#將 Log 寫入指定檔案
	write( logcont, file=filename, append=TRUE)						
}

# 將 Matrix 內 Cell 的型態轉為 Double
Mx_Convert_Double <- function(mx)
{
	# 轉為 Double 後 ， dmx 將不會是 Matrix 的型態
	dmx <- as.double(mx) 
	# 將 dmx 從新組成 Matrix
	dmx <- matrix(dmx, nrow=nrow(mx), ncol=ncol(mx))	
	return(dmx)				
}

# 從 .bat 傳入參數
args <- commandArgs(trailingOnly = TRUE)

# 將 .bat 中取得的數值存入自訂參數
server <- args[1]
uid <- args[2]
pwd <- args[3]
dbname <- args[4]
docview <- args[5]
mxview <- args[6]

print("Creating Directory...")
# 建立實驗專屬資料夾儲存結果，以開始執行的時間命名
dirname <- paste(mxview, "-", format(Sys.time(), "%Y-%m-%d-%k%M%S"), sep="")
dir.create(dirname, showWarnings = TRUE, recursive = FALSE)

# 設定工作目錄
setwd(dirname)

# 紀錄 Log
logfunc("log.txt", "Connecting Database...")


# 設定連線資訊
conn <- odbcDriverConnect(paste("driver={SQL Server};server=", server, ";database=", dbname, ";uid=", uid, ";pwd=", pwd, ";", sep=""))
# 建立 SQL 指令
sqlcmd <- paste("select Row, CONVERT(nvarchar,TID) from ", mxview, sep=" ")
# conn <- odbcDriverConnect("driver={SQL Server};server=;database=;uid=;pwd=")
# sqlcmd <- "select Row, Term from "
# 執行SQL指令並取得回傳結果
res <- sqlQuery(conn, sqlcmd)
# sqlcmd <- "select Doc from "
sqlcmd <- paste("select CONVERT(nvarchar,DID), Doc, DocName from ", docview, sep=" ")
docs <- sqlQuery(conn, sqlcmd)
# 關閉連線
odbcClose(conn)

# 將取得的結果分別存入變數
# res 的 column 1 
datarows <- as.vector(res[,1])
# res 的 column 2
termnames <- as.vector(res[,2])
# docs 的 column 1,2,3
docIDs <- as.vector(docs[,1])
docconts <- as.vector(docs[,2])
docnames <- as.vector(docs[,3])



logfunc("log.txt", "Matrix Building...")

mx <- read.table(text = datarows)
# 將第一筆 datarows 的資料存進 Matrix 型態的變數
# 主要是為設定 Columns 的數量
# datarow <- datarows[1]
# mx <- read.table(text = toString(datarow))


# # 依序將每一筆 datarow append into Matrix(效率差)
# for(n in 2:length(datarows))
# {
# 	mxtmp <- read.table(text = toString(datarows[n]))
# 	mx <- rbind(mx, mxtmp)
# }

# 將欄位命名以便觀察
# for(n in 1:length(docnames))
# {
# 	colnames(mx)[n] <- toString(docnames[n])
# }

# for(n in 1:length(termnames))
# {
# 	rownames(mx)[n] <- toString(termnames[n])
# }


# X = T S D'
# s$u %*% D %*% t(s$v) #  X = U D V'

logfunc("log.txt", "SVD Calculating...")

# 使用 svd Library 的函式計算 svd
s <- svd(mx)
# 將結果存入變數
mx_T <- s$u
mx_S <- diag(s$d)
mx_d <- t(s$v)

logfunc("log.txt", "Result Saving...")

# 將所有結果以 .RData 格式寫入檔案，之後用R做實驗可以快速讀取參數
save(termnames,file="vt_TermNames.RData")
save(docIDs,file="vt_DocIDs.RData")
save(docnames,file="vt_DocNames.RData")
save(docconts,file="vt_DocConts.RData")
save(mx,file="mx_X.RData")
save(mx_T,file="mx_T.RData")
save(mx_S,file="mx_S.RData")
save(mx_d,file="mx_t(D).RData")

# 將所有結果以 .csv 格式寫入檔案，以便其他程式讀取使用
# write.table(termnames, file = "Termnames.csv", sep = ",", col.names = NA, qmethod = "double")
# write.table(docIDs, file = "DocIDs.csv", sep = ",", col.names = NA, qmethod = "double")
# write.table(docnames, file = "Docnames.csv", sep = ",", col.names = NA, qmethod = "double")
# write.table(docconts, file = "DocConts.csv", sep = ",", col.names = NA, qmethod = "double")
# write.table(mx, file = "X.csv", sep = ",", col.names = NA, qmethod = "double")
# write.table(round(mx_T,3), file = "T.csv", sep = ",", col.names = NA, qmethod = "double")
# write.table(round(mx_S,3), file = "S.csv", sep = ",", col.names = NA, qmethod = "double")
# write.table(round(mx_d,3), file = "t(D).csv", sep = ",", col.names = NA, qmethod = "double")

logfunc("log.txt", "Program Complete...")

