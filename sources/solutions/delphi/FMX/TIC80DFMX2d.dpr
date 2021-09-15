program TIC80DFMX2d;

uses
  System.StartUpCopy,
  FMX.Forms,
  fmain in 'fmain.pas' {Form2},
  Tic80Backend in '..\..\..\common\Tic80Backend.pas',
  VerySimple.Lua.Lib in '..\..\..\thirdPart\verysimplelua\Source\VerySimple.Lua.Lib.pas',
  VerySimple.Lua in '..\..\..\thirdPart\verysimplelua\Source\VerySimple.Lua.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
