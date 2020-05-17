{ ============================================
  Software Name : 	Windownly Service
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2020                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit GlobalVariableFile;

interface

type

  TIngredientsConfiguration = class
  private
    FValue : String;
    FOpen : Boolean;
    FMode : String;
  public
    property Value : String read FValue write FValue;
    property Open : Boolean read FOpen write FOpen;
    property Mode : String read FMode write FMode;
  end;

var
  IngredientsConfiguration : TIngredientsConfiguration;

implementation
uses
    SysUtils // FreeAndNil
  ;

initialization
  IngredientsConfiguration := TIngredientsConfiguration.Create;

finalization
  FreeAndNil(IngredientsConfiguration);

end.
 