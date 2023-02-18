FOR %%a IN (*.XOM) DO (
 Xom2Xml %%~na.XOM -out %%~na.xml -l >%%~na.txt
 )
