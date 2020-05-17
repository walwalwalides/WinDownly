{ ============================================
  Software Name : 	Windownly App
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2020                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit FrHome;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls,
  System.Notification, FMX.ScrollBox, FMX.Memo, System.zip, IdBaseComponent,
  IdComponent, IdUDPBase, IdUDPClient,
  IdTrivialFTP, rtcConn, rtcDataCli, rtcHttpCli, rtcFunction, rtcInfo,
  rtcCliModule, DW.PermissionsRequester, DW.PermissionsTypes, System.ImageList,
  FMX.ImgList, FMX.Objects, FMX.Edit, FMX.ListBox, FMX.Layouts,
  FMX.TabControl, System.Rtti, System.Bindings.Outputs, FMX.Bind.Editors,
  Data.Bind.EngExt, FMX.Bind.DBEngExt,
  Data.Bind.Components, Data.Bind.DBScope, FileManager, FMX.TMSBaseControl,
  FMX.TMSBaseGroup, FMX.TMSRadioGroup, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.TMSCustomPicker, FMX.TMSBitmapPicker, FMX.Bind.GenData,
  Data.Bind.ObjectScope;

type
  TModeTransfer = (mtDownload, mtUpload);

  TFHome = class(TFrame)
    btnFileDownload: TButton;
    NotificationCenter1: TNotificationCenter;
    Memo1: TMemo;
    lblLastDownloadedFile: TLabel;
    IdTrivialFTP1: TIdTrivialFTP;
    RtcClientModule1: TRtcClientModule;
    RtcResult1: TRtcResult;
    RtcHttpClient1: TRtcHttpClient;
    AniIndicator: TAniIndicator;
    statbrMain: TStatusBar;
    lblstatusbar: TLabel;
    ImageList1: TImageList;
    StyleWinDownly: TStyleBook;
    TabCtrlMain: TTabControl;
    TabItemAction: TTabItem;
    TabItemSetting: TTabItem;
    ListBox1: TListBox;
    GroupName: TListBoxGroupHeader;
    ListBoxItemIPAdresse: TListBoxItem;
    edtIpAdresse: TEdit;
    ListBoxItemBenutzer: TListBoxItem;
    edtBnutzer: TEdit;
    ListBoxItemPassword: TListBoxItem;
    edtPassword: TEdit;
    ListBoxItemWeitere: TListBoxItem;
    edtPort: TEdit;
    ListBoxItem1: TListBoxItem;
    ListBoxItemEmail: TListBoxItem;
    edtEmail: TEdit;
    ListBoxItem2: TListBoxItem;
    ListBoxItemInternet: TListBoxItem;
    edtInternet: TEdit;
    RadioButton1: TRadioButton;
    rbConnecMethode: TTMSFMXRadioGroup;
    btnSave: TButton;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkControlToField1: TLinkControlToField;
    LinkControlToField2: TLinkControlToField;
    LinkControlToField3: TLinkControlToField;
    LinkControlToField4: TLinkControlToField;
    Rectangle1: TRectangle;
    btnFileUpload: TButton;
    btnFolder: TButton;
    GroupBox1: TGroupBox;
    bmpPickerMain: TTMSFMXBitmapPicker;
    Label1: TLabel;
    Panel1: TPanel;
    Image1: TImage;
    Label2: TLabel;
    ListView1: TListView;
    PrototypeBindSource1: TPrototypeBindSource;
    LinkFillControlToField1: TLinkFillControlToField;
    procedure btnFileDownloadClick(Sender: TObject);
    procedure NotificationCenter1ReceiveLocalNotification(Sender: TObject;
      ANotification: TNotification);
    procedure RtcResult1Return(Sender: TRtcConnection; Data, Result: TRtcValue);
    procedure Button2Click(Sender: TObject);
    procedure btnFileDownloadApplyStyleLookup(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure IdTrivialFTP1Status(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: string);
    procedure IdTrivialFTP1Connected(Sender: TObject);
    procedure btnFileUploadClick(Sender: TObject);
    procedure btnFolderClick(Sender: TObject);
    procedure bmpPickerMainItemSelected(Sender: TObject; AItemIndex: Integer);
  private
    FRanOnce: Boolean;
    FRequester: TPermissionsRequester;
    procedure DownloadFileUDP(Afilename: string);
    function OnCreateDecompressStream(const AInStream: TStream;
      const AZipFile: TZipFile; const AHeader: TZipHeader;
      AIsEncrypted: Boolean): TStream;
    procedure GetFilename;
    procedure PermissionsResultHandler(Sender: TObject;
      const ARequestCode: Integer; const AResults: TPermissionResults);
    procedure StartSecondThread;
    procedure TerminatedSecondThread(Sender: TObject);
    procedure NewParmetreSaved;

    // procedure AppOnIdle(Sender: TObject; var Done: Boolean);

    procedure GetUploadDone(Afilename: string);

    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetSelectedFile(ASelectedItem: TArrayCheck);
    procedure FirstShow;
    procedure ReleaseFrame;
    procedure CheckWifi;
    procedure iniConnection;
    { Public declarations }
  end;

var
  FHome: TFHome;
  ModeTransfer: TModeTransfer;

implementation

{$R *.fmx}

uses
  System.IOUtils,

  GlobalVariableFile, GFsearchPicutre,
  SecondThrd, {$IFDEF ANDROID}
  System.Android.Service, Androidapi.JNI.JavaTypes,
  Androidapi.JNI.GraphicsContentViewText, Androidapi.JNI.Net,
  Androidapi.Helpers, Androidapi.JNI.App, IntentServiceUnit,
  Androidapi.JNIBridge, Androidapi.JNI.Net.Wifi, {$ENDIF}
  dmMain, Global, DNLog.Types, System.StrUtils, System.JSON, System.Threading,
  uDM, uFunc, uSign;

const
  cPermissionReadExternalStorage = 'android.permission.READ_EXTERNAL_STORAGE';
  cPermissionWriteExternalStorage = 'android.permission.WRITE_EXTERNAL_STORAGE';
  cPermissionCamera = 'android.permission.CAMERA';
  cPermissionSendSMS = 'android.permission.SEND_SMS';
  cPermissionReceiveSMS = 'android.permission.RECEIVE_SMS';
  cPermissionReadSMS = 'android.permission.READ_SMS';
  cPermissionReceiveMMS = 'android.permission.RECEIVE_MMS';
  cPermissionReceiveWAPPush = 'android.permission.RECEIVE_WAP_PUSH';
  cPermissionsCodeExternalStorage = 1;
  cPermissionsCodeSMS = 2;

  cPDFSampleFileName = 'pdf-sample.pdf';

var
  sFilename: string;
  Loading: Boolean = False;
  zLThread: TLoadThread = nil;
  itest: Integer = 0;
  BoolInActive: Boolean = False;

procedure TFHome.FirstShow;
var
  Task: ITask;
begin
  Task := TTask.Create(
    procedure
    begin
      // Tasking, agar responsive. hati hati dalam menggunakan Task.
      // LoadHarga;

      lblstatusbar.Text := '';
      TabCtrlMain.TabIndex := 0;
      CheckWifi;
      iniConnection;

      BindSourceDB1.DataSet := dataMain.tblconnection;
      dataMain.mtblconnection.open;

    end);
  Task.Start;
end;

constructor TFHome.Create(AOwner: TComponent);
begin
  inherited;

  FRequester := TPermissionsRequester.Create;
  FRequester.OnPermissionsResult := PermissionsResultHandler;
  Panel1.Visible := False;
  Label2.Visible := False;
{$IFDEF MSWINDOWS}
  // self.Position := TFormPosition.MainFormCenter;
{$ENDIF}
  // Application.OnIdle := AppOnIdle;
  lblLastDownloadedFile.WordWrap := true;
  // if (dataMain = nil) then
  // dataMain := TdataMain.Create(nil);

  try
    if Assigned(dataMain.tblconnection) then
    begin
      dataMain.InitializeDatabase(0);
      dataMain.tblconnection.Close;
      dataMain.tblconnection.open;

      if (dataMain.tblconnection.FieldByName('IPAddress').asString <> '') then
        IdTrivialFTP1.Host := dataMain.tblconnection.FieldByName
          ('IPAddress').asString
      else
        IdTrivialFTP1.Host := SERVER_ADDRESS;

    end;
  finally
    // FreeAndNil(dataMain);
  end;

  //
  // lblstatusbar.Text := '';
  // TabCtrlMain.TabIndex := 0;
  // CheckWifi;
  // iniConnection;
  //
  // BindSourceDB1.DataSet := dataMain.tblconnection;
  // dataMain.mtblconnection.open;


  // FHome.lblstatusbar.text := '';
  // FHome.TabCtrlMain.TabIndex := 0;
  // FHome.CheckWifi;
  // FHome.iniConnection;
  //
  // FHome.BindSourceDB1.DataSet := dataMain.tblconnection;
  // dataMain.mtblconnection.open;

end;

procedure TFHome.iniConnection;
begin
  if not FRanOnce then
  begin
    FRanOnce := true;
    inc(itest);

    // if (dataMain=nil) then
    // dataMain:=TdataMain.Create(FHome);

    dataMain.InitializeDatabase(0);

    dataMain.tblconnection.open;
    rbConnecMethode.itemindex := dataMain.tblconnection.FieldByName
      ('METHODEINDEX').asinteger;
  end;
end;

function TFHome.OnCreateDecompressStream(const AInStream: TStream;
const AZipFile: TZipFile; const AHeader: TZipHeader;
AIsEncrypted: Boolean): TStream;
begin
  try
    if AIsEncrypted then
    begin
      // Perform decrypt operation on AInStream. For example, you can use your own implementation of CryptZip or AES-256.
      // Result := DecryptedStream;
    end
    else
      Result := AInStream;
  except
    on E: Exception do
    begin
      Result := AInStream;
    end;
  end;
end;

procedure TFHome.ReleaseFrame;
begin
{$IF DEFINED(IOS) or DEFINED(ANDROID)}
  DisposeOf;
  // FreeAndNil(dataMain);
{$ELSE}
  Free;
  // FreeAndNil(dataMain);
{$ENDIF}
  FHome := Nil;
end;

procedure TFHome.RtcResult1Return(Sender: TRtcConnection;
Data, Result: TRtcValue);
var
  JSonValue: TJSonValue;
  FileUploaded: String;
  sJsonObject: string;
  str: string;
  iPos: Integer;
  sstatus, sname: string;

begin

  if (ModeTransfer = mtDownload) then
  Begin
    sFilename := Result.asString;
    sFilename := Utf8Decode(sFilename);
    if (sFilename <> EmptyStr) then
      DownloadFileUDP(sFilename)
    else
    begin
      lblstatusbar.Text := '';
      AniIndicator.Enabled := False;
      AniIndicator.Visible := False;
      lblstatusbar.Text:='No File To Download!';
    end;
  End;

  if (ModeTransfer = mtUpload) then
  Begin

    with Result do
    begin

      sJsonObject := Utf8Decode(toJSON);
      try
        JSonValue := TJSonObject.ParseJSONValue(sJsonObject);
        sstatus := JSonValue.GetValue<string>('params[0].status');
        sname := JSonValue.GetValue<string>('params[0].name');
      finally
        FreeAndNil(JSonValue);
      end;

    end;

    if (sstatus = 'Done') then
    begin
      lblLastDownloadedFile.Text := 'Last Uploaded File : ' + sname;
      AniIndicator.Enabled := False;
      AniIndicator.Visible := False;
      // Insert file information to download table
      LogInTable(sname, 0);

      bmpPickerMain.SelectedItemIndex := 0;
      bmpPickerMain.Index := 0;
      bmpPickerMainItemSelected(self, 0);
      bmpPickerMain.SetFocus;

    end;

  End;
end;

destructor TFHome.Destroy;
begin

  FRequester.Free;
  inherited;
end;

procedure TFHome.PermissionsResultHandler(Sender: TObject;
const ARequestCode: Integer; const AResults: TPermissionResults);
begin
  case ARequestCode of
    cPermissionsCodeExternalStorage:
      begin
        // if AResults.AreAllGranted then
        // FMediaLibrary.TakePhoto
        // else
        // ShowMessage('You need to grant all required permissions for the app to be able to take photos!');
      end;
    cPermissionsCodeSMS:
      begin
        if AResults.AreAllGranted then
          ShowMessage('SMS permissions granted')
        else
          ShowMessage
            ('You need to grant all required permissions for the app to be able to handle SMS!');
      end;
  end;
end;

procedure TFHome.StartSecondThread;
begin
  zLThread := TLoadThread.Create('', '', 0, False);
  zLThread.OnTerminate := TerminatedSecondThread;
  zLThread.Start;
  Loading := true;
  AniIndicator.Visible := true;
  AniIndicator.Enabled := true;

end;

procedure TFHome.TerminatedSecondThread(Sender: TObject);
begin
  zLThread := nil;
  Loading := False;
  AniIndicator.Visible := False;
  AniIndicator.Enabled := False;
end;

procedure TFHome.bmpPickerMainItemSelected(Sender: TObject;
AItemIndex: Integer);
var
  listitem: TListViewItem;
  O: Integer;
  tmpBMP:TBitmap;
begin
  tmpBMP:=TBitmap.Create;
  tmpBMP.Assign(bmpPickerMain.SelectedBitmap);
//  Image1.Bitmap.Assign(bmpPickerMain.SelectedBitmap);

  case AItemIndex of
    0:
      begin
        try

          DM.Conn.StartTransaction;
          ListView1.Items.Clear;
          // fnSQLAdd(DM.QTemp1, 'DELETE FROM tbl_username', True);
          // fnExecSQL(DM.QTemp1);

          fnSQLAdd(DM.QTemp1,
            'SELECT filename,transferdate FROM tbl_upload', true);
          DM.QTemp1.open;
          Label1.Text := 'Upload';
          if (DM.QTemp1.RecordCount > 0) then

          begin

            ListView1.BeginUpdate;

            // wichtig: vor schleifendurchlauf, da sonst mit jedem neuen eintrag aufgerufen wird.

            for O := 0 to DM.QTemp1.RecordCount - 1 do
            begin
              listitem := ListView1.Items.Add;
              listitem.Bitmap.Assign(tmpBMP);

              // listitem.Objects.TextObject.Text := 'Task 1' ﻿;
              listitem.Objects.TextObject.Text :=
                DM.QTemp1.FieldByName('filename').asString;
              listitem.Objects.DetailObject.Text :=
                DM.QTemp1.FieldByName('transferdate').asString;

              // listitem.Data[sdStatusSignal] := 'SIGNAL';
              DM.QTemp1.Next;
            end;

            ListView1.EndUpdate;

          end
          else
          begin
            ListView1.Items.Clear;
          end;

          DM.Conn.Commit;

        except
          DM.Conn.Rollback;
        end;

      end;

    1:

      begin

        try

          DM.Conn.StartTransaction;
          ListView1.Items.Clear;
          // fnSQLAdd(DM.QTemp1, 'DELETE FROM tbl_username', True);
          // fnExecSQL(DM.QTemp1);

          fnSQLAdd(DM.QTemp1,
            'SELECT filename,transferdate FROM tbl_download', true);
          DM.QTemp1.open;
          Label1.Text := 'Download';
          if (DM.QTemp1.RecordCount > 0) then

          begin

            ListView1.BeginUpdate;

            // wichtig: vor schleifendurchlauf, da sonst mit jedem neuen eintrag aufgerufen wird.

            for O := 0 to DM.QTemp1.RecordCount - 1 do
            begin
              listitem := ListView1.Items.Add;
              listitem.Bitmap.Assign(tmpBMP);
              // listitem.Objects.TextObject.Text := 'Task 1' ﻿;
              listitem.Objects.TextObject.Text :=
                DM.QTemp1.FieldByName('filename').asString;
              listitem.Objects.DetailObject.Text :=
                DM.QTemp1.FieldByName('transferdate').asString;

              // listitem.Data[sdStatusSignal] := 'SIGNAL';
              DM.QTemp1.Next;
            end;

            ListView1.EndUpdate;

          end
          else
          begin
            ListView1.Items.Clear;
          end;
          DM.Conn.Commit;

        except
          DM.Conn.Rollback;
        end;

      end;

  end;

  FreeAndNil(tmpBMP);
end;

procedure TFHome.Button2Click(Sender: TObject);
begin
  GetFilename;
end;

procedure TFHome.DownloadFileUDP(Afilename: string);
var
{$IFDEF ANDROID}
  LIntentService: TIntentServiceHelper;
  LIntent: JIntent;
{$ENDIF}
  st: TMemoryStream;
  sPAthZip: string;
  sPAthDB: string;
  myZipFile: TZipFile;
  // Instance: GlobalVariableFile.TIngredientsConfiguration;
  // insPicSearch: GFsearchPicutre.TPictureConfiguration;

  sNotifyFile: string;
  sDownloadFile: string;
  sRequest: String;
begin
  sNotifyFile := '';
  sDownloadFile := '';

  // Instance := GlobalVariableFile.IngredientsConfiguration;

{$IF DEFINED(IOS) or DEFINED(ANDROID)}
  sPAthDB := TPath.GetSharedDownloadsPath + PathDelim + 'WinDownly';
{$ELSE}
  sPAthDB := 'WinDownly';
{$ENDIF}
{$IF DEFINED(IOS) or DEFINED(ANDROID)}
  sPAthZip := TPath.GetSharedDownloadsPath + PathDelim + Afilename;
{$ELSE}
  sPAthZip := Afilename;
{$ENDIF}
  // if not DirectoryExists(sPAthZip) then
  // ForceDirectories(sPAthZip);

  st := TMemoryStream.Create;
  try
    // sRequest:=Utf8Encode(Afilename);

    IdTrivialFTP1.Get(Afilename, st);

  except
    // on E: Exception do
    // Begin
    // 'Socket-Fehler # 11001Host nicht gefunden.'#$D#$A
    // if (E.ClassName = 'Zeitüberschreitung') then
    // Begin

    FreeAndNil(st);
    lblstatusbar.Text := 'No Connection !';
    AniIndicator.Visible := False;
    AniIndicator.Enabled := False;
    // End;
    // End;

  end;

  if Assigned(st) then
  begin
    st.SaveToFile(sPAthZip);

    // ShowMessage('Filesize=' + IntToStr(ST.Size));
    FreeAndNil(st);

    // UDPLogAct(2);

    // {$IF DEFINED(IOS) or DEFINED(ANDROID)}
    myZipFile := TZipFile.Create;
    myZipFile.OnCreateDecompressStream := OnCreateDecompressStream;
    try
      myZipFile.open(sPAthZip, zmRead);
      myZipFile.ExtractAll(sPAthDB);
      sDownloadFile := myZipFile.FileName[0];
      sNotifyFile := 'File : ' + sDownloadFile;
      myZipFile.Close;
    finally
      myZipFile.Free;

    end;
    if File_Exists(sPAthZip) then
    begin
      DeleteFile(sPAthZip);

{$IF DEFINED(IOS) or DEFINED(ANDROID)}
      // insPicSearch := GFsearchPicutre.PicConfiguration;
      // insPicSearch.picname:= sPAthDB;
      //
      // Instance.Ingredients := sPAthDB;

      // LIntent := TJIntent.Create;
      // LIntent.setClassName(TAndroidHelper.Context.getPackageName(),
      // TAndroidHelper.StringToJString
      // ('com.embarcadero.services.LocationService'));
      // LIntent.putExtra(TAndroidHelper.StringToJString
      // ('com.embarcadero.services.LocationUser'),
      // TAndroidHelper.StringToJString(sPAthDB));
      // TAndroidHelper.Activity.startService(LIntent);

      TLocalServiceConnection.startService('NotificationService');

      LIntentService := TIntentServiceHelper.Create('NotificationService', 0,
        sNotifyFile);
      TAndroidHelper.Activity.startService(LIntentService.Intent);

{$ELSE}
{$ENDIF}
    end;

    // {$ELSE}
    // try
    // SevenZip1:=TipzSevenZip.create(nil);
    // SevenZip1.Reset;
    // SevenZip1.ArchiveFile := sPAthZip;
    // SevenZip1.Scan;
    // SevenZip1.ExtractToPath := sPAthDB;
    // try
    // SevenZip1.ExtractAll;
    // finally
    //
    // end;
    //
    // except
    // on E: EipzSevenZip do
    // ShowMessage(E.Message);
    // end;
    //
    // FreeAndNil(SevenZip1);
    // {$ENDIF}
    //

    AniIndicator.Visible := False;
    AniIndicator.Enabled := False;
    lblstatusbar.Text := 'Download is finished';
    LogInTable(sDownloadFile, 1);

    bmpPickerMain.SelectedItemIndex := 1;
    bmpPickerMain.Index := 1;
    bmpPickerMainItemSelected(self, 1);
   bmpPickerMain.SetFocus;
    lblLastDownloadedFile.Text := 'Last Downloaded File : ' + sDownloadFile;

  end
  else
  Begin
    AniIndicator.Visible := False;
    AniIndicator.Enabled := False;

    lblstatusbar.Text := 'No Connection !';
  End;

  // zLThread.terminate;

end;

(*

*)
procedure TFHome.CheckWifi;

{$IFDEF ANDROID}
var
  WifiManagerObj: JObject;
  WifiManager: JWifiManager;
  WifiInfo: JWifiInfo;
{$ENDIF}
begin

{$IFDEF ANDROID}
  WifiManagerObj := SharedActivityContext.getSystemService
    (TJContext.JavaClass.WIFI_SERVICE);
  WifiManager := TJWifiManager.Wrap((WifiManagerObj as ILocalObject)
    .GetObjectID);
  WifiInfo := WifiManager.getConnectionInfo();

  if ((WifiManager.isWifiEnabled) and (WifiManager.getWifiState = 3)) then
  begin

    btnFileDownload.Enabled := true;
    btnFileUpload.Enabled := true;
    if (BoolInActive = true) then
    begin
      lblstatusbar.Text := 'Wifi State: ' + 'Active !';
      BoolInActive := False;
    end;

  end
  else
  begin
    btnFileDownload.Enabled := False;
    btnFileUpload.Enabled := False;
    lblstatusbar.Text := 'Wifi State: ' + 'Not Active !';
    BoolInActive := true;
  end;

{$ENDIF}
End;

procedure TFHome.GetFilename;
begin
  with RtcClientModule1 do
  begin
    // (1)
    with Data.newFunction('GetFilename') do
    begin
      // (2)
      // asString['name'] := edUserName.Text;
    end;
    // (3)
    Call(RtcResult1);
  end;
end;

procedure TFHome.GetUploadDone(Afilename: string);
begin
  with RtcClientModule1 do
  begin
    // (1)
    with Data.newFunction('GetUploadDone') do
    begin
      // (2)
      asString['status'] := Utf8Encode('Upload');
      asString['name'] := Utf8Encode(Afilename);
    end;
    // (3)
    Call(RtcResult1);
  end;
end;

procedure TFHome.IdTrivialFTP1Connected(Sender: TObject);
begin

  lblstatusbar.Text := 'Connection Successful';

end;

procedure TFHome.IdTrivialFTP1Status(ASender: TObject; const AStatus: TIdStatus;
const AStatusText: string);
begin
  if (AStatus = ftpTransfer) then
  begin
    lblstatusbar.Text := 'Transfer Started...';
  end;
end;

procedure TFHome.NewParmetreSaved;
Begin

  ShowCustumMessage('INFO', 'ALERT', 'INFO', 'New parameters saved', 'OK', '',
    $FF31B824, $FFDF5447);

end;

procedure TFHome.btnSaveClick(Sender: TObject);
var
  iPos: Integer;
begin
  inherited;
  //
  //
  // FDQueryInsert.ParamByName('TaskName').AsString := TaskName;
  // FDQueryInsert.ExecSQL();
  // FDTableTask.Refresh;
  try
    dataMain.tblconnection.Edit;
    iPos := rbConnecMethode.itemindex;
    dataMain.tblconnection.FieldByName('MethodeIndex').asinteger := iPos;

    //
    case iPos of
      0:
        dataMain.tblconnection.FieldByName('Methode').asString := 'TCP';

      1:
        dataMain.tblconnection.FieldByName('Methode').asString := 'UDP';

    end;

    dataMain.tblconnection.post;
  finally
    dataMain.tblconnection.refresh;
    NewParmetreSaved;
    TabCtrlMain.TabIndex := 0;

  end;

end;

// procedure TFHome.AppOnIdle(Sender: TObject; var Done: Boolean);
// begin
// //
// end;

procedure TFHome.btnFileDownloadApplyStyleLookup(Sender: TObject);

var
  Button: TCustomButton;
  Control: TControl;
  TextObj: TFmxObject;
begin
  Button := (Sender as TCustomButton);
  for Control in Button.Controls do
    if Control is TImage then
    begin
      TextObj := Button.FindStyleResource('text');
      if TextObj is TText then
        case Control.Align of
          TAlignLayout.alLeft:
            TText(TextObj).Padding.Left := Control.Width;
          TAlignLayout.alTop:
            TText(TextObj).Padding.Top := Control.Height;
          TAlignLayout.alRight:
            TText(TextObj).Padding.Right := Control.Width;
          TAlignLayout.alBottom:
            TText(TextObj).Padding.Bottom := Control.Height;
        end;
      Break;
    end;
end;

procedure TFHome.btnFileDownloadClick(Sender: TObject);

begin


  lblstatusbar.Text := '';
  ModeTransfer := mtDownload;
  FRequester.RequestPermissions([cPermissionReadExternalStorage,
    cPermissionWriteExternalStorage, cPermissionCamera],
    cPermissionsCodeExternalStorage);

  dataMain.tblconnection.Close;
  dataMain.tblconnection.open;

  if (dataMain.tblconnection.FieldByName('IPAddress').asString <> '') then
    IdTrivialFTP1.Host := dataMain.tblconnection.FieldByName
      ('IPAddress').asString
  else
    IdTrivialFTP1.Host := SERVER_ADDRESS;

  sFilename := EmptyStr;

  // StartSecondThread;
  AniIndicator.Visible := true;
  AniIndicator.Enabled := true;
  lblstatusbar.Text := 'Please Wait...';
  GetFilename;

end;

procedure TFHome.btnFileUploadClick(Sender: TObject);
begin
  { Upload }

  lblstatusbar.Text := '';
  ModeTransfer := mtUpload;
  FRequester.RequestPermissions([cPermissionReadExternalStorage,
    cPermissionWriteExternalStorage, cPermissionCamera],
    cPermissionsCodeExternalStorage);

  dataMain.tblconnection.Close;
  dataMain.tblconnection.open;

  if (dataMain.tblconnection.FieldByName('IPAddress').asString <> '') then
    IdTrivialFTP1.Host := dataMain.tblconnection.FieldByName
      ('IPAddress').asString
  else
    IdTrivialFTP1.Host := SERVER_ADDRESS;

  if (frmFileManager <> nil) then
    FreeAndNil(frmFileManager);
  if (frmFileManager = nil) then
  begin
    Application.CreateForm(TfrmFilemanager, frmFileManager);
    frmFileManager.Callback := SetSelectedFile;
  end;

  try
    frmFileManager.Show;
  finally

  end;
  // frmFileManager.CD(TPath.GetDownloadsPath);

end;

procedure TFHome.btnFolderClick(Sender: TObject);
// var
// LIntent: JIntent;
begin
  // LIntent := TJIntent.Create;
  // LIntent.setComponent(TJComponentName.JavaClass.init(StringToJString('com.android.settings'), StringToJString('com.android.settings.bluetooth.BluetoothSettings')));
  // TAndroidHelper.Context.startActivity(LIntent);

end;

procedure TFHome.SetSelectedFile(ASelectedItem: TArrayCheck);
var
  i: Integer;
  LItemPath: string;
  sFolder, sFile, sReport: string;
  st: TMemoryStream;
  bReport: Boolean;
begin
  AniIndicator.Visible := False;
  AniIndicator.Enabled := False;
  for i := 0 to Length(ASelectedItem) - 1 do
  begin

    if ASelectedItem[i][0] <> '' then
    begin
      // Ïîëó÷àåì ïóòü èç ìàññèâà
      LItemPath := ASelectedItem[i][2];

      if ASelectedItem[i][1] = 'folder' then
      begin
        AniIndicator.Visible := true;
        AniIndicator.Enabled := true;
        try

          // Upload Folder

          sFolder := LItemPath;
          // st:=TMemoryStream.Create;
          // st.LoadFromFile(sFolder);
          // try
          // IdTrivialFTP1.Put(st,ExtractFileName(sfolder));
          // finally
          // FreeAndNil(st);
          //
          // lblLastDownloadedFile.Text:='Last Uploaded Folder : '+ExtractFileName(sFolder);
          // end;

          ShowMessage('Can''t Upload Folder: ' + ASelectedItem[i][0] + ' !');

        except
          ShowMessage('Can''t Upload Folder: ' + ASelectedItem[i][0] + ' !');
          AniIndicator.Visible := False;
          AniIndicator.Enabled := False;
        end;
      end
      else if ASelectedItem[i][1] = 'file' then
      begin
        AniIndicator.Visible := true;
        AniIndicator.Enabled := true;
        try
          // Upload File
          sFile := LItemPath;

          st := TMemoryStream.Create;
          st.LoadFromFile(sFile);
          sReport := '';
          bReport := False;
          try

            IdTrivialFTP1.Put(st, ExtractFileName(sFile));

          finally
            FreeAndNil(st);
            GetUploadDone(ExtractFileName(sFile));

          end;



          // TFile.copy(LItemPath, path + PathDelim + ASelectedItem[i][0], True);

        except
          FreeAndNil(st);
          ShowMessage('Can''t Upload File: ' + ASelectedItem[i][0] + ' !');
          sReport := ' ( failed! )';
          AniIndicator.Visible := False;
          AniIndicator.Enabled := False;
        end;

        lblLastDownloadedFile.Text := 'Last Uploaded File : ' +
          ExtractFileName(sFile) + sReport;
      end;
    end;
  end;

  AniIndicator.Visible := False;
  AniIndicator.Enabled := False;
  // ShowMessage(ASelectedItem);
end;

procedure TFHome.NotificationCenter1ReceiveLocalNotification(Sender: TObject;
ANotification: TNotification);
begin
  Memo1.Lines.Add('Notification received:');
  Memo1.Lines.Add(ANotification.AlertBody);
end;

end.
