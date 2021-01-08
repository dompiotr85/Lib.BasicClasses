unit BasicClasses_Lists_TestCase;

interface

uses
  System.Types,
  System.Classes,
  DUnitX.TestFramework,
  TypeDefinitions,
  BasicClasses.Lists;

type
  { TMyBCList - class definition }
  TMyBCList = class(TBCList)
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  end;

  { TBasicClasses_TBCList_TestCase - class definition }
  [TestFixture]
  TBasicClasses_TBCList_TestCase = class
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

  { TBasicClasses_TIntegerList_TestCase - class definition }
  [TestFixture]
  TBasicClasses_TIntegerList_TestCase = class
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

  { TBasicClasses_TIntegerProbabilityList_TestCase - class definition }
  [TestFixture]
  TBasicClasses_TIntegerProbabilityList_TestCase = class
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
    [TestCase('TIntegerProbabilityList ScaleProbability', '')]
    procedure Test_ScaleProbability;
    [TestCase('TIntegerProbabilityList RandomValue', '')]
    procedure Test_RandomValue;
    [TestCase('TIntegerProbabilityList NormalizeProbabilities', '')]
    procedure Test_NormalizeProbabilities;
    [TestCase('TIntegerProbabilityList SetProbability', '')]
    procedure Test_SetProbability;
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

{ TBasicClasses_TBCList_TestCase - class implementation }

procedure TBasicClasses_TBCList_TestCase.Setup;
begin
  { Create List. }
  List := TMyBCList.Create;
end;

procedure TBasicClasses_TBCList_TestCase.TearDown;
begin
  { (1) Clear List. }
  List.Clear;

  { (2) Free List. }
  List.Free;
  List := nil;
end;

procedure TBasicClasses_TBCList_TestCase.Test_AddItems;
var
  pItem: PInteger;
  I, Idx: SizeUInt;
begin
  { (1) Set List GrowMode to gmFast. }
  List.GrowMode := gmFast;

  { (2.1) Prepare our list by adding 100 items and check list's capacity
          growage: }
  for I := 1 to 100 do
  begin
    { (2.2) Allocate memory for new item. }
    New(pItem);

    { (2.3) Set value for new item. }
    PInteger(pItem)^ := Integer(I);

    { (2.4) Add new item to the list. }
    Idx := List.Add(pItem);

    { (2.5) Check that item was added properly and that item in the list have
            proper value. }
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(pItem) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(PInteger(List[Idx])^), 'PInteger(List[Idx])^ item isn''t equal to ' + I.ToString + '!');

    { (2.6) Depending on amount already added, check List.Capacity values. }
    if (I = 32) then
      Assert.AreEqual(32, Cardinal(List.Capacity), 'List.Capacity isn''t equal to 32!');
    if (I = 33) then
      Assert.AreEqual(64, Cardinal(List.Capacity), 'List.Capacity isn''t equal to 64!');
    if (I = 64) then
      Assert.AreEqual(64, Cardinal(List.Capacity), 'List.Capacity isn''t equal to 64!');
    if (I = 65) then
      Assert.AreEqual(128, Cardinal(List.Capacity), 'List.Capacity isn''t equal to 128!');
  end;

  { (3) Clear the list. }
  List.Clear;

  { (4) Set List GrowMode to gmSlow. }
  List.GrowMode := gmSlow;

  { (5.1) Prepare our list by adding 100 items and check list's capacity
          growage: }
  for I := 1 to 100 do
  begin
    { (5.2) Allocate memory for new item. }
    New(pItem);

    { (5.3) Set value for new item. }
    PInteger(pItem)^ := Integer(I);

    { (5.4) Add new item to the list. }
    Idx := List.Add(pItem);

    { (5.5) Check that item was added properly and that item in the list have
            proper value. }
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(pItem) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(PInteger(List[Idx])^), 'PInteger(List[Idx])^ item isn''t equal to ' + I.ToString + '!');

    { (5.6) Depending on amount already added, check List.Capacity values. }
    if (I > 32) then
      Assert.AreEqual(Cardinal(I), Cardinal(List.Capacity), 'List.Capacity isn''t equal to ' + I.ToString + '!')
    else
      Assert.AreEqual(32, Cardinal(List.Capacity), 'List.Capacity isn''t equal to 32!');
  end;

  { (6) Clear the list. }
  List.Clear;

  { (7) Set List GrowMode to gmLinear and GrowFactor to 2.0. }
  List.GrowMode := gmLinear;
  List.GrowFactor := 2.0;

  { (8.1) Prepare our list by adding 100 items and check list's capacity
          growage: }
  for I := 1 to 100 do
  begin
    { (8.2) Allocate memory for new item. }
    New(pItem);

    { (8.3) Set value for new item. }
    PInteger(pItem)^ := Integer(I);

    { (8.4) Add new item to the list. }
    Idx := List.Add(pItem);

    { (8.5) Check that item was added properly and that item in the list have
            proper value. }
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(pItem) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(PInteger(List[Idx])^), 'PInteger(List[Idx])^ item isn''t equal to ' + I.ToString + '!');

    { (8.6) Depending on amount already added, check List.Capacity values. }
    if (I = 64) then
      Assert.AreEqual(Cardinal(64), Cardinal(List.Capacity), 'List.Capacity isn''t equal to 64!');
    if (I = 65) then
      Assert.AreEqual(Cardinal(66), Cardinal(List.Capacity), 'List.Capacity isn''t equal to 66!');
    if (I = 86) then
      Assert.AreEqual(Cardinal(86), Cardinal(List.Capacity), 'List.Capacity isn''t equal to 86!');
    if (I = 87) then
      Assert.AreEqual(Cardinal(88), Cardinal(List.Capacity), 'List.Capacity isn''t equal to 88!');
  end;

  { (9) Clear the list. }
  List.Clear;

  { (10) Set List GrowMode to gmFastAttenuated and GrowLimit to 64. }
  List.GrowMode := gmFastAttenuated;
  List.GrowLimit := 64;

  { (11.1) Prepare our list by adding 100 items and check list's capacity
           growage: }
  for I := 1 to 100 do
  begin
    { (11.2) Allocate memory for new item. }
    New(pItem);

    { (11.3) Set value for new item. }
    PInteger(pItem)^ := Integer(I);

    { (11.4) Add new item to the list. }
    Idx := List.Add(pItem);

    { (11.5) Check that item was added properly and that item in the list have
             proper value. }
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(pItem) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(PInteger(List[Idx])^), 'PInteger(List[Idx])^ item isn''t equal to ' + I.ToString + '!');

    { (11.6) Depending on amount already added, check List.Capacity values. }
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

procedure TBasicClasses_TBCList_TestCase.Test_Assign;
var
  List2: TBCList;
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
  List2 := TBCList.Create;
  try
    List2.Assign(List);

    { (3) Compare both list. They should be equal. }
    if (List2.Count > 0) then
      for Idx := List2.LowIndex to List2.HighIndex do
        Assert.AreEqual(PInteger(List[Idx])^, PInteger(List2[Idx])^, 'PInteger(List[Idx])^ isn''t equal to PInteger(List2[Idx])^!');
  finally
    { (4) Release lists. }
    List2.Free;
  end;
end;

procedure TBasicClasses_TBCList_TestCase.Test_Creation;
begin
  Assert.AreEqual(Cardinal(0), Cardinal(List.Capacity), 'List.Capacity isn''t 0!');
  Assert.AreEqual(Cardinal(0), Cardinal(List.Count), 'List.Count isn''t 0!');
end;

procedure TBasicClasses_TBCList_TestCase.Test_Exchange;
var
  pItem: PInteger;
  I: SizeUInt;
begin
  { (1.1) Prepare our list by adding 100 items: }
  for I := 1 to 100 do
  begin
    { (1.2) Allocate memory for new item. }
    New(pItem);

    { (1.3) Set item value. }
    PInteger(pItem)^ := Integer(I);

    { (1.4) Add new item to the list. }
    List.Add(pItem);
  end;

  { Exchange 2 items and validate that operation. }
  List.Exchange(0, 99);
  Assert.AreEqual(Integer(100), PInteger(List[0])^, 'PInteger(List[0])^ isn''t equal to 100!');
  Assert.AreEqual(Integer(1), PInteger(List[99])^, 'PInteger(List[99])^ isn''t equal to 1!');
end;

procedure TBasicClasses_TBCList_TestCase.Test_Extract;
var
  pItem: PInteger;
  I: SizeUInt;
begin
  { (1.1) Prepare our list by adding 100 items: }
  for I := 1 to 100 do
  begin
    { (1.2) Allocate memory for new item. }
    New(pItem);

    { (1.3) Set item value. }
    PInteger(pItem)^ := Integer(I);

    { (1.4) Add new item to the list. }
    List.Add(pItem);
  end;

  { (2) Retrieve item from position (index) 49. }
  pItem := List[49];

  { (3) Extract item from the list. }
  pItem := List.Extract(pItem);

  { (4) If extracted item isn't equal to nil, verify that item was deleted from
        the list. }
  Assert.AreNotEqual<PInteger>(nil, pItem, 'List.Extract(pItem) returned nil!');
  if (pItem <> nil) then
  begin
    Assert.AreEqual(Cardinal(99), Cardinal(List.Count), 'List.Count isn''t equal to 99!');
    Assert.AreNotEqual(Integer(50), PInteger(List[49])^, 'PInteger(List[49])^ is equal to 50!');
  end;

  { (5) Retrieve item from position (index) 24. }
  pItem := List[24];

  { (6) Extract item from the list. }
  pItem := List.ExtractItem(pItem, FromEnd);

  { (7) If extracted item isn't equal to nil, verify that item was deleted from
        the list. }
  Assert.AreNotEqual<PInteger>(nil, pItem, 'List.ExtractItem(pItem, FromEnd) returned nil!');
  if (pItem <> nil) then
  begin
    Assert.AreEqual(Cardinal(98), Cardinal(List.Count), 'List.Count isn''t equal to 98!');
    Assert.AreNotEqual(Integer(25), PInteger(List[24])^, 'PInteger(List[24])^ is equal to 25!');
  end;
end;

procedure TBasicClasses_TBCList_TestCase.Test_FirstAndLast;
var
  pItem: PInteger;
  I: SizeUInt;
begin
  { (1.1) Prepare our list by adding 100 items: }
  for I := 1 to 100 do
  begin
    { (1.2) Allocate memory for new item. }
    New(pItem);

    { (1.3) Set item value. }
    PInteger(pItem)^ := Integer(I);

    { (1.4) Add new item to the list. }
    List.Add(pItem);
  end;

  { (2) Validate that List.First and List.Last points to proper entries in
        the list. }
  Assert.AreEqual(Integer(1), PInteger(List.First)^, 'List.First^ isn''t equal to 1!');
  Assert.AreEqual(Integer(100), PInteger(List.Last)^, 'List.Last^ isn''t equal to 100!');

  { (3) Validate that List.LowIndex and List.HighIndex returns proper values. }
  Assert.AreEqual(Cardinal(0), Cardinal(List.LowIndex), 'List.LowIndex isn''t equal to 0!');
  Assert.AreEqual(Cardinal(99), Cardinal(List.HighIndex), 'List.HighIndex isn''t equal to 99!');

  { (4) Delete last entry from the list. }
  List.Delete(List.HighIndex);

  { (5) Validate again that List.Last points to last entry in the list. }
  Assert.AreEqual(Integer(99), PInteger(List.Last)^, 'List.Last^ isn''t equal to 99!');
end;

procedure TBasicClasses_TBCList_TestCase.Test_IndexOf;
var
  pItem: PInteger;
  I: SizeUInt;
begin
  { (1.1) Prepare our list by adding 100 items: }
  for I := 1 to 100 do
  begin
    { (1.2) Allocate memory for new item. }
    New(pItem);

    { (1.3) Set value to new item. }
    PInteger(pItem)^ := Integer(I);

    { (1.4) Add new item to the list. }
    List.Add(pItem);
  end;

  { (2) Retrieve List[36] entry from the list. }
  pItem := List[36];

  { (3.1) Validate that retrieved item isn't nil. }
  Assert.IsNotNull(pItem, 'List[36] is nil!');
  if (pItem <> nil) then
  begin
    { (3.2) Validate List.IndexOf and List.IndexOfItem methods. }
    Assert.AreEqual(Cardinal(36), Cardinal(List.IndexOf(pItem)), 'List.IndexOf(pItem) didn''t return 36!');
    Assert.AreEqual(Cardinal(36), Cardinal(List.IndexOfItem(pItem, FromEnd)), 'List.IndexOfItem(pItem, FromEnd) didn''t return 36!');
  end;
end;

procedure TBasicClasses_TBCList_TestCase.Test_Insert;
var
  pItem: PInteger;
  I, Idx: SizeUInt;
begin
  { (1.1) Prepare our list by adding 100 items: }
  for I := 1 to 100 do
  begin
    { (1.2) Allocate memory for new item. }
    New(pItem);

    { (1.3) Set value to new item. }
    PInteger(pItem)^ := Integer(I);

    { (1.4) Add new item to the list and returns it new position (index) to
            Idx. }
    Idx := List.Add(pItem);

    { (1.5) Validate that returned position is valid. }
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(pItem) returned invalid value!');

    { (1.6) Validate that entry with Idx position (index) is valid. }
    Assert.AreEqual(Cardinal(I), Cardinal(PInteger(List[Idx])^), 'List[Idx] item value is invalid!');
  end;

  { (2.1) Prepare our list by inserting 100 items to position (index) 50: }
  for I := 1 to 100 do
  begin
    { (2.2) Allocate memory for new item. }
    New(pItem);

    { (2.3) Set value for new item. }
    PInteger(pItem)^ := Integer(I);

    { (2.4) Insert new item to position (index) 50. }
    List.Insert(50, pItem);
  end;

  { (3) Validate that List.Count grow to 200. }
  Assert.AreEqual(Cardinal(200), Cardinal(List.Count), 'List.Count isn''t equal to 200!');

  { (4) Validate that List[49] entry is equal to 50. }
  Assert.AreEqual(Integer(50), PInteger(List[49])^, 'PInteger(List[49])^ isn''t equal to 50!');

  { (5) Validate that List[50] entry is equal to 100. }
  Assert.AreEqual(Integer(100), PInteger(List[50])^, 'PInteger(List[50])^ isn''t equal to 100!');
end;

procedure TBasicClasses_TBCList_TestCase.Test_Move;
var
  pItem: PInteger;
  I, Idx: SizeUInt;
begin
  { (1.1) Prepare our list by adding 100 items: }
  for I := 1 to 100 do
  begin
    { (1.2) Allocate memory for new item. }
    New(pItem);

    { (1.3) Set value for new item. }
    PInteger(pItem)^ := Integer(I);

    { (1.4) Add new item to the list and store it's position (index) in Idx. }
    Idx := List.Add(pItem);

    { (1.5) Validate that returned position is valid. }
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(pItem) returned invalid value!');

    { (1.6) Validate that added item's value is valid. }
    Assert.AreEqual(Cardinal(I), PCardinal(List[Idx])^, 'List[Idx] item value is invalid!');
  end;

  { (2) Move item from position (index) 10 to 90. }
  List.Move(10, 90);

  { (3) Validate that moved entries was actualy moved. }
  Assert.AreNotEqual(Integer(11), PInteger(List[10])^, 'List[10] is equal to 11!');
  Assert.AreEqual(Integer(11), PInteger(List[90])^, 'List[90] isn''t equal to 11!');
end;

procedure TBasicClasses_TBCList_TestCase.Test_RemoveItems;
var
  pItem: PInteger;
  I, Idx: SizeUInt;
begin
  { (1.1) Prepare our list by adding 200 items: }
  for I := 1 to 200 do
  begin
    { (1.2) Allocate memory for new item. }
    New(pItem);

    { (1.3) Set value for new item. }
    PInteger(pItem)^ := Integer(I);

    { (1.4) Add new item to the list and store its position (index) in Idx. }
    Idx := List.Add(pItem);

    { (1.5) Validate that returned position is valid. }
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(@Item) returned invalid value!');

    { (1.6) Validate that added item's value is valid. }
    Assert.AreEqual(Cardinal(I), PCardinal(List[Idx])^, 'List[Idx] item value is invalid!');
  end;

  { (2) Check removal with ShrinkMode set to smNormal. }
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

  { (3.1) Prepare our list by adding 200 items: }
  for I := 1 to 200 do
  begin
    { (3.2) Allocate memory for the new item. }
    New(pItem);

    { (3.3) Set value for the new item. }
    PInteger(pItem)^ := Integer(I);

    { (3.4) Add new item to the list and store its position (index) to Idx. }
    Idx := List.Add(pItem);

    { (3.5) Validate that returned position is valid. }
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(pItem) returned invalid value!');

    { (3.6) Validate that added item's value is valid. }
    Assert.AreEqual(Cardinal(I), PCardinal(List[Idx])^, 'List[Idx] item value is invalid!');
  end;

  { (4) Check removal with ShrinkMode set to smToCount. }
  List.ShrinkMode := smToCount;

  for I := 1 to 200 do
  begin
    if (List.Count > 0) then
      List.Delete(0);

    Assert.AreEqual(Cardinal(200 - I), Cardinal(List.Capacity), 'List.Capacity isn''t equal to ' + IntToStr(200 - I) + '!');
  end;

  List.Clear;

  { (5.1) Prepare our list by adding 200 items: }
  for I := 1 to 200 do
  begin
    { (5.2) Allocate memory for new item. }
    New(pItem);

    { (5.3) Set value for the new item. }
    PInteger(pItem)^ := Integer(I);

    { (5.4) Add new item to the list and store its position to Idx. }
    Idx := List.Add(pItem);

    { (5.5) Validate that returned position is valid. }
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(pItem) return invalid value!');
  end;

  { (6) Check removal with ShrinkMode set to smKeepCap. }
  List.ShrinkMode := smKeepCap;

  for I := 1 to 200 do
  begin
    List.Delete(0);
    Assert.AreEqual(Cardinal(256), Cardinal(List.Capacity), 'List.Capacity isn''t equal to 256!');
  end;

  List.Clear;

  { (7.1) Prepare our list by adding 200 items: }
  for I := 1 to 200 do
  begin
    { (7.2) Allocate memory for new item. }
    New(pItem);

    { (7.3) Set value for the new item. }
    PInteger(pItem)^ := Integer(I);

    { (7.4) Add new item to the list and store its position to Idx. }
    Idx := List.Add(pItem);

    { (7.5) Validate that returned position is valid. }
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(pItem) return invalid value!');
  end;

  { (8) Check removal by Remove() method. }
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

procedure TBasicClasses_TBCList_TestCase.Test_Sort;
var
  pItem: PInteger;
  Idx: SizeUInt;
begin
  { (1) Fill our list with random values. }
  for Idx := 1 to 200 do
  begin
    New(pItem);
    PInteger(pItem)^ := Integer(Random(200));
    List.Add(pItem);
  end;

  { (2) In addition, shuffle the list to make it more random. }
  List.Shuffle;

  { (3) Sort the list. }
  List.Sort(Pointer_CompareFunc);

  { (4) Make sure that items were sorted. }
  for Idx := List.LowIndex to (List.HighIndex - 1) do
    Assert.IsTrue(PInteger(List[Idx])^ <= PInteger(List[Idx + 1])^, 'PInteger(List[' + Idx.ToString + '])^ <= PInteger(List[' + SizeUInt(Idx + 1).ToString + '] condition failed!');
end;

procedure TBasicClasses_TBCList_TestCase.Test_Enumerator;
var
  pItem: PInteger;
  Idx: Integer;
  It: TBCList.TEnumerator;
  RevIt: TBCList.TReverseEnumerator;
begin
  { (1.1) Prepare our list by adding 200 items: }
  for Idx := 1 to 100 do
  begin
    { (1.2) Allocate memory for the new item. }
    New(pItem);

    { (1.3) Set value for the new item. }
    PInteger(pItem)^ := Idx;

    { (1.4) Add new item to the list. }
    List.Add(pItem);
  end;

  { (2) Create enumerator and test it. }
  It := List.GetEnumerator;
  try
    Idx := 1;

    while It.MoveNext do
    begin
      Assert.AreEqual(Idx, PInteger(It.Current)^, 'PInteger(It.Current)^ isn''t equal to Idx which is equal to ' + Idx.ToString + '!');
      Inc(Idx);
    end;
  finally
    It.Free;
  end;

  { (3) Create reverse enumerator and test it. }
  RevIt := List.GetReverseEnumerator;
  try
    Idx := 100;

    while RevIt.MoveNext do
    begin
      Assert.AreEqual(Idx, PInteger(RevIt.Current)^, 'PInteger(RevIt.Current)^ isn''t equal to Idx which is equal to ' + Idx.ToString + '!');
      Dec(Idx);
    end;
  finally
    RevIt.Free;
  end;
end;

{ TBasicClasses_TIntegerList_TestCase - class implementation }

procedure TBasicClasses_TIntegerList_TestCase.Setup;
begin
  { (1) Create List. }
  List := TIntegerList.Create;

  { (2) Set NeedRelease flag to True. }
  List.NeedRelease := True;
end;

procedure TBasicClasses_TIntegerList_TestCase.TearDown;
begin
  { (1) Clear List. }
  List.Clear;

  { (2) Free List. }
  List.Free;
  List := nil;
end;

procedure TBasicClasses_TIntegerList_TestCase.Test_AddItems;
var
  I, Idx: SizeUInt;
begin
  { (1) Set List GrowMode to gmFast. }
  List.GrowMode := gmFast;

  { (2.1) Prepare our list by adding 100 items and check list's capacity
          growage: }
  for I := 1 to 100 do
  begin
    { (2.2) Add new item to the list and store its position in Idx. }
    Idx := List.Add(TIntItem(I));

    { (2.3) Check that item was added properly and that item in the list have
            proper value. }
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(TIntItem(I)) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx]), 'List[Idx] item isn''t equal to ' + I.ToString + '!');

    { (2.4) Depending on amount already added, check List.Capacity values. }
    if (I = 32) then
      Assert.AreEqual(Cardinal(32), Cardinal(List.Capacity), 'List.Capacity isn''t equal to 32!');
    if (I = 33) then
      Assert.AreEqual(Cardinal(64), Cardinal(List.Capacity), 'List.Capacity isn''t equal to 64!');
    if (I = 64) then
      Assert.AreEqual(Cardinal(64), Cardinal(List.Capacity), 'List.Capacity isn''t equal to 64!');
    if (I = 65) then
      Assert.AreEqual(Cardinal(128), Cardinal(List.Capacity), 'List.Capacity isn''t equal to 128!');
  end;

  { (3) Clear the list. }
  List.Clear;

  { (4) Set List GrowMode to gmSlow. }
  List.GrowMode := gmSlow;

  { (5.1) Prepare our list by adding 100 items and check list's capacity
          growage: }
  for I := 1 to 100 do
  begin
    { (5.2) Add new item to the list and store its position in Idx. }
    Idx := List.Add(TIntItem(I));

    { (5.3) Check that item was added properly and that item in the list have
            proper value. }
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(TIntItem(I)) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx]), 'List[Idx] item isn''t equal to ' + I.ToString + '!');

    { (5.4) Depending on amount already added, check List.Capacity values. }
    if (I > 32) then
      Assert.AreEqual(Cardinal(I), Cardinal(List.Capacity), 'List.Capacity isn''t equal to ' + I.ToString + '!')
    else
      Assert.AreEqual(Cardinal(32), Cardinal(List.Capacity), 'List.Capacity isn''t equal to 32!');
  end;

  { (6) Clear the list. }
  List.Clear;

  { (7) Set List GrowMode to gmLinear and GrowFactor to 2.0. }
  List.GrowMode := gmLinear;
  List.GrowFactor := 2.0;

  { (8.1) Prepare our list by adding 100 items and check list's cpacity
          growage: }
  for I := 1 to 100 do
  begin
    { (8.2) Add new item to the list and store its position in Idx. }
    Idx := List.Add(TIntItem(I));

    { (8.3) Check that item was added properly and that item in the list have
            proper value. }
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(TIntItem(I)) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx]), 'List[Idx] item isn''t equal to ' + I.ToString + '!');

    { (8.4) Depending on amount already added, check List.Capacity values. }
    if (I = 64) then
      Assert.AreEqual(Cardinal(64), Cardinal(List.Capacity), 'List.Capacity isn''t equal to 64!');
    if (I = 65) then
      Assert.AreEqual(Cardinal(66), Cardinal(List.Capacity), 'List.Capacity isn''t equal to 66!');
    if (I = 86) then
      Assert.AreEqual(Cardinal(86), Cardinal(List.Capacity), 'List.Capacity isn''t equal to 86!');
    if (I = 87) then
      Assert.AreEqual(Cardinal(88), Cardinal(List.Capacity), 'List.Capacity isn''t equal to 88!');
  end;

  { (9) Clear the list. }
  List.Clear;

  { (10) Set List GrowMode to gmFastAttenuated and GrowLimit to 64. }
  List.GrowMode := gmFastAttenuated;
  List.GrowLimit := 64;

  { (11.1) Prepare our list by adding 100 items and check list's capacity
           growage: }
  for I := 1 to 100 do
  begin
    { (11.2) Add new item to the list and store its position in Idx. }
    Idx := List.Add(TIntItem(I));

    { (11.3) Check that item was added properly and that item in the list have
             proper value. }
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(TIntItem(I)) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx]), 'List[Idx] item isn''t equal to ' + I.ToString + '!');

    { (11.4) Depending on amount already added, check List.Capacity values. }
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

procedure TBasicClasses_TIntegerList_TestCase.Test_Assign;
var
  NewList: TIntegerList;
  Idx: SizeUInt;
begin
  { (1) Add 6 items to the list. }
  for Idx := 1 to 6 do
    List.Add(TIntItem(Idx));

  { (2) Shuffle list. }
  List.BestShuffle;

  { (3) Create and assign List to NewList. Mark that NewList shouldn't release
        items. }
  NewList := TIntegerList.Create;
  try
    NewList.Assign(List);
    NewList.NeedRelease := False;

    { (4) Compare both list. They should be equal. }
    if (NewList.Count > 0) then
      for Idx := NewList.LowIndex to NewList.HighIndex do
        Assert.AreEqual(List[Idx], NewList[Idx], 'List[Idx] isn''t equal to NewList[Idx]!');
  finally
    { (5) Release NewList. }
    NewList.Free;
  end;
end;

procedure TBasicClasses_TIntegerList_TestCase.Test_ChainToString;
const
  ValidString: String = '1, 2, 3, 4, 5, 6, 7, 8, 9, 10';
var
  Idx: SizeUInt;
begin
  { (1.1) Prepare our list by adding 10 items. }
  for Idx := 1 to 10 do
    List.Add(TIntItem(Idx));

  { (2) Compare generated string with ValidString. Both should be equal. }
  Assert.AreEqual(ValidString, List.ChainToString, 'List.ChainToString returned invalid value!');
end;

procedure TBasicClasses_TIntegerList_TestCase.Test_CopyFrom;
var
  NewList: TIntegerList;
  Idx: SizeUInt;
begin
  { (1) Prepare our list by adding 40 items. }
  for Idx := 1 to 40 do
    List.Add(TIntItem(Idx));

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
      Assert.AreEqual(List[Idx], NewList[Idx], 'List[Idx] isn''t equal to NewList[Idx]!');
  finally
    { (7) Finally release NewList. }
    NewList.Free;
  end;
end;

procedure TBasicClasses_TIntegerList_TestCase.Test_Creation;
begin
  Assert.AreEqual(Cardinal(0), Cardinal(List.Capacity), 'List.Capacity isn''t equal to 0!');
  Assert.AreEqual(Cardinal(0), Cardinal(List.Count), 'List.Count isn''t equal to 0!');
end;

procedure TBasicClasses_TIntegerList_TestCase.Test_Enumerator;
var
  Idx: Integer;
  It: TIntegerList.TEnumerator;
  RevIt: TIntegerList.TReverseEnumerator;
begin
  { (1) Prepare our list by adding 200 items. }
  for Idx := 1 to 100 do
    List.Add(TIntItem(Idx));

  { (2) Create enumerator and test it. }
  It := List.GetEnumerator;
  try
    Idx := 1;

    while It.MoveNext do
    begin
      Assert.AreEqual(Idx, Integer(It.Current), 'It.Current isn''t equal to Idx which is equal to ' + Idx.ToString + '!');
      Inc(Idx);
    end;
  finally
    It.Free;
  end;

  { (3) Create reverse enumerator and test it. }
  RevIt := List.GetReverseEnumerator;
  try
    Idx := 100;

    while RevIt.MoveNext do
    begin
      Assert.AreEqual(Idx, Integer(RevIt.Current), 'RevIt.Current isn''t equal to Idx which is equal to ' + Idx.ToString + '!');
      Dec(Idx);
    end;
  finally
    RevIt.Free;
  end;
end;

procedure TBasicClasses_TIntegerList_TestCase.Test_Exchange;
var
  Idx: SizeUInt;
  I: SizeUInt;
begin
  { (1.1) Prepare our list by adding 100 items. }
  for I := 1 to 100 do
  begin
    Idx := List.Add(TIntItem(I));

    { (1.2) Check that item was added properly and that item in the list have
            proper value. }
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(TIntItem(I)) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx]), 'List[Idx] item value is invalid!');
  end;

  { (2) Exchange 2 items and validate operation. }
  List.Exchange(0, 99);
  Assert.AreEqual(Integer(100), Integer(List[0]), 'Integer(List[0]) isn''t equal to 100!');
  Assert.AreEqual(Integer(1), Integer(List[99]), 'Integer(List[99]) isn''t equal to 1!');
end;

procedure TBasicClasses_TIntegerList_TestCase.Test_Exists;
var
  Idx: SizeUInt;
begin
  { (1) Prepare our list by adding 100 items. }
  for Idx := 1 to 100 do
    List.Add(TIntItem(Idx));

  { (2) Check existance of item with value 39. }
  Assert.IsTrue(List.Exists(TIntItem(39)), 'List.Exists(TIntItem(39)) doesn''t exists!');
end;

procedure TBasicClasses_TIntegerList_TestCase.Test_Extract;
var
  Item: TIntItem;
  pItem: PIntItem;
  I, Idx: SizeUInt;
begin
  { (1.1) Prepare our list by adding 100 items: }
  for I := 1 to 100 do
  begin
    Idx := List.Add(TIntItem(I));

    { (1.2) Check that item was added properly and that item in the list have
            proper value. }
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(TIntItem(I)) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx]), 'List[Idx] item value is invalid!');
  end;

  { (2) Retrieve item from position (index) 49. }
  Item := List[49];

  { (3) Extract item from the list. }
  pItem := List.Extract(Item);

  { (4) If extracted item isn't equal to nil, verify that item was deleted from
        the list. }
  Assert.areNotEqual<PIntItem>(nil, pItem, 'List.Extract(pItem) returned nil!');
  if (pItem <> nil) then
  begin
    Assert.AreEqual(Cardinal(99), Cardinal(List.Count), 'List.Count isn''t equal to 99!');
    Assert.AreNotEqual(Integer(50), Integer(List[49]), 'List[49] is equal to 50!');
  end;

  { (5) Retrieve item from position (index) 24. }
  Item := List[24];

  { (6) Extract item from the list using FromEnd direction. }
  pItem := List.ExtractItem(Item, FromEnd);

  { (7) If extracted item isn't equal to nil, verify that item was deleted from
        the list. }
  Assert.AreNotEqual<PIntItem>(nil, pItem, 'List.ExtractItem(Item, FromEnd) returned nil!');
  if (pItem <> nil) then
  begin
    Assert.AreEqual(Cardinal(98), Cardinal(List.Count), 'List.Count isn''t equal to 98!');
    Assert.AreNotEqual(Integer(25), Integer(List[24]), 'List[24] is equal to 25!');
  end;
end;

procedure TBasicClasses_TIntegerList_TestCase.Test_FirstAndLast;
var
  I: SizeUInt;
begin
  { (1) Prepare our list by adding 100 items. }
  for I := 1 to 100 do
    List.Add(TIntItem(I));

  { (2) Check that List.First and List.Last points to valid items in the list. }
  Assert.AreEqual(Integer(1), Integer(PIntItem(List.First)^), 'List.First^ isn''t equal to 1!');
  Assert.AreEqual(Integer(100), Integer(PIntItem(List.Last)^), 'List.Last^ isn''t equal to 100!');
  Assert.AreEqual(Cardinal(0), Cardinal(List.LowIndex), 'List.LowIndex isn''t equal to 0!');
  Assert.AreEqual(Cardinal(99), Cardinal(List.HighIndex), 'List.HighIndex isn''t equal to 99!');

  { (3) Delete last item from the list. }
  List.Delete(List.HighIndex);

  { (4) Check again that List.Last point to the last item in the list which now
        is different than last time. }
  Assert.AreEqual(Integer(99), Integer(PIntItem(List.Last)^), 'List.Last^ isn''t equal to 99!');
end;

procedure TBasicClasses_TIntegerList_TestCase.Test_IndexOf;
var
  Item: TIntItem;
  I: SizeUInt;
begin
  { (1) Prepare our list by adding 100 items. }
  for I := 1 to 100 do
    List.Add(TIntItem(I));

  { (2) Retrieve List[36] entry. }
  Item := List[36];

  { (3) Check that retrieved item is valid. }
  Assert.AreEqual(Integer(37), Integer(Item), 'List[36] isn''t equal to 37!');

  { (4) Now check List.IndexOf() and List IndexOfItem() methods. }
  Assert.AreEqual(Cardinal(36), Cardinal(List.IndexOf(Item)), 'List.IndexOf(Item) didn''t return 36!');
  Assert.AreEqual(Cardinal(36), Cardinal(List.IndexOfItem(Item, FromEnd)), 'List.IndexOfItem(Item, FromEnd) didn''t return 36!');
end;

procedure TBasicClasses_TIntegerList_TestCase.Test_Insert;
var
  I, Idx: SizeUInt;
begin
  { (1.1) Prepare our list by adding 100 items. }
  for I := 1 to 100 do
  begin
    Idx := List.Add(TIntItem(I));

    { (1.2) Check that item was added properly and that item in the list have
            proper value. }
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(Item) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx]), 'List[Idx] item value is invalid!');
  end;

  { (2) Prepare our list by inserting 100 items to position (index) 50. }
  for I := 1 to 100 do
    List.Insert(50, TIntItem(I));

  { (3) Check that there was actualy proper entry insertion in the list. }
  Assert.AreEqual(Cardinal(200), Cardinal(List.Count), 'List.Count isn''t equal to 200!');
  Assert.AreEqual(Integer(50), Integer(List[49]), 'List[49] isn''t equal to 50!');
  Assert.AreEqual(Integer(100), Integer(List[50]), 'List[50]) isn''t equal to 100!');
end;

procedure TBasicClasses_TIntegerList_TestCase.Test_Move;
var
  I, Idx: SizeUInt;
begin
  { (1.1) Prepare our list by adding 100 items. }
  for I := 1 to 100 do
  begin
    Idx := List.Add(TIntItem(I));

    { (1.2) Check that item was added properly and that item in the list have
            proper value. }
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(Item) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx]), 'List[Idx] item value is invalid!');
  end;

  { (2) Move item from position (index) 10 to 90. }
  List.Move(10, 90);

  { (3) Check that there was proper move operation. }
  Assert.AreNotEqual(Integer(11), Integer(List[10]), 'List[10] is equal to 11!');
  Assert.AreEqual(Integer(11), Integer(List[90]), 'List[90] isn''t equal to 11!');
end;

procedure TBasicClasses_TIntegerList_TestCase.Test_RemoveDuplicates;
var
  Idx: SizeUInt;
begin
  { (1) Prepare our list by adding some duplicated items. }
  for Idx := 1 to 8 do
    List.Add(TIntItem(9));

  for Idx := 1 to 4 do
    List.Add(TIntItem(73));

  for Idx := 1 to 7 do
    List.Add(TIntItem(49));

  { (2) Shuffle list entries for better randomization. }
  List.Shuffle;

  { (3) Remove duplicates and verify that operation was correct. }
  Assert.AreEqual(Integer(19), Integer(List.Count), 'List.Count isn''t equal to 19!');
  List.RemoveDuplicates;
  Assert.AreEqual(Integer(3), Integer(List.Count), 'List.Count isn''t equal to 3!');
end;

procedure TBasicClasses_TIntegerList_TestCase.Test_RemoveItems;
var
  Item: TIntItem;
  I, Idx: SizeUInt;
begin
  { (1.1) Prepare our list by adding 200 items. }
  for I := 1 to 200 do
  begin
    { (1.2) Add new item to the list. }
    Idx := List.Add(TIntItem(I));

    { (1.3) Check that item was added properly and that item in the list have
            proper value. }
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(TIntItem(I)) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx]), 'List[Idx] item value is invalid!');
  end;

  { (2.1) Set List ShinkMode to smNormal and ShrinkLimit to 100. }
  List.ShrinkMode := smNormal;
  List.ShrinkLimit := 100;

  { (2.2) Loop from 1 to 180 for check of list's capacity shinkage: }
  for I := 1 to 180 do
  begin
    { (2.3) Delete entry at 0 position (index). }
    List.Delete(0);

    { (2.4) Depending on amount already removed, check List.Capacity values. }
    if (200 - I = 64) then
      Assert.AreEqual(Cardinal(256), Cardinal(List.Capacity), 'List.Capacity isn''t equal 256!');
    if (200 - I = 63) then
      Assert.AreEqual(Cardinal(128), Cardinal(List.Capacity), 'List.Capacity isn''t equal 128!');
    if (200 - I = 32) then
      Assert.AreEqual(Cardinal(128), Cardinal(List.Capacity), 'List.Capacity isn''t equal 128!');
    if (200 - I = 31) then
      Assert.AreEqual(Cardinal(64), Cardinal(List.Capacity), 'List.Capacity isn''t equal 64!');
  end;

  { (3) Clear the list. }
  List.Clear;

  { (4.1) Prepare our list by adding 200 items. }
  for I := 1 to 200 do
  begin
    { (4.2) Add new item to the list. }
    Idx := List.Add(TIntItem(I));

    { (4.3) Check that item was added propery and that item in the list have
            proper value. }
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(TIntItem(I)) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx]), 'List[Idx] item value is invalid!');
  end;

  { (5) Set list ShrinkMode to smToCount. }
  List.ShrinkMode := smToCount;

  { (6.1) Loop from 1 to 100 for check of list's capacity shrinkage: }
  for I := 1 to 100 do
  begin
    { (6.2) Delete entry at 0 position (index). }
    if (List.Count > 1) then
      List.Delete(0);

    { (6.3) Depending on amount already removed, check List.Capacity values. }
    Assert.AreEqual(Cardinal(List.Count), Cardinal(List.Capacity), 'List.Capacity isn''t equal to ' + IntToStr(List.Count) + '!');
  end;

  { (7) Clear the list. }
  List.Clear;

  { (8.1) Prepare our list by adding 200 items. }
  for I := 1 to 200 do
  begin
    { (8.2) Add new item to the list. }
    Idx := List.Add(TIntItem(I));

    { (8.3) Check that item was added properly and that item in the list have
            proper value. }
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(TIntItem(I)) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx]), 'List[Idx] item value is invalid!');
  end;

  { (9) Set list ShrinkMode to smKeepCap. }
  List.ShrinkMode := smKeepCap;

  { (10.1) Loop from 1 to 100 for check of list's capacity shrinkage: }
  for I := 1 to 100 do
  begin
    { (10.2) Delete last entry of the list. }
    if (List.Count > 0) then
      List.Delete(List.Count - 1);

    { (10.3) Depending on amount already removed, check List.Capacity values. }
    Assert.AreEqual(Cardinal(256), Cardinal(List.Capacity), 'List.Capacity isn''t equal to 256!');
  end;

  { (11) Clear the list. }
  List.Clear;

  { (12.1) Prepare our list by adding 200 items. }
  for I := 1 to 200 do
  begin
    { (12.2) Add new item to the list. }
    Idx := List.Add(TIntItem(I));

    { (12.3) Check that item was added properly and that item in the list have
             proper value. }
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(TIntItem(I)) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx]), 'List[Idx] item value is invalid!');
  end;

  { (13) Check removal by Remove() method. }
  for I := 1 to 10 do
  begin
    Item := List[123];
    Assert.AreEqual(Cardinal(123), Cardinal(List.Remove(Item)), 'List.Remove(Item) returned value not equal to 123!');
  end;

  { (14) Clear the list. }
  List.Clear;

  { (15.1) Prepare our list by adding 200 items. }
  for I := 1 to 200 do
  begin
    { (15.2) Add new item to the list. }
    Idx := List.Add(TIntItem(I));

    { (15.3) Check that item was added properly and that item in the list have
             proper value. }
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(TIntItem(I)) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx]), 'List[Idx] item value is invalid!');
  end;

  { (16) Check removal by RemoveItem() method with FromEnd direction. }
  for I := 1 to 10 do
  begin
    Item := List[123];
    Assert.AreEqual(Cardinal(123), Cardinal(List.RemoveItem(Item, FromEnd)), 'List.RemoveItem(Item, FromEnd) returned value not equal to 123!');
  end;
end;

procedure TBasicClasses_TIntegerList_TestCase.Test_SameAs;
var
  List2: TIntegerList;
  Idx: SizeUInt;
begin
  { (1) Create List2 and set NeedRelease flag to True. }
  List2 := TIntegerList.Create;
  try
    List2.NeedRelease := True;

    { (2) Prepare two list with identical entries. }
    for Idx := 1 to 100 do
    begin
      List.Add(TIntItem(Idx));
      List2.Add(TIntItem(Idx));
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

function TIntItem_CompareFunc(Item1, Item2: Pointer): Integer;
begin
  Result := PIntItem(Item1)^ - PIntItem(Item2)^;
end;

procedure TBasicClasses_TIntegerList_TestCase.Test_Sort;
var
  Idx: SizeUInt;
begin
  { (1) Prepare our list by adding 200 random values. }
  for Idx := 0 to 200 do
    List.Add(TIntItem(Random(200)));

  { (2) Sort the list. }
  List.Sort(TIntItem_CompareFunc);

  { (3) Make sure that items were sorted. }
  for Idx := List.LowIndex to (List.HighIndex - 1) do
    Assert.IsTrue(Integer(List[Idx]) <= Integer(List[Idx + 1]), 'List[' + Idx.ToString + '] <= List[' + SizeUInt(Idx + 1).ToString + '] condition failed!');
end;

procedure TBasicClasses_TIntegerList_TestCase.Test_Values;
var
  Idx: SizeUInt;
begin
  { (1) Prepare our list by adding 100 items. }
  for Idx := 1 to 100 do
    List.Add(TIntItem(Idx));

  { (2) Check List.ValuesMin calculation. }
  Assert.AreEqual(Integer(1), Integer(List.ValuesMin), 'List.ValuesMin isn''t equal to 1!');

  { (3) Check List.ValuesMax calculation. }
  Assert.AreEqual(Integer(100), Integer(List.ValuesMax), 'List.ValuesMax isn''t equal to 100!');

  { (4) Check List.ValuesSum calculation. }
  Assert.AreEqual(Integer(5050), Integer(List.ValuesSum), 'List.ValuesSum isn''t equal to 5050!');

  { (5) Check List.ValuesAvg calculation. }
  Assert.AreEqual(Integer(50), Integer(List.ValuesAvg), 'List.ValuesAvg isn''t equal to 50!');
end;

{ TBasicClasses_TIntegerProbabilityList_TestCase - class implementation }

procedure TBasicClasses_TIntegerProbabilityList_TestCase.Setup;
begin
  { (1) Create the List. }
  List := TIntegerProbabilityList.Create;

  { (2) Set NeedRelease flag to True. }
  List.NeedRelease := True;
end;

procedure TBasicClasses_TIntegerProbabilityList_TestCase.TearDown;
begin
  { (1) Clear the List. }
  List.Clear;

  { (2) Free the List. }
  List.Free;
  List := nil;
end;

procedure TBasicClasses_TIntegerProbabilityList_TestCase.Test_AddItems;
var
  I, Idx: SizeUInt;
begin
  { (1) Set List GrowMode to gmFast. }
  List.GrowMode := gmFast;

  { (2.1) Prepare our list by adding 100 items and check list's capacity
          growage: }
  for I := 1 to 100 do
  begin
    { (2.2) Add new item to the list and store its position (index) in Idx. }
    Idx := List.Add(TIntProbValue(I), 1.0);

    { (2.3) Check that item was added properly and that item in the list have
            proper value. }
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(TIntProbValue(I), 1.0) retured invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx].Value), 'List[Idx].Value isn''t equal to ' + I.ToString + '!');

    { (2.4) Depending on amount already added, check List.Capacity values. }
    if (I = 32) then
      Assert.AreEqual(Cardinal(32), Cardinal(List.Capacity), 'List.Capacity isn''t equal to 32!');
    if (I = 33) then
      Assert.AreEqual(Cardinal(64), Cardinal(List.Capacity), 'List.Capacity isn''t equal to 64!');
    if (I = 64) then
      Assert.AreEqual(Cardinal(64), Cardinal(List.Capacity), 'List.Capacity isn''t equal to 64!');
    if (I = 65) then
      Assert.AreEqual(Cardinal(128), Cardinal(List.Capacity), 'List.Capacity isn''t equal to 128!');
  end;

  { (3) Clear the list. }
  List.Clear;

  { (4) Set List GrowMode to gmSlow. }
  List.GrowMode := gmSlow;

  { (5.1) Prepare our list by adding 100 items and check list's capacity
          growage: }
  for I := 1 to 100 do
  begin
    { (5.2) Add new item to the list and store its position (index) in Idx. }
    Idx := List.Add(TIntProbValue(I), 1.0);

    { (5.3) Check that item was added properly and that item in the list have
            proper value. }
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(TIntProbValue(I), 1.0) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx].Value), 'List[Idx].Value isn''t equal to ' + I.ToString + '!');

    { (5.4) Depending on amount already added, check List.Capacity values. }
    if (I > 32) then
      Assert.AreEqual(Cardinal(I), Cardinal(List.Capacity), 'List.Capacity isn''t equal to ' + I.ToString + '!')
    else
      Assert.AreEqual(Cardinal(32), Cardinal(List.Capacity), 'List.Capacity isn''t equal to 32!');
  end;

  { (6) Clear the list. }
  List.Clear;

  { (7) Set List GrowMode to gmLinear and GrowFactor to 2.0. }
  List.GrowMode := gmLinear;
  List.GrowFactor := 2.0;

  { (8.1) Prepare our list by adding 100 items and check list's capacity
          growage: }
  for I := 1 to 100 do
  begin
    { (8.2) Add new item to the list and store its position (index) in Idx. }
    Idx := List.Add(TIntProbValue(I), 1.0);

    { (8.3) Check that item was added properly and that item in the list have
            proper value. }
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(TIntProbValue(I), 1.0) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx].Value), 'List[Idx].Value isn''t equal to ' + I.ToString + '!');

    { (8.4) Depending on amount already added, check List.Capacity values. }
    if (I = 64) then
      Assert.AreEqual(Cardinal(64), Cardinal(List.Capacity), 'List.Capacity isn''t equal to 64!');
    if (I = 65) then
      Assert.AreEqual(Cardinal(66), Cardinal(List.Capacity), 'List.Capacity isn''t equal to 66!');
    if (I = 86) then
      Assert.AreEqual(Cardinal(86), Cardinal(List.Capacity), 'List.Capacity isn''t equal to 86!');
    if (I = 87) then
      Assert.AreEqual(Cardinal(88), Cardinal(List.Capacity), 'List.Capacity isn''t equal to 88!');
  end;

  { (9) Clear the list. }
  List.Clear;

  { (10) Set List GrowMode to gmFastAttenuated and GrowLimit to 64. }
  List.GrowMode := gmFastAttenuated;
  List.GrowLimit := 64;

  { (11.1) Prepare our list by adding 100 items and check list's capacity
           growage: }
  for I := 1 to 100 do
  begin
    { (11.2) Add new item to the list and store its position (index) in Idx. }
    Idx := List.Add(TIntProbValue(I), 1.0);

    { (11.3) Check that item was added properly and that item in the list have
            proper value. }
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(TIntProbValue(I), 1.0) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx].Value), 'List[Idx].Value isn''t equal to ' + I.ToString + '!');

    { (11.4) Depending on amount already added, check List.Capacity values. }
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

procedure TBasicClasses_TIntegerProbabilityList_TestCase.Test_Assign;
var
  NewList: TIntegerProbabilityList;
  Idx: SizeUInt;
begin
  { (1) Add 6 items to the list. }
  for Idx := 1 to 6 do
    List.Add(TIntProbValue(Idx), 1.0);

  { (2) Shuffle list. }
  List.BestShuffle;

  { (3) Create and assign List to NewList. Mark that NewList shouldn't release
        its items. }
  NewList := TIntegerProbabilityList.Create;
  try
    NewList.Assign(List);

    NewList.NeedRelease := False;

    { (4) Compare both list. They should be equal. }
    Assert.IsTrue(List.SameAs(NewList), 'List isn''t equal to NewList!');
  finally
    { (5) Release NewList. }
    NewList.Free;
  end;
end;

procedure TBasicClasses_TIntegerProbabilityList_TestCase.Test_CopyFrom;
var
  NewList: TIntegerProbabilityList;
  Idx: SizeUInt;
begin
  { (1) Prepare our list by adding 40 items. }
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

procedure TBasicClasses_TIntegerProbabilityList_TestCase.Test_Creation;
begin
  Assert.AreEqual(Cardinal(0), Cardinal(List.Capacity), 'List.Capacity isn''t 0!');
  Assert.AreEqual(Cardinal(0), Cardinal(List.Count), 'List.Count isn''t 0!');
end;

procedure TBasicClasses_TIntegerProbabilityList_TestCase.Test_Enumerator;
var
  Idx: Integer;
  It: TIntegerProbabilityList.TEnumerator;
  RevIt: TIntegerProbabilityList.TReverseEnumerator;
begin
  { (1) Prepare our list by adding 200 items. }
  for Idx := 1 to 100 do
    List.Add(TIntProbValue(Idx), 1.0);

  { (2.1) Retrieve enumerator and test it. }
  It := List.GetEnumerator;
  try
    Idx := 1;

    while It.MoveNext do
    begin
      Assert.AreEqual(Idx, Integer(It.Current.Value), 'It.Current.Value isn''t equal to Idx which is equal to ' + Idx.ToString + '!');
      Inc(Idx);
    end;
  finally
    { (2.2) Finally release retrieved enumerator. }
    It.Free;
  end;

  { (3.1) Retrieve reverse enumerator and test it. }
  RevIt := List.GetReverseEnumerator;
  try
    Idx := 100;

    while RevIt.MoveNext do
    begin
      Assert.AreEqual(Idx, Integer(RevIt.Current.Value), 'RevIt.Current.Value isn''t equal to Idx which is equal to ' + Idx.ToString + '!');
      Dec(Idx);
    end;
  finally
    { (3.2) Finally release retrieved enumerator. }
    RevIt.Free;
  end;
end;

procedure TBasicClasses_TIntegerProbabilityList_TestCase.Test_Exchange;
var
  Idx, I: SizeUInt;
begin
  { (1.1) Prepare our list by adding 100 items: }
  for I := 1 to 100 do
  begin
    { (1.2) Add new item to the list. }
    Idx := List.Add(TIntProbValue(I), 1.0);

    { (1.3) Check that item was added properly and that item in the list have
            proper value. }
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(TIntItem(I)) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx].Value), 'List[Idx].Value is invalid!');
  end;

  { (2) Exchange 2 items and validate. }
  List.Exchange(0, 99);

  { (3) Check that exchange operation was successful. }
  Assert.AreEqual(Integer(100), Integer(List[0].Value), 'Integer(List[0].Value) isn''t equal to 100!');
  Assert.AreEqual(Integer(1), Integer(List[99].Value), 'Integer(List[99].Value) isn''t equal to 1!');
end;

procedure TBasicClasses_TIntegerProbabilityList_TestCase.Test_Exists;
var
  Idx: SizeUInt;
  Item: TIntegerProbabilityList.TIntProbItem;
begin
  { (1) Prepare our list by adding 100 items. }
  for Idx := 1 to 100 do
    List.Add(TIntProbValue(Idx), 1.0);

  { (2) Retrieve List[38] item. }
  Item := List[38];

  { (3) Check existance of item from List[38]. }
  Assert.IsTrue(List.Exists(Item), 'List.Exists(Item) doesn''t exists!');
end;

procedure TBasicClasses_TIntegerProbabilityList_TestCase.Test_Extract;
var
  Item: TIntegerProbabilityList.TIntProbItem;
  pItem: TIntegerProbabilityList.PIntProbItem;
  I, Idx: SizeUInt;
begin
  { (1.1) Prepare our list by adding 100 items: }
  for I := 1 to 100 do
  begin
    { (1.2) Add new item to the list. }
    Idx := List.Add(TIntProbValue(I), 1.0);

    { (1.3) Check that item was added properly and that item in the list have
            proper value. }
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(TIntProbValue(I), 1.0) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx].Value), 'List[Idx].Value is invalid!');
  end;

  { (2) Retrieve item from position (index) 49. }
  Item := List[49];

  { (3) Extract item from the list. }
  pItem := List.Extract(Item);

  { (4) If extracted item isn't equal to nil, verify that item was deleted from
        the list. }
  Assert.AreNotEqual<TIntegerProbabilityList.PIntProbItem>(nil, pItem, 'List.Extract(Item) returned nil!');
  if (pItem <> nil) then
  begin
    Assert.AreEqual(Cardinal(99), Cardinal(List.Count), 'List.Count isn''t equal to 99!');
    Assert.AreNotEqual(Integer(50), Integer(List[49].Value), 'List[49].Value is equal to 50!');
  end;

  { (5) Retrieve item from position (index) 24. }
  Item := List[24];

  { (6) Extract item from the list using FromEnd direction. }
  pItem := List.ExtractItem(Item, FromEnd);

  { (7) If extracted item isn't equal to nil, verify that item was deleted from
        the list. }
  Assert.AreNotEqual<TIntegerProbabilityList.PIntProbItem>(nil, pItem, 'List.ExtractItem(Item, FromEnd) returned nil!');
  if (pItem <> nil) then
  begin
    Assert.AreEqual(Cardinal(98), Cardinal(List.Count), 'List.Count isn''t equal to 98!');
    Assert.AreNotEqual(Integer(25), Integer(List[24].Value), 'List[24].Value is equal to 25!');
  end;

  { (8) Extract item from the list by it's value. }
  pItem := List.Extract(TIntProbValue(51));

  { (9) If extracted item isn't equal to nil, verify that item was deleted from
        the list. }
  Assert.AreNotEqual<TIntegerProbabilityList.PIntProbItem>(nil, pItem, 'List.Extract(TIntProbValue(51)) returned nil!');
  if (pItem <> nil) then
    Assert.AreEqual(Cardinal(97), Cardinal(List.Count), 'List.Count isn''t equal to 97!');

  { (10) Extract item from the list by it's value. }
  pItem := List.ExtractItem(TIntProbValue(26), FromEnd);

  { (11) If extracted item isn't equal to nil, verify that item was deleted from
         the list. }
  Assert.AreNotEqual<TIntegerProbabilityList.PIntProbItem>(nil, pItem, 'List.ExtractItem(TIntProbValue(26), FromEnd) returned nil!');
  if (pItem <> nil) then
    Assert.AreEqual(Cardinal(96), Cardinal(List.Count), 'List.Count isn''t equal to 96!');
end;

procedure TBasicClasses_TIntegerProbabilityList_TestCase.Test_FirstAndLast;
var
  I: SizeUInt;
begin
  { (1) Prepare our list by adding 100 items. }
  for I := 1 to 100 do
    List.Add(TIntProbValue(I), 1.0);

  { (2) Check that List.First and List.Last points to proper entries. }
  Assert.AreEqual(Integer(1), Integer(TIntProbValue(List.First^.Value)), 'List.First^.Value isn''t equal to 1!');
  Assert.AreEqual(Integer(100), Integer(TIntProbValue(List.Last^.Value)), 'List.Last^.Value isn''t equal to 100!');

  { (3) Check that List.LowIndex and List.HighIndex are valid. }
  Assert.AreEqual(Cardinal(0), Cardinal(List.LowIndex), 'List.LowIndex isn''t equal to 0!');
  Assert.AreEqual(Cardinal(99), Cardinal(List.HighIndex), 'List.HighIndex isn''t equal to 99!');

  { (4) Delete last entry in the list. }
  List.Delete(List.HighIndex);

  { (5) Check again that List.Last points to proper entry. }
  Assert.AreEqual(Integer(99), Integer(TIntProbValue(List.Last^.Value)), 'List.Last^ isn''t equal to 99!');
end;

procedure TBasicClasses_TIntegerProbabilityList_TestCase.Test_IndexOf;
var
  Item: TIntegerProbabilityList.TIntProbItem;
  I: SizeUInt;
begin
  { (1) Prepare our list by adding 100 items. }
  for I := 1 to 100 do
    List.Add(TIntProbValue(I), 1.0);

  { (2) Verify that all variants of IndexOf and IndexOfItem works. }
  Item := List[36];

  Assert.AreEqual(Integer(37), Integer(Item.Value), 'List[36].Value isn''t equal to 37!');

  Assert.AreEqual(Cardinal(36), Cardinal(List.IndexOf(Item)), 'List.IndexOf(Item) didn''t returned 36!');
  Assert.AreEqual(Cardinal(36), Cardinal(List.IndexOfItem(Item, FromEnd)), 'List.IndexOfItem(Item, FromEnd) didn''t returned 36!');
  Assert.AreEqual(Cardinal(36), Cardinal(List.IndexOf(Item.Value)), 'List.IndexOf(Item.Value) didn''t returned 36!');
  Assert.AreEqual(Cardinal(36), Cardinal(List.IndexOfItem(Item.Value, FromEnd)), 'List.IndexOfItem(Item.Value, FromEnd) didn''t returned 36!');
end;

procedure TBasicClasses_TIntegerProbabilityList_TestCase.Test_Insert;
var
  I, Idx: SizeUInt;
begin
  { (1.1) Prepare our list by adding 100 items: }
  for I := 1 to 100 do
  begin
    { (1.2) Add new item to the list. }
    Idx := List.Add(TIntProbValue(I), 1.0);

    { (1.3) Check that item was added properly and that item in the list have
            proper value. }
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(TIntProbValue(I), 1.0) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx].Value), 'List[Idx].Value is invalid!');
  end;

  { (2) Prepare our list by inserting 100 items to position (index) 50. }
  for I := 1 to 100 do
    List.Insert(50, TIntProbValue(I), 1.0);

  { (3) Check that insertion operation was successful. }
  Assert.AreEqual(Cardinal(200), Cardinal(List.Count), 'List.Count isn''t equal to 200!');
  Assert.AreEqual(Integer(50), Integer(List[49].Value), 'List[49].Value isn''t equal to 50!');
  Assert.AreEqual(Integer(100), Integer(List[50].Value), 'List[50].Value isn''t equal to 100!');
end;

procedure TBasicClasses_TIntegerProbabilityList_TestCase.Test_Move;
var
  I, Idx: SizeUInt;
begin
  { (1.1) Prepare our list by adding 100 items: }
  for I := 1 to 100 do
  begin
    { (1.2) Add new item to the list. }
    Idx := List.Add(TIntProbValue(I), 1.0);

    { (1.3) Check that item was added properly and that item in the list have
            proper value. }
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(TIntProbValue(I), 1.0) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx].Value), 'List[Idx].Value is invalid!');
  end;

  { (2) Move item from position (index) 10 to 90. }
  List.Move(10, 90);

  { (3) Check that move operation was successful. }
  Assert.AreNotEqual(Integer(11), Integer(List[10].Value), 'List[10].Value is equal to 11!');
  Assert.AreEqual(Integer(11), Integer(List[90].Value), 'List[90].Value isn''t equal to 11!');
end;

procedure TBasicClasses_TIntegerProbabilityList_TestCase.Test_NormalizeProbabilities;
begin
  { (1) Prepare our list by adding 10 items. }
  List.Add(TIntProbValue(1), 0.25);
  List.Add(TIntProbValue(2), 0.36);
  List.Add(TIntProbValue(3), 0.48);
  List.Add(TIntProbValue(4), 0.96);
  List.Add(TIntProbValue(5), 0.98);
  List.Add(TIntProbValue(6), 0.68);
  List.Add(TIntProbValue(7), 0.73);
  List.Add(TIntProbValue(8), 0.82);
  List.Add(TIntProbValue(9), 0.59);
  List.Add(TIntProbValue(10), 2.34);

  { (2) Normalize probabilities of the list. }
  List.NormalizeProbabilities;

  { (3) Check that probabilities was normalized. }
  Assert.AreEqual(0.031, List[0].Probability, 0.001, 'List[0].Probability isn''t equal to 0.031!');
  Assert.AreEqual(0.044, List[1].Probability, 0.001, 'List[1].Probability isn''t equal to 0.044!');
  Assert.AreEqual(0.059, List[2].Probability, 0.001, 'List[2].Probability isn''t equal to 0.059!');
  Assert.AreEqual(0.117, List[3].Probability, 0.001, 'List[3].Probability isn''t equal to 0.117!');
  Assert.AreEqual(0.12,  List[4].Probability, 0.001, 'List[4].Probability isn''t equal to 0.12!');
  Assert.AreEqual(0.083, List[5].Probability, 0.001, 'List[5].Probability isn''t equal to 0.083!');
  Assert.AreEqual(0.089, List[6].Probability, 0.001, 'List[6].Probability isn''t equal to 0.089!');
  Assert.AreEqual(0.1,   List[7].Probability, 0.001, 'List[7].Probability isn''t equal to 0.1!');
  Assert.AreEqual(0.072, List[8].Probability, 0.001, 'List[8].Probability isn''t equal to 0.072!');
  Assert.AreEqual(0.286, List[9].Probability, 0.001, 'List[9].Probability isn''t equal to 0.286!');
end;

procedure TBasicClasses_TIntegerProbabilityList_TestCase.Test_RandomValue;
var
  Idx: SizeUInt;
begin
  { (1) Prepare our list by adding 100 items with random probability. }
  for Idx := 1 to 100 do
    List.Add(TIntProbValue(Idx), Random * 1.0);

  { (2) Loop from 0 to (List.Count - 1) and retrieve random value which is
        calculated from List probability and compare it with List entries.
        Retrieved values should be random, but they should ocupy the List. }
  for Idx := List.LowIndex to List.HighIndex do
    Assert.IsTrue(List.IndexOf(TIntProbValue(List.GetRandomValue)) <> -1, 'List.IndexOf(TIntProbValue(List.GetRandomValue)) returned -1!');

  { (3) Loop List.Count times and extract random value which is calculated
        from the List probability and search it within the List entries. Search
        result should be -1 becouse extracted random value shouldn't be in the
        List. }
  Idx := List.Count;
  while (Idx > 0) do
  begin
    Assert.IsFalse(List.IndexOf(TIntProbValue(List.ExtractRandomValue)) <> -1, 'List.IndexOf(TIntProbValue(List.ExtractRandomValue)) didn''t return -1!');
    Dec(Idx);
  end;

  { (4) Validate that List.Count is equal 0. }
  Assert.IsTrue(List.Count = 0, 'List.Count didn''t return 0!');
end;

procedure TBasicClasses_TIntegerProbabilityList_TestCase.Test_RemoveDuplicates;
var
  Idx: SizeUInt;
begin
  { (1) Prepare our list by adding some duplicated items. }
  for Idx := 1 to 8 do
    List.Add(TIntProbValue(9), 1.0);

  for Idx := 1 to 4 do
    List.Add(TIntProbValue(73), 1.0);

  for Idx := 1 to 7 do
    List.Add(TIntProbValue(49), 1.0);

  { (2) In addition, shuffle list entries. }
  List.Shuffle;

  { (3) Remove duplicates and verify that operation was correct. }
  Assert.AreEqual(Integer(19), Integer(List.Count), 'List.Count isn''t equal to 19!');
  List.RemoveDuplicates;
  Assert.AreEqual(Integer(3), Integer(List.Count), 'List.Count isn''t equal to 3!');
end;

procedure TBasicClasses_TIntegerProbabilityList_TestCase.Test_RemoveItems;
var
  Item: TIntegerProbabilityList.TIntProbItem;
  I, Idx: SizeUInt;
begin
  { (1.1) Prepare our list by adding 200 items: }
  for I := 1 to 200 do
  begin
    { (1.2) Add new item to the list. }
    Idx := List.Add(TIntProbValue(I), 1.0);

    { (1.3) Check that item was added properly and that item in the list have
            proper value. }
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(TIntItem(I)) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx].Value), 'List[Idx].Value is invalid!');
  end;

  { (2) Set List ShrinkMode to smNormal and ShrinkLimit to 100. }
  List.ShrinkMode := smNormal;
  List.ShrinkLimit := 100;

  { (3.1) Loop from 1 to 180 for check of list's capacity shinkage: }
  for I := 1 to 180 do
  begin
    { (3.2) Delete entry at 0 position (index). }
    List.Delete(0);

    { (3.3) Depending on amount already removed, check List.Capacity values. }
    if (200 - I = 64) then
      Assert.AreEqual(Cardinal(256), Cardinal(List.Capacity), 'List.Capacity isn''t equal 256!');
    if (200 - I = 63) then
      Assert.AreEqual(Cardinal(128), Cardinal(List.Capacity), 'List.Capacity isn''t equal 128!');
    if (200 - I = 32) then
      Assert.AreEqual(Cardinal(128), Cardinal(List.Capacity), 'List.Capacity isn''t equal 128!');
    if (200 - I = 31) then
      Assert.AreEqual(Cardinal(64), Cardinal(List.Capacity), 'List.Capacity isn''t equal 64!');
  end;

  { (4) Clear the list. }
  Assert.AreEqual(Cardinal(64), Cardinal(Length(List.List.List)), 'Length(List.List) isn''t equal to 64!');
  List.Clear;
  Assert.AreEqual(Cardinal(0), Cardinal(Length(List.List.List)), 'Length(List.List) isn''t equal to 0!');

  { (5.1) Prepare our list by adding 200 items: }
  for I := 1 to 200 do
  begin
    { (5.2) Add new item to the list. }
    Idx := List.Add(TIntProbValue(I), 1.0);

    { (5.3) Check that item was added properly and that item in the list have
            proper value. }
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(TIntItem(I)) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx].Value), 'List[Idx].Value is invalid!');
  end;

  { (5.4) Set List ShrinkMode to smToCount. }
  List.ShrinkMode := smToCount;

  { (6.1) Loop from 1 to 100 for check of list's capacity shinkage: }
  for I := 1 to 100 do
  begin
    { (6.2) Delete entry at 0 position (index). }
    if (List.Count > 1) then
      List.Delete(0);

    { (6.3) Depending on amount already removed, check List.Capacity values. }
    Assert.AreEqual(Cardinal(List.Count), Cardinal(List.Capacity), 'List.Capacity isn''t equal to ' + IntToStr(List.Count) + '!');
  end;

  { (7) Clear the list. }
  List.Clear;

  { (8.1) Prepare our list by adding 200 items: }
  for I := 1 to 200 do
  begin
    { (8.2) Add new item to the list. }
    Idx := List.Add(TIntProbValue(I), 1.0);

    { (8.3) Check that item was added properly and that item in the list have
            proper value. }
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(TIntItem(I)) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx].Value), 'List[Idx].Value is invalid!');
  end;

  { (9) Set List ShrinkMode to smKeepCap. }
  List.ShrinkMode := smKeepCap;

  { (10.1) Loop from 1 to 100 for check of list's capacity shinkage: }
  for I := 1 to 100 do
  begin
    { (11.2) Delete entry at 0 position (index). }
    if (List.Count > 0) then
      List.Delete(List.Count - 1);

    { (11.3) Depending on amount already removed, check List.Capacity values. }
    Assert.AreEqual(Cardinal(256), Cardinal(List.Capacity), 'List.Capacity isn''t equal to 256!');
  end;

  { (12) Clear the list. }
  List.Clear;

  { (13.1) Prepare our list by adding 200 items: }
  for I := 1 to 200 do
  begin
    { (13.2) Add new item to the list. }
    Idx := List.Add(TIntProbValue(I), 1.0);

    { (13.3) Check that item was added properly and that item in the list have
             proper value. }
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(TIntItem(I)) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx].Value), 'List[Idx].Value is invalid!');
  end;

  { (14) Check removal by Remove() method. }
  for I := 1 to 10 do
  begin
    Item := List[123];
    Assert.AreEqual(Cardinal(123), Cardinal(List.Remove(Item)), 'List.Remove(Item) returned value not equal to 123!');
  end;

  { (15) Clear the list. }
  List.Clear;

  { (16.1) Prepare our list by adding 200 items: }
  for I := 1 to 200 do
  begin
    { (16.2) Add new item to the list. }
    Idx := List.Add(TIntProbValue(I), 1.0);

    { (16.3) Check that item was added properly and that item in the list have
             proper value. }
    Assert.AreEqual(Cardinal(I - 1), Cardinal(Idx), 'List.Add(TIntItem(I)) returned invalid value!');
    Assert.AreEqual(Cardinal(I), Cardinal(List[Idx].Value), 'List[Idx].Value is invalid!');
  end;

  { (17) Check removal by RemoveItem() method with FromEnd direction. }
  for I := 1 to 10 do
  begin
    Item := List[123];
    Assert.AreEqual(Cardinal(123), Cardinal(List.RemoveItem(Item, FromEnd)), 'List.RemoveItem(Item, FromEnd) returned value not equal to 123!');
  end;
end;

procedure TBasicClasses_TIntegerProbabilityList_TestCase.Test_SameAs;
var
  List2: TIntegerProbabilityList;
  Idx: SizeUInt;
begin
  { (1) Create List2 and set NeedRelease flag to True. }
  List2 := TIntegerProbabilityList.Create;
  try
    List2.NeedRelease := True;

    { (2) Prepare two list with identical entries. }
    for Idx := 1 to 100 do
    begin
      List.Add(TIntProbValue(Idx), 1.0);
      List2.Add(TIntProbValue(Idx), 1.0);
    end;

    { (3) Compare both lists. They should have identical entries. }
    Assert.IsTrue(List.SameAs(List2), 'List isn''t the same as List2!');

    { (4) Clear List2 and prepare it again but now List2 should have different
          values. }
    List2.Clear;

    for Idx := 1 to 2000 do
      List2.Add(TIntProbValue(Random(500)), 1.0);

    { (5) Compare both list. They aren't identical. }
    Assert.IsFalse(List.SameAs(List2), 'List is the same as List2!');
  finally
    { (6) Finally release List2. }
    List2.Free;
  end;
end;

procedure TBasicClasses_TIntegerProbabilityList_TestCase.Test_ScaleProbability;
begin
  { (1) Prepare our list by adding 10 items. }
  List.Add(TIntProbValue(1), 0.5);
  List.Add(TIntProbValue(2), 0.4);
  List.Add(TIntProbValue(3), 0.3);
  List.Add(TIntProbValue(4), 0.2);
  List.Add(TIntProbValue(5), 0.1);
  List.Add(TIntProbValue(6), 0.6);
  List.Add(TIntProbValue(7), 0.7);
  List.Add(TIntProbValue(8), 0.8);
  List.Add(TIntProbValue(9), 0.9);
  List.Add(TIntProbValue(10), 1.0);

  { (2) Scale probability of single item in the list. }
  List.ScaleProbability(TIntProbValue(3), 0.5);

  { (3) Validate List[2].Probability value. }
  Assert.AreEqual(0.15, List[2].Probability, 0.001, 'List[2].Probability isn''t equal to 0.15!');

  { (4) Scale probability of all items in the list except one. }
  List.ScaleProbabilityExcept(TIntProbValue(8), 0.5);

  { (5) Validate all entries of the list except List[7].Probability. }
  Assert.AreEqual(0.25,  List[0].Probability, 0.001, 'List[0].Probability isn''t equal to 0.25!');
  Assert.AreEqual(0.2,   List[1].Probability, 0.001, 'List[0].Probability isn''t equal to 0.2!');
  Assert.AreEqual(0.075, List[2].Probability, 0.001, 'List[0].Probability isn''t equal to 0.075!');
  Assert.AreEqual(0.1,   List[3].Probability, 0.001, 'List[0].Probability isn''t equal to 0.1!');
  Assert.AreEqual(0.05,  List[4].Probability, 0.001, 'List[0].Probability isn''t equal to 0.05!');
  Assert.AreEqual(0.3,   List[5].Probability, 0.001, 'List[0].Probability isn''t equal to 0.3!');
  Assert.AreEqual(0.349, List[6].Probability, 0.001, 'List[0].Probability isn''t equal to 0.349!');
  Assert.AreEqual(0.8,   List[7].Probability, 0.001, 'List[0].Probability isn''t equal to 0.8!');
  Assert.AreEqual(0.449, List[8].Probability, 0.001, 'List[0].Probability isn''t equal to 0.449!');
  Assert.AreEqual(0.5,   List[9].Probability, 0.001, 'List[0].Probability isn''t equal to 0.5!');
end;

procedure TBasicClasses_TIntegerProbabilityList_TestCase.Test_SetProbability;
var
  Idx: SizeUInt;
begin
  { (1) Prepare our list by adding 10 items. }
  for Idx := 1 to 10 do
    List.Add(TIntProbValue(Idx), Random * 1.0);

  { (2) Set new probability values and validate that thouse values are set. }
  for Idx := 1 to 10 do
    List.Probability[TIntProbValue(Idx)] := Float(0.1 * Idx);

  { (3) Check that each entry' probability value was changed. }
  Assert.AreEqual(0.1, List[0].Probability, 0.1, 'List[0].Probability isn''t equal to 0.1!');
  Assert.AreEqual(0.2, List[1].Probability, 0.1, 'List[1].Probability isn''t equal to 0.2!');
  Assert.AreEqual(0.3, List[2].Probability, 0.1, 'List[2].Probability isn''t equal to 0.3!');
  Assert.AreEqual(0.4, List[3].Probability, 0.1, 'List[3].Probability isn''t equal to 0.4!');
  Assert.AreEqual(0.5, List[4].Probability, 0.1, 'List[4].Probability isn''t equal to 0.5!');
  Assert.AreEqual(0.6, List[5].Probability, 0.1, 'List[5].Probability isn''t equal to 0.6!');
  Assert.AreEqual(0.7, List[6].Probability, 0.1, 'List[6].Probability isn''t equal to 0.7!');
  Assert.AreEqual(0.8, List[7].Probability, 0.1, 'List[7].Probability isn''t equal to 0.8!');
  Assert.AreEqual(0.9, List[8].Probability, 0.1, 'List[8].Probability isn''t equal to 0.9!');
  Assert.AreEqual(1.0, List[9].Probability, 0.1, 'List[9].Probability isn''t equal to 1.0!');
end;

function TIntProbValue_CompareFunc(Item1, Item2: Pointer): Integer;
begin
  Result := TIntegerProbabilityList.PIntProbItem(Item1)^.Value - TIntegerProbabilityList.PIntProbItem(Item2)^.Value;
end;

procedure TBasicClasses_TIntegerProbabilityList_TestCase.Test_Sort;
var
  Idx: SizeUInt;
begin
  { (1) Prepare our list by adding 200 random values. }
  for Idx := 0 to 200 do
    List.Add(TIntProbValue(Random(200)), 1.0);

  { (2) In addition, shuffle the list for more random placement. }
  List.BestShuffle;

  { (3) Sort the list. }
  List.Sort(TIntProbValue_CompareFunc);

  { (4) Make sure that items were sorted. }
  for Idx := List.LowIndex to (List.HighIndex - 1) do
    Assert.IsTrue(Integer(List[Idx].Value) <= Integer(List[Idx + 1].Value), 'List[' + Idx.ToString + '].Value <= List[' + SizeUInt(Idx + 1).ToString + '].Value condition failed!');
end;

initialization
  TDUnitX.RegisterTestFixture(TBasicClasses_TBCList_TestCase, 'TBCList Test');
  TDUnitX.RegisterTestFixture(TBasicClasses_TIntegerList_TestCase, 'TIntegerList Test');
  TDUnitX.RegisterTestFixture(TBasicClasses_TIntegerProbabilityList_TestCase, 'TIntegerProbabilityList Test');

end.
