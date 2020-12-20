{===============================================================================

  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

===============================================================================}

{-------------------------------------------------------------------------------
 A collection of basic classes such as lists, enumerators and containers that
 help you in your software development.

 Version 0.1.3

 Copyright (c) 2018-2020, Piotr Domañski

 Last change:
   18-12-2020

 Changelog:
   For detailed changelog and history please refer to this git repository:
     https://github.com/dompiotr85/Lib.BasicClasses

 Contacts:
   Piotr Domañski (dom.piotr.85@gmail.com)

 Dependencies:
   - JEDI common files (https://github.com/project-jedi/jedi)
   - Lib.TypeDefinitions (https://github.com/dompiotr85/Lib.TypeDefinitions)
-------------------------------------------------------------------------------}

{$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
/// <summary>
///   A collection of basic classes such as lists, enumerators and containers
///   that help you in your software development.
/// </summary>
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
unit BasicClasses.Lists;

{$INCLUDE BasicClasses.Config.inc}

interface

uses
  {$IFDEF HAS_UNITSCOPE}System.Types{$ELSE}Types{$ENDIF},
  {$IFDEF HAS_UNITSCOPE}System.Classes{$ELSE}Classes{$ENDIF},
  {$IFDEF HAS_UNITSCOPE}System.SysUtils{$ELSE}SysUtils{$ENDIF},
  TypeDefinitions,
  BasicClasses;

{===============================================================================
  TCustomList - class declaration
===============================================================================}

{$IFDEF SUPPORTS_REGION}{$REGION 'TCustomList declaration'}{$ENDIF}
type
  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Grow mode type.
  /// </summary>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  TGrowMode = (
    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Grow by <i>1</i>.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    gmSlow,

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Grow by <i>GrowFactor</i> (integer part of the float).
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    gmLinear,

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Grow by <i>capacity * GrowFactor</i>.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    gmFast,

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   If capacity is below <i>GrowLimit</i>, grow by <i>capacity * GrowFactor</i>.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    gmFastAttenuated);

  {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Shrink mode type.
  /// </summary>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  TShrinkMode = (
    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   List is not shrinked, <i>Capacity</i> is preserved.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    smKeepCap,

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   If <i>Capacity</i> is above <i>ShrinkLimit</i> and <i>Count</i> is
    ///   bellow <i>(Capacity * ShrinkFactor) / 2</i>, then <i>Capacity</i> is
    ///   set to <i>Capacity * ShrinkFactor</i>, otherwise <i>Capacity</i> is
    ///   preserved.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    smNormal,

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   <i>Capacity</i> is set to <i>Count</i>.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    smToCount);

  {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Structure used to store grow settings in one place.
  /// </summary>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  TListGrowSettings = record
    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Grow mode.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    GrowMode: TGrowMode;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Grow factor.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    GrowFactor: Float64;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Grow limit.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    GrowLimit: SizeUInt;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Shrink mode.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    ShrinkMode: TShrinkMode;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Shrink factor.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    ShrinkFactor: Float64;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Shrink limit.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    ShrinkLimit: SizeUInt;
  end;

  {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Pointer to <i>TListGrowSettings</i>.
  /// </summary>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  PListGrowSettings = ^TListGrowSettings;

  {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

const
  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Default list grow/shrink settings.
  /// </summary>
  /// <remarks>
  ///   <i>GrowMode</i> is set to <i>gmFast</i>, <i>GrowFactor</i> is set to
  ///   <i>1.0</i>, <i>GrowLimit</i> is set to value equal
  ///   <i>128 * 1024 * 1024</i>, <i>ShrinkMode</i> is set to <i>smNormal</i>,
  ///   <i>ShrinkFactor</i> is set to <i>0.5</i> and <i>ShrinkLimit</i> is set
  ///   to <i>256</i>.
  /// </remarks>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  BC_LIST_GROW_SETTINGS_DEFAULT: TListGrowSettings = (
    GrowMode: gmFast;
    GrowFactor: 1.0;
    GrowLimit: 128 * 1024 * 1024;
    ShrinkMode: smNormal;
    ShrinkFactor: 0.5;
    ShrinkLimit: 256);

  {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

type
  PCustomList = ^TCustomList;

  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Implements methods for advanced parametrized growing and shrinking of
  ///   any list and a few more.
  /// </summary>
  /// <remarks>
  ///   Expects derived class to properly implement <i>Capacity</i> and
  ///   <i>Count</i> properties (both getters and setters) and <i>LowIndex</i>
  ///   and <i>HighIndex</i> functions.
  /// </remarks>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  TCustomList = class(TCustomObject)
  private
    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   List Grow Settings.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    FListGrowSettings: TListGrowSettings;
  protected
    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves current capacity of the list and returns its value.
    /// </summary>
    /// <returns>
    ///   Returns current capacity of the list.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetCapacity: SizeUInt; virtual; abstract;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Sets new capacity of the list.
    /// </summary>
    /// <param name="Value">
    ///   New capacity value.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure SetCapacity(NewCapacity: SizeUInt); virtual; abstract;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves current count of the list and returns its value.
    /// </summary>
    /// <returns>
    ///   Returns current count of the list.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetCount: SizeUInt; virtual; abstract;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Sets new count value of the list.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure SetCount(NewCount: SizeUInt); virtual; abstract;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Grows the list.
    /// </summary>
    /// <param name="MinDelta">
    ///   Minimal delta value. Default is <i>1</i>.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure Grow(MinDelta: SizeUInt = 1); virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Shrinks the list.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure Shrink; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  public
    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Default constructor.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    constructor Create;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves low index of the list and returns its value.
    /// </summary>
    /// <returns>
    ///   Returns low index value.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function LowIndex: SizeInt; virtual; abstract;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves high index of the list and returns its value.
    /// </summary>
    /// <returns>
    ///   Returns high index value.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function HighIndex: SizeInt; virtual; abstract;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Checks that specified <i>Index</i> is valid. Returns <i>True</i> if
    ///   specified <i>Index</i> is valid, otherwise returns <i>False</i>.
    /// </summary>
    /// <param name="Index">
    ///   Index value.
    /// </param>
    /// <returns>
    ///   Returns <i>True</i> if specified <i>Index</i> is valid, otherwise
    ///   returns <i>False</i>.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function CheckIndex(Index: SizeUInt): Boolean; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Copies grow settings from specified <i>Source</i> parameter to this
    ///   list.
    /// </summary>
    /// <param name="Source">
    ///   Other list from which grow settings will be copied.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure CopyGrowSettings(Source: TCustomList); virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   List's grow settings.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    property ListGrowSettings: TListGrowSettings read FListGrowSettings write FListGrowSettings;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   List's grow mode.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    property GrowMode: TGrowMode read FListGrowSettings.GrowMode write FListGrowSettings.GrowMode;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   List's grow factor value.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    property GrowFactor: Float64 read FListGrowSettings.GrowFactor write FListGrowSettings.GrowFactor;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   List's grow limit value.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    property GrowLimit: SizeUInt read FListGrowSettings.GrowLimit write FListGrowSettings.GrowLimit;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   List's shrink mode value.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    property ShrinkMode: TShrinkMode read FListGrowSettings.ShrinkMode write FListGrowSettings.ShrinkMode;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   List's shrink factor value.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    property ShrinkFactor: Float64 read FListGrowSettings.ShrinkFactor write FListGrowSettings.ShrinkFactor;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   List's shrink limit value.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    property ShrinkLimit: SizeUInt read FListGrowSettings.ShrinkLimit write FListGrowSettings.ShrinkLimit;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   List's capacity value.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    property Capacity: SizeUInt read GetCapacity write SetCapacity;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   List's count value.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    property Count: SizeUInt read GetCount write SetCount;
  end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{===============================================================================
  TCustomMultiList - class declaration
===============================================================================}

{$IFDEF SUPPORTS_REGION}{$REGION 'TCustomMultiList declaration'}{$ENDIF}
type
  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Very similar to <i>TCustomListObject</i>, but this class can support
  ///   multiple separate lists that are distinguished by index (integer).
  /// </summary>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  TCustomMultiList = class(TCustomObject)
  private
    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Dynamic array holding List Grow Settings.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    FListGrowSettings: array of TListGrowSettings;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves amount of stored lists and returns that value.
    /// </summary>
    /// <returns>
    ///   Results amount of stored lists.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetListCount: SizeUInt; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Sets new amount of stored lists.
    /// </summary>
    /// <param name="Value">
    ///   New amount of stored lists.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure SetListCount(Value: SizeUInt); virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves <i>ListGrowSettings</i> for specified list's <i>Index</i>
    ///   and return it.
    /// </summary>
    /// <param name="List">
    ///   Index value of stored list.
    /// </param>
    /// <returns>
    ///   Returns <i>ListGrowSettings</i> for the list's specified <i>Index</i>.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetListGrowSettings(Index: SizeUInt): TListGrowSettings; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Sets new <i>ListGrowSettings</i> for specified list's <i>Index</i>.
    /// </summary>
    /// <param name="Index">
    ///   List's <i>Index</i>.
    /// </param>
    /// <param name="Value">
    ///   New <i>ListGrowSettings</i>.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure SetListGrowSettings(Index: SizeUInt; Value: TListGrowSettings); virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves <i>ListGrowSettings</i> for specified list's <i>Index</i>
    ///   and return its pointer.
    /// </summary>
    /// <param name="Index">
    ///   List's <i>Index</i>.
    /// </param>
    /// <returns>
    ///   Returns pointer to ListGrowSettings of specified list by its
    ///   <i>Index</i>.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetListGrowSettingsPtr(Index: SizeUInt): PListGrowSettings; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  protected
    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves capacity of specified list by its <i>Index</i> and returns
    ///   that value.
    /// </summary>
    /// <param name="Index">
    ///   List's <i>Index</i>.
    /// </param>
    /// <returns>
    ///   Returns capacity value of specified list by its <i>Index</i>.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetCapacity(Index: SizeUInt): SizeUInt; virtual; abstract;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Sets new capacity for specified list by its <i>Index</i>.
    /// </summary>
    /// <param name="Index">
    ///   List's <i>Index</i>.
    /// </param>
    /// <param name="Value">
    ///   New capacity value.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure SetCapacity(Index, Value: SizeUInt); virtual; abstract;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves current size of specified list by its <i>Index</i> and
    ///   returns it.
    /// </summary>
    /// <param name="Index">
    ///   List's <i>Index</i>.
    /// </param>
    /// <returns>
    ///   Returns current size of specified list.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetCount(Index: SizeUInt): SizeUInt; virtual; abstract;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Sets new size of specified list by its <i>Index</i>.
    /// </summary>
    /// <param name="Index">
    ///   List's <i>Index</i>.
    /// </param>
    /// <param name="Value">
    ///   New size value.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure SetCount(Index, Value: SizeUInt); virtual; abstract;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Grows specified list by its <i>Index</i> by specified <i>MinDelta</i>.
    /// </summary>
    /// <param name="Index">
    ///   List's <i>Index</i>.
    /// </param>
    /// <param name="MinDelta">
    ///   Grow value. Default: <i>1</i>.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure Grow(Index: SizeUInt; MinDelta: SizeUInt = 1); virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Shrinks specified list by its <i>Index</i>.
    /// </summary>
    /// <param name="Index">
    ///   List's <i>Index</i>.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure Shrink(Index: SizeUInt); virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  public
    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Default constructor.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    constructor Create; overload;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Constructor with initial <i>ListCount</i>.
    /// </summary>
    /// <param name="ListCount">
    ///   Initial <i>ListCount</i> value.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    constructor Create(ListCount: SizeUInt); overload;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Default destructor.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    destructor Destroy; override;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves low index of this list and returns the value.
    /// </summary>
    /// <returns>
    ///   Returns low index of this list.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function LowList: SizeUInt; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves high index of this list and returns the value.
    /// </summary>
    /// <returns>
    ///   Returns high index of this list.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function HighList: SizeUInt; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves low index of specified list by its <i>Index</i> and returns
    ///   that value.
    /// </summary>
    /// <param name="Index">
    ///   List's <i>Index</i>.
    /// </param>
    /// <returns>
    ///   Returns low index of specified list by its <i>Index</i>.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function LowIndex(Index: SizeUInt): SizeUInt; virtual; abstract;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves high index of specified list by its <i>Index</i> and returns
    ///   that value.
    /// </summary>
    /// <param name="Index">
    ///   List's <i>Index</i>.
    /// </param>
    /// <returns>
    ///   Returns high index of specified list by its <i>Index</i>.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function HighIndex(Index: SizeUInt): SizeUInt; virtual; abstract;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Checks that specified list's <i>Index</i> is valid and returns
    ///   <i>True</i> or <i>False</i> as a validation result.
    /// </summary>
    /// <param name="Index">
    ///   List's <i>Index</i>.
    /// </param>
    /// <returns>
    ///   Returns <i>True</i> if specified list's <i>Index</i> is valid,
    ///   otherwise returns <i>False</i>.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function CheckList(Index: SizeUInt): Boolean; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Checks that specified <i>ListIndex</i> is valid for specified list's
    ///   <i>Index</i> and returns <i>True</i> or <i>False</i> as a validation
    ///   result.
    /// </summary>
    /// <param name="Index">
    ///   List's <i>Index</i>.
    /// </param>
    /// <param name="ListIndex">
    ///   Specified list's <i>ListIndex</i>.
    /// </param>
    /// <returns>
    ///   Returns <i>True</i> if specified <i>ListIndex</i> is valid for
    ///   specified list's <i>Index</i>, otherwise return <i>False</i>.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function CheckIndex(Index, ListIndex: SizeUInt): Boolean; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Copies GrowSettings from <i>Source</i> multi-list.
    /// </summary>
    /// <param name="Source">
    ///   Reference to other multi-list instance from which GrowSettings will be
    ///   copied from.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure CopyGrowSettings(Source: TCustomMultiList); virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Returns amount of stored list in this multi-list.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    property ListCount: SizeUInt read GetListCount write SetListCount;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Returns <i>ListGrowSettings</i> for the list with specified
    ///   <i>Index</i>.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    property ListGrowSettings[&Index: SizeUInt]: TListGrowSettings read GetListGrowSettings write SetListGrowSettings;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Returns pointer to <i>ListGrowSettings</i> for the list with specified
    ///   <i>Index</i>.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    property ListGrowSettingsPtrs[&Index: SizeUInt]: PListGrowSettings read GetListGrowSettingsPtr;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Returns capacity for the list with specified <i>Index</i>.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    property Capacity[&Index: SizeUInt]: SizeUInt read GetCapacity write SetCapacity;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Returns size for the list with specified <i>Index</i>.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    property Count[&Index: SizeUInt]: SizeUInt read GetCount write SetCount;
  end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{===============================================================================
  TBCList - class declaration
===============================================================================}

{$IFDEF SUPPORTS_REGION}{$REGION 'TBCList declaration'}{$ENDIF}

type
  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   TBCList exception class.
  /// </summary>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  EBCListError = class(Exception);

  {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Basic pointer list definition.
  /// </summary>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  TBCList = class(TCustomList)
  public type

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Basic pointer list enumerator definition.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    TEnumerator = class
    private
      {$IFDEF AUTOREFCOUNT}[weak]{$ENDIF} FList: TBCList;
      FIndex: SizeInt;

      {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    public
      {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
      /// <summary>
      ///   Default constructor. Do NOT use directly! Rather call GetEnumerator
      ///   method of TBCList class.
      /// </summary>
      /// <param name="AList">
      ///   Reference to the source list instance.
      /// </param>
      {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
      constructor Create(AList: TBCList);

      {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

      {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
      /// <summary>
      ///   Retrieves pointer of the current item and returns it.
      /// </summary>
      /// <returns>
      ///   Returns pointer of the current item.
      /// </returns>
      {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
      function GetCurrent: Pointer; inline;

      {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

      {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
      /// <summary>
      ///   Moves to the next item in the list and returns True if end of the
      ///   list is NOT reached. Otherwise returns False.
      /// </summary>
      /// <returns>
      ///   Returns True if end of the list is NOT reached, otherwise returns
      ///   False.
      /// </returns>
      {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
      function MoveNext: Boolean; inline;

      {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

      {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
      /// <summary>
      ///   Retrieves pointer to the current item and returns it.
      /// </summary>
      {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
      property Current: Pointer read GetCurrent;

      {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
      /// <summary>
      ///   Returns current index position of enumerator.
      /// </summary>
      {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
      property &Index: SizeInt read FIndex;
    end;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Basic pointer list reverse enumerator definition.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    TReverseEnumerator = class
    private
      {$IFDEF AUTOREFCOUNT}[weak]{$ENDIF} FList: TBCList;
      FIndex: SizeInt;

      {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    public
      {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
      /// <summary>
      ///   Default constructor. Do NOT use directly! Rather call
      ///   GetReverseEnumerator method of TBCList class.
      /// </summary>
      /// <param name="AList">
      ///   Reference to the source list instance.
      /// </param>
      {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
      constructor Create(AList: TBCList);

      {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

      {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
      /// <summary>
      ///   Retrieves pointer of the current item and returns it.
      /// </summary>
      /// <returns>
      ///   Returns pointer of the current item.
      /// </returns>
      {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
      function GetCurrent: Pointer; inline;

      {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

      {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
      /// <summary>
      ///   Moves to the next item in the list and returns True if end of the
      ///   list is NOT reached. Otherwise returns False.
      /// </summary>
      /// <returns>
      ///   Returns True if end of the list is NOT reached, otherwise returns
      ///   False.
      /// </returns>
      {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
      function MoveNext: Boolean; inline;

      {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

      {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
      /// <summary>
      ///   Retrieves pointer to the current item and returns it.
      /// </summary>
      {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
      property Current: Pointer read GetCurrent;

      {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
      /// <summary>
      ///   Returns current index position of enumerator.
      /// </summary>
      {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
      property &Index: SizeInt read FIndex;
    end;

  private
    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Dynamic list of pointers.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    FList: TPointerList;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Current amount of items in the list.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    FCount: SizeUInt;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Capacity of the list.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    FCapacity: SizeUInt;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  protected
    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves list's item with specified Index position and returns it as
    ///   pure pointer.
    /// </summary>
    /// <param name="Index">
    ///   Index position of item that will be retrieved and returned.
    /// </param>
    /// <returns>
    ///   Returns pointer to the retrieved item.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetItem(const Index: SizeUInt): Pointer;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Sets new item at specified Index position of the list.
    /// </summary>
    /// <param name="Index">
    ///   Index position where specified item should be stored at.
    /// </param>
    /// <param name="Item">
    ///   Pointer to the item.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure SetItem(const Index: SizeUInt; Item: Pointer);

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Notify method calls implemented code that should handle management of
    ///   stored items.
    /// </summary>
    /// <param name="Ptr">
    ///   Pointer to the item.
    /// </param>
    /// <param name="Action">
    ///   List notification type.
    /// </param>
    /// <remarks>
    ///   This method should be implemented by the user.
    /// </remarks>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure Notify(Ptr: Pointer; Action: TListNotification); virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves the current capacity of the list and returns it.
    /// </summary>
    /// <returns>
    ///   Returns the current capacity of the list.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetCapacity: SizeUInt; override;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Sets new capacity of the list.
    /// </summary>
    /// <param name="NewCapacity">
    ///   New capacity value.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure SetCapacity(NewCapacity: SizeUInt); override;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves the current amount of items stored in the list and returns
    ///   it.
    /// </summary>
    /// <returns>
    ///   Returns the current amount of items stored in the list.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetCount: SizeUInt; override;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Sets new amount of items in the list.
    /// </summary>
    /// <param name="NewCount">
    ///   New amount of items in the list.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure SetCount(NewCount: SizeUInt); override;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves the pointer to a dynamic array which stores list's items and
    ///   return it.
    /// </summary>
    /// <returns>
    ///   Returns the pointer to a dynamic array which stores list's items.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetMemAddr: Pointer;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  public
    type
      TDirection = System.Types.TDirection;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Default constructor.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    constructor Create;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Default destructor.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    destructor Destroy; override;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Adds new item to the end of the list and returns its new index
    ///   position.
    /// </summary>
    /// <param name="Item">
    ///   Pointer to the new item that will be added to the list.
    /// </param>
    /// <returns>
    ///   Returns index position of newly added item.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function Add(Item: Pointer): SizeUInt;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Clears all items stored in the list and sets its parameters to the
    ///   default values.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure Clear; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Copies all entries from Source list to this list.
    /// </summary>
    /// <param name="Source">
    ///   Reference to source list from which copy operation will be made.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure CopyFrom(const Source: TBCList);

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Deletes item from specified <i>Index</i> position of the list.
    /// </summary>
    /// <remarks>
    ///   This method notifies about item deletion if <i>Notify</i> method
    ///   implemented.
    /// </remarks>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure Delete(Index: SizeUInt);

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Raises EBCListError exception with specified informations.
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
    ///   Raises EBCListError exception with specified informations.
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
    ///   Performs exchange of two items in the list.
    /// </summary>
    /// <param name="Index1">
    ///   Index position of first item that will be replaced.
    /// </param>
    /// <param name="Index2">
    ///   Index position of second item that will be replaced.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure Exchange(Index1, Index2: SizeUInt);

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Expands the list by one item and returns it self.
    /// </summary>
    /// <returns>
    ///   Returns it self.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function Expand: TBCList;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Performs extraction operation for specified <i>Item</i>. In other
    ///   words, removes a specified item from the list. Call Extract to remove
    ///   an item from the list. After the item is removed, all the objects that
    ///   follow it are moved up in index position and Count is decremented.
    ///   To remove the reference to an item without deleting the entry from the
    ///   Items array and changing the Count, set the Items property for Index
    ///   to <i>nil</i>.
    /// </summary>
    /// <param name="Item">
    ///   Pointer to the item that need to be extracted.
    /// </param>
    /// <returns>
    ///   Returns pointer to the extracted item or nil if nothing was found.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function Extract(Item: Pointer): Pointer; inline;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Removes and returns a list entry, looping through the list items in
    ///   the specified direction. This function is identical to Extract, only
    ///   that it allows you to specify in which Direction to search the list,
    ///   which allows you to increase the performance of this operation if you
    ///   know whether Value is towards the beginning or towards the end of the
    ///   list.
    /// </summary>
    /// <param name="Item">
    ///   Pointer to the item that need to be extracted.
    /// </param>
    /// <param name="Direction">
    ///   Direction of search loop.
    /// </param>
    /// <returns>
    ///   Returns pointer to the extracted item or nil if nothing was found.
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ExtractItem(Item: Pointer; Direction: TDirection): Pointer;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves pointer to the first item in the list and returns it.
    ///   If the list is empty, nil will be returned. Call First to get the
    ///   first pointer in the Items array.
    /// </summary>
    /// <returns>
    ///   Returns pointer to the first item in the list. If the list is empty,
    ///   nil will be returned.
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function First: Pointer; inline;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves index position of the first item in the list and returns it.
    ///   If the list is empty, -1 will be returned.
    /// </summary>
    /// <returns>
    ///   Returns index position of the first item in the list/ If the list is
    ///   empty, -1 will be returned.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function LowIndex: SizeInt; override;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Returns a TBCList enumerator.
    ///   GetEnumerator returns a TBCList.TEnumerator reference, which
    ///   enumerates all items in the list. To do so, call the
    ///   TBCList.TEnumerator GetCurrent method within a while MoveNext do loop.
    /// </summary>
    /// <returns>
    ///   Reference to the list enumerator.
    /// </returns>
    /// <remarks>
    ///   It is user's responsibility to release retrieved enumerator by calling
    ///   Free() method.
    /// </remarks>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetEnumerator: TBCList.TEnumerator; inline;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Returns a TBCList reverse enumerator.
    ///   GetReverseEnumerator returns a TBCList.TReverseEnumerator reference,
    ///   which enumerates all items in the list. To do so, call the
    ///   TBCList.TReverseEnumerator GetCurrent method within a while MoveNext
    ///   do loop.
    /// </summary>
    /// <returns>
    ///   Reference to the list reverse enumerator.
    /// </returns>
    /// <remarks>
    ///   It is user's responsibility to release retrieved reverse enumerator by
    ///   calling its Free() method.
    /// </remarks>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetReverseEnumerator: TBCList.TReverseEnumerator; inline;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Returns the index of the first entry in the Items array with
    ///   a specified value.
    ///   Call IndexOf to get the index for a pointer in the Items array.
    ///   Specify the pointer as the Item parameter.
    ///   The first item in the array has index 0, the second item has index 1,
    ///   and so on. If an item is not in the list, IndexOf returns -1.
    ///   If a pointer appears more than once in the array, IndexOf returns the
    ///   index of the first appearance.
    /// </summary>
    /// <param name="Item">
    ///   Pointer to the item that will be searched for.
    /// </param>
    /// <returns>
    ///   Returns the index of the first entry in the Items array with
    ///   a specified value or -1 if nothing was found.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function IndexOf(Item: Pointer): SizeInt;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Returns the item's index.
    ///   Call IndexOfItem to determine the location of an item in the TList
    ///   list, using a linear search. If the item is not found, -1 is returned.
    ///   To increase the performance of this operation, if you know whether
    ///   Item is towards the beginning or towards the end of the list you can
    ///   use Direction parameter.
    /// </summary>
    /// <param name="Item">
    ///   Pointer to the Item that will be searched for.
    /// </param>
    /// <param name="Direction">
    ///   Direction of search loop.
    /// </param>
    /// <returns>
    ///   Returns index position of the item that was found or -1 when nothing
    ///   was found.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function IndexOfItem(Item: Pointer; Direction: TDirection): SizeInt;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Adds an object to the Items array at the position specified by Index.
    ///   Call Insert to add Item to the middle of the Items array. The Index
    ///   parameter is a zero-based index, so the first position in the array
    ///   has an index of 0. Insert adds the item at the indicated position,
    ///   shifting the item that previously occupied that position, and all
    ///   subsequent items, up. Insert increments Count and, if necessary,
    ///   allocates memory by increasing the value of Capacity.
    ///   To replace a nil pointer in the array with a new item, without growing
    ///   the Items array, set the Items property.
    /// </summary>
    /// <param name="Index">
    ///   Index position where new item will be inserted into the list.
    /// </param>
    /// <param name="Item">
    ///   Pointer to new Item that will be inserted into the list.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure Insert(Index: SizeUInt; Item: Pointer);

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves pointer to the last item in the list and returns it.
    ///   Call Last to retrieve the last pointer in the Items array.
    ///   If the list is empty, nil will be returned.
    /// </summary>
    /// <returns>
    ///   Returns pointer to the last item in the list. If the list is empty,
    ///   nil will be returned.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function Last: Pointer;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves index position of the last item in the list and returns it.
    ///   If the list is empty, -1 will be returned.
    /// </summary>
    /// <returns>
    ///   Returns index position of the last item in the list. If the list is
    ///   empty, -1 will be returned.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function HighIndex: SizeInt; override;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Changes the position of an item in the Items array. Call Move to move
    ///   the item at the position CurIndex so that it occupies the position
    ///   NewIndex. CurIndex and NewIndex are zero-based indexes into the Items
    ///   array.
    /// </summary>
    /// <param name="CurIndex">
    ///   Current index position of the item that will be moved.
    /// </param>
    /// <param name="NewIndex">
    ///   New index position of the item.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure Move(CurIndex, NewIndex: SizeUInt);

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Deletes the first reference to the Item parameter from the Items
    ///   array. Call Remove to remove a specific item from the Items array when
    ///   its index is unknown. The value returned is the index of the item in
    ///   the Items array before it was removed. After an item is removed, all
    ///   the items that follow it are moved up in index position and the Count
    ///   is reduced by one.
    ///   If the Items array contains more than one copy of the pointer, only
    ///   the first copy is deleted.
    /// </summary>
    /// <param name="Item">
    ///   Pointer to the item that will be removed from the list.
    /// </param>
    /// <returns>
    ///   Returns index position of removed item from the list or -1 if nothing
    ///   was found.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function Remove(Item: Pointer): SizeInt; inline;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Removes the first occurrence of value, looping through the list items
    ///   in the specified direction. In other words, it removes the first or
    ///   last occurrence of Value depending on the specified Direction.
    ///   RemoveItem is identical to Remove, only that it allows you to specify
    ///   in which Direction to search the list, so that you can remove the last
    ///   occurrence instead of the first one.
    /// </summary>
    /// <param name="Item">
    ///   Pointer to the item that will be searched for.
    /// </param>
    /// <param name="Direction">
    ///   Direction of search loop.
    /// </param>
    /// <returns>
    ///   Returns index position of removed item from the list or -1 if nothing
    ///   was found.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function RemoveItem(Item: Pointer; Direction: TDirection): SizeInt;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Deletes all nil items from the Items array. Call Pack to move all
    ///   non-nil items to the front of the Items array and reduce the Count
    ///   property to the number of items actually used. Pack does not free up
    ///   the memory used to store the nil pointers. To free up the memory for
    ///   the unused entries removed by Pack, set the Capacity property to the
    ///   new value of Count.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure Pack;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Performs a QuickSort on the list based on the comparison function
    ///   Compare. Call Sort to sort the items in the Items array. Compare is
    ///   a comparison function that indicates how the items are to be ordered.
    /// </summary>
    /// <param name="Compare">
    ///   Reference to comparison function that will be used in this operation.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure Sort(Compare: TListSortCompare);

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Performs a QuickSort on list of items. Call SortList to sort the Items
    ///   in the TBCList list.
    /// </summary>
    /// <param name="Compare">
    ///   TListSortCompareFunc as reference.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure SortList(const Compare: TListSortCompareFunc);

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Copies elements of one list to another. Call Assign to assign the
    ///   elements of another list to this one. Assign combines the source list
    ///   with this one using the logical operator specified by the AOperator
    ///   parameter.
    ///   If the ListB parameter is specified, then Assign first replaces all
    ///   the elements of this list with those in ListA, and then merges ListB
    ///   into this list using the operator specified by AOperator.
    ///   If the ListB parameter is not specified, then Assign merges ListA into
    ///   this list using the operator specified by AOperator.
    /// </summary>
    /// <param name="ListA">
    ///   Reference to ListA.
    /// </param>
    /// <param name="AOperator">
    ///   List assign operator type. Default is laCopy.
    /// </param>
    /// <param name="ListB">
    ///   Reference to ListB. Default is nil.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure Assign(ListA: TBCList; AOperator: TListAssignOp = laCopy; ListB: TBCList = nil);

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   <para>
    ///     Specifies the allocated size of the array of pointers maintained
    ///     by the <i>TBCList</i> class.
    ///   </para>
    ///   <para>
    ///     Set <i>Capacity</i> to the number of pointers the list will need
    ///     to contain. When setting the <i>Capacity</i> property, an <i>
    ///     EOutOfMemory</i> exception occurs if there is not enough memory
    ///     to expand the list to its new size.
    ///   </para>
    ///   <para>
    ///     Read <i>Capacity</i> to learn number of objects the list can hold
    ///     without reallocating memory.
    ///   </para>
    ///   <para>
    ///     Do not confuse <i>Capacity</i> with the <i>Count</i> property,
    ///     which is the number of entries in the list that are in use. The
    ///     value of <i>Capacity</i> is always greater than or equal to the
    ///     value of <i>Count</i>. When <i>Capacity</i> is greater than <i>
    ///     Count</i>, the unused memory can be reclaimed by setting <i>
    ///     Capacity</i> to <i>Count</i>.
    ///   </para>
    ///   <para>
    ///     When an object is added to a list that is already filled to
    ///     capacity, the <i>Capacity</i> property is automatically
    ///     increased. Setting <i>Capacity</i> before adding objects can
    ///     reduce the number of memory reallocations and thereby improve
    ///     performance. For example:
    ///   </para>
    ///   <code lang="Delphi">List.Clear;
    /// List.Capacity := Count;
    /// for I := 1 to Count do
    ///   List.Add(...);</code>
    ///   <para>
    ///     The assignment to <i>Capacity</i> before the for loop ensures
    ///     that each of the following <i>Add</i> operations doesn't cause
    ///     the list to be reallocated. Avoiding reallocations on the calls
    ///     to <i>Add</i> improves performance and ensures that the Add
    ///     operations never raise an exception.
    ///   </para>
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    property Capacity: SizeUInt read GetCapacity write SetCapacity;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   <para>
    ///     Indicates the number of entries in the list that are in use.
    ///   </para>
    ///   <para>
    ///     Read <i>Count</i> to determine the number of entries in the <see cref="BasicClasses.Lists|TBCList.Items[SizeUInt]">
    ///     Items</see> array.
    ///   </para>
    ///   <para>
    ///     Increasing the size of <i>Count</i> will add the necessary number
    ///     of nil pointers to the end of the <see cref="BasicClasses.Lists|TBCList.Items[SizeUInt]">
    ///     Items</see> array. Decreasing the size of <i>Count</i> will
    ///     remove the necessary number of entries from the end of the <see cref="BasicClasses.Lists|TBCList.Items[SizeUInt]">
    ///     Items</see> array.
    ///   </para>
    ///   <para>
    ///     <i>Count</i> is not always the same as the number of objects
    ///     referenced in the list. Some of the entries in the <see cref="BasicClasses.Lists|TBCList.Items[SizeUInt]">
    ///     Items</see> array may contain nil pointers. To remove the nil
    ///     pointers and set <i>Count</i> to the number of entries that
    ///     contain references to objects, call the <see cref="BasicClasses.Lists|TBCList.Pack">
    ///     Pack</see> method.
    ///   </para>
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    property Count: SizeUInt read GetCount write SetCount;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Pointer to memory address where list's items are allocated.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    property MemAddr: Pointer read GetMemAddr;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   <para>
    ///     Lists the object references.
    ///   </para>
    ///   <para>
    ///     Use <i>Items</i> to obtain a pointer to a specific object in the
    ///     array. The Index parameter indicates the index of the object,
    ///     where 0 is the index of the first object, 1 is the index of the
    ///     second object, and so on. Set <i>Items</i> to change the
    ///     reference at a specific location.
    ///   </para>
    ///   <para>
    ///     Use <i>Items</i> with the <see cref="BasicClasses.Lists|TBCList.Count">
    ///     Count</see> property to iterate through all of the objects in the
    ///     list.
    ///   </para>
    ///   <para>
    ///     Not all of the entries in the Items array need to contain
    ///     references to objects. Some of the entries may be nil pointers.
    ///     To remove the nil pointers and reduce the size of the <i>Items</i>
    ///      array to the number of objects, call the <see cref="BasicClasses.Lists|TBCList.Pack">
    ///     Pack</see> method.
    ///   </para>
    /// </summary>
    /// <remarks>
    ///   <i>Items</i> is the default property for TList. This means you can
    ///   omit the property name. Thus, instead of <i>MyList.Items[i]</i>, you
    ///   can write <i>MyList[i]</i>.
    /// </remarks>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    property Items[const &Index: SizeUInt]: Pointer read GetItem write SetItem; default;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   <para>
    ///     Specifies the array of pointers that make up the <i>Items</i>
    ///     array.
    ///   </para>
    ///   <para>
    ///     Use List to gain direct access to the <i>Items</i> array.
    ///   </para>
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    property List: TPointerList read FList;
  end;

{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{===============================================================================
  TIntegerList - class declaration
===============================================================================}

{$IFDEF SUPPORTS_REGION}{$REGION 'TIntegerList declaration'}{$ENDIF}

type
  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   TIntegerList exception class.
  /// </summary>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  EIntegerListError = class(Exception);

  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Pointer to <see cref="BasicClasses|TIntItem" />.
  /// </summary>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  PIntItem = ^TIntItem;

  {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Defines which type should be used in
  ///   <see cref="BasicClasses|TIntegerList" />. Enable or disable feature
  ///   <b>BC_IntegerListUsesStdInt</b> to set this up.
  /// </summary>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  TIntItem = {$IFDEF BC_IntegerListUsesStdInt}StdInt{$ELSE}Integer{$ENDIF};

  {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Pointer to <see cref="BasicClasses|TIntegerList" />.
  /// </summary>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  PIntegerList = ^TIntegerList;

  {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Definition of Integer list class. TIntegerList class is simple Wrapper
  ///   of TBCList.
  /// </summary>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  TIntegerList = class(TCustomObject)
  public type

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Integer list enumerator definition.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    TEnumerator = class
    private
      {$IFDEF AUTOREFCOUNT}[weak]{$ENDIF} FList: TIntegerList;
      FIndex: SizeInt;

      {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    public
      {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
      /// <summary>
      ///   Default constructor. Do NOT use directly! Rather call GetEnumerator
      ///   method of TIntegerList class.
      /// </summary>
      /// <param name="AList">
      ///   Reference to the source list instance.
      /// </param>
      {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
      constructor Create(AList: TIntegerList);

      {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

      {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
      /// <summary>
      ///   Retrieves value of the current item and returns it.
      /// </summary>
      /// <returns>
      ///   Returns value of the current item.
      /// </returns>
      {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
      function GetCurrent: TIntItem; inline;

      {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

      {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
      /// <summary>
      ///   Moves to the next item in the list and returns True if end of the
      ///   list is NOT reached. Otherwise returns False.
      /// </summary>
      /// <returns>
      ///   Returns True if end of the list is NOT reached, otherwise returns
      ///   False.
      /// </returns>
      {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
      function MoveNext: Boolean; inline;

      {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

      {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
      /// <summary>
      ///   Retrieves value of the current item and returns it.
      /// </summary>
      {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
      property Current: TIntItem read GetCurrent;

      {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
      /// <summary>
      ///   Returns current index position of enumerator.
      /// </summary>
      {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
      property &Index: SizeInt read FIndex;
    end;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Integer list reverse enumerator definition.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    TReverseEnumerator = class
    private
      {$IFDEF AUTOREFCOUNT}[weak]{$ENDIF} FList: TIntegerList;
      FIndex: SizeInt;

      {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    public
      {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
      /// <summary>
      ///   Default constructor. Do NOT use directly! Rather call
      ///   GetReverseEnumerator method of TIntegerList class.
      /// </summary>
      /// <param name="AList">
      ///   Reference to the source list instance.
      /// </param>
      {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
      constructor Create(AList: TIntegerList);

      {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

      {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
      /// <summary>
      ///   Retrieves value of the current item and returns it.
      /// </summary>
      /// <returns>
      ///   Returns value of the current item.
      /// </returns>
      {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
      function GetCurrent: TIntItem; inline;

      {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

      {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
      /// <summary>
      ///   Moves to the next item in the list and returns True if end of the
      ///   list is NOT reached. Otherwise returns False.
      /// </summary>
      /// <returns>
      ///   Returns True if end of the list is NOT reached, otherwise returns
      ///   False.
      /// </returns>
      {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
      function MoveNext: Boolean; inline;

      {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

      {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
      /// <summary>
      ///   Retrieves value to the current item and returns it.
      /// </summary>
      {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
      property Current: TIntItem read GetCurrent;

      {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
      /// <summary>
      ///   Returns current index position of enumerator.
      /// </summary>
      {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
      property &Index: SizeInt read FIndex;
    end;

      {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  private type
    TIntList = class(TBCList)
    protected
      procedure Notify(Ptr: Pointer; Action: TListNotification); override;
    end;

  private
    FList: TIntList;
    FFirst: PIntItem;
    FLast: PIntItem;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  protected

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves list's item with specified Index position and returns it.
    /// </summary>
    /// <param name="Index">
    ///   Index position of item that will be retrieved and returned.
    /// </param>
    /// <returns>
    ///   Returns retrieved item.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetItem(const Index: SizeUInt): TIntItem;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Sets new item at specified Index position of the list.
    /// </summary>
    /// <param name="Index">
    ///   Index position where specified item should be stored at.
    /// </param>
    /// <param name="Item">
    ///   The item.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure SetItem(const Index: SizeUInt; Item: TIntItem);

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves the current capacity of the list and returns it.
    /// </summary>
    /// <returns>
    ///   Returns the current capacity of the list.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetCapacity: SizeUInt;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Sets new capacity of the list.
    /// </summary>
    /// <param name="NewCapacity">
    ///   New capacity value.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure SetCapacity(NewCapacity: SizeUInt);

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves the current amount of items stored in the list and returns
    ///   it.
    /// </summary>
    /// <returns>
    ///   Returns the current amount of items stored in the list.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetCount: SizeUInt;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Sets new amount of items in the list.
    /// </summary>
    /// <param name="NewCount">
    ///   New amount of items in the list.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure SetCount(NewCount: SizeUInt);

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves the pointer to a dynamic array which stores list's items and
    ///   return it.
    /// </summary>
    /// <returns>
    ///   Returns the pointer to a dynamic array which stores list's items.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetMemAddr: Pointer;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  public
    type
      TDirection = System.Types.TDirection;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Default constructor.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    constructor Create;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Default destructor.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    destructor Destroy; override;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Adds new item to the end of the list and returns its new index
    ///   position.
    /// </summary>
    /// <param name="Item">
    ///   The new item that will be added to the list.
    /// </param>
    /// <returns>
    ///   Returns index position of newly added item.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function Add(Item: TIntItem): SizeUInt;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Clears all items stored in the list and sets its parameters to the
    ///   default values.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure Clear; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Copies all entries from Source list to this list.
    /// </summary>
    /// <param name="Source">
    ///   Reference to source list from which copy operation will be made.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure CopyFrom(const Source: TIntegerList);

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Deletes item from specified <i>Index</i> position of the list.
    /// </summary>
    /// <remarks>
    ///   This method notifies about item deletion if <i>Notify</i> method
    ///   implemented.
    /// </remarks>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure Delete(Index: SizeUInt);

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Raises EIntegerListError exception with specified informations.
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
    ///   Raises EIntegerListError exception with specified informations.
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
    class procedure Error(Msg: PResStringRec; const Method: String; Data: NativeInt); overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Performs exchange of two items in the list.
    /// </summary>
    /// <param name="Index1">
    ///   Index position of first item that will be replaced.
    /// </param>
    /// <param name="Index2">
    ///   Index position of second item that will be replaced.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure Exchange(Index1, Index2: SizeUInt);

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Expands the list by one item and returns it self.
    /// </summary>
    /// <returns>
    ///   Returns it self.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function Expand: TIntegerList;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Performs extraction operation for specified <i>Item</i>. In other
    ///   words, removes a specified item from the list. Call Extract to remove
    ///   an item from the list. After the item is removed, all the objects that
    ///   follow it are moved up in index position and Count is decremented.
    ///   To remove the reference to an item without deleting the entry from the
    ///   Items array and changing the Count, set the Items property for Index
    ///   to <i>nil</i>.
    /// </summary>
    /// <param name="Item">
    ///   The item that need to be extracted.
    /// </param>
    /// <returns>
    ///   Returns pointer to the extracted item or nil if nothing was found.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function Extract(Item: TIntItem): PIntItem; inline;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Removes and returns a list entry, looping through the list items in
    ///   the specified direction. This function is identical to Extract, only
    ///   that it allows you to specify in which Direction to search the list,
    ///   which allows you to increase the performance of this operation if you
    ///   know whether Value is towards the beginning or towards the end of the
    ///   list.
    /// </summary>
    /// <param name="Item">
    ///   Pointer to the item that need to be extracted.
    /// </param>
    /// <param name="Direction">
    ///   Direction of search loop.
    /// </param>
    /// <returns>
    ///   Returns pointer to the extracted item or nil if nothing was found.
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ExtractItem(Item: TIntItem; Direction: TDirection): PIntItem;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves pointer to the first item in the list and returns it.
    ///   If the list is empty, nil will be returned. Call First to get the
    ///   first pointer in the Items array.
    /// </summary>
    /// <returns>
    ///   Returns pointer to the first item in the list. If the list is empty,
    ///   nil will be returned.
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function First: PIntItem; inline;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves index position to the first item in the list and returns it.
    ///   If the list is empty, -1 will be returned.
    /// </summary>
    /// <returns>
    ///   Returns pointer to the last item in the list. If the list is empty,
    ///   -1 will be returned.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function LowIndex: SizeInt;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Returns a TIntegerList enumerator.
    ///   GetEnumerator returns a TIntegerList.TEnumerator reference, which
    ///   enumerates all items in the list. To do so, call the
    ///   TIntegerList.TEnumerator GetCurrent method within a while MoveNext do
    ///   loop.
    /// </summary>
    /// <returns>
    ///   Reference to the list enumerator.
    /// </returns>
    /// <remarks>
    ///   It is user's responsibility to release retrieved enumerator by calling
    ///   Free() method.
    /// </remarks>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetEnumerator: TIntegerList.TEnumerator; inline;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Returns a TIntegerList reverse enumerator.
    ///   GetReverseEnumerator returns a TIntegerList.TReverseEnumerator
    ///   reference, which enumerates all items in the list. To do so, call the
    ///   TIntegerList.TReverseEnumerator GetCurrent method within a while
    ///   MoveNext do loop.
    /// </summary>
    /// <returns>
    ///   Reference to the list reverse enumerator.
    /// </returns>
    /// <remarks>
    ///   It is user's responsibility to release retrieved reverse enumerator by
    ///   calling its Free() method.
    /// </remarks>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetReverseEnumerator: TIntegerList.TReverseEnumerator; inline;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Returns the index of the first entry in the Items array with
    ///   a specified value.
    ///   Call IndexOf to get the index for entry in the Items array.
    ///   Specify the item as the Item parameter.
    ///   The first item in the array has index 0, the second item has index 1,
    ///   and so on. If an item is not in the list, IndexOf returns -1.
    ///   If an entry appears more than once in the array, IndexOf returns the
    ///   index of the first appearance.
    /// </summary>
    /// <param name="Item">
    ///   The item that will be searched for.
    /// </param>
    /// <returns>
    ///   Returns the index of the first entry in the Items array with
    ///   a specified value or -1 if nothing was found.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function IndexOf(Item: TIntItem): SizeInt;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Returns the item's index.
    ///   Call IndexOfItem to determine the location of an item in the
    ///   TIntegerList list, using a linear search. If the item is not found, -1
    ///   is returned. To increase the performance of this operation, if you
    ///   know whether Item is towards the beginning or towards the end of the
    ///   list you can use Direction parameter.
    /// </summary>
    /// <param name="Item">
    ///   The Item that will be searched for.
    /// </param>
    /// <param name="Direction">
    ///   Direction of search loop.
    /// </param>
    /// <returns>
    ///   Returns index position of the item that was found or -1 when nothing
    ///   was found.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function IndexOfItem(Item: TIntItem; Direction: TDirection): SizeInt;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Adds an object to the Items array at the position specified by Index.
    ///   Call Insert to add Item to the middle of the Items array. The Index
    ///   parameter is a zero-based index, so the first position in the array
    ///   has an index of 0. Insert adds the item at the indicated position,
    ///   shifting the item that previously occupied that position, and all
    ///   subsequent items, up. Insert increments Count and, if necessary,
    ///   allocates memory by increasing the value of Capacity.
    ///   To replace an entry in the array with a new item, without growing the
    ///   Items array, set the Items property.
    /// </summary>
    /// <param name="Index">
    ///   Index position where new item will be inserted into the list.
    /// </param>
    /// <param name="Item">
    ///   The new Item that will be inserted into the list.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure Insert(Index: SizeUInt; Item: TIntItem);

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves pointer to the last item in the list and returns it.
    ///   Call Last to retrieve the last pointer in the Items array.
    ///   If list is empty, nil will be returned.
    /// </summary>
    /// <returns>
    ///   Returns pointer to the last item in the list. If the list is empty,
    ///   nil will be returned.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function Last: PIntItem;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves index position of the last item in the list and returns it.
    ///   If list is empty, -1 will be returned.
    /// </summary>
    /// <returns>
    ///   Returns index position of the last item in the list. If list is empty,
    ///   -1 will be returned.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function HighIndex: SizeInt;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Changes the position of an item in the Items array. Call Move to move
    ///   the item at the position CurIndex so that it occupies the position
    ///   NewIndex. CurIndex and NewIndex are zero-based indexes into the Items
    ///   array.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure Move(CurIndex, NewIndex: SizeUInt);

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Deletes the first reference to the Item parameter from the Items
    ///   array. Call Remove to remove a specific item from the Items array when
    ///   its index is unknown. The value returned is the index of the item in
    ///   the Items array before it was removed. After an item is removed, all
    ///   the items that follow it are moved up in index position and the Count
    ///   is reduced by one.
    ///   If the Items array contains more than one copy of the entry, only
    ///   the first copy is deleted.
    /// </summary>
    /// <param name="Item">
    ///   The item that will be removed from the list.
    /// </param>
    /// <returns>
    ///   Returns index position of removed item from the list or -1 if nothing
    ///   was found.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function Remove(Item: TIntItem): SizeInt; inline;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Removes the first occurrence of value, looping through the list items
    ///   in the specified direction. In other words, it removes the first or
    ///   last occurrence of Value depending on the specified Direction.
    ///   RemoveItem is identical to Remove, only that it allows you to specify
    ///   in which Direction to search the list, so that you can remove the last
    ///   occurrence instead of the first one.
    /// </summary>
    /// <param name="Item">
    ///   The item that will be searched for.
    /// </param>
    /// <param name="Direction">
    ///   Direction of search loop.
    /// </param>
    /// <returns>
    ///   Returns index position of removed item from the list or -1 if nothing
    ///   was found.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function RemoveItem(Item: TIntItem; Direction: TDirection): SizeInt;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Performs a QuickSort on the list based on the comparison function
    ///   Compare. Call Sort to sort the items in the Items array. Compare is
    ///   a comparison function that indicates how the items are to be ordered.
    /// </summary>
    /// <param name="Compare">
    ///   Reference to comparison function that will be used in this operation.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure Sort(Compare: TListSortCompare);

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Performs a QuickSort on list of items. Call SortList to sort the Items
    ///   in the TBCList list.
    /// </summary>
    /// <param name="Compare">
    ///   TListSortCompareFunc as reference.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure SortList(const Compare: TListSortCompareFunc);

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Copies elements of one list to another. Call Assign to assign the
    ///   elements of another list to this one. Assign combines the source list
    ///   with this one using the logical operator specified by the AOperator
    ///   parameter.
    ///   If the ListB parameter is specified, then Assign first replaces all
    ///   the elements of this list with those in ListA, and then merges ListB
    ///   into this list using the operator specified by AOperator.
    ///   If the ListB parameter is not specified, then Assign merges ListA into
    ///   this list using the operator specified by AOperator.
    /// </summary>
    /// <param name="ListA">
    ///   Reference to ListA.
    /// </param>
    /// <param name="AOperator">
    ///   List assign operator type. Default is laCopy.
    /// </param>
    /// <param name="ListB">
    ///   Reference to ListB. Default is nil.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure Assign(Other: TIntegerList);

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Randomly shuffles list.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure Shuffle;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Randomly shuffles list.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure BestShuffle;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Loops throu all elements and remove duplicates.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure RemoveDuplicates;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Returns text representation of integer list e.g. "21, 14, 7, 3, 1".
    /// </summary>
    /// <returns>
    ///   Returns text representation of integer list.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function ChainToString: String;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Compares this list with other list specified in Other and returns
    ///   True if both are the same or False otherwise.
    /// </summary>
    /// <param name="Other">
    ///   Reference to other list of the same type that will be compared.
    /// </param>
    /// <returns>
    ///   Returns True if both lists are the same, otherwise returns False.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function SameAs(const Other: TIntegerList): Boolean;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   <para>
    ///     Specifies the allocated size of the array of entries maintained by
    ///     the <i>TIntegerList</i> class.
    ///   </para>
    ///   <para>
    ///     Set <i>Capacity</i> to the number of entries the list will need
    ///     to contain. When setting the <i>Capacity</i> property, an <i>
    ///     EOutOfMemory</i> exception occurs if there is not enough memory
    ///     to expand the list to its new size.
    ///   </para>
    ///   <para>
    ///     Read <i>Capacity</i> to learn number of entries the list can hold
    ///     without reallocating memory.
    ///   </para>
    ///   <para>
    ///     Do not confuse <i>Capacity</i> with the <i>Count</i> property,
    ///     which is the number of entries in the list that are in use. The
    ///     value of <i>Capacity</i> is always greater than or equal to the
    ///     value of <i>Count</i>. When <i>Capacity</i> is greater than <i>
    ///     Count</i>, the unused memory can be reclaimed by setting <i>
    ///     Capacity</i> to <i>Count</i>.
    ///   </para>
    ///   <para>
    ///     When an entry is added to a list that is already filled to
    ///     capacity, the <i>Capacity</i> property is automatically
    ///     increased. Setting <i>Capacity</i> before adding objects can
    ///     reduce the number of memory reallocations and thereby improve
    ///     performance. For example:
    ///   </para>
    ///   <code lang="Delphi">List.Clear;
    /// List.Capacity := Count;
    /// for I := 1 to Count do
    ///   List.Add(...);</code>
    ///   <para>
    ///     The assignment to <i>Capacity</i> before the for loop ensures
    ///     that each of the following <i>Add</i> operations doesn't cause
    ///     the list to be reallocated. Avoiding reallocations on the calls
    ///     to <i>Add</i> improves performance and ensures that the Add
    ///     operations never raise an exception.
    ///   </para>
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    property Capacity: SizeUInt read GetCapacity write SetCapacity;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   <para>
    ///     Indicates the number of entries in the list that are in use.
    ///   </para>
    ///   <para>
    ///     Read <i>Count</i> to determine the number of entries in the <see cref="BasicClasses.Lists|TBCList.Items[SizeUInt]">
    ///     Items</see> array.
    ///   </para>
    ///   <para>
    ///     Increasing the size of <i>Count</i> will add the necessary number
    ///     of nil pointers to the end of the <see cref="BasicClasses.Lists|TBCList.Items[SizeUInt]">
    ///     Items</see> array. Decreasing the size of <i>Count</i> will
    ///     remove the necessary number of entries from the end of the <see cref="BasicClasses.Lists|TBCList.Items[SizeUInt]">
    ///     Items</see> array.
    ///   </para>
    ///   <para>
    ///     <i>Count</i> is not always the same as the number of objects
    ///     referenced in the list. Some of the entries in the <see cref="BasicClasses.Lists|TBCList.Items[SizeUInt]">
    ///     Items</see> array may contain nil pointers. To remove the nil
    ///     pointers and set <i>Count</i> to the number of entries that
    ///     contain references to objects, call the <see cref="BasicClasses.Lists|TBCList.Pack">
    ///     Pack</see> method.
    ///   </para>
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    property Count: SizeUInt read GetCount write SetCount;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Returns pointer to the first element of dynamic array.
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    property MemAddr: Pointer read GetMemAddr;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   <para>
    ///     Lists the entry references.
    ///   </para>
    ///   <para>
    ///     Use <i>Items</i> to obtain an entry to a specific object in the
    ///     array. The Index parameter indicates the index of the entry, where 0
    ///     is the index of the first entry, 1 is the index of the second entry,
    ///     and so on. Set <i>Items</i> to change the reference at a specific
    ///     location.
    ///   </para>
    ///   <para>
    ///     Use <i>Items</i> with the <see cref="BasicClasses.Lists|TBCList.Count">
    ///     Count</see> property to iterate through all of the entries in the
    ///     list.
    ///   </para>
    /// </summary>
    /// <remarks>
    ///   <i>Items</i> is the default property for TIntegerList. This means you
    ///   can omit the property name. Thus, instead of <i>MyList.Items[i]</i>,
    ///   you can write <i>MyList[i]</i>.
    /// </remarks>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    property Items[const &Index: SizeUInt]: TIntItem read GetItem write SetItem; default;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   <para>
    ///     Specifies the array of pointers that make up the <i>Items</i>
    ///     array.
    ///   </para>
    ///   <para>
    ///     Use List to gain direct access to the <i>Items</i> array.
    ///   </para>
    /// </summary>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    property List: TIntList read FList;
  end;


{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{===============================================================================
  General routines definition
===============================================================================}

{$IFDEF SUPPORTS_REGION}{$REGION 'General routines definition'}{$ENDIF}

{$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
/// <summary>
///   Performs sorting of SortList array using QuickSort algorithm.
/// </summary>
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
procedure QuickSort(SortList: TPointerList; L, R: Integer; const SCompare: TListSortCompareFunc);

{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

implementation

uses
{$IF (DEFINED(Windows) AND DEFINED(PurePascal))}
  {$IFDEF HAS_UNITSCOPE}Winapi.Windows{$ELSE}Windows{$ENDIF},
{$IFEND}
  {$IFDEF HAS_UNITSCOPE}System.SyncObjs{$ELSE}SyncObjs{$ENDIF},
  {$IFDEF HAS_UNITSCOPE}System.Math{$ELSE}Math{$ENDIF},
  BasicClasses.Consts;

{===============================================================================
  General routines implementation
===============================================================================}

{$IFDEF SUPPORTS_REGION}{$REGION 'General routines implementation'}{$ENDIF}
procedure QuickSort(SortList: TPointerList; L, R: Integer; const SCompare: TListSortCompareFunc);
var
  I, J: Integer;
  P, T: Pointer;
begin
  if (L < R) then
  begin
    repeat
      if ((R - L) = 1) then
      begin
        if (SCompare(SortList[L], SortList[R]) > 0) then
        begin
          T := SortList[L];
          SortList[L] := SortList[R];
          SortList[R] := T;
        end;

        Break;
      end;

      I := L;
      J := R;
      P := SortList[(L + R) shr 1];

      repeat
        while (SCompare(SortList[I], P) < 0) do
          Inc(I);

        while (SCompare(SortList[J], P) > 0) do
          Dec(J);

        if (I <= J) then
        begin
          if (I <> J) then
          begin
            T := SortList[I];
            SortList[I] := SortList[J];
            SortList[J] := T;
          end;

          Inc(I);
          Dec(J);
        end;
      until (I > J);

      if ((J - L) > (R - I)) then
      begin
        if (I < R) then
          QuickSort(SortList, I, R, SCompare);

        R := J;
      end else
        begin
          if (L < J) then
            QuickSort(SortList, L, J, SCompare);

          L := I;
        end;
    until (L >= R);
  end;
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{===============================================================================
  TCustomList - class implementation
===============================================================================}

{$IFDEF SUPPORTS_REGION}{$REGION 'TCustomList implementation'}{$ENDIF}
const
  CAPACITY_GROW_INIT = 32;

function TCustomList.CheckIndex(Index: SizeUInt): Boolean;
begin
  { If Index is in the bounds, return True. Otherwise return False. }
  Result := (Index >= LowIndex) and (Index <= HighIndex);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TCustomList.CopyGrowSettings(Source: TCustomList);
begin
  { Copy list grow settings from specified Source. }
  FListGrowSettings := Source.ListGrowSettings;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

constructor TCustomList.Create;
begin
  inherited;

  { Set default list grow settings. }
  FListGrowSettings := BC_LIST_GROW_SETTINGS_DEFAULT;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TCustomList.Grow(MinDelta: SizeUInt);
var
  Delta: Integer;
begin
  { (1) Set default value for Delta. }
  Delta := 0;

  { (2.1) If count is greater or equal to Capacity then ... }
  if (Count >= Capacity) then
  begin
    { (2.2) ... if Capacity is equal 0, then set Delta to CAPACITY_GROW_INIT. }
    if (Capacity = 0) then
      Delta := CAPACITY_GROW_INIT
    else
      { (2.3) ... else depending on Grow Mode, calculate proper Delta value. }
      case FListGrowSettings.GrowMode of
        gmLinear:
          Delta := Trunc(FListGrowSettings.GrowFactor);

        gmFast:
          Delta := Trunc(Capacity * FListGrowSettings.GrowFactor);

        gmFastAttenuated:
          If (Capacity >= FListGrowSettings.GrowLimit) then
            Delta := FListGrowSettings.GrowLimit shr 4
          else
            Delta := Trunc(Capacity * FListGrowSettings.GrowFactor);

        gmSlow:
          Delta := 1;
      end;

    { (2.4) Trim Delta if its smaller than MinDelta. }
    if (Delta < MinDelta) then
      Delta := MinDelta
    else
      if (Delta <= 0) then
        Delta := 1;

    { (2.5) Set calculated Capacity. }
    Capacity := Capacity + SizeUInt(Delta);
  end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TCustomList.Shrink;
begin
  { (1) If Capacity is greater than 0, ... }
  if (Capacity > 0) then
    { (2) Depending on Shrink Mode, calculate proper Capacity. }
    case FListGrowSettings.ShrinkMode of
      smNormal:
        if ((Capacity > FListGrowSettings.ShrinkLimit) and (Count < Integer(Trunc((Capacity * FListGrowSettings.ShrinkFactor) / 2)))) then
          Capacity := Trunc(Capacity * FListGrowSettings.ShrinkFactor);

      smToCount:
        Capacity := Count;

      smKeepCap:
        { In this case, do nothing. }
    end;
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{===============================================================================
  TCustomMultiList - class implementation
===============================================================================}

{$IFDEF SUPPORTS_REGION}{$REGION 'TCustomMultiList implementation'}{$ENDIF}
function TCustomMultiList.CheckIndex(Index, ListIndex: SizeUInt): Boolean;
begin
  { If Index is in the bounds, then return True. Otherwise return False. }
  Result := (Index >= LowIndex(ListIndex)) and (Index <= HighIndex(ListIndex));
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomMultiList.CheckList(Index: SizeUInt): Boolean;
begin
  { If Index is in the bounds, then return True. Otherwise return False. }
  Result := (Index >= LowList) and (Index <= HighList);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TCustomMultiList.CopyGrowSettings(Source: TCustomMultiList);
var
  I: Integer;
begin
  { If ListCount of this list is equal to ListCount of specified Source,
    itterate throu all list items and copy list grow settings from specified
    Source, ... }
  if (Self.ListCount = Source.ListCount) then
  begin
    for I := LowList to HighList do
      {FListGrowSettings[I] := BC_LIST_GROW_SETTINGS_DEFAULT;}
      FListGrowSettings[I] := Source.ListGrowSettings[I];
  end else
    { ... else raise error about list count mismatch. }
    raise EBCIncompatibleClass.CreateFmt(
      SCustomMultiList_ListCountMismatch, ['TCustomMultiList.CopyGrowSettings', Self.ListCount, Source.ListCount]);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

constructor TCustomMultiList.Create(ListCount: SizeUInt);
begin
  inherited Create;

  { Set default list count specified in ListCount. }
  SetListCount(ListCount);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

constructor TCustomMultiList.Create;
begin
  inherited;

  { Set list count as 0. }
  SetListCount(0);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

destructor TCustomMultiList.Destroy;
begin
  { Set length of FListGrowSettings to 0. }
  SetLength(FListGrowSettings, 0);

  inherited;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomMultiList.GetListCount: SizeUInt;
begin
  { Retrieve length of FListGrowSettings and return it as list count. }
  Result := Length(FListGrowSettings);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomMultiList.GetListGrowSettings(Index: SizeUInt): TListGrowSettings;
begin
  { If specified Index is in the bounds, then return list grow settings of list
    stored at specified Index position. }
  if (CheckList(Index)) then
    Result := FListGrowSettings[Index]
  else
    { Otherwise raise Index Out of Bounds error. }
    raise EBCIndexOutOfBounds.CreateFmt(SCustomMultiList_IndexOutOfBounds, ['SCustomMultiList.GetListGrowSettings', Index]);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomMultiList.GetListGrowSettingsPtr(Index: SizeUInt): PListGrowSettings;
begin
  { If specified Index is in the bounds, then return pointer to list grow
    settings of list stored at specified Index position. }
  if (CheckList(Index)) then
    Result := Addr(FListGrowSettings[Index])
  else
    { Otherwise raise Index Out of Bounds error. }
    raise EBCIndexOutOfBounds.CreateFmt(SCustomMultiList_IndexOutOfBounds, ['TCustomMultiList.GetListGrowSettingsPtr', Index]);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TCustomMultiList.Grow(Index, MinDelta: SizeUInt);
var
  Delta: Integer;
begin
  { (1) Set default value for Delta. }
  Delta := 0;

  { (2.1) If specified Index is valid, then ... }
  if (CheckList(Index)) then
  begin
    { (2.2) ... if Count[Index] is greater or equal to Capacity[Index],
            then ... }
    if (Count[Index] >= Capacity[Index]) then
    begin
      { (2.2.1) ... If Capacity[Index] is equal to 0, then ... }
      if (Capacity[Index] = 0) then
        { (2.2.2) ... set Delta to default CAPACITY_GROW_INIT. }
        Delta := CAPACITY_GROW_INIT
      else
        { (2.3) Otherwise depending on Grow Mode of list with specified Index,
                  calculate proper Delta value. }
        case FListGrowSettings[Index].GrowMode of
          gmLinear:
            Delta := Trunc(fListGrowSettings[Index].GrowFactor);

          gmFast:
            Delta := Trunc(Capacity[Index] * FListGrowSettings[Index].GrowFactor);

          gmFastAttenuated:
            if (Capacity[Index] >= fListGrowSettings[Index].GrowLimit) then
              Delta := FListGrowSettings[Index].GrowLimit shr 4
            else
              Delta := Trunc(Capacity[Index] * FListGrowSettings[Index].GrowFactor);

          gmSlow:
            Delta := 1;
          end;

      { (2.4) Trim Delta. }
      if (Delta < MinDelta) then
        Delta := MinDelta
      else
        if (Delta <= 0) then
          Delta := 1;

      { (2.5) Set calculated Capacity for list with specified Index. }
      Capacity[Index] := Capacity[Index] + SizeUInt(Delta);
    end;
  end else
    { Raise Index Out of Bounds error. }
    EBCIndexOutOfBounds.CreateFmt(SCustomMultiList_IndexOutOfBounds, ['TCustomMultiList.Grow', Index]);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomMultiList.HighList: SizeUInt;
begin
  { Return index of last list. }
  Result := High(FListGrowSettings);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomMultiList.LowList: SizeUInt;
begin
  { Return index of first list. }
  Result := Low(FListGrowSettings);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TCustomMultiList.SetListCount(Value: SizeUInt);
var
  OldCount, I: Integer;
begin
  { (1) if Value is other than length of FListGrowSettings and Value is greater
        or equal to 0, then: }
  if ((Value <> Length(FListGrowSettings)) and (Value >= 0)) then
  begin
    { (2) Store current length of FListGrowSettings in OldCount. }
    OldCount := Length(FListGrowSettings);

    { (3) Set new length of FListGrowSettings to Value. }
    SetLength(FListGrowSettings, Value);

    { (4.1) If Value is greater than OldCount, then ... }
    if (Value > OldCount) then
      { (4.2) Itterate throu rest of list above OldCount and ... }
      for I := OldCount to High(fListGrowSettings) do
        { (4.3) set FListGrowSettings of those lists to default settings. }
        FListGrowSettings[I] := BC_LIST_GROW_SETTINGS_DEFAULT;
  end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TCustomMultiList.SetListGrowSettings(Index: SizeUInt; Value: TListGrowSettings);
begin
  { Validate that specified Index isn't out of bounds. If it's valid, then ... }
  if (CheckList(Index)) then
    { ... set new Value to list with specified Index. }
    FListGrowSettings[Index] := Value
  else
    { Otherwise raise Index Out of Bounds error. }
    raise EBCIndexOutOfBounds.CreateFmt(SCustomMultiList_IndexOutOfBounds, ['TCustomMultiList.SetListGrowSettings', Index]);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TCustomMultiList.Shrink(Index: SizeUInt);
begin
  { (1.1) Validate that specified Index isn't out of the bounds of the lists.
        If it's valid, then ... }
  if (CheckList(Index)) then
  begin
    { (2.1) If Capacity of list with specified Index is greater than 0, then
            depending on list Shrink Mode, calculate new Capacity. }
    if (Capacity[Index] > 0) then
      case FListGrowSettings[Index].ShrinkMode of
        smNormal:
          if ((Capacity[Index] > FListGrowSettings[Index].ShrinkLimit) and
              (Count[Index] < Integer(Trunc((Capacity[Index] * FListGrowSettings[Index].ShrinkFactor) / 2)))) then
            Capacity[Index] := Trunc(Capacity[Index] * FListGrowSettings[Index].ShrinkFactor);

        smToCount:
          Capacity[Index] := Count[Index];

        smKeepCap:
          { Do nothing }
      end;
  end else
    { (1.2) Otherwise raise Index Out of Bounds error. }
    EBCIndexOutOfBounds.CreateFmt(SCustomMultiList_IndexOutOfBounds, ['TCustomMultiList.Shrink', Index]);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{===============================================================================
  TBCList - class implementation
===============================================================================}

{$IFDEF SUPPORTS_REGION}{$REGION 'TBCList implementation'}{$ENDIF}

{$IFDEF SUPPORTS_REGION}{$REGION 'TBCList.TBCListEnumerator implementation'}{$ENDIF}
constructor TBCList.TEnumerator.Create(AList: TBCList);
begin
  { (1) Call inherited Create. }
  inherited Create;

  { (2) Set current position FIndex to -1. }
  FIndex := -1;

  { (3) Set FList to specified AList. }
  FList := AList;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TBCList.TEnumerator.GetCurrent: Pointer;
begin
  { Return current item from the dynamic array. }
  Result := FList.List[FIndex];
end;

function TBCList.TEnumerator.MoveNext: Boolean;
begin
  { (1) Increment current position FIndex by 1. }
  Inc(FIndex);

  { (2) Return True if we didn't reach end of the dynamic array, or False if
        we are at the end of the dynamic array. }
  Result := FIndex < FList.Count;
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'TBCList.TBCListReverseEnumerator implementation'}{$ENDIF}
constructor TBCList.TReverseEnumerator.Create(AList: TBCList);
begin
  { (1) Call inherited Create. }
  inherited Create;

  { (2) Set current position FIndex to AList.HighIndex + 1. }
  FIndex := AList.HighIndex + 1;

  { (3) Set FList to specified AList. }
  FList := AList;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TBCList.TReverseEnumerator.GetCurrent: Pointer;
begin
  { Return current item from the dynamic array. }
  Result := FList.List[FIndex];
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TBCList.TReverseEnumerator.MoveNext: Boolean;
begin
  { (1) Decrement current position FIndex by 1. }
  Dec(FIndex);

  { (2) Return True if we didn't reach end of the dynamic array, or False if
        we are at the end of the dynamic array. }
  Result := FIndex > FList.LowIndex;
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TBCList.Add(Item: Pointer): SizeUInt;
begin
  { (1) FCount value is the same as position (index) of new item, so store it
        in Result. }
  Result := FCount;

  { (2) If current capacity is equal to position (index) of the new item,
        grow the dynamic array. }
  if (Result = FCapacity) then
    Grow;

  { (3) Store new item in the dynamic array. }
  FList[Result] := Item;

  { (4) Increment FCount by 1. }
  Inc(FCount);

  { (5.1) If new item isn't nil and the class isn't TBCList type, then notify
          that Item is added. }
  if ((Item <> nil) and (ClassType <> TBCList)) then
    Notify(Item, lnAdded);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TBCList.Assign(ListA: TBCList; AOperator: TListAssignOp; ListB: TBCList);
var
  I: SizeUInt;
  LTemp, LSource: TBCList;
begin
  { (1) Is ListB given? }
  if (ListB <> nil) then
  begin
    LSource := ListB;
    Assign(ListA);
  end else
    LSource := ListA;

  { (2) On with the show. }
  case AOperator of
    { 12345, 346 = 346 : Only those in the new list. }
    laCopy:
    begin
      Clear;
      Capacity := LSource.Capacity;

      for I := 0 to (LSource.Count - 1) do
        Add(LSource[I]);
    end;

    { 12345, 346 = 34 : Intersection of the two lists. }
    laAnd:
      for I := (Count - 1) downto 0 do
        if (LSource.IndexOf(Items[I]) = -1) then
          Delete(I);

    { 12345, 346 = 123456 : Union of the two lists. }
    laOr:
      for I := 0 to (LSource.Count - 1) do
        if (IndexOf(LSource[I]) = -1) then
          Add(LSource[I]);

    { 12345, 346 = 1256 : Only those not in both lists. }
    laXor:
    begin
      LTemp := TBCList.Create; { Temp holder of 4 byte values. }
      try
        LTemp.Capacity := LSource.Count;

        for I := 0 to (LSource.Count - 1) do
          if (IndexOf(LSource[I]) = -1) then
            LTemp.Add(LSource[I]);

        for I := (Count - 1) downto 0 do
          if (LSource.IndexOf(Items[I]) <> -1) then
            Delete(I);

        I := Count + LTemp.Count;

        if (Capacity < I) then
          Capacity := I;

        for I := 0 to (LTemp.Count - 1) do
          Add(LTemp[I]);
      finally
        LTemp.Free;
      end;
    end;

    { 12345, 346 = 125 : Only those unique to source. }
    laSrcUnique:
      for I := (Count - 1) downto 0 do
        if (LSource.IndexOf(Items[I]) <> -1) then
          Delete(I);

    { 12345, 346 = 6 : Only those unique to dest. }
    laDestUnique:
    begin
      LTemp := TBCList.Create;
      try
        LTemp.Capacity := LSource.Count;

        for I := (LSource.Count - 1) downto 0 do
          if (IndexOf(LSource[I]) = -1) then
            LTemp.Add(LSource[I]);

        Assign(LTemp);
      finally
        LTemp.Free;
      end;
    end;
  end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TBCList.Clear;
begin
  { (1) Set count to 0. }
  SetCount(0);

  { (2) Set capacity to 0. }
  SetCapacity(0);

  { (3) Set default list grow settings. }
  FListGrowSettings := BC_LIST_GROW_SETTINGS_DEFAULT;

  { (4) Perform shrink calculation. }
  Shrink;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TBCList.CopyFrom(const Source: TBCList);
var
  It: TBCList.TEnumerator;
begin
  { (1) If Source.Count is greater than 0, then ... }
  if (Source.Count > 0) then
  begin
    { (2) ... itterate throu all entries and add each of them to this list. }
    It := Source.GetEnumerator;

    while It.MoveNext do
      Add(It.Current);

    { (3) Release enumerator. }
    It.Free;
  end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

constructor TBCList.Create;
begin
  inherited;

  { Set default values. }
  FCapacity := 0;
  FCount := 0;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TBCList.Delete(Index: SizeUInt);
var
  Temp: Pointer;
begin
  { (1) If Index is greater or equal to FCount, raise list index error. }
  if (Index >= FCount) then
    Error(@SBCList_ListIndexError, 'TBCList.Delete', Index);

  { (2) Store the item in temporary Temp variable. }
  Temp := FList[Index];

  { (3) Decrement FCount by 1. }
  Dec(FCount);

  { (4) If Index is less than FCount, we need to move everything above Index
        position down by 1. }
  if Index < FCount then
    System.Move(FList[Index + 1], FList[Index], (FCount - Index) * SizeOf(Pointer));

  { (5) Shrink the dynamic array if needed. }
  Shrink;

  { (6) If the temporary Temp variable isn't nil and the class isn't TBCList
        type, then notify that item is deleted. }
  if ((Temp <> nil) and (ClassType <> TBCList)) then
    Notify(Temp, lnDeleted);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

destructor TBCList.Destroy;
begin
  { Clear everything. }
  Clear;

  inherited;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

class procedure TBCList.Error(Msg: PResStringRec; const Method: String; Data: NativeInt);
begin
  { Raise error. }
  raise EBCListError.CreateFmt(LoadResString(Msg), [Method, Data]) at ReturnAddress;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

class procedure TBCList.Error(const Msg, Method: String; Data: NativeInt);
begin
  { Raise error. }
  raise EBCListError.CreateFmt(Msg, [Method, Data]) at ReturnAddress;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TBCList.Exchange(Index1, Index2: SizeUInt);
var
  Temp: Pointer;
begin
  { (1) Raise list index error if Index1 and Index2 variables are out of
        bounds. }
  if (Index1 >= FCount) then
    Error(@SBCList_ListIndexError, 'TBCList.Exchange', Index1);
  if (Index2 >= FCount) then
    Error(@SBCList_ListIndexError, 'TBCList.Exchange', Index2);

  { (2) Make simple position exchange of two items with help of temporary Temp
        variable. }
  Temp := FList[Index1];
  FList[Index1] := FList[Index2];
  FList[Index2] := Temp;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TBCList.Expand: TBCList;
begin
  { (1) If FCount is equal to FCapacity, grow list capacity. }
  if (FCount = FCapacity) then
    Grow;

  { (2) Return your self. }
  Result := Self;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TBCList.Extract(Item: Pointer): Pointer;
begin
  { Call ExtractItem() with from beginning direction. }
  Result := ExtractItem(Item, TDirection.FromBeginning);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TBCList.ExtractItem(Item: Pointer; Direction: TDirection): Pointer;
var
  I: SizeInt;
begin
  { (1) For now set Result variable as nil. }
  Result := nil;

  { (2) Search for specified Item throu all items of the dynamic array using
        specified Direction. }
  I := IndexOfItem(Item, Direction);

  { (3.1) If something was found: }
  if (I >= 0) then
  begin
    { (3.2) Store the Item as a result. }
    Result := FList[I];

    { (3.3) Set nil to item that we found in the dynamic array. }
    FList[I] := nil;

    { (3.4) Perform proper removal ouf the item from the dynamic array. }
    Delete(I);

    { (3.5) If the class isn't TBCList type, then notify that item is
            extracted. }
    if (ClassType <> TBCList) then
      Notify(Result, lnExtracted);
  end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TBCList.First: Pointer;
begin
  { Return first item from the dynamic array. }
  Result := GetItem(0);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TBCList.GetCapacity: SizeUInt;
begin
  { Return current FCapacity value. }
  Result := FCapacity;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TBCList.GetCount: SizeUInt;
begin
  { Return current FCount value. }
  Result := FCount;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TBCList.GetEnumerator: TBCList.TEnumerator;
begin
  { Create TBCListEnumerator class for your self and return it. }
  Result := TEnumerator.Create(Self);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TBCList.GetItem(const Index: SizeUInt): Pointer;
begin
  { (1.1) If specified Index is greater or equal than FCount value, then ... }
  if (Index >= FCount) then
    { (1.2) ... raise list index out of bound error. }
    Error(@SBCList_ListIndexError, 'TBCList.GetItem', Index);

  { (2) Return item with Index position from the dynamic array. }
  Result := FList[Index];
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TBCList.GetMemAddr: Pointer;
begin
  if (FCount > 0) then
    Result := @FList[0]
  else
    Result := nil;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TBCList.GetReverseEnumerator: TBCList.TReverseEnumerator;
begin
  { Create TBCListReverseEnumerator class for your self and return it. }
  Result := TReverseEnumerator.Create(Self);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TBCList.HighIndex: SizeInt;
begin
  if (FCount > 0) then
    Result := FCount - 1
  else
    Result := -1;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TBCList.IndexOf(Item: Pointer): SizeInt;
var
  P: PPointer;
begin
  { (1) If FCount is greater than 0, then: }
  if (FCount > 0) then
  begin
    { (2) Store pointer to the dynamic array FList in P variable. }
    P := Pointer(FList);

    { (3.1) Itterate from 0 to (FCount - 1) and save that value in Result: }
    for Result := 0 to (FCount - 1) do
    begin
      { (3.2) Cast the pointer P to proper type and compare it with specified
              Item. If comparison is successful, exit from this function. }
      if (P^ = Item) then
        Exit;

      { (3.3) Increment the P pointer. }
      Inc(P);
    end;
  end;

  { (4) If we reach this point, we didn't find specified Item so return -1. }
  Result := -1;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TBCList.IndexOfItem(Item: Pointer; Direction: TDirection): SizeInt;
var
  P: PPointer;
begin
  { (1.1) If specified Direction is equal to FromBeginning, call
          IndexOf(Item). }
  if (Direction = FromBeginning) then
    Result := IndexOf(Item)
  else
    begin
      { (1.2.1) Otherwise if FCount is greater than 0: }
      if (FCount > 0) then
      begin
        { (1.2.2) Retrieve pointer to last item of the dynamic array and store
                  it in P variable. }
        P := PPointer(@FList[FCount - 1]);

        { (1.2.3.1) Itterate from (FCount - 1) down to 0 and save that value in
                  Result: }
        for Result := (FCount - 1) downto 0 do
        begin
          { (1.2.3.2) Cast the pointer and compare it with specified item. If
                      comparison is successful, exit from this function. }
          if (P^ = Item) then
            Exit;

          { (1.2.3.3) Decrement the P pointer. }
          Dec(P);
        end;
      end;

      { (1.2.4) If we reach this point, we didn't find specified Item so
                return -1. }
      Result := -1;
    end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TBCList.Insert(Index: SizeUInt; Item: Pointer);
begin
  { (1) Raise list index error if Index is greater than FCount. }
  if (Index > FCount) then
    Error(@SBCList_ListIndexError, 'TBCList.Insert', Index);

  { (2) If FCount is equal to FCapacity, grow the capacity. }
  if (FCount = FCapacity) then
    Grow;

  { (3) If Index is less than FCount, we are inserting the Item so we need to
        move all items which are above Index position in the dynamic array
        by 1. }
  if (Index < FCount) then
    System.Move(FList[Index], FList[Index + 1], (FCount - Index) * SizeOf(Pointer));

  { (4) Store the item in Index position of the dynamic array. }
  FList[Index] := Item;

  { (5) Increment FCount by 1. }
  Inc(FCount);

  { (6) If Item isn't nil and the class isn't TBCList type, then notify that
        Item is added. }
  if ((Item <> nil) and (ClassType <> TBCList)) then
    Notify(Item, lnAdded);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TBCList.Last: Pointer;
begin
  { (1.1) If FCount is greater than 0, then return last item of the dynamic
          array. }
  if (FCount > 0) then
    Result := FList[Count - 1]
  else
    begin
      { (1.2) Otherwise raise list index error and return nil. }
      Error(@SBCList_ListIndexError, 'TBCList.Last', 0);
      Result := nil;
    end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TBCList.LowIndex: SizeInt;
begin
  if (FCount > 0) then
    Result := 0
  else
    Result := -1;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TBCList.Move(CurIndex, NewIndex: SizeUInt);
var
  Temp: Pointer;
begin
  { (1) If CurIndex isn't equal to NewIndex: }
  if (CurIndex <> NewIndex) then
  begin
    { (2.1) If NewIndex is greater or equal to FCount, then raise list index
            error. }
    if (NewIndex >= FCount) then
      Error(@SBCList_ListIndexError, 'TBCList.Move', NewIndex);

    { (2.2) Retrieve item from CurIndex position of the dynamic array and store
            it in Temp variable. }
    Temp := GetItem(CurIndex);

    { (2.3) Set that item from CurIndex position of the dynamic array to nil. }
    FList[CurIndex] := nil;

    { (2.4) Properly delete item from CurIndex position of the dynamic array by
            calling Delete(CurIndex). }
    Delete(CurIndex);

    { (2.5) Insert nil item to the dynamic array at NewIndex position by calling
            Insert(NewIndex, nil). }
    Insert(NewIndex, nil);

    { (2.6) Set Temp variable as that inserted item to the dynamic array. }
    FList[NewIndex] := Temp;
  end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TBCList.Notify(Ptr: Pointer; Action: TListNotification);
begin
  { Do nothing. If user want to handle notification, implementation of this
    method must be made. }
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TBCList.Pack;
var
  PackedCount, StartIndex, EndIndex: Integer;
begin
  { If FCount is equal 0, exit this procedure. }
  if (FCount = 0) then
    Exit;

  { Preparation. }
  PackedCount := 0;
  StartIndex := 0;

  repeat
    { Locate the first/next non-nil element in the list. }
    while ((StartIndex < FCount) and (FList[StartIndex] = nil)) do
      Inc(StartIndex);

    { If StartIndex is greater or equal than FCount, there is nothing more to
      do. }
    if (StartIndex < FCount) then
    begin
      { Locate the next nil pointer. }
      EndIndex := StartIndex;
      while ((EndIndex < FCount) and (FList[EndIndex] <> nil)) do
        Inc(EndIndex);

      Dec(EndIndex);

      { Move this block of non-null items to the index recorded in
        PackedToCount:
        If this is a contiguous non-nil block at the start of the list then
        StartIndex and PackedToCount will be equal (and 0) so don't bother with
        the move. }
      if (StartIndex > PackedCount) then
        System.Move(FList[StartIndex], FList[PackedCount], (EndIndex - StartIndex + 1) * SizeOf(Pointer));

      { Set the PackedToCount to reflect the number of items in the list that
        have now been packed. }
      Inc(PackedCount, EndIndex - StartIndex + 1);

      { Reset StartIndex to the element following EndIndex. }
      StartIndex := EndIndex + 1;
    end;
  until (StartIndex >= FCount);

  { Set Count so that the 'free' item. }
  FCount := PackedCount;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TBCList.Remove(Item: Pointer): SizeInt;
begin
  { Search for specified Item using FromBeginning direction. If found, delete it
    and return its position where it was in the dynamic array or -1 if not
    found. }
  Result := RemoveItem(Item, TBCList.TDirection.FromBeginning);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TBCList.RemoveItem(Item: Pointer; Direction: TDirection): SizeInt;
begin
  { (1) Search for specified Item in the dynamic array using specified Direction
        of search and store its position in Result when found or -1 when not
        found. }
  Result := IndexOfItem(Item, Direction);

  { (2) If Result is greater or equal to 0, call Delete(Result). }
  if (Result >= 0) then
    Delete(Result);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TBCList.SetCapacity(NewCapacity: SizeUInt);
begin
  { (1) If NewCapacity is smaller than FCount, raise list capacity error. }
  if (NewCapacity < FCount) then
    Error(@SBCList_ListCapacityError, 'TBCList.SetCapacity', NewCapacity);

  { (2.1) If NewCapacity isn't equal to FCapacity, ... }
  if (NewCapacity <> FCapacity) then
  begin
    { (2.2) ... set new length equal NewCapacity for the dynamic array and ... }
    SetLength(FList, NewCapacity);

    { (2.3) ... store NewCapacity value in FCapacity. }
    FCapacity := NewCapacity;
  end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TBCList.SetCount(NewCount: SizeUInt);
var
  I: SizeUInt;
  Temp: Pointer;
begin
  { (1.1) If NewCount isn't equal to FCount: }
  if (NewCount <> FCount) then
  begin
    { (1.2) If NewCount is greater than FCapacity, set new capacity of
            the list. }
    if (NewCount > FCapacity) then
      SetCapacity(NewCount);

    { (1.3.1) If NewCount is greater than FCount, fill newly allocated space
              with 0. }
    if (NewCount > FCount) then
      FillChar(FList[FCount], (NewCount - FCount) * SizeOf(Pointer), 0)
    else
      { (1.3.2) Otherwise if the class isn't TBCList type: }
      if (ClassType <> TBCList) then
      begin
        { (1.3.2.1) Itterate throu the dynamic array, but in reverse order from
                    last item (FCount - 1) down to NewCount: }
        for I := (FCount - 1) downto NewCount do
        begin
          { (1.3.2.2) Decrement FCount by 1. }
          Dec(FCount);

          { (1.3.2.3) Store currently itterated item in the temporary Temp
                      variable. }
          Temp := List[I];

          { (1.3.2.4) If saved temporary variable isn't nil, notify that item
                      is deleted. }
          if (Temp <> nil) then
            Notify(Temp, lnDeleted);
        end;
      end;

    { (1.4) Store NewCount value in FCount variable. }
    FCount := NewCount;
  end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TBCList.SetItem(const Index: SizeUInt; Item: Pointer);
var
  Temp: Pointer;
begin
  { (1) If specified Index is out of bounds, raise out of bounds error. }
  if (Index >= FCount) then
    Error(@SBCList_ListIndexError, 'TBCList.SetItem', Index);

  { (2) Validate that new Item is different than stored one and execute further
        code only if validation was True. }
  if (Item <> FList[Index]) then
  begin
    { (3) Store current Item from specified position (Index) to the Temp pointer
          for later operations. }
    Temp := FList[Index];

    { (4) Store new Item in specified position (Index). }
    FList[Index] := Item;

    { (5.1) If the class type is TBCList ... }
    if (ClassType <> TBCList) then
    begin
      { (5.2.1) ... and Temp isn't nil, ... }
      if (Temp <> nil) then
        { (5.2.2) ... notify that Temp is deleted. }
        Notify(Temp, lnDeleted);

      { (5.3.1) ... and Item isn't nil, ... }
      if (Item <> nil) then
        { (5.3.2) ... notify that Item is added. }
        Notify(Item, lnAdded);
    end;
  end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TBCList.Sort(Compare: TListSortCompare);
begin
  { If the list contains at least two items, then ... }
  if (Count > 1) then
    { ... perform sorting of the list using QuickSort algorithm. }
    QuickSort(FList, 0, Count - 1,
      function(Item1, Item2: Pointer): Integer
      begin
        Result := Compare(Item1, Item2);
      end);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TBCList.SortList(const Compare: TListSortCompareFunc);
begin
  { If the list contains at least two items, then ... }
  if (Count > 1) then
    { ... perform sorting of the list using QuickSort algorithm. }
    QuickSort(FList, 0, Count - 1, Compare);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{===============================================================================
  TIntegerList - class implementation
===============================================================================}

{$IFDEF SUPPORTS_REGION}{$REGION 'TIntegerList implementation'}{$ENDIF}

{$IFDEF SUPPORTS_REGION}{$REGION 'TIntegerList.TEnumerator implementation'}{$ENDIF}
constructor TIntegerList.TEnumerator.Create(AList: TIntegerList);
begin
  { (1) Call inherited Create. }
  inherited Create;

  { (2) Set current position FIndex to -1. }
  FIndex := -1;

  { (3) Set FList to specified AList. }
  FList := AList;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TIntegerList.TEnumerator.GetCurrent: TIntItem;
begin
  { Return current item from the dynamic array. }
  //Result := FList.List[FIndex];
  Result := PIntItem(FList.List.List[FIndex])^;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TIntegerList.TEnumerator.MoveNext: Boolean;
begin
  { (1) Increment current position FIndex by 1. }
  Inc(FIndex);

  { (2) Return True if we didn't reach end of the dynamic array, or False if
        we are at the end of the dynamic array. }
  Result := FIndex < FList.Count;
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'TIntegerList.TReverseEnumerator implementation'}{$ENDIF}
constructor TIntegerList.TReverseEnumerator.Create(AList: TIntegerList);
begin
  { (1) Call inherited Create. }
  inherited Create;

  { (2) Set current position FIndex to AList.HighIndex + 1. }
  FIndex := AList.HighIndex + 1;

  { (3) Set FList to specified AList. }
  FList := AList;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TIntegerList.TReverseEnumerator.GetCurrent: TIntItem;
begin
  { Return current item from the dynamic array. }
  Result := PIntItem(FList.List.List[FIndex])^;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TIntegerList.TReverseEnumerator.MoveNext: Boolean;
begin
  { (1) Decrement current position FIndex by 1. }
  Dec(FIndex);

  { (2) Return True if we didn't reach end of the dynamic array, or False if
        we are at the end of the dynamic array. }
  Result := FIndex > FList.LowIndex;
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'TIntegerList.TIntList implementation'}{$ENDIF}
procedure TIntegerList.TIntList.Notify(Ptr: Pointer; Action: TListNotification);
begin
  if (Action = lnDeleted) then
    Dispose(Ptr);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TIntegerList.Add(Item: TIntItem): SizeUInt;
var
  pItem: PIntItem;
begin
  { (1) Allocate new pItem in memory and set it's value to Item. }
  New(pItem);
  pItem^ := Item;

  { (2) Add pointer to specified Item to the FList and returns index position
        which was returned by Add method. }
  Result := FList.Add(pItem);

  { (3) If FList.Count is equal to 1, save FFirst pointer. }
  if (FList.Count = 1) then
    FFirst := FList.First;

  { (4) Save last item in FLast. }
  FLast := FList.Last;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TIntegerList.Assign(Other: TIntegerList);
begin
  { (1) Assign other list to this list. }
  FList.Assign(Other.List, laCopy);

  { (2) Save FFirst and FLast pointers. }
  FFirst := Other.First;
  FLast := Other.Last;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TIntegerList.BestShuffle;
var
  TmpList: TBCList;
  Idx: SizeUInt;
begin
  { (1) Create temporary list TmpList. }
  TmpList := TBCList.Create;
  try
    { (2) Copy all of the entries of the list to TmpList. }
    TmpList.CopyFrom(FList);

    { (3) Clear the list. }
    Clear;

    { (4.1) While TmpList.Count is greater than 0, ... }
    while (TmpList.Count > 0) do
    begin
      { (4.2) Get random value in range [0..TmpList.Count]. }
      Idx := Random(TmpList.Count);

      { (4.3) Add entry with random Idx to the list. }
      FList.Add(TmpList[Idx]);

      { (4.4) Delete added entry from TmpList. }
      TmpList.Delete(Idx);
    end;
  finally
    { (5) Finally release temporary TmpList. }
    TmpList.Free;

    { (6) Update FFirst and FLast pointers. }
    FFirst := FList.First;
    FLast := FList.Last;
  end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TIntegerList.ChainToString: String;
var
  It: TBCList.TEnumerator;
begin
  { (1) Set Result to ''. }
  Result := '';

  { (3) Retrieve FList enumerator. }
  It := FList.GetEnumerator;

  { (3.1) Itterate throu the list using enumerator and ... }
  while It.MoveNext do
  begin
    { (3.2) Append current entry of enumerator as string. }
    Result := Result + IntToStr(PIntItem(It.Current)^);

    { (3.3) If we didn't read end of the list, append ',' character to the
            Result string. }
    if (It.Index < FList.Count - 1) then
      Result := Result + ', ';
  end;

  { (4) Release enumerator. }
  It.Free;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TIntegerList.Clear;
begin
  { (1) Clear FList. }
  FList.Clear;

  { (2) Set FFirst and FLast to nil. }
  FFirst := nil;
  FLast := nil;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TIntegerList.CopyFrom(const Source: TIntegerList);
var
  It: TIntegerList.TEnumerator;
begin
  { (1) If Source.Count is greater than 0, then: }
  if (Source.Count > 0) then
  begin
    { (2) Retrieve Source enumerator and store it in It variable. }
    It := Source.GetEnumerator;

    { (3) Itterate throu all entries of Source list and add them to the list. }
    while It.MoveNext do
      Add(It.Current);

    { (4) Update FFirst and FLast pointers. }
    FFirst := Source.First;
    FLast := Source.Last;

    { (5) Release enumerator. }
    It.Free;
  end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

constructor TIntegerList.Create;
begin
  inherited;

  { (1) Create the list. }
  FList := TIntList.Create;

  { (2) Set FFirst and FLast pointers to nil. }
  FFirst := nil;
  FLast := nil;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TIntegerList.Delete(Index: SizeUInt);
var
  Tmp: PIntItem;
begin
  { (1) Make sure that specified Index is not out of bound. If is, raise
        error. }
  if (Index >= FList.Count) then
    Error(@SIntegerList_ListIndexError, 'TIntegerList.Delete', Index);

  { (2) Make temporary copy of entry pointer. }
  Tmp := FList[Index];

  { (3) Delete entry from the list. }
  FList.Delete(Index);

  { (4) Update FFirst and FLast pointers. }
  FFirst := FList.First;
  FLast := FList.Last;

  { (5) If the class isn't TIntegerList type, then notify that item was
        deleted. }
  if (ClassType <> TIntegerList) then
    Notify(Tmp, lnDeleted);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

destructor TIntegerList.Destroy;
begin
  { Release FList. }
  FList.Free;

  inherited;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

class procedure TIntegerList.Error(Msg: PResStringRec; const Method: String; Data: NativeInt);
begin
  { Raise error. }
  raise EIntegerListError.CreateFmt(LoadResString(Msg), [Method, Data]) at ReturnAddress;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

class procedure TIntegerList.Error(const Msg, Method: String; Data: NativeInt);
begin
  { Raise error. }
  raise EIntegerListError.CreateFmt(Msg, [Method, Data]) at ReturnAddress;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TIntegerList.Exchange(Index1, Index2: SizeUInt);
begin
  { (1) Raise list index error if Index1 and Index2 variables are out of
        bounds. }
  if (Index1 >= FList.Count) then
    Error(@SIntegerList_ListIndexError, 'TIntegerList.Exchange', Index1);
  if (Index2 >= FList.Count) then
    Error(@SIntegerList_ListIndexError, 'TIntegerList.Exchange', Index2);

  { (2) Exchange two entries. }
  FList.Exchange(Index1, Index2);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TIntegerList.Expand: TIntegerList;
begin
  { (1) Expand the list. }
  FList := FList.Expand;

  { (2) Update FFirst and FLast pointers. }
  FFirst := FList.First;
  FLast := FList.Last;

  { (3) Return your self. }
  Result := Self;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TIntegerList.Extract(Item: TIntItem): PIntItem;
begin
  { Call ExtractItem() with from beginning direction. }
  Result := ExtractItem(Item, TDirection.FromBeginning);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TIntegerList.ExtractItem(Item: TIntItem; Direction: TDirection): PIntItem;
var
  I: SizeInt;
begin
  { (1) For now set Result variable as nil. }
  Result := nil;

  { (2) Search for specified Item throu all entries using specified Direction. }
  I := IndexOfItem(Item, Direction);

  { (3.1) If something was found: }
  if (I >= 0) then
  begin
    { (3.2) Store list's entry as a result. }
    Result := FList[I];

    { (3.3) Set nil to list's entry that we found. }
    FList[I] := nil;

    { (3.4) Perform proper removal of the item from the list. }
    Delete(I);

    { (3.5) Update FFirst and FLast pointers. }
    FFirst := FList.First;
    FLast := FList.Last;

    { (3.6) If the class isn't TIntegerList type, then notify that item is
            extracted. }
    if (ClassType <> TIntegerList) then
      Notify(Result, lnExtracted);
  end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TIntegerList.First: PIntItem;
begin
  { Return cached FFirst pointer. }
  Result := FFirst;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TIntegerList.GetCapacity: SizeUInt;
begin
  Result := FList.Capacity;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TIntegerList.GetCount: SizeUInt;
begin
  Result := FList.Count;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TIntegerList.GetEnumerator: TIntegerList.TEnumerator;
begin
  Result := TEnumerator.Create(Self);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TIntegerList.GetItem(const Index: SizeUInt): TIntItem;
begin
  { (1) Make sure that Index is in the bounds, if not then raise error. }
  if (Index >= FList.Count) then
    Error(SIntegerList_ListIndexError, 'TIntegerList.GetItem', Index);

  { (2) Return entry with Index position in the list. }
  Result := PIntItem(FList[Index])^;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TIntegerList.GetMemAddr: Pointer;
begin
  { Return FList.MemAddr property. }
  Result := FList.MemAddr;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TIntegerList.GetReverseEnumerator: TIntegerList.TReverseEnumerator;
begin
  { Create reverse enumerator for this list. }
  Result := TReverseEnumerator.Create(Self);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TIntegerList.HighIndex: SizeInt;
begin
  { Return FList.HighIndex. }
  Result := FList.HighIndex;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TIntegerList.IndexOf(Item: TIntItem): SizeInt;
var
  P: PPointer;
begin
  { (1) If FList.Count is greater than 0, then: }
  if (FList.Count > 0) then
  begin
    { (2) Store pointer of the FList.List in P variable. }
    P := Pointer(FList.List);

    { (3.1) Itterate from FList.LowIndex to FList.HighIndex and save that value in
            Result: }
    for Result := FList.LowIndex to FList.HighIndex do
    begin
      { (3.2) Cast the pointer P to proper type and compare it with searched Item.
              If comparison is successful, exit from this function. Return value
              is set already by for-loop. }
      if (PIntItem(P)^ = Item) then
        Exit;


      { (3.3) Increment the P pointer. }
      Inc(P);
    end;
  end;

  { (4) If we reach this point, we didn't find specified Item so return -1. }
  Result := -1;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TIntegerList.IndexOfItem(Item: TIntItem; Direction: TDirection): SizeInt;
var
  P: PPointer;
begin
  { (1.1) If specified Direction is equal to FromBeginning, call
          IndexOf(Item). }
  if (Direction = FromBeginning) then
    Result := IndexOf(Item)
  else
    begin
      { (1.2.1) Otherwise if FList.Count is greater than 0: }
      if (FList.Count > 0) then
      begin
        { (1.2.2) Retrieve pointer to last item of the dynamic array and store
                  it in P variable. }
        P := Pointer(@FList.List[FList.Count - 1]);

        { (1.2.3.1) Itterate from (FCount - 1) down to 0 and save that value in
                  Result: }
        for Result := FList.HighIndex downto FList.LowIndex do
        begin
          { (1.2.3.2) Cast the pointer P to proper type and compare it with
                      searched Item. If comparison is successful, exit from this
                      function. }
          if (PIntItem(P)^ = Item) then
            Exit;

          { (1.2.3.3) Decrement the P pointer. }
          Dec(P);
        end;
      end;

      { (1.2.4) If we reach this point, we didn't find specified Item so
                return -1. }
      Result := -1;
    end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TIntegerList.Insert(Index: SizeUInt; Item: TIntItem);
begin
  { (1) If Index is greater than FList.Count, Raise out of bounds error. }
  if (Index > FList.Count) then
    Error(@SIntegerList_ListIndexError, 'TIntegerList.Insert', Index);

  { (2) Insert specified Item to the list. }
  FList.Insert(Index, @Item);

  { (3) Update FFirst and FLast pointers. }
  FFirst := FList.First;
  FLast := FList.Last;

  { (4) If this class isn't TIntegerList type, then notify that Item is added. }
  if (ClassType <> TIntegerList) then
    Notify(@Item, lnAdded);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TIntegerList.Last: PIntItem;
begin
  { Return cached FLast pointer. }
  Result := FLast;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TIntegerList.LowIndex: SizeInt;
begin
  { Return FList.LowIndex. }
  Result := FList.LowIndex;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TIntegerList.Move(CurIndex, NewIndex: SizeUInt);
begin
  { (1) If CurIndex isn't equal to NewIndex: }
  if (CurIndex <> NewIndex) then
  begin
    { (2.1) Check that CurIndex and NewIndex aren't out of bounds. Raise error
            if needed. }
    if (CurIndex >= FList.Count) then
      Error(@SIntegerList_ListIndexError, 'TIntegerList.Move', CurIndex);
    if (NewIndex >= FList.Count) then
      Error(@SIntegerList_ListIndexError, 'TIntegerList.Move', NewIndex);

    { (2.2) Move entries in the list. }
    FList.Move(CurIndex, NewIndex);
  end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TIntegerList.Notify(Ptr: Pointer; Action: TListNotification);
begin
  { Do nothing. If user want to handle notification, implementation of this
    method must be made. }
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TIntegerList.Remove(Item: TIntItem): SizeInt;
begin
  { Search for first specified Item using FromBeginning direction. If found,
    delete it and return its position where it was in the list or -1 if not
    found. }
  Result := RemoveItem(Item, FromBeginning);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TIntegerList.RemoveDuplicates;
var
  I, J: SizeUInt;
begin
  for J := (FList.Count - 1) downto 0 do
    for I := 0 to (J - 1) do
      if (PIntItem(FList[J])^ = PIntItem(FList[I])^) then
      begin
        Delete(J);
        Break;
      end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TIntegerList.RemoveItem(Item: TIntItem; Direction: TDirection): SizeInt;
begin
  { (1) Search for first specified Item in the list using specified Direction
        of search and store its position in Result when found or -1 when not
        found. }
  Result := IndexOfItem(Item, Direction);

  { (2) If Result is greater or equal to 0, call Delete(Result). }
  if (Result >= 0) then
    Delete(Result);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TIntegerList.SameAs(const Other: TIntegerList): Boolean;
var
  I: SizeUInt;
begin
  { (1) If both list are the same or if both list have 0 entries, then they are
        the same so return True. }
  if ((Self = Other) or ((FList.Count = 0) and (Other.Count = 0))) then
    Exit(True);

  { (2) If entries amount of both lists aren't the same, lists aren't equal. }
  if (FList.Count <> Other.Count) then
    Exit(False);

  { (3) Validate entries one by one. }
  for I := LowIndex to HighIndex do
    if (PIntItem(FList[I])^ <> PIntItem(Other.List[I])^) then
      Exit(False);

  Result := True;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TIntegerList.SetCapacity(NewCapacity: SizeUInt);
begin
  { (1) If NewCapacity is smaller than FList.Count, raise list capacity error. }
  if (NewCapacity < FList.Count) then
    Error(@SIntegerList_ListCapacityError, 'TIntegerList.SetCapacity', NewCapacity);

  FList.Capacity := NewCapacity;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TIntegerList.SetCount(NewCount: SizeUInt);
begin
  { (1) Set NewCount to FList.Count property. }
  FList.Count := NewCount;

  { (2) Update FFirst and FLast pointers. }
  FFirst := FList.First;
  FLast := FList.Last;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TIntegerList.SetItem(const Index: SizeUInt; Item: TIntItem);
begin
  { (1) If specified Index is out of bounds, raise out of bounds error. }
  if (Index >= FList.Count) then
    Error(@SIntegerList_ListIndexError, 'TIntegerList.SetItem', Index);

  { (2) Set new item. }
  FList[Index] := @Item;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TIntegerList.Shuffle;
var
  I: SizeUInt;
begin
  for I := FList.HighIndex downto (FList.LowIndex + 1) do
    Exchange(I, SizeUInt(Random(I + 1)));
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TIntegerList.Sort(Compare: TListSortCompare);
begin
  { If the list contains at least two items, then ... }
  if (Count > 1) then
    { ... perform sorting of the list using QuickSort algorithm. }
    QuickSort(FList.List, FList.LowIndex, FList.HighIndex,
      function(Item1, Item2: Pointer): Integer
      begin
        Result := Compare(Item1, Item2);
      end);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TIntegerList.SortList(const Compare: TListSortCompareFunc);
begin
  { If the list contains at least two items, then ... }
  if (FList.Count > 1) then
    { ... perform sorting of the list using QuickSort algorithm. }
    QuickSort(FList.List, FList.LowIndex, FList.HighIndex, Compare);
end;

{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

end.
