FOR %%a IN (Bonus_*.xom;*.kev) DO (
 Xom2Xml -xom "%%~nxa" -id -schm PSPMAP.xml -ximg-file png -out "landscape\%%~na.xml"
 )
