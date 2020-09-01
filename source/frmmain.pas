{ +--------------------------------------------------------------------------+ }
{ | MM6DRead v0.1 * Status reader program for MM6D device                    | }
{ | Copyright (C) 2020 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>          | }
{ | frmmain.pas                                                              | }
{ | Main form                                                                | }
{ +--------------------------------------------------------------------------+ }

//   This program is free software: you can redistribute it and/or modify it
// under the terms of the European Union Public License 1.1 version.

//   This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.

unit frmmain;

{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls, Buttons, ExtCtrls, untcommonproc;

type
  { TForm1 }
  TForm1 = class(TForm)
    Bevel1: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Bevel6: TBevel;
    Bevel8: TBevel;
    Button1: TButton;
    Button10: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape7: TShape;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    StatusBar1: TStatusBar;
    procedure Button10Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  inifile: string;

const
  CNTNAME = 'MM6D';
  CNTVER = '0.1';

resourcestring
  MESSAGE01 = 'Cannot read configuration file!';
  MESSAGE02 = 'Cannot write configuration file!';
  MESSAGE03 = 'Cannot read data from this URL!';
  MESSAGE04 = 'Not compatible controller!';

implementation

{$R *.lfm}
{ TForm1 }

// add URL to list
procedure TForm1.SpeedButton2Click(Sender: TObject);
var
  line: byte;
  thereis: boolean;
begin
  thereis := False;
  if ComboBox1.Items.Count > 0 then
    for line := 0 to ComboBox1.Items.Count - 1 do
      if ComboBox1.Items.Strings[line] = ComboBox1.Text then
        thereis := True;
  if (not thereis) and (ComboBox1.Items.Count < 64) then
    ComboBox1.Items.AddText(ComboBox1.Text);
end;

// remove URL from list
procedure TForm1.SpeedButton3Click(Sender: TObject);
var
  line: byte;
begin
  if ComboBox1.Items.Count > 0 then
  begin
    for line := 0 to ComboBox1.Items.Count - 1 do
      if ComboBox1.Items.Strings[line] = ComboBox1.Text then
        break;
    ComboBox1.Items.Delete(line);
    ComboBox1Change(Sender);
  end;
end;

// event of ComboBox1
procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  if length(ComboBox1.Text) = 0 then
  begin
    SpeedButton2.Enabled := False;
    SpeedButton3.Enabled := False;
    Button1.Enabled := False;
    Button2.Enabled := False;
    Button3.Enabled := False;
    Button4.Enabled := False;
    Button5.Enabled := False;
    Button6.Enabled := False;
    Button7.Enabled := False;
    Button8.Enabled := False;
    Button9.Enabled := False;
    Button10.Enabled := False;
  end
  else
  begin
    SpeedButton2.Enabled := True;
    SpeedButton3.Enabled := True;
    Button1.Enabled := True;
    Button2.Enabled := True;
    Button3.Enabled := True;
    Button4.Enabled := True;
    Button5.Enabled := True;
    Button6.Enabled := True;
    Button7.Enabled := True;
    Button8.Enabled := True;
    Button9.Enabled := True;
    Button10.Enabled := True;
  end;
end;

function checkcompatibility(Name, version: string): byte;
begin
  Result := 0;
  if getdatafromdevice(Form1.ComboBox1.Text, 0, Form1.Edit1.Text) then
  begin
    if untcommonproc.Value.Count = 2 then
      if (untcommonproc.Value.Strings[0] <> Name) or
        (untcommonproc.Value.Strings[1] <> version) then
        Result := 1;
  end
  else
    Result := 2;
end;

procedure turnonoff(cmd: byte);
var
  good: boolean;
begin
  case checkcompatibility(CNTNAME, CNTVER) of
    0: Form1.StatusBar1.Panels.Items[0].Text :=
        Value.Strings[0] + ' ' + Value.Strings[1];
    1:
    begin
      ShowMessage(MESSAGE04);
      Form1.StatusBar1.Panels.Items[0].Text := '';
      exit;
    end;
    2: Form1.StatusBar1.Panels.Items[0].Text := '';
  end;
  good := getdatafromdevice(Form1.ComboBox1.Text, cmd, Form1.Edit1.Text);
  if good then
    if Value.Count <> 1 then
      good := False
    else
      good := True;
  if not good then
    ShowMessage(MESSAGE03);
end;

// get input status
procedure TForm1.Button10Click(Sender: TObject);
begin

end;

// get alarm status
procedure TForm1.Button7Click(Sender: TObject);
begin

end;

// turn off lamps
procedure TForm1.Button1Click(Sender: TObject);
begin
  turnonoff(3);
end;

// turn on lamps
procedure TForm1.Button2Click(Sender: TObject);
begin
  turnonoff(4);
end;

// turn off ventilators
procedure TForm1.Button4Click(Sender: TObject);
begin
  turnonoff(5);
end;

// turn on ventilators
procedure TForm1.Button3Click(Sender: TObject);
begin
  turnonoff(6);
end;

// turn off heaters
procedure TForm1.Button5Click(Sender: TObject);
begin
  turnonoff(7);
end;

// turn on heaters
procedure TForm1.Button6Click(Sender: TObject);
begin
  turnonoff(8);
end;

// turn off all outputs
procedure TForm1.Button8Click(Sender: TObject);
begin
  turnonoff(2);
end;

// restore alarm status
procedure TForm1.Button9Click(Sender: TObject);
begin
  turnonoff(13);
end;

// events of Form1
procedure TForm1.FormCreate(Sender: TObject);
var
  b: byte;
begin
  makeuserdir;
  getlang;
  getexepath;
  Form1.Caption := APPNAME + ' v' + VERSION;
  // load configuration
  inifile := untcommonproc.userdir + DIR_CONFIG + 'mm6dread.ini';
  if FileSearch('mm6dread.ini', untcommonproc.userdir + DIR_CONFIG) <> '' then
    if not loadconfiguration(inifile) then
      ShowMessage(MESSAGE01);
  Edit1.Text := untcommonproc.uids;
  for b := 0 to 63 do
    if length(urls[b]) > 0 then
      ComboBox1.Items.Add(untcommonproc.urls[b]);
  untcommonproc.Value := TStringList.Create;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
  b: byte;
begin
  for b := 0 to 63 do
    untcommonproc.urls[b] := '';
  if ComboBox1.Items.Count > 0 then
    for b := 0 to ComboBox1.Items.Count - 1 do
      untcommonproc.urls[b] := ComboBox1.Items.Strings[b];
  untcommonproc.uids := Edit1.Text;
  if not saveconfiguration(inifile) then
    ShowMessage(MESSAGE02);
  untcommonproc.Value.Free;
end;

end.
