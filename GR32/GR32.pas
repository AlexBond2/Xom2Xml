unit GR32;

(* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1 or LGPL 2.1 with linking exception
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * Alternatively, the contents of this file may be used under the terms of the
 * Free Pascal modified version of the GNU Lesser General Public License
 * Version 2.1 (the "FPC modified LGPL License"), in which case the provisions
 * of this license are applicable instead of those above.
 * Please see the file LICENSE.txt for additional information concerning this
 * license.
 *
 * The Original Code is Graphics32
 *
 * The Initial Developer of the Original Code is
 * Alex A. Denisov
 *
 * Portions created by the Initial Developer are Copyright (C) 2000-2009
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *   Michael Hansen <dyster_tid@hotmail.com>
 *   Andre Beckedorf <Andre@metaException.de>
 *   Mattias Andersson <mattias@centaurix.com>
 *   J. Tulach <tulach at position.cz>
 *   Jouni Airaksinen <markvera at spacesynth.net>
 *   Timothy Weber <teejaydub at users.sourceforge.net>
 *
 * ***** END LICENSE BLOCK ***** *)

interface

{$I GR32.inc}

uses
  Classes, SysUtils, Windows;

type

//----- Only main types of GR32 module -------

  PColor32 = ^TColor32;
  TColor32 = type Cardinal;

  PColor32Array = ^TColor32Array;
  TColor32Array = array [0..0] of TColor32;
  TArrayOfColor32 = array of TColor32;

  TColor32Component = (ccBlue, ccGreen, ccRed, ccAlpha);
  TColor32Components = set of TColor32Component;

  PColor32Entry = ^TColor32Entry;
  TColor32Entry = packed record
    case Integer of
      0: (B, G, R, A: Byte);
      1: (ARGB: TColor32);
      2: (Planes: array[0..3] of Byte);
      3: (Components: array[TColor32Component] of Byte);
  end;

  PColor32EntryArray = ^TColor32EntryArray;
  TColor32EntryArray = array [0..0] of TColor32Entry;
  TArrayOfColor32Entry = array of TColor32Entry;

  PPalette32 = ^TPalette32;
  TPalette32 = array [Byte] of TColor32;

  // TFloat determines the precision level for certain floating-point operations
  PFloat = ^TFloat;
  TFloat = Single;

// Compact TCustomBitmap32 by AlexBond

  AByte = array of Byte;

  TCustomBitmap32 = class(TPersistent)
  private
    FBits: PColor32Array;
    function GetPixelPtr(X, Y: Integer): PColor32;
    function GetScanLine(Y: Integer): PColor32Array;
  protected
    FHeight: Integer;
    FWidth: Integer;
    procedure SetHeight(NewHeight: Integer); virtual;
    procedure SetWidth(NewWidth: Integer); virtual;
  public
    constructor Create;
    destructor Destroy;
    procedure Delete;

    property Height: Integer read FHeight write SetHeight;
    property Width: Integer read FWidth write SetWidth;

    property PixelPtr[X, Y: Integer]: PColor32 read GetPixelPtr;
    property ScanLine[Y: Integer]: PColor32Array read GetScanLine;

    property Bits: PColor32Array read FBits;
    
    function SetSize(NewWidth, NewHeight: Integer): Boolean; virtual;
  end;

// Custom TBitmaps32 by AlexBond

  TBitmap32 = class(TCustomBitmap32)
  private
    FNumMipMaps: Integer;
    FPalette: PPalette32;
    FIndexes: AByte;
    FMipMaps: array of PColor32Array;
  public
    constructor Create;
    destructor Destroy;
    procedure LoadFromData(Data: Pointer; Width, Height, ColorBits, MipMaps: Integer; Palette: Pointer);
    procedure LoadFromBlocks(Data: Pointer);
    procedure LoadFromBlock32(Data: Pointer);
    procedure DrawBlock(X, Y: Integer; Bitmap: TBitmap32);
    procedure SaveBlock64(Data: TStream; X, Y :Integer);
    procedure SaveBlock32(Data: TStream);
    function GenMipMaps: Integer;
    procedure FreeMipMaps;
    procedure SaveToStream(Data: TStream; ColorBits: Integer);
    function LoadPaletteFromTGA(Stream, Data: TStream): Boolean;
    procedure LoadFromTGA(Stream: TStream);
    procedure SaveToTGA(Stream: TStream; ColorBits, IndexColors: Integer; RLE: Boolean = True);
    procedure LoadFromPNG(Stream: TStream);
    procedure SaveToPNG(Stream: TStream);
    procedure LoadFromDDS(Stream: TStream);
    procedure SaveToDDS(Stream: TStream; ColorBits: Integer);
    property NumMipMaps: Integer read FNumMipMaps;
  end;

implementation

uses
  Math, GR32_Png;

{ TCustomBitmap32 }

constructor TCustomBitmap32.Create;
begin
  inherited;
end;

procedure TCustomBitmap32.Delete;
begin
  inherited;
  FWidth := 0;
  FHeight := 0;
  FreeMem(FBits);
end;

destructor TCustomBitmap32.Destroy;
begin
  FreeMem(FBits);
  inherited;
end;

function TCustomBitmap32.GetPixelPtr(X, Y: Integer): PColor32;
begin
  Result := @Bits[X + Y * Width];
end;

function TCustomBitmap32.GetScanLine(Y: Integer): PColor32Array;
begin
  Result := @Bits[Y * FWidth];
end;

procedure TCustomBitmap32.SetHeight(NewHeight: Integer);
begin
  SetSize(Width, NewHeight);
end;

function TCustomBitmap32.SetSize(NewWidth, NewHeight: Integer): Boolean;
var
  DataSize: Integer;
begin
  if NewWidth < 0 then NewWidth := 0;
  if NewHeight < 0 then NewHeight := 0;
  Result := (NewWidth <> FWidth) or (NewHeight <> FHeight);
  if Result then
  begin
    FWidth := NewWidth;
    FHeight := NewHeight;
    // Bits
    if (FWidth>0) and (FHeight>0) then begin
      DataSize := FWidth * FHeight * Sizeof(TColor32);
      If FBits <> nil then Dispose(FBits);
      FBits := AllocMem(DataSize);
    end;
  end;
end;

procedure TCustomBitmap32.SetWidth(NewWidth: Integer);
begin
  SetSize(NewWidth, Height);
end;

{ TBitmap32 }

constructor TBitmap32.Create;
begin
  inherited;
end;

procedure TBitmap32.FreeMipMaps;
var l, i:Integer;
begin
  l := Length(FMipMaps)-1;
  for i:=0 to l do
    FreeMem(FMipMaps[i]);
  SetLength(FMipMaps,0);
  FNumMipMaps := 0;
end;

destructor TBitmap32.Destroy;
var i:integer;
begin
  FreeMipMaps;
  SetLength(FIndexes, 0);
  inherited;
end;

// Portable Network Graphics

procedure TBitmap32.LoadFromPNG(Stream: TStream);
begin
  LoadBitmap32FromPNG(self, Stream);
end;

procedure TBitmap32.SaveToPNG(Stream: TStream);
begin
  SaveBitmap32ToPNG(self, Stream);
end;

//  Truevision Graphics Adapter

type

  TGAHeader = packed record
    IDLength: Byte;
    ColorMapType: Byte;
    ImageType: Byte;
    ColourMapOrigin: Word;
    ColourMapLength: Word;
    ColourMapDepth: Byte;
    xOrigin: Word;
    yOrigin: Word;
    Width: Word;
    Height: Word;
    BitsPerPixel: Byte;
    ImageDescriptor: Byte;
  end;

procedure EncodeRLE(var Pixels: AByte; Width, Height, PixelSize: Integer);
var
  i, c, y, ScanLineSize, Pos, Len, Count, CountBpp: integer;
  Chunk: Byte;
  Compressed, RowData: AByte;
  Zero, IsRLE: Boolean;
  Pixel, NextPixel: TColor32;
begin
  Len := Length(Pixels);
  SetLength(Compressed, Len*2);
  c := 0;

  Pixel := 0;
  NextPixel := 0;

  ScanLineSize := Width * PixelSize;
  SetLength(RowData, ScanLineSize);
  Count := 0;
  for y := 0 to Height-1 do
  begin
    Pos := 0;
    Move(Pixels[y * ScanLineSize], RowData[0], ScanLineSize);

    while (Pos < ScanLineSize) do
    begin
    if (Pos >= ScanLineSize - PixelSize) then
    begin
      Compressed[c]:=0; Inc(c);
      Move(RowData[Pos], Compressed[c], PixelSize);  Inc(c, PixelSize);
      Inc(Pos, PixelSize);
      break;
    end;

    Count := 1;
    Move(RowData[Pos], Pixel, PixelSize);
    Move(RowData[Pos + PixelSize], NextPixel, PixelSize);
    IsRLE := (Pixel = NextPixel);

    i := Pos + PixelSize;
    while  ( i < Math.Min(Pos + 128 * PixelSize, ScanLineSize) - PixelSize) do
    begin
      if IsRLE then
      Move(RowData[Pos], Pixel, PixelSize)
      else
      Move(RowData[i], Pixel, PixelSize);
      Move(RowData[i + PixelSize], NextPixel, PixelSize);

      if (IsRLE xor (Pixel = NextPixel)) then
      begin
      if (Pixel = NextPixel) then Dec(Count);
      break;
      end
      else
      Inc(Count);

      Inc(i, PixelSize);
    end;

    CountBpp := (Count + 1) * PixelSize;
    if IsRLE then begin
      Compressed[c]:= Count or 128; Inc(c);
      Move(RowData[Pos], Compressed[c], PixelSize);  Inc(c, PixelSize);
    end else begin
      Compressed[c]:= Count; Inc(c);
      Move(RowData[Pos], Compressed[c], CountBpp);  Inc(c, CountBpp);
    end;

    Inc(Pos, CountBpp);
    end;
  end;
  
  SetLength(Compressed, c);
  SetLength(RowData, 0);
  SetLength(Pixels, 0);
  Pixels := Compressed;
end;

procedure TBitmap32.SaveToTGA(Stream: TStream; ColorBits, IndexColors: Integer; RLE: Boolean = True);
var
  Tga: TGAHeader;
  x,y,p: Integer;
  Pixel: PColor32;
  PixelSize, Count: Integer;
  Index: Byte;
  Pixels: AByte;

begin
  ZeroMemory(@Tga, SizeOf(TGAHeader));
  if RLE then
    Tga.ImageType := 8;
  if ColorBits > 8 then
    Tga.ImageType := Tga.ImageType or 2 // true-color image
  else begin
    Tga.ImageType := Tga.ImageType or 1; // color-mapped image
    Tga.ColorMapType := 1;
    Tga.ColourMapOrigin := 0;
    Tga.ColourMapLength := IndexColors;
    Tga.ColourMapDepth := 32;
  end;

  Tga.Width := FWidth;
  Tga.Height := FHeight;
  Tga.BitsPerPixel := ColorBits;
  Stream.Write(Tga, SizeOf(TGAHeader));

  PixelSize := ColorBits div 8;
  SetLength(Pixels, FHeight * FWidth * PixelSize);

  if PixelSize = 1 then begin
   for x:=0 to Tga.ColourMapLength-1 do begin
    Stream.Write(TColor32Entry(FPalette[x]).R, 1);
    Stream.Write(TColor32Entry(FPalette[x]).G, 1);
    Stream.Write(TColor32Entry(FPalette[x]).B, 1);
    Stream.Write(TColor32Entry(FPalette[x]).A, 1);
   end;
  end;

  Count := 0;
  for y := FHeight - 1 downto 0 do
    for x := 0 to FWidth - 1 do
    begin
      if PixelSize = 1 then begin
        Index := FIndexes[x + y*FWidth];
        Pixels[Count] := Index; Inc(Count);
      end else begin
        Pixel := PixelPtr[x, y];
        Move(Pixel^, Pixels[Count], PixelSize);
        Inc(Count, PixelSize);
      end;
    end;

 if RLE then
   EncodeRLE(Pixels, FWidth, FHeight, PixelSize);

  Stream.Write(Pixels[0], Length(Pixels));
end;

Function TBitmap32.LoadPaletteFromTGA(Stream, Data: TStream):Boolean;
var
  Tga: TGAHeader;
  i, PixelSize: integer;
  Color: TColor32Entry;
begin
  Stream.Read(Tga, sizeOf(TGAHeader));
  if Tga.ImageType and 1 = 1 then begin
  PixelSize := Tga.ColourMapDepth div 8;
    for i := 0 to Tga.ColourMapLength-1 do begin
     Stream.Read(Color, PixelSize);
     Data.Write(Color.R, 1);
     Data.Write(Color.G, 1);
     Data.Write(Color.B, 1);
     Data.Write(Color.A, 1);
    end;
    Result := True;
  end else
    Result := False;
end;

procedure DecodeRLE(Stream: TStream; var Pixels:AByte; Width, Height, PixelSize:Integer);
var
  x, y, i, counter: integer;
  chunkHeader: byte;
  Color: TColor32;
begin
  y := 0;
  x := 0;
  i := 0;
  while y < Height do
  begin //repeat
    Stream.Read(chunkHeader,1);
    if chunkHeader < 128 then //array of colors
    begin
    Inc(chunkHeader);
    for counter := 0 to chunkHeader -1 do
    begin
      if x > Width - 1 then
      begin
      Inc(y);
      if y = Height then Break;
      x := 0;
      end;
      Stream.Read(Pixels[i], PixelSize);
      Inc(i, PixelSize);
      Inc(x);
    end;
    end
    else  //repeat color
    begin
    chunkHeader := chunkHeader - 127;
    Stream.Read(Color, PixelSize);
    for counter:=0 to chunkHeader -1 do
    begin
      if x > Width - 1 then
      begin
      Inc(y);
      if y = Height then Break;
      x := 0;
      end;
      Move(Color, Pixels[i], PixelSize);
      Inc(i, PixelSize);
      Inc(x);
    end;
    end;
  end;
end;

procedure TBitmap32.LoadFromTGA(Stream: TStream);
var
  x, y, i, counter: integer;
  chunkHeader: byte;
  Tga: TGAHeader;
  Pixel: PColor32;
  Color: TColor32Entry;
  PixelSize, PalSize, Index: Integer;
  Palette: array of TColor32;
  Pixels: AByte;
begin

  Stream.Read(Tga, sizeOf(TGAHeader));

  SetSize(Tga.Width, Tga.Height);
  PixelSize := Tga.BitsPerPixel div 8;

  SetLength(Pixels, Tga.Width * Tga.Height * PixelSize);

  if Tga.ImageType and 2 = 2 then  // true-color image
  begin
    if Tga.ImageType and 8 = 8 then // RLE
       DecodeRLE(Stream, Pixels, Tga.Width, Tga.Height, PixelSize)
    else
       Stream.Read(Pixels[0],Length(Pixels));
    i := 0;
    for y := Tga.Height - 1 downto 0 do
    begin
      for x := 0 to Tga.Width - 1 do
      begin
        Pixel := PixelPtr[x,y];
        Move(Pixels[i],Pixel^, PixelSize); Inc(i, PixelSize);
        if PixelSize = 3 then TColor32Entry(Pixel^).A := 255;
      end;
    end;
  end
  else if Tga.ImageType and 1 = 1 then  // color-mapped image
  begin
    SetLength(Palette, Tga.ColourMapLength);
    SetLength(FIndexes, Tga.Height * Tga.Width);
    PalSize := Tga.ColourMapDepth div 8;
    for i := 0 to Tga.ColourMapLength-1 do
     Stream.Read(Palette[i], PalSize);
    if Tga.ImageType and 8 = 8 then // RLE
       DecodeRLE(Stream, Pixels, Tga.Width, Tga.Height, PixelSize)
    else
       Stream.Read(Pixels[0],Length(Pixels));
    i := 0;
    for y := Tga.Height - 1 downto 0 do
    begin
      for x := 0 to Tga.Width - 1 do
      begin
        Pixel := PixelPtr[x,y];
        Index := Pixels[i]; Inc(i);
        FIndexes[x +  y * Tga.Width] := Index;
        Pixel^ := Palette[Index];
        if PalSize = 3 then TColor32Entry(Pixel^).A := 255;
      end;
    end;
  end;
end;

procedure TBitmap32.DrawBlock(X, Y: Integer; Bitmap: TBitmap32);
var
 i, xin, j, yin, MWidth, MHeight: Integer;
 PixelIn, PixelOut: PColor32;
begin
 MWidth := X + Bitmap.Width;
 MHeight := Y + Bitmap.Height;
 yin := 0;
 for j := Y to MHeight - 1 do begin
  PixelOut := PixelPtr[X, j];
  PixelIn := Bitmap.PixelPtr[0, yin];
  Move(PixelIn^, PixelOut^, Bitmap.Width * 4);
  inc(yin);
 end;

end;

// Blocks 8x8

procedure TBitmap32.LoadFromBlocks(Data: Pointer);
var
 x, y, i, j : Integer;
 Pixel: PColor32;
 Color: TColor32Entry;
 Color16: Word;
begin
  for j:=0 to 7 do
    for i:=0 to 7 do
      for y:=0 to 7 do
        for x:=0 to 7 do
          begin
            Pixel := @Bits[(i * 8 + x) + (j * 8 + y) * Width];
            Color16 := Word(Data^);
            Color.R := (Color16 and $1F) * 8;
            Color.G := ((Color16 shr 5) and $1F) * 8;
            Color.B := ((Color16 shr 10) and $1F) * 8;
            Color.A := (Color16 shr 15) * $FF;
            Inc(LongWord(Data), 2);
            TColor32Entry(Pixel^) := Color;
          end;
end;

procedure TBitmap32.SaveBlock64(Data: TStream; X, Y :Integer );
var
 i, j, xb, yb : Integer;
 Pixel: PColor32;
 Color: TColor32Entry;
 Color16: Word;

  function Ato1(A: Byte): Byte;
  begin
  if A > 127 then
    Result := 1
  else
    Result := 0;
  end;

begin
  for j:=0 to 7 do
    for i:=0 to 7 do
      for yb:=0 to 7 do
        for xb:=0 to 7 do
          begin
            Pixel := PixelPtr[X + i * 8 + xb, Y + j * 8 + yb];
            Color := TColor32Entry(Pixel^);
            Color16 := (Color.R div 8) or
              ((Color.G div 8) shl 5) or
              ((Color.B div 8) shl 10) or
              ( Ato1(Color.A) shl 15);
            Data.Write(Color16, 2);
          end;
end;

// block 32x32

procedure TBitmap32.SaveBlock32(Data: TStream);
var
 i, j, Index : Integer;
begin
 for j := FHeight-1 downto 0 do
   for i := 0 to FWidth-1 do
     begin
       Index := FIndexes[i + j * FWidth] + 128;
       Data.Write(Index, 1);
     end;
end;

procedure TBitmap32.LoadFromBlock32(Data: Pointer);
var
 i, j, xb, yb, Index: Integer;
 Palette: Pointer;
 Pixel: PColor32;
 Color, PColor: TColor32Entry;
begin
 SetSize(32, 32);
 SetLength(FIndexes, 32 * 32);
 Palette:= Pointer(LongWord(Data)+Length(FIndexes));
 FPalette := Palette;
  for j:=31 downto 0 do
    for i:=0 to 31 do
      begin
        Pixel := PixelPtr[i, j];
        Index:= Byte(Data^) - 128;
        FIndexes[i + j * 32] := Index;
        PColor := TColor32Entry(FPalette[Index]);
        Color.R := PColor.B;
        Color.G := PColor.G;
        Color.B := PColor.R;
        Color.A := PColor.A;
        Inc(LongWord(Data));
        TColor32Entry(Pixel^) := Color;
      end; 
end;

// BGR Image

procedure TBitmap32.LoadFromData(Data: Pointer; Width, Height,
  ColorBits: Integer; MipMaps: Integer; Palette: Pointer);
var
 PixelSize, i, MWidth, MHeight: Integer;
 Pixels: PColor32Array;

 procedure ReadDataBGR(dWidth, dHeight:Integer);
 var
 x, y : Integer;
 Pixel: PColor32;
 Color: TColor32Entry;
 begin
    for y := dHeight - 1 downto 0 do
    for x := 0 to dWidth - 1 do
    begin
      Pixel := @Pixels[x + y * dWidth];
      Color.R := TColor32Entry(Data^).B;
      Color.G := TColor32Entry(Data^).G;
      Color.B := TColor32Entry(Data^).R;
      if PixelSize = 4 then
         Color.A := TColor32Entry(Data^).A
      else
         Color.A := 255;
      Inc(LongWord(Data),PixelSize);
      TColor32Entry(Pixel^) := Color;
    end;
 end;

 procedure ReadDataBGRP(dWidth, dHeight:Integer);
 var
 x, y, i, j, blockW, blockH : Integer;
 Pixel: PColor32;
 Color, PColor: TColor32Entry;
 Index: Byte;
 bWidth, bHeight: Integer;
 begin
  if Palette <> nil then
  begin
  // PixelSize := (Palette.Size div 256);
   SetLength(FIndexes, dWidth * dHeight);

   blockW := 16;
   if FWidth < 16 then blockW := 8;
   blockH := 8;

   FPalette := Palette;
   bWidth := FWidth div blockW;
   bHeight := FHeight div blockH;

   for y := bHeight - 1 downto 0 do
    for x := 0 to bWidth - 1 do
     for j := blockH-1 downto 0 do
      for i := 0 to blockW-1 do
       begin
      Pixel := PixelPtr[x * blockW + i, y * blockH + j];
      Index := Byte(Data^);
      FIndexes[x * blockW + i + (y * blockH + j)* dWidth] := Index;
      PColor := TColor32Entry(FPalette[Index]);
      Color.R := PColor.B;
      Color.G := PColor.G;
      Color.B := PColor.R;
      Color.A := PColor.A;
      Inc(LongWord(Data));
      TColor32Entry(Pixel^) := Color;
    end;

  end;
 end;

begin
  SetSize(Width, Height);
  PixelSize := ColorBits div 8;
  Pixels := FBits;
  if (PixelSize = 1) then
    ReadDataBGRP(FWidth, FHeight)
  else
    ReadDataBGR(FWidth, FHeight);

  If MipMaps>1 then begin
    MWidth := Width;
    MHeight := Height;
    FreeMipMaps;
    FNumMipMaps := MipMaps-1;
    SetLength(FMipMaps, FNumMipMaps);
    for i:=0 to FNumMipMaps-1 do begin
      MWidth := MWidth div 2;
      if MWidth = 0 then MWidth := 1;
      MHeight := MHeight div 2;
      if MHeight = 0 then MHeight := 1;
      Pixels := AllocMem(MWidth * MHeight * Sizeof(TColor32));
      ReadDataBGR(MWidth, MHeight);
      FMipMaps[i] := Pixels;
    end;
  end;

end;

procedure DownScale(srcData: Pointer; pixelSize, srcWidth, srcHeight,
        dstWidth, dstHeight: Integer; dstData: Pointer);

type
  PPix = ^TPix;
  TPix = array [0..0] of Byte;
  
var
  x, y, ix, iy: integer;
  px, pxS, pxD: integer;
  iRatio: Single;
  pt, pt1: PPix;
  iSrc, iDst: integer;
  RowDest, RowSource, RowSourceStart: LongWord;
  w, h, p: integer;
  dx, dy: integer;
  iPix: array of Longword;

begin

  w := dstWidth;
  h := dstHeight;
  p := pixelSize;

  iDst := dstWidth * p;
  iSrc := srcWidth * p;

  dx := srcWidth div w;
  dy := srcHeight div h;

  SetLength(iPix, p);

  dec(w); dec(h); dec(p);

  RowDest := LongWord(dstData);
  RowSourceStart := LongWord(srcData);
  RowSource := RowSourceStart;

  for y := 0 to h do
  begin
    pxS := 0; pxD := 0;
    for x := 0 to w do
    begin
      for px:=0 to p do
        iPix[px] := 0;
      RowSource := RowSourceStart;
      for iy := 1 to dy do
      begin
        pt := PPix(RowSource + pxS);
        for ix := 1 to dx do
        begin
          for px:=0 to p do
            iPix[px] := iPix[px] + pt[px];
          inc(LongWord(pt), pixelSize);
        end;
        inc(RowSource, iSrc);
      end;
      iRatio := 1.0 / (dx * dy);
      pt1 := PPix(RowDest + pxD);
      for px:=0 to p do
         pt1[px] := trunc(iPix[px] * iRatio);
      inc(pxS, pixelSize * dx);
      inc(pxD, pixelSize);
    end;
    inc(RowDest, iDst);
    RowSourceStart := RowSource;
  end;

end;

function TBitmap32.GenMipMaps:Integer;
var
 i, nMM, PixelSize, Maps, MaxMaps, MWidth, MHeight: Integer;
 mData, sData: Pointer;
begin
  PixelSize := 4;

  Maps  := Max(FWidth, FHeight);
  MaxMaps := Round(Log2(Maps));

  Result := FNumMipMaps;

  if MaxMaps = FNumMipMaps then exit;
  nMM := FNumMipMaps;
  FNumMipMaps := MaxMaps;

  MWidth := FWidth;
  MHeight := FHeight;

  sData := FBits;
  SetLength(FMipMaps, FNumMipMaps);
  for i := 0 to FNumMipMaps - 1 do
  begin
    MWidth  := MWidth div 2;
    if MWidth = 0 then MWidth := 1;
    MHeight := MHeight div 2;
    if MHeight = 0 then MHeight := 1;
    if i < nMM then continue;
    mData := AllocMem(MWidth * MHeight * Sizeof(TColor32));
    DownScale(sData, PixelSize, FWidth, FHeight, MWidth, MHeight, mData);
    FMipMaps[i] := mData;
  end;
  Result := FNumMipMaps;
end;

procedure TBitmap32.SaveToStream(Data: TStream; ColorBits: Integer);
var
 i, PixelSize, Maps, NMaps, MWidth, MHeight: Integer;
 Pixels: PColor32Array;

 procedure WriteBGRP(dWidth, dHeight: Integer);
 var
 i, j, x, y, bWidth, bHeight, blockW, blockH : Integer;
 Index: Byte;
 begin

  blockW := 16;
  blockH := 8;
  if dWidth < 16 then blockW := 8;

   bWidth := dWidth div blockW;
   bHeight := dHeight div blockH;

   for y := bHeight - 1 downto 0 do
    for x := 0 to bWidth - 1 do
     for j := blockH-1 downto 0 do
      for i := 0 to blockW-1 do
       begin
       Index := FIndexes[x * blockW + i + (y * blockH + j)* dWidth];
       Data.Write(Index, 1);
       end;

 end;

 procedure WriteBGR(dWidth, dHeight: Integer);
 var
 x, y : Integer;
 Pixel: PColor32;
 Color: TColor32Entry;
 begin
  for y := dHeight - 1 downto 0 do
    for x := 0 to dWidth - 1 do
    begin
      Pixel := @Pixels[x + y * dWidth];
      Color.R := TColor32Entry(Pixel^).B;
      Color.G := TColor32Entry(Pixel^).G;
      Color.B := TColor32Entry(Pixel^).R;
      if PixelSize = 4 then
         Color.A := TColor32Entry(Pixel^).A;
      Data.Write(Color, PixelSize);
    end;
 end;

begin
  PixelSize := ColorBits div 8;
  Pixels := FBits;

  if (PixelSize = 1) then
    WriteBGRP(FWidth, FHeight)
  else
    WriteBGR(FWidth, FHeight);

  MWidth := FWidth;
  MHeight := FHeight;

  for i := 0 to FNumMipMaps - 1 do
  begin
    Pixels := FMipMaps[i];
    MWidth  := MWidth div 2;
    if MWidth = 0 then MWidth := 1;
    MHeight := MHeight div 2;
    if MHeight = 0 then MHeight := 1;
    WriteBGR(MWidth, MHeight);
  end;
end;

// DirectDraw Surface
{ Types from ImagingDds.pas https://github.com/galfar/imaginglib }

type
  Uint32 = Cardinal;
  Int32 = Integer;

const

  { Constants used by TDDSPixelFormat.Flags.}
  DDPF_ALPHAPIXELS     = $00000001;    // used by formats which contain alpha
  DDPF_FOURCC          = $00000004;    // used by DXT and large ARGB formats
  DDPF_RGB             = $00000040;    // used by RGB formats
  DDPF_LUMINANCE       = $00020000;    // used by formats like D3DFMT_L16
  DDPF_BUMPLUMINANCE   = $00040000;    // used by mixed signed-unsigned formats
  DDPF_BUMPDUDV        = $00080000;    // used by signed formats

  { Four character codes.}
  DDSMagic    = UInt32(Byte('D') or (Byte('D') shl 8) or (Byte('S') shl 16) or
    (Byte(' ') shl 24));

  { Constants used by TDDSurfaceDesc2.Flags.}
  DDSD_CAPS            = $00000001;
  DDSD_HEIGHT          = $00000002;
  DDSD_WIDTH           = $00000004;
  DDSD_PITCH           = $00000008;
  DDSD_PIXELFORMAT     = $00001000;
  DDSD_MIPMAPCOUNT     = $00020000;
  DDSD_LINEARSIZE      = $00080000;
  DDSD_DEPTH           = $00800000;

  { Flags for TDDSurfaceDesc2.Flags used when saving DDS file.}
  DDS_SAVE_FLAGS = DDSD_CAPS or DDSD_PIXELFORMAT or DDSD_WIDTH or
    DDSD_HEIGHT or DDSD_LINEARSIZE;

  { Constants used by TDDSCaps.Caps1.}
  DDSCAPS_COMPLEX      = $00000008;
  DDSCAPS_TEXTURE      = $00001000;
  DDSCAPS_MIPMAP       = $00400000;

type
  { Stores the pixel format information.}
  TDDPixelFormat = packed record
    Size: UInt32;       // Size of the structure = 32 bytes
    Flags: UInt32;      // Flags to indicate valid fields
    FourCC: UInt32;     // Four-char code for compressed textures (DXT)
    BitCount: UInt32;   // Bits per pixel if uncomp. usually 16,24 or 32
    RedMask: UInt32;    // Bit mask for the Red component
    GreenMask: UInt32;  // Bit mask for the Green component
    BlueMask: UInt32;   // Bit mask for the Blue component
    AlphaMask: UInt32;  // Bit mask for the Alpha component
  end;

  { Specifies capabilities of surface.}
  TDDSCaps = packed record
    Caps1: UInt32;      // Should always include DDSCAPS_TEXTURE
    Caps2: UInt32;      // For cubic environment maps
    Reserved: array[0..1] of UInt32; // Reserved
  end;

  { Record describing DDS file contents.}
  TDDSurfaceDesc2 = packed record
    Size: UInt32;       // Size of the structure = 124 Bytes
    Flags: UInt32;      // Flags to indicate valid fields
    Height: UInt32;     // Height of the main image in pixels
    Width: UInt32;      // Width of the main image in pixels
    PitchOrLinearSize: UInt32; // For uncomp formats number of bytes per
                               // scanline. For comp it is the size in
                               // bytes of the main image
    Depth: UInt32;      // Only for volume text depth of the volume
    MipMaps: Int32;     // Total number of levels in the mipmap chain
    Reserved1: array[0..10] of UInt32; // Reserved
    PixelFormat: TDDPixelFormat; // Format of the pixel data
    Caps: TDDSCaps;       // Capabilities
    Reserved2: UInt32;  // Reserved
  end;

  { DDS file header.}
  TDDSFileHeader = packed record
    Magic: UInt32;       // File format magic
    Desc: TDDSurfaceDesc2; // Surface description
  end;

procedure TBitmap32.LoadFromDDS(Stream: TStream);
var
 Hdr: TDDSFileHeader;
 PixelSize, i, MWidth, MHeight: Integer;
 Pixels: PColor32Array;

 procedure ReadDataRGB(dWidth, dHeight:Integer);
 var
 x, y : Integer;
 Pixel: PColor32;
 Color: TColor32Entry;
 begin
  for y := 0 to dHeight - 1 do
    for x := 0 to dWidth - 1 do
    begin
      Pixel := @Pixels[x + y * dWidth];
      Stream.Read(Pixel^, PixelSize);
      if PixelSize = 3 then TColor32Entry(Pixel^).A := 255;
    end;
 end;

begin
  Stream.Read( Hdr, SizeOf(TDDSFileHeader));
  With Hdr, Hdr.Desc.PixelFormat do begin
  SetSize(Desc.Width, Desc.Height);
  PixelSize:=0;
  if (Flags and DDPF_RGB) = DDPF_RGB then
    begin
      // Handle RGB formats
      if (Flags and DDPF_ALPHAPIXELS) = DDPF_ALPHAPIXELS then
      begin
        // Handle RGB with alpha formats
        If BitCount = 32 then   // A8R8G8B8
        begin
          // BlueMask = $00FF0000
          PixelSize := 4;
        end;
      end else
      begin
        If BitCount = 24 then  // R8G8B8
        begin
          PixelSize := 3;
        end;
      end;
   end;

  If PixelSize = 0 then exit;
  Pixels := FBits;
  ReadDataRGB(Desc.Width, Desc.Height);

  if Desc.MipMaps>1 then begin
    // Read MipMaps
    MWidth := Width;
    MHeight := Height;
    FreeMipMaps;
    FNumMipMaps := Desc.MipMaps - 1;
    SetLength(FMipMaps, FNumMipMaps);
    for i:=0 to FNumMipMaps-1 do begin
      MWidth := MWidth div 2;
      if MWidth = 0 then MWidth := 1;
      MHeight := MHeight div 2;
      if MHeight = 0 then MHeight := 1;
      Pixels := AllocMem(MWidth * MHeight * Sizeof(TColor32));
      ReadDataRGB(MWidth, MHeight);
      FMipMaps[i] := Pixels;
    end;
  end;

  end;
end;

procedure TBitmap32.SaveToDDS(Stream: TStream; ColorBits: Integer);
var
  Hdr: TDDSFileHeader;
 i, PixelSize, Maps, NMaps, MWidth, MHeight: Integer;
 Pixels: PColor32Array;

 procedure WriteRGB(dWidth, dHeight: Integer);
 var
 x, y : Integer;
 Pixel: PColor32;
 Color: TColor32Entry;
 begin
  for y := 0 to dHeight - 1 do
    for x := 0 to dWidth - 1 do
    begin
      Pixel := @Pixels[x + y * dWidth];
      Stream.Write(Pixel^, PixelSize);
    end;
 end;

begin
  FillChar(Hdr, Sizeof(Hdr), 0);
  PixelSize := ColorBits div 8;
  with Hdr do begin
    Magic := DDSMagic;
    Desc.Size := SizeOf(Desc);
    Desc.Width := FWidth;
    Desc.Height := FHeight;
    Desc.Flags := DDS_SAVE_FLAGS;
    Desc.Caps.Caps1 := DDSCAPS_TEXTURE;
    Desc.PixelFormat.Size := SizeOf(Desc.PixelFormat);
    Desc.PitchOrLinearSize := FWidth * FHeight * PixelSize;

    if FNumMipMaps > 0 then
    begin
      // Set proper flags if we have some mipmaps to be saved
      Desc.Flags := Desc.Flags or DDSD_MIPMAPCOUNT;
      Desc.Caps.Caps1 := Desc.Caps.Caps1 or DDSCAPS_MIPMAP or DDSCAPS_COMPLEX;
      Desc.MipMaps := FNumMipMaps + 1;
    end;

    Desc.PixelFormat.Flags := DDPF_RGB;
    Desc.PixelFormat.BitCount := ColorBits;

    Desc.PixelFormat.RedMask :=   $00FF0000;
    Desc.PixelFormat.GreenMask := $0000FF00;
    Desc.PixelFormat.BlueMask :=  $000000FF;

    if PixelSize = 4 then
      begin
        Desc.PixelFormat.Flags := Desc.PixelFormat.Flags or DDPF_ALPHAPIXELS;
        Desc.PixelFormat.AlphaMask := $FF000000;
      end;
  end;

  Stream.Write(Hdr, SizeOf(Hdr));
  Pixels := FBits;
  WriteRGB(FWidth,FHeight);

  MWidth := FWidth;
  MHeight := FHeight;

  for i := 0 to FNumMipMaps - 1 do
  begin
    Pixels := FMipMaps[i];
    MWidth  := MWidth div 2;
    if MWidth = 0 then MWidth := 1;
    MHeight := MHeight div 2;
    if MHeight = 0 then MHeight := 1;
    WriteRGB(MWidth, MHeight);
  end;

end;

end.
