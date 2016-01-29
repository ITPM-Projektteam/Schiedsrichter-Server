unit Server;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ColorGrd,
  Vcl.Buttons, Vcl.Grids, IdBaseComponent, IdComponent, IdCustomTCPServer,
  IdTCPServer, Vcl.ComCtrls, IdContext, ClientUndServer, Math, StrUtils;

type

  Adresse = record
    IP: string;
    Port: Word;
  end;

  TSchiedsrichter = class(TForm)
    Label1: TLabel;
    Image_Kamerabild: TImage;
    Label2: TLabel;
    Label_Punkte: TLabel;
    LB_Roboter_Rot: TListBox;
    Label4: TLabel;
    LB_Roboter_Blau: TListBox;
    Label5: TLabel;
    Label_Zeit: TLabel;
    Panel1: TPanel;
    Label9: TLabel;
    Button_Start: TButton;
    Shape_Bereit_Rot: TShape;
    Shape_Bereit_Blau: TShape;
    Server: TIdTCPServer;
    Button_Kamera_kalibrieren: TButton;
    DTPicker_Spieldauer: TDateTimePicker;
    Label3: TLabel;
    procedure ServerExecute(AContext: TIdContext);
    procedure ServerConnect(AContext: TIdContext);
    procedure FormCreate(Sender: TObject);
  private
    Adresse: array[TTeam] of Adresse;
    Bereit: array[TTeam] of Boolean;
    KameraIstKalibriert: Boolean;

    SpielLaeuft: Boolean;
    Spielende: TDateTime;
    RoboterAktiv: array[TTeam] of array[1..ANZAHL_ROBOTER] of Boolean;
    Punkte: array[TTeam] of Integer;

    procedure SendeSpielstatus;
    procedure VerbindungAbbrechen(art: TFehlerart; Kontext: TIdContext);
  public
    { Public-Deklarationen }
  end;

var
  Schiedsrichter: TSchiedsrichter;

implementation

{$R *.dfm}

procedure TSchiedsrichter.FormCreate(Sender: TObject);
var
  team: TTeam;
  i: Integer;
begin
  KameraIstKalibriert := False;
  SpielLaeuft := False;

  for team in [TEAM_ROT, TEAM_BLAU] do
  begin
    Bereit[team] := False;
    Punkte[team] := 0;
    for i := Low(RoboterAktiv[team]) to High(RoboterAktiv[team]) do
      RoboterAktiv[team][i] := False;

   // FillChar(Spielstatus.Roboterpositionen[team],
   //          SizeOf(Spielstatus.Roboterpositionen[team]), #0); //< TODO: So richtig?
  end;

end;

procedure TSchiedsrichter.SendeSpielstatus;
var
  Kontext: ^TIdContext;
  Team: TTeam;
  Paket: TMemoryStream;
  Zeitstempel: TTimeStamp;
  i: Integer;
begin

  Paket := TMemoryStream.Create;
  Zeitstempel := DateTimeToTimeStamp(Now); // Zeitpunkt der Aufnahme des Bildes einfügen
  Paket.Write(Zeitstempel, SizeOf(Zeitstempel));

  for Team in [TEAM_ROT, TEAM_BLAU] do
  begin
    Paket.Write(Punkte[Team], SizeOf(Punkte[Team]));
    for i := 1 to ANZAHL_ROBOTER do
    begin
      Paket.Write(RoboterAktiv[Team][i], SizeOf(RoboterAktiv[Team][i]));
      Paket.Write(i, 4); //Platzhalter
      Paket.Write(i, 4); //Platzhalter
      //Paket.Write(RoboterPosition[team][i], SizeOf(RoboterPosition[team][i]));
    end;
  end;

  Try
    for Kontext in Server.Contexts.LockList do
    begin
      Paket.Position := 0;
      Kontext.Connection.Socket.Write(Paket, Paket.Size);
    end;
  Finally
    Server.Contexts.UnlockList;
  End;

end;

procedure TSchiedsrichter.ServerConnect(AContext: TIdContext);
var teamwahl: TTeam;
begin
  if AContext.Connection.Socket.ReadByte <> Byte(ANMELDUNG) then
  begin
    VerbindungAbbrechen(ALLGEMEINER_PROTOKOLLFEHLER, AContext);
    Exit;
  end;

  if AContext.Connection.Socket.ReadSmallInt <> PROTOKOLL_VERSION then
  begin
    VerbindungAbbrechen(FALSCHE_VERSION, AContext);
    Exit;
  end;

  teamwahl := TTeam(AContext.Connection.Socket.ReadByte);

  if (teamwahl <> TEAM_ROT) and (teamwahl <> TEAM_BLAU) then
  begin
    VerbindungAbbrechen(ALLGEMEINER_PROTOKOLLFEHLER, AContext);
    Exit;
  end;

  if Bereit[teamwahl] = True then
  begin
    VerbindungAbbrechen(TEAM_SCHON_ANGEMELDET, AContext);
    Exit;
  end;

  if Adresse[teamwahl].IP = '' then
  begin
    Shape_Bereit_Rot.Brush.Color := clRed;
    Adresse[teamwahl].IP := AContext.Binding.PeerIP;
    Adresse[teamwahl].Port := AContext.Binding.PeerPort;
    AContext.Connection.Socket.Write(Byte(ANMELDUNG_ERFOLGREICH));
    Bereit[teamwahl] := True;
  end
  else
    AContext.Connection.Socket.Write(Byte(ANMELDUNG_FEHLGESCHLAGEN));

  if Bereit[TEAM_BLAU] and Bereit[TEAM_ROT] and KameraIstKalibriert then
    Button_Start.Enabled := True;

end;

procedure TSchiedsrichter.ServerExecute(AContext: TIdContext);
var
  index: Integer;
  sender, team: TTeam;
begin
  with  AContext.Connection.Socket do
  begin

    sender := TTeam(-1);

    for team in [TEAM_ROT, TEAM_BLAU] do
      if (Adresse[team].IP = AContext.Binding.IP) and (Adresse[team].Port = AContext.Binding.Port) then
        sender := team;

    Assert(sender <> TTeam(-1));

    case ReadByte of
      Byte(MELDUNG_GEFANGEN):
        begin
          index := ReadLongInt;

          if not inRange(index, Low(RoboterAktiv[sender]), High(RoboterAktiv[sender])) then
          begin
            VerbindungAbbrechen(UNGUELTIGE_ROBOTER_ID, AContext);
            Exit;
          end;

          if SpielLaeuft and RoboterAktiv[sender][index] then
          begin
            if sender = TEAM_ROT then
              Inc(Punkte[TEAM_BLAU])
            else
              Inc(Punkte[TEAM_ROT]);

            Label_Punkte.Caption := IntToStr(Punkte[TEAM_BLAU]) + ' - ' + IntToStr(Punkte[TEAM_ROT]);
          end;
        end;

    end;
  end;

end;

procedure TSchiedsrichter.VerbindungAbbrechen(art: TFehlerart; Kontext: TIdContext);
begin
  Kontext.Connection.Socket.Write(Byte(ABBRUCH_DURCH_SERVER));
  Kontext.Connection.Socket.Write(Byte(art));
  Kontext.Connection.Disconnect;
end;

end.
