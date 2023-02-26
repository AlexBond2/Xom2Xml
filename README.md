# Xom2Xml

Console converter XOM files to XML for Windows

```
Usage:
   Xom2Xml <filename> [options]

Filename:
   file.xml      For converting xml file to xom
   file.xom      For converting xom file to xml

Options:
   -h            Shows help and usage information
   -id           Export Xid index to XML to save original order
   -schm <file>  Sets a custom scheme file.
                 The default is XOMSCHM.dat scheme file
   -out <file>   Sets output filename to save
   -xom <file>   Sets input filename as xom
   -l            Logs process of reading
   -cl           Export XML in game format   

```

## Russian
**Xom2Xml** это консольный конвертер для xom файлов в xml и обатно. 

База **WUM** для xom файлов папок **Data**,**Tweak** и часть **Data\Bundles** для игры **Worms Ultimate Mayhem**. 

База **W3D** для xom файлов папки **Data** для игры **Worms 3D**. Файлы которые поддерживает база: 
 - xom файлы из папки **Data**
 - языковые файлы xom из папки **Data\Language\PC**

Программа читает Xom файл по структуре описанной в **XOMSCHM.dat** (обычный XML файл) и конвертирует его в XML формат, которые можно редактировать и конвертировать обратно в Xom. 

```
Использование:
   Xom2Xml <имяфайла> [опции]

Имя файла:
   file.xml     Для преобразования файла xml в xom
   file.xom     Для преобразования файла xom в xml

Опции:
   -h           Показывает информацию по использованию
   -id          Экспортирует Xid индекс в XML для сохранения оригинального порядка контейнеров
   -schm <file> Установить пользовательский файл структуры. По умолчанию используется XOMSCHM.dat
   -out <file>  Установить выходное имя файла
   -xom <file>  Установить входное имя файла
   -l           Вывести лог процесса чтения
   -cl          Экспортирует XML в игровом формате
```
## Пример для карт

**Worms 3D**
```
xom2xml kong.xom -schm W3DMAP.xml -out kong.xml
Xgame = W3D
... conversion kong.xom >> kong.xml done.

xom2xml kong.xml -schm W3DMAP.xml -out kong_new.xom
Xgame = W3D
... conversion kong.xml >> kong_new.xom done.
```

**Worms 4: Mayhem / Worms Ultimate Mayhem**  
(структура \*.xan файлов не отличается от W3D версии и тут подходит схема W3DMAP.xml)
```
xom2xml -xom Multi_TyrannoSawUs.xan -schm W3DMAP.xml -out Multi_TyrannoSawUs.xml
Xgame = W3D
... conversion Multi_TyrannoSawUs.xan >> Multi_TyrannoSawUs.xml done.

xom2xml Multi_TyrannoSawUs.xml -schm W3DMAP.xml -out Tyranno.xan
Xgame = W3D
... conversion Multi_TyrannoSawUs.xml >> Tyranno.xan done.
```

## Обновление

Обновление в версии 1.3.0.3:
 - добавлена поддержка классов XGraphSet, XBaseResourceDescriptor, XTextureStage, XGeometry, XAttribute
 - добавлена поддержка некоторых файлов файлов из папки **Data\Bundles** игры **Worms Ultimate Mayhem**
 - добавлен тип **XBase64Byte** для кодированного отображения байтовых данных

Обновление в версии 1.2.1.2:
 - добавлена поддержка карт из игры **Worms 3D**, **Worms 4: Mayhem / Worms Ultimate Mayhem** и создана кастомная схема
 - добавлены **Drag&Drop** батники для конвертации карт и xom файлов перетаскиванием
 - добавлена поддержка файлов из папки **Data** игры **Worms Ultimate Mayhem**

Обновление в версии 1.2.0.2:
 - добавлена поддержка xom файлов для игры **Worms 3D**
 - программа обновлена из-за специфики формата контейнеров **W3D** (ключи с одинаковыми именами но отличающиеся регистром читались как один)
 - формат **Boolean** теперь экспортируется в нижнем регистре **false / true**, т.к. игра не читала **True / False**.
