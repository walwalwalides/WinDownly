{ ============================================
  Software Name : 	Windownly Server
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight � 2020                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit unitGame;

interface

uses unitGamePlayer;

type
  TGuessResult = (Correct, ToHigh, ToLow);

  TGuessingGame = class
  private
    FPlayer: TGamePlayer;
    FValueToGuess : Integer;
    FGuessesMade: Integer;
  public
    constructor Create(aPlayer : TGamePlayer);
    procedure Reset;
    function HaveAGuess(Value : Integer): TGuessResult;
    property Guesses : Integer read FGuessesMade;
    property Player : TGamePlayer read FPlayer;
  end;

implementation

{ TGuessingGame }

constructor TGuessingGame.Create(aPlayer: TGamePlayer);
begin
  Assert(aPlayer <> nil,'Player details missing');
  inherited Create;
  FPlayer := aPlayer;
  Reset;
end;

function TGuessingGame.HaveAGuess(Value: Integer): TGuessResult;
begin
  Inc(FGuessesMade);
  if Value = FValueToGuess then
    Exit(TGuessResult.Correct)
  else if Value > FValueToGuess then
    Exit(TGuessResult.ToHigh)
  else
    Exit(TGuessResult.ToLow);
end;

procedure TGuessingGame.Reset;
begin
  Randomize;
  FValueToGuess := Random(100);
  FGuessesMade := 0;
end;

end.
