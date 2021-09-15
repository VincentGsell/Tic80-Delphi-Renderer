program TI804OP;

uses
  Vcl.Forms,
  fmain in 'fmain.pas' {Form1},
  Tic80Backend in '..\..\..\common\Tic80Backend.pas',
  VerySimple.Lua.Lib in '..\..\..\thirdPart\verysimplelua\Source\VerySimple.Lua.Lib.pas',
  VerySimple.Lua in '..\..\..\thirdPart\verysimplelua\Source\VerySimple.Lua.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
