{ ============================================
  Software Name : 	Windownly Service
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight � 2020                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit NotificationServiceUnit;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Android.Service,
  AndroidApi.JNI.GraphicsContentViewText,
  AndroidApi.JNI.Os, System.Notification, AndroidApi.JNI.App;

type
  TNotificationServiceDM = class(TAndroidService)
    NotificationCenter1: TNotificationCenter;
    function AndroidServiceStartCommand(const Sender: TObject;
      const Intent: JIntent; Flags, StartId: Integer): Integer;
  private
    { Private declarations }
    FThread: TThread;

    FAlarmIntent: JPendingIntent;
    FInterval: Int64;
    FDownloadFile: string;
    procedure CreateAlarmIntent(const AAction: string);
    procedure SetAlarm(const AAction: string; AStartAt: Int64 = 0;
      AInterval: Int64 = 0);
    procedure SetDailyAlarm(const AAction: string; const AStartAt: Int64);
    procedure StopAlarm;

    procedure LaunchNotification;
    property DownloadFile:string read FDownloadFile write FDownloadFile;
  public
    { Public declarations }
  end;

var
  NotificationServiceDM: TNotificationServiceDM;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses
  System.DateUtils,
  AndroidApi.Helpers, AndroidApi.JNI.JavaTypes,GlobalVariableFile, GFsearchPicutre,IntentServiceUnit;

const
  cReceiverName = 'com.delphiworlds.kastri.DWMultiBroadcastReceiver';
  cServiceName = 'com.embarcadero.services.ScheduledService';
  cActionServiceAlarm = cReceiverName + '.ACTION_SERVICE_ALARM';

{$R *.dfm}

function SecondsUntilMidnight: Int64;
begin
  Result := SecondsBetween(Now, Trunc(Now + 1));
end;

function GetTimeFromNowInMillis(const ASeconds: Integer): Int64;
var
  LCalendar: JCalendar;
begin
  LCalendar := TJCalendar.JavaClass.getInstance;
  if ASeconds > 0 then
    LCalendar.add(TJCalendar.JavaClass.SECOND, ASeconds);
  Result := LCalendar.getTimeInMillis;
end;

function GetMidnightInMillis: Int64;
begin
  Result := GetTimeFromNowInMillis(SecondsUntilMidnight);
end;

procedure TNotificationServiceDM.CreateAlarmIntent(const AAction: string);
var
  LActionIntent: JIntent;
begin
  LActionIntent := TJIntent.JavaClass.init(StringToJString(AAction));
  LActionIntent.setClassName(TAndroidHelper.Context.getPackageName,
    StringToJString(cReceiverName));
  LActionIntent.putExtra(StringToJString('ServiceName'),
    StringToJString(cServiceName));
  FAlarmIntent := TJPendingIntent.JavaClass.getBroadcast(TAndroidHelper.Context,
    0, LActionIntent, TJPendingIntent.JavaClass.FLAG_CANCEL_CURRENT);
end;

procedure TNotificationServiceDM.SetAlarm(const AAction: string;
  AStartAt: Int64 = 0; AInterval: Int64 = 0);
begin
  if AStartAt = 0 then
    AStartAt := GetTimeFromNowInMillis(0);
  StopAlarm;
  FInterval := AInterval;
  CreateAlarmIntent(AAction);
  if FInterval > 0 then
  begin
    // Allow for alarms while in "doze" mode
    if TOSVersion.Check(6) then
      TAndroidHelper.AlarmManager.setExactAndAllowWhileIdle
        (TJAlarmManager.JavaClass.RTC_WAKEUP, GetTimeFromNowInMillis(AInterval),
        FAlarmIntent)
    else
      TAndroidHelper.AlarmManager.setRepeating
        (TJAlarmManager.JavaClass.RTC_WAKEUP, AStartAt, AInterval,
        FAlarmIntent);
  end
  else
    TAndroidHelper.AlarmManager.&set(TJAlarmManager.JavaClass.RTC_WAKEUP,
      AStartAt, FAlarmIntent);
end;

procedure TNotificationServiceDM.SetDailyAlarm(const AAction: string;
  const AStartAt: Int64);
begin
  SetAlarm(AAction, AStartAt, TJAlarmManager.JavaClass.INTERVAL_DAY);
end;

procedure TNotificationServiceDM.StopAlarm;
begin
  if FAlarmIntent <> nil then
    TAndroidHelper.AlarmManager.cancel(FAlarmIntent);
  FAlarmIntent := nil;
end;

function TNotificationServiceDM.AndroidServiceStartCommand
  (const Sender: TObject; const Intent: JIntent;
  Flags, StartId: Integer): Integer;
 var
 LTIntentService: TIntentServiceHelper;
  LIntentService: TIntentServiceHelper;
begin
   LTIntentService := TIntentServiceHelper.Create(Intent);

//  LData := LTIntentService.Data.Split([Char('|')]);

 FDownloadFile:=LTIntentService.Data;
 // FDownloadFile:=TAndroidHelper.JStringToString(Intent.getStringExtra(TAndroidHelper.StringToJString('com.embarcadero.services.LocationUser')));
  LaunchNotification;
  JavaService.stopSelf;
  Result := TJService.JavaClass.START_STICKY;
end;

procedure TNotificationServiceDM.LaunchNotification;
var
  MyNotification: TNotification;
//  Instance: GlobalVariableFile.TIngredientsConfiguration;
//   insPicSearch: GFsearchPicutre.TPictureConfiguration;
begin
//    insPicSearch := GFsearchPicutre.PicConfiguration;
//  Instance := GlobalVariableFile.IngredientsConfiguration;

  MyNotification := NotificationCenter1.CreateNotification;
  try
    MyNotification.Name := 'ServiceNotification';
    MyNotification.Title :=FDownloadFile;
    MyNotification.AlertBody := 'Successful Download';
    MyNotification.FireDate := IncSecond(Now, 8);
    NotificationCenter1.ScheduleNotification(MyNotification);
  finally
    MyNotification.Free;
  end;
end;

end.
