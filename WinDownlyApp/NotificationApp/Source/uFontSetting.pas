{ ============================================
  Software Name : 	Windownly App
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight � 2020                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit uFontSetting;

interface
uses
  FMX.Platform, FMX.Graphics;

type
  TmyFMXSystemFontService = class(TInterfacedObject, IFMXSystemFontService)
  public
    function GetDefaultFontFamilyName: string;
    function GetDefaultFontSize: Single;
  end;
implementation

{ TmyFMXSystemFontService }

function TmyFMXSystemFontService.GetDefaultFontFamilyName: string;
begin
  Result := 'Calibri';
end;

function TmyFMXSystemFontService.GetDefaultFontSize: Single;
begin
  Result := 12;
end;

procedure InitFont;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXSystemFontService) then
    TPlatformServices.Current.RemovePlatformService(IFMXSystemFontService);

  TPlatformServices.Current.AddPlatformService(IFMXSystemFontService, TmyFMXSystemFontService.Create);
end;

initialization

InitFont;

end.
