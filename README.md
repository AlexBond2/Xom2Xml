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

```

## Russian
**Xom2Xml** это консольный конвертер для xom файлов папки Tweak для игры **Worms Ultimate Mayhem**. 

Программа читает Xom файл по структуре описанной в **XOMSCHM.dat** (обычный XML файл) и конвертирует его в XML формат, которые можно редактировать и конвертировать обратно в Xom. 

Теоретически может конвертировать любой XOM любой игры, но нужен файл структуры XOMSCHM.dat. На данный момент составлен только файл для типов xom файлов папки Tweak для игры Worms Ultimate Mayhem.
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
```
