====== 前置作業 ======
1. 安裝 SQL Server
2. 安裝 R  ( http://cran.r-project.org/bin/windows/base/ )
3. 使用 RGui 安裝 R 套件 RODBC 、 svd
4. 開啟 本機 > 內容 > 進階系統設定 > 環境變數 >
	在 Path 中新增 C:\Program Files\R\R-3.1.2\bin (可能因安裝路徑或版本不同有些許相異，請自行修正路徑 )


====== RunBuilder.bat 參數設置 ======
1. 於 SQL Server 中建立 SVD 所需的 Documents View (DocView.jpg) 及 Terms View (TermView.jpg)
2. 編輯 RunBuilder.bat
	Process.bat <Server> <UserID> <UserPWD> <DBName> <DocView> <TermView> <New_MatrixTable> 
	
	<DocView> 	先前建立的 Documents View 名稱
	<TermView>	先前建立的 Terms View 名稱
	<New_MatrixTable>	存放 Matrix Rows 的 Table 名稱， Table 將由 BuildMatrix.sql 自動生成。務必確認當前資料庫中無同名之Table。

2. 執行 RunBuilder.bat



====== RunExpr.bat 參數設置 ======
1. 編輯 RunExpr.bat
	processExpr.bat <Server> <UserID> <UserPWD> <DBName> <ExprName> <DirPath> <Times> <increase n% of S per time>
				
	<ExprName> 	實驗名稱請以英文命名，勿使用特殊字元。程式將以此名稱於 Database建立Table。勿使用重複的實驗名稱。
	<DirPath>	RunBuilder.bat 產生的資料夾路徑
	<Times> 	計算的總次數 
	<Increase n% of S per time>	S0的 Dimension 每次增加 n%

2. 執行 RunExpr.bat


	
	