{ ============================================
  Software Name : 	Windownly App
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight � 2020                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit unitGamePlayer;

interface

uses Generics.Collections;

const
  Data_Delimiter = '^';

type
  TGamePlayer = class
  private
    FName: string;
    FScore: Integer;
  public
    constructor Create(aName : string); overload;


    property Name : string read FName write FName;
    property Score : Integer read FScore write FScore;
  end;

  TGamePlayerList = class(TObjectList<TGamePlayer>);

implementation

{ TGamePlayer }

constructor TGamePlayer.Create(aName: string);
begin
  inherited Create;
  Name := aName;
  FScore := 0;
end;

end.
