program BasicClasses_Tests;

{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}
{$STRONGLINKTYPES ON}
uses
  System.SysUtils,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ELSE}
  DUnitX.Loggers.Console,
  {$ENDIF }
  DUnitX.TestFramework,
  BasicClasses_TestCase in '..\..\Tests\BasicClasses_TestCase.pas',
  BasicClasses_Lists_TestCase in '..\..\Tests\BasicClasses_Lists_TestCase.pas',
  BasicClasses_Streams_TestCase in '..\..\Tests\BasicClasses_Streams_TestCase.pas';

{$IFNDEF TESTINSIGHT}
var
  runner: ITestRunner;
  results: IRunResults;
  logger: ITestLogger;
{$ENDIF}
begin
  Randomize;
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;

{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX.RunRegisteredTests;
{$ELSE}
  try
    { Check command line options, will exit if invalid. }
    TDUnitX.CheckCommandLine;

    { Create the test runner. }
    runner := TDUnitX.CreateRunner;

    { Tell the runner to use RTTI to find Fixtures. }
    runner.UseRTTI := True;

    { When true, Assertions must be made during tests. }
    runner.FailsOnNoAsserts := False;

    { tell the runner how we will log things. }
    { Log to the console window if desired. }
    if (TDUnitX.Options.ConsoleMode <> TDunitXConsoleMode.Off) then
    begin
      logger := TDUnitXConsoleLogger.Create(TDUnitX.Options.ConsoleMode = TDunitXConsoleMode.Quiet);
      runner.AddLogger(logger);
    end;

    { Run tests. }
    results := runner.Execute;
    if (not results.AllPassed) then
      System.ExitCode := EXIT_ERRORS;

    {$IFNDEF CI}
    { We don't want this happening when running under CI. }
    if (TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause) then
    begin
      System.Write('Done.. press <Enter> key to quit.');
      System.Readln;
    end;
    {$ENDIF}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;
{$ENDIF}
end.
