program BasicClasses_Tests;

{$mode objfpc}{$H+}

uses
  LazUTF8, Classes, consoletestrunner, BasicClasses_TestCase,
  BasicClasses_Lists_TestCase, BasicClasses_Streams_TestCase;

type
  { TMyTestRunner }
  TMyTestRunner = class(TTestRunner)
  protected
  // override the protected methods of TTestRunner to customize its behavior
  end;

var
  Application: TMyTestRunner;

begin
  Writeln('BasicClasses Test program');
  Writeln;
  Application := TMyTestRunner.Create(nil);
  Application.Initialize;
  Application.Title := 'Lib.BasicClasses Tests';
  Application.Run;
  Application.Free;

  Writeln('Done. Press <ENTER> key to quit.');
  Readln;
end.
