unit BasicClassesTests;

interface

uses
  DUnitX.TestFramework,
  BasicClasses;

type
  [TestFixture]
  TBasicClasses_Test = class
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

procedure TBasicClasses_Test.Setup;
begin
  { Do nothing }
end;

procedure TBasicClasses_Test.TearDown;
begin
  { Do nothing }
end;

procedure TBasicClasses_Test.Test_TCustomObject_InstanceString;
var
  MyObject: TCustomObject;
begin
  MyObject := TCustomObject.Create;

  Assert.AreEqual('TCustomObject', Copy(MyObject.InstanceString, 1, 13));

  MyObject.Free;
end;

procedure TBasicClasses_Test.Test_TCustomRefCountedObject;
var
  RefCountedObj, RefCountedObj2: TCustomRefCountedObject;
  Tmp: Int32;
begin
  RefCountedObj := TCustomRefCountedObject.Create;
  RefCountedObj.FreeOnRelease := True;

  Assert.AreEqual(0, RefCountedObj.RefCount, 'RefCountedObj.RefCount isn''t equal 0!');

  RefCountedObj.Acquire;
  Assert.AreEqual(1, RefCountedObj.RefCount, 'RefCountedObj.RefCount isn''t equal 1!');

  RefCountedObj2 := RefCountedObj.RetrieveRefCountedObjectCopy;
  Assert.AreEqual(2, RefCountedObj.RefCount, 'RefCountedObj.RefCount isn''t equal 2!');
  Assert.AreEqual(2, RefCountedObj.RefCount, 'RefCountedObj2.RefCount isn''t equal 2!');

  RefCountedObj2.Release;

  Tmp := RefCountedObj.Release;
  Assert.AreEqual(0, Tmp, 'RefCountedObj.Release isn''t equal 0!');
end;

initialization
  TDUnitX.RegisterTestFixture(TBasicClasses_Test);

end.
