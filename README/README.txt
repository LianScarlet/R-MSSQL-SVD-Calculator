====== �e�m�@�~ ======
1. �w�� SQL Server
2. �w�� R  ( http://cran.r-project.org/bin/windows/base/ )
3. �ϥ� RGui �w�� R �M�� RODBC �B svd
4. �}�� ���� > ���e > �i���t�γ]�w > �����ܼ� >
	�b Path ���s�W C:\Program Files\R\R-3.1.2\bin (�i��]�w�˸��|�Ϊ������P���ǳ\�۲��A�Цۦ�ץ����| )


====== RunBuilder.bat �ѼƳ]�m ======
1. �� SQL Server ���إ� SVD �һݪ� Documents View (DocView.jpg) �� Terms View (TermView.jpg)
2. �s�� RunBuilder.bat
	Process.bat <Server> <UserID> <UserPWD> <DBName> <DocView> <TermView> <New_MatrixTable> 
		<New_MatrixTable>���إߪ� Table �W�� ( Table �d�Ҥ��e�Ԩ� MxTable.jpg )
2. ���� RunBuilder.bat



====== RunExpr.bat �ѼƳ]�m ======
1. �s�� RunBuilder.bat
	SVDExpr.R <ExprName> <DirPath> <Dimension_of_S>
		<ExprName>����W��( �|�H���W�٫إ߸�Ƨ��s�񵲪G )
		<DirPath>�������һݭn�� Matries FIle ( T.csv�BS.csv�Bt(D).csv) �ɮצs�񪺸�Ƨ����|
		<Dimension_of_S>Matrix S ���j�p
1. ���� RunBuilder.bat


	
	