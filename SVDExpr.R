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

# 將 Matrix 中的資料以資料表的格式存入 .txt 
Save_BCP <- function( rows, cols, mx, BCPfile, part)
{
	# 儲存做BCP要用的字串
	BCPtxt <- ""
	# 檢查 columns 跟 rows 名稱是否相同，相同的話只需儲存下三角
	check <- toString(cols) == toString(rows)
	for(i in 1:length(rows))
	{
		# 取得 Row 的 id
		rid <- toString(rows[i])
		for(j in 1:length(cols))
		{	
			# 取得 Column 的 id		
			cid <- toString(cols[j])
			# cid <- strsplit(toString(cols[j]),"[.]")[[1]][1]
			# Database 中的 attribute 是以 int 宣告 ， 
			# 故將 Similarity 乘以100取得小數點後二位之數值
			simi <- floor(mx[i,j] * 100)
			# 數值高於門檻才紀錄
			if(simi > 99)
			{
				# 將個數值組成資料表的 Row
				BCPRow <- paste(rid, cid, toString(simi), toString(t), sep="\t")
				# 將 Row 加入 BCPtxt 中
				if(BCPtxt == "")
					BCPtxt <- BCPRow
				else
					BCPtxt <- paste(BCPtxt, BCPRow, sep="\n")
			}
			# columns 跟 rows 相同，故取到三角形的斜邊時跳出 for 迴圈
			if(check && i == j)
				break
		}
		# 將累積一定長度的 BCPtxt 寫入檔案，並清空 BCPtxt
		if(BCPtxt != "")
		{
			write( BCPtxt, file=BCPfile, append=TRUE, sep="")	
			BCPtxt <- ""
		}
	}		
}

args <- commandArgs(trailingOnly = TRUE)
# 取得實驗名稱
exprname <- args[1]
# 取得實驗路徑
workdir <- args[2]
# 取得實驗的次數
times <- as.integer(args[3])
# 取得每次實驗的數值百分比
range <- as.double(args[4]) / 100

# 設定工作路徑
print("Creating Directory...")
setwd(workdir)
logpath <- paste(workdir, "\\",exprname, "\\log.txt",sep="")
BCPpath <- paste(workdir, "\\",exprname, "\\",sep="")
# 建議以 exprname 為名稱的資料夾
dir.create(exprname, showWarnings = TRUE, recursive = FALSE)

# 資料讀取，並從讀取的資料中取出需要的部分
docnames <- read.csv("Docnames.csv", header = FALSE)
docnames <- docnames[2:nrow(docnames),2:ncol(docnames)]
termnames <- read.csv("Termnames.csv", header = FALSE)
termnames <- termnames[2:nrow(termnames),2:ncol(termnames)]
logfunc(logpath, "Reading T.csv ...")
mx_T <- read.csv("T.csv", header = FALSE)
mx_T <- Mx_Convert_Double(as.matrix(mx_T[2:nrow(mx_T),2:ncol(mx_T)]))
logfunc(logpath, "Reading S.csv ...")
mx_S <- read.csv("S.csv", header = FALSE)
mx_S <- Mx_Convert_Double(as.matrix(mx_S[2:nrow(mx_S),2:ncol(mx_S)]))
logfunc(logpath, "Reading t(D).csv ...")
mx_d <- read.csv("t(D).csv", header = FALSE)
mx_d <- Mx_Convert_Double(as.matrix(mx_d[2:nrow(mx_d),2:ncol(mx_d)]))

# 設定工作路徑
setwd(exprname)

# 計算數值區間
range <- nrow(mx_S) * range

# t 為實驗的次序
for(t in 1:times)
{
	# 次序 * 區間 = Dimension
	dim <- as.integer(t * range)
	dirname <- paste(exprname, "_", t, "of", times, "_Dim(", dim, ")", sep="")
	dir.create(dirname, showWarnings = TRUE, recursive = FALSE)
	setwd(dirname)
	logfunc(logpath, paste("Calculating", dirname, "..."))

	# X = T S D'
	mx_X <- mx_T[,1:dim] %*% mx_S[1:dim,1:dim] %*% mx_d[1:dim,]
	# 計算 Document Similarity
	mx_DocCp <- t(mx_X) %*% mx_X
	# 計算 Term Similarity
	mx_TermCp <- mx_X %*% t(mx_X)

	# 將 Matrix 中的結果以資料表的格式存入 DD.txt, TT.txt, TD.txt 
	logfunc(logpath, "BCP File Saving...DocSimilarity")
	Save_BCP( docnames, docnames, mx_DocCp, paste(BCPpath, "DD.txt", sep=""), t)
	logfunc(logpath, "BCP File Saving...TermSimilarity")
	Save_BCP( termnames, termnames, mx_TermCp, paste(BCPpath, "TT.txt", sep=""), t)
	logfunc(logpath, "BCP File Saving...TermDocAssociation")
	Save_BCP( termnames, docnames, mx_X, paste(BCPpath, "TD.txt", sep=""), t)

	# 將 Matrix 中的結果寫入 .csv 檔案
	logfunc(logpath, "csv Files Saving...")
	write.table(mx_X, file = "X.csv", sep = ",", col.names = NA, qmethod = "double")
	write.table(mx_DocCp, file = "DocComparison.csv", sep = ",", col.names = NA, qmethod = "double")
	write.table(mx_TermCp, file = "TermComparison.csv", sep = ",", col.names = NA, qmethod = "double")
	# 跳回當前路徑的前一層
	setwd("..")	
}
logfunc(logpath, "Saving Result to SQL Server...")