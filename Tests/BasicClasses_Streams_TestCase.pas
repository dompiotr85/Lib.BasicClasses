unit BasicClasses_Streams_TestCase;

interface

uses
  System.Types,
  System.Classes,
  DUnitX.TestFramework,
  TypeDefinitions,
  BasicClasses.Lists,
  BasicClasses.Streams;

type
  { TBasicClasses_TCustomStreamer_TestCase - class definition }
  [TestFixture]
  TBasicClasses_TCustomStreamer_TestCase = class
  private
    Streamer: TCustomStreamer;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    { Test methods }
    [TestCase('TCustomStreamer Creation', '')]
    procedure Test_Creation;
    [TestCase('TCustomStreamer AddBookmarks', '')]
    procedure Test_AddBookmarks;
    [TestCase('TCustomStreamer RemoveBookmarks', '')]
    procedure Test_RemoveBookmarks;
  end;

  { TBasicClasses_TMemoryStreamer_TestCase - class definition }
  [TestFixture]
  TBasicClasses_TMemoryStreamer_TestCase = class
  private
    Streamer: TMemoryStreamer;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    { Test methods }
    [TestCase('TMemoryStreamer Creation', '')]
    procedure Test_Creation;
    [TestCase('TMemoryStreamer WriteAndRead', '')]
    procedure Test_WriteAndRead;
    [TestCase('TMemoryStreamer Bookmarks', '')]
    procedure Test_Bookmarks;
  end;

  { TBasicClasses_TStreamStreamer_TestCase - class definition }
  TBasicClasses_TStreamStreamer_TestCase = class
  private
    FileStream: TFileStream;
    Streamer: TStreamStreamer;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    { Test methods }
    [TestCase('TStreamStreamer Creation', '')]
    procedure Test_Creation;
    [TestCase('TStreamStreamer WriteAndRead', '')]
    procedure Test_WriteAndRead;
    [TestCase('TStreamStreamer Bookmarks', '')]
    procedure Test_Bookmarks;
  end;

implementation

uses
  System.SysUtils;


{ TBasicClasses_TCustomStreamer_TestCase - class implementation }
procedure TBasicClasses_TCustomStreamer_TestCase.Setup;
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
    Assert.AreEqual(Cardinal(Idx - 1), Cardinal(I), 'Streamer.AddBookmark(Int64(Idx)) returned invalid value!');
    Assert.AreEqual(Cardinal(Idx), Cardinal(Streamer.Count), 'Streamer.Count isn''t equal to ' + Idx.ToString + '!');
    Assert.AreEqual(Cardinal(Idx), Cardinal(Streamer.Bookmarks[Idx - 1]), 'Streamer.Bookmarks[Idx - 1] value isn''t equal to ' + Idx.ToString);
  end;

  { (2) Clear Streamer's bookmarks. }
  Streamer.ClearBookmark;
end;

procedure TBasicClasses_TCustomStreamer_TestCase.Test_Creation;
begin
  Assert.IsTrue(Assigned(Streamer), 'Streamer isn''t assigned!');
  Assert.AreEqual(Cardinal(0), Cardinal(Streamer.Capacity), 'Streamer.Capacity isn''t equal to 0!');
  Assert.AreEqual(Cardinal(0), Cardinal(Streamer.Count), 'Streamer.Count isn''t equal to 0!');
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
    Assert.AreEqual(Cardinal(Idx), Cardinal(Streamer.Bookmarks[Idx - 1]), 'Streamer.Bookmarks[Idx - 1] value isn''t equal to ' + Idx.ToString);
    Assert.AreEqual(Cardinal(Idx), Cardinal(Streamer.Count), 'Streamer.Count isn''t equal to ' + Idx.ToString + '!');
  end;

  { (2.1) Itterate from 0 to (Streamer.Count - 1) and: }
  for Idx := 0 to (Streamer.Count - 1) do
  begin
    { (2.2) Retrieve first bookmark of the Streamer. }
    Bookmark := Streamer.Bookmarks[0];

    { (2.3) Remove Streamer's first bookmark and check that function returned
            value other than -1 and that Streamer.Count have proper value. }
    Assert.IsTrue(Streamer.RemoveBookmark(Bookmark, False) <> -1, 'Streamer.RemoveBookmark(Bookmark, False) returned invalid value!');
    Assert.AreEqual(Cardinal(10 - (Idx + 1)), Cardinal(Streamer.Count), 'Streamer.Count isn''t equal to ' + Cardinal(10 - (Idx + 1)).ToString);
  end;
end;

{ TBasicClasses_TMemoryStreamer_TestCase - class implementation }
procedure TBasicClasses_TMemoryStreamer_TestCase.Setup;
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
    Assert.AreEqual(UInt8(200 - I), UInt8(Streamer.ReadUInt8), 'Streamer.ReadUInt8 returned value isn''t equal to ' + UInt8(200 - I).ToString);
end;

procedure TBasicClasses_TMemoryStreamer_TestCase.Test_Creation;
begin
  Assert.IsTrue(Assigned(Streamer), 'Streamer isn''t assigned!');
  Assert.AreEqual(Cardinal(0), Cardinal(Streamer.Capacity), 'Streamer.Capacity isn''t equal to 0!');
  Assert.AreEqual(Cardinal(0), Cardinal(Streamer.Count), 'Streamer.Count isn''t equal to 0!');
end;

procedure TBasicClasses_TMemoryStreamer_TestCase.Test_WriteAndRead;
const
  TestString: String = 'Test string';
  BytesArray: array of UInt8 = [2, 4, 8, 16, 32, 64, 128, 255];
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
  Assert.AreEqual(Cardinal(1), Cardinal(Streamer.WriteBool(True)), 'Streamer.WriteBool(True) returned value that isn''t equal to 1!');
  Assert.AreEqual(Cardinal(1), Cardinal(Streamer.WriteBoolean(True)), 'Streamer.WriteBoolean(True) returned value that isn''t equal to 1!');

  { (1.2) Int8 and UInt8. }
  Assert.AreEqual(Cardinal(1), Cardinal(Streamer.WriteInt8(127)), 'Streamer.WriteInt8(127) returned value that isn''t equal to 1!');
  Assert.AreEqual(Cardinal(1), Cardinal(Streamer.WriteUInt8(255)), 'Streamer.WriteUInt8(255) returned value that isn''t equal to 1!');

  { (1.3) Int16 and UInt16. }
  Assert.AreEqual(Cardinal(2), Cardinal(Streamer.WriteInt16(32767)), 'Streamer.WriteInt16(32767) returned value that isn''t equal to 2!');
  Assert.AreEqual(Cardinal(2), Cardinal(Streamer.WriteUInt16(65535)), 'Streamer.WriteUInt16(65535) returned value that isn''t equal to 2!');

  { (1.4) Int32 and UInt32. }
  Assert.AreEqual(Cardinal(4), Cardinal(Streamer.WriteInt32(2147483647)), 'Streamer.WriteInt32(2147483647) returned value that isn''t equal to 4!');
  Assert.AreEqual(Cardinal(4), Cardinal(Streamer.WriteUInt32(4294967295)), 'Streamer.WriteUInt32(4294967295) returned value that isn''t equal to 4!');

  { (1.5) Int64 and UInt64. }
  Assert.AreEqual(Cardinal(8), Cardinal(Streamer.WriteInt64(9223372036854775807)), 'Streamer.WriteInt64(9223372036854775807) returned value that isn''t equal to 8!');
  Assert.AreEqual(Cardinal(8), Cardinal(Streamer.WriteUInt64(18446744073709551615)), 'Streamer.WriteUInt64(18446744073709551615) returned value that isn''t equal to 8!');

  { (1.6) Float32, Float64, Float80 and Currency. }
  Assert.AreEqual(Cardinal(4), Cardinal(Streamer.WriteFloat32(Float32(3.14))), 'Streamer.WriteFloat32(Float32(3.14)) returned value that isn''t equal to 4!');
  Assert.AreEqual(Cardinal(8), Cardinal(Streamer.WriteFloat64(Float64(3.14))), 'Streamer.WriteFloat64(Float64(3.14)) returned value that isn''t equal to 8!');
  //Assert.AreEqual(Cardinal(10), Cardinal(Streamer.WriteFloat80(Float80(3.14))), 'Streamer.WriteFloat80(Float80(3.14)) returned value that isn''t equal to 10!');
  Assert.AreEqual(Cardinal(8), Cardinal(Streamer.WriteCurrency(Currency(3.14))), 'Streamer.WriteCurrency(Currency(3.14)) returned value that isn''t equal to 8!');

  { (1.7) AnsiChar, UTF8Char, WideChar and UnicodeChar. }
  Assert.AreEqual(Cardinal(1), Cardinal(Streamer.WriteAnsiChar(#13)), 'Streamer.WriteAnsiChar(#13) returned value that isn''t equal to 1!');
  Assert.AreEqual(Cardinal(1), Cardinal(Streamer.WriteUTF8Char(#13)), 'Streamer.WriteUTF8Char(#13) returned value that isn''t equal to 1!');
  Assert.AreEqual(Cardinal(2), Cardinal(Streamer.WriteWideChar(#13)), 'Streamer.WriteWideChar(#13) returned value that isn''t equal to 2!');
  Assert.AreEqual(Cardinal(2), Cardinal(Streamer.WriteUnicodeChar(#13)), 'Streamer.WriteUnicodeChar(#13) returned value that isn''t equal to 2!');

  { (1.8) ShortString, AnsiString, UTF8String, WideString, UnicodeString and
          String. }
  Assert.AreEqual(Cardinal(12), Cardinal(Streamer.WriteShortString(ShortString(TestString))), 'Streamer.WriteShortString(ShortString(TestString)) returned value that isn''t equal to 12!');
  Assert.AreEqual(Cardinal(15), Cardinal(Streamer.WriteAnsiString(AnsiString(TestString))), 'Streamer.WriteAnsiString(AnsiString(TestString)) returned value that isn''t equal to 15!');
  Assert.AreEqual(Cardinal(15), Cardinal(Streamer.WriteUTF8String(UTF8String(TestString))), 'Streamer.WriteUTF8String(UTF8String(TestString)) returned value that isn''t equal to 15!');
  Assert.AreEqual(Cardinal(26), Cardinal(Streamer.WriteWideString(WideString(TestString))), 'Streamer.WriteWideString(WideString(TestString)) returned value that isn''t equal to 26!');
  Assert.AreEqual(Cardinal(26), Cardinal(Streamer.WriteUnicodeString(UnicodeString(TestString))), 'Streamer.WriteUnicodeString(UnicodeString(TestString)) returned value that isn''t equal to 26!');
  Assert.AreEqual(Cardinal(15), Cardinal(Streamer.WriteString(TestString)), 'Streamer.WriteString(TestString) returned value that isn''t equal to 15!');

  { (1.9) TDateTime. }
  DT := Now;
  Assert.AreEqual(Cardinal(8), Cardinal(Streamer.WriteDateTime(DT)), 'Streamer.WriteDateTime(DT) returned value that isn''t equal to 8!');

  { (1.10) BytesArray. }
  Assert.AreEqual(Cardinal(8), Cardinal(Streamer.WriteBytes(BytesArray)), 'Streamer.WriteBytes(BytesArray) returned value that isn''t equal to 8!');

  { (1.11) Buffer. }
  Assert.AreEqual(Cardinal(8), Cardinal(Streamer.WriteBuffer(Pointer(BytesArray)^, Length(BytesArray))), 'Streamer.WriteBuffer(Pointer(BytesArray)^, Length(BytesArray)) returned value that isn''t equal to 8!');

  { (2) Move Streamer cursor to start position. }
  Streamer.MoveToStart;

  { (3) Read all types from our streamer. Check sizes of actual reads that are
        valid. }
  { (3.1) ByteBool and Boolean. }
  Assert.AreEqual(ByteBool(True), ByteBool(Streamer.ReadBool), 'Streamer.ReadBool returned value that isn''t equal to ByteBool(True)!');
  Assert.AreEqual(Cardinal(1), Cardinal(Streamer.ReadBoolean(BooleanVal)), 'Streamer.ReadBoolean returned value that isn''t equal to 1!');
  Assert.IsTrue(BooleanVal, 'BooleanVal isn''t True!');

  { (3.2) Int8 and UInt8. }
  Assert.AreEqual(Cardinal(127), Cardinal(Streamer.ReadInt8), 'Streamer.ReadInt8 returned value that isn''t equal to 127!');
  Assert.AreEqual(Cardinal(255), Cardinal(Streamer.ReadUInt8), 'Streamer.ReadUInt8 returned value that isn''t equal to 255!');

  { (3.3) Int16 and UInt16. }
  Assert.AreEqual(Cardinal(32767), Cardinal(Streamer.ReadInt16), 'Streamer.ReadInt16 returned value that isn''t equal to 32767!');
  Assert.AreEqual(Cardinal(65535), Cardinal(Streamer.ReadUInt16), 'Streamer.ReadUInt16 returned value that isn''t equal to 65535!');

  { (3.4) Int32 and UInt32. }
  Assert.AreEqual(Cardinal(2147483647), Cardinal(Streamer.ReadInt32), 'Streamer.ReadInt32 returned value that isn''t equal to 2147483647!');
  Assert.AreEqual(Cardinal(4294967295), Cardinal(Streamer.ReadUInt32), 'Streamer.ReadUInt32 returned value that isn''t equal to 4294967295!');

  { (3.5) Int64 and UInt64. }
  Assert.AreEqual(Int64(9223372036854775807), Int64(Streamer.ReadInt64), 'Streamer.ReadInt64 returned value that isn''t eqaul to 9223372036854775807!');
  Assert.AreEqual(UInt64(18446744073709551615), UInt64(Streamer.ReadUInt64), 'Streamer.ReadUInt64 returned value that isn''t equal to 18446744073709551615!');

  { (3.6) Float32, Float64, Float80 and Currency. }
  Assert.AreEqual(Float32(3.14), Float32(Streamer.ReadFloat32), 0.001, 'Streamer.ReadFloat32 returned value that isn''t equal to 3.14!');
  Assert.AreEqual(Float64(3.14), Float64(Streamer.ReadFloat64), 0.001, 'Streamer.ReadFloat64 returned value that isn''t equal to 3.14!');
  //Assert.AreEqual(Float80(3.14), Float80(Streamer.ReadFloat80), 0.001, 'Streamer.ReadFloat80 returned value that isn''t equal to 3.14!');
  Assert.AreEqual(Currency(3.14), Currency(Streamer.ReadCurrency), 0.001, 'Streamer.ReadCurrency returned value that isn''t equal to 3.14!');

  { (3.7) AnsiChar, UTF8Char, WideChar and UnicodeChar. }
  Assert.AreEqual(AnsiChar(#13), AnsiChar(Streamer.ReadAnsiChar), 'Streamer.ReadAnsiChar returned value that isn''t equal to AnsiChar(#13)');
  Assert.AreEqual(UTF8Char(#13), UTF8Char(Streamer.ReadUTF8Char), 'Streamer.ReadUTF8Char returned value that isn''t equal to UTF8Char(#13)');
  Assert.AreEqual(WideChar(#13), WideChar(Streamer.ReadWideChar), 'Streamer.ReadWideChar returned value that isn''t equal to WideChar(#13)');
  Assert.AreEqual(UnicodeChar(#13), UnicodeChar(Streamer.ReadUnicodeChar), 'Streamer.ReadUnicodeChar returned value that isn''t equal to UnicodeChar(#13)');

  { (3.8) ShortString, AnsiString, UTF8String, WideString, UnicodeString and
          String. }
  Assert.AreEqual(String(TestString), String(Streamer.ReadShortString), 'Streamer.ReadShortString returned value that isn''t equal to ShortString(TestString)!');
  Assert.AreEqual(AnsiString(TestString), AnsiString(Streamer.ReadAnsiString), 'Streamer.ReadAnsiString returned value that isn''t equal to AnsiString(TestString)!');
  Assert.AreEqual(UTF8String(TestString), UTF8String(Streamer.ReadUTF8String), 'Streamer.ReadUTF8String returned value that isn''t equal to UTF8String(TestString)!');
  Assert.AreEqual(WideString(TestString), WideString(Streamer.ReadWideString), 'Streamer.ReadWideString returned value that isn''t equal to WideString(TestString)!');
  Assert.AreEqual(UnicodeString(TestString), UnicodeString(Streamer.ReadUnicodeString), 'Streamer.ReadUnicodeString returned value that isn''t equal to UnicodeString(TestString)!');
  Assert.AreEqual(String(TestString), String(Streamer.ReadString), 'Streamer.ReadString returned value that isn''t equal to String(TestString)!');

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
  Assert.AreEqual(Integer(Hour), Integer(Hour2), 'Hour value isn''t equal to Hour2 value!');
  Assert.AreEqual(Integer(Minute), Integer(Minute2), 'Minute value isn''t equal to Minute2 value!');
  Assert.AreEqual(Integer(Second), Integer(Second2), 'Second value isn''t equal to Second2 value!');
  //Assert.AreEqual(Integer(MilliSecond), Integer(MilliSecond2), 'MilliSecond value isn''t equal to MilliSecond2 value!');
  Assert.AreEqual(Integer(Year), Integer(Year2), 'Year value isn''t equal to Year2 value!');
  Assert.AreEqual(Integer(Month), Integer(Month2), 'Month value isn''t equal to Month2 value!');
  Assert.AreEqual(Integer(Day), Integer(Day2), 'Day value isn''t equal to Day2 value!');

  { (4) BytesArray. }
  for I := 0 to 7 do
    Assert.AreEqual(UInt8(BytesArray[I]), UInt8(Streamer.ReadUInt8), 'Streamer.ReadUInt8 value isn''t equal to ' + BytesArray[I].ToString + '!');

  { (5) Buffer. }
  { (5.1) Set proper length for dynamic array Arr and fill it with 0. }
  SetLength(Arr, 8);
  FillChar(Arr[0], Length(Arr), 0);

  { (5.2) Read buffer from Streamer. }
  Assert.AreEqual(Cardinal(8), Cardinal(Streamer.ReadBuffer(Pointer(Arr)^, Length(BytesArray))), 'Streamer.ReadBuffer(Pointer(Arr)^, Length(BytesArray)) returned value isn''t equal to 8!');

  { (5.3) Compare each entry with BytesArray. }
  for I := 0 to 7 do
    Assert.AreEqual(BytesArray[I], Arr[I], 'Arr[' + I.ToString + '] value isn''t equal to ' + BytesArray[I].ToString + '!');

  { (5.4) To avoid memory leak, set length of Arr to 0. }
  SetLength(Arr, 0);
end;

{ TBasicClasses_TStreamStreamer_TestCase - class implementation }
procedure TBasicClasses_TStreamStreamer_TestCase.Setup;
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
    Assert.AreEqual(UInt8(200 - I), UInt8(Streamer.ReadUInt8), 'Streamer.ReadUInt8 returned value isn''t equal to ' + UInt8(200 - I).ToString);
end;

procedure TBasicClasses_TStreamStreamer_TestCase.Test_Creation;
begin
  Assert.IsTrue(Assigned(Streamer), 'Streamer isn''t assigned!');
  Assert.AreEqual(Cardinal(0), Cardinal(Streamer.Capacity), 'Streamer.Capacity isn''t equal to 0!');
  Assert.AreEqual(Cardinal(0), Cardinal(Streamer.Count), 'Streamer.Count isn''t equal to 0!');
end;

procedure TBasicClasses_TStreamStreamer_TestCase.Test_WriteAndRead;
const
  TestString: String = 'Test string';
  BytesArray: array of UInt8 = [2, 4, 8, 16, 32, 64, 128, 255];
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
  Assert.AreEqual(Cardinal(1), Cardinal(Streamer.WriteBool(True)), 'Streamer.WriteBool(True) returned value that isn''t equal to 1!');
  Assert.AreEqual(Cardinal(1), Cardinal(Streamer.WriteBoolean(True)), 'Streamer.WriteBoolean(True) returned value that isn''t equal to 1!');

  { (1.2) Int8 and UInt8. }
  Assert.AreEqual(Cardinal(1), Cardinal(Streamer.WriteInt8(127)), 'Streamer.WriteInt8(127) returned value that isn''t equal to 1!');
  Assert.AreEqual(Cardinal(1), Cardinal(Streamer.WriteUInt8(255)), 'Streamer.WriteUInt8(255) returned value that isn''t equal to 1!');

  { (1.3) Int16 and UInt16. }
  Assert.AreEqual(Cardinal(2), Cardinal(Streamer.WriteInt16(32767)), 'Streamer.WriteInt16(32767) returned value that isn''t equal to 2!');
  Assert.AreEqual(Cardinal(2), Cardinal(Streamer.WriteUInt16(65535)), 'Streamer.WriteUInt16(65535) returned value that isn''t equal to 2!');

  { (1.4) Int32 and UInt32. }
  Assert.AreEqual(Cardinal(4), Cardinal(Streamer.WriteInt32(2147483647)), 'Streamer.WriteInt32(2147483647) returned value that isn''t equal to 4!');
  Assert.AreEqual(Cardinal(4), Cardinal(Streamer.WriteUInt32(4294967295)), 'Streamer.WriteUInt32(4294967295) returned value that isn''t equal to 4!');

  { (1.5) Int64 and UInt64. }
  Assert.AreEqual(Cardinal(8), Cardinal(Streamer.WriteInt64(9223372036854775807)), 'Streamer.WriteInt64(9223372036854775807) returned value that isn''t equal to 8!');
  Assert.AreEqual(Cardinal(8), Cardinal(Streamer.WriteUInt64(18446744073709551615)), 'Streamer.WriteUInt64(18446744073709551615) returned value that isn''t equal to 8!');

  { (1.6) Float32, Float64, Float80 and Currency. }
  Assert.AreEqual(Cardinal(4), Cardinal(Streamer.WriteFloat32(Float32(3.14))), 'Streamer.WriteFloat32(Float32(3.14)) returned value that isn''t equal to 4!');
  Assert.AreEqual(Cardinal(8), Cardinal(Streamer.WriteFloat64(Float64(3.14))), 'Streamer.WriteFloat64(Float64(3.14)) returned value that isn''t equal to 8!');
  //Assert.AreEqual(Cardinal(10), Cardinal(Streamer.WriteFloat80(Float80(3.14))), 'Streamer.WriteFloat80(Float80(3.14)) returned value that isn''t equal to 10!');
  Assert.AreEqual(Cardinal(8), Cardinal(Streamer.WriteCurrency(Currency(3.14))), 'Streamer.WriteCurrency(Currency(3.14)) returned value that isn''t equal to 8!');

  { (1.7) AnsiChar, UTF8Char, WideChar and UnicodeChar. }
  Assert.AreEqual(Cardinal(1), Cardinal(Streamer.WriteAnsiChar(#13)), 'Streamer.WriteAnsiChar(#13) returned value that isn''t equal to 1!');
  Assert.AreEqual(Cardinal(1), Cardinal(Streamer.WriteUTF8Char(#13)), 'Streamer.WriteUTF8Char(#13) returned value that isn''t equal to 1!');
  Assert.AreEqual(Cardinal(2), Cardinal(Streamer.WriteWideChar(#13)), 'Streamer.WriteWideChar(#13) returned value that isn''t equal to 2!');
  Assert.AreEqual(Cardinal(2), Cardinal(Streamer.WriteUnicodeChar(#13)), 'Streamer.WriteUnicodeChar(#13) returned value that isn''t equal to 2!');

  { (1.8) ShortString, AnsiString, UTF8String, WideString, UnicodeString and
          String. }
  Assert.AreEqual(Cardinal(12), Cardinal(Streamer.WriteShortString(ShortString(TestString))), 'Streamer.WriteShortString(ShortString(TestString)) returned value that isn''t equal to 12!');
  Assert.AreEqual(Cardinal(15), Cardinal(Streamer.WriteAnsiString(AnsiString(TestString))), 'Streamer.WriteAnsiString(AnsiString(TestString)) returned value that isn''t equal to 15!');
  Assert.AreEqual(Cardinal(15), Cardinal(Streamer.WriteUTF8String(UTF8String(TestString))), 'Streamer.WriteUTF8String(UTF8String(TestString)) returned value that isn''t equal to 15!');
  Assert.AreEqual(Cardinal(26), Cardinal(Streamer.WriteWideString(WideString(TestString))), 'Streamer.WriteWideString(WideString(TestString)) returned value that isn''t equal to 26!');
  Assert.AreEqual(Cardinal(26), Cardinal(Streamer.WriteUnicodeString(UnicodeString(TestString))), 'Streamer.WriteUnicodeString(UnicodeString(TestString)) returned value that isn''t equal to 26!');
  Assert.AreEqual(Cardinal(15), Cardinal(Streamer.WriteString(TestString)), 'Streamer.WriteString(TestString) returned value that isn''t equal to 15!');

  { (1.9) TDateTime. }
  DT := Now;
  Assert.AreEqual(Cardinal(8), Cardinal(Streamer.WriteDateTime(DT)), 'Streamer.WriteDateTime(DT) returned value that isn''t equal to 8!');

  { (1.10) BytesArray. }
  Assert.AreEqual(Cardinal(8), Cardinal(Streamer.WriteBytes(BytesArray)), 'Streamer.WriteBytes(BytesArray) returned value that isn''t equal to 8!');

  { (1.11) Buffer. }
  Assert.AreEqual(Cardinal(8), Cardinal(Streamer.WriteBuffer(Pointer(BytesArray)^, Length(BytesArray))), 'Streamer.WriteBuffer(Pointer(BytesArray)^, Length(BytesArray)) returned value that isn''t equal to 8!');

  { (2) Move Streamer cursor to start position. }
  Streamer.MoveToStart;

  { (3) Read all types from our streamer. Check sizes of actual reads that are
        valid. }
  { (3.1) ByteBool and Boolean. }
  Assert.AreEqual(ByteBool(True), ByteBool(Streamer.ReadBool), 'Streamer.ReadBool returned value that isn''t equal to ByteBool(True)!');
  Assert.AreEqual(Cardinal(1), Cardinal(Streamer.ReadBoolean(BooleanVal)), 'Streamer.ReadBoolean returned value that isn''t equal to 1!');
  Assert.IsTrue(BooleanVal, 'BooleanVal isn''t True!');

  { (3.2) Int8 and UInt8. }
  Assert.AreEqual(Cardinal(127), Cardinal(Streamer.ReadInt8), 'Streamer.ReadInt8 returned value that isn''t equal to 127!');
  Assert.AreEqual(Cardinal(255), Cardinal(Streamer.ReadUInt8), 'Streamer.ReadUInt8 returned value that isn''t equal to 255!');

  { (3.3) Int16 and UInt16. }
  Assert.AreEqual(Cardinal(32767), Cardinal(Streamer.ReadInt16), 'Streamer.ReadInt16 returned value that isn''t equal to 32767!');
  Assert.AreEqual(Cardinal(65535), Cardinal(Streamer.ReadUInt16), 'Streamer.ReadUInt16 returned value that isn''t equal to 65535!');

  { (3.4) Int32 and UInt32. }
  Assert.AreEqual(Cardinal(2147483647), Cardinal(Streamer.ReadInt32), 'Streamer.ReadInt32 returned value that isn''t equal to 2147483647!');
  Assert.AreEqual(Cardinal(4294967295), Cardinal(Streamer.ReadUInt32), 'Streamer.ReadUInt32 returned value that isn''t equal to 4294967295!');

  { (3.5) Int64 and UInt64. }
  Assert.AreEqual(Int64(9223372036854775807), Int64(Streamer.ReadInt64), 'Streamer.ReadInt64 returned value that isn''t eqaul to 9223372036854775807!');
  Assert.AreEqual(UInt64(18446744073709551615), UInt64(Streamer.ReadUInt64), 'Streamer.ReadUInt64 returned value that isn''t equal to 18446744073709551615!');

  { (3.6) Float32, Float64, Float80 and Currency. }
  Assert.AreEqual(Float32(3.14), Float32(Streamer.ReadFloat32), 0.001, 'Streamer.ReadFloat32 returned value that isn''t equal to 3.14!');
  Assert.AreEqual(Float64(3.14), Float64(Streamer.ReadFloat64), 0.001, 'Streamer.ReadFloat64 returned value that isn''t equal to 3.14!');
  //Assert.AreEqual(Float80(3.14), Float80(Streamer.ReadFloat80), 0.001, 'Streamer.ReadFloat80 returned value that isn''t equal to 3.14!');
  Assert.AreEqual(Currency(3.14), Currency(Streamer.ReadCurrency), 0.001, 'Streamer.ReadCurrency returned value that isn''t equal to 3.14!');

  { (3.7) AnsiChar, UTF8Char, WideChar and UnicodeChar. }
  Assert.AreEqual(AnsiChar(#13), AnsiChar(Streamer.ReadAnsiChar), 'Streamer.ReadAnsiChar returned value that isn''t equal to AnsiChar(#13)');
  Assert.AreEqual(UTF8Char(#13), UTF8Char(Streamer.ReadUTF8Char), 'Streamer.ReadUTF8Char returned value that isn''t equal to UTF8Char(#13)');
  Assert.AreEqual(WideChar(#13), WideChar(Streamer.ReadWideChar), 'Streamer.ReadWideChar returned value that isn''t equal to WideChar(#13)');
  Assert.AreEqual(UnicodeChar(#13), UnicodeChar(Streamer.ReadUnicodeChar), 'Streamer.ReadUnicodeChar returned value that isn''t equal to UnicodeChar(#13)');

  { (3.8) ShortString, AnsiString, UTF8String, WideString, UnicodeString and
          String. }
  Assert.AreEqual(String(TestString), String(Streamer.ReadShortString), 'Streamer.ReadShortString returned value that isn''t equal to ShortString(TestString)!');
  Assert.AreEqual(AnsiString(TestString), AnsiString(Streamer.ReadAnsiString), 'Streamer.ReadAnsiString returned value that isn''t equal to AnsiString(TestString)!');
  Assert.AreEqual(UTF8String(TestString), UTF8String(Streamer.ReadUTF8String), 'Streamer.ReadUTF8String returned value that isn''t equal to UTF8String(TestString)!');
  Assert.AreEqual(WideString(TestString), WideString(Streamer.ReadWideString), 'Streamer.ReadWideString returned value that isn''t equal to WideString(TestString)!');
  Assert.AreEqual(UnicodeString(TestString), UnicodeString(Streamer.ReadUnicodeString), 'Streamer.ReadUnicodeString returned value that isn''t equal to UnicodeString(TestString)!');
  Assert.AreEqual(String(TestString), String(Streamer.ReadString), 'Streamer.ReadString returned value that isn''t equal to String(TestString)!');

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
  Assert.AreEqual(Integer(Hour), Integer(Hour2), 'Hour value isn''t equal to Hour2 value!');
  Assert.AreEqual(Integer(Minute), Integer(Minute2), 'Minute value isn''t equal to Minute2 value!');
  Assert.AreEqual(Integer(Second), Integer(Second2), 'Second value isn''t equal to Second2 value!');
  //Assert.AreEqual(Integer(MilliSecond), Integer(MilliSecond2), 'MilliSecond value isn''t equal to MilliSecond2 value!');
  Assert.AreEqual(Integer(Year), Integer(Year2), 'Year value isn''t equal to Year2 value!');
  Assert.AreEqual(Integer(Month), Integer(Month2), 'Month value isn''t equal to Month2 value!');
  Assert.AreEqual(Integer(Day), Integer(Day2), 'Day value isn''t equal to Day2 value!');

  { (4) BytesArray. }
  for I := 0 to 7 do
    Assert.AreEqual(UInt8(BytesArray[I]), UInt8(Streamer.ReadUInt8), 'Streamer.ReadUInt8 value isn''t equal to ' + BytesArray[I].ToString + '!');

  { (5) Buffer. }
  { (5.1) Set proper length for dynamic array Arr and fill it with 0. }
  SetLength(Arr, 8);
  FillChar(Arr[0], Length(Arr), 0);

  { (5.2) Read buffer from Streamer. }
  Assert.AreEqual(Cardinal(8), Cardinal(Streamer.ReadBuffer(Pointer(Arr)^, Length(BytesArray))), 'Streamer.ReadBuffer(Pointer(Arr)^, Length(BytesArray)) returned value isn''t equal to 8!');

  { (5.3) Compare each entry with BytesArray. }
  for I := 0 to 7 do
    Assert.AreEqual(BytesArray[I], Arr[I], 'Arr[' + I.ToString + '] value isn''t equal to ' + BytesArray[I].ToString + '!');

  { (5.4) To avoid memory leak, set length of Arr to 0. }
  SetLength(Arr, 0);
end;

initialization
  TDUnitX.RegisterTestFixture(TBasicClasses_TCustomStreamer_TestCase, 'TCustomStreamer Test');
  TDUnitX.RegisterTestFixture(TBasicClasses_TMemoryStreamer_TestCase, 'TMemoryStreamer Test');
  TDUnitX.RegisterTestFixture(TBasicClasses_TStreamStreamer_TestCase, 'TStreamStreamer Test');

end.
