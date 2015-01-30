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
sqlcmd <- paste("select CONVERT(nvarchar,DID) from ", docview, sep=" ")
docnames <- sqlQuery(conn, sqlcmd)
# 關閉連線
odbcClose(conn)

# 將取得的結果分別存入變數
# res 的 column 1 
datarows <- res[,1]
# res 的 column 2
termnames <- res[,2]
# docnames 的 column 1
docnames <- docnames[,1]


logfunc("log.txt", "Matrix Building...")

# 將第一筆 datarows 的資料存進 Matrix 型態的變數
# 主要是為設定 Columns 的數量
datarow <- datarows[1]
mx <- read.table(text = toString(datarow))


# 依序將每一筆 datarow append into Matrix
for(n in 2:length(datarows))
{
	mxtmp <- read.table(text = toString(datarows[n]))
	mx <- rbind(mx, mxtmp)
}


# X = T S D'
# s$u %*% D %*% t(s$v) #  X = U D V'

logfunc("log.txt", "SVD Calculating...")

# 使用 svd Library 的函式計算 svd
s <- svd(mx)
# 將結果存入變數
svd_T <- s$u
svd_S <- diag(s$d)
svd_d <- t(s$v)

logfunc("log.txt", "Result Saving...")

# 將所有結果以 .csv 格式寫入檔案，以便未來實驗使用
write.table(termnames, file = "Termnames.csv", sep = ",", col.names = NA, qmethod = "double")
write.table(docnames, file = "Docnames.csv", sep = ",", col.names = NA, qmethod = "double")
write.table(mx, file = "X.csv", sep = ",", col.names = NA, qmethod = "double")
write.table(round(svd_T,3), file = "T.csv", sep = ",", col.names = NA, qmethod = "double")
write.table(round(svd_S,3), file = "S.csv", sep = ",", col.names = NA, qmethod = "double")
write.table(round(svd_d,3), file = "t(D).csv", sep = ",", col.names = NA, qmethod = "double")

logfunc("log.txt", "Program Complete...")

