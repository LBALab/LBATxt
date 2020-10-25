unit XML;

interface

uses StrUtils, files, SysUtils;

procedure SaveToXML(path: string);
procedure ReadFromXML(path: string);

implementation

uses LBATxt1, Preview;

function NewLinesToTags(s: String): String;
begin
 s:=AnsiReplaceText(s,#10,'');
 Result:=AnsiReplaceText(s,#13,'<linebreak />');
end;

function TagsToNewLines(s: String): String;
begin
 s:=AnsiReplaceText(s,'<linebreak',#13#10);
 Result:=AnsiReplaceText(s,' />','');
end;

procedure SaveToXML(path: string);
var f: TextFile;
    a: Integer;
begin
 AssignFile(f,path);
 Rewrite(f);

 WriteLn(f,'<?xml version="1.0" encoding="ISO-8859-1" ?>');
 WriteLn(f,'');
 WriteLn(f,'<lbatexts>');
 WriteLn(f,'  <game>'+IfThen(Lba2,'2','1')+'</game>');
 WriteLn(f,'  <quotes>');

 for a:=0 to High(Entries)-1 do
  WriteLn(f,Format('    <quote id="%d" type="%d">%s</quote>',
   [a+1,Entries[a].TType,NewLinesToTags(Entries[a].Text)]));

 WriteLn(f,'  </quotes>');
 WriteLn(f,'</lbatexts>');

 CloseFile(f);
 SaveFinish(path);
end;

procedure ParseQuoteTag(tag: String; var id: Integer; var qtype: byte);
var a, b, start, spos: Integer;
    temp, varname, varval: String;
begin
 start:=1;
 for a:=1 to Length(tag) do
  if (a=Length(tag)) or (tag[a+1]=' ') then begin
   temp:=Copy(tag,start,a-start+1);
   spos:=Pos('=',temp);
   if spos>0 then begin
    varname:=Copy(temp,1,spos-1);
    varval:=AnsiDequotedStr(Copy(temp,spos+1,Length(temp)-spos),'"');
    if varname='id' then id:=StrToIntDef(varval,1)
    else if varname='type' then qtype:=StrToIntDef(varval,0);
   end;
   start:=a+2;
  end;
end;

procedure ReadFromXML(path: string);
var f: File;
    a, b, tagsize, tagnamesize, gamestart, id, quotestart: Integer;
    ttype: Byte;
    buf, tag, tagname, game, quote: String;
begin
 AssignFile(f,path);
 Reset(f,1);
 SetLength(buf,FileSize(f));
 BlockRead(f,buf[1],Length(buf));
 CloseFile(f);

 SetLength(Entries,0);
 a:=0;
 gamestart:=-1;
 quotestart:=-1;
 repeat
  repeat Inc(a) until (buf[a]='<') or (a>=Length(buf));
  tagsize:=0;
  tagnamesize:=0;
  repeat
   Inc(tagsize);
   if (tagnamesize=0) and ((buf[a+tagsize]=' ') or (buf[a+tagsize]='>')) then
    tagnamesize:=tagsize;
  until (buf[a+tagsize]='>') or (a+tagsize>=Length(buf));
  tag:=Trim(Copy(buf,a+1,tagsize-1));
  tagname:=Trim(Copy(buf,a+1,tagnamesize-1));
  If tagname='game' then gamestart:=a+tagsize+1
  else if tagname='/game' then begin
   game:=Trim(Copy(buf,gamestart,a-gamestart));
   gamestart:=-1;
  end
  else if tagname='quote' then begin
   ParseQuoteTag(tag,id,ttype);
   quotestart:=a+tagsize+1;
  end
  else if tagname='/quote' then begin
   quote:=Copy(buf,quotestart,a-quotestart);
   If Length(Entries)<=id then SetLength(Entries,id+1);
   Entries[id-1].TType:=ttype;
   Entries[id-1].Text:=TagsToNewLines(quote);
   quotestart:=-1;
  end;
  Inc(a,tagsize);
 until a>=Length(buf);

 Lba2:=game='2';

 LoadFinish(path);
end;

end.
