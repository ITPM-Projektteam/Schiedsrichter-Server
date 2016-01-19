program Project1;

uses
  Vcl.Forms,
  Server in 'Server.pas' {Schiedsrichter},
  Client in 'Client.pas',
  ClientUndServer in 'ClientUndServer.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TSchiedsrichter, Schiedsrichter);
  Application.Run;
end.
