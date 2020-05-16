{ ============================================
  Software Name : 	Windownly App
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2020                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit Fr2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, System.Rtti, FMX.Grid.Style, REST.Types,
  REST.Client, Data.Bind.Components, Data.Bind.ObjectScope, FMX.Grid,
  FMX.ScrollBox, FMXTee.Series, FMXTee.Engine, FMXTee.Procs, FMXTee.Chart,
  FMX.ImgList, FMX.Objects, FMX.Layouts;

type
  TF2 = class(TFrame)
  private
    { Private declarations }
  public
    { Public declarations }
    procedure FirstShow;
    procedure ReleaseFrame;
  end;

var
  F2 : TF2;

implementation

{$R *.fmx}

{ TF2 }

procedure TF2.FirstShow;
begin

end;

procedure TF2.ReleaseFrame;
begin
  {$IF DEFINED(IOS) or DEFINED(ANDROID)}
    DisposeOf;
  {$ELSE}
    Free;
  {$ENDIF}
  F2 := Nil;
end;

end.
