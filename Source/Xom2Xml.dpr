program Xom2Xml;

{$APPTYPE CONSOLE}
{$R 'res\icon.res' 'res\icon.rc'}

uses
  SysUtils,
  Classes,
  XomLibTwk,
  XomCntrLibTwk,
  NativeXml;

var
  FileName, OFilename, lafDir : String;
  guid, help, schema, log, isxid, outfile,
  clear, xomfile, hqfloat, islaf: Boolean;
  XData: TDataInfo;

procedure ExportXML(FileName: String; schmnode : TXmlNode);
var
  XML: TNativeXml;
  LoadedXom:TXom;
  node,xomObjects,xomTypes,XContainer,XType: TXmlNode;
  s, dir: string;
  xomArchive,XNode: TsdElement;
  i,Xver: integer;
begin
  LoadedXom:=TXom.Create;
  LoadedXom.LoadXomFileName(FileName);
  LoadedXom.LogXML:=log;
  LoadedXom.IsXid:=isxid;
  LoadedXom.XData:=XData;
  LoadedXom.hqFloat := hqFloat;
  XContainer := schmnode.NodeByName('XContainer');

  XML := TNativeXml.CreateName('xomArchive');
  XML.XmlFormat := xfReadable;
  XML.EolStyle := esLF;
  XML.NodeClosingStyle := ncDefault;

  //XML.ExternalEncoding := seUTF8;

  xomArchive := XML.Root;
  if not clear then begin
 // Types
  xomTypes := XML.NodeNew('xomTypes');
  if LoadedXom.XomHandle.nType <> $2000000 then // MOIK default version
    xomTypes.AttributeAdd(XML.AttrText('Xver', IntToStr(LoadedXom.XomHandle.nType shr 24)));

  for i:=0 to LoadedXom.XomHandle.NumTypes-1 do begin
        XNode := TsdElement.CreateParent(XML,xomTypes);
        XType := LoadedXom.GetXTypeNode(i, schmnode);
        if XType=nil then begin
          WriteLn(Format('Error: Try read %s type [%d]',[LoadedXom.XomHandle.TypesInfo[i].Name, i]));
          Halt;
        end;
        XNode.Name := XType.Name;
        XVer:=StrToInt(XType.AttributeValueByName['Xver']);
        if LoadedXom.XomHandle.TypesInfo[i].btype<>XVer then
        XNode.AttributeAdd(XML.AttrText('Xver', IntToStr(LoadedXom.XomHandle.TypesInfo[i].btype)));
        XNode.NodeClosingStyle := ncClose;
  end;
  
  xomArchive.NodeAdd(xomTypes);
  end;
 // Objects
  xomObjects := XML.NodeNew('xomObjects');

  // convert to XML
  LoadedXom.XMLNumCntr:=0;
  LoadedXom.AddXMLNode(LoadedXom.BaseCntr,schmnode,'id',XML,xomObjects);
  If LoadedXom.BaseCntr.CntrArr.Count-1 < LoadedXom.XMLNumCntr then
    Writeln(Format('Error: Loaded %d of %d',[LoadedXom.XMLNumCntr,LoadedXom.BaseCntr.CntrArr.Count-1]));
  If LoadedXom.BaseCntr.CntrArr.Count-1 > LoadedXom.XMLNumCntr then
    Writeln(Format('Warning: Loaded %d of %d',[LoadedXom.XMLNumCntr,LoadedXom.BaseCntr.CntrArr.Count-1]));
  xomArchive.NodeAdd(xomObjects);
  if outfile then begin
    dir := ExtractFilePath(OFileName);
    if not DirectoryExists(dir) then CreateDir(dir);
    s := OFileName;
  end else
  s := ChangeFileExt(FileName,'.xml');
  Writeln('... conversion ', ExtractFileName(FileName), ' >> ', ExtractFileName(s) ,' done.');
  XML.SaveToFile(s);
  XML.Free;
  LoadedXom.Free;
end;

procedure ExportXom(FileName: String; schmnode : TXmlNode);
var
  XML: TNativeXml;
  NewXom:TXom;
  node,xomObjects,xomTypes,XContainer: TXmlNode;
  s, dir: string;
  code: string;
begin
  XML:=TNativeXml.CreateName('xomArchive');
  XML.XmlFormat := xfReadable;
  XML.EolStyle := esLF;
  XML.LoadFromFile(FileName);
  xomTypes := XML.Root.NodeByName('xomTypes');
  xomObjects := XML.Root.NodeByName('xomObjects');
  XContainer := schmnode;
  // parse
  NewXom:=TXom.Create;
  NewXom.LogXML:=log;
  NewXom.LoadFromXML(xomTypes,xomObjects,XContainer);
  if outfile then begin
    dir := ExtractFilePath(OFileName);
    if not DirectoryExists(dir) then CreateDir(dir);
    s := OFileName;
  end else
  s := ChangeFileExt(FileName,'.xom');
  Writeln('... conversion ', ExtractFileName(FileName), ' >> ', ExtractFileName(s) ,' done.');
  NewXom.SaveXom(s);
  NewXom.Free;
  XML.Free;
end;

procedure ExportGuidXML(FileName: String);
var
  XML: TNativeXml;
  node: TXmlNode;
  s: string;
  code: string;
  NewXom:TXom;
  xomGUID: TsdElement;
  i: integer;
begin
  NewXom:=TXom.Create;
  NewXom.LoadXomFileName(FileName);
  XML := TNativeXml.CreateName('xomSCHM');
  XML.XmlFormat := xfReadable;
  xomGUID := XML.Root;
  for i:=0 to NewXom.XomHandle.NumTypes-1 do begin
  if NewXom.XomHandle.TypesInfo[i].Size = 0 then
   xomGUID.NodeAdd(
         XML.NodeNewTextAttr( NewXom.XomHandle.TypesInfo[i].Name,'0',[
          XML.AttrText('guid',   GUIDToString(NewXom.XomHandle.TypesInfo[i].GUID)),
          XML.AttrText('Xver',   IntToStr(NewXom.XomHandle.TypesInfo[i].btype))
          ])
   )
  else
   xomGUID.NodeAdd(
         XML.NodeNewAttr( NewXom.XomHandle.TypesInfo[i].Name,[
         XML.AttrText('guid',   GUIDToString(NewXom.XomHandle.TypesInfo[i].GUID)),
         XML.AttrText('Xver',   IntToStr(NewXom.XomHandle.TypesInfo[i].btype))
         ])
   );
  end;
  if outfile then
    s := OFileName
  else
    s := ChangeFileExt(FileName,'_GUID.xml');
  XML.SaveToFile(s);
  XML.Free;
  Writeln('... export GUID ', ExtractFileName(FileName), ' >> ', ExtractFileName(s) ,' done.');
  NewXom.Free;
end;

function CompareFileNames(Str: TStringList; Index1, Index2: Integer): Integer;
var
  Num1, Num2: Integer;
  function GetNum(FileName:String):Integer;
  begin
    Delete(FileName, 1, 5);
    Delete(FileName, Pos('.', FileName), 4);
    Result := StrToIntDef(FileName, -1);
  end;
begin
  Num1 := GetNum(Str[Index1]);
  Num2 := GetNum(Str[Index2]);
  if (Num1 = -1) or (Num2 = -1) then
    Result := CompareText(Str[Index1], Str[Index2])
  else
    Result := Num1 - Num2;
end;

procedure PackLaf(DirPath:String);
var
 Files: TStringList;
 FileStream, Data: TMemoryStream;
 Size, Offset, OldOffset: Longword;
 i: integer;
 Filename: String;

  function GetFiles(Dir: string): TStringList;
  var
    SR: TSearchRec;
    f: Integer;
    FileTempl: String;
  begin
    Result := TStringList.Create;
    FileTempl := IncludeTrailingPathDelimiter(Dir) + 'file_*.*';
    f := FindFirst(FileTempl, faAnyFile, SR);
    while f = 0 do
    begin
      Result.Add(SR.Name);
      f := FindNext(SR);
    end;
    FindClose(SR);
    Result.CustomSort(CompareFileNames);
  end;

begin
  Files := GetFiles(DirPath);
  if Files.Count > 0 then begin
    Data := TMemoryStream.Create;
    FileStream := TMemoryStream.Create;
    Offset := 0;
    for i:=0 to Files.Count-1 do
    begin
      OldOffset := Offset;
      Filename := IncludeTrailingPathDelimiter(DirPath) + Files.Strings[i];
      FileStream.LoadFromFile(Filename);
      Size := FileStream.Size;
      Offset := OldOffset + Size + 4;
      Data.Write(Offset,4);
      FileStream.SaveToStream(Data);
      FileStream.Clear;
      //Data.CopyFrom(FileStream, Size);
      Writeln('<< '+Filename);
    end;
   FileStream.Free;
   Files.Free;
   if not outfile then OFilename:='global.laf';
   Data.SaveToFile(OFilename);
   Data.Free;
  end;
  Writeln('... '+OFilename+' saved');
end;

procedure UnpackLaf(Filename, DirPath:String);
var
  FileStream: TFileStream;
  Size, Offset, OldOffset: Longword;
  Data: TMemoryStream;
  Index: Integer;
  NewFilename, DataName: string;

  function GetFileExt(Data: TMemoryStream): string;
  var Magic: array [0..3] of Char;
  begin
   Data.Position:=0;
   Data.Read(Magic,4);
   if Magic = 'MOIK' then Result := '.xom' else
   if Magic = '‰PNG' then Result := '.png' else
   if Magic = '////' then Result := '.txt' else
   if Magic = 'RIFF' then Result := '.wav' else
    Result := '.bin';
  end;

begin
  if DirPath <> '' then begin
    if not DirectoryExists(DirPath) then CreateDir(DirPath);
    DirPath := IncludeTrailingPathDelimiter(DirPath);
  end;
  Data := TMemoryStream.Create;
  FileStream := TFileStream.Create(Filename, fmOpenRead);
  DataName := DirPath + 'file_';
  try
    Index := 0;
    Offset := 0;
    while FileStream.Position < FileStream.Size do
    begin
      OldOffset := Offset;
      FileStream.Seek(Offset,0);
      FileStream.Read(Offset, SizeOf(Size));
      Size:=Offset-OldOffset-4;
      Data.CopyFrom(FileStream, Size);
      NewFilename := DataName + IntToStr(Index) + GetFileExt(Data);
      Data.SaveToFile(NewFilename);
      Writeln('>> '+NewFilename);
      Data.Clear;
      Inc(Index);
    end;
    Writeln('Files saved');
  finally
    FileStream.Free;
  end;
end;

procedure ReadParamOption(var Option:String; const Name: String);
var
 i: integer;
begin
 for i:=1 to ParamCount do
  begin
     if (ParamStr(i) = Name) and (i<ParamCount) then
        begin Option := ParamStr(i+1); break; end;
  end;
end;

var
 i: integer;
 param, schmfile, Xgame: string;
 schmxml: TNativeXml = nil;
 schmnode : TXmlNode = nil;
begin
  guid := FindCmdLineSwitch('g');
  help := FindCmdLineSwitch('h');
  log := FindCmdLineSwitch('l');
  clear := FindCmdLineSwitch('cl');
  isxid := FindCmdLineSwitch('id');
  hqfloat := FindCmdLineSwitch('xfloat');
  if clear then isxid := false;
  WUM := true;
  W3D := false;
  Filename := '';
  LafDir := '';
  for i:=1 to ParamCount do
  begin
     param := ParamStr(i);
     if (param[1]<>'-') then begin FileName:= param; break; end;
  end;
  OFilename := FileName;
  schmfile := 'XOMSCHM.dat';
  schema := FindCmdLineSwitch('schm');
  if schema then ReadParamOption(schmfile, '-schm');
  xomfile := FindCmdLineSwitch('xom');
  if xomfile then ReadParamOption(FileName, '-xom');
  outfile := FindCmdLineSwitch('out');
  if outfile then ReadParamOption(OFilename, '-out');
  XData.outfile := 'bin';
  XData.isfile := FindCmdLineSwitch('ximg-file');
  if XData.isfile then ReadParamOption(XData.outfile, '-ximg-file')
  else begin
    XData.isfile := FindCmdLineSwitch('aud-file');
    if XData.isfile then ReadParamOption(XData.outfile, '-aud-file');
  end;
  XData.dir := ExtractFilePath(OFilename);
  XData.isdir := FindCmdLineSwitch('ximg-dir');
  if XData.isdir then ReadParamOption(XData.dir, '-ximg-dir')
  else begin
    XData.isdir := FindCmdLineSwitch('aud-dir');
    if XData.isdir then ReadParamOption(XData.dir, '-aud-dir')
  end;
  islaf := FindCmdLineSwitch('laf');
  if islaf then ReadParamOption(lafDir, '-laf');

  if (Filename='') or help then begin
    // show help
    Writeln('Xom2Xml version 1.3');
    Writeln('Copyright 2023 AlexBond');
    Writeln;
    Writeln('Usage:');
    Writeln('   Xom2Xml <filename> [options]');
    Writeln;
    Writeln('Filename:');
    Writeln('   file.xml             For converting xml file to xom');
    Writeln('   file.xom             For converting xom file to xml');
    Writeln;
    Writeln('Options:');
    Writeln('   -h                   Shows help and usage information');
    Writeln('   -id                  Export Xid index to XML to save original order');
    Writeln('   -schm <file>         Sets a custom scheme file.');
    Writeln('                        The default is XOMSCHM.dat scheme file');
    Writeln('   -out <file>          Sets output filename to save');
    Writeln('   -xom <file>          Sets input filename as xom');
    Writeln('   -l                   Logs process of reading');
    Writeln('   -cl                  Export XML in game format');
    Writeln('   -xfloat              Slow writing float values with max precision');
    Writeln('   -ximg-file <format>  Set XImage data in format:');
    Writeln('    -ximg-file bin      BIN with Mipmaps');
    Writeln('    -ximg-file dds      DDS with Mipmaps');
    Writeln('    -ximg-file png      PNG compression');
    Writeln('    -ximg-file tga      TGA format');
    Writeln('   -ximg-dir <dir>      Save XImages files in custom directory.');
    Writeln('                        The default is output folder for XML');
    Writeln('   -aud-file <format>   Set SampleData in format:');
    Writeln('    -aud-file bin       BIN data');
    Writeln('    -aud-file wav       WAV audio');
    Writeln('   -aud-dir <dir>       Save SampleData files in custom directory');
    Writeln('   -laf <dir>           Unpack laf file to xom files in custom directory');

   // Writeln('   -g       Save GUID info from xom as xml');
    Writeln;

  end;

  if islaf then begin
    if (FileExists(FileName) = true) then
        UnpackLaf(FileName, LafDir)
    else begin
      if DirectoryExists(LafDir) then
        PackLaf(LafDir)
      else
        Writeln('Directory not exist');
    end;
    Exit;
  end;

  if (FileExists(FileName) = true) then  begin
   if (FileExists(schmfile) = false) then begin
    Writeln('Scheme file not found');
    Exit;
   end else
   begin
     schmxml:=TNativeXml.CreateName('xomSCHM');
     schmxml.LoadFromFile(schmfile);
     schmnode:= schmxml.Root;
     Xgame := schmnode.AttributeValueByName['Xgame'];
     if Xgame<>'' then begin
       WUM:=false;
       if Xgame='WUM' then WUM:=true
       else if Xgame='W4' then W4:=true
       else if Xgame='W3D' then W3D:=true
       else if Xgame='WF' then WF:=true
       else if Xgame='WB' then WB:=true
       else if Xgame='WR' then WR:=true
       else if Xgame='WBI' then begin PSP:=true; WBI:=true; end
       else if Xgame='W3DGC' then W3DGC:=true
       else if (Xgame='PSP') or (Xgame='WOW') then PSP:=true;
       Writeln('Xgame = ', Xgame);
     end else begin
       Writeln('Xgame not found.');
       schmxml.Free;
     end;
  end;

    if xomfile or (LowerCase(ExtractFileExt(FileName)) = '.xom') then
  begin
    // convert xom to xml
    if guid then
      ExportGuidXML(FileName)
    else
      ExportXML(FileName,schmnode);
  end else
    if LowerCase(ExtractFileExt(FileName)) = '.xml' then
  begin
    // convert xml to xom
    ExportXom(FileName,schmnode);
  end;

  end else if not help then
    Writeln('File not found');

  if schmxml<>nil then schmxml.Free;

end.
