//******************************************************************************
// LBA Text Editor 2 - editing lbt (text) files from Little Big Adventure 1 & 2
//
// Editor unit.
// Contains routines used for external editor (editor in separate window).
//
// Copyright (C) Zink
// e-mail: zink@poczta.onet.pl
// See the GNU General Public License (License.txt) for details.
//******************************************************************************

unit Editor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ActnList;

type
  TTextForm = class(TForm)
    SaveBtn: TBitBtn;
    CancelBtn: TBitBtn;
    FindBtn: TButton;
    FindNext: TSpeedButton;
    reExt: TRichEdit;
    cbExt: TComboBox;
    ShowPreview: TSpeedButton;
    ActionList1: TActionList;
    aFindSingle: TAction;
    aFindSingleNext: TAction;
    aPreviewSingle: TAction;
    procedure FormShow(Sender: TObject);
    procedure FindBtnClick(Sender: TObject);
    procedure FindNextClick(Sender: TObject);
    procedure reExtChange(Sender: TObject);
    procedure ShowPreviewClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TextForm: TTextForm;

procedure SetFrame(number: byte);
function GetFrame: byte;
Procedure TextEditEnd;

implementation

{$R *.dfm}

uses Find, Lang, Preview, LBATxt1, IntEditor, files;

procedure SetFrame(number: byte);
begin
 With TypeCombo do
  case number of
   1:ItemIndex:=0;
   3:ItemIndex:=1;
   5:ItemIndex:=2;
   9:ItemIndex:=3;
   17:ItemIndex:=4;
   33:ItemIndex:=5;
   35:ItemIndex:=6;
   65:ItemIndex:=7;
   129:ItemIndex:=8;
  end;
end;

function GetFrame: byte;
const Map: array[0..8] of byte = (1,3,5,9,17,33,35,65,129);
begin
 Result:=Map[TypeCombo.ItemIndex];
end;

Procedure TextEditEnd;
begin
 Entries[Selected].Text:=RichEdit.Text;
 If Lba2 then Entries[Selected].TType:=GetFrame;
 CalcOffsets;
 DrawTexts(True);
 SetModified;
end;

procedure TTextForm.FormShow(Sender: TObject);
begin
 ActiveControl:=reExt;
end;

procedure TTextForm.FindBtnClick(Sender: TObject);
begin
 FindForm.ShowSpecial(False);
 If FindForm.ModalResult=mrOK then begin
  TextPos:=1;
  If FindSingle(RichEdit.Text) then begin
   RichEdit.SetFocus;
   RichEdit.SelStart:=TextPos-1;
   RichEdit.SelLength:=Length(FindForm.Edit1.Text);
   aFindSingleNext.Enabled:=True;
  end
  else
   aFindSingleNext.Enabled:=False;
 end;
end;

procedure TTextForm.FindNextClick(Sender: TObject);
begin
 If TextPos=-1 then Exit;
 Inc(TextPos);
 If FindSingle(RichEdit.Text) then begin
  RichEdit.SetFocus;
  RichEdit.SelStart:=TextPos-1;
  RichEdit.SelLength:=Length(FindForm.Edit1.Text);
 end
 else
  aFindSingleNext.Enabled:=False;
end;

procedure TTextForm.reExtChange(Sender: TObject);
begin
 SetPreviewText(reExt.Text);
 PaintPreview;
end;

procedure TTextForm.ShowPreviewClick(Sender: TObject);
begin
 PrevForm.Show;
end;

end.
