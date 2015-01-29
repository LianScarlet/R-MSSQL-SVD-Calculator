sqlcmd -S %1 -U %2 -P %3 -d %4 -v ExprName="%5" -i CreateResultTable.sql
rscript SVDExpr.R %5 %6 %7 %8
bcp.exe %4.dbo.%5_DD in %6\%5\DD.txt -e err.txt -c -S %1 -U %2 -P %3
bcp.exe %4.dbo.%5_TT in %6\%5\TT.txt -e err.txt -c -S %1 -U %2 -P %3
bcp.exe %4.dbo.%5_TD in %6\%5\TD.txt -e err.txt -c -S %1 -U %2 -P %3
rscript CompleteLog.R %5 %6 
pause