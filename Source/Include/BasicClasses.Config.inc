{===============================================================================

  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

===============================================================================}

{$IFNDEF BC_CONFIG_INC}
{$DEFINE BC_CONFIG_INC}

{ Include jedi.inc file. }
{$INCLUDE jedi\jedi.inc}

{$IFDEF SUPPORTS_LEGACYIFEND}{$LEGACYIFEND ON}{$ENDIF}
{$UNDEF BC_PurePascal}
{$UNDEF BC_IntegerListUsesStdInt}
{$UNDEF BC_IntegerProbabilityListUsesStdInt}

{-- Remove dot ('.') to enable specific feature in Lib.BasicClasses -----------}

{ BC_PurePascal feature forces compiler to build this library in pure pascal,
  any assembler code will not be compiled. Enabling this feature, entire library
  and this unit will be compiled in PurePascal mode. }
{.$DEFINE BC_PurePascal}

{ BC_IntegerListUsesStdInt feature forces TIntegerList class to holds StdInt
  type as an item. }
{.$DEFINE BC_IntegerListUsesStdInt}

{ BC_IntegerProbabilityListUsesStdInt feature forces TIntProbList class to holds
  StdInt type as an item. }
{.$DEFINE BC_IntegerProbabilityListUsesStdInt}

{------------------------------------------------------------------------------}

{$IFDEF BC_PurePascal}
 {$DEFINE PurePascal}
{$ENDIF ~BC_PurePascal}

{$IF DEFINED(CPUX86_64) OR DEFINED(CPUX64)}
 {$DEFINE x64}
{$ELSEIF DEFINED(CPU386)}
 {$DEFINE x86}
{$ELSE}
 {$DEFINE PurePascal}
{$IFEND}

{$IF DEFINED(WINDOWS) OR DEFINED(MSWINDOWS)}
 {$DEFINE Windows}
{$ELSE}
 {$MESSAGE FATAL 'Unsupported operating system!'}
{$IFEND}

{ Delphi compiler directives. }
{$DEFINE DELPHI}
{$ALIGN ON}
{$H+}

{$ENDIF ~BC_CONFIG_INC}

