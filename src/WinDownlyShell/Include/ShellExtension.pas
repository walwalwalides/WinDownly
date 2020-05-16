{ ============================================
  Software Name : 	WinDownlyShell
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2020                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }

unit ShellExtension;

interface

/// <summary> Adds shell context menu with actipons list. </summary>
procedure RegShellMenu(ShellExe: string);
/// <summary> Removes shell context menu items. </summary>
procedure UnregShellMenu;

implementation

uses System.SysUtils, Winapi.Windows, Registry2, IFEO;

const
  K0 = 'Software\Classes\*\shell\WinDownly'; // HKCU
  K1 = K0 + '\shell\%0.2d';

// Extracts only file from ActionsExe
function GetIcon(S: string): string;
begin
  Result := Copy(S, 1, LastDelimiter('"', S)) + ',0';
end;

procedure RegShellMenu(ShellExe: string);
const
  ActionCaptionsGUI: array [TAction] of string = ('',
    '&Download', '&Upload', '',
    '', '', '', '',
    '', '', '', '', '', ''
    );
var
  a: TAction;
begin
  with TRegistry.Create do
    try
      begin
        RootKey := HKEY_CURRENT_USER;
        if not OpenKey(K0, True) then
          raise Exception.Create('Unable to create registry key.');
        WriteString('Icon', '"' + ShellExe + '",0');
        WriteString('MUIVerb', 'WinDownly');
        WriteString('ExtendedSubCommandsKey', '*\shell\WinDownly');
        WriteString('HasLUAShield', '');
        CloseKey;
        OpenKey(Format(K1, [0]), True);
        WriteString('MUIVerb', '&None');
        OpenKey('command', True);
        WriteString('', '"' + ShellExe + '" reset "%1"');
        CloseKey;
        for a in [aDownload,aUpload] do
        begin
          OpenKey(Format(K1, [Integer(a) + 1]), True);
          if a = aDenyAccess then
            WriteString('Icon', GetIcon(EMDebuggers[aDenyAndNotify]))
          else
            WriteString('Icon', GetIcon(EMDebuggers[a]));
          WriteString('MUIVerb', ActionCaptionsGUI[a]);
          OpenKey('command', True);
          WriteString('', '"' + ShellExe + '" set "%1" ' + ActionShortNames[a]);
          CloseKey;
        end;
      end;
    finally
      Free;
    end;
end;

procedure UnregShellMenu;
begin
  with TRegistry.Create do
    try
    begin
      RootKey := HKEY_CURRENT_USER;
      if KeyExists(K0) then
        if not DeleteKey(K0) then
          raise Exception.Create('Unable to delete registry key.');
    end;
    finally
      Free;
    end;
end;

end.
