{===============================================================================

  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

===============================================================================}

{$INCLUDE BasicClasses.Config.inc}

{$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
/// <summary>
///   A collection of basic classes such as lists, enumerators, containers, etc.
///   that help you in creating software.
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
unit BasicClasses.Lists;

interface

uses
  {$IFDEF HAS_UNITSCOPE}System.Classes,{$ELSE}Classes,{$ENDIF}
  TypeDefinitions,
  BasicClasses,
  BasicClasses.Streams;

{$IFDEF SUPPORTS_REGION}{$REGION 'TIntegerList'}{$ENDIF}

type
  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Pointer to <see cref="TListInt" />.
  /// </summary>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  PListInt = ^TListInt;

  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Defines which type should be used in
  ///   <see cref="BasicClasses|TIntegerList" /> and
  ///   <see cref="TIntegerProbabilityList" /> as a single item value.
  /// </summary>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  TListInt =
  {$IFDEF BC_TIntegerList_StdInt}
    StdInt
  {$ELSE}
    Integer
  {$ENDIF ~BC_TIntegerList_StdInt};

  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Pointer to <see cref="BasicClasses|TIntegerList" />.
  /// </summary>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  PIntegerList = ^TIntegerList;

  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Definition of Integer List class.
  /// </summary>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  TIntegerList = class
  public type
    TEnumerator = class
    private
      {$IFDEF AUTOREFCOUNT}[weak]{$ENDIF} FList: TIntegerList;
      FIndex: Integer;

      function GetCurrent: TListInt;
    public
      constructor Create(const AList: TIntegerList);
      destructor Destroy; override;

      function MoveNext: Boolean;
      property Current: TListInt read GetCurrent;
    end;
  private const
    ListGrowIncrement = 8;
    ListGrowFraction = 4;
  private
    FData: array of TListInt;
    FDataCount: Integer;

    function GetItem(const Index: Integer): TListInt;
    procedure SetItem(const Index: Integer; const Value: TListInt);
    procedure Request(const NeedCapacity: Integer);
    function GetMemAddr: Pointer;
    function GetValuesSum: TListInt;
    function GetValuesAvg: TListInt;
    function GetValuesMax: TListInt;
    function GetValuesMin: TListInt;
    procedure ListSwap(const Index1, Index2: Integer); inline;
    function ListCompare(const Value1, Value2: TListInt): Integer;
    function ListSplit(const Start, Stop: Integer): Integer;
    procedure ListSort(const Start, Stop: Integer);
    procedure SetCount(const NewCount: Integer);
  public
    constructor Create;
    destructor Destroy; override;

    function IndexOf(const Value: TListInt): Integer;
    function Add(const Value: TListInt): Integer; overload;

    procedure InsertFirst(const Value: TListInt);

    procedure Remove(const Index: Integer);
    procedure Clear;

    procedure Sort;
    procedure Swap(const Index1, Index2: Integer);

    procedure CopyFrom(const Source: TIntegerList);
    procedure AddFrom(const Source: TIntegerList);
    procedure AddFromPtr(const Source: PListInt; const ElementCount: Integer);

    procedure Include(const Value: TListInt);
    procedure Exclude(const Value: TListInt);

    function Exists(const Value: TListInt): Boolean;

    procedure Series(const NumCount: Integer);

    procedure InsertRepeatValue(const Value: TListInt; const Count: Integer);

    procedure Shuffle;
    procedure BestShuffle;
    procedure RemoveDuplicates;
    function GetRandomValue: TListInt;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Returns text representation of integer list e.g. "21, 14, 7, 3, 1".
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ChainToString: String;

    procedure DefineValueAtIndex(const Index: Integer; const Value: TListInt);
    procedure IncrementValueAtIndex(const Index: Integer);
    function GetValueAtIndex(const Index: Integer): TListInt;

    function SameAs(const OtherList: TIntegerList): Boolean;

    function GetEnumerator: TEnumerator;

    procedure SaveToStream(const Stream: TStream);
    procedure LoadFromStream(const Stream: TStream);

    property MemAddr: Pointer read GetMemAddr;

    property Count: Integer read FDataCount write SetCount;
    property Items[const &Index: Integer]: TListInt read GetItem
      write SetItem; default;

    property ValuesSum: TListInt read GetValuesSum;
    property ValuesAvg: TListInt read GetValuesAvg;
    property ValuesMax: TListInt read GetValuesMax;
    property ValuesMin: TListInt read GetValuesMin;
  end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{$IFDEF SUPPORTS_REGION}{$REGION 'TIntegerProbabilityList'}{$ENDIF}
type
  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Pointer to <see cref="BasicClasses|TIntegerProbabilityList" />.
  /// </summary>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  PIntegerProbabilityList = ^TIntegerProbabilityList;

  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Definition of Integer Probability List class.
  /// </summary>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  TIntegerProbabilityList = class
  public type
    PDataSample = ^TDataSample;
    TDataSample = record
      Value: TListInt;
      Probability: Float;
    end;

    TEnumerator = class
    private
      {$IFDEF AUTOREFCOUNT}[weak]{$ENDIF} FList: TIntegerProbabilityList;
      FIndex: Integer;
      function GetCurrent: PDataSample;
    public
      constructor Create(const AList: TIntegerProbabilityList);
      destructor Destroy; override;

      function MoveNext: Boolean;
      property Current: PDataSample read GetCurrent;
    end;
  private const
    ListGrowIncrement = 8;
    ListGrowFraction = 4;
  private
    FData: array of TDataSample;
    FDataCount: Integer;

    function GetMemAddr: Pointer;
    function GetItem(const Index: Integer): PDataSample;
    procedure Request(const NeedCapacity: Integer);
    function GetValue(const Index: Integer): Integer;
    function GetProbability(const DataValue: TListInt): Float;
    procedure SetProbability(
      const DataValue: TListInt; const Probability: Float);
  public
    constructor Create;
    destructor Destroy; override;

    function Add(const DataValue: TListInt; const Probability: Float = 1.0): Integer;

    procedure Remove(const Index: Integer);
    procedure Clear;

    function IndexOf(const DataValue: TListInt): Integer;
    function Exists(const DataValue: TListInt): Boolean;

    procedure Include(const DataValue: TListInt; const Probability: Float = 1.0);
    procedure Exclude(const DataValue: TListInt);

    procedure Series(const MaxValue: TListInt; const Probability: Float = 1.0);

    procedure ScaleProbability(const DataValue: TListInt; const Scale: Float);
    procedure ScaleProbabilityExcept(const DataValue: TListInt; const Scale: Float);

    procedure CopyFrom(const Source: TIntegerProbabilityList);
    procedure AddFrom(const Source: TIntegerProbabilityList);

    function ExtractRandomValue: TListInt;
    procedure NormalizeProbabilities;

    function GetRandomValue: TListInt;

    procedure SaveToStream(const Stream: TStream);
    procedure LoadFromStream(const Stream: TStream);

    function GetEnumerator: TEnumerator;

    property MemAddr: Pointer read GetMemAddr;

    property Count: Integer read FDataCount;
    property Items[const &Index: Integer]: PDataSample read GetItem;

    property Value[const &Index: Integer]: Integer read GetValue;
    property Probability[const DataValue: TListInt]: Float
      read GetProbability write SetProbability; default;
  end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

implementation

uses
  {$IFDEF HAS_UNITSCOPE}System.SyncObjs{$ELSE}SyncObjs{$ENDIF},
  {$IFDEF HAS_UNITSCOPE}System.SysUtils{$ELSE}SysUtils{$ENDIF},
  {$IFDEF HAS_UNITSCOPE}System.Math{$ELSE}Math{$ENDIF};

{$IFDEF SUPPORTS_REGION}{$REGION 'Global routines'}{$ENDIF}
function RoundBy16(const Value: Integer): Integer; inline;
const
  RoundBlockSize = 16;
begin
  Result := (Value + RoundBlockSize - 1) and (not (RoundBlockSize - 1));
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{$IFDEF SUPPORTS_REGION}{$REGION 'TIntegerList'}{$ENDIF}
{$IFDEF SUPPORTS_REGION}{$REGION 'TIntegerList.TEnumerator'}{$ENDIF}
constructor TIntegerList.TEnumerator.Create(const AList: TIntegerList);
begin
  inherited Create;

  Increment_BC_ClassInstances;

  FList := AList;
  FIndex := -1;
end;

destructor TIntegerList.TEnumerator.Destroy;
begin
  Decrement_BC_ClassInstances;

  inherited;
end;

function TIntegerList.TEnumerator.GetCurrent: TListInt;
begin
  Result := FList[FIndex];
end;

function TIntegerList.TEnumerator.MoveNext: Boolean;
begin
  Result := FIndex < FList.Count - 1;

  if (Result) then
    Inc(FIndex);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

function TIntegerList.Add(const Value: TListInt): Integer;
var
  Index: Integer;
begin
  Index := FDataCount;
  Request(FDataCount + 1);

  FData[Index] := Value;
  Inc(FDataCount);

  Result := Index;
end;

procedure TIntegerList.AddFrom(const Source: TIntegerList);
var
  I: Integer;
begin
  Request(FDataCount + Source.FDataCount);

  for I := 0 to (Source.FDataCount - 1) do
    FData[I + FDataCount] := Source.FData[I];

  Inc(FDataCount, Source.FDataCount);
end;

procedure TIntegerList.AddFromPtr(
  const Source: PListInt; const ElementCount: Integer);
var
  I: Integer;
  InpValue: PListInt;
begin
  Request(FDataCount + ElementCount);

  InpValue := Source;

  for I := 0 to (ElementCount - 1) do
  begin
    FData[I + FDataCount] := InpValue^;
    Inc(InpValue);
  end;

  Inc(FDataCount, ElementCount);
end;

procedure TIntegerList.BestShuffle;
var
  TempList: TIntegerList;
  Index: Integer;
begin
  TempList := TIntegerList.Create;
  try
    TempList.CopyFrom(Self);
    Clear;

    while (TempList.Count > 0) do
    begin
      Index := Random(TempList.Count);
      Add(TempList[Index]);
      TempList.Remove(Index);
    end;
  finally
    TempList.Free;
  end;
end;

function TIntegerList.ChainToString: String;
var
  I: Integer;
begin
  Result := '';

  for I := 0 to (FDataCount - 1) do
  begin
    Result := Result + IntToStr(FData[I]);

    if (I < FDataCount - 1) then
      Result := Result + ', ';
  end;
end;

procedure TIntegerList.Clear;
begin
  FDataCount := 0;
end;

procedure TIntegerList.CopyFrom(const Source: TIntegerList);
var
  I: Integer;
begin
  Request(Source.FDataCount);

  for I := 0 to (Source.FDataCount - 1) do
    FData[I] := Source.FData[I];

  FDataCount := Source.FDataCount;
end;

constructor TIntegerList.Create;
begin
  inherited;

  Increment_BC_ClassInstances;
end;

procedure TIntegerList.DefineValueAtIndex(const Index: Integer; const Value: TListInt);
var
  StartAt, I: Integer;
begin
  if (Index < 0) then
    Exit;

  if (Index >= FDataCount) then
  begin
    StartAt := FDataCount;
    Request(Index + 1);

    for I := StartAt to (Index - 1) do
      FData[I] := 0;

    FDataCount := Index + 1;
  end;

  FData[Index] := Value;
end;

destructor TIntegerList.Destroy;
begin
  Decrement_BC_ClassInstances;

  inherited;
end;

procedure TIntegerList.Exclude(const Value: TListInt);
var
  Index: Integer;
begin
  Index := IndexOf(Value);
  if (Index <> -1) then
    Remove(Index);
end;

function TIntegerList.Exists(const Value: TListInt): Boolean;
begin
  Result := IndexOf(Value) <> -1;
end;

function TIntegerList.GetEnumerator: TEnumerator;
begin
  Result := TEnumerator.Create(Self)
end;

function TIntegerList.GetItem(const Index: Integer): TListInt;
begin
  if ((Index >= 0) and (Index < FDataCount)) then
    Result := FData[Index]
  else
    Result := Low(Integer);
end;

function TIntegerList.GetMemAddr: Pointer;
begin
  if (FDataCount > 0) then
    Result := @FData[0]
  else
    Result := nil;
end;

function TIntegerList.GetRandomValue: TListInt;
begin
  if (FDataCount > 0) then
    Result := FData[Random(FDataCount)]
  else
    Result := 0;
end;

function TIntegerList.GetValueAtIndex(const Index: Integer): TListInt;
begin
  if ((Index >= 0) and (Index < FDataCount)) then
    Result := FData[Index]
  else
    Result := 0;
end;

function TIntegerList.GetValuesAvg: TListInt;
begin
  if (FDataCount > 0) then
    Result := GetValuesSum div FDataCount
  else
    Result := 0;
end;

function TIntegerList.GetValuesMax: TListInt;
var
  I: Integer;
begin
  if (FDataCount < 1) then
    Exit(0);

  Result := FData[0];

  for I := 1 to (FDataCount - 1) do
    Result := Max(Result, FData[I]);
end;

function TIntegerList.GetValuesMin: TListInt;
var
  I: Integer;
begin
  if (FDataCount < 1) then
    Exit(0);

  Result := FData[0];

  for I := 1 to (Length(FData) - 1) do
    Result := Min(Result, FData[I]);
end;

function TIntegerList.GetValuesSum: TListInt;
var
  I: Integer;
begin
  Result := 0;

  for I := 0 to (FDataCount - 1) do
    Inc(Result, FData[I]);
end;

procedure TIntegerList.Include(const Value: TListInt);
begin
  if (IndexOf(Value) = -1) then
    Add(Value);
end;

procedure TIntegerList.IncrementValueAtIndex(const Index: Integer);
var
  StartAt, I: Integer;
begin
  if (Index < 0) then
    Exit;

  if (Index >= FDataCount) then
  begin
    StartAt := FDataCount;

    Request(Index + 1);

    for I := StartAt to Index do
      FData[I] := 0;

    FDataCount := Index + 1;
  end;

  Inc(FData[Index]);
end;

function TIntegerList.IndexOf(const Value: TListInt): Integer;
var
  I: Integer;
begin
  for I := 0 to (FDataCount - 1) do
    if (FData[I] = Value) then
      Exit(I);

  Result := -1;
end;

procedure TIntegerList.InsertFirst(const Value: TListInt);
var
  I: Integer;
begin
  Request(FDataCount + 1);

  for I := (FDataCount - 1) downto 1 do
    FData[I] := FData[I - 1];

  FData[0] := Value;
end;

procedure TIntegerList.InsertRepeatValue(const Value: TListInt; const Count: Integer);
var
  I: Integer;
begin
  Request(FDataCount + Count);

  for I := 0 to (Count - 1) do
    FData[FDataCount + I] := Value;

  Inc(FDataCount, Count);
end;

function TIntegerList.ListCompare(const Value1, Value2: TListInt): Integer;
begin
  Result := 0;

  if (Value1 < Value2) then
    Result := -1
  else
    if (Value1 > Value2) then
      Result := 1;
end;

procedure TIntegerList.ListSort(const Start, Stop: Integer);
var
  SplitPt: Integer;
begin
  if (Start < Stop) then
  begin
    SplitPt := ListSplit(Start, Stop);

    ListSort(Start, SplitPt - 1);
    ListSort(SplitPt + 1, Stop);
  end;
end;

function TIntegerList.ListSplit(const Start, Stop: Integer): Integer;
var
  Left, Right: Integer;
  Pivot: TListInt;
begin
  Left := Start + 1;
  Right := Stop;
  Pivot := FData[Start];

  while (Left <= Right) do
  begin
    while ((Left <= Stop) and (ListCompare(FData[Left], Pivot) < 0)) do
      Inc(Left);

    while ((Right > Start) and (ListCompare(FData[Right], Pivot) >= 0)) do
      Dec(Right);

    if (Left < Right) then
      ListSwap(Left, Right);
  end;

  ListSwap(Start, Right);
  Result := Right;
end;

procedure TIntegerList.ListSwap(const Index1, Index2: Integer);
var
  TempValue: TListInt;
begin
  TempValue := FData[Index1];
  FData[Index1] := FData[Index2];
  FData[Index2] := TempValue;
end;

procedure TIntegerList.LoadFromStream(const Stream: TStream);
var
  Amount, I: Integer;
begin
  Amount := Stream.GetLongInt;
  Request(Amount);

  for I := 0 to (Amount - 1) do
    FData[I] := Stream.GetLongInt;

  FDataCount := Amount;
end;

procedure TIntegerList.Remove(const Index: Integer);
var
  I: Integer;
begin
  if ((Index < 0) or (Index >= FDataCount)) then
    Exit;

  for I := Index to (FDataCount - 2) do
    FData[I] := FData[I + 1];

  Dec(FDataCount);
end;

procedure TIntegerList.RemoveDuplicates;
var
  I, J: Integer;
begin
  for J := (FDataCount - 1) downto 0 do
    for I := 0 to (J - 1) do
      if (FData[J] = FData[I]) then
      begin
        Remove(J);
        Break;
      end;
end;

procedure TIntegerList.Request(const NeedCapacity: Integer);
var
  NewCapacity, Capacity: Integer;
begin
  if (NeedCapacity < 1) then
    Exit;

  Capacity := Length(FData);

  if (Capacity < NeedCapacity) then
  begin
    NewCapacity :=
      ListGrowIncrement + Capacity + (Capacity div ListGrowFraction);

    if (NewCapacity < NeedCapacity) then
      NewCapacity :=
        ListGrowIncrement + NeedCapacity + (NeedCapacity div ListGrowFraction);

    SetLength(FData, RoundBy16(NewCapacity));
  end;
end;

function TIntegerList.SameAs(const OtherList: TIntegerList): Boolean;
var
  I: Integer;
begin
  { (1) Check if the list points to itself or if both lists are empty. }
  if ((Self = OtherList) or ((FDataCount < 1) and (OtherList.FDataCount < 1))) then
    Exit(True);

  { (2) If the lists have different number of elements, they are not equals. }
  if (FDataCount <> OtherList.FDataCount) then
    Exit(False);

  { (3) Test element one by one. }
  for I := 0 to (FDataCount - 1) do
    if (FData[I] <> OtherList.FData[I]) then
      Exit(False);

  Result := True;
end;

procedure TIntegerList.SaveToStream(const Stream: TStream);
var
  I: Integer;
begin
  Stream.PutLongInt(FDataCount);

  for I := 0 to (FDataCount - 1) do
    Stream.PutLongInt(FData[I]);
end;

procedure TIntegerList.Series(const NumCount: Integer);
var
  I: Integer;
begin
  Request(NumCount);
  FDataCount := NumCount;

  for I := 0 to (FDataCount - 1) do
    FData[I] := I;
end;

procedure TIntegerList.SetCount(const NewCount: Integer);
begin
  if (NewCount > 0) then
  begin
    Request(NewCount);
    FDataCount := NewCount;
  end else
    Clear;
end;

procedure TIntegerList.SetItem(const Index: Integer; const Value: TListInt);
begin
  if ((Index >= 0) and (Index < FDataCount)) then
    FData[Index] := Value;
end;

procedure TIntegerList.Shuffle;
var
  I: Integer;
begin
  for I := (FDataCount - 1) downto 1 do
    ListSwap(I, Random(I + 1));
end;

procedure TIntegerList.Sort;
begin
  if (FDataCount > 1) then
    ListSort(0, FDataCount - 1);
end;

procedure TIntegerList.Swap(const Index1, Index2: Integer);
begin
  if ((Index1 >= 0) and (Index1 < FDataCount) and
      (Index2 >= 0) and (Index2 < FDataCount)) then
    ListSwap(Index1, Index2);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{$IFDEF SUPPORTS_REGION}{$REGION 'TIntegerProbabilityList'}{$ENDIF}
{$IFDEF SUPPORTS_REGION}{$REGION 'TIntegerProbabilityList.TEnumerator'}{$ENDIF}
constructor TIntegerProbabilityList.TEnumerator.Create(const AList: TIntegerProbabilityList);
begin
  inherited Create;

  Increment_BC_ClassInstances;

  FList := AList;
  FIndex := -1;
end;

destructor TIntegerProbabilityList.TEnumerator.Destroy;
begin
  Decrement_BC_ClassInstances;

  inherited;
end;

function TIntegerProbabilityList.TEnumerator.GetCurrent: PDataSample;
begin
  Result := FList.Items[FIndex];
end;

function TIntegerProbabilityList.TEnumerator.MoveNext: Boolean;
begin
  Result := FIndex < FList.Count - 1;

  if (Result) then
    Inc(FIndex);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

function TIntegerProbabilityList.Add(const DataValue: TListInt; const Probability: Float): Integer;
var
  Index: Integer;
begin
  Index := FDataCount;
  Request(FDataCount + 1);

  FData[Index].Value := DataValue;
  FData[Index].Probability := Probability;
  Inc(FDataCount);

  Result := Index;
end;

procedure TIntegerProbabilityList.AddFrom(const Source: TIntegerProbabilityList);
var
  I: Integer;
begin
  Request(FDataCount + Source.FDataCount);

  for I := 0 to (Source.FDataCount - 1) do
    FData[I + FDataCount] := Source.FData[I];

  Inc(FDataCount, Source.FDataCount);
end;

procedure TIntegerProbabilityList.Clear;
begin
  FDataCount := 0;
end;

procedure TIntegerProbabilityList.CopyFrom(const Source: TIntegerProbabilityList);
var
  I: Integer;
begin
  Request(Source.FDataCount);

  for I := 0 to (Source.FDataCount - 1) do
    FData[I] := Source.FData[I];

  FDataCount := Source.FDataCount;
end;

constructor TIntegerProbabilityList.Create;
begin
  inherited;

  Increment_BC_ClassInstances;
end;

destructor TIntegerProbabilityList.Destroy;
begin
  Decrement_BC_ClassInstances;

  inherited;
end;

procedure TIntegerProbabilityList.Exclude(const DataValue: TListInt);
begin
  Remove(IndexOf(DataValue));
end;

function TIntegerProbabilityList.Exists(const DataValue: TListInt): Boolean;
begin
  Result := IndexOf(DataValue) <> -1;
end;

function TIntegerProbabilityList.ExtractRandomValue: TListInt;
var
  Sample, SampleMax, SampleIn: Float;
  I, SampleNo: Integer;
begin
  Result := 0;
  if (FDataCount < 1) then
    Exit;

  SampleMax := 0.0;

  for I := 0 to (FDataCount - 1) do
    SampleMax := SampleMax + FData[I].Probability;

  Sample := Random * SampleMax;

  SampleIn := 0.0;
  SampleNo := -1;

  for I := 0 to (FDataCount - 1) do
  begin
    if ((Sample >= SampleIn) and
        (Sample < SampleIn + FData[I].Probability)) then
    begin
      Result := FData[I].Value;
      SampleNo := I;

      Break;
    end;

    SampleIn := SampleIn + FData[I].Probability;
  end;

  if (SampleNo <> -1) then
    Remove(SampleNo);
end;

function TIntegerProbabilityList.GetEnumerator: TEnumerator;
begin
  Result := TEnumerator.Create(Self);
end;

function TIntegerProbabilityList.GetItem(const Index: Integer): PDataSample;
begin
  if ((Index >= 0) and (Index < FDataCount)) then
    Result := @FData[Index]
  else
    Result := nil;
end;

function TIntegerProbabilityList.GetMemAddr: Pointer;
begin
  Result := @FData[0];
end;

function TIntegerProbabilityList.GetProbability(const DataValue: TListInt): Float;
var
  Index: Integer;
begin
  Index := IndexOf(DataValue);

  if (Index <> -1) then
    Result := FData[Index].Probability
  else
    Result := 0;
end;

function TIntegerProbabilityList.GetRandomValue: TListInt;
var
  Sample, SampleMax, SampleIn: Float;
  I: Integer;
begin
  Result := 0;
  if (FDataCount < 1) then
    Exit;

  SampleMax := 0;

  for I := 0 to (FDataCount - 1) do
    SampleMax := SampleMax + FData[I].Probability;

  Sample := Random * SampleMax;

  SampleIn := 0;
  for I := 0 to (FDataCount - 1) do
  begin
    if ((Sample >= SampleIn) and
        (Sample < SampleIn + FData[I].Probability)) then
      Exit(FData[I].Value);

    SampleIn := SampleIn + FData[I].Probability;
  end;
end;

function TIntegerProbabilityList.GetValue(const Index: Integer): Integer;
begin
  if ((Index >= 0) and (Index < FDataCount)) then
    Result := FData[Index].Value
  else
    Result := 0;
end;

procedure TIntegerProbabilityList.Include(const DataValue: TListInt; const Probability: Float);
var
  Index: Integer;
begin
  Index := IndexOf(DataValue);

  if (Index <> -1) then
    FData[Index].Probability := Probability
  else
    Add(DataValue, Probability);
end;

function TIntegerProbabilityList.IndexOf(const DataValue: TListInt): Integer;
var
  I: Integer;
begin
  Result := -1;

  for I := 0 to (FDataCount - 1) do
    if (FData[I].Value = DataValue) then
    begin
      Result := I;
      Break;
    end;
end;

procedure TIntegerProbabilityList.LoadFromStream(const Stream: TStream);
var
  I, Total: Integer;
begin
  Total := Stream.GetLongInt;

  Request(Total);

  for I := 0 to (Total - 1) do
  begin
    FData[I].Value := Stream.GetLongInt;
    FData[I].Probability := Stream.GetSingle;
  end;

  FDataCount := Total;
end;

procedure TIntegerProbabilityList.NormalizeProbabilities;
var
  I: Integer;
  Total: Float;
begin
  Total := 0;

  for I := 0 to (FDataCount - 1) do
    Total := Total + FData[I].Probability;

  if (Total <= 0) then
    Exit;

  for I := 0 to (FDataCount - 1) do
    FData[I].Probability := FData[I].Probability / Total;
end;

procedure TIntegerProbabilityList.Remove(const Index: Integer);
var
  I: Integer;
begin
  if ((Index < 0) or (Index >= FDataCount)) then
    Exit;

  for I := Index to (FDataCount - 2) do
    FData[I] := FData[I + 1];

  Dec(FDataCount);
end;

procedure TIntegerProbabilityList.Request(const NeedCapacity: Integer);
var
  NewCapacity, Capacity: Integer;
begin
  if (NeedCapacity < 1) then
    Exit;

  Capacity := Length(FData);

  if (Capacity < NeedCapacity) then
  begin
    NewCapacity :=
      ListGrowIncrement + Capacity + (Capacity div ListGrowFraction);

    if (NewCapacity < NeedCapacity) then
      NewCapacity :=
        ListGrowIncrement + NeedCapacity + (NeedCapacity div ListGrowFraction);

    SetLength(FData, RoundBy16(NewCapacity));
  end;
end;

procedure TIntegerProbabilityList.SaveToStream(const Stream: TStream);
var
  I: Integer;
begin
  Stream.PutLongInt(FDataCount);

  for I := 0 to (FDataCount - 1) do
  begin
    Stream.PutLongInt(FData[I].Value);
    Stream.PutSingle(FData[I].Probability);
  end;
end;

procedure TIntegerProbabilityList.ScaleProbability(const DataValue: TListInt; const Scale: Float);
var
  Index: Integer;
begin
  Index := IndexOf(DataValue);

  if (Index <> -1) then
    FData[Index].Probability := FData[Index].Probability * Scale;
end;

procedure TIntegerProbabilityList.ScaleProbabilityExcept(const DataValue: TListInt; const Scale: Float);
var
  I: Integer;
begin
  for I := 0 to (FDataCount - 1) do
    if (FData[I].Value <> DataValue) then
      FData[I].Probability := FData[I].Probability * Scale;
end;

procedure TIntegerProbabilityList.Series(const MaxValue: TListInt; const Probability: Float);
var
  CurValue: TListInt;
begin
  Clear;
  CurValue := 0;

  while (CurValue < MaxValue) do
  begin
    Add(CurValue, Probability);
    Inc(CurValue);
  end;
end;

procedure TIntegerProbabilityList.SetProbability(const DataValue: TListInt; const Probability: Float);
var
  Index: Integer;
begin
  Index := IndexOf(DataValue);

  if (Index <> -1) then
    FData[Index].Probability := Probability
  else
    Add(DataValue, Probability);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

end.
