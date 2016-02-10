object fmHauptForm: TfmHauptForm
  Left = 686
  Top = 309
  Caption = 'USB-Kamera - Darstellung und Farberkennung V1.3, (c) FH M'#252'nster'
  ClientHeight = 490
  ClientWidth = 1234
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -10
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object imAusgabe: TImage
    Left = 524
    Top = 96
    Width = 480
    Height = 360
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Proportional = True
    Stretch = True
    OnMouseDown = imAusgabeMouseDown
  end
  object laInformationen: TLabel
    Left = 629
    Top = 25
    Width = 12
    Height = 12
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = '---'
    Visible = False
  end
  object Label2: TLabel
    Left = 168
    Top = 6
    Width = 41
    Height = 12
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'd Punkte'
  end
  object Label3: TLabel
    Left = 425
    Top = 10
    Width = 61
    Height = 12
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Farbe Team 1'
  end
  object Label4: TLabel
    Left = 528
    Top = 6
    Width = 37
    Height = 12
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Intervall'
  end
  object laStatus: TLabel
    Left = 629
    Top = 6
    Width = 12
    Height = 12
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = '---'
    Visible = False
  end
  object Label1: TLabel
    Left = 228
    Top = 6
    Width = 66
    Height = 12
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Pixel p. Objekt'
  end
  object Label5: TLabel
    Left = 306
    Top = 6
    Width = 104
    Height = 12
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Max. Abstand Pix.-Obj.'
  end
  object Label6: TLabel
    Left = 582
    Top = 6
    Width = 28
    Height = 12
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'O-Bild'
  end
  object laObjPos: TLabel
    Left = 629
    Top = 41
    Width = 12
    Height = 12
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = '---'
    Visible = False
  end
  object Label7: TLabel
    Left = 425
    Top = 36
    Width = 61
    Height = 12
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Farbe Team 2'
  end
  object Label8: TLabel
    Left = 420
    Top = 62
    Width = 66
    Height = 12
    Caption = 'Farbe Spielfeld'
  end
  object seDPixel: TSpinEdit
    Left = 168
    Top = 23
    Width = 31
    Height = 21
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Enabled = False
    MaxValue = 9
    MinValue = 1
    TabOrder = 0
    Value = 2
    OnChange = seDPixelChange
  end
  object seDFarbe1: TSpinEdit
    Left = 491
    Top = 7
    Width = 33
    Height = 21
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Enabled = False
    Increment = 5
    MaxValue = 255
    MinValue = 0
    TabOrder = 1
    Value = 40
    OnChange = seDFarbe1Change
  end
  object btKameraStart: TButton
    Left = 30
    Top = 8
    Width = 97
    Height = 19
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Kamera starten'
    TabOrder = 2
    OnClick = btKameraStartClick
  end
  object Panel1: TPanel
    Left = 30
    Top = 96
    Width = 480
    Height = 360
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    DoubleBuffered = False
    ParentDoubleBuffered = False
    TabOrder = 3
  end
  object btAuswertungStarten: TButton
    Left = 30
    Top = 32
    Width = 97
    Height = 18
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Auswertung starten'
    Enabled = False
    TabOrder = 4
    OnClick = btAuswertungStartenClick
  end
  object edIntervall: TEdit
    Left = 528
    Top = 23
    Width = 35
    Height = 20
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    TabOrder = 5
    Text = '200'
    OnChange = edIntervallChange
  end
  object seMaxAbstand: TSpinEdit
    Left = 306
    Top = 23
    Width = 43
    Height = 21
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Enabled = False
    Increment = 5
    MaxValue = 200
    MinValue = 3
    TabOrder = 6
    Value = 20
    OnChange = seMaxAbstandChange
  end
  object cbOBild: TCheckBox
    Left = 582
    Top = 23
    Width = 26
    Height = 12
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    TabOrder = 7
    OnClick = cbOBildClick
  end
  object sePixPerObjekt: TSpinEdit
    Left = 228
    Top = 23
    Width = 43
    Height = 21
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Enabled = False
    Increment = 10
    MaxValue = 5000
    MinValue = 0
    TabOrder = 8
    Value = 100
    OnChange = sePixPerObjektChange
  end
  object btTreiber: TButton
    Left = 228
    Top = 57
    Width = 97
    Height = 19
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Treibername+Ver.'
    TabOrder = 9
    Visible = False
    OnClick = btTreiberClick
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 471
    Width = 1234
    Height = 19
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Panels = <
      item
        Width = 700
      end
      item
        Width = 50
      end>
  end
  object cbFS1: TCheckBox
    Left = 558
    Top = 69
    Width = 67
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'TEAM 1'
    Checked = True
    Enabled = False
    State = cbChecked
    TabOrder = 11
    OnClick = cbFS1Click
  end
  object cbFS2: TCheckBox
    Left = 647
    Top = 69
    Width = 66
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'TEAM 2'
    Checked = True
    Enabled = False
    State = cbChecked
    TabOrder = 12
    OnClick = cbFS2Click
  end
  object cbFS3: TCheckBox
    Left = 752
    Top = 69
    Width = 61
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Spielfeld'
    Checked = True
    Enabled = False
    State = cbChecked
    TabOrder = 13
    OnClick = cbFS3Click
  end
  object cbPixel: TCheckBox
    Left = 582
    Top = 41
    Width = 43
    Height = 13
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Pixel'
    Checked = True
    State = cbChecked
    TabOrder = 14
    OnClick = cbPixelClick
  end
  object seDFarbe2: TSpinEdit
    Left = 491
    Top = 32
    Width = 33
    Height = 21
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Enabled = False
    Increment = 5
    MaxValue = 255
    MinValue = 0
    TabOrder = 15
    Value = 40
    OnChange = seDFarbe2Change
  end
  object StatusBox: TListBox
    Left = 1024
    Top = 96
    Width = 202
    Height = 360
    ItemHeight = 12
    TabOrder = 16
  end
  object seDFarbe3: TSpinEdit
    Left = 491
    Top = 56
    Width = 33
    Height = 21
    Enabled = False
    Increment = 5
    MaxValue = 255
    MinValue = 0
    TabOrder = 17
    Value = 40
    OnChange = seDFarbe3Change
  end
  object Button1: TButton
    Left = 30
    Top = 56
    Width = 97
    Height = 18
    Caption = 'Spielfeld Kalibrieren'
    TabOrder = 18
    OnClick = Button1Click
  end
  object Panel2: TPanel
    Left = 656
    Top = 6
    Width = 573
    Height = 56
    Margins.Right = 0
    BevelOuter = bvLowered
    TabOrder = 19
    DesignSize = (
      573
      56)
    object Shape_Bereit_Rot: TShape
      Left = 208
      Top = 19
      Width = 65
      Height = 20
    end
    object Shape_Bereit_Blau: TShape
      Left = 386
      Top = 19
      Width = 65
      Height = 20
    end
    object Label10: TLabel
      Left = 17
      Top = 4
      Width = 80
      Height = 19
      Caption = 'Spieldauer:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label_Zeit: TLabel
      Left = 111
      Top = 12
      Width = 70
      Height = 33
      Caption = '00:00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -27
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label_Punkte: TLabel
      Left = 287
      Top = 4
      Width = 85
      Height = 48
      Alignment = taCenter
      Caption = '0 - 0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -40
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Button_Start: TButton
      Left = 472
      Top = 12
      Width = 93
      Height = 31
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
    object DTPicker_Spieldauer: TDateTimePicker
      Left = 19
      Top = 29
      Width = 70
      Height = 21
      Date = 42371.020833333340000000
      Time = 42371.020833333340000000
      Kind = dtkTime
      ParentShowHint = False
      ShowHint = False
      TabOrder = 1
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = Timer1Timer
    Left = 792
    Top = 224
  end
  object MainMenu1: TMainMenu
    Left = 600
    Top = 184
    object Datei1: TMenuItem
      Caption = 'Datei'
      object Einstellungenladen1: TMenuItem
        Caption = 'Einstellungen Laden'
        Enabled = False
        Hint = #214'ffnen|Vorhandene Datei '#246'ffnen'
        ImageIndex = 7
        OnClick = Einstellungenladen1Click
      end
      object Einstellungenspeichern1: TMenuItem
        Caption = 'Einstellungen Speichern'
        Enabled = False
        Hint = 'Speichern unter|Aktive Datei unter einem neuen Namen speichern'
        ImageIndex = 30
        OnClick = Einstellungenspeichern1Click
      end
      object Schlieen1: TMenuItem
        Action = FileExit1
        Caption = '&Schlie'#223'en'
      end
    end
    object Einstellungen1: TMenuItem
      Caption = 'Einstellungen'
      object BildEinstellungen1: TMenuItem
        Caption = 'Bild-Einstellungen'
        ShortCut = 112
        OnClick = BildEinstellungen1Click
      end
      object FormatEinstellungen1: TMenuItem
        Caption = 'Format-Einstellungen'
        ShortCut = 113
        OnClick = FormatEinstellungen1Click
      end
    end
  end
  object ActionList1: TActionList
    Left = 600
    Top = 264
    object FileExit1: TFileExit
      Category = 'Datei'
      Caption = '&Beenden'
      Hint = 'Beenden|Anwendung beenden'
      ImageIndex = 43
    end
    object Action2: TAction
      Category = 'Datei'
      Caption = 'Action2'
    end
  end
  object Server: TIdTCPServer
    Active = True
    Bindings = <>
    DefaultPort = 12345
    MaxConnections = 2
    OnConnect = ServerConnect
    OnExecute = ServerExecute
    Left = 878
    Top = 221
  end
end
