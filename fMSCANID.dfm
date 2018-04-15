object frmmscanid: Tfrmmscanid
  Left = 290
  Top = 108
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Set MSCAN ID'
  ClientHeight = 223
  ClientWidth = 389
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblid: TLabel
    Left = 8
    Top = 10
    Width = 41
    Height = 13
    AutoSize = False
    Caption = 'ID:0x'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object lblequ: TLabel
    Left = 112
    Top = 10
    Width = 33
    Height = 13
    AutoSize = False
    Caption = ' = 0b'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbl1: TLabel
    Left = 350
    Top = 32
    Width = 26
    Height = 8
    AutoSize = False
    Color = clMaroon
    ParentColor = False
    OnMouseDown = lbl1MouseDown
  end
  object lbl2: TLabel
    Tag = 1
    Left = 322
    Top = 32
    Width = 26
    Height = 8
    AutoSize = False
    Color = clGreen
    ParentColor = False
    OnMouseDown = lbl1MouseDown
  end
  object lbl3: TLabel
    Tag = 2
    Left = 294
    Top = 32
    Width = 26
    Height = 8
    AutoSize = False
    Color = clOlive
    ParentColor = False
    OnMouseDown = lbl1MouseDown
  end
  object lbl4: TLabel
    Tag = 3
    Left = 266
    Top = 32
    Width = 26
    Height = 8
    AutoSize = False
    Color = clNavy
    ParentColor = False
    OnMouseDown = lbl1MouseDown
  end
  object lbl5: TLabel
    Tag = 4
    Left = 238
    Top = 32
    Width = 26
    Height = 8
    AutoSize = False
    Color = clPurple
    ParentColor = False
    OnMouseDown = lbl1MouseDown
  end
  object lbl6: TLabel
    Tag = 5
    Left = 210
    Top = 32
    Width = 26
    Height = 8
    AutoSize = False
    Color = clTeal
    ParentColor = False
    OnMouseDown = lbl1MouseDown
  end
  object lbl7: TLabel
    Tag = 6
    Left = 182
    Top = 32
    Width = 26
    Height = 8
    AutoSize = False
    Color = clGray
    ParentColor = False
    OnMouseDown = lbl1MouseDown
  end
  object lbl8: TLabel
    Tag = 7
    Left = 154
    Top = 32
    Width = 26
    Height = 8
    AutoSize = False
    Color = clSilver
    ParentColor = False
    OnMouseDown = lbl1MouseDown
  end
  object lbl9: TLabel
    Left = 95
    Top = 32
    Width = 14
    Height = 8
    AutoSize = False
    Color = clMaroon
    ParentColor = False
    OnMouseDown = lbl9MouseDown
  end
  object lbl10: TLabel
    Tag = 1
    Left = 79
    Top = 32
    Width = 14
    Height = 8
    AutoSize = False
    Color = clGreen
    ParentColor = False
    OnMouseDown = lbl9MouseDown
  end
  object lbl11: TLabel
    Tag = 2
    Left = 63
    Top = 32
    Width = 14
    Height = 8
    AutoSize = False
    Color = clOlive
    ParentColor = False
    OnMouseDown = lbl9MouseDown
  end
  object lbl12: TLabel
    Tag = 3
    Left = 46
    Top = 32
    Width = 14
    Height = 8
    AutoSize = False
    Color = clNavy
    ParentColor = False
    OnMouseDown = lbl9MouseDown
  end
  object lblmsk: TLabel
    Left = 8
    Top = 42
    Width = 41
    Height = 13
    AutoSize = False
    Caption = 'Mask'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object lblmskbin: TLabel
    Left = 112
    Top = 42
    Width = 33
    Height = 13
    AutoSize = False
    Caption = ' = 0b'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lblLink: TLabel
    Left = 8
    Top = 197
    Width = 109
    Height = 13
    Cursor = crHandPoint
    Caption = 'http://www.fksd3.com'
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = lblLinkClick
  end
  object grdid: TStringGrid
    Left = 8
    Top = 88
    Width = 372
    Height = 97
    TabStop = False
    ColCount = 10
    Ctl3D = False
    DefaultColWidth = 36
    DefaultRowHeight = 18
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
    ParentCtl3D = False
    ScrollBars = ssNone
    TabOrder = 7
    OnClick = grdidClick
    OnDrawCell = grdidDrawCell
    OnSelectCell = grdidSelectCell
    ColWidths = (
      36
      36
      36
      36
      36
      36
      36
      36
      36
      36)
  end
  object radstd: TRadioButton
    Left = 144
    Top = 66
    Width = 113
    Height = 17
    Caption = 'Standard Frame'
    Checked = True
    TabOrder = 5
    TabStop = True
    OnClick = radstdClick
  end
  object radextend: TRadioButton
    Left = 264
    Top = 66
    Width = 113
    Height = 17
    Caption = 'Extend Frame'
    TabOrder = 6
    OnClick = radextendClick
  end
  object chkremote: TCheckBox
    Left = 16
    Top = 66
    Width = 97
    Height = 17
    Caption = 'Remote Frame'
    TabOrder = 4
    OnClick = chkremoteClick
  end
  object edtidhex: TEdit
    Left = 40
    Top = 8
    Width = 73
    Height = 24
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnChange = edtidhexChange
    OnEnter = edtidbinEnter
  end
  object edtidbin: TEdit
    Left = 144
    Top = 8
    Width = 236
    Height = 22
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnChange = edtidbinChange
    OnEnter = edtidbinEnter
  end
  object edtmskhex: TEdit
    Left = 40
    Top = 40
    Width = 73
    Height = 24
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    Text = '7FF'
    OnChange = edtmskhexChange
    OnEnter = edtmskbinEnter
  end
  object edtmskbin: TEdit
    Left = 144
    Top = 40
    Width = 236
    Height = 22
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    Text = '011111111111'
    OnChange = edtmskbinChange
    OnEnter = edtmskbinEnter
  end
  object btnOK: TBitBtn
    Left = 266
    Top = 192
    Width = 115
    Height = 25
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 8
    OnClick = btnokClick
  end
end
