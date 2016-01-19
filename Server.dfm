object Schiedsrichter: TSchiedsrichter
  Left = 0
  Top = 0
  AutoSize = True
  Caption = 'Schiedsrichter'
  ClientHeight = 507
  ClientWidth = 705
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Padding.Left = 10
  Padding.Top = 10
  Padding.Right = 10
  Padding.Bottom = 10
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    705
    507)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 13
    Top = 81
    Width = 193
    Height = 54
    Caption = 'Team Rot'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -45
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Image_Kamerabild: TImage
    Left = 13
    Top = 227
    Width = 495
    Height = 270
  end
  object Label2: TLabel
    Left = 475
    Top = 81
    Width = 212
    Height = 54
    Caption = 'Team Blau'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -45
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label_Punkte: TLabel
    Left = 295
    Top = 81
    Width = 94
    Height = 54
    Alignment = taCenter
    Caption = '0 - 0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -45
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 514
    Top = 227
    Width = 107
    Height = 23
    Caption = 'Roboter Rot:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel
    Left = 514
    Top = 371
    Width = 115
    Height = 23
    Caption = 'Roboter Blau:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label_Zeit: TLabel
    Left = 295
    Top = 153
    Width = 116
    Height = 54
    Anchors = [akTop]
    Caption = '00:00'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -45
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object LB_Roboter_Rot: TListBox
    Left = 514
    Top = 256
    Width = 176
    Height = 97
    ItemHeight = 13
    TabOrder = 0
  end
  object LB_Roboter_Blau: TListBox
    Left = 514
    Top = 400
    Width = 168
    Height = 97
    ItemHeight = 13
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 10
    Top = 10
    Width = 685
    Height = 65
    Margins.Right = 0
    BevelOuter = bvLowered
    TabOrder = 2
    DesignSize = (
      685
      65)
    object Label9: TLabel
      Left = 373
      Top = 14
      Width = 79
      Height = 33
      Caption = 'Bereit:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -27
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Shape_Bereit_Rot: TShape
      Left = 457
      Top = 10
      Width = 65
      Height = 20
    end
    object Shape_Bereit_Blau: TShape
      Left = 457
      Top = 36
      Width = 65
      Height = 20
    end
    object Label3: TLabel
      Left = 231
      Top = 6
      Width = 96
      Height = 23
      Caption = 'Spieldauer:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Button_Start: TButton
      Left = 529
      Top = 7
      Width = 148
      Height = 49
      Anchors = [akTop, akRight]
      Caption = 'Start'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -27
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object Button_Kamera_kalibrieren: TButton
      Left = 7
      Top = 8
      Width = 189
      Height = 49
      Anchors = [akTop, akRight]
      Caption = 'Kamera kalibrieren'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object DTPicker_Spieldauer: TDateTimePicker
      Left = 231
      Top = 35
      Width = 98
      Height = 21
      Date = 42371.020833333340000000
      Time = 42371.020833333340000000
      Kind = dtkTime
      ParentShowHint = False
      ShowHint = False
      TabOrder = 2
    end
  end
  object Server: TIdTCPServer
    Active = True
    Bindings = <>
    DefaultPort = 12345
    MaxConnections = 2
    OnConnect = ServerConnect
    OnExecute = ServerExecute
    Left = 552
    Top = 168
  end
end
