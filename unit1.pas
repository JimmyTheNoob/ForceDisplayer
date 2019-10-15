unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, Process;

const
  C_FNAME = 'display.py';

type

  { TForce_Displayer }

  TForce_Displayer = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Force_Displayer: TForce_Displayer;
  tfOut: TextFile;
  Res1: String;
  Res2: String;
  ResFull: String;
  RunProgram: TProcess;


implementation

{$R *.lfm}

{ TForce_Displayer }

procedure TForce_Displayer.FormCreate(Sender: TObject); // When program begins
begin
  ShowMessage('If you are using NVIDIA drivers this program wont work for you. If you do have NVIDIA drivers make sure to disable legacy boot and enable secure boot in your BIOS!');
end;

procedure TForce_Displayer.Button1Click(Sender: TObject); // On button press
begin

  Res1 := Edit1.Caption;
  Res2 := Edit2.Caption;
  ResFull := Res1 + 'x' + Res2;
  AssignFile(tfOut, C_FNAME);
  {$I+}
  try
    // Create the file, write some text and close it.
    rewrite(tfOut);

    writeln(tfOut, 'import subprocess');
    writeln(tfOut, 'import os');
    writeln(tfOut, 'import re');
    writeln(tfOut, 'def slicer(my_str,sub):');
    writeln(tfOut, '  index=my_str.find(sub)');
    writeln(tfOut, '  if index !=-1 :');
    writeln(tfOut, '      return my_str[index:]');
    writeln(tfOut, '  else :');
    writeln(tfOut, '      raise Exception("error")');
    writeln(tfOut, 'monitor = subprocess.check_output("xrandr | grep -w connected  | awk -F''[ \+]'' ''{print $1}''", shell=True)');
    writeln(tfOut, 'resolutionDetails = subprocess.check_output("cvt ' + Res1 + ' '+ Res2 + ' 60", shell=True)');
    writeln(tfOut, 'resolutionInfo = slicer(resolutionDetails, ''"'')');
    writeln(tfOut, 'a = "xrandr --newmode " + resolutionInfo');
    writeln(tfOut, 'b = "xrandr --addmode " + monitor + " " + "'+ ResFull +'" + "_60.00"');
    writeln(tfOut, 'c = "xrandr --output "+ monitor +" --mode "+ "'+ResFull+'" +"_60.00"');
    writeln(tfOut, 'monitor = monitor.replace(''\r'', '''').replace(''\n'', '''')');
    writeln(tfOut, 'resolutionInfo = resolutionInfo.replace(''\r'', '''').replace(''\n'', '''')');
    writeln(tfOut, 'a = a.replace("\r", "").replace("\n", "")');
    writeln(tfOut, 'b = b.replace("\r", "").replace("\n", "")');
    writeln(tfOut, 'c = c.replace("\r", "").replace("\n", "")');
    writeln(tfOut, 'print("\n\n")');
    writeln(tfOut, 'os.system(a)');
    writeln(tfOut, 'os.system(b)');
    writeln(tfOut, 'os.system(c)');
    writeln(tfOut, '');

    CloseFile(tfOut);

    RunProgram := TProcess.Create(nil);
    RunProgram.CommandLine := 'python display.py';
    RunProgram.Execute;
    RunProgram.Free;

    ShowMessage('Done');
    ShowMessage('Make sure to make that display.py script autostart in pc startup!');
  except
    // If there was an error the reason can be found here
    on E: EInOutError do
      ShowMessage('ERROR')
  end;

end;

end.

