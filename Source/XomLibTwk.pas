unit XomLibTwk;

interface

uses IdGlobal, SysUtils, Classes,
  Math, XomCntrLibTwk, NativeXml, TntClasses, GR32, Base64;

type TXomType = packed record
        aType:array [0..3] of Char;
        bType:integer;
        Size:integer;
        nZero:integer;
        GUID:TGUID;
        Name:array [0..31] of Char;
        end;

type TXomHandle = packed record
        Head:array[0..3]of char;
        nType:Longword;
        nZero:array [0..3] of Integer;
        NumTypes:integer;
        MaxCount:integer;
        RootCount:integer;
        nZero2:array [0..6] of Integer;
        //------
        TypesInfo: array of TXomType;
        Guid:array[0..3]of char;
        GuidZero:array [0..2] of Integer;
        SCHM:array[0..3]of char;
        SCHMType:integer;
        SCHMZero:array [0..1] of Integer;
        Strs:array[0..3]of char;
        SizeStrs:Integer;
        LenStrs:Integer;
        StringTable:TTntStringList;
        end;

  TIndex = record
    ID: Integer;
    Values: array [0..12] of Integer;
  end;

  TXImg = record
    isfile: boolean;
    outfile: string;
    isdir: boolean;
    dir: string;
    end;

  TStEdByte = record
    //sbyte,ebyte:smallint;
    id: Integer;
  end;

  TsdText = class(TsdCharData)
  end;

type
  TXom = class
    constructor Create;
    destructor Destroy; override;
  public
    saidx: Integer;
    BaseCntr: TContainer;
    Buf: Pointer;
    XomHandle:TXomHandle;
    CntrArr:TContainers;
    AsW3D:boolean;
    Loading:boolean;
    LogXML:boolean;
    IsXid:boolean;
    hqFloat:boolean;
    XMLNumCntr: Integer;
    XImg:TXImg;
    function GetXType(XName:PChar;var XType:XTypes):Boolean;
    procedure LoadXomFileName(FileName: string; var OutCaption: string; ShowProgress:boolean=true);


    procedure SaveXom(FileName: String);
  //  function BuildTree( XCntr: TContainer; Tree: TTreeView; Node: TTreeNode): XTypes;
    function ReadXContainer(p:pointer;NType:XTypes; var Name:String; var IsCtnr:Boolean; Schema: Integer):Pointer;
    procedure AddXTypeXML( XContainer,xomObjects:TXmlNode);
    procedure LoadXTypeXML( XContainer,xomTypes:TXmlNode);
    function GetXTypeNode(Name:String;XContainer:TXmlNode):TXmlNode; overload;
    function GetXTypeNode(nType:Integer;XContainer:TXmlNode):TXmlNode; overload;
    procedure WriteXMLContaiter(index:integer;XCntr:TContainer;XContainer: TXmlNode);
    function AddXMLNode(XCntr:TContainer; XContainer:TXmlNode; XName:String; XML:TNativeXml; xomObjects:TXmlNode):String;
    function XBitmapAddBlocks(Point:Pointer; Size: Integer):String;
    function XImageEncode(XImageNode: TXmlNode; Point:Pointer; Size: Integer):String;
    procedure XImageDecode(XImageNode: TXmlNode; XValue: String; Buf:TStream);
    procedure LoadFromXML(xomTypes, xomObjects, XContainer:TXmlNode);
    procedure InitXomHandle;
    procedure SaveXomHandle(var p:pointer);
    procedure SaveStringTable(var p:Pointer;LStrings:TTntStringList);
    procedure WriteXString(var Memory:TMemoryStream; XString:Utf8String);
    function GetStr128(var p:Pointer): WideString;
    function GetIdx128(var p:Pointer):Integer;
    function GetSize128(var p:Pointer):Integer;
    function CopyType(XType:XTypes):TXomType;
    procedure SetSizeType(XType:XTypes;Size:integer);
    procedure SetType(Index:Integer;NewGUID:TGUID;XType:XTypes);
    procedure ClearSizeType;
    procedure TestClearType(XType:XTypes);
    function SearchType(XType:XTypes; var index:Integer):Boolean;
    function SearchTypeByName(Name:String; var index:Integer):Boolean;
  end;

  TStringArray = array of string;

  TKeyValue = record
    Key: string;
    Value: Integer;
  end;

  TKeyValues = array of TKeyValue;

  TKeyValueList = class
    constructor Create;
    destructor Destroy; override;
  private
    FKeys: TKeyValues;
    function GetValue(const Name: string): Integer;
    procedure SetValue(const Name: string; Value: Integer);
  public
    property Values[const Name: string]: Integer read GetValue write SetValue;
  end;

function StringListFromStrings(const Strings: array of string;Size:integer): TStringList;

function ToTime(milisec: Longword): Single;


const
 APPVER = 'XomLibTwk';

  MaxMaps    = 10000;
  MaxType    = 1000;
  MODEL3DBUF = 10000;

  FontGL  = 2000;
  MaxDeph = 100000.0;  // максимальная глубина


  ATypePosition = $0102;
  ATypeRotation = $0103;
  ATypeScale    = $0104;
  AType2DTex    = $0401;
  ATypeReScale  = $0904;
  ATypeTexture  = $1100;
  ATypeChilds   = $0100;
  ATypeX        = 0;
  ATypeY        = 1;
  ATypeZ        = 2;

  TORAD   = Pi / 180;
  RADIANS = 180 / Pi;

  ZereVector: Tver = (0, 0, 0);
  TestVert: Tver   = (0.0, 0, 0);

  nVn  = #13#10;

var
  Xom: TXom;
 // GrafKeys:array of TGrafKey;
  EdMode,AnimEd:Boolean;
 // SelectKey,SKey: PKeyFrame;
//  SelectKdata:PKeyData;
  SelectType:Integer;
  SelectObjName:String;
  ShowGraph:Boolean;
//  AnimClip: TAnimClip;
 // MAxis,AAxis:TAxis;
  //  PSelect, PTarget: TPoint;
 //   wd,wdup:TXYZ;
  SelectObj, SelectObjOn: Integer;
  Bbitpoint, bBitPoint2: Pointer;
  StarPoint,BuildPoint,LightPoint,PyramidPoint: Pointer;


 // AnimTimer: THRTimer;
//  AnimClips:TAnimClips;
 // CurAnimClip:TAnimClip;
 // BaseClip:TAnimClip;

//  MaxAnimTime: Single;

  Active3DModel: Integer = MODEL3DBUF;
 // TransView,TVModel: TTransView;
  GLwidth, GLheight: Integer;
  position2: color4d = (0.0, 0.0, 0.0, 1.0);
  MainBox: TBox;
  NTexture: Integer = 0;
  LastTexture: Integer = 0;
  XomImport, XomReplace,ImageReady, Xom3DReady, AnimReady: Boolean;
  SelectMode,
  MoveMode, MoveReady,
  RotateMode, RotateReady,
  ScaleMode, ScaleReady,
  Particle_mode,
  ZoomActivePox, TextureB, FillMode, MoveFirts,
  ScaleFirts,RotateFirts,
  CtrlMove, Ctrl,ShiftOn, FullSize, ChillMode: Boolean;
  ChillMax:Integer;
  AddClick,DeleteClick:TNotifyEvent;
  AddMesh,DeleteMesh:TNotifyEvent;
//  StrArray: XConteiners;
//      CntrArr:XContainers;
 // ActiveMesh:TMesh;
  ObjMatrix:TMatrix;

  TEXTUREBASE:Integer = 0;
var
  ActiveMatrix, TempMatrix: TMatrix;
  NKey:Tver;
  MovePoxPos,  ScalePoxPos,RotatePoxPos:Tver;
 // p:TXYZ;
  theta,alpha,beta,gamma:single;
  
implementation


constructor TXom.Create;
begin
  inherited Create;
  CntrArr := TContainers.Create(true);
end;


procedure TXom.WriteXString(var Memory:TMemoryStream; XString:Utf8String);
var
    Index,i:integer;
    XName: WideString;
begin
    Index:=-1;
    XName:= UTF8Decode(XString);
    for i:=0 to XomHandle.StringTable.Count-1 do
      if XomHandle.StringTable[i]=XName then
                begin Index:=i; break; end;

    if Index=-1 then begin
        Index:=XomHandle.StringTable.Add(XName);
    end;
    WriteXByte(Memory,Index);
end;



function TXom.GetSize128(var p:Pointer):Integer;
var
indx: Integer;
begin
indx:= TestByte128(p);
result:= indx;
end;

function TXom.GetIdx128(var p:Pointer):Integer;
begin
result:= TestByte128(p);
end;

function TXom.GetStr128(var p:Pointer): WideString;
var
indx: Integer;

begin
indx := TestByte128(p);
 with XomHandle do
 if (indx < StringTable.Count) and (indx <> 0) then
      Result := StringTable[indx]
  else
      Result := '';

end;


procedure TXom.LoadXomFileName(FileName: string; var OutCaption: string;ShowProgress:boolean=true);
var
  s: string;
  ws: WideString;
  sizecount, sizeoffset, i, j, MaxInx, LenSTR : Integer;
  P, p2: Pointer;
  Xi: XTypes;
  IDtest, Outpoint, IsCtnr : Boolean;
  iFileHandle: Integer;
  iFileLength: Integer;
  L ,k:longword;
  NTypes: array of XTypes;
begin

// новый код

      // открываем файл и загружаем в память.
      iFileHandle := FileOpen(FileName, fmOpenRead);
      iFileLength := FileSeek(iFileHandle,0,2);
      FileSeek(iFileHandle,0,0);

  FreeMem(Buf);

      Buf := AllocMem(iFileLength + 1);
      FileRead(iFileHandle, Buf^, iFileLength);
      FileClose(iFileHandle);

// очищаем список

  s := ExtractFileName(FileName);
  OutCaption := Format('%s - [%s]', [APPVER,s]);


//--------
      InitXomHandle;
// Считываем данные
      Move(Buf^,XomHandle,64);
// Считываем количество контерйнеров
//      XomHandle.NumTypes:=word(pointer(Longword(Buf)+24)^);
// Инициализация данных
  saidx:=0;

  // очистка контейнеров
  CntrArr.Clear;
// количество контейнеров
//      XomHandle.MaxCount:=integer(pointer(Longword(Buf)+28)^);
 //     XomHandle.RootCount:=integer(pointer(Longword(Buf)+32)^);
// Считываем индексный контейнер
      CntrArr.Count:=XomHandle.MaxCount+1;

      SetLength(XomHandle.TypesInfo,XomHandle.NumTypes);
      SetLength(NTypes, XomHandle.NumTypes);

try
// Цикл покойтейнерного считывания Названий контейнеров
      for i := 0 to XomHandle.NumTypes-1 do begin
        p:=pointer(64+i*Sizeof(TXomType)+Longword(Buf));
        Move(p^,XomHandle.TypesInfo[i],Sizeof(TXomType));
      {  XomHandle.TypesInfo[i].aType:='TYPE';
        XomHandle.TypesInfo[i].bType:=Longword(pointer(Longword(p)+4)^);
        XomHandle.TypesInfo[i].Size:=Longword(pointer(Longword(p)+8)^);
        Move(pointer(Longword(p)+16)^,XomHandle.TypesInfo[i].GUID,16);
        Move(pointer(Longword(p)+32)^,XomHandle.TypesInfo[i].Name,32); }
        if GetXType(XomHandle.TypesInfo[i].Name,Xi) then
                NTypes[i]:=Xi;

      end;

      p:=pointer(Longword(Buf)+64+XomHandle.NumTypes*Sizeof(TXomType)+16);
//Считывание с проверкой начала таблицы
      if Longword(p^)<>Ctnr2 then
      p:=pointer(16+4+Longword(p))else
      p:=pointer(4+Longword(p));

 //   STOffset:=p;

      XomHandle.SizeStrs:=Longword(p^);
      inc(Longword(p),4);

      XomHandle.LenStrs:=Longword(p^);
      inc(Longword(p),4);


      //<table str>
      k:=Longword(p)+XomHandle.SizeStrs*4;
      XomHandle.StringTable.Add('');
      // заполнение таблицы имен
      for i:=0 to XomHandle.SizeStrs-2 do begin
        L:=longword(pointer(i*4+Longword(p)+4)^);
        ws:=Utf8Decode(Pchar(pointer(k+L)));
       // s:=Pchar(pointer(k+L));
        XomHandle.StringTable.Add(ws); //
      end;
      k:=XomHandle.LenStrs+XomHandle.SizeStrs*4;
      inc(Longword(p),k);
 // if ShowProgress then
 // But.Status.Text := Format('Strings: (%d) - (%d)', [MaxInx, LenSTR]);
      //Tree adding

  CntrArr[0]:=TContainer.Create(0,CntrArr,p);
  Outpoint := false; // вылет из памяти

  for j := 0 to XomHandle.NumTypes - 1 do
  with XomHandle.TypesInfo[j] do
  begin

    if Size > 0 then
      for i := 1 to Size do
        if not Outpoint then
        begin
          IsCtnr := true;

          if (Longword(p^) = Ctnr) then
            sizeoffset := 4
          else
            sizeoffset := 0;

          sizecount := sizeoffset;

          p2:=ReadXContainer(p,NTypes[j],s,IsCtnr,XomHandle.TypesInfo[j].btype);

          if not IsCtnr then
            sizecount := Longword(p2) - Longword(p);

          Inc(saidx);


          CntrArr[saidx] := TContainer.Create(saidx, CntrArr,
                                        Pointer(Longword(p) + sizeoffset));
          CntrArr[saidx].XType := NTypes[j];
          CntrArr[saidx].CTNR := (Longword(p^) = Ctnr);
          CntrArr[saidx].Name := s;

          if saidx = XomHandle.RootCount then
                BaseCntr := CntrArr[saidx];

          if (IsCtnr) then  // ищем конец контейнера

            while (Longword(Pointer(Longword(p) + sizecount)^) <> Ctnr) do
            begin
              if ((Longword(p) + sizecount - Longword(Buf)) > iFileLength) then
              begin
                Outpoint := true;
                CntrArr[saidx].size := sizecount - sizeoffset - 1;
                Exit;
              end;
              Inc(sizecount);
            end;

          CntrArr[saidx].size := sizecount - sizeoffset;


          p := Pointer(Longword(p) + sizecount);
        end;
  end;
Except
      on E : Exception do
      Writeln(Format('Error "%s" in LoadXomFileName() on [%d] ', [E.ClassName,saidx]));
  end;
end;


{ TXom }

procedure TXom.InitXomHandle;
begin
XomHandle.Head:='MOIK';
XomHandle.nType:=$2000000;
XomHandle.Guid:='GUID';
XomHandle.SCHM:='SCHM';
XomHandle.SCHMType:=1;
XomHandle.Strs:='STRS';
SetLength(XomHandle.TypesInfo,0);
XomHandle.StringTable:=TTntStringList.Create;
end;

function TXom.SearchType(XType: XTypes;var index:Integer): Boolean;
var i:integer;
begin
Result:=false;
for i:=0 to Length(XomHandle.TypesInfo)-1 do
 if  StrLComp(XomHandle.TypesInfo[i].Name,PCharXTypes[XType],31)=0 then begin
   Index:=i;
   Result:= true;
   Break;
  end;
end;

function TXom.CopyType(XType:XTypes):TXomType;
var i:integer;
begin
if SearchType(XType,i) then begin
   Result:= XomHandle.TypesInfo[i];
   // Move(XomHandle.TypesInfo[i],Result,Sizeof(TXomType));
   Result.Size:=0;
   end;
end;

procedure TXom.SetSizeType(XType:XTypes;Size:integer);
var i:integer;
begin
if SearchType(XType,i) then
   XomHandle.TypesInfo[i].Size:=Size;
end;

procedure TXom.TestClearType(XType: XTypes);
var i,len:integer;
begin
Len:=Length(XomHandle.TypesInfo)-1;
if SearchType(XType,i) then begin
   if i <> Len then
        Move(XomHandle.TypesInfo[i+1],XomHandle.TypesInfo[i],Sizeof(TXomType)*(Len-i));
   SetLength(XomHandle.TypesInfo,Len);
   end;
end;

function CSComareCntrs(Cntr1, Cntr2: TContainer): Integer;
begin
  if Cntr1.Index = Cntr2.Index then
    Result := 0
  else if Cntr1.Index > Cntr2.Index then
    Result := 1
  else
    Result := -1;
end;

function StringListCS(List: TTntStringList; Index1, Index2: Integer): Integer;
var
  s1, s2: WideString;
begin
  //inc(sortcount);
  s1 := List.Strings[Index1];
  s2 := List.Strings[Index2];
  if s1 = s2 then
    Result := 0
  else if s1 > s2 then
    Result := 1
  else
    Result := -1;
end;

procedure TXom.SaveXomHandle(var p:pointer);
begin
Move(XomHandle.Head,p^,16*4);
inc(integer(p),16*4);
Move(XomHandle.TypesInfo[0],p^,16*4*XomHandle.NumTypes);
inc(integer(p),16*4*XomHandle.NumTypes);
if XomHandle.nType > $1000000 then begin
  Move(XomHandle.Guid,p^,16);
  inc(integer(p),16);
end;
Move(XomHandle.SCHM,p^,16*2 - 4);
inc(integer(p),16*2);
end;

procedure TXom.SaveStringTable(var p:Pointer;LStrings:TTntStringList);
var
  p1,p3,p4:pointer;
  i,j,len: Integer;
  ws: WideString;
  s2:Utf8String;
  SortStrings:TTntStringList;
begin
  j := LStrings.Count-1; // нулевой индекс занят
//  p2 := VBuf;
  p4 := Pointer(Longword(p) + j * 4);  // размер таблицы индексов текста
  Len := 1;
  SortStrings:=TTntStringList.Create;
  LStrings.CaseSensitive:=true;
  SortStrings.Assign(LStrings);
  SortStrings.Delete(0);
  SortStrings.CustomSort(StringListCS);
 // SortStrings.CaseSensitive := True;
 // SortStrings.Sort;
  //Str Table
  for i := 0 to j - 1 do
  begin
    ws  := SortStrings.Strings[i];
    Longword(Pointer((LStrings.IndexOf(ws)-1) * 4 + Longword(p))^) := Longword(Len);
 //   Smallint(Pointer(i * 4 + Longword(p))^) := Smallint(Len);  // заполняем длинны в индексы
    p3 := Pointer(Longword(p4) + Len);
    s2:= Utf8Encode(ws);
   // s2:=s;
    p1  := PChar(s2);
    Move(p1^, p3^, Length(s2));// копируем текст в пямять
    Len := Len + Length(s2) + 1;
  end;
  SortStrings.Free;
  Longword(Pointer(Longword(p) - 12)^) := Longword(j + 1); // пишем количество слов
  Longword(Pointer(Longword(p) - 8)^) := Longword(Len);  // длинна слов
  p := Pointer(Longword(p4) + Len); // прыгаем после таблицы слов
end;

procedure TXom.SaveXom(Filename: String);
var
  VirtualBufer: TMemoryStream;
  p2: Pointer;

  i,j,n: Integer;
  VBufBegin,VBuf: Pointer;
  LStrings:TStringList;
begin
 // OldXom := Buf;
  if Filename <> '' then
  begin
    VirtualBufer := TMemoryStream.Create;
    n := CntrArr.Count;//Length(Containers);

  VBufBegin := AllocMem(1024*1024); // берем память для строк и шапок
  VBuf := VBufBegin;
  p2:=VBuf;

  SaveXomHandle(p2);
  SaveStringTable(p2,XomHandle.StringTable);

    VBuf:=p2;
    VirtualBufer.Write(VBufBegin^, Longword(VBuf)-Longword(VBufBegin));
    FreeMem(VBufBegin);

    for i := 1 to n - 1 do
      CntrArr[i].WriteCNTR(VirtualBufer);

    if ExtractFileExt(FileName)='' then FileName:=FileName+'.xom';
    VirtualBufer.SaveToFile(FileName);
    VirtualBufer.Free;
  end;
end;

function ToTime(milisec: Longword): Single;
begin
  Result := (milisec div 60000) + ((milisec mod 60000) div 1000) / 100;
end;

Function TXom.ReadXContainer(p:pointer;NType:XTypes;var Name:String; var IsCtnr:Boolean; Schema: Integer):pointer;
label
_XSimpleShader;
var
p2:Pointer;
k,s,x,x1,x2,k3,k2,inx, inx1,inx2:integer;
px:Longword;
ExpAnim: Boolean;
begin

          if (Longword(p^) = Ctnr) then
            p2 := Pointer(Longword(p) + 7)
          else
            p2 := Pointer(Longword(p) + 3);
          k := TestByte128(p2);
          Name := 'id';
          case NType of
            XGraphSet:
            begin
              p2 := p;
              k := TestByte128(p2);
              for x := 1 to k do
              begin
                Inc(Longword(p2), 16);
                k3 := TestByte128(p2);
                k3 := TestByte128(p2);
              end;
              IsCtnr := false;
            end;
            XOglTextureMap:
            begin
              p2 := Pointer(Longword(p) + 7);
              Inc(Longword(p2), 4);
              Inc(Longword(p2), 4 * 4);
              k3 := TestByte128(p2);
              Inc(Longword(p2), 4);
              k2 := Word(p2^);
              Inc(Longword(p2), 2);
              Inc(Longword(p2), 4 * 5);
              k := TestByte128(p2);
              //  dec(Longword(p2),4);
              // funit, float4,index,float,unit,funit5
              if k2 <> 1 then
                Inc(Longword(p2), 68);
              if not WR then
              IsCtnr := false;
            end;
            XBinormal3fSet:
            begin
               p2 := Pointer(Longword(p) + 7);
               k2 := TestByte128(p2);
               Inc(Longword(p2), k2*12);
               IsCtnr := false;
            end;
            XDetailSwitch:
            begin
               p2 := Pointer(Longword(p) + 7);
               Inc(Longword(p2), 4*3);
               k2 := TestByte128(p2);
               Inc(Longword(p2), k2*4);
               Inc(Longword(p2), 4*2);
               IsCtnr := false;
            end;
            XBitmapDescriptor:
            begin
              p2 := p;
              s := TestByte128(p2);
              if WUM then  Inc(Longword(p2));
              Inc(Longword(p2));
              k2 := TestByte128(p2);
              Inc(Longword(p2), 4);
             // if WUM then  Inc(Longword(p2));
             if WR then  Inc(Longword(p2),13); //?
              IsCtnr := false;
            end;
            XXomInfoNode:
            begin
              for x := 1 to k do
                TestByte128(p2);
            end;
            WXTemplateSet:
            begin
              for x := 1 to k do  //Templates
                TestByte128(p2);
              p2 := Pointer(Longword(p2) + 4 * 5);  // Bounds BoundMode
              Name := GetStr128(p2);    // Name
            IsCtnr := false;  
            end;
            WXTemplate:
            begin
              for x:=1 to k do   // Connectors
                 TestByte128(p2);
              k:=TestByte128(p2); // Bounds
              for x:=1 to k do
                 TestByte128(p2);
              k := TestByte128(p2);   // Outline
              Inc(Longword(p2), 4*3*3); // PreviewPos  PreviewOrientation PreviewScale
              k := TestByte128(p2);  // PreviewName
              Inc(Longword(p2), 1 + 4); // RandomRoot LandCost
              Inc(Longword(p2), 2*2);// Complexity EmitterCost
              Inc(Longword(p2), 4); // LumpType
              Inc(Longword(p2), 4); //  YPlacement
              IsCtnr := false;
            end;
            W3DTemplateSet:
            begin
              for x := 1 to k do
                TestByte128(p2);
              Inc(Longword(p2), 12);
              Inc(Longword(p2), 8);
              s := TestByte128(p2);
              IsCtnr := false;
            end;
            XCustomDescriptor:
            begin
              p2 := p;
              s := TestByte128(p2);
              if WUM then  Inc(Longword(p2));
              Inc(Longword(p2), 3);
              if WR then  Inc(Longword(p2),13); //?
              IsCtnr := false;
            end;
            XMeshDescriptor:
            begin
              p2 := p;
              s := TestByte128(p2);
              if WUM then Inc(Longword(p2));
              k3 := byte(p2^);//14
              Inc(Longword(p2));
              x := TestByte128(p2);
              Inc(Longword(p2), 2);// 80 00
              if WR then  begin
              Inc(Longword(p2),6);
               TestByte128(p2);
               TestByte128(p2);
              end;
              IsCtnr := false;
            end;
            XEnvironmentMapShader:
            begin
              p2 := Pointer(Longword(p) + 7);
              k2 := TestByte128(p2);
              k3 := TestByte128(p2);
              Inc(Longword(p2), 1);
              x := TestByte128(p2);
              x := TestByte128(p2);
              Inc(Longword(p2), 7);
              s := TestByte128(p2);
            end;
            XMultiTexShader:
            begin
              p2 := Pointer(Longword(p) + 7);
                k:=TestByte128(p2);
                for x:=1 to k do
                        k3:=TestByte128(p2);
                k:=TestByte128(p2);
                k:=TestByte128(p2);
             //   k:=TestByte128(p2);
                inc(Longword(p2),4);
                s:=TestByte128(p2);
            end;
            XTextDescriptor:
            begin
              p2 := p;
              s := TestByte128(p2);
              if WUM then  Inc(Longword(p2));
              k := TestByte128(p2); //1  number
              k := TestByte128(p2); //2  link
              if WR then begin
              Inc(Longword(p2), 2);
              end;
              k := Word(p2^);       // size
              if WR then begin
              Inc(Longword(p2), 23);
              end else
              Inc(Longword(p2), 4); // 1
              for x := 1 to k do
                Inc(Longword(p2), 6); // num, wchar, wchar
              //     k3:=TestByte128(p2);
              IsCtnr := false;
            end;
            XDirectMusicDescriptor:
             begin
              p2 := p;
              s := TestByte128(p2);
              s := TestByte128(p2);
              Inc(Longword(p2),4);
              IsCtnr := false;
            end;
            XNullDescriptor:
            begin
              p2 := p;
              s := TestByte128(p2);
              if WUM then  Inc(Longword(p2));
              k := TestByte128(p2);
              IsCtnr := false;
            end;
            XSpriteSet:
            begin
             p2 := Pointer(Longword(p) + 4);
             if WR then
             begin
             Inc(Longword(p2));
             Inc(Longword(p2),36);
             IsCtnr := false;
             end;
            end;
            XSpriteSetDescriptor:
            begin
              p2 := p;
              s := TestByte128(p2);
              if WUM then  Inc(Longword(p2));
              Inc(Longword(p2), 1);// 0
              k3 := TestByte128(p2);
              if WR then TestByte128(p2);
              if WR then Inc(Longword(p2),13);
              IsCtnr := false;
            end;
            XCollisionData:
            begin
              p2 := Pointer(Longword(p) + 9);
              k := TestByte128(p2); 
              k3 := 0;
              if k <> 0 then 
                k3 := TestByte128(p2);
            end;
            XImage:
            begin
              //s := GetString(k);
              //                k2:=TestByte128(p2);
            end;
            XInteriorNode:
            begin
              for x := 1 to k do
                k3 := TestByte128(p2);
              px := Longword(p2); //4*4+4*3*2+4
              p2 := Pointer(Longword(p2) + 4 * 5);
              if WR then Inc(Longword(p2),4*3*2);
              s := TestByte128(p2);
              IsCtnr := false;
            end;
            XGroup, XSkin:
            begin
              k := TestByte128(p2);
              for x := 1 to k do
                k3 := TestByte128(p2);
              px := Longword(p2);
              p2 := Pointer(Longword(p2) + 4 * 5);
              Name := GetStr128(p2);
            end;
            XChildSelector:
            begin
            end;
            XBinModifier:
            begin
              k := TestByte128(p2);
              //               for x:=1 to k do
              k3 := TestByte128(p2);
              k := TestByte128(p2);
              for x := 1 to k do
                k3 := TestByte128(p2);
              px := Longword(p2);
              p2 := Pointer(Longword(p2) + 4 * 5);
              s := TestByte128(p2);
            end;
            XBone:
            begin
              p2 := Pointer(Longword(p) + 7);
              Inc(Longword(p2), 4*4*4);
              Inc(Longword(p2), 4*4*4);
              TestByte128(p2);
              k := TestByte128(p2);
              for x := 1 to k do
                k3 := TestByte128(p2);
              Inc(Longword(p2), 4*4+4);
              s := TestByte128(p2);
            end;
            XAnimChannel:
            begin
              p2 := Pointer(Longword(p) + 7);
              Inc(Longword(p2), 4+4*2);
               k := TestByte128(p2);
              //MustContribute XBool
              // IsWeighted XBool
              // IsStatic   XBool
              // IsLinear  XBool
              // PreInfinity XEnumByte
              // PostInfinity  XEnumByte
              // KeyArray XSet

               Inc(Longword(p2), k*4);
                IsCtnr := false;
            end;
            XAnimClipLibrary:
            begin
              p2 := p;
              s := TestByte128(p2);  // Name
              inx1 := Integer(p2^); // NumKeys
              //    if inx>16000 then break;
              Inc(Longword(p2), 4);
              for x := 1 to inx1 do
              begin   // Keys
                Inc(Longword(p2), 4);   //AnimType
                s := TestByte128(p2); //Object
              end;
              inx2 := Integer(p2^);  // NumClips
              Inc(Longword(p2), 4);
              for x := 1 to inx2 do 
              begin
                Inc(Longword(p2), 4); // time
                s := TestByte128(p2); // name
                inx := Word(p2^);     // NumAnimKeys
                ExpAnim := not WR and ((inx = 256) or (inx=257));
                // 00 01   - zero Frame
                // 01 01   - frame no Index
                // 24 00   - index frame
                //  ExpAnim:= inx <> integer($0101);
                if ExpAnim then
                  inx := inx1
                else
                  Inc(Longword(p2), 4);
                for x1 := 1 to inx do
                begin // AnimKeys
                  x2 := Word(p2^);
                  if x2 = 256 then
                  begin
                    Inc(Longword(p2), 16);
                    Continue;
                  end;
                  Inc(Longword(p2), 4); // 1 1 0 0
                  if not ExpAnim then
                  begin
                    k2 := Word(p2^); 
                    Inc(Longword(p2), 2);
                  end;
                  k3 := Word(p2^);
                  Inc(Longword(p2), 2);
                  Inc(Longword(p2), 6);
                  k := Integer(p2^); 
                  Inc(Longword(p2), 4);
                  for x2 := 1 to k do
                    Inc(Longword(p2), 6 * 4);
                end;
              end;
              IsCtnr := false;
            end;
            XSkinShape:
            begin
              for x := 1 to k do
                k3 := TestByte128(p2);
              Inc(Longword(p2), 4);
              k3 := TestByte128(p2);
              k3 := TestByte128(p2);
              Inc(Longword(p2), 5);
              px := Longword(p2);
              p2 := Pointer(Longword(p2) + 4 * 5);
              s := TestByte128(p2);
            end;
            XShape:
            begin
              Inc(Longword(p2), 3); //Flags
              k3 := TestByte128(p2); // Shader
              k3 := TestByte128(p2);  // Geometry
              if WUM or W4 then begin
                Inc(Longword(p2), 4); // SortKey
                if Schema = 3 then k3 := TestByte128(p2) else  // Parameters
                if Schema = 4 then begin
                  k3 := TestByte128(p2);  // PreRenderFunc
                  k3 := TestByte128(p2);  // PostRenderFunc
                end;
              end;
              //px := Longword(p2);
              p2 := Pointer(Longword(p2) + 4 * 5);  // Bounds BoundMode
              Name := GetStr128(p2);    // Name
            end;
            XBuildingShape:
            begin
            //  Inc(Longword(p2), 3);
              k3 := TestByte128(p2);
              k3 := TestByte128(p2);
              Inc(Longword(p2), 9);
              k3 := TestByte128(p2);
              Inc(Longword(p2), 6);
              px := Longword(p2);
              p2 := Pointer(Longword(p2) + 4 * 5);
              s := TestByte128(p2);
            end;
            XTransform:
            begin
              px := Longword(p) + 7;
            end;
            XJointTransform:
            begin
              px := Longword(p) + 7;
            end;
            XMatrix:
            begin
              px := Longword(p) + 7 + 36;
              p2:= Pointer(Longword(p) + 3+7*8);
              if WR then IsCtnr:=false;
            end;
            XTexturePlacement2D:
            begin
              //px:=Longword(p)+7;
            end;
            XCustomShader:
            begin
              p2 := Pointer(Longword(p) + 7 );
              k := TestByte128(p2);
              for x := 1 to k do
                k3 := TestByte128(p2);
              Inc(Longword(p2), 4*2);
              k := TestByte128(p2);
              for x := 1 to k do
                k3 := TestByte128(p2);
              k := TestByte128(p2);
              for x := 1 to k do
                k3 := TestByte128(p2);
              k := TestByte128(p2);
              for x := 1 to k do
                k3 := TestByte128(p2);
              k := TestByte128(p2);
              for x := 1 to k do
                k3 := TestByte128(p2);
              k := TestByte128(p2);
              Inc(Longword(p2), k*4);
              k := TestByte128(p2);
              Inc(Longword(p2), k*4);
              Inc(Longword(p2), 4);
              s := TestByte128(p2);
            //  IsCtnr := false;
            end;
            XTexFont:
            begin
              for x := 1 to k do
                Inc(Longword(p2), 8);
              k := TestByte128(p2);
              for x := 1 to k do
                Inc(Longword(p2), 8);
              k := TestByte128(p2);
              goto _XSimpleShader;
            end;
            XSimpleShader:
            begin _XSimpleShader:
              for x := 1 to k do    // TextureStages
                k3 := TestByte128(p2);
              k := TestByte128(p2);  
              for x := 1 to k do    // Attributes
                k3 := TestByte128(p2);
              // XShader
              Inc(Longword(p2), 4); // Flags
              Name := GetStr128(p2); // Name
              if WUM then begin
                if SearchTypeByName('XShader',inx) then
                  Schema := Self.XomHandle.TypesInfo[inx].bType;
               if (Schema = 2) then  Inc(Longword(p2)); // FragmentShader  Schema	2
              end;
              IsCtnr := false;
            end;
            XContainerResourceDetails:
            begin
              Name := GetStr128(p2);
          //    k3 := TestByte128(p2);
              //       sTemp:= sTemp+s+nVn;
            end;
            XFloatResourceDetails: 
            begin
              p2 := Pointer(Longword(p) + 7 + 4);
              Name := GetStr128(p2);
              //         sTemp:= sTemp+s+nVn;
            end;
            XIntResourceDetails, XUintResourceDetails: 
            begin
              p2 := Pointer(Longword(p) + 7 + 4);
              Name := GetStr128(p2);
              //        sTemp:= sTemp+s+nVn;
            end;
            XStringResourceDetails, GSProfile,XExportAttributeString:
            begin
              Name := GetStr128(p2);
             // k3 := TestByte128(p2);
            end;
            LockedContainer:
            begin
              p2 := Pointer(Longword(p) + 7 + 1);
              s := TestByte128(p2);
            end;
            MenuDescription:
            begin
             p2 := Pointer(Longword(p) + 7 + 4*6);
             TestByte128(p2);
             TestByte128(p2);
             TestByte128(p2);
             TestByte128(p2);
             s := TestByte128(p2);
            end;
            HighScoreData:
            begin
              p2 := Pointer(Longword(p2) + 4);
              s := TestByte128(p2);
              p2 := Pointer(Longword(p2) + 4);
              s := TestByte128(p2);
              //         sTemp:= sTemp+s+nVn;
            end;
            BrickLinkage:
            begin
             p2 := Pointer(Longword(p) + 7 + 2);
             s := TestByte128(p2);
            end;
            LevelLock:
            begin
             p2 := Pointer(Longword(p) + 7 + 4+4);
             s := TestByte128(p2);
            end;
            MovieLock:
            begin
             p2 := Pointer(Longword(p) + 7 + 4);
             s := TestByte128(p2);
            end;
            XAlphaTest:
            begin
              Inc(Longword(p2), 8);
              IsCtnr := false;
            end;
            XLightingEnable:
            begin
              px := Longword(p) + 14;
              p2 := Pointer(Longword(p) + 14 + 16);
              IsCtnr := false;
            end;
            XBlendModeGL:
            begin
              p2 := Pointer(Longword(p) + 11);
              //    IsCtnr:=false;
            end;
            XDepthTest:
            begin
              if WR then begin
              p2 := Pointer(Longword(p) + 7 + 9+4);
              IsCtnr:=false;
              end;
            end;
            XCullFace:
            begin
              p2:= Pointer(Longword(p) + 7 + 4);
              IsCtnr := false;
            end;
            XPointLight:
            begin
             p2 := Pointer(Longword(p) + 7 + 86);
             s := TestByte128(p2);
            end;
            XMaterial:
            begin
            end;
            XVectorResourceDetails:
            begin
              p2 := Pointer(Longword(p) + 7 + 12);
             // s := TestByte128(p2);
              Name := GetStr128(p2);
              //         sTemp:= sTemp+s+nVn;
            end;
            XColorResourceDetails:
            begin
              p2 := Pointer(Longword(p) + 7 + 4);
             // s := TestByte128(p2);
              Name := GetStr128(p2);
              //            sTemp:= sTemp+s+nVn;
            end;
            XCoord3fSet, XNormal3fSet: 
            begin
              px := Longword(p2);
            end;
            XCoord3sSet_1uScale, XNormal3sSet_1uScale:
            begin
              px := Longword(p2);
            end;
            XTexCoord2fSet: 
            begin
              px := Longword(p2);
            end;
            XMultiTexCoordSet:
            begin
              p2 := Pointer(Longword(p) + 7);
              k := TestByte128(p2);
              k2:= TestByte128(p2);
              k3:= TestByte128(p2);
            end;
            XPsTextureReference:
            begin
              p2:= Pointer(Longword(p) + 7);
              k := TestByte128(p2);
              k := TestByte128(p2);
              Inc(Longword(p2));
              IsCtnr := false;
            end;
            XPaletteWeightSet:
            begin
              p2 := Pointer(Longword(p) + 7);
              k := TestByte128(p2);
            end;
            XWeightSet:
            begin
              p2 := Pointer(Longword(p) + 7);
              k2 := Word(p2^);
              Inc(Longword(p2), 2);
              k := TestByte128(p2);
              px := Longword(p2);
            end;
            XColor4ubSet: 
            begin
              px := Longword(p2);
            end;
            XIndexedTriangleSet://,XIndexedCustomTriangleSet:
            begin
              Inc(Longword(p2), 4);
              k2 := Word(p2^);
              Inc(Longword(p2), 4);
              k3 := TestByte128(p2);
              k3 := TestByte128(p2);
              k3 := TestByte128(p2);
              k3 := TestByte128(p2);
              Inc(Longword(p2));
              px := Longword(p2);
            end;
            XIndexedTriangleStripSet:
            begin
            WF:=true;
              p2 := Pointer(Longword(p) + 8);
              k2 := Word(p2^);
              Inc(Longword(p2), 2);
              k3 := TestByte128(p2);
              Inc(Longword(p2), 8);
              k3 := TestByte128(p2);
              k3 := TestByte128(p2);
              k3 := TestByte128(p2);
              k3 := TestByte128(p2);
              Inc(Longword(p2));
              px := Longword(p2);
            end;
            XConstColorSet: 
            begin
              px := Longword(p) + 7;
            end;
            XBrickIndexSet:
            begin
            end;
            XMultiIndexSet:
            begin
              k3 := TestByte128(p2);
              k3 := TestByte128(p2);
              k3 := TestByte128(p2);
              k3 := TestByte128(p2);
            end;
            XIndexSet:
            begin
              Inc(Longword(p2),2*k);
              IsCtnr := false;
            end;
            XIndexSet8:
            begin
              Inc(Longword(p2),k);
              IsCtnr := false;
            end;
            StringStack:
            begin
            end;
            XBrickGeometry:
            begin
            end;
            XCollisionGeometry:
            begin
              p2 := Pointer(Longword(p) + 4 + 7 + 8);
              k3 := TestByte128(p2);
              p2 := Pointer(Longword(p2) + 2 * k3);
              k3 := TestByte128(p2);
              p2 := Pointer(Longword(p2) + 4 * k3);
              p2 := Pointer(Longword(p2) + 4 * 5);  // Bounds BoundMode
              Name := GetStr128(p2);    // Name
            end;
            XDataBank:
            begin
            end;
            XExpandedAnimInfo:
            begin
              if (Longword(p^) = Ctnr) then
                p2 := Pointer(Longword(p) + 7 + 4)
              else
                p2 := Pointer(Longword(p) + 7);
              IsCtnr := false;
            end;
            XPalette: 
            begin
            end;
            XAnimInfo:
            begin
              if (Longword(p^) = Ctnr) then
                p2 := Pointer(Longword(p) + 5 + 4)
              else
                p2 := Pointer(Longword(p) + 5);
              IsCtnr := false;
            end;
            XSceneCamera:
            begin
             p2 := Pointer(Longword(p) + 7 + 3*3*4+4);
             s:=TestByte128(p2);
            end;
            XFortsExportedData:
            begin
            end;
            BrickBuildingCtr:
            begin
            end;
            PC_LandChunk:
            begin
              p2 := Pointer(Longword(p) + 7 + 4);
              Inc(Longword(p2), 4 * 4);  // Bounds
              Inc(Longword(p2), 5);   // BoundMode  // Name
              IsCtnr := false;
            end;
            LandFrameStore:
            begin
              p2 := Pointer(Longword(p) + 7);
              Name := GetStr128(p2);
            end;
            PC_LandFrame:
            begin
              p2 := Pointer(Longword(p) + 7);
              k3 := TestByte128(p2); // FloorRoofLightIndex
              Inc(Longword(p2), k3);
              k3 := TestByte128(p2); // WallLightIndex
              Inc(Longword(p2), k3);
              k3 := TestByte128(p2); // TintedLighting
              Inc(Longword(p2), k3);
              k3 := TestByte128(p2); // Siblings
              Inc(Longword(p2), k3);
              Inc(Longword(p2), 4);    // MostSignificantMaterial SolidVoxelCount
              Inc(Longword(p2), 368);  // Position - CentreOffset
              k3 := TestByte128(p2);   // EdgeOffset1
              Inc(Longword(p2), k3 * 2 * 4);
              k3 := TestByte128(p2); // EdgeOffset2
              Inc(Longword(p2), k3 * 2 * 4);
              k3 := TestByte128(p2); // HeightMap
              Inc(Longword(p2), k3 * 4);
              Inc(Longword(p2), 4);  // PeturbCliffs
              k3 := TestByte128(p2); // BitArray
              Inc(Longword(p2), k3 * 4);
              k3 := TestByte128(p2); // SecondTextureBitArray
              Inc(Longword(p2), k3 * 4);
              // ?????
              k3 := TestByte128(p2); // RLEVoxelData
              Inc(Longword(p2), (k3 - 1) * 4);
              Inc(Longword(p2), 16); //???
              Inc(Longword(p2), 4);  // ff ff ff ff  Tint
              k3 := TestByte128(p2); // Children
              for x := 1 to k3 do
                TestByte128(p2);
              Inc(Longword(p2), 4 * 4); // Bounds
              Inc(Longword(p2), 4);     // BoundMode
              s := TestByte128(p2);  // Name
              IsCtnr := false;
            end;
            XSoundBank:
            begin
              p2 := p;
              k3 := TestByte128(p2); // childs
              for x := 1 to k3 do
                TestByte128(p2);
              s:=TestByte128(p2);
               IsCtnr := false;
            end;
            XInternalSampleData:
            begin
              p2 := p;
                k:= Longword(p2^); Inc(Longword(p2) , 4);
                Inc(Longword(p2),k);
              if not WB then begin   Inc(Longword(p2), 4); //0
                Inc(Longword(p2), 4);//1
                Inc(Longword(p2), 4);//2
              end;
                IsCtnr := false;
            end;
            XSampleData:
            begin
                p2 := p;
                TestByte128(p2); //01:Sound ID Key
                TestByte128(p2);//02:Sound Direct Key
                if WB then Inc(Longword(p2), 34)
                 else
                 Inc(Longword(p2), 47);
                IsCtnr := false;
            end;
            XStreamData:
            begin
              p2 := p;
                TestByte128(p2); //01:Sound ID Key
                TestByte128(p2);//02:Sound Direct Key
                Inc(Longword(p2),4);     //44 AC: Hz 44100
                Inc(Longword(p2), 4); //float
                inc(Longword(p2),4); //int
                inc(Longword(p2),1); // byte
                Inc(Longword(p2), 4); //00 00 7A 44 - 1000
                Inc(Longword(p2), 4); //00 40 9C 45- 5000
                Inc(Longword(p2), 4); //00 00 CB 42 -101,5   float
                Inc(Longword(p2), 4); //00 80 BB 44  float
                Inc(Longword(p2), 4); //00 80 BB 44  float
                Inc(Longword(p2), 4*3); //?
                k:= Longword(p2^);Inc(Longword(p2), 4);
                Inc(Longword(p2),k);
                Inc(Longword(p2), 4); //?
                Inc(Longword(p2), 4); //?

              IsCtnr := false;
            end;
            DetailEntityStore:
            begin
              p2 := Pointer(Longword(p) + 7);
              Name:=GetStr128(p2);
              TestByte128(p2);
              Inc(Longword(p2), 4*3*4);//pos,rot,clip,size
              Inc(Longword(p2), 4*2+4*3+1);
               IsCtnr := false;
            end;
            XPathFinderData:
            begin
            end;
            XPositionData:
            begin
              p2 := Pointer(Longword(p) + 12);
              IsCtnr := false;
            end;
            XDetailObjectsData:
            begin
              p2 := Pointer(Longword(p) + 7);
              k := TestByte128(p2);
              for x := 1 to k do
                k3 := TestByte128(p2);
              k := TestByte128(p2);
              for x := 1 to k do 
                k3 := TestByte128(p2);

              k := TestByte128(p2);
              for x := 1 to k do 
                Inc(Longword(p2), 3 * 4);
              k := TestByte128(p2);
              for x := 1 to k do
                Inc(Longword(p2), 3 * 4);
              k := TestByte128(p2);
              for x := 1 to k do
                Inc(Longword(p2), 3 * 4);
              IsCtnr := false;
            end;
            XNone:
              s := k;
          end;
result:=p2;
end;

// XML part

const
  VTYPES = 22;

  XCheckedValues : array [0..VTYPES] of String = (
    'XInt','XUInt','XInt8','XUInt8',
    'XInt16','XUInt16','XString',
    'XFloat','XBool','XEnum','XColor4ub',
    'XVector2f','XVector3f','XVector4f',
    'XUIntHex', 'XGUID','XMatrix34','XMatrix3','XMatrix','XBoundBox',
    'XBase64Byte', 'XKey','XBitmap16');
var
XGlobid:Integer=0;
XGlobBlocks:array of TBitmap32;
XBlockIndex:Integer=0;
XBlockName:String;

function TXom.XBitmapAddBlocks(Point:Pointer; Size: Integer):String;
var
  Bitmap: TBitmap32;
  Mem: TMemoryStream;
begin
  Bitmap := TBitmap32.Create;
  Bitmap.Width := 64;
  Bitmap.Height := 64;
  Bitmap.LoadFromBlocks(Point, 8, 8, 16);
  Inc(XBlockIndex);
 // -------
  Mem:= TMemoryStream.Create;
  if XImg.outfile = 'png' then
     Bitmap.SaveToPNG(Mem);
  XBlockName := format('%d.%s',[ XBlockIndex, Ximg.outfile]);

    if XImg.dir <> '' then begin
      if not DirectoryExists(XImg.dir) then CreateDir(XImg.dir);
      XImg.dir := IncludeTrailingPathDelimiter(XImg.dir);
    end;

    XBlockName:= XImg.dir + XBlockName;
  Mem.SaveToFile(XBlockName);
 // --------
//  SetLength(XGlobBocks,XBlockIndex);
//  XGlobBocks[XBlockIndex] := Bitmap;
  Result := XBlockName;
end;

function TXom.XImageEncode(XImageNode: TXmlNode; Point:Pointer; Size: Integer):String;
var
  Bitmap: TBitmap32;
  Mem: TMemoryStream;
  Name, attr, FileName: String;
  Width, Height, xFormat, Bits, MipMaps: Integer;
begin
  if XImg.isfile then begin
    Name := format('-%d.tga',[XGlobid-1]);
    Name := StringReplace(XImageNode.NodeByName('Name').ValueUnicode,'/-1',Name,[rfReplaceAll]);
    Name := StringReplace(Name,'maya:','',[rfReplaceAll]);
    Name := StringReplace(Name,'/','\',[rfReplaceAll]);
    Name := ExtractFileName(Name);

    if Pos('.',Name)>0 then
      Name:=ChangeFileExt(Name,'.'+Ximg.outfile)
    else begin
      attr := XImageNode.AttributeValueByName['id'];
      Name := format('%s.%s',[ attr, Ximg.outfile]);
    end;

    if XImg.dir <> '' then begin
      if not DirectoryExists(XImg.dir) then CreateDir(XImg.dir);
      XImg.dir := IncludeTrailingPathDelimiter(XImg.dir);
    end;

    FileName:= XImg.dir + Name;
     if XImg.outfile = 'bin' then
     begin
       Mem:= TMemoryStream.Create;
       Mem.Write(Point^,Size);
       Mem.SaveToFile(FileName);
       Mem.Free;
       Result := FileName;
     end else
     begin
      Bitmap:= TBitmap32.Create;
      Width := XImageNode.NodeByName('Width').ValueAsInteger;
      Height := XImageNode.NodeByName('Height').ValueAsInteger;
      MipMaps := XImageNode.NodeByName('MipLevels').ValueAsInteger;
      xFormat := XImageNode.NodeByName('Format').ValueAsInteger;
      Case xFormat of
       0: Bits := 24;  // kImageFormat_R8G8B8
       1: Bits := 32; // kImageFormat_A8R8G8B8
      else begin // TODO xFormat
         Bitmap.Free;
         Result := EncodePointer(Point, Size);
         Exit;
        end;
      end;

      Bitmap.LoadFromData(Point, Width, Height, Bits, MipMaps);
      Mem:= TMemoryStream.Create;

      if XImg.outfile = 'png' then
        Bitmap.SaveToPNG(Mem)
      else if XImg.outfile = 'tga' then
        Bitmap.SaveToTGA(Mem, Bits)
      else if XImg.outfile = 'dds' then
        Bitmap.SaveToDDS(Mem, Bits);

      Mem.SaveToFile(FileName);
      Result := FileName;

      Mem.Free;
      Bitmap.Free;
     end
  end else
     Result := EncodePointer(Point, Size);

end;

procedure TXom.XImageDecode(XImageNode: TXmlNode; XValue: String; Buf:TStream);
var
  Bitmap: TBitmap32;
  Mem: TMemoryStream;
  isfile: Boolean;
  Name, base64Data, ExtPart, FileName, outfile: String;
  Width, Height, xFormat, Bits, MipMaps, Len, ps: Integer;
begin
  isfile := false;
  outfile := '';
  Len := Length(XValue);
  if Len > 4 then begin
    ExtPart := Copy(XValue, len - 3, 1); // .png
    if ExtPart = '.' then begin isfile:=true;  end;
  end;

  if isfile then begin

    if not FileExists(XValue) then
    begin
       WriteLn(Format('Error: File %s not exist',[XValue]));
       Halt;
    end;
    
      Mem:= TMemoryStream.Create;

      outfile := LowerCase(Copy(XValue, len - 2, 3));
      FileName := XValue;
      Mem.LoadFromFile(FileName);

     if outfile = 'bin' then
     begin
       Buf.CopyFrom(Mem, Mem.Size);
     end else
     begin
      Bitmap:= TBitmap32.Create;

      Width := XImageNode.NodeByName('Width').ValueAsInteger;
      Height := XImageNode.NodeByName('Height').ValueAsInteger;
      MipMaps := XImageNode.NodeByName('MipLevels').ValueAsInteger;
      xFormat := XImageNode.NodeByName('Format').ValueAsInteger;
      if xFormat>1 then begin // TODO
         WriteLn(Format('Error: kImageFormat %s not supported',[ImageFormatWUM[xFormat]]));
         Halt;
        end;

      Bits := (3 + xFormat) * 8;
      Mem.Position := 0;

      if outfile = 'png' then
        Bitmap.LoadFromPNG(Mem)
      else if outfile = 'tga' then
        Bitmap.LoadFromTGA(Mem)
      else if outfile = 'dds' then
        Bitmap.LoadFromDDS(Mem);
       // TODO convert full XImage
      if (Width <> Bitmap.Width) or (Height <> Bitmap.Height) then begin
         WriteLn(Format('Error: WxH = %d x %d is not correct',[Bitmap.Width, Bitmap.Height]));
         Halt;
        end;

      if MipMaps > 1 then Bitmap.GenMipMaps;

      Bitmap.SaveToStream(Buf, Bits);
      Bitmap.Free;
     end;

     Mem.Free;
  end else
     DecodeStreamString(XValue, Buf);

end;

type
  Int32Rec = packed record
    case Integer of
      0: (Floats: Single);
      1: (Cardinals: Cardinal);
  end;

function CompareFloatHex(v1,v2:Single):Boolean;
begin
    result:=  Int32Rec(v1).Cardinals = Int32Rec(v2).Cardinals;
end;


function TXom.AddXMLNode(XCntr:TContainer; XContainer:TXmlNode; XName:String;  XML:TNativeXml; xomObjects:TXmlNode):String;
var
  XType,XRef: string;
  XCont,SXCont:TXmlNode;
  i: integer;
  p2: Pointer;

  function CheckXValue(XValue:String):Boolean;
  var n:integer;
  begin
    Result:=true;
    for n:=0 to VTYPES do
      if XValue = XCheckedValues[n] then exit;
    Result:=false;
  end;

  function XReadFloat:UTF8String;
  var f: Single; s:String; q: integer;
  begin
    f := Single(p2^);
    s := FloatToStrF(f,ffGeneral,7,7);
    if hqFloat then  begin
      if Int32Rec(f).Cardinals = 2147483648 then s:='-0';
      for q := 8 to 15 do begin
        if CompareFloatHex(StrToFloatDef(S, 0.0),f) then break;
        s := FloatToStrF(f,ffGeneral,q,q);
      end;
    end;
    Result := s;
    Inc(Longword(p2), 4);
  end;

  function XReadValue(XValue:String):UTF8String;
  var n:integer;
  begin
   try
    if XValue='XInt' then begin
      Result:=Format('%d', [Integer(p2^)]);
      Inc(Longword(p2), 4);
    end else if XValue='XUInt' then begin
      Result:=Format('%d', [Cardinal(p2^)]);
      Inc(Longword(p2), 4);
    end else if (XValue='XColor4ub') or
      (XValue='XUIntHex') then begin
      Result:=IntToHex(Cardinal(p2^), 8);
      Inc(Longword(p2), 4);
    end else if XValue='XBool' then begin
      Result:=Format('%s', [LowerCase(BoolToStr(Boolean(byte(p2^)), true))]);
      Inc(Longword(p2));
    end else if XValue='XString' then begin
      Result:=Utf8Encode(GetStr128(p2));
    end else if XValue='XFloat' then begin
      Result:=XReadFloat;
    end else if XValue='XVector2f' then begin
      Result:=XReadFloat + ' ' + XReadFloat;
    end else if XValue='XVector3f' then begin
      Result:=XReadFloat + ' ' + XReadFloat + ' ' + XReadFloat;
    end else if XValue='XVector4f' then begin
      Result:=XReadFloat + ' ' + XReadFloat + ' ' + XReadFloat + ' ' + XReadFloat;
    end else if XValue='XMatrix3' then begin
      Result:='';
      for n:=1 to 8 do
        Result:=Result+XReadFloat + ' ';
      Result:=Result+XReadFloat;
    end else if XValue='XMatrix34' then begin
      Result:='';
      for n:=1 to 11 do
        Result:=Result+XReadFloat + ' ';
      Result:=Result+XReadFloat;
    end else if XValue='XMatrix' then begin
      Result:='';
      for n:=1 to 15 do
        Result:=Result+XReadFloat + ' ';
      Result:=Result+XReadFloat;
    end else if (XValue='XBoundBox') or (XValue='XKey') then begin
      Result:='';
      for n:=1 to 5 do
        Result:=Result+XReadFloat + ' ';
      Result:=Result+XReadFloat;
    end else if XValue='XEnum' then begin
      Result:=Format('%d', [Cardinal(p2^)]);
      Inc(Longword(p2), 4);
    end else if XValue='XInt8' then begin
      Result:=Format('%d', [ShortInt(p2^)]);
      Inc(Longword(p2), 1);
    end else if XValue='XUInt8' then begin
      Result:=Format('%d', [Byte(p2^)]);
      Inc(Longword(p2), 1);
    end else if XValue='XInt16' then begin
      Result:=Format('%d', [SmallInt(p2^)]);
      Inc(Longword(p2), 2);
    end else if XValue='XUInt16' then begin
      Result:=Format('%d', [Word(p2^)]);
      Inc(Longword(p2), 2);
    end else if XValue='XBitmap16' then begin
      Result:=IntToHex(Word(p2^), 4);
      Inc(Longword(p2), 2);
    end else if XValue='XGUID' then begin
      Result:=GUIDToString(TGUID(p2^));
      Inc(Longword(p2), 16);
    end;
    if Longword(p2)>Longword(XCntr.Point)+XCntr.Size then begin
       WriteLn(Format('Error: Out of container when read %s of XContainer[%d]: %s',[XValue, XCntr.Index, PCharXTypes[XCntr.Xtype]]));
       Halt;
    end;// else
   // WriteLn(Format('readed %s = %s of XContainer[%d]: %s',[XValue,Result, XCntr.Index, PCharXTypes[XCntr.Xtype]]));

  Except
      on E : Exception do   begin
       WriteLn(Format('Error: Try read %s of XContainer[%d]: %s',[XValue, XCntr.Index, PCharXTypes[XCntr.Xtype]]));
       Halt;
    end;
    end;
  end;

  procedure AddPropPack(XSNode, XCont:TXmlNode; n:Integer);
  var
  XValueType:String;
  s,XValue: UTF8String;
  XStNode: TsdCharData;
  XNode: TsdElement;
  i:Integer;
  begin
      if Length(XSNode.Value)>0 then  //< >Value</ >
      begin
        XValueType:=XSNode.Value;
        if CheckXValue(XValueType) then begin
          XNode := TsdElement.CreateParent(XML,XCont);
          XNode.Name:=XSNode.Name;
          XNode.NodeClosingStyle := ncFull;
          XStNode := TsdCharData.CreateParent(XML,XNode);
          s:='';
          If XValueType = 'XBase64Byte' then begin
            if XCont.Name = 'XImage' then
              s := XImageEncode(XCont, p2, n)
            else
              s := EncodePointer(p2,n);
            Inc(Longword(p2), n);
          end else if (XValueType = 'XBitmap16') and Ximg.isfile then begin
            s := XBitmapAddBlocks(p2, n);
            Inc(Longword(p2), n * 2);
          end else begin
            for i := 1 to n do
              s := s + XReadValue(XValueType)+' ';
          end;
          XStNode.Value := Trim(s);
          XNode.AttributeAdd('Xpack',format('%d', [n]));
        end;
      end;
  end;

  function AddProp(XSNode, XCont:TXmlNode):TsdElement;
  var
  XValueType:String;
  XValue,Attr: UTF8String;
  XStNode: TsdCharData;
  XNode: TsdElement;
  i,n:Integer;
  begin
      XNode := nil;
      if Length(XSNode.Value)>0 then  //< >Value</ >
      begin
        XValueType:=XSNode.Value;
        if CheckXValue(XValueType) then begin
          XNode := TsdElement.CreateParent(XML,XCont);
          XNode.Name:=XSNode.Name;
          XNode.NodeClosingStyle := ncFull;
          XStNode := TsdCharData.CreateParent(XML,XNode);
          XStNode.Value := XReadValue(XValueType);
        end;
      end else    //  attr= />
      begin
        XNode := TsdElement.CreateParent(XML,XCont);
        XNode.Name:=XSNode.Name;
        XNode.NodeClosingStyle := ncClose;
        for i:=0 to XSNode.AttributeCount-1 do
          begin
            Attr := XSNode.Attributes[i].Name;
            if  (Attr = 'Xtype') or (Attr = 'Xver') or (Attr = 'Nver') then begin
              Continue;
            end else
            if Attr = 'href' then begin
               // XContainer
               n:=GetIdx128(p2);
               if n=0 then Continue;
               XValue:=AddXMLNode(XCntr.CntrArr[n], XContainer, XName, XML, xomObjects); // GetNameID
               XNode.AttributeAdd('href',XValue);
            end else begin
              XValueType:=XSNode.Attributes[i].Value;
              if not CheckXValue(XValueType) then Continue;
              XValue := XReadValue(XValueType);
              XNode.AttributeAdd(XSNode.Attributes[i].Name,XValue);
            end;
          end;
      end;
      Result := XNode;
  end;

  procedure ReadAndAddProp(XSNode, XCont:TXmlNode);
  var
  XValueType:String;
  i,j,n:Integer;
  Xtype:XTypes;
  Xpack:String;
  XNode:TsdElement;
  begin
 //   try
      if XSNode.AttributeCount = 0 then   // >Value<
      begin
        AddProp(XSNode, XCont);
      end else begin
       if XSNode.HasAttribute('guid') then exit;
       if XSNode.HasAttribute('Nver') then begin
         if SearchTypeByName(Pchar(XSNode.Parent.Name),n) then begin
           n:=XomHandle.TypesInfo[n].btype;
           if n = StrToIntDef(XSNode.AttributeValueByName['Nver'],0) then
            exit;
        end;
       end;
       if XSNode.HasAttribute('Xver') then begin
         if SearchTypeByName(Pchar(XSNode.Parent.Name),n) then begin
           n:=XomHandle.TypesInfo[n].btype;
           if n < StrToIntDef(XSNode.AttributeValueByName['Xver'],0) then
            exit;
        end;
       end;
       XValueType:=XSNode.AttributeValueByName['Xtype'];
       if XValueType='XCollection' then begin
          Xpack:=XSNode.AttributeValueByName['Xpack'];
          n := GetSize128(p2);
          if Xpack='true' then
             AddPropPack(XSNode, XCont, n)
          else
          for i := 1 to n do
             AddProp(XSNode, XCont);
       end else if XValueType='XMapCollection' then begin
          n := Cardinal(p2^); // MapNum
          Inc(Longword(p2), 4);
          for i := 1 to n do
              AddProp(XSNode, XCont);
       end else if XValueType='XClipCollection' then begin
          n := Cardinal(p2^); // ClipNum
          Inc(Longword(p2), 4);
          for i := 1 to n do begin
            XNode := AddProp(XSNode, XCont);
            for j:=0 to XSNode.ElementCount-1 do
              ReadAndAddProp(XSNode.Elements[j], XNode);
          end;
       end else if XValueType='XChannelCollection' then begin
          n := Cardinal(p2^); // ChannelNum
          Inc(Longword(p2), 4);
          for i := 1 to n do begin
            XNode := TsdElement.CreateParent(XML,XCont);
            XNode.Name := XSNode.Name;
            XNode.NodeClosingStyle := ncFull;
            for j:=0 to XSNode.ElementCount-1 do
              ReadAndAddProp(XSNode.Elements[j], XNode);
          end;
       end else if XValueType='XKeyCollection' then begin
          Xpack:=XSNode.AttributeValueByName['Xpack'];
          n := Cardinal(p2^); // KeyNum
          Inc(Longword(p2), 4);
          if Xpack='true' then
             AddPropPack(XSNode, XCont, n)
          else begin
            WriteLn(Format('Error: Not found Xpack for %s',[XValueType]));
            Halt;
          end;
       end else
           AddProp(XSNode, XCont);
      end;
{  Except
      on E : Exception do
      WriteLn(Format('Error: Out size of XContainer[%d]: %s',[XCntr.Index, PCharXTypes[XCntr.Xtype]]));
  end;  }
  end;

  procedure ReadParentProp(XParent:TXmlNode);
  var i:integer ;
  begin
  if XParent.Name='xomSCHM' then exit;
  For i:=0 to XParent.ElementCount-1 do
    ReadAndAddProp(XParent.Elements[i], XCont);
  // check prop parrents
  if XParent.Parent.Name<>'XContainer' then
     ReadParentProp(XParent.Parent);
  end;

begin
  if XCntr.XRef<>'' then begin Result:=XCntr.XRef; Exit; end;
  XType := PCharXTypes[XCntr.Xtype];
  SXCont := GetXTypeNode(XType, XContainer);
  if SXCont=nil then begin
    WriteLn(Format('Error: %s not found in xomSCHM',[XType]));
    Halt;
  end;
  XCont := XML.NodeNew(XType);
  p2 := XCntr.GetPoint;
  if LogXML then Writeln(format('%s [%d]',[XType,XCntr.Index]));
  if SXCont.Parent.Name='XResourceDetails' then begin
   XName:=XCntr.Name;
   XRef:= XName;
   XGlobid:=0;
  end else begin
    if (SXCont.Name='LandFrameStore') or
     // (SXCont.Name='XGraphSet') or
      (SXCont.Name='XGroup') or
      (SXCont.Name='XShape') or
      (SXCont.Name='XSimpleShader') or
      (SXCont.Name='XCollisionGeometry') then
      begin
        XName:=XCntr.Name;
        if XName='' then XName:='id';
      end;
    XRef:= format('%s-%d',[XName,XGlobid]);  // GetNameID
    XCntr.XRef:= XRef;
    Inc(XGlobid);
  end;
  XCont.AttributeAdd('id',XRef);
  xomObjects.NodeAdd(XCont);

  if SXCont.AttributeValueByName['Xtype'] = 'XDesc' then
    ReadParentProp(SXCont.Parent);

  For i:=0 to SXCont.ElementCount-1 do
    ReadAndAddProp(SXCont.Elements[i], XCont);
  // check prop parrents
  if (SXCont.Parent.Name<>'XContainer') and (SXCont.AttributeValueByName['Xtype'] <> 'XDesc') then
     ReadParentProp(SXCont.Parent);


  if (Longword(p2)-Longword(XCntr.Point))<>XCntr.Size then
      Writeln(Format('Error: %s Size: %d <> %d',[XType,Longword(p2)-Longword(XCntr.Point),XCntr.Size]));
  if IsXid then XCont.AttributeAdd('Xid',IntToStr(XCntr.Index));
  if not XCntr.CTNR then XCont.AttributeAdd('NoCntr','true');
  if XCntr.CTNR and (Byte(XCntr.Point^)>0)
    then XCont.AttributeAdd('Zver',IntToStr(Byte(XCntr.Point^)));
  Inc(XMLNumCntr);
  Result := XRef;
end;


function TXom.GetXTypeNode(Name: String; XContainer: TXmlNode): TXmlNode;
var found:Boolean;
FndNode: TXmlNode;
  procedure CheckXTypeNode(XCont:TXmlNode);
  var i:integer;
  begin
    if not Found then begin
      if XCont.HasAttribute('guid') and (XCont.Name = Name) then
      begin
        Found:=true;
        FndNode:=XCont;
      end else begin
        for i:=0 to XCont.ElementCount-1 do begin
          CheckXTypeNode(XCont.Elements[i]);
          if Found then break;
        end;
      end;
    end;
  end;

begin
  FndNode := nil;
  Found := false;
  CheckXTypeNode(XContainer);
  Result := FndNode;
end;

function TXom.GetXTypeNode(nType:Integer; XContainer: TXmlNode): TXmlNode;
var found:Boolean;
sGuid: String;
FndNode: TXmlNode;
  procedure CheckXTypeNode(XCont:TXmlNode);
  var i:integer;
  begin
    if not Found then begin
      if XCont.HasAttribute('guid') and (XCont.AttributeValueByName['guid'] = sGuid) then
      begin
        Found:=true;
        FndNode:=XCont;
      end else begin
        for i:=0 to XCont.ElementCount-1 do begin
          CheckXTypeNode(XCont.Elements[i]);
          if Found then break;
        end;
      end;
    end;
  end;
begin
  sGuid := GUIDToString(XomHandle.TypesInfo[nType].GUID);
  FndNode := nil;
  Found := false;
  CheckXTypeNode(XContainer);
  Result := FndNode;
end;

procedure TXom.LoadXTypeXML(XContainer, xomTypes: TXmlNode);
var
i, v: integer;
XTypeName: String;
XClass: TXmlNode;

  procedure AddType(XClass: TXmlNode; Xver: Integer);
   var LastTypeI: Integer;
   XGuid: TGUID;
   XName: String;
   vType: Integer;
   begin
      LastTypeI:=Length(XomHandle.TypesInfo);
      XomHandle.NumTypes:=LastTypeI+1;
      SetLength(XomHandle.TypesInfo,XomHandle.NumTypes);
      XGuid := StringToGUID(XClass.AttributeValueByName['guid']);
      XName := XClass.Name;
      vType := StrToIntDef(XClass.AttributeValueByName['Xver'],0);
      if (Xver>-1) and (Xver<>vType) then vType:=Xver;
      with XomHandle.TypesInfo[LastTypeI] do begin
        StrLCopy(@aType[0],PChar('TYPE'),4);
        bType:=vType;
        Size:=0;
        GUID:=XGuid;
        FillChar(Name[0], SizeOf(Name),#0);
        StrLCopy(@Name[0],PChar(XName),31);
      end;
   end;

begin
   v := StrToIntDef(xomTypes.AttributeValueByName['Xver'],2);
   XomHandle.nType := v shl 24;
   if v = 1 then XomHandle.SCHMType:=0; // 2003 MOIK with version 1
   for i:=0 to xomTypes.ElementCount-1 do begin
      XTypeName:= xomTypes.Elements[i].Name;
      v := StrToIntDef(xomTypes.Elements[i].AttributeValueByName['Xver'],-1);
      XClass := GetXTypeNode(XTypeName, XContainer);
      if XClass = nil then begin
      WriteLn('Error: ' + XTypeName + ' not found in scheme');
      Halt;
      end;
      AddType(XClass,v);
   end;
end;

procedure TXom.AddXTypeXML(XContainer,xomObjects: TXmlNode);
var
  i:integer;
  XElement: TsdElement;

   function IsChilds(XClass: TXmlNode):boolean;
   var
     n:integer;
     XChild: TsdElement;
     XCont: TXmlNode;
   begin
      Result:=false;
      for n:=0 to XClass.ElementCount-1 do begin
         XChild:=XClass.Elements[n];
         if XChild.HasAttribute('guid') and XChild.HasAttribute('Xver') then
         begin
          XCont := xomObjects.FindNode(XChild.Name);
          if XCont<>nil then begin Result:=true; Break; end
          else if XChild.AttributeValueByName['Xtype']='XClass' then
            if IsChilds(XChild) then begin Result:=true; Break; end
         end
         else Break;
      end;
   end;

   function FindContainer(XClass: TxmlNode):boolean;
   var
   XCont: TXmlNode;
   begin
   Result:= false;
    if XClass.HasAttribute('guid') and XClass.HasAttribute('Xver') then begin
      XCont := xomObjects.FindNode(XClass.Name);
      if XCont <> nil then Result:=true
        else if XClass.AttributeValueByName['Xtype']='XClass' then
          Result := IsChilds(XClass);
    end;
   end;

   procedure AddType(XClass: TxmlNode);
   var LastTypeI: Integer;
   XGuid: TGUID;
   XName: String;
   vType: Integer;
   begin
      LastTypeI:=Length(XomHandle.TypesInfo);
      XomHandle.NumTypes:=LastTypeI+1;
      SetLength(XomHandle.TypesInfo,XomHandle.NumTypes);
      XGuid := StringToGUID(XClass.AttributeValueByName['guid']);
      XName := XClass.Name;
      vType := StrToInt(XClass.AttributeValueByName['Xver']);
      with XomHandle.TypesInfo[LastTypeI] do begin
        StrLCopy(@aType[0],PChar('TYPE'),4);
        bType:=vType;
        Size:=0;
        GUID:=XGuid;
        FillChar(Name[0], SizeOf(Name),#0);
        StrLCopy(@Name[0],PChar(XName),31);
      end;
   end;

begin
   if FindContainer(XContainer) then AddType(XContainer);
   for i:=0 to XContainer.ElementCount-1 do begin
     XElement:= XContainer.Elements[i];
     if FindContainer(XElement) then AddXTypeXML(XElement,xomObjects) else
     if not XElement.HasAttribute('guid') then Break;
   end;
end;

function XTypeSort(Item1,Item2:Pointer):Integer;
var Cntr1,Cntr2:TContainer;
Indx1,Indx2: Integer;
begin
  Cntr1:=TContainer(Item1);
  Cntr2:=TContainer(Item2);
  if Cntr1.TypeIndex = Cntr2.TypeIndex then  begin
 {   if Cntr1.Name = Cntr2.Name then
       Result := 0
    else if Cntr1.Name > Cntr2.Name then
       Result := 1
    else
       Result := -1;     }
    if Cntr1.Xid = Cntr2.Xid then
       Result := 0
    else if Cntr1.Xid > Cntr2.Xid then
       Result := 1
    else
       Result := -1;
   { if Cntr1.Index = Cntr2.Index then
       Result := 0
    else if Cntr1.Index > Cntr2.Index then
       Result := 1
    else
       Result := -1;  }
  end
  else if Cntr1.TypeIndex > Cntr2.TypeIndex then
    Result := 1
  else
    Result := -1;
end;

function StrToFloatDefSafe(const aStr : Utf8String; const aDef : Extended) : Extended;
const
  D = ['.', ','];
var
  S : String;
  i : Integer;
begin
  S := aStr;
  for i := 1 to Length(S) do
    if S[i] in D then begin
      S[i] := DecimalSeparator;
      Break;
    end;
  Result := StrToFloatDef(S, aDef);
end;



procedure TXom.WriteXMLContaiter(index:integer;XCntr:TContainer;XContainer: TXmlNode);
    var
      XCont,XClass:TXmlNode;
      Buf:TMemoryStream;
      XName: String;
      e,Zero: integer;
      LocalIndex:TKeyValueList;

  function CheckXValue(XValue:String):Boolean;
  var n:integer;
  begin
    Result:=true;
    for n:=0 to VTYPES do
      if XValue = XCheckedValues[n] then exit;
    Result:=false;
  end;

  procedure XWriteValue(XValueType,XValue:Utf8String; Buf:TMemoryStream);
  var
    xi:Integer;
    xui:Cardinal;
    xb: Byte;
    xs: String;
    xf: Single;
    xi8: ShortInt;
    xui8: Byte;
    xi16: SmallInt;
    xui16: Word;
    xGUID:TGUID;
  begin
   try
    if XValueType='XInt' then begin
      xi:= StrToInt(XValue);
      Buf.Write(xi,4);
    end else if XValueType='XUInt' then begin
      xui:= StrToCard(XValue);
      Buf.Write(xui,4);
    end else if (XValueType='XUIntHex') or
      (XValueType='XColor4ub') then begin
      xui:= StrToCard('$'+XValue);
      Buf.Write(xui,4);
    end else if XValueType='XBool' then begin
      xb:=IfThen(StrToBool(XValue),1,0);
      Buf.Write(xb,1);
    end else if XValueType='XString' then begin
      WriteXString(Buf,XValue);
    end else if XValueType='XFloat' then begin
      xf:=StrToFloatDefSafe(XValue,0.0);
      Buf.Write(xf,4);
    end else if XValueType='XEnum' then begin
      xui:= StrToCard(XValue);
      Buf.Write(xui,4);
    end else if XValueType='XInt8' then begin
      xi8:= StrToInt(XValue);
      Buf.Write(xi8,1);
    end else if XValueType='XUInt8' then begin
      xui8:= StrToInt(XValue);
      Buf.Write(xui8,1);
    end else if XValueType='XInt16' then begin
      xi16:= StrToInt(XValue);
      Buf.Write(xi16,2);
    end else if XValueType='XUInt16' then begin
      xui16:= StrToInt(XValue);
      Buf.Write(xui16,2);
    end else if XValueType='XGUID' then begin
      xGUID:= StringToGUID(XValue);
      Buf.Write(xGUID,16);
    end;
  Except
      on E : Exception do   begin
       WriteLn(Format('Error: Try write %s: %s',[XValueType, XValue]));
       Halt;
    end;
    end;
  end;

  procedure WritePropPack(XSNode,XCont:TXmlNode; Buf:TMemoryStream);
  var
  XValueType, XValue: UTF8String;
  XValues:TStringList;
  i,len:Integer;
  begin
      if Length(XSNode.Value)>0 then  //< >Value</ >
      begin
        XValueType:=XSNode.Value;
        if CheckXValue(XValueType) then begin
          if XCont.Value='' then
            XValue:=''
          else
            XValue :=sdReplaceString(TsdText(XCont.Nodes[1]).GetCoreValue);
          If XValueType = 'XBase64Byte' then begin
            if XCont.Parent.Name = 'XImage' then
             XImageDecode(XCont.Parent, XValue, Buf)
            else
             DecodeStreamString(XValue,Buf);
            exit;
          end;
          XValues := TStringList.Create;
          XValues.Delimiter := ' ';
          XValues.DelimitedText := XValue;
          len := XValues.Count-1;
          if (XValueType = 'XVector2f') or
            (XValueType = 'XVector3f') or
            (XValueType = 'XKey') then XValueType:='XFloat';
          for i:=0 to len do
            XWriteValue(XValueType,XValues[i],Buf);
          XValues.Free;
        end;
      end;
  end;

  procedure WriteProp(XSNode,XCont:TXmlNode; Buf:TMemoryStream);
  var
  XValueType, XValue,Attr: UTF8String;
  i,n,index,len:Integer;
  XValues:TStringList;
  begin
      // WriteLn(Format('write %s: %s',[XSNode.Name,XCont.Value]));
      if Length(XSNode.Value)>0 then  //< >Value</ >
      begin
        XValueType:=XSNode.Value;
        if CheckXValue(XValueType) then begin
          if XCont.Value = '' then
            XValue := ''
          else
            XValue := sdReplaceString(TsdText(XCont.Nodes[0]).GetCoreValue);

          if (XValueType = 'XVector4f') or
            (XValueType = 'XMatrix34') or
            (XValueType = 'XMatrix3') or
            (XValueType = 'XMatrix') or
            (XValueType = 'XBoundBox') then
          begin
            XValues := TStringList.Create;
            XValues.Delimiter := ' ';
            XValues.DelimitedText := XValue;
            len := XValues.Count-1;
            for i:=0 to len do
                XWriteValue('XFloat',XValues[i],Buf);
            XValues.Free;
          end else
            XWriteValue(XValueType,XValue,Buf);

        end;
      end else    //  attr= />
      begin
        for i:=0 to XSNode.AttributeCount-1 do
          begin
            Attr := XSNode.Attributes[i].Name;
            if (Attr = 'Xtype') or (Attr = 'Xver') or (Attr = 'Nver') then begin
              Continue;
            end else
            if Attr = 'href' then begin
               // XContainer
               XValue := XCont.AttributeValueByName['href'];
               if XValue='' then begin
                  index:=0;
                  WriteXByte(Buf,index);
                  Continue;
               end;
               index := CntrArr.FindIndexByName(XValue);
               WriteXByte(Buf,index);
               WriteXMLContaiter(index,CntrArr[index],XContainer);
            end else begin
              XValueType:=XSNode.Attributes[i].Value;
              if not CheckXValue(XValueType) then Continue;
              XValue := XCont.AttributeValueByName[XSNode.Attributes[i].Name];
              XWriteValue(XValueType,XValue,Buf);
            end;
          end;
      end;
  end;

  procedure ReadAndWriteProp(XSNode,XCont:TXmlNode; Buf:TMemoryStream);
  var
  XValueType:String;
  i,j,n:Integer;
  NodeList: TList;
  XNode: TXmlNode;
  Xpack:String;

    procedure CheckXNode;
    begin
     if XNode=nil then begin
       Writeln(Format('Error: Property "%s" not found',[XSNode.Name]));
       Halt;
     end;
    end;

  begin
      if XSNode.AttributeCount = 0 then   // >Value<
      begin
        NodeList:= TList.Create;
        XCont.NodesByName(XSNode.Name,NodeList);
        if NodeList.Count = 1 then
          i:=0
        else
          i:=LocalIndex.Values[XSNode.Name];
        XNode:=TXmlNode(NodeList[i]);
        NodeList.Clear;
       // XNode:=XCont.NodeByName(XSNode.Name);
        CheckXNode;
        WriteProp(XSNode,XNode,Buf);
      end else begin
       if XSNode.HasAttribute('guid') then exit;
       if XSNode.HasAttribute('Nver') then begin
         if SearchTypeByName(Pchar(XSNode.Parent.Name),n) then begin
           n:=XomHandle.TypesInfo[n].btype;
           if n = StrToIntDef(XSNode.AttributeValueByName['Nver'],0) then
            exit;
        end;
       end;
       if XSNode.HasAttribute('Xver') then begin
         if SearchTypeByName(Pchar(XSNode.Parent.Name),n) then begin
           n:=XomHandle.TypesInfo[n].btype;
           if n < StrToIntDef(XSNode.AttributeValueByName['Xver'],0) then
            exit;
        end;
       end;
       XValueType:=XSNode.AttributeValueByName['Xtype'];
       if XValueType='XCollection' then begin
          Xpack:=XSNode.AttributeValueByName['Xpack'];
          if Xpack = 'true' then begin
           XNode:=XCont.NodeByName(XSNode.Name);
           n := StrToInt(XNode.AttributeValueByName['Xpack']);
           WriteXByte(Buf,n);
           if n>0 then
             WritePropPack(XSNode,XNode,Buf);
          end
          else begin
           NodeList:= TList.Create;
           XCont.NodesByName(XSNode.Name,NodeList);
           n := NodeList.Count;
           WriteXByte(Buf,n);
           for i := 0 to n-1 do
             WriteProp(XSNode,TXmlNode(NodeList[i]),Buf);
           NodeList.Clear;
          end;
       end else if XValueType='XMapCollection' then begin
           NodeList:= TList.Create;
           XCont.NodesByName(XSNode.Name,NodeList);
           n := NodeList.Count; // MapNum
           Buf.Write(n,4);
           for i := 0 to n-1 do
             WriteProp(XSNode,TXmlNode(NodeList[i]),Buf);
           NodeList.Clear;
       end else if XValueType='XClipCollection' then begin
           NodeList:= TList.Create;
           XCont.NodesByName(XSNode.Name,NodeList);
           n := NodeList.Count; // ClipNum
           Buf.Write(n,4);
           for i := 0 to n-1 do begin
             WriteProp(XSNode,TXmlNode(NodeList[i]),Buf);
             for j:=0 to XSNode.ElementCount-1 do
                ReadAndWriteProp(XSNode.Elements[j],TXmlNode(NodeList[i]), Buf);
           end;
           NodeList.Clear;
       end else if XValueType='XChannelCollection' then begin
           NodeList:= TList.Create;
           XCont.NodesByName(XSNode.Name,NodeList);
           n := NodeList.Count; // ChannelNum
           Buf.Write(n,4);
           for i := 0 to n-1 do begin
             for j:=0 to XSNode.ElementCount-1 do
                ReadAndWriteProp(XSNode.Elements[j],TXmlNode(NodeList[i]), Buf);
           end;
           NodeList.Clear;
       end else if XValueType='XKeyCollection' then begin
          Xpack:=XSNode.AttributeValueByName['Xpack'];  // only true
          if Xpack = 'true' then begin
           XNode:=XCont.NodeByName(XSNode.Name);
           n := StrToInt(XNode.AttributeValueByName['Xpack']);
           Buf.Write(n,4);  // KeyNum
           if n>0 then
             WritePropPack(XSNode,XNode,Buf);
          end else begin
            WriteLn(Format('Error: Not found Xpack for %s',[XValueType]));
            Halt;
          end;
       end else begin
           XNode:=XCont.NodeByName(XSNode.Name);
           CheckXNode;
           WriteProp(XSNode,XNode,Buf);
           end;
      end;
  end;

  procedure ReadParentProp(XParent,XCont:TXmlNode; Buf:TMemoryStream);
  var i:integer ;
  begin
  if XParent.Name='xomSCHM' then exit;
  For i:=0 to XParent.ElementCount-1 do
    ReadAndWriteProp(XParent.Elements[i],XCont,Buf);
  // check prop parrents
  if XParent.Parent.Name<>'XContainer' then
     ReadParentProp(XParent.Parent,XCont,Buf);
  end;

    begin
      if XCntr.Update then exit;
      if LogXML then Writeln(format('%s [%d]',[XCntr.Name,index]));
      XCont:=TXmlNode(XCntr.Point);
      LocalIndex := TKeyValueList.Create;
      Buf := TMemoryStream.Create;
      Zero:=XCntr.Zver;
      if XCntr.CTNR then
        Buf.Write(zero, 3);
      XClass := GetXTypeNode(XCont.Name, XContainer);
      if XClass.AttributeValueByName['Xtype'] = 'XDesc' then
        ReadParentProp(XClass.Parent,XCont,Buf);

      for e:=0 to XClass.ElementCount-1 do
        ReadAndWriteProp(XClass.Elements[e],XCont,Buf);
      // check prop parrents
      if (XClass.Parent.Name<>'XContainer') and (XClass.AttributeValueByName['Xtype'] <> 'XDesc') then
        ReadParentProp(XClass.Parent,XCont,Buf);
      XCntr.Point:=nil;
      XCntr.WriteBuf(Buf);
      Buf.Free;
      LocalIndex.Free;
end;

procedure TXom.LoadFromXML(xomTypes, xomObjects, XContainer: TXmlNode);
var
  i,indx:integer;
  XRoot:TContainer;
  XElement: TsdElement;

    procedure AddXContainer(XCont:TXmlNode);
    var
      n:integer;
    begin
      for n:=0 to XomHandle.NumTypes-1 do
        if StrLComp(PChar(XCont.Name),XomHandle.TypesInfo[n].Name,31)=0 then
        begin
          CntrArr.Count := indx + 1;
          CntrArr[indx] := TContainer.Create(indx, CntrArr, XCont);
          Inc(XomHandle.TypesInfo[n].Size);
          // Save Index Type in XCont
          CntrArr[indx].CTNR := not XCont.HasAttribute('NoCntr');
          if XCont.HasAttribute('Zver') then
            CntrArr[indx].Zver:=XCont.AttributeByName['Zver'].ValueAsInteger
          else CntrArr[indx].Zver := 0;
          CntrArr[indx].Name := XCont.AttributeValueByName['id'];
          if XCont.HasAttribute('Xid') then
            CntrArr[indx].Xid := XCont.AttributeByName['Xid'].ValueAsInteger
          else
            CntrArr[indx].Xid := indx;
          CntrArr[indx].TypeIndex := n;
          // Add to XCntr point to XCont;
          Inc(indx);
          Break;
        end;
    end;

begin
   InitXomHandle;
   XomHandle.StringTable.Add('');
// Read XTypes with order
   if xomTypes = nil then
    AddXTypeXML(XContainer,xomObjects)
   else
    LoadXTypeXML(XContainer,xomTypes);
// Set Container Numbers
   indx:=0;
   CntrArr.Count := indx + 1;
   CntrArr[indx]:= TContainer.Create(0,CntrArr,nil);
   Inc(indx);
   for i:=0 to xomObjects.ElementCount-1 do begin
      XElement:=xomObjects.Elements[i];
      AddXContainer(XElement);
   end;
   XRoot:=CntrArr[1];
   CntrArr.Sort(XTypeSort);
   XomHandle.MaxCount:= CntrArr.Count-1;
// Write Data from XML to Containers
   // Get RootContainer
   For i:=1 to CntrArr.Count-1 do begin
      if CntrArr[i]=XRoot then begin
      XomHandle.RootCount:=i;
      break;
      end; 
   //   WriteXMLContaiter(i,CntrArr[i],XContainer);
   end;
   WriteXMLContaiter(XomHandle.RootCount,XRoot,XContainer); // write tree

end;

destructor TXom.Destroy;
begin
  CntrArr.Free;
  SetLength(XomHandle.TypesInfo,0);
  XomHandle.StringTable.Free;
  inherited Destroy;
end;

procedure TXom.ClearSizeType;
var i:integer;
begin
for i:=0 to Length(XomHandle.TypesInfo)-1 do
   XomHandle.TypesInfo[i].Size:=0;
end;

procedure TXom.SetType(Index: Integer; NewGUID: TGUID; XType: XTypes);
var s:string;
begin
  with XomHandle.TypesInfo[Index]do begin
        GUID:=NewGUID;
        FillChar(Name[0], SizeOf(Name),#0);
        StrLCopy(@Name[0],PCharXTypes[XType],31);
  end;
end;

function TXom.GetXType(XName: PChar; var XType: XTypes): Boolean;
var
Xi:XTypes;
begin
Result:=false;
      for Xi:=Low(XTypes) to High(XTypes) do
         if StrLComp(XName,PCharXTypes[Xi],31)=0 then
                begin XType:=Xi; Result:=true; break; end;
end;

function StringListFromStrings(const Strings: array of string;Size:integer): TStringList;
var
  i: Integer;
begin
  Result := TStringList.Create;
  for i := 0 to Size do
    Result.Add(Strings[i]);
end;

function TXom.SearchTypeByName(Name: String; var index: Integer): Boolean;
var i:integer;
begin
Result:=false;
for i:=0 to Length(XomHandle.TypesInfo)-1 do
 if  StrLComp(XomHandle.TypesInfo[i].Name,PChar(Name),31)=0 then begin
   Index:=i;
   Result:= true;
   Break;
  end;
end;

{ TKeyValueList }

constructor TKeyValueList.Create;
begin
  SetLength(FKeys,0);
end;

destructor TKeyValueList.Destroy;
begin
  FKeys:=nil;
  inherited;
end;

function TKeyValueList.GetValue(const Name: string): Integer;
var
  i,n:integer;
begin
  n := Length(FKeys);
  for i:=0 to n-1 do
    if FKeys[i].Key = Name then begin
      Result := FKeys[i].Value;
      Inc(FKeys[i].Value);
      Exit;
    end;
  SetLength(FKeys,n+1);
  FKeys[n].Key := Name;
  FKeys[n].Value := 0;
  Result := FKeys[n].Value;
  Inc(FKeys[n].Value);
end;

procedure TKeyValueList.SetValue(const Name: string; Value: Integer);
var
  i,n:integer;
begin
  n := Length(FKeys);
  for i:=0 to n-1 do
    if FKeys[i].Key = Name then begin
      FKeys[i].Value := Value;
      Exit;
    end;
  SetLength(FKeys, n+1);
  FKeys[n].Key := Name;
  FKeys[n].Value := Value;
end;

end.
