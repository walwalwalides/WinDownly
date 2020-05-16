{ ============================================
  Software Name : 	Windownly App
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2020                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit SecondThrd;

interface
uses system.Classes;


type
  TLoadThread = class(TThread)
  public
    Host: string;
    NamePath: string;
    Port: Integer;
    Config: Boolean;
    constructor Create(const aHost, aNamePath: string; aPort: Integer; aConfig: Boolean); reintroduce;
  protected
    procedure Execute; override;
  end;


implementation


constructor TLoadThread.Create(const aHost, aNamePath: string; aPort: Integer; aConfig: Boolean);
begin
  inherited Create(True);
  FreeOnTerminate := True;
  Host := aHost;
  NamePath := aNamePath;
  Port := aPort;
  Config := aConfig;
end;

procedure TLoadThread.Execute;
begin
  //do processing

//  Synchronize(
//    procedure
//      //update main form
//    end);

  //do processing
end;

end.
