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
	
	<DocView> 	���e�إߪ� Documents View �W��
	<TermView>	���e�إߪ� Terms View �W��
	<New_MatrixTable>	�s�� Matrix Rows �� Table �W�١A Table �N�� BuildMatrix.sql �۰ʥͦ��C�ȥ��T�{��e��Ʈw���L�P�W��Table�C

2. ���� RunBuilder.bat



====== RunExpr.bat �ѼƳ]�m ======
1. �s�� RunExpr.bat
	processExpr.bat <Server> <UserID> <UserPWD> <DBName> <ExprName> <DirPath> <Times> <increase n% of S per time>
				
	<ExprName> 	����W�ٽХH�^��R�W�A�ŨϥίS��r���C�{���N�H���W�٩� Database�إ�Table�C�Ũϥέ��ƪ�����W�١C
	<DirPath>	RunBuilder.bat ���ͪ���Ƨ����|
	<Times> 	�p�⪺�`���� 
	<Increase n% of S per time>	S0�� Dimension �C���W�[ n%

2. ���� RunExpr.bat


	
	