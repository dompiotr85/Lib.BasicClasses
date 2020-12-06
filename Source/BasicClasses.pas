{===============================================================================

  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

===============================================================================}

{$INCLUDE BasicClasses.Config.inc}

{$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
/// <summary>
///   Increment and decrement routines in thread-safe fasion.
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

unit BasicClasses;

interface

uses
  {$IFDEF HAS_UNITSCOPE}System.SyncObjs{$ELSE}SyncObjs{$ENDIF},
  TypeDefinitions;

{$IFDEF SUPPORTS_REGION}{$REGION 'General routines'}{$ENDIF}
type
  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   Special data type that is meant for storing class instances in
  ///   <see cref="BasicClasses|BC_ClassInstances" />. Typically, this is a
  ///   32-bit signed integer.
  /// </summary>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  TBC_ClassInstances = Integer;

var
  {$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
  /// <summary>
  ///   A special global variable that holds number of un-released BC class
  ///   instances and is meant for debugging purposes, especially when running
  ///   under ARC in Delphi.
  /// </summary>
  {$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
  BC_ClassInstances: TBC_ClassInstances {$IFNDEF PASDOC}= 0{$ENDIF};

{$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
/// <summary>
///    Checks whether the Value is @nil and if not, calls
///    <see cref="FreeMem()" /> on that value and then assigns @nil to it.
/// </summary>
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
procedure FreeMemAndNil(var Value);

{$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
/// <summary>
///   Saves the current FPU state to stack and increments internal stack
///   pointer. The stack has length of 16. If the stack becomes full, this
///   function does nothing.
/// </summary>
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
procedure PushFPUState;

{$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
/// <summary>
///   Similarly to <see cref="BasicClasses|PushFPUState">PushFPUState()</see>,
///   this saves the current FPU state to stack and increments internal stack
///   pointer. Afterwards, this function disables all FPU exceptions. This is
///   typically used with Direct3D rendering methods that require FPU
///   exceptions to be disabled.
/// </summary>
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
procedure PushClearFPUState;

{$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
/// <summary>
///   Recovers FPU state from the stack previously saved by
///   <see cref="BasicClasses|PushFPUState">PushFPUState()</see> or
///   <see cref="BasicClasses|PushClearFPUState">PushClearFPUState()</see> and
///   decrements internal stack pointer. If there
///   are no items on the stack, this function does nothing.
/// </summary>
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
procedure PopFPUState;

{$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
/// <summary>
///   Increments the current number of BC class instances in a thread-safe
///   fashion.
/// </summary>
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
procedure Increment_BC_ClassInstances;

{$IFDEF SUPPORTS_REGION}{$REGION 'Documentation'}{$ENDIF}
/// <summary>
///   Decrements the current number of BC class instances in a thread-safe
///   fashion.
/// </summary>
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}
procedure Decrement_BC_ClassInstances; inline;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

implementation

uses
  {$IFDEF HAS_UNITSCOPE}System.SysUtils{$ELSE}SysUtils{$ENDIF},
  {$IFDEF HAS_UNITSCOPE}System.Math{$ELSE}Math{$ENDIF};

{$IFDEF SUPPORTS_REGION}{$REGION 'Global routines'}{$ENDIF}
const
  FPUStateStackLength = 16;

{$IF NOT DEFINED(DELPHIXE2_UP)}
type
  TArithmeticExceptionMask = TFPUExceptionMask;

const
  exAllArithmeticExceptions = [exInvalidOp, exDenormalized, exZeroDivide, exOverflow, exUnderflow, exPrecision];
{$IFEND}

var
  FPUStateStack: array[0..FPUStateStackLength - 1] of TArithmeticExceptionMask;
  FPUStackAt: Integer = 0;

procedure FreeMemAndNil(var Value);
var
  TempValue: Pointer;
begin
  if (Pointer(Value) <> nil) then
  begin
    TempValue := Pointer(Value);
    Pointer(Value) := nil;
    FreeMem(TempValue);
  end;
end;

procedure PushFPUState;
begin
  if (FPUStackAt >= FPUStateStackLength) then
    Exit;

  FPUStateStack[FPUStackAt] := GetExceptionMask;
  Inc(FPUStackAt);
end;

procedure PushClearFPUState;
begin
  PushFPUState;
  SetExceptionMask(exAllArithmeticExceptions);
end;

procedure PopFPUState;
begin
  if (FPUStackAt <= 0) then
    Exit;

  Dec(FPUStackAt);

  SetExceptionMask(FPUStateStack[FPUStackAt]);
  FPUStateStack[FPUStackAt] := [];
end;

procedure Increment_BC_ClassInstances;
begin
  TInterlocked.Increment(BC_ClassInstances);
end;

procedure Decrement_BC_ClassInstances;
begin
  TInterlocked.Decrement(BC_ClassInstances);
end;
{$IFDEF SUPPORTS_REGION}{$ENDREGION}{$ENDIF}

end.
