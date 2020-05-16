unit UploadPackage;

interface

uses
  Windows, Messages, SysUtils,
  Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, ExtCtrls,
  ImgList, Menus,

  rtcTypes, rtcConn, rtcDataCli, rtcHttpCli,
  rtcInfo, rtcCliModule, rtcFunction,

  tools,

  Client_ChatForm, System.ImageList;

const
  MSG_STATUS_UNKNOWN = 0;
  MSG_STATUS_OFFLINE = 1;
  MSG_STATUS_ONLINE = 2;
  MSG_STATUS_IGNORE = 3;

type
  TfrmUploadPackage = class(TFrame)
    ClientModule: TRtcClientModule;
    Client: TRtcHttpClient;
    MessengerTab: TPageControl;
    tabLogin: TTabSheet;
    tabFriends: TTabSheet;
    tabIgnore: TTabSheet;
    Panel1: TPanel;
    Panel2: TPanel;
    btnLogout: TBitBtn;
    panLogin: TPanel;
    Panel4: TPanel;
    Label4: TLabel;
    eLoginUser: TEdit;
    Label5: TLabel;
    eLoginPass: TEdit;
    btnLogin: TBitBtn;
    btnRegister: TBitBtn;
    btnAddFriend: TBitBtn;
    Panel5: TPanel;
    Panel6: TPanel;
    btnLogout2: TBitBtn;
    btnAddIgnore: TBitBtn;
    tvFriends: TTreeView;
    tvIgnore: TTreeView;
    resLogin: TRtcResult;
    lblLogin: TLabel;
    resUpdate: TRtcResult;
    resTimer: TRtcResult;
    resSendText: TRtcResult;
    pmFriends: TPopupMenu;
    SendMessage1: TMenuItem;
    N1: TMenuItem;
    btnDelFriend: TMenuItem;
    AddNewFriend1: TMenuItem;
    pmIgnore: TPopupMenu;
    AddnewIgnore1: TMenuItem;
    N2: TMenuItem;
    btnDelIgnore: TMenuItem;
    resLogout: TRtcResult;
    TimerClient: TRtcHttpClient;
    TimerModule: TRtcClientModule;
    resTimerLogin: TRtcResult;
    msgImages: TImageList;
    pingTimer: TTimer;
    resPing: TRtcResult;
    btnPutFile: TButton;
    btnOpen: TButton;
    eLocalFileName: TEdit;
    Label6: TLabel;
    eRequestFileName: TEdit;
    Label7: TLabel;
    RtcDataRequest1: TRtcDataRequest;
    Label8: TLabel;
    eUploadFolder: TEdit;
    pInfo: TPanel;
    U1: TMenuItem;
    TabSetting: TTabSheet;
    eServerAddr: TEdit;
    Label1: TLabel;
    xUseProxy: TCheckBox;
    xUseIPv6: TCheckBox;
    xUseXMLRPC: TCheckBox;
    eModulePath: TEdit;
    eServerPort: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    OpenDialog1: TOpenDialog;
    procedure btnLogoutClick(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    procedure resLoginReturn(Sender: TRtcConnection; Data, Result: TRtcValue);
    procedure ClientModuleResponseAbort(Sender: TRtcConnection);
    procedure FormCreate(Sender: TObject);
    procedure btnRegisterClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure resUpdateReturn(Sender: TRtcConnection; Data, Result: TRtcValue);
    procedure btnAddFriendClick(Sender: TObject);
    procedure btnAddIgnoreClick(Sender: TObject);
    procedure btnSendMessageClick(Sender: TObject);
    procedure msgTimerTimer(Sender: TObject);
    procedure resTimerReturn(Sender: TRtcConnection; Data, Result: TRtcValue);
    procedure resSendTextReturn(Sender: TRtcConnection;
      Data, Result: TRtcValue);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnDelFriendClick(Sender: TObject);
    procedure btnDelIgnoreClick(Sender: TObject);
    procedure resLogoutReturn(Sender: TRtcConnection; Data, Result: TRtcValue);
    procedure resTimerLoginReturn(Sender: TRtcConnection;
      Data, Result: TRtcValue);
    procedure pingTimerTimer(Sender: TObject);
    procedure resPingReturn(Sender: TRtcConnection; Data, Result: TRtcValue);
    procedure btnPutFileClick(Sender: TObject);
    procedure RtcDataRequest1DataSent(Sender: TRtcConnection);
    procedure RtcDataRequest1DataReceived(Sender: TRtcConnection);
    procedure RtcDataRequest1DataOut(Sender: TRtcConnection);
    procedure RtcDataRequest1BeginRequest(Sender: TRtcConnection);
    procedure U1Click(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    do_notify: Boolean;

    oldUserName, myUserName: string;
    myCheckTime: TDateTime;

    procedure StartLogin;

    procedure FriendList_Clear;
    procedure IgnoreList_Clear;

    procedure FriendList_Add(uname: string);
    procedure FriendList_Del(uname: string);
    procedure IgnoreList_Add(uname: string);
    procedure IgnoreList_Del(uname: string);

    function FriendList_Selected: string;
    function IgnoreList_Selected: string;

    procedure SendText(to_user, msg: string);

    function isFriend(uname: string): Boolean;
    function isIgnore(uname: string): Boolean;

    procedure FriendList_Status(uname: string; status: integer);

    procedure make_notify(uname, ntype: string);
  end;

var
  frmUploadPackage: TfrmUploadPackage;
  const
  cDirDB='DataBase\';
  cNameDB='PackageDB.sqb';

implementation

uses
  System.IOUtils;

{$R *.dfm}

procedure TfrmUploadPackage.FormCreate(Sender: TObject);
begin
  // Width:=206;

  Self.Caption:='Upload Packages';
  do_notify := False;

  myUserName := '';
  oldUserName := '';

  // Assign the method for sending a Text message (used by Chat_Form)
  SendMsg := SendText;

  MessengerTab.ActivePage := tabLogin;
  tabLogin.TabVisible := True;
  tabFriends.TabVisible := False;
  tabIgnore.TabVisible := False;
  panLogin.Enabled := True;
  btnPutFile.Enabled := False;
  eLocalFileName.Text:=ExtractFilePath(Application.ExeName)+cDirDB+cNameDB;
end;

procedure TfrmUploadPackage.FormShow(Sender: TObject);
begin
  if tabLogin.TabVisible and tabLogin.Visible then
    eLoginUser.SetFocus;
end;

procedure TfrmUploadPackage.StartLogin;
begin
  Client.Disconnect;
  Client.ServerAddr := RtcString(eServerAddr.Text);
  Client.ServerPort := RtcString(eServerPort.Text);
  Client.ServerIPV := GetRtcIPV(xUseIPv6.Checked);
  Client.UseProxy := xUseProxy.Checked;
  Client.SkipRequests;
  Client.Session.Close;
  with ClientModule do
  begin
    if xUseXMLRPC.Checked then
      DataFormat := fmt_XMLRPC
    else
      DataFormat := fmt_RTC;
    ModuleFileName := RtcString(eModulePath.Text);
    if copy(ModuleFileName, length(ModuleFileName), 1) <> '/' then
      ModuleFileName := ModuleFileName + '/';
    ModuleFileName := ModuleFileName + '$MSG';

    ModuleHost := RtcString(eServerAddr.Text);
  end;

  TimerClient.ServerAddr := RtcString(eServerAddr.Text);
  TimerClient.ServerPort := RtcString(eServerPort.Text);
  TimerClient.ServerIPV := GetRtcIPV(xUseIPv6.Checked);
  TimerClient.UseProxy := xUseProxy.Checked;
  TimerClient.SkipRequests;
  TimerClient.Session.Close;
  with TimerModule do
  begin
    if xUseXMLRPC.Checked then
      DataFormat := fmt_XMLRPC
    else
      DataFormat := fmt_RTC;
    ModuleFileName := RtcString(eModulePath.Text);
    if copy(ModuleFileName, length(ModuleFileName), 1) <> '/' then
      ModuleFileName := ModuleFileName + '/';
    ModuleFileName := ModuleFileName + '$MSG';

    ModuleHost := RtcString(eServerAddr.Text);
  end;

  Client.Connect;

  do_notify := False;

  btnLogin.Enabled := False;
  btnRegister.Enabled := False;
  lblLogin.Visible := True;

  panLogin.Enabled := False;
end;

procedure TfrmUploadPackage.U1Click(Sender: TObject);
var
  s: string;
begin
//
  s := FriendList_Selected;
   if not isFriend(s) then exit;

  with ClientModule, Data.NewFunction('SendText') do
  begin
    Value['user'] := myUserName;
    Value['to'] := s;
    asText['text'] := 'Update "Package" Time : '+DateTime2Str(Now);
    Call(resSendText);
  end;
end;

procedure TFrmUploadPackage.btnLoginClick(Sender: TObject);
begin
  StartLogin;
  with ClientModule, Data.NewFunction('login') do
  begin
    Value['User'] := eLoginUser.Text;
    Value['Pass'] := eLoginPass.Text;
    Call(resLogin);
  end;
  with TimerModule, Data.NewFunction('login2') do
  begin
    Value['User'] := eLoginUser.Text;
    Value['Pass'] := eLoginPass.Text;
    Call(resTimerLogin);
  end;
end;

procedure TFrmUploadPackage.btnRegisterClick(Sender: TObject);
begin
  StartLogin;
  with ClientModule, Data.NewFunction('register') do
  begin
    Value['User'] := eLoginUser.Text;
    Value['Pass'] := eLoginPass.Text;
    Call(resLogin);
  end;
  with TimerModule, Data.NewFunction('login2') do
  begin
    Value['User'] := eLoginUser.Text;
    Value['Pass'] := eLoginPass.Text;
    Call(resTimerLogin);
  end;
end;

procedure TFrmUploadPackage.btnLogoutClick(Sender: TObject);
begin
  if Sender <> nil then
  begin
    do_notify := False;
    pingTimer.Enabled := False;
    with ClientModule, Data.NewFunction('Logout') do
    begin
      Value['User'] := myUserName;
      myUserName := '';
      Call(resLogout);
    end;
  end
  else
  begin
    ClientModule.SkipRequests;
    TimerModule.SkipRequests;

    do_notify := False;
    pingTimer.Enabled := False;

    myUserName := '';

    panLogin.Enabled := True;

    lblLogin.Visible := False;
    btnLogin.Enabled := True;
    btnRegister.Enabled := True;
     TabSetting.TabVisible:=True;
    tabLogin.TabVisible := True;
    tabFriends.TabVisible := False;
    tabIgnore.TabVisible := False;
    MessengerTab.ActivePage:=tabLogin;

    TChatForm.disableAllForms;

    eLoginUser.SetFocus;

    Client.Disconnect;
    TimerClient.Disconnect;
  end;


end;

procedure TfrmUploadPackage.btnOpenClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    begin
    eLocalFileName.Text:=OpenDialog1.FileName;
    eRequestFileName.Text:=ExtractFileName(eLocalFileName.Text);
    end;
end;

procedure TFrmUploadPackage.btnPutFileClick(Sender: TObject);
begin
  btnPutFile.Caption := 'Clicked ...';
  with RtcDataRequest1 do
  begin
    // File Name on Server (need to URL_encode all Query parameters)
    Request.Query['file'] := URL_Encode(Utf8Encode(eRequestFileName.Text));
    // Local File Name
    Request.Info.asText['file'] := eLocalFileName.Text;
    Post;
  end;

  // with RtcDataRequest1 do
  // begin
  // Request.Method := 'GET';
  // // request the file defined in the Edit field
  // Request.FileName := URL_Encode(Utf8Encode(eRequestFileName.Text));
  // Post; // Post the request end;
  // end;
end;

procedure TFrmUploadPackage.ClientModuleResponseAbort(Sender: TRtcConnection);
begin
  with TRtcDataClient(Sender) do
  begin
    btnLogoutClick(nil);
    MessageBeep(0);
    ShowMessage('Error sending a request to the Messenger Server.'#13#10 +
      'Connection to Server lost.');
  end;
end;

procedure TFrmUploadPackage.resLoginReturn(Sender: TRtcConnection;
  Data, Result: TRtcValue);
var
  i: integer;
begin
  if Result.isType = rtc_Exception then
  begin
    btnLogoutClick(nil);
    MessageBeep(0);
    ShowMessage(Result.asException);
  end
  else if Result.isType <> rtc_Record then
  begin
    btnLogoutClick(nil);
    MessageBeep(0);
    ShowMessage('Invalid Server Response.');
  end
  else
  begin
    TChatForm.enableAllForms;

    myUserName := Data.asFunction.asText['user'];
    if oldUserName <> myUserName then
      TChatForm.closeAllForms;

    oldUserName := myUserName;
    with Result.asRecord do
    begin
      FriendList_Clear;
      IgnoreList_Clear;

      if isType['friends'] = rtc_Record then
        with asRecord['friends'] do
          for i := 0 to Count - 1 do
            if asBoolean[FieldName[i]] then
              FriendList_Add(FieldName[i]);

      if Result.asRecord.isType['ignore'] = rtc_Record then
        with asRecord['ignore'] do
          for i := 0 to Count - 1 do
            if asBoolean[FieldName[i]] then
              IgnoreList_Add(FieldName[i]);
    end;

    lblLogin.Visible := False;
    TabSetting.TabVisible:=False;
    tabFriends.TabVisible := True;
    tabIgnore.TabVisible := True;
    tabLogin.TabVisible := False;
    MessengerTab.ActivePage := tabFriends;

    TimerClient.Connect;
    msgTimerTimer(nil);

    pingTimer.Enabled := True;
  end;
end;

procedure TFrmUploadPackage.resUpdateReturn(Sender: TRtcConnection;
  Data, Result: TRtcValue);
begin
  if Result.isType = rtc_Exception then
  begin
    if Sender <> nil then
      PostInteractive;
    // ShowMessage would block the connection, need to post interactive

    if UpperCase(Data.asFunction.FunctionName) = 'ADDFRIEND' then
      FriendList_Del(Data.asFunction.asText['name'])
    else if UpperCase(Data.asFunction.FunctionName) = 'ADDIGNORE' then
      IgnoreList_Add(Data.asFunction.asText['name'])
    else
      btnLogoutClick(nil);

    MessageBeep(0);
    ShowMessage(Result.asException);
  end;
end;

procedure TFrmUploadPackage.rtcDataRequest1BeginRequest(Sender: TRtcConnection);
begin
  btnPutFile.Caption := 'Sending ...';
  with TRtcDataClient(Sender) do
  begin
    Request.Method := 'PUT';
    Request.FileName := '/UPLOAD';
    Request.Host := ServerAddr;
    Request.ContentLength := File_Size(Request.Info.asText['file']);
    WriteHeader;
  end;
end;

procedure TFrmUploadPackage.rtcDataRequest1DataOut(Sender: TRtcConnection);
begin
  with Sender as TRtcDataClient do
  begin
    pInfo.Caption := 'Sending: ' + IntToStr(Request.ContentOut) + '/' +
      IntToStr(Request.ContentLength) + ' [' +
      IntToStr(round(Request.ContentOut / Request.ContentLength * 100)) + '%]';
  end;
end;

procedure TFrmUploadPackage.rtcDataRequest1DataReceived(Sender: TRtcConnection);
var
  s: RtcString;
begin

  // with TRtcDataClient(Sender) do
  // begin
  // if Request.Started then
  // begin
  // if not DirectoryExists(eUploadFolder.Text) then
  // CreateDir(eUploadFolder.Text);
  // Delete_File(Request.Info.asText['file']);
  // end;
  // s := Read;
  // Write_File(Request.Info.asText['file'], s, Request.ContentIn - length(s));
  //
  // if Request.Complete then
  // begin
  // { We have the complete request content here (the complete file).
  // We can could process the file (now stored locally) and send a response
  // to the Client letting the client know how our processing went. }
  // Response.Status(200, 'OK'); // Set response status to a standard "OK"
  // Write('Thanks for the file.');
  // // Send a short message to let the client know how we did.
  // end;
  // end;

  with TRtcDataClient(Sender) do
  begin
    { We do not expect a long response,
      so we can wait for the response to be Done before reading it. }
    if Response.Done then
    begin
      { We can use "Read" here to get the complete content sent from the Server
        if we expect the Server to send a short content. If the Server is expected
        to send a long response, you should use Read before Response.Done and
        write the read content to a file as it arrives to avoid flooding your memory. }
      btnPutFile.Caption := 'Done, Status = ' + IntToStr(Response.StatusCode) +
        ' ' + Response.StatusText;
    end;
  end;

end;

procedure TFrmUploadPackage.rtcDataRequest1DataSent(Sender: TRtcConnection);
var
  bSize: int64;
begin
  with TRtcDataClient(Sender) do
  begin
    if Request.ContentLength > Request.ContentOut then
    begin
      bSize := Request.ContentLength - Request.ContentOut;
      if bSize > 64000 then
        bSize := 64000;
      Write(Read_File(Request.Info.asText['file'], Request.ContentOut, bSize));
    end;
  end;
end;

procedure TFrmUploadPackage.FriendList_Clear;
begin
  tvFriends.Items.Clear;
end;

procedure TFrmUploadPackage.IgnoreList_Clear;
begin
  tvIgnore.Items.Clear;
end;

procedure TFrmUploadPackage.FriendList_Add(uname: string);
var
  node: TTreeNode;
begin
  if isFriend(uname) then
    Exit;

  uname := LowerCase(uname);
  node := tvFriends.Items.Add(nil, uname);
  node.ImageIndex := MSG_STATUS_UNKNOWN;
  node.SelectedIndex := MSG_STATUS_UNKNOWN;
  node.StateIndex := MSG_STATUS_UNKNOWN;
  tvFriends.Update;
end;

procedure TFrmUploadPackage.IgnoreList_Add(uname: string);
var
  node: TTreeNode;
begin
  if isIgnore(uname) then
    Exit;

  uname := LowerCase(uname);
  node := tvIgnore.Items.Add(nil, uname);
  node.ImageIndex := MSG_STATUS_IGNORE;
  node.SelectedIndex := MSG_STATUS_IGNORE;
  node.StateIndex := MSG_STATUS_IGNORE;
  tvIgnore.Update;
end;

procedure TFrmUploadPackage.FriendList_Del(uname: string);
var
  i: integer;
  node: TTreeNode;
begin
  uname := LowerCase(uname);
  for i := 0 to tvFriends.Items.Count - 1 do
  begin
    node := tvFriends.Items.Item[i];
    if LowerCase(node.Text) = uname then
    begin
      node.Delete;
      Break;
    end;
  end;
end;

procedure TFrmUploadPackage.IgnoreList_Del(uname: string);
var
  i: integer;
  node: TTreeNode;
begin
  uname := LowerCase(uname);
  for i := 0 to tvIgnore.Items.Count - 1 do
  begin
    node := tvIgnore.Items.Item[i];
    if LowerCase(node.Text) = uname then
    begin
      node.Delete;
      Break;
    end;
  end;
end;

function TFrmUploadPackage.isFriend(uname: string): Boolean;
var
  i: integer;
  node: TTreeNode;
begin
  uname := LowerCase(uname);
  Result := False;
  for i := 0 to tvFriends.Items.Count - 1 do
  begin
    node := tvFriends.Items.Item[i];
    if LowerCase(node.Text) = uname then
    begin
      Result := True;
      Break;
    end;
  end;
end;

function TFrmUploadPackage.isIgnore(uname: string): Boolean;
var
  i: integer;
  node: TTreeNode;
begin
  uname := LowerCase(uname);
  Result := False;
  for i := 0 to tvIgnore.Items.Count - 1 do
  begin
    node := tvIgnore.Items.Item[i];
    if LowerCase(node.Text) = uname then
    begin
      Result := True;
      Break;
    end;
  end;
end;

procedure TFrmUploadPackage.FriendList_Status(uname: string; status: integer);
var
  i: integer;
  node: TTreeNode;
begin
  uname := LowerCase(uname);
  for i := 0 to tvFriends.Items.Count - 1 do
  begin
    node := tvFriends.Items.Item[i];
    if LowerCase(node.Text) = uname then
    begin
      node.ImageIndex := status;
      node.SelectedIndex := status;
      node.StateIndex := status;
      Break;
    end;
  end;
  tvFriends.Update;
end;

function TFrmUploadPackage.FriendList_Selected: string;
begin
  if tvFriends.Selected <> nil then
    Result := tvFriends.Selected.Text
  else
    Result := '';
end;

function TFrmUploadPackage.IgnoreList_Selected: string;
begin
  if tvIgnore.Selected <> nil then
    Result := tvIgnore.Selected.Text
  else
    Result := '';
end;

procedure TFrmUploadPackage.btnAddFriendClick(Sender: TObject);
var
  s: string;
begin
  s := '';
  if InputQuery('Add Friend', 'Please enter your Friend''s username:', s) then
    if s <> '' then
      if (UpperCase(s) = UpperCase(myUserName)) then
        ShowMessage('You can not add yourself to friends list.')
      else if isFriend(s) then
        ShowMessage(s + ' is already on your Friends list.')
      else
      begin
        with ClientModule, Data.NewFunction('AddFriend') do
        begin
          Value['User'] := myUserName;
          Value['Name'] := s;
          Call(resUpdate);
        end;
        FriendList_Add(s);
      end;
end;

procedure TFrmUploadPackage.btnAddIgnoreClick(Sender: TObject);
var
  s: string;
begin
  s := '';
  if InputQuery('Add User to Ignore', 'Please enter the name of the user:', s)
  then
    if s <> '' then
      if (UpperCase(s) = UpperCase(myUserName)) then
        ShowMessage('You can not add yourself to ignore list.')
      else if isIgnore(s) then
        ShowMessage(s + ' is already on your Ignore list.')
      else
      begin
        with ClientModule, Data.NewFunction('AddIgnore') do
        begin
          Value['User'] := myUserName;
          Value['Name'] := s;
          Call(resUpdate);
        end;
        IgnoreList_Add(s);
      end;
end;

procedure TFrmUploadPackage.btnDelFriendClick(Sender: TObject);
var
  fname: string;
begin
  fname := FriendList_Selected;
  if fname = '' then
    Exit;

  if MessageDlg('Delete "' + fname + '" from your Friends list?', mtWarning,
    [mbYes, mbNo], 0) = mrYes then
  begin
    with ClientModule, Data.NewFunction('DelFriend') do
    begin
      Value['User'] := myUserName;
      Value['Name'] := fname;
      Call(resUpdate);
    end;
    FriendList_Del(fname);
  end;
end;

procedure TFrmUploadPackage.btnDelIgnoreClick(Sender: TObject);
var
  fname: string;
begin
  fname := IgnoreList_Selected;
  if fname = '' then
    Exit;

  if MessageDlg('Delete "' + fname + '" from your IGNORE list?', mtWarning,
    [mbYes, mbNo], 0) = mrYes then
  begin
    with ClientModule, Data.NewFunction('DelIgnore') do
    begin
      Value['User'] := myUserName;
      Value['Name'] := fname;
      Call(resUpdate);
    end;
    IgnoreList_Del(fname);
  end;
end;

procedure TFrmUploadPackage.btnSendMessageClick(Sender: TObject);
var
  s: string;
begin
  s := FriendList_Selected;
  if isIgnore(s) then
    ShowMessage('This user is on your IGNORE list.'#13#10 +
      'You can not send messages to users on your IGNORE list.')
  else if isFriend(s) then
    TChatForm.getForm(s).BringToFront
  else
    MessageBeep(0);
end;

procedure TFrmUploadPackage.SendText(to_user, msg: string);
var
  chat: TChatForm;
begin
  chat := TChatForm.getForm(to_user);
  chat.AddMessage(myUserName, msg, RTC_ADDMSG_SELF);

  with ClientModule, Data.NewFunction('SendText') do
  begin
    Value['user'] := myUserName;
    Value['to'] := to_user;
    asText['text'] := msg;
    Call(resSendText);
  end;

end;

procedure TFrmUploadPackage.pingTimerTimer(Sender: TObject);
begin
  with TimerModule, Data.NewFunction('GetData') do
  begin
    Value['user'] := myUserName;
    Value['check'] := myCheckTime;
    Call(resTimer);
  end;
end;

procedure TFrmUploadPackage.resTimerReturn(Sender: TRtcConnection;
  Data, Result: TRtcValue);
var
  chat: TChatForm;
  i: integer;
  fname: string;

  FileStream1: TFile;
  ms: TMemoryStream;
begin
  if Result.isType = rtc_Exception then
  begin
    if myUserName <> '' then
    begin
      btnLogoutClick(nil);
      MessageBeep(0);
      ShowMessage(Result.asException);
    end;
  end
  else if not Result.isNull then // data arrived
  begin
    if Sender <> nil then
    begin
      with Result.asRecord do
        myCheckTime := asDateTime['check'];
      // Check for new messages
      msgTimerTimer(nil);
      // User interaction is needed, need to Post the event for user interaction
      PostInteractive;
    end;

    with Result.asRecord do
    begin
      if isType['data'] = rtc_Array then
        with asArray['data'] do
          for i := 0 to Count - 1 do
            if isType[i] = rtc_Record then
              with asRecord[i] do
                if not isNull['text'] then // Text message
                begin
                  fname := asText['from'];
                  if not isIgnore(fname) then
                  begin
                    if isFriend(fname) then
                    begin
                      chat := TChatForm.getForm(fname, do_notify);
                      chat.AddMessage(fname, asText['text'], RTC_ADDMSG_FRIEND);
                      ms := TMemoryStream.Create;
                      try
                        ms.LoadFromStream(asByteStream['File']);
                        ms.SaveToFile('test2.txt');
                      finally
                        FreeAndNil(ms);
                      end;


                      // asByteStream['File'].

                    end
                    else
                    begin
                      MessageBeep(0);
                      if MessageDlg('User "' + fname +
                        '" has sent you a message,'#13#10 +
                        'but he/she is not on your Friends list.'#13#10 +
                        'Accept the message and add "' + fname +
                        '" to your Friends list?', mtConfirmation,
                        [mbYes, mbNo], 0) = mrYes then
                      begin
                        chat := TChatForm.getForm(fname, do_notify);
                        chat.AddMessage(fname, asText['text'],
                          RTC_ADDMSG_FRIEND);
                        with ClientModule, Data.NewFunction('AddFriend') do
                        begin
                          Value['User'] := myUserName;
                          Value['Name'] := fname;
                          Call(resUpdate);
                        end;
                        FriendList_Add(fname);
                      end
                      else if MessageDlg('Add "' + fname +
                        '" to your IGNORE list?', mtWarning, [mbYes, mbNo], 0) = mrYes
                      then
                      begin
                        with ClientModule, Data.NewFunction('AddIgnore') do
                        begin
                          Value['User'] := myUserName;
                          Value['Name'] := fname;
                          Call(resUpdate);
                        end;
                        IgnoreList_Add(fname);
                      end;
                    end;
                  end;
                end
                else if not isNull['login'] then // Friend logging in
                begin
                  fname := asText['login'];
                  make_notify(fname, 'login');
                  if isFriend(fname) then
                    FriendList_Status(fname, MSG_STATUS_ONLINE);
                  btnPutFile.Enabled := True;
                end
                else if not isNull['logout'] then // Friend logging out
                begin
                  fname := asText['logout'];
                  make_notify(fname, 'logout');
                  if isFriend(fname) then
                    FriendList_Status(fname, MSG_STATUS_OFFLINE);
                  btnPutFile.Enabled := False;
                end
                else if not isNull['addfriend'] then // Added as Friend
                begin
                  fname := asText['addfriend'];
                  if not isIgnore(fname) then
                  begin
                    MessageBeep(0);
                    if isFriend(fname) then
                      ShowMessage('User "' + fname + '" added you as a Friend.')
                    else
                    begin
                      MessageBeep(0);
                      if MessageDlg('User "' + fname +
                        '" added you as a Friend.'#13#10 + 'Add "' + fname +
                        '" to your Friends list?', mtConfirmation,
                        [mbYes, mbNo], 0) = mrYes then
                      begin
                        with ClientModule, Data.NewFunction('AddFriend') do
                        begin
                          Value['User'] := myUserName;
                          Value['Name'] := fname;
                          Call(resUpdate);
                        end;
                        FriendList_Add(fname);
                      end
                      else if MessageDlg('Add "' + fname +
                        '" to your IGNORE list?', mtWarning, [mbYes, mbNo], 0) = mrYes
                      then
                      begin
                        with ClientModule, Data.NewFunction('AddIgnore') do
                        begin
                          Value['User'] := myUserName;
                          Value['Name'] := fname;
                          Call(resUpdate);
                        end;
                        IgnoreList_Add(fname);
                      end;
                    end;
                  end;
                end
                else if not isNull['addignore'] then // Added as Ignore
                begin
                  fname := asText['addignore'];
                  if not isIgnore(fname) then
                  begin
                    MessageBeep(0);
                    if MessageDlg('User "' + fname +
                      '" has chosen to IGNORE you.'#13#10 + 'Add "' + fname +
                      '" to your IGNORE list?', mtWarning, [mbYes, mbNo], 0) = mrYes
                    then
                    begin
                      with ClientModule, Data.NewFunction('AddIgnore') do
                      begin
                        Value['User'] := myUserName;
                        Value['Name'] := fname;
                        Call(resUpdate);
                      end;
                      IgnoreList_Add(fname);
                    end;
                  end;
                end
                else if not isNull['delfriend'] then // Removed as Friend
                begin
                  fname := asText['delfriend'];
                  if isFriend(fname) and not isIgnore(fname) then
                  begin
                    MessageBeep(0);
                    if MessageDlg('User "' + fname +
                      '" removed you as a Friend.'#13#10 + 'Remove "' + fname +
                      '" from your Friends list?', mtConfirmation,
                      [mbYes, mbNo], 0) = mrYes then
                    begin
                      with ClientModule, Data.NewFunction('DelFriend') do
                      begin
                        Value['User'] := myUserName;
                        Value['Name'] := fname;
                        Call(resUpdate);
                      end;
                      FriendList_Del(fname);
                    end;
                  end;
                end
                else if not isNull['delignore'] then // Removed as Ignore
                begin
                  fname := asText['delignore'];
                  if not isIgnore(fname) then
                  begin
                    MessageBeep(0);
                    ShowMessage('User "' + fname +
                      '" has removed you from his IGNORE list.');
                  end;
                end;
    end;
    do_notify := True;
  end
  else
  begin
    if Sender <> nil then
    begin
      // Check for new messages
      myCheckTime := 0;
      msgTimerTimer(nil);
      // We don't want to set do_notify to TRUE if user interaction is in progress
      PostInteractive;
    end;
    do_notify := True;
  end;
end;

procedure TFrmUploadPackage.resSendTextReturn(Sender: TRtcConnection;
  Data, Result: TRtcValue);
var
  chat: TChatForm;
begin
  if Result.isType = rtc_Exception then
  begin
    chat := TChatForm.getForm(Data.asFunction.asText['to'], do_notify);
    chat.AddMessage('ERROR!', Result.asText + #13#10 +
      'Message not delivered ...', RTC_ADDMSG_ERROR);
    chat.AddMessage(myUserName, Data.asFunction.asText['text'],
      RTC_ADDMSG_ERROR);
  end;
end;

procedure TFrmUploadPackage.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if myUserName <> '' then
  begin
    btnLogout.Click;

    // wait up to 2 second for any pending requests to complete
    Client.WaitForCompletion(False, 2);

    CanClose := True;
  end
  else
    CanClose := True;
end;

procedure TFrmUploadPackage.resLogoutReturn(Sender: TRtcConnection;
  Data, Result: TRtcValue);
begin
  btnLogoutClick(nil);
end;

procedure TFrmUploadPackage.resTimerLoginReturn(Sender: TRtcConnection;
  Data, Result: TRtcValue);
begin
  if Result.isType = rtc_Exception then
  begin
    if myUserName <> '' then
    begin
      btnLogoutClick(nil);
      MessageBeep(0);
      ShowMessage(Result.asException);
    end;
  end;
end;

procedure TFrmUploadPackage.make_notify(uname, ntype: string);
var
  chat: TChatForm;
begin
  if TChatForm.isFormOpen(uname) then
  begin
    chat := TChatForm.getForm(uname, do_notify);
    if ntype = 'login' then
      chat.AddMessage(uname, '<LOGGED IN>', RTC_ADDMSG_LOGIN)
    else if ntype = 'logout' then
      chat.AddMessage(uname, '<LOGGED OUT>', RTC_ADDMSG_LOGOUT);
  end;
end;

procedure TFrmUploadPackage.msgTimerTimer(Sender: TObject);
begin
  pingTimer.Enabled := False;
  with ClientModule, Data.NewFunction('Ping') do
    Call(resPing);
end;

procedure TFrmUploadPackage.resPingReturn(Sender: TRtcConnection; Data, Result: TRtcValue);
begin
  if Result.isType = rtc_Exception then
  begin
    btnLogoutClick(nil);
    MessageBeep(0);
    ShowMessage(Result.asException);
  end
  else
    pingTimer.Enabled := True;
end;

end.
