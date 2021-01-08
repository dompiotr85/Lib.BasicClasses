unit BasicClasses_Lists_TestCase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, BasicClasses.Lists;

type
  { TMyBCList - class definition }
  TMyBCList = class(TBCList)
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  end;

  { TBasicClasses_TBCList_TestCase - class definition }
  TBasicClasses_TBCList_TestCase = class(TTestCase)
  private
    List: TMyBCList;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    { Test methods }
    procedure Test_Creation;
    procedure Test_AddItems;
    procedure Test_RemoveItems;
    procedure Test_Exchange;
    procedure Test_Extract;
    procedure Test_FirstAndLast;
    procedure Test_IndexOf;
    procedure Test_Insert;
    procedure Test_Move;
    procedure Test_Sort;
    procedure Test_Enumerator;
    procedure Test_Assign;
  end;

  { TBasicClasses_TIntegerList_TestCase - class definition }
  TBasicClasses_TIntegerList_TestCase = class(TTestCase)
  private
    List: TIntegerList;
  protected
    procedure Setup; override;
    procedure TearDown; override;
  published
    { Test methods }
    procedure Test_Creation;
    procedure Test_AddItems;
    procedure Test_RemoveItems;
    procedure Test_Exchange;
    procedure Test_Extract;
    procedure Test_FirstAndLast;
    procedure Test_IndexOf;
    procedure Test_Insert;
    procedure Test_Move;
    procedure Test_Sort;
    procedure Test_Enumerator;
    procedure Test_Assign;
    procedure Test_CopyFrom;
    procedure Test_RemoveDuplicates;
    procedure Test_ChainToString;
    procedure Test_SameAs;
    procedure Test_Values;
    procedure Test_Exists;
  end;

  { TBasicClasses_TIntegerProbabilityList_TestCase - class definition }
  TBasicClasses_TIntegerProbabilityList_TestCase = class(TTestCase)
  private
    List: TIntegerProbabilityList;
  protected
    procedure Setup; override;
    procedure TearDown; override;
  published
    { Test methods }
    procedure Test_Creation;
    procedure Test_AddItems;
    procedure Test_RemoveItems;
    procedure Test_Exchange;
    procedure Test_Extract;
    procedure Test_FirstAndLast;
    procedure Test_IndexOf;
    procedure Test_Insert;
    procedure Test_Move;
    procedure Test_Sort;
    procedure Test_Enumerator;
    procedure Test_Assign;
    procedure Test_CopyFrom;
    procedure Test_RemoveDuplicates;
    procedure Test_SameAs;
    procedure Test_Exists;
    procedure Test_ScaleProbability;
    procedure Test_RandomValue;
    procedure Test_NormalizeProbabilities;
    procedure Test_SetProbability;
  end;

implementation

uses
  TypeDefinitions;

{ TMyBCList - class implementation }
procedure TMyBCList.Notify(Ptr: Pointer; Action: TListNotification);
begin
  if (Action = lnDeleted) then
    Dispose(PInteger(Ptr));
end;

{ TBasicClasses_TBCList_TestCase - class implementation }
procedure TBasicClasses_TBCList_TestCase.SetUp;
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

procedure TBasicClasses_TBCList_TestCase.Test_Creation;
begin
  AssertEquals('List.Capacity isn''t equal to 0!', Cardinal(0), Cardinal(List.Capacity));
  AssertEquals('List.Count isn''t equal to 0!', Cardinal(0), Cardinal(List.Count));
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
    AssertEquals('List.Add(pItem) returned invalid value!', Cardinal(I - 1), Cardinal(Idx));
    AssertEquals('PInteger(List[Idx])^ item isn''t equal to ' + I.ToString + '!', Cardinal(I), Cardinal(PInteger(List[Idx])^));

    { (2.6) Depending on amount already added, check List.Capacity values. }
    if (I = 32) then
      AssertEquals('List.Capacity isn''t equal to 32!', Cardinal(32), Cardinal(List.Capacity));
    if (I = 33) then
      AssertEquals('List.Capacity isn''t equal to 64!', Cardinal(64), Cardinal(List.Capacity));
    if (I = 64) then
      AssertEquals('List.Capacity isn''t equal to 64!', Cardinal(64), Cardinal(List.Capacity));
    if (I = 65) then
      AssertEquals('List.Capacity isn''t equal to 128!', Cardinal(128), Cardinal(List.Capacity));
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
    AssertEquals('List.Add(pItem) returned invalid value!', Cardinal(I - 1), Cardinal(Idx));
    AssertEquals('PInteger(List[Idx])^ item isn''t equal to ' + I.ToString + '!', Cardinal(I), Cardinal(PInteger(List[Idx])^));

    { (5.6) Depending on amount already added, check List.Capacity values. }
    if (I > 32) then
      AssertEquals('List.Capacity isn''t equal to ' + I.ToString + '!', Cardinal(I), Cardinal(List.Capacity))
    else
      AssertEquals('List.Capacity isn''t equal to 32!', Cardinal(32), Cardinal(List.Capacity));
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
    AssertEquals('List.Add(pItem) returned invalid value!', Cardinal(I - 1), Cardinal(Idx));
    AssertEquals('PInteger(List[Idx])^ item isn''t equal to ' + I.ToString + '!', Cardinal(I), Cardinal(PInteger(List[Idx])^));

    { (8.6) Depending on amount already added, check List.Capacity values. }
    if (I = 64) then
      AssertEquals('List.Capacity isn''t equal to 64!', Cardinal(64), Cardinal(List.Capacity));
    if (I = 65) then
      AssertEquals('List.Capacity isn''t equal to 66!', Cardinal(66), Cardinal(List.Capacity));
    if (I = 86) then
      AssertEquals('List.Capacity isn''t equal to 86!', Cardinal(86), Cardinal(List.Capacity));
    if (I = 87) then
      AssertEquals('List.Capacity isn''t equal to 88!', Cardinal(88), Cardinal(List.Capacity));
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
    AssertEquals('List.Add(pItem) returned invalid value!', Cardinal(I - 1), Cardinal(Idx));
    AssertEquals('PInteger(List[Idx])^ item isn''t equal to ' + I.ToString + '!', Cardinal(I), Cardinal(PInteger(List[Idx])^));

    { (11.6) Depending on amount already added, check List.Capacity values. }
    if (I = 64) then
      AssertEquals('List.Capacity isn''t equal to 64!', Cardinal(64), Cardinal(List.Capacity));
    if (I = 65) then
      AssertEquals('List.Capacity isn''t equal to 68!', Cardinal(68), Cardinal(List.Capacity));
    if (I = 71) then
      AssertEquals('List.Capacity isn''t equal to 72!', Cardinal(72), Cardinal(List.Capacity));
    if (I = 85) then
      AssertEquals('List.Capacity isn''t equal to 88!', Cardinal(88), Cardinal(List.Capacity));
  end;
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
    AssertEquals('List.Add(pItem) returned invalid value!', Cardinal(I - 1), Cardinal(Idx));

    { (1.6) Validate that added item's value is valid. }
    AssertEquals('List[Idx] item value is invalid!', Cardinal(I), PCardinal(List[Idx])^);
  end;

  { (2) Check removal with ShrinkMode set to smNormal. }
  List.ShrinkMode := smNormal;
  List.ShrinkLimit := 100;

  for I := 1 to 180 do
  begin
    List.Delete(0);

    if (200 - I = 64) then
      AssertEquals('List.Capacity isn''t equal to 256!', Cardinal(256), Cardinal(List.Capacity));
    if (200 - I = 63) then
      AssertEquals('List.Capacity isn''t equal to 128!', Cardinal(128), Cardinal(List.Capacity));
    if (200 - I = 32) then
      AssertEquals('List.Capacity isn''t equal to 128!', Cardinal(128), Cardinal(List.Capacity));
    if (200 - I = 31) then
      AssertEquals('List.Capacity isn''t equal to 64!', Cardinal(64), Cardinal(List.Capacity));
  end;

  AssertEquals('Length(List.List) didn''t return 64!', Cardinal(64), Cardinal(Length(List.List)));
  List.Clear;
  AssertEquals('Length(List.List) didn''t return 0!', Cardinal(0), Cardinal(Length(List.List)));

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
    AssertEquals('List.Add(pItem) returned invalid value!', Cardinal(I - 1), Cardinal(Idx));

    { (3.6) Validate that added item's value is valid. }
    AssertEquals('List[Idx] item value is invalid!', Cardinal(I), Cardinal(PInteger(List[Idx])^));
  end;

  { (4) Check removal with ShrinkMode set to smToCount. }
  List.ShrinkMode := smToCount;

  for I := 1 to 200 do
  begin
    if (List.Count > 0) then
      List.Delete(0);

    AssertEquals('List.Capacity isn''t equal to ' + IntToStr(200 - I) + '!', Cardinal(200 - I), Cardinal(List.Capacity));
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
    AssertEquals('List.Add(pItem) returned invalid value!', Cardinal(I - 1), Cardinal(Idx));
  end;

  { (6) Check removal with ShrinkMode set to smKeepCap. }
  List.ShrinkMode := smKeepCap;

  for I := 1 to 200 do
  begin
    List.Delete(0);
    AssertEquals('List.Capacity isn''t equal to 256!', Cardinal(256), Cardinal(List.Capacity));
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
    AssertEquals('List.Add(pItem) returned invalid value!', Cardinal(I - 1), Cardinal(Idx));
  end;

  { (8) Check removal by Remove() method. }
  for I := 1 to 10 do
  begin
    pItem := List[123];
    AssertEquals('List.Remove(pItem) returned value not equal to 123!', Cardinal(123), Cardinal(List.Remove(pItem)));
  end;
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
  AssertEquals('PInteger(List[0])^ isn''t equal to 100!', Integer(100), PInteger(List[0])^);
  AssertEquals('PInteger(List[99])^ isn''t equal to 1!', Integer(1), PInteger(List[99])^);
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
  AssertNotNull('List.Extract(pItem) returned nil!', pItem);
  if (pItem <> nil) then
  begin
    AssertEquals('List.Count isn''t equal to 99!', Cardinal(99), Cardinal(List.Count));
    AssertFalse('PInteger(List[49])^ is equal to 50!', PInteger(List[49])^ = Integer(50));
  end;

  { (5) Retrieve item from position (index) 24. }
  pItem := List[24];

  { (6) Extract item from the list. }
  pItem := List.ExtractItem(pItem, TBCList.TDirection.FromEnd);

  { (7) If extracted item isn't equal to nil, verify that item was deleted from
        the list. }
  AssertNotNull('List.ExtractItem(pItem, FromEnd) returned nil!', pItem);
  if (pItem <> nil) then
  begin
    AssertEquals('List.Count isn''t equal to 98!', Cardinal(98), Cardinal(List.Count));
    AssertFalse('PInteger(List[24])^ is equal to 25!', PInteger(List[24])^ = Integer(25));
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
  AssertEquals('List.First^ isn''t equal to 1!', Integer(1), PInteger(List.First)^);
  AssertEquals('List.Last^ isn''t equal to 100!', Integer(100), PInteger(List.Last)^);

  { (3) Validate that List.LowIndex and List.HighIndex returns proper values. }
  AssertEquals('List.LowIndex isn''t equal to 0!', Cardinal(0), Cardinal(List.LowIndex));
  AssertEquals('List.HighIndex isn''t equal to 99!', Cardinal(99), Cardinal(List.HighIndex));

  { (4) Delete last entry from the list. }
  List.Delete(List.HighIndex);

  { (5) Validate again that List.Last points to last entry in the list. }
  AssertEquals('List.Last^ isn''t equal to 99!', Integer(99), PInteger(List.Last)^);
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
  AssertNotNull('List[36] is nil!', pItem);
  if (pItem <> nil) then
  begin
    { (3.2) Validate List.IndexOf and List.IndexOfItem methods. }
    AssertEquals('List.IndexOf(pItem) didn''t return 36!', Cardinal(36), Cardinal(List.IndexOf(pItem)));
    AssertEquals('List.IndexOfItem(pItem, FromEnd) didn''t return 36!', Cardinal(36), Cardinal(List.IndexOfItem(pItem, TBCList.TDirection.FromEnd)));
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
    AssertEquals('List.Add(pItem) returned invalid value!', Cardinal(I - 1), Cardinal(Idx));

    { (1.6) Validate that entry with Idx position (index) is valid. }
    AssertEquals('List[Idx] item value is invalid!', Cardinal(I), Cardinal(PInteger(List[Idx])^));
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
  AssertEquals('List.Count isn''t equal to 200!', Cardinal(200), Cardinal(List.Count));

  { (4) Validate that List[49] entry is equal to 50. }
  AssertEquals('PInteger(List[49])^ isn''t equal to 50!', Integer(50), PInteger(List[49])^);

  { (5) Validate that List[50] entry is equal to 100. }
  AssertEquals('PInteger(List[50])^ isn''t equal to 100!', Integer(100), PInteger(List[50])^);
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
    AssertEquals('List.Add(pItem) returned invalid value!', Cardinal(I - 1), Cardinal(Idx));

    { (1.6) Validate that added item's value is valid. }
    AssertEquals('List[Idx] item value is invalid!', Cardinal(I), PCardinal(List[Idx])^);
  end;

  { (2) Move item from position (index) 10 to 90. }
  List.Move(10, 90);

  { (3) Validate that moved entries was actualy moved. }
  AssertFalse('List[10] is equal to 11!', PInteger(List[10])^ = Integer(11));
  AssertEquals('List[90] isn''t equal to 11!', Integer(11), PInteger(List[90])^);
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
  List.Sort(@Pointer_CompareFunc);

  { (4) Make sure that items were sorted. }
  for Idx := List.LowIndex to (List.HighIndex - 1) do
    AssertTrue('PInteger(List[' + Idx.ToString + ']])^ <= PInteger(List[' + SizeUInt(Idx + 1).ToString + '])^ condition failed!', PInteger(List[Idx])^ <= PInteger(List[Idx + 1])^);
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
      AssertEquals('PInteger(It.Current)^ isn''t equal to Idx which is equal to ' + Idx.ToString + '!', Idx, PInteger(It.Current)^);
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
      AssertEquals('PInteger(RevIt.Current)^ isn''t equal to Idx which is equal to ' + Idx.ToString + '!', Idx, PInteger(RevIt.Current)^);
      Dec(Idx);
    end;
  finally
    RevIt.Free;
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
        AssertEquals('PInteger(List[Idx])^ isn''t equal to PInteger(List2[Idx])^!', PInteger(List[Idx])^, PInteger(List2[Idx])^);
  finally
    { (4) Release lists. }
    List2.Free;
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

procedure TBasicClasses_TIntegerList_TestCase.Test_Creation;
begin
  AssertEquals('List.Capacity isn''t equal to 0!', Cardinal(0), Cardinal(List.Capacity));
  AssertEquals('List.Count isn''t equal to 0!', Cardinal(0), Cardinal(List.Count));
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
    AssertEquals('List.Add(TIntItem(I)) returned invalid value!', Cardinal(I - 1), Cardinal(Idx));
    AssertEquals('List[Idx] item isn''t equal to ' + I.ToString + '!', Cardinal(I), Cardinal(List[Idx]));

    { (2.4) Depending on amount already added, check List.Capacity values. }
    if (I = 32) then
      AssertEquals('List.Capacity isn''t equal to 32!', Cardinal(32), Cardinal(List.Capacity));
    if (I = 33) then
      AssertEquals('List.Capacity isn''t equal to 64!', Cardinal(64), Cardinal(List.Capacity));
    if (I = 64) then
      AssertEquals('List.Capacity isn''t equal to 64!', Cardinal(64), Cardinal(List.Capacity));
    if (I = 65) then
      AssertEquals('List.Capacity isn''t equal to 128!', Cardinal(128), Cardinal(List.Capacity));
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
    AssertEquals('List.Add(TIntItem(I)) returned invalid value!', Cardinal(I - 1), Cardinal(Idx));
    AssertEquals('List[Idx] item isn''t equal to ' + I.ToString + '!', Cardinal(I), Cardinal(List[Idx]));

    { (5.4) Depending on amount already added, check List.Capacity values. }
    if (I > 32) then
      AssertEquals('List.Capacity isn''t equal to ' + I.ToString + '!', Cardinal(I), Cardinal(List.Capacity))
    else
      AssertEquals('List.Capacity isn''t equal to 32!', Cardinal(32), Cardinal(List.Capacity));
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
    AssertEquals('List.Add(TIntItem(I)) returned invalid value!', Cardinal(I - 1), Cardinal(Idx));
    AssertEquals('List[Idx] item isn''t equal to ' + I.ToString + '!', Cardinal(I), Cardinal(List[Idx]));

    { (8.4) Depending on amount already added, check List.Capacity values. }
    if (I = 64) then
      AssertEquals('List.Capacity isn''t equal to 64!', Cardinal(64), Cardinal(List.Capacity));
    if (I = 65) then
      AssertEquals('List.Capacity isn''t equal to 66!', Cardinal(66), Cardinal(List.Capacity));
    if (I = 86) then
      AssertEquals('List.Capacity isn''t equal to 86!', Cardinal(86), Cardinal(List.Capacity));
    if (I = 87) then
      AssertEquals('List.Capacity isn''t equal to 88!', Cardinal(88), Cardinal(List.Capacity));
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
    AssertEquals('List.Add(TIntItem(I)) returned invalid value!', Cardinal(I - 1), Cardinal(Idx));
    AssertEquals('List[Idx] item isn''t equal to ' + I.ToString + '!', Cardinal(I), Cardinal(List[Idx]));

    { (11.4) Depending on amount already added, check List.Capacity values. }
    if (I = 64) then
      AssertEquals('List.Capacity isn''t equal to 64!', Cardinal(64), Cardinal(List.Capacity));
    if (I = 65) then
      AssertEquals('List.Capacity isn''t equal to 68!', Cardinal(68), Cardinal(List.Capacity));
    if (I = 71) then
      AssertEquals('List.Capacity isn''t equal to 72!', Cardinal(72), Cardinal(List.Capacity));
    if (I = 85) then
      AssertEquals('List.Capacity isn''t equal to 88!', Cardinal(88), Cardinal(List.Capacity));
  end;
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
    AssertEquals('List.Add(TIntItem(I)) returned invalid value!', Cardinal(I - 1), Cardinal(Idx));
    AssertEquals('List[Idx] item value is invalid!', Cardinal(I), Cardinal(List[Idx]));
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
      AssertEquals('List.Capacity isn''t equal 256!', Cardinal(256), Cardinal(List.Capacity));
    if (200 - I = 63) then
      AssertEquals('List.Capacity isn''t equal 128!', Cardinal(128), Cardinal(List.Capacity));
    if (200 - I = 32) then
      AssertEquals('List.Capacity isn''t equal 128!', Cardinal(128), Cardinal(List.Capacity));
    if (200 - I = 31) then
      AssertEquals('List.Capacity isn''t equal 64!', Cardinal(64), Cardinal(List.Capacity));
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
    AssertEquals('List.Add(TIntItem(I)) returned invalid value!', Cardinal(I - 1), Cardinal(Idx));
    AssertEquals('List[Idx] item value is invalid!', Cardinal(I), Cardinal(List[Idx]));
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
    AssertEquals('List.Capacity isn''t equal to ' + IntToStr(List.Count) + '!', Cardinal(List.Count), Cardinal(List.Capacity));
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
    AssertEquals('List.Add(TIntItem(I)) returned invalid value!', Cardinal(I - 1), Cardinal(Idx));
    AssertEquals('List[Idx] item value is invalid!', Cardinal(I), Cardinal(List[Idx]));
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
    AssertEquals('List.Capacity isn''t equal to 256!', Cardinal(256), Cardinal(List.Capacity));
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
    AssertEquals('List.Add(TIntItem(I)) returned invalid value!', Cardinal(I - 1), Cardinal(Idx));
    AssertEquals('List[Idx] item value is invalid!', Cardinal(I), Cardinal(List[Idx]));
  end;

  { (13) Check removal by Remove() method. }
  for I := 1 to 10 do
  begin
    Item := List[123];
    AssertEquals('List.Remove(Item) returned value not equal to 123!', Cardinal(123), Cardinal(List.Remove(Item)));
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
    AssertEquals('List.Add(TIntItem(I)) returned invalid value!', Cardinal(I - 1), Cardinal(Idx));
    AssertEquals('List[Idx] item value is invalid!', Cardinal(I), Cardinal(List[Idx]));
  end;

  { (16) Check removal by RemoveItem() method with FromEnd direction. }
  for I := 1 to 10 do
  begin
    Item := List[123];
    AssertEquals('List.RemoveItem(Item, FromEnd) returned value not equal to 123!', Cardinal(123), Cardinal(List.RemoveItem(Item, TIntegerList.TDirection.FromEnd)));
  end;
end;

procedure TBasicClasses_TIntegerList_TestCase.Test_Exchange;
var
  Idx: SizeUInt;
begin
  { (1) Prepare our list by adding 100 items. }
  for Idx := 1 to 100 do
    List.Add(TIntItem(Idx));

  { (2) Check existance of item with value 39. }
  AssertTrue('List.Exists(TIntItem(39)) doesn''t exists!', List.Exists(TIntItem(39)));
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
    AssertEquals('List.Add(TIntItem(I)) returned invalid value!', Cardinal(I - 1), Cardinal(Idx));
    AssertEquals('List[Idx] item value is invalid!', Cardinal(I), Cardinal(List[Idx]));
  end;

  { (2) Retrieve item from position (index) 49. }
  Item := List[49];

  { (3) Extract item from the list. }
  pItem := List.Extract(Item);

  { (4) If extracted item isn't equal to nil, verify that item was deleted from
        the list. }
  AssertNotNull('List.Extract(pItem) returned nil!', pItem);
  if (pItem <> nil) then
  begin
    AssertEquals('List.Count isn''t equal to 99!', Cardinal(99), Cardinal(List.Count));
    AssertFalse('List[49] is equal to 50!', Integer(50) = Integer(List[49]));
  end;

  { (5) Retrieve item from position (index) 24. }
  Item := List[24];

  { (6) Extract item from the list using FromEnd direction. }
  pItem := List.ExtractItem(Item, TIntegerList.TDirection.FromEnd);

  { (7) If extracted item isn't equal to nil, verify that item was deleted from
        the list. }
  AssertNotNull('List.ExtractItem(Item, FromEnd) returned nil!', pItem);
  if (pItem <> nil) then
  begin
    AssertEquals('List.Count isn''t equal to 98!', Cardinal(98), Cardinal(List.Count));
    AssertFalse('List[24] is equal to 25!', Integer(25) = Integer(List[24]));
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
  AssertEquals('List.First^ isn''t equal to 1!', Integer(1), Integer(PIntItem(List.First)^));
  AssertEquals('List.Last^ isn''t equal to 100!', Integer(100), Integer(PIntItem(List.Last)^));
  AssertEquals('List.LowIndex isn''t equal to 0!', Cardinal(0), Cardinal(List.LowIndex));
  AssertEquals('List.HighIndex isn''t equal to 99!', Cardinal(99), Cardinal(List.HighIndex));

  { (3) Delete last item from the list. }
  List.Delete(List.HighIndex);

  { (4) Check again that List.Last point to the last item in the list which now
        is different than last time. }
  AssertEquals('List.Last^ isn''t equal to 99!', Integer(99), Integer(PIntItem(List.Last)^));
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
  AssertEquals('List[36] isn''t equal to 37!', Integer(37), Integer(Item));

  { (4) Now check List.IndexOf() and List IndexOfItem() methods. }
  AssertEquals('List.IndexOf(Item) didn''t return 36!', Cardinal(36), Cardinal(List.IndexOf(Item)));
  AssertEquals('List.IndexOfItem(Item, FromEnd) didn''t return 36!', Cardinal(36), Cardinal(List.IndexOfItem(Item, TIntegerList.TDirection.FromEnd)));
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
    AssertEquals('List.Add(Item) returned invalid value!', Cardinal(I - 1), Cardinal(Idx));
    AssertEquals('List[Idx] item value is invalid!', Cardinal(I), Cardinal(List[Idx]));
  end;

  { (2) Prepare our list by inserting 100 items to position (index) 50. }
  for I := 1 to 100 do
    List.Insert(50, TIntItem(I));

  { (3) Check that there was actualy proper entry insertion in the list. }
  AssertEquals('List.Count isn''t equal to 200!', Cardinal(200), Cardinal(List.Count));
  AssertEquals('List[49] isn''t equal to 50!', Integer(50), Integer(List[49]));
  AssertEquals('List[50]) isn''t equal to 100!', Integer(100), Integer(List[50]));
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
    AssertEquals('List.Add(Item) returned invalid value!', Cardinal(I - 1), Cardinal(Idx));
    AssertEquals('List[Idx] item value is invalid!', Cardinal(I), Cardinal(List[Idx]));
  end;

  { (2) Move item from position (index) 10 to 90. }
  List.Move(10, 90);

  { (3) Check that there was proper move operation. }
  AssertFalse('List[10] is equal to 11!', Integer(11) = Integer(List[10]));
  AssertEquals('List[90] isn''t equal to 11!', Integer(11), Integer(List[90]));
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

  { (2) Shuffle list for additional randomness. }
  List.Shuffle;

  { (3) Sort the list. }
  List.Sort(@TIntItem_CompareFunc);

  { (4) Make sure that items were sorted. }
  for Idx := List.LowIndex to (List.HighIndex - 1) do
    AssertTrue('List[' + Idx.ToString + '] <= List[' + SizeUInt(Idx + 1).ToString + '] condition failed!', Integer(List[Idx]) <= Integer(List[Idx + 1]));
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
      AssertEquals('It.Current isn''t equal to Idx which is equal to ' + Idx.ToString + '!', Idx, Integer(It.Current));
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
      AssertEquals('RevIt.Current isn''t equal to Idx which is equal to ' + Idx.ToString + '!', Idx, Integer(RevIt.Current));
      Dec(Idx);
    end;
  finally
    RevIt.Free;
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
        AssertEquals('List[Idx] isn''t equal to NewList[Idx]!', List[Idx], NewList[Idx]);
  finally
    { (5) Release NewList. }
    NewList.Free;
  end;
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
      AssertEquals('List[Idx] isn''t equal to NewList[Idx]!', List[Idx], NewList[Idx]);
  finally
    { (7) Finally release NewList. }
    NewList.Free;
  end;
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
  AssertEquals('List.Count isn''t equal to 19!', Integer(19), Integer(List.Count));
  List.RemoveDuplicates;
  AssertEquals('List.Count isn''t equal to 3!', Integer(3), Integer(List.Count));
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
  AssertEquals('List.ChainToString returned invalid value!', ValidString, List.ChainToString);
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
    AssertTrue('List isn''t the same as List2!', List.SameAs(List2));

    { (4) Clear List2 and prepare it again but now List2 should have different
          values. }
    List2.Clear;

    for Idx := 1 to 2000 do
      List2.Add(TIntItem(Random(500)));

    { (5) Compare both list. They aren't identical. }
    AssertFalse('List is the same as List2!', List.SameAs(List2));
  finally
    { (6) Finally release List2. }
    List2.Free;
  end;
end;

procedure TBasicClasses_TIntegerList_TestCase.Test_Values;
var
  Idx: SizeUInt;
begin
  { (1) Prepare our list by adding 100 items. }
  for Idx := 1 to 100 do
    List.Add(TIntItem(Idx));

  { (2) Check List.ValuesMin calculation. }
  AssertEquals('List.ValuesMin isn''t equal to 1!', Integer(1), Integer(List.ValuesMin));

  { (3) Check List.ValuesMax calculation. }
  AssertEquals('List.ValuesMax isn''t equal to 100!', Integer(100), Integer(List.ValuesMax));

  { (4) Check List.ValuesSum calculation. }
  AssertEquals('List.ValuesSum isn''t equal to 5050!', Integer(5050), Integer(List.ValuesSum));

  { (5) Check List.ValuesAvg calculation. }
  AssertEquals('List.ValuesAvg isn''t equal to 50!', Integer(50), Integer(List.ValuesAvg));
end;

procedure TBasicClasses_TIntegerList_TestCase.Test_Exists;
var
  Idx: SizeUInt;
begin
  { (1) Prepare our list by adding 100 items. }
  for Idx := 1 to 100 do
    List.Add(TIntItem(Idx));

  { (2) Check existance of item with value 39. }
  AssertTrue('List.Exists(TIntItem(39)) doesn''t exists!', List.Exists(TIntItem(39)));
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

procedure TBasicClasses_TIntegerProbabilityList_TestCase.Test_Creation;
begin
  AssertEquals('List.Capacity isn''t 0!', Cardinal(0), Cardinal(List.Capacity));
  AssertEquals('List.Count isn''t 0!', Cardinal(0), Cardinal(List.Count));
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
    AssertEquals('List.Add(TIntProbValue(I), 1.0) retured invalid value!', Cardinal(I - 1), Cardinal(Idx));
    AssertEquals('List[Idx].Value isn''t equal to ' + I.ToString + '!', Cardinal(I), Cardinal(List[Idx].Value));

    { (2.4) Depending on amount already added, check List.Capacity values. }
    if (I = 32) then
      AssertEquals('List.Capacity isn''t equal to 32!', Cardinal(32), Cardinal(List.Capacity));
    if (I = 33) then
      AssertEquals('List.Capacity isn''t equal to 64!', Cardinal(64), Cardinal(List.Capacity));
    if (I = 64) then
      AssertEquals('List.Capacity isn''t equal to 64!', Cardinal(64), Cardinal(List.Capacity));
    if (I = 65) then
      AssertEquals('List.Capacity isn''t equal to 128!', Cardinal(128), Cardinal(List.Capacity));
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
    AssertEquals('List.Add(TIntProbValue(I), 1.0) returned invalid value!', Cardinal(I - 1), Cardinal(Idx));
    AssertEquals('List[Idx].Value isn''t equal to ' + I.ToString + '!', Cardinal(I), Cardinal(List[Idx].Value));

    { (5.4) Depending on amount already added, check List.Capacity values. }
    if (I > 32) then
      AssertEquals('List.Capacity isn''t equal to ' + I.ToString + '!', Cardinal(I), Cardinal(List.Capacity))
    else
      AssertEquals('List.Capacity isn''t equal to 32!', Cardinal(32), Cardinal(List.Capacity));
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
    AssertEquals('List.Add(TIntProbValue(I), 1.0) returned invalid value!', Cardinal(I - 1), Cardinal(Idx));
    AssertEquals('List[Idx].Value isn''t equal to ' + I.ToString + '!', Cardinal(I), Cardinal(List[Idx].Value));

    { (8.4) Depending on amount already added, check List.Capacity values. }
    if (I = 64) then
      AssertEquals('List.Capacity isn''t equal to 64!', Cardinal(64), Cardinal(List.Capacity));
    if (I = 65) then
      AssertEquals('List.Capacity isn''t equal to 66!', Cardinal(66), Cardinal(List.Capacity));
    if (I = 86) then
      AssertEquals('List.Capacity isn''t equal to 86!', Cardinal(86), Cardinal(List.Capacity));
    if (I = 87) then
      AssertEquals('List.Capacity isn''t equal to 88!', Cardinal(88), Cardinal(List.Capacity));
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
    AssertEquals('List.Add(TIntProbValue(I), 1.0) returned invalid value!', Cardinal(I - 1), Cardinal(Idx));
    AssertEquals('List[Idx].Value isn''t equal to ' + I.ToString + '!', Cardinal(I), Cardinal(List[Idx].Value));

    { (11.4) Depending on amount already added, check List.Capacity values. }
    if (I = 64) then
      AssertEquals('List.Capacity isn''t equal to 64!', Cardinal(64), Cardinal(List.Capacity));
    if (I = 65) then
      AssertEquals('List.Capacity isn''t equal to 68!', Cardinal(68), Cardinal(List.Capacity));
    if (I = 71) then
      AssertEquals('List.Capacity isn''t equal to 72!', Cardinal(72), Cardinal(List.Capacity));
    if (I = 85) then
      AssertEquals('List.Capacity isn''t equal to 88!', Cardinal(88), Cardinal(List.Capacity));
  end;
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
    AssertEquals('List.Add(TIntItem(I)) returned invalid value!', Cardinal(I - 1), Cardinal(Idx));
    AssertEquals('List[Idx].Value is invalid!', Cardinal(I), Cardinal(List[Idx].Value));
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
      AssertEquals('List.Capacity isn''t equal 256!', Cardinal(256), Cardinal(List.Capacity));
    if (200 - I = 63) then
      AssertEquals('List.Capacity isn''t equal 128!', Cardinal(128), Cardinal(List.Capacity));
    if (200 - I = 32) then
      AssertEquals('List.Capacity isn''t equal 128!', Cardinal(128), Cardinal(List.Capacity));
    if (200 - I = 31) then
      AssertEquals('List.Capacity isn''t equal 64!', Cardinal(64), Cardinal(List.Capacity));
  end;

  { (4) Clear the list. }
  AssertEquals('Length(List.List) isn''t equal to 64!', Cardinal(64), Cardinal(Length(List.List.List)));
  List.Clear;
  AssertEquals('Length(List.List) isn''t equal to 0!', Cardinal(0), Cardinal(Length(List.List.List)));

  { (5.1) Prepare our list by adding 200 items: }
  for I := 1 to 200 do
  begin
    { (5.2) Add new item to the list. }
    Idx := List.Add(TIntProbValue(I), 1.0);

    { (5.3) Check that item was added properly and that item in the list have
            proper value. }
    AssertEquals('List.Add(TIntItem(I)) returned invalid value!', Cardinal(I - 1), Cardinal(Idx));
    AssertEquals('List[Idx].Value is invalid!', Cardinal(I), Cardinal(List[Idx].Value));
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
    AssertEquals('List.Capacity isn''t equal to ' + IntToStr(List.Count) + '!', Cardinal(List.Count), Cardinal(List.Capacity));
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
    AssertEquals('List.Add(TIntItem(I)) returned invalid value!', Cardinal(I - 1), Cardinal(Idx));
    AssertEquals('List[Idx].Value is invalid!', Cardinal(I), Cardinal(List[Idx].Value));
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
    AssertEquals('List.Capacity isn''t equal to 256!', Cardinal(256), Cardinal(List.Capacity));
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
    AssertEquals('List.Add(TIntItem(I)) returned invalid value!', Cardinal(I - 1), Cardinal(Idx));
    AssertEquals('List[Idx].Value is invalid!', Cardinal(I), Cardinal(List[Idx].Value));
  end;

  { (14) Check removal by Remove() method. }
  for I := 1 to 10 do
  begin
    Item := List[123];
    AssertEquals('List.Remove(Item) returned value not equal to 123!', Cardinal(123), Cardinal(List.Remove(Item)));
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
    AssertEquals('List.Add(TIntItem(I)) returned invalid value!', Cardinal(I - 1), Cardinal(Idx));
    AssertEquals('List[Idx].Value is invalid!', Cardinal(I), Cardinal(List[Idx].Value));
  end;

  { (17) Check removal by RemoveItem() method with FromEnd direction. }
  for I := 1 to 10 do
  begin
    Item := List[123];
    AssertEquals('List.RemoveItem(Item, FromEnd) returned value not equal to 123!', Cardinal(123), Cardinal(List.RemoveItem(Item, TIntegerProbabilityList.TDirection.FromEnd)));
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
    AssertEquals('List.Add(TIntItem(I)) returned invalid value!', Cardinal(I - 1), Cardinal(Idx));
    AssertEquals('List[Idx].Value is invalid!', Cardinal(I), Cardinal(List[Idx].Value));
  end;

  { (2) Exchange 2 items and validate. }
  List.Exchange(0, 99);

  { (3) Check that exchange operation was successful. }
  AssertEquals('Integer(List[0].Value) isn''t equal to 100!', Integer(100), Integer(List[0].Value));
  AssertEquals('Integer(List[99].Value) isn''t equal to 1!', Integer(1), Integer(List[99].Value));
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
    AssertEquals('List.Add(TIntProbValue(I), 1.0) returned invalid value!', Cardinal(I - 1), Cardinal(Idx));
    AssertEquals('List[Idx].Value is invalid!', Cardinal(I), Cardinal(List[Idx].Value));
  end;

  { (2) Retrieve item from position (index) 49. }
  Item := List[49];

  { (3) Extract item from the list. }
  pItem := List.Extract(Item);

  { (4) If extracted item isn't equal to nil, verify that item was deleted from
        the list. }
  AssertNotNull('List.Extract(Item) returned nil!', pItem);
  if (pItem <> nil) then
  begin
    AssertEquals('List.Count isn''t equal to 99!', Cardinal(99), Cardinal(List.Count));
    AssertFalse('List[49].Value is equal to 50!', Integer(50) = Integer(List[49].Value));
  end;

  { (5) Retrieve item from position (index) 24. }
  Item := List[24];

  { (6) Extract item from the list using FromEnd direction. }
  pItem := List.ExtractItem(Item, TIntegerProbabilityList.TDirection.FromEnd);

  { (7) If extracted item isn't equal to nil, verify that item was deleted from
        the list. }
  AssertNotNull('List.ExtractItem(Item, FromEnd) returned nil!', pItem);
  if (pItem <> nil) then
  begin
    AssertEquals('List.Count isn''t equal to 98!', Cardinal(98), Cardinal(List.Count));
    AssertFalse('List[24].Value is equal to 25!', Integer(25) = Integer(List[24].Value));
  end;

  { (8) Extract item from the list by it's value. }
  pItem := List.Extract(TIntProbValue(51));

  { (9) If extracted item isn't equal to nil, verify that item was deleted from
        the list. }
  AssertNotNull('List.Extract(TIntProbValue(51)) returned nil!', pItem);
  if (pItem <> nil) then
    AssertEquals('List.Count isn''t equal to 97!', Cardinal(97), Cardinal(List.Count));

  { (10) Extract item from the list by it's value. }
  pItem := List.ExtractItem(TIntProbValue(26), TIntegerProbabilityList.TDirection.FromEnd);

  { (11) If extracted item isn't equal to nil, verify that item was deleted from
         the list. }
  AssertNotNull('List.ExtractItem(TIntProbValue(26), FromEnd) returned nil!', pItem);
  if (pItem <> nil) then
    AssertEquals('List.Count isn''t equal to 96!', Cardinal(96), Cardinal(List.Count));
end;

procedure TBasicClasses_TIntegerProbabilityList_TestCase.Test_FirstAndLast;
var
  I: SizeUInt;
begin
  { (1) Prepare our list by adding 100 items. }
  for I := 1 to 100 do
    List.Add(TIntProbValue(I), 1.0);

  { (2) Check that List.First and List.Last points to proper entries. }
  AssertEquals('List.First^.Value isn''t equal to 1!', Integer(1), Integer(TIntProbValue(List.First^.Value)));
  AssertEquals('List.Last^.Value isn''t equal to 100!', Integer(100), Integer(TIntProbValue(List.Last^.Value)));

  { (3) Check that List.LowIndex and List.HighIndex are valid. }
  AssertEquals('List.LowIndex isn''t equal to 0!', Cardinal(0), Cardinal(List.LowIndex));
  AssertEquals('List.HighIndex isn''t equal to 99!', Cardinal(99), Cardinal(List.HighIndex));

  { (4) Delete last entry in the list. }
  List.Delete(List.HighIndex);

  { (5) Check again that List.Last points to proper entry. }
  AssertEquals('List.Last^ isn''t equal to 99!', Integer(99), Integer(TIntProbValue(List.Last^.Value)));
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

  AssertEquals('List[36].Value isn''t equal to 37!', Integer(37), Integer(Item.Value));

  AssertEquals('List.IndexOf(Item) didn''t returned 36!', Cardinal(36), Cardinal(List.IndexOf(Item)));
  AssertEquals('List.IndexOfItem(Item, FromEnd) didn''t returned 36!', Cardinal(36), Cardinal(List.IndexOfItem(Item, TIntegerProbabilityList.TDirection.FromEnd)));
  AssertEquals('List.IndexOf(Item.Value) didn''t returned 36!', Cardinal(36), Cardinal(List.IndexOf(Item.Value)));
  AssertEquals('List.IndexOfItem(Item.Value, FromEnd) didn''t returned 36!', Cardinal(36), Cardinal(List.IndexOfItem(Item.Value, TIntegerProbabilityList.TDirection.FromEnd)));
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
    AssertEquals('List.Add(TIntProbValue(I), 1.0) returned invalid value!', Cardinal(I - 1), Cardinal(Idx));
    AssertEquals('List[Idx].Value is invalid!', Cardinal(I), Cardinal(List[Idx].Value));
  end;

  { (2) Prepare our list by inserting 100 items to position (index) 50. }
  for I := 1 to 100 do
    List.Insert(50, TIntProbValue(I), 1.0);

  { (3) Check that insertion operation was successful. }
  AssertEquals('List.Count isn''t equal to 200!', Cardinal(200), Cardinal(List.Count));
  AssertEquals('List[49].Value isn''t equal to 50!', Integer(50), Integer(List[49].Value));
  AssertEquals('List[50].Value isn''t equal to 100!', Integer(100), Integer(List[50].Value));
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
    AssertEquals('List.Add(TIntProbValue(I), 1.0) returned invalid value!', Cardinal(I - 1), Cardinal(Idx));
    AssertEquals('List[Idx].Value is invalid!', Cardinal(I), Cardinal(List[Idx].Value));
  end;

  { (2) Move item from position (index) 10 to 90. }
  List.Move(10, 90);

  { (3) Check that move operation was successful. }
  AssertFalse('List[10].Value is equal to 11!', Integer(11) = Integer(List[10].Value));
  AssertEquals('List[90].Value isn''t equal to 11!', Integer(11), Integer(List[90].Value));
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
  List.Sort(@TIntProbValue_CompareFunc);

  { (4) Make sure that items were sorted. }
  for Idx := List.LowIndex to (List.HighIndex - 1) do
    AssertTrue('List[' + Idx.ToString + '].Value <= List[' + SizeUInt(Idx + 1).ToString + '].Value condition failed!', Integer(List[Idx].Value) <= Integer(List[Idx + 1].Value));
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
      AssertEquals('It.Current.Value isn''t equal to Idx which is equal to ' + Idx.ToString + '!', Idx, Integer(It.Current.Value));
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
      AssertEquals('RevIt.Current.Value isn''t equal to Idx which is equal to ' + Idx.ToString + '!', Idx, Integer(RevIt.Current.Value));
      Dec(Idx);
    end;
  finally
    { (3.2) Finally release retrieved enumerator. }
    RevIt.Free;
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
    AssertTrue('List isn''t equal to NewList!', List.SameAs(NewList));
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
    AssertTrue('List isn''t equal to NewList!', List.SameAs(NewList));
  finally
    { (7) Finally release NewList. }
    NewList.Free;
  end;
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
  AssertEquals('List.Count isn''t equal to 19!', Integer(19), Integer(List.Count));
  List.RemoveDuplicates;
  AssertEquals('List.Count isn''t equal to 3!', Integer(3), Integer(List.Count));
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
    AssertTrue('List isn''t the same as List2!', List.SameAs(List2));

    { (4) Clear List2 and prepare it again but now List2 should have different
          values. }
    List2.Clear;

    for Idx := 1 to 2000 do
      List2.Add(TIntProbValue(Random(500)), 1.0);

    { (5) Compare both list. They aren't identical. }
    AssertFalse('List is the same as List2!', List.SameAs(List2));
  finally
    { (6) Finally release List2. }
    List2.Free;
  end;
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
  AssertTrue('List.Exists(Item) doesn''t exists!', List.Exists(Item));
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
  AssertEquals('List[2].Probability isn''t equal to 0.15!', 0.15, List[2].Probability, 0.001);

  { (4) Scale probability of all items in the list except one. }
  List.ScaleProbabilityExcept(TIntProbValue(8), 0.5);

  { (5) Validate all entries of the list except List[7].Probability. }
  AssertEquals('List[0].Probability isn''t equal to 0.25!',  0.25,  List[0].Probability, 0.001);
  AssertEquals('List[0].Probability isn''t equal to 0.2!',   0.2,   List[1].Probability, 0.001);
  AssertEquals('List[0].Probability isn''t equal to 0.075!', 0.075, List[2].Probability, 0.001);
  AssertEquals('List[0].Probability isn''t equal to 0.1!',   0.1,   List[3].Probability, 0.001);
  AssertEquals('List[0].Probability isn''t equal to 0.05!',  0.05,  List[4].Probability, 0.001);
  AssertEquals('List[0].Probability isn''t equal to 0.3!',   0.3,   List[5].Probability, 0.001);
  AssertEquals('List[0].Probability isn''t equal to 0.349!', 0.349, List[6].Probability, 0.001);
  AssertEquals('List[0].Probability isn''t equal to 0.8!',   0.8,   List[7].Probability, 0.001);
  AssertEquals('List[0].Probability isn''t equal to 0.449!', 0.449, List[8].Probability, 0.001);
  AssertEquals('List[0].Probability isn''t equal to 0.5!',   0.5,   List[9].Probability, 0.001);
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
    AssertTrue('List.IndexOf(TIntProbValue(List.GetRandomValue)) returned -1!', List.IndexOf(TIntProbValue(List.GetRandomValue)) <> -1);

  { (3) Loop List.Count times and extract random value which is calculated
        from the List probability and search it within the List entries. Search
        result should be -1 becouse extracted random value shouldn't be in the
        List. }
  Idx := List.Count;
  while (Idx > 0) do
  begin
    AssertFalse('List.IndexOf(TIntProbValue(List.ExtractRandomValue)) didn''t return -1!', List.IndexOf(TIntProbValue(List.ExtractRandomValue)) <> -1);
    Dec(Idx);
  end;

  { (4) Validate that List.Count is equal 0. }
  AssertTrue('List.Count didn''t return 0!', List.Count = 0);
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
  AssertEquals('List[0].Probability isn''t equal to 0.031!', 0.031, List[0].Probability, 0.001);
  AssertEquals('List[1].Probability isn''t equal to 0.044!', 0.044, List[1].Probability, 0.001);
  AssertEquals('List[2].Probability isn''t equal to 0.059!', 0.059, List[2].Probability, 0.001);
  AssertEquals('List[3].Probability isn''t equal to 0.117!', 0.117, List[3].Probability, 0.001);
  AssertEquals('List[4].Probability isn''t equal to 0.12!',  0.12,  List[4].Probability, 0.001);
  AssertEquals('List[5].Probability isn''t equal to 0.083!', 0.083, List[5].Probability, 0.001);
  AssertEquals('List[6].Probability isn''t equal to 0.089!', 0.089, List[6].Probability, 0.001);
  AssertEquals('List[7].Probability isn''t equal to 0.1!',   0.1,   List[7].Probability, 0.001);
  AssertEquals('List[8].Probability isn''t equal to 0.072!', 0.072, List[8].Probability, 0.001);
  AssertEquals('List[9].Probability isn''t equal to 0.286!', 0.286, List[9].Probability, 0.001);
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
  AssertEquals('List[0].Probability isn''t equal to 0.1!', 0.1, List[0].Probability, 0.1);
  AssertEquals('List[1].Probability isn''t equal to 0.2!', 0.2, List[1].Probability, 0.1);
  AssertEquals('List[2].Probability isn''t equal to 0.3!', 0.3, List[2].Probability, 0.1);
  AssertEquals('List[3].Probability isn''t equal to 0.4!', 0.4, List[3].Probability, 0.1);
  AssertEquals('List[4].Probability isn''t equal to 0.5!', 0.5, List[4].Probability, 0.1);
  AssertEquals('List[5].Probability isn''t equal to 0.6!', 0.6, List[5].Probability, 0.1);
  AssertEquals('List[6].Probability isn''t equal to 0.7!', 0.7, List[6].Probability, 0.1);
  AssertEquals('List[7].Probability isn''t equal to 0.8!', 0.8, List[7].Probability, 0.1);
  AssertEquals('List[8].Probability isn''t equal to 0.9!', 0.9, List[8].Probability, 0.1);
  AssertEquals('List[9].Probability isn''t equal to 1.0!', 1.0, List[9].Probability, 0.1);
end;

initialization
  RegisterTests(
    [TBasicClasses_TBCList_TestCase,
     TBasicClasses_TIntegerList_TestCase,
     TBasicClasses_TIntegerProbabilityList_TestCase]);

end.

