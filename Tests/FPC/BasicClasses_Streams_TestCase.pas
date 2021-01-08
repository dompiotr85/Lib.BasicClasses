unit BasicClasses_Streams_TestCase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry,
  TypeDefinitions,
  BasicClasses.Streams;

type
  { TBasicClasses_TCustomStreamer_TestCase - class definition }
  TBasicClasses_TCustomStreamer_TestCase = class(TTestCase)
  private
    Streamer: TCustomStreamer;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure Test_Creation;
    procedure Test_AddBookmarks;
    procedure Test_RemoveBookmarks;
  end;

  { TBasicClasses_TMemoryStreamer_TestCase - class definition }
  TBasicClasses_TMemoryStreamer_TestCase = class(TTestCase)
  private
    Streamer: TMemoryStreamer;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure Test_Creation;
    procedure Test_WriteAndRead;
    procedure Test_Bookmarks;
  end;

  { TBasicClasses_TStreamStreamer_TestCase - class definition }
  TBasicClasses_TStreamStreamer_TestCase = class(TTestCase)
  private
    FileStream: TFileStream;
    Streamer: TStreamStreamer;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure Test_Creation;
    procedure Test_WriteAndRead;
    procedure Test_Bookmarks;
  end;

implementation

{ TBasicClasses_TCustomStreamer_TestCase - class implementation }
procedure TBasicClasses_TCustomStreamer_TestCase.SetUp;
begin
  { Create Streamer class. }
  Streamer := TCustomStreamer.Create;
end;

procedure TBasicClasses_TCustomStreamer_TestCase.TearDown;
begin
  { (1) Free Streamer class. }
  Streamer.Free;

  { (2) Set Streamer to nil. }
  Streamer := nil;
end;

procedure TBasicClasses_TCustomStreamer_TestCase.Test_Creation;
begin
  AssertTrue('Streamer isn''t assigned!', Assigned(Streamer));
  AssertEquals('Streamer.Capacity isn''t equal to 0!', Cardinal(0), Cardinal(Streamer.Capacity));
  AssertEquals('Streamer.Count isn''t equal to 0!', Cardinal(0), Cardinal(Streamer.Count));
end;

procedure TBasicClasses_TCustomStreamer_TestCase.Test_AddBookmarks;
var
  Idx: SizeUInt;
  I: Integer;
begin
  { (1.1) Prepare our Streamer by adding 10 new bookmarks. }
  for Idx := 1 to 10 do
  begin
    I := Streamer.AddBookmark(Int64(Idx));

    { (1.2) Check that Streamer's new bookmark was added, that have proper value
            and that Streamer.Count value is valid. }
    AssertEquals('Streamer.AddBookmark(Int64(Idx)) returned invalid value!', Cardinal(Idx - 1), Cardinal(I));
    AssertEquals('Streamer.Count isn''t equal to ' + Idx.ToString + '!', Cardinal(Idx), Cardinal(Streamer.Count));
    AssertEquals('Streamer.Bookmarks[Idx - 1] value isn''t equal to ' + Idx.ToString, Cardinal(Idx), Cardinal(Streamer.Bookmarks[Idx - 1]));
  end;

  { (2) Clear Streamer's bookmarks. }
  Streamer.ClearBookmark;
end;

procedure TBasicClasses_TCustomStreamer_TestCase.Test_RemoveBookmarks;
var
  Idx: SizeUInt;
  Bookmark: Integer;
begin
  { (1.1) Prepare our Streamer by adding 10 new bookmarks. }
  for Idx := 1 to 10 do
  begin
    Streamer.AddBookmark(Int64(Idx));

    { (1.2) Check that Streamer's new bookmark have proper value and that
            Streamer.Count value is valid. }
    AssertEquals('Streamer.Bookmarks[Idx - 1] value isn''t equal to ' + Idx.ToString, Cardinal(Idx), Cardinal(Streamer.Bookmarks[Idx - 1]));
    AssertEquals('Streamer.Count isn''t equal to ' + Idx.ToString + '!', Cardinal(Idx), Cardinal(Streamer.Count));
  end;

  { (2.1) Itterate from 0 to (Streamer.Count - 1) and: }
  for Idx := 0 to (Streamer.Count - 1) do
  begin
    { (2.2) Retrieve first bookmark of the Streamer. }
    Bookmark := Streamer.Bookmarks[0];

    { (2.3) Remove Streamer's first bookmark and check that function returned
            value other than -1 and that Streamer.Count have proper value. }
    AssertTrue('Streamer.RemoveBookmark(Bookmark, False) returned invalid value!', Streamer.RemoveBookmark(Bookmark, False) <> -1);
    AssertEquals('Streamer.Count isn''t equal to ' + Cardinal(10 - (Idx + 1)).ToString, Cardinal(10 - (Idx + 1)), Cardinal(Streamer.Count));
  end;
end;

{ TBasicClasses_TMemoryStreamer_TestCase - class implementation }
procedure TBasicClasses_TMemoryStreamer_TestCase.SetUp;
begin
  { Create TMemoryStreamer. }
  Streamer := TMemoryStreamer.Create(200);
end;

procedure TBasicClasses_TMemoryStreamer_TestCase.TearDown;
begin
  { (1) Release Streamer. }
  Streamer.Free;

  { (2) Set Streamer to nil. }
  Streamer := nil;
end;

procedure TBasicClasses_TMemoryStreamer_TestCase.Test_Creation;
begin
  AssertTrue('Streamer isn''t assigned!', Assigned(Streamer));
  AssertEquals('Streamer.Capacity isn''t equal to 0!', Cardinal(0), Cardinal(Streamer.Capacity));
  AssertEquals('Streamer.Count isn''t equal to 0!', Cardinal(0), Cardinal(Streamer.Count));
end;

procedure TBasicClasses_TMemoryStreamer_TestCase.Test_WriteAndRead;
const
  TestString: String = 'Test string';
  BytesArray: array of UInt8 = (2, 4, 8, 16, 32, 64, 128, 255);
var
  BooleanVal: Boolean;
  DT, DT2: TDateTime;
  Hour, Minute, Second, MilliSecond: Word;
  Hour2, Minute2, Second2, MilliSecond2: Word;
  Year, Month, Day: Word;
  Year2, Month2, Day2: Word;
  I: Integer;
  Arr: array of UInt8;
begin
  { (1) Write all types to our streamer. Check sizes of actual writes that are
        valid. }
  { (1.1) ByteBool and Boolean. }
  AssertEquals('Streamer.WriteBool(True) returned value that isn''t equal to 1!', Cardinal(1), Cardinal(Streamer.WriteBool(True)));
  AssertEquals('Streamer.WriteBoolean(True) returned value that isn''t equal to 1!', Cardinal(1), Cardinal(Streamer.WriteBoolean(True)));

  { (1.2) Int8 and UInt8. }
  AssertEquals('Streamer.WriteInt8(127) returned value that isn''t equal to 1!', Cardinal(1), Cardinal(Streamer.WriteInt8(127)));
  AssertEquals('Streamer.WriteUInt8(255) returned value that isn''t equal to 1!', Cardinal(1), Cardinal(Streamer.WriteUInt8(255)));

  { (1.3) Int16 and UInt16. }
  AssertEquals('Streamer.WriteInt16(32767) returned value that isn''t equal to 2!', Cardinal(2), Cardinal(Streamer.WriteInt16(32767)));
  AssertEquals('Streamer.WriteUInt16(65535) returned value that isn''t equal to 2!', Cardinal(2), Cardinal(Streamer.WriteUInt16(65535)));

  { (1.4) Int32 and UInt32. }
  AssertEquals('Streamer.WriteInt32(2147483647) returned value that isn''t equal to 4!', Cardinal(4), Cardinal(Streamer.WriteInt32(2147483647)));
  AssertEquals('Streamer.WriteUInt32(4294967295) returned value that isn''t equal to 4!', Cardinal(4), Cardinal(Streamer.WriteUInt32(4294967295)));

  { (1.5) Int64 and UInt64. }
  AssertEquals('Streamer.WriteInt64(9223372036854775807) returned value that isn''t equal to 8!', Cardinal(8), Cardinal(Streamer.WriteInt64(9223372036854775807)));
  AssertEquals('Streamer.WriteUInt64(18446744073709551615) returned value that isn''t equal to 8!', Cardinal(8), Cardinal(Streamer.WriteUInt64(18446744073709551615)));

  { (1.6) Float32, Float64, Float80 and Currency. }
  AssertEquals('Streamer.WriteFloat32(Float32(3.14)) returned value that isn''t equal to 4!', Cardinal(4), Cardinal(Streamer.WriteFloat32(Float32(3.14))));
  AssertEquals('Streamer.WriteFloat64(Float64(3.14)) returned value that isn''t equal to 8!', Cardinal(8), Cardinal(Streamer.WriteFloat64(Float64(3.14))));
  //AssertEquals('Streamer.WriteFloat80(Float80(3.14)) returned value that isn''t equal to 10!', Cardinal(10), Cardinal(Streamer.WriteFloat80(Float80(3.14))));
  AssertEquals('Streamer.WriteCurrency(Currency(3.14)) returned value that isn''t equal to 8!', Cardinal(8), Cardinal(Streamer.WriteCurrency(Currency(3.14))));

  { (1.7) AnsiChar, UTF8Char, WideChar and UnicodeChar. }
  AssertEquals('Streamer.WriteAnsiChar(#13) returned value that isn''t equal to 1!', Cardinal(1), Cardinal(Streamer.WriteAnsiChar(#13)));
  AssertEquals('Streamer.WriteUTF8Char(#13) returned value that isn''t equal to 1!', Cardinal(1), Cardinal(Streamer.WriteUTF8Char(#13)));
  AssertEquals('Streamer.WriteWideChar(#13) returned value that isn''t equal to 2!', Cardinal(2), Cardinal(Streamer.WriteWideChar(#13)));
  AssertEquals('Streamer.WriteUnicodeChar(#13) returned value that isn''t equal to 2!', Cardinal(2), Cardinal(Streamer.WriteUnicodeChar(#13)));

  { (1.8) ShortString, AnsiString, UTF8String, WideString, UnicodeString and
          String. }
  AssertEquals('Streamer.WriteShortString(ShortString(TestString)) returned value that isn''t equal to 12!', Cardinal(12), Cardinal(Streamer.WriteShortString(ShortString(TestString))));
  AssertEquals('Streamer.WriteAnsiString(AnsiString(TestString)) returned value that isn''t equal to 15!', Cardinal(15), Cardinal(Streamer.WriteAnsiString(AnsiString(TestString))));
  AssertEquals('Streamer.WriteUTF8String(UTF8String(TestString)) returned value that isn''t equal to 15!', Cardinal(15), Cardinal(Streamer.WriteUTF8String(UTF8String(TestString))));
  AssertEquals('Streamer.WriteWideString(WideString(TestString)) returned value that isn''t equal to 26!', Cardinal(26), Cardinal(Streamer.WriteWideString(WideString(TestString))));
  AssertEquals('Streamer.WriteUnicodeString(UnicodeString(TestString)) returned value that isn''t equal to 26!', Cardinal(26), Cardinal(Streamer.WriteUnicodeString(UnicodeString(TestString))));
  AssertEquals('Streamer.WriteString(TestString) returned value that isn''t equal to 15!', Cardinal(15), Cardinal(Streamer.WriteString(TestString)));

  { (1.9) TDateTime. }
  DT := Now;
  AssertEquals('Streamer.WriteDateTime(DT) returned value that isn''t equal to 8!', Cardinal(8), Cardinal(Streamer.WriteDateTime(DT)));

  { (1.10) BytesArray. }
  AssertEquals('Streamer.WriteBytes(BytesArray) returned value that isn''t equal to 8!', Cardinal(8), Cardinal(Streamer.WriteBytes(BytesArray)));

  { (1.11) Buffer. }
  AssertEquals('Streamer.WriteBuffer(Pointer(BytesArray)^, Length(BytesArray)) returned value that isn''t equal to 8!', Cardinal(8), Cardinal(Streamer.WriteBuffer(Pointer(BytesArray)^, Length(BytesArray))));

  { (2) Move Streamer cursor to start position. }
  Streamer.MoveToStart;

  { (3) Read all types from our streamer. Check sizes of actual reads that are
        valid. }
  { (3.1) ByteBool and Boolean. }
  AssertEquals('Streamer.ReadBool returned value that isn''t equal to ByteBool(True)!', ByteBool(True), ByteBool(Streamer.ReadBool));
  AssertEquals('Streamer.ReadBoolean returned value that isn''t equal to 1!', Cardinal(1), Cardinal(Streamer.ReadBoolean(BooleanVal)));
  AssertTrue('BooleanVal isn''t True!', BooleanVal);

  { (3.2) Int8 and UInt8. }
  AssertEquals('Streamer.ReadInt8 returned value that isn''t equal to 127!', Cardinal(127), Cardinal(Streamer.ReadInt8));
  AssertEquals('Streamer.ReadUInt8 returned value that isn''t equal to 255!', Cardinal(255), Cardinal(Streamer.ReadUInt8));

  { (3.3) Int16 and UInt16. }
  AssertEquals('Streamer.ReadInt16 returned value that isn''t equal to 32767!', Cardinal(32767), Cardinal(Streamer.ReadInt16));
  AssertEquals('Streamer.ReadUInt16 returned value that isn''t equal to 65535!', Cardinal(65535), Cardinal(Streamer.ReadUInt16));

  { (3.4) Int32 and UInt32. }
  AssertEquals('Streamer.ReadInt32 returned value that isn''t equal to 2147483647!', Cardinal(2147483647), Cardinal(Streamer.ReadInt32));
  AssertEquals('Streamer.ReadUInt32 returned value that isn''t equal to 4294967295!', Cardinal(4294967295), Cardinal(Streamer.ReadUInt32));

  { (3.5) Int64 and UInt64. }
  AssertEquals('Streamer.ReadInt64 returned value that isn''t eqaul to 9223372036854775807!', Int64(9223372036854775807), Int64(Streamer.ReadInt64));
  AssertEquals('Streamer.ReadUInt64 returned value that isn''t equal to 18446744073709551615!', UInt64(18446744073709551615), UInt64(Streamer.ReadUInt64));

  { (3.6) Float32, Float64, Float80 and Currency. }
  AssertEquals('Streamer.ReadFloat32 returned value that isn''t equal to 3.14!', Float32(3.14), Float32(Streamer.ReadFloat32), 0.001);
  AssertEquals('Streamer.ReadFloat64 returned value that isn''t equal to 3.14!', Float64(3.14), Float64(Streamer.ReadFloat64), 0.001);
  //AssertEquals('Streamer.ReadFloat80 returned value that isn''t equal to 3.14!', Float80(3.14), Float80(Streamer.ReadFloat80), 0.001);
  AssertEquals('Streamer.ReadCurrency returned value that isn''t equal to 3.14!', Currency(3.14), Currency(Streamer.ReadCurrency), 0.001);

  { (3.7) AnsiChar, UTF8Char, WideChar and UnicodeChar. }
  AssertEquals('Streamer.ReadAnsiChar returned value that isn''t equal to AnsiChar(#13)', AnsiChar(#13), AnsiChar(Streamer.ReadAnsiChar));
  AssertEquals('Streamer.ReadUTF8Char returned value that isn''t equal to UTF8Char(#13)', UTF8Char(#13), UTF8Char(Streamer.ReadUTF8Char));
  AssertEquals('Streamer.ReadWideChar returned value that isn''t equal to WideChar(#13)', WideChar(#13), WideChar(Streamer.ReadWideChar));
  AssertEquals('Streamer.ReadUnicodeChar returned value that isn''t equal to UnicodeChar(#13)', UnicodeChar(#13), UnicodeChar(Streamer.ReadUnicodeChar));

  { (3.8) ShortString, AnsiString, UTF8String, WideString, UnicodeString and
          String. }
  AssertEquals('Streamer.ReadShortString returned value that isn''t equal to ShortString(TestString)!', ShortString(TestString), ShortString(Streamer.ReadShortString));
  AssertEquals('Streamer.ReadAnsiString returned value that isn''t equal to AnsiString(TestString)!', AnsiString(TestString), AnsiString(Streamer.ReadAnsiString));
  AssertEquals('Streamer.ReadUTF8String returned value that isn''t equal to UTF8String(TestString)!', UTF8String(TestString), UTF8String(Streamer.ReadUTF8String));
  AssertEquals('Streamer.ReadWideString returned value that isn''t equal to WideString(TestString)!', WideString(TestString), WideString(Streamer.ReadWideString));
  AssertEquals('Streamer.ReadUnicodeString returned value that isn''t equal to UnicodeString(TestString)!', UnicodeString(TestString), UnicodeString(Streamer.ReadUnicodeString));
  AssertEquals('Streamer.ReadString returned value that isn''t equal to String(TestString)!', String(TestString), String(Streamer.ReadString));

  { (3.9) TDateTime. }
  { (3.9.1) Read TDateTime to DT2. }
  DT2 := Streamer.ReadDateTime;

  { (3.9.2) Decode time of DT and DT2. }
  DecodeTime(DT, Hour, Minute, Second, MilliSecond);
  DecodeTime(DT2, Hour2, Minute2, Second2, MilliSecond2);

  { (3.9.3) Decode date of DT and DT2. }
  DecodeDate(DT, Year, Month, Day);
  DecodeDate(DT2, Year2, Month2, Day2);

  { (3.9.4) Compare both dates and times. }
  AssertEquals('Hour value isn''t equal to Hour2 value!', Integer(Hour), Integer(Hour2));
  AssertEquals('Minute value isn''t equal to Minute2 value!', Integer(Minute), Integer(Minute2));
  AssertEquals('Second value isn''t equal to Second2 value!', Integer(Second), Integer(Second2));
  //AssertEquals('MilliSecond value isn''t equal to MilliSecond2 value!', Integer(MilliSecond), Integer(MilliSecond2));
  AssertEquals('Year value isn''t equal to Year2 value!', Integer(Year), Integer(Year2));
  AssertEquals('Month value isn''t equal to Month2 value!', Integer(Month), Integer(Month2));
  AssertEquals('Day value isn''t equal to Day2 value!', Integer(Day), Integer(Day2));

  { (4) BytesArray. }
  for I := 0 to 7 do
    AssertEquals('Streamer.ReadUInt8 value isn''t equal to ' + BytesArray[I].ToString + '!', UInt8(BytesArray[I]), UInt8(Streamer.ReadUInt8));

  { (5) Buffer. }
  { (5.1) Set proper length for dynamic array Arr and fill it with 0. }
  SetLength(Arr, 8);
  FillChar(Arr[0], Length(Arr), 0);

  { (5.2) Read buffer from Streamer. }
  AssertEquals('Streamer.ReadBuffer(Pointer(Arr)^, Length(BytesArray)) returned value isn''t equal to 8!', Cardinal(8), Cardinal(Streamer.ReadBuffer(Pointer(Arr)^, Length(BytesArray))));

  { (5.3) Compare each entry with BytesArray. }
  for I := 0 to 7 do
    AssertEquals('Arr[' + I.ToString + '] value isn''t equal to ' + BytesArray[I].ToString + '!', BytesArray[I], Arr[I]);

  { (5.4) To avoid memory leak, set length of Arr to 0. }
  SetLength(Arr, 0);
end;

procedure TBasicClasses_TMemoryStreamer_TestCase.Test_Bookmarks;
var
  I: UInt8;
begin
  { (1) Add new bookmark and add 50 bytes of some data. }
  Streamer.AddBookmark;
  for I := 1 to 50 do
    Streamer.writeUInt8(UInt8(I));

  { (2) Add new bookmark and add 50 bytes of some data. }
  Streamer.AddBookmark;
  for I := 1 to 50 do
    Streamer.writeUInt8(UInt8(200 - I));

  { (3) Add new bookmark and add 50 bytes of some data. }
  Streamer.AddBookmark;
  for I := 1 to 50 do
    Streamer.writeUInt8(UInt8(I));

  { (4) Add new bookmark and add 50 bytes of some data. }
  Streamer.AddBookmark;
  for I := 1 to 50 do
    Streamer.writeUInt8(UInt8(100 - I));

  { (5) Set position of Streamer cursor to Bookmark[1], read 50 bytes and check
        that read values are valid. }
  Streamer.MoveToBookmark(1);
  for I := 1 to 50 do
    AssertEquals('Streamer.ReadUInt8 returned value isn''t equal to ' + UInt8(200 - I).ToString, UInt8(200 - I), UInt8(Streamer.ReadUInt8));
end;

{ TBasicClasses_TStreamStreamer_TestCase - class implementation }
procedure TBasicClasses_TStreamStreamer_TestCase.SetUp;
begin
  { (1) Create TFileStream. }
  FileStream := TFileStream.Create('Test.txt', fmCreate);

  { (2) Create TStreamStreamer. }
  Streamer := TStreamStreamer.Create(FileStream);
end;

procedure TBasicClasses_TStreamStreamer_TestCase.TearDown;
begin
  { (1) Release Streamer and set it to nil. }
  Streamer.Free;
  Streamer := nil;

  { (2) Release FileStream and set it to nil. }
  FileStream.Free;
  FileStream := nil;

  { (3) Remove 'Test.txt' file if exists. }
  if (FileExists('Test.txt')) then
    DeleteFile('Test.txt');
end;

procedure TBasicClasses_TStreamStreamer_TestCase.Test_Creation;
begin
  AssertTrue('Streamer isn''t assigned!', Assigned(Streamer));
  AssertEquals('Streamer.Capacity isn''t equal to 0!', Cardinal(0), Cardinal(Streamer.Capacity));
  AssertEquals('Streamer.Count isn''t equal to 0!', Cardinal(0), Cardinal(Streamer.Count));
end;

procedure TBasicClasses_TStreamStreamer_TestCase.Test_WriteAndRead;
const
  TestString: String = 'Test string';
  BytesArray: array of UInt8 = (2, 4, 8, 16, 32, 64, 128, 255);
var
  BooleanVal: Boolean;
  DT, DT2: TDateTime;
  Hour, Minute, Second, MilliSecond: Word;
  Hour2, Minute2, Second2, MilliSecond2: Word;
  Year, Month, Day: Word;
  Year2, Month2, Day2: Word;
  I: Integer;
  Arr: array of UInt8;
begin
  { (1) Write all types to our streamer. Check sizes of actual writes that are
        valid. }
  { (1.1) ByteBool and Boolean. }
  AssertEquals('Streamer.WriteBool(True) returned value that isn''t equal to 1!', Cardinal(1), Cardinal(Streamer.WriteBool(True)));
  AssertEquals('Streamer.WriteBoolean(True) returned value that isn''t equal to 1!', Cardinal(1), Cardinal(Streamer.WriteBoolean(True)));

  { (1.2) Int8 and UInt8. }
  AssertEquals('Streamer.WriteInt8(127) returned value that isn''t equal to 1!', Cardinal(1), Cardinal(Streamer.WriteInt8(127)));
  AssertEquals('Streamer.WriteUInt8(255) returned value that isn''t equal to 1!', Cardinal(1), Cardinal(Streamer.WriteUInt8(255)));

  { (1.3) Int16 and UInt16. }
  AssertEquals('Streamer.WriteInt16(32767) returned value that isn''t equal to 2!', Cardinal(2), Cardinal(Streamer.WriteInt16(32767)));
  AssertEquals('Streamer.WriteUInt16(65535) returned value that isn''t equal to 2!', Cardinal(2), Cardinal(Streamer.WriteUInt16(65535)));

  { (1.4) Int32 and UInt32. }
  AssertEquals('Streamer.WriteInt32(2147483647) returned value that isn''t equal to 4!', Cardinal(4), Cardinal(Streamer.WriteInt32(2147483647)));
  AssertEquals('Streamer.WriteUInt32(4294967295) returned value that isn''t equal to 4!', Cardinal(4), Cardinal(Streamer.WriteUInt32(4294967295)));

  { (1.5) Int64 and UInt64. }
  AssertEquals('Streamer.WriteInt64(9223372036854775807) returned value that isn''t equal to 8!', Cardinal(8), Cardinal(Streamer.WriteInt64(9223372036854775807)));
  AssertEquals('Streamer.WriteUInt64(18446744073709551615) returned value that isn''t equal to 8!', Cardinal(8), Cardinal(Streamer.WriteUInt64(18446744073709551615)));

  { (1.6) Float32, Float64, Float80 and Currency. }
  AssertEquals('Streamer.WriteFloat32(Float32(3.14)) returned value that isn''t equal to 4!', Cardinal(4), Cardinal(Streamer.WriteFloat32(Float32(3.14))));
  AssertEquals('Streamer.WriteFloat64(Float64(3.14)) returned value that isn''t equal to 8!', Cardinal(8), Cardinal(Streamer.WriteFloat64(Float64(3.14))));
  //AssertEquals('Streamer.WriteFloat80(Float80(3.14)) returned value that isn''t equal to 10!', Cardinal(10), Cardinal(Streamer.WriteFloat80(Float80(3.14))));
  AssertEquals('Streamer.WriteCurrency(Currency(3.14)) returned value that isn''t equal to 8!', Cardinal(8), Cardinal(Streamer.WriteCurrency(Currency(3.14))));

  { (1.7) AnsiChar, UTF8Char, WideChar and UnicodeChar. }
  AssertEquals('Streamer.WriteAnsiChar(#13) returned value that isn''t equal to 1!', Cardinal(1), Cardinal(Streamer.WriteAnsiChar(#13)));
  AssertEquals('Streamer.WriteUTF8Char(#13) returned value that isn''t equal to 1!', Cardinal(1), Cardinal(Streamer.WriteUTF8Char(#13)));
  AssertEquals('Streamer.WriteWideChar(#13) returned value that isn''t equal to 2!', Cardinal(2), Cardinal(Streamer.WriteWideChar(#13)));
  AssertEquals('Streamer.WriteUnicodeChar(#13) returned value that isn''t equal to 2!', Cardinal(2), Cardinal(Streamer.WriteUnicodeChar(#13)));

  { (1.8) ShortString, AnsiString, UTF8String, WideString, UnicodeString and
          String. }
  AssertEquals('Streamer.WriteShortString(ShortString(TestString)) returned value that isn''t equal to 12!', Cardinal(12), Cardinal(Streamer.WriteShortString(ShortString(TestString))));
  AssertEquals('Streamer.WriteAnsiString(AnsiString(TestString)) returned value that isn''t equal to 15!', Cardinal(15), Cardinal(Streamer.WriteAnsiString(AnsiString(TestString))));
  AssertEquals('Streamer.WriteUTF8String(UTF8String(TestString)) returned value that isn''t equal to 15!', Cardinal(15), Cardinal(Streamer.WriteUTF8String(UTF8String(TestString))));
  AssertEquals('Streamer.WriteWideString(WideString(TestString)) returned value that isn''t equal to 26!', Cardinal(26), Cardinal(Streamer.WriteWideString(WideString(TestString))));
  AssertEquals('Streamer.WriteUnicodeString(UnicodeString(TestString)) returned value that isn''t equal to 26!', Cardinal(26), Cardinal(Streamer.WriteUnicodeString(UnicodeString(TestString))));
  AssertEquals('Streamer.WriteString(TestString) returned value that isn''t equal to 15!', Cardinal(15), Cardinal(Streamer.WriteString(TestString)));

  { (1.9) TDateTime. }
  DT := Now;
  AssertEquals('Streamer.WriteDateTime(DT) returned value that isn''t equal to 8!', Cardinal(8), Cardinal(Streamer.WriteDateTime(DT)));

  { (1.10) BytesArray. }
  AssertEquals('Streamer.WriteBytes(BytesArray) returned value that isn''t equal to 8!', Cardinal(8), Cardinal(Streamer.WriteBytes(BytesArray)));

  { (1.11) Buffer. }
  AssertEquals('Streamer.WriteBuffer(Pointer(BytesArray)^, Length(BytesArray)) returned value that isn''t equal to 8!', Cardinal(8), Cardinal(Streamer.WriteBuffer(Pointer(BytesArray)^, Length(BytesArray))));

  { (2) Move Streamer cursor to start position. }
  Streamer.MoveToStart;

  { (3) Read all types from our streamer. Check sizes of actual reads that are
        valid. }
  { (3.1) ByteBool and Boolean. }
  AssertEquals('Streamer.ReadBool returned value that isn''t equal to ByteBool(True)!', ByteBool(True), ByteBool(Streamer.ReadBool));
  AssertEquals('Streamer.ReadBoolean returned value that isn''t equal to 1!', Cardinal(1), Cardinal(Streamer.ReadBoolean(BooleanVal)));
  AssertTrue('BooleanVal isn''t True!', BooleanVal);

  { (3.2) Int8 and UInt8. }
  AssertEquals('Streamer.ReadInt8 returned value that isn''t equal to 127!', Cardinal(127), Cardinal(Streamer.ReadInt8));
  AssertEquals('Streamer.ReadUInt8 returned value that isn''t equal to 255!', Cardinal(255), Cardinal(Streamer.ReadUInt8));

  { (3.3) Int16 and UInt16. }
  AssertEquals('Streamer.ReadInt16 returned value that isn''t equal to 32767!', Cardinal(32767), Cardinal(Streamer.ReadInt16));
  AssertEquals('Streamer.ReadUInt16 returned value that isn''t equal to 65535!', Cardinal(65535), Cardinal(Streamer.ReadUInt16));

  { (3.4) Int32 and UInt32. }
  AssertEquals('Streamer.ReadInt32 returned value that isn''t equal to 2147483647!', Cardinal(2147483647), Cardinal(Streamer.ReadInt32));
  AssertEquals('Streamer.ReadUInt32 returned value that isn''t equal to 4294967295!', Cardinal(4294967295), Cardinal(Streamer.ReadUInt32));

  { (3.5) Int64 and UInt64. }
  AssertEquals('Streamer.ReadInt64 returned value that isn''t eqaul to 9223372036854775807!', Int64(9223372036854775807), Int64(Streamer.ReadInt64));
  AssertEquals('Streamer.ReadUInt64 returned value that isn''t equal to 18446744073709551615!', UInt64(18446744073709551615), UInt64(Streamer.ReadUInt64));

  { (3.6) Float32, Float64, Float80 and Currency. }
  AssertEquals('Streamer.ReadFloat32 returned value that isn''t equal to 3.14!', Float32(3.14), Float32(Streamer.ReadFloat32), 0.001);
  AssertEquals('Streamer.ReadFloat64 returned value that isn''t equal to 3.14!', Float64(3.14), Float64(Streamer.ReadFloat64), 0.001);
  //AssertEquals('Streamer.ReadFloat80 returned value that isn''t equal to 3.14!', Float80(3.14), Float80(Streamer.ReadFloat80), 0.001);
  AssertEquals('Streamer.ReadCurrency returned value that isn''t equal to 3.14!', Currency(3.14), Currency(Streamer.ReadCurrency), 0.001);

  { (3.7) AnsiChar, UTF8Char, WideChar and UnicodeChar. }
  AssertEquals('Streamer.ReadAnsiChar returned value that isn''t equal to AnsiChar(#13)', AnsiChar(#13), AnsiChar(Streamer.ReadAnsiChar));
  AssertEquals('Streamer.ReadUTF8Char returned value that isn''t equal to UTF8Char(#13)', UTF8Char(#13), UTF8Char(Streamer.ReadUTF8Char));
  AssertEquals('Streamer.ReadWideChar returned value that isn''t equal to WideChar(#13)', WideChar(#13), WideChar(Streamer.ReadWideChar));
  AssertEquals('Streamer.ReadUnicodeChar returned value that isn''t equal to UnicodeChar(#13)', UnicodeChar(#13), UnicodeChar(Streamer.ReadUnicodeChar));

  { (3.8) ShortString, AnsiString, UTF8String, WideString, UnicodeString and
          String. }
  AssertEquals('Streamer.ReadShortString returned value that isn''t equal to ShortString(TestString)!', ShortString(TestString), ShortString(Streamer.ReadShortString));
  AssertEquals('Streamer.ReadAnsiString returned value that isn''t equal to AnsiString(TestString)!', AnsiString(TestString), AnsiString(Streamer.ReadAnsiString));
  AssertEquals('Streamer.ReadUTF8String returned value that isn''t equal to UTF8String(TestString)!', UTF8String(TestString), UTF8String(Streamer.ReadUTF8String));
  AssertEquals('Streamer.ReadWideString returned value that isn''t equal to WideString(TestString)!', WideString(TestString), WideString(Streamer.ReadWideString));
  AssertEquals('Streamer.ReadUnicodeString returned value that isn''t equal to UnicodeString(TestString)!', UnicodeString(TestString), UnicodeString(Streamer.ReadUnicodeString));
  AssertEquals('Streamer.ReadString returned value that isn''t equal to String(TestString)!', String(TestString), String(Streamer.ReadString));

  { (3.9) TDateTime. }
  { (3.9.1) Read TDateTime to DT2. }
  DT2 := Streamer.ReadDateTime;

  { (3.9.2) Decode time of DT and DT2. }
  DecodeTime(DT, Hour, Minute, Second, MilliSecond);
  DecodeTime(DT2, Hour2, Minute2, Second2, MilliSecond2);

  { (3.9.3) Decode date of DT and DT2. }
  DecodeDate(DT, Year, Month, Day);
  DecodeDate(DT2, Year2, Month2, Day2);

  { (3.9.4) Compare both dates and times. }
  AssertEquals('Hour value isn''t equal to Hour2 value!', Integer(Hour), Integer(Hour2));
  AssertEquals('Minute value isn''t equal to Minute2 value!', Integer(Minute), Integer(Minute2));
  AssertEquals('Second value isn''t equal to Second2 value!', Integer(Second), Integer(Second2));
  AssertEquals('MilliSecond value isn''t equal to MilliSecond2 value!', Integer(MilliSecond), Integer(MilliSecond2));
  AssertEquals('Year value isn''t equal to Year2 value!', Integer(Year), Integer(Year2));
  AssertEquals('Month value isn''t equal to Month2 value!', Integer(Month), Integer(Month2));
  AssertEquals('Day value isn''t equal to Day2 value!', Integer(Day), Integer(Day2));

  { (4) BytesArray. }
  for I := 0 to 7 do
    AssertEquals('Streamer.ReadUInt8 value isn''t equal to ' + BytesArray[I].ToString + '!', UInt8(BytesArray[I]), UInt8(Streamer.ReadUInt8));

  { (5) Buffer. }
  { (5.1) Set proper length for dynamic array Arr and fill it with 0. }
  SetLength(Arr, 8);
  FillChar(Arr[0], Length(Arr), 0);

  { (5.2) Read buffer from Streamer. }
  AssertEquals('Streamer.ReadBuffer(Pointer(Arr)^, Length(BytesArray)) returned value isn''t equal to 8!', Cardinal(8), Cardinal(Streamer.ReadBuffer(Pointer(Arr)^, Length(BytesArray))));

  { (5.3) Compare each entry with BytesArray. }
  for I := 0 to 7 do
    AssertEquals('Arr[' + I.ToString + '] value isn''t equal to ' + BytesArray[I].ToString + '!', BytesArray[I], Arr[I]);

  { (5.4) To avoid memory leak, set length of Arr to 0. }
  SetLength(Arr, 0);
end;

procedure TBasicClasses_TStreamStreamer_TestCase.Test_Bookmarks;
var
  I: UInt8;
begin
  { (1) Add new bookmark and add 50 bytes of some data. }
  Streamer.AddBookmark;
  for I := 1 to 50 do
    Streamer.writeUInt8(UInt8(I));

  { (2) Add new bookmark and add 50 bytes of some data. }
  Streamer.AddBookmark;
  for I := 1 to 50 do
    Streamer.writeUInt8(UInt8(200 - I));

  { (3) Add new bookmark and add 50 bytes of some data. }
  Streamer.AddBookmark;
  for I := 1 to 50 do
    Streamer.writeUInt8(UInt8(I));

  { (4) Add new bookmark and add 50 bytes of some data. }
  Streamer.AddBookmark;
  for I := 1 to 50 do
    Streamer.writeUInt8(UInt8(100 - I));

  { (5) Set position of Streamer cursor to Bookmark[1], read 50 bytes and check
        that read values are valid. }
  Streamer.MoveToBookmark(1);
  for I := 1 to 50 do
    AssertEquals('Streamer.ReadUInt8 returned value isn''t equal to ' + UInt8(200 - I).ToString, UInt8(200 - I), UInt8(Streamer.ReadUInt8));
end;

initialization
  RegisterTests(
    [TBasicClasses_TCustomStreamer_TestCase,
     TBasicClasses_TMemoryStreamer_TestCase,
     TBasicClasses_TStreamStreamer_TestCase]);

end.

