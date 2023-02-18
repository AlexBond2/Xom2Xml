## Инструкция от firsacho

Как с этим работать:
 1. копируем папку **/editor** в директорию игры, которую хотим редактировать, например в **/Data/Tweak/**;
 2. копируем **ВСЕ** .XOM файлы, которые хотим посмотреть в папку **/editor/sources/** , жмём по **ToXML.BAT** и они все конвертируются в .XML и появляются в этой же папке. В папке /editor/sources/ ничего НЕ РЕДАКТИРУЕМ - здесь только исходные .XOM и .XML файлы. Удобно для их изучения и бэкапа;
 3. сконвертированные .XML файлы копируем в папку **/editor/**. Здесь мы редактируем файлы блокнотом и сохраняем.
 4. жмём **ToXOM.BAT** и все XML файлы в этой папке конвертируются в XOM и сразу заменяют оригинальные файлы в каталоге выше (т.е. в примере в **/Data/Tweak/**);
 5. если что-то поломалось и не работает идем в **/editor/sources/** и восстанавливаем оригинальные файлы.

В чем особенность работы:
 - прогу (Xom2Xml c XOMSCHM.dat файлом) разделяем по 2м папкам - одна часть для конвертации в XML, вторая для обратной конвертации в XOM;
 - в папках лежат соответствующие .BAT файлы для быстрой конвертации всех файлов в директории "одним кликом" (вообще с .BAT намного быстрее работать, думаю его очень не хватает в комплекте с прогой);
 - в .BAT также прописана опция делать логи в .TXT файлах, поэтому если что то сломалось в процессе конвертации - можно посмотреть причину в соответствующем файле.