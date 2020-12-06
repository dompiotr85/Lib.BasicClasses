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

{ Enable the following option to make TIntegerList and TIntProbList use
  StdInt instead of Integer data type. This can be useful, for instance, when
  StdInt is used as 64-bit integer. }
{$DEFINE BC_TIntegerList_StdInt}

{ Delphi compiler directives. }
{$DEFINE DELPHI}
{$ALIGN ON}

{$ENDIF !BC_CONFIG_INC}

