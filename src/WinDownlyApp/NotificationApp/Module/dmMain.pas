{ ============================================
  Software Name : 	Windownly App
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2020                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit dmMain;

interface

uses
  System.SysUtils, System.Classes, Data.Bind.GenData, IPPeerClient,
  IPPeerServer, System.Tether.Manager, System.Tether.AppProfile,
  Data.Bind.Components, Data.Bind.ObjectScope, Fmx.Bind.GenData,
  unitGamePlayer, System.Actions, Fmx.ActnList, FireDAC.UI.Intf,
  FireDAC.FMXUI.Wait, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteDef, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Stan.Intf,
  FireDAC.Comp.UI, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.Stan.StorageBin, FireDAC.DApt,
  FireDAC.Comp.DataSet;

type
  TTetheringStatus = class
  private
    FStatus: string;
  public
    property Status: string read FStatus write FStatus;
  end;

  TdataMain = class(TDataModule)
    TetheringManager1: TTetheringManager;
    TetheringAppProfile1: TTetheringAppProfile;
    ActionList1: TActionList;
    actGetScores: TAction;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    ConnectionMain: TFDConnection;
    FDManager1: TFDManager;
    ConnectionSetting: TFDConnection;
    FDSQLiteSecurity1: TFDSQLiteSecurity;
    mtblConnection: TFDMemTable;
    tblConnection: TFDTable;
    tblConnectionID: TIntegerField;
    tblConnectionMETHODE: TWideStringField;
    tblConnectionUSER: TWideStringField;
    tblConnectionPASSWORD: TWideStringField;
    tblConnectionIPADDRESS: TWideStringField;
    tblConnectionPORT: TIntegerField;
    tblConnectionMETHODEINDEX: TIntegerField;
    procedure TetheringManager1RequestManagerPassword(const Sender: TObject;
      const RemoteIdentifier: string; var Password: string);
    procedure pbsStatusCreateAdapter(Sender: TObject;
      var ABindSourceAdapter: TBindSourceAdapter);
    procedure pbsPlayerCreateAdapter(Sender: TObject;
      var ABindSourceAdapter: TBindSourceAdapter);
    procedure TetheringAppProfile1ResourceReceived(const Sender: TObject;
      const AResource: TRemoteResource);
    procedure pbsScoreboardCreateAdapter(Sender: TObject;
      var ABindSourceAdapter: TBindSourceAdapter);
    procedure ConnectionMainBeforeConnect(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure ConnectionSettingBeforeConnect(Sender: TObject);
    procedure ConnectionSettingAfterConnect(Sender: TObject);
  private
    { Private declarations }
    FScoreBoard: TGamePlayerList;
    procedure InsertDefaultConecParam;

  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ConnectToScoreboard;
    procedure SendScore;
    procedure SendPicture;
    procedure InitializeDatabase(const imal :integer);
    function getMConnection: integer;
  end;

const
  DB_FILENAME = 'SettingDB';
  Dir_PACKAGEDB = 'WinDownlyDB';
  DB_PASSWORD = 'SQLitePassword';
  DB_ENCRYPTION = 'aes-256';
  DB_TABLE = 'Connection';

var
  dataMain: TdataMain;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses Rest.JSON, Fmx.Dialogs, System.IOUtils, DNLog.Types;

{$R *.dfm}

procedure TdataMain.ConnectionSettingAfterConnect(Sender: TObject);
begin
  // ConnectionSetting.ExecSQL ('CREATE TABLE IF NOT EXISTS Task (TaskName TEXT NOT NULL)');
end;

procedure TdataMain.ConnectionSettingBeforeConnect(Sender: TObject);
begin
{$IF DEFINED(IOS) or DEFINED(ANDROID)}
  ConnectionMain.Params.Values['Database'] := TPath.GetDocumentsPath + PathDelim+Dir_PACKAGEDB+PathDelim
    + 'SettingDB.sqb';
{$ELSE}
  ConnectionMain.Params.Values['Database'] := Dir_PACKAGEDB+PathDelim+'SettingDB.sqb';
{$ENDIF}
end;

procedure TdataMain.ConnectToScoreboard;
begin
  TetheringManager1.AutoConnect;
end;

constructor TdataMain.Create(AOwner: TComponent);
begin
  // FScoreBoard := TGamePlayerList.Create(True);
  // FStatusObj := TTetheringStatus.Create;
  inherited Create(AOwner);
end;

procedure TdataMain.DataModuleCreate(Sender: TObject);
begin
  ConnectionMain.Connected := False;

end;

destructor TdataMain.Destroy;
begin
  inherited;
end;

function TdataMain.getMConnection: integer;
var
  iMethode: integer;
begin
  ConnectionSetting.Close;

{$IF DEFINED(IOS) or DEFINED(ANDROID)}
  ConnectionSetting.Params.Values['Database'] := TPath.GetDocumentsPath +
    PathDelim + 'SettingDB.sqb';
{$ELSE}
  ConnectionSetting.Params.Values['Database'] := 'SettingDB.sqb';
{$ENDIF}
//  ConnectionSetting.Params.Values['Encrypt'] := DB_ENCRYPTION;
//  ConnectionSetting.Params.Password := DB_PASSWORD;
  ConnectionSetting.open;
  // connectionSetting.Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, DB_FILENAME);

  tblConnection.TableName := DB_TABLE;

  tblConnection.Close;
  try
    tblConnection.open;

    if (tblConnection.RecordCount > 0) then
    begin
      iMethode := tblConnection.FieldByName('MethodeIndex').asinteger;
      Result := iMethode;

    end
    else
      Result := 1;
  finally
    tblConnection.Close;

  end;

end;

procedure TdataMain.ConnectionMainBeforeConnect(Sender: TObject);
begin
{$IF DEFINED(IOS) or DEFINED(ANDROID)}
  ConnectionMain.Params.Values['Database'] := TPath.GetDocumentsPath + PathDelim+Dir_PACKAGEDB+PathDelim
    + 'PackageDB.sqb';
{$ELSE}
  ConnectionMain.Params.Values['Database'] := Dir_PACKAGEDB+PathDelim+'PackageDB.sqb';
{$ENDIF}
end;

procedure TdataMain.pbsPlayerCreateAdapter(Sender: TObject;
  var ABindSourceAdapter: TBindSourceAdapter);
begin
  ABindSourceAdapter := TObjectBindSourceAdapter<TGamePlayer>.Create(Self,
    TGamePlayer.Create('Annonymous'), True);
end;

procedure TdataMain.pbsScoreboardCreateAdapter(Sender: TObject;
  var ABindSourceAdapter: TBindSourceAdapter);
begin
  ABindSourceAdapter := TListBindSourceAdapter<TGamePlayer>.Create(Self,
    FScoreBoard, True);
end;

procedure TdataMain.pbsStatusCreateAdapter(Sender: TObject;
  var ABindSourceAdapter: TBindSourceAdapter);
begin
  // ABindSourceAdapter := TObjectBindSourceAdapter<TTetheringStatus>.Create(Self,
  // FStatusObj, True);
end;

procedure TdataMain.SendScore;
begin
  // if TetheringManager1.RemoteProfiles.Count > 0 then
  // TetheringAppProfile1.SendString(TetheringManager1.RemoteProfiles.Items[0],
  // 'TGamePlayer', TJson.ObjectToJsonString
  // (TGamePlayer(pbsPlayer.InternalAdapter.current)));
end;

procedure TdataMain.SendPicture;
var
  MS: TMemoryStream;
begin
  MS := TMemoryStream.Create;
  MS.LoadFromFile('Test.txt');
  // Layout1.MakeScreenShot.SaveToStream(MS);
  MS.Seek(0, 0);
  if TetheringManager1.RemoteProfiles.Count > 0 then
    TetheringAppProfile1.SendStream(TetheringManager1.RemoteProfiles[0],
      'TGamePlayer', MS);
  MS.Free;

  // if TetheringManager1.RemoteProfiles.Count > 0 then
  // TetheringAppProfile1.SendStream(TetheringManager1.RemoteProfiles.Items[0],
  // 'TGamePlayer', TJson.ObjectToJsonString
  // (TGamePlayer(pbsPlayer.InternalAdapter.Current)));

end;

procedure TdataMain.TetheringAppProfile1ResourceReceived(const Sender: TObject;
  const AResource: TRemoteResource);
var
  TopPlayers: TStringList;
  PlayerObj: TGamePlayer;
  PlayerJSON: string;
  stream: TStream;
  MS: TMemoryStream;
  sPAth: string;
begin

  if AResource.ResType = TRemoteResourceType.Data then
  begin
    FScoreBoard.Clear;
    TopPlayers := TStringList.Create;
    try
      TopPlayers.Delimiter := Data_Delimiter;
      TopPlayers.DelimitedText := AResource.Value.AsString;
      for PlayerJSON in TopPlayers do
      begin
        PlayerObj := TJson.JsonToObject<TGamePlayer>(PlayerJSON);
        FScoreBoard.Add(PlayerObj);
      end;
    finally
      TopPlayers.Free;
    end;
  end;
  if AResource.ResType = TRemoteResourceType.stream then
  begin
    // Take the string value, convert to the object and add to the dataset.

    stream := AResource.Value.AsStream;
    MS := TMemoryStream.Create;
    try
      MS.LoadFromStream(stream);
{$IF DEFINED(IOS) or DEFINED(ANDROID)}
      sPAth := TPath.GetDocumentsPath + PathDelim + 'PackageDB.sqb';
{$ELSE}
      sPAth := 'PackageDB.sqb';
{$ENDIF}
      MS.SaveToFile(sPAth);

    finally
      FreeAndNil(MS);
    end;

  end;
end;

procedure TdataMain.TetheringManager1RequestManagerPassword
  (const Sender: TObject; const RemoteIdentifier: string; var Password: string);
begin
  Password := '1234';
end;

procedure TdataMain.InsertDefaultConecParam;
begin

  tblConnection.Edit;

  tblConnection.FieldByName('MethodeIndex').asinteger := 1;
  tblConnection.FieldByName('Methode').AsString := connection_udp;
  tblConnection.FieldByName('User').AsString := 'admin';
  tblConnection.FieldByName('Password').AsString := 'admin';
  tblConnection.FieldByName('IPAddress').AsString := SERVER_ADDRESS;
  tblConnection.FieldByName('Port').asinteger := SERVER_PORT;

  try
    dataMain.tblConnection.post;
  finally
    dataMain.tblConnection.refresh;
  end;

end;

procedure TdataMain.InitializeDatabase(const iMal :integer);
begin
// if imal>1 then
//  exit;
  ConnectionSetting.connected:=false ;

{$IF DEFINED(IOS) or DEFINED(ANDROID)}
  ConnectionSetting.Params.Values['Database'] := TPath.GetDocumentsPath +
    PathDelim + 'SettingDB.sqb';
{$ELSE}
  ConnectionSetting.Params.Values['Database'] := 'SettingDB.sqb';
{$ENDIF}
  // connectionSetting.Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, DB_FILENAME);

  tblConnection.TableName := DB_TABLE;


  if TFile.Exists(ConnectionSetting.Params.Values['Database']) = True then

  begin
//    FDSQLiteSecurity1.Database := ConnectionSetting.Params.Values['Database'];
  end
  else
  begin
    ConnectionSetting.open;        //First time create database
    // initialize table
    try
      tblConnection.FieldDefs.Clear;
      tblConnection.FieldDefs.Assign(mtblConnection.FieldDefs);
      tblConnection.CreateTable(True);
      tblConnection.CopyDataSet(mtblConnection, [coStructure, coRestart,
        coAppend]);

      InsertDefaultConecParam;

    finally
      ConnectionSetting.Close;
    end;
    // encrypt database
//    FDSQLiteSecurity1.Database := ConnectionSetting.Params.Values['Database'];
//    FDSQLiteSecurity1.Password := DB_ENCRYPTION + ':' + DB_PASSWORD;
//    FDSQLiteSecurity1.SetPassword;
  end;

//  ConnectionSetting.Params.Values['Encrypt'] := DB_ENCRYPTION;
//  ConnectionSetting.Params.Password := DB_PASSWORD;
  ConnectionSetting.open;
  tblConnection.IndexFieldNames := mtblConnection.IndexFieldNames;
  tblConnection.open;
//  mtblConnection.Free;
end;

end.
