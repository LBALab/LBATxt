//******************************************************************************
// LBA Text Editor 2 - editing lbt (text) files from Little Big Adventure 1 & 2
//
// IntEditor unit.
// Contains routines used for internal editor (editor embedded in the main
// program window).
//
// Copyright (C) Zink
// e-mail: zink@poczta.onet.pl
// See the GNU General Public License (License.txt) for details.
//******************************************************************************

unit IntEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ComCtrls, ActnList;

type
  TIntForm = class(TForm)
    Bevel1: TBevel;
    SaveBtn: TBitBtn;
    CancelBtn: TBitBtn;
    ShowPreview: TSpeedButton;
    FindBtn: TButton;
    FindNext: TSpeedButton;
    cbInt: TComboBox;
    rgExit: TRadioGroup;
    btPrev: TBitBtn;
    btNext: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btPrevClick(Sender: TObject);
    procedure btNextClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IntForm: TIntForm;

  RichEdit: TRichEdit;
  TypeCombo: TComboBox;

  ActionStates: array of Boolean;
  ScrollState: Boolean;

Procedure InternalStart;
procedure InternalEnd(Cancel: Boolean);

implementation

uses LBATxt1, files, Editor, Preview;

{$R *.dfm}

Procedure DisableAllActions;
var a: Integer;
begin
 Form1.ToolBar1.Enabled:=False;
 Form1.mRecent.Enabled:=False;
 ScrollState:=Form1.TextScr.Enabled;
 Form1.TextScr.Enabled:=False;
 for a:=0 to Form1.ActionList.ActionCount-1 do begin
  ActionStates[a]:=(Form1.ActionList.Actions[a] as TAction).Enabled;
  (Form1.ActionList.Actions[a] as TAction).Enabled:=False;
 end;
end;

Procedure EnableAllActions;
var a: Integer;
begin
 Form1.ToolBar1.Enabled:=True;
 Form1.mRecent.Enabled:=Form1.mRecent.Count>0;
 Form1.TextScr.Enabled:=ScrollState;
 for a:=0 to Form1.ActionList.ActionCount-1 do
  If ActionStates[a] then (Form1.ActionList.Actions[a] as TAction).Enabled:=True;
end;

Procedure InternalStart;
var a: Integer;
begin
 With Form1 do begin
  If Entries[Selected].YPos-TextScr.Position<1 then
   TextScr.Position:=Entries[Selected].YPos-1
  else if Entries[Selected+1].YPos-TextScr.Position>TextPB.Height then
   TextScr.Position:=Entries[Selected+1].YPos-TextPB.Height;

  DisableAllActions;

  IntForm.btPrev.Enabled:=Selected>0;
  IntForm.btNext.Enabled:=Selected<High(Entries)-1;

  reInt.Visible:=False;    //You never know...
  reInt.Left:=TextPB.Left;
  reInt.Width:=TextPB.Width;
  reInt.Top:=Entries[Selected].YPos-TextScr.Position-1;
  If reInt.Top<-1 then reInt.Top:=-1;
  reInt.Height:=Entries[Selected+1].YPos-TextScr.Position-reInt.Top;
  If reInt.Height>TextPB.Height then reInt.Height:=TextPB.Height;
  reInt.Top:=reInt.Top+TextPB.Top;
  reInt.Visible:=True;

  IntForm.Left:=Form1.Left-IntForm.Width;
  If reInt.Height<IntForm.ClientHeight then
   IntForm.Top:=(reInt.Height-IntForm.ClientHeight) div 2 +
    ClientToScreen(Point(0,reInt.Top)).Y
  else
   IntForm.Top:=ClientToScreen(Point(0,reInt.Top)).Y;

  AnimateWindow(IntForm.Handle,50,AW_HOR_NEGATIVE+AW_SLIDE);
  IntForm.Visible:=True;

 reInt.SetFocus;
 end;
end;

procedure InternalEnd(Cancel: Boolean);
var a: Integer;
begin
 If not IntForm.Visible then Exit;
 If not Cancel then TextEditEnd;
 Form1.reInt.Visible:=False;
 AnimateWindow(IntForm.Handle,50,AW_HOR_POSITIVE+AW_HIDE+AW_SLIDE);
 IntForm.Visible:=False;
 EnableAllActions;
 Form1.eGoTo.SetFocus;
end;

procedure TIntForm.FormCreate(Sender: TObject);
begin
 RichEdit:=Form1.reInt;
 TypeCombo:=cbInt;
 SetLength(ActionStates,Form1.ActionList.ActionCount);
end;

procedure TIntForm.SaveBtnClick(Sender: TObject);
begin
 InternalEnd(False);
end;

procedure TIntForm.CancelBtnClick(Sender: TObject);
begin
 InternalEnd(True);
end;

procedure TIntForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 If ssAlt in Shift then
  case Key of
   84: IntForm.cbInt.SetFocus;      //Alt+T
   80: PrevForm.Show;               //Alt+P
   38: IntForm.btPrev.Click;        //Alt+Up
   40: IntForm.btNext.Click;        //Alt+Down
  end
 else
  case Key of
   27: IntForm.CancelBtnClick(Self);      //Esc
   113: IntForm.SaveBtnClick(Self);       //F2
   114: TextForm.aFindSingleNext.Execute; //F3
  end;
end;

procedure TIntForm.btPrevClick(Sender: TObject);
begin
 InternalEnd(rgExit.ItemIndex=1); 
 If Selected>0 then begin
  Dec(Selected);
  SendCommand(Selected);
  Form1.aEdit.Execute;
  Mouse.CursorPos:=ClientToScreen(Point(btPrev.Left+(btPrev.Width div 2),btPrev.Top+(btPrev.Height div 2)));
 end;
end;

procedure TIntForm.btNextClick(Sender: TObject);
begin
 InternalEnd(rgExit.ItemIndex=1);
 If Selected<High(Entries)-1 then begin
  Inc(Selected);
  SendCommand(Selected);
  Form1.aEdit.Execute;
  Mouse.CursorPos:=ClientToScreen(Point(btNext.Left+(btNext.Width div 2),btNext.Top+(btNext.Height div 2)));
 end;
end;

end.
