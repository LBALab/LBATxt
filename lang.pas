//******************************************************************************
// LBA Text Editor 2 - editing lbt (text) files from Little Big Adventure 1 & 2
//
// Lang unit.
// Contains language changing routines.
//
// Copyright (C) Zink
// e-mail: zink@poczta.onet.pl
// See the GNU General Public License (License.txt) for details.
//******************************************************************************

unit lang;

interface

uses ActnList, SysUtils, Classes, IniFiles;

var
 sQModified, sText, sOffset, sFSize, sQType, sQTType, sStartup1, sStartup2,
 sStartup3, sWExists, sWTExists, sFind, sReplace, sNotFound, sModified, sEInvOffs,
 sEOneFile, sMFound, sWConvIni, sEFontInc, sEFontNotFound, sCancel, sSECapt,
 sGoToRange: String;

 Types: TStringList;

 CurrentLang: Byte;
 LangFile: String;
 LangIni: TIniFile;

procedure SetLang(Index: Integer);

implementation

uses LbaTxt1, Editor, Find, Forms, Preview, ConvTbl, files, IntEditor;

procedure SetHints;
var a: Integer;
begin
 With Form1 do
  For a:=0 to ComponentCount-1 do
   If Components[a] is TAction then
    (Components[a] as TAction).Hint:=(Components[a] as TAction).Caption;
end;

procedure SetLang(Index: Integer);
begin
 Types:=TStringList.Create;
 If (Index=1) or (Index=2) then begin
  if Index=1 then begin
   LangIni:=TIniFile.Create('');
   Form1.aEnglish.Checked:=True;
  end
  else begin
   LangIni:=TIniFile.Create(LangFile);
   Form1.aLangFile.Checked:=True;
  end;
  With LangIni do begin
   sCancel:=ReadString('Lang','sCancel','Cancel');
   sFind:=ReadString('Lang','sFind','Find');
   sQModified:=ReadString('Lang','sQModified','The file has been modified. Do you want to save changes?');
   sText:=ReadString('Lang','sText','Text %d of %d');
   sOffset:=ReadString('Lang','sOffset','Offset: %d');
   sFSize:=ReadString('Lang','sFSize','File size: %d');
   sQType:=ReadString('Lang','sQType','Is this LBA1 text file?');
   sQTType:=ReadString('Lang','sQTType','Choose file type');
   sStartup1:=ReadString('Lang','sStartup1','*** No file loaded ***');
   sStartup2:=ReadString('Lang','sStartup2',' Little Big Adventure 1/2 text file editor version %s, Copyright '#169' Zink.');
   sStartup3:=ReadString('Lang','sStartup3',' LBA Text Editor 2 comes with ABSOLUTELY NO WARRANTY; for details see License.txt. This is free software, and you are welcome to redistribute it under certain conditions; see License.txt for details.');
   sWExists:=ReadString('Lang','sWExists','File doesn''t exist !');
   sWTExists:=ReadString('Lang','sWTExists','Error');
   sModified:=ReadString('Lang','sModified','Modified');
   sEInvOffs:=ReadString('Lang','sEInvOffs','Last offset does not match file size. The file may be broken. Load it anyway?');
   sEOneFile:=ReadString('Lang','sEOneFile','You can''t open more than one file at the same time.');
   sMFound:=ReadString('Lang','sMFound','Found and replaced %d occurences.');
   sWConvIni:=ReadString('Lang','sWConvIni','Conversion map in the ini file is incorrect. Default map will be used instead.');
   sEFontInc:=ReadString('Lang','sEFontInc','Font file is incorrect or broken. Default font will be loaded.');
   sEFontNotFound:=ReadString('Lang','sEFontNotFound','Font file not found. Default font will be loaded.');
   sGoToRange:=ReadString('Lang','sGoToRange','Index must be between 1 and %d!');
   Form1.aEdit.Caption:=ReadString('Lang','aEdit','Edit selected entry...');
   Form1.aPreview.Caption:=ReadString('Lang','aPreview','Preview selected entry');
   Form1.aFind.Caption:=sFind+'...';
   Form1.aFindNext.Caption:=ReadString('Lang','aFindNext','Find next');
   Form1.aFindRep.Caption:=ReadString('Lang','aFindRep','Find and replace');
   Form1.aDelete.Caption:=ReadString('Lang','aDelete','Delete selected entry');
   Form1.aMoveUp.Caption:=ReadString('Lang','aMoveUp','Move up');
   Form1.aMoveDown.Caption:=ReadString('Lang','aMoveDown','Move down');
   Form1.aInsAbove.Caption:=ReadString('Lang','aInsAbove','Insert above');
   Form1.aInsBelow.Caption:=ReadString('Lang','aInsBelow','Insert below');
   Form1.aLock.Caption:=ReadString('Lang','aLock','Lock file structure');
   Form1.aLtr.Caption:=ReadString('Lang','aLtr','Left to right');
   Form1.aRtl.Caption:=ReadString('Lang','aRtl','Right to left');
   Form1.aRtlNa.Caption:=ReadString('Lang','aRtlNa','Right to left - no align');
   Form1.aRtlRo.Caption:=ReadString('Lang','aRtlRo','Right to left - reading only');
   Form1.aDefault.Caption:=ReadString('Lang','aDefault','Default');
   Form1.aHebrew.Caption:=ReadString('Lang','aHebrew','Hebrew');
   Form1.aDefMap.Caption:=ReadString('Lang','aDefMap','Default (used in Lba)');
   Form1.aNoneMap.Caption:=ReadString('Lang','aNoneMap','None');
   Form1.aCustomMap.Caption:=ReadString('Lang','aCustomMap','Custom...');
   Form1.aLoadMap.Caption:=ReadString('Lang','aLoadMap','Load from file');
   Form1.aRemember.Caption:=ReadString('Lang','aRemember','Remember last map');
   Form1.aAutoDetect.Caption:=ReadString('Lang','aAutodetect','Autodetect file type');
   Form1.aAssociate.Caption:=ReadString('Lang','aAssociate','Associate with LBA text files (*.lbt)');
   Form1.aInternal.Caption:=ReadString('Lang','aInternal','Editor in the same window');
   Form1.aOpen.Caption:=ReadString('Lang','aOpen','Open...');
   Form1.aReload.Caption:=ReadString('Lang','aReload','Reload');
   Form1.aSave.Caption:=ReadString('Lang','aSave','Save...');
   Form1.aSaveAs.Caption:=ReadString('Lang','aSaveAs','Save as...');
   Form1.aClone.Caption:=ReadString('Lang','aClone','Clone window');
   Form1.aExit.Caption:=ReadString('Lang','aExit','Exit');
   Form1.aLangFile.Caption:=ReadString('Lang','aLangFile','From file...');
   Form1.aSendCom.Caption:=ReadString('Lang','aSendCom','Send commands');
   Form1.aReceiveCom.Caption:=ReadString('Lang','aReceiveCom','Receive commands');
   Form1.aBothCom.Caption:=ReadString('Lang','aBothCom','Send and receive commands');
   Form1.aOff.Caption:=ReadString('Lang','aOff','Off');
   Form1.dOpen.Title:=ReadString('Lang','dOpen.Title','Open LBA text file');
   Form1.dOpen.Filter:=ReadString('Lang','dOpen.Filter','All supported files (*.lbt,*.xml)|*.lbt;*.xml|LBA text files (*.lbt)|*.lbt|XML files (*.xml)|*.xml');
   Form1.dSave.Title:=ReadString('Lang','dSave.Title','Save text file');
   Form1.dSave.Filter:=ReadString('Lang','dSave.Filter','LBA text files (*.lbt)|*.lbt|XML files (*.xml)|*.xml');
   Form1.dOpenLang.Title:=ReadString('Lang','dOpenLang.Title','Open language file');
   Form1.dOpenLang.Filter:=ReadString('Lang','dOpenLang.Filter','Text Editor language files (*.lng)|*.lng');
   Form1.mFile.Caption:=ReadString('Lang','mFile','File');
   Form1.mEdit.Caption:=ReadString('Lang','mEdit','Edit');
   Form1.mOptions.Caption:=ReadString('Lang','mOptions','Options');
   Form1.mDirection.Caption:=ReadString('Lang','mDirection','Direction');
   Form1.mCharset.Caption:=ReadString('Lang','mCharset','Charset');
   Form1.mConvMap.Caption:=ReadString('Lang','mConvMap','Conversion map');
   Form1.mLanguage.Caption:=ReadString('Lang','mLanguage','Language');
   Form1.mRecent.Caption:=ReadString('Lang','mRecent','Recent files');
   Form1.mColourSet.Caption:=ReadString('Lang','mColourSet','Menu colour set');
   Form1.mBlue.Caption:=ReadString('Lang','mBlue','Blue');
   Form1.mGreen.Caption:=ReadString('Lang','mGreen','Green');
   Form1.mRed.Caption:=ReadString('Lang','mRed','Red');
   Form1.mYellow.Caption:=ReadString('Lang','mYellow','Yellow');
   Form1.mPurple.Caption:=ReadString('Lang','mPurple','Purple');
   Form1.mOrange.Caption:=ReadString('Lang','mOrange','Orange');
   Form1.mTranslator.Caption:=ReadString('Lang','mTranslator','Translator mode');
   Form1.lbGoTo.Caption:=ReadString('Lang','lbGoTo','Go to text:');
   sSECapt:=ReadString('Lang','TextForm.Caption','String editor - text #%d');
   TextForm.SaveBtn.Caption:=ReadString('Lang','SaveBtn','Save');
   TextForm.CancelBtn.Caption:=sCancel;
   TextForm.FindBtn.Caption:=sFind+'...';
   TextForm.FindNext.Hint:=ReadString('Lang','FindNext','Find mext');
   TextForm.ShowPreview.Hint:=ReadString('Lang','ShowPreview','Preview');
   IntForm.SaveBtn.Caption:=ReadString('Lang','Iternal.SaveBtn','Save (F2)');
   IntForm.CancelBtn.Caption:=ReadString('Lang','Iternal.CancelBtn','Cancel (Esc)');
   IntForm.btPrev.Hint:=ReadString('Lang','Iternal.btPrev','Previous text (Alt+Up)');
   IntForm.btNext.Hint:=ReadString('Lang','Iternal.btNext','Next text (Alt+Down)');
   IntForm.ShowPreview.Hint:=ReadString('Lang','Iternal.ShowPreview','Preview');
   IntForm.FindBtn.Caption:=sFind+'...';
   IntForm.FindNext.Hint:=ReadString('Lang','Iternal.FindNext','Find next');
   IntForm.rgExit.Caption:=ReadString('Lang','Iternal.rgExit','On edit box exit:');
   IntForm.rgExit.Items[0]:=ReadString('Lang','Iternal.rgExit.Items[0]','Save');
   IntForm.rgExit.Items[1]:=ReadString('Lang','Iternal.rgExit.Items[1]','Cancel');
   Types.Clear;
   Types.Add(ReadString('Lang','tNormal','Normal (1)'));
   Types.Add(ReadString('Lang','tBigFrame','Big frame (3)'));
   Types.Add(ReadString('Lang','tBigPict','No frame - big picture (5)'));
   Types.Add(ReadString('Lang','tNoFrame','No frame - floating text (9)'));
   Types.Add(ReadString('Lang','tHolomap','Holomap location (17)'));
   Types.Add(ReadString('Lang','tRadio','Radio (33)'));
   Types.Add(ReadString('Lang','tBigRadio','Radio - big frame (35)'));
   Types.Add(ReadString('Lang','tInventory','Inventory text (65)'));
   Types.Add(ReadString('Lang','tDemo','Demo text (129)'));
   FindForm.Caption:=ReadString('Lang','FindForm.Caption','Search for text');
   FindForm.Label1.Caption:=ReadString('Lang','FindLabel','Find text:');
   FindForm.Button2.Caption:=sCancel;
   FindForm.cbCase.Caption:=ReadString('Lang','cbCase','Match case');
   FindForm.Label3.Caption:=ReadString('Lang','ReplaceLabel','...and replace it with:');
   FindForm.rbBegin.Caption:=ReadString('Lang','RepFromBegin','From the beginning');
   FindForm.rbSelected.Caption:=ReadString('Lang','RepFromSel','From the selected text');
   sReplace:=ReadString('Lang','sReplaceAll','Replace all');
   sNotFound:=ReadString('Lang','sNotFound','Searched text not found');
   PrevForm.Caption:=ReadString('Lang','PrevForm.Caption','Preview selected text');
   PrevForm.btLockTop.Caption:=ReadString('Lang','btLockTop','Lock at top');
   PrevForm.btLockBtm.Caption:=ReadString('Lang','btLockBtm','Lock at bottom');
   PrevForm.btFont2.Caption:=ReadString('Lang','btFont2.Caption','Default LBA 2 font');
   PrevForm.btFont2.Hint:=ReadString('Lang','btFont2.Hint','LBA 1 font has just less defined characters, so its useless to put it here');
   PrevForm.btLoad.Caption:=ReadString('Lang','btLoad','Load font from file');
   PrevForm.btOptions.Caption:=ReadString('Lang','btOptions','Options');
   PrevForm.btClose.Caption:=ReadString('Lang','btClose','Close');
   PrevForm.cbRemLast.Caption:=ReadString('Lang','cbRemLast','Remember last font');
   PrevForm.cbRemSet.Caption:=ReadString('Lang','cbRemSet','Remember settings');
   PrevForm.cbLbaStyle.Caption:=ReadString('Lang','cbLbaStyle','LBA letter style');
   PrevForm.cbOnTop.Caption:=ReadString('Lang','cbOnTop','Stay on top');
   PrevForm.cbWordWrap.Caption:=ReadString('Lang','cbWordWrap','Word wrap');
   PrevForm.Label2.Caption:=ReadString('Lang','FontColour','Font colour:');
   PrevForm.Label3.Caption:=ReadString('Lang','FontBack','Background colour:');
   ConvForm.Caption:=ReadString('Lang','ConvForm.Caption','Conversion map');
   ConvForm.MapTab.Caption:=ReadString('Lang','TableTab','Table view');
   ConvForm.ListTab.Caption:=ReadString('Lang','ListTab','List view');
   ConvForm.Label1.Caption:=ReadString('Lang','TableText','This table is "on load" table. Adequate "on save" table is created automatically.');
   ConvForm.Label4.Caption:=ReadString('Lang','ListText1','This list is "on load" list.')+#13+ReadString('Lang','ListText2','Adequate "on save" list is created automatically.');
   ConvForm.btAdd.Caption:=ReadString('Lang','btAdd','Add / Edit');
   ConvForm.btDelete.Caption:=ReadString('Lang','btDelete','Delete selected');
   ConvForm.rgDec.Caption:=ReadString('Lang','rgDec','View as:');
   ConvForm.rgDec.Items[0]:=ReadString('Lang','rgDec.Items[0]','Decimal');
   ConvForm.rgDec.Items[1]:=ReadString('Lang','rgDec.Items[1]','Hexadecimal');
   ConvForm.rgEdit.Caption:=ReadString('Lang','rgEdit','Edit when:');
   ConvForm.rgEdit.Items[0]:=ReadString('Lang','rgEdit.Items[0]','Clicked');
   ConvForm.rgEdit.Items[1]:=ReadString('Lang','rgEdit.Items[1]','Dbl. clicked');
   ConvForm.rgExit.Caption:=ReadString('Lang','rgExit','On edit box exit:');
   ConvForm.rgExit.Items[0]:=ReadString('Lang','rgExit.Items[0]','Save');
   ConvForm.rgExit.Items[1]:=ReadString('Lang','rgExit.Items[1]','Cancel');
   ConvForm.GroupBox1.Caption:=ReadString('Lang','Selected','Selected:');
   ConvForm.btSave.Caption:=ReadString('Lang','btSave','Save to file');
   ConvForm.btLoad.Caption:=ReadString('Lang','btLoad','Load from file');
   ConvForm.btDefault.Caption:=ReadString('Lang','btDefault','Reset to default');
   ConvForm.btBlank.Caption:=ReadString('Lang','btBlank','Reset to blank');
   ConvForm.btClose.Caption:=ReadString('Lang','btClose','Close');
   ConvForm.dOpenMap.Title:=ReadString('Lang','dOpenMap.Title','Open conversion map');
   ConvForm.dOpenMap.Filter:=ReadString('Lang','dOpenMap.Filter','Conversion maps (*.cnv)|*.cnv|All files (*.*)|*.*');
   ConvForm.dSaveMap.Title:=ReadString('Lang','dSaveMap.Title','Save conversion map');
   ConvForm.dSaveMap.Filter:=ReadString('Lang','dSaveMap.Filter','Conversion maps (*.cnv)|*.cnv');
  end;
  LangIni.Destroy;
 end
 else begin
  Form1.aPolski.Checked:=True;
  sQModified:='Plik zosta³ zmieniony. Czy chcesz zapisaæ zmiany?';
  sText:='Tekst %d z %d';
  sOffset:='Offset: %d';
  sFSize:='Rozmiar pliku: %d';
  sQType:='Czy to plik tekstowy z LBA1?';
  sQTType:='Wybierz typ pliku';
  sStartup1:='*** Nie za³adowano ¿adnego pliku ***';
  sStartup2:=' Edytor plików tekstowych z gry Little Big Adveture 1/2 wersja %s, Copyright '#169' Zink.';
  sStartup3:=' LBA Text Editor 2 wydawany jest ABSOLUTNIE BEZ ¯ADNEJ GWARANCJI - w celu uzyskania dalszych szczegó³ów zajrzyj do pliku Licencja.txt. '+'To jest wolne oprogramowanie i mile widziane jest dalsze rozpowszechnianie go przez ciebie na okreœlonych warunkach - w celu uzyskania bli¿szych szczegó³ów zajrzyj do pliku Licencja.txt';
  sWExists:='Plik nie istnieje !!!';
  sWTExists:='B³¹d';
  sModified:='Zmieniony';
  sEInvOffs:='Ostatni offset jest inny ni¿ rozmiar pliku. Plik mo¿e byæ uszkodzny. Za³adowaæ go pomimo tego?';
  sEOneFile:='Mo¿esz otworzyæ tylko jeden plik naraz.';
  sMFound:='Znaleziono i zast¹piono %d razy.';
  sWConvIni:='Mapa konwersji w pliku ini jest nieprawid³owa. Zamiast niej zostanie u¿yta mapa domyœlna.';
  sEFontInc:='Plik czcionki jest nieprawid³owy. Zostanie za³adowana domyœlna czcionka.';
  sEFontNotFound:='Plik czcionki nie zosta³ znaleziony. Zostanie za³adowana domyœlna czcionka.';
  sGoToRange:='Indeks musi zawieraæ siê pomiêdzy 1 i %d!';
  Form1.aEdit.Caption:='Edytuj zaznaczony tekst...';
  Form1.aPreview.Caption:='Podgl¹d zaznaczonego tekstu';
  Form1.aFind.Caption:='ZnajdŸ...';
  Form1.aFindNext.Caption:='ZnajdŸ nastêpny';
  Form1.aFindRep.Caption:='ZnajdŸ i zamieñ';
  Form1.aDelete.Caption:='Usuñ zaznaczony tekst';
  Form1.aMoveUp.Caption:='Przesuñ w górê';
  Form1.aMoveDown.Caption:='Przesuñ w dó³';
  Form1.aInsAbove.Caption:='Wstaw powy¿ej';
  Form1.aInsBelow.Caption:='Wstaw poni¿ej';
  Form1.aLock.Caption:='Zablokuj strukturê pliku';
  Form1.aLtr.Caption:='Od lewej do prawej';
  Form1.aRtl.Caption:='Od prawej do lewej';
  Form1.aRtlNa.Caption:='Od prawej do lewej - bez przestawiania';
  Form1.aRtlRo.Caption:='Od prawej do lewej - tylko czytanie';
  Form1.aDefault.Caption:='Domyœlny';
  Form1.aHebrew.Caption:='Hebrajski';
  Form1.aDefMap.Caption:='Domyœlna (u¿ywana w Lba)';
  Form1.aNoneMap.Caption:='Bez konwersji';
  Form1.aCustomMap.Caption:='W³asna...';
  Form1.aLoadMap.Caption:='Za³aduj z pliku';
  Form1.aRemember.Caption:='Pamiêtaj ostatni¹ mapê';
  Form1.aAutoDetect.Caption:='Automatycznie wykrywaj typ pliku';
  Form1.aAssociate.Caption:='Skojarz z plikami tekstowymi z LBA (*.lbt)';
  Form1.aInternal.Caption:='Edytor w tym samym oknie';
  Form1.aOpen.Caption:='Otwórz...';
  Form1.aReload.Caption:='Prze³aduj';
  Form1.aSave.Caption:='Zapisz...';
  Form1.aSaveAs.Caption:='Zapisz jako...';
  Form1.aClone.Caption:='Klonuj okno';
  Form1.aExit.Caption:='Wyjœcie';
  Form1.aLangFile.Caption:='Z pliku...';
  Form1.aSendCom.Caption:='Wysy³aj polecenia';
  Form1.aReceiveCom.Caption:='Odbieraj polecenia';
  Form1.aBothCom.Caption:='Wysy³aj i odbieraj polecenia';
  Form1.aOff.Caption:='Wy³¹czony';
  Form1.dOpen.Title:='Otwórz plik tekstowy z gry LBA';
  Form1.dOpen.Filter:='Wszystkie obs³ugiwane pliki (*.lbt,*.xml)|*.lbt;*.xml|Pliki tekstowe z LBA (*.lbt)|*.lbt|Pliki XML (*.xml)|*.xml';
  Form1.dSave.Title:='Zapisz plik tekstowy';
  Form1.dSave.Filter:='Pliki tekstowe z LBA (*.lbt)|*.lbt|Pliki XML (*.xml)|*.xml';
  Form1.dOpenLang.Title:='Otwórz plik jêzyka';
  Form1.dOpenLang.Filter:='Pliki jêzykowe programu Text Editor (*.lng)|*.lng';
  Form1.mFile.Caption:='Plik';
  Form1.mEdit.Caption:='Edycja';
  Form1.mOptions.Caption:='Opcje';
  Form1.mDirection.Caption:='Kierunek tekstu';
  Form1.mCharset.Caption:='Zestaw znaków';
  Form1.mConvMap.Caption:='Mapa konwersji';
  Form1.mLanguage.Caption:='Jêzyk';
  Form1.mRecent.Caption:='Niedawne pliki';
  Form1.mColourSet.Caption:='Kolory menu';
  Form1.mBlue.Caption:='Niebieskie';
  Form1.mGreen.Caption:='Zielone';
  Form1.mRed.Caption:='Czerwone';
  Form1.mYellow.Caption:='¯ó³te';
  Form1.mPurple.Caption:='Fioletowe';
  Form1.mOrange.Caption:='Pomarañczowe';
  Form1.mTranslator.Caption:='Tryb t³umacza';
  Form1.lbGoTo.Caption:='IdŸ do tekstu:';
  sSECapt:='Edytor tekstu - tekst #%d';
  TextForm.SaveBtn.Caption:='Zapisz';
  TextForm.CancelBtn.Caption:='Anuluj';
  TextForm.FindBtn.Caption:='ZnajdŸ...';
  TextForm.FindNext.Hint:='ZnajdŸ nastêpny';
  TextForm.ShowPreview.Hint:='Podgl¹d tekstu';
  IntForm.SaveBtn.Caption:='Zapisz (F2)';
  IntForm.CancelBtn.Caption:='Anuluj (Esc)';
  IntForm.btPrev.Hint:='Poprzedni tekst (Alt + W górê)';
  IntForm.btNext.Hint:='Nastêpny tekst (Alt + W dó³)';
  IntForm.ShowPreview.Hint:='Podgl¹d tekstu';
  IntForm.FindBtn.Caption:='ZnajdŸ...';
  IntForm.FindNext.Hint:='ZnajdŸ nastêpny';
  IntForm.rgExit.Caption:='Wyjœcie z pola edycji:';
  IntForm.rgExit.Items[0]:='Zapisz';
  IntForm.rgExit.Items[1]:='Odrzuæ';
  Types.Clear;
  Types.Add('Normalny (1)');
  Types.Add('Du¿a ramka (3)');
  Types.Add('Bez ramki - du¿y obraz (5)');
  Types.Add('Bez ramki - lataj¹cy tekst (9)');
  Types.Add('Lokacja na holomapie (17)');
  Types.Add('Radio (33)');
  Types.Add('Radio - du¿a ramka (35)');
  Types.Add('Tekst w inwentarzu (65)');
  Types.Add('Tekst w wersji demo (129)');
  FindForm.Caption:='Szukaj tekstu';
  FindForm.Label1.Caption:='ZnajdŸ tekst:';
  FindForm.Button2.Caption:='Anuluj';
  FindForm.cbCase.Caption:='Uwzglêdniaj wielkoœæ znaków';
  FindForm.Label3.Caption:='...i zamieñ na:';
  FindForm.rbBegin.Caption:='Od pocz¹tku';
  FindForm.rbSelected.Caption:='Od zaznaczonego tekstu';
  sFind:='ZnajdŸ';
  sReplace:='Zamieñ wszystkie';
  sNotFound:='Szukany tekst nie zosta³ znaleziony';
  PrevForm.Caption:='Podgl¹d zaznaczonego tekstu';
  PrevForm.btLockTop.Caption:='Zablokuj na górze';
  PrevForm.btLockBtm.Caption:='Zablokuj na dole';
  PrevForm.btFont2.Caption:='Czcionka z LBA 2';
  PrevForm.btFont2.Hint:='Czcionka z LBA 1 ma tylko kilka znaków mniej, wiêc nie ma sensu jej tu wstawiaæ';
  PrevForm.btLoad.Caption:='Otwórz z pliku';
  PrevForm.btOptions.Caption:='Opcje';
  PrevForm.btClose.Caption:='Zamknij';
  PrevForm.cbRemLast.Caption:='Pamiêtaj ostatni¹ czcionkê';
  PrevForm.cbRemSet.Caption:='Pamiêtaj ustawienia';
  PrevForm.cbLbaStyle.Caption:='Styl liter jak w LBA';
  PrevForm.cbOnTop.Caption:='Okno na wierzchu';
  PrevForm.cbWordWrap.Caption:='Zawijanie wierszy';
  PrevForm.Label2.Caption:='Kolor czcionki:';
  PrevForm.Label3.Caption:='Kolor t³a:';
  ConvForm.Caption:='Mapa konwersji';
  ConvForm.MapTab.Caption:='Widok tabeli';
  ConvForm.ListTab.Caption:='Widok listy';
  ConvForm.Label1.Caption:='Ta tabela s³u¿y do ³adowania plików.'#13'Odpowiadaj¹ca jej tabela do zapisywania jest tworzona automatycznie.';
  ConvForm.Label4.Caption:='Ta lista s³u¿y do ³adowania plików.'#13'Odpowiadaj¹ca jej lista do zapisywania jest tworzona automatycznie.';
  ConvForm.btAdd.Caption:='Dodaj / Edytuj';
  ConvForm.btDelete.Caption:='Usuñ zaznaczone';
  ConvForm.rgDec.Caption:='Wyœwietlaj:';
  ConvForm.rgDec.Items[0]:='Dziesiêtnie';
  ConvForm.rgDec.Items[1]:='Szesnastkowo';
  ConvForm.rgEdit.Caption:='Edycja kiedy:';
  ConvForm.rgEdit.Items[0]:='Klikniêty';
  ConvForm.rgEdit.Items[1]:='Podw. klikn.';
  ConvForm.rgExit.Caption:='Wyj. z pola edycji:';
  ConvForm.rgExit.Items[0]:='Zapisz';
  ConvForm.rgExit.Items[1]:='Odrzuæ';
  ConvForm.GroupBox1.Caption:='Zaznaczony:';
  ConvForm.btSave.Caption:='Zapisz do pliku';
  ConvForm.btLoad.Caption:='Otwórz z pliku';
  ConvForm.btDefault.Caption:='Domyœlna mapa';
  ConvForm.btBlank.Caption:='Pusta mapa';
  ConvForm.btClose.Caption:='Zamknij';
  ConvForm.dOpenMap.Title:='Otwórz mapê konwersji';
  ConvForm.dOpenMap.Filter:='Mapy konwersji (*.cnv)|*.cnv|Wszystkie pliki (*.*)|*.*';
  ConvForm.dSaveMap.Title:='Zapisz mapê konwersji';
  ConvForm.dSaveMap.Filter:='Mapy konwersji (*.cnv)|*.cnv';
 end;
 CurrentLang:=index;
 TextForm.cbExt.Items.Assign(Types);
 IntForm.cbInt.Items.Assign(Types);
 Types.Destroy;
 If not Loaded then begin
  Entries[0].Text:=sStartup1+#13#10#13#10+Format(sStartup2,[VerNum])+#13#10#13#10+sStartup3;
  DrawTexts(True);
 end;
 SetHints;
 Form1.eGoTo.Left:=Form1.lbGoTo.Width+4;
 Form1.paGoTo.Width:=Form1.lbGoTo.Width+Form1.eGoTo.Width+5;
 Form1.Status.Repaint;
 Form1.Repaint;
end;

end.
