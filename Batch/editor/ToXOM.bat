FOR %%a IN (*.xml) DO (
 Xom2Xml %%~na.xml -out ../%%~na.XOM -l >%%~na.txt
 )
 pause
