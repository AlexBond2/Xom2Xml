# Xom2Xml

Console converter XOM files to XML for Windows

```
Usage:
   Xom2Xml <filename> [options]

Filename:
   file.xml             For converting xml file to xom
   file.xom             For converting xom file to xml

Options:
   -h                   Shows help and usage information
   -id                  Export Xid index to XML to save original order
   -schm <file>         Sets a custom scheme file.
                        The default is XOMSCHM.dat scheme file
   -out <file>          Sets output filename to save
   -xom <file>          Sets input filename as xom
   -l                   Logs process of reading
   -cl                  Export XML in game format
   -xfloat              Slow writing float values with max precision
   -ximg-file <format>  Set XImage data in format:
    -ximg-file bin      BIN with Mipmaps
    -ximg-file dds      DDS with Mipmaps
    -ximg-file png      PNG compression
    -ximg-file tga      TGA format
   -ximg-dir <dir>      Save XImages files in custom directory.
                        The default is output folder for XML
                        
```
## Examples
Extract WUM Textures as **tga** format in folder **ThemeArabian**
```
Xom2Xml Bundl13.xom -ximg-file tga -ximg-dir ThemeArabian
Xgame = WUM
... conversion Bundl13.xom >> Bundl13.xml done.
```
Extract W3D Textures as **tga** format in folder **ThemePirate**
```
Xom2Xml Bundle08.xom -ximg-file tga -ximg-dir ThemePirate
Xgame = W3D
... conversion Bundle08.xom >> Bundle08.xml done.
```
Convert WUM Xom to Xml in folder **editfolder**
```
Xom2Xml MenuTwk.xom -out editfolder\MenuTwk.xml
Xgame = WUM
... conversion MenuTwk.xom >> MenuTwk.xml done.
```
Convert WUM Xml to Xom from **editfolder** to **newxom**
```
Xom2Xml editfolder\MenuTwk.xml -out newxom\MenuTwk.xom
Xgame = WUM
... conversion MenuTwk.xml >> MenuTwk.xom done.
```

## Russian
**Xom2Xml** это консольный конвертер для xom файлов в xml и обатно. 

База **WUM** для xom файлов папок **Data**,**Tweak** и **Data\Bundles** для игры **Worms Ultimate Mayhem**. 

База **W3D** для xom файлов папки **Data**, **Data\Language\PC** и **Data\Bundles** для игры **Worms 3D**. 

База **WF** для xom файлов папки **data\Tweak**, **data\Bundles** и всех остальных для игры **Worms Forts: Under Siege**. 

Программа читает Xom файл по структуре описанной в **XOMSCHM.dat** (обычный XML файл) и конвертирует его в XML формат, которые можно редактировать и конвертировать обратно в Xom. 

```
Использование:
   Xom2Xml <имяфайла> [опции]

Имя файла:
   file.xml             Для преобразования файла xml в xom
   file.xom             Для преобразования файла xom в xml

Опции:
   -h                   Показывает информацию по использованию
   -id                  Экспортирует Xid индекс в XML для сохранения оригинального порядка контейнеров
   -schm <file>         Установить пользовательский файл структуры. По умолчанию используется XOMSCHM.dat
   -out <file>          Установить выходное имя файла
   -xom <file>          Установить входное имя файла
   -l                   Вывести лог процесса чтения
   -cl                  Экспортирует XML в игровом формате
   -xfloat              Медленная запись плавающих значений с максимальной точностью
   -ximg-file <format>  Преобразовать данные XImage в формате:
    -ximg-file bin      BIN с Mipmaps
    -ximg-file dds      DDS с Mipmaps
    -ximg-file png      PNG с сжатием
    -ximg-file tga      TGA формат
   -ximg-dir <dir>      Сохранить XImages файлы в выбранном пути.
                        По умолчанию путь тот же что и XML   
                        
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

## Пример с сохранение XImage в формате dds, png, tga в отдельную папку
```
Xom2Xml Bundl00.xom -ximg-file dds -ximg-dir dds
Xgame = WUM
... conversion Bundl00.xom >> Bundl00.xml done.

Xom2Xml Bundl13.xom -ximg-file tga -ximg-dir ThemeArabian
Xgame = WUM
... conversion Bundl13.xom >> Bundl13.xml done.

Xom2Xml Bundl14.xom -ximg-file png -ximg-dir ThemeBuilding
Xgame = WUM
... conversion Bundl14.xom >> Bundl14.xml done.
```
**Примечание:** папка указазанная флагом **-ximg-dir** будет автоматически создана, если ее нет. Сам же **xml** будет сохранен в папке где был **xom**. Можно указать  и общую папку для **xml** и текстур через **-out**, но не обе сразу. Это сделано из-за относительного адреса внутри **xml** на ресурс к изображению. Иначе при обратной конвертации текстуры не будут найдены, это нужно учитывать.

## Пример конвертации с максимальной точностью
При такой конвертации файл **xom\Bundl474.xom** будет идентичен оригиналу.
```
Xom2Xml Bundl474.xom -id -xfloat -ximg-file dds -out xml\Bundl474.xml
Xgame = WUM
... conversion Bundl474.xom >> Bundl474.xml done.

Xom2Xml xml\Bundl474.xml -out xom\Bundl474.xom
Xgame = WUM
... conversion Bundl474.xml >> Bundl474.xom done.
```
**Примечание:** флаг **-id** сохраняет оригинальную сортировку чанков. Формат **dds** для текстур сохраняет все MipMaps поэтому их не нужно генерировать. А флаг **-xfloat** повшает точность для чисел. Такая точность нужна только для проверки работы, поэтому флаги **-id** и **-xfloat** можно игнорировать.

## Обновление
Обновление в версии 1.3.3.2:
 - поддержка класса **XPSPBitmapImage** для **PSP** игр **Worms Battle Islands**, **Worms Open Warfare**, **Worms Open Warfare 2**
 - сборка блоков из **KEV** файлов в PNG и обратно
 
Обновление в версии 1.3.3.1:
 - поддержка всех классов для **WF** игры **Worms Forts: Under Siege**
 - поиск классов в XML заменен
 - имена текстур **maya:file** для **XImage** корректно преобразуются в имя файла

Обновление в версии 1.3.2.1:
 - поддержка всех классов для **WUM**
 - поддержка всех классов для **W3D**
 - поддержка класса **XTexFont**, **XImage**, **XAnimClipLibrary**
 - поддержка всех файлов с текстурами из папки **Data\Bundles** игры **Worms Ultimate Mayhem**
 - экспорт / импорт форматов **PNG**, **DDS**, **TGA** для экспорта импорта **XImage**
 - возможность сохранять **XImage** как файл и как кодированные данные в **Base64** если формат не выбран
 - автогенерация **MipMaps** для **Ximage** если источник не поддерживает их

Обновление в версии 1.3.0.3:
 - добавлена поддержка классов XGraphSet, XBaseResourceDescriptor, XTextureStage, XGeometry, XAttribute
 - добавлена поддержка некоторых файлов из папки **Data\Bundles** игры **Worms Ultimate Mayhem**
 - добавлен тип **XBase64Byte** для кодированного отображения байтовых данных

Обновление в версии 1.2.1.2:
 - добавлена поддержка карт из игры **Worms 3D**, **Worms 4: Mayhem / Worms Ultimate Mayhem** и создана кастомная схема
 - добавлены **Drag&Drop** батники для конвертации карт и xom файлов перетаскиванием
 - добавлена поддержка файлов из папки **Data** игры **Worms Ultimate Mayhem**

Обновление в версии 1.2.0.2:
 - добавлена поддержка xom файлов для игры **Worms 3D**
 - программа обновлена из-за специфики формата контейнеров **W3D** (ключи с одинаковыми именами но отличающиеся регистром читались как один)
 - формат **Boolean** теперь экспортируется в нижнем регистре **false / true**, т.к. игра не читала **True / False**.
