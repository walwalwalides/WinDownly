program Download;

{$R *.res}

uses
  Winapi.Windows,
  Winapi.Winsafer,
  ProcessUtils in '..\Include\ProcessUtils.pas',
  CmdUtils in '..\Include\CmdUtils.pas',
  SysUtils.Min in '..\Include\SysUtils.Min.pas';

const
  IFEO_KEY = '/IFEO'; // Makes sure we were launched from IFEO

var
  IFEO_Enabled: Boolean;
  StartFrom: integer;
  hLevel, hToken: THandle;
  UIAccess: DWORD;

begin
  // Actually, Image-File-Execution-Options always pass one or more parameters
  ExitCode := ERROR_INVALID_PARAMETER;
  if ParamCount = 0 then
    Exit;

  // making sure we were launched by IFEO
  IFEO_Enabled := ParamStr(1) = IFEO_KEY;
  if IFEO_Enabled and (ParamCount = 1) then
    Exit;

  if IFEO_Enabled then
    StartFrom := 2
  else
    StartFrom := 1;

  ExitCode := STATUS_DLL_INIT_FAILED; // It will be overwritten on success

  // Try to handle it without UAC
  SetEnvironmentVariable('__COMPAT_LAYER', 'RunAsInvoker');

  // Create restricted token
  if not SaferCreateLevel(SAFER_SCOPEID_USER, SAFER_LEVELID_NORMALUSER,
    SAFER_LEVEL_OPEN, hLevel, nil) then
    Exit;
  if not SaferComputeTokenFromLevel(hLevel, 0, @hToken, 0, nil) then
    Exit;
  SaferCloseLevel(hLevel);

  // Now we should fix the integrity level and set it to medium
  SetTokenIntegrity(hToken, ilMedium);

  // And also disable UIAccess flag
  UIAccess := 0;
  SetTokenInformation(hToken, TokenUIAccess, @UIAccess, SizeOf(UIAccess));

  if RunIgnoringIFEOAndWait(ParamsStartingFrom(StartFrom), hToken) =
    ERROR_ELEVATION_REQUIRED then
  begin
    if IFEO_Enabled then
      RunElevatedAndWait(ParamsStartingFrom(StartFrom))
    else // We can't rely on Image-File-Execution-Options
      RunElevatedAndWait('"' + ParamStr(0) + '" ' + ParamsStartingFrom(1))
      { In this case the only way to launch the program with restricted but
        elevated token is to start it from another instance of Drop.exe
        with higher privileges.}
  end;
end.
