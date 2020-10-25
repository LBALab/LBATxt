object PrevForm: TPrevForm
  Left = 200
  Top = 103
  AutoScroll = False
  Caption = 'Preview selected text'
  ClientHeight = 88
  ClientWidth = 589
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  OnCreate = FormCreate
  OnResize = FormResize
  DesignSize = (
    589
    88)
  PixelsPerInch = 96
  TextHeight = 13
  object btLockTop: TSpeedButton
    Left = 0
    Top = 66
    Width = 93
    Height = 22
    AllowAllUp = True
    Anchors = [akLeft, akBottom]
    GroupIndex = 1
    Caption = 'Lock at top'
    Layout = blGlyphTop
    Margin = 2
    Spacing = 0
    Transparent = False
    OnClick = btLockBtmClick
  end
  object btLockBtm: TSpeedButton
    Left = 93
    Top = 66
    Width = 92
    Height = 22
    AllowAllUp = True
    Anchors = [akLeft, akBottom]
    GroupIndex = 1
    Caption = 'Lock at bottom'
    Layout = blGlyphTop
    Margin = 2
    Spacing = 0
    Transparent = False
    OnClick = btLockBtmClick
  end
  object btLoad: TSpeedButton
    Left = 297
    Top = 66
    Width = 104
    Height = 22
    Anchors = [akLeft, akBottom]
    Caption = 'Load font from file'
    Layout = blGlyphTop
    Margin = 2
    Spacing = 0
    Transparent = False
    OnClick = btLoadClick
  end
  object btFont2: TSpeedButton
    Left = 192
    Top = 66
    Width = 105
    Height = 22
    Hint = 
      'LBA 1 font has just less defined characters, so its useless to p' +
      'ut it here'
    Anchors = [akLeft, akBottom]
    Caption = 'Default LBA 2 font'
    Layout = blGlyphTop
    Margin = 2
    ParentShowHint = False
    ShowHint = True
    Spacing = 0
    Transparent = False
    OnClick = btFont2Click
  end
  object btClose: TSpeedButton
    Left = 532
    Top = 66
    Width = 57
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = 'Close'
    Layout = blGlyphTop
    Margin = 2
    Spacing = 0
    Transparent = False
    OnClick = btCloseClick
  end
  object btOptions: TSpeedButton
    Left = 416
    Top = 66
    Width = 105
    Height = 22
    AllowAllUp = True
    Anchors = [akRight, akBottom]
    GroupIndex = 2
    Caption = 'Options'
    Layout = blGlyphTop
    Margin = 2
    Spacing = 0
    Transparent = False
    OnClick = btOptionsClick
  end
  object PanelMain: TPanel
    Left = 0
    Top = 0
    Width = 589
    Height = 64
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    Constraints.MinHeight = 50
    Constraints.MinWidth = 10
    FullRepaint = False
    TabOrder = 0
    DesignSize = (
      589
      64)
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 589
      Height = 64
      Anchors = [akLeft, akRight, akBottom]
      BevelInner = bvLowered
      Constraints.MinHeight = 1
      Constraints.MinWidth = 1
      UseDockManager = False
      FullRepaint = False
      TabOrder = 0
      object Label2: TLabel
        Left = 248
        Top = 8
        Width = 56
        Height = 13
        Caption = 'Font colour:'
      end
      object Label3: TLabel
        Left = 416
        Top = 8
        Width = 93
        Height = 13
        Caption = 'Background colour:'
      end
      object cFont: TColorBox
        Left = 248
        Top = 24
        Width = 145
        Height = 22
        AutoDropDown = True
        NoneColorColor = clBtnFace
        Style = [cbStandardColors, cbExtendedColors, cbIncludeNone, cbPrettyNames]
        DropDownCount = 20
        ItemHeight = 16
        TabOrder = 0
        OnChange = pbPrevPaint
      end
      object cBack: TColorBox
        Left = 416
        Top = 24
        Width = 145
        Height = 22
        AutoDropDown = True
        NoneColorColor = clBtnFace
        Selected = clWhite
        Style = [cbStandardColors, cbExtendedColors, cbIncludeNone, cbPrettyNames]
        DropDownCount = 20
        ItemHeight = 16
        TabOrder = 1
        OnChange = pbPrevPaint
      end
      object cbRemLast: TCheckBox
        Left = 8
        Top = 8
        Width = 201
        Height = 17
        Caption = 'Remember last font'
        TabOrder = 2
      end
      object cbRemSet: TCheckBox
        Left = 8
        Top = 24
        Width = 153
        Height = 17
        Caption = 'Remember settings'
        TabOrder = 3
      end
      object cbLbaStyle: TCheckBox
        Left = 8
        Top = 40
        Width = 121
        Height = 17
        Caption = 'LBA letter style'
        TabOrder = 4
        OnClick = pbPrevPaint
      end
      object cbOnTop: TCheckBox
        Left = 136
        Top = 24
        Width = 105
        Height = 17
        Caption = 'Stay on top'
        TabOrder = 5
        OnClick = cbOnTopClick
      end
      object cbWordWrap: TCheckBox
        Left = 136
        Top = 40
        Width = 105
        Height = 17
        Caption = 'Word wrap'
        TabOrder = 6
        OnClick = pbPrevPaint
      end
    end
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 589
      Height = 64
      Anchors = [akLeft, akTop, akRight, akBottom]
      BevelInner = bvLowered
      BevelOuter = bvNone
      Constraints.MinHeight = 10
      Constraints.MinWidth = 10
      Ctl3D = True
      UseDockManager = False
      FullRepaint = False
      ParentCtl3D = False
      TabOrder = 1
      DesignSize = (
        589
        64)
      object pbPrev: TPaintBox
        Left = 1
        Top = 1
        Width = 569
        Height = 44
        Anchors = [akLeft, akTop, akRight, akBottom]
        Constraints.MinHeight = 10
        Constraints.MinWidth = 10
        OnPaint = pbPrevPaint
      end
      object ImgPBuf: TImage
        Left = 72
        Top = 8
        Width = 105
        Height = 41
        Visible = False
      end
      object sbHoriz: TScrollBar
        Left = 1
        Top = 46
        Width = 570
        Height = 16
        Anchors = [akLeft, akRight, akBottom]
        LargeChange = 20
        PageSize = 0
        SmallChange = 2
        TabOrder = 0
        OnChange = pbPrevPaint
      end
      object sbVert: TScrollBar
        Left = 571
        Top = 1
        Width = 16
        Height = 44
        Anchors = [akTop, akRight, akBottom]
        Kind = sbVertical
        LargeChange = 60
        PageSize = 0
        SmallChange = 40
        TabOrder = 1
        OnChange = pbPrevPaint
      end
    end
  end
  object FontDlg: TOpenDialog
    Filter = 'LBA font files (*.lfn)|*.lfn|All files (*.*)|*.*'
    Options = [ofHideReadOnly, ofExtensionDifferent, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Open font file'
    Left = 464
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 464
    Top = 32
  end
end
