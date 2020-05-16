{ ============================================
  Software Name : 	Windownly App
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2020                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit Global;

interface

uses FMX.Forms, Form.CustumMessage;

procedure ShowCustumMessage(icone, tipo_mensagem, titulo, texto_msg, texto_btn1,
  texto_btn2: string; cor_btn1, cor_btn2: Cardinal);

implementation

procedure ShowCustumMessage(icone, tipo_mensagem, titulo, texto_msg, texto_btn1,
  texto_btn2: string; cor_btn1, cor_btn2: Cardinal);
begin
  if NOT Assigned(frmCustumMessage) then
    Application.CreateForm(TfrmCustumMessage,frmCustumMessage);

  frmCustumMessage.Execute_Message(icone, tipo_mensagem, titulo, texto_msg,
    texto_btn1, texto_btn2, cor_btn1, cor_btn2);
end;

end.
