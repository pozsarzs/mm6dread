{ +--------------------------------------------------------------------------+ }
{ | MM6DRead v0.3 * Status reader program for MM6D device                    | }
{ | Copyright (C) 2020-2022 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>     | }
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
  StdCtrls, Buttons, ExtCtrls, ValEdit, StrUtils, untcommonproc;

type
  { TForm1 }
  TForm1 = class(TForm)
    Bevel1: TBevel;
    Bevel10: TBevel;
    Bevel5: TBevel;
    Bevel6: TBevel;
    Bevel7: TBevel;
    Bevel8: TBevel;
    Bevel9: TBevel;
    Button10: TButton;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Memo1: TMemo;
    PageControl1: TPageControl;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Shape7: TShape;
    Shape8: TShape;
    Shape9: TShape;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    StatusBar1: TStatusBar;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    ValueListEditor1: TValueListEditor;
    procedure Button10Click(Sender: TObject);
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
  CNTVER = '0.3';

resourcestring
  MESSAGE01 = 'Cannot read configuration file!';
  MESSAGE02 = 'Cannot write configuration file!';
  MESSAGE03 = 'Cannot read data from this URL!';
  MESSAGE04 = 'Not compatible controller!';
  MESSAGE05 = 'name';
  MESSAGE06 = 'value';
  MESSAGE07 = 'IP address:';
  MESSAGE08 = 'MAC address:';
  MESSAGE09 = 'Serial number:';
  MESSAGE10 = 'Sw. version:';
  MESSAGE11 = 'Mode:';
  MESSAGE12 = 'Manual switches:';
  MESSAGE13 = 'Overcurrent protection:';
  MESSAGE14 = 'Alarm:';
  MESSAGE15 = 'Lamp output:';
  MESSAGE16 = 'Ventilator output:';
  MESSAGE17 = 'Heater output:';
  MESSAGE18 = 'Your IP address is not allowed!';
  MESSAGE19 = 'Authentication error!';


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
    Button10.Enabled := False;
  end
  else
  begin
    SpeedButton2.Enabled := True;
    SpeedButton3.Enabled := True;
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

// refresh displays
procedure TForm1.Button10Click(Sender: TObject);
var
  i: integer;
const
  s1a: string = '<br>';
  s1b: string = '<td>';
  s1c: string = '</td>';
  s2: string = 'IP address:';
  s3: string = 'MAC address:';
  s4: string = 'Hardware serial number:';
  s5: string = 'Software version:';
  s6: string = '<td>Operation mode:</td>';
  s7: string = '<td>Manual mode:</td>';
  s8: string = '<td>Overcurrent protection:</td>';
  s9: string = '<td>Alarm event:</td>';
  s10: string = '<td>Lamp:</td>';
  s11: string = '<td>Ventilator:</td>';
  s12: string = '<td>Heater:</td>';
begin
  // clear pages
  Shape4.Brush.Color := clOlive;
  Shape5.Brush.Color := clMaroon;
  Shape6.Brush.Color := clGreen;
  Shape8.Brush.Color := clGreen;
  Shape9.Brush.Color := clGreen;
  Shape7.Brush.Color := clMaroon;
  ValueListEditor1.Cols[1].Clear;
  Memo1.Clear;
  // check compatibility
  case checkcompatibility(CNTNAME, CNTVER) of
    0: StatusBar1.Panels.Items[0].Text := Value.Strings[0] + ' v' + Value.Strings[1];
    1:
    begin
      ShowMessage(MESSAGE04);
      StatusBar1.Panels.Items[0].Text := '';
      exit;
    end;
    2: StatusBar1.Panels.Items[0].Text := '';
  end;
  // get values
  if getdatafromdevice(ComboBox1.Text, 1, Edit1.Text) then
  begin
    // get IP address
    for i := 0 to Value.Count - 1 do
      if findpart(s2, Value.Strings[i]) <> 0 then
        break;
    if Value.Strings[i] = 'Not allowed client IP address!' then
    begin
      ShowMessage(MESSAGE18);
      exit;
    end;
    if Value.Strings[i] = 'Authentication error!' then
    begin
      ShowMessage(MESSAGE19);
      exit;
    end;
    Value.Strings[i] := stringreplace(Value.Strings[i], s1a, '', [rfReplaceAll]);
    Value.Strings[i] := stringreplace(Value.Strings[i], s2, '', [rfReplaceAll]);
    Value.Strings[i] := rmchr1(Value.Strings[i]);
    ValueListEditor1.Cells[1, 1] := Value.Strings[i];
    // get MAC address
    for i := 0 to Value.Count - 1 do
      if findpart(s3, Value.Strings[i]) <> 0 then
        break;
    Value.Strings[i] := stringreplace(Value.Strings[i], s1a, '', [rfReplaceAll]);
    Value.Strings[i] := stringreplace(Value.Strings[i], s3, '', [rfReplaceAll]);
    Value.Strings[i] := rmchr1(Value.Strings[i]);
    ValueListEditor1.Cells[1, 2] := Value.Strings[i];
    // get serial number
    for i := 0 to Value.Count - 1 do
      if findpart(s4, Value.Strings[i]) <> 0 then
        break;
    Value.Strings[i] := stringreplace(Value.Strings[i], s1a, '', [rfReplaceAll]);
    Value.Strings[i] := stringreplace(Value.Strings[i], s4, '', [rfReplaceAll]);
    Value.Strings[i] := rmchr1(Value.Strings[i]);
    ValueListEditor1.Cells[1, 3] := Value.Strings[i];
    // get software version
    for i := 0 to Value.Count - 1 do
      if findpart(s5, Value.Strings[i]) <> 0 then
        break;
    Value.Strings[i] := stringreplace(Value.Strings[i], s1a, '', [rfReplaceAll]);
    Value.Strings[i] := stringreplace(Value.Strings[i], s5, '', [rfReplaceAll]);
    Value.Strings[i] := rmchr1(Value.Strings[i]);
    ValueListEditor1.Cells[1, 4] := Value.Strings[i];
    // get operation mode
    for i := 0 to Value.Count - 1 do
      if findpart(s6, Value.Strings[i]) <> 0 then
        break;
    Value.Strings[i + 1] := rmchr1(Value.Strings[i + 1]);
    Value.Strings[i + 1] := stringreplace(Value.Strings[i + 1], s1b, '', [rfReplaceAll]);
    Value.Strings[i + 1] := stringreplace(Value.Strings[i + 1], s1c, '', [rfReplaceAll]);
    Value.Strings[i + 1] := rmchr1(Value.Strings[i + 1]);
    ValueListEditor1.Cells[1, 5] := Value.Strings[i + 1];
    // get status of manual mode switches
    for i := 0 to Value.Count - 1 do
      if findpart(s7, Value.Strings[i]) <> 0 then
        break;
    Value.Strings[i + 1] := rmchr1(Value.Strings[i + 1]);
    Value.Strings[i + 1] := stringreplace(Value.Strings[i + 1], s1b, '', [rfReplaceAll]);
    Value.Strings[i + 1] := stringreplace(Value.Strings[i + 1], s1c, '', [rfReplaceAll]);
    Value.Strings[i + 1] := rmchr1(Value.Strings[i + 1]);
    ValueListEditor1.Cells[1, 6] := Value.Strings[i + 1];
    // get status of overcurrent protection
    for i := 0 to Value.Count - 1 do
      if findpart(s8, Value.Strings[i]) <> 0 then
        break;
    Value.Strings[i + 1] := rmchr1(Value.Strings[i + 1]);
    Value.Strings[i + 1] := stringreplace(Value.Strings[i + 1], s1b, '', [rfReplaceAll]);
    Value.Strings[i + 1] := stringreplace(Value.Strings[i + 1], s1c, '', [rfReplaceAll]);
    Value.Strings[i + 1] := rmchr1(Value.Strings[i + 1]);
    ValueListEditor1.Cells[1, 7] := Value.Strings[i + 1];
    // get status of alarm
    for i := 0 to Value.Count - 1 do
      if findpart(s9, Value.Strings[i]) <> 0 then
        break;
    Value.Strings[i + 1] := rmchr3(Value.Strings[i + 1]);
    Value.Strings[i + 1] := stringreplace(Value.Strings[i + 1], s1b, '', [rfReplaceAll]);
    Value.Strings[i + 1] := stringreplace(Value.Strings[i + 1], s1c, '', [rfReplaceAll]);
    Value.Strings[i + 1] := rmchr2(Value.Strings[i + 1]);
    ValueListEditor1.Cells[1, 8] := Value.Strings[i + 1];
    // get status of lamp output
    for i := 0 to Value.Count - 1 do
      if findpart(s10, Value.Strings[i]) <> 0 then
        break;
    Value.Strings[i + 1] := stringreplace(Value.Strings[i + 1], s1b, '', [rfReplaceAll]);
    Value.Strings[i + 1] := stringreplace(Value.Strings[i + 1], s1c, '', [rfReplaceAll]);
    Value.Strings[i + 1] := rmchr1(Value.Strings[i + 1]);
    ValueListEditor1.Cells[1, 9] := Value.Strings[i + 1];
    // get status of ventilator output
    for i := 0 to Value.Count - 1 do
      if findpart(s11, Value.Strings[i]) <> 0 then
        break;
    Value.Strings[i + 1] := stringreplace(Value.Strings[i + 1], s1b, '', [rfReplaceAll]);
    Value.Strings[i + 1] := stringreplace(Value.Strings[i + 1], s1c, '', [rfReplaceAll]);
    Value.Strings[i + 1] := rmchr1(Value.Strings[i + 1]);
    ValueListEditor1.Cells[1, 10] := Value.Strings[i + 1];
    // get status of heater output
    for i := 0 to Value.Count - 1 do
      if findpart(s12, Value.Strings[i]) <> 0 then
        break;
    Value.Strings[i + 1] := stringreplace(Value.Strings[i + 1], s1b, '', [rfReplaceAll]);
    Value.Strings[i + 1] := stringreplace(Value.Strings[i + 1], s1c, '', [rfReplaceAll]);
    Value.Strings[i + 1] := rmchr1(Value.Strings[i + 1]);
    ValueListEditor1.Cells[1, 11] := Value.Strings[i + 1];
    ValueListEditor1.AutoSizeColumns;
    // write to display
    // manual mode
    if ValueListEditor1.Cells[1, 6] = 'ON' then
      Shape4.Brush.Color := clYellow
    else
      Shape4.Brush.Color := clOlive;
    // overcurrent protection
    if ValueListEditor1.Cells[1, 7] = 'Opened' then
      Shape5.Brush.Color := clRed
    else
      Shape5.Brush.Color := clMaroon;
    // outputs
    if ValueListEditor1.Cells[1, 9] = 'ON' then
      Shape6.Brush.Color := clLime
    else
      Shape6.Brush.Color := clGreen;
    if ValueListEditor1.Cells[1, 10] = 'ON' then
      Shape8.Brush.Color := clLime
    else
      Shape8.Brush.Color := clGreen;
    if ValueListEditor1.Cells[1, 11] = 'ON' then
      Shape9.Brush.Color := clLime
    else
      Shape9.Brush.Color := clGreen;
    // alarm
    if ValueListEditor1.Cells[1, 8] = 'Detected' then
      Shape7.Brush.Color := clRed
    else
      Shape7.Brush.Color := clMaroon;
  end
  else
  begin
    ShowMessage(MESSAGE03);
    exit;
  end;
  // get log
  if getdatafromdevice(ComboBox1.Text, 2, Edit1.Text) then
  begin
    // write log
    for i := 0 to Value.Count - 1 do
      if findpart('<tr><td><pre>', Value.Strings[i]) <> 0 then
      begin
        Value.Strings[i] := rmchr3(Value.Strings[i]);
        Value.Strings[i] := stringreplace(Value.Strings[i], '<tr><td><pre>',
          '', [rfReplaceAll]);
        Value.Strings[i] := stringreplace(Value.Strings[i],
          '</pre></td><td><pre>', #9, [rfReplaceAll]);
        Value.Strings[i] := stringreplace(Value.Strings[i], '</pre></td></tr>',
          '', [rfReplaceAll]);
        Memo1.Lines.Insert(0, Value.Strings[i]);
      end;
    Memo1.SelStart := 0;
  end
  else
  begin
    ShowMessage(MESSAGE03);
    exit;
  end;
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
  Label1.Caption := Form1.Caption;
  // load configuration
  inifile := untcommonproc.userdir + DIR_CONFIG + 'mm6dread.ini';
  if FileSearch('mm6dread.ini', untcommonproc.userdir + DIR_CONFIG) <> '' then
    if not loadconfiguration(inifile) then
      ShowMessage(MESSAGE01);
  Edit1.Text := untcommonproc.uids;
  for b := 0 to 63 do
    if length(urls[b]) > 0 then
      ComboBox1.Items.Add(untcommonproc.urls[b]);
  // others
  untcommonproc.Value := TStringList.Create;
  ValueListEditor1.Cells[0, 0] := MESSAGE05;
  ValueListEditor1.Cells[1, 0] := MESSAGE06;
  ValueListEditor1.Cells[0, 1] := MESSAGE07;
  ValueListEditor1.Cells[0, 2] := MESSAGE08;
  ValueListEditor1.Cells[0, 3] := MESSAGE09;
  ValueListEditor1.Cells[0, 4] := MESSAGE10;
  ValueListEditor1.Cells[0, 5] := MESSAGE11;
  ValueListEditor1.Cells[0, 6] := MESSAGE12;
  ValueListEditor1.Cells[0, 7] := MESSAGE13;
  ValueListEditor1.Cells[0, 8] := MESSAGE14;
  ValueListEditor1.Cells[0, 9] := MESSAGE15;
  ValueListEditor1.Cells[0, 10] := MESSAGE16;
  ValueListEditor1.Cells[0, 11] := MESSAGE17;
  ValueListEditor1.AutoSizeColumn(0);
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
