{ ============================================
  Software Name : 	Windownly App
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2020                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit uDM;

interface

uses
  System.SysUtils, System.Classes, System.ImageList, FMX.ImgList,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, REST.Types, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope;

type
  TDM = class(TDataModule)
    Conn: TFDConnection;
    QTemp1: TFDQuery;
    QTemp2: TFDQuery;
    QTemp3: TFDQuery;
    QTemp4: TFDQuery;
    RClient: TRESTClient;
    RReq: TRESTRequest;
    RResp: TRESTResponse;
    bgRClient: TRESTClient;
    bgRReq: TRESTRequest;
    bgRResp: TRESTResponse;
    img: TImageList;
    procedure ConnBeforeConnect(Sender: TObject);
    procedure ConnAfterConnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses
{$IF DEFINED(IOS) or DEFINED(ANDROID)}
  System.IOUtils;
{$ELSEIF Defined(MSWINDOWS)}
  System.IOUtils, IWSystem;
{$ELSE}
  System.IOUtils;
{$ENDIF}
{$R *.dfm}

procedure TDM.ConnAfterConnect(Sender: TObject);
begin
  Conn.ExecSQL
    ('CREATE TABLE IF NOT EXISTS tbl_download (filename text,transferdate text)');
  Conn.ExecSQL
    ('CREATE TABLE IF NOT EXISTS tbl_upload (filename text,transferdate text)');
  Conn.ExecSQL
    ('CREATE TABLE IF NOT EXISTS tbl_username (id text,username text,password text,email text,leveluser text)');
      Conn.ExecSQL
    ('CREATE TABLE IF NOT EXISTS tbl_setting (stat text,val text)');

end;

procedure TDM.ConnBeforeConnect(Sender: TObject);
begin
{$IF DEFINED(IOS) or DEFINED(ANDROID)}
  Conn.Params.Values['Database'] := TPath.GetDocumentsPath + PathDelim +
    'dbRegister.db';
{$ELSE}
  Conn.Params.Values['Database'] := gsAppPath + 'dbRegister.db';
{$ENDIF}
end;

end.
