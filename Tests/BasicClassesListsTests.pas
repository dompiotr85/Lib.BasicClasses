unit BasicClassesListsTests;

interface

uses
  System.Types,
  System.Classes,
  DUnitX.TestFramework,
  TypeDefinitions,
  BasicClasses.Lists;

type
  { TMyBCList - class declaration }
  TMyBCList = class(TBCList)
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  end;

  { TBasicClasses_TBCList_Test - class declaration }
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
    [TestCase('TBCList Assign', '')]
    procedure Test_Assign;
  end;

  { TBasicClasses_TIntegerList_Test - class declaration }
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
    [TestCase('TIntegerList Assign', '')]
    procedure Test_Assign;
    [TestCase('TIntegerList CopyFrom', '')]
    procedure Test_CopyFrom;
    [TestCase('TIntegerList RemoveDuplicates', '')]
    procedure Test_RemoveDuplicates;
    [TestCase('TIntegerList ChainToString', '')]
    procedure Test_ChainToString;
    [TestCase('TIntegerList SameAs', '')]
    procedure Test_SameAs;
    [TestCase('TIntegerList Values', '')]
    procedure Test_Values;
    [TestCase('TIntegerList Exists', '')]
    procedure Test_Exists;
  end;

  { TBasicClasses_TIntegerProbabilityList_Test - class declaration }
  [TestFixture]
  TBasicClasses_TIntegerProbabilityList_Test = class
  private
    List: TIntegerProbabilityList;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    { Test methods }
    [TestCase('TIntegerProbabilityList creation', '')]
    procedure Test_Creation;
    [TestCase('TIntegerProbabilityList adding 100 items', '')]
    procedure Test_AddItems;
    [TestCase('TIntegerProbabilityList remove 100 items', '')]
    procedure Test_RemoveItems;
    [TestCase('TIntegerProbabilityList exchange', '')]
    procedure Test_Exchange;
    [TestCase('TIntegerProbabilityList extract', '')]
    procedure Test_Extract;
    [TestCase('TIntegerProbabilityList first and last', '')]
    procedure Test_FirstAndLast;
    [TestCase('TIntegerProbabilityList IndexOf', '')]
    procedure Test_IndexOf;
    [TestCase('TIntegerProbabilityList Insert', '')]
    procedure Test_Insert;
    [TestCase('TIntegerProbabilityList Move', '')]
    procedure Test_Move;
    [TestCase('TIntegerProbabilityList Sort', '')]
    procedure Test_Sort;
    [TestCase('TIntegerProbabilityList TEnumerator & TReverseEnumerator', '')]
    procedure Test_Enumerator;
    [TestCase('TIntegerProbabilityList Assign', '')]
    procedure Test_Assign;
    [TestCase('TIntegerProbabilityList CopyFrom', '')]
    procedure Test_CopyFrom;
    [TestCase('TIntegerProbabilityList RemoveDuplicates', '')]
    procedure Test_RemoveDuplicates;
    [TestCase('TIntegerProbabilityList SameAs', '')]
    procedure Test_SameAs;
    [TestCase('TIntegerProbabilityList Exists', '')]
    procedure Test_Exists;
  end;

implementation

uses
  System.SysUtils;

{ TMyBCList - class implementation }

procedure TMyBCList.Notify(Ptr: Pointer; Action: TListNotification);
begin
  if (Action = lnDeleted) then
    Dispose(Ptr);
end;

{ TBasicClasses_TBCList_Test - class implementation }

procedure TBasicClasses_TBCList_Test.Setup;
begin
  { Create List. }
  List := TMyBCList.Create;
end;

procedure TBasicClasses_TBCList_Test.TearDown;
begin
  { (1) Clear List. }
  List.Clear;

  { (2) Free List. }
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
    PInteger(pItem)^ := Integer(I);
    Idx := List.Add(pItem);
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(@Item) returned invalid value!');
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
    PInteger(pItem)^ := Integer(I);
    Idx := List.Add(pItem);
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(@Item) returned invalid value!');
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
    PInteger(pItem)^ := Integer(I);
    Idx := List.Add(pItem);
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(@Item) returned invalid value!');
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
    PInteger(pItem)^ := Integer(I);
    Idx := List.Add(pItem);
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(@Item) returned invalid value!');
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

procedure TBasicClasses_TBCList_Test.Test_Assign;
var
  NewList: TBCList;
  Idx: SizeUInt;
  pItem: PInteger;
begin
  { (1) Add 6 items to List. }
  for Idx := 1 to 6 do
  begin
    New(pItem);
    PInteger(pItem)^ := Integer(Idx);
    List.Add(pItem);
  end;

  { (2) Create and assign List to NewList. }
  NewList := TBCList.Create;

  NewList.Assign(List);

  { (3) Compare both list. They should be equal. }
  if (NewList.Count > 0) then
    for Idx := NewList.LowIndex to NewList.HighIndex do
      Assert.AreEqual(PInteger(List[Idx])^, PInteger(NewList[Idx])^, 'List[Idx] isn''t equal to NewList[Idx]!');

  { (4) Release lists. }
  NewList.Free;
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
    PInteger(pItem)^ := Integer(I);
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
    PInteger(pItem)^ := Integer(I);
    List.Add(pItem);
  end;

  { Retrieve item from position (index) 49. }
  pItem := List[49];

  { Extract item from the list. }
  pItem := List.Extract(pItem);

  { If extracted item isn't equal to nil, verify that item was deleted from the
    list. }
  Assert.AreNotEqual<PInteger>(nil, pItem, 'List.Extract(pItem) returned nil!');
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
  Assert.AreNotEqual<PInteger>(nil, pItem, 'List.ExtractItem(pItem, FromEnd) returned nil!');
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
  { Prepare our list by adding 100 items. }
  for I := 1 to 100 do
  begin
    New(pItem);
    PInteger(pItem)^ := Integer(I);
    List.Add(pItem);
  end;

  Assert.AreEqual(Integer(1), PInteger(List.First)^, 'List.First^ isn''t equal to 1!');
  Assert.AreEqual(Integer(100), PInteger(List.Last)^, 'List.Last^ isn''t equal to 100!');
  Assert.AreEqual(Cardinal(0), Cardinal(List.LowIndex), 'List.LowIndex isn''t equal to 0!');
  Assert.AreEqual(Cardinal(99), Cardinal(List.HighIndex), 'List.HighIndex isn''t equal to 99!');

  List.Delete(List.HighIndex);

  Assert.AreEqual(Integer(99), PInteger(List.Last)^, 'List.Last^ isn''t equal to 99!');
end;

procedure TBasicClasses_TBCList_Test.Test_IndexOf;
var
  pItem: PInteger;
  I: SizeUInt;
begin
  { Prepare our list by adding 100 items. }
  for I := 1 to 100 do
  begin
    New(pItem);
    PInteger(pItem)^ := Integer(I);
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
    PInteger(pItem)^ := Integer(I);
    Idx := List.Add(pItem);
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(@Item) returned invalid value!');
    Assert.AreEqual(Cardinal(I), PCardinal(List[Idx])^, 'List[Idx] item value is invalid!');
  end;

  { Prepare our list by inserting 100 items to position (index) 50. }
  for I := 1 to 100 do
  begin
    New(pItem);
    PInteger(pItem)^ := Integer(I);
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
    PInteger(pItem)^ := Integer(I);
    Idx := List.Add(pItem);
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(@Item) returned invalid value!');
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
    PInteger(pItem)^ := Integer(I);
    Idx := List.Add(pItem);
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(@Item) returned invalid value!');
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
    PInteger(pItem)^ := Integer(I);
    Idx := List.Add(pItem);
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(@Item) returned invalid value!');
    Assert.AreEqual(Cardinal(I), PCardinal(List[Idx])^, 'List[Idx] item value is invalid!');
  end;

  { Check removal with ShrinkMode set to smToCount. }
  List.ShrinkMode := smToCount;

  for I := 1 to 200 do
  begin
    if (List.Count > 0) then
      List.Delete(0);

    Assert.AreEqual(Cardinal(200 - I), Cardinal(List.Capacity), 'List.Capacity isn''t equal to ' + IntToStr(200 - I) + '!');
  end;

  List.Clear;

  { Prepare our list by adding 200 items. }
  for I := 1 to 200 do
  begin
    New(pItem);
    PInteger(pItem)^ := Integer(I);
    Idx := List.Add(pItem);
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(@Item) return invalid value!');
  end;

  { Check removal with ShrinkMode set to smKeepCap. }
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
    PInteger(pItem)^ := Integer(I);
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
    PInteger(pItem)^ := Integer(Random(200));
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
    PInteger(pItem)^ := Idx;
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
  { (1) Create List. }
  List := TIntegerList.Create;

  { (2) Set NeedRelease flag to True. }
  List.NeedRelease := True;
end;

procedure TBasicClasses_TIntegerList_Test.TearDown;
begin
  { (1) Clear List. }
  List.Clear;

  { (2) Free List. }
  List.Free;
  List := nil;
end;

procedure TBasicClasses_TIntegerList_Test.Test_AddItems;
var
  I, Idx: SizeUInt;
begin
  List.GrowMode := gmFast;

  for I := 1 to 100 do
  begin
    Idx := List.Add(TIntItem(I));
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(TIntItem(I)) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx]), 'List[Idx] item isn''t equal to ' + I.ToString + '!');

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
    Idx := List.Add(TIntItem(I));
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(TIntItem(I)) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx]), 'List[Idx] item isn''t equal to ' + I.ToString + '!');

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
    Idx := List.Add(TIntItem(I));
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(TIntItem(I)) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx]), 'List[Idx] item isn''t equal to ' + I.ToString + '!');

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
    Idx := List.Add(TIntItem(I));
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(TIntItem(I)) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx]), 'List[Idx] item isn''t equal to ' + I.ToString + '!');

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

procedure TBasicClasses_TIntegerList_Test.Test_Assign;
var
  NewList: TIntegerList;
  Idx: SizeUInt;
  Item: TIntItem;
begin
  { (1) Add 6 items to List. }
  for Idx := 1 to 6 do
  begin
    Item := TIntItem(Idx);
    List.Add(Item);
  end;

  { (2) Shuffle list. }
  List.BestShuffle;

  { (3) Create and assign List to NewList. Mark that NewList shouldn't release items. }
  NewList := TIntegerList.Create;
  NewList.NeedRelease := False;

  NewList.Assign(List);

  { (4) Compare both list. They should be equal. }
  if (NewList.Count > 0) then
    for Idx := NewList.LowIndex to NewList.HighIndex do
      Assert.AreEqual(List[Idx], NewList[Idx], 'List[Idx] isn''t equal to NewList[Idx]!');

  { (5) Release NewList. }
  NewList.Free;
end;

procedure TBasicClasses_TIntegerList_Test.Test_ChainToString;
const
  ValidString: String = '1, 2, 3, 4, 5, 6, 7, 8, 9, 10';
var
  Item: TIntItem;
  Idx: SizeUInt;
begin
  { (1) Prepare our list by filling 10 items. }
  for Idx := 1 to 10 do
  begin
    Item := TIntItem(Idx);
    List.Add(Item);
  end;

  { (2) Compare generated string with ValidString. Both should be equal. }
  Assert.AreEqual(ValidString, List.ChainToString, 'List.ChainToString returned invalid value!');
end;

procedure TBasicClasses_TIntegerList_Test.Test_CopyFrom;
var
  NewList: TIntegerList;
  Item: TIntItem;
  Idx: SizeUInt;
begin
  { (1) Prepare our list by filling 40 items. }
  for Idx := 1 to 40 do
  begin
    Item := TIntItem(Idx);
    List.Add(Item);
  end;

  { (2) Shuffle list. }
  List.Shuffle;

  { (3) Create NewList. }
  NewList := TIntegerList.Create;
  try
    { (4) Mark that list shouldn't release entries. }
    NewList.NeedRelease := False;

    { (5) Copy entries from the List to NewList. }
    NewList.CopyFrom(List);

    { (6) Itterate throu the list and compare it with the source. }
    for Idx := NewList.LowIndex to NewList.HighIndex do
    begin
      Assert.AreEqual(List[Idx], NewList[Idx], 'List[Idx] isn''t equal to NewList[Idx]!');
    end;
  finally
    { (7) Finally release NewList. }
    NewList.Free;
  end;
end;

procedure TBasicClasses_TIntegerList_Test.Test_Creation;
begin
  Assert.AreEqual(Cardinal(0), Cardinal(List.Capacity), 'List.Capacity isn''t 0!');
  Assert.AreEqual(Cardinal(0), Cardinal(List.Count), 'List.Count isn''t 0!');
end;

procedure TBasicClasses_TIntegerList_Test.Test_Enumerator;
var
  Item: TIntItem;
  Idx: Integer;
  It: TIntegerList.TEnumerator;
  RevIt: TIntegerList.TReverseEnumerator;
begin
  { Prepare our list by adding 200 items. }
  for Idx := 1 to 100 do
  begin
    Item := TIntItem(Idx);
    List.Add(Item);
  end;

  { Create enumerator and test it. }
  It := List.GetEnumerator;
  Idx := 1;

  while It.MoveNext do
  begin
    Assert.AreEqual(Idx, Integer(It.Current), 'It.Current isn''t equal to Idx which is equal to ' + Idx.ToString + '!');
    Inc(Idx);
  end;

  It.Free;

  { Create reverse enumerator and test it. }
  RevIt := List.GetReverseEnumerator;
  Idx := 100;

  while RevIt.MoveNext do
  begin
    Assert.AreEqual(Idx, Integer(RevIt.Current), 'RevIt.Current isn''t equal to Idx which is equal to ' + Idx.ToString + '!');
    Dec(Idx);
  end;

  RevIt.Free;
end;

procedure TBasicClasses_TIntegerList_Test.Test_Exchange;
var
  Idx: SizeUInt;
  I: SizeUInt;
begin
  { Prepare our list by adding 100 items. }
  for I := 1 to 100 do
  begin
    Idx := List.Add(TIntItem(I));
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(TIntItem(I)) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx]), 'List[Idx] item value is invalid!');
  end;

  { Exchange 2 items and validate. }
  List.Exchange(0, 99);
  Assert.AreEqual(Integer(100), Integer(List[0]), 'Integer(List[0]) isn''t equal to 100!');
  Assert.AreEqual(Integer(1), Integer(List[99]), 'Integer(List[99]) isn''t equal to 1!');
end;

procedure TBasicClasses_TIntegerList_Test.Test_Exists;
var
  Item: TIntItem;
  Idx: SizeUInt;
begin
  { Prepare our list by adding 100 items. }
  for Idx := 1 to 100 do
  begin
    Item := TIntItem(Idx);
    List.Add(Item);
  end;

  { Check existance of item with value 39. }
  Assert.IsTrue(List.Exists(TIntItem(39)), 'List.Exists(TIntItem(39)) doesn''t exists!');
end;

procedure TBasicClasses_TIntegerList_Test.Test_Extract;
var
  Item: TIntItem;
  pItem: PIntItem;
  I, Idx: SizeUInt;
begin
  { Prepare our list by adding 100 items. }
  for I := 1 to 100 do
  begin
    Idx := List.Add(TIntItem(I));
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(TIntItem(I)) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx]), 'List[Idx] item value is invalid!');
  end;

  { Retrieve item from position (index) 49. }
  Item := List[49];

  { Extract item from the list. }
  pItem := List.Extract(Item);

  { If extracted item isn't equal to nil, verify that item was deleted from the
    list. }
  Assert.areNotEqual<PIntItem>(nil, pItem, 'List.Extract(pItem) returned nil!');
  if (pItem <> nil) then
  begin
    Assert.AreEqual(Cardinal(99), Cardinal(List.Count), 'List.Count isn''t equal to 99!');
    Assert.AreNotEqual(Integer(50), Integer(List[49]), 'List[49] is equal to 50!');
  end;

  { Retrieve item from position (index) 24. }
  Item := List[24];

  { Extract item from the list using FromEnd direction. }
  pItem := List.ExtractItem(Item, FromEnd);

  { If extracted item isn't equal to nil, verify that item was deleted from the
    list. }
  Assert.AreNotEqual<PIntItem>(nil, pItem, 'List.ExtractItem(Item, FromEnd) returned nil!');
  if (pItem <> nil) then
  begin
    Assert.AreEqual(Cardinal(98), Cardinal(List.Count), 'List.Count isn''t equal to 98!');
    Assert.AreNotEqual(Integer(25), Integer(List[24]), 'List[24] is equal to 25!');
  end;
end;

procedure TBasicClasses_TIntegerList_Test.Test_FirstAndLast;
var
  Item: TIntItem;
  I: SizeUInt;
begin
  { Prepare our list by adding 100 items. }
  for I := 1 to 100 do
  begin
    Item := TIntItem(I);
    List.Add(Item);
  end;

  Assert.AreEqual(Integer(1), Integer(PIntItem(List.First)^), 'List.First^ isn''t equal to 1!');
  Assert.AreEqual(Integer(100), Integer(PIntItem(List.Last)^), 'List.Last^ isn''t equal to 100!');
  Assert.AreEqual(Cardinal(0), Cardinal(List.LowIndex), 'List.LowIndex isn''t equal to 0!');
  Assert.AreEqual(Cardinal(99), Cardinal(List.HighIndex), 'List.HighIndex isn''t equal to 99!');

  List.Delete(List.HighIndex);

  Assert.AreEqual(Integer(99), Integer(PIntItem(List.Last)^), 'List.Last^ isn''t equal to 99!');
end;

procedure TBasicClasses_TIntegerList_Test.Test_IndexOf;
var
  Item: TIntItem;
  I: SizeUInt;
begin
  { Prepare our list by adding 100 items. }
  for I := 1 to 100 do
  begin
    Item := TIntItem(I);
    List.Add(Item);
  end;

  Item := List[36];
  Assert.AreEqual(Integer(37), Integer(Item), 'List[36] isn''t equal to 37!');

  Assert.AreEqual(Cardinal(36), Cardinal(List.IndexOf(Item)), 'List.IndexOf(Item) didn''t return 36!');
  Assert.AreEqual(Cardinal(36), Cardinal(List.IndexOfItem(Item, FromEnd)), 'List.IndexOfItem(Item, FromEnd) didn''t return 36!');
end;

procedure TBasicClasses_TIntegerList_Test.Test_Insert;
var
  Item: TIntItem;
  I, Idx: SizeUInt;
begin
  { Prepare our list by adding 100 items. }
  for I := 1 to 100 do
  begin
    Item := TIntItem(I);
    Idx := List.Add(Item);
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(Item) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx]), 'List[Idx] item value is invalid!');
  end;

  { Prepare our list by inserting 100 items to position (index) 50. }
  for I := 1 to 100 do
  begin
    Item := TIntItem(I);
    List.Insert(50, Item);
  end;

  Assert.AreEqual(Cardinal(200), Cardinal(List.Count), 'List.Count isn''t equal to 200!');
  Assert.AreEqual(Integer(50), Integer(List[49]), 'List[49] isn''t equal to 50!');
  Assert.AreEqual(Integer(100), Integer(List[50]), 'List[50]) isn''t equal to 100!');
end;

procedure TBasicClasses_TIntegerList_Test.Test_Move;
var
  Item: TIntItem;
  I, Idx: SizeUInt;
begin
  { Prepare our list by adding 100 items. }
  for I := 1 to 100 do
  begin
    Item := TIntItem(I);
    Idx := List.Add(Item);
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(Item) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx]), 'List[Idx] item value is invalid!');
  end;

  { Move item from position (index) 10 to 90. }
  List.Move(10, 90);
  Assert.AreNotEqual(Integer(11), Integer(List[10]), 'List[10] is equal to 11!');
  Assert.AreEqual(Integer(11), Integer(List[90]), 'List[90] isn''t equal to 11!');
end;

procedure TBasicClasses_TIntegerList_Test.Test_RemoveDuplicates;
var
  Item: TIntItem;
  Idx: SizeUInt;
begin
  { Prepare our list by adding some duplicated items. }
  Item := TIntItem(9);
  for Idx := 1 to 8 do
    List.Add(Item);

  Item := TIntItem(73);
  for Idx := 1 to 4 do
    List.Add(Item);

  Item := TIntItem(49);
  for Idx := 1 to 7 do
    List.Add(Item);

  Assert.AreEqual(Integer(19), Integer(List.Count), 'List.Count isn''t equal to 19!');
  List.RemoveDuplicates;
  Assert.AreEqual(Integer(3), Integer(List.Count), 'List.Count isn''t equal to 3!');
end;

procedure TBasicClasses_TIntegerList_Test.Test_RemoveItems;
var
  Item: TIntItem;
  I, Idx: SizeUInt;
begin
  { Prepare our list by adding 200 items. }
  for I := 1 to 200 do
  begin
    Idx := List.Add(TIntItem(I));
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(TIntItem(I)) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx]), 'List[Idx] item value is invalid!');
  end;

  { Check removal with ShinkMode set to smNormal. }
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

  Assert.AreEqual(Cardinal(64), Cardinal(Length(List.List.List)), 'Length(List.List) isn''t equal to 64!');
  List.Clear;
  Assert.AreEqual(Cardinal(0), Cardinal(Length(List.List.List)), 'Length(List.List) isn''t equal to 0!');

  { Prepare our list by adding 200 items. }
  for I := 1 to 200 do
  begin
    Idx := List.Add(TIntItem(I));
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(TIntItem(I)) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx]), 'List[Idx] item value is invalid!');
  end;

  { Check removal with ShrinkMode set to smToCount. }
  List.ShrinkMode := smToCount;

  for I := 1 to 100 do
  begin
    if (List.Count > 1) then
      List.Delete(0);

    Assert.AreEqual(Cardinal(List.Count), Cardinal(List.Capacity), 'List.Capacity isn''t equal to ' + IntToStr(List.Count) + '!');
  end;

  List.Clear;

  { Prepare our list by adding 200 items. }
  for I := 1 to 200 do
  begin
    Idx := List.Add(TIntItem(I));
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(TIntItem(I)) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx]), 'List[Idx] item value is invalid!');
  end;

  { Check removal with ShrinkMode set to smKeepCap. }
  List.ShrinkMode := smKeepCap;

  for I := 1 to 100 do
  begin
    if (List.Count > 0) then
      List.Delete(List.Count - 1);
    Assert.AreEqual(Cardinal(256), Cardinal(List.Capacity), 'List.Capacity isn''t equal to 256!');
  end;


  List.Clear;

  { Prepare our list by adding 200 items. }
  for I := 1 to 200 do
  begin
    Idx := List.Add(TIntItem(I));
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(TIntItem(I)) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx]), 'List[Idx] item value is invalid!');
  end;

  { Check removal by Remove() method. }
  for I := 1 to 10 do
  begin
    Item := List[123];
    Assert.AreEqual(Cardinal(123), Cardinal(List.Remove(Item)), 'List.Remove(Item) returned value not equal to 123!');
  end;

  List.Clear;

  { Prepare our list by adding 200 items. }
  for I := 1 to 200 do
  begin
    Idx := List.Add(TIntItem(I));
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(TIntItem(I)) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx]), 'List[Idx] item value is invalid!');
  end;

  { Check removal by RemoveItem() method with FromEnd direction. }
  for I := 1 to 10 do
  begin
    Item := List[123];
    Assert.AreEqual(Cardinal(123), Cardinal(List.RemoveItem(Item, FromEnd)), 'List.RemoveItem(Item, FromEnd) returned value not equal to 123!');
  end;
end;

function TIntItem_CompareFunc(Item1, Item2: Pointer): Integer;
begin
  Result := PIntItem(Item1)^ - PIntItem(Item2)^;
end;

procedure TBasicClasses_TIntegerList_Test.Test_SameAs;
var
  List2: TIntegerList;
  Item: TIntItem;
  Idx: SizeUInt;
begin
  { (1) Create List2 and set NeedRelease flag to True. }
  List2 := TIntegerList.Create;
  try
    List2.NeedRelease := True;

    { (2) Prepare two list with identical entries. }
    for Idx := 1 to 100 do
    begin
      Item := TIntItem(Idx);
      List.Add(Item);
      List2.Add(Item);
    end;

    { (3) Compare both lists. They should have identical entries. }
    Assert.IsTrue(List.SameAs(List2), 'List isn''t the same as List2!');

    { (4) Clear List2 and prepare it again but now List2 should have different
          values. }
    List2.Clear;

    for Idx := 1 to 2000 do
      List2.Add(TIntItem(Random(500)));

    { (5) Compare both list. They aren't identical. }
    Assert.IsFalse(List.SameAs(List2), 'List is the same as List2!');
  finally
    { (6) Finally release List2. }
    List2.Free;
  end;
end;

procedure TBasicClasses_TIntegerList_Test.Test_Sort;
var
  Item: TIntItem;
  Idx: SizeUInt;
begin
  { Fill our list with random values. }
  for Idx := 0 to 200 do
  begin
    Item := TIntItem(Random(200));
    List.Add(Item);
  end;

  { Sort list. }
  List.Sort(TIntItem_CompareFunc);

  { Make sure that items were sorted. }
  for Idx := List.LowIndex to (List.HighIndex - 1) do
    Assert.IsTrue(Integer(List[Idx]) <= Integer(List[Idx + 1]), 'List[' + Idx.ToString + '] <= List[' + SizeUInt(Idx + 1).ToString + '] condition failed!');
end;

procedure TBasicClasses_TIntegerList_Test.Test_Values;
var
  Item: TIntItem;
  Idx: SizeUInt;
begin
  { Fill our list with 100 values. }
  for Idx := 1 to 100 do
  begin
    Item := TIntItem(Idx);
    List.Add(Item);
  end;

  Assert.AreEqual(Integer(1), Integer(List.ValuesMin), 'List.ValuesMin isn''t equal to 1!');
  Assert.AreEqual(Integer(100), Integer(List.ValuesMax), 'List.ValuesMax isn''t equal to 100!');
  Assert.AreEqual(Integer(5050), Integer(List.ValuesSum), 'List.ValuesSum isn''t equal to 5050!');
  Assert.AreEqual(Integer(50), Integer(List.ValuesAvg), 'List.ValuesAvg isn''t equal to 50!');
end;

{ TBasicClasses_TIntegerProbabilityList_Test - class implementation }

procedure TBasicClasses_TIntegerProbabilityList_Test.Setup;
begin
  { (1) Create List. }
  List := TIntegerProbabilityList.Create;

  { (2) Set NeedRelease flag to True. }
  List.NeedRelease := True;
end;

procedure TBasicClasses_TIntegerProbabilityList_Test.TearDown;
begin
  { (1) Clear List. }
  List.Clear;

  { (2) Free List. }
  List.Free;
  List := nil;
end;

procedure TBasicClasses_TIntegerProbabilityList_Test.Test_AddItems;
var
  I, Idx: SizeUInt;
begin
  List.GrowMode := gmFast;

  for I := 1 to 100 do
  begin
    Idx := List.Add(TIntProbValue(I), 1.0);
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(TIntProbValue(I), 1.0) retured invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx].Value), 'List[Idx].Value isn''t equal to ' + I.ToString + '!');

    if (I = 32) then
      Assert.AreEqual(Cardinal(32), Cardinal(List.Capacity), 'List.Capacity isn''t equal to 32!');
    if (I = 33) then
      Assert.AreEqual(Cardinal(64), Cardinal(List.Capacity), 'List.Capacity isn''t equal to 64!');
    if (I = 64) then
      Assert.AreEqual(Cardinal(64), Cardinal(List.Capacity), 'List.Capacity isn''t equal to 64!');
    if (I = 65) then
      Assert.AreEqual(Cardinal(128), Cardinal(List.Capacity), 'List.Capacity isn''t equal to 128!');
  end;

  List.Clear;
  List.GrowMode := gmSlow;

  for I := 1 to 100 do
  begin
    Idx := List.Add(TIntProbValue(I), 1.0);
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(TIntProbValue(I), 1.0) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx].Value), 'List[Idx].Value isn''t equal to ' + I.ToString + '!');

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
    Idx := List.Add(TIntProbValue(I), 1.0);
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(TIntProbValue(I), 1.0) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx].Value), 'List[Idx].Value isn''t equal to ' + I.ToString + '!');

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
    Idx := List.Add(TIntProbValue(I), 1.0);
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(TIntProbValue(I), 1.0) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx].Value), 'List[Idx].Value isn''t equal to ' + I.ToString + '!');

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

procedure TBasicClasses_TIntegerProbabilityList_Test.Test_Assign;
var
  NewList: TIntegerProbabilityList;
  Idx: SizeUInt;
begin
  { (1) Add 6 items to List. }
  for Idx := 1 to 6 do
    List.Add(TIntProbValue(Idx), 1.0);

  { (2) Shuffle list. }
  List.BestShuffle;

  { (3) Create and assign List to NewList. Mark that NewList shouldn't release items. }
  NewList := TIntegerProbabilityList.Create;
  try
    NewList.NeedRelease := False;

    NewList.Assign(List);

    { (4) Compare both list. They should be equal. }
    Assert.IsTrue(List.SameAs(NewList), 'List isn''t equal to NewList!');
  finally
    { (5) Release NewList. }
    NewList.Free;
  end;
end;

procedure TBasicClasses_TIntegerProbabilityList_Test.Test_CopyFrom;
var
  NewList: TIntegerProbabilityList;
  Idx: SizeUInt;
begin
  { (1) Prepare our list by filling 40 items. }
  for Idx := 1 to 40 do
    List.Add(TIntProbValue(Idx), 1.0);

  { (2) Shuffle list. }
  List.Shuffle;

  { (3) Create NewList. }
  NewList := TIntegerProbabilityList.Create;
  try
    { (4) Mark that list shouldn't release entries. }
    NewList.NeedRelease := False;

    { (5) Copy entries from the List to NewList. }
    NewList.CopyFrom(List);

    { (6) Itterate throu the list and compare it with the source. }
    Assert.IsTrue(List.SameAs(NewList), 'List isn''t equal to NewList!');
  finally
    { (7) Finally release NewList. }
    NewList.Free;
  end;
end;

procedure TBasicClasses_TIntegerProbabilityList_Test.Test_Creation;
begin
  Assert.AreEqual(Cardinal(0), Cardinal(List.Capacity), 'List.Capacity isn''t 0!');
  Assert.AreEqual(Cardinal(0), Cardinal(List.Count), 'List.Count isn''t 0!');
end;

procedure TBasicClasses_TIntegerProbabilityList_Test.Test_Enumerator;
var
  Idx: Integer;
  It: TIntegerProbabilityList.TEnumerator;
  RevIt: TIntegerProbabilityList.TReverseEnumerator;
begin
  { Prepare our list by adding 200 items. }
  for Idx := 1 to 100 do
    List.Add(TIntProbValue(Idx), 1.0);

  { Create enumerator and test it. }
  It := List.GetEnumerator;
  try
    Idx := 1;

    while It.MoveNext do
    begin
      Assert.AreEqual(Idx, Integer(It.Current.Value), 'It.Current.Value isn''t equal to Idx which is equal to ' + Idx.ToString + '!');
      Inc(Idx);
    end;
  finally
    It.Free;
  end;

  { Create reverse enumerator and test it. }
  RevIt := List.GetReverseEnumerator;
  try
    Idx := 100;

    while RevIt.MoveNext do
    begin
      Assert.AreEqual(Idx, Integer(RevIt.Current.Value), 'RevIt.Current.Value isn''t equal to Idx which is equal to ' + Idx.ToString + '!');
      Dec(Idx);
    end;
  finally
    RevIt.Free;
  end;
end;

procedure TBasicClasses_TIntegerProbabilityList_Test.Test_Exchange;
var
  Idx: SizeUInt;
  I: SizeUInt;
begin
  { Prepare our list by adding 100 items. }
  for I := 1 to 100 do
  begin
    Idx := List.Add(TIntProbValue(I), 1.0);
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(TIntItem(I)) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx].Value), 'List[Idx].Value is invalid!');
  end;

  { Exchange 2 items and validate. }
  List.Exchange(0, 99);
  Assert.AreEqual(Integer(100), Integer(List[0].Value), 'Integer(List[0].Value) isn''t equal to 100!');
  Assert.AreEqual(Integer(1), Integer(List[99].Value), 'Integer(List[99].Value) isn''t equal to 1!');
end;

procedure TBasicClasses_TIntegerProbabilityList_Test.Test_Exists;
var
  Idx: SizeUInt;
  Item: TIntegerProbabilityList.TIntProbItem;
begin
  { Prepare our list by adding 100 items. }
  for Idx := 1 to 100 do
  begin
    List.Add(TIntProbValue(Idx), 1.0);
  end;

  Item.Value := 39;
  Item.Probability := 1.0;

  { Check existance of item with value 39. }
  Assert.IsTrue(List.Exists(Item), 'List.Exists(Item) doesn''t exists!');
end;

procedure TBasicClasses_TIntegerProbabilityList_Test.Test_Extract;
begin

end;

procedure TBasicClasses_TIntegerProbabilityList_Test.Test_FirstAndLast;
begin

end;

procedure TBasicClasses_TIntegerProbabilityList_Test.Test_IndexOf;
begin

end;

procedure TBasicClasses_TIntegerProbabilityList_Test.Test_Insert;
begin

end;

procedure TBasicClasses_TIntegerProbabilityList_Test.Test_Move;
begin

end;

procedure TBasicClasses_TIntegerProbabilityList_Test.Test_RemoveDuplicates;
begin

end;

procedure TBasicClasses_TIntegerProbabilityList_Test.Test_RemoveItems;
begin

end;

procedure TBasicClasses_TIntegerProbabilityList_Test.Test_SameAs;
begin

end;

procedure TBasicClasses_TIntegerProbabilityList_Test.Test_Sort;
begin

end;

initialization
  TDUnitX.RegisterTestFixture(TBasicClasses_TBCList_Test, 'TBCList Test');
  TDUnitX.RegisterTestFixture(TBasicClasses_TIntegerList_Test, 'TIntegerList Test');
  TDUnitX.RegisterTestFixture(TBasicClasses_TIntegerProbabilityList_Test, 'TIntegerProbabilityList Test');

end.
