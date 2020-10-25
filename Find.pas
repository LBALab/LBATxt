//******************************************************************************
// LBA Text Editor 2 - editing lbt (text) files from Little Big Adventure 1 & 2
//
// Find unit.
// Contains searching and replacing routines.
//
// Copyright (C) Zink
// e-mail: zink@poczta.onet.pl
// See the GNU General Public License (License.txt) for details.
//******************************************************************************

unit Find;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

type
  TFindForm = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    cbCase: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label3: TLabel;
    Edit2: TEdit;
    rbBegin: TRadioButton;
    rbSelected: TRadioButton;
    procedure FormShow(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Procedure ShowSpecial(Replace: Boolean);
  end;

var
  FindForm: TFindForm;

  TextNum: Integer = -1;
  TextPos: Integer = -1;

procedure CenterSelected;
procedure FindSelected;
Function FindText(ShowMsg: Boolean = True): Boolean;
Function FindSingle(Source: String; ShowMsg: Boolean = True): Boolean;
Procedure Replace;

implementation

{$R *.dfm}

uses LBATxt1, Editor, Lang, files;

procedure CenterSelected;
var Buffer: Integer;
begin
 If Entries[Selected+1].YPos-Entries[Selected].YPos>=Form1.TextPB.Height then
  Buffer:=Entries[Selected].YPos
 else
  Buffer:=(Entries[Selected].YPos+Entries[Selected+1].YPos-Form1.TextPB.Height) div 2;
 If Buffer<0 then Buffer:=0;
 If Buffer>Form1.TextScr.Max then Buffer:=Form1.TextScr.Max;
 Form1.TextScr.Position:=Buffer;
 DrawTexts;
end;

procedure FindSelected;
begin
 If Entries[Selected+1].YPos-Entries[Selected].YPos>=Form1.TextPB.Height then
  Form1.TextScr.Position:=Entries[Selected].YPos
 else begin
  If Entries[Selected].YPos-Form1.TextScr.Position<1 then
   Form1.TextScr.Position:=Entries[Selected].YPos-1
  else if Entries[Selected+1].YPos-Form1.TextScr.Position>Form1.TextPB.Height then
   Form1.TextScr.Position:=Entries[Selected+1].YPos-Form1.TextPB.Height;
 end;
 DrawTexts;
end;

Function FindText(ShowMsg: Boolean = True): Boolean;
var a, b: Integer;
    Text, TextToFind: String;
begin
 Result:=True;
 For a:=TextNum to High(Entries)-1 do begin
  If FindForm.cbCase.Checked then begin
   Text:=Entries[a].Text;
   TextToFind:=FindForm.Edit1.Text;
  end
  else begin
   Text:=LowerCase(Entries[a].Text);
   TextToFind:=LowerCase(FindForm.Edit1.Text);
  end;
  For b:=1 to Length(Text)-Length(TextToFind)+1 do
   If TextToFind=Copy(Text,b,Length(TextToFind)) then begin
    TextNum:=a;
    TextPos:=b;
    Exit;
   end;
 end;
 TextPos:=-1;
 TextNum:=-1;
 If ShowMsg then MessageBox(FindForm.Handle,PChar(sNotFound),'LBA Text Editor 2',MB_ICONINFORMATION+MB_OK);
 Result:=False;
end;

Function FindSingle(Source: String; ShowMsg: Boolean = True): Boolean;
var a: Integer;
    Text, TextToFind: String;
begin
 Result:=True;
 If FindForm.cbCase.Checked then begin
  Text:=Source;
  TextToFind:=FindForm.Edit1.Text;
 end
 else begin
  Text:=LowerCase(Source);
  TextToFind:=LowerCase(FindForm.Edit1.Text);
 end;
 For a:=TextPos to Length(Text)-Length(TextToFind)+1 do
  If TextToFind=Copy(Text,a,Length(TextToFind)) then begin
   TextPos:=a;
   Exit;
  end;
 TextPos:=-1;
 If ShowMsg then MessageBox(FindForm.Handle,PChar(sNotFound),'LBA Text Editor 2',MB_ICONINFORMATION+MB_OK);
 Result:=False;
end;

Procedure ReplaceSingle;
begin
 Delete(Entries[TextNum].Text,TextPos,Length(FindForm.Edit1.Text));
 Insert(FindForm.Edit2.Text,Entries[TextNum].Text,TextPos);
end;

Procedure Replace;
var a: Integer;
begin
 a:=0;
 If FindForm.rbBegin.Checked then TextNum:=0
 else TextNum:=Selected;
 While FindText(False) do begin
  ReplaceSingle;
  Inc(a);
  While FindSingle(Entries[TextNum].Text,False) do begin
   ReplaceSingle;
   Inc(a);
   Inc(TextPos);
  end;
  Inc(TextNum);
 end;
 If a>0 then begin
  MessageBox(Form1.Handle,PChar(Format(sMFound,[a])),'LBA Text Editor 2',MB_ICONINFORMATION+MB_OK);
  SetModified;
 end 
 else
  MessageBox(Form1.Handle,PChar(sNotFound),'LBA Text Editor 2',MB_ICONINFORMATION+MB_OK);
end;

Procedure TFindForm.ShowSpecial(Replace: Boolean);
begin
 If Replace then begin
  PageControl1.ActivePageIndex:=0;
  Button1.Caption:=sReplace;
 end
 else begin
  PageControl1.ActivePageIndex:=1;
  Button1.Caption:=sFind;
 end;
 ShowModal;
end;

procedure TFindForm.FormShow(Sender: TObject);
begin
 Edit1Change(Self);
 cbCase.Left:=335-Canvas.TextWidth(cbCase.Caption);
 Edit1.SetFocus;
 Edit1.SelectAll;
end;

procedure TFindForm.Edit1Change(Sender: TObject);
begin
 Button1.Enabled:=Edit1.Text<>'';
end;

end.
