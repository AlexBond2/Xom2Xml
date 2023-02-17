program Xom2Xml;

{$APPTYPE CONSOLE}
{$R 'res\icon.res' 'res\icon.rc'}

uses
  SysUtils,
  Classes,
  XomLibTwk, XomCntrLibTwk,
  NativeXml;
  //,EncdDecd;
  
var
  FileName, OFilename :String;
  guid, help, schema, log, isxid, outfile: boolean;

procedure ExportXML(FileName: String; schmnode : TXmlNode);
var
  XML: TNativeXml;
  LoadedXom:TXom;
  node,xomObjects,xomTypes,XContainer: TXmlNode;
  s: string;
  code: string;
  xomArchive,XNode: TsdElement;
  i: integer;
begin
  LoadedXom:=TXom.Create;
  LoadedXom.LoadXomFileName(FileName, s,false);
  LoadedXom.LogXML:=log;
  LoadedXom.IsXid:=isxid;
  XContainer := schmnode.NodeByName('XContainer');

  XML := TNativeXml.CreateName('xomArchive');
  XML.XmlFormat := xfReadable;
  XML.EolStyle := esLF;
  XML.NodeClosingStyle := ncDefault;

  //XML.ExternalEncoding := seUTF8;

  xomArchive := XML.Root;
 // Types
  xomTypes := XML.NodeNew('xomTypes');

  for i:=0 to LoadedXom.XomHandle.NumTypes-1 do begin
        XNode := TsdElement.CreateParent(XML,xomTypes);
        XNode.Name := LoadedXom.GetXTypeName(LoadedXom.XomHandle.TypesInfo[i].Name,XContainer);
        XNode.NodeClosingStyle := ncClose;
  end;

  xomArchive.NodeAdd(xomTypes);
 // Objects
  xomObjects := XML.NodeNew('xomObjects');

  // convert to XML
  LoadedXom.XMLNumCntr:=0;
  LoadedXom.AddXMLNode(LoadedXom.BaseCntr,XContainer,'id',XML,xomObjects);
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
  XContainer := schmnode.NodeByName('XContainer');
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

var
i: integer;
param, schmfile, Xgame: string;
schmxml: TNativeXml = nil;
schmnode : TXmlNode = nil;
begin
  guid:=FindCmdLineSwitch('g');
  help:=FindCmdLineSwitch('h');
  log:=FindCmdLineSwitch('l');
  isxid:=FindCmdLineSwitch('id');
  schema:=FindCmdLineSwitch('schm');
  outfile:=FindCmdLineSwitch('out');
  WUM:=true;
  W3D:=false;
  schmfile:='XOMSCHM.dat';
  Filename := '';
  for i:=1 to ParamCount do
  begin
     param:= ParamStr(i);
     if (param[1]<>'-') then begin filename:= param; break; end;
  end;
  OFilename:=filename;
  if schema then
 for i:=1 to ParamCount do
  begin
     param:= ParamStr(i);
     if (param='-schm') and (i<ParamCount) then
        begin schmfile:= ParamStr(i+1); break; end;
  end;

  if outfile then
 for i:=1 to ParamCount do
  begin
     param:= ParamStr(i);
     if (param='-out') and (i<ParamCount) then
        begin OFilename:= ParamStr(i+1); break; end;
  end;
  if (Filename='') or help then begin
    // show help
    Writeln('Xom2Xml version 1.0');
    Writeln('Copyright 2021 AlexBond');
    Writeln;
    Writeln('Usage:');
    Writeln('   Xom2Xml <filename> [options]');
    Writeln;
    Writeln('Filename:');
    Writeln('   file.xml      For converting xml file to xom');
    Writeln('   file.xom      For converting xom file to xml');
    Writeln;
    Writeln('Options:');
    Writeln('   -h            Shows help and usage information');
    Writeln('   -id           Export Xid index to XML to save original order');
    Writeln('   -schm <file>  Sets a custom scheme file.');
    Writeln('                 The default is XOMSCHM.dat scheme file');
    Writeln('   -out <file>   Sets output filename to save');
    Writeln('   -l            Logs process of reading');

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

    if LowerCase(ExtractFileExt(FileName)) = '.xom' then
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
