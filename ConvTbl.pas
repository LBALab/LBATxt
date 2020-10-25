//******************************************************************************
// LBA Text Editor 2 - editing lbt (text) files from Little Big Adventure 1 & 2
//
// ConvTbl unit.
// Contains conversion table routines.
//
// Copyright (C) Zink
// e-mail: zink@poczta.onet.pl
// See the GNU General Public License (License.txt) for details.
//******************************************************************************

unit ConvTbl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Buttons, Math;

type
  TConvForm = class(TForm)
    PageControl1: TPageControl;
    MapTab: TTabSheet;
    ListTab: TTabSheet;
    pbMap: TPaintBox;
    Label1: TLabel;
    rgDec: TRadioGroup;
    Edit1: TEdit;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    btSave: TBitBtn;
    btLoad: TBitBtn;
    btDefault: TBitBtn;
    btBlank: TBitBtn;
    btClose: TBitBtn;
    dOpenMap: TOpenDialog;
    dSaveMap: TSaveDialog;
    List: TListView;
    Edit2: TEdit;
    Label3: TLabel;
    btAdd: TButton;
    btDelete: TButton;
    btOK: TButton;
    Edit3: TEdit;
    rgExit: TRadioGroup;
    rgEdit: TRadioGroup;
    Label4: TLabel;
    procedure pbMapPaint(Sender: TObject);
    procedure rgDecClick(Sender: TObject);
    procedure pbMapClick(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure pbMapDblClick(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure pbMapMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure btDefaultClick(Sender: TObject);
    procedure btCloseClick(Sender: TObject);
    procedure btBlankClick(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
    procedure btLoadClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListClick(Sender: TObject);
    procedure ListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure btDeleteClick(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure btOKClick(Sender: TObject);
    procedure ListDblClick(Sender: TObject);
    procedure Edit2Exit(Sender: TObject);
    procedure btAddClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TConversionTable = array[0..255] of Char;

const
 DefaultLoadTable: TConversionTable = (
  #0,#1,#2,#3,#4,#5,#6,#7,#8,#9,#10,#11,#12,#13,#14,#15,
  #16,#17,#18,#19,#20,#21,#22,#23,#24,#25,#26,#27,#28,#29,#30,#31,
  #32,#33,#34,#35,#36,#37,#38,#39,#40,#41,#42,#43,#44,#45,#46,#47,
  #48,#49,#50,#51,#52,#53,#54,#55,#56,#57,#58,#59,#60,#61,#62,#63,
  #64,#65,#66,#67,#68,#69,#70,#71,#72,#73,#74,#75,#76,#77,#78,#79,
  #80,#81,#82,#83,#84,#85,#86,#87,#88,#89,#90,#91,#92,#93,#94,#95,
  #96,#97,#98,#99,#100,#101,#102,#103,#104,#105,#106,#107,#108,#109,#110,#111,
  #112,#113,#114,#115,#116,#117,#118,#119,#120,#121,#122,#123,#124,#125,#126,#127,
  #199{},#252{},#233{},#226{},#228{},#224{},#134,#231{},#234{},#235{},#232{},#239{},#238{},#236{},#196{},#143,
  #201{},#230{},#198{},#244{},#246{},#242{},#251{},#249{},#255{},#214{},#220{},#155,#163{},#157,#158,#159,
  #225{},#237{},#243{},#250{},#241{},#209{},#166,#167,#191{},#169,#170,#171,#172,#161{},#174,#175,
  #227{},#245{},#178,#179,#156{},#140{},#192{},#195{},#213{},#185,#248{},#187,#188,#169{},#167{},#153{},
  #192,#193,#194,#195,#196,#197,#198,#199,#200,#201,#202,#203,#204,#205,#206,#207,
  #208,#209,#210,#211,#212,#213,#214,#215,#216,#217,#218,#219,#220,#221,#222,#223,
  #224,#223{},#226,#227,#228,#229,#230,#231,#232,#233,#234,#235,#236,#237,#238,#239,
  #240,#241,#242,#243,#244,#245,#246,#247,#248,#249,#250,#251,#252,#253,#254,#255);

 BlankTable: TConversionTable = (
  #0,#1,#2,#3,#4,#5,#6,#7,#8,#9,#10,#11,#12,#13,#14,#15,
  #16,#17,#18,#19,#20,#21,#22,#23,#24,#25,#26,#27,#28,#29,#30,#31,
  #32,#33,#34,#35,#36,#37,#38,#39,#40,#41,#42,#43,#44,#45,#46,#47,
  #48,#49,#50,#51,#52,#53,#54,#55,#56,#57,#58,#59,#60,#61,#62,#63,
  #64,#65,#66,#67,#68,#69,#70,#71,#72,#73,#74,#75,#76,#77,#78,#79,
  #80,#81,#82,#83,#84,#85,#86,#87,#88,#89,#90,#91,#92,#93,#94,#95,
  #96,#97,#98,#99,#100,#101,#102,#103,#104,#105,#106,#107,#108,#109,#110,#111,
  #112,#113,#114,#115,#116,#117,#118,#119,#120,#121,#122,#123,#124,#125,#126,#127,
  #128,#129,#130,#131,#132,#133,#134,#135,#136,#137,#138,#139,#140,#141,#142,#143,
  #144,#145,#146,#147,#148,#149,#150,#151,#152,#153,#154,#155,#156,#157,#158,#159,
  #160,#161,#162,#163,#164,#165,#166,#167,#168,#169,#170,#171,#172,#173,#174,#175,
  #176,#177,#178,#179,#180,#181,#182,#183,#184,#185,#186,#187,#188,#189,#190,#191,
  #192,#193,#194,#195,#196,#197,#198,#199,#200,#201,#202,#203,#204,#205,#206,#207,
  #208,#209,#210,#211,#212,#213,#214,#215,#216,#217,#218,#219,#220,#221,#222,#223,
  #224,#225,#226,#227,#228,#229,#230,#231,#232,#233,#234,#235,#236,#237,#238,#239,
  #240,#241,#242,#243,#244,#245,#246,#247,#248,#249,#250,#251,#252,#253,#254,#255);

var
  ConvForm: TConvForm;
  OnLoadTable, OnSaveTable, CustomTable: TConversionTable;

  Select: TPoint = (x:0; y:0);

Procedure CreateSaveTable;
Function AnsiToWinOnLoad(Src: String): String;
Function WinToAnsiOnSave(Src: String): String;
procedure UpdateList(Index, NewValue: Integer);
procedure MakeList;
procedure SelectList;

implementation

{$R *.dfm}

Procedure CreateSaveTable;
var a: Integer;
begin
 OnSaveTable:=BlankTable;
 for a:=0 to 255 do
  If OnLoadTable[a]<>Chr(a) then
   OnSaveTable[Ord(OnLoadTable[a])]:=Chr(a);
end;

Function AnsiToWinOnLoad(Src: String): String;
var a: Integer;
begin
 For a:=1 to Length(Src) do
  Src[a]:=OnLoadTable[Byte(Src[a])];
 Result:=Src;
end;

Function WinToAnsiOnSave(Src: String): String;
var a: Integer;
begin
 For a:=1 to Length(Src) do
  Src[a]:=OnSaveTable[Byte(Src[a])];
 Result:=Src;
end;

procedure UpdateLabel;
begin
 If ConvForm.rgDec.ItemIndex=0 then
  ConvForm.Label2.Caption:=Format('%d => %d',
  [Select.x+Select.y*16,Ord(OnLoadTable[Select.x+Select.y*16])])
 else
  ConvForm.Label2.Caption:=IntToHex(Select.x+Select.y*16,2)+' => '+
   IntToHex(Ord(OnLoadTable[Select.x+Select.y*16]),2);
end;

// == map editing ==

Procedure PaintBtn(x,y, Value, Digits: Integer; Down: Boolean = False;
 Header: Boolean = False; Marked: Boolean = False);
var buff: string;
begin
 x:=x*24;
 y:=y*18;
 With ConvForm.pbMap.Canvas do begin
  Brush.Color:=clBtnFace;
  If Header then Brush.Color:=clSkyBlue;
  If Marked then Brush.Color:=$80c0ff;;
  FillRect(Rect(x,y,x+24,y+18));
  If Down then Pen.Color:=clBtnShadow else Pen.Color:=clBtnHighlight;
  MoveTo(x,y+17);
  LineTo(x,y);
  LineTo(x+23,y);
  If Down then Pen.Color:=clBtnHighlight else Pen.Color:=clBtnShadow;
  LineTo(x+23,y+17);
  LineTo(x,y+17);
  //If Down then begin Inc(x); Inc(y); end;
  If ConvForm.rgDec.ItemIndex=0 then buff:=IntToStr(Value)
  else buff:=IntToHex(Value,Digits);
  TextOut(x+11-(TextWidth(buff) div 2),y+2,buff);
 end;
end;

procedure PaintAutoBtn(x,y: Integer; Down: Boolean = False);
begin
 PaintBtn(x+1,y+1,Ord(OnLoadTable[x+y*16]),2,Down,False,Ord(OnLoadTable[x+y*16])<>x+y*16);
end;

procedure TConvForm.pbMapPaint(Sender: TObject);
var a, b: Integer;
    buff: String;
begin
 With ConvForm.pbMap.Canvas do begin
  Brush.Color:=clBtnFace;
  FillRect(Rect(0,0,pbMap.Width,pbMap.Height));
  Font.Color:=clBlack;
  Pen.Color:=clBtnShadow;
  For a:=1 to 16 do begin
   MoveTo(a*24+23,18);
   LineTo(a*24+23,305);
   MoveTo(24,a*18+17);
   LineTo(407,a*18+17);
  end;
  Pen.Color:=clBtnHighlight;
  For a:=1 to 16 do begin
   MoveTo(a*24,18);
   LineTo(a*24,305);
   MoveTo(24,a*18);
   LineTo(407,a*18);
  end;
  For a:=1 to 16 do begin
   PaintBtn(a,0,a-1,1,False,True);
   PaintBtn(0,a,(a-1)*16,2,False,True);
  end;

  For b:=0 to 15 do
   For a:=0 to 15 do begin
    If OnLoadTable[a+b*16]<>Chr(a+b*16) then begin
     Brush.Color:=$80c0ff;
     FillRect(Rect(a*24+25,b*18+19,a*24+47,b*18+35));
    end
    else Brush.Color:=clBtnFace;
    If rgDec.Itemindex=0 then
     Buff:=IntToStr(Ord(OnLoadTable[a+b*16]))
    else
     Buff:=IntToHex(Ord(OnLoadTable[a+b*16]),2);
    TextOut(a*24+35-(TextWidth(buff) div 2),b*18+20,buff);
   end;

  PaintAutoBtn(Select.x,Select.y,True);
 end;
 UpdateLabel;
end;

Function HexToInt(val: String): Integer;
var a, b, c: Integer;
begin
 val:=LowerCase(val);
 b:=1;
 c:=0;
 for a:=Length(val) downto 1 do begin
  if (val[a]>='0') and (val[a]<='9') then
   c:=c+(Ord(val[a])-48)*b
  else if (val[a]>='a') and (val[a]<='f') then
   c:=c+(Ord(val[a])-87)*b
  else Continue;
  b:=b*16;
 end;
 Result:=c;  
end;

procedure TConvForm.rgDecClick(Sender: TObject);
begin
 If rgDec.ItemIndex=0 then begin
  Edit1.MaxLength:=3;
  Edit2.MaxLength:=3;
  Edit3.MaxLength:=3;
 end
 else begin
  Edit1.MaxLength:=2;
  Edit2.MaxLength:=2;
  Edit3.MaxLength:=2;
 end; 
 pbMapPaint(self);
 MakeList;
 UpdateLabel;
end;

procedure EditMap;
var buff: String;
    p: TPoint;
begin
 With ConvForm do begin
  p:=pbMap.ScreenToClient(Mouse.CursorPos);
  p:=Point((p.x div 24)-1,(p.Y div 18)-1);
  If (p.x>=0) and (p.y>=0) then begin
   Edit1.Left:=(p.x+1)*24+pbMap.Left;
   Edit1.Top:=(p.y+1)*18+pbMap.Top;
   If rgDec.Itemindex=0 then
    buff:=IntToStr(Ord(OnLoadTable[p.x+p.y*16]))
   else
    buff:=IntToHex(Ord(OnLoadTable[p.x+p.y*16]),2);
   Edit1.Text:=buff;
   Edit1.Tag:=p.x+p.y*16;
   Edit1.Visible:=True;
   Edit1.SelStart:=0;
   Edit1.SelLength:=3;
   Edit1.SetFocus;
  end;
 end;
end;

procedure MapEditEnd(Cancel: Boolean);
var buff: String;
    val: Integer;
begin
 if not ConvForm.Edit1.Visible then Exit;
 If not Cancel then begin
  buff:=ConvForm.Edit1.Text;
  If ConvForm.rgDec.ItemIndex=0 then begin
   If Length(buff)>3 then SetLength(buff,3);
   val:=StrToIntDef(buff,-1);
  end
  else begin
   If Length(buff)>2 then SetLength(buff,2);
   val:=HexToInt(buff);
  end;
  If val<0 then val:=0;
  If val>255 then val:=255;
  OnLoadTable[ConvForm.Edit1.Tag]:=Chr(val);
  UpdateList(ConvForm.Edit1.Tag,val);
  UpdateLabel;
 end;
 ConvForm.Edit1.Visible:=False;
end;

procedure TConvForm.pbMapClick(Sender: TObject);
begin
 MapEditEnd(rgExit.ItemIndex=1);
 If rgEdit.ItemIndex=0 then EditMap;
end;

procedure TConvForm.pbMapDblClick(Sender: TObject);
begin
 If rgEdit.ItemIndex=1 then EditMap;
end;

procedure TConvForm.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
 If Key=#27 then MapEditEnd(True)
 else If Key=#13 then MapEditEnd(False)
 else begin
  If ((Key<='9') and (Key>='0')) or (Key=#8) then Exit;
  If (((Key>='a')) and (Key<='f') or (Key>='A') and ((Key<='F')))
  and (rgDec.ItemIndex=1) then Exit;
 end;
 Key:=#0;
end;

procedure TConvForm.Edit1Exit(Sender: TObject);
begin
 MapEditEnd(rgExit.ItemIndex=1);
end;

procedure TConvForm.Edit1Change(Sender: TObject);
var a: Integer;
    buff: String;
begin
 buff:='';
 For a:=1 to Length(Edit1.Text) do
  if ((Edit1.Text[a]>='0') and (Edit1.Text[a]<='9')) or
  (((LowerCase(Edit1.Text[a])>='a') and
  (LowerCase(Edit1.Text[a])<='f')) and (rgDec.ItemIndex=1)) then
   buff:=buff+Edit1.Text[a];
 Edit1.Text:=buff;  
end;

procedure TConvForm.pbMapMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var p: TPoint;
begin
 p:=Point((x div 24)-1,(y div 18)-1);
 If (p.x>=0) and (p.y>=0) then begin
  PaintAutoBtn(Select.x,Select.y,False);
  Select:=p;
  PaintAutoBtn(Select.x,Select.y,True);
  SelectList;
  UpdateLabel;
 end;
end;

// == list editing ==

procedure ChangeListValue(Item: TListItem; Val1, Val2: Integer);
var buff1, buff2: String;
begin
 Item.Caption:=IntToStr(Val1);
 While Item.SubItems.Count<3 do Item.SubItems.Add('');
 If ConvForm.rgDec.ItemIndex=0 then begin
  buff1:=IntToStr(Val1);
  buff2:=IntToStr(Val2);
 end
 else begin
  buff1:=IntToHex(Val1,2);
  buff2:=IntToHex(Val2,2);
 end;
 Item.Subitems[0]:=buff1;
 Item.SubItems[1]:='=>';
 Item.SubItems[2]:=buff2;
 SelectList;
end;

procedure UpdateList(Index, NewValue: Integer);
var a: Integer;
    b: String;
    temp: TListItem;
begin
 b:=IntToStr(Index);
 With ConvForm.List do
  If Index=NewValue then begin
   for a:=0 to Items.Count-1 do
    If Items[a].Caption=b then begin
     Items.Delete(a);
     Exit;
    end;
  end
  else begin
   for a:=0 to Items.Count-1 do
    If Items[a].Caption=b then begin
     ChangeListValue(Items[a],Index,NewValue);
     Exit;
    end;
   for a:=0 to Items.Count-1 do
    If StrToInt(Items[a].Caption)>Index then break;
   If a=Items.Count then
    temp:=Items.Add
   else
    temp:=Items.Insert(a);
   ChangeListValue(temp,Index,NewValue);
   SelectList;
  end;
end;

procedure MakeList;
var a: Integer;
    temp: TListItem;
begin
 ConvForm.List.Clear;
 for a:=0 to 255 do
  If Ord(OnLoadTable[a])<>a then begin
   temp:=ConvForm.List.Items.Add;
   ChangeListValue(temp,a,Ord(OnLoadTable[a]));
  end;
 SelectList; 
end;

procedure SelectList;
var temp: TListItem;
begin
 If ConvForm.List.SelCount>0 then ConvForm.List.Selected.Focused:=False;
 ConvForm.List.ClearSelection;
 temp:=ConvForm.List.FindCaption(0,IntToStr(Select.X+Select.Y*16),False,True,False);
 If temp<>nil then begin
  ConvForm.List.Items[temp.Index].Selected:=True;
  ConvForm.List.Items[temp.Index].Focused:=True;
 end;
end;

procedure TConvForm.ListSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var a: Integer;
begin
 If Selected then begin
  a:=StrToInt(Item.Caption);
  Select:=Point(a mod 16, a div 16);
  UpdateLabel;
 end;
end;

procedure EditList(New: Boolean = False);
begin
 With ConvForm do
  If New or (List.SelCount=1) then begin
   Label3.Enabled:=True;
   btOK.Enabled:=True;
   Edit2.Enabled:=True;
   Edit2.SelStart:=0;
   Edit2.SelLength:=3;
   Edit3.Enabled:=True;
   Edit3.SelStart:=0;
   Edit3.SelLength:=3;
   If New then begin
    Edit2.Text:='';
    Edit3.Text:='';
    Edit2.SetFocus;
   end
   else If List.SelCount=1 then begin
    Edit2.Text:=List.Selected.SubItems[0];
    Edit3.Text:=List.Selected.SubItems[2];
    Edit3.SetFocus;
   end;
  end;
end;

procedure ListEditEnd(Cancel: Boolean);
var a: Integer;
    buff: array[2..3] of String;
    val: array[2..3] of Integer;
begin
 If not ConvForm.Edit2.Enabled then Exit;
 If not Cancel then begin
  buff[2]:=ConvForm.Edit2.Text;
  buff[3]:=ConvForm.Edit3.Text;
  for a:=2 to 3 do begin
   If ConvForm.rgDec.ItemIndex=0 then begin
   If Length(buff[a])>3 then SetLength(buff[a],3);
    val[a]:=StrToIntDef(buff[a],-1);
   end
   else begin
    If Length(buff[a])>2 then SetLength(buff[a],2);
    val[a]:=HexToInt(buff[a]);
   end;
   If val[a]<0 then val[a]:=0;
   If val[a]>255 then val[a]:=255;
  end;
  OnLoadTable[val[2]]:=Chr(val[3]);
  UpdateList(val[2],val[3]);
  UpdateLabel;
 end;
 ConvForm.Edit2.Text:='';
 ConvForm.Edit3.Text:='';
 ConvForm.Label3.Enabled:=False;
 ConvForm.btOK.Enabled:=False;
 ConvForm.Edit2.Enabled:=False;
 ConvForm.Edit3.Enabled:=False;
end;

procedure TConvForm.ListClick(Sender: TObject);
begin
 if rgEdit.ItemIndex = 0 then EditList();
end;

procedure TConvForm.ListDblClick(Sender: TObject);
begin
 if rgEdit.ItemIndex = 1 then EditList();
end;

procedure TConvForm.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
 If Key = #27 then ListEditEnd(True)
 else If Key = #13 then ListEditEnd(False)
 else begin
   if ((Key<='9') and (Key>='0')) or (Key=#8) then Exit;
   if (((Key>='a')) and (Key<='f') or (Key>='A') and ((Key<='F')))
   and (rgDec.ItemIndex=1) then Exit;
 end;
 Key:= #0;
end;

procedure TConvForm.Edit2Exit(Sender: TObject);
begin
 If Assigned(ConvForm.ActiveControl) and
  (ConvForm.ActiveControl.Name<>'Edit2') and
  (ConvForm.ActiveControl.Name<>'Edit3') and
  (ConvForm.ActiveControl.Name<>'btOK') then
    ListEditEnd(rgExit.ItemIndex=1);
end;

procedure TConvForm.btOKClick(Sender: TObject);
begin
 ListEditEnd(False);
end;

procedure TConvForm.btDeleteClick(Sender: TObject);
var a, b: Integer;
begin
 For a:=0 to List.Items.Count-1 do
  If List.Items[a].Selected then begin
   b:=StrToInt(List.Items[a].Caption);
   OnLoadTable[b]:=Chr(b);
  end;
 List.DeleteSelected;
end;

procedure TConvForm.btAddClick(Sender: TObject);
begin
 EditList(True);
end;

// == window procs ==

procedure TConvForm.FormShow(Sender: TObject);
begin
 UpdateLabel;
 MakeList;
end;

procedure TConvForm.btDefaultClick(Sender: TObject);
begin
 OnLoadTable:=DefaultLoadTable;
 pbMap.Repaint;
 MakeList;
end;

procedure TConvForm.btBlankClick(Sender: TObject);
begin
 OnLoadTable:=BlankTable;
 pbMap.Repaint;
 ConvForm.List.Clear;
end;

procedure TConvForm.btCloseClick(Sender: TObject);
begin
 Close;
end;

procedure TConvForm.btSaveClick(Sender: TObject);
var f: File;
    a: Integer;
begin
 If dSaveMap.Execute then begin
  AssignFile(f,dSaveMap.FileName);
  Rewrite(f,256);
  BlockWrite(f,OnLoadTable[0],1);
  CloseFile(f);
 end;
end;

procedure TConvForm.btLoadClick(Sender: TObject);
var f: File;
    a: Integer;
begin
 If dOpenMap.Execute then begin
  AssignFile(f,dOpenMap.FileName);
  Reset(f,256);
  BlockRead(f,OnLoadTable[0],1);
  CloseFile(f);
 end;
 pbMap.Repaint;
 MakeList;
end;

procedure TConvForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 CustomTable:=OnLoadTable;
end;

end.
