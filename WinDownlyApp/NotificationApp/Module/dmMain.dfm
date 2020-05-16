object dataMain: TdataMain
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 426
  Width = 481
  object TetheringManager1: TTetheringManager
    OnRequestManagerPassword = TetheringManager1RequestManagerPassword
    Password = 'ClientPassword'
    Text = 'TetheringManagerClient'
    Enabled = False
    AllowedAdapters = 'Network'
    Left = 96
    Top = 192
  end
  object TetheringAppProfile1: TTetheringAppProfile
    Manager = TetheringManager1
    Text = 'TetheringAppProfile1'
    Group = 'Game'
    Enabled = False
    Actions = <
      item
        Name = 'actGetScores'
        IsPublic = True
        Kind = Mirror
        Action = actGetScores
        NotifyUpdates = False
      end>
    Resources = <
      item
        Name = 'Scoreboard'
        IsPublic = True
        Kind = Mirror
        OnResourceReceived = TetheringAppProfile1ResourceReceived
      end>
    OnResourceReceived = TetheringAppProfile1ResourceReceived
    Left = 24
    Top = 176
  end
  object ActionList1: TActionList
    Left = 48
    Top = 32
    object actGetScores: TAction
      Text = 'actGetScores'
    end
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'FMX'
    Left = 256
    Top = 48
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 184
    Top = 120
  end
  object ConnectionMain: TFDConnection
    Params.Strings = (
      'DriverID=SQLite')
    LoginPrompt = False
    BeforeConnect = ConnectionMainBeforeConnect
    Left = 152
    Top = 40
  end
  object FDManager1: TFDManager
    SilentMode = True
    FormatOptions.AssignedValues = [fvMapRules]
    FormatOptions.OwnMapRules = True
    FormatOptions.MapRules = <>
    Active = True
    Left = 184
    Top = 184
  end
  object ConnectionSetting: TFDConnection
    Params.Strings = (
      'DriverID=SQLite'
      'Encrypt=No'
      
        'Database=C:\ProgIDE\Projekt\SoftProject\Delphi\WinDownly\WinDown' +
        'lyApp\BIN\SettingDB.sqb')
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    LoginPrompt = False
    AfterConnect = ConnectionSettingAfterConnect
    BeforeConnect = ConnectionSettingBeforeConnect
    Left = 56
    Top = 96
  end
  object FDSQLiteSecurity1: TFDSQLiteSecurity
    Left = 376
    Top = 80
  end
  object mtblConnection: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'Id'
        DataType = ftInteger
      end
      item
        Name = 'Methode'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'User'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'Password'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'IPAddress'
        DataType = ftWideString
        Size = 255
      end
      item
        Name = 'Port'
        DataType = ftInteger
      end
      item
        Name = 'MethodeIndex'
        DataType = ftInteger
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvPersistent, rvSilentMode]
    ResourceOptions.Persistent = True
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 264
    Top = 216
    Content = {
      414442530F0030580C030000FF00010001FF02FF0304001C0000006D00740062
      006C0043006F006E006E0065006300740069006F006E0005000A000000540061
      0062006C006500060000000000070000080032000000090000FF0AFF0B040004
      00000049006400050004000000490064000C00010000000E000D000F00011000
      0111000112000113000114000115000400000049006400FEFF0B04000E000000
      4D006500740068006F006400650005000E0000004D006500740068006F006400
      65000C00020000000E0016001700FF0000000F00011000011100011200011300
      0114000115000E0000004D006500740068006F00640065001800FF000000FEFF
      0B040008000000550073006500720005000800000055007300650072000C0003
      0000000E0016001700FF0000000F000110000111000112000113000114000115
      000800000055007300650072001800FF000000FEFF0B04001000000050006100
      7300730077006F0072006400050010000000500061007300730077006F007200
      64000C00040000000E0016001700FF0000000F00011000011100011200011300
      01140001150010000000500061007300730077006F00720064001800FF000000
      FEFF0B0400120000004900500041006400640072006500730073000500120000
      004900500041006400640072006500730073000C00050000000E0016001700FF
      0000000F00011000011100011200011300011400011500120000004900500041
      006400640072006500730073001800FF000000FEFF0B04000800000050006F00
      7200740005000800000050006F00720074000C00060000000E000D000F000110
      000111000112000113000114000115000800000050006F0072007400FEFF0B04
      00180000004D006500740068006F006400650049006E00640065007800050018
      0000004D006500740068006F006400650049006E006400650078000C00070000
      000E000D000F00011000011100011200011300011400011500180000004D0065
      00740068006F006400650049006E00640065007800FEFEFF19FEFF1AFEFF1BFE
      FEFEFF1CFEFF1DFF1EFEFEFE0E004D0061006E0061006700650072001E005500
      7000640061007400650073005200650067006900730074007200790012005400
      610062006C0065004C006900730074000A005400610062006C00650008004E00
      61006D006500140053006F0075007200630065004E0061006D0065000A005400
      6100620049004400240045006E0066006F0072006300650043006F006E007300
      74007200610069006E00740073001E004D0069006E0069006D0075006D004300
      6100700061006300690074007900180043006800650063006B004E006F007400
      4E0075006C006C00140043006F006C0075006D006E004C006900730074000C00
      43006F006C0075006D006E00100053006F007500720063006500490044000E00
      6400740049006E00740033003200100044006100740061005400790070006500
      1400530065006100720063006800610062006C006500120041006C006C006F00
      77004E0075006C006C000800420061007300650014004F0041006C006C006F00
      77004E0075006C006C0012004F0049006E005500700064006100740065001000
      4F0049006E00570068006500720065001A004F0072006900670069006E004300
      6F006C004E0061006D0065001800640074005700690064006500530074007200
      69006E0067000800530069007A006500140053006F0075007200630065005300
      69007A0065001C0043006F006E00730074007200610069006E0074004C006900
      73007400100056006900650077004C006900730074000E0052006F0077004C00
      6900730074001800520065006C006100740069006F006E004C00690073007400
      1C0055007000640061007400650073004A006F00750072006E0061006C000E00
      4300680061006E00670065007300}
  end
  object tblConnection: TFDTable
    Connection = ConnectionSetting
    UpdateOptions.UpdateTableName = 'CONNECTION'
    TableName = 'CONNECTION'
    Left = 204
    Top = 232
    object tblConnectionID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
    end
    object tblConnectionMETHODE: TWideStringField
      FieldName = 'METHODE'
      Origin = 'METHODE'
      Size = 255
    end
    object tblConnectionUSER: TWideStringField
      FieldName = 'USER'
      Origin = 'USER'
      Size = 255
    end
    object tblConnectionPASSWORD: TWideStringField
      FieldName = 'PASSWORD'
      Origin = 'PASSWORD'
      Size = 255
    end
    object tblConnectionIPADDRESS: TWideStringField
      FieldName = 'IPADDRESS'
      Origin = 'IPADDRESS'
      Size = 255
    end
    object tblConnectionPORT: TIntegerField
      FieldName = 'PORT'
      Origin = 'PORT'
    end
    object tblConnectionMETHODEINDEX: TIntegerField
      FieldName = 'METHODEINDEX'
      Origin = 'METHODEINDEX'
    end
  end
end
