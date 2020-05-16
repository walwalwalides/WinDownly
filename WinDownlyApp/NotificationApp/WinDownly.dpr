program WinDownly;

uses
  System.StartUpCopy,
  FMX.Forms,
  FrMain in 'FrMain.pas' {FMain},
  {$IFDEF ANDROID}
  FMX.FontGlyphs.Android in 'Source\FMX.FontGlyphs.Android.pas',
  NotificationServiceUnit in '..\NotificationService\NotificationServiceUnit.pas' {NotificationServiceDM: TAndroidService},
  IntentServiceUnit in 'Unit\IntentServiceUnit.pas',
   Androidapi.JNI.Net.Wifi in 'Unit\Androidapi.JNI.Net.Wifi.pas',
  {$ENDIF }
  uFontSetting in 'Source\uFontSetting.pas',
  uFunc in 'Source\uFunc.pas',
  uHelper in 'Source\uHelper.pas',
  uOpenUrl in 'Source\uOpenUrl.pas',
  uRest in 'Source\uRest.pas',
  uStartUp in 'Source\uStartUp.pas',
  uDM in 'uDM.pas' {DM: TDataModule},
  uMain in 'Source\uMain.pas',
  FrLoading in 'Frame\FrLoading.pas' {FLoading: TFrame},
  uGoFrame in 'Source\uGoFrame.pas',
  FrLogin in 'Frame\FrLogin.pas' {FLogin: TFrame},
  uSign in 'Source\uSign.pas',
  Fr2 in 'Frame\Fr2.pas' {F2: TFrame},
  Fr3 in 'Frame\Fr3.pas' {F3: TFrame},
  Fr4 in 'Frame\Fr4.pas' {F4: TFrame},
  FrHome in 'Frame\FrHome.pas' {FHome},
  GlobalVariableFile in 'Unit\GlobalVariableFile.pas',
  GFsearchPicutre in 'Unit\GFsearchPicutre.pas',
  SecondThrd in 'Unit\SecondThrd.pas',
  dmMain in 'Module\dmMain.pas' {dataMain: TDataModule},
  DNLog.Client in 'UDP\DNLog.Client.pas',
  DNLog.Types in 'UDP\DNLog.Types.pas',
  unitGame in 'Module\Prog\unitGame.pas',
  unitGamePlayer in 'Module\Prog\unitGamePlayer.pas',
  Global in 'Unit\Global.pas',
  Form.CustumMessage in 'View\Form.CustumMessage.pas' {frmCustumMessage},
  FileManager in 'FileManager.pas' {frmFileManager};



{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.CreateForm(TDataMain, DataMain);
  Application.CreateForm(TDM, DM);
  Application.Run;

end.
