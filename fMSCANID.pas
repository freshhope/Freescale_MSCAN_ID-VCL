{ *****************************************************************

            CAN Bus Development Environment (AutoCAN)

            AutoCAN MSCAN ID Calculator Form (fMSCANID.pas)

            Copyright (c) 2011, FreshHope

            Author: FreshHope (FreshHope@126.com)

            2011.09.17

****************************************************************** }
unit fMSCANID;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, Buttons, ExtCtrls;

type
  Tfrmmscanid = class(TForm)
    grdid: TStringGrid;
    radstd: TRadioButton;
    radextend: TRadioButton;
    chkremote: TCheckBox;
    lblid: TLabel;
    edtidhex: TEdit;
    edtidbin: TEdit;
    lblequ: TLabel;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    lbl6: TLabel;
    lbl7: TLabel;
    lbl8: TLabel;
    lbl9: TLabel;
    lbl10: TLabel;
    lbl11: TLabel;
    lbl12: TLabel;
    lblmsk: TLabel;
    lblmskbin: TLabel;
    edtmskhex: TEdit;
    edtmskbin: TEdit;
    btnOK: TBitBtn;
    lblLink: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure grdidSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure grdidDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure grdidClick(Sender: TObject);
    procedure radstdClick(Sender: TObject);
    procedure radextendClick(Sender: TObject);
    procedure chkremoteClick(Sender: TObject);
    procedure edtidhexChange(Sender: TObject);
    procedure edtidbinChange(Sender: TObject);
    procedure edtmskhexChange(Sender: TObject);
    procedure edtmskbinChange(Sender: TObject);
    procedure edtidbinEnter(Sender: TObject);
    procedure edtmskbinEnter(Sender: TObject);
    procedure lbl1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lbl9MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOKClick(Sender: TObject);
    procedure lblLinkClick(Sender: TObject);
  private
    isMask: boolean;
    IsExtend: Boolean;
    CurACol, CurARow: integer;
    IDEXT, IDSTD: array of array of byte;
    IDEXTm, IDSTDm: array of array of byte;
    CellsEXT, CellsSTD: array of array of string;
    Color01: array[0..1] of TColor;
    procedure CalcID;
    procedure CalcIDMsk;
    procedure CalcIDR;
    procedure CalcIDRMsk;
    procedure CalcFromIDBin;
    procedure CalcFromIDBinMsk;
    procedure SwitchExtend;
    procedure SwitchStandard;
  protected
    procedure DoCreate; override;
  public
    { Public declarations }
  end;

var
  frmmscanid: Tfrmmscanid;

implementation

{$R *.dfm}

uses
  StrUtils,
  ShellAPI;

function BinToHex(x: string): string;
var h, temp: string;
  b, n: integer;
begin
  result := '';
  temp := RightStr(x, 4);
  while Length(temp) > 0 do
  begin
    b := StrToInt(temp);
    n := (b div 1000) * 8 + (b div 100 mod 10) * 4 +
      (b div 10 mod 10) * 2 + b mod 10;
    case n of
      10: h := 'A';
      11: h := 'B';
      12: h := 'C';
      13: h := 'D';
      14: h := 'E';
      15: h := 'F';
    else h := IntToStr(n);
    end;
    x := copy(x, 1, length(x) - 4);
    result := h + result;
    temp := RightStr(x, 4);
  end;
end;

function BinToHexEx(const ABitStr: string): string;
var
  i: Integer;
  AHexStr: string[4];
  AStrPos: PChar;
  AIndex: Integer;
  ALen: Integer;
begin
  AStrPos := PChar(ABitStr);
  ALen := Length(ABitStr) div 4;
  SetLength(Result, ALen);
  AIndex := 0;
  while 0 < ALen do begin
    for i:=1 to Length(AHexStr) do begin
      AHexStr[i] := AnsiChar(astrpos[i]);
    end;
    Inc(AIndex, 1);
    Inc(ALen, -1);
    Inc(AStrPos, 4);
    if AHexStr = '0000' then Result[AIndex] := '0' else
      if AHexStr = '0001' then Result[AIndex] := '1' else
        if AHexStr = '0010' then Result[AIndex] := '2' else
          if AHexStr = '0011' then Result[AIndex] := '3' else
            if AHexStr = '0100' then Result[AIndex] := '4' else
              if AHexStr = '0101' then Result[AIndex] := '5' else
                if AHexStr = '0110' then Result[AIndex] := '6' else
                  if AHexStr = '0111' then Result[AIndex] := '7' else
                    if AHexStr = '1000' then Result[AIndex] := '8' else
                      if AHexStr = '1001' then Result[AIndex] := '9' else
                        if AHexStr = '1010' then Result[AIndex] := 'A' else
                          if AHexStr = '1011' then Result[AIndex] := 'B' else
                            if AHexStr = '1100' then Result[AIndex] := 'C' else
                              if AHexStr = '1101' then Result[AIndex] := 'D' else
                                if AHexStr = '1110' then Result[AIndex] := 'E' else
                                  if AHexStr = '1111' then Result[AIndex] := 'F' else Result[AIndex] := '0';
  end;
end;

function HexToBin(mHex: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(mHex) do
    case mHex[I] of
      '0': Result := Result + '0000';
      '1': Result := Result + '0001';
      '2': Result := Result + '0010';
      '3': Result := Result + '0011';
      '4': Result := Result + '0100';
      '5': Result := Result + '0101';
      '6': Result := Result + '0110';
      '7': Result := Result + '0111';
      '8': Result := Result + '1000';
      '9': Result := Result + '1001';
      'a', 'A': Result := Result + '1010';
      'b', 'B': Result := Result + '1011';
      'c', 'C': Result := Result + '1100';
      'd', 'D': Result := Result + '1101';
      'e', 'E': Result := Result + '1110';
      'f', 'F': Result := Result + '1111';
    else Result := Result + '         ';
    end;
end;

procedure Tfrmmscanid.FormCreate(Sender: TObject);
var
  //resStream: TResourceStream;
  i, j: Integer;
begin
  SetWindowLong(edtidhex.Handle, GWL_STYLE, GetWindowLong(edtidhex.Handle, GWL_STYLE) or Es_right);
  SetWindowLong(edtidbin.Handle, GWL_STYLE, GetWindowLong(edtidbin.Handle, GWL_STYLE) or Es_right);
  SetWindowLong(edtmskhex.Handle, GWL_STYLE, GetWindowLong(edtmskhex.Handle, GWL_STYLE) or Es_right);
  SetWindowLong(edtmskbin.Handle, GWL_STYLE, GetWindowLong(edtmskbin.Handle, GWL_STYLE) or Es_right);
  //resStream := TResourceStream.Create(HInstance, Name, 'lcres');
  //Icon.LoadFromStream(resStream);
  //resstream.Free;
  SetLength(IDEXT, 4, 8);
  SetLength(IDSTD, 4, 8);
  SetLength(IDEXTm, 4, 8);
  SetLength(IDSTDm, 4, 8);
  for i := 0 to 3 do
    for j := 0 to 7 do
      IDEXTm[i, j] := 1;
  IDEXTm[3, 7] := 0;
  for i := 0 to 7 do
    IDSTDm[0, i] := 1;
  for i := 0 to 2 do
    IDSTDm[1, i] := 1;
  SetLength(CellsEXT, 10, 5);
  SetLength(CellsSTD, 10, 5);
  Color01[0] := clWindow;
  Color01[1] := clGray;
  with grdid do begin
    Cells[0, 0] := ' REG';
    Cells[1, 0] := 'Value';
    Cells[2, 0] := 'Bit 7';
    Cells[3, 0] := 'Bit 6';
    Cells[4, 0] := 'Bit 5';
    Cells[5, 0] := 'Bit 4';
    Cells[6, 0] := 'Bit 3';
    Cells[7, 0] := 'Bit 2';
    Cells[8, 0] := 'Bit 1';
    Cells[9, 0] := 'Bit 0';
    Cells[0, 1] := 'IDR0';
    Cells[0, 2] := 'IDR1';
    Cells[0, 3] := 'IDR2';
    Cells[0, 4] := 'IDR3';
    //colwidths[1] := 64;

  end;

  CellsEXT[2, 1] := 'ID28';
  CellsEXT[3, 1] := 'ID27';
  CellsEXT[4, 1] := 'ID26';
  CellsEXT[5, 1] := 'ID25';
  CellsEXT[6, 1] := 'ID24';
  CellsEXT[7, 1] := 'ID23';
  CellsEXT[8, 1] := 'ID22';
  CellsEXT[9, 1] := 'ID21';

  CellsEXT[2, 2] := 'ID20';
  CellsEXT[3, 2] := 'ID19';
  CellsEXT[4, 2] := 'ID18';
  CellsEXT[5, 2] := 'SRR=1';
  CellsEXT[6, 2] := 'IDE=1';
  CellsEXT[7, 2] := 'ID17';
  CellsEXT[8, 2] := 'ID16';
  CellsEXT[9, 2] := 'ID15';

  CellsEXT[2, 3] := 'ID14';
  CellsEXT[3, 3] := 'ID13';
  CellsEXT[4, 3] := 'ID12';
  CellsEXT[5, 3] := 'ID11';
  CellsEXT[6, 3] := 'ID10';
  CellsEXT[7, 3] := 'ID9';
  CellsEXT[8, 3] := 'ID8';
  CellsEXT[9, 3] := 'ID7';

  CellsEXT[2, 4] := 'ID6';
  CellsEXT[3, 4] := 'ID5';
  CellsEXT[4, 4] := 'ID4';
  CellsEXT[5, 4] := 'ID3';
  CellsEXT[6, 4] := 'ID2';
  CellsEXT[7, 4] := 'ID1';
  CellsEXT[8, 4] := 'ID0';
  CellsEXT[9, 4] := 'RTR';

  CellsSTD[2, 1] := 'ID10';
  CellsSTD[3, 1] := 'ID9';
  CellsSTD[4, 1] := 'ID8';
  CellsSTD[5, 1] := 'ID7';
  CellsSTD[6, 1] := 'ID6';
  CellsSTD[7, 1] := 'ID5';
  CellsSTD[8, 1] := 'ID4';
  CellsSTD[9, 1] := 'ID3';

  CellsSTD[2, 2] := 'ID2';
  CellsSTD[3, 2] := 'ID1';
  CellsSTD[4, 2] := 'ID0';
  CellsSTD[5, 2] := 'RTR';
  CellsSTD[6, 2] := 'IDE=0';
  CellsSTD[7, 2] := '';
  CellsSTD[8, 2] := '';
  CellsSTD[9, 2] := '';

  CellsSTD[2, 3] := '';
  CellsSTD[3, 3] := '';
  CellsSTD[4, 3] := '';
  CellsSTD[5, 3] := '';
  CellsSTD[6, 3] := '';
  CellsSTD[7, 3] := '';
  CellsSTD[8, 3] := '';
  CellsSTD[9, 3] := '';

  CellsSTD[2, 4] := '';
  CellsSTD[3, 4] := '';
  CellsSTD[4, 4] := '';
  CellsSTD[5, 4] := '';
  CellsSTD[6, 4] := '';
  CellsSTD[7, 4] := '';
  CellsSTD[8, 4] := '';
  CellsSTD[9, 4] := '';

  SwitchStandard;

end;

procedure Tfrmmscanid.SwitchExtend;
var
  i, j: integer;
begin
  IsExtend := true;
  with grdid do begin
    for i := 1 to 4 do
      for j := 2 to 9 do
        Cells[j, i] := cellsEXT[j, i];
  end;

  IDEXTm[1, 3] := 1;
  IDEXTm[1, 4] := 1;

  if isMask then
    if IDEXTm[3, 7] = 1 then
      chkremote.Checked := true
    else
      chkremote.Checked := false;
  CalcIDMsk;

  IDEXT[1, 3] := 1;
  IDEXT[1, 4] := 1;

  if not isMask then
    if IDEXT[3, 7] = 1 then
      chkremote.Checked := true
    else
      chkremote.Checked := false;
  CalcID;

end;

procedure Tfrmmscanid.SwitchStandard;
var
  i, j: Integer;
begin
  IsExtend := false;
  with grdid do begin
    for i := 1 to 4 do
      for j := 2 to 9 do
        Cells[j, i] := cellsSTD[j, i];
  end;

  IDSTDm[1, 4] := 0;
  if isMask then
    if IDSTDm[1, 3] = 1 then
      chkremote.Checked := true
    else
      chkremote.Checked := false;
  CalcIDMsk;

  IDSTD[1, 4] := 0;
  if not isMask then
    if IDSTD[1, 3] = 1 then
      chkremote.Checked := true
    else
      chkremote.Checked := false;
  CalcID;

end;

procedure Tfrmmscanid.grdidSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
//  if ACol = 1 then
//    grdid.Options := grdid.Options + [goEditing]
//  else
//    grdid.Options := grdid.Options - [goEditing];
end;

procedure Tfrmmscanid.grdidDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  rect1: TRect;
  w, h: integer;
begin
  if isMask then begin
    if (ACol >= 2) and (ARow >= 1) then
      with grdid do begin
        if IsExtend then begin
          Canvas.Brush.Color := color01[IDEXTm[ARow - 1, ACol - 2]];
        end else begin
          Canvas.Brush.Color := color01[IDstdm[ARow - 1, ACol - 2]];
        end;
        Canvas.FillRect(Rect);
        Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, Cells[ACol, ARow]);

        w := Rect.Right - Rect.Left - 2;
        h := rect.Bottom - rect.Top - 2;
        if (ARow = CurARow) and (ACol + 1 = CurACol) then begin
          if IsExtend then begin
            Canvas.Brush.Color := color01[IDEXTm[CurARow - 1, CurACol - 2]];
          end else begin
            Canvas.Brush.Color := color01[IDstdm[CurARow - 1, CurACol - 2]];
          end;
          rect1.Left := Rect.Right + 1;
          rect1.Top := Rect.Top + 1;
          rect1.Right := rect1.Left + w;
          Rect1.Bottom := rect1.Top + h;
          Canvas.FillRect(Rect1);
          Canvas.TextOut(Rect.Right + 2, Rect.Top + 2, Cells[CurACol, CurARow]);
        end else if (ARow + 1 = CurARow) and (ACol = CurACol) then begin
          if IsExtend then begin
            Canvas.Brush.Color := color01[IDEXTm[CurARow - 1, CurACol - 2]];
          end else begin
            Canvas.Brush.Color := color01[IDstdm[CurARow - 1, CurACol - 2]];
          end;
          rect1.Left := Rect.left + 1;
          rect1.Top := Rect.Bottom + 1;
          rect1.Right := rect1.Left + w;
          Rect1.Bottom := rect1.Top + h;
          Canvas.FillRect(Rect1);
          Canvas.TextOut(Rect.Left + 2, Rect.Bottom + 2, Cells[CurACol, CurARow]);
        end else if (ARow = CurARow + 1) and (ACol = CurACol) then begin
          if IsExtend then begin
            Canvas.Brush.Color := color01[IDEXTm[CurARow - 1, CurACol - 2]];
          end else begin
            Canvas.Brush.Color := color01[IDstdm[CurARow - 1, CurACol - 2]];
          end;
          rect1.Left := Rect.Left + 1;
          rect1.Top := Rect.Top - Rect.Bottom + rect.Top + 1;
          rect1.Right := rect1.Left + w;
          Rect1.Bottom := rect1.Top + h;
          Canvas.FillRect(Rect1);
          Canvas.TextOut(Rect.Left + 2, Rect.Top - Rect.Bottom + rect.Top + 1, Cells[CurACol, CurARow]);
        end;
      end;
  end else begin
    if (ACol >= 2) and (ARow >= 1) then
      with grdid do begin
        if IsExtend then begin
          Canvas.Brush.Color := color01[IDEXT[ARow - 1, ACol - 2]];
        end else begin
          Canvas.Brush.Color := color01[IDstd[ARow - 1, ACol - 2]];
        end;
        Canvas.FillRect(Rect);
        Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, Cells[ACol, ARow]);

        w := Rect.Right - Rect.Left - 2;
        h := rect.Bottom - rect.Top - 2;
        if (ARow = CurARow) and (ACol + 1 = CurACol) then begin
          if IsExtend then begin
            Canvas.Brush.Color := color01[IDEXT[CurARow - 1, CurACol - 2]];
          end else begin
            Canvas.Brush.Color := color01[IDstd[CurARow - 1, CurACol - 2]];
          end;
          rect1.Left := Rect.Right + 1;
          rect1.Top := Rect.Top + 1;
          rect1.Right := rect1.Left + w;
          Rect1.Bottom := rect1.Top + h;
          Canvas.FillRect(Rect1);
          Canvas.TextOut(Rect.Right + 2, Rect.Top + 2, Cells[CurACol, CurARow]);
        end else if (ARow + 1 = CurARow) and (ACol = CurACol) then begin
          if IsExtend then begin
            Canvas.Brush.Color := color01[IDEXT[CurARow - 1, CurACol - 2]];
          end else begin
            Canvas.Brush.Color := color01[IDstd[CurARow - 1, CurACol - 2]];
          end;
          rect1.Left := Rect.left + 1;
          rect1.Top := Rect.Bottom + 1;
          rect1.Right := rect1.Left + w;
          Rect1.Bottom := rect1.Top + h;
          Canvas.FillRect(Rect1);
          Canvas.TextOut(Rect.Left + 2, Rect.Bottom + 2, Cells[CurACol, CurARow]);
        end else if (ARow = CurARow + 1) and (ACol = CurACol) then begin
          if IsExtend then begin
            Canvas.Brush.Color := color01[IDEXT[CurARow - 1, CurACol - 2]];
          end else begin
            Canvas.Brush.Color := color01[IDstd[CurARow - 1, CurACol - 2]];
          end;
          rect1.Left := Rect.Left + 1;
          rect1.Top := Rect.Top - Rect.Bottom + rect.Top + 1;
          rect1.Right := rect1.Left + w;
          Rect1.Bottom := rect1.Top + h;
          Canvas.FillRect(Rect1);
          Canvas.TextOut(Rect.Left + 2, Rect.Top - Rect.Bottom + rect.Top + 1, Cells[CurACol, CurARow]);
        end;
      end;
  end;
  if (ACol = 1) and (ARow >= 1) then with grdid do begin
      Canvas.Font.Color := clRed;
      Canvas.TextOut(Rect.Left + 2, Rect.top + 2, Cells[ACol, ARow]);
      Canvas.Font.Color := clWindowText;
    end;
end;

procedure Tfrmmscanid.grdidClick(Sender: TObject);
begin
  if isMask then begin
    with grdid do begin
      CurACol := Col;
      CurARow := Row;
      if (Col >= 2) and (Row >= 1) then begin
        if IsExtend then begin
          if (Row = 2) and (Col = 5) then Exit;
          if (Row = 2) and (Col = 6) then Exit;
          IDEXTm[Row - 1, Col - 2] := IDEXTm[Row - 1, Col - 2] xor 1;
          if IDEXTm[3, 7] = 1 then
            chkremote.Checked := true
          else
            chkremote.Checked := false;
        end else begin
          if (Row = 2) and (Col >= 6) then Exit;
          if Row >= 3 then exit;
          IDstdm[Row - 1, Col - 2] := IDstdm[Row - 1, Col - 2] xor 1;
          if IDSTDm[1, 3] = 1 then
            chkremote.Checked := true
          else
            chkremote.Checked := false;
        end;
        Repaint;
      end;
    end;
    CalcIDmsk;
  end else begin
    with grdid do begin
      CurACol := Col;
      CurARow := Row;
      if (Col >= 2) and (Row >= 1) then begin
        if IsExtend then begin
          if (Row = 2) and (Col = 5) then Exit;
          if (Row = 2) and (Col = 6) then Exit;
          IDEXT[Row - 1, Col - 2] := IDEXT[Row - 1, Col - 2] xor 1;
          if IDEXT[3, 7] = 1 then
            chkremote.Checked := true
          else
            chkremote.Checked := false;
        end else begin
          if (Row = 2) and (Col >= 6) then Exit;
          if Row >= 3 then exit;
          IDstd[Row - 1, Col - 2] := IDstd[Row - 1, Col - 2] xor 1;
          if IDSTD[1, 3] = 1 then
            chkremote.Checked := true
          else
            chkremote.Checked := false;
        end;
        Repaint;
      end;
    end;
    CalcID;
  end;
end;

procedure Tfrmmscanid.radstdClick(Sender: TObject);
begin
  SwitchStandard;
end;

procedure Tfrmmscanid.radextendClick(Sender: TObject);
begin
  SwitchExtend;
end;

procedure Tfrmmscanid.chkremoteClick(Sender: TObject);
begin
  if isMask then begin
    if IsExtend then begin
      if chkremote.Checked then
        IDEXTm[3, 7] := 1
      else
        IDEXTm[3, 7] := 0;
    end else begin
      if chkremote.Checked then
        IDSTDm[1, 3] := 1
      else
        IDSTDm[1, 3] := 0;
    end;
    SendMessage(grdid.Handle, WM_KEYDOWN, VK_HOME, 0);
    CalcIDRmsk;
  end else begin
    if IsExtend then begin
      if chkremote.Checked then
        IDEXT[3, 7] := 1
      else
        IDEXT[3, 7] := 0;
    end else begin
      if chkremote.Checked then
        IDSTD[1, 3] := 1
      else
        IDSTD[1, 3] := 0;
    end;
    SendMessage(grdid.Handle, WM_KEYDOWN, VK_HOME, 0);
    CalcIDR;
  end;
  grdid.Refresh;
end;

procedure Tfrmmscanid.CalcID;
var
  i, id: Integer;
begin
  id := 0;
  if IsExtend then begin
    for i := 21 to 28 do
      id := id or (idext[0, 7 - (i - 21)] shl i);
    for i := 18 to 20 do
      id := id or (idext[1, 2 - (i - 18)] shl i);
    for i := 15 to 17 do
      id := id or (idext[1, 7 - (i - 15)] shl i);
    for i := 7 to 14 do
      id := id or (idext[2, 7 - (i - 7)] shl i);
    for i := 0 to 6 do
      id := id or (idext[3, 7 - (i + 1)] shl i);
    edtidhex.Text := IntToHex(id, 8);
    edtidbin.Text := HexToBin(edtidhex.Text);
  end else begin
    for i := 3 to 10 do
      id := id or (idstd[0, 7 - (i - 3)] shl i);
    for i := 0 to 2 do
      id := id or (idstd[1, 2 - i] shl i);
    edtidhex.Text := IntToHex(id, 3);
    edtidbin.Text := HexToBin(edtidhex.Text);
  end;
  CalcIDR;
end;

procedure Tfrmmscanid.CalcIDR;
var
  i, j, id: integer;
begin
  with grdid do begin
    if IsExtend then begin
      for j := 1 to 4 do begin
        id := 0;
        for i := 0 to 7 do
          id := id or (idext[j - 1, 7 - i] shl i);
        Cells[1, j] := IntToHex(id, 2);
      end;
    end else begin
      for j := 1 to 4 do begin
        id := 0;
        for i := 0 to 7 do
          id := id or (idstd[j - 1, 7 - i] shl i);
        Cells[1, j] := IntToHex(id, 2);
      end;
    end;
  end;
end;

procedure Tfrmmscanid.edtidhexChange(Sender: TObject);
var
  s: string;
  i: Integer;
begin
  s := UpperCase(edtidhex.Text);
  if IsExtend then begin
    if Length(s) > 8 then begin
      edtidhex.Color := clFuchsia;
      Exit;
    end;
  end else begin
    if Length(s) > 4 then begin
      edtidhex.Color := clFuchsia;
      Exit;
    end;
  end;
  for i := 1 to Length(s) do begin
    if not (CharInSet(AnsiChar(s[i]), ['0'..'9']) or
            CharInSet(AnsiChar(s[i]), ['A'..'F'])) then begin
      edtidhex.Color := clFuchsia;
      edtidhex.SelStart := i;
      Exit;
    end;
  end;
  edtidhex.Color := clWindow;
  if not edtidbin.Focused then
    edtidbin.Text := HexToBin(edtidhex.Text);
end;

procedure Tfrmmscanid.edtidbinChange(Sender: TObject);
var
  s: string;
  i: Integer;
begin
  s := edtidbin.Text;
  i := Length(s);
  if IsExtend then begin
    if i > 32 then begin
      edtidbin.Color := clFuchsia;
      Exit;
    end;
  end else begin
    if i > 16 then begin
      edtidbin.Color := clFuchsia;
      Exit;
    end;
  end;
  for i := 1 to Length(s) do begin
    if not CharInSet(AnsiChar(s[i]), ['0'..'1']) then begin
      edtidbin.SelStart := i;
      edtidbin.Color := clFuchsia;
      Exit;
    end;
  end;
  edtidbin.Color := clWindow;
  if not edtidhex.Focused then
    edtidhex.Text := BinToHex(edtidbin.Text);
  CalcFromIDBin;
end;

procedure Tfrmmscanid.btnOKClick(Sender: TObject);
begin
  Close;

end;

procedure Tfrmmscanid.CalcFromIDBin;
var
  s: string;
  i: integer;
begin
  s := Trim(edtidbin.Text);

  with grdid do begin
    if IsExtend then begin
      for i := 1 to 32 - length(s) do begin
        s := '0' + s;
      end;
      IDEXT[0, 0] := byte(s[4]) - byte('0');
      IDEXT[0, 1] := byte(s[5]) - byte('0');
      IDEXT[0, 2] := byte(s[6]) - byte('0');
      IDEXT[0, 3] := byte(s[7]) - byte('0');
      IDEXT[0, 4] := byte(s[8]) - byte('0');
      IDEXT[0, 5] := byte(s[9]) - byte('0');
      IDEXT[0, 6] := byte(s[10]) - byte('0');
      IDEXT[0, 7] := byte(s[11]) - byte('0');

      IDEXT[1, 0] := byte(s[12]) - byte('0');
      IDEXT[1, 1] := byte(s[13]) - byte('0');
      IDEXT[1, 2] := byte(s[14]) - byte('0');
      //IDEXT[1, 3] := byte(s[]) - byte('0');
      //IDEXT[1, 4] := byte(s[]) - byte('0');
      IDEXT[1, 5] := byte(s[15]) - byte('0');
      IDEXT[1, 6] := byte(s[16]) - byte('0');
      IDEXT[1, 7] := byte(s[17]) - byte('0');

      IDEXT[2, 0] := byte(s[18]) - byte('0');
      IDEXT[2, 1] := byte(s[19]) - byte('0');
      IDEXT[2, 2] := byte(s[20]) - byte('0');
      IDEXT[2, 3] := byte(s[21]) - byte('0');
      IDEXT[2, 4] := byte(s[22]) - byte('0');
      IDEXT[2, 5] := byte(s[23]) - byte('0');
      IDEXT[2, 6] := byte(s[24]) - byte('0');
      IDEXT[2, 7] := byte(s[25]) - byte('0');

      IDEXT[3, 0] := byte(s[26]) - byte('0');
      IDEXT[3, 1] := byte(s[27]) - byte('0');
      IDEXT[3, 2] := byte(s[28]) - byte('0');
      IDEXT[3, 3] := byte(s[29]) - byte('0');
      IDEXT[3, 4] := byte(s[30]) - byte('0');
      IDEXT[3, 5] := byte(s[31]) - byte('0');
      IDEXT[3, 6] := byte(s[32]) - byte('0');
      //IDEXT[3, 7] := byte(s[]) - byte('0');

    end else begin
      for i := 1 to 16 - length(s) do begin
        s := '0' + s;
      end;
      IDSTD[0, 0] := Byte(s[6]) - Byte('0');
      IDSTD[0, 1] := Byte(s[7]) - Byte('0');
      IDSTD[0, 2] := Byte(s[8]) - Byte('0');
      IDSTD[0, 3] := Byte(s[9]) - Byte('0');
      IDSTD[0, 4] := Byte(s[10]) - Byte('0');
      IDSTD[0, 5] := Byte(s[11]) - Byte('0');
      IDSTD[0, 6] := Byte(s[12]) - Byte('0');
      IDSTD[0, 7] := Byte(s[13]) - Byte('0');

      IDSTD[1, 0] := Byte(s[14]) - Byte('0');
      IDSTD[1, 1] := Byte(s[15]) - Byte('0');
      IDSTD[1, 2] := Byte(s[16]) - Byte('0');

    end;
    CalcIDR;
    Repaint;
  end;
end;

procedure Tfrmmscanid.edtmskhexChange(Sender: TObject);
var
  s: string;
  i: Integer;
begin
  s := UpperCase(edtmskhex.Text);
  if IsExtend then begin
    if Length(s) > 8 then begin
      edtmskhex.Color := clFuchsia;
      Exit;
    end;
  end else begin
    if Length(s) > 4 then begin
      edtmskhex.Color := clFuchsia;
      Exit;
    end;
  end;
  for i := 1 to Length(s) do begin
    if not (CharInSet(AnsiChar(s[i]), ['0'..'9']) or
            CharInSet(AnsiChar(s[i]), ['A'..'F'])) then begin
      edtmskhex.Color := clFuchsia;
      edtmskhex.SelStart := i;
      Exit;
    end;
  end;
  edtmskhex.Color := clWindow;
  if not edtmskbin.Focused then
    edtmskbin.Text := HexToBin(edtmskhex.Text);
end;

procedure Tfrmmscanid.edtmskbinChange(Sender: TObject);
var
  s: string;
  i: Integer;
begin
  s := edtmskbin.Text;
  i := Length(s);
  if IsExtend then begin
    if i > 32 then begin
      edtmskbin.Color := clFuchsia;
      Exit;
    end;
  end else begin
    if i > 16 then begin
      edtmskbin.Color := clFuchsia;
      Exit;
    end;
  end;
  for i := 1 to Length(s) do begin
    if not CharInSet(s[i], ['0'..'1']) then begin
      edtmskbin.SelStart := i;
      edtmskbin.Color := clFuchsia;
      Exit;
    end;
  end;
  edtmskbin.Color := clWindow;
  if not edtmskhex.Focused then
    edtmskhex.Text := BinToHex(edtmskbin.Text);
  CalcFromIDBinMsk;
end;

procedure Tfrmmscanid.CalcFromIDBinMsk;
var
  s: string;
  i: integer;
begin
  s := Trim(edtmskbin.Text);

  with grdid do begin
    if IsExtend then begin
      for i := 1 to 32 - length(s) do begin
        s := '0' + s;
      end;
      IDEXTm[0, 0] := byte(s[4]) - byte('0');
      IDEXTm[0, 1] := byte(s[5]) - byte('0');
      IDEXTm[0, 2] := byte(s[6]) - byte('0');
      IDEXTm[0, 3] := byte(s[7]) - byte('0');
      IDEXTm[0, 4] := byte(s[8]) - byte('0');
      IDEXTm[0, 5] := byte(s[9]) - byte('0');
      IDEXTm[0, 6] := byte(s[10]) - byte('0');
      IDEXTm[0, 7] := byte(s[11]) - byte('0');

      IDEXTm[1, 0] := byte(s[12]) - byte('0');
      IDEXTm[1, 1] := byte(s[13]) - byte('0');
      IDEXTm[1, 2] := byte(s[14]) - byte('0');
      //IDEXTm[1, 3] := byte(s[]) - byte('0');
      //IDEXTm[1, 4] := byte(s[]) - byte('0');
      IDEXTm[1, 5] := byte(s[15]) - byte('0');
      IDEXTm[1, 6] := byte(s[16]) - byte('0');
      IDEXTm[1, 7] := byte(s[17]) - byte('0');

      IDEXTm[2, 0] := byte(s[18]) - byte('0');
      IDEXTm[2, 1] := byte(s[19]) - byte('0');
      IDEXTm[2, 2] := byte(s[20]) - byte('0');
      IDEXTm[2, 3] := byte(s[21]) - byte('0');
      IDEXTm[2, 4] := byte(s[22]) - byte('0');
      IDEXTm[2, 5] := byte(s[23]) - byte('0');
      IDEXTm[2, 6] := byte(s[24]) - byte('0');
      IDEXTm[2, 7] := byte(s[25]) - byte('0');

      IDEXTm[3, 0] := byte(s[26]) - byte('0');
      IDEXTm[3, 1] := byte(s[27]) - byte('0');
      IDEXTm[3, 2] := byte(s[28]) - byte('0');
      IDEXTm[3, 3] := byte(s[29]) - byte('0');
      IDEXTm[3, 4] := byte(s[30]) - byte('0');
      IDEXTm[3, 5] := byte(s[31]) - byte('0');
      IDEXTm[3, 6] := byte(s[32]) - byte('0');
      //IDEXTm[3, 7] := byte(s[]) - byte('0');

    end else begin
      for i := 1 to 16 - length(s) do begin
        s := '0' + s;
      end;
      IDSTDm[0, 0] := Byte(s[6]) - Byte('0');
      IDSTDm[0, 1] := Byte(s[7]) - Byte('0');
      IDSTDm[0, 2] := Byte(s[8]) - Byte('0');
      IDSTDm[0, 3] := Byte(s[9]) - Byte('0');
      IDSTDm[0, 4] := Byte(s[10]) - Byte('0');
      IDSTDm[0, 5] := Byte(s[11]) - Byte('0');
      IDSTDm[0, 6] := Byte(s[12]) - Byte('0');
      IDSTDm[0, 7] := Byte(s[13]) - Byte('0');

      IDSTDm[1, 0] := Byte(s[14]) - Byte('0');
      IDSTDm[1, 1] := Byte(s[15]) - Byte('0');
      IDSTDm[1, 2] := Byte(s[16]) - Byte('0');

    end;
    CalcIDRMsk;
    Repaint;
  end;
end;

procedure Tfrmmscanid.CalcIDRMsk;
var
  i, j, id: integer;
begin
  with grdid do begin
    if IsExtend then begin
      for j := 1 to 4 do begin
        id := 0;
        for i := 0 to 7 do
          id := id or (idextm[j - 1, 7 - i] shl i);
        Cells[1, j] := IntToHex(id, 2);
      end;
    end else begin
      for j := 1 to 4 do begin
        id := 0;
        for i := 0 to 7 do
          id := id or (idstdm[j - 1, 7 - i] shl i);
        Cells[1, j] := IntToHex(id, 2);
      end;
    end;
  end;
end;

procedure Tfrmmscanid.edtidbinEnter(Sender: TObject);
begin
  isMask := false;
  if IsExtend then begin
    if IDEXT[3, 7] = 1 then
      chkremote.Checked := true
    else
      chkremote.Checked := false;
  end else begin
    if IDSTD[1, 3] = 1 then
      chkremote.Checked := true
    else
      chkremote.Checked := false;
  end;
  CalcIDR;
  grdid.Repaint;
end;

procedure Tfrmmscanid.edtmskbinEnter(Sender: TObject);
begin
  isMask := True;
  if IsExtend then begin
    if IDEXTm[3, 7] = 1 then
      chkremote.Checked := true
    else
      chkremote.Checked := false;
  end else begin
    if IDSTDm[1, 3] = 1 then
      chkremote.Checked := true
    else
      chkremote.Checked := false;
  end;
  CalcIDRmsk;
  grdid.Repaint;
end;

procedure Tfrmmscanid.CalcIDMsk;
var
  i, id: Integer;
begin
  id := 0;
  if IsExtend then begin
    for i := 21 to 28 do
      id := id or (idextm[0, 7 - (i - 21)] shl i);
    for i := 18 to 20 do
      id := id or (idextm[1, 2 - (i - 18)] shl i);
    for i := 15 to 17 do
      id := id or (idextm[1, 7 - (i - 15)] shl i);
    for i := 7 to 14 do
      id := id or (idextm[2, 7 - (i - 7)] shl i);
    for i := 0 to 6 do
      id := id or (idextm[3, 7 - (i + 1)] shl i);
    edtmskhex.Text := IntToHex(id, 8);
    edtmskbin.Text := HexToBin(edtmskhex.Text);
  end else begin
    for i := 3 to 10 do
      id := id or (idstdm[0, 7 - (i - 3)] shl i);
    for i := 0 to 2 do
      id := id or (idstdm[1, 2 - i] shl i);
    edtmskhex.Text := IntToHex(id, 3);
    edtmskbin.Text := HexToBin(edtmskhex.Text);
  end;
  CalcIDRmsk;
end;

procedure Tfrmmscanid.lbl1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  edt: TEdit;
  i: Integer;
begin
  if isMask = False then
    edt := edtidbin
  else
    edt := edtmskbin;
  i := Length(edt.Text) - ((sender as TLabel).Tag * 4 + 4);
  if i >= 0 then begin
    edt.SetFocus;
    edt.SelStart := i;
    edt.SelLength := 4;
  end;
end;

procedure Tfrmmscanid.lbl9MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  edt: TEdit;
  i: Integer;
begin
  if isMask = False then
    edt := edtidhex
  else
    edt := edtmskhex;
  i := Length(edt.Text) - ((sender as TLabel).Tag * 2 + 2);
  if i >= 0 then begin
    edt.SetFocus;
    edt.SelStart := i;
    edt.SelLength := 2;
  end;
end;

procedure Tfrmmscanid.lblLinkClick(Sender: TObject);
begin
  ShellExecute(Handle,
               'open',
               'http://www.ihr-sh.com',
               nil,
               nil,
               SW_SHOW);

end;

procedure Tfrmmscanid.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //Action := caFree;
end;

procedure Tfrmmscanid.DoCreate;
begin
  inherited;

end;

end.

