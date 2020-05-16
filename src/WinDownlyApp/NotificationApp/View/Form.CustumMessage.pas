{ ============================================
  Software Name : 	Windownly App
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides                     }
{ CopyRight © 2020                             }
{ Email : WalWalWalides@gmail.com              }
{ GitHub :https://github.com/walwalwalides     }
{ ******************************************** }
unit Form.CustumMessage;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls;

type
  TfrmCustumMessage = class(TForm)
    rect_fundo: TRectangle;
    img_erro: TImage;
    img_alerta: TImage;
    img_sucesso: TImage;
    img_pergunta: TImage;
    rect_msg: TRectangle;
    lbl_titulo: TLabel;
    lbl_msg: TLabel;
    img_icone: TImage;
    layout_botao: TLayout;
    rect_btn1: TRectangle;
    lbl_btn1: TLabel;
    rect_btn2: TRectangle;
    lbl_btn2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure lbl_btn1Click(Sender: TObject);
    procedure lbl_btn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    sbtnReturn: string;
    procedure Execute_Message(icone, tipo_mensagem, titulo, texto_msg,
      texto_btn1, texto_btn2: string; cor_btn1, cor_btn2: Cardinal);
  end;

var
  frmCustumMessage: TfrmCustumMessage;

implementation

{$R *.fmx}

procedure TfrmCustumMessage.FormCreate(Sender: TObject);
begin
  self.Position:=TFormPosition.MainFormCenter;
  img_erro.Visible := false;
  img_alerta.Visible := false;
  img_sucesso.Visible := false;
  img_pergunta.Visible := false;
end;

procedure TfrmCustumMessage.lbl_btn1Click(Sender: TObject);
begin
  sbtnReturn := '1';
  close;
end;

procedure TfrmCustumMessage.lbl_btn2Click(Sender: TObject);
begin
  sbtnReturn := '2';
  close;
end;


procedure TfrmCustumMessage.Execute_Message(icone, tipo_mensagem, titulo, texto_msg,
  texto_btn1, texto_btn2: string; cor_btn1, cor_btn2: Cardinal);
begin

  // Icon
  if icone = 'ALARM' then
    img_icone.Bitmap := img_alerta.Bitmap
  else if icone = 'FRAGE' then
    img_icone.Bitmap := img_pergunta.Bitmap
  else if icone = 'ERROR' then
    img_icone.Bitmap := img_erro.Bitmap
    else if icone = 'INFO' then
    img_icone.Bitmap := img_sucesso.Bitmap;


  rect_btn2.Visible := false;
  if tipo_mensagem = 'FRAGE' then
  begin
    rect_btn1.Width := 102;
    rect_btn2.Width := 102;
    rect_btn1.Align := TAlignLayout.Left;
    rect_btn2.Align := TAlignLayout.Right;

    rect_btn2.Visible := true;
  end
  else
  begin
    rect_btn1.Width := 160;
    rect_btn1.Align := TAlignLayout.Center;
  end;

  // Text Message
  lbl_titulo.Text := titulo;
  lbl_msg.Text := texto_msg;

  // Text Button
  lbl_btn1.Text := texto_btn1;
  lbl_btn2.Text := texto_btn2;

  // Color Button
  rect_btn1.Fill.Color := cor_btn1;
  rect_btn2.Fill.Color := cor_btn2;
  self.Height:=292;
  self.Width:=260;
  self.Show;
end;

end.
