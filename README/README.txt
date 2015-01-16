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
		<New_MatrixTable>欲建立的 Table 名稱 ( Table 範例內容詳見 MxTable.jpg )
2. 執行 RunBuilder.bat



====== RunExpr.bat 參數設置 ======
1. 編輯 RunBuilder.bat
	SVDExpr.R <ExprName> <DirPath> <Dimension_of_S>
		<ExprName>實驗名稱( 會以此名稱建立資料夾存放結果 )
		<DirPath>執行實驗所需要的 Matries FIle ( T.csv、S.csv、t(D).csv) 檔案存放的資料夾路徑
		<Dimension_of_S>Matrix S 的大小
1. 執行 RunBuilder.bat


	
	