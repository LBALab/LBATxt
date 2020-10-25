//******************************************************************************
// LBA Text Editor 2 - editing lbt (text) files from Little Big Adventure 1 & 2
//
// This is main program file.
//
// Copyright (C) Zink
// e-mail: zink@poczta.onet.pl
//
// This source code is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This source code is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License (License.txt) for more details.
//******************************************************************************

program LBATxt;

uses
  Forms,
  SysUtils,
  IniFiles,
  LBATxt1 in 'LBATxt1.pas' {Form1},
  Editor in 'Editor.pas' {TextForm},
  lang in 'lang.pas',
  ConvTbl in 'ConvTbl.pas' {ConvForm},
  settings in 'settings.pas',
  Find in 'Find.pas' {FindForm},
  Preview in 'Preview.pas' {PrevForm},
  IntEditor in 'IntEditor.pas' {IntForm},
  files in 'files.pas',
  CompMods in '..\libs\CompMods.pas',
  XML in 'XML.pas',
  Utils in 'Utils.pas';

{$R *.RES}
{$R Icon.res}

begin
  Application.Initialize;
  Application.Title := 'LBA Text Editor 2';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TTextForm, TextForm);
  Application.CreateForm(TConvForm, ConvForm);
  Application.CreateForm(TFindForm, FindForm);
  Application.CreateForm(TPrevForm, PrevForm);
  Application.CreateForm(TIntForm, IntForm);
  SetLength(Entries, 2);
  LoadSettings();

  Form1.dOpen.InitialDir:= CurrentDir;
  Form1.dOpenLang.InitialDir:= ExtractFilePath(Application.ExeName);
  if ParamCount > 0 then
    if FileExists(ParamStr(1)) then
      LoadTexts(ParamStr(1));

  UpdateComponents();
  Application.Run;

  SaveSettings();
end.
