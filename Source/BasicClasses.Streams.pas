{===============================================================================

  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

===============================================================================}

{$INCLUDE BasicClasses.Config.inc}

{$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
/// <summary>
///   Extensions and utility classes that extend functionality of streams and
///   provide ways for reading assets. With this unit <see cref="TStream" />
///   dependent classes can read and write different values depending on
///   platform.
/// </summary>
/// <remarks>
///   Dependencies:
///   <list type="bullet">
///     <item>
///       Lib.TypeDefinitions - github.com/dompiotr85/Lib.TypeDefinitions
///     </item>
///   </list>
///   Version 0.1.2
/// </remarks>
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
unit BasicClasses.Streams;

interface

{$IFNDEF PASDOC}
 {$IF DEFINED(ANDROID)}
  {$DEFINE AndroidAssets}
 {$IFEND}
{$ENDIF ~PASDOC}

uses
{$IFDEF AndroidAssets}
  BasicClasses.Android.AssetManager,
{$ENDIF ~AndroidAssets}
  {$IFDEF HAS_UNITSCOPE}System.Classes,{$ELSE}Classes,{$ENDIF}
  TypeDefinitions;

{$IFDEF AndroidAssets}
type
  EAssetManagerNotSpecified = class(EStreamError);
{$ENDIF ~AndroidAssets}

{$IFDEF SUPPORTS_REGION}{$REGION 'TStreamHelper'}{$ENDIF}
type
  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Extensions to <see cref="TStream" /> class for reading and writing
  ///   different values depending on platform. Although <see cref="TStream" />
  ///   in recent versions of FPC and Delphi introduced similar functions, this
  ///   extension class provides a more comprehensive and unified set of
  ///   functions that work across all platforms.
  /// </summary>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  TStreamHelper = class helper for TStream
  public type
    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Value stored as unsigned 8-bit integer, but represented as unsigned
    ///   32-bit or 64-bit value depending on platform.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    TStreamByte = SizeUInt;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Value stored as unsigned 16-bit integer, but represented as unsigned
    ///   32-bit or 64-bit value depending on platform.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    TStreamWord = SizeUInt;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Value stored as unsigned 32-bit integer, but represented as unsigned
    ///   32-bit or 64-bit value depending on platform.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    TStreamLongWord =
    {$IF SizeOf(SizeUInt) >= 4}
      SizeUInt
    {$ELSE}
      LongWord
    {$IFEND};

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Value stored and represented as unsigned 64-bit integer.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    TStreamUInt64 = UInt64;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Value stored as 8-bit signed integer, but represented as signed
    ///   32-bit or 64-bit value depending on platform.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    TStreamShortInt = SizeInt;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Value stored as 16-bit signed integer, but represented as signed
    ///   32-bit or 64-bit value depending on platform.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    TStreamSmallInt = SizeInt;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Value stored as 32-bit signed integer, but represented as signed
    ///   32-bit or 64-bit value depending on platform.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    TStreamLongInt =
    {$IF SizeOf(SizeInt) >= 4}
      SizeInt
    {$ELSE}
      LongInt
    {$IFEND};

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Value stored and represented as signed 64-bit integer.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    TStreamInt64 = Int64;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Value stored and represented as 32-bit (single-precision)
    ///   floating-point.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    TStreamSingle = Single;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Value stored and represented as 64-bit (double-precision)
    ///   floating-point.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    TStreamDouble = Double;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Value stored as 8-bit unsigned integer, but represented as Boolean.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    TStreamByteBool = Boolean;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Value stored as unsigned 8-bit integer, but represented as signed
    ///   32-bit or 64-bit index depending on platform.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    TStreamByteIndex = SizeInt;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Value stored as unsigned 16-bit integer, but represented as signed
    ///   32-bit or 64-bit index depending on platform.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    TStreamWordIndex =
      {$IF SizeOf(SizeInt) >= 4}SizeInt{$ELSE}LongInt{$IFEND};
  public
    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Saves 8-bit unsigned integer to the stream. If the value is outside
    ///   of [0..255] range, it will be clamped.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure PutByte(const Value: TStreamByte); inline;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Loads 8-bit unsigned integer from the stream.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetByte: TStreamByte; inline;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Saves 16-bit unsigned integer to the stream. If the value is outside
    ///   of [0..65535] range, it will be clamped.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure PutWord(const Value: TStreamWord); inline;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Loads 16-bit unsigned integer value from the stream.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetWord: TStreamWord; inline;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Saves 32-bit unsigned integer to the stream.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure PutLongWord(const Value: TStreamLongWord); inline;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Loads 32-bit unsigned integer from the stream.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetLongWord: TStreamLongWord; inline;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Saves 64-bit unsigned integer to the stream.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure PutUInt64(const Value: TStreamUInt64); inline;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Loads 64-bit unsigned integer from the stream.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetUInt64: TStreamUInt64; inline;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Saves 8-bit signed integer to the stream. If the value is outside of
    ///   [-128..127] range, it will be clamped.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure PutShortInt(const Value: TStreamShortInt); inline;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Loads 8-bit signed integer from the stream.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetShortInt: TStreamShortInt; inline;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Saves 16-bit signed integer to the stream. If the value is outside of
    ///   [-32768..32767] range, it will be clamped.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure PutSmallInt(const Value: TStreamSmallInt); inline;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Loads 16-bit signed integer from the stream.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetSmallInt: TStreamSmallInt; inline;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Saves 32-bit signed integer to the stream.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure PutLongInt(const Value: TStreamLongInt); inline;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Loads 32-bit signed integer from the stream.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetLongInt: TStreamLongInt; inline;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Saves 64-bit signed integer to the stream.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure PutInt64(const Value: TStreamInt64); inline;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Loads 64-bit signed integer from the stream.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetInt64: TStreamInt64; inline;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Saves 32-bit floating-point value (single-precision) to the stream.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure PutSingle(const Value: TStreamSingle); inline;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Loads 32-bit floating-point value (single-precision) from the stream.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetSingle: TStreamSingle; inline;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Saves 64-bit floating-point value (double-precision) to the stream.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure PutDouble(const Value: TStreamDouble); inline;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Loads 64-bit floating-point value (double-precision) from the stream.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetDouble: TStreamDouble; inline;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Saves <b>Boolean</b> value to the stream as 8-bit unsigned integer. A
    ///   value of <i>False</i> is saved as 255, while <i>True</i> is saved as
    ///   0.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure PutByteBool(const Value: TStreamByteBool); inline;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Loads <b>Boolean</b> value from the stream previously saved by
    ///   <see cref="BasicClasses.Streams|TStreamHelper.PutByteBool(TStreamByteBool)">
    ///   PutByteBool</see>. The resulting value is treated as 8-bit unsigned
    ///   integer with values of [0..127] considered as <i>True</i> and values
    ///   of [128..255] considered as <i>False</i>.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetByteBool: TStreamByteBool; inline;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Saves 8-bit unsigned index to the stream. A value of -1 (and other
    ///   negative values) is stored as 255. Positive numbers that are outside
    ///   of [0..254] range will be clamped.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure PutByteIndex(const Value: TStreamByteIndex); inline;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Loads 8-bit unsigned index from the stream. The range of returned
    ///   values is [0..254], the value of 255 is returned as -1.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetByteIndex: TStreamByteIndex; inline;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Saves 16-bit unsigned index to the stream. A value of -1 (and other
    ///   negative values) is stored as 65535. Positive numbers that are
    ///   outside of [0..65534] range will be clamped.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure PutWordIndex(const Value: TStreamWordIndex); inline;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Loads 16-bit unsigned index from the stream. The range of returned
    ///   values is [0..65534], the value of 65535 is returned as -1.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetWordIndex: TStreamWordIndex; inline;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Saves floating-point value as 8-bit signed byte to the stream using
    ///   1:3:4 fixed-point format with values outside of [-8..7.9375] range
    ///   will be clamped.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure PutFloat34(const Value: Single);

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Loads floating-point value as 8-bit signed byte from the stream using
    ///   1:3:4 fixed-point format. The possible values are in [-8..7.9375]
    ///   range.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetFloat34: Single;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Saves floating-point value as 8-bit signed byte to the stream using
    ///   1:4:3 fixed-point format with values outside of [-16..15.875] range
    ///   will be clamped.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure PutFloat43(const Value: Single);

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Loads floating-point value as 8-bit signed byte from the stream using
    ///   1:4:3 fixed-point format. The possible values are in [-16..15.875]
    ///   range.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetFloat43: Single;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Saves two floating-point values as a single 8-bit unsigned byte to
    ///   the stream with each value having 4-bits. Values outside of [-8..7]
    ///   range will be clamped.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure PutFloats44(const Value1, Value2: Single);

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Loads two floating-point values as a single 8-bit unsigned byte from
    ///   the stream with each value having 4-bits. The possible values are in
    ///   [-8..7] range.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure GetFloats44(out Value1, Value2: Single);

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Saves two floating-point values as a single 8-bit unsigned byte to
    ///   the stream with each value stored in fixed-point 1:2:1 format. Values
    ///   outside of [-4..3.5] range will be clamped.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure PutFloats3311(const Value1, Value2: Single);

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Loads two floating-point values as a single 8-bit unsigned byte from
    ///   the stream with each value stored in fixed-point 1:2:1 format. The
    ///   possible values are in [-4..3.5] range.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure GetFloats3311(out Value1, Value2: Single);

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Saves Unicode string to the stream in UTF-8 encoding. The resulting
    ///   UTF-8 string is limited to a maximum of 255 characters; therefore,
    ///   for certain char-sets the actual string is limited to either 127 or
    ///   even 85 characters in worst case. If <i>MaxCount</i> is not zero, the
    ///   input string will be limited to the given number of characters.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure PutShortString(const Text: UniString; const MaxCount: Integer = 0);

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Loads Unicode string from the stream in UTF-8 encoding previously
    ///   saved by
    ///   <see cref="BasicClasses.Streams|TStreamHelper.PutShortString(UnicodeString,Integer)">
    ///   PutShortString</see>.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetShortString: UniString;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Saves Unicode string to the stream in UTF-8 encoding. The resulting
    ///   UTF-8 string is limited to a maximum of 65535 characters; therefore,
    ///   for certain char-sets the actual string is limited to either 32767 or
    ///   even 21845 characters in worst case. If <i>MaxCount</i> is not zero,
    ///   the input string will be limited to the given number of characters.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure PutMediumString(const Text: UniString; const MaxCount: Integer = 0);

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Loads Unicode string from the stream in UTF-8 encoding previously
    ///   saved by
    ///   <see cref="BasicClasses.Streams|TStreamHelper.PutMediumString(UnicodeString,Integer)">
    ///   PutMediumString</see>.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetMediumString: UniString;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Stores Unicode string to the stream in UTF-8 encoding.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure PutLongString(const Text: UniString);

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Loads Unicode string from the stream in UTF-8 encoding previously
    ///   saved by
    ///   <see cref="BasicClasses.Streams|TStreamHelper.PutLongString(UnicodeString)">
    ///   PutLongString</see>.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetLongString: UniString;
  end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{$IFDEF SUPPORTS_REGION}{$REGION 'TAssetStream'}{$ENDIF}
type
  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Special stream type that is used to read assets on android platform.
  ///   This stream serves no purpose on other platforms.
  /// </summary>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  TAssetStream = class(TStream)
  private
    FFileName: StdString;

  {$IFDEF AndroidAssets}
    FAsset: PAAsset;
    FFileSize: Int64;
  {$ENDIF !AndroidAssets}
  protected
    { @exclude } function GetSize: Int64; override;
  public
    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Creates instance of asset stream to read form the specified file,
    ///   which must be located in /assets sub-folder of current Android
    ///   package. }
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    constructor Create(const AFileName: StdString);

    { @exclude } destructor Destroy; override;

    { @exclude } function Read(var Buffer; Count: Longint): Longint; override;
    { @exclude } function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; override;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Asset file name, which must be located in /assets sub-folder.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    property FileName: StdString read FFileName;
  {$IFDEF AndroidAssets}
  public
    property Asset: PAAsset read FAsset;
  private
    class var FAssetManager: PAAssetManager;
  public
    class property AssetManager: PAAssetManager read FAssetManager
      write FAssetManager;
  {$ENDIF !AndroidAssets}
  end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

implementation

uses
{$IFDEF DELPHI_NEXTGEN}
  {$IFDEF HAS_UNITSCOPE}System.SysUtils{$ELSE}SysUtils{$ENDIF},
{$ENDIF ~DELPHI_NEXTGEN}
  {$IFDEF HAS_UNITSCOPE}System.RTLConsts{$ELSE}RTLConsts{$ENDIF},
  BasicClasses.Consts;

{$IFDEF SUPPORTS_REGION}{$REGION 'Global routines'}{$ENDIF}
{$IFDEF DELPHI_NEXTGEN}
const
  { UTF-8 }
  DefaultCodePage = 65001;

function StringToBytes(const Text: String): TBytes;
var
  ByteCount: Integer;
begin
  if (Text.IsEmpty) then
    Exit(nil);

  ByteCount := LocaleCharsFromUnicode(DefaultCodePage, 0, Pointer(Text), Length(Text), nil, 0, nil, nil);

  SetLength(Result, ByteCount);
  LocaleCharsFromUnicode(DefaultCodePage, 0, Pointer(Text), Length(Text), Pointer(Result), ByteCount, nil, nil);
end;

function BytesToString(const Bytes: TBytes): String;
var
  TextLength: Integer;
begin
  if (Length(Bytes) < 1) then
    Exit(String.Empty);

  TextLength := UnicodeFromLocaleChars(DefaultCodePage, 0, Pointer(Bytes), Length(Bytes), nil, 0);
  if (TextLength < 1) then
    Exit(String.Empty);

  SetLength(Result, TextLength);
  UnicodeFromLocaleChars(DefaultCodePage, 0, Pointer(Bytes), Length(Bytes), Pointer(Result), TextLength);
end;
{$ENDIF ~DELPHI_NEXTGEN}

function Saturate(const Value, MinLimit, MaxLimit: LongInt): LongInt;
begin
  Result := Value;

  if (Result < MinLimit) then
    Result := MinLimit;

  if (Result > MaxLimit) then
    Result := MaxLimit;
end;

function CrossFixFileName(const FileName: StdString): StdString;
const
{$IFDEF MSWINDOWS}
  PrevChar = '/';
  NewChar = '\';
{$ELSE}
  PrevChar = '\';
  NewChar = '/';
{$ENDIF ~MSWINDOWS}
var
  I: Integer;
begin
  Result := FileName;
  UniqueString(Result);

  for I := 1 to Length(Result) do
    if (Result[I] = PrevChar) then
      Result[I] := NewChar;
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{$IFDEF SUPPORTS_REGION}{$REGION 'TStreamHelper'}{$ENDIF}
function TStreamHelper.GetByte: TStreamByte;
var
  ByteValue: Byte;
begin
  ReadBuffer(ByteValue, SizeOf(Byte));
  Result := ByteValue;
end;

function TStreamHelper.GetByteBool: TStreamByteBool;
var
  ByteValue: Byte;
begin
  ReadBuffer(ByteValue, SizeOf(Byte));
  Result := ByteValue < 128;
end;

function TStreamHelper.GetByteIndex: TStreamByteIndex;
var
  ByteValue: Byte;
begin
  Result := -1;

  if ((Read(ByteValue, SizeOf(Byte)) = SizeOf(Byte)) and (ByteValue <> 255)) then
    Result := ByteValue;
end;

function TStreamHelper.GetDouble: TStreamDouble;
begin
  ReadBuffer(Result, SizeOf(Double));
end;

function TStreamHelper.GetFloat34: Single;
begin
  Result := GetShortInt / 16;
end;

function TStreamHelper.GetFloat43: Single;
begin
  Result := GetShortInt / 8;
end;

procedure TStreamHelper.GetFloats3311(out Value1, Value2: Single);
var
  Temp: Integer;
begin
  Temp := GetByte;

  Value1 := ((Temp and $0F) - 8) / 2;
  Value2 := ((Temp shr 4) - 8) / 2;
end;

procedure TStreamHelper.GetFloats44(out Value1, Value2: Single);
var
  Temp: Integer;
begin
  Temp := GetByte;

  Value1 := (Temp and $0F) - 8;
  Value2 := (Temp shr 4) - 8;
end;

function TStreamHelper.GetInt64: TStreamInt64;
begin
  ReadBuffer(Result, SizeOf(Int64));
end;

function TStreamHelper.GetLongInt: TStreamLongInt;
{$IF SizeOf(TStream.TStreamLongInt) > 4}
var
  LongValue: LongInt;
{$IFEND}
begin
{$IF SizeOf(TStream.TStreamLongInt) > 4}
  ReadBuffer(LongValue, SizeOf(LongInt));
  Result := LongValue;
{$ELSE}
  ReadBuffer(Result, SizeOf(LongInt));
{$IFEND}
end;

function TStreamHelper.GetLongString: UnicodeString;
{$IFDEF DELPHI_NEXTGEN}
var
  Count: Integer;
  Bytes: TBytes;
begin
  Count := GetLongInt;
  SetLength(Bytes, Count);

  if (Read(Pointer(Bytes)^, Count) = Count) then
    Result := BytesToString(Bytes)
  else
    Result := String.Empty;
end;
{$ELSE}
var
  Count: Integer;
  LongText: AnsiString;
begin
  Count := GetLongInt;
  SetLength(LongText, Count);

  if (Read(Pointer(LongText)^, Count) <> Count) then
    Exit('');

  Result := UTF8ToWideString(LongText);
end;
{$ENDIF ~DELPHI_NEXTGEN}

function TStreamHelper.GetLongWord: TStreamLongWord;
{$IF SizeOf(TStream.TStreamLongWord) > 4}
var
  LongWordValue: LongWord;
{$IFEND}
begin
{$IF SizeOf(TStream.TStreamLongWord) > 4}
  ReadBuffer(LongWordValue, SizeOf(LongWord));
  Result := LongWordValue;
{$ELSE}
  ReadBuffer(Result, SizeOf(LongWord));
{$IFEND}
end;

function TStreamHelper.GetMediumString: UnicodeString;
{$IFDEF DELPHI_NEXTGEN}
var
  Count: Integer;
  Bytes: TBytes;
begin
  Count := GetWord;
  SetLength(Bytes, Count);

  if (Read(Pointer(Bytes)^, Count) = Count) then
    Result := BytesToString(Bytes)
  else
    Result := String.Empty;
end;
{$ELSE}
var
  Count: Integer;
  MediumText: AnsiString;
begin
  Count := GetWord;
  SetLength(MediumText, Count);

  if (Read(Pointer(MediumText)^, Count) <> Count) then
    Exit('');

  Result := UTF8ToWideString(MediumText);
end;
{$ENDIF ~~DELPHI_NEXTGEN}

function TStreamHelper.GetShortInt: TStreamShortInt;
var
  ShortValue: ShortInt;
begin
  ReadBuffer(ShortValue, SizeOf(ShortInt));
  Result := ShortValue;
end;

function TStreamHelper.GetShortString: UnicodeString;
{$IFDEF DELPHI_NEXTGEN}
var
  Count: Integer;
  Bytes: TBytes;
begin
  Count := GetByte;
  SetLength(Bytes, Count);

  if (Read(Pointer(Bytes)^, Count) = Count) then
    Result := BytesToString(Bytes)
  else
    Result := String.Empty;
end;
{$ELSE}
var
  Count: Integer;
  ShortText: AnsiString;
begin
  Count := GetByte;
  SetLength(ShortText, Count);

  if (Read(Pointer(ShortText)^, Count) <> Count) then
    Exit('');

  Result := UTF8ToWideString(ShortText);
end;
{$ENDIF ~DELPHI_NEXTGEN}

function TStreamHelper.GetSingle: TStreamSingle;
begin
  ReadBuffer(Result, SizeOf(Single));
end;

function TStreamHelper.GetSmallInt: TStreamSmallInt;
{$IF SizeOf(TStream.TStreamSmallInt) > 2}
var
  SmallValue: SmallInt;
{$IFEND}
begin
{$IF SizeOf(TStream.TStreamSmallInt) > 2}
  ReadBuffer(SmallValue, SizeOf(SmallInt));
  Result := SmallValue;
{$ELSE}
  ReadBuffer(Result, SizeOf(SmallInt));
{$IFEND}
end;

function TStreamHelper.GetUInt64: TStreamUInt64;
begin
  ReadBuffer(Result, SizeOf(UInt64));
end;

function TStreamHelper.GetWord: TStreamWord;
{$IF SizeOf(TStream.TStreamWord) > 2}
var
  WordValue: Word;
{$IFEND}
begin
{$IF SizeOf(TStream.TStreamWord) > 2}
  ReadBuffer(WordValue, SizeOf(Word));
  Result := WordValue;
{$ELSE}
  ReadBuffer(Result, SizeOf(Word));
{$IFEND}
end;

function TStreamHelper.GetWordIndex: TStreamWordIndex;
var
  WordValue: Word;
begin
  Result := -1;

  if ((Read(WordValue, SizeOf(Word)) = SizeOf(Word)) and
      (WordValue <> 65535)) then
    Result := WordValue;
end;

procedure TStreamHelper.PutByte(const Value: TStreamByte);
var
  ByteValue: Byte;
begin
  if (Value <= High(Byte)) then
    ByteValue := Value
  else
    ByteValue := High(Byte);

  WriteBuffer(ByteValue, SizeOf(Byte));
end;

procedure TStreamHelper.PutByteBool(const Value: TStreamByteBool);
var
  ByteValue: Byte;
begin
  ByteValue := 255;

  if (Value) then
    ByteValue := 0;

  WriteBuffer(ByteValue, SizeOf(Byte));
end;

procedure TStreamHelper.PutByteIndex(const Value: TStreamByteIndex);
var
  ByteValue: Byte;
begin
  if (Value < 0) then
    ByteValue := 255
  else
    if (Value > 254) then
      ByteValue := 254
    else
      ByteValue := Value;

  WriteBuffer(ByteValue, SizeOf(Byte));
end;

procedure TStreamHelper.PutDouble(const Value: TStreamDouble);
begin
  WriteBuffer(Value, SizeOf(Double));
end;

procedure TStreamHelper.PutFloat34(const Value: Single);
begin
  PutShortInt(Saturate(Round(Value * 16), -128, 127));
end;

procedure TStreamHelper.PutFloat43(const Value: Single);
begin
  PutShortInt(Saturate(Round(Value * 8), -128, 127));
end;

procedure TStreamHelper.PutFloats3311(const Value1, Value2: Single);
var
  Temp1, Temp2: Integer;
begin
  Temp1 := Saturate(Round(Value1 * 2), -8, 7) + 8;
  Temp2 := Saturate(Round(Value2 * 2), -8, 7) + 8;

  PutByte(Temp1 or (Temp2 shl 4));
end;

procedure TStreamHelper.PutFloats44(const Value1, Value2: Single);
var
  Temp1, Temp2: Integer;
begin
  Temp1 := Saturate(Round(Value1), -8, 7) + 8;
  Temp2 := Saturate(Round(Value2), -8, 7) + 8;

  PutByte(Temp1 or (Temp2 shl 4));
end;

procedure TStreamHelper.PutInt64(const Value: TStreamInt64);
begin
  WriteBuffer(Value, SizeOf(Int64));
end;

procedure TStreamHelper.PutLongInt(const Value: TStreamLongInt);
{$IF SizeOf(TStream.TStreamLongInt) > 4}
var
  LongValue: LongInt;
{$IFEND}
begin
{$IF SizeOf(TStream.TStreamLongInt) > 4}
  if (Value < Low(LongInt)) then
    LongValue := Low(LongInt)
  else
    if (Value > High(LongInt)) then
      LongValue := High(LongInt)
    else
      LongValue := Value;

  WriteBuffer(LongValue, SizeOf(LongInt));
{$ELSE}
  WriteBuffer(Value, SizeOf(LongInt));
{$IFEND}
end;

procedure TStreamHelper.PutLongString(const Text: UnicodeString);
{$IFDEF DELPHI_NEXTGEN}
var
  Count: Integer;
  Bytes: TBytes;
begin
  Bytes := StringToBytes(Text);
  Count := Length(Bytes);

  PutLongInt(Count);
  Write(Pointer(Bytes)^, Count);
end;
{$ELSE}
var
  Count: Integer;
  LongText: AnsiString;
begin
  LongText := UTF8Encode(Text);

  Count := Length(LongText);
  PutLongInt(Count);

  Write(Pointer(LongText)^, Count);
end;
{$ENDIF ~DELPHI_NEXTGEN}

procedure TStreamHelper.PutLongWord(const Value: TStreamLongWord);
{$IF SizeOf(TStream.TStreamLongWord) > 4}
var
  LongWordValue: LongWord;
{$IFEND}
begin
{$IF SizeOf(TStream.TStreamLongWord) > 4}
  if (Value <= High(LongWord)) then
    LongWordValue := Value
  else
    LongWordValue := High(LongWord);

  WriteBuffer(LongWordValue, SizeOf(LongWord));
{$ELSE}
  WriteBuffer(Value, SizeOf(LongWord));
{$IFEND}
end;

procedure TStreamHelper.PutMediumString(const Text: UnicodeString; const MaxCount: Integer);
{$IFDEF DELPHI_NEXTGEN}
var
  Count: Integer;
  Bytes: TBytes;
begin
  Bytes := StringToBytes(Text);
  Count := Length(Bytes);

  if (Count > 65535) then
    Count := 65535;

  if ((MaxCount > 0) and (MaxCount < Count)) then
    Count := MaxCount;

  PutWord(Count);

  Write(Pointer(Bytes)^, Count);
end;
{$ELSE}
var
  Count: Integer;
  MediumText: AnsiString;
begin
  MediumText := UTF8Encode(Text);

  Count := Length(MediumText);
  if (Count > 65535) then
    Count := 65535;

  if ((MaxCount > 0) and (MaxCount < Count)) then
    Count := MaxCount;

  PutWord(Count);

  Write(Pointer(MediumText)^, Count);
end;
{$ENDIF ~DELPHI_NEXTGEN}

procedure TStreamHelper.PutShortInt(const Value: TStreamShortInt);
var
  ShortValue: ShortInt;
begin
  if (Value < Low(ShortInt)) then
    ShortValue := Low(ShortInt)
  else
    if (Value > High(ShortInt)) then
      ShortValue := High(ShortInt)
    else
      ShortValue := Value;

  WriteBuffer(ShortValue, SizeOf(ShortInt));
end;

procedure TStreamHelper.PutShortString(const Text: UnicodeString; const MaxCount: Integer);
{$IFDEF DELPHI_NEXTGEN}
var
  Count: Integer;
  Bytes: TBytes;
begin
  Bytes := StringToBytes(Text);
  Count := Length(Bytes);

  if (Count > 255) then
    Count := 255;

  if ((MaxCount > 0) and (MaxCount < Count)) then
    Count := MaxCount;

  PutByte(Count);

  Write(Pointer(Bytes)^, Count);
end;
{$ELSE}
var
  Count: Integer;
  ShortText: AnsiString;
begin
  ShortText := UTF8Encode(Text);
  Count := Length(ShortText);

  if (Count > 255) then
    Count := 255;

  if ((MaxCount > 0) and (MaxCount < Count)) then
    Count := MaxCount;

  PutByte(Count);

  Write(Pointer(ShortText)^, Count);
end;
{$ENDIF ~DELPHI_NEXTGEN}

procedure TStreamHelper.PutSingle(const Value: TStreamSingle);
begin
  WriteBuffer(Value, SizeOf(Single));
end;

procedure TStreamHelper.PutSmallInt(const Value: TStreamSmallInt);
{$IF SizeOf(TStream.TStreamSmallInt) > 2}
var
  SmallValue: SmallInt;
{$IFEND}
begin
{$IF SizeOf(TStream.TStreamSmallInt) > 2}
  if (Value < Low(SmallInt)) then
    SmallValue := Low(SmallInt)
  else
    if (Value > High(SmallInt)) then
      SmallValue := High(SmallInt)
    else
      SmallValue := Value;

  WriteBuffer(SmallValue, SizeOf(SmallInt));
{$ELSE}
  WriteBuffer(Value, SizeOf(SmallInt));
{$IFEND}
end;

procedure TStreamHelper.PutUInt64(const Value: TStreamUInt64);
begin
  WriteBuffer(Value, SizeOf(UInt64));
end;

procedure TStreamHelper.PutWord(const Value: TStreamWord);
{$IF SizeOf(TStream.TStreamWord) > 2}
var
  WordValue: Word;
{$IFEND}
begin
{$IF SizeOf(TStream.TStreamWord) > 2}
  if (Value <= High(Word)) then
    WordValue := Value
  else
    WordValue := High(Word);

  WriteBuffer(WordValue, SizeOf(Word));
{$ELSE}
  WriteBuffer(Value, SizeOf(Word));
{$IFEND}
end;

procedure TStreamHelper.PutWordIndex(const Value: TStreamWordIndex);
var
  WordValue: Word;
begin
  if (Value < 0) then
    WordValue := 65535
  else
    if (Value > 65534) then
      WordValue := 65534
    else
      WordValue := Value;

  Write(WordValue, SizeOf(Word));
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{$IFDEF SUPPORTS_REGION}{$REGION 'TAssetStream'}{$ENDIF}
constructor TAssetStream.Create(const AFileName: StdString);
begin
  inherited Create;

  FFileName := AFileName;

{$IFDEF AndroidAssets}
  if (FAssetManager = nil) then
    raise EAssetManagerNotSpecified.Create(EAssetManagerNotSpecified);

  FAsset := AAssetManager_open(FAssetManager, PAnsiChar(FFileName), AASSET_MODE_STREAMING);
  if (FAsset = nil) then
    raise EFOpenError.Create(@SFOpenError, [FFileName]);

  FFileSize := AAsset_getLength64(FAsset);
{$ELSE}
  inherited Create;
{$ENDIF ~AndroidAssets}
end;

destructor TAssetStream.Destroy;
begin
{$IFDEF AndroidAssets}
  if (FAsset <> nil) then
  begin
    AAsset_close(FAsset);
    FAsset := nil;
  end;

  FFileSize := 0;
{$ENDIF ~AndroidAssets}

  inherited;
end;

function TAssetStream.GetSize: Int64;
begin
{$IFDEF AndroidAssets}
  Result := FFileSize;
{$ELSE}
  Result := inherited;
{$ENDIF ~AndroidAssets}
end;

function TAssetStream.Read(var Buffer; Count: Longint): Longint;
begin
{$IFDEF AndroidAssets}
  Result := AAsset_read(FAsset, @Buffer, Count);
{$ELSE}
  Result := inherited;
{$ENDIF ~AndroidAssets}
end;

function TAssetStream.Seek(const Offset: Int64; Origin: TSeekOrigin): Int64;
begin
{$IFDEF AndroidAssets}
  Result := AAsset_seek64(FAsset, Offset, Ord(Origin));
{$ELSE}
  Result := inherited;
{$ENDIF ~AndroidAssets}
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

end.
