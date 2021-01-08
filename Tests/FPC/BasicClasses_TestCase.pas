unit BasicClasses_TestCase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry,
  BasicClasses;

type
  { TBasicClasses_TestCase }

  TBasicClasses_TestCase = class(TTestCase)
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    { Test methods }
    procedure Test_TCustomObject_InstanceString;
    procedure Test_TCustomRefCountedObject;
  end;

implementation

procedure TBasicClasses_TestCase.SetUp;
begin
  { Do nothing. }
end;

procedure TBasicClasses_TestCase.TearDown;
begin
  { Do nothing. }
end;

procedure TBasicClasses_TestCase.Test_TCustomObject_InstanceString;
var
  MyObject: TCustomObject;
begin
  { (1) Create MyObject. }
  MyObject := TCustomObject.Create;
  try
    { (2) Test MyObject.InstanceString return string. }
    AssertEquals('TCustomObject', Copy(MyObject.InstanceString, 1, 13));
  finally
    { (3) Finally release MyObject. }
    MyObject.Free;
  end;
end;

procedure TBasicClasses_TestCase.Test_TCustomRefCountedObject;
var
  RefCountedObj, RefCountedObj2: TCustomRefCountedObject;
  Tmp: Int32;
begin
  RefCountedObj := TCustomRefCountedObject.Create;
  RefCountedObj.FreeOnRelease := True;

  AssertEquals('RefCountedObj.RefCount isn''t equal to 0!', 0, RefCountedObj.RefCount);

  RefCountedObj.Acquire;
  AssertEquals('RefCountedObj.RefCount isn''t equal to 1!', 1, RefCountedObj.RefCount);

  RefCountedObj2 := RefCountedObj.RetrieveRefCountedObjectCopy;
  AssertEquals('RefCountedObj.RefCount isn''t equal to 2!', 2, RefCountedObj.RefCount);
  AssertEquals('RefCountedObj2.RefCount isn''t equal to 2!', 2, RefCountedObj2.RefCount);

  RefCountedObj2.Release;

  Tmp := RefCountedObj.Release;
  AssertEquals('RefCountedObj.Release isn''t equal to 0!', 0, Tmp);
end;

initialization
  RegisterTest(TBasicClasses_TestCase);

end.

