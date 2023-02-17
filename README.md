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
   -l            Logs process of reading
   -cl           Export XML in game format   

```

## Russian
**Xom2Xml** это консольный конвертер для xom файлов в xml и обатно. 

База **WUM** для xom файлов папки **Tweak** для игры **Worms Ultimate Mayhem**. 

База **W3D** для xom файлов папки **Data** для игры **Worms 3D**. Файлы которые поддерживает база: 
 - xom файлы из папки Data
 - языковые файлы xom из папки Data\Language\PC

Программа читает Xom файл по структуре описанной в **XOMSCHM.dat** (обычный XML файл) и конвертирует его в XML формат, которые можно редактировать и конвертировать обратно в Xom. 

```
Использывание:
   Xom2Xml <имяфайла> [опции]

Имя файла:
   file.xml     Для преобразования файла xml в xom
   file.xom     Для преобразования файла xom в xml

Опции:
   -h           Показывает информацию по использованию
   -id          Экспортирует Xid индекс в XML для сохранения оригинального порядка контейнеров
   -schm <file> Установить пользовательский файл структуры. По умолчанию используется XOMSCHM.dat
   -out <file>  Установить выходное имя файла
   -l           Вывести лог процесса чтения
   -cl          Экспортирует XML в игровом формате
```
## Обновление

Обновление в версии 1.2.0.2:
 - добавлена поддержка xom файлов для игры **Worms 3D**
 - программа обновлена из-за специфики формата контейнеров **W3D** (ключи с одинаковыми именами но отличающиеся регистром читались как один)
 - формат **Boolean** теперь экспортируется в нижнем регистре **false / true**, т.к. игра не читала **True / False**.
