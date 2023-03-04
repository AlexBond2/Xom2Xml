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
  public
    procedure LoadFromData(Data: Pointer; Width, Height: Integer; ColorBits: Integer);
    procedure SaveToStream(Data: TStream; ColorBits: Integer; GenMipMaps: Boolean);
    procedure LoadFromTGA(FileName: String);
    procedure SaveToTGA(FileName: String; ColorBits: Integer);
    procedure LoadFromPNG(Filename: string); overload;
    procedure LoadFromPNG(Stream: TStream); overload;
    procedure SaveToPNG(FileName: string); overload;
    procedure SaveToPNG(Stream: TStream); overload;
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

procedure TBitmap32.LoadFromPNG(Filename: string);
begin
  LoadBitmap32FromPNG(self, Filename);
end;

procedure TBitmap32.LoadFromPNG(Stream: TStream);
begin
  LoadBitmap32FromPNG(self, Stream);
end;

procedure TBitmap32.SaveToPNG(Stream: TStream);
begin
  SaveBitmap32ToPNG(self, Stream);
end;

procedure TBitmap32.SaveToPNG(FileName: string);
begin
  SaveBitmap32ToPNG(self, FileName);
end;

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

procedure TBitmap32.SaveToTGA(FileName: String; ColorBits: Integer);
var
  Bufer: TMemoryStream;
  Tga: TGAHeader;
  x,y: Integer;
  Pixel: PColor32;
  PixelSize: Integer;
begin
  Bufer := TMemoryStream.Create;
  ZeroMemory(@Tga, SizeOf(TGAHeader));
  Tga.ImageType := 2;
  Tga.Width := FWidth;
  Tga.Height := FHeight;
  Tga.BitsPerPixel := ColorBits;
  Bufer.Write(Tga, SizeOf(TGAHeader));
  PixelSize := ColorBits div 8;
  for y := FHeight - 1 downto 0 do
    for x := 0 to FWidth - 1 do
    begin
      Pixel := PixelPtr[x,y];
      Bufer.Write(Pixel^, PixelSize);
    end;
  Bufer.SaveToFile(FileName);
  Bufer.Free;
end;

procedure TBitmap32.LoadFromTGA(FileName: String);
var
  x,y, counter: integer;
  chunkHeader: byte;
  FileStream: TMemoryStream;
  Tga: TGAHeader;
  Pixel: PColor32;
  Color: TColor32Entry;
  PixelSize: Integer;
begin

  FileStream := TMemoryStream.Create;
  FileStream.LoadFromFile(FileName);
  FileStream.Read(Tga, sizeOf(TGAHeader));

  SetSize(Tga.Width, Tga.Height);
  PixelSize := tga.BitsPerPixel div 8;

  if Tga.ImageType = 2 then
  begin
    for y := Tga.Height - 1 downto 0 do
    begin
      for x := 0 to Tga.Width - 1 do
      begin
        Pixel := PixelPtr[x,y];
        FileStream.Read(Pixel^, PixelSize);
        if PixelSize = 3 then TColor32Entry(Pixel^).A := 255;
      end;
    end;
  end
  else //compressed
  begin
    y := tga.Height -1;
    x := 0;

    while y >= 0 do
    begin
    //repeat
      FileStream.Read(chunkHeader,1);
      if chunkHeader < 128 then //array of colors
      begin
        Inc(chunkHeader);
        for counter := 0 to chunkHeader -1 do
        begin
          if x > Tga.Width -1 then
          begin
            Dec(y);
            x := 0;
          end;
          Pixel := PixelPtr[x,y];
          FileStream.Read(Pixel^, PixelSize);
          if PixelSize = 3 then TColor32Entry(Pixel^).A := 255;
          Inc(x);
        end;
      end
      else  //repeat color
      begin
        chunkHeader := chunkHeader - 127;
        FileStream.Read(Color, PixelSize);
        if PixelSize = 3 then Color.A := 255;

        for counter:=0 to chunkHeader -1 do
        begin
          if x > Tga.Width - 1 then
          begin
            Dec(y);
            x := 0;
          end;
          Pixel := PixelPtr[x,y];
          TColor32Entry(Pixel^) := Color;
          Inc(x);
        end;
      end;
    end;
  end;

  FileStream.Free;
end;

procedure TBitmap32.LoadFromData(Data: Pointer; Width, Height,
  ColorBits: Integer);
var
 x, y, PixelSize: Integer;
 Pixel: PColor32;
 Color: TColor32Entry;
begin
  SetSize(Width, Height);
  PixelSize := ColorBits div 8;
  for y := FHeight - 1 downto 0 do
    for x := 0 to FWidth - 1 do
    begin
      Pixel := PixelPtr[x,y];
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

procedure TBitmap32.SaveToStream(Data: TStream; ColorBits: Integer; GenMipMaps:Boolean);
var
 i, x, y, PixelSize, Maps, NMaps, MWidth, MHeight: Integer;
 Pixel: PColor32;
 Color: TColor32Entry;
 MipXImage, RGBImage, sData: Pointer;

  function GetMipmap(sData: Pointer;
    sWidth, sHeight: Integer;
    dData: Pointer;
    dWidth, dHeight, PixelSize: Integer):Cardinal;
  begin
    if (sWidth <> dWidth) and (sHeight <> dHeight) then
      DownScale(sData, PixelSize, sWidth, sHeight,
        dWidth, dHeight, dData)
    else
      Move(sData^, dData^, sWidth * sHeight * PixelSize);
  end;

begin

  PixelSize := ColorBits div 8;

	RGBImage := AllocMem(FWidth * FHeight * PixelSize);
  sData := RGBImage;
  for y := FHeight - 1 downto 0 do
    for x := 0 to FWidth - 1 do
    begin
      Pixel := PixelPtr[x,y];
      Color.R := TColor32Entry(Pixel^).B;
      Color.G := TColor32Entry(Pixel^).G;
      Color.B := TColor32Entry(Pixel^).R;
      if PixelSize = 4 then
         Color.A := TColor32Entry(Pixel^).A;

      Move(Color, sData^, PixelSize);
      Inc(LongWord(sData), PixelSize);
    end;

  if not GenMipMaps then
    NMaps := 1
  else
    begin
      Maps  := Max(FWidth, FHeight);
      NMaps := Round(Log2(Maps)) + 1;
    end;

  MWidth := FWidth;
  MHeight := FHeight;

  MipXImage := AllocMem(MWidth * MHeight * PixelSize);
  sData := RGBImage;

	for i := 0 to NMaps - 1 do
	begin
	  if MWidth = 0 then MWidth := 1;
	  if MHeight = 0 then MHeight := 1;

	  GetMipmap(sData, FWidth, FHeight, MipXImage, MWidth, MHeight, PixelSize);
	  Data.Write(MipXImage^, MWidth * MHeight * PixelSize);

	  if ((MWidth = 1) and (MHeight = 1)) then
		Break;
	  MWidth  := MWidth div 2;
	  MHeight := MHeight div 2;
	end;

  FreeMem(RGBImage);
  FreeMem(MipXImage);

end;


end.
