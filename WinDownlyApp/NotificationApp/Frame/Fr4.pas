{ ============================================
  Software Name : 	Windownly App
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2020                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit Fr4;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation;

type
  TF4 = class(TFrame)
    CornerButton1: TCornerButton;
    Label1: TLabel;
    procedure CornerButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure FirstShow;
    procedure ReleaseFrame;
  end;

var
  F4: TF4;

implementation

{$R *.fmx}

uses uMain, uDM, uFunc;

{ TF4 }

procedure TF4.CornerButton1Click(Sender: TObject);
begin
  try

    DM.Conn.StartTransaction;

    // fnSQLAdd(DM.QTemp1, 'DELETE FROM tbl_username', True);
    // fnExecSQL(DM.QTemp1);

    fnSQLAdd(DM.QTemp1,
      'SELECT * FROM tbl_setting where stat=:sta',
      True);
    fnSQLParamByName(DM.QTemp1, 'sta','LastLogout');
    DM.QTemp1.Open;
    if (DM.QTemp1.RecordCount > 0) then

    begin
            fnSQLAdd(DM.QTemp1, 'UPDATE tbl_setting SET val =:val where stat=:sta', True);
      fnSQLParamByName(DM.QTemp1, 'sta', 'LastLogout');
      fnSQLParamByName(DM.QTemp1, 'val', DateTimeToStr(now));
      fnExecSQL(DM.QTemp1);

    end
    else
    begin
      fnSQLAdd(DM.QTemp1, 'INSERT INTO tbl_setting (stat,val)'#13 +
        ' VALUES (:sta, :val)', True);
      fnSQLParamByName(DM.QTemp1, 'sta', 'LastLogout');
      fnSQLParamByName(DM.QTemp1, 'val', DateTimeToStr(now));
      fnExecSQL(DM.QTemp1);


    end;
     DM.Conn.Commit;
    fnShowE('Logout successful', Ok);
  except
    DM.Conn.Rollback;
  end;

  fnGoFrame(goFrame, Login);
end;

procedure TF4.FirstShow;
begin

end;

procedure TF4.ReleaseFrame;
begin
{$IF DEFINED(IOS) or DEFINED(ANDROID)}
  DisposeOf;
{$ELSE}
  Free;
{$ENDIF}
  F4 := Nil;
end;

end.
