{ ============================================
  Software Name : 	Windownly App
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight � 2020                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit DNLog.Types;

interface

uses
  System.SysUtils;

const
  SERVER_ADDRESS = '127.0.0.1';
//  SERVER_BIND_ADDRESS_4 = '127.0.0.1';
  SERVER_BIND_ADDRESS_4 = '0.0.0.0';
//  SERVER_BIND_ADDRESS_6 = '::1';
  SERVER_BIND_ADDRESS_6 = '::';
  SERVER_BIND_PORT = 9999;
  SERVER_PORT = 69;
  SERVER_BUFFER_SIZE = 20; // [MB]
  CONNECTION_UDP='UDP';
  CONNECTION_TCP='TCP';

type TDNLogPriority = (prDebug, prInfo, prWarning, prError);

type TDNLogMessage = record
  LogPriority: TDNLogPriority;
  LogTimestamp: Cardinal;
  LogTypeNr: ShortInt;
  LogMessage: string;
  LogData: TBytes;
end;

implementation

end.
