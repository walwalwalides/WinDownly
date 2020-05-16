object frmMainServer: TfrmMainServer
  Left = 369
  Top = 185
  BorderStyle = bsSizeToolWin
  Caption = 'MPP_Server'
  ClientHeight = 411
  ClientWidth = 309
  Color = clWhite
  Constraints.MaxHeight = 450
  Constraints.MaxWidth = 325
  Constraints.MinHeight = 450
  Constraints.MinWidth = 325
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 16
  object pInfo: TPanel
    Left = 0
    Top = 382
    Width = 309
    Height = 29
    Align = alBottom
    BevelOuter = bvLowered
    Caption = 'Server not listening.'
    TabOrder = 0
  end
  object xIPv6: TCheckBox
    Left = 156
    Top = 12
    Width = 65
    Height = 25
    Caption = 'IPv6'
    TabOrder = 1
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 309
    Height = 382
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 2
    object TabSheet1: TTabSheet
      Caption = 'Setting'
      object Bevel1: TBevel
        Left = -4
        Top = 96
        Width = 288
        Height = 3
      end
      object lblLocalIp: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 332
        Width = 295
        Height = 16
        Align = alBottom
        Caption = 'lblLocalIp'
        ExplicitTop = 335
        ExplicitWidth = 58
      end
      object btnStart: TButton
        Left = 3
        Top = 49
        Width = 92
        Height = 31
        Caption = 'Start'
        ImageIndex = 3
        Images = Icons
        TabOrder = 0
        OnClick = btnStartClick
      end
      object btnStop: TButton
        Left = 101
        Top = 49
        Width = 92
        Height = 31
        Caption = 'Stop'
        Enabled = False
        ImageIndex = 4
        Images = Icons
        TabOrder = 1
        OnClick = btnStopClick
      end
      object Button1: TButton
        Left = 199
        Top = 49
        Width = 92
        Height = 31
        Caption = 'Update'
        ImageIndex = 5
        Images = Icons
        TabOrder = 2
        OnClick = Button1Click
      end
      object Panel1: TPanel
        Left = 8
        Top = 111
        Width = 288
        Height = 66
        TabOrder = 3
        object Label2: TLabel
          Left = 1
          Top = 1
          Width = 286
          Height = 16
          Align = alTop
          Alignment = taCenter
          Caption = 'Upload Folder'
          ExplicitWidth = 87
        end
        object eUploadFolder: TEdit
          Left = 40
          Top = 23
          Width = 208
          Height = 24
          TabOrder = 0
          Text = 'Documents\WinDownly'
        end
      end
      object Panel2: TPanel
        Left = 4
        Top = 3
        Width = 189
        Height = 41
        TabOrder = 4
        object Label1: TLabel
          Left = 8
          Top = 14
          Width = 67
          Height = 16
          Caption = 'Server Port'
        end
        object edtPort: TEdit
          Left = 96
          Top = 9
          Width = 46
          Height = 24
          NumbersOnly = True
          TabOrder = 0
          Text = '8085'
        end
      end
      object Panel3: TPanel
        Left = 8
        Top = 183
        Width = 287
        Height = 41
        TabOrder = 5
        object lblIPAdresse: TLabel
          Left = 9
          Top = 14
          Width = 67
          Height = 16
          Caption = 'IP-Adresse'
        end
        object mskedtIP: TMaskEdit
          Left = 103
          Top = 9
          Width = 177
          Height = 24
          TabOrder = 0
          Text = ''
        end
      end
    end
    object TabLog: TTabSheet
      Caption = 'Loging'
      ImageIndex = 1
      object btnLogging: TButton
        Left = 3
        Top = 3
        Width = 92
        Height = 31
        Caption = 'Logging'
        ImageIndex = 6
        Images = Icons
        TabOrder = 0
        OnClick = btnLoggingClick
      end
    end
  end
  object Server: TRtcHttpServer
    MultiThreaded = True
    Timeout.AfterConnecting = 40
    ServerAddr = 'localhost'
    ServerPort = '8085'
    RestartOn.ListenLost = True
    OnListenStart = ServerListenStart
    OnListenStop = ServerListenStop
    FixupRequest.RemovePrefix = True
    OnRequestNotAccepted = ServerRequestNotAccepted
    MaxRequestSize = 64000
    MaxHeaderSize = 16000
    Left = 200
    Top = 312
  end
  object RtcDataProvider1: TRtcDataProvider
    Server = Server
    OnCheckRequest = RtcDataProvider1CheckRequest
    OnDataReceived = RtcDataProvider1DataReceived
    Left = 256
    Top = 128
  end
  object TrayIconApp: TRzTrayIcon
    HideOnStartup = True
    PopupMenu = PopupMenu
    Left = 264
    Top = 344
  end
  object PopupMenu: TPopupMenu
    Images = Icons
    Left = 60
    Top = 288
    object AboutBtn: TMenuItem
      Action = AboutApplication
      Bitmap.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000000000000000
        000000000000000000003324154666482B8D90653CC7AD7A48F0AD7A48F09065
        3CC766482B8D3324154600000000000000000000000000000000000000000000
        000017100A2065472A8CAF7C49F3B8824DFFB8824DFFB8824DFFB8824DFFB882
        4DFFB8824DFFAF7C49F365472A8C17100A200000000000000000000000001710
        0A20765331A3B8824DFFB8824DFFB8824DFFB8824DFFB8824DFFB8824DFFB882
        4DFFB8824DFFB8824DFFB8824DFF765331A317100A2000000000000000006547
        2A8CB8824DFFB8824DFFB8824DFFB8824DFFB8824DFFB8824DFFB8824DFFB882
        4DFFB8824DFFB8824DFFB8824DFFB8824DFF65472A8C0000000033241546AF7C
        49F3B8824DFFB8824DFFB8824DFFB8824DFFB8824DFF0000000000000000B882
        4DFFB8824DFFB8824DFFB8824DFFB8824DFFAF7C49F33324154666482B8DB882
        4DFFB8824DFFB8824DFFB8824DFFB8824DFFB8824DFF0000000000000000B882
        4DFFB8824DFFB8824DFFB8824DFFB8824DFFB8824DFF66482B8D90653CC7B882
        4DFFB8824DFFB8824DFFB8824DFFB8824DFFB8824DFF0000000000000000B882
        4DFFB8824DFFB8824DFFB8824DFFB8824DFFB8824DFF90653CC7AD7A48F0B882
        4DFFB8824DFFB8824DFFB8824DFFB8824DFFB8824DFF0000000000000000B882
        4DFFB8824DFFB8824DFFB8824DFFB8824DFFB8824DFFAD7A48F0AD7A48F0B882
        4DFFB8824DFFB8824DFFB8824DFFB8824DFFB8824DFF0000000000000000B882
        4DFFB8824DFFB8824DFFB8824DFFB8824DFFB8824DFFAD7A48F090653CC7B882
        4DFFB8824DFFB8824DFFB8824DFFB8824DFFB8824DFFB8824DFFB8824DFFB882
        4DFFB8824DFFB8824DFFB8824DFFB8824DFFB8824DFF90653CC766482B8DB882
        4DFFB8824DFFB8824DFFB8824DFFB8824DFFB8824DFF0000000000000000B882
        4DFFB8824DFFB8824DFFB8824DFFB8824DFFB8824DFF66482B8D33241546AF7C
        49F3B8824DFFB8824DFFB8824DFFB8824DFFB8824DFF0000000000000000B882
        4DFFB8824DFFB8824DFFB8824DFFB8824DFFAF7C49F333241546000000006547
        2A8CB8824DFFB8824DFFB8824DFFB8824DFFB8824DFFB8824DFFB8824DFFB882
        4DFFB8824DFFB8824DFFB8824DFFB8824DFF65472A8C00000000000000001710
        0A20765331A3B8824DFFB8824DFFB8824DFFB8824DFFB8824DFFB8824DFFB882
        4DFFB8824DFFB8824DFFB8824DFF765331A317100A2000000000000000000000
        000017100A2065472A8CAF7C49F3B8824DFFB8824DFFB8824DFFB8824DFFB882
        4DFFB8824DFFAF7C49F365472A8C17100A200000000000000000000000000000
        000000000000000000003324154666482B8D90653CC7AD7A48F0AD7A48F09065
        3CC766482B8D3324154600000000000000000000000000000000}
    end
    object LineItem: TMenuItem
      Caption = '-'
    end
    object ExitBtn: TMenuItem
      Action = CloseApplication
      Bitmap.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        200000000000000400000000000000000000000000000000000000000000131C
        3C471E2B5F700000000000000000000000000000000000000000000000000000
        00000000000000000000000000001F2D6375131C3C4700000000131C3C474260
        D0F64463D8FF1F2D617300000000000000000000000000000000000000000000
        00000000000000000000202E65774463D8FF4260D1F7131C3C472130687B4463
        D8FF4463D8FF4463D8FF1F2D6173000000000000000000000000000000000000
        000000000000202E65774463D8FF4463D8FF4463D8FF212F677A000000002231
        6C7F4463D8FF4463D8FF4463D8FF1F2D61730000000000000000000000000000
        0000202E65774463D8FF4463D8FF4463D8FF22316B7E00000000000000000000
        000022316C7F4463D8FF4463D8FF4463D8FF1F2D61730000000000000000202E
        65774463D8FF4463D8FF4463D8FF22316B7E0000000000000000000000000000
        00000000000022316C7F4463D8FF4463D8FF4463D8FF1F2D6173202E65774463
        D8FF4463D8FF4463D8FF22316B7E000000000000000000000000000000000000
        0000000000000000000022316C7F4463D8FF4463D8FF4463D8FF4463D8FF4463
        D8FF4463D8FF22316B7E00000000000000000000000000000000000000000000
        000000000000000000000000000022316C7F4463D8FF4463D8FF4463D8FF4463
        D8FF22316B7E0000000000000000000000000000000000000000000000000000
        0000000000000000000000000000202E65774463D8FF4463D8FF4463D8FF4463
        D8FF1F2D62740000000000000000000000000000000000000000000000000000
        00000000000000000000202E65774463D8FF4463D8FF4463D8FF4463D8FF4463
        D8FF4463D8FF1F2D627400000000000000000000000000000000000000000000
        000000000000202E65774463D8FF4463D8FF4463D8FF22316B7E22316C7F4463
        D8FF4463D8FF4463D8FF1F2D6274000000000000000000000000000000000000
        0000202E65774463D8FF4463D8FF4463D8FF21316A7D00000000000000002231
        6C7F4463D8FF4463D8FF4463D8FF1F2D6274000000000000000000000000202E
        65774463D8FF4463D8FF4463D8FF21316A7D0000000000000000000000000000
        000022316C7F4463D8FF4463D8FF4463D8FF1F2D6274000000001F2D63754463
        D8FF4463D8FF4463D8FF21316A7D000000000000000000000000000000000000
        00000000000022316C7F4463D8FF4463D8FF4463D8FF1E2C6172151E414D4261
        D3F94463D8FF21316A7D00000000000000000000000000000000000000000000
        0000000000000000000022316C7F4463D8FF4261D3F9151E424E00000000151E
        414D212F677A0000000000000000000000000000000000000000000000000000
        00000000000000000000000000002130687B151E414D00000000}
      Break = mbBarBreak
    end
  end
  object Icons: TImageList
    Left = 16
    Top = 280
    Bitmap = {
      494C010107001000040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000010101022927
      25494F4B4799655F57D4756D62F1766C5EFE6E6453FE5B5041F138322ACF1E1B
      189A0E0C0A4B000000020000000000000000958E87FF938D86FF938D86FF928C
      85FF918B84FF908A84FF99938FFFA19C98FFAFADA8FF0D4F5DFFC7C4C3FF7270
      6DFF4A4845FF9C9795FF918D8AFF86827EFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000001547000045E60000
      54FF000052FF000052FF000053FF000051FF000051FF000051FF000051FF0000
      51FF000053FF000045E300001341000000000000000012111023706A63CEBBB4
      ACFFD8CDC1FFDDD1C2FFCCBCAAFFBBAB94FFAC9980FF9D8B71FF877967FF675F
      53FF534C44FF3D3932CE0C0B0A2300000000968F88FFFEFEFEFFFEFEFEFFFEFE
      FEFFFEFEFEFF918B84FFFCFCFCFF0D4F5DFFB8B3B3FF62A1A8FF0D4F5DFFDAD9
      D9FF9B9897FF4B4844FFE6E6E6FF908C88FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000053E62525C3FF4F4E
      EDFF4E4DEAFF4D4DEAFF4C4CE8FF4C4CE8FF4C4CE8FF4C4CE8FF4C4CE8FF4C4C
      E9FF4C4CEBFF1E1EBAFF00004EDD0000000000000000665F59CED4CABCFFFAF0
      E6FFEDE2D5FFDCD0C1FFC9BAA6FFB8A792FFAA9880FF9C8970FF877B67FF796E
      62FF897F71FF968B7DFF514A42D900000000979188FFFEFEFEFFFAF4EDFFFAF4
      EEFFFEFEFEFF928C85FFFBFBFBFF64A4ABFF0D4F5DFFDEE0DEFF61A2A8FF0D4F
      5DFFCFCBCBFF5B5855FF63605DFF9D9996FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000006AFF4545E4FF6F70
      FCFF7F81FEFF7F82FEFF7F83FEFF8183FEFF8082FEFF8182FEFF7F83FEFF7F81
      FEFF6F70FDFF3E3EDDFF000063F7000000000000000080796FFEE8DCCDFFF9F0
      E8FFE5DFD6FFC4BDB4FFB0A79CFFB2A799FFB2A798FFB4A898FFB2A795FFA59A
      8AFF958A7DFF978D7FFF696157FE00000000989189FFFEFEFEFFF9F2ECFFFAF2
      EDFFFEFEFEFF938D86FFFBFBFBFFB9B5B2FF66A4AAFF0D4F5DFFEEEBE9FF96BE
      C2FFBDBCBBFF6F6966FF5B5955FF615F5DFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000068FF3A3AD9FF5353
      EBFF5A5AECFF5656EAFF5555EAFF5656EAFF5656EAFF5656ECFF5757EBFF595B
      EDFF5454EBFF3333D2FF000068FF000000000000000082796EFFCCC5BDFFB7B1
      AAFFC8BDB3FFD7CCBEFFC9B9A6FFB8A892FFAB9A82FF9F8E75FF8D806DFF8378
      69FFA99D8CFFBEB19FFF655E53FF00000000999289FFFEFEFEFFFEFEFEFFFEFE
      FEFFFEFEFEFF958E87FFFBFBFBFF9D9A98FFE2DEDAFFAAC8CAFFE4E2DFFFBCB8
      B4FF868582FF7F7B78FF726E6AFF4C4945FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000006BFF3232D0FF3D3D
      DAFF3B3BD6FF3A3AD5FF3A3AD5FF3A3AD5FF3A3AD5FF3A3AD5FF3A3AD5FF3C3C
      D6FF3E3EDAFF2C2CCAFF000068FF00000000000000007C776FFDE0D6C7FFF9F1
      E9FFF0E7DCFFE2D6C9FFC8B9A6FFB8A792FFAA987FFF9C8A70FF877A67FF776D
      5FFF8D8277FFBAAD9EFF6C655AFD000000009A938AFF999289FF999289FF9891
      89FF969088FF968F88FF9C958FFFA6A29DFF827F7CFF989390FFA29D9BFFA6A4
      A3FFAFACA7FF9E9B96FF99948FFF6A6663FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000006BFF2B2BC5FF2F2F
      C6FF2F2FC6FF2F2FC6FF2F2FC6FF2F2FC6FF2F2FC6FF2F2FC6FF2F2FC6FF2F2F
      C6FF3030C7FF2626C1FF00006AFF0000000000000000777064FFE8DBCBFFF9F4
      ECFFEBE6DFFFD2CBC3FFB4AB9EFFB4A99BFFBAB0A2FFC2B7AAFFC5BBAEFFBBB3
      A6FFB3ACA2FFB2AA9FFF756E65FF000000009D958BFFFEFEFEFFFEFEFEFFFEFE
      FEFFFEFEFEFF969088FFFDFDFDFFFCFCFCFFFAFAFAFFBEBCBBFF7F7B79FF7773
      70FF787370FF7B7875FF979391FF989490FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000006DFF2626BBFF2727
      B7FF2727B7FF2727B7FF2727B7FF2727B7FF2828B7FF2828B7FF2828B7FF2828
      B7FF2929B7FF2222B6FF00006AFF00000000000000007D766BFFC1BBB4FFBEB8
      B1FFCDC5BBFFDBD2C7FFC7B8A5FFB7A791FFB7A995FF0E5922FF0F5B23FF0F5C
      24FF105E25FF115F26FF827D75FF000000009E968DFFFEFEFEFFF9F1EAFFF9F3
      EBFFFEFEFEFF989189FFFEFEFEFFF9F2ECFFF8F1EBFFFCFCFCFFA5A09AFFFBFB
      FBFFF7F4EFFFF8F3F1FFFBFBFBFF95928CFF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000002026EFF2222B0FF2020
      A8FF2020A8FF2020A8FF2020A8FF2020A8FF2020A8FF2020A8FF2020A8FF2020
      A8FF2020A8FF1E1EADFF00006DFF0000000000000000807C74FDE1D5C8FFFBF4
      EEFFF3EBE1FFE8DFD4FFC7B9A6FFB8A792FFBDB09EFF0F5C24FF22A845FF28AF
      4CFF28B24DFF126128FF8F8A82FD00000000A0988DFFFEFEFEFFF9F1EAFFF9F1
      E8FFFEFEFEFF999289FFFEFEFEFFF8F1E9FFF9F1E9FFFEFEFEFF948E86FFFEFE
      FEFFFAF3EEFFFAF5EFFFFEFEFEFF8F8984FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000020270FF2424AAFF2222
      9DFF21219DFF21219DFF21219DFF21219DFF21219DFF21219DFF21219DFF2121
      9DFF22229DFF1E1EA6FF00006CFF000000000000000080796DFFE6DBCAFFFAF6
      F1FFF3EDE6FFE3DDD8FFC2B8AEFFC0B8ADFFCCC5BBFF115F26FF2BB34EFF33BB
      57FF2FBD54FF136329FF9F9C95FF00000000A2998FFFFEFEFEFFFEFEFEFFFEFE
      FEFFFEFEFEFF9A938AFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFF958F87FFFEFE
      FEFFFEFEFEFFFEFEFEFFFEFEFEFF908A84FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000006EFF2F2FA8FF3C3C
      9EFF3A3A9EFF3A3A9EFF3A3A9EFF3A3A9EFF3A3A9EFF3A3A9EFF3A3A9EFF3A3A
      9EFF3C3C9EFF2A2AA4FF00006DFF0000000000000000857E74FFBFB9B2FFC8C3
      BFFFC9C3BBFFDAD4CCFFC2B7A8FF105E25FF115F26FF126027FF37C05BFF47C9
      68FF36C65CFF15662BFF16672CFF17682DFFA49B8FFFA2998FFFA1988EFFA097
      8DFF9E968CFF9C958BFF9A938AFF999289FF989189FF979188FF968F88FF958F
      87FF948E86FF938D86FF938D86FF918B85FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000001016EFF3B3BA8FF5151
      A0FF4F4FA0FF4F4FA0FF4F4FA0FF4F4FA0FF5050A1FF5050A1FF5050A1FF5050
      A1FF5252A1FF3636A3FF00006EFF00000000000000007E7870FCDFD3C5FFFDF8
      F5FFF4EEE6FFEEE8E1FFCFC3B4FF126027FF25A045FF3EC661FF4ECE70FF59D5
      7AFF3AD061FF40D868FF37BD5AFF176A2EFFA69D91FFFEFEFEFFFEFEFEFFFEFE
      FEFFFEFEFEFF9E968CFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFF979188FFFEFE
      FEFFFEFEFEFFFEFEFEFFFEFEFEFF938D86FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000006EFE4949A8FF6D6D
      A6FF6A6AA6FF6B6BA6FF6B6BA6FF6B6BA6FF6B6BA6FF6B6BA6FF6B6BA6FF6B6B
      A6FF6E6EA7FF4545A5FF00006DFF0000000000000000867E73FFE5D8C9FFFBF8
      F3FFF2EDE7FFEDE8E2FFD7CFC2FFB0BAA5FF14642AFF40C162FF5BDA7CFF69E1
      88FF41D869FF3FD165FF196D30FF04150933A89E92FFFEFEFEFFF8F1E9FFF7ED
      E3FFFEFEFEFFA0978DFFFEFEFEFFF8EFE5FFF8EFE8FFFEFEFEFF999289FFFEFE
      FEFFF9F4EDFFFAF4EEFFFEFEFEFF938D86FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000A0A62E03535B8FF5050
      A7FF4E4EA7FF4F4FA8FF4D4DA6FF4D4DA6FF4E4EA7FF4C4CA5FF4C4CA5FF4C4C
      A5FF4E4EA5FF2E2EB1FF090962E200000000000000008D877EFEF8F3ECFFECE7
      DFFFE2DACEFFDAD0C1FFD7CBBCFFD7CDBEFFB2BDA7FF16672CFF68DF87FF79EA
      96FF44DB6CFF1A6E31FF7C8976FE00000000AAA093FFFEFEFEFFF8EFE5FFF7ED
      E3FFFEFEFEFFA1988EFFFEFEFEFFF7EDE3FFF8EEE5FFFEFEFEFF9A9389FFFEFE
      FEFFFAF2ECFFFAF4EDFFFEFEFEFF958E87FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000007071F43272782E43232
      A0FF31319FFF32329FFF30309FFF2D2D9EFF2E2E9EFF2E2E9DFF2E2E9DFF2E2E
      9DFF2F2F9EFF262680E406061F430000000000000000666665B2BCBAB7FFE4E0
      DDFFF2EBE3FFF6EDE3FFF4EBE1FFF2E9DEFFEFE7DDFFC2CEBAFF186B2FFF81F0
      9EFF1B7032FF98A48FFF5D5B53B400000000ABA195FFFEFEFEFFFEFEFEFFFEFE
      FEFFFEFEFEFFA49B8FFFFEFEFEFFFEFEFEFFFEFEFEFFFEFEFEFF9B948AFFFEFE
      FEFFFEFEFEFFFEFEFEFFFEFEFEFF968F88FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000010101022A28284B5353
      51956D6B6AC2807B77E68E8883F38F8983FA918A82FA97938CF37F8D7CEB1C71
      33FF536153AA2727244B0100000200000000ADA395FFADA295FFABA094FFA99F
      93FFA79E92FFA59C91FFA49B8FFFA2998FFFA0988DFF9E968DFF9D958BFF9B94
      8AFF9A9389FF999289FF989189FF979188FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000008651FFF0868
      20FF086520FF0000000000000000000000000000000000000001000000070000
      000E00000017000000200000002A000000320000002F000000270000001E0000
      00150000000C0000000600000000000000000000000000000000000000000000
      000000000000000000000000000000000001726B62E578726CD5403E3B720303
      030800000000000000000000000000000000000000000C0600352A1A02D92E1C
      03FD1B0F02B60602002600000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007B756FD39E96
      8EFE928B84F2635E59B522221F3E00000000000000000000000008661FFF09C9
      3BFF086820FF00000000000000000000000000000000000000040000000E0000
      114200002476000000290000002E00000031000000310000002E000000290000
      57EC000000180000000E00000004000000000000000000000000000000000000
      000000000000000000000000000000000000696359D7E8DFD5FFB6ADA2FF7B76
      70D912111021000000000000000000000000000000003B2202D99D651CFFDE95
      39FF794D12FF2B1A03F7140C0180010000070000000000000000000000000000
      0000000000000000000000000000000000000000000000000000524E4A8FC9BF
      B5FFFBF0E5FFE4DBD0FFACA39CFC504C4981222120341515141E08661FFF09C9
      3BFF086820FF0000000000000000000000000000000000000000000015380000
      5FFF00005FFF00002A720000000000000000000000000000000000005CF70000
      6CFF00005DFA0000000000000000000000000000000000000000000000000000
      00022825234D534F4A9D6D655DDB7B756AEB827B71F8E4DBD1FFF2E8DDFFDDD3
      C8FF7C7770DD0504040B0000000000000000000000004E2D03FED89036FFFEC6
      74FFFEB95DFFBE7C2BFF503108FF1F1403D90B06004300000000000000000000
      0000000000000000000000000000000000000000000000000000151413299B93
      89FFF4E9DEFFF7EDE3FFF6EFE7FF216333FF17632AFF17632AFF096620FF09C7
      3AFF086A20FF086920FF086920FF08631EFF000000000000184200005FFF0000
      A2FF0000A3FF00005FFF00003082000000000000000000005EFB00007EFF0000
      A3FF000081FF00005EFC000000000000000000000000000000001C1B1939716B
      61D8A49B8EFFCCC3B9FFECE2D8FFF0E7DDFFF3EAE1FFF5ECE2FFF6ECE2FFEFE5
      D9FFB7ADA3FF3C3936700000000000000000000000004D2C03FFC98730FFF7B7
      6CFFF5B568FFF6B260FFE29C42FF8D5A17FF362104FE180E02A4030200170000
      0000000000000000000000000000000000000000000025221F42878078F0DCD3
      C8FFF8EDE2FFF8EEE4FFF5EEE6FF29683AFF8BE3A3FF72DE90FF4AD471FF21C9
      4CFF09C73AFF09C73AFF09C73AFF09611FFF00001E5000005FFF0000A3FF0000
      A3FF0000A3FF0000A3FF000060FF0000369200005EFD000081FF0000A3FF0000
      A3FF0000A3FF000082FF00005FFE0000000000000000272522518E857CFADAD0
      C4FFE7DCD0FFE9DDD2FFDED2C5FFE2D6CAFFE4D7CBFFE4D9CDFFEDE2D6FFF5EA
      E0FFE3D9CEFF837B70F11B19173900000000000000004D2D03FFC07F2DFFE5A9
      5CFFE1A359FFE1A255FFE0A054FFE19D49FFBD7D2CFF643E0CFF271804EE110A
      01680000000200000000000000000000000012110F25867E75F2E9DFD3FFF0E6
      DAFFF5EAE0FFF7EDE2FFF5EDE4FF316C41FF2B6D3BFF2B6D3BFF246F38FF52D8
      78FF0F6825FF0A611FFF0A611FFF0A5E1FFF0000030900005FFF000096FF0000
      A3FF0000A3FF0000A3FF0000A3FF000061FF000084FF0000A3FF0000A3FF0000
      A3FF0000A3FF000068FF00004DCF00000000100F0D23857B70F5DACFC2FFDED2
      C4FFE2D7C9FFE1D3C3FFAD7933FFB27523FFB27523FFB0792EFFE1CEB7FFF2E8
      DDFFECE2D6FFDAD0C4FF7A7267EB09090816000000004E2D03FFB77B29FFD197
      4EFFCE9248FFCE8F45FFCB8D42FFCA8C40FFCB8C3DFFC68634FF97611AFF462B
      07FF1F1103C70804002F00000000000000004C4740A4CEC2B4FFE3D7C9FFEBE0
      D3FFE4D9CEFFA99F98FFB3AAA4FFC8C2BDFFCDC8C3FFD0CAC7FF306F41FF7BE1
      99FF246935FFE7E1D8FFC3BEB7FE2F2D2B53000000000000020600005FFF0000
      94FF0000A3FF0000A3FF0000A3FF0000A3FF0000A3FF0000A3FF0000A3FF0000
      A3FF000066FF00004AC600000000000000004C463EA6C1B5A7FFD6C9B9FFDACE
      BFFFE0D4C5FFE4D9CBFFE5D9CBFFA1681CFFA76C1EFFE9DBCAFFF0E5DAFFEDE3
      D7FFE8DDD1FFE0D4C6FFBCB1A3FF46413999000000004F2D03FFAF7326FFBD84
      3CFFB98238FFB87E36FFB67C34FFB57A31FFB37A2FFFB4782EFFB3762BFFAB6F
      23FF754910FF321F05FA100A0062000000007C7166F0D9CCBBFFDDD0C1FFE4D8
      CAFFE2D7CAFFE2D7CBFFE4D9CDFFE2D9CBFFE2D6CBFFE4DCD3FF306F41FF92E5
      ABFF246935FFDAD1C5FFD3C7B6FF5A544BC40000000000000000000001030000
      5FFF000090FF0000A3FF0000A3FF0000A3FF0000A3FF0000A3FF0000A3FF0000
      64FF000046BC00000000000000000000000070685CE7CEC1B0FFD0C3B2FFD6C9
      B9FFDBCFBFFFE0D4C5FFE1D4C6FF97621DFF9D6720FFE6D6C6FFE9DED2FFE7DC
      CFFFE2D6C9FFDBCEBFFFD0C3B3FF6D6459E700000000502E04FFA66D22FFA66F
      2CFFA56D2AFFA36B27FFA16A26FFA06824FF9E6723FF9D6622FF9C6520FF9B64
      1FFF9C641EFF8C5914FF271704EC00000000847B6EFED2C5B4FFD4C7B6FFDBCE
      BFFFDACEC0FF9C9289FFACA197FFA99E94FFA3968EFFBAB1ACFF377147FF336F
      43FF306C40FFD4C8BAFFCEC1AFFF7F7469F90000000000000000000000000000
      000200005FFF00009EFF0000A3FF0000A3FF0000A3FF0000A3FF000067FF0000
      58EC00000000000000000000000000000000776D5EFACABDACFFCBBDAAFFD0C2
      B1FFD5C8B8FFD8CCBCFFD2C5B7FF916225FF97682AFFE1D2C1FFE1D5C7FFDFD3
      C4FFDACEBEFFD3C6B6FFCBBEACFF766C5DFE00000000503004FF9D6620FF915E
      21FF905D20FF8F5C1DFF8E5A1CFF8C581AFF8C5819FF8E5B1EFF906124FF956A
      31FF9C723DFF92601DFF311E04F000000000696054E4D3C7B7FFD5CABBFFD3C6
      B6FFCCC0AFFFCBBFB0FFCDC1B3FFCDC1B3FFCDC1B2FFD0C4B7FFD1C7BAFFD4CA
      BDFFD2C7B8FFCDC1B0FFD4C9B9FF7E7364FC0000000000000000000000021212
      6BFF4343ADFF3D3DB9FF2727B1FF0909A7FF0000A3FF0000A3FF0000A3FF0000
      64FF000046BC000000000000000000000000655D50E4CABEADFFCFC3B3FFCCBE
      ADFFCDBFAEFFCCBDABFF886332FF906A39FF906A38FFD9C9B7FFD8CBBBFFD5C8
      B8FFD2C4B4FFD2C6B6FFCDC1B1FF6D6454F400000000523004FF986420FF875C
      26FF895E29FF8A602CFF8D6432FF916A39FF967244FF9A774BFF9C7D55FF9670
      3EFF875514FF543305FD1B10016F000000003B352E8FAEA190FFD9CFC3FFDAD2
      C6FFD8CEC1FFA89D93FFA89C90FF9E9185FFA4988BFF9F9286FFA19589FFCEC2
      B3FFD4CABCFFD6CCC0FFCEC2B1FF574E44CD000000000000010517176EFF4C4C
      B3FF4545BCFF3F3FBAFF3737B7FF3131B5FF2A2AB2FF2323B0FF1C1CADFF1414
      AAFF0B0B6DFF00004AC600000000000000004039329BACA08FFFD2C8BBFFD6CC
      BFFFD5CBBDFFD3C8B9FFD1C5B6FFC2A989FFC2A682FFD0C3B2FFD5CABBFFD7CD
      BFFFD9D0C3FFD6CCBFFFB7AB9AFF4A4339B500000000513003FF966628FF8663
      39FF89683EFF8C6C44FF8F714AFF937751FF977C5BFF957854FF906123FF6E42
      09FF3C2403D4120A013E00000000000000000706061463594BE7CABFAEFFDDD4
      CAFFD9D1C7FFDAD2C9FFDCD4CAFFDCD6CBFFDCD4CBFFDBD3CAFFDAD2C8FFDAD2
      C7FFD9D2C6FFDED5C8FF928675FF28241F61000002071D1D72FF5454B7FF4E4E
      BFFF4747BDFF4040BAFF3939B8FF2F2F7EFF2B2B9AFF2525B1FF1E1EAEFF1717
      ACFF1010A9FF09096EFF00004DCF00000000090807196A6151EEC6BCADFFD7CE
      C3FFD9D1C6FFDBD3C8FFD1C2B0FF9D6822FF9E6A24FFD0BCA3FFDDD5CBFFDCD4
      C9FFD9D1C6FFCEC4B6FF796D5EFB14120F33000000005C3809FF94682FFF876D
      4EFF8B7252FF8F7758FF967E61FF968167FF916B3AFF81500EFF4D2D03F32114
      0175010000050000000000000000000000000000000016141134625749EBBBB0
      A0FFE5DED5FFE2DBD2FFE1DBD1FFE1DAD1FFE1D9D1FFE0DAD0FFE0D9D0FFE1DA
      D1FFE2DBD0FF9A8E7DFF453D32A800000001242476FF5D5DBCFF5656C2FF4F4F
      C0FF4848BDFF4242BBFF353581FF00002E7C030361FC262694FF1F1FAEFF1919
      ACFF1212AAFF0B0BA7FF04046DFF000050D700000000191613436E6353F4BEB4
      A6FFDCD5CBFFDDD6CCFFDED6CDFFA67F4FFFA47C4AFFD7CDC1FFDED7CEFFDDD6
      CCFFCAC0B3FF7E7161FE29251F6B000000000000000082561DFF936B38FF8D7B
      62FF938168FF988873FF8D7555FF8F5D1BFF633B06FE311C02AD0805001D0000
      00000000000000000000000000000000000000000000000000000D0C0A204840
      33B8807462FEBAB0A2FFE0D8CDFFEBE6E0FFECE7E0FFECE7DFFFDDD5CAFFB3A9
      99FF726552FA362F27870101010400000000000040AC5B5B9AFF5757C2FF5151
      C0FF4A4ABEFF3A3A84FF00002A70000000000000000002025FF921218DFF1A1A
      ADFF1313AAFF0C0C9FFF020261FF000006100000000000000000110F0C2F5046
      3ACE8A7F6EFFBCB2A5FFD8D1C6FFE1DBD3FFE2DCD4FFDBD4CAFFC6BCAFFF978C
      7BFF5F5444E81E1B1652000000000000000000000000A5712CFE947040FF9B8F
      80FF928472FF926730FF7A4A0BFF3E2401DC160D004A00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000015120F37332B23934B4032D1605442F46C5F4DFF5F5440F2473D31CB2F28
      20860B0B09210000000000000000000000000000000000003B9E545495FF5252
      C1FF404088FF0000256500000000000000000000000000000000010160FF1C1C
      87FF1515A0FF040462FF0000040C000000000000000000000000000000000000
      00011B18134C3B3429A355493BDC675A47F9695C4AFD5C5040E7423A2EB72520
      1A680302020B00000000000000000000000000000000825925D7B87D31FF9674
      46FFA76D21FF603B0BF724150182020100090000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000036903E3E
      86FF0000225B0000000000000000000000000000000000000000000000000000
      5AF0070764FF0000030800000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000001D140735845925D9A973
      2FFD5F4119B6100A032600000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF00FFFFC003000000008001800100000000
      8001800100000000800180010000000080018001000000008001800100000000
      8001800100000000800180010000000080018001000000008001800100000000
      8001800000000000800180000000000080018000000000008001800100000000
      8001800100000000FFFF800100000000FFC70000FE0F83FFC1C70000FF0780FF
      C0070000E003807FC0000000C003801F80000000800180070000000000008003
      0000000000008001000000000000800100000000000080010000000000008001
      00000000000080030000000000008007800000008001801FC0010000C003807F
      F0070000E00780FFFFFF0000FFFF83FF00000000000000000000000000000000
      000000000000}
  end
  object actlstNOt: TActionList
    Images = Icons
    Left = 64
    Top = 304
    object CloseApplication: TAction
      Caption = '&Exit'
      ImageIndex = 1
      OnExecute = CloseApplicationExecute
    end
    object AboutApplication: TAction
      Caption = 'About...'
      ImageIndex = 2
    end
  end
  object TetheringManager1: TTetheringManager
    Password = '1234'
    Text = 'TetheringManager1'
    AllowedAdapters = 'Network'
    Left = 96
    Top = 304
  end
  object TetheringAppProfile1: TTetheringAppProfile
    Manager = TetheringManager1
    Text = 'Scoreboard1'
    Group = 'Game'
    Actions = <
      item
        Name = 'actGetScores'
        IsPublic = True
        Action = actGetScores
        NotifyUpdates = False
      end>
    Resources = <
      item
        Name = 'Scoreboard'
        IsPublic = True
      end>
    OnResourceReceived = TetheringAppProfile1ResourceReceived
    Left = 104
    Top = 280
  end
  object ActionList1: TActionList
    Left = 112
    Top = 256
    object actGetScores: TAction
      Caption = 'actGetScores'
      OnExecute = actGetScoresExecute
    end
  end
  object Timer1: TTimer
    Interval = 3000
    OnTimer = Timer1Timer
    Left = 76
    Top = 163
  end
  object SevenZip1: TipzSevenZip
    Left = 172
    Top = 251
  end
  object Zip1: TipzZip
    Left = 148
    Top = 227
  end
  object fctAdmin: TRtcFunctionGroup
    Left = 99
    Top = 216
  end
  object fctGetFilename: TRtcFunction
    Group = fctAdmin
    FunctionName = 'GetFilename'
    OnExecute = fctGetFilenameExecute
    Left = 232
    Top = 224
  end
  object RtcServerModule1: TRtcServerModule
    Link = RtcDataServerLink1
    ModuleFileName = '/mytest'
    FunctionGroup = fctAdmin
    Left = 200
    Top = 128
  end
  object RtcDataServerLink1: TRtcDataServerLink
    Server = Server
    Left = 240
    Top = 296
  end
  object RtcFunctionGroup1: TRtcFunctionGroup
    Left = 131
    Top = 112
  end
  object fctGetUploadDone: TRtcFunction
    Group = fctAdmin
    FunctionName = 'GetUploadDone'
    OnExecute = fctGetUploadDoneExecute
    Left = 240
    Top = 184
  end
end