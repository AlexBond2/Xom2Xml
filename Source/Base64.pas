{ unit EncdDecd }
unit Base64;

{ Have string use stream encoding since that logic wraps properly }

interface

uses Classes;

procedure EncodeStream(Input, Output: TStream);
procedure DecodeStream(Input, Output: TStream);
function  EncodePointer(Mem:Pointer; Size: Cardinal): string;
procedure DecodeStreamString(const Input: string; Output: TStream);

implementation

const
  EncodeTable: array[0..63] of Char =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
    'abcdefghijklmnopqrstuvwxyz' +
    '0123456789+/';

  DecodeTable: array[#0..#127] of Integer = (
    Byte('='), 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
    64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
    64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 62, 64, 64, 64, 63,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 64, 64, 64, 64, 64, 64,
    64,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 64, 64, 64, 64, 64,
    64, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 64, 64, 64, 64, 64);

type
  PPacket = ^TPacket;
  TPacket = packed record
    case Integer of
      0: (b0, b1, b2, b3: Byte);
      1: (i: Integer);
      2: (a: array[0..3] of Byte);
      3: (c: array[0..3] of Char);
  end;

procedure EncodePacket(const Packet: TPacket; NumChars: Integer; OutBuf: PChar);
begin
  OutBuf[0] := EnCodeTable[Packet.a[0] shr 2];
  OutBuf[1] := EnCodeTable[((Packet.a[0] shl 4) or (Packet.a[1] shr 4)) and $0000003f];
  if NumChars < 2 then
    OutBuf[2] := '='
  else OutBuf[2] := EnCodeTable[((Packet.a[1] shl 2) or (Packet.a[2] shr 6)) and $0000003f];
  if NumChars < 3 then
    OutBuf[3] := '='
  else OutBuf[3] := EnCodeTable[Packet.a[2] and $0000003f];
end;

function DecodePacket(InBuf: PChar; var nChars: Integer): TPacket;
begin
  Result.a[0] := (DecodeTable[InBuf[0]] shl 2) or
    (DecodeTable[InBuf[1]] shr 4);
  NChars := 1;
  if InBuf[2] <> '=' then
  begin
    Inc(NChars);
    Result.a[1] := Byte((DecodeTable[InBuf[1]] shl 4) or (DecodeTable[InBuf[2]] shr 2));
  end;
  if InBuf[3] <> '=' then
  begin
    Inc(NChars);
    Result.a[2] := Byte((DecodeTable[InBuf[2]] shl 6) or DecodeTable[InBuf[3]]);
  end;
end;

procedure EncodeStream(Input, Output: TStream);
type
  PInteger = ^Integer;
var
  InBuf: array[0..509] of Byte;
  OutBuf: array[0..1023] of Char;
  BufPtr: PChar;
  I, J, K, BytesRead: Integer;
  Packet: TPacket;
begin
  K := 0;
  repeat
    BytesRead := Input.Read(InBuf, SizeOf(InBuf));
    I := 0;
    BufPtr := OutBuf;
    while I < BytesRead do
    begin
      if BytesRead - I < 3 then
        J := BytesRead - I
      else J := 3;
      Packet.i := 0;
      Packet.b0 := InBuf[I];
      if J > 1 then
        Packet.b1 := InBuf[I + 1];
      if J > 2 then
        Packet.b2 := InBuf[I + 2];
      EncodePacket(Packet, J, BufPtr);
      Inc(I, 3);
      Inc(BufPtr, 4);
     { Inc(K, 4);
      if K > 75 then
      begin
        BufPtr[0] := #$0D;
        BufPtr[1] := #$0A;
        Inc(BufPtr, 2);
        K := 0;
      end;  }
    end;
    Output.Write(Outbuf, BufPtr - PChar(@OutBuf));
  until BytesRead = 0;
end;

procedure DecodeStream(Input, Output: TStream);
var
  InBuf: array[0..75] of Char;
  OutBuf: array[0..60] of Byte;
  InBufPtr, OutBufPtr: PChar;
  I, J, K, BytesRead: Integer;
  Packet: TPacket;

  procedure SkipWhite;
  var
    C: Char;
    NumRead: Integer;
  begin
    while True do
    begin
      NumRead := Input.Read(C, 1);
      if NumRead = 1 then
      begin
        if C in ['0'..'9','A'..'Z','a'..'z','+','/','='] then
        begin
          Input.Position := Input.Position - 1;
          Break;
        end;
      end else Break;
    end;
  end;

  function ReadInput: Integer;
  var
    WhiteFound, EndReached : Boolean;
    CntRead, Idx, IdxEnd: Integer;
  begin
    IdxEnd:= 0;
    repeat
      WhiteFound := False;
      CntRead := Input.Read(InBuf[IdxEnd], (SizeOf(InBuf)-IdxEnd));
      EndReached := CntRead < (SizeOf(InBuf)-IdxEnd);
      Idx := IdxEnd;
      IdxEnd := CntRead + IdxEnd;
      while (Idx < IdxEnd) do
      begin
        if not (InBuf[Idx] in ['0'..'9','A'..'Z','a'..'z','+','/','=']) then
        begin
          Dec(IdxEnd);
          if Idx < IdxEnd then
            Move(InBuf[Idx+1], InBuf[Idx], IdxEnd-Idx);
          WhiteFound := True;
        end
        else
          Inc(Idx);
      end;
    until (not WhiteFound) or (EndReached);
    Result := IdxEnd;
  end;

begin
  repeat
    SkipWhite;
    {
    BytesRead := Input.Read(InBuf, SizeOf(InBuf));
    }
    BytesRead := ReadInput;
    InBufPtr := InBuf;
    OutBufPtr := @OutBuf;
    I := 0;
    while I < BytesRead do
    begin
      Packet := DecodePacket(InBufPtr, J);
      K := 0;
      while J > 0 do
      begin
        OutBufPtr^ := Char(Packet.a[K]);
        Inc(OutBufPtr);
        Dec(J);
        Inc(K);
      end;
      Inc(InBufPtr, 4);
      Inc(I, 4);
    end;
    Output.Write(OutBuf, OutBufPtr - PChar(@OutBuf));
  until BytesRead = 0;
end;

function EncodePointer(Mem:Pointer; Size: Cardinal): string;

var
  InStr, OutStr: TStringStream;
  InMem:TMemoryStream;
  SBase64:TStringStream;
begin
  InMem := TMemoryStream.Create();
  InMem.Write(Mem^, Size);
  InMem.Position:=0;
  try
    OutStr := TStringStream.Create('');
    try
      EncodeStream(InMem, OutStr);
      Result := OutStr.DataString;
    finally
      OutStr.Free;
    end;
  finally
    InMem.Free;
  end;
end;

procedure DecodeStreamString(const Input: string; Output: TStream);

var
  InStr: TStringStream;
begin
  InStr := TStringStream.Create(Input);
  try
    DecodeStream(InStr, Output);
  finally
    InStr.Free;
  end;
end;

end.
