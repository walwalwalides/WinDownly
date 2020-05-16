program WinDownly;

{$include rtcDefs.inc}
{$include rtcDeploy.inc}

uses
  {$IFDEF RtcDeploy}
  {$IFNDEF IDE_2006up}
  FastMM4,
  {$ENDIF }
  {$ENDIF }
  sysutils,
  Forms,
  rtcMessenger in 'Tools\rtcMessenger.pas',
  rtcMessengerProvider in 'Tools\rtcMessengerProvider.pas' {Messenger_Provider: TDataModule},
  unitGame in 'Class\unitGame.pas',
  unitGamePlayer in 'Class\unitGamePlayer.pas',
  uFileUtils in 'Tools\uFileUtils.pas',
  uFileChecker in 'Tools\uFileChecker.pas',
  LogServer in 'LogServer\LogServer.pas' {frmLogServer},
  DNLog.Server in 'DNetLog\DNLog.Server.pas',
  DNLog.Types in 'DNetLog\DNLog.Types.pas',
  MainServer in 'MainServer.pas' {frmMainServer};

{$R *.res}

begin
//      if (ParamCount = 0) then
//    Exit;
//
//  case ParamCount of
//    1:
//      if (ParamStr(1) = 'Notify') then
//      begin
//        //
//      end
//      else
//        Exit;
//  end;

  Application.Initialize;
  Application.Title:=copy(extractfilename(Application.ExeName),0,length(extractfilename(Application.ExeName))-4);
  Application.CreateForm(TfrmMainServer, frmMainServer);
  Application.CreateForm(TfrmLogServer, frmLogServer);
  Application.Run;
end.
