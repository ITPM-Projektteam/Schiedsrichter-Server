program USBKamera;

uses
  Vcl.Forms,
  FormUnit in 'FormUnit.pas' {fmHauptForm},
  GlobaleTypen in 'GlobaleTypen.pas',
  AuswertungKlasse in 'AuswertungKlasse.pas',
  KameraUnit in 'KameraUnit.pas',
  Client in 'Client.pas',
  ClientUndServer in 'ClientUndServer.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmHauptForm, fmHauptForm);
  Application.Run;
end.
