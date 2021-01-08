unit BasicClasses_TestCase;

interface

uses
  DUnitX.TestFramework,
  BasicClasses;

type
  { TBasicClasses_Test - class definition }
  [TestFixture]
  TBasicClasses_TestCase = class
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    { Test methods }
    [TestCase('TCustomObject', '')]
    procedure Test_TCustomObject_InstanceString;
    [TestCase('TCustomRefCountedObject', '')]
    procedure Test_TCustomRefCountedObject;
  end;

implementation

uses
  System.SysUtils;

{ TBasicClasses_Test - class implementation }

procedure TBasicClasses_TestCase.Setup;
begin
  { Do nothing }
end;

procedure TBasicClasses_TestCase.TearDown;
begin
  { Do nothing }
end;

procedure TBasicClasses_TestCase.Test_TCustomObject_InstanceString;
var
  MyObject: TCustomObject;
begin
  { (1) Create MyObject. }
  MyObject := TCustomObject.Create;
  try
    { (2) Test MyObject.InstanceString return string. }
    Assert.AreEqual('TCustomObject', Copy(MyObject.InstanceString, 1, 13));
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

  Assert.AreEqual(0, RefCountedObj.RefCount, 'RefCountedObj.RefCount isn''t equal to 0!');

  RefCountedObj.Acquire;
  Assert.AreEqual(1, RefCountedObj.RefCount, 'RefCountedObj.RefCount isn''t equal to 1!');

  RefCountedObj2 := RefCountedObj.RetrieveRefCountedObjectCopy;
  Assert.AreEqual(2, RefCountedObj.RefCount, 'RefCountedObj.RefCount isn''t equal to 2!');
  Assert.AreEqual(2, RefCountedObj2.RefCount, 'RefCountedObj2.RefCount isn''t equal to 2!');

  RefCountedObj2.Release;

  Tmp := RefCountedObj.Release;
  Assert.AreEqual(0, Tmp, 'RefCountedObj.Release isn''t equal to 0!');
end;

initialization
  TDUnitX.RegisterTestFixture(TBasicClasses_TestCase);

end.
