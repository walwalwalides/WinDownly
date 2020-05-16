{ ============================================
  Software Name : 	Windownly App
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2020                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit uHelper;

interface
uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.Threading;

type
  Helper = Class
    public
     class procedure WBDidLoad(ASender : TObject);
  end;

implementation

{ Helper }

uses uFunc;

class procedure Helper.WBDidLoad(ASender: TObject);
begin
  if statBW = True then
    WB.Visible := True;
end;

end.
