{ ============================================
  Software Name : 	Windownly Service
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2020                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit GFsearchPicutre;

interface

type

  TPictureConfiguration = class
  private
    FPicname : String;
    FOffer : String;
    FVersion : String;
    FUserID: String;
  public
    property Picname : String read FPicname write FPicname;
    property UserID : String read FUserID write FUserID;
    property Offer : String read FOffer write FOffer;
    property Version : String read FVersion write FVersion;
  end;

  function PicConfiguration : TPictureConfiguration;

implementation
uses
    SysUtils // FreeAndNil
  ;

var
  HiddenPictureConfiguration : TPictureConfiguration;

  function PicConfiguration : TPictureConfiguration;
  begin
    if not(Assigned(HiddenPictureConfiguration)) then
      HiddenPictureConfiguration := TPictureConfiguration.Create;

    Result := HiddenPictureConfiguration;
  end;

initialization

finalization
  FreeAndNil(HiddenPictureConfiguration);

end.
