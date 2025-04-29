program prjGenerate;

uses
  Vcl.Forms,
  uMainGenerate in 'uMainGenerate.pas' {fmGenerate};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmGenerate, fmGenerate);
  Application.Run;
end.
