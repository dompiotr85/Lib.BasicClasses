{===============================================================================

  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

===============================================================================}

{-------------------------------------------------------------------------------
 Basic classes implementation and other class-related things.

 Version 0.1.3

 Copyright (c) 2018-2021, Piotr Doma�ski

 Last change:
   01-01-2021

 Changelog:
   For detailed changelog and history please refer to this git repository:
     https://github.com/dompiotr85/Lib.BasicClasses

 Contacts:
   Piotr Doma�ski (dom.piotr.85@gmail.com)

 Dependencies:
   - JEDI common files (https://github.com/project-jedi/jedi)
   - Lib.TypeDefinitions (https://github.com/dompiotr85/Lib.TypeDefinitions)
-------------------------------------------------------------------------------}

{$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
/// <summary>
///   Basic classes implementation and other class-related things.
/// </summary>
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

unit BasicClasses;

{$INCLUDE BasicClasses.Config.inc}

interface

uses
  {$IFDEF HAS_UNITSCOPE}System.SysUtils{$ELSE}SysUtils{$ENDIF},
  TypeDefinitions;

{- Event and callback types  - - - - - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Event and callback types'}{$ENDIF}
type
  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Plain event type.
  /// </summary>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  TPlainEvent = procedure of object;

  {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Plain callback type.
  /// </summary>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  TPlainCallback = procedure;

  {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Notify event type.
  /// </summary>
  /// <remarks>
  ///   TNotifyEvent is declared in BasicClasses unit, but if including entire
  ///   classes unit into the project is not desirable, this declaration can be
  ///   used instead.
  /// </remarks>
  /// <param name="Sender">
  ///   In an event handler, the Sender parameter indicates which component
  ///   received the event and therefore called the handler.
  /// </param>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  TNotifyEvent = procedure (Sender: TObject) of object;

  {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Notify callback type.
  /// </summary>
  /// <param name="Sender">
  ///   Reference to the control that was used to call the method.
  /// </param>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  TNotifyCallback = procedure (Sender: TObject);

  {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Integer event type.
  /// </summary>
  /// <param name="Sender">
  ///   In an event handler, the Sender parameter indicates which component
  ///   received the event and therefore called the handler.
  /// </param>
  /// <param name="Value">
  ///   Reference to the integer value.
  /// </param>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  TIntegerEvent = procedure (Sender: TObject; Value: Integer) of object;

  {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Integer callback type.
  /// </summary>
  /// <param name="Sender">
  ///   Reference to the control that was used to call the method.
  /// </param>
  /// <param name="Value">
  ///   Reference to the integer value.
  /// </param>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  TIntegerCallback = procedure (Sender: TObject; Value: Integer);

  {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Index event type.
  /// </summary>
  /// <param name="Sender">
  ///   In an event handler, the Sender parameter indicates which component
  ///   received the event and therefore called the handler.
  /// </param>
  /// <param name="Index">
  ///   Reference to the index value.
  /// </param>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  TIndexEvent = procedure (Sender: TObject; Index: Integer) of object;

  {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Index callback type.
  /// </summary>
  /// <param name="Sender">
  ///   Reference to the control that was used to call the method.
  /// </param>
  /// <param name="Index">
  ///   Reference to the index value.
  /// </param>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  TIndexCallback = procedure (Sender: TObject; Index: Integer);

  {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Float event type.
  /// </summary>
  /// <param name="Sender">
  ///   In an event handler, the Sender parameter indicates which component
  ///   received the event and therefore called the handler.
  /// </param>
  /// <param name="Value">
  ///   Reference to the Float value.
  /// </param>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  TFloatEvent = procedure (Sender: TObject; Value: Float) of object;

  {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Float callback type.
  /// </summary>
  /// <param name="Sender">
  ///   Reference to the control that was used to call the method.
  /// </param>
  /// <param name="Value">
  ///   Reference to the Float value.
  /// </param>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  TFloatCallback = procedure (Sender: TObject; Value: Float);

  {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   String event type.
  /// </summary>
  /// <param name="Sender">
  ///   In an event handler, the Sender parameter indicates which component
  ///   received the event and therefore called the handler.
  /// </param>
  /// <param name="Value">
  ///   Reference to the string value.
  /// </param>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  TStringEvent = procedure (Sender: TObject; const Value: String) of object;

  {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   String callback type.
  /// </summary>
  /// <param name="Sender">
  ///   Reference to the control that was used to call the method.
  /// </param>
  /// <param name="Value">
  ///   Reference to the string value.
  /// </param>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  TStringCallback = procedure (Sender: TObject; const Value: String);

  {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Memory event type.
  /// </summary>
  /// <param name="Sender">
  ///   In an event handler, the Sender parameter indicates which component
  ///   received the event and therefore called the handler.
  /// </param>
  /// <param name="Addr">
  ///   Reference to the pointer pointing to some memory address.
  /// </param>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  TMemoryEvent = procedure (Sender: TObject; Addr: Pointer) of object;

  {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Memory callback type.
  /// </summary>
  /// <param name="Sender">
  ///   Reference to the control that was used to call the method.
  /// </param>
  /// <param name="Addr">
  ///   Reference to the pointer pointing to some memory address.
  /// </param>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  TMemoryCallback = procedure (Sender: TObject; Addr: Pointer);

  {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Buffer event type.
  /// </summary>
  /// <param name="Sender">
  ///   In an event handler, the Sender parameter indicates which component
  ///   received the event and therefore called the handler.
  /// </param>
  /// <param name="Buffer">
  ///   Reference to the buffer.
  /// </param>
  /// <param name="Size">
  ///   Reference to the size value of a buffer.
  /// </param>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  TBufferEvent = procedure (Sender: TObject; const Buffer; Size: TMemSize) of object;

  {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Buffer callback type.
  /// </summary>
  /// <param name="Sender">
  ///   Reference to the control that was used to call the method.
  /// </param>
  /// <param name="Buffer">
  ///   Reference to the buffer.
  /// </param>
  /// <param name="Size">
  ///   Reference to the size value of a buffer.
  /// </param>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  TBufferCallback = procedure (Sender: TObject; const Buffer; Size: TMemSize);

  {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Object event type.
  /// </summary>
  /// <param name="Sender">
  ///   In an event handler, the Sender parameter indicates which component
  ///   received the event and therefore called the handler.
  /// </param>
  /// <param name="Obj">
  ///   Reference to the object class.
  /// </param>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  TObjectEvent = procedure (Sender: TObject; Obj: TObject) of object;

  {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Object callback type.
  /// </summary>
  /// <param name="Sender">
  ///   Reference to the control that was used to call the method.
  /// </param>
  /// <param name="Obj">
  ///   Reference to the object class.
  /// </param>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  TObjectCallback = procedure (Sender: TObject; Obj: TObject);

  {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Open event type.
  /// </summary>
  /// <param name="Sender">
  ///   In an event handler, the Sender parameter indicates which component
  ///   received the event and therefore called the handler.
  /// </param>
  /// <param name="Values">
  ///   Reference to the dynamic array of items.
  /// </param>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  TOpenEvent = procedure (Sender: TObject; Values: array of const) of object;

  {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Open callback type.
  /// </summary>
  /// <param name="Sender">
  ///   Reference to the control that was used to call the method.
  /// </param>
  /// <param name="Values">
  ///   Reference to the dynamic array of items.
  /// </param>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  TOpenCallback = procedure (Sender: TObject; Values: array of const);
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- General routines definition  - - - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'General routines'}{$ENDIF}

{$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
/// <summary>
///   Returns human-readable string describing specified Instance.
/// </summary>
/// <param name="Instance">
///   Reference to the instance that will be described.
/// </param>
/// <returns>
///   Returns human-readable string describing specified Instance.
/// </returns>
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
function GetInstanceString(Instance: TObject): String;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- Library exceptions  - - - - - - - - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'Library exceptions'}{$ENDIF}
type
  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Generic BasicClasses exception.
  /// </summary>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  EBCException = class(Exception);

  {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   TCustomMultiList exception class.
  /// </summary>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  ECustomMultiList = class(EBCException);

  {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   TBCList exception class.
  /// </summary>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  EBCListError = class(EBCException);

  {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   TIntegerList exception class.
  /// </summary>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  EIntegerListError = class(EBCException);

  {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   TIntegerProbabilityList exception class.
  /// </summary>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  EIntegerProbabilityListError = class(EBCException);

  {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   TCustomStreamer exception class.
  /// </summary>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  ECustomStreamerError = class(EBCException);

{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- TCustomObject - class definition - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'TCustomObject - class definition'}{$ENDIF}
type
  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Custom object class with simple Integer data and pointer data than can
  ///   be used by user for any purpose.
  /// </summary>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  TCustomObject = class(TObject)
  private
    FUserIntData: PtrInt;
    FUserPtrData: Pointer;
  protected
    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Raises error exception with specified parameters.
    /// </summary>
    /// <param name="ExceptionClass">
    ///   Reference to exception class.
    /// </param>
    /// <param name="Method">
    ///   Method name where exception will be raised.
    /// </param>
    /// <param name="Msg">
    ///   Message string that will be displayed.
    /// </param>
    /// <param name="Args">
    ///   Dynamic array with arguments.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure RaiseError(ExceptionClass: ExceptClass; const Method, Msg: String; const Args: array of const); overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Raises error exception with specified parameters.
    /// </summary>
    /// <param name="ExceptionClass">
    ///   Reference to exception class.
    /// </param>
    /// <param name="Method">
    ///   Method name where exception will be raised.
    /// </param>
    /// <param name="Msg">
    ///   Message string that will be displayed.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure RaiseError(ExceptionClass: ExceptClass; const Method, Msg: String); overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Raises error exception with specified parameters.
    /// </summary>
    /// <param name="Method">
    ///   Method name where exception will be raised.
    /// </param>
    /// <param name="Msg">
    ///   Message string that will be displayed.
    /// </param>
    /// <param name="Args">
    ///   Dynamic array with arguments.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure RaiseError(const Method, Msg: String; const Args: array of const); overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Raises error exception with specified parameters.
    /// </summary>
    /// <param name="Method">
    ///   Method name where exception will be raised.
    /// </param>
    /// <param name="Msg">
    ///   Message string that will be displayed.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure RaiseError(const Method, Msg: String); overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Raises error exception with specified parameters.
    /// </summary>
    /// <param name="ExceptionClass">
    ///   Reference to exception class.
    /// </param>
    /// <param name="Msg">
    ///   Message string that will be displayed.
    /// </param>
    /// <param name="Args">
    ///   Dynamic array with arguments.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure RaiseError(ExceptionClass: ExceptClass; const Msg: String; const Args: array of const); overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Raises error exception with specified parameters.
    /// </summary>
    /// <param name="ExceptionClass">
    ///   Reference to exception class.
    /// </param>
    /// <param name="Msg">
    ///   Message string that will be displayed.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure RaiseError(ExceptionClass: ExceptClass; const Msg: String); overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Raises error exception with specified parameters.
    /// </summary>
    /// <param name="Msg">
    ///   Message string that will be displayed.
    /// </param>
    /// <param name="Args">
    ///   Dynamic array with arguments.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure RaiseError(const Msg: String; const Args: array of const); overload; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Raises error exception with specified parameters.
    /// </summary>
    /// <param name="Msg">
    ///   Message string that will be displayed.
    /// </param>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    procedure RaiseError(const Msg: String); overload; virtual;

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
    ///   Returns human-readable string describing this class.
    /// </summary>
    /// <returns>
    ///   Returns human-readable string describing this class.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function InstanceString: String; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    property UserIntData: PtrInt read FUserIntData write FUserIntData;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    property UserPtrData: Pointer read FUserPtrData write FUserPtrData;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    property UserData: PtrInt read FUserIntData write FUserIntData;
  end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- TCustomRefCountedObject - class definition - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'TCustomRefCountedObject - class definition'}{$ENDIF}
type
  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Reference counted object. Note that reference counting is not
  ///   automatic, you have to call methods Acquire and Release for it to work.
  ///   When FreeOnRelease is set to true (by default set to false), then the
  ///   object is automatically freed inside of function Release when reference
  ///   counter upon entry to this function is 1 (ie. it reaches 0 in this
  ///   call).
  /// </summary>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  TCustomRefCountedObject = class(TCustomObject)
  private
    FRefCount: Int32;
    FFreeOnRelease: Boolean;

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Returns current reference count value.
    /// </summary>
    /// <returns>
    ///   Returns current reference count value.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function GetRefCount: Int32;

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
    ///   Increments internal reference counting value and returns its new
    ///   value.
    /// </summary>
    /// <returns>
    ///   Returns internal reference counting value after incrementation.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function Acquire: Int32; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Decrements internal reference counting value and returns its new
    ///   value.
    /// </summary>
    /// <returns>
    ///   Returns internal reference couting value after decrementation.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function Release: Int32; virtual;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
    /// <summary>
    ///   Retrieves reference to it self and returns it. In addition,
    ///   increments internal reference couting value.
    /// </summary>
    /// <returns>
    ///   Returns reference to it self with incremented reference couting
    ///   value.
    /// </returns>
    {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
    function RetrieveRefCountedObjectCopy: TCustomRefCountedObject;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    property RefCount: Int32 read GetRefCount;

    {- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

    property FreeOnRelease: Boolean read fFreeOnRelease write fFreeOnRelease;
  end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

implementation

{$IF NOT DEFINED(FPC) AND DEFINED(Windows) AND Defined(PurePascal)}
uses
  {$IFDEF HAS_UNITSCOPE}Winapi.{$ENDIF}Windows;
{$IFEND}

{- General routines implementation - - - - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'General routines implementation'}{$ENDIF}
function GetInstanceString(Instance: TObject): String;
begin
  if (Assigned(Instance)) then
    Result := Format('%s(%p)', [Instance.ClassName, Pointer(Instance)])
  else
    Result := 'TObject(nil)'; // Return some sensible string, not just nothing.
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- TCustomObject - class implementation  - - - - - - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'TCustomObject - class implementation'}{$ENDIF}
procedure TCustomObject.RaiseError(ExceptionClass: ExceptClass; const Method, Msg: String; const Args: array of const);
begin
{$IFDEF FPC}
  raise ExceptionClass.CreateFmt(Format('%s.%s: %s', [InstanceString, Method, Msg]), Args) at @TCustomObject.RaiseError;
{$ELSE}
  raise ExceptionClass.CreateFmt(Format('%s.%s: %s', [InstanceString, Method, Msg]), Args) at ReturnAddress;
{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TCustomObject.RaiseError(ExceptionClass: ExceptClass; const Method, Msg: String);
begin
  RaiseError(ExceptionClass, Method, Msg, []);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TCustomObject.RaiseError(const Method,Msg: String; const Args: array of const);
begin
  RaiseError(EBCException, Method, Msg, Args);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TCustomObject.RaiseError(const Method,Msg: String);
begin
  RaiseError(EBCException, Method, Msg, []);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TCustomObject.RaiseError(ExceptionClass: ExceptClass; const Msg: String; const Args: array of const);
begin
{$IFDEF FPC}
  raise ExceptionClass.CreateFmt(Format('%s: %s', [InstanceString, Msg]), Args) at @TCustomObject.RaiseError;
{$ELSE}
  raise ExceptionClass.CreateFmt(Format('%s: %s', [InstanceString, Msg]), Args) at ReturnAddress;
{$ENDIF}
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TCustomObject.RaiseError(ExceptionClass: ExceptClass; const Msg: String);
begin
  RaiseError(ExceptionClass, Msg, []);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TCustomObject.RaiseError(const Msg: String; const Args: array of const);
begin
  RaiseError(EBCException, Msg, Args);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure TCustomObject.RaiseError(const Msg: String);
begin
  RaiseError(EBCException, Msg, []);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

constructor TCustomObject.Create;
begin
  inherited;

  FUserIntData := 0;
  FUserPtrData := nil;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

Function TCustomObject.InstanceString: String;
begin
  Result := GetInstanceString(Self);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

{- TCustomRefCountedObject - class implementation  - - - - - - - - - - - - - - }
{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

{$IFDEF SUPPORTS_REGION}{$REGION 'TCustomRefCountedObject - class implementation'}{$ENDIF}
{$IFNDEF PurePascal}
function InterlockedExchangeAdd(var A: Int32; B: Int32): Int32; register; assembler;
asm
 {$IFDEF x64}
  {$IFDEF Windows}
        XCHG      RCX,  RDX
  LOCK  XADD      dword ptr [RDX], ECX
        MOV       EAX,  ECX
  {$ELSE !Windows}
        XCHG      RDI,  RSI
  LOCK  XADD      dword ptr [RSI], EDI
        MOV       EAX,  EDI
  {$ENDIF !Windows}
 {$ELSE !x64}
        XCHG       EAX,  EDX
  LOCK  XADD       dword ptr [EDX], EAX
 {$ENDIF !x64}
end;
{$ENDIF !PurePascal}

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomRefCountedObject.GetRefCount: Int32;
begin
  Result := InterlockedExchangeAdd(fRefCount, 0);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

constructor TCustomRefCountedObject.Create;
begin
  inherited Create;

  FRefCount := 0;
  FFreeOnRelease := False;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomRefCountedObject.Acquire: Int32;
begin
  Result := InterlockedExchangeAdd(fRefCount, 1) + 1;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomRefCountedObject.Release: Int32;
begin
  Result := InterlockedExchangeAdd(fRefCount, -1) - 1;
  if ((FFreeOnRelease) and (Result <= 0)) then
    Self.Free;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

function TCustomRefCountedObject.RetrieveRefCountedObjectCopy: TCustomRefCountedObject;
begin
  Acquire;
  Result := Self;
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

end.
