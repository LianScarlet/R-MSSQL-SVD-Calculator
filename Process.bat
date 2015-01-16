:: ¨Ì§Ç°õ¦æ¨C¦æ Code
:: Process.bat <Server> <UserID> <UserPWD> <DBName> <DocView> <TermView> <New_MatrixTable>  
echo Starting...
echo Creating Matrix Table...
sqlcmd -S %1 -U %2 -P %3 -d %4 -v DocView="%5" TermView="%6" MxTable="%7" -i BuildMatrix.sql
rscript DoSVD.R %1 %2 %3 %4 %5 %7
pause
