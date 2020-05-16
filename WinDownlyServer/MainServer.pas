{ ============================================
  Software Name : 	Windownly Server
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight � 2020                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit MainServer;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,

  rtcTypes, rtcInfo, rtcConn,
  rtcHttpSrv, rtcDataSrv,

  rtcMessengerProvider, RzTray, System.Actions, Vcl.ActnList, System.ImageList,
  Vcl.ImgList, Vcl.Menus, IPPeerClient, IPPeerServer, System.Tether.Manager,
  System.Tether.AppProfile, REST.Json, Vcl.ComCtrls, IniFiles, ipzcore,
  ipzsevenzip, ipzzip, Vcl.Mask, rtcSrvModule, rtcFunction;

type
  TWMMYMessage = record
    Msg: Cardinal; // ( first is the message ID )
    Handle: HWND; // ( this is the wParam, Handle of sender)
    Info: Longint; // ( this is lParam, pointer to our data)
    Result: Longint;
  end;

type
  TfrmMainServer = class(TForm)
    btnStart: TButton;
    btnStop: TButton;
    Server: TRtcHttpServer;
    pInfo: TPanel;
    Label1: TLabel;
    edtPort: TEdit;
    xIPv6: TCheckBox;
    eUploadFolder: TEdit;
    Label2: TLabel;
    RtcDataProvider1: TRtcDataProvider;
    TrayIconApp: TRzTrayIcon;
    PopupMenu: TPopupMenu;
    AboutBtn: TMenuItem;
    LineItem: TMenuItem;
    ExitBtn: TMenuItem;
    Icons: TImageList;
    actlstNOt: TActionList;
    CloseApplication: TAction;
    AboutApplication: TAction;
    TetheringManager1: TTetheringManager;
    TetheringAppProfile1: TTetheringAppProfile;
    Button1: TButton;
    ActionList1: TActionList;
    actGetScores: TAction;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Bevel1: TBevel;
    Panel1: TPanel;
    Panel2: TPanel;
    Timer1: TTimer;
    TabLog: TTabSheet;
    btnLogging: TButton;
    SevenZip1: TipzSevenZip;
    Zip1: TipzZip;
    Panel3: TPanel;
    lblIPAdresse: TLabel;
    mskedtIP: TMaskEdit;
    lblLocalIp: TLabel;
    fctAdmin: TRtcFunctionGroup;
    fctGetFilename: TRtcFunction;
    RtcServerModule1: TRtcServerModule;
    RtcDataServerLink1: TRtcDataServerLink;
    RtcFunctionGroup1: TRtcFunctionGroup;
    fctGetUploadDone: TRtcFunction;
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure ServerListenStart(Sender: TRtcConnection);
    procedure ServerListenStop(Sender: TRtcConnection);
    procedure ServerRequestNotAccepted(Sender: TRtcConnection);
    procedure RtcDataProvider1CheckRequest(Sender: TRtcConnection);
    procedure RtcDataProvider1DataReceived(Sender: TRtcConnection);
    procedure CloseApplicationExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TetheringAppProfile1ResourceReceived(const Sender: TObject;
      const AResource: TRemoteResource);
    procedure Button1Click(Sender: TObject);
    procedure actGetScoresExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnLoggingClick(Sender: TObject);
    procedure fctGetFilenameExecute(Sender: TRtcConnection;
      Param: TRtcFunctionInfo; Result: TRtcValue);
    procedure fctGetUploadDoneExecute(Sender: TRtcConnection;
      Param: TRtcFunctionInfo; Result: TRtcValue);
  private
    procedure UpdateDB;
    procedure Tray(ActInd: Integer);
    function ReadLastSendFile(const LFileName: string): Boolean;
    procedure SaveLastSendFile(const LFileName: string);
    procedure mskedtIPExit(Sender: TObject);
    function ReadConnecParametere: Boolean;
    procedure SaveConnecParametere;
    function GetIP: String;
    function GetLastUploadFile: string;

    { Private declarations }
  public
    { Public declarations }
    procedure DefaultHandler(var Message); override;
    procedure WMMYMessage(var Msg: TWMMYMessage);
    procedure StartServer;
    procedure StopServer;
  end;

const
  csDir = 'WinDownly\';
  csDB = 'PackageDB.sqb';

var
  frmMainServer: TfrmMainServer;
  boolClose: Boolean = false;
  IconIndex: byte;
  IconFull: TIcon;

implementation

uses
  unitGame, unitGamePlayer, Winapi.ShellAPI, uFileUtils, uFileChecker,
  LogServer, IdStack, System.IOUtils;

{$R *.dfm}

var
  WM_OURMESSAGE: DWORD;
  INIPath: string;

procedure TfrmMainServer.DefaultHandler(var Message);
var
  ee: TWMMYMessage;
begin
  with TMessage(Message) do
  begin
    if (Msg = WM_OURMESSAGE) then
    begin
      ee.Msg := Msg;
      ee.Handle := wParam;
      ee.Info := lParam;
      // Checking if this message is not from us
      if ee.Handle <> Handle then
        WMMYMessage(ee);
    end
    else
      inherited DefaultHandler(Message);
  end;
end;

function Getfiledirectory(Path: string): string;
var
  SR: TSearchRec;
begin
  if FindFirst(Path + '*.*', faArchive, SR) = 0 then
  begin
    repeat
      Result := Utf8Encode(SR.Name);
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;

end;

procedure TfrmMainServer.fctGetFilenameExecute(Sender: TRtcConnection;
  Param: TRtcFunctionInfo; Result: TRtcValue);
var
  SFile: String;
begin
  // SFile := TPath.GetDocumentsPath+PathDelim+ csDir;

  // SFile := ExtractFilePath(Application.ExeName) + csDir + csDB;

  if (GetLastUploadFile <> '') then
    Result.asString := GetLastUploadFile;


  // Result.asString := Getfiledirectory(SFile);

end;

procedure TfrmMainServer.fctGetUploadDoneExecute(Sender: TRtcConnection;
  Param: TRtcFunctionInfo; Result: TRtcValue);
var
  checkFile: String;
  sNamefile: String;
  sStatus: string;
begin

  //
  with Result do

  begin

    with Param do
    begin
      sNamefile := Utf8Decode(asString['name']);
      sStatus := Utf8Decode(asString['status']);
      checkFile := TPath.GetDocumentsPath + PathDelim + csDir + sNamefile;
    end;

  end;
  if (sStatus = 'Upload') then

    if FileExists(checkFile) then
    begin


        with Result.newFunction('GetUploadDone') do
        begin
          // (2)
          asString['status'] := Utf8Encode('Done');
          asString['name'] := Utf8Encode(sNamefile);
        end;


    end
    else
    begin
      with Result do
      begin
        Param['name'].asString := Utf8Encode(sNamefile);
        Param['status'].asString := Utf8Encode('notDone');

      end;

    end;

end;

procedure TfrmMainServer.SaveLastSendFile(const LFileName: string);
var
  INI: TIniFile;
  LWorkingFileCount: Integer;
  LWorkingFileIndex: Integer;
  LFileInformation: TFileInformation;
begin
  if FileIsInteresting(LFileName, LFileInformation) then
  begin

    INI := TIniFile.Create
      (INIPath + ChangeFileExt(ExtractFileName(Application.ExeName), '.ini'));
    try

      INI.WriteInteger('LastFile', 'Size', LFileInformation.FileSize);
      INI.writeBool('LastFile', 'Send', True);
      INI.WriteString('LastFile', 'Filetype', LFileInformation.FileType);

      INI.WriteString('LastFile', 'Filename', ExtractFileName(LFileName));

    finally
      INI.Free;
    end;
  end;
end;

function TfrmMainServer.ReadConnecParametere: Boolean;
var
  INI: TIniFile;
  LIPAdresse: string;
  LPort: string;

begin
  Result := false;
  INI := TIniFile.Create(INIPath + ChangeFileExt
    (ExtractFileName(Application.ExeName), '.ini'));
  try
    LIPAdresse := INI.ReadString('Connection', 'IP-Adresse', GetIP);
    LPort := INI.ReadString('Connection', 'Port', '8085');

    mskedtIP.Text := LIPAdresse;
    edtPort.Text := LPort;

    Server.ServerAddr := trim(LIPAdresse);
    Server.ServerPort := LPort;

    Result := True;

    // INI.ReadBool('LastFile', 'Send', false);
    // INI.ReadString('LastFile', 'Filetype', LFileInformation.FileType);
    // INI.readString('LastFile', 'Filename', ExtractFileName(LFileName));

  finally
    INI.Free;
  end;
end;

procedure TfrmMainServer.SaveConnecParametere;
var
  INI: TIniFile;
  LIPAdresse: string;
  LPort: string;
begin
  INI := TIniFile.Create(INIPath + ChangeFileExt
    (ExtractFileName(Application.ExeName), '.ini'));
  try
    LIPAdresse := mskedtIP.Text;
    LPort := edtPort.Text;
    INI.WriteString('Connection', 'IP-Adresse', LIPAdresse);
    INI.WriteString('Connection', 'Port', LPort);
  finally
    INI.Free;
  end;
end;

function TfrmMainServer.GetLastUploadFile: string;
var
  INI: TIniFile;
  SFile: String;

  //
  LWorkingFileIndex: Integer;
  LFileInformation: TFileInformation;
  sFilename: string;
begin

  Result := '';

  INI := TIniFile.Create(INIPath + ChangeFileExt
    (ExtractFileName(Application.ExeName), '.ini'));
  try

    sFilename := INI.ReadString('LastFile', 'Filename', '');

  finally
    INI.Free;
  end;

  if (sFilename <> '') then
  begin
    SFile := TPath.GetDocumentsPath + PathDelim + csDir + sFilename;

    if FileExists(SFile) then
      Result := Utf8Encode(sFilename)
    else
      Result := '';

  end
  else
  begin
    Result := '';
  end;

end;

function TfrmMainServer.ReadLastSendFile(const LFileName: string): Boolean;
var
  INI: TIniFile;
  LWorkingFileCount: Integer;
  LWorkingFileIndex: Integer;
  LFileInformation: TFileInformation;
  iSize: Integer;
begin
  Result := false;
  if FileIsInteresting(LFileName, LFileInformation) then
  begin

    INI := TIniFile.Create
      (INIPath + ChangeFileExt(ExtractFileName(Application.ExeName), '.ini'));
    try

      iSize := INI.ReadInteger('LastFile', 'Size', 0);

      // INI.ReadBool('LastFile', 'Send', false);
      // INI.ReadString('LastFile', 'Filetype', LFileInformation.FileType);
      // INI.readString('LastFile', 'Filename', ExtractFileName(LFileName));

    finally
      INI.Free;
    end;

    if (iSize = 0) then
    begin
      SaveLastSendFile(LFileName);
      Result := True;
      exit;
    end;

    if (iSize <> LFileInformation.FileSize) then
    begin

      Result := True;
      SaveLastSendFile(LFileName);
    end
    else
    begin
      Result := false;
    end;

  end;

end;

function GetFullFileName(fname: string): string;
var
  DocRoot: string;
begin
  // Get the executable file's folder name ...
  DocRoot := ExtractFilePath(AppFileName);
  // Make sure the file doesn't end with '\' ...
  if Copy(DocRoot, length(DocRoot), 1) = '\' then
    Delete(DocRoot, length(DocRoot), 1);
  // We want to use a sub-folder named '\data' ...
  DocRoot := DocRoot + '\data';
  // Requests use "/" instead of "\" ...
  fname := StringReplace(fname, '/', '\', [rfreplaceall]);
  // Create file name containing full path
  Result := ExpandFileName(DocRoot + fname);
  // Check if the file is inside our folder
  // (don't want people to use "..\" to
  // move out of this folder)
  if UpperCase(Copy(Result, 1, length(DocRoot))) <> UpperCase(DocRoot) then
    Result := ''; // return empty file name.
end;

procedure TfrmMainServer.actGetScoresExecute(Sender: TObject);
var
  SFile: String;
begin
  SFile := ExtractFilePath(Application.ExeName) + csDir + csDB;

  if (ReadLastSendFile(SFile) = True) then
    UpdateDB;

end;

procedure TfrmMainServer.btnStartClick(Sender: TObject);
begin
  GetMessengerProvider.ServerLink.Server := Server;
  Server.ServerIPV := GetRtcIPV(xIPv6.Checked);
  Server.ServerPort := RtcString(trim(edtPort.Text));
  Server.Listen;
end;

procedure TfrmMainServer.StopServer;
begin

  btnStopClick(nil);
end;

procedure TfrmMainServer.StartServer;
begin

  btnStartClick(nil);
end;

procedure TfrmMainServer.btnStopClick(Sender: TObject);
begin
  Server.StopListen;
end;

procedure TfrmMainServer.Button1Click(Sender: TObject);
var
  SFile: String;
begin
  SFile := ExtractFilePath(Application.ExeName) + csDir + csDB;
  if File_Exists(SFile) then
    UpdateDB;
end;

procedure TfrmMainServer.btnLoggingClick(Sender: TObject);
begin
  frmLogServer.WindowState := wsMaximized;
  frmLogServer.Position := poMainFormCenter;
  frmLogServer.Caption := 'Logging(Server)';
  frmLogServer.Show;
end;

procedure TfrmMainServer.UpdateDB;
var
  MS: TMemoryStream;
  SFile: String;
begin
  SFile := ExtractFilePath(Application.ExeName) + csDir + csDB;
  MS := TMemoryStream.Create;
  MS.LoadFromFile(SFile);
  // Layout1.MakeScreenShot.SaveToStream(MS);
  MS.Seek(0, 0);
  if TetheringManager1.RemoteProfiles.Count > 0 then
    TetheringAppProfile1.SendStream(TetheringManager1.RemoteProfiles[0],
      'TGamePlayer', MS);
  MS.Free;
end;

procedure TfrmMainServer.WMMYMessage(var Msg: TWMMYMessage);
begin

  IconIndex := 0;
  Tray(2);

  Msg.Result := 32;
  Application.Terminate;
end;

procedure TfrmMainServer.CloseApplicationExecute(Sender: TObject);
begin
  btnStopClick(nil);
  Application.Terminate;
end;

procedure TfrmMainServer.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := boolClose;
  if not(boolClose) then
    Application.Minimize;
end;

procedure TfrmMainServer.mskedtIPExit(Sender: TObject);
var
  net1, net2, host1, host2, netmask1, netmask2, hostmask1, hostmask2, sub_net1,
    sub_net2, sub_host1, sub_host2: Integer;

  IP, Mask: String;

begin
  // Extract the net and host address from the IP.
  IP := mskedtIP.Text;
  net1 := StrToInt(TrimRight(Copy(IP, 0, 3)));
  net2 := StrToInt(TrimRight(Copy(IP, 5, 3)));
  host1 := StrToInt(TrimRight(Copy(IP, 9, 3)));
  host2 := StrToInt(TrimRight(Copy(IP, 13, 3)));

  // A range test that you cannot validate through edit masks.
  if ((net1 < 0) Or (net1 > 255) Or (net2 < 0) Or (net2 > 255) Or (host1 < 0) Or
    (host1 > 255) Or (host2 < 0) Or (host2 > 255)) then
    raise EArgumentException.Create('Not a valid IP address.');

  // Extract the net and host mask from the subnet mask.

end;

function TfrmMainServer.GetIP: String;
begin
  TIdStack.IncUsage;
  try
    Result := GStack.LocalAddress;
  finally
    TIdStack.DecUsage;
  end;
end;

procedure TfrmMainServer.FormCreate(Sender: TObject);
var
  tmpPath: string;
begin
  // Define EditMask as IpAdresse

  mskedtIP.Text := '';
  lblLocalIp.Caption := '';
  lblLocalIp.Font.Size := 8;
  lblLocalIp.Font.Style := [fsBold];

  // mskedtIP.Font.Name := 'Courier';

  mskedtIP.EditMask := '!099.099.099.099;1; ';

  mskedtIP.OnExit := mskedtIPExit;
  ReadConnecParametere;
  // TrayIconApp.HideOnStartup := True;

  PageControl1.ActivePageIndex := 0;
  self.Caption := Application.Title;
  tmpPath := ExtractFilePath(Application.ExeName) + csDir;
  if not DirectoryExists(tmpPath) then
    ForceDirectories(tmpPath);
  INIPath := ExtractFilePath(Application.ExeName);

  lblLocalIp.Caption := 'Local IP Adresse : ' + GetIP;

end;

procedure TfrmMainServer.FormDestroy(Sender: TObject);
begin
  SaveConnecParametere;
  IconIndex := 0;
  Tray(2);
end;

procedure TfrmMainServer.RtcDataProvider1CheckRequest(Sender: TRtcConnection);
var
  fname: string;
  stest: string;
begin

  with TRtcDataServer(Sender) do
  begin
    stest := Request.FileName;
    if (Request.Method = 'PUT') and (UpperCase(Request.FileName) = '/DATABASE')
      and (Request.Query['file'] <> '') then
    begin
      fname := GetFullFileName(Request.FileName);
      Request.Info.asText['file'] := eUploadFolder.Text + '\' +
        Utf8Decode(URL_Decode(Request.Query['file']));
      Accept;

    end;
  end;

end;

procedure TfrmMainServer.RtcDataProvider1DataReceived(Sender: TRtcConnection);
var
  s: RtcString;
var
  SFile: String;
begin
  SFile := ExtractFilePath(Application.ExeName) + csDir + csDB;
  with TRtcDataServer(Sender) do
  begin
    if Request.Started then
    begin
      if not DirectoryExists(eUploadFolder.Text) then
        CreateDir(eUploadFolder.Text);
      Delete_File(Request.Info.asText['file']);
    end;
    s := Read;
    Write_File(Request.Info.asText['file'], s, Request.ContentIn - length(s));

    if Request.Complete then
    begin
      { We have the complete request content here (the complete file).
        We can could process the file (now stored locally) and send a response
        to the Client letting the client know how our processing went. }
      Response.Status(200, 'OK'); // Set response status to a standard "OK"
      Write('Thanks for the file.');
      // Send a short message to let the client know how we did.
      Write('Current time is: ' + TimeToStr(Now));

      try
        Zip1.Reset;
        Zip1.ArchiveFile := SFile + '.zip';
        //
        Zip1.IncludeFiles(SFile);
        //
        /// /        if not(txtPassword.Text = '') then
        /// /        begin
        /// /          Zip1.Password := txtPassword.Text;
        /// /
        /// /        end;
        //
        Zip1.Compress;
        //
        /// /        ShowMessage('SevenZip complete.');
        //
      except
        /// /        on E: EipzZip do
        /// /          ShowMessage(E.Message);
      end;
      // Delete the Orginal File
      if File_Exists(SFile) then
        Delete_File(SFile)

    end;
  end;

end;

procedure TfrmMainServer.Tray(ActInd: Integer);
var
  nim: TNotifyIconData;
begin

  with nim do
  begin
    cbSize := System.SizeOf(nim);
    Wnd := self.Handle;
    uId := 1;
    uFlags := NIF_MESSAGE or NIF_ICON or NIF_TIP;

    if IconIndex = 0 then
      hIcon := SendMessage(Application.Handle, WM_GETICON, ICON_SMALL2, 0)
    else
      hIcon := IconFull.Handle;

    uCallBackMessage := WM_USER + 1;
    StrCopy(szTip, PChar(Application.Title));
  end;
  case ActInd of
    1:
      Shell_NotifyIcon(NIM_ADD, @nim);
    2:
      Shell_NotifyIcon(NIM_DELETE, @nim);
    3:
      Shell_NotifyIcon(NIM_MODIFY, @nim);
  end;
end;

procedure TfrmMainServer.ServerListenStart(Sender: TRtcConnection);
begin
  btnStart.Enabled := false;
  btnStop.Enabled := True;
  pInfo.Caption := 'Server Ready.';
end;

procedure TfrmMainServer.ServerListenStop(Sender: TRtcConnection);
begin
  btnStart.Enabled := True;
  btnStop.Enabled := false;
  pInfo.Caption := 'Server not Listening.';
end;

procedure TfrmMainServer.ServerRequestNotAccepted(Sender: TRtcConnection);
begin
  with TRtcDataServer(Sender) do
    if Request.Complete then
    begin
      Response.Status(301, 'Invalid request');
      Write;
    end;
end;

procedure TfrmMainServer.TetheringAppProfile1ResourceReceived
  (const Sender: TObject; const AResource: TRemoteResource);
var
  Player: TGamePlayer;
  Stream: Tstream;
  MS: TMemoryStream;
  SFile: String;
begin
  SFile := ExtractFilePath(Application.ExeName) + csDir + csDB;
  if AResource.ResType = TRemoteResourceType.Data then
  begin
    // Take the string value, convert to the object and add to the dataset.
    Player := TJson.JsonToObject<TGamePlayer>(AResource.Value.asString);

    // if tableScores.Locate('Name', Player.Name, [loCaseInsensitive]) then
    // tableScores.Edit
    // else
    // begin
    // tableScores.Insert;
    // tableScoresName.AsString := Player.Name;
    // end;
    // tableScoresScore.AsInteger := Player.Score;
    // tableScores.Post;
  end;

  if AResource.ResType = TRemoteResourceType.Stream then
  begin
    // Take the string value, convert to the object and add to the dataset.
    Stream := AResource.Value.AsStream;
    MS := TMemoryStream.Create;
    try
      MS.LoadFromStream(Stream);
      MS.SaveToFile(SFile);
    finally
      FreeAndNil(MS);
    end;

  end;

end;

procedure TfrmMainServer.Timer1Timer(Sender: TObject);
begin
  btnStartClick(nil);
  Timer1.Enabled := false;
end;

var
  mutex: THandle = 0;

procedure Do_Initialization;
begin
  mutex := CreateMutex(nil, True, PChar(Application.Title));
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    Application.MessageBox('The application can only be started once.',
      'Warnung', MB_OK or MB_ICONWARNING);
    halt;
  end;
end;

procedure Do_Finalization;
begin
  if mutex <> 0 then
    CloseHandle(mutex);
end;

initialization

WM_OURMESSAGE := RegisterWindowMessage('MMP');
Do_Initialization;

finalization

Do_Finalization;

end.
