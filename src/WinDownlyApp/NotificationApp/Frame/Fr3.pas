{ ============================================
  Software Name : 	Windownly App
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2020                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit Fr3;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, System.Rtti, FMX.Grid.Style, FMX.Gestures,
  System.Actions, FMX.ActnList, FMX.TabControl, FMX.Grid, FMXTee.Series,
  FMX.ScrollBox, FMX.Memo, FMX.ListView, FMX.Layouts, FMX.ImgList, FMX.Effects,
  FMXTee.Engine, FMXTee.Procs, FMXTee.Chart, FMX.Objects, FMX.Ani;

type
  TF3 = class(TFrame)
  private
    { Private declarations }
  public
    { Public declarations }
    procedure FirstShow;
    procedure ReleaseFrame;
  end;

var
  F3 : TF3;

implementation

{$R *.fmx}

{ TF3 }

procedure TF3.FirstShow;
begin

end;

procedure TF3.ReleaseFrame;
begin
  {$IF DEFINED(IOS) or DEFINED(ANDROID)}
    DisposeOf;
  {$ELSE}
    Free;
  {$ENDIF}
  F3 := Nil;
end;

end.
