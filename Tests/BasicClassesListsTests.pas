unit BasicClassesListsTests;

interface

uses
  System.Types,
  System.Classes,
  DUnitX.TestFramework,
  TypeDefinitions,
  BasicClasses.Lists;

type
  TMyBCList = class(TBCList)
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  end;

  [TestFixture]
  TBasicClasses_TBCList_Test = class
  private
    List: TMyBCList;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    { Test methods }
    [TestCase('TBCList creation', '')]
    procedure Test_Creation;
    [TestCase('TBCList adding 100 items', '')]
    procedure Test_AddItems;
    [TestCase('TBCList remove 100 items', '')]
    procedure Test_RemoveItems;
    [TestCase('TBCList exchange', '')]
    procedure Test_Exchange;
    [TestCase('TBCList extract', '')]
    procedure Test_Extract;
    [TestCase('TBCList first and last', '')]
    procedure Test_FirstAndLast;
    [TestCase('TBCList IndexOf', '')]
    procedure Test_IndexOf;
    [TestCase('TBCList Insert', '')]
    procedure Test_Insert;
    [TestCase('TBCList Move', '')]
    procedure Test_Move;
    [TestCase('TBCList Sort', '')]
    procedure Test_Sort;
    [TestCase('TBCList TEnumerator & TReverseEnumerator', '')]
    procedure Test_Enumerator;
  end;

  [TestFixture]
  TBasicClasses_TIntegerList_Test = class
  private
    List: TIntegerList;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    { Test methods }
    [TestCase('TIntegerList creation', '')]
    procedure Test_Creation;
    [TestCase('TIntegerList adding 100 items', '')]
    procedure Test_AddItems;
    [TestCase('TIntegerList remove 100 items', '')]
    procedure Test_RemoveItems;
    [TestCase('TIntegerList exchange', '')]
    procedure Test_Exchange;
    [TestCase('TIntegerList extract', '')]
    procedure Test_Extract;
    [TestCase('TIntegerList first and last', '')]
    procedure Test_FirstAndLast;
    [TestCase('TIntegerList IndexOf', '')]
    procedure Test_IndexOf;
    [TestCase('TIntegerList Insert', '')]
    procedure Test_Insert;
    [TestCase('TIntegerList Move', '')]
    procedure Test_Move;
    [TestCase('TIntegerList Sort', '')]
    procedure Test_Sort;
    [TestCase('TIntegerList TEnumerator & TReverseEnumerator', '')]
    procedure Test_Enumerator;
  end;

implementation

uses
  System.SysUtils;

{ TMyBCList }

procedure TMyBCList.Notify(Ptr: Pointer; Action: TListNotification);
begin
  if (Action = lnDeleted) then
    Dispose(Ptr);
end;

{ TBasicClasses_List_TestObject }

procedure TBasicClasses_TBCList_Test.Setup;
begin
  List := TMyBCList.Create;
end;

procedure TBasicClasses_TBCList_Test.TearDown;
begin
  List.Clear;

  List.Free;
  List := nil;
end;

procedure TBasicClasses_TBCList_Test.Test_AddItems;
var
  pItem: PInteger;
  I, Idx: SizeUInt;
begin
  List.GrowMode := gmFast;

  for I := 1 to 100 do
  begin
    New(pItem);
    pItem^ := I;
    Idx := List.Add(pItem);
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(@Item) return invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(PInteger(List[Idx])^), 'List[Idx] item isn''t equal to ' + I.ToString + '!');

    if (I = 32) then
      Assert.AreEqual(32, Cardinal(List.Capacity), 'List.Capacity isn''t equal to 32!');
    if (I = 33) then
      Assert.AreEqual(64, Cardinal(List.Capacity), 'List.Capacity isn''t equal to 64!');
    if (I = 64) then
      Assert.AreEqual(64, Cardinal(List.Capacity), 'List.Capacity isn''t equal to 64!');
    if (I = 65) then
      Assert.AreEqual(128, Cardinal(List.Capacity), 'List.Capacity isn''t equal to 128!');
  end;

  List.Clear;
  List.GrowMode := gmSlow;

  for I := 1 to 100 do
  begin
    New(pItem);
    pItem^ := I;
    Idx := List.Add(pItem);
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(@Item) return invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(PInteger(List[Idx])^), 'List[Idx] item isn''t equal to ' + I.ToString + '!');

    if (I > 32) then
      Assert.AreEqual(Cardinal(I), Cardinal(List.Capacity), 'List.Capacity isn''t equal to ' + I.ToString + '!')
    else
      Assert.AreEqual(32, Cardinal(List.Capacity), 'List.Capacity isn''t equal to 32!');
  end;

  List.Clear;
  List.GrowMode := gmLinear;
  List.GrowFactor := 2.0;

  for I := 1 to 100 do
  begin
    New(pItem);
    pItem^ := I;
    Idx := List.Add(pItem);
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(@Item) return invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(PInteger(List[Idx])^), 'List[Idx] item isn''t equal to ' + I.ToString + '!');

    if (I = 64) then
      Assert.AreEqual(Cardinal(64), Cardinal(List.Capacity), 'List.Capacity isn''t equal to 64!');
    if (I = 65) then
      Assert.AreEqual(Cardinal(66), Cardinal(List.Capacity), 'List.Capacity isn''t equal to 66!');
    if (I = 86) then
      Assert.AreEqual(Cardinal(86), Cardinal(List.Capacity), 'List.Capacity isn''t equal to 86!');
    if (I = 87) then
      Assert.AreEqual(Cardinal(88), Cardinal(List.Capacity), 'List.Capacity isn''t equal to 88!');
  end;

  List.Clear;
  List.GrowMode := gmFastAttenuated;
  List.GrowLimit := 64;

  for I := 1 to 100 do
  begin
    New(pItem);
    pItem^ := I;
    Idx := List.Add(pItem);
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(@Item) return invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(PInteger(List[Idx])^), 'List[Idx] item isn''t equal to ' + I.ToString + '!');

    if (I = 64) then
      Assert.AreEqual(Cardinal(64), Cardinal(List.Capacity), 'List.Capacity isn''t equal to 64!');
    if (I = 65) then
      Assert.AreEqual(Cardinal(68), Cardinal(List.Capacity), 'List.Capacity isn''t equal to 68!');
    if (I = 71) then
      Assert.AreEqual(Cardinal(72), Cardinal(List.Capacity), 'List.Capacity isn''t equal to 72!');
    if (I = 85) then
      Assert.AreEqual(Cardinal(88), Cardinal(List.Capacity), 'List.Capacity isn''t equal to 88!');
  end;
end;

procedure TBasicClasses_TBCList_Test.Test_Creation;
begin
  Assert.AreEqual(Cardinal(0), Cardinal(List.Capacity), 'List.Capacity isn''t 0!');
  Assert.AreEqual(Cardinal(0), Cardinal(List.Count), 'List.Count isn''t 0!');
end;

procedure TBasicClasses_TBCList_Test.Test_Exchange;
var
  pItem: PInteger;
  I: SizeUInt;
begin
  { Prepare our list by adding 100 items. }
  for I := 1 to 100 do
  begin
    New(pItem);
    pItem^ := I;
    List.Add(pItem);
  end;

  { Exchange 2 items and validate. }
  List.Exchange(0, 99);
  Assert.AreEqual(Integer(100), PInteger(List[0])^, 'PInteger(List[0])^ isn''t equal to 100!');
  Assert.AreEqual(Integer(1), PInteger(List[99])^, 'PInteger(List[99])^ isn''t equal to 1!');
end;

procedure TBasicClasses_TBCList_Test.Test_Extract;
var
  pItem: PInteger;
  I: SizeUInt;
begin
  { Prepare our list by adding 100 items. }
  for I := 1 to 100 do
  begin
    New(pItem);
    pItem^ := I;
    List.Add(pItem);
  end;

  { Retrieve item from position (index) 49. }
  pItem := List[49];

  { Extract item from the list. }
  pItem := List.Extract(pItem);

  { If extracted item isn't equal to nil, verify that item was deleted from the
    list. }
  Assert.AreNotEqual<Pointer>(nil, pItem, 'List.Extract(pItem) returned nil!');
  if (pItem <> nil) then
  begin
    Assert.AreEqual(Cardinal(99), Cardinal(List.Count), 'List.Count isn''t equal to 99!');
    Assert.AreNotEqual(Integer(50), PInteger(List[49])^, 'PInteger(List[49])^ is equal to 50!');
  end;

  { Retrieve item from position (index) 24. }
  pItem := List[24];

  { Extract item from the list. }
  pItem := List.ExtractItem(pItem, FromEnd);

  { If extracted item isn't equal to nil, verify that item was deleted from the
    list. }
  Assert.AreNotEqual<Pointer>(nil, pItem, 'List.ExtractItem(pItem, FromEnd) returned nil!');
  if (pItem <> nil) then
  begin
    Assert.AreEqual(Cardinal(98), Cardinal(List.Count), 'List.Count isn''t equal to 98!');
    Assert.AreNotEqual(Integer(25), PInteger(List[24])^, 'PInteger(List[24])^ is equal to 25!');
  end;
end;

procedure TBasicClasses_TBCList_Test.Test_FirstAndLast;
var
  pItem: PInteger;
  I: SizeUInt;
begin
  { Prepare our list by adding 200 items. }
  for I := 1 to 100 do
  begin
    New(pItem);
    pItem^ := I;
    List.Add(pItem);
  end;

  Assert.AreEqual(Integer(1), PInteger(List.First)^, 'List.First isn''t equal to 1!');
  Assert.AreEqual(Integer(100), PInteger(List.Last)^, 'List.Last isn''t equal to 100!');
  Assert.AreEqual(Cardinal(0), Cardinal(List.LowIndex), 'List.LowIndex isn''t equal to 0!');
  Assert.AreEqual(Cardinal(99), Cardinal(List.HighIndex), 'List.HighIndex isn''t equal to 99!');
end;

procedure TBasicClasses_TBCList_Test.Test_IndexOf;
var
  pItem: PInteger;
  I: SizeUInt;
begin
  { Prepare our list by adding 200 items. }
  for I := 1 to 100 do
  begin
    New(pItem);
    pItem^ := I;
    List.Add(pItem);
  end;

  pItem := List[36];
  Assert.IsNotNull(pItem, 'List[36] is nil!');
  if (pItem <> nil) then
  begin
    Assert.AreEqual(Cardinal(36), Cardinal(List.IndexOf(pItem)), 'List.IndexOf(pItem) didn''t return 36!');
    Assert.AreEqual(Cardinal(36), Cardinal(List.IndexOfItem(pItem, FromEnd)), 'List.IndexOfItem(pItem, FromEnd) didn''t return 36!');
  end;
end;

procedure TBasicClasses_TBCList_Test.Test_Insert;
var
  pItem: PInteger;
  I, Idx: SizeUInt;
begin
  { Prepare our list by adding 100 items. }
  for I := 1 to 100 do
  begin
    New(pItem);
    pItem^ := I;
    Idx := List.Add(pItem);
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(@Item) return invalid value!');
    Assert.AreEqual(Cardinal(I), PCardinal(List[Idx])^, 'List[Idx] item value is invalid!');
  end;

  { Prepare our list by inserting 100 items to position (index) 50. }
  for I := 1 to 100 do
  begin
    New(pItem);
    pItem^ := I;
    List.Insert(50, pItem);
  end;

  Assert.AreEqual(Cardinal(200), Cardinal(List.Count), 'List.Count isn''t equal to 200!');
  Assert.AreEqual(Integer(50), PInteger(List[49])^, 'PInteger(List[49])^ isn''t equal to 50!');
  Assert.AreEqual(Integer(100), PInteger(List[50])^, 'PInteger(List[50])^ isn''t equal to 100!');
end;

procedure TBasicClasses_TBCList_Test.Test_Move;
var
  pItem: PInteger;
  I, Idx: SizeUInt;
begin
  { Prepare our list by adding 100 items. }
  for I := 1 to 100 do
  begin
    New(pItem);
    pItem^ := I;
    Idx := List.Add(pItem);
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(@Item) return invalid value!');
    Assert.AreEqual(Cardinal(I), PCardinal(List[Idx])^, 'List[Idx] item value is invalid!');
  end;

  { Move item from position (index) 10 to 90. }
  List.Move(10, 90);
  Assert.AreNotEqual(Integer(11), PInteger(List[10])^, 'List[10] is equal to 11!');
  Assert.AreEqual(Integer(11), PInteger(List[90])^, 'List[90] isn''t equal to 11!');
end;

procedure TBasicClasses_TBCList_Test.Test_RemoveItems;
var
  pItem: PInteger;
  I, Idx: SizeUInt;
begin
  { Prepare our list by adding 200 items. }
  for I := 1 to 200 do
  begin
    New(pItem);
    pItem^ := I;
    Idx := List.Add(pItem);
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(@Item) return invalid value!');
    Assert.AreEqual(Cardinal(I), PCardinal(List[Idx])^, 'List[Idx] item value is invalid!');
  end;

  { Check removal with ShrinkMode set to smNormal. }
  List.ShrinkMode := smNormal;
  List.ShrinkLimit := 100;

  for I := 1 to 180 do
  begin
    List.Delete(0);

    if (200 - I = 64) then
      Assert.AreEqual(Cardinal(256), Cardinal(List.Capacity), 'List.Capacity isn''t equal 256!');
    if (200 - I = 63) then
      Assert.AreEqual(Cardinal(128), Cardinal(List.Capacity), 'List.Capacity isn''t equal 128!');
    if (200 - I = 32) then
      Assert.AreEqual(Cardinal(128), Cardinal(List.Capacity), 'List.Capacity isn''t equal 128!');
    if (200 - I = 31) then
      Assert.AreEqual(Cardinal(64), Cardinal(List.Capacity), 'List.Capacity isn''t equal 64!');
  end;

  Assert.AreEqual(Cardinal(64), Cardinal(Length(List.List)), 'Length(List.List) isn''t equal to 64!');
  List.Clear;
  Assert.AreEqual(Cardinal(0), Cardinal(Length(List.List)), 'Length(List.List) isn''t equal to 0!');

  { Prepare our list by adding 200 items. }
  for I := 1 to 200 do
  begin
    New(pItem);
    pItem^ := I;
    Idx := List.Add(pItem);
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(@Item) return invalid value!');
    Assert.AreEqual(Cardinal(I), PCardinal(List[Idx])^, 'List[Idx] item value is invalid!');
  end;

  { Check removal with ShrinkMode set to smToCount. }
  List.ShrinkMode := smToCount;

  for I := 1 to 200 do
  begin
    List.Delete(0);
    Assert.AreEqual(Cardinal(200 - I), Cardinal(List.Capacity), 'List.Capacity isn''t equal to ' + IntToStr(200 - I) + '!');
  end;

  List.Clear;

  { Prepare our list by adding 200 items. }
  for I := 1 to 200 do
  begin
    New(pItem);
    pItem^ := I;
    Idx := List.Add(pItem);
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(@Item) return invalid value!');
  end;

  { Check removal with ShrinkMode set to smToCount. }
  List.ShrinkMode := smKeepCap;

  for I := 1 to 200 do
  begin
    List.Delete(0);
    Assert.AreEqual(Cardinal(256), Cardinal(List.Capacity), 'List.Capacity isn''t equal to 256!');
  end;

  List.Clear;

  { Prepare our list by adding 200 items. }
  for I := 1 to 200 do
  begin
    New(pItem);
    pItem^ := I;
    Idx := List.Add(pItem);
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(@Item) return invalid value!');
  end;

  { Check removal by Remove() method. }
  for I := 1 to 10 do
  begin
    pItem := List[123];
    Assert.AreEqual(Cardinal(123), Cardinal(List.Remove(pItem)), 'List.Remove(pItem) returned value not equal to 123!');
  end;
end;

function Pointer_CompareFunc(Item1, Item2: Pointer): Integer;
begin
  Result := PInteger(Item1)^ - PInteger(Item2)^;
end;

procedure TBasicClasses_TBCList_Test.Test_Sort;
var
  pItem: PInteger;
  Idx: SizeUInt;
begin
  { Fill our list with random values. }
  for Idx := 0 to 200 do
  begin
    New(pItem);
    pItem^ := Random(200);
    List.Add(pItem);
  end;

  { Sort list. }
  List.Sort(Pointer_CompareFunc);

  { Make sure that items were sorted. }
  for Idx := List.LowIndex to (List.HighIndex - 1) do
    Assert.IsTrue(PInteger(List[Idx])^ <= PInteger(List[Idx + 1])^, 'PInteger(List[' + Idx.ToString + '])^ <= PInteger(List[' + SizeUInt(Idx + 1).ToString + '] condition failed!');
end;

procedure TBasicClasses_TBCList_Test.Test_Enumerator;
var
  pItem: PInteger;
  Idx: Integer;
  It: TBCList.TEnumerator;
  RevIt: TBCList.TReverseEnumerator;
begin
  { Prepare our list by adding 200 items. }
  for Idx := 1 to 100 do
  begin
    New(pItem);
    pItem^ := Idx;
    List.Add(pItem);
  end;

  { Create enumerator and test it. }
  It := List.GetEnumerator;
  Idx := 1;

  while It.MoveNext do
  begin
    Assert.AreEqual(Idx, PInteger(It.Current)^, 'PInteger(It.Current)^ isn''t equal to Idx which is equal to ' + Idx.ToString + '!');
    Inc(Idx);
  end;

  It.Free;

  { Create reverse enumerator and test it. }
  RevIt := List.GetReverseEnumerator;
  Idx := 100;

  while RevIt.MoveNext do
  begin
    Assert.AreEqual(Idx, PInteger(RevIt.Current)^, 'PInteger(RevIt.Current)^ isn''t equal to Idx which is equal to ' + Idx.ToString + '!');
    Dec(Idx);
  end;

  RevIt.Free;
end;

{ TBasicClasses_TIntegerList_Test }

procedure TBasicClasses_TIntegerList_Test.Setup;
begin
  List := TIntegerList.Create;
end;

procedure TBasicClasses_TIntegerList_Test.TearDown;
begin
  List.Clear;

  List.Free;
  List := nil;
end;

procedure TBasicClasses_TIntegerList_Test.Test_AddItems;
begin

end;

procedure TBasicClasses_TIntegerList_Test.Test_Creation;
begin
  Assert.AreEqual(Cardinal(0), Cardinal(List.Capacity), 'List.Capacity isn''t 0!');
  Assert.AreEqual(Cardinal(0), Cardinal(List.Count), 'List.Count isn''t 0!');
end;

procedure TBasicClasses_TIntegerList_Test.Test_Enumerator;
begin

end;

procedure TBasicClasses_TIntegerList_Test.Test_Exchange;
begin

end;

procedure TBasicClasses_TIntegerList_Test.Test_Extract;
begin

end;

procedure TBasicClasses_TIntegerList_Test.Test_FirstAndLast;
begin

end;

procedure TBasicClasses_TIntegerList_Test.Test_IndexOf;
begin

end;

procedure TBasicClasses_TIntegerList_Test.Test_Insert;
begin

end;

procedure TBasicClasses_TIntegerList_Test.Test_Move;
begin

end;

procedure TBasicClasses_TIntegerList_Test.Test_RemoveItems;
begin

end;

procedure TBasicClasses_TIntegerList_Test.Test_Sort;
begin

end;

initialization
  TDUnitX.RegisterTestFixture(TBasicClasses_TBCList_Test, 'TBCList Test');
  TDUnitX.RegisterTestFixture(TBasicClasses_TIntegerList_Test, 'TIntegerList Test');

end.
