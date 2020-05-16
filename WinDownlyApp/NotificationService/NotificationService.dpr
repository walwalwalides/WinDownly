program NotificationService;

uses
  System.Android.ServiceApplication,
  NotificationServiceUnit in 'NotificationServiceUnit.pas' {NotificationServiceDM: TAndroidService},
  GlobalVariableFile in '..\NotificationApp\Unit\GlobalVariableFile.pas',
  GFsearchPicutre in '..\NotificationApp\Unit\GFsearchPicutre.pas',
  IntentServiceUnit in '..\NotificationApp\Unit\IntentServiceUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TNotificationServiceDM, NotificationServiceDM);
  Application.Run;
end.
