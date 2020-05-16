﻿program WinDownlyShell;

{$WEAKLINKRTTI ON}
{$R *.res}

uses
  System.SysUtils,
  Winapi.Windows,
  System.ioutils,
  System.zip,
  Tlhelp32,
  Shellapi,
  IniFiles,
  IFEO in 'Include\IFEO.pas',
  Registry2 in 'Include\Registry2.pas',
  CmdUtils in 'Include\CmdUtils.pas',
  ProcessUtils in 'Include\ProcessUtils.pas',
  ShellExtension in 'Include\ShellExtension.pas',
  MessageDialog in 'Include\MessageDialog.pas',
  uFileChecker in 'Include\uFileChecker.pas',
  uFileUtils in 'Include\uFileUtils.pas';

const
  DesDirectory_Name = 'WinDownly\';
  exeWinDownly = 'WinDownly.exe';
  PROGRAM_NAME = 'Execution Master shell extension';

procedure ShowStatusMessage(Verb: String; Text: String = '';
  Icon: TMessageIcon = miInformation);
begin
  ShowMessageOk(PROGRAM_NAME, Verb, Text, Icon);
end;

procedure ActionReset;
var
  Core: TImageFileExecutionOptions;
  executable: String;
  i: integer;
begin
  executable := ExtractFileName(ParamStr(2));
  try
    Core := TImageFileExecutionOptions.Create;
    for i := 0 to Core.Count - 1 do
    begin
      if ParamCount >= 2 then
        if Core[i].TreatedFile <> executable then
          Continue;
      Core.UnregisterDebugger(Core[i].TreatedFile);
      Break;
    end;
  finally
    FreeAndNil(Core);
  end;
  // ShowStatusMessage('The action was successfully reset.', executable);
end;

procedure CheckerUI(Text: string);
begin
  if ShowMessageYesNo(PROGRAM_NAME, 'Are you sure?', Text, miWarning) <> IDYES
  then
    raise Exception.Create('The operation was canceled by the user.');
end;

procedure CheckForProblems(Action: TAction; S: String);
var
  i: integer;
begin
  for i := Low(DangerousProcesses) to High(DangerousProcesses) do
    if LowerCase(S) = DangerousProcesses[i] then
    begin
      CheckerUI(Format(WARN_SYSPROC, [S]));
      Break;
    end;

  if Action in [aAsk .. aDisplayOn, aExecuteEx] then
  begin
    for i := Low(CompatibilityProblems) to High(CompatibilityProblems) do
      if LowerCase(S) = CompatibilityProblems[i] then
      begin
        CheckerUI(Format(WARN_COMPAT, [S]));
        Break;
      end;

    for i := Low(UIAccessPrograms) to High(UIAccessPrograms) do
      if LowerCase(S) = UIAccessPrograms[i] then
      begin
        CheckerUI(Format(WARN_UIACCESS, [S]));
        Break;
      end;
  end;
end;

function GetLastUploadFile: string;
const
  csDir = 'WinDownly\';
var
  INI: TIniFile;
  SFile: String;

  //
  LWorkingFileIndex: integer;
  LFileInformation: TFileInformation;
  sFilename: string;
begin

  Result := '';

  INI := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'WinDownly.ini');
  try

    sFilename := INI.ReadString('LastFile', 'Filename', '');

  finally
    INI.Free;
  end;

  if (sFilename <> '') then
  begin
    SFile := TPath.GetDocumentsPath + PathDelim + csDir + sFilename;

    if FileExists(SFile) then
      Result := sFilename
    else
      Result := '';

  end
  else
  begin
    Result := '';
  end;

end;

procedure DeleteFileDirectory(const Dir: string);
var
  Result: TSearchRec;

begin

  if FindFirst(Dir + '\*', faAnyFile, Result) = 0 then
  begin
    Try
      repeat
        if (Result.Attr and faDirectory) = faDirectory then
        begin
          if (Result.Name <> '.') and (Result.Name <> '..')  then
            begin
            DeleteFileDirectory(Pchar(Dir + '\' + Result.Name));
            end;

        end
        else if not DeleteFile(Pchar(Dir + '\' + Result.Name)) then
          RaiseLastOSError;
      until FindNext(Result) <> 0;
    Finally
      System.SysUtils.FindClose(Result);
    End;
  end;
  // if not RemoveDir(Dir) then
  // RaiseLastOSError;
end;

function processExists(ExeFileName: string): boolean;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: Thandle;
  FProcessEntry32: TProcessEntry32;
begin
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  Result := false;
  while integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile))
      = UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile)
      = UpperCase(ExeFileName))) then
    begin
      Result := true;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

function KillTask(ExeFileName: string): integer;
const
  PROCESS_TERMINATE = $0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: Thandle;
  FProcessEntry32: TProcessEntry32;
begin
  Result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);

  while integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile))
      = UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile)
      = UpperCase(ExeFileName))) then
      Result := integer(TerminateProcess(OpenProcess(PROCESS_TERMINATE, BOOL(0),
        FProcessEntry32.th32ProcessID), 0));
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

procedure SaveLastSendFile(const LFileName: string);
var
  INI: TIniFile;
  LWorkingFileCount: integer;
  LWorkingFileIndex: integer;
  LFileInformation: TFileInformation;
begin
  if FileIsInteresting(LFileName, LFileInformation) then
  begin

    INI := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'WinDownly.ini');
    try

      INI.WriteInteger('LastFile', 'Size', LFileInformation.FileSize);
      INI.writeBool('LastFile', 'Send', true);
      INI.WriteString('LastFile', 'Filetype', LFileInformation.FileType);

      INI.WriteString('LastFile', 'Filename', ExtractFileName(LFileName));

    finally
      INI.Free;
    end;
  end;
end;

procedure ActionSet;
var
  a: TAction;
  Dbg: TIFEORec;
  executable: string;
  SMovingFile, sexeWin: string;
  sDisDirectory: string;
  zip: TZipFile;
  iresult: integer;
  sGetLastUploadFile: string;
begin
  if ParamCount < 3 then
    raise Exception.Create('Not enough parameters.');
  for a := Low(TAction) to Pred(High(TAction)) do // not including aExecuteEx!
    if LowerCase(ParamStr(3)) = ActionShortNames[a] then
      Break;
  if a = High(TAction) then // for-cycle finished without breaking
    raise Exception.Create('Unknown action.');




  if a in [Low(TFileBasedAction) .. High(TFileBasedAction)] then
    if not FileExists(Copy(EMDebuggers[a], 2, Pos('"', EMDebuggers[a], 2) - 2))
        then // Only file without params
              raise Exception.Create(ERR_ACTION);

         executable := ExtractFileName(ParamStr(2));
  if (LowerCase(executable)='download') then
  begin
    if not processExists(exeWinDownly) then
    begin
      // KillTask('UPM.exe');
      iresult := ShellExecute(0, 'open', Pchar(sexeWin), '', nil, SW_SHOW);
    end;
    exit;
  end;


  CheckForProblems(a, executable);
  Dbg := TIFEORec.Create(a, executable);
  // TImageFileExecutionOptions.RegisterDebugger(Dbg);
  sDisDirectory := TPath.GetDocumentsPath + PathDelim + DesDirectory_Name;
  if not directoryexists(sDisDirectory) then
    ForceDirectories(sDisDirectory)
  else
  Begin
   sGetLastUploadFile := sDisDirectory+GetLastUploadFile;
   if FileExists(sGetLastUploadFile) then
   DeleteFile(Pchar(sGetLastUploadFile));

//    DeleteFileDirectory(sDisDirectory);
  End;

  sexeWin := ExtractFileDir(ParamStr(0)) + PathDelim + exeWinDownly;

  if not processExists(exeWinDownly) then
  begin
    // KillTask('UPM.exe');
    iresult := ShellExecute(0, 'open', Pchar(sexeWin), '', nil, SW_SHOW);
  end;

  zip := TZipFile.Create;
  try
    SMovingFile := ChangeFileExt(ExtractFileName(executable), '') + '.zip';
    zip.Open(SMovingFile, zmWrite);

    zip.Add(executable);

  finally
    zip.Free;
  end;
  executable := ChangeFileExt(executable, '.zip');

  moveFile(Pchar(executable), Pchar(sDisDirectory + SMovingFile));

  SaveLastSendFile(sDisDirectory + SMovingFile);

  // ShowStatusMessage('The action was successfully set.',
  // executable + '  →  ' + Dbg.GetCaption);
end;

begin
  try
    if ParamCount >= 1 then
    begin
      if LowerCase(ParamStr(1)) = 'set' then
        ActionSet
      else if LowerCase(ParamStr(1)) = 'reset' then // none
      begin
        if processExists(exeWinDownly) then
          KillTask(exeWinDownly);
      end
      else if LowerCase(ParamStr(1)) = '/reg' then
      begin
        RegShellMenu(ParamStr(0));
        // ShowStatusMessage('Shell extension was successfully registered.');
      end
      else if LowerCase(ParamStr(1)) = '/unreg' then
      begin
        UnregShellMenu;
        // ShowStatusMessage('Shell extension was successfully unregistered.');
      end;
    end
    else
      ShowStatusMessage('Usage:',
        'WinDownlyShell.exe /reg - register shell extension;'#$D#$A +
        'WinDownlyShell.exe /unreg - unregister shell extension.'#$D#$A);
  except
    on E: Exception do
      ShowStatusMessage('The action was not registered:', E.ToString, miError);
  end;

end.
