{===============================================================================

  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at http://mozilla.org/MPL/2.0/.

===============================================================================}

unit BasicClasses.Consts;

{$INCLUDE BasicClasses.Config.inc}

interface

resourcestring
  { TCustomMultiList }
  SCustomMultiList_ListCountMismatch = '%s: List count mismatch (%d,%d)!';
  SCustomMultiList_IndexOutOfBounds = '%s: List index %d out of bounds!';

  { TBCList }
  SBCList_ListIndexError = '%s: List index %d out of bounds!';
  SBCList_ListCapacityError = '%s: List capacity %d out of bounds!';

  { TIntegerList }
  SIntegerList_ListIndexError = '%s: List index %d out of bounds!';
  SIntegerList_ListCapacityError = '%s: List capacity %d out of bounds!';

  {TIntegerProbabilityList }
  SIntegerProbabilityList_ListIndexError = '%s: List index %d out of bounds!';
  SIntegerProbabilityList_ListCapacityError = '%s: List capacity %d out of bounds!';

implementation

end.
