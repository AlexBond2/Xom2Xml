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
  FileName, OFilename :String;
  guid, help, schema, log, isxid, outfile, clear, xomfile: boolean;
  ximg: TXImg;

procedure ExportXML(FileName: String; schmnode : TXmlNode);
var
  XML: TNativeXml;
  LoadedXom:TXom;
  node,xomObjects,xomTypes,XContainer,XType: TXmlNode;
  s: string;
  code: string;
  xomArchive,XNode: TsdElement;
  i,Xver: integer;
begin
  LoadedXom:=TXom.Create;
  LoadedXom.LoadXomFileName(FileName, s,false);
  LoadedXom.LogXML:=log;
  LoadedXom.IsXid:=isxid;
  LoadedXom.XImg:=XImg;
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
  try
  for i:=0 to LoadedXom.XomHandle.NumTypes-1 do begin
        XNode := TsdElement.CreateParent(XML,xomTypes);
        XNode.Name := LoadedXom.GetXTypeName(LoadedXom.XomHandle.TypesInfo[i].Name,schmnode);
        XType:=schmnode.FindNode(XNode.Name);
        XVer:=StrToInt(XType.AttributeValueByName['Xver']);
        if LoadedXom.XomHandle.TypesInfo[i].btype<>XVer then
        XNode.AttributeAdd(XML.AttrText('Xver', IntToStr(LoadedXom.XomHandle.TypesInfo[i].btype)));
        XNode.NodeClosingStyle := ncClose;
  end;
  Except
      on E : Exception do   begin
       WriteLn(Format('Error: Try read %s type [%d]',[XNode.Name, i]));
       Halt;
    end;
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
  if outfile then
    s := OFileName
  else
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
  s: string;
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
  if outfile then
    s := OFileName
  else
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
  NewXom.LoadXomFileName(FileName, s,false);
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
  schema := FindCmdLineSwitch('schm');
  outfile := FindCmdLineSwitch('out');
  xomfile := FindCmdLineSwitch('xom');
  ximg.base64 := FindCmdLineSwitch('ximg-base64');
  ximg.isfile := FindCmdLineSwitch('ximg-file');
  ximg.outfile := 'png';
  ximg.isdir := FindCmdLineSwitch('ximg-dir');
  if clear then isxid := false;
  WUM := true;
  W3D := false;
  schmfile := 'XOMSCHM.dat';
  Filename := '';
  for i:=1 to ParamCount do
  begin
     param := ParamStr(i);
     if (param[1]<>'-') then begin FileName:= param; break; end;
  end;
  OFilename := FileName;
  if schema then ReadParamOption(schmfile, '-schm');
  if xomfile then ReadParamOption(FileName, '-xom');
  if outfile then ReadParamOption(OFilename, '-out');
  if ximg.isfile then ReadParamOption(ximg.outfile, '-ximg-file');
  ximg.dir := ExtractFilePath(OFilename);
  if ximg.isdir then ReadParamOption(ximg.dir, '-ximg-dir');

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
    Writeln('   -ximg-base64         Save XImage data as Base64 encoding.');
    Writeln('                        Otherwise save XImage data as file.');
    Writeln('   -ximg-file <format>  Set XImage data in format:');
    Writeln('    -ximg-file bin      BIN with Mipmaps');
    Writeln('    -ximg-file dds      DDS with Mipmaps');
    Writeln('    -ximg-file png      PNG compression');
    Writeln('    -ximg-file tga      TGA format');
    Writeln('   -ximg-dir <dir>      Save XImages files in custom directory.');
    Writeln('                        The default is output folder for XML');

   // Writeln('   -g       Save GUID info from xom as xml');
    Writeln;

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
       else if Xgame='W3DGC' then W3DGC:=true;
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
