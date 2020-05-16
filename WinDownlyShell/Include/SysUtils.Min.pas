{ ============================================
  Software Name : 	WinDownlyShell
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight � 2020                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }

unit SysUtils.Min;

// DO NOT INCLUDE THIS UNIT IF YOU USE System.SysUtils.

interface

implementation

uses
  Winapi.Windows;

const
  STATUS_UNHANDLED_EXCEPTION: Integer = Integer($C0000144);

function _IntToStr(i: NativeUInt): ShortString; inline;
begin
  Str(i, Result);
end;

function IntToStr(i: NativeUInt): String;
begin
  Result := String(_IntToStr(i));
end;

// Since try..except doesn't work without System.SysUtils
// we should handle all exceptions on our own.
function HaltOnException(P: PExceptionRecord): IntPtr;
begin
  Result := 0;
  OutputDebugStringW(
    PWideChar(
      'Exception occured: code = ' + IntToStr(P.ExceptionCode) +
      '; address = ' + IntToStr(NativeUInt(P.ExceptionAddress))
    )
  );
  Halt(STATUS_UNHANDLED_EXCEPTION);
end;

initialization

ExceptObjProc := @HaltOnException;

end.
