unit ServerContainerU;

interface

uses
  SysUtils, Classes, 
  SvcMgr, 
  DSTCPServerTransport,
  DSServer, DSCommonServer, DSAuth, IPPeerServer,MidasLib, Datasnap.DSHTTP;

type
  TWinDownly = class(TService)
    procedure DSServerClass1GetClass(DSServerClass: TDSServerClass;
      var PersistentClass: TPersistentClass);

    procedure DSAuthenticationManager1UserAuthenticate(Sender: TObject; const Protocol, Context, User, Password: string; var valid: Boolean;
      UserRoles: TStrings);
  private

    { Private declarations }
  protected
    function DoStop: Boolean; override;
    function DoPause: Boolean; override;
    function DoContinue: Boolean; override;
    procedure DoInterrogate; override;
  public
    function GetServiceController: TServiceController; override;
  end;

var
  WinDownly: TWinDownly;

implementation

uses Windows, MainServer;

{$R *.dfm}



procedure TWinDownly.DSAuthenticationManager1UserAuthenticate(Sender: TObject; const Protocol, Context, User, Password: string; var valid: Boolean; UserRoles: TStrings);
begin
 valid := True;
end;

procedure TWinDownly.DSServerClass1GetClass(
  DSServerClass: TDSServerClass; var PersistentClass: TPersistentClass);
begin
   PersistentClass := TfrmMainServer;

end;

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  WinDownly.Controller(CtrlCode);
end;

function TWinDownly.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

function TWinDownly.DoContinue: Boolean;
begin
frmMainServer.StartServer;
  Result := inherited;

end;

procedure TWinDownly.DoInterrogate;
begin
  frmMainServer.StopServer;
  inherited;
end;

function TWinDownly.DoPause: Boolean;
begin
  frmMainServer.StopServer;
  Result := inherited;
end;

function TWinDownly.DoStop: Boolean;
begin
  frmMainServer.StartServer;
  Result := inherited;
end;

end.

