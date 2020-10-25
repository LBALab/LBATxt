//******************************************************************************
// LBA Text Editor 2 - editing lbt (text) files from Little Big Adventure 1 & 2
//
// Files unit.
// Contains lbt files opening/saving routines.
//
// Copyright (C) Zink
// e-mail: zink@poczta.onet.pl
// See the GNU General Public License (License.txt) for details.
//******************************************************************************

unit files;

interface

uses Windows, SysUtils, Forms, Controls, Menus, CompMods;

var
  Entries: array of Record
   Text: String;
   Offset: Word;
   YPos: Integer;
   TType: Byte;
  end;

  Lba2: Boolean = False;
  Loaded: Boolean = False;
  CurrentFile: String;

function GetLongName(ShortName: String): String;
procedure AddToRecent(path: String);
Procedure SetModified;
Procedure ClearModified;
Procedure CheckFileSave;
procedure OpenFile(path: String);
procedure LoadTexts(path: String; CheckType: Boolean = True);
procedure LoadFinish(path: String);
Procedure CalcOffsets;
Procedure SaveTexts(path: String);
procedure SaveFinish(path: String);

implementation

uses LBATxt1, lang, Editor, ConvTbl, Preview, Settings, IntEditor, XML;

function Smaller(v1, v2: Integer): Integer;
begin
 If v1<v2 then Result:=v1 else Result:=v2;
end;

function GetLongName(ShortName: String): String;
var sr: TSearchRec;
begin
 Result:='';
 If {(pos('\\', ShortName)+pos('*', ShortName)+pos('?', ShortName)<>0)
 or} not FileExists(ShortName) then
  Result:= ShortName
 else begin
  While FindFirst(ShortName,faAnyFile,sr)=0 do begin
   Result:= '\' + sr.Name + Result;
   SysUtils.FindClose(sr);
   ShortName:= ExtractFileDir(ShortName);
   If Length(ShortName) <= 2 then Break;
  end;
  Result:= ExtractFileDrive(ShortName)+Result;
 end;
end;

procedure AddToRecent(path: String);
var a: Integer;
    temp: TMenuItem;
begin
 path:=GetLongName(path);
 With Form1 do begin
  for a:=0 to Smaller(mRecent.Count,9)-1 do
   if AnsiSameText(path,mRecent.Items[a].Caption) then break;
  If a<mRecent.Count then begin
   temp:=mRecent.Items[a];
   mRecent.Delete(a);
   mRecent.Insert(0,temp);
   mRecent.Items[0].Caption:=path;
  end
  else begin
   mRecent.Insert(0,NewItem(path,0,False,True,aOpenRecent,0,''));
   ModMenu.UpdateMenuItem(mRecent.Items[0],False);
  end;
  mRecent.Enabled:=mRecent.Count>0;
 end;
end;

Procedure SetModified;
begin
 Modified:=True;
 Form1.aSave.Enabled:=True;
 Form1.Status.Repaint;
end;

Procedure ClearModified;
begin
 Modified:=False;
 Form1.aSave.Enabled:=False;
 Form1.Status.Repaint;
end;

Procedure CheckFileSave;
begin
 If Modified then
  Case MessageBox(Form1.Handle,PChar(sQModified),'LBA Text Editor 2',MB_ICONQUESTION+MB_YESNOCANCEL)
  of
   IDYES:SaveTexts(CurrentFile);
   IDCANCEL:Abort;
  end;
end;

Function ConvertToLBA(src: String): String;
var a: Integer;
    Buff: String;
begin
 If Length(src)>2 then begin
  Buff:='';
  a:=1;
  repeat
   If (a<Length(src)) and (src[a]=#13) and (src[a+1]=#10) then begin
    Buff:=Buff+' @';
    Inc(a);
   end
   else
    Buff:=Buff+src[a];
   Inc(a);
  until a>Length(src);
 end
 else buff:=src;
 Result:=Buff;
end;

procedure OpenFile(path: String);
var ext: String;
begin
 CheckFileSave;
 If FileExists(path) then begin
  ext:=ExtractFileExt(path);
  If ext='.lbt' then LoadTexts(path)
  else if ext='.xml' then ReadFromXML(path);
 end;
end;

procedure LoadTexts(path: String; CheckType: Boolean = True);
var ff: File;
    a, b: Integer;
    Buff: Char;
begin
 AssignFile(ff,path);
 Reset(ff,1);
 SetLength(Entries,1);
 Entries[0].Text:='';
 BlockRead(ff,Entries[0].Offset,2);
 SetLength(Entries,Entries[0].Offset div 2);
 for a:=1 to High(Entries) do
  BlockRead(ff,Entries[a].Offset,2);
 If Entries[High(Entries)].Offset<>FileSize(ff) then
  If MessageBox(Form1.handle,PChar(sEInvOffs),'LBA Text Editor 2',MB_ICONQUESTION+MB_YESNO)=ID_NO then begin
   SetLength(Entries,2);
   Entries[0].Text:=sStartup1+#13#10#13#10+sStartup2+#13#10+Format(sStartup3,[VerNum]);
   DrawTexts(True);
   Loaded:=False;
   Form1.Caption:='LBA Text Editor 2';
   Form1.Status.Panels[1].Text:='LBA ?';
   CloseFile(ff);
   Abort;
  end;
 If CheckType then begin
  If Form1.aAutoDetect.Checked then begin
   Lba2:=True;
   for a:=0 to High(Entries)-1 do begin
    Seek(ff,Entries[a].Offset);
    BlockRead(ff,Buff,1);
    If (Buff<>#01) and (Buff<>#03) and (Buff<>#05) and (Buff<>#09) and (Buff<>#17)
    and (Buff<>#33) and (Buff<>#35) and (Buff<>#65) and (Buff<>#129) then begin
     Lba2:=False;
     Break;
    end;
   end;
   Seek(ff,Entries[0].Offset);
  end
  else
   Lba2:=MessageBox(Form1.Handle,PChar(sQType),PChar(sQTType),MB_ICONQUESTION+MB_YESNO)<>ID_YES;
 end;

 For a:=0 to High(Entries)-1 do begin
  If Lba2 then BlockRead(ff,Entries[a].TType,1);
  For b:=Entries[a].Offset+Byte(Lba2) to Entries[a+1].Offset-1 do begin
   BlockRead(ff,Buff,1);
   If Buff<>#0 then
    If Buff='@' then begin
     If Entries[a].Text[Length(Entries[a].Text)]=' ' then
      Entries[a].Text[Length(Entries[a].Text)]:=#13
     else
      Entries[a].Text:=Entries[a].Text+#13;
     Entries[a].Text:=Entries[a].Text+#10;
    end
    else
     Entries[a].Text:=Entries[a].Text+Buff;
  end;
  Entries[a].Text:=AnsiToWinOnLoad(Entries[a].Text);
 end;
 CloseFile(ff);
 LoadFinish(path);
end;

procedure LoadFinish(path: String);
begin
 TextForm.cbExt.Enabled:=Lba2;
 IntForm.cbInt.Enabled:=Lba2;
 Form1.Caption:='LBA Text Editor 2 - '+ExtractFileName(path);
 Form1.Status.Panels[1].Text:=Format('LBA %d',[1+Byte(LBA2)]);
 Selected:=0;
 Form1.TextScr.Position:=0;
 Form1.eGoTo.MaxLength:=Length(IntToStr(High(Entries)));
 DrawTexts(True);
 SetPreviewText(Entries[Selected].Text);
 PaintPreview;
 Loaded:=True;
 CurrentFile:=path;
 AddToRecent(path);
 ClearModified;
 Beep;
end;

Procedure CalcOffsets;
var a: Integer;
    b: Word;
begin
 b:=Length(Entries)*2;
 For a:=0 to High(Entries) do begin
  Entries[a].Offset:=b;
  Inc(b,Length(ConvertToLba(Entries[a].Text))+1+Byte(Lba2));
 end;
end;

Procedure SaveTexts(path: String);
var ff: File;
    a, b: Integer;
    Buff: String;
    nullcode: Byte;
begin
 Screen.Cursor:=crHourGlass;
 nullcode:=0;
 CalcOffsets;
 AssignFile(ff,path);
 Rewrite(ff,1);
 For a:=0 to High(Entries) do
  BlockWrite(ff,Entries[a].Offset,2);
 For a:=0 to High(Entries)-1 do begin
  Buff:=WinToAnsiOnSave(ConvertToLba(Entries[a].Text));
  If Lba2 then BlockWrite(ff,Entries[a].TType,1);
  For b:=1 to Length(Buff) do
   BlockWrite(ff,Buff[b],1);
  BlockWrite(ff,nullcode,1);
 end;
 CloseFile(ff);
 SaveFinish(path);
end;

procedure SaveFinish(path: String);
begin
 ClearModified;
 Form1.Caption:='LBA Text Editor 2 - '+ExtractFileName(path);
 CurrentFile:=path;
 AddToRecent(path);
 Beep;
 Screen.Cursor:=crDefault;
end;

end.
