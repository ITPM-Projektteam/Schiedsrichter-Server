unit Client;

interface

  uses IdTCPClient, IdGlobal, ClientUndServer, SysUtils, Classes;

  type
    TServerVerbindung = class(TObject)
      private
        tcpClient: TIdTCPClient;
      public
        constructor Create(IP: String; Port: Integer); //< Baut eine Verbindung zum Server auf
        function Anmelden(Teamwahl: TTeam): Boolean; //< Meldet das Team an.
        function WarteAufSpielstart: Boolean; //< Wartet bis der Server das Signal für den Spielstart sendet.
        function StatusEmpfangen: TSpielstatus; ///< Wartet auf den nächsten Satz Spieldaten und gibt diese dann zurück.
        function GefangenMelden(index: Integer): Boolean; //< Meldet den Roboter mit dem übergebenen Index als gefangen.
    end;

implementation

{ TServerVerbindung }

constructor TServerVerbindung.Create(IP: String; Port: Integer);
begin
  tcpClient.Host := IP;
  tcpClient.Port := Port;
end;

function TServerVerbindung.Anmelden(Teamwahl: TTeam): Boolean;
begin
  Try
    tcpClient.Connect;
    tcpClient.Socket.Write(Byte(ANMELDUNG));
    tcpClient.Socket.Write(SmallInt(PROTOKOLL_VERSION));
    tcpClient.Socket.Write(Byte(Teamwahl));
    Result := tcpClient.Socket.ReadByte = Byte(ANMELDUNG_ERFOLGREICH);
  Except
    Result := False;
  End;
end;

function TServerVerbindung.GefangenMelden(index: Integer): Boolean;
begin
  Try
    tcpClient.Socket.Write(Byte(MELDUNG_GEFANGEN));
    tcpClient.Socket.Write(index);
    Result := True;
  Except
    Result := False;
  End;
end;

function TServerVerbindung.StatusEmpfangen: TSpielstatus;
var
    Paket: TMemoryStream;
    Zeitstempel: TTimeStamp;
    Team: TTeam;
    i: Integer;
begin
  tcpClient.Socket.ReadStream(Paket, SizeOf(TSpielstatus)); // TODO: Bytezahl könnte bei Änderungen nicht mehr stimmen

  Paket.Read(Zeitstempel, SizeOf(Zeitstempel));
  Result.Zeit := TimeStampToDateTime(Zeitstempel);

  for Team in [TEAM_ROT, TEAM_BLAU] do
  begin
    Paket.Read(Result.Punktestand[Team], SizeOf(Result.Punktestand[Team]));
    for i := 1 to ANZAHL_ROBOTER do
    begin
      Paket.Read(Result.RoboterIstAktiv[Team][i], SizeOf(Result.RoboterIstAktiv[Team][i]));
      Paket.Read(Result.Roboterpositionen[Team][i], SizeOf(Result.Roboterpositionen[Team][i]));
    end;
  end;

end;

function TServerVerbindung.WarteAufSpielstart: Boolean;
var alterTimeout: Integer;
begin
  alterTimeout := tcpClient.ReadTimeout;
  tcpClient.ReadTimeout := IdTimeoutInfinite;
  Result := tcpClient.Socket.ReadByte = Byte(SPIELBEGINN);
  tcpClient.ReadTimeout := alterTimeout;
end;

end.
