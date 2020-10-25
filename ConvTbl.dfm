object ConvForm: TConvForm
  Left = 200
  Top = 103
  Width = 558
  Height = 418
  Caption = 'Conversion map'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 433
    Height = 377
    ActivePage = MapTab
    TabOrder = 0
    object MapTab: TTabSheet
      Caption = 'Table view'
      object pbMap: TPaintBox
        Left = 8
        Top = 35
        Width = 408
        Height = 306
        Color = clSkyBlue
        ParentColor = False
        OnClick = pbMapClick
        OnDblClick = pbMapDblClick
        OnMouseDown = pbMapMouseDown
        OnPaint = pbMapPaint
      end
      object Label1: TLabel
        Left = 16
        Top = 0
        Width = 393
        Height = 28
        Alignment = taCenter
        AutoSize = False
        Caption = 
          'This table is "on load" table. Adequate "on save" table is creat' +
          'ed automatically.'
        Layout = tlCenter
      end
      object Edit1: TEdit
        Left = 369
        Top = 48
        Width = 24
        Height = 18
        AutoSize = False
        BevelOuter = bvSpace
        Ctl3D = True
        MaxLength = 2
        ParentCtl3D = False
        TabOrder = 0
        Text = '0'
        Visible = False
        OnChange = Edit1Change
        OnExit = Edit1Exit
        OnKeyPress = Edit1KeyPress
      end
    end
    object ListTab: TTabSheet
      Caption = 'List view'
      ImageIndex = 1
      object Label3: TLabel
        Left = 206
        Top = 104
        Width = 20
        Height = 20
        Alignment = taRightJustify
        Caption = '=>'
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label4: TLabel
        Left = 160
        Top = 8
        Width = 249
        Height = 41
        AutoSize = False
        Caption = 
          'This list is "on load" list.'#13'Adequate "on save" list is created ' +
          'automatically.'
        WordWrap = True
      end
      object List: TListView
        Left = 24
        Top = 8
        Width = 120
        Height = 329
        AllocBy = 300
        Columns = <
          item
            Width = 1
          end
          item
            Alignment = taRightJustify
            Caption = 'from'
            Width = 30
          end
          item
            Alignment = taRightJustify
            Caption = '=>'
            Width = 27
          end
          item
            Caption = 'to'
            Width = 40
          end>
        ColumnClick = False
        HideSelection = False
        Items.Data = {
          540000000200000000000000FFFFFFFFFFFFFFFF030000000000000000033130
          31023D3E0331303000000000FFFFFFFFFFFFFFFF030000000000000000033230
          30023D3E03323031FFFFFFFFFFFFFFFFFFFFFFFF}
        MultiSelect = True
        ReadOnly = True
        RowSelect = True
        ShowColumnHeaders = False
        TabOrder = 0
        ViewStyle = vsReport
        OnClick = ListClick
        OnDblClick = ListDblClick
        OnSelectItem = ListSelectItem
      end
      object Edit2: TEdit
        Left = 168
        Top = 104
        Width = 33
        Height = 21
        Ctl3D = True
        Enabled = False
        MaxLength = 2
        ParentCtl3D = False
        TabOrder = 2
        OnExit = Edit2Exit
        OnKeyPress = Edit2KeyPress
      end
      object btAdd: TButton
        Left = 168
        Top = 64
        Width = 129
        Height = 25
        Caption = 'Add / Edit'
        TabOrder = 1
        OnClick = btAddClick
      end
      object btDelete: TButton
        Left = 168
        Top = 144
        Width = 129
        Height = 25
        Caption = 'Delete selected'
        TabOrder = 5
        OnClick = btDeleteClick
      end
      object btOK: TButton
        Left = 272
        Top = 104
        Width = 25
        Height = 21
        Caption = 'OK'
        Enabled = False
        TabOrder = 4
        OnClick = btOKClick
      end
      object Edit3: TEdit
        Left = 232
        Top = 104
        Width = 33
        Height = 21
        Ctl3D = True
        Enabled = False
        MaxLength = 2
        ParentCtl3D = False
        TabOrder = 3
        OnExit = Edit2Exit
        OnKeyPress = Edit2KeyPress
      end
    end
  end
  object rgDec: TRadioGroup
    Left = 448
    Top = 8
    Width = 97
    Height = 49
    Caption = 'View as:'
    ItemIndex = 1
    Items.Strings = (
      'Dec'
      'Hex')
    TabOrder = 2
    OnClick = rgDecClick
  end
  object GroupBox1: TGroupBox
    Left = 448
    Top = 166
    Width = 97
    Height = 41
    Caption = 'Selected:'
    TabOrder = 1
    object Label2: TLabel
      Left = 6
      Top = 18
      Width = 86
      Height = 20
      Alignment = taCenter
      AutoSize = False
      Caption = '255     255'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object btSave: TBitBtn
    Left = 448
    Top = 216
    Width = 97
    Height = 25
    Caption = 'Save to file'
    TabOrder = 5
    OnClick = btSaveClick
    NumGlyphs = 2
  end
  object btLoad: TBitBtn
    Left = 448
    Top = 248
    Width = 97
    Height = 25
    Caption = 'Load from file'
    TabOrder = 6
    OnClick = btLoadClick
  end
  object btDefault: TBitBtn
    Left = 448
    Top = 288
    Width = 97
    Height = 25
    Caption = 'Reset to default'
    TabOrder = 7
    OnClick = btDefaultClick
  end
  object btBlank: TBitBtn
    Left = 448
    Top = 320
    Width = 97
    Height = 25
    Caption = 'Reset to blank'
    TabOrder = 8
    OnClick = btBlankClick
  end
  object btClose: TBitBtn
    Left = 448
    Top = 360
    Width = 97
    Height = 25
    Caption = 'Close'
    TabOrder = 9
    OnClick = btCloseClick
  end
  object rgExit: TRadioGroup
    Left = 448
    Top = 112
    Width = 97
    Height = 49
    Caption = 'On edit box exit:'
    ItemIndex = 0
    Items.Strings = (
      'Save'
      'Cancel')
    TabOrder = 4
  end
  object rgEdit: TRadioGroup
    Left = 448
    Top = 60
    Width = 97
    Height = 49
    Caption = 'To edit:'
    ItemIndex = 1
    Items.Strings = (
      'Click'
      'Double click')
    TabOrder = 3
  end
  object dOpenMap: TOpenDialog
    DefaultExt = 'cnv'
    Filter = 'Conversion maps (*.cnv)|*.cnv|All files (*.*)|*.*'
    Options = [ofHideReadOnly, ofExtensionDifferent, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Open conversion map'
    Left = 484
  end
  object dSaveMap: TSaveDialog
    DefaultExt = 'cnv'
    Filter = 'Conversion maps (*.cnv)|*.cnv'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Save conversion map'
    Left = 516
  end
end
