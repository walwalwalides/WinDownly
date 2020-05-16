{ ============================================
  Software Name : 	Windownly App
  ============================================ }
{ ******************************************** }
{ Written By WalWalWalides }
{ CopyRight © 2020 }
{ Email : WalWalWalides@gmail.com }
{ GitHub :https://github.com/walwalwalides }
{ ******************************************** }

unit FileManager;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListBox, FMX.Layouts, FMX.StdCtrls, FMX.Objects, FMX.Edit, FMX.Effects,
  FMX.Controls.Presentation;

type
  TArrayCheck = array of array of string;
  TCallback = procedure(ASelected: TArrayCheck) of object;

  TfrmFileManager = class(TForm)
    ListBox1: TListBox;
    Label1: TLabel;
    ToolBar1: TToolBar;
    spdbtnBackFolder: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    ImageBook: TStyleBook;
    SpeedButton4: TSpeedButton;
    Image1: TImage;
    StyleBook1: TStyleBook;
    Image2: TImage;
    Dialog: TRectangle;
    ToolBar2: TToolBar;
    Layout1: TLayout;
    DialogEdit: TEdit;
    DialogTitle: TLabel;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    ShadowEffect1: TShadowEffect;
    DialogFon: TRectangle;
    DialogError: TLabel;
    SpeedButton7: TSpeedButton;
    Image3: TImage;
    SpeedButton8: TSpeedButton;
    ToolBar3: TToolBar;
    Image4: TImage;
    SpeedButton9: TSpeedButton;
    Image5: TImage;
    spdbtnSelect: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure ListBox1ItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure spdbtnBackFolderClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure ListBox1ChangeCheck(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure DialogEditChangeTracking(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure spdbtnSelectClick(Sender: TObject);
  private

    procedure AddListItem(list: array of string; itype: string);
    procedure TotalWork(path_tr: string; clear: boolean);
    procedure OnOffButton(del, add, copy, cut: boolean);
    { Private declarations }
  public
  var
    Callback: TCallback;
    function GetImage(const AImageName: string): TBitmap;
    { Public declarations }
  end;

var
  frmFileManager: TfrmFileManager;

implementation

{$R *.fmx}

uses
  System.IOUtils, System.Generics.Collections, Generics.Defaults
{$IFDEF ANDROID}
    , FMX.Helpers.Android, Androidapi.JNI.JavaTypes, Androidapi.Helpers,
  Androidapi.JNI.GraphicsContentViewText, Androidapi.JNI.Webkit
{$ENDIF}
    , System.Threading;

var
  path: string; //
  ItemsCheck: TArrayCheck; //

function CompareLowerStr(const Left, Right: string): Integer;
begin
  Result := CompareStr(AnsiLowerCase(Left), AnsiLowerCase(Right));
end;

function TfrmFileManager.GetImage(const AImageName: string): TBitmap;
var
  StyleObject: TFmxObject;
  Image: TImage;
begin
  StyleObject := ImageBook.Style.FindStyleResource(AImageName);
  if (StyleObject <> nil) and (StyleObject is TImage) then
  begin
    Image := StyleObject as TImage;
    Result := Image.Bitmap;
  end
  else
    Result := nil;
end;

procedure TfrmFileManager.AddListItem(list: array of string; itype: string);
var
  c: Integer;
  LItem: TListBoxItem;
  BitmapFolder, BitmapFile: TBitmap;
begin

  BitmapFolder := GetImage('folder');
  BitmapFile := GetImage('file');

  ListBox1.BeginUpdate;

  for c := 0 to Length(list) - 1 do
  begin

    LItem := TListBoxItem.Create(ListBox1);

    if itype = 'folder' then
    begin
      if BitmapFolder <> nil then
      begin
        LItem.ItemData.Bitmap.Assign(BitmapFolder);
      end;
    end
    else
    begin
      if BitmapFile <> nil then
      begin
        LItem.ItemData.Bitmap.Assign(BitmapFile);
      end;
    end;

    LItem.ItemData.Text := ExtractFileName(list[c]);
    LItem.ItemData.Detail := list[c];
    LItem.TagString := itype;
    ListBox1.AddObject(LItem);

  end;

  ListBox1.EndUpdate;

end;

function CheckName(NewName: string): boolean;
const
  InvalidChars: Array [0 .. 9] of Char = ('\', '/', ':', '*', '?', '"', '<',
    '>', '|', '~');
var
  LengthName, i, j: Integer;
begin

  Result := False;

  LengthName := Length(NewName);

  if LengthName <> 0 then
  begin
    for i := 0 to LengthName - 1 do
    begin
      for j := 0 to 9 do
      begin
        if NewName[i] = InvalidChars[j] then
        begin
          Result := True;
        end;
      end;
    end;
  end;

end;

procedure TfrmFileManager.DialogEditChangeTracking(Sender: TObject);
begin
  if CheckName(DialogEdit.Text) then
    DialogError.Text := 'Недопускаются \ / : * ? " < > | ~'
  else
    DialogError.Text := '';
end;

procedure TfrmFileManager.FormCreate(Sender: TObject);
begin
{$IFDEF MSWINDOWS}
  self.Position := TFormPosition.MainFormCenter;
{$ENDIF}
  path := '/';
  path := TPath.GetPicturesPath;
{$IFDEF ANDROID}
  path := TPath.GetSharedDownloadsPath;
{$ENDIF}
  TotalWork(path, False);

  SpeedButton2.Visible := False;
  SpeedButton3.Visible := False;
  SpeedButton4.Visible := False;
  SpeedButton5.Visible := False;
  SpeedButton6.Visible := False;
  SpeedButton7.Visible := False;
  SpeedButton8.Visible := False;
  SpeedButton9.Visible := False;

end;

procedure TfrmFileManager.FormKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Dialog.Visible = False then
  begin

    if (Key = vkHardwareBack) AND (path <> '/') then
    begin
      spdbtnBackFolderClick(self); // Back Folder
      Key := 0;
    end;

  end
  else
  begin
    if Key = vkHardwareBack then
    begin
      SpeedButton5Click(self); //
      Key := 0;
    end;

    if Key = 13 then
    begin
      SpeedButton6Click(self); //
    end;
  end;
end;

procedure TfrmFileManager.ListBox1ChangeCheck(Sender: TObject);
var
  i: Integer;
begin
  SetLength(ItemsCheck, 0, 0);

  for i := 0 to ListBox1.Count - 1 do
  begin

    if (ListBox1.ListItems[i].IsChecked) and
      (ListBox1.ListItems[i].TagString = 'file') then
    begin
      SetLength(ItemsCheck, i + 1, 3);
      ItemsCheck[i][0] := ListBox1.ListItems[i].Text;
      ItemsCheck[i][1] := ListBox1.ListItems[i].TagString;
      ItemsCheck[i][2] := ListBox1.ListItems[i].ItemData.Detail;
    end
    else if (ListBox1.ListItems[i].IsChecked) and
      (ListBox1.ListItems[i].TagString = 'folder') then
    begin

      ShowMessage('Unable to Upload a Folder!');
      ListBox1.ListItems[i].IsChecked := False;
    end;

  end;

  if Length(ItemsCheck) <> 0 then
  begin
    OnOffButton(True, False, True, True);
  end
  else
  begin
    OnOffButton(False, False, False, False);
  end;

end;

procedure TfrmFileManager.ListBox1ItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
var
  FileName, ExtFile: string;
{$IFDEF ANDROID}
  mime: JMimeTypeMap;
  ExtToMime: JString;
  Intent: JIntent;

{$ENDIF}
begin

  if Length(ItemsCheck) <> 0 then
  begin
    OnOffButton(False, True, False, False);
  end
  else
  begin
    OnOffButton(False, False, False, False);
  end;

  if (Item.TagString = 'folder') then
  begin

    path := Item.ItemData.Detail;

    if TDirectory.Exists(path) then
    begin
      TotalWork(path, True);
    end
    else
    begin
      ListBox1.Items.Delete(Item.Index);
      ShowMessage('Folder not found!');
    end;

  end
  else if (Item.TagString = 'file') then
  begin

    FileName := Item.ItemData.Detail;

    try

{$IFDEF ANDROID}
      ExtFile := AnsiLowerCase(StringReplace(TPath.GetExtension(FileName),
        '.', '', []));
      mime := TJMimeTypeMap.JavaClass.getSingleton();
      ExtToMime := mime.getMimeTypeFromExtension(StringToJString(ExtFile));

      Intent := TJIntent.Create;
      Intent.setAction(TJIntent.JavaClass.ACTION_VIEW);
      Intent.setDataAndType(StrToJURI('file:' + FileName), ExtToMime);
      SharedActivity.startActivity(Intent);

{$ENDIF}
    except
      // ShowMessage('Unable to open File!');
    end;
  end;
end;

procedure TfrmFileManager.OnOffButton(del, add, copy, cut: boolean);
begin
  SpeedButton2.Enabled := del;
  SpeedButton7.Enabled := add;
  SpeedButton8.Enabled := copy;
  SpeedButton9.Enabled := cut;
end;

procedure TfrmFileManager.spdbtnSelectClick(Sender: TObject);
var
  LResult: String;
begin
  // System.TMonitor.Enter(Self);
  //
  // System.TMonitor.Exit(Self);

  if (Length(ItemsCheck) <> 0) then
  Begin
    TTask.Run(
      procedure
      Begin
        if Assigned(Callback) then
        begin
          // if ListBox1.ItemIndex = -1 then
          // LResult := EmptyStr
          // else
          // LResult := ListBox1.Items[ListBox1.ItemIndex];

          Callback(ItemsCheck);
        end;

        TThread.Synchronize(nil,
          procedure
          begin

          end);
      End);
  end;

  Close;

end;

procedure TfrmFileManager.spdbtnBackFolderClick(Sender: TObject);
begin

  path := ExtractFileDir(path);

  if path = '/' then
    path := '/'
  else
    path := path;

  TotalWork(path, True);

  if Length(ItemsCheck) <> 0 then
  begin
    OnOffButton(False, True, False, False);
  end
  else
  begin
    OnOffButton(False, False, False, False);
  end;
end;

procedure TfrmFileManager.SpeedButton2Click(Sender: TObject);
var
  i: Integer;
  LItemPath: string;
  msg: Integer;
begin
  msg := MessageDlg('Do you have a separate file?',
    System.UITypes.TMsgDlgType.mtConfirmation, [System.UITypes.TMsgDlgBtn.mbYes,
    System.UITypes.TMsgDlgBtn.mbNo], 0);

  if msg = mrYes then
  begin

    for i := 0 to Length(ItemsCheck) - 1 do
    begin

      if ItemsCheck[i][0] <> '' then
      begin
        LItemPath := ItemsCheck[i][2];
        if ItemsCheck[i][1] = 'folder' then
        begin

          if TDirectory.Exists(LItemPath) then
          begin
            TDirectory.Delete(LItemPath, True);
          end;

        end
        else if ItemsCheck[i][1] = 'file' then
        begin

          if TFile.Exists(LItemPath) then
          begin
            TFile.Delete(LItemPath);
          end;

        end;
      end;
    end;
    TotalWork(path, True);
    ListBox1ChangeCheck(self);
  end;
end;

procedure TfrmFileManager.SpeedButton3Click(Sender: TObject);
begin
  DialogTitle.Text := 'Create a File';
  DialogEdit.TagString := 'CreateFile';
  DialogFon.Visible := True;
  Dialog.Visible := True;
end;

procedure TfrmFileManager.SpeedButton4Click(Sender: TObject);
begin
  DialogTitle.Text := 'Create a Folder';
  DialogEdit.TagString := 'CreateFolder';
  DialogFon.Visible := True;
  Dialog.Visible := True;
end;

procedure TfrmFileManager.SpeedButton5Click(Sender: TObject);
begin
  DialogEdit.Text := '';
  DialogError.Text := '';
  Dialog.Visible := False;
  DialogFon.Visible := False;
end;

procedure TfrmFileManager.SpeedButton6Click(Sender: TObject);
var
  newpath: string;
  newfile: TFileStream;
begin

  if (Length(DialogEdit.Text) = 0) OR (DialogEdit.Text = ' ') then
  begin
    DialogError.Text := 'Empty !';
    Exit;
  end;

  newpath := path + PathDelim + DialogEdit.Text;

  if (DialogEdit.TagString = 'CreateFile') then
  begin
    if TFile.Exists(newpath) then
    begin
      ShowMessage('File already exists!');
    end
    else
    begin
      newfile := TFile.Create(newpath);
      newfile.Free;
      SpeedButton5Click(self);
      TotalWork(path, True);
    end;
  end
  else if DialogEdit.TagString = 'CreateFolder' then
  begin
    if TDirectory.Exists(newpath) then
    begin
      ShowMessage('Folder already exists!');
    end
    else
    begin
      TDirectory.CreateDirectory(newpath);
      SpeedButton5Click(self);
      TotalWork(path, True);
    end;
  end;
end;

procedure TfrmFileManager.SpeedButton7Click(Sender: TObject);
var
  i: Integer;
  LItemPath: string;
begin

  for i := 0 to Length(ItemsCheck) - 1 do
  begin

    if ItemsCheck[i][0] <> '' then
    begin
      LItemPath := ItemsCheck[i][2];

      if ItemsCheck[i][1] = 'folder' then
      begin
        try
          if SpeedButton9.Tag <> 1 then
          begin
            TDirectory.copy(LItemPath, path + PathDelim + ItemsCheck[i][0]);
          end
          else
          begin
            TDirectory.Move(LItemPath, path + PathDelim + ItemsCheck[i][0]);
          end;
        except
          ShowMessage('Using the folder' + ItemsCheck[i][0] +
            'is not possible !');
        end;
      end
      else if ItemsCheck[i][1] = 'file' then
      begin
        try
          if SpeedButton9.Tag <> 1 then
          begin
            TFile.copy(LItemPath, path + PathDelim + ItemsCheck[i][0], True);
          end
          else
          begin
            TFile.Move(LItemPath, path + PathDelim + ItemsCheck[i][0]);
          end;
        except
          ShowMessage('Using the file ' + ItemsCheck[i][0] +
            ' is not possible !');
        end;
      end;
    end;
  end;
  SpeedButton9.Tag := 0;
  TotalWork(path, True);
  ListBox1ChangeCheck(self);
end;

procedure TfrmFileManager.SpeedButton8Click(Sender: TObject);
begin
  if (Length(ItemsCheck) <> 0) then
  begin
    ShowMessage('Not File Selected!');
  end;
end;

procedure TfrmFileManager.SpeedButton9Click(Sender: TObject);
begin
  if Length(ItemsCheck) <> 0 then // cut file
  begin
    SpeedButton9.Tag := 1;
    ShowMessage('Not File Selected!');
  end;
end;

procedure TfrmFileManager.TotalWork(path_tr: string; clear: boolean);
var
  folders, files: TStringDynArray;
begin
  Label1.Text := path_tr;
  folders := TDirectory.GetDirectories(path_tr);
  TArray.Sort<String>(folders, TComparer<String>.Construct(CompareLowerStr));

  if clear then
  begin
    ListBox1.clear;
  end;

  AddListItem(folders, 'folder');
  files := TDirectory.GetFiles(path_tr);
  TArray.Sort<String>(files, TComparer<String>.Construct(CompareLowerStr));
  AddListItem(files, 'file');

end;

end.
