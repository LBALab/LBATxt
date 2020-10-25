//******************************************************************************
// LBA Text Editor 2 - editing lbt (text) files from Little Big Adventure 1 & 2
//
// Settings unit.
// Contains routines used for saving and reading the program settings.
//
// Copyright (C) Zink
// e-mail: zink@poczta.onet.pl
// See the GNU General Public License (License.txt) for details.
//******************************************************************************

unit settings;

interface

uses IniFiles, SysUtils, Windows, Forms, ActnList, Registry, Menus, Classes, CompMods;

var
 CfgFile: TIniFile;
 CurrentDir: String;
 FontDir: String;
 
procedure SetAssociation;
procedure SaveSettings;
procedure LoadSettings;

implementation

uses LBATxt1, lang, ConvTbl, Preview, IntEditor, Files;

function ExpandNumber(val: Integer): String;
var buf, valstr: String;
begin
 valstr:=IntToStr(val);
 if Length(valstr)<3 then begin
  buf:='000';
  SetLength(buf,3-Length(valstr));
  Result:=buf+valstr;
 end
 else
  Result:=valstr;
end;

procedure SetAssociation;
var Rejestr: TRegIniFile;
begin
 Rejestr:=TRegIniFile.Create('');
 Rejestr.RootKey:=HKEY_CLASSES_ROOT;
 If Form1.aAssociate.Checked then begin
  Rejestr.WriteString('.lbt','','LBA_text');
  Rejestr.WriteString('LBA_text','','LBA Text file');
  Rejestr.WriteString('LBA_text','Created by','LBA Text Editor');
  Rejestr.WriteString('LBA_text\DefaultIcon','',Application.ExeName+',1');
  Rejestr.WriteString('LBA_text\shell','','open');
  Rejestr.WriteString('LBA_text\shell\open\command','','"'+Application.ExeName+'" "%1"');
 end
 else begin
  If Rejestr.ReadString('LBA_text','Created by','')='LBA Text Editor'
  then begin
   Rejestr.EraseSection('.lbt');
   Rejestr.EraseSection('LBA_text');
  end;
 end;
 Rejestr.Destroy;
end;

procedure SaveSettings;
var Buffer: Integer;
    TableStr: String;
    a: Integer;
begin
 CfgFile:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'LBATxt.ini');
 With CfgFile,Form1 do begin
  WriteInteger('General','Language',CurrentLang);
  WriteString('General','LangFile',LangFile);
  WriteString('General','LastDir',CurrentDir);
  WriteString('General','LastFontDir',FontDir);
  WriteBool('General','AutoDetect',aAutoDetect.Checked);
  WriteBool('General','Associate',aAssociate.Checked);
  WriteBool('General','Internal',aInternal.Checked);
  WriteInteger('General','ColourSet',ColourSetIndex);
  WriteInteger('General','EditorExit',IntForm.rgExit.ItemIndex);
  If aLtr.Checked then Buffer:=0
  else if aRtl.Checked then Buffer:=1
  else if aRtlNa.Checked then Buffer:=2
  else if aRtlRo.Checked then Buffer:=3;
  WriteInteger('General','Direction',Buffer);
  If aDefault.Checked then Buffer:=0
  else if aAnsi.Checked then Buffer:=1
  else if aArabic.Checked then Buffer:=2
  else if aBaltic.Checked then Buffer:=3
  else if aChineseBig5.Checked then Buffer:=4
  else if aEastEurope.Checked then Buffer:=5
  else if aGB2312.Checked then Buffer:=6
  else if aGreek.Checked then Buffer:=7
  else if aHangeul.Checked then Buffer:=8
  else if aHebrew.Checked then Buffer:=9
  else if aJohab.Checked then Buffer:=10
  else if aMac.Checked then Buffer:=11
  else if aOem.Checked then Buffer:=12
  else if aRussian.Checked then Buffer:=13
  else if aShiftjis.Checked then Buffer:=14
  else if aThai.Checked then Buffer:=15
  else if aTurkish.Checked then Buffer:=16;
  WriteInteger('General','Charset',Buffer);
  WriteBool('Preview','RememberFont',PrevForm.cbRemLast.Checked);
  WriteString('Preview','LastFont',FontPath);
  WriteBool('Preview','RememberSet',PrevForm.cbRemSet.Checked);
  WriteBool('Preview','LbaStyle',PrevForm.cbLbaStyle.Checked);
  WriteInteger('Preview','FontColour',PrevForm.cFont.ItemIndex);
  WriteInteger('Preview','BackColour',PrevForm.cBack.ItemIndex);
  WriteBool('Preview','StayOnTop',PrevForm.cbOnTop.Checked);
  WriteBool('Preview','WordWrap',PrevForm.cbWordWrap.Checked);
  If aDefMap.Checked then Buffer:=0
  else if aNoneMap.Checked then Buffer:=1
  else if aCustomMap.Checked then Buffer:=2;
  WriteInteger('Conversion','LastMap',Buffer);
  WriteBool('Conversion','Remember',aRemember.Checked);
  TableStr:='';
  for a:=0 to 255 do
   TableStr:=TableStr+ExpandNumber(Ord(CustomTable[a]));
  WriteString('Conversion','MapData',TableStr);
  WriteInteger('Conversion','ViewAs',ConvForm.rgDec.ItemIndex);
  WriteInteger('Conversion','ToEdit',ConvForm.rgEdit.ItemIndex);
  WriteInteger('Conversion','OnExit',ConvForm.rgExit.ItemIndex);
  for a:=0 to mRecent.Count-1 do
   WriteString('Recent',IntToStr(a),mRecent.Items[a].Caption);
  for a:=mRecent.Count to 9 do
   DeleteKey('Recent',IntToStr(a));
 end;
 CfgFile.Destroy;

 //CfgFile:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'zzz.ini');
 //CfgFile.WriteString('gfsdsdg','sgsgs','asdgfs'#13#10'fsdhfusd');
 //CfgFile.Destroy;
end;

procedure LoadSettings();
var Buffer: Integer;
    TableStr, capt: String;
    a, b: Integer;
begin
 CfgFile:= TIniFile.Create(ExtractFilePath(Application.ExeName)+'LBATxt.ini');
 With CfgFile,Form1 do begin
  LangFile:=ReadString('General','LangFile','');
  SetLang(ReadInteger('General','Language',1));
  CurrentDir:=ReadString('General','LastDir',ExtractFilePath(Application.ExeName));
  FontDir:=ReadString('General','LastFontDir',CurrentDir);
  aAutoDetect.Checked:=ReadBool('General','AutoDetect',True);
  aAssociate.Checked:=ReadBool('General','Associate',False);
  aInternal.Checked:=ReadBool('General','Internal',True);
  aInternalExecute(Form1);
  SwitchColourSet(ReadInteger('General','ColourSet',0));
  mColourSet.Items[ColourSetIndex].Checked:=True;
  IntForm.rgExit.ItemIndex:=ReadInteger('General','EditorExit',0);
  Buffer:=ReadInteger('General','Direction',0);
  case Buffer of
   0: aLtr.Checked:=True;
   1: aRtl.Checked:=True;
   2: aRtlNa.Checked:=True;
   3: aRtlRo.Checked:=True;
  end;
  Form1.aBiDiExecute(Form1);
  Buffer:=ReadInteger('General','Charset',0);
  case Buffer of
   0: aDefault.Checked:=True;
   1: aAnsi.Checked:=True;
   2: aArabic.Checked:=True;
   3: aBaltic.Checked:=True;
   4: aChineseBig5.Checked:=True;
   5: aEastEurope.Checked:=True;
   6: aGB2312.Checked:=True;
   7: aGreek.Checked:=True;
   8: aHangeul.Checked:=True;
   9: aHebrew.Checked:=True;
   10: aJohab.Checked:=True;
   11: aMac.Checked:=True;
   12: aOem.Checked:=True;
   13: aRussian.Checked:=True;
   14: aShiftjis.Checked:=True;
   15: aThai.Checked:=True;
   16: aTurkish.Checked:=True;
  end;

  PrevForm.cbRemLast.Checked:=ReadBool('Preview','RememberFont',False);
  TableStr:=ReadString('Preview','LastFont','!default');
  If not PrevForm.cbRemLast.Checked or (TableStr='!default') or not OpenFont(TableStr,False) then LoadDefaultFont;
  PrevForm.cbRemSet.Checked:=ReadBool('Preview','RememberSet',False);
  If PrevForm.cbRemSet.Checked then begin
   PrevForm.cbLbaStyle.Checked:=ReadBool('Preview','LbaStyle',False);
   PrevForm.cFont.ItemIndex:=ReadInteger('Preview','FontColour',0);
   PrevForm.cBack.ItemIndex:=ReadInteger('Preview','BackColour',15);
   PrevForm.cbOnTop.Checked:=ReadBool('Preview','StayOnTop',False);
   PrevForm.cbOnTopClick(Form1);
   PrevForm.cbWordWrap.Checked:=ReadBool('Preview','WordWrap',False);
  end;

  aRemember.Checked:=ReadBool('Conversion','Remember',False);
  If aRemember.Checked then begin
   Buffer:=ReadInteger('Conversion','LastMap',0);
   case Buffer of
    0: aDefMap.Checked:=True;
    1: aNoneMap.Checked:=True;
    2: aCustomMap.Checked:=True;
   end;
  end
  else Buffer:=0;
  TableStr:=ReadString('Conversion','MapData','');
  If Length(TableStr)=256*3 then
   for a:=0 to 255 do
    CustomTable[a]:=Chr(StrToInt(Copy(TableStr,a*3+1,3)))
  else begin
   CustomTable:=DefaultLoadTable;
   if Buffer=2 then begin
    MessageBox(Handle,PChar(sWConvIni),'Lba Text Editor 2',MB_ICONWARNING+MB_OK);
    aDefMap.Checked:=True;
   end;
  end;
  Case Buffer of
   0:OnLoadTable:=DefaultLoadTable;
   1:OnLoadTable:=BlankTable;
   2:OnLoadTable:=CustomTable;
  end;
  CreateSaveTable;
  ConvForm.rgDec.ItemIndex:=ReadInteger('Conversion','ViewAs',1);
  ConvForm.rgEdit.ItemIndex:=ReadInteger('Conversion','ToEdit',1);
  ConvForm.rgExit.ItemIndex:=ReadInteger('Conversion','OnExit',0);

  for a:=0 to 9 do begin
   capt:=GetLongName(ReadString('Recent',IntToStr(a),''));
   If capt<>'' then
    mRecent.Add(NewItem(capt,0,False,True,aOpenRecent,0,''));
  end;
  ModMenu.UpdateMenuItem(mRecent,True);
  mRecent.Enabled:=mRecent.Count>0;
 end;
 CfgFile.Destroy;
 SetAssociation;
end;

{function GetVersion: ShortString;  I couldn't get it to work
const
  InfoNum = 10;
  InfoStr: array[1..InfoNum] of string = ('CompanyName', 'FileDescription', 'FileVersion', 'InternalName', 'LegalCopyright', 'LegalTradeMarks', 'OriginalFileName', 'ProductName', 'ProductVersion', 'Comments');
var
 S: string;
 n, Len, i: DWORD;
 Buf: PChar;
 Value: PChar;
begin
 S := Application.ExeName;
 i:=0;
 n := GetFileVersionInfoSize(PChar(S), i);
 Result:='';
 if n>0 then begin
  Buf:=AllocMem(n);
  GetFileVersionInfo(PChar(S),0,n,Buf);
  for i := 1 to InfoNum do
   if VerQueryValue(Buf, '\', Pointer(Value), Len) then
    Form1.Memo1.Lines.Add(InfoStr[i] + ' = ' + Value);

 //  Result:=Value;
  FreeMem(Buf, n);
 end;
 //Form1.Memo1.Lines.Add(Result);
end;}

end.
