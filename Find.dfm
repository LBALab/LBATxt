object FindForm: TFindForm
  Left = 226
  Top = 102
  Width = 497
  Height = 144
  Caption = 'Search for text'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 43
    Height = 13
    Caption = 'Find text:'
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 48
    Width = 361
    Height = 65
    ActivePage = TabSheet1
    Style = tsButtons
    TabOrder = 4
    object TabSheet1: TTabSheet
      Caption = 'Replace'
      TabVisible = False
      object Label3: TLabel
        Left = 4
        Top = 0
        Width = 90
        Height = 13
        Caption = 'And replace it with:'
      end
      object Edit2: TEdit
        Left = 12
        Top = 16
        Width = 337
        Height = 21
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 0
        OnChange = Edit1Change
      end
      object rbBegin: TRadioButton
        Left = 20
        Top = 40
        Width = 125
        Height = 17
        Caption = 'Form the beginning'
        Checked = True
        TabOrder = 1
        TabStop = True
      end
      object rbSelected: TRadioButton
        Left = 148
        Top = 40
        Width = 205
        Height = 17
        Caption = 'From the selected text'
        TabOrder = 2
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Find'
      ImageIndex = 1
      TabVisible = False
    end
  end
  object Edit1: TEdit
    Left = 16
    Top = 24
    Width = 337
    Height = 21
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 0
    OnChange = Edit1Change
  end
  object cbCase: TCheckBox
    Left = 191
    Top = 48
    Width = 161
    Height = 17
    BiDiMode = bdLeftToRight
    Caption = 'Uwzgl'#281'dniaj wielko'#347#263' znak'#243'w'
    ParentBiDiMode = False
    TabOrder = 1
  end
  object Button1: TButton
    Left = 368
    Top = 21
    Width = 113
    Height = 25
    Caption = 'Find'
    Default = True
    Enabled = False
    ModalResult = 1
    TabOrder = 2
  end
  object Button2: TButton
    Left = 368
    Top = 56
    Width = 113
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
