//******************************************************************************
// LBA Text Editor 2 - editing lbt (text) files from Little Big Adventure 1 & 2
//
// LBATxt1 unit.
// This is the main unit. Contains all main window events.
//
// Copyright (C) Zink
// e-mail: zink@poczta.onet.pl
// See the GNU General Public License (License.txt) for details.
//******************************************************************************

unit LBATxt1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, ExtCtrls, ComCtrls, AxCtrls, OleCtrls, VCF1, Buttons,
  Menus, ActnList, ImgList, ShellApi, ToolWin, CompMods, XML, Math;

const
 VerNum: String = '2.3';

type
  TForm1 = class(TForm)
    Bevel1: TBevel;
    TextScr: TScrollBar;
    dOpen: TOpenDialog;
    dSave: TSaveDialog;
    ActionList: TActionList;
    aOpen: TAction;
    aSave: TAction;
    aReload: TAction;
    aExit: TAction;
    aEdit: TAction;
    aFind: TAction;
    aFindNext: TAction;
    aFindRep: TAction;
    aLtr: TAction;
    aRtl: TAction;
    aRtlNa: TAction;
    aRtlRo: TAction;
    aDefault: TAction;
    aHebrew: TAction;
    aDefMap: TAction;
    aNoneMap: TAction;
    aCustomMap: TAction;
    aLoadMap: TAction;
    aPolski: TAction;
    aEnglish: TAction;
    ImageList1: TImageList;
    aRemember: TAction;
    PopupMenu1: TPopupMenu;
    Editselectedentry1: TMenuItem;
    aDelete: TAction;
    aMoveUp: TAction;
    aMoveDown: TAction;
    aInsAbove: TAction;
    aInsBelow: TAction;
    aLock: TAction;
    N1: TMenuItem;
    Find1: TMenuItem;
    Findnext1: TMenuItem;
    Findreplace1: TMenuItem;
    N2: TMenuItem;
    Insertabove1: TMenuItem;
    Insertbelow1: TMenuItem;
    Deleteselectedentry1: TMenuItem;
    N3: TMenuItem;
    Moveup1: TMenuItem;
    Movedown1: TMenuItem;
    ImgTBuf: TImage;
    aPreview: TAction;
    TextPB: TPaintBox;
    Status: TStatusBar;
    aSaveAs: TAction;
    aAutoDetect: TAction;
    aLangFile: TAction;
    dOpenLang: TOpenDialog;
    aAssociate: TAction;
    aInternal: TAction;
    reInt: TRichEdit;
    aSendCom: TAction;
    aReceiveCom: TAction;
    aBothCom: TAction;
    aOff: TAction;
    Timer1: TTimer;
    aClone: TAction;
    MainMenu: TMainMenu;
    mFile: TMenuItem;
    mEdit: TMenuItem;
    mOptions: TMenuItem;
    mDirection: TMenuItem;
    mCharset: TMenuItem;
    mConvMap: TMenuItem;
    mLanguage: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    SaveAs1: TMenuItem;
    Reload1: TMenuItem;
    Clonewindow1: TMenuItem;
    N4: TMenuItem;
    Exit1: TMenuItem;
    mRecent: TMenuItem;
    Editselectedentry2: TMenuItem;
    Previewselectedentry1: TMenuItem;
    N6: TMenuItem;
    Find2: TMenuItem;
    Findnext2: TMenuItem;
    Findandreplace1: TMenuItem;
    N7: TMenuItem;
    Insertabove2: TMenuItem;
    Insertbelow2: TMenuItem;
    Deleteselectedentry2: TMenuItem;
    N8: TMenuItem;
    Moveup2: TMenuItem;
    Movedown2: TMenuItem;
    N9: TMenuItem;
    Lockfilestructure1: TMenuItem;
    Autodetectfiletype1: TMenuItem;
    AssociatewithLBAtextfileslbt1: TMenuItem;
    Internaleditor1: TMenuItem;
    mTranslator: TMenuItem;
    Sendcommands1: TMenuItem;
    Receivecommands1: TMenuItem;
    Sendandreceivecommands1: TMenuItem;
    Off1: TMenuItem;
    Lefttoright1: TMenuItem;
    Righttoleft1: TMenuItem;
    Righttoleftnoalign1: TMenuItem;
    Righttoleftreadingonly1: TMenuItem;
    Default1: TMenuItem;
    Hebrew1: TMenuItem;
    DefaultusedinLba1: TMenuItem;
    None1: TMenuItem;
    Custom1: TMenuItem;
    N10: TMenuItem;
    Loadfromfile1: TMenuItem;
    N11: TMenuItem;
    Rememberlastmap1: TMenuItem;
    Polski1: TMenuItem;
    English1: TMenuItem;
    Fromfile1: TMenuItem;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    ToolButton17: TToolButton;
    ToolButton18: TToolButton;
    ToolButton19: TToolButton;
    ToolButton20: TToolButton;
    paGoTo: TPanel;
    lbGoTo: TLabel;
    eGoTo: TEdit;
    mColourSet: TMenuItem;
    mBlue: TMenuItem;
    mGreen: TMenuItem;
    mRed: TMenuItem;
    mYellow: TMenuItem;
    mPurple: TMenuItem;
    mOrange: TMenuItem;
    N12: TMenuItem;
    ChineseBig51: TMenuItem;
    GB23121: TMenuItem;
    ANSI1: TMenuItem;
    Arabic1: TMenuItem;
    Baltic1: TMenuItem;
    EastEurope1: TMenuItem;
    Greek1: TMenuItem;
    Hangeul1: TMenuItem;
    Johab1: TMenuItem;
    Mac1: TMenuItem;
    OEM1: TMenuItem;
    Russian1: TMenuItem;
    Shiftjis1: TMenuItem;
    hai1: TMenuItem;
    urkish1: TMenuItem;
    aAnsi: TAction;
    aArabic: TAction;
    aBaltic: TAction;
    aChineseBig5: TAction;
    aEastEurope: TAction;
    aGB2312: TAction;
    aGreek: TAction;
    aHangeul: TAction;
    aJohab: TAction;
    aMac: TAction;
    aOem: TAction;
    aRussian: TAction;
    aShiftjis: TAction;
    aThai: TAction;
    aTurkish: TAction;
    procedure aOpenExecute(Sender: TObject);
    procedure TextScrChange(Sender: TObject);
    procedure TextPBPaint(Sender: TObject);
    procedure TextPBMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure aEditExecute(Sender: TObject);
    procedure aSaveExecute(Sender: TObject);
    procedure aReloadExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure aFindExecute(Sender: TObject);
    procedure aFindNextExecute(Sender: TObject);
    procedure aLangExecute(Sender: TObject);
    procedure aBiDiExecute(Sender: TObject);
    procedure aCharsetExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure aDefMapExecute(Sender: TObject);
    procedure aEmptyAction(Sender: TObject);
    procedure aExitExecute(Sender: TObject);
    procedure aLoadMapExecute(Sender: TObject);
    procedure aMoveUpExecute(Sender: TObject);
    procedure aMoveDownExecute(Sender: TObject);
    procedure aLockExecute(Sender: TObject);
    procedure aDeleteExecute(Sender: TObject);
    procedure aInsAboveExecute(Sender: TObject);
    procedure aInsBelowExecute(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure aFindRepExecute(Sender: TObject);
    procedure aPreviewExecute(Sender: TObject);
    procedure FormConstrainedResize(Sender: TObject; var MinWidth,
      MinHeight, MaxWidth, MaxHeight: Integer);
    procedure StatusDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel;
      const Rect: TRect);
    procedure aSaveAsExecute(Sender: TObject);
    procedure aOpenRecent(Sender: TObject);
    procedure aAssociateExecute(Sender: TObject);
    procedure aInternalExecute(Sender: TObject);
    procedure reIntChange(Sender: TObject);
    procedure reIntKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure aTranslatorExecute(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure aCloneExecute(Sender: TObject);
    procedure lbGoToMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure eGoToKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mBlueClick(Sender: TObject);
    procedure aExportXMLExecute(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  private
    { Private declarations }
    procedure AppMessage(var Msg: TMsg; var Handled: Boolean);
    procedure WMDropFiles(hDrop : THandle; hWindow : HWnd);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

  Selected: Integer = 0;
  Modified: Boolean = False;

  ComHandle: THandle;
  ComSelected: ^Integer;
  LastComSel: Integer = 0;

procedure UpdateImage;
procedure DrawTexts(NeedCalc: Boolean = False);
procedure SendCommand(Value: Integer);

implementation

uses Editor, Find, Lang, ConvTbl, settings, Preview, IntEditor, files, Utils;

var WheelTimer: Int64 = 0;

{$R *.DFM}

Procedure StatusText(Text, Offset, Size: String);
begin
 Form1.Status.Panels[2].Text:=Text;
 Form1.Status.Panels[3].Text:=Offset;
 Form1.Status.Panels[4].Text:=Size;
end;

procedure UpdateImage;
begin
 Form1.TextPB.Canvas.CopyRect(Rect(0,0,Form1.TextPB.Width,Form1.TextPB.Height),
  Form1.ImgTBuf.Canvas,Rect(0,0,Form1.ImgTBuf.Width,Form1.ImgTBuf.Height));
end;

procedure CalcPos;
var a, CurrentPos: Integer;
    TextRect: TRect;
    DrawStyle: LongInt;
    BiDiStyle: LongInt;
begin
 If Length(Entries)<1 then Exit;
 if Form1.aLtr.Checked then BiDiStyle:=0
  else if Form1.aRtl.Checked then BiDiStyle:=DT_RIGHT
  else if Form1.aRtlNa.Checked or Form1.aRtlRo.Checked then BiDIStyle:=DT_RTLREADING;
 CurrentPos:=0;
 For a:=0 to High(Entries) do begin
  TextRect:=Rect(2,0,Form1.ImgTBuf.Width-3,10);
  DrawStyle:=DT_WORDBREAK+DT_CALCRECT+DT_NOPREFIX+BiDiStyle;
  DrawText(Form1.ImgTBuf.Canvas.Handle,PChar(Entries[a].Text),Length(Entries[a].Text),
   TextRect,DrawStyle);
  If TextRect.Bottom-TextRect.Top<18 then
   TextRect.Bottom:=TextRect.Top+18;
  Entries[a].YPos:=CurrentPos;
  Inc(CurrentPos,TextRect.Bottom+1);
 end;
 If Entries[High(Entries)].YPos<=Form1.TextPB.Height then
  Form1.TextScr.Enabled:=False
 else begin
  Form1.TextScr.Enabled:=True;
  Form1.TextScr.Max:=Entries[High(Entries)].YPos-1;
  Form1.TextScr.PageSize:=Form1.TextPB.Height;
  Form1.TextScr.LargeChange:=Form1.TextScr.PageSize;
 end;
end;

procedure DrawTexts(NeedCalc: Boolean = False);
var a, cur, Pos: Integer;
    TextRect: TRect;
    DrawStyle: LongInt;
    BiDiStyle: LongInt;
begin
 With Form1 do begin
  if aLtr.Checked then BiDiStyle:=0
  else if aRtl.Checked then BiDiStyle:=DT_RIGHT
  else if aRtlNa.Checked or aRtlRo.Checked then BiDIStyle:=DT_RTLREADING;

  If NeedCalc then CalcPos;
  Pos:=TextScr.Position;
  StatusText(Format(sText,[Selected+1,High(Entries)]),
             Format(sOffset,[Entries[Selected].Offset]),
             Format(sFSize,[Entries[High(Entries)].Offset]));
  ImgTBuf.Canvas.Pen.Color:=clWhite;
  ImgTBuf.Canvas.Brush.Color:=clWhite;
  ImgTBuf.Canvas.Rectangle(0,0,ImgTBuf.Width,ImgTBuf.Height);
  For a:=0 to High(Entries)-1 do begin
   If Entries[a+1].YPos<=Pos then Continue;
   If Entries[a].YPos>Pos+TextPB.Height then Break;
   TextRect:=Rect(2,Entries[a].YPos-Pos,TextPB.Width-3,Entries[a+1].YPos-Pos);
   DrawStyle:=DT_WORDBREAK+DT_NOPREFIX+BiDiStyle;
   If a=Selected then begin
    ImgTBuf.Canvas.Brush.Color:=clSkyBlue;
    ImgTBuf.Canvas.Pen.Color:=clSkyBlue;
    ImgTBuf.Canvas.Rectangle(0,TextRect.Top,TextPB.Width,TextRect.Bottom-1);
    ImgTBuf.Canvas.Brush.Style:=bsClear;
   end;
   DrawText(ImgTBuf.Canvas.Handle,PChar(Entries[a].Text),Length(Entries[a].Text),
    TextRect,DrawStyle);
   ImgTBuf.Canvas.Pen.Color:=clSilver;
   ImgTBuf.Canvas.MoveTo(0,TextRect.Bottom-1);
   ImgTBuf.Canvas.LineTo(ImgTBuf.Width,TextRect.Bottom-1);
  end;
  If not TextScr.Enabled then begin
   ImgTBuf.Canvas.Brush.Color:=clBtnFace;
   ImgTBuf.Canvas.FillRect(Rect(0,Entries[High(Entries)].YPos,TextPB.Width,TextPB.Height));
  end;
 end;
 UpdateImage;
end;

procedure TForm1.aOpenExecute(Sender: TObject);
begin
 dOpen.InitialDir:=CurrentDir;
 dOpen.FileName:='';
 If dOpen.Execute then begin
  CurrentDir:=ExtractFilePath(dOpen.FileName);
  OpenFile(dOpen.FileName);
 end;
end;

procedure TForm1.TextScrChange(Sender: TObject);
begin
 DrawTexts;
end;

procedure TForm1.TextPBPaint(Sender: TObject);
begin
 DrawTexts;
end;

procedure SendCommand(Value: Integer);
begin
 If Form1.aSendCom.Checked or Form1.aBothCom.Checked then begin
  ComSelected:=MapViewOfFile(ComHandle,File_Map_All_Access,0,0,0);
  ComSelected^:=Selected;
  UnmapViewOfFile(ComSelected);
 end;
end;

procedure TForm1.TextPBMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var a: Integer;
begin
 For a:=0 to High(Entries) do
  If (Entries[a].YPos>Y+TextScr.Position) then begin
   if a-1<>Selected then InternalEnd(IntForm.rgExit.ItemIndex=1);
   Selected:=a-1;
   DrawTexts;
   SetPreviewText(Entries[Selected].Text);
   PaintPreview;
   SendCommand(Selected);
   Exit;
  end;
end;

procedure TForm1.aEditExecute(Sender: TObject);
begin
 If Selected<=High(Entries)-1 then begin
  If IntForm.Visible then InternalEnd(IntForm.rgExit.ItemIndex=1);
  With TextForm do begin
   RichEdit.Text:=Entries[Selected].Text;
   If Lba2 then SetFrame(Entries[Selected].TType);
   If Selected=TextNum then begin
    RichEdit.SelStart:=TextPos-1;
    RichEdit.SelLength:=Length(FindForm.Edit1.Text);
    aFindSingleNext.Enabled:=True;
   end;
   Caption:=Format(sSECapt,[Selected+1]);
   If aInternal.Checked then InternalStart
   else begin
    ShowModal;
    If ModalResult=mrOK then TextEditEnd;
   end;
  end;
 end;
end;

procedure TForm1.aSaveExecute(Sender: TObject);
var ext: String;
begin
 ext:=ExtractFileExt(CurrentFile);
 If ext='.lbt' then SaveTexts(CurrentFile)
 else if ext='.xml' then SaveToXML(CurrentFile);
end;

procedure TForm1.aSaveAsExecute(Sender: TObject);
begin
 dSave.InitialDir:=CurrentDir;
 dSave.DefaultExt:='lbt';
 dSave.FileName:=ExtractFileName(CurrentFile);
 if ExtractFileExt(CurrentFile)='.xml' then dSave.FilterIndex:=2;
 If dSave.Execute then begin
  CurrentDir:=ExtractFilePath(dSave.FileName);
  If dSave.FilterIndex=1 then begin
   If ExtractFileExt(dSave.FileName)<>'.lbt' then
    dSave.FileName:=dSave.FileName+'.lbt';
   SaveTexts(dSave.FileName);
  end
  else begin
   If ExtractFileExt(dSave.FileName)<>'.xml' then
    dSave.FileName:=dSave.FileName+'.xml';
   SaveToXML(dSave.FileName);
  end;
 end;
end;

procedure TForm1.aReloadExecute(Sender: TObject);
var a: Integer;
begin
 If CurrentFile='' then Exit;
 If FileExists(CurrentFile) then begin
  CheckFileSave;
  LoadTexts(CurrentFile,False);
  ClearModified;
 end
 else
  MessageBox(Handle,PChar(sWExists),PChar(sWTExists),MB_ICONERROR+MB_OK);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 CheckFileSave;
 DragAcceptFiles(Form1.Handle,False);
 CloseHandle(ComHandle);
end;

procedure TForm1.aFindExecute(Sender: TObject);
begin
 FindForm.ShowSpecial(False);
 If FindForm.ModalResult=mrOK then begin
  TextNum:=0;
  If FindText then begin
   Selected:=TextNum;
   CenterSelected;
   aFindNext.Enabled:=True;
  end
  else
   aFindNext.Enabled:=False;
 end;
end;

procedure TForm1.aFindNextExecute(Sender: TObject);
begin
 If TextNum=-1 then Exit;
 Inc(TextNum);
 If FindText then begin
  Selected:=TextNum;
  CenterSelected;
 end
 else
  aFindNext.Enabled:=False;
end;

procedure TForm1.aFindRepExecute(Sender: TObject);
begin
 FindForm.ShowSpecial(True);
 If FindForm.ModalResult=mrOK then begin
  Replace;
  DrawTexts(True);
 end;
end;

procedure TForm1.aLangExecute(Sender: TObject);
begin
 If aPolski.Checked then SetLang(0)
 else if aEnglish.Checked then SetLang(1)
 else
  If dOpenLang.Execute then begin
   LangFile:=dOpenLang.FileName;
   SetLang(2);
  end
  else SetLang(1);
end;

procedure TForm1.aBiDiExecute(Sender: TObject);
var ChangeTo: TBiDiMode;
begin
 If aRtl.Checked or aRtlNa.Checked then begin
  TextPB.Left:=20;
  TextScr.Left:=1;
  TextScr.Anchors:=[akLeft,akTop,akBottom];
 end
 else begin
  TextPB.Left:=1;
  TextScr.Left:=Form1.Width-27;
  TextScr.Anchors:=[akTop,akRight,akBottom];
 end;
 TextForm.reExt.Clear;
 reInt.Clear;
 If aLtr.Checked then ChangeTo:=bdLeftToRight
 else If aRtl.Checked then ChangeTo:=bdRightToLeft
 else If aRtlNa.Checked then ChangeTo:=bdRightToLeftNoAlign
 else If aRtlRo.Checked then ChangeTo:=bdRightToLeftReadingOnly;
 TextForm.reExt.BiDiMode:=ChangeTo;
 reInt.BiDiMode:=ChangeTo;
 DrawTexts(True);
end;

procedure TForm1.aCharsetExecute(Sender: TObject);
var ChangeTo: TFontCharset;
begin
 If aDefault.Checked then ChangeTo:=DEFAULT_CHARSET
 else if aAnsi.Checked then ChangeTo:=ANSI_CHARSET
 else if aArabic.Checked then ChangeTo:=ARABIC_CHARSET
 else if aBaltic.Checked then ChangeTo:=BALTIC_CHARSET
 else if aChineseBig5.Checked then ChangeTo:=CHINESEBIG5_CHARSET
 else if aEastEurope.Checked then ChangeTo:=EASTEUROPE_CHARSET
 else if aGB2312.Checked then ChangeTo:=GB2312_CHARSET
 else if aGreek.Checked then ChangeTo:=GREEK_CHARSET
 else if aHangeul.Checked then ChangeTo:=HANGEUL_CHARSET
 else if aHebrew.Checked then ChangeTo:=HEBREW_CHARSET
 else if aJohab.Checked then ChangeTo:=JOHAB_CHARSET
 else if aMac.Checked then ChangeTo:=MAC_CHARSET
 else if aOem.Checked then ChangeTo:=OEM_CHARSET
 else if aRussian.Checked then ChangeTo:=RUSSIAN_CHARSET
 else if aShiftjis.Checked then ChangeTo:=SHIFTJIS_CHARSET
 else if aThai.Checked then ChangeTo:=THAI_CHARSET
 else if aTurkish.Checked then ChangeTo:=TURKISH_CHARSET;
 TextPB.Font.Charset:=ChangeTo;
 TextForm.reExt.Clear;
 reInt.Clear;
 TextForm.reExt.Font.Charset:=ChangeTo;
 reInt.Font.Charset:=ChangeTo;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 //ComMsg:=RegisterWindowMessage('LBATextEditorCommand');
 ComHandle:= CreateFileMapping($FFFFFFFF,nil,Page_ReadWrite,0,10,'LBATextEditor2');
 Application.OnMessage:= AppMessage;
 DragAcceptFiles(Form1.Handle, True);
 ImgTBuf.Canvas.Font.Name:= 'Courier New';
 ImgTBuf.Canvas.Font.Size:= 11;
 Form1.DoubleBuffered:= True;
end;

procedure TForm1.WMDropFiles(hDrop : THandle; hWindow : HWnd);
var
  TotalNumberOfFiles, nFileLength, ACol, ARow: Integer;
  pszFileName: PChar;
  DropPoint: TPoint;
begin
  //liczba zrzuconych plików
  TotalNumberOfFiles:=DragQueryFile(hDrop,$FFFFFFFF,nil,0);
  If TotalNumberOfFiles=1 then begin
   nFileLength:=DragQueryFile(hDrop,0,Nil,0)+1;
   GetMem(pszFileName,nFileLength);
   DragQueryFile(hDrop,0,pszFileName,nFileLength);
   DragQueryPoint(hDrop,DropPoint);
   //pszFileName - nazwa upuszczonego pliku
   //tutaj robimy coœ z nazw¹ pliku
   try    //¿eby wykona³o siê FreeMem je¿eli bêdzie b³¹d
    CheckFileSave;
    If FileExists(pszFileName) then
     LoadTexts(pszFileName)
    else
     Beep;
   except
   end;

   FreeMem(pszFileName,nFileLength);
  end
  else
   MessageBox(handle,PChar(sEOneFile),'LBA Text Editor 2',MB_ICONERROR+MB_OK);

  DragFinish(hDrop);
end; //sprawdzamy co zosta³o przeci¹gniête i obs³ugujemy to

procedure TForm1.AppMessage(var Msg: TMsg; var Handled: Boolean);
begin
 case Msg.Message of
  WM_DROPFILES: WMDropFiles(Msg.wParam, Msg.hWnd);
 end;
end;

procedure TForm1.aDefMapExecute(Sender: TObject);
begin
 If aDefMap.Checked then
  OnLoadTable:=DefaultLoadTable
 else if aNoneMap.Checked then
  OnLoadTable:=BlankTable
 else begin
  OnLoadTable:=CustomTable;
  ConvForm.ShowModal;
 end;
 //ImageList_DrawEx(gd,fg,fg,dg,fdg,dfg,fdg,fdg,dfg,ILD_
 //ImageList1.DrawOverlay(ToolBar1.Canvas,0,0,17,dsNormal,itMask,False);
 //ToolBar1.Canvas.CopyMode:=cm
 //MainMenu.O
 CreateSaveTable;
end;

procedure TForm1.aEmptyAction(Sender: TObject);
begin
 //afsdf
end;

procedure TForm1.aExitExecute(Sender: TObject);
begin
 Close;
end;

procedure TForm1.aLoadMapExecute(Sender: TObject);
var f: File;
    a: Integer;
begin
 if ConvForm.dOpenMap.Execute() then begin
   AssignFile(f, ConvForm.dOpenMap.FileName);
   Reset(f, 256);
   BlockRead(f, OnLoadTable[0], 1);
   CloseFile(f);
   CustomTable:= OnLoadTable;
   CreateSaveTable();
   aCustomMap.Checked:= True;
 end;
end;

procedure TForm1.aMoveUpExecute(Sender: TObject);
var temp1: String;
    temp2: byte;
begin
 If Selected>0 then begin
  temp1:=Entries[Selected-1].Text;
  temp2:=Entries[Selected-1].TType;
  Entries[Selected-1].Text:=Entries[Selected].Text;
  Entries[Selected-1].TType:=Entries[Selected].TType;
  Entries[Selected].Text:=temp1;
  Entries[Selected].TType:=temp2;
  Dec(Selected);
  SetModified;
  DrawTexts(True);
 end;
end;

procedure TForm1.aMoveDownExecute(Sender: TObject);
var temp1: String;
    temp2: byte;
begin
 If Selected<High(Entries)-1 then begin
  temp1:=Entries[Selected+1].Text;
  temp2:=Entries[Selected+1].TType;
  Entries[Selected+1].Text:=Entries[Selected].Text;
  Entries[Selected+1].TType:=Entries[Selected].TType;
  Entries[Selected].Text:=temp1;
  Entries[Selected].TType:=temp2;
  Inc(Selected);
  SetModified;
  DrawTexts(True);
 end;
end;

procedure TForm1.aLockExecute(Sender: TObject);
begin
 If aLock.Checked then begin
  aDelete.Enabled:=False;
  aMoveUp.Enabled:=False;
  aMoveDown.Enabled:=False;
  aInsAbove.Enabled:=False;
  aInsBelow.Enabled:=False;
 end
 else begin
  aDelete.Enabled:=True;
  aMoveUp.Enabled:=True;
  aMoveDown.Enabled:=True;
  aInsAbove.Enabled:=True;
  aInsBelow.Enabled:=True;
 end;
end;

procedure TForm1.aDeleteExecute(Sender: TObject);
var a: Integer;
begin
 for a:=Selected+1 to High(Entries) do begin
  Entries[a-1].Text:=Entries[a].Text;
  Entries[a-1].TType:=Entries[a].TType;
 end;
 SetLength(Entries,Length(Entries)-1);
 SetModified;
 DrawTexts(True);
end;

procedure TForm1.aInsAboveExecute(Sender: TObject);
var a: Integer;
begin
 SetLength(Entries,Length(Entries)+1);
 for a:=High(Entries) downto Selected+1 do begin
  Entries[a].Text:=Entries[a-1].Text;
  Entries[a].TType:=Entries[a-1].TType;
 end;
 Entries[Selected].Text:='';
 Entries[Selected].TType:=1;
 SetModified;
 DrawTexts(True);
end;

procedure TForm1.aInsBelowExecute(Sender: TObject);
var a: Integer;
begin
 SetLength(Entries,Length(Entries)+1);
 for a:=High(Entries) downto Selected+2 do begin
  Entries[a].Text:=Entries[a-1].Text;
  Entries[a].TType:=Entries[a-1].TType;
 end;
 Inc(Selected);
 Entries[Selected].Text:='';
 Entries[Selected].TType:=1;
 SetModified;
 DrawTexts(True);
end;

procedure TForm1.FormResize(Sender: TObject);
begin
 ImgTBuf.Width:=TextPB.Width;
 ImgTBuf.Height:=TextPB.Height;
 ImgTBuf.Picture.Bitmap.Width:=TextPB.Width;
 ImgTBuf.Picture.Bitmap.Height:=TextPB.Height;
 DrawTexts(True);
end;

procedure TForm1.aPreviewExecute(Sender: TObject);
begin
 SetPreviewText(Entries[Selected].Text);
 PrevForm.Show; 
end;

procedure TForm1.FormConstrainedResize(Sender: TObject; var MinWidth,
  MinHeight, MaxWidth, MaxHeight: Integer);
begin
 If PrevForm.btLockTop.Down then PrevForm.Top:=Form1.Top-PrevForm.Height;
 If PrevForm.btLockBtm.Down then PrevForm.Top:=Form1.Top+Form1.Height;
 If PrevForm.btLockTop.Down or PrevForm.btLockBtm.Down then
  PrevForm.Left:=Form1.Left+(Form1.Width-PrevForm.Width) div 2;
 If IntForm.Visible then begin
  IntForm.Left:=Form1.Left-IntForm.Width;
  If reInt.Height<IntForm.ClientHeight then
   IntForm.Top:=(reInt.Height-IntForm.ClientHeight) div 2 +
    ClientToScreen(Point(0,reInt.Top)).Y
  else
   IntForm.Top:=ClientToScreen(Point(0,reInt.Top)).Y;
 end;  
end;

procedure TForm1.StatusDrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
begin
 If Modified then begin
  Status.Canvas.Font.Color:=clYellow;
  Status.Canvas.Brush.Color:=clBlue;
  Status.Canvas.FillRect(Rect);
  Status.Canvas.Font.Style:=[fsBold];
  Status.Canvas.TextOut(Rect.Left+(Rect.Right-Status.Canvas.TextWidth(sModified)) div 2,Rect.Top,sModified);
 end;
end;

procedure TForm1.aOpenRecent(Sender: TObject);
begin
 OpenFile((Sender as TMenuItem).Caption);
end;

procedure TForm1.aAssociateExecute(Sender: TObject);
begin
 SetAssociation;
end;

procedure TForm1.aInternalExecute(Sender: TObject);
begin
 If aInternal.Checked then begin
  RichEdit:=Form1.reInt;
  TypeCombo:=IntForm.cbInt;
 end
 else begin
  RichEdit:=TextForm.reExt;
  TypeCombo:=TextForm.cbExt;
 end;
end;

procedure TForm1.reIntChange(Sender: TObject);
begin
 SetPreviewText(reInt.Text);
 PaintPreview;
end;

procedure TForm1.reIntKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 If ssAlt in Shift then
  case Key of
   70: TextForm.aFindSingle.Execute; //Alt+F
   83: IntForm.SaveBtnClick(Self);   //Alt+S
   67: IntForm.CancelBtnClick(Self); //Alt+C
   84: IntForm.cbInt.SetFocus;       //Alt+T
   80: PrevForm.Show;                //Alt+P
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

procedure TForm1.aTranslatorExecute(Sender: TObject);
var ThreadId: Cardinal;
begin
 Timer1.Enabled:=(aReceiveCom.Checked or aBothCom.Checked);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
 ComSelected:= MapViewOfFile(ComHandle,File_Map_All_Access,0,0,0);
 if (ComSelected^ <> LastComSel)
 and (ComSelected^ <> Selected) and (ComSelected^ <= High(Entries) - 1) then begin
   InternalEnd(IntForm.rgExit.ItemIndex = 1);
   Selected:= ComSelected^;
   CenterSelected();
   SetPreviewText(Entries[Selected].Text);
   PaintPreview();
   LastComSel:= Selected;
 end;
 UnmapViewOfFile(ComSelected);
end;

procedure TForm1.aCloneExecute(Sender: TObject);
begin
 WinExec(PChar(Application.ExeName+' "'+CurrentFile+'"'),sw_Normal);
end;

procedure TForm1.lbGoToMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 eGoTo.SetFocus;
 eGoTo.SelectAll;
end;

procedure TForm1.eGoToKeyPress(Sender: TObject; var Key: Char);
var a: Integer;
begin
 If Key=#13 then begin
  a:=StrToIntDef(eGoTo.Text,-1);
  If a>-1 then begin
   If (a<1) or (a>High(Entries)) then
    MessageBox(Handle,PChar(Format(sGoToRange,[High(Entries)])),'LBA Text Editor 2',MB_ICONWARNING+MB_OK)
   else begin
    Selected:=a-1;
    CenterSelected;
    SendCommand(Selected);
   end;
  end;
  eGoTo.Text:='';
 end;
 If ((Key<'0') or (Key>'9')) and (Key<>#8) then Key:=#0;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if IntForm.Visible then Exit;
 if ((Key = 13) and (eGoTo.Text = '')) //Enter
 or (Key = 113) then begin //F2
   aEdit.Execute();
   Exit;
 end;
 if (Key = 38) and (Selected > 0) then //Up
   Dec(Selected)
 else if (Key = 40) and (Selected < High(Entries) - 1) then //Down
   Inc(Selected)
 else
   Exit;
 FindSelected();
 SendCommand(Selected);
 Key:= 0;
end;

procedure TForm1.mBlueClick(Sender: TObject);
begin
 SwitchColourSet((Sender as TMenuItem).MenuIndex);
end;

procedure TForm1.aExportXMLExecute(Sender: TObject);
begin
 dSave.InitialDir:=CurrentDir;
 dSave.Title:='Save as XML file';
 dSave.Filter:='XML files (*.xml)|*.xml';
 dSave.DefaultExt:='xml';
 dSave.FileName:=ExtractFileName(CurrentFile);
 if dSave.Execute then begin
   CurrentDir:=ExtractFilePath(dSave.FileName);
   SaveToXML(dSave.FileName);
 end;
end;

procedure TForm1.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var Interval: Int64;
begin
 Interval:= MeasureTime(WheelTimer, True);
 if Interval < 1000 then Exit; //1ms

 if ssCtrl in Shift then begin
   if WheelDelta > 0 then
     TextScr.Position:= Max(TextScr.Position - 30, TextScr.Min)
   else if WheelDelta < 0 then
     TextScr.Position:= Min(TextScr.Position + 30, TextScr.Max);
 end else begin
   if (WheelDelta > 0) and (Selected > 0) then
     Dec(Selected)
   else if (WheelDelta < 0) and (Selected < High(Entries) - 1) then
     Inc(Selected)
   else
     Exit;
   FindSelected();
   SendCommand(Selected);
 end;  
end;

end.
