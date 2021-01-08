{===============================================================================

  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

===============================================================================}

{-------------------------------------------------------------------------------
 Streaming

 Set of functions and classes designed to help writing and reading of binary
 data into/from streams and memory locations.

 All primitives larger than one byte (integers, floats, wide characters -
 including in UTF-16 strings, ...) are always written with little endiannes.

 Boolean data are written as one byte, where zero represents false and any
 non-zero value represents true.

 All strings are written with explicit length, and without terminating zero
 character. First a length is stored, followed immediately by the character
 stream.

 Short strings are stored with 8-bit unsigned integer length, all other strings
 are stored with 32-bit signed integer length (note that the length of 0 or
 lower marks an empty string, such length is not followed by any character
 belonging to that particular string). Length is in characters, not bytes or
 code points.

 Default type Char is always stored as 16-bit unsigned integer, irrespective
 of how it is declared.

 Default type String is always stored as UTF-8 encoded string, again
 irrespective of how it is declared.

 Buffers and array of bytes are both stored as plain byte streams, without
 explicit size.

 Parameter Advance in writing and reading functions indicates whether the
 position in stream being written to or read from (or the passed memory pointer)
 can be advanced by number of bytes written or read. When set to True, the
 position (pointer) is advanced, when False, the position is the same after the
 call as was before it.

 Return value of almost all reading and writing functions is number of bytes
 written or read. The exception to this are read functions that are directly
 returning the value being read.

 Version 0.1.3

 Copyright (c) 2018-2021, Piotr Domañski

 Last change:
   08-01-2021

 Changelog:
   For detailed changelog and history please refer to this git repository:
     https://github.com/dompiotr85/Lib.BasicClasses

 Contacts:
   Piotr Domañski (dom.piotr.85@gmail.com)

 Dependencies:
   - JEDI common files (https://github.com/project-jedi/jedi)
   - Lib.TypeDefinitions (https://github.com/dompiotr85/Lib.TypeDefinitions)
   - Lib.StringRectification (https://github.com/dompiotr85/Lib.StringRectification)
-------------------------------------------------------------------------------}

{$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
/// <summary>
///   Set of function and classes designed to help writing and reading of
///   binary data into/from streams and memory locations.
/// </summary>
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
unit BasicClasses.Streams;

{$INCLUDE BasicClasses.Config.inc}

interface

uses
  {$IFDEF HAS_UNITSCOPE}System.SysUtils{$ELSE}SysUtils{$ENDIF},
  {$IFDEF HAS_UNITSCOPE}System.Classes{$ELSE}Classes{$ENDIF},
  TypeDefinitions,
  BasicClasses,
  BasicClasses.Lists;

{- Allocation helper functions definition  - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Allocation helper functions definition'}{$ENDIF}
{ Following functions are returning number of bytes that are required to store
  a given type. They are here mainly to ease allocation when streaming into
  memory.

  Basic types have static size (nevertheless for completeness sake they are
  included), but some strings might be a little tricky (because of implicit
  conversion and explicitly stored size). }

function StreamedSize_Bool: TMemSize; {$IFDEF CanInline}inline;{$ENDIF}
function StreamedSize_Boolean: TMemSize; {$IFDEF CanInline}inline;{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function StreamedSize_Int8: TMemSize; {$IFDEF CanInline}inline;{$ENDIF}
function StreamedSize_UInt8: TMemSize; {$IFDEF CanInline}inline;{$ENDIF}
function StreamedSize_Int16: TMemSize; {$IFDEF CanInline}inline;{$ENDIF}
function StreamedSize_UInt16: TMemSize; {$IFDEF CanInline}inline;{$ENDIF}
function StreamedSize_Int32: TMemSize; {$IFDEF CanInline}inline;{$ENDIF}
function StreamedSize_UInt32: TMemSize; {$IFDEF CanInline}inline;{$ENDIF}
function StreamedSize_Int64: TMemSize; {$IFDEF CanInline}inline;{$ENDIF}
function StreamedSize_UInt64: TMemSize; {$IFDEF CanInline}inline;{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function StreamedSize_Float32: TMemSize; {$IFDEF CanInline}inline;{$ENDIF}
function StreamedSize_Float64: TMemSize; {$IFDEF CanInline}inline;{$ENDIF}
function StreamedSize_Float80: TMemSize; {$IFDEF CanInline}inline;{$ENDIF}
function StreamedSize_DateTime: TMemSize; {$IFDEF CanInline}inline;{$ENDIF}
function StreamedSize_Currency: TMemSize; {$IFDEF CanInline}inline;{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function StreamedSize_AnsiChar: TMemSize; {$IFDEF CanInline}inline;{$ENDIF}
function StreamedSize_UTF8Char: TMemSize; {$IFDEF CanInline}inline;{$ENDIF}
function StreamedSize_WideChar: TMemSize; {$IFDEF CanInline}inline;{$ENDIF}
function StreamedSize_UnicodeChar: TMemSize; {$IFDEF CanInline}inline;{$ENDIF}
function StreamedSize_Char: TMemSize; {$IFDEF CanInline}inline;{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function StreamedSize_ShortString(const Str: ShortString): TMemSize; {$IFDEF CanInline}inline;{$ENDIF}
function StreamedSize_AnsiString(const Str: AnsiString): TMemSize; {$IFDEF CanInline}inline;{$ENDIF}
function StreamedSize_UTF8String(const Str: UTF8String): TMemSize; {$IFDEF CanInline}inline;{$ENDIF}
function StreamedSize_WideString(const Str: WideString): TMemSize; {$IFDEF CanInline}inline;{$ENDIF}
function StreamedSize_UnicodeString(const Str: UnicodeString): TMemSize; {$IFDEF CanInline}inline;{$ENDIF}
function StreamedSize_String(const Str: String): TMemSize;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function StreamedSize_Buffer(Size: TMemSize): TMemSize; {$IFDEF CanInline}inline;{$ENDIF}
function StreamedSize_Bytes(Count: TMemSize): TMemSize; {$IFDEF CanInline}inline;{$ENDIF}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Memory writing functions definition - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Memory writing functions definition'}{$ENDIF}
function Ptr_WriteBool(var Dest: Pointer; Value: ByteBool; Advance: Boolean): TMemSize; overload;
function Ptr_WriteBool(Dest: Pointer; Value: ByteBool): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_WriteBoolean(var Dest: Pointer; Value: Boolean; Advance: Boolean): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_WriteBoolean(Dest: Pointer; Value: Boolean): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_WriteInt8(var Dest: Pointer; Value: Int8; Advance: Boolean): TMemSize; overload;
function Ptr_WriteInt8(Dest: Pointer; Value: Int8): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_WriteUInt8(var Dest: Pointer; Value: UInt8; Advance: Boolean): TMemSize; overload;
function Ptr_WriteUInt8(Dest: Pointer; Value: UInt8): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_WriteInt16(var Dest: Pointer; Value: Int16; Advance: Boolean): TMemSize; overload;
function Ptr_WriteInt16(Dest: Pointer; Value: Int16): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_WriteUInt16(var Dest: Pointer; Value: UInt16; Advance: Boolean): TMemSize; overload;
function Ptr_WriteUInt16(Dest: Pointer; Value: UInt16): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_WriteInt32(var Dest: Pointer; Value: Int32; Advance: Boolean): TMemSize; overload;
function Ptr_WriteInt32(Dest: Pointer; Value: Int32): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_WriteUInt32(var Dest: Pointer; Value: UInt32; Advance: Boolean): TMemSize; overload;
function Ptr_WriteUInt32(Dest: Pointer; Value: UInt32): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_WriteInt64(var Dest: Pointer; Value: Int64; Advance: Boolean): TMemSize; overload;
function Ptr_WriteInt64(Dest: Pointer; Value: Int64): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_WriteUInt64(var Dest: Pointer; Value: UInt64; Advance: Boolean): TMemSize; overload;
function Ptr_WriteUInt64(Dest: Pointer; Value: UInt64): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_WriteFloat32(var Dest: Pointer; Value: Float32; Advance: Boolean): TMemSize; overload;
function Ptr_WriteFloat32(Dest: Pointer; Value: Float32): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_WriteFloat64(var Dest: Pointer; Value: Float64; Advance: Boolean): TMemSize; overload;
function Ptr_WriteFloat64(Dest: Pointer; Value: Float64): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_WriteFloat80(var Dest: Pointer; Value: Float80; Advance: Boolean): TMemSize; overload;
function Ptr_WriteFloat80(Dest: Pointer; Value: Float80): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_WriteDateTime(var Dest: Pointer; Value: TDateTime; Advance: Boolean): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_WriteDateTime(Dest: Pointer; Value: TDateTime): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_WriteCurrency(var Dest: Pointer; Value: Currency; Advance: Boolean): TMemSize; overload;
function Ptr_WriteCurrency(Dest: Pointer; Value: Currency): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_WriteAnsiChar(var Dest: Pointer; Value: AnsiChar; Advance: Boolean): TMemSize; overload;
function Ptr_WriteAnsiChar(Dest: Pointer; Value: AnsiChar): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_WriteUTF8Char(var Dest: Pointer; Value: UTF8Char; Advance: Boolean): TMemSize; overload;
function Ptr_WriteUTF8Char(Dest: Pointer; Value: UTF8Char): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_WriteWideChar(var Dest: Pointer; Value: WideChar; Advance: Boolean): TMemSize; overload;
function Ptr_WriteWideChar(Dest: Pointer; Value: WideChar): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_WriteUnicodeChar(var Dest: Pointer; Value: UnicodeChar; Advance: Boolean): TMemSize; overload;
function Ptr_WriteUnicodeChar(Dest: Pointer; Value: UnicodeChar): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_WriteChar(var Dest: Pointer; Value: Char; Advance: Boolean): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_WriteChar(Dest: Pointer; Value: Char): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_WriteShortString(var Dest: Pointer; const Str: ShortString; Advance: Boolean): TMemSize; overload;
function Ptr_WriteShortString(Dest: Pointer; const Str: ShortString): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_WriteAnsiString(var Dest: Pointer; const Str: AnsiString; Advance: Boolean): TMemSize; overload;
function Ptr_WriteAnsiString(Dest: Pointer; const Str: AnsiString): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_WriteUTF8String(var Dest: Pointer; const Str: UTF8String; Advance: Boolean): TMemSize; overload;
function Ptr_WriteUTF8String(Dest: Pointer; const Str: UTF8String): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_WriteWideString(var Dest: Pointer; const Str: WideString; Advance: Boolean): TMemSize; overload;
function Ptr_WriteWideString(Dest: Pointer; const Str: WideString): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_WriteUnicodeString(var Dest: Pointer; const Str: UnicodeString; Advance: Boolean): TMemSize; overload;
function Ptr_WriteUnicodeString(Dest: Pointer; const Str: UnicodeString): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_WriteString(var Dest: Pointer; const Str: String; Advance: Boolean): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_WriteString(Dest: Pointer; const Str: String): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_WriteBuffer(var Dest: Pointer; const Buffer; Size: TMemSize; Advance: Boolean): TMemSize; overload;
function Ptr_WriteBuffer(Dest: Pointer; const Buffer; Size: TMemSize): TMemSize; overload;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_WriteBytes(var Dest: Pointer; const Value: array of UInt8; Advance: Boolean): TMemSize; overload;
function Ptr_WriteBytes(Dest: Pointer; const Value: array of UInt8): TMemSize; overload;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_FillBytes(var Dest: Pointer; Count: TMemSize; Value: UInt8; Advance: Boolean): TMemSize; overload;
function Ptr_FillBytes(Dest: Pointer; Count: TMemSize; Value: UInt8): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Memory reading functions definition - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Memory writing functions definition'}{$ENDIF}
function Ptr_ReadBool(var Src: Pointer; out Value: ByteBool; Advance: Boolean): TMemSize; overload;
function Ptr_ReadBool(Src: Pointer; out Value: ByteBool): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadBool(var Src: Pointer; Advance: Boolean): ByteBool; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadBool(Src: Pointer): ByteBool; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_ReadBoolean(var Src: Pointer; out Value: Boolean; Advance: Boolean): TMemSize; overload;
function Ptr_ReadBoolean(Src: Pointer; out Value: Boolean): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadInt8(var Src: Pointer; out Value: Int8; Advance: Boolean): TMemSize; overload;
function Ptr_ReadInt8(Src: Pointer; out Value: Int8): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadInt8(var Src: Pointer; Advance: Boolean): Int8; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadInt8(Src: Pointer): Int8; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_ReadUInt8(var Src: Pointer; out Value: UInt8; Advance: Boolean): TMemSize; overload;
function Ptr_ReadUInt8(Src: Pointer; out Value: UInt8): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadUInt8(var Src: Pointer; Advance: Boolean): UInt8; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadUInt8(Src: Pointer): UInt8; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_ReadInt16(var Src: Pointer; out Value: Int16; Advance: Boolean): TMemSize; overload;
function Ptr_ReadInt16(Src: Pointer; out Value: Int16): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadInt16(var Src: Pointer; Advance: Boolean): Int16; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadInt16(Src: Pointer): Int16; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_ReadUInt16(var Src: Pointer; out Value: UInt16; Advance: Boolean): TMemSize; overload;
function Ptr_ReadUInt16(Src: Pointer; out Value: UInt16): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadUInt16(var Src: Pointer; Advance: Boolean): UInt16; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadUInt16(Src: Pointer): UInt16; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_ReadInt32(var Src: Pointer; out Value: Int32; Advance: Boolean): TMemSize; overload;
function Ptr_ReadInt32(Src: Pointer; out Value: Int32): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadInt32(var Src: Pointer; Advance: Boolean): Int32; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadInt32(Src: Pointer): Int32; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_ReadUInt32(var Src: Pointer; out Value: UInt32; Advance: Boolean): TMemSize; overload;
function Ptr_ReadUInt32(Src: Pointer; out Value: UInt32): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadUInt32(var Src: Pointer; Advance: Boolean): UInt32; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadUInt32(Src: Pointer): UInt32; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_ReadInt64(var Src: Pointer; out Value: Int64; Advance: Boolean): TMemSize; overload;
function Ptr_ReadInt64(Src: Pointer; out Value: Int64): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadInt64(var Src: Pointer; Advance: Boolean): Int64; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadInt64(Src: Pointer): Int64; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_ReadUInt64(var Src: Pointer; out Value: UInt64; Advance: Boolean): TMemSize; overload;
function Ptr_ReadUInt64(Src: Pointer; out Value: UInt64): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadUInt64(var Src: Pointer; Advance: Boolean): UInt64; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadUInt64(Src: Pointer): UInt64; overload; {$IFDEF CanInline}inline;{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadFloat32(var Src: Pointer; out Value: Float32; Advance: Boolean): TMemSize; overload;
function Ptr_ReadFloat32(Src: Pointer; out Value: Float32): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadFloat32(var Src: Pointer; Advance: Boolean): Float32; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadFloat32(Src: Pointer): Float32; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_ReadFloat64(var Src: Pointer; out Value: Float64; Advance: Boolean): TMemSize; overload;
function Ptr_ReadFloat64(Src: Pointer; out Value: Float64): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadFloat64(var Src: Pointer; Advance: Boolean): Float64; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadFloat64(Src: Pointer): Float64; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_ReadFloat80(var Src: Pointer; out Value: Float80; Advance: Boolean): TMemSize; overload;
function Ptr_ReadFloat80(Src: Pointer; out Value: Float80): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadFloat80(var Src: Pointer; Advance: Boolean): Float80; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadFloat80(Src: Pointer): Float80; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_ReadDateTime(var Src: Pointer; out Value: TDateTime; Advance: Boolean): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadDateTime(Src: Pointer; out Value: TDateTime): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadDateTime(var Src: Pointer; Advance: Boolean): TDateTime; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadDateTime(Src: Pointer): TDateTime; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_ReadCurrency(var Src: Pointer; out Value: Currency; Advance: Boolean): TMemSize; overload;
function Ptr_ReadCurrency(Src: Pointer; out Value: Currency): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadCurrency(var Src: Pointer; Advance: Boolean): Currency; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadCurrency(Src: Pointer): Currency; overload; {$IFDEF CanInline}inline;{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadAnsiChar(var Src: Pointer; out Value: AnsiChar; Advance: Boolean): TMemSize; overload;
function Ptr_ReadAnsiChar(Src: Pointer; out Value: AnsiChar): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadAnsiChar(var Src: Pointer; Advance: Boolean): AnsiChar; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadAnsiChar(Src: Pointer): AnsiChar; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_ReadUTF8Char(var Src: Pointer; out Value: UTF8Char; Advance: Boolean): TMemSize; overload;
function Ptr_ReadUTF8Char(Src: Pointer; out Value: UTF8Char): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadUTF8Char(var Src: Pointer; Advance: Boolean): UTF8Char; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadUTF8Char(Src: Pointer): UTF8Char; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_ReadWideChar(var Src: Pointer; out Value: WideChar; Advance: Boolean): TMemSize; overload;
function Ptr_ReadWideChar(Src: Pointer; out Value: WideChar): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadWideChar(var Src: Pointer; Advance: Boolean): WideChar; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadWideChar(Src: Pointer): WideChar; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_ReadUnicodeChar(var Src: Pointer; out Value: UnicodeChar; Advance: Boolean): TMemSize; overload;
function Ptr_ReadUnicodeChar(Src: Pointer; out Value: UnicodeChar): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadUnicodeChar(var Src: Pointer; Advance: Boolean): UnicodeChar; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadUnicodeChar(Src: Pointer): UnicodeChar; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_ReadChar(var Src: Pointer; out Value: Char; Advance: Boolean): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadChar(Src: Pointer; out Value: Char): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadChar(var Src: Pointer; Advance: Boolean): Char; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadChar(Src: Pointer): Char; overload; {$IFDEF CanInline}inline;{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadShortString(var Src: Pointer; out Str: ShortString; Advance: Boolean): TMemSize; overload;
function Ptr_ReadShortString(Src: Pointer; out Str: ShortString): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadShortString(var Src: Pointer; Advance: Boolean): ShortString; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadShortString(Src: Pointer): ShortString; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_ReadAnsiString(var Src: Pointer; out Str: AnsiString; Advance: Boolean): TMemSize; overload;
function Ptr_ReadAnsiString(Src: Pointer; out Str: AnsiString): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadAnsiString(var Src: Pointer; Advance: Boolean): AnsiString; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadAnsiString(Src: Pointer): AnsiString; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_ReadUTF8String(var Src: Pointer; out Str: UTF8String; Advance: Boolean): TMemSize; overload;
function Ptr_ReadUTF8String(Src: Pointer; out Str: UTF8String): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadUTF8String(var Src: Pointer; Advance: Boolean): UTF8String; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadUTF8String(Src: Pointer): UTF8String; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_ReadWideString(var Src: Pointer; out Str: WideString; Advance: Boolean): TMemSize; overload;
function Ptr_ReadWideString(Src: Pointer; out Str: WideString): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadWideString(var Src: Pointer; Advance: Boolean): WideString; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadWideString(Src: Pointer): WideString; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_ReadUnicodeString(var Src: Pointer; out Str: UnicodeString; Advance: Boolean): TMemSize; overload;
function Ptr_ReadUnicodeString(Src: Pointer; out Str: UnicodeString): TMemSize; overload; {$IFDEF CanInline} inline;{$ENDIF}
function Ptr_ReadUnicodeString(var Src: Pointer; Advance: Boolean): UnicodeString; overload; {$IFDEF CanInline} inline;{$ENDIF}
function Ptr_ReadUnicodeString(Src: Pointer): UnicodeString; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Ptr_ReadString(var Src: Pointer; out Str: String; Advance: Boolean): TMemSize; overload;
function Ptr_ReadString(Src: Pointer; out Str: String): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadString(var Src: Pointer; Advance: Boolean): String; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Ptr_ReadString(Src: Pointer): String; overload; {$IFDEF CanInline}inline;{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadBuffer(var Src: Pointer; var Buffer; Size: TMemSize; Advance: Boolean): TMemSize; overload;
function Ptr_ReadBuffer(Src: Pointer; var Buffer; Size: TMemSize): TMemSize; overload;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Stream writing functions definition - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Stream writing functions definition'}{$ENDIF}
function Stream_WriteBool(Stream: TStream; Value: ByteBool; Advance: Boolean = True): TMemSize;
function Stream_WriteBoolean(Stream: TStream; Value: Boolean; Advance: Boolean = True): TMemSize; {$IFDEF CanInline}inline;{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_WriteInt8(Stream: TStream; Value: Int8; Advance: Boolean = True): TMemSize;
function Stream_WriteUInt8(Stream: TStream; Value: UInt8; Advance: Boolean = True): TMemSize;
function Stream_WriteInt16(Stream: TStream; Value: Int16; Advance: Boolean = True): TMemSize;
function Stream_WriteUInt16(Stream: TStream; Value: UInt16; Advance: Boolean = True): TMemSize;
function Stream_WriteInt32(Stream: TStream; Value: Int32; Advance: Boolean = True): TMemSize;
function Stream_WriteUInt32(Stream: TStream; Value: UInt32; Advance: Boolean = True): TMemSize;
function Stream_WriteInt64(Stream: TStream; Value: Int64; Advance: Boolean = True): TMemSize;
function Stream_WriteUInt64(Stream: TStream; Value: UInt64; Advance: Boolean = True): TMemSize;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_WriteFloat32(Stream: TStream; Value: Float32; Advance: Boolean = True): TMemSize;
function Stream_WriteFloat64(Stream: TStream; Value: Float64; Advance: Boolean = True): TMemSize;
function Stream_WriteFloat80(Stream: TStream; Value: Float80; Advance: Boolean = True): TMemSize;
function Stream_WriteDateTime(Stream: TStream; Value: TDateTime; Advance: Boolean = True): TMemSize; {$IFDEF CanInline}inline;{$ENDIF}
function Stream_WriteCurrency(Stream: TStream; Value: Currency; Advance: Boolean = True): TMemSize;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_WriteAnsiChar(Stream: TStream; Value: AnsiChar; Advance: Boolean = True): TMemSize;
function Stream_WriteUTF8Char(Stream: TStream; Value: UTF8Char; Advance: Boolean = True): TMemSize;
function Stream_WriteWideChar(Stream: TStream; Value: WideChar; Advance: Boolean = True): TMemSize;
function Stream_WriteUnicodeChar(Stream: TStream; Value: UnicodeChar; Advance: Boolean = True): TMemSize;
function Stream_WriteChar(Stream: TStream; Value: Char; Advance: Boolean = True): TMemSize; {$IFDEF CanInline}inline;{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_WriteShortString(Stream: TStream; const Str: ShortString; Advance: Boolean = True): TMemSize;
function Stream_WriteAnsiString(Stream: TStream; const Str: AnsiString; Advance: Boolean = True): TMemSize;
function Stream_WriteUTF8String(Stream: TStream; const Str: UTF8String; Advance: Boolean = True): TMemSize;
function Stream_WriteWideString(Stream: TStream; const Str: WideString; Advance: Boolean = True): TMemSize;
function Stream_WriteUnicodeString(Stream: TStream; const Str: UnicodeString; Advance: Boolean = True): TMemSize;
function Stream_WriteString(Stream: TStream; const Str: String; Advance: Boolean = True): TMemSize; {$IFDEF CanInline}inline;{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_WriteBuffer(Stream: TStream; const Buffer; Size: TMemSize; Advance: Boolean = True): TMemSize;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_WriteBytes(Stream: TStream; const Value: array of UInt8; Advance: Boolean = True): TMemSize;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_FillBytes(Stream: TStream; Count: TMemSize; Value: UInt8; Advance: Boolean = True): TMemSize;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Stream reading functions definition - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Stream reading functions definition'}{$ENDIF}
function Stream_ReadBool(Stream: TStream; out Value: ByteBool; Advance: Boolean = True): TMemSize; overload;
function Stream_ReadBool(Stream: TStream; Advance: Boolean = True): ByteBool; overload; {$IFDEF CanInline}inline;{$ENDIF}

function Stream_ReadBoolean(Stream: TStream; out Value: Boolean; Advance: Boolean = True): TMemSize;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadInt8(Stream: TStream; out Value: Int8; Advance: Boolean = True): TMemSize; overload;
function Stream_ReadInt8(Stream: TStream; Advance: Boolean = True): Int8; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Stream_ReadUInt8(Stream: TStream; out Value: UInt8; Advance: Boolean = True): TMemSize; overload;
function Stream_ReadUInt8(Stream: TStream; Advance: Boolean = True): UInt8; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Stream_ReadInt16(Stream: TStream; out Value: Int16; Advance: Boolean = True): TMemSize; overload;
function Stream_ReadInt16(Stream: TStream; Advance: Boolean = True): Int16; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Stream_ReadUInt16(Stream: TStream; out Value: UInt16; Advance: Boolean = True): TMemSize; overload;
function Stream_ReadUInt16(Stream: TStream; Advance: Boolean = True): UInt16; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Stream_ReadInt32(Stream: TStream; out Value: Int32; Advance: Boolean = True): TMemSize; overload;
function Stream_ReadInt32(Stream: TStream; Advance: Boolean = True): Int32; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Stream_ReadUInt32(Stream: TStream; out Value: UInt32; Advance: Boolean = True): TMemSize; overload;
function Stream_ReadUInt32(Stream: TStream; Advance: Boolean = True): UInt32; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Stream_ReadInt64(Stream: TStream; out Value: Int64; Advance: Boolean = True): TMemSize; overload;
function Stream_ReadInt64(Stream: TStream; Advance: Boolean = True): Int64; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Stream_ReadUInt64(Stream: TStream; out Value: UInt64; Advance: Boolean = True): TMemSize; overload;
function Stream_ReadUInt64(Stream: TStream; Advance: Boolean = True): UInt64; overload; {$IFDEF CanInline}inline;{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadFloat32(Stream: TStream; out Value: Float32; Advance: Boolean = True): TMemSize; overload;
function Stream_ReadFloat32(Stream: TStream; Advance: Boolean = True): Float32; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Stream_ReadFloat64(Stream: TStream; out Value: Float64; Advance: Boolean = True): TMemSize; overload;
function Stream_ReadFloat64(Stream: TStream; Advance: Boolean = True): Float64; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Stream_ReadFloat80(Stream: TStream; out Value: Float80; Advance: Boolean = True): TMemSize; overload;
function Stream_ReadFloat80(Stream: TStream; Advance: Boolean = True): Float80; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Stream_ReadDateTime(Stream: TStream; out Value: TDateTime; Advance: Boolean = True): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Stream_ReadDateTime(Stream: TStream; Advance: Boolean = True): TDateTime; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Stream_ReadCurrency(Stream: TStream; out Value: Currency; Advance: Boolean = True): TMemSize; overload;
function Stream_ReadCurrency(Stream: TStream; Advance: Boolean = True): Currency; overload; {$IFDEF CanInline}inline;{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadAnsiChar(Stream: TStream; out Value: AnsiChar; Advance: Boolean = True): TMemSize; overload;
function Stream_ReadAnsiChar(Stream: TStream; Advance: Boolean = True): AnsiChar; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Stream_ReadUTF8Char(Stream: TStream; out Value: UTF8Char; Advance: Boolean = True): TMemSize; overload;
function Stream_ReadUTF8Char(Stream: TStream; Advance: Boolean = True): UTF8Char; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Stream_ReadWideChar(Stream: TStream; out Value: WideChar; Advance: Boolean = True): TMemSize; overload;
function Stream_ReadWideChar(Stream: TStream; Advance: Boolean = True): WideChar; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Stream_ReadUnicodeChar(Stream: TStream; out Value: UnicodeChar; Advance: Boolean = True): TMemSize; overload;
function Stream_ReadUnicodeChar(Stream: TStream; Advance: Boolean = True): UnicodeChar; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Stream_ReadChar(Stream: TStream; out Value: Char; Advance: Boolean = True): TMemSize; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Stream_ReadChar(Stream: TStream; Advance: Boolean = True): Char; overload; {$IFDEF CanInline}inline;{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadShortString(Stream: TStream; out Str: ShortString; Advance: Boolean = True): TMemSize; overload;
function Stream_ReadShortString(Stream: TStream; Advance: Boolean = True): ShortString; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Stream_ReadAnsiString(Stream: TStream; out Str: AnsiString; Advance: Boolean = True): TMemSize; overload;
function Stream_ReadAnsiString(Stream: TStream; Advance: Boolean = True): AnsiString; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Stream_ReadUTF8String(Stream: TStream; out Str: UTF8String; Advance: Boolean = True): TMemSize; overload;
function Stream_ReadUTF8String(Stream: TStream; Advance: Boolean = True): UTF8String; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Stream_ReadWideString(Stream: TStream; out Str: WideString; Advance: Boolean = True): TMemSize; overload;
function Stream_ReadWideString(Stream: TStream; Advance: Boolean = True): WideString; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Stream_ReadUnicodeString(Stream: TStream; out Str: UnicodeString; Advance: Boolean = True): TMemSize; overload;
function Stream_ReadUnicodeString(Stream: TStream; Advance: Boolean = True): UnicodeString; overload; {$IFDEF CanInline}inline;{$ENDIF}
function Stream_ReadString(Stream: TStream; out Str: String; Advance: Boolean = True): TMemSize; overload;
function Stream_ReadString(Stream: TStream; Advance: Boolean = True): String; overload; {$IFDEF CanInline}inline;{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadBuffer(Stream: TStream; var Buffer; Size: TMemSize; Advance: Boolean = True): TMemSize; overload;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- TCustomStreamer - class definition  - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'TCustomStreamer - class definition'}{$ENDIF}
type
  TValueType = (
    vtShortString, vtAnsiString,
    vtUTF8String, vtWideString,
    vtUnicodeString, vtString,
    vtFillBytes, vtBytes,
    vtPrimitive1B, vtPrimitive2B, vtPrimitive4B, vtPrimitive8B, vtPrimitive10B);

  {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Custom Streamer class definition.
  /// </summary>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  TCustomStreamer = class(TCustomList)
  protected
    FBookmarks: array of Int64;
    FCount: Integer;
    FStartPosition: Int64;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves current capacity of custom streamer.
    /// </summary>
    /// <returns>
    ///   Returns current capacity of custom streamer.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetCapacity: SizeUInt; override;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Sets current capacity of custom streamer.
    /// </summary>
    /// <param name="Value">
    ///   New capacity value.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure SetCapacity(Value: SizeUInt); override;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves current count of custom streamer.
    /// </summary>
    /// <returns>
    ///   Returns current count of custom streamer.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetCount: SizeUInt; override;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Sets current count of custom streamer.
    /// </summary>
    /// <param name="Value">
    ///   New count value.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure SetCount(Value: SizeUInt); override;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves bookmark value at specified Index position.
    /// </summary>
    /// <param name="Index">
    ///   Index position of bookmark which will be retrieved.
    /// </param>
    /// <returns>
    ///   Returns bookmark value.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetBookmark(Index: Integer): Int64; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Sets new bookmark value at specified Index position.
    /// </summary>
    /// <param name="Index">
    ///   Index position of bookmark which will be set.
    /// </param>
    /// <param name="Value">
    ///   New value of bookmark.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure SetBookmark(Index: Integer; Value: Int64); virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves current position of the caret.
    /// </summary>
    /// <returns>
    ///   Returns current position of the caret.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetCurrentPosition: Int64; virtual; abstract;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Sets new position of the caret.
    /// </summary>
    /// <param name="NewPosition">
    ///   New position of the caret.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure SetCurrentPosition(NewPosition: Int64); virtual; abstract;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves byte distance of the caret. Distance is calculated from
    ///   begining of streamer data to current position of the caret.
    /// </summary>
    /// <returns>
    ///   Returns byte distance of the caret.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetDistance: Int64; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Writes specified data to this streamer.
    /// </summary>
    /// <param name="Value">
    ///   Pointer to the value that will be written.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag.
    /// </param>
    /// <param name="Size">
    ///   Size of the data (in bytes).
    /// </param>
    /// <param name="ValueType">
    ///   Describes type of the value.
    /// </param>
    /// <returns>
    ///   Returns actual size written to this streamer.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function WriteValue(Value: Pointer; Advance: Boolean; Size: TMemSize; ValueType: TValueType): TMemSize; virtual; abstract;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads data from this streamer.
    /// </summary>
    /// <param name="Value">
    ///   Pointer where readed data will be stored in.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag.
    /// </param>
    /// <param name="Size">
    ///   Size of the data to read (in bytes).
    /// </param>
    /// <param name="ValueType">
    ///   Describes type of the value.
    /// </param>
    /// <returns>
    ///   Returns actual size read from this streamer.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadValue(Value: Pointer; Advance: Boolean; Size: TMemSize; ValueType: TValueType): TMemSize; virtual; abstract;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  public

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Raises ECustomStreamerError exception with specified informations.
    /// </summary>
    /// <param name="Msg">
    ///   Reference to exception message string.
    /// </param>
    /// <param name="Method">
    ///   Reference to method name string where this exception need to be
    ///   called.
    /// </param>
    /// <param name="Data">
    ///   Reference to data.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    class procedure Error(const Msg, Method: String; Data: NativeInt); overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Raises ECustomStreamerError exception with specified informations.
    /// </summary>
    /// <param name="Msg">
    ///   Pointer to resource string record.
    /// </param>
    /// <param name="Method">
    ///   Reference to method name string where this exception need to be
    ///   called.
    /// </param>
    /// <param name="Data">
    ///   Reference to data.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    class procedure Error(Msg: PResStringRec; const Method: String; Data: NativeInt); overload;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves low index of this streamer.
    /// </summary>
    /// <returns>
    ///   Returns low index of this streamer.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function LowIndex: SizeInt; override;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves high index of this streamer.
    /// </summary>
    /// <returns>
    ///   Returns high index of this streamer.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function HighIndex: SizeInt; override;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Initializes internal data of this streamer.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure Initialize; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Moves position of the caret to the begining of the streamer.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure MoveToStart; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Moves position of the caret to bookmark position with specified Index.
    /// </summary>
    /// <param name="Index">
    ///   Index position of bookmark.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure MoveToBookmark(Index: Integer); virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Moves position of the caret by specified Offset.
    /// </summary>
    /// <param name="Offset">
    ///   Offset position.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure MoveBy(Offset: Int64); virtual;

    {- Bookmarks methods - - - - - - - - - - - - - - - - - - - - - - - - - - - }
    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves index of the bookmark which points to specified Position.
    ///   If there isn't bookmark which points to specified Position, -1 will be
    ///   returned.
    /// </summary>
    /// <param name="Position">
    ///   Position in the streamer.
    /// </param>
    /// <returns>
    ///   Returns index of the bookmakr which points to specified Position.
    ///   If there isn't bookmark which points to specified position, -1 will be
    ///   returned.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function IndexOfBookmark(Position: Int64): Integer; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Adds new bookmark that points to the current position of the caret.
    /// </summary>
    /// <returns>
    ///   Returns index position of new bookmark.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function AddBookmark: Integer; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Adds new bookmark that points to specified Position.
    /// </summary>
    /// <param name="Position">
    ///   Position value of new bookmark.
    /// </param>
    /// <returns>
    ///   Returns index position of new bookmark.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function AddBookmark(Position: Int64): Integer; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Removes bookmark which points to specified Position. If RemoveAll flag
    ///   is set, then all bookmarks that points to specified Position will be
    ///   removed.
    /// </summary>
    /// <param name="Position">
    ///   Position value which will be searched in all bookmarks.
    /// </param>
    /// <param name="RemoveAll">
    ///   If this flag is set to True, all bookmarks which points to specified
    ///   Position will be removed. If False, then only first bookmark with
    ///   specified position will be removed.
    /// <returns>
    ///   If RemoveAll flag is set to False, then this function returns index
    ///   position of first bookmark which was found or -1 if nothing was found.
    ///   If RemoveAll flag is set to True, then this function always returns
    ///   -1.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function RemoveBookmark(Position: Int64; RemoveAll: Boolean = True): Integer; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Removes bookmark with specified Index position.
    /// </summary>
    /// <param name="Index">
    ///   Index position of bookmark which will be removed.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure DeleteBookmark(Index: Integer); virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Clears all bookmarks stored in this streamer.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure ClearBookmark; virtual;

    {- Write methods - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Writes Bool value to the streamer.
    /// </summary>
    /// <param name="Value">
    ///   Bool value.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size written (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function WriteBool(Value: ByteBool; Advance: Boolean = True): TMemSize; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Writes Boolean value to the streamer.
    /// </summary>
    /// <param name="Value">
    ///   Boolean value.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size written (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function WriteBoolean(Value: Boolean; Advance: Boolean = True): TMemSize; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Writes Int8 value to the streamer.
    /// </summary>
    /// <param name="Value">
    ///   Int8 value.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size written (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function WriteInt8(Value: Int8; Advance: Boolean = True): TMemSize; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Writes UInt8 value to the streamer.
    /// </summary>
    /// <param name="Value">
    ///   UInt8 value.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size written (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function WriteUInt8(Value: UInt8; Advance: Boolean = True): TMemSize; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Writes Int16 value to the streamer.
    /// </summary>
    /// <param name="Value">
    ///   Int16 value.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size written (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function WriteInt16(Value: Int16; Advance: Boolean = True): TMemSize; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Writes UInt16 value to the streamer.
    /// </summary>
    /// <param name="Value">
    ///   UInt16 value.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size written (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function WriteUInt16(Value: UInt16; Advance: Boolean = True): TMemSize; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Writes Int32 value to the streamer.
    /// </summary>
    /// <param name="Value">
    ///   Int32 value.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size written (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function WriteInt32(Value: Int32; Advance: Boolean = True): TMemSize; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Writes UInt32 value to the streamer.
    /// </summary>
    /// <param name="Value">
    ///   UInt32 value.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size written (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function WriteUInt32(Value: UInt32; Advance: Boolean = True): TMemSize; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Writes Int64 value to the streamer.
    /// </summary>
    /// <param name="Value">
    ///   Int64 value.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size written (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function WriteInt64(Value: Int64; Advance: Boolean = True): TMemSize; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Writes UInt64 value to the streamer.
    /// </summary>
    /// <param name="Value">
    ///   UInt64 value.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size written (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function WriteUInt64(Value: UInt64; Advance: Boolean = True): TMemSize; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Writes Float32 value to the streamer.
    /// </summary>
    /// <param name="Value">
    ///   Float32 value.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size written (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function WriteFloat32(Value: Float32; Advance: Boolean = True): TMemSize; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Writes Float64 value to the streamer.
    /// </summary>
    /// <param name="Value">
    ///   Float64 value.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size written (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function WriteFloat64(Value: Float64; Advance: Boolean = True): TMemSize; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Writes Float80 value to the streamer.
    /// </summary>
    /// <param name="Value">
    ///   Float80 value.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size written (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function WriteFloat80(Value: Float80; Advance: Boolean = True): TMemSize; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Writes TDateTime value to the streamer.
    /// </summary>
    /// <param name="Value">
    ///   TDateTime value.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size written (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function WriteDateTime(Value: TDateTime; Advance: Boolean = True): TMemSize; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Writes Currency value to the streamer.
    /// </summary>
    /// <param name="Value">
    ///   Currency value.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size written (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function WriteCurrency(Value: Currency; Advance: Boolean = True): TMemSize; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Writes AnsiChar to the streamer.
    /// </summary>
    /// <param name="Value">
    ///   AnsiChar value.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size written (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function WriteAnsiChar(Value: AnsiChar; Advance: Boolean = True): TMemSize; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Writes UTF8Char to the streamer.
    /// </summary>
    /// <param name="Value">
    ///   UTF8Char value.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size written (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function WriteUTF8Char(Value: UTF8Char; Advance: Boolean = True): TMemSize; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Writes WideChar to the streamer.
    /// </summary>
    /// <param name="Value">
    ///   WideChar value.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size written (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function WriteWideChar(Value: WideChar; Advance: Boolean = True): TMemSize; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Writes UnicodeChar to the streamer.
    /// </summary>
    /// <param name="Value">
    ///   UnicodeChar value.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size written (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function WriteUnicodeChar(Value: UnicodeChar; Advance: Boolean = True): TMemSize; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Writes Char to the streamer.
    /// </summary>
    /// <param name="Value">
    ///   Char value.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size written (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function WriteChar(Value: Char; Advance: Boolean = True): TMemSize; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Writes ShortString to the streamer.
    /// </summary>
    /// <param name="Value">
    ///   ShortString value.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size written (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function WriteShortString(const Value: ShortString; Advance: Boolean = True): TMemSize; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Writes AnsiString to the streamer.
    /// </summary>
    /// <param name="Value">
    ///   AnsiString value.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size written (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function WriteAnsiString(const Value: AnsiString; Advance: Boolean = True): TMemSize; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Writes UTF8String to the streamer.
    /// </summary>
    /// <param name="Value">
    ///  UTF8String value.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size written (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function WriteUTF8String(const Value: UTF8String; Advance: Boolean = True): TMemSize; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Writes WideString to the streamer.
    /// </summary>
    /// <param name="Value">
    ///   WideString value.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size written (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function WriteWideString(const Value: WideString; Advance: Boolean = True): TMemSize; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Writes UnicodeString to the streamer.
    /// </summary>
    /// <param name="Value">
    ///   UnicodeString value.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size written (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function WriteUnicodeString(const Value: UnicodeString; Advance: Boolean = True): TMemSize; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Writes String to the streamer.
    /// </summary>
    /// <param name="Value">
    ///   String value.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size written (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function WriteString(const Value: String; Advance: Boolean = True): TMemSize; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Writes data buffer to the streamer.
    /// </summary>
    /// <param name="Value">
    ///   Data buffer.
    /// </param>
    /// <param name="Size">
    ///   Size of the buffer (in bytes).
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size written (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function WriteBuffer(const Buffer; Size: TMemSize; Advance: Boolean = True): TMemSize; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Writes array of bytes to the streamer.
    /// </summary>
    /// <param name="Value">
    ///   Array of bytes.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size written (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function WriteBytes(const Value: array of UInt8; Advance: Boolean = True): TMemSize; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Writes specified Value ByteCount times to the streamer.
    /// </summary>
    /// <param name="ByteCount">
    ///   Byte count value.
    /// </param>
    /// <param name="Value">
    ///   Byte value.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size written (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function FillBytes(ByteCount: TMemSize; Value: UInt8; Advance: Boolean = True): TMemSize; virtual;

    {- Read methods  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads Bool value from the streamer.
    /// </summary>
    /// <param name="Value">
    ///   Bool value where read data will be stored in.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size read (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadBool(out Value: ByteBool; Advance: Boolean = True): TMemSize; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads Bool value from the streamer.
    /// </summary>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns read Bool value.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadBool(Advance: Boolean = True): ByteBool; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads Boolean value from the streamer.
    /// </summary>
    /// <param name="Value">
    ///   Boolean value where read data will be stored in.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size read (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadBoolean(out Value: Boolean; Advance: Boolean = True): TMemSize; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads Int8 value from the streamer.
    /// </summary>
    /// <param name="Value">
    ///   Int8 value where read data will be stored in.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size read (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadInt8(out Value: Int8; Advance: Boolean = True): TMemSize; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads Int8 value from the streamer.
    /// </summary>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns read Int8 value.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadInt8(Advance: Boolean = True): Int8; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads UInt8 value from the streamer.
    /// </summary>
    /// <param name="Value">
    ///   UInt8 value where read data will be stored in.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size read (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadUInt8(out Value: UInt8; Advance: Boolean = True): TMemSize; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads UInt8 value from the streamer.
    /// </summary>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns read UInt8 value.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadUInt8(Advance: Boolean = True): UInt8; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads Int16 value from the streamer.
    /// </summary>
    /// <param name="Value">
    ///   Int16 value where read data will be stored in.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size read (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadInt16(out Value: Int16; Advance: Boolean = True): TMemSize; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads Int16 value from the streamer.
    /// </summary>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns read Int16 value.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadInt16(Advance: Boolean = True): Int16; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads UIn16 value from the streamer.
    /// </summary>
    /// <param name="Value">
    ///   UInt16 value where read data will be stored in.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size read (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadUInt16(out Value: UInt16; Advance: Boolean = True): TMemSize; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads UInt16 value from the streamer.
    /// </summary>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns read UInt16 value.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadUInt16(Advance: Boolean = True): UInt16; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads Int32 value from the streamer.
    /// </summary>
    /// <param name="Value">
    ///   Int32 value where read data will be stored in.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size read (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadInt32(out Value: Int32; Advance: Boolean = True): TMemSize; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads Int32 value from the streamer.
    /// </summary>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns read Int32 value.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadInt32(Advance: Boolean = True): Int32; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads UInt32 value from the streamer.
    /// </summary>
    /// <param name="Value">
    ///  UInt32 value where read data will be stored in.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size read (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadUInt32(out Value: UInt32; Advance: Boolean = True): TMemSize; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads UInt32 value from the streamer.
    /// </summary>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns read UInt32 value.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadUInt32(Advance: Boolean = True): UInt32; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads Int64 value from the streamer.
    /// </summary>
    /// <param name="Value">
    ///   Int64 value where read data will be stored in.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size read (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadInt64(out Value: Int64; Advance: Boolean = True): TMemSize; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads Int64 value from the streamer.
    /// </summary>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns read Int64 value.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadInt64(Advance: Boolean = True): Int64; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads UInt64 value from the streamer.
    /// </summary>
    /// <param name="Value">
    ///   UInt64 value where read data will be stored in.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size read (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadUInt64(out Value: UInt64; Advance: Boolean = True): TMemSize; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads UInt64 value from the streamer.
    /// </summary>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns read UInt64 value.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadUInt64(Advance: Boolean = True): UInt64; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads Float32 value from the streamer.
    /// </summary>
    /// <param name="Value">
    ///   Float32 value where read data will be stored in.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size read (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadFloat32(out Value: Float32; Advance: Boolean = True): TMemSize; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads Float32 value from the streamer.
    /// </summary>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns read Float32 value.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadFloat32(Advance: Boolean = True): Float32; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads Float64 value from the streamer.
    /// </summary>
    /// <param name="Value">
    ///   Float64 value where read data will be stored in.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size read (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadFloat64(out Value: Float64; Advance: Boolean = True): TMemSize; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads Float64 value from the streamer.
    /// </summary>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns read Float64 value.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadFloat64(Advance: Boolean = True): Float64; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads Float80 value from the streamer.
    /// </summary>
    /// <param name="Value">
    ///   Float80 value where read data will be stored in.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size read (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadFloat80(out Value: Float80; Advance: Boolean = True): TMemSize; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads Float80 value from the streamer.
    /// </summary>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns read Float80 value.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadFloat80(Advance: Boolean = True): Float80; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads TDateTime value from the streamer.
    /// </summary>
    /// <param name="Value">
    ///   TDateTime value where read data will be stored in.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size read (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadDateTime(out Value: TDateTime; Advance: Boolean = True): TMemSize; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads TDateTime value from the streamer.
    /// </summary>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns read TDateTime value.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadDateTime(Advance: Boolean = True): TDateTime; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads Currency value from the streamer.
    /// </summary>
    /// <param name="Value">
    ///   Currency value where read data will be stored in.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size read (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadCurrency(out Value: Currency; Advance: Boolean = True): TMemSize; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads Currency value from the streamer.
    /// </summary>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns read Currency value.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadCurrency(Advance: Boolean = True): Currency; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads AnsiChar value from the streamer.
    /// </summary>
    /// <param name="Value">
    ///   AnsiChar value where read data will be stored in.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size read (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadAnsiChar(out Value: AnsiChar; Advance: Boolean = True): TMemSize; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads AnsiChar value from the streamer.
    /// </summary>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns read AnsiChar value.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadAnsiChar(Advance: Boolean = True): AnsiChar; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads UTF8Char value from the streamer.
    /// </summary>
    /// <param name="Value">
    ///   UTF8Char value where read data will be stored in.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size read (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadUTF8Char(out Value: UTF8Char; Advance: Boolean = True): TMemSize; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads UTF8Char value from the streamer.
    /// </summary>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns read UTF8Char value.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadUTF8Char(Advance: Boolean = True): UTF8Char; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads WideChar value from the streamer.
    /// </summary>
    /// <param name="Value">
    ///   WideChar value where read data will be stored in.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size read (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadWideChar(out Value: WideChar; Advance: Boolean = True): TMemSize; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads WideChar value from the streamer.
    /// </summary>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns read WideChar value.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadWideChar(Advance: Boolean = True): WideChar; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads UnicodeChar value from the streamer.
    /// </summary>
    /// <param name="Value">
    ///   UnicodeChar value where read data will be stored in.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size read (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadUnicodeChar(out Value: UnicodeChar; Advance: Boolean = True): TMemSize; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads UnicodeChar value from the streamer.
    /// </summary>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns read UnicodeChar value.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadUnicodeChar(Advance: Boolean = True): UnicodeChar; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads Char value from the streamer.
    /// </summary>
    /// <param name="Value">
    ///   Char value where read data will be stored in.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size read (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadChar(out Value: Char; Advance: Boolean = True): TMemSize; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads Char value from the streamer.
    /// </summary>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns read Char value.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadChar(Advance: Boolean = True): Char; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads ShortString value from the streamer.
    /// </summary>
    /// <param name="Value">
    ///   ShortString value where read data will be stored in.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size read (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadShortString(out Value: ShortString; Advance: Boolean = True): TMemSize; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads ShortString value from the streamer.
    /// </summary>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns read ShortString value.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadShortString(Advance: Boolean = True): ShortString; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Read AnsiString value from the streamer.
    /// </summary>
    /// <param name="Value">
    ///   AnsiString value where read data will be stored in.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size read (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadAnsiString(out Value: AnsiString; Advance: Boolean = True): TMemSize; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads AnsiString value from the streamer.
    /// </summary>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns read AnsiString value.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadAnsiString(Advance: Boolean = True): AnsiString; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads UTF8String value from the streamer.
    /// </summary>
    /// <param name="Value">
    ///   UTF8String value where read data will be stored in.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size read (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadUTF8String(out Value: UTF8String; Advance: Boolean = True): TMemSize; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads UTF8String value from the streamer.
    /// </summary>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns read UTF8String value.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadUTF8String(Advance: Boolean = True): UTF8String; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads WideString value from the streamer.
    /// </summary>
    /// <param name="Value">
    ///   WideString value where read data will be stored in.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size read (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadWideString(out Value: WideString; Advance: Boolean = True): TMemSize; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads WideString value from the streamer.
    /// </summary>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns read WideString value.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadWideString(Advance: Boolean = True): WideString; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads UnicodeString value from the streamer.
    /// </summary>
    /// <param name="Value">
    ///   UnicodeString value where read data will be stored in.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size read (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadUnicodeString(out Value: UnicodeString; Advance: Boolean = True): TMemSize; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads UnicodeString value from the streamer.
    /// </summary>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns read UnicodeString value.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadUnicodeString(Advance: Boolean = True): UnicodeString; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads String value from the streamer.
    /// </summary>
    /// <param name="Value">
    ///   String value where read data will be stored in.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size read (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadString(out Value: String; Advance: Boolean = True): TMemSize; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads String value from the streamer.
    /// </summary>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns read String value.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadString(Advance: Boolean = True): String; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads data to a buffer from the streamer.
    /// </summary>
    /// <param name="Buffer">
    ///   Reference to the buffer where read data will be stored in.
    /// </param>
    /// <param name="Size">
    ///   Amount of bytes that will be read from.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag. Default is True.
    /// </param>
    /// <returns>
    ///   Returns actual size read (in bytes).
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadBuffer(var Buffer; Size: TMemSize; Advance: Boolean = True): TMemSize; overload; virtual;

    {- Properties  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Bookmark's value from bookmark with specified Index position.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    property Bookmarks[&Index: Integer]: Int64 read GetBookmark write SetBookmark;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Current position of streamer's caret.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    property CurrentPosition: Int64 read GetCurrentPosition write SetCurrentPosition;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Returns start position of the streamer.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    property StartPosition: Int64 read fStartPosition;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Returns distance between current position and start position of the
    ///   streamer.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    property Distance: Int64 read GetDistance;
  end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- TMemoryStreamer - class definition  - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'TMemoryStreamer - class definition'}{$ENDIF}
type
  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Memory streamer class definition.
  /// </summary>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  TMemoryStreamer = class(TCustomStreamer)
  private
    FCurrentPtr: Pointer;
    FOwnsPointer: Boolean;
    FMemorySize: TMemSize;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves start pointer.
    /// </summary>
    /// <returns>
    ///   Returns start pointer.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetStartPtr: Pointer;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  protected

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Sets new bookmark value at specified Index position.
    /// </summary>
    /// <param name="Index">
    ///   Index position of bookmark which will be set.
    /// </param>
    /// <param name="Value">
    ///   New value of bookmark.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure SetBookmark(Index: Integer; Value: Int64); override;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves current position of the caret.
    /// </summary>
    /// <returns>
    ///   Returns current position of the caret.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetCurrentPosition: Int64; override;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Sets new position of the caret.
    /// </summary>
    /// <param name="NewPosition">
    ///   New position of the caret.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure SetCurrentPosition(NewPosition: Int64); override;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Writes specified data to this streamer.
    /// </summary>
    /// <param name="Value">
    ///   Pointer to the value that will be written.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag.
    /// </param>
    /// <param name="Size">
    ///   Size of the data (in bytes).
    /// </param>
    /// <param name="ValueType">
    ///   Describes type of the value.
    /// </param>
    /// <returns>
    ///   Returns actual size written to this streamer.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function WriteValue(Value: Pointer; Advance: Boolean; Size: TMemSize; ValueType: TValueType): TMemSize; override;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads data from this streamer.
    /// </summary>
    /// <param name="Value">
    ///   Pointer where readed data will be stored in.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag.
    /// </param>
    /// <param name="Size">
    ///   Size of the data to read (in bytes).
    /// </param>
    /// <param name="ValueType">
    ///   Describes type of the value.
    /// </param>
    /// <returns>
    ///   Returns actual size read from this streamer.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadValue(Value: Pointer; Advance: Boolean; Size: TMemSize; ValueType: TValueType): TMemSize; override;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  public

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Constructor with initial Memory pointer which will be used by the
    ///   streamer.
    /// </summary>
    /// <param name="Memory">
    ///   Pointer to memory.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    constructor Create(Memory: Pointer); overload;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Constructor with initial memory size. Streamer will allocated internal
    ///   pointer with MemorySize amount of bytes which will be used as streamer
    ///   data.
    /// </summary>
    /// <param name="MemorySize">
    ///   Amount of bytes which streamer's data will have.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    constructor Create(MemorySize: TMemSize); overload;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Default destructor. If streamer's data was created internally, now
    ///   that data will be released.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    destructor Destroy; override;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Initializes internal structure of the streamer.
    /// </summary>
    /// <param name="Memory">
    ///   Pointer to memory.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure Initialize(Memory: Pointer); reintroduce; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Initializes internal structure of the streamer.
    /// </summary>
    /// <param name="MemorySize">
    ///   Amount of bytes which streamer's data will have.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure Initialize(MemorySize: TMemSize); reintroduce; overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves index of the bookmark which points to specified Position.
    ///   If there isn't bookmark which points to specified Position, -1 will be
    ///   returned.
    /// </summary>
    /// <param name="Position">
    ///   Position in the streamer.
    /// </param>
    /// <returns>
    ///   Returns index of the bookmakr which points to specified Position.
    ///   If there isn't bookmark which points to specified position, -1 will be
    ///   returned.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function IndexOfBookmark(Position: Int64): Integer; override;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Adds new bookmark that points to specified Position.
    /// </summary>
    /// <param name="Position">
    ///   Position value of new bookmark.
    /// </param>
    /// <returns>
    ///   Returns index position of new bookmark.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function AddBookmark(Position: Int64): Integer; override;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Removes bookmark which points to specified Position. If RemoveAll flag
    ///   is set, then all bookmarks that points to specified Position will be
    ///   removed.
    /// </summary>
    /// <param name="Position">
    ///   Position value which will be searched in all bookmarks.
    /// </param>
    /// <param name="RemoveAll">
    ///   If this flag is set to True, all bookmarks which points to specified
    ///   Position will be removed. If False, then only first bookmark with
    ///   specified position will be removed.
    /// <returns>
    ///   If RemoveAll flag is set to False, then this function returns index
    ///   position of first bookmark which was found or -1 if nothing was found.
    ///   If RemoveAll flag is set to True, then this function always returns
    ///   -1.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function RemoveBookmark(Position: Int64; RemoveAll: Boolean = True): Integer; override;

    {- Properties  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   True if streamer creates it's data pointer by it self, otherwise
    ///   False.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    property OwnsPointer: Boolean read FOwnsPointer;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Streamer data memory size (in bytes).
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    property MemorySize: TMemSize read FMemorySize;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Pointer to the streamer's caret.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    property CurrentPtr: Pointer read FCurrentPtr write FCurrentPtr;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Pointer to the begining of the streamer's data.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    property StartPtr: Pointer read GetStartPtr;
  end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- TStreamStreamer - class definition  - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'TStreamStreamer - class definition'}{$ENDIF}
type
  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Stream Streamer class definition.
  /// </summary>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  TStreamStreamer = class(TCustomStreamer)
  private
    FTarget: TStream;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  protected

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves current position of the caret.
    /// </summary>
    /// <returns>
    ///   Returns current position of the caret.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetCurrentPosition: Int64; override;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Sets new position of the caret.
    /// </summary>
    /// <param name="NewPosition">
    ///   New position of the caret.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure SetCurrentPosition(NewPosition: Int64); override;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Writes specified data to this streamer.
    /// </summary>
    /// <param name="Value">
    ///   Pointer to the value that will be written.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag.
    /// </param>
    /// <param name="Size">
    ///   Size of the data (in bytes).
    /// </param>
    /// <param name="ValueType">
    ///   Describes type of the value.
    /// </param>
    /// <returns>
    ///   Returns actual size written to this streamer.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function WriteValue(Value: Pointer; Advance: Boolean; Size: TMemSize; ValueType: TValueType): TMemSize; override;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Reads data from this streamer.
    /// </summary>
    /// <param name="Value">
    ///   Pointer where readed data will be stored in.
    /// </param>
    /// <param name="Advance">
    ///   Advance flag.
    /// </param>
    /// <param name="Size">
    ///   Size of the data to read (in bytes).
    /// </param>
    /// <param name="ValueType">
    ///   Describes type of the value.
    /// </param>
    /// <returns>
    ///   Returns actual size read from this streamer.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ReadValue(Value: Pointer; Advance: Boolean; Size: TMemSize; ValueType: TValueType): TMemSize; override;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  public

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Constructor with initial Target value.
    /// </summary>
    /// <param name="Target">
    ///   Referece to target stream.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    constructor Create(Target: TStream);

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Initializes internal structure of the streamer.
    /// </summary>
    /// <param name="Target">
    ///   Reference to target stream.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure Initialize(Target: TStream); reintroduce; virtual;

    {- Properties  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves target stream class.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    property Target: TStream read FTarget;
  end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

implementation

uses
  StringRectification,
  BasicClasses.Consts;

{$IFDEF FPC_DisableWarns}
 {$DEFINE FPCDWM}
 { Conversion between ordinals and pointers is not portable. }
 {$DEFINE W4055:={$WARN 4055 OFF}}
 { Conversion between ordinals and pointers is not portable. }
 {$DEFINE W4056:={$WARN 4056 OFF}}
 { Parameter "$1" not used. }
 {$DEFINE W5024:={$WARN 5024 OFF}}
 { Local variable "$1" does not seem to be initialized. }
 {$DEFINE W5057:={$WARN 5057 OFF}}
 { Variable "$1" does not seem to be initialized. }
 {$DEFINE W5058:={$WARN 5058 OFF}}
{$ENDIF !FPC_DisableWarns}

{- Auxiliary routines implementation - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Auxiliary routines implementation'}{$ENDIF}
function BoolToNum(Val: Boolean): UInt8;
begin
  { If Val is True, then ... }
  if (Val) then
    { ... return $FF, else ... }
    Result := $FF
  else
    { ... return 0. }
    Result := 0;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function NumToBool(Val: UInt8): Boolean;
begin
  { Return True if Val isn't equal to 0, otherwise False. }
  Result := (Val <> 0);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF ENDIAN_BIG}
type
  Int32Rec = packed record
    LoWord: UInt16;
    HiWord: UInt16;
  end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function SwapEndian(Value: UInt16): UInt16; overload; {$IFDEF CanInline}inline;{$ENDIF}
begin
  Result := UInt16(Value shl 8) or UInt16(Value shr 8);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function SwapEndian(Value: UInt32): UInt32; overload;
begin
  Int32Rec(Result).HiWord := SwapEndian(Int32Rec(Value).LoWord);
  Int32Rec(Result).LoWord := SwapEndian(Int32Rec(Value).HiWord);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function SwapEndian(Value: UInt64): UInt64; overload;
begin
  Int64Rec(Result).Hi := SwapEndian(Int64Rec(Value).Lo);
  Int64Rec(Result).Lo := SwapEndian(Int64Rec(Value).Hi);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function SwapEndian(Value: Float32): Float32; overload;
begin
  Int32Rec(Result).HiWord := SwapEndian(Int32Rec(Value).LoWord);
  Int32Rec(Result).LoWord := SwapEndian(Int32Rec(Value).HiWord);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function SwapEndian(Value: Float64): Float64; overload;
begin
  Int64Rec(Result).Hi := SwapEndian(Int64Rec(Value).Lo);
  Int64Rec(Result).Lo := SwapEndian(Int64Rec(Value).Hi);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function SwapEndian(Value: Float80): Float80; overload;
type
  TOverlay = packed array[0..9] of Byte;
begin
  TOverlay(Result)[0] := TOverlay(Value)[9];
  TOverlay(Result)[1] := TOverlay(Value)[8];
  TOverlay(Result)[2] := TOverlay(Value)[7];
  TOverlay(Result)[3] := TOverlay(Value)[6];
  TOverlay(Result)[4] := TOverlay(Value)[5];
  TOverlay(Result)[5] := TOverlay(Value)[4];
  TOverlay(Result)[6] := TOverlay(Value)[3];
  TOverlay(Result)[7] := TOverlay(Value)[2];
  TOverlay(Result)[8] := TOverlay(Value)[1];
  TOverlay(Result)[9] := TOverlay(Value)[0];
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_WriteUTF16LE(var Dest: PUInt16; Data: PUInt16; Length: TStrSize): TMemSize;
var
  I:  TStrSize;
begin
  Result := 0;

  for I := 1 to Length do
  begin
    Dest^ := SwapEndian(Data^);
    Inc(Dest);
    Inc(Data);
    Inc(Result, SizeOf(UInt16));
  end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadUTF16LE(var Src: PUInt16; Data: PUInt16; Length: TStrSize): TMemSize;
var
  I:  TStrSize;
begin
  Result := 0;

  for I := 1 to Length do
  begin
    Data^ := SwapEndian(Src^);
    Inc(Src);
    Inc(Data);
    Inc(Result, SizeOf(UInt16));
  end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_WriteUTF16LE(Stream: TStream; Data: PUInt16; Length: TStrSize): TMemSize;
var
  I: TStrSize;
  Buff: UInt16;
begin
  Result := 0;

  for I := 1 to Length do
  begin
    Buff := SwapEndian(Data^);
    Stream.WriteBuffer(Buff, SizeOf(UInt16));
    Inc(Result, TMemSize(SizeOf(UInt16)));
    Inc(Data);
  end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

 {$IFDEF FPCDWM}{$PUSH}W5057{$ENDIF}
function Stream_ReadUTF16LE(Stream: TStream; Data: PUInt16; Length: TStrSize): TMemSize;
var
  I: TStrSize;
  Buff: UInt16;
begin
  Result := 0;

  for I := 1 to Length do
  begin
    Stream.ReadBuffer(Buff, SizeOf(UInt16));
    Inc(Result, TMemSize(SizeOf(UInt16)));
    Data^ := SwapEndian(Buff);
    Inc(Data);
  end;
end;
 {$IFDEF FPCDWM}{$POP}{$ENDIF}
{$ENDIF ENDIAN_BIG}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Allocation helper functions implementation  - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Allocation helper functions implementation'}{$ENDIF}
function StreamedSize_Bool: TMemSize;
begin
  Result := SizeOf(UInt8);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function StreamedSize_Boolean: TMemSize;
begin
  Result := StreamedSize_Bool;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function StreamedSize_Int8: TMemSize;
begin
  Result := SizeOf(Int8);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function StreamedSize_UInt8: TMemSize;
begin
  Result := SizeOf(UInt8);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function StreamedSize_Int16: TMemSize;
begin
  Result := SizeOf(Int16);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function StreamedSize_UInt16: TMemSize;
begin
  Result := SizeOf(UInt16);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function StreamedSize_Int32: TMemSize;
begin
  Result := SizeOf(Int32);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function StreamedSize_UInt32: TMemSize;
begin
  Result := SizeOf(UInt32);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function StreamedSize_Int64: TMemSize;
begin
  Result := SizeOf(Int64);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function StreamedSize_UInt64: TMemSize;
begin
  Result := SizeOf(UInt64);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function StreamedSize_Float32: TMemSize;
begin
  Result := SizeOf(Float32);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function StreamedSize_Float64: TMemSize;
begin
  Result := SizeOf(Float64);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function StreamedSize_Float80: TMemSize;
begin
  Result := SizeOf(Float80);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function StreamedSize_DateTime: TMemSize;
begin
  Result := StreamedSize_Float64;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function StreamedSize_Currency: TMemSize;
begin
  Result := SizeOf(Currency);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function StreamedSize_AnsiChar: TMemSize;
begin
  Result := SizeOf(AnsiChar);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function StreamedSize_UTF8Char: TMemSize;
begin
  Result := SizeOf(UTF8Char);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function StreamedSize_WideChar: TMemSize;
begin
  Result := SizeOf(WideChar);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function StreamedSize_UnicodeChar: TMemSize;
begin
  Result := SizeOf(UnicodeChar);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function StreamedSize_Char: TMemSize;
begin
  Result := StreamedSize_UInt16;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function StreamedSize_ShortString(const Str: ShortString): TMemSize;
begin
  Result := StreamedSize_UInt8 + TMemSize(Length(Str));
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function StreamedSize_AnsiString(const Str: AnsiString): TMemSize;
begin
  Result := StreamedSize_Int32 + TMemSize(Length(Str) * SizeOf(AnsiChar));
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function StreamedSize_UTF8String(const Str: UTF8String): TMemSize;
begin
  Result := StreamedSize_Int32 + TMemSize(Length(Str) * SizeOf(UTF8Char));
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function StreamedSize_WideString(const Str: WideString): TMemSize;
begin
  Result := StreamedSize_Int32 + TMemSize(Length(Str) * SizeOf(WideChar));
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function StreamedSize_UnicodeString(const Str: UnicodeString): TMemSize;
begin
  Result := StreamedSize_Int32 + TMemSize(Length(Str) * SizeOf(UnicodeChar));
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function StreamedSize_String(const Str: String): TMemSize;
begin
  Result := StreamedSize_UTF8String(StrToUTF8(Str));
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function StreamedSize_Buffer(Size: TMemSize): TMemSize;
begin
  Result := Size;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function StreamedSize_Bytes(Count: TMemSize): TMemSize;
begin
  Result := Count;
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Memory writing functions implementation - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Memory writing functions implementation'}{$ENDIF}
function Ptr_WriteBool(var Dest: Pointer; Value: ByteBool; Advance: Boolean): TMemSize;
begin
  UInt8(Dest^) := BoolToNum(Value);
  Result := SizeOf(UInt8);

{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
  if (Advance) then
    Dest := Pointer(PtrUInt(Dest) + Result);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_WriteBool(Dest: Pointer; Value: ByteBool): TMemSize;
begin
  Result := Ptr_WriteBool(Dest, Value, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_WriteBoolean(var Dest: Pointer; Value: Boolean; Advance: Boolean): TMemSize;
begin
  Result := Ptr_WriteBool(Dest, Value, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_WriteBoolean(Dest: Pointer; Value: Boolean): TMemSize;
begin
  Result := Ptr_WriteBool(Dest, Value);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_WriteInt8(var Dest: Pointer; Value: Int8; Advance: Boolean): TMemSize;
begin
  Int8(Dest^) := Value;
  Result := SizeOf(Value);

{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
  if (Advance) then
    Dest := Pointer(PtrUInt(Dest) + Result);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_WriteInt8(Dest: Pointer; Value: Int8): TMemSize;
begin
  Result := Ptr_WriteInt8(Dest, Value, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_WriteUInt8(var Dest: Pointer; Value: UInt8; Advance: Boolean): TMemSize;
begin
  UInt8(Dest^) := Value;
  Result := SizeOf(Value);

{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
  if (Advance) then
    Dest := Pointer(PtrUInt(Dest) + Result);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_WriteUInt8(Dest: Pointer; Value: UInt8): TMemSize;
begin
  Result := Ptr_WriteUInt8(Dest, Value, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_WriteInt16(var Dest: Pointer; Value: Int16; Advance: Boolean): TMemSize;
begin
{$IFDEF ENDIAN_BIG}
  Int16(Dest^) := Int16(SwapEndian(UInt16(Value)));
{$ELSE}
  Int16(Dest^) := Value;
{$ENDIF}

  Result := SizeOf(Value);

{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
  if (Advance) then
    Dest := Pointer(PtrUInt(Dest) + Result);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_WriteInt16(Dest: Pointer; Value: Int16): TMemSize;
begin
  Result := Ptr_WriteInt16(Dest, Value, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_WriteUInt16(var Dest: Pointer; Value: UInt16; Advance: Boolean): TMemSize;
begin
{$IFDEF ENDIAN_BIG}
  UInt16(Dest^) := SwapEndian(Value);
{$ELSE}
  UInt16(Dest^) := Value;
{$ENDIF}

  Result := SizeOf(Value);

{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
  if (Advance) then
    Dest := Pointer(PtrUInt(Dest) + Result);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_WriteUInt16(Dest: Pointer; Value: UInt16): TMemSize;
begin
  Result := Ptr_WriteUInt16(Dest, Value, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_WriteInt32(var Dest: Pointer; Value: Int32; Advance: Boolean): TMemSize;
begin
{$IFDEF ENDIAN_BIG}
  Int32(Dest^) := Int32(SwapEndian(UInt32(Value)));
{$ELSE}
  Int32(Dest^) := Value;
{$ENDIF}

  Result := SizeOf(Value);

{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
  if (Advance) then
    Dest := Pointer(PtrUInt(Dest) + Result);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_WriteInt32(Dest: Pointer; Value: Int32): TMemSize;
begin
  Result := Ptr_WriteInt32(Dest, Value, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_WriteUInt32(var Dest: Pointer; Value: UInt32; Advance: Boolean): TMemSize;
begin
{$IFDEF ENDIAN_BIG}
  UInt32(Dest^) := SwapEndian(Value);
{$ELSE}
  UInt32(Dest^) := Value;
{$ENDIF}

  Result := SizeOf(Value);

{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
  if (Advance) then
    Dest := Pointer(PtrUInt(Dest) + Result);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_WriteUInt32(Dest: Pointer; Value: UInt32): TMemSize;
begin
  Result := Ptr_WriteUInt32(Dest, Value, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_WriteInt64(var Dest: Pointer; Value: Int64; Advance: Boolean): TMemSize;
begin
{$IFDEF ENDIAN_BIG}
  Int64(Dest^) := Int64(SwapEndian(UInt64(Value)));
{$ELSE}
  Int64(Dest^) := Value;
{$ENDIF}

  Result := SizeOf(Value);

{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
  if (Advance) then
    Dest := Pointer(PtrUInt(Dest) + Result);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_WriteInt64(Dest: Pointer; Value: Int64): TMemSize;
begin
  Result := Ptr_WriteInt64(Dest, Value, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_WriteUInt64(var Dest: Pointer; Value: UInt64; Advance: Boolean): TMemSize;
begin
{$IFDEF ENDIAN_BIG}
  UInt64(Dest^) := SwapEndian(Value);
{$ELSE}
  UInt64(Dest^) := Value;
{$ENDIF}

  Result := SizeOf(Value);

{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
  if (Advance) then
    Dest := Pointer(PtrUInt(Dest) + Result);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_WriteUInt64(Dest: Pointer; Value: UInt64): TMemSize;
begin
  Result := Ptr_WriteUInt64(Dest, Value, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_WriteFloat32(var Dest: Pointer; Value: Float32; Advance: Boolean): TMemSize;
begin
{$IFDEF ENDIAN_BIG}
  Float32(Dest^) := SwapEndian(Value);
{$ELSE}
  Float32(Dest^) := Value;
{$ENDIF}

  Result := SizeOf(Value);

{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
  if (Advance) then
    Dest := Pointer(PtrUInt(Dest) + Result);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_WriteFloat32(Dest: Pointer; Value: Float32): TMemSize;
begin
  Result := Ptr_WriteFloat32(Dest, Value, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_WriteFloat64(var Dest: Pointer; Value: Float64; Advance: Boolean): TMemSize;
begin
{$IFDEF ENDIAN_BIG}
  Float64(Dest^) := SwapEndian(Value);
{$ELSE}
  Float64(Dest^) := Value;
{$ENDIF}

  Result := SizeOf(Value);

{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
  if (Advance) then
    Dest := Pointer(PtrUInt(Dest) + Result);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_WriteFloat64(Dest: Pointer; Value: Float64): TMemSize;
begin
  Result := Ptr_WriteFloat64(Dest, Value, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_WriteFloat80(var Dest: Pointer; Value: Float80; Advance: Boolean): TMemSize;
begin
{$IFDEF ENDIAN_BIG}
  Float80(Dest^) := SwapEndian(Value);
{$ELSE}
  Float80(Dest^) := Value;
{$ENDIF}

  Result := SizeOf(Value);

{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
  if (Advance) then
    Dest := Pointer(PtrUInt(Dest) + Result);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_WriteFloat80(Dest: Pointer; Value: Float80): TMemSize;
begin
  Result := Ptr_WriteFloat80(Dest, Value, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_WriteDateTime(var Dest: Pointer; Value: TDateTime; Advance: Boolean): TMemSize;
begin
  Result := Ptr_WriteFloat64(Dest, Value, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_WriteDateTime(Dest: Pointer; Value: TDateTime): TMemSize;
begin
  Result := Ptr_WriteDateTime(Dest, Value, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_WriteCurrency(var Dest: Pointer; Value: Currency; Advance: Boolean): TMemSize;
begin
  { Prevent conversion of currency to other types. }
{$IFDEF ENDIAN_BIG}
  Int64(Dest^) := SwapEndian(Int64(Addr(Value)^));
{$ELSE}
  Int64(Dest^) := Int64(Addr(Value)^);
{$ENDIF}

  Result := SizeOf(Value);

{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
  if (Advance) then
    Dest := Pointer(PtrUInt(Dest) + Result);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_WriteCurrency(Dest: Pointer; Value: Currency): TMemSize;
begin
  Result := Ptr_WriteCurrency(Dest, Value, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_WriteAnsiChar(var Dest: Pointer; Value: AnsiChar; Advance: Boolean): TMemSize;
begin
  AnsiChar(Dest^) := Value;
  Result := SizeOf(Value);

{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
  if (Advance) then
    Dest := Pointer(PtrUInt(Dest) + Result);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_WriteAnsiChar(Dest: Pointer; Value: AnsiChar): TMemSize;
begin
  Result := Ptr_WriteAnsiChar(Dest, Value, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_WriteUTF8Char(var Dest: Pointer; Value: UTF8Char; Advance: Boolean): TMemSize;
begin
  UTF8Char(Dest^) := Value;
  Result := SizeOf(Value);

{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
  if (Advance) then
    Dest := Pointer(PtrUInt(Dest) + Result);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_WriteUTF8Char(Dest: Pointer; Value: UTF8Char): TMemSize;
begin
  Result := Ptr_WriteUTF8Char(Dest, Value, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_WriteWideChar(var Dest: Pointer; Value: WideChar; Advance: Boolean): TMemSize;
begin
{$IFDEF ENDIAN_BIG}
  WideChar(Dest^) := WideChar(SwapEndian(UInt16(Value)));
{$ELSE}
  WideChar(Dest^) := Value;
{$ENDIF}

  Result := SizeOf(Value);

{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
  if (Advance) then
    Dest := Pointer(PtrUInt(Dest) + Result);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_WriteWideChar(Dest: Pointer; Value: WideChar): TMemSize;
begin
  Result := Ptr_WriteWideChar(Dest, Value, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_WriteUnicodeChar(var Dest: Pointer; Value: UnicodeChar; Advance: Boolean): TMemSize;
begin
{$IFDEF ENDIAN_BIG}
  UnicodeChar(Dest^) := UnicodeChar(SwapEndian(UInt16(Value)));
{$ELSE}
  UnicodeChar(Dest^) := Value;
{$ENDIF}

  Result := SizeOf(Value);

{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
  if (Advance) then
    Dest := Pointer(PtrUInt(Dest) + Result);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_WriteUnicodeChar(Dest: Pointer; Value: UnicodeChar): TMemSize;
begin
  Result := Ptr_WriteUnicodeChar(Dest, Value, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_WriteChar(var Dest: Pointer; Value: Char; Advance: Boolean): TMemSize;
begin
  Result := Ptr_WriteUInt16(Dest, UInt16(Ord(Value)), Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_WriteChar(Dest: Pointer; Value: Char): TMemSize;
begin
  Result := Ptr_WriteChar(Dest, Value, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_WriteShortString(var Dest: Pointer; const Str: ShortString; Advance: Boolean): TMemSize;
var
  WorkPtr: Pointer;
begin
  if (Assigned(Dest)) then
  begin
    WorkPtr := Dest;
    Result := Ptr_WriteUInt8(WorkPtr, UInt8(Length(Str)), True);
    Inc(Result, Ptr_WriteBuffer(WorkPtr, (Addr(Str[1]))^, Length(Str), True));

    If (Advance) then
      Dest := WorkPtr;
  end else
    Result := Length(Str) + 1;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_WriteShortString(Dest: Pointer; const Str: ShortString): TMemSize;
begin
  Result := Ptr_WriteShortString(Dest, Str, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_WriteAnsiString(var Dest: Pointer; const Str: AnsiString; Advance: Boolean): TMemSize;
var
  WorkPtr: Pointer;
begin
  if (Assigned(Dest)) then
  begin
    WorkPtr := Dest;
    Result := Ptr_WriteInt32(WorkPtr, Length(Str), True);
    Inc(Result, Ptr_WriteBuffer(WorkPtr, PAnsiChar(Str)^, Length(Str) * SizeOf(AnsiChar), True));

    if (Advance) then
      Dest := WorkPtr;
  end else
    Result := SizeOf(Int32) + (Length(Str) * SizeOf(AnsiChar));
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_WriteAnsiString(Dest: Pointer; const Str: AnsiString): TMemSize;
begin
  Result := Ptr_WriteAnsiString(Dest, Str, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_WriteUTF8String(var Dest: Pointer; const Str: UTF8String; Advance: Boolean): TMemSize;
var
  WorkPtr:  Pointer;
begin
  if (Assigned(Dest)) then
  begin
    WorkPtr := Dest;
    Result := Ptr_WriteInt32(WorkPtr, Length(Str), True);
    Inc(Result, Ptr_WriteBuffer(WorkPtr, PUTF8Char(Str)^, Length(Str) * SizeOf(UTF8Char), True));

    If (Advance) then
      Dest := WorkPtr;
  end else
    Result := SizeOf(Int32) + (Length(Str) * SizeOf(UTF8Char));
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_WriteUTF8String(Dest: Pointer; const Str: UTF8String): TMemSize;
begin
  Result := Ptr_WriteUTF8String(Dest, Str, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_WriteWideString(var Dest: Pointer; const Str: WideString; Advance: Boolean): TMemSize;
var
  WorkPtr:  Pointer;
begin
  if (Assigned(Dest)) then
  begin
    WorkPtr := Dest;
    Result := Ptr_WriteInt32(WorkPtr, Length(Str), True);
{$IFDEF ENDIAN_BIG}
    Inc(Result, Ptr_WriteUTF16LE(PUInt16(WorkPtr), PUInt16(PWideChar(Str)), Length(Str)));
{$ELSE}
    Inc(Result, Ptr_WriteBuffer(WorkPtr, PWideChar(Str)^, Length(Str) * SizeOf(WideChar), True));
{$ENDIF}

    if (Advance) then
      Dest := WorkPtr;
  end else
    Result := SizeOf(Int32) + (Length(Str) * SizeOf(WideChar));
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_WriteWideString(Dest: Pointer; const Str: WideString): TMemSize;
begin
  Result := Ptr_WriteWideString(Dest, Str, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_WriteUnicodeString(var Dest: Pointer; const Str: UnicodeString; Advance: Boolean): TMemSize;
var
  WorkPtr:  Pointer;
begin
  if (Assigned(Dest)) then
  begin
    WorkPtr := Dest;
    Result := Ptr_WriteInt32(WorkPtr, Length(Str), True);
{$IFDEF ENDIAN_BIG}
    Inc(Result, Ptr_WriteUTF16LE(PUInt16(WorkPtr), PUInt16(PUnicodeChar(Str)), Length(Str)));
{$ELSE}
    Inc(Result, Ptr_WriteBuffer(WorkPtr, PUnicodeChar(Str)^, Length(Str) * SizeOf(UnicodeChar), True));
{$ENDIF}

    if (Advance) then
      Dest := WorkPtr;
  end else
    Result := SizeOf(Int32) + (Length(Str) * SizeOf(UnicodeChar));
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_WriteUnicodeString(Dest: Pointer; const Str: UnicodeString): TMemSize;
begin
  Result := Ptr_WriteUnicodeString(Dest, Str, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_WriteString(var Dest: Pointer; const Str: String; Advance: Boolean): TMemSize;
begin
  Result := Ptr_WriteUTF8String(Dest, StrToUTF8(Str), Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_WriteString(Dest: Pointer; const Str: String): TMemSize;
begin
  Result := Ptr_WriteString(Dest, Str, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_WriteBuffer(var Dest: Pointer; const Buffer; Size: TMemSize; Advance: Boolean): TMemSize;
begin
  Move(Buffer, Dest^, Size);
  Result := Size;

{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
  if (Advance) then
    Dest := Pointer(PtrUInt(Dest) + Result);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_WriteBuffer(Dest: Pointer; const Buffer; Size: TMemSize): TMemSize;
begin
  Result := Ptr_WriteBuffer(Dest, Buffer, Size, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_WriteBytes(var Dest: Pointer; const Value: array of UInt8; Advance: Boolean): TMemSize;
var
  I: Integer;
begin
  Result := 0;

  for I := Low(Value) to High(Value) do
    Inc(Result, Ptr_WriteUInt8(Dest, Value[i], True));

{$IFDEF FPCDWM}{$PUSH}W4055 W4056{$ENDIF}
  if (not Advance) then
    Dest := Pointer(PtrUInt(Dest) - Result);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_WriteBytes(Dest: Pointer; const Value: array of UInt8): TMemSize;
begin
  Result := Ptr_WriteBytes(Dest, Value, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_FillBytes(var Dest: Pointer; Count: TMemSize; Value: UInt8; Advance: Boolean): TMemSize;
begin
  FillChar(Dest^, Count, Value);
  Result := Count;

{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
  if (Advance) then
    Dest := Pointer(PtrUInt(Dest) + Result);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_FillBytes(Dest: Pointer; Count: TMemSize; Value: UInt8): TMemSize;
begin
  Result := Ptr_FillBytes(Dest, Count, Value, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Memory reading functions implementation - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Memory reading functions implementation'}{$ENDIF}
function Ptr_ReadBool(var Src: Pointer; out Value: ByteBool; Advance: Boolean): TMemSize;
begin
  Value := NumToBool(UInt8(Src^));
  Result := SizeOf(UInt8);

{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
  if (Advance) then
    Src := Pointer(PtrUInt(Src) + Result);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadBool(Src: Pointer; out Value: ByteBool): TMemSize;
begin
  Result := Ptr_ReadBool(Src, Value, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadBool(var Src: Pointer; Advance: Boolean): ByteBool;
begin
  Ptr_ReadBool(Src, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadBool(Src: Pointer): ByteBool;
begin
  Ptr_ReadBool(Src, Result, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadBoolean(var Src: Pointer; out Value: Boolean; Advance: Boolean): TMemSize;
var
  TempBool: ByteBool;
begin
  Result := Ptr_ReadBool(Src, TempBool, Advance);
  Value := TempBool;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadBoolean(Src: Pointer; out Value: Boolean): TMemSize;
begin
  Result := Ptr_ReadBoolean(Src, Value, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadInt8(var Src: Pointer; out Value: Int8; Advance: Boolean): TMemSize;
begin
  Value := Int8(Src^);
  Result := SizeOf(Value);

{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
  if (Advance) then
    Src := Pointer(PtrUInt(Src) + Result);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadInt8(Src: Pointer; out Value: Int8): TMemSize;
begin
  Result := Ptr_ReadInt8(Src, Value, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadInt8(var Src: Pointer; Advance: Boolean): Int8;
begin
  Ptr_ReadInt8(Src, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadInt8(Src: Pointer): Int8;
begin
  Ptr_ReadInt8(Src, Result, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadUInt8(var Src: Pointer; out Value: UInt8; Advance: Boolean): TMemSize;
begin
  Value := UInt8(Src^);
  Result := SizeOf(Value);

{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
  if (Advance) then
    Src := Pointer(PtrUInt(Src) + Result);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadUInt8(Src: Pointer; out Value: UInt8): TMemSize;
begin
  Result := Ptr_ReadUInt8(Src, Value, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadUInt8(var Src: Pointer; Advance: Boolean): UInt8;
begin
  Ptr_ReadUInt8(Src, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadUInt8(Src: Pointer): UInt8;
begin
  Ptr_ReadUInt8(Src, Result, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadInt16(var Src: Pointer; out Value: Int16; Advance: Boolean): TMemSize;
begin
{$IFDEF ENDIAN_BIG}
  Value := Int16(SwapEndian(UInt16(Src^)));
{$ELSE}
  Value := Int16(Src^);
{$ENDIF}

  Result := SizeOf(Value);

{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
  if (Advance) then
    Src := Pointer(PtrUInt(Src) + Result);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadInt16(Src: Pointer; out Value: Int16): TMemSize;
begin
  Result := Ptr_ReadInt16(Src, Value, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadInt16(var Src: Pointer; Advance: Boolean): Int16;
begin
  Ptr_ReadInt16(Src, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadInt16(Src: Pointer): Int16;
begin
  Ptr_ReadInt16(Src, Result, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadUInt16(var Src: Pointer; out Value: UInt16; Advance: Boolean): TMemSize;
begin
{$IFDEF ENDIAN_BIG}
  Value := SwapEndian(UInt16(Src^));
{$ELSE}
  Value := UInt16(Src^);
{$ENDIF}

  Result := SizeOf(Value);

{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
  if (Advance) then
    Src := Pointer(PtrUInt(Src) + Result);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadUInt16(Src: Pointer; out Value: UInt16): TMemSize;
begin
  Result := Ptr_ReadUInt16(Src, Value, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadUInt16(var Src: Pointer; Advance: Boolean): UInt16;
begin
  Ptr_ReadUInt16(Src, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadUInt16(Src: Pointer): UInt16;
begin
  Ptr_ReadUInt16(Src, Result, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadInt32(var Src: Pointer; out Value: Int32; Advance: Boolean): TMemSize;
begin
{$IFDEF ENDIAN_BIG}
  Value := Int32(SwapEndian(UInt32(Src^)));
{$ELSE}
  Value := Int32(Src^);
{$ENDIF}

  Result := SizeOf(Value);

{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
  if (Advance) then
    Src := Pointer(PtrUInt(Src) + Result);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadInt32(Src: Pointer; out Value: Int32): TMemSize;
begin
  Result := Ptr_ReadInt32(Src, Value, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadInt32(var Src: Pointer; Advance: Boolean): Int32;
begin
  Ptr_ReadInt32(Src, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadInt32(Src: Pointer): Int32;
begin
  Ptr_ReadInt32(Src, Result, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadUInt32(var Src: Pointer; out Value: UInt32; Advance: Boolean): TMemSize;
begin
{$IFDEF ENDIAN_BIG}
  Value := SwapEndian(UInt32(Src^));
{$ELSE}
  Value := UInt32(Src^);
{$ENDIF}

  Result := SizeOf(Value);

{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
  if (Advance) then
    Src := Pointer(PtrUInt(Src) + Result);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadUInt32(Src: Pointer; out Value: UInt32): TMemSize;
begin
  Result := Ptr_ReadUInt32(Src, Value, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadUInt32(var Src: Pointer; Advance: Boolean): UInt32;
begin
  Ptr_ReadUInt32(Src, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadUInt32(Src: Pointer): UInt32;
begin
  Ptr_ReadUInt32(Src, Result, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadInt64(var Src: Pointer; out Value: Int64; Advance: Boolean): TMemSize;
begin
{$IFDEF ENDIAN_BIG}
  Value := Int64(SwapEndian(UInt64(Src^)));
{$ELSE}
  Value := Int64(Src^);
{$ENDIF}

  Result := SizeOf(Value);

{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
  if (Advance) then
    Src := Pointer(PtrUInt(Src) + Result);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadInt64(Src: Pointer; out Value: Int64): TMemSize;
begin
  Result := Ptr_ReadInt64(Src, Value, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadInt64(var Src: Pointer; Advance: Boolean): Int64;
begin
  Ptr_ReadInt64(Src, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadInt64(Src: Pointer): Int64;
begin
  Ptr_ReadInt64(Src, Result, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadUInt64(var Src: Pointer; out Value: UInt64; Advance: Boolean): TMemSize;
begin
{$IFDEF ENDIAN_BIG}
  Value := SwapEndian(UInt64(Src^));
{$ELSE}
  Value := UInt64(Src^);
{$ENDIF}

  Result := SizeOf(Value);

{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
  if (Advance) then
    Src := Pointer(PtrUInt(Src) + Result);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadUInt64(Src: Pointer; out Value: UInt64): TMemSize;
begin
  Result := Ptr_ReadUInt64(Src, Value, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadUInt64(var Src: Pointer; Advance: Boolean): UInt64;
begin
  Ptr_ReadUInt64(Src, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadUInt64(Src: Pointer): UInt64;
begin
  Ptr_ReadUInt64(Src, Result, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadFloat32(var Src: Pointer; out Value: Float32; Advance: Boolean): TMemSize;
begin
{$IFDEF ENDIAN_BIG}
  Value := SwapEndian(Float32(Src^));
{$ELSE}
  Value := Float32(Src^);
{$ENDIF}

  Result := SizeOf(Value);

{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
  if (Advance) then
    Src := Pointer(PtrUInt(Src) + Result);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadFloat32(Src: Pointer; out Value: Float32): TMemSize;
begin
  Result := Ptr_ReadFloat32(Src, Value, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadFloat32(var Src: Pointer; Advance: Boolean): Float32;
begin
  Ptr_ReadFloat32(Src, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadFloat32(Src: Pointer): Float32;
begin
  Ptr_ReadFloat32(Src, Result, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadFloat64(var Src: Pointer; out Value: Float64; Advance: Boolean): TMemSize;
begin
{$IFDEF ENDIAN_BIG}
  Value := SwapEndian(Float64(Src^));
{$ELSE}
  Value := Float64(Src^);
{$ENDIF}

  Result := SizeOf(Value);

{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
  if (Advance) then
    Src := Pointer(PtrUInt(Src) + Result);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadFloat64(Src: Pointer; out Value: Float64): TMemSize;
begin
  Result := Ptr_ReadFloat64(Src, Value, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadFloat64(var Src: Pointer; Advance: Boolean): Float64;
begin
  Ptr_ReadFloat64(Src, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadFloat64(Src: Pointer): Float64;
begin
  Ptr_ReadFloat64(Src, Result, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadFloat80(var Src: Pointer; out Value: Float80; Advance: Boolean): TMemSize;
begin
{$IFDEF ENDIAN_BIG}
  Value := SwapEndian(Float80(Src^));
{$ELSE}
  Value := Float80(Src^);
{$ENDIF}

  Result := SizeOf(Value);

{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
  if (Advance) then
    Src := Pointer(PtrUInt(Src) + Result);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadFloat80(Src: Pointer; out Value: Float80): TMemSize;
begin
  Result := Ptr_ReadFloat80(Src, Value, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadFloat80(var Src: Pointer; Advance: Boolean): Float80;
begin
  Ptr_ReadFloat80(Src, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadFloat80(Src: Pointer): Float80;
begin
  Ptr_ReadFloat80(Src, Result, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadDateTime(var Src: Pointer; out Value: TDateTime; Advance: Boolean): TMemSize;
begin
  Result := Ptr_ReadFloat64(Src, Float64(Value), Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadDateTime(Src: Pointer; out Value: TDateTime): TMemSize;
begin
  Result := Ptr_ReadDateTime(Src, Value, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadDateTime(var Src: Pointer; Advance: Boolean): TDateTime;
begin
  Ptr_ReadDateTime(Src, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadDateTime(Src: Pointer): TDateTime;
begin
  Ptr_ReadDateTime(Src, Result, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadCurrency(var Src: Pointer; out Value: Currency; Advance: Boolean): TMemSize;
{$IFDEF ENDIAN_BIG}
var
  Temp: UInt64 absolute Value;
{$ENDIF}
begin
{$IFDEF ENDIAN_BIG}
  Temp := SwapEndian(UInt64(Src^));
{$ELSE}
  Value := Currency(Src^);
{$ENDIF}

  Result := SizeOf(Value);

{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
  if (Advance) then
    Src := Pointer(PtrUInt(Src) + Result);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadCurrency(Src: Pointer; out Value: Currency): TMemSize;
begin
  Result := Ptr_ReadCurrency(Src, Value, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadCurrency(var Src: Pointer; Advance: Boolean): Currency;
begin
  Ptr_ReadCurrency(Src, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadCurrency(Src: Pointer): Currency;
begin
  Ptr_ReadCurrency(Src, Result, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadAnsiChar(var Src: Pointer; out Value: AnsiChar; Advance: Boolean): TMemSize;
begin
  Value := AnsiChar(Src^);
  Result := SizeOf(Value);

{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
  if (Advance) then
    Src := Pointer(PtrUInt(Src) + Result);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadAnsiChar(Src: Pointer; out Value: AnsiChar): TMemSize;
begin
  Result := Ptr_ReadAnsiChar(Src, Value, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadAnsiChar(var Src: Pointer; Advance: Boolean): AnsiChar;
begin
  Ptr_ReadAnsiChar(Src, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadAnsiChar(Src: Pointer): AnsiChar;
begin
  Ptr_ReadAnsiChar(Src, Result, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadUTF8Char(var Src: Pointer; out Value: UTF8Char; Advance: Boolean): TMemSize;
begin
  Value := UTF8Char(Src^);
  Result := SizeOf(Value);

{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
  if (Advance) then
    Src := Pointer(PtrUInt(Src) + Result);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadUTF8Char(Src: Pointer; out Value: UTF8Char): TMemSize;
begin
  Result := Ptr_ReadUTF8Char(Src, Value, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadUTF8Char(var Src: Pointer; Advance: Boolean): UTF8Char;
begin
  Ptr_ReadUTF8Char(Src, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadUTF8Char(Src: Pointer): UTF8Char;
begin
  Ptr_ReadUTF8Char(Src, Result, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadWideChar(var Src: Pointer; out Value: WideChar; Advance: Boolean): TMemSize;
begin
{$IFDEF ENDIAN_BIG}
  Value := WideChar(SwapEndian(UInt16(Src^)));
{$ELSE}
  Value := WideChar(Src^);
{$ENDIF}

  Result := SizeOf(Value);

{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
  if (Advance) then
    Src := Pointer(PtrUInt(Src) + Result);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadWideChar(Src: Pointer; out Value: WideChar): TMemSize;
begin
  Result := Ptr_ReadWideChar(Src, Value, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadWideChar(var Src: Pointer; Advance: Boolean): WideChar;
begin
  Ptr_ReadWideChar(Src, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadWideChar(Src: Pointer): WideChar;
begin
  Ptr_ReadWideChar(Src, Result, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadUnicodeChar(var Src: Pointer; out Value: UnicodeChar; Advance: Boolean): TMemSize;
begin
{$IFDEF ENDIAN_BIG}
  Value := UnicodeChar(SwapEndian(UInt16(Src^)));
{$ELSE}
  Value := UnicodeChar(Src^);
{$ENDIF}

  Result := SizeOf(Value);

{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
  if (Advance) then
    Src := Pointer(PtrUInt(Src) + Result);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadUnicodeChar(Src: Pointer; out Value: UnicodeChar): TMemSize;
begin
  Result := Ptr_ReadUnicodeChar(Src, Value, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadUnicodeChar(var Src: Pointer; Advance: Boolean): UnicodeChar;
begin
  Ptr_ReadUnicodeChar(Src, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadUnicodeChar(Src: Pointer): UnicodeChar;
begin
  Ptr_ReadUnicodeChar(Src, Result, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadChar(var Src: Pointer; out Value: Char; Advance: Boolean): TMemSize;
var
  Temp: UInt16;
begin
  Result := Ptr_ReadUInt16(Src, Temp, Advance);
  Value := Char(Temp);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadChar(Src: Pointer; out Value: Char): TMemSize;
begin
  Result := Ptr_ReadChar(Src, Value, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadChar(var Src: Pointer; Advance: Boolean): Char;
begin
  Ptr_ReadChar(Src, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadChar(Src: Pointer): Char;
begin
  Ptr_ReadChar(Src, Result, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadShortString(var Src: Pointer; out Str: ShortString; Advance: Boolean): TMemSize;
var
  StrLength: UInt8;
  WorkPtr: Pointer;
begin
  WorkPtr := Src;
  Result := Ptr_ReadUInt8(WorkPtr, StrLength, True);
  SetLength(Str, StrLength);
  Inc(Result, Ptr_ReadBuffer(WorkPtr, Addr(Str[1])^, StrLength, True));

  if (Advance) then
    Src := WorkPtr;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadShortString(Src: Pointer; out Str: ShortString): TMemSize;
begin
  Result := Ptr_ReadShortString(Src, Str, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadShortString(var Src: Pointer; Advance: Boolean): ShortString;
begin
  Ptr_ReadShortString(Src, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadShortString(Src: Pointer): ShortString;
begin
  Ptr_ReadShortString(Src, Result, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadAnsiString(var Src: Pointer; out Str: AnsiString; Advance: Boolean): TMemSize;
var
  StrLength: Int32;
  WorkPtr: Pointer;
begin
  WorkPtr := Src;
  Result := Ptr_ReadInt32(WorkPtr, StrLength, True);
  SetLength(Str, StrLength);
  Inc(Result, Ptr_ReadBuffer(WorkPtr, PAnsiChar(Str)^, StrLength * SizeOf(AnsiChar), True));

  if (Advance) then
    Src := WorkPtr;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadAnsiString(Src: Pointer; out Str: AnsiString): TMemSize;
begin
  Result := Ptr_ReadAnsiString(Src, Str, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadAnsiString(var Src: Pointer; Advance: Boolean): AnsiString;
begin
  Ptr_ReadAnsiString(Src, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadAnsiString(Src: Pointer): AnsiString;
begin
  Ptr_ReadAnsiString(Src, Result, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadUTF8String(var Src: Pointer; out Str: UTF8String; Advance: Boolean): TMemSize;
var
  StrLength: Int32;
  WorkPtr: Pointer;
begin
  WorkPtr := Src;
  Result := Ptr_ReadInt32(WorkPtr, StrLength, True);
  SetLength(Str, StrLength);
  Inc(Result, Ptr_ReadBuffer(WorkPtr, PUTF8Char(Str)^, StrLength * SizeOf(UTF8Char), True));

  if (Advance) then
    Src := WorkPtr;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadUTF8String(Src: Pointer; out Str: UTF8String): TMemSize;
begin
  Result := Ptr_ReadUTF8String(Src, Str, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadUTF8String(var Src: Pointer; Advance: Boolean): UTF8String;
begin
  Ptr_ReadUTF8String(Src, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadUTF8String(Src: Pointer): UTF8String;
begin
  Ptr_ReadUTF8String(Src, Result, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadWideString(var Src: Pointer; out Str: WideString; Advance: Boolean): TMemSize;
var
  StrLength: Int32;
  WorkPtr: Pointer;
begin
  WorkPtr := Src;
  Result := Ptr_ReadInt32(WorkPtr, StrLength, True);
  SetLength(Str, StrLength);

{$IFDEF ENDIAN_BIG}
  Inc(Result, Ptr_ReadUTF16LE(PUInt16(WorkPtr), PUInt16(PWideChar(Str)), StrLength));
{$ELSE}
  Inc(Result, Ptr_ReadBuffer(WorkPtr, PWideChar(Str)^, StrLength * SizeOf(WideChar), True));
{$ENDIF}

  if (Advance) then
    Src := WorkPtr;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadWideString(Src: Pointer; out Str: WideString): TMemSize;
begin
  Result := Ptr_ReadWideString(Src, Str, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadWideString(var Src: Pointer; Advance: Boolean): WideString;
begin
  Ptr_ReadWideString(Src, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadWideString(Src: Pointer): WideString;
begin
  Ptr_ReadWideString(Src, Result, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadUnicodeString(var Src: Pointer; out Str: UnicodeString; Advance: Boolean): TMemSize;
var
  StrLength: Int32;
  WorkPtr: Pointer;
begin
  WorkPtr := Src;
  Result := Ptr_ReadInt32(WorkPtr, StrLength, True);
  SetLength(Str, StrLength);

{$IFDEF ENDIAN_BIG}
  Inc(Result, Ptr_ReadUTF16LE(PUInt16(WorkPtr), PUInt16(PUnicodeChar(Str)), StrLength));
{$ELSE}
  Inc(Result, Ptr_ReadBuffer(WorkPtr, PUnicodeChar(Str)^, StrLength * SizeOf(UnicodeChar), True));
{$ENDIF}

  if (Advance) then
    Src := WorkPtr;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadUnicodeString(Src: Pointer; out Str: UnicodeString): TMemSize;
begin
  Result := Ptr_ReadUnicodeString(Src, Str, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadUnicodeString(var Src: Pointer; Advance: Boolean): UnicodeString;
begin
  Ptr_ReadUnicodeString(Src, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadUnicodeString(Src: Pointer): UnicodeString;
begin
  Ptr_ReadUnicodeString(Src, Result, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadString(var Src: Pointer; out Str: String; Advance: Boolean): TMemSize;
var
  TempStr: UTF8String;
begin
  Result := Ptr_ReadUTF8String(Src, TempStr, Advance);
  Str := UTF8ToStr(TempStr);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadString(Src: Pointer; out Str: String): TMemSize;
begin
  Result := Ptr_ReadString(Src, Str, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadString(var Src: Pointer; Advance: Boolean): String;
begin
  Ptr_ReadString(Src, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadString(Src: Pointer): String;
begin
  Ptr_ReadString(Src, Result, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Ptr_ReadBuffer(var Src: Pointer; var Buffer; Size: TMemSize; Advance: Boolean): TMemSize;
begin
  Move(Src^, Buffer, Size);
  Result := Size;

{$IFDEF FPCDWM}{$PUSH}W4055{$ENDIF}
  if (Advance) then
    Src := Pointer(PtrUInt(Src) + Result);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5058{$ENDIF}
function Ptr_ReadBuffer(Src: Pointer; var Buffer; Size: TMemSize): TMemSize;
begin
  Result := Ptr_ReadBuffer(Src, Buffer, Size, False);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Stream writing functions implementation - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Stream writing functions implementation'}{$ENDIF}
function Stream_WriteBool(Stream: TStream; Value: ByteBool; Advance: Boolean = True): TMemSize;
var
  Temp: UInt8;
begin
  Temp := BoolToNum(Value);
  Stream.WriteBuffer(Temp, SizeOf(Temp));
  Result := SizeOf(Temp);

  If (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_WriteBoolean(Stream: TStream; Value: Boolean; Advance: Boolean = True): TMemSize;
begin
  Result := Stream_WriteBool(Stream, Value, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_WriteInt8(Stream: TStream; Value: Int8; Advance: Boolean = True): TMemSize;
begin
  Stream.WriteBuffer(Value, SizeOf(Value));
  Result := SizeOf(Value);

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_WriteUInt8(Stream: TStream; Value: UInt8; Advance: Boolean = True): TMemSize;
begin
  Stream.WriteBuffer(Value, SizeOf(Value));
  Result := SizeOf(Value);

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_WriteInt16(Stream: TStream; Value: Int16; Advance: Boolean = True): TMemSize;
begin
{$IFDEF ENDIAN_BIG}
  Value := Int16(SwapEndian(UInt16(Value)));
{$ENDIF}

  Stream.WriteBuffer(Value, SizeOf(Value));
  Result := SizeOf(Value);

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_WriteUInt16(Stream: TStream; Value: UInt16; Advance: Boolean = True): TMemSize;
begin
{$IFDEF ENDIAN_BIG}
  Value := SwapEndian(Value);
{$ENDIF}

  Stream.WriteBuffer(Value, SizeOf(Value));
  Result := SizeOf(Value);

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_WriteInt32(Stream: TStream; Value: Int32; Advance: Boolean = True): TMemSize;
begin
{$IFDEF ENDIAN_BIG}
  Value := Int32(SwapEndian(UInt32(Value)));
{$ENDIF}

  Stream.WriteBuffer(Value, SizeOf(Value));
  Result := SizeOf(Value);

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_WriteUInt32(Stream: TStream; Value: UInt32; Advance: Boolean = True): TMemSize;
begin
{$IFDEF ENDIAN_BIG}
  Value := SwapEndian(Value);
{$ENDIF}

  Stream.WriteBuffer(Value, SizeOf(Value));
  Result := SizeOf(Value);

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_WriteInt64(Stream: TStream; Value: Int64; Advance: Boolean = True): TMemSize;
begin
{$IFDEF ENDIAN_BIG}
  Value := Int64(SwapEndian(UInt64(Value)));
{$ENDIF}

  Stream.WriteBuffer(Value, SizeOf(Value));
  Result := SizeOf(Value);

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_WriteUInt64(Stream: TStream; Value: UInt64; Advance: Boolean = True): TMemSize;
begin
{$IFDEF ENDIAN_BIG}
  Value := SwapEndian(Value);
{$ENDIF}

  Stream.WriteBuffer(Value, SizeOf(Value));
  Result := SizeOf(Value);

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_WriteFloat32(Stream: TStream; Value: Float32; Advance: Boolean = True): TMemSize;
begin
{$IFDEF ENDIAN_BIG}
  Value := SwapEndian(Value);
{$ENDIF}

  Stream.WriteBuffer(Value, SizeOf(Value));
  Result := SizeOf(Value);

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_WriteFloat64(Stream: TStream; Value: Float64; Advance: Boolean = True): TMemSize;
begin
{$IFDEF ENDIAN_BIG}
  Value := SwapEndian(Value);
{$ENDIF}

  Stream.WriteBuffer(Value, SizeOf(Value));
  Result := SizeOf(Value);

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_WriteFloat80(Stream: TStream; Value: Float80; Advance: Boolean = True): TMemSize;
begin
{$IFDEF ENDIAN_BIG}
  Value := SwapEndian(Value);
{$ENDIF}

  Stream.WriteBuffer(Value, SizeOf(Value));
  Result := SizeOf(Value);

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_WriteDateTime(Stream: TStream; Value: TDateTime; Advance: Boolean = True): TMemSize;
begin
  Result := Stream_WriteFloat64(Stream, Value, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_WriteCurrency(Stream: TStream; Value: Currency; Advance: Boolean = True): TMemSize;
begin
{$IFDEF ENDIAN_BIG}
  UInt64(Addr(Value)^) := SwapEndian(UInt64(Addr(Value)^));
{$ENDIF}

  Stream.WriteBuffer(Value, SizeOf(Value));
  Result := SizeOf(Value);

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_WriteAnsiChar(Stream: TStream; Value: AnsiChar; Advance: Boolean = True): TMemSize;
begin
  Stream.WriteBuffer(Value, SizeOf(Value));
  Result := SizeOf(Value);

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_WriteUTF8Char(Stream: TStream; Value: UTF8Char; Advance: Boolean = True): TMemSize;
begin
  Stream.WriteBuffer(Value, SizeOf(Value));
  Result := SizeOf(Value);

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_WriteWideChar(Stream: TStream; Value: WideChar; Advance: Boolean = True): TMemSize;
begin
{$IFDEF ENDIAN_BIG}
  Value := WideChar(SwapEndian(UInt16(Value)));
{$ENDIF}

  Stream.WriteBuffer(Value, SizeOf(Value));
  Result := SizeOf(Value);

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_WriteUnicodeChar(Stream: TStream; Value: UnicodeChar; Advance: Boolean = True): TMemSize;
begin
{$IFDEF ENDIAN_BIG}
  Value := UnicodeChar(SwapEndian(UInt16(Value)));
{$ENDIF}

  Stream.WriteBuffer(Value, SizeOf(Value));
  Result := SizeOf(Value);

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_WriteChar(Stream: TStream; Value: Char; Advance: Boolean = True): TMemSize;
begin
  Result := Stream_WriteUInt16(Stream, UInt16(Ord(Value)), Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_WriteShortString(Stream: TStream; const Str: ShortString; Advance: Boolean = True): TMemSize;
begin
  Result := Stream_WriteUInt8(Stream, UInt8(Length(Str)), True);
  Inc(Result, Stream_WriteBuffer(Stream, Addr(Str[1])^, Length(Str), True));

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_WriteAnsiString(Stream: TStream; const Str: AnsiString; Advance: Boolean = True): TMemSize;
begin
  Result := Stream_WriteInt32(Stream, Length(Str), True);
  Inc(Result, Stream_WriteBuffer(Stream, PAnsiChar(Str)^, Length(Str) * SizeOf(AnsiChar), True));

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_WriteUTF8String(Stream: TStream; const Str: UTF8String; Advance: Boolean = True): TMemSize;
begin
  Result := Stream_WriteInt32(Stream, Length(Str), True);
  Inc(Result, Stream_WriteBuffer(Stream, PUTF8Char(Str)^, Length(Str) * SizeOf(UTF8Char), True));

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_WriteWideString(Stream: TStream; const Str: WideString; Advance: Boolean = True): TMemSize;
begin
  Result := Stream_WriteInt32(Stream, Length(Str), True);

{$IFDEF ENDIAN_BIG}
  Inc(Result, Stream_WriteUTF16LE(Stream, PUInt16(PWideChar(Str)), Length(Str)));
{$ELSE}
  Inc(Result, Stream_WriteBuffer(Stream, PWideChar(Str)^, Length(Str) * SizeOf(WideChar), True));
{$ENDIF}

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_WriteUnicodeString(Stream: TStream; const Str: UnicodeString; Advance: Boolean = True): TMemSize;
begin
  Result := Stream_WriteInt32(Stream, Length(Str), True);

{$IFDEF ENDIAN_BIG}
  Inc(Result, Stream_WriteUTF16LE(Stream, PUInt16(PUnicodeChar(Str)), Length(Str)));
{$ELSE}
  Inc(Result, Stream_WriteBuffer(Stream, PUnicodeChar(Str)^, Length(Str) * SizeOf(UnicodeChar), True));
{$ENDIF}

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_WriteString(Stream: TStream; const Str: String; Advance: Boolean = True): TMemSize;
begin
  Result := Stream_WriteUTF8String(Stream, StrToUTF8(Str), Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_WriteBuffer(Stream: TStream; const Buffer; Size: TMemSize; Advance: Boolean = True): TMemSize;
begin
  Stream.WriteBuffer(Buffer, Size);
  Result := Size;

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_WriteBytes(Stream: TStream; const Value: array of UInt8; Advance: Boolean = True): TMemSize;
var
  I: Integer;
begin
  Result := 0;

  for I := Low(Value) to High(Value) do
    Inc(Result, Stream_WriteUInt8(Stream, Value[I], True));

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_FillBytes(Stream: TStream; Count: TMemSize; Value: UInt8; Advance: Boolean = True): TMemSize;
var
  I: TMemSize;
begin
  Result := 0;

  for I := 1 to Count do
  begin
    Stream.WriteBuffer(Value, SizeOf(Value));
    Inc(Result, SizeOf(Value));
  end;

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Stream reading functions implementation - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Stream reading functions implementation'}{$ENDIF}
{$IFDEF FPCDWM}{$PUSH}W5057{$ENDIF}
function Stream_ReadBool(Stream: TStream; out Value: ByteBool; Advance: Boolean = True): TMemSize;
var
  Temp: UInt8;
begin
  Stream.ReadBuffer(Temp, SizeOf(Temp));
  Result := SizeOf(Temp);
  Value := NumToBool(Temp);

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadBool(Stream: TStream; Advance: Boolean = True): ByteBool;
begin
  Stream_ReadBool(Stream, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadBoolean(Stream: TStream; out Value: Boolean; Advance: Boolean = True): TMemSize;
var
  TempBool: ByteBool;
begin
  Result := Stream_ReadBool(Stream, TempBool, Advance);
  Value := TempBool;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadInt8(Stream: TStream; out Value: Int8; Advance: Boolean = True): TMemSize;
begin
  Value := 0;
  Stream.ReadBuffer(Value, SizeOf(Value));
  Result := SizeOf(Value);

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadInt8(Stream: TStream; Advance: Boolean = True): Int8;
begin
  Stream_ReadInt8(Stream, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadUInt8(Stream: TStream; out Value: UInt8; Advance: Boolean = True): TMemSize;
begin
  Value := 0;
  Stream.ReadBuffer(Value, SizeOf(Value));
  Result := SizeOf(Value);

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadUInt8(Stream: TStream; Advance: Boolean = True): UInt8;
begin
  Stream_ReadUInt8(Stream, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadInt16(Stream: TStream; out Value: Int16; Advance: Boolean = True): TMemSize;
begin
  Value := 0;
  Stream.ReadBuffer(Value, SizeOf(Value));
  Result := SizeOf(Value);

{$IFDEF ENDIAN_BIG}
  Value := Int16(SwapEndian(UInt16(Value)));
{$ENDIF}

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadInt16(Stream: TStream; Advance: Boolean = True): Int16;
begin
  Stream_ReadInt16(Stream, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadUInt16(Stream: TStream; out Value: UInt16; Advance: Boolean = True): TMemSize;
begin
  Value := 0;
  Stream.ReadBuffer(Value, SizeOf(Value));
  Result := SizeOf(Value);

{$IFDEF ENDIAN_BIG}
  Value := SwapEndian(Value);
{$ENDIF}

  if (not Advance) then
    Stream.Seek(-Int64(Result),soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadUInt16(Stream: TStream; Advance: Boolean = True): UInt16;
begin
  Stream_ReadUInt16(Stream, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadInt32(Stream: TStream; out Value: Int32; Advance: Boolean = True): TMemSize;
begin
  Value := 0;
  Stream.ReadBuffer(Value, SizeOf(Value));
  Result := SizeOf(Value);

{$IFDEF ENDIAN_BIG}
  Value := Int32(SwapEndian(UInt32(Value)));
{$ENDIF}

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadInt32(Stream: TStream; Advance: Boolean = True): Int32;
begin
  Stream_ReadInt32(Stream, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadUInt32(Stream: TStream; out Value: UInt32; Advance: Boolean = True): TMemSize;
begin
  Value := 0;
  Stream.ReadBuffer(Value, SizeOf(Value));
  Result := SizeOf(Value);

{$IFDEF ENDIAN_BIG}
  Value := SwapEndian(Value);
{$ENDIF}

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadUInt32(Stream: TStream; Advance: Boolean = True): UInt32;
begin
  Stream_ReadUInt32(Stream, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadInt64(Stream: TStream; out Value: Int64; Advance: Boolean = True): TMemSize;
begin
  Value := 0;
  Stream.ReadBuffer(Value, SizeOf(Value));
  Result := SizeOf(Value);

{$IFDEF ENDIAN_BIG}
  Value := Int64(SwapEndian(UInt64(Value)));
{$ENDIF}

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadInt64(Stream: TStream; Advance: Boolean = True): Int64;
begin
  Stream_ReadInt64(Stream, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadUInt64(Stream: TStream; out Value: UInt64; Advance: Boolean = True): TMemSize;
begin
  Value := 0;
  Stream.ReadBuffer(Value, SizeOf(Value));
  Result := SizeOf(Value);

{$IFDEF ENDIAN_BIG}
  Value := SwapEndian(Value);
{$ENDIF}

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadUInt64(Stream: TStream; Advance: Boolean = True): UInt64;
begin
  Stream_ReadUInt64(Stream, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadFloat32(Stream: TStream; out Value: Float32; Advance: Boolean = True): TMemSize;
begin
  Value := 0.0;
  Stream.ReadBuffer(Value, SizeOf(Value));
  Result := SizeOf(Value);

{$IFDEF ENDIAN_BIG}
  Value := SwapEndian(Value);
{$ENDIF}

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadFloat32(Stream: TStream; Advance: Boolean = True): Float32;
begin
  Stream_ReadFloat32(Stream, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadFloat64(Stream: TStream; out Value: Float64; Advance: Boolean = True): TMemSize;
begin
  Value := 0.0;
  Stream.ReadBuffer(Value, SizeOf(Value));
  Result := SizeOf(Value);

{$IFDEF ENDIAN_BIG}
  Value := SwapEndian(Value);
{$ENDIF}

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadFloat64(Stream: TStream; Advance: Boolean = True): Float64;
begin
  Stream_ReadFloat64(Stream, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadFloat80(Stream: TStream; out Value: Float80; Advance: Boolean = True): TMemSize;
begin
  FillChar(Addr(Value)^, SizeOf(Value), 0);
  Stream.ReadBuffer(Value, SizeOf(Value));
  Result := SizeOf(Value);

{$IFDEF ENDIAN_BIG}
  Value := SwapEndian(Value);
{$ENDIF}

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

//   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---

function Stream_ReadFloat80(Stream: TStream; Advance: Boolean = True): Float80;
begin
  Stream_ReadFloat80(Stream, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadDateTime(Stream: TStream; out Value: TDateTime; Advance: Boolean = True): TMemSize;
begin
  Result := Stream_ReadFloat64(Stream, Float64(Value), Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadDateTime(Stream: TStream; Advance: Boolean = True): TDateTime;
begin
  Stream_ReadDateTime(Stream, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadCurrency(Stream: TStream; out Value: Currency; Advance: Boolean = True): TMemSize;
begin
  Value := 0.0;
  Stream.ReadBuffer(Value, SizeOf(Value));
  Result := SizeOf(Value);

{$IFDEF ENDIAN_BIG}
  UInt64(Addr(Value)^) := SwapEndian(UInt64(Addr(Value)^));
{$ENDIF}

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

//   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---   ---

function Stream_ReadCurrency(Stream: TStream; Advance: Boolean = True): Currency;
begin
  Stream_ReadCurrency(Stream, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadAnsiChar(Stream: TStream; out Value: AnsiChar; Advance: Boolean = True): TMemSize;
begin
  Value := AnsiChar(0);
  Stream.ReadBuffer(Value, SizeOf(Value));
  Result := SizeOf(Value);

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadAnsiChar(Stream: TStream; Advance: Boolean = True): AnsiChar;
begin
  Stream_ReadAnsiChar(Stream, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadUTF8Char(Stream: TStream; out Value: UTF8Char; Advance: Boolean = True): TMemSize;
begin
  Value := UTF8Char(0);
  Stream.ReadBuffer(Value, SizeOf(Value));
  Result := SizeOf(Value);

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadUTF8Char(Stream: TStream; Advance: Boolean = True): UTF8Char;
begin
  Stream_ReadUTF8Char(Stream, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadWideChar(Stream: TStream; out Value: WideChar; Advance: Boolean = True): TMemSize;
begin
  Value := WideChar(0);
  Stream.ReadBuffer(Value, SizeOf(Value));
  Result := SizeOf(Value);

{$IFDEF ENDIAN_BIG}
  Value := WideChar(SwapEndian(UInt16(Value)));
{$ENDIF}

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadWideChar(Stream: TStream; Advance: Boolean = True): WideChar;
begin
  Stream_ReadWideChar(Stream, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadUnicodeChar(Stream: TStream; out Value: UnicodeChar; Advance: Boolean = True): TMemSize;
begin
  Value := UnicodeChar(0);
  Stream.ReadBuffer(Value, SizeOf(Value));
  Result := SizeOf(Value);

{$IFDEF ENDIAN_BIG}
  Value := UnicodeChar(SwapEndian(UInt16(Value)));
{$ENDIF}

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadUnicodeChar(Stream: TStream; Advance: Boolean = True): UnicodeChar;
begin
  Stream_ReadUnicodeChar(Stream, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadChar(Stream: TStream; out Value: Char; Advance: Boolean = True): TMemSize;
var
  Temp: UInt16;
begin
  Result := Stream_ReadUInt16(Stream, Temp, Advance);
  Value := Char(Temp);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadChar(Stream: TStream; Advance: Boolean = True): Char;
begin
  Stream_ReadChar(Stream, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadShortString(Stream: TStream; out Str: ShortString; Advance: Boolean = True): TMemSize;
var
  StrLength: UInt8;
begin
  Result := Stream_ReadUInt8(Stream, StrLength, True);
  SetLength(Str, StrLength);
  Inc(Result, Stream_ReadBuffer(Stream, Addr(Str[1])^, StrLength, True));

  If (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadShortString(Stream: TStream; Advance: Boolean = True): ShortString;
begin
  Stream_ReadShortString(Stream, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadAnsiString(Stream: TStream; out Str: AnsiString; Advance: Boolean = True): TMemSize;
var
  StrLength: Int32;
begin
  Result := Stream_ReadInt32(Stream, StrLength, True);
  SetLength(Str, StrLength);
  Inc(Result, Stream_ReadBuffer(Stream, PAnsiChar(Str)^, StrLength * SizeOf(AnsiChar), True));

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadAnsiString(Stream: TStream; Advance: Boolean = True): AnsiString;
begin
  Stream_ReadAnsiString(Stream, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadUTF8String(Stream: TStream; out Str: UTF8String; Advance: Boolean = True): TMemSize;
var
  StrLength: Int32;
begin
  Result := Stream_ReadInt32(Stream, StrLength, True);
  SetLength(Str, StrLength);
  Inc(Result, Stream_ReadBuffer(Stream, PUTF8Char(Str)^, StrLength * SizeOf(UTF8Char), True));

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadUTF8String(Stream: TStream; Advance: Boolean = True): UTF8String;
begin
  Stream_ReadUTF8String(Stream, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadWideString(Stream: TStream; out Str: WideString; Advance: Boolean = True): TMemSize;
var
  StrLength:  Int32;
begin
  Result := Stream_ReadInt32(Stream, StrLength, True);
  SetLength(Str, StrLength);

{$IFDEF ENDIAN_BIG}
  Inc(Result, Stream_ReadUTF16LE(Stream, PUInt16(PWideChar(Str)), StrLength));
{$ELSE}
  Inc(Result, Stream_ReadBuffer(Stream, PWideChar(Str)^, StrLength * SizeOf(WideChar), True));
{$ENDIF}

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadWideString(Stream: TStream; Advance: Boolean = True): WideString;
begin
  Stream_ReadWideString(Stream, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadUnicodeString(Stream: TStream; out Str: UnicodeString; Advance: Boolean = True): TMemSize;
var
  StrLength: Int32;
begin
  Result := Stream_ReadInt32(Stream, StrLength, True);
  SetLength(Str, StrLength);

{$IFDEF ENDIAN_BIG}
  Inc(Result, Stream_ReadUTF16LE(Stream, PUInt16(PUnicodeChar(Str)), StrLength));
{$ELSE}
  Inc(Result, Stream_ReadBuffer(Stream, PUnicodeChar(Str)^, StrLength * SizeOf(UnicodeChar), True));
{$ENDIF}

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadUnicodeString(Stream: TStream; Advance: Boolean = True): UnicodeString;
begin
  Stream_ReadUnicodeString(Stream, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadString(Stream: TStream; out Str: String; Advance: Boolean = True): TMemSize;
var
  TempStr: UTF8String;
begin
  Result := Stream_ReadUTF8String(Stream, TempStr, Advance);
  Str := UTF8ToStr(TempStr);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadString(Stream: TStream; Advance: Boolean = True): String;
begin
  Stream_ReadString(Stream, Result, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function Stream_ReadBuffer(Stream: TStream; var Buffer; Size: TMemSize; Advance: Boolean = True): TMemSize;
begin
  Stream.ReadBuffer(Buffer, Size);
  Result := Size;

  if (not Advance) then
    Stream.Seek(-Int64(Result), soCurrent);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- TCustomStreamer - class implementation  - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'TCustomStreamer - class implementation'}{$ENDIF}
function TCustomStreamer.AddBookmark(Position: Int64): Integer;
begin
  { (1) Perform Grow operation to update the capacity. }
  Grow;

  { (2) Return current amount of entries of the array as new bookmark index
        position. }
  Result := FCount;

  { (3) Set specified Position in new bookmark. }
  FBookmarks[Result] := Position;

  { (4) Increment amount of entries of the array. }
  Inc(FCount);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.AddBookmark: Integer;
begin
  { Add new bookmark with CurrentPosition and return its new index position. }
  Result := AddBookmark(CurrentPosition);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TCustomStreamer.ClearBookmark;
begin
  { (1) Set current amount of entries of the array to 0. }
  FCount := 0;

  { (2) Perform Shrink operation to update the capacity. }
  Shrink;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TCustomStreamer.DeleteBookmark(Index: Integer);
var
  I: Integer;
begin
  { (1.1) Check that specified Index isn't out of the bounds. }
  if (CheckIndex(Index)) then
  begin
    { (1.2) Move all bookmarks above Index down by one. }
    for I := Index to Pred(High(FBookmarks)) do
      FBookmarks[I] := FBookMarks[I + 1];

    { (1.3) Decrement amount of entries of the array. }
    Dec(FCount);

    { (1.4) Perform Shrink operation to update the capacity. }
    Shrink;
  end else
    { (1.5) If specified Index is out of the bounds, then raise error. }
    Error(@SCustomStreamer_IndexOutOfBounds, 'TCustomStreamer.DeleteBookmark', Index);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

class procedure TCustomStreamer.Error(Msg: PResStringRec; const Method: String; Data: NativeInt);
begin
  { Raise error. }
{$IFDEF FPC}
  raise ECustomStreamerError.CreateFmt(LoadResString(Msg), [Method, Data]) at @TCustomStreamer.Error;
{$ELSE !FPC}
  raise ECustomStreamerError.CreateFmt(LoadResString(Msg), [Method, Data]) at ReturnAddress;
{$ENDIF !FPC}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

class procedure TCustomStreamer.Error(const Msg, Method: String; Data: NativeInt);
begin
  { Raise error. }
{$IFDEF FPC}
  raise ECustomStreamerError.CreateFmt(Msg, [Method, Data]) at @TCustomStreamer.Error;
{$ELSE !FPC}
  raise ECustomStreamerError.CreateFmt(Msg, [Method, Data]) at ReturnAddress;
{$ENDIF !FPC}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.FillBytes(ByteCount: TMemSize; Value: UInt8; Advance: Boolean): TMemSize;
begin
  { Write value with specified parameters and return actual size written. }
  Result := WriteValue(@Value, Advance, ByteCount, vtFillBytes);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.GetBookmark(Index: Integer): Int64;
begin
  { (1) By default, return -1. }
  Result := -1;

  { (2.1) If specified Index isn't out of the bounds, then ... }
  if (CheckIndex(Index)) then
    { (2.2) ... return value of bookmark with specified Index position. }
    Result := FBookmarks[Index]
  else
    { (2.3) Otherwise raise error. }
    Error(@SCustomStreamer_IndexOutOfBounds, 'TCustomStreamer.GetBookmark', Index);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.GetCapacity: SizeUInt;
begin
  { Return current length of the array. }
  Result := Length(FBookmarks);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.GetCount: SizeUInt;
begin
  { Returns current amount of entries of the array. }
  Result := FCount;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.GetDistance: Int64;
begin
  { Return the distance. }
  Result := CurrentPosition - StartPosition;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.HighIndex: SizeInt;
begin
  { Return high index. }
  Result := Pred(FCount);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.IndexOfBookmark(Position: Int64): Integer;
var
  I: Integer;
begin
  { (1) By default, return -1. }
  Result := -1;

  { (2.1) Itterate throu all entries of the array and ... }
  for I := LowIndex to HighIndex do
    { (2.2) ... if FBookmarks[I] is equal to specified Position, then ... }
    if (FBookmarks[I] = Position) then
    begin
      { (2.3) ... return I value and break for-loop. }
      Result := I;
      Break;
    end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TCustomStreamer.Initialize;
begin
  { (1) Set FBookmarks array to 0. }
  SetLength(FBookmarks, 0);

  { (2) Set FStartPosition to 0. }
  FStartPosition := 0;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.LowIndex: SizeInt;
begin
  { Return low index of the array. }
  Result := Low(FBookmarks);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TCustomStreamer.MoveBy(Offset: Int64);
begin
  { Move CurrentPosition by specified Offset. }
  CurrentPosition := CurrentPosition + Offset;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TCustomStreamer.MoveToBookmark(Index: Integer);
begin
  { (1.1) If specified Index isn't out of bound, then ... }
  if (CheckIndex(Index)) then
    { (1.2) ... change CurrentPosition to FBookmarks[Index] value. }
    CurrentPosition := FBookmarks[Index]
  else
    { (1.3) ... otherwise raise error. }
    Error(@SCustomStreamer_IndexOutOfBounds, 'TCustomStreamer.MoveToBookmark', Index);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TCustomStreamer.MoveToStart;
begin
  { Change CurrentPosition to StartPosition. }
  CurrentPosition := StartPosition;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadAnsiChar(Advance: Boolean): AnsiChar;
begin
  ReadValue(@Result, Advance, SizeOf(Result), vtPrimitive1B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadAnsiChar(out Value: AnsiChar; Advance: Boolean): TMemSize;
begin
  Result := ReadValue(@Value, Advance, SizeOf(Value), vtPrimitive1B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadAnsiString(Advance: Boolean): AnsiString;
begin
  ReadValue(@Result, Advance, 0, vtAnsiString);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadAnsiString(out Value: AnsiString; Advance: Boolean): TMemSize;
begin
  Result := ReadValue(@Value, Advance, 0, vtAnsiString);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadBool(out Value: ByteBool; Advance: Boolean): TMemSize;
var
  Temp: UInt8;
begin
  Result := ReadValue(@Temp, Advance, SizeOf(Temp), vtPrimitive1B);
  Value := NumToBool(Temp);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadBool(Advance: Boolean): ByteBool;
var
  Temp: UInt8;
begin
  ReadValue(@Temp, Advance, SizeOf(Temp), vtPrimitive1B);
  Result := NumToBool(Temp);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadBoolean(out Value: Boolean; Advance: Boolean): TMemSize;
var
  TempBool: ByteBool;
begin
  Result := ReadBool(TempBool, Advance);
  Value := TempBool;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadBuffer(var Buffer; Size: TMemSize; Advance: Boolean): TMemSize;
begin
  Result := ReadValue(@Buffer, Advance, Size, vtBytes);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadChar(Advance: Boolean): Char;
var
  Temp: UInt16;
begin
  ReadValue(@Temp, Advance, SizeOf(Temp), vtPrimitive2B);
  Result := Char(Temp);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadChar(out Value: Char; Advance: Boolean): TMemSize;
var
  Temp: UInt16;
begin
  Result := ReadValue(@Temp, Advance, SizeOf(Temp), vtPrimitive2B);
  Value := Char(Temp);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadCurrency(Advance: Boolean): Currency;
begin
  ReadValue(@Result, Advance, SizeOf(Result), vtPrimitive8B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadCurrency(out Value: Currency; Advance: Boolean): TMemSize;
begin
  Result := ReadValue(@Value, Advance, SizeOf(Value), vtPrimitive8B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadDateTime(out Value: TDateTime; Advance: Boolean): TMemSize;
begin
  Result := ReadValue(@Value, Advance, SizeOf(Value), vtPrimitive8B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadDateTime(Advance: Boolean): TDateTime;
begin
  ReadValue(@Result, Advance, SizeOf(Result), vtPrimitive8B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadFloat32(Advance: Boolean): Float32;
begin
  ReadValue(@Result, Advance, SizeOf(Result), vtPrimitive4B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadFloat32(out Value: Float32; Advance: Boolean): TMemSize;
begin
  Result := ReadValue(@Value, Advance, SizeOf(Value), vtPrimitive4B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadFloat64(Advance: Boolean): Float64;
begin
  ReadValue(@Result, Advance, SizeOf(Result), vtPrimitive8B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadFloat64(out Value: Float64; Advance: Boolean): TMemSize;
begin
  Result := ReadValue(@Value, Advance, SizeOf(Value), vtPrimitive8B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadFloat80(out Value: Float80; Advance: Boolean): TMemSize;
begin
  Result := ReadValue(@Value, Advance, SizeOf(Value), vtPrimitive10B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadFloat80(Advance: Boolean): Float80;
begin
  ReadValue(@Result, Advance, SizeOf(Result), vtPrimitive10B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadInt16(Advance: Boolean): Int16;
begin
  ReadValue(@Result, Advance, SizeOf(Result), vtPrimitive2B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadInt16(out Value: Int16; Advance: Boolean): TMemSize;
begin
  Result := ReadValue(@Value, Advance, SizeOf(Value), vtPrimitive2B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadInt32(Advance: Boolean): Int32;
begin
  ReadValue(@Result, Advance, SizeOf(Result), vtPrimitive4B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadInt32(out Value: Int32; Advance: Boolean): TMemSize;
begin
  Result := ReadValue(@Value, Advance, SizeOf(Value), vtPrimitive4B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadInt64(Advance: Boolean): Int64;
begin
  ReadValue(@Result, Advance, SizeOf(Result), vtPrimitive8B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadInt64(out Value: Int64; Advance: Boolean): TMemSize;
begin
  Result := ReadValue(@Value, Advance, SizeOf(Value), vtPrimitive8B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadInt8(out Value: Int8; Advance: Boolean): TMemSize;
begin
  Result := ReadValue(@Value, Advance, SizeOf(Value), vtPrimitive1B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadInt8(Advance: Boolean): Int8;
begin
  ReadValue(@Result, Advance, SizeOf(Result), vtPrimitive1B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadShortString(out Value: ShortString; Advance: Boolean): TMemSize;
begin
  Result := ReadValue(@Value, Advance, 0, vtShortString);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadShortString(Advance: Boolean): ShortString;
begin
  ReadValue(@Result, Advance, 0, vtShortString);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadString(out Value: String; Advance: Boolean): TMemSize;
begin
  Result := ReadValue(@Value, Advance, 0, vtString);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadString(Advance: Boolean): String;
begin
  ReadValue(@Result, Advance, 0, vtString);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadUInt16(out Value: UInt16; Advance: Boolean): TMemSize;
begin
  Result := ReadValue(@Value, Advance, SizeOf(Value), vtPrimitive2B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadUInt16(Advance: Boolean): UInt16;
begin
  ReadValue(@Result, Advance, SizeOf(Result), vtPrimitive2B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadUInt32(Advance: Boolean): UInt32;
begin
  ReadValue(@Result, Advance, SizeOf(Result), vtPrimitive4B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadUInt32(out Value: UInt32; Advance: Boolean): TMemSize;
begin
  Result := ReadValue(@Value, Advance, SizeOf(Value), vtPrimitive4B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadUInt64(out Value: UInt64; Advance: Boolean): TMemSize;
begin
  Result := ReadValue(@Value, Advance, SizeOf(Value), vtPrimitive8B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadUInt64(Advance: Boolean): UInt64;
begin
  ReadValue(@Result, Advance, SizeOf(Result), vtPrimitive8B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadUInt8(out Value: UInt8; Advance: Boolean): TMemSize;
begin
  Result := ReadValue(@Value, Advance, SizeOf(Value), vtPrimitive1B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadUInt8(Advance: Boolean): UInt8;
begin
  ReadValue(@Result, Advance, SizeOf(Result), vtPrimitive1B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadUnicodeChar(Advance: Boolean): UnicodeChar;
begin
  ReadValue(@Result, Advance, SizeOf(Result), vtPrimitive2B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadUnicodeChar(out Value: UnicodeChar; Advance: Boolean): TMemSize;
begin
  Result := ReadValue(@Value, Advance, SizeOf(Value), vtPrimitive2B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadUnicodeString(Advance: Boolean): UnicodeString;
begin
  ReadValue(@Result, Advance, 0, vtUnicodeString);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadUnicodeString(out Value: UnicodeString; Advance: Boolean): TMemSize;
begin
  Result := ReadValue(@Value, Advance, 0, vtUnicodeString);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadUTF8Char(Advance: Boolean): UTF8Char;
begin
  ReadValue(@Result, Advance, SizeOf(Result), vtPrimitive1B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadUTF8Char(out Value: UTF8Char; Advance: Boolean): TMemSize;
begin
  Result := ReadValue(@Value, Advance, SizeOf(Value), vtPrimitive1B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadUTF8String(out Value: UTF8String; Advance: Boolean): TMemSize;
begin
  Result := ReadValue(@Value, Advance, 0, vtUTF8String);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadUTF8String(Advance: Boolean): UTF8String;
begin
  ReadValue(@Result, Advance, 0, vtUTF8String);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadWideChar(Advance: Boolean): WideChar;
begin
  ReadValue(@Result, Advance, SizeOf(Result), vtPrimitive2B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadWideChar(out Value: WideChar; Advance: Boolean): TMemSize;
begin
  Result := ReadValue(@Value, Advance, SizeOf(Value), vtPrimitive2B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadWideString(Advance: Boolean): WideString;
begin
  ReadValue(@Result, Advance, 0, vtWideString);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.ReadWideString(out Value: WideString; Advance: Boolean): TMemSize;
begin
  Result := ReadValue(@Value, Advance, 0, vtWideString);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.RemoveBookmark(Position: Int64; RemoveAll: Boolean): Integer;
begin
  { (1) Repeat until ((Result < 0) or (not RemoveAll)). }
  repeat
    { (2.1) Search for bookmark that have Position as it's value and return it's
            index of found or -1 if not found. }
    Result := IndexOfBookmark(Position);

    { (2.2) If bookmark was found, then ... }
    if (Result >= 0) then
      { (2.3) ... delete that bookmark. }
      DeleteBookMark(Result);
  until ((Result < 0) or (not RemoveAll));
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TCustomStreamer.SetBookmark(Index: Integer; Value: Int64);
begin
  { (1.1) If specified Index isn't out of bounds, then ... }
  if (CheckIndex(Index)) then
    { (1.2) ... set new value for FBookmarks[Index]. }
    FBookmarks[Index] := Value
  else
    { (1.3) ... otherwise raise error. }
    Error(@SCustomStreamer_IndexOutOfBounds, 'TCustomStreamer.SetBookmark', Index);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TCustomStreamer.SetCapacity(Value: SizeUInt);
begin
  { (1.1) If specified Value is different than current length of FBookmarks
          array, then ... }
  if (Value <> Length(FBookmarks)) then
  begin
    { (1.2) ... set new length of FBookmarks array to specified Value. }
    SetLength(FBookMarks, Value);

    { (1.3.1) If specified Value is less than current amount of entries of the
              array, then ... }
    if (Value < FCount) then
      { (1.3.2) ... set new amount of entries of the array to new Value. }
      FCount := Value;
  end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF FPCDWM}{$PUSH}W5024{$ENDIF}
procedure TCustomStreamer.SetCount(Value: SizeUInt);
begin
  { Do nothing. }
end;
{$IFDEF FPCDWM}{$POP}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.WriteAnsiChar(Value: AnsiChar; Advance: Boolean): TMemSize;
begin
  Result := WriteValue(@Value, Advance, SizeOf(Value), vtPrimitive1B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.WriteAnsiString(const Value: AnsiString; Advance: Boolean): TMemSize;
begin
  Result := WriteValue(@Value, Advance, 0, vtAnsiString);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.WriteBool(Value: ByteBool; Advance: Boolean): TMemSize;
var
  Temp: UInt8;
begin
  Temp := BoolToNum(Value);
  Result := WriteValue(@Temp, Advance, SizeOf(Temp), vtPrimitive1B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.WriteBoolean(Value, Advance: Boolean): TMemSize;
begin
  Result := WriteBool(Value, Advance);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.WriteBuffer(const Buffer; Size: TMemSize; Advance: Boolean): TMemSize;
begin
  Result := WriteValue(@Buffer, Advance, Size, vtBytes);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.WriteBytes(const Value: array of UInt8; Advance: Boolean): TMemSize;
var
  I: Integer;
  OldPos: Int64;
begin
  OldPos := CurrentPosition;
  Result := 0;

  for I := Low(Value) to High(Value) do
    Result := Result + WriteUInt8(Value[i], True);

  if (not Advance) then
    CurrentPosition := OldPos;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.WriteChar(Value: Char; Advance: Boolean): TMemSize;
var
  Temp: UInt16;
begin
  Temp := UInt16(Ord(Value));
  Result := WriteValue(@Temp, Advance, SizeOf(Temp), vtPrimitive2B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.WriteCurrency(Value: Currency; Advance: Boolean): TMemSize;
begin
  Result := WriteValue(@Value, Advance, SizeOf(Value), vtPrimitive8B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.WriteDateTime(Value: TDateTime; Advance: Boolean): TMemSize;
begin
  Result := WriteValue(@Value, Advance, SizeOf(Value), vtPrimitive8B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.WriteFloat32(Value: Float32; Advance: Boolean): TMemSize;
begin
  Result := WriteValue(@Value, Advance, SizeOf(Value), vtPrimitive4B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.WriteFloat64(Value: Float64; Advance: Boolean): TMemSize;
begin
  Result := WriteValue(@Value, Advance, SizeOf(Value), vtPrimitive8B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.WriteFloat80(Value: Float80; Advance: Boolean): TMemSize;
begin
  Result := WriteValue(@Value, Advance, SizeOf(Value), vtPrimitive10B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.WriteInt16(Value: Int16; Advance: Boolean): TMemSize;
begin
  Result := WriteValue(@Value, Advance, SizeOf(Value), vtPrimitive2B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.WriteInt32(Value: Int32; Advance: Boolean): TMemSize;
begin
  Result := WriteValue(@Value, Advance, SizeOf(Value), vtPrimitive4B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.WriteInt64(Value: Int64; Advance: Boolean): TMemSize;
begin
  Result := WriteValue(@Value, Advance, SizeOf(Value), vtPrimitive8B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.WriteInt8(Value: Int8; Advance: Boolean): TMemSize;
begin
  Result := WriteValue(@Value, Advance, SizeOf(Value), vtPrimitive1B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.WriteShortString(const Value: ShortString; Advance: Boolean): TMemSize;
begin
  Result := WriteValue(@Value, Advance, 0, vtShortString);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.WriteString(const Value: String; Advance: Boolean): TMemSize;
begin
  Result := WriteValue(@Value, Advance, 0, vtString);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.WriteUInt16(Value: UInt16; Advance: Boolean): TMemSize;
begin
  Result := WriteValue(@Value, Advance, SizeOf(Value), vtPrimitive2B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.WriteUInt32(Value: UInt32; Advance: Boolean): TMemSize;
begin
  Result := WriteValue(@Value, Advance, SizeOf(Value), vtPrimitive4B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.WriteUInt64(Value: UInt64; Advance: Boolean): TMemSize;
begin
  Result := WriteValue(@Value, Advance, SizeOf(Value), vtPrimitive8B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.WriteUInt8(Value: UInt8; Advance: Boolean): TMemSize;
begin
  Result := WriteValue(@Value, Advance, SizeOf(Value), vtPrimitive1B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.WriteUnicodeChar(Value: UnicodeChar; Advance: Boolean): TMemSize;
begin
  Result := WriteValue(@Value, Advance, SizeOf(Value), vtPrimitive2B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.WriteUnicodeString(const Value: UnicodeString; Advance: Boolean): TMemSize;
begin
  Result := WriteValue(@Value, Advance, 0, vtUnicodeString);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.WriteUTF8Char(Value: UTF8Char; Advance: Boolean): TMemSize;
begin
  Result := WriteValue(@Value, Advance, SizeOf(Value), vtPrimitive1B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.WriteUTF8String(const Value: UTF8String; Advance: Boolean): TMemSize;
begin
  Result := WriteValue(@Value, Advance, 0, vtUTF8String);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.WriteWideChar(Value: WideChar; Advance: Boolean): TMemSize;
begin
  Result := WriteValue(@Value, Advance, SizeOf(Value), vtPrimitive2B);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomStreamer.WriteWideString(const Value: WideString; Advance: Boolean): TMemSize;
begin
  Result := WriteValue(@Value, Advance, 0, vtWideString);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- TMemoryStreamer - class implementation  - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'TMemoryStreamer - class implementation'}{$ENDIF}
function TMemoryStreamer.AddBookmark(Position: Int64): Integer;
begin
  { Call inherited AddBookmark with properly casted Position. }
  Result := inherited AddBookmark(PtrInt(Position));
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

constructor TMemoryStreamer.Create(MemorySize: TMemSize);
begin
  { (1) Call inherited code. }
  inherited Create;

  { (2) Set FOwnsPointer to False. }
  FOwnsPointer := False;

  { (2) Initialize internal structure with specified MemorySize. }
  Initialize(MemorySize);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

constructor TMemoryStreamer.Create(Memory: Pointer);
begin
  { (1) Call inherited code. }
  inherited Create;

  { (2) Set FOwnsPointer to False. }
  FOwnsPointer := False;

  { (3) Initialize internal structure with specified Memory pointer. }
  Initialize(Memory);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

destructor TMemoryStreamer.Destroy;
begin
  { (1.1) If FOwnsPointer is True, then ... }
  if (FOwnsPointer) then
    { (1.2) ... release memory of StartPtr. }
    FreeMem(StartPtr, FMemorySize);

  { (2) Call inherited code. }
  inherited;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TMemoryStreamer.GetCurrentPosition: Int64;
begin
  { Return current position. }
{$IFDEF FPCDWM}{$PUSH}W4055 W4056{$ENDIF}
  Result := Int64(FCurrentPtr);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TMemoryStreamer.GetStartPtr: Pointer;
begin
  { Return start position pointer. }
{$IFDEF FPCDWM}{$PUSH}W4055 W4056{$ENDIF}
  Result := Pointer(FStartPosition);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TMemoryStreamer.IndexOfBookmark(Position: Int64): Integer;
begin
  { Call inherited IndexOfBookmark with properly casted Position. }
  Result := inherited IndexOfBookmark(PtrInt(Position));
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TMemoryStreamer.Initialize(Memory: Pointer);
begin
  { (1) Call inherited code. }
  inherited Initialize;

  { (2) Set FOwnsPointer to False. }
  FOwnsPointer := False;

  { (3) Set FMemorySize to 0. }
  FMemorySize := 0;

  { (4) Set FCurrentPtr to specified Memory. }
  FCurrentPtr := Memory;

  { (5) Set FStartPosition to properly casted Memory. }
{$IFDEF FPCDWM}{$PUSH}W4055 W4056{$ENDIF}
  FStartPosition := Int64(Memory);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TMemoryStreamer.Initialize(MemorySize: TMemSize);
var
  TempPtr: Pointer;
begin
  { (1) Call inherited code. }
  inherited Initialize;

  { (2.1) If streamer owns pointer, then: }
  if (FOwnsPointer) then
  begin
    { (2.2) Store current StartPtr to TempPtr. }
    TempPtr := StartPtr;

    { (2.3) Reallocate TempPtr to new MemorySize. }
    ReallocMem(TempPtr, MemorySize);
  end else
    { (2.4) Otherwise allocate new memory for TempPtr. }
    TempPtr := AllocMem(MemorySize);

  { (3) Streamer owns pointer, so set FOwnsPointer to True. }
  FOwnsPointer := True;

  { (4) Set FMemorySize to MemorySize. }
  FMemorySize := MemorySize;

  { (5) Set FCurrentPtr to TempPtr. }
  FCurrentPtr := TempPtr;

  { (6) Set FStartPosition to properly casted TempPtr. }
{$IFDEF FPCDWM}{$PUSH}W4055 W4056{$ENDIF}
  FStartPosition := Int64(TempPtr);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TMemoryStreamer.ReadValue(Value: Pointer; Advance: Boolean; Size: TMemSize; ValueType: TValueType): TMemSize;
begin
  { Depending on specified ValueType, read proper value from the memory. }
  case ValueType of
    vtShortString:
      Result := Ptr_ReadShortString(FCurrentPtr, ShortString(Value^), Advance);

    vtAnsiString:
      Result := Ptr_ReadAnsiString(FCurrentPtr, AnsiString(Value^), Advance);

    vtUTF8String:
      Result := Ptr_ReadUTF8String(FCurrentPtr, UTF8String(Value^), Advance);

    vtWideString:
      Result := Ptr_ReadWideString(FCurrentPtr, WideString(Value^), Advance);

    vtUnicodeString:
      Result := Ptr_ReadUnicodeString(FCurrentPtr, UnicodeString(Value^), Advance);

    vtString:
      Result := Ptr_ReadString(FCurrentPtr, String(Value^), Advance);

    vtPrimitive1B:
      Result := Ptr_ReadUInt8(FCurrentPtr, UInt8(Value^), Advance);

    vtPrimitive2B:
      Result := Ptr_ReadUInt16(FCurrentPtr, UInt16(Value^), Advance);

    vtPrimitive4B:
      Result := Ptr_ReadUInt32(FCurrentPtr, UInt32(Value^), Advance);

    vtPrimitive8B:
      Result := Ptr_ReadUInt64(FCurrentPtr, UInt64(Value^), Advance);

    vtPrimitive10B:
      Result := Ptr_ReadFloat80(FCurrentPtr, Float80(Value^), Advance);

    else
      { vtFillBytes, vtBytes }
      Result := Ptr_ReadBuffer(FCurrentPtr, Value^, Size, Advance);
  end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TMemoryStreamer.RemoveBookmark(Position: Int64; RemoveAll: Boolean): Integer;
begin
  { Call inherited RemoveBookmark with properly casted Position and specified
    RemoveAll flag. }
  Result := inherited RemoveBookmark(PtrInt(Position), RemoveAll);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TMemoryStreamer.SetBookmark(Index: Integer; Value: Int64);
begin
  { Call inherited SetBookmark with specified Index and properly casted Value.
    Casting to PtrInt is done to cut off higher 32-bits on 32-bit system. }
  inherited SetBookmark(Index, Int64(PtrInt(Value)));
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TMemoryStreamer.SetCurrentPosition(NewPosition: Int64);
begin
  { Set FCurrentPtr to properly caster NewPosition value. }
{$IFDEF FPCDWM}{$PUSH}W4055 W4056{$ENDIF}
  FCurrentPtr := Pointer(NewPosition);
{$IFDEF FPCDWM}{$POP}{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TMemoryStreamer.WriteValue(Value: Pointer; Advance: Boolean; Size: TMemSize; ValueType: TValueType): TMemSize;
begin
  { Depending on specified ValueType, write proper value to the memory. }
  case ValueType of
    vtShortString:
      Result := Ptr_WriteShortString(FCurrentPtr, ShortString(Value^), Advance);

    vtAnsiString:
      Result := Ptr_WriteAnsiString(FCurrentPtr, AnsiString(Value^), Advance);

    vtUTF8String:
      Result := Ptr_WriteUTF8String(FCurrentPtr, UTF8String(Value^), Advance);

    vtWideString:
      Result := Ptr_WriteWideString(FCurrentPtr, WideString(Value^), Advance);

    vtUnicodeString:
      Result := Ptr_WriteUnicodeString(FCurrentPtr, UnicodeString(Value^), Advance);

    vtString:
      Result := Ptr_WriteString(FCurrentPtr, String(Value^), Advance);

    vtFillBytes:
      Result := Ptr_FillBytes(FCurrentPtr, Size, UInt8(Value^), Advance);

    vtPrimitive1B:
      Result := Ptr_WriteUInt8(FCurrentPtr, UInt8(Value^), Advance);

    vtPrimitive2B:
      Result := Ptr_WriteUInt16(FCurrentPtr, UInt16(Value^), Advance);

    vtPrimitive4B:
      Result := Ptr_WriteUInt32(FCurrentPtr, UInt32(Value^), Advance);

    vtPrimitive8B:
      Result := Ptr_WriteUInt64(FCurrentPtr, UInt64(Value^), Advance);

    vtPrimitive10B:
      Result := Ptr_WriteFloat80(FCurrentPtr, Float80(Value^), Advance);

    else
      { vtBytes }
      Result := Ptr_WriteBuffer(FCurrentPtr, Value^, Size, Advance);
  end;
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- TStreamStreamer - class implementation  - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'TStreamStreamer - class implementation'}{$ENDIF}
constructor TStreamStreamer.Create(Target: TStream);
begin
  { (1) Call inherited code. }
  inherited Create;

  { (2) Initialize internal structure with specified Target stream. }
  Initialize(Target);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TStreamStreamer.GetCurrentPosition: Int64;
begin
  { Return current position of stream caret. }
  Result := FTarget.Position;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TStreamStreamer.Initialize(Target: TStream);
begin
  { (1) Call inherited code. }
  inherited Initialize;

  { (2) Set FTarget to specified Target stream. }
  FTarget := Target;

  { (3) Set FStartPosition to Target.Position. }
  FStartPosition := Target.Position;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TStreamStreamer.ReadValue(Value: Pointer; Advance: Boolean; Size: TMemSize; ValueType: TValueType): TMemSize;
begin
  { Depending on specified ValueType, read proper value from the stream. }
  case ValueType of
    vtShortString:
      Result := Stream_ReadShortString(FTarget, ShortString(Value^), Advance);

    vtAnsiString:
      Result := Stream_ReadAnsiString(FTarget, AnsiString(Value^), Advance);

    vtUTF8String:
      Result := Stream_ReadUTF8String(FTarget, UTF8String(Value^), Advance);

    vtWideString:
      Result := Stream_ReadWideString(FTarget, WideString(Value^), Advance);

    vtUnicodeString:
      Result := Stream_ReadUnicodeString(FTarget, UnicodeString(Value^), Advance);

    vtString:
      Result := Stream_ReadString(FTarget, String(Value^), Advance);

    vtPrimitive1B:
      Result := Stream_ReadUInt8(FTarget, UInt8(Value^), Advance);

    vtPrimitive2B:
      Result := Stream_ReadUInt16(FTarget, UInt16(Value^), Advance);

    vtPrimitive4B:
      Result := Stream_ReadUInt32(FTarget, UInt32(Value^), Advance);

    vtPrimitive8B:
      Result := Stream_ReadUInt64(FTarget, UInt64(Value^), Advance);

    vtPrimitive10B:
      Result := Stream_ReadFloat80(FTarget, Float80(Value^), Advance);

    else
      { vtFillBytes, vtBytes }
      Result := Stream_ReadBuffer(fTarget, Value^, Size, Advance);
  end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TStreamStreamer.SetCurrentPosition(NewPosition: Int64);
begin
  { Set FTarget.Position to specified NewPosition. }
  FTarget.Position := NewPosition;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TStreamStreamer.WriteValue(Value: Pointer; Advance: Boolean; Size: TMemSize; ValueType: TValueType): TMemSize;
begin
  { Depending on specified ValueType, write proper value to the stream. }
  case ValueType of
    vtShortString:
      Result := Stream_WriteShortString(FTarget, ShortString(Value^), Advance);

    vtAnsiString:
      Result := Stream_WriteAnsiString(FTarget, AnsiString(Value^), Advance);

    vtUTF8String:
      Result := Stream_WriteUTF8String(FTarget, UTF8String(Value^), Advance);

    vtWideString:
      Result := Stream_WriteWideString(FTarget, WideString(Value^), Advance);

    vtUnicodeString:
      Result := Stream_WriteUnicodeString(FTarget, UnicodeString(Value^), Advance);

    vtString:
      Result := Stream_WriteString(FTarget, String(Value^), Advance);

    vtFillBytes:
      Result := Stream_FillBytes(FTarget, Size,UInt8(Value^), Advance);

    vtPrimitive1B:
      Result := Stream_WriteUInt8(FTarget, UInt8(Value^), Advance);

    vtPrimitive2B:
      Result := Stream_WriteUInt16(FTarget, UInt16(Value^), Advance);

    vtPrimitive4B:
      Result := Stream_WriteUInt32(FTarget, UInt32(Value^), Advance);

    vtPrimitive8B:
      Result := Stream_WriteUInt64(FTarget, UInt64(Value^), Advance);

    vtPrimitive10B:
      Result := Stream_WriteFloat80(FTarget, Float80(Value^), Advance);

  else
    { vtBytes }
    Result := Stream_WriteBuffer(FTarget, Value^, Size, Advance);
  end;
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

end.
