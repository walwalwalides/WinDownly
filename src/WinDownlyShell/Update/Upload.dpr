program Upload;

{$R *.res}

uses
  Winapi.Windows,
  ProcessUtils in '..\Include\ProcessUtils.pas',
  CmdUtils in '..\Include\CmdUtils.pas',
  SysUtils.Min in '..\Include\SysUtils.Min.pas';

begin
  // Actually, Image-File-Execution-Options always pass one or more parameters
  ExitCode := ERROR_INVALID_PARAMETER;
  if ParamCount = 0 then
    Exit;

  ExitCode := STATUS_DLL_INIT_FAILED; // It will be overwritten on success
  if IsElevated then
    RunIgnoringIFEOAndWait(ParamsStartingFrom(1))
  else
    RunElevatedAndWait(ParamsStartingFrom(1));
end.
