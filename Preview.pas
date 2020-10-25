//******************************************************************************
// LBA Text Editor 2 - editing lbt (text) files from Little Big Adventure 1 & 2
//
// Preview unit.
// Contains routines used for preview.
//
// Copyright (C) Zink
// e-mail: zink@poczta.onet.pl
// See the GNU General Public License (License.txt) for details.
//******************************************************************************

unit Preview;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, StdCtrls;

type
  TPrevForm = class(TForm)
    btLockTop: TSpeedButton;
    btLockBtm: TSpeedButton;
    btClose: TSpeedButton;
    btLoad: TSpeedButton;
    btFont2: TSpeedButton;
    FontDlg: TOpenDialog;
    btOptions: TSpeedButton;
    Timer1: TTimer;
    PanelMain: TPanel;
    Panel2: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    cFont: TColorBox;
    cBack: TColorBox;
    cbRemLast: TCheckBox;
    cbRemSet: TCheckBox;
    cbLbaStyle: TCheckBox;
    cbOnTop: TCheckBox;
    Panel1: TPanel;
    pbPrev: TPaintBox;
    ImgPBuf: TImage;
    sbHoriz: TScrollBar;
    cbWordWrap: TCheckBox;
    sbVert: TScrollBar;
    procedure btCloseClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btLoadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure pbPrevPaint(Sender: TObject);
    procedure btFont2Click(Sender: TObject);
    procedure btOptionsClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btLockBtmClick(Sender: TObject);
    procedure cbOnTopClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TCharImage = Record
   Height, Width: Byte;
   OffsetX, OffsetY: Byte;
   Data: array of Record
    LCount: Byte;
    Lines: array of Byte;
   end;
  end;

const CharCount: Integer = 256;

var
  PrevForm: TPrevForm;

  FontLoaded: Boolean = False;
  FontPath: String;

  LFont: Record
   FileLen: DWord;
   CharOffset: array[0..255] of DWord;
   LChar: array[0..255] of TCharImage;
  end;

  PreviewText: String;

function OpenFont(path: String; ShowErrors: Boolean = True): Boolean;
procedure LoadDefaultFont;
procedure SetPreviewText(Text: String);
procedure PaintPreview;

implementation

{$R *.dfm}
{$R Font.res}

uses LBATxt1, Editor, settings, lang, ConvTbl;

procedure SetPreviewText(Text: String);
var a: Integer;
begin
 PreviewText:=WinToAnsiOnSave(Text);
 While Pos(' '#13,PreviewText)>0 do
  PreviewText:=StringReplace(PreviewText,' '#13,#13,[]);
 PrevForm.sbHoriz.Position:=0;
 PrevForm.sbVert.Position:=0;
end;

function OpenFont(path: String; ShowErrors: Boolean = True): Boolean;
var a, b, c: Integer;
    f: file;
begin
 Result:=False;
 If FileExists(path) then begin
  AssignFile(f,path);
  FileMode:=fmOpenRead;
  Reset(f,1);
  With LFont do begin
   For a:=0 to 255 do
    BlockRead(f,CharOffset[a],4);
   BlockRead(f,FileLen,4);
   If FileSize(f)=FileLen then begin
    For a:=0 to 255 do begin
     BlockRead(f,LChar[a].Width,1);
     BlockRead(f,LChar[a].Height,1);
     BlockRead(f,LChar[a].OffsetX,1);
     BlockRead(f,LChar[a].OffsetY,1);
     SetLength(LChar[a].Data,LChar[a].Height);
     For b:=0 to LChar[a].Height-1 do begin
      BlockRead(f,LChar[a].Data[b].LCount,1);
      SetLength(LChar[a].Data[b].Lines,LChar[a].Data[b].LCount);
      For c:=0 to LChar[a].Data[b].LCount-1 do
       BlockRead(f,LChar[a].Data[b].Lines[c],1);
     end;
    end;
    FontPath:=path;
    Result:=True;
   end
   else
    If ShowErrors then MessageBox(PrevForm.Handle,PChar(sEFontInc),'LBA Text Editor 2',MB_ICONERROR+MB_OK);
   CloseFile(F);
  end;
 end
 else
  If ShowErrors then MessageBox(PrevForm.Handle,PChar(sEFontNotFound),'LBA Text Editor 2',MB_ICONERROR+MB_OK);
end;

procedure LoadDefaultFont;
var FRes: TResourceStream;
    a, b, c: Integer;
begin
 FRes:=TResourceStream.Create(0,'LBA_2_FONT','LBA_FONT_FILE');
 With LFont do begin
  For a:=0 to 255 do
   FRes.Read(CharOffset[a],4);
  FRes.Read(FileLen,4);
  For a:=0 to 255 do begin
   FRes.Read(LChar[a].Width,1);
   FRes.Read(LChar[a].Height,1);
   FRes.Read(LChar[a].OffsetX,1);
   FRes.Read(LChar[a].OffsetY,1);
   SetLength(LChar[a].Data,LChar[a].Height);
   For b:=0 to LChar[a].Height-1 do begin
    FRes.Read(LChar[a].Data[b].LCount,1);
    SetLength(LChar[a].Data[b].Lines,LChar[a].Data[b].LCount);
    For c:=0 to LChar[a].Data[b].LCount-1 do
     FRes.Read(LChar[a].Data[b].Lines[c],1);
   end;
  end;
 end;
 FontPath:='!default';
 Fres.Free;
end;

Procedure PaintChar(Code: Byte; x, y: Integer; Colour: TColor);
var a, b, c, e, yy: Integer;
begin
 PrevForm.ImgPBuf.Canvas.Pen.Color:=Colour;
 With LFont.LChar[Code] do
  For a:=0 to Height-1 do begin
   c:=0;
   e:=x+OffsetX;
   For b:=0 to Data[a].LCount-1 do begin
    If c=1 then begin
     PrevForm.ImgPBuf.Canvas.MoveTo(e,a+y+OffsetY);
     PrevForm.ImgPBuf.Canvas.LineTo(e+Data[a].Lines[b],a+y+OffsetY);
     c:=0;
    end
    else c:=1;
    Inc(e,Data[a].Lines[b]);
   end;
  end;
end;

procedure UpdateImage;
begin
 PrevForm.pbPrev.Canvas.CopyRect(Rect(0,0,PrevForm.pbPrev.Width,PrevForm.pbPrev.Height),
  PrevForm.ImgPBuf.Canvas,Rect(0,0,PrevForm.ImgPBuf.Width,PrevForm.ImgPBuf.Height));
end;

function NextWordWidth(Index: Integer): Integer;
var a, b: Integer;
begin
 b:=0;
 for a:=Index+1 to Length(PreviewText) do begin
  If (PreviewText[a]=#32) or (PreviewText[a]=#13) then Break;
  Inc(b,LFont.LChar[Ord(PreviewText[a])].Width+2);
 end;
 Result:=b;
end;

procedure PaintPreview;
var a, b, d: Integer;
    c: byte;
begin
 With PrevForm do begin
  ImgPBuf.Canvas.Brush.Color:=cBack.Selected;
  ImgPBuf.Canvas.FillRect(Rect(0,0,ImgPBuf.Width,ImgPBuf.Height));
  If cbWordWrap.Checked then begin
   b:=2;
   d:=2-sbVert.Position;
   for a:=1 to Length(PreviewText) do begin
    c:=Ord(PreviewText[a]);
    If ((d+40>=-2) and (d<=pbPrev.Height))
    and (c<>32) and (c<>13) and (c<>10) then begin
     if cbLbaStyle.Checked then
      PaintChar(c,b+2,d+6,clBlack);
     PaintChar(c,b,d+2,cFont.Selected);
    end;
    If c=32 then begin
     If b+NextWordWidth(a){-PrevSpacesWidth(a)}+15>pbPrev.Width then begin
      Inc(d,40);
      b:=2;
     end
     else Inc(b,15);
    end
    else if c<>10 then Inc(b,LFont.LChar[c].Width+2);
    If c=13 then begin Inc(d,40); b:=2; end;
   end;
   Inc(d,40);
   If d+2+sbVert.Position>pbPrev.Height then begin
    sbVert.Max:=d+2+sbVert.Position;
    sbVert.PageSize:=pbPrev.Height;
    sbVert.Enabled:=True;
   end
   else begin
    sbVert.Enabled:=False;
    sbVert.Position:=0;
   end;
   sbHoriz.Enabled:=False;
  end
  else begin
   b:=2-sbHoriz.Position;
   for a:=1 to Length(PreviewText) do begin
    c:=Ord(PreviewText[a]);
    If ((b+LFont.LChar[c].Width>=-2) and (b<=pbPrev.Width))
    and (c<>32) and (c<>13) and (c<>10) then begin
     if cbLbaStyle.Checked then
      PaintChar(c,b+2,6,clBlack);
     PaintChar(c,b,2,cFont.Selected);
    end;
    If (c=32) or (c=13) or (c=10) then Inc(b,15) else Inc(b,LFont.LChar[c].Width+2);
   end;
   If b+2+sbHoriz.Position>pbPrev.Width then begin
    sbHoriz.Max:=b+2+sbHoriz.Position;
    sbHoriz.PageSize:=pbPrev.Width;
    sbHoriz.Enabled:=True;
   end
   else begin
    sbHoriz.Enabled:=False;
    sbHoriz.Position:=0;
   end;
   sbVert.Enabled:=False;
  end;
 end;
 UpdateImage;
end;

procedure TPrevForm.btCloseClick(Sender: TObject);
begin
 Close;
end;

procedure TPrevForm.FormResize(Sender: TObject);
begin
 ImgPBuf.Width:=pbPrev.Width;
 ImgPBuf.Height:=pbPrev.Height;
 ImgPBuf.Picture.Bitmap.Width:=pbPrev.Width;
 ImgPBuf.Picture.Bitmap.Height:=pbPrev.Height;
 PaintPreview;
end;

procedure TPrevForm.btLoadClick(Sender: TObject);
begin
 FontDlg.InitialDir:=FontDir;
 If FontDlg.Execute then begin
  FontDir:=ExtractFilePath(FontDlg.FileName);
  If not OpenFont(FontDlg.FileName) then
   LoadDefaultFont;
  PaintPreview;
 end;
end;

procedure TPrevForm.FormCreate(Sender: TObject);
begin
 //PrevForm.DoubleBuffered:=True;
 Panel1.DoubleBuffered:=True;
end;

procedure TPrevForm.pbPrevPaint(Sender: TObject);
begin
 PaintPreview;
end;

procedure TPrevForm.btFont2Click(Sender: TObject);
begin
 LoadDefaultFont;
 PaintPreview;
end;

procedure TPrevForm.btOptionsClick(Sender: TObject);
var a: Integer;
begin
 btOptions.Enabled:=False;
 If btOptions.Down then begin
  for a:=0 to 4 do begin
   Panel2.Top:=PanelMain.Height-a*16;
   Panel1.Top:=-a*16;
   Panel1.Refresh;
   Panel2.Refresh;
  end;
 end
 else begin
  for a:=4 downto 0 do begin
   Panel2.Top:=PanelMain.Height-a*16;
   Panel1.Top:=-a*16;
   Panel1.Refresh;
   Panel2.Refresh;
  end;
 end;
 btOptions.Enabled:=True;
end;

procedure TPrevForm.Timer1Timer(Sender: TObject);
begin
 Timer1.Enabled:=False;
end;

procedure TPrevForm.btLockBtmClick(Sender: TObject);
begin
 If btLockTop.Down or btLockBtm.Down then begin
  PrevForm.Width:=PrevForm.ClientWidth;
  PrevForm.Height:=PrevForm.ClientHeight;
  PrevForm.BorderStyle:=bsNone;
  Form1.Realign;
 end
 else begin
  PrevForm.BorderStyle:=bsSizeable;
  PrevForm.ClientWidth:=PrevForm.Width;
  PrevForm.ClientHeight:=PrevForm.Height;
 end;
end;

procedure TPrevForm.cbOnTopClick(Sender: TObject);
begin
 If cbOnTop.Checked then PrevForm.FormStyle:=fsStayOnTop
 else PrevForm.FormStyle:=fsNormal;
end;

end.
