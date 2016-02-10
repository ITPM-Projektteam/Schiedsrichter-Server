// Unit FormUnit
// fuer Projekt USBKamera
//
// aufgebaut fuer:
// Modul Programmiersprachen II, WiSe 2015/16
// Versionen 0-1.3: Autor = S. Behr, FH Muenster
// Erweiterungen: Version 1.xx: Autor =

// TEAM 1     = Blau
// TEAM 2     = Grün
// Spielfeld  = Gelb

unit FormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ColorGrd,
  Vcl.Samples.Spin, Vcl.ComCtrls, JPEG, System.Types, Vcl.Buttons,
  GlobaleTypen, KameraUnit, AuswertungKlasse, Vcl.Menus, Vcl.ActnList,
  Vcl.StdActns, System.Actions, IdContext, IdBaseComponent, IdComponent,
  IdCustomTCPServer, IdTCPServer, ClientUndServer, Math, StrUtils;


type
  TfmHauptForm = class(TForm)
    imAusgabe: TImage;
    laInformationen: TLabel;
    seDPixel: TSpinEdit;
    seDFarbe1: TSpinEdit;
    Label2: TLabel;
    Label3: TLabel;
    btKameraStart: TButton;
    Panel1: TPanel;
    Timer1: TTimer;
    btAuswertungStarten: TButton;
    edIntervall: TEdit;
    Label4: TLabel;
    laStatus: TLabel;
    Label1: TLabel;
    Label5: TLabel;
    seMaxAbstand: TSpinEdit;
    cbOBild: TCheckBox;
    Label6: TLabel;
    sePixPerObjekt: TSpinEdit;
    laObjPos: TLabel;
    btTreiber: TButton;
    StatusBar1: TStatusBar;
    cbFS1: TCheckBox;
    cbFS2: TCheckBox;
    cbFS3: TCheckBox;
    cbPixel: TCheckBox;
    Label7: TLabel;
    seDFarbe2: TSpinEdit;
    MainMenu1: TMainMenu;
    Datei1: TMenuItem;
    Einstellungen1: TMenuItem;
    BildEinstellungen1: TMenuItem;
    FormatEinstellungen1: TMenuItem;
    Einstellungenladen1: TMenuItem;
    Einstellungenspeichern1: TMenuItem;
    ActionList1: TActionList;
    Schlieen1: TMenuItem;
    FileExit1: TFileExit;
    StatusBox: TListBox;
    Action2: TAction;
    seDFarbe3: TSpinEdit;
    Label8: TLabel;
    Button1: TButton;
    Panel2: TPanel;
    Shape_Bereit_Rot: TShape;
    Shape_Bereit_Blau: TShape;
    Label10: TLabel;
    Button_Start: TButton;
    DTPicker_Spieldauer: TDateTimePicker;
    Server: TIdTCPServer;
    Label_Zeit: TLabel;
    Label_Punkte: TLabel;

    type
      Adresse = record
      IP: string;
      Port: Word;
    end;

    procedure btAuswertungStartenClick(Sender: TObject);
    procedure seDPixelChange(Sender: TObject);
    procedure btKameraStartClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure seDFarbe1Change(Sender: TObject);
    procedure edIntervallChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure seMaxAbstandChange(Sender: TObject);
    procedure cbOBildClick(Sender: TObject);
    procedure sePixPerObjektChange(Sender: TObject);
    procedure imAusgabeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cbPixelClick(Sender: TObject);
    procedure btTreiberClick(Sender: TObject);
    procedure cbFS1Click(Sender: TObject);
    procedure cbFS2Click(Sender: TObject);
    procedure cbFS3Click(Sender: TObject);
    procedure seDFarbe2Change(Sender: TObject);
    procedure BildEinstellungen1Click(Sender: TObject);
    procedure FormatEinstellungen1Click(Sender: TObject);
    procedure Schlieen1Click(Sender: TObject);
    procedure WindowClose1Execute(Sender: TObject);
    procedure Einstellungenspeichern1Click(Sender: TObject);
    procedure Einstellungenladen1Click(Sender: TObject);
    procedure seDFarbe3Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ServerExecute(AContext: TIdContext);
    procedure ServerConnect(AContext: TIdContext);
  private
    Adressen: array[TTeam] of Adresse;
    Bereit: array[TTeam] of Boolean;
    KameraIstKalibriert: Boolean;
    SpielLaeuft: Boolean;
    Spielende: TDateTime;
    RoboterAktiv: array[TTeam] of array[1..ANZAHL_ROBOTER] of Boolean;
    Punkte: array[TTeam] of Integer;
  
    TimerIntervall: Integer;
    OBildAnzeige: Boolean;
    PixelAnzeige: Boolean;
    CamCanvas: TCanvas;
    HilfsBitmap: TBitmap;
    procedure ObjektDarstellung;
    
    procedure SendeSpielstatus;
    procedure VerbindungAbbrechen(art: TFehlerart; Kontext: TIdContext);
end;


var
  fmHauptForm: TfmHauptForm;




implementation
{$R *.dfm}



// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// Ablaufschema des Programms:
// FormCreate
// btKameraStartClick
//    --> KameraStarten
// btAuswertungStartenClick
//    --> Timer starten
// Timer1
//    --> Arbeitsschritt
//    --> ObjektDarstellung
// Arbeitsschritt
//    --> BitmapBereitstellen
//    --> Farbauswertung
//    --> Objektauswertung
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------



// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// btKameraStartClick
// ruft KameraStarten auf
procedure TfmHauptForm.btKameraStartClick(Sender: TObject);
begin
  btKameraStart.Enabled := False;  // klick once button

  USBKamera.KameraStarten(Panel1);

  btAuswertungStarten.Enabled := True;
  laStatus.Caption := 'Kamera gestartet';
  StatusBox.Items.Add('Kamera gestartet');

  // Canvas nach Bitmap umkopieren, damit
  // Bitmap.Scanline verwendet werden kann (Performance!)
  CamCanvas := TCanvas.Create;
  CamCanvas.Handle := GetWindowDC(Panel1.Handle);

  HilfsBitmap := TBitmap.Create;
  HilfsBitmap.Width := 640;
  HilfsBitmap.Height := 480;
  HilfsBitmap.PixelFormat := pf24bit;

end;



procedure TfmHauptForm.btTreiberClick(Sender: TObject);
begin
; // tbd
end;

procedure TfmHauptForm.Button1Click(Sender: TObject);
begin
  AuswertungObjekt.SollKalibrieren := True;
end;

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// btAuswertungStartenClick
// Auswertung beginnen, d. h. Timer starten
procedure TfmHauptForm.BildEinstellungen1Click(Sender: TObject);
begin
  USBKamera.DialogEinstellungen
end;

procedure TfmHauptForm.btAuswertungStartenClick(Sender: TObject);
var tdb: TDreiBool;
begin
  btAuswertungStarten.Enabled := False; // klick once button!
  Einstellungenladen1.Enabled := True;
  Einstellungenspeichern1.Enabled := True;


  tdb[1] := cbFS1.Checked;
  tdb[2] := cbFS2.Checked;
  tdb[3] := cbFS3.Checked;

  AuswertungObjekt := TAuswertung.Create(seDPixel.Value,
                                         seDFarbe1.Value,
                                         seDFarbe2.Value,
                                         seDFarbe3.Value,
                                         sePixPerObjekt.Value,
                                         seMaxAbstand.Value,
                                         tdb);

  AuswertungObjekt.Rechteck := Rect(0,0,HilfsBitmap.Width,HilfsBitmap.Height);

  HilfsBitmap.Canvas.CopyRect(AuswertungObjekt.Rechteck,
                              CamCanvas, AuswertungObjekt.Rechteck);


  OBildAnzeige := cbOBild.Checked;
  PixelAnzeige := cbPixel.Checked;

  seDPixel.Enabled := True;
  seDFarbe1.Enabled := True;
  seDFarbe2.Enabled := True;
  seDFarbe3.Enabled := True;
  seMaxAbstand.Enabled := True;
  sePixPerObjekt.Enabled := True;

  cbFS1.Enabled := True;
  cbFS2.Enabled := True;
  cbFS3.Enabled := True;

  edIntervall.Enabled := True;


  Timer1.Interval := TimerIntervall; // Start-Intervallwert verwenden
  Timer1.Enabled := True;
  laStatus.Caption := 'Auswertung gestartet';
  StatusBox.Items.Add('Auswertung gestartet');
  edIntervall.OnChange(Sender); // eingetragenen Intervallwert holen
  Application.ProcessMessages;
end;



// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// Timer1Timer
// Timer-Routine, einen Arbeitsschritt ausfuehren
procedure TfmHauptForm.Timer1Timer(Sender: TObject);
var tic, toc: TDateTime;
    i: Integer;
begin
  Timer1.Enabled := False;


  tic := Time;
  // Pixel und Objekte finden
  AuswertungObjekt.Arbeitsschritt(CamCanvas, HilfsBitmap);
  // Objekte darstellen (nur ausreichend grosse)
  ObjektDarstellung;
  toc := Time;


  // Informationen in der GUI bereitstellen
  {laInformationen.Caption := format('#Pixel = %d.  #FarbPixel = %d.  #Objekte = %d.' +
                                    '  #gr.Objekte = %d.  Dauer = %.2g', // %.2f durch %.2g ersetzt
                                      [AuswertungObjekt.GesamtPixel,
                                       AuswertungObjekt.PixelAnzahl,
                                       AuswertungObjekt.ObjektAnzahl,
                                       Length(AuswertungObjekt.GrosseObjekte),
                                       (toc-tic)*24*60*60]);
  laObjPos.Caption := '';
  for i := 0 to Length(AuswertungObjekt.GrosseObjekte)-1 do
    laObjPos.Caption := laObjPos.Caption + format('%d: %.0f:%.0f  ',
                                                [i,
                                                 AuswertungObjekt.GrosseObjekte[i].Mittelpunkt.X,
                                                 AuswertungObjekt.GrosseObjekte[i].Mittelpunkt.Y]);
    laObjPos.Caption := laObjPos.Caption + IntToStr(i) + ': '
                        + FloatToStr(AuswertungObjekt.GrosseObjekte[i].Mittelpunkt.X) + ':'
                        + FloatToStr(AuswertungObjekt.GrosseObjekte[i].Mittelpunkt.Y); }
  laStatus.Caption := 'Auswertung durchgeführt';

  Application.ProcessMessages;

  Timer1.Interval := TimerIntervall; // falls geaendert
  Timer1.Enabled := True;
end;


procedure TfmHauptForm.WindowClose1Execute(Sender: TObject);
begin

end;

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// ObjektDarstellung
procedure TfmHauptForm.ObjektDarstellung();
var i, j, farbe: Integer;
begin
  fmHauptForm.imAusgabe.Visible := False; // ggf. Ausblenden fuer Performance

  // Canvas von imAusgabe leeren
  imAusgabe.Canvas.Brush.Color := clBtnFace;// clWhite;
  imAusgabe.Canvas.FillRect(imAusgabe.Canvas.ClipRect);
  imAusgabe.Canvas.Pen.Color := clBlack;
  imAusgabe.Canvas.Rectangle(imAusgabe.Canvas.ClipRect);

  // ggf. Bild in imAusgabe unterlegen
  if cbOBild.Checked then
     imAusgabe.Picture.Bitmap.Assign(HilfsBitmap);


  // Darstellung Objekt-Punkte: bzgl. Farbschema einfaerben
  if PixelAnzeige then
  begin
    for i := 0 to AuswertungObjekt.ObjektAnzahl-1 do
    begin
      // nur groessere Objekte darstellen
      if AuswertungObjekt.ObjektListe[i].IstGross then
      begin
        for j := 0 to AuswertungObjekt.ObjektListe[i].AnzahlPunkte-1 do
        begin
          case AuswertungObjekt.ObjektListe[i].FarbSchema of
          fsRot:     farbe := clRed;
          fsGruen:   farbe := clGreen;
          fsGelb:    farbe := clYellow;
          fsSchwarz: farbe := clBlack;
          fsBlau:    farbe := clBlue;
          else farbe := clblack;
          end;
          with AuswertungObjekt.PixelListe[AuswertungObjekt.ObjektListe[i].PunkteIndizes[j]] do
            imAusgabe.Canvas.Pixels[Round(Position.X), Round(Position.Y)] := farbe;
        end;
      end;
    end;
  end;

  // Darstellung Mittelpunkte der Objekte: rote Kreise
  for i := Low(AuswertungObjekt.PosNeu) to High(AuswertungObjekt.PosNeu) do
  begin
    if (AuswertungObjekt.ersterd = false) then begin
      if i < ANZAHL_ROBOTER then
        imAusgabe.Canvas.Pen.Color := clBlue
      else
        imAusgabe.Canvas.Pen.Color := clGreen;
      imAusgabe.Canvas.Ellipse(Round(AuswertungObjekt.PosNeu[i].X)-10,
                                Round(AuswertungObjekt.PosNeu[i].Y)-10,
                                Round(AuswertungObjekt.PosNeu[i].X)+10,
                                Round(AuswertungObjekt.PosNeu[i].Y)+10);
      imAusgabe.Canvas.TextOut(Round(AuswertungObjekt.PosNeu[i].X-3),
                                Round(AuswertungObjekt.PosNeu[i].Y-7),
                                inttostr(i mod 4 + 1));
    end;

    imAusgabe.Canvas.Pen.Color := clBlack;
    imAusgabe.Canvas.MoveTo(Round(AuswertungObjekt.Spielfeld[0].X),Round(AuswertungObjekt.Spielfeld[0].Y));
    imAusgabe.Canvas.LineTo(Round(AuswertungObjekt.Spielfeld[1].X), Round(AuswertungObjekt.Spielfeld[1].Y));
    imAusgabe.Canvas.LineTo(Round(AuswertungObjekt.Spielfeld[2].X), Round(AuswertungObjekt.Spielfeld[2].Y));
    imAusgabe.Canvas.LineTo(Round(AuswertungObjekt.Spielfeld[3].X), Round(AuswertungObjekt.Spielfeld[3].Y));
    imAusgabe.Canvas.LineTo(Round(AuswertungObjekt.Spielfeld[0].X), Round(AuswertungObjekt.Spielfeld[0].Y));

    
  end;

  imAusgabe.Visible := True; // Ausgabe-Image wieder einblenden
end;


procedure TfmHauptForm.Schlieen1Click(Sender: TObject);
begin

end;

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// Auslesen von Pixelfarben per Mausklick: in imAusgabe-Koordinaten!!
procedure TfmHauptForm.imAusgabeMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var w: Integer;
    rgb: PRGB24;

begin
 w :=  HilfsBitmap.Canvas.Pixels[X,Y];
 rgb := @w;
 StatusBar1.Panels[1].Text := format('R: %d, G: %d, B: %d', [rgb.R, rgb.G, rgb.B]);
end;

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// im folgenden nur noch Konstruktor und simple Steuerelement-Callbacks
procedure TfmHauptForm.FormatEinstellungen1Click(Sender: TObject);
begin
  USBKamera.DialogFormat;
end;

procedure TfmHauptForm.FormCreate(Sender: TObject);
var
  team: TTeam;
  i: Integer;
begin
  TimerIntervall := 10;  // beim ersten Mal: quasi sofort!
  laStatus.Caption := 'Bereit';
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

procedure TfmHauptForm.SendeSpielstatus;
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

procedure TfmHauptForm.ServerConnect(AContext: TIdContext);
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

  if Adressen[teamwahl].IP = '' then
  begin
    if teamwahl = TEAM_ROT then
    begin
      Shape_Bereit_Rot.Brush.Color := clRed;
      StatusBox.Items.Add('Team Grün bereit');
    end
    else
    begin
      Shape_Bereit_Rot.Brush.Color := clBlue;
      StatusBox.Items.Add('Team Blau bereit');
    end;
    Adressen[teamwahl].IP := AContext.Binding.PeerIP;
    Adressen[teamwahl].Port := AContext.Binding.PeerPort;
    AContext.Connection.Socket.Write(Byte(ANMELDUNG_ERFOLGREICH));
    Bereit[teamwahl] := True;
  end
  else
    AContext.Connection.Socket.Write(Byte(ANMELDUNG_FEHLGESCHLAGEN));

  if Bereit[TEAM_BLAU] and Bereit[TEAM_ROT] and KameraIstKalibriert then
    Button_Start.Enabled := True;

end;

procedure TfmHauptForm.ServerExecute(AContext: TIdContext);
var
  index: Integer;
  sender, team: TTeam;
begin
  with  AContext.Connection.Socket do
  begin

    sender := TTeam(-1);

    for team in [TEAM_ROT, TEAM_BLAU] do
      if (Adressen[team].IP = AContext.Binding.IP) and (Adressen[team].Port = AContext.Binding.Port) then
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

procedure TfmHauptForm.VerbindungAbbrechen(art: TFehlerart; Kontext: TIdContext);
begin
  Kontext.Connection.Socket.Write(Byte(ABBRUCH_DURCH_SERVER));
  Kontext.Connection.Socket.Write(Byte(art));
  Kontext.Connection.Disconnect;
end;

procedure TfmHauptForm.seDFarbe1Change(Sender: TObject);
begin
  AuswertungObjekt.deltaFarbe1 := seDFarbe1.Value;
end;

procedure TfmHauptForm.seDFarbe2Change(Sender: TObject);
begin
  AuswertungObjekt.deltaFarbe2 := seDFarbe2.Value;
end;

procedure TfmHauptForm.seDFarbe3Change(Sender: TObject);
begin
  AuswertungObjekt.deltaFarbe3 := seDFarbe3.Value;
end;

procedure TfmHauptForm.seDPixelChange(Sender: TObject);
begin
  AuswertungObjekt.deltaPixel := seDPixel.Value;
end;

procedure TfmHauptForm.seMaxAbstandChange(Sender: TObject);
begin
  AuswertungObjekt.MaxAbstand := seMaxAbstand.Value;
end;

procedure TfmHauptForm.sePixPerObjektChange(Sender: TObject);
begin
  AuswertungObjekt.PixelProObjekt := sePixPerObjekt.Value;
end;

procedure TfmHauptForm.edIntervallChange(Sender: TObject);
begin
  TimerIntervall := StrToInt(edIntervall.Text);
end;

procedure TfmHauptForm.Einstellungenladen1Click(Sender: TObject);
var sl: TStringList;
    zeile: Integer;
begin
  sl:= TStringList.Create;
  zeile := 0;

  try
    sl.LoadFromFile('config.txt');
    sedPixel.Value := StrToInt(sl[zeile]);
    Inc(Zeile);
    sePixPerObjekt.Value := StrToInt(sl[zeile]);
    Inc(zeile);
    seMaxAbstand.Value := StrToInt(sl[zeile]);
    Inc(zeile);
    seDFarbe1.Value := StrToInt(sl[zeile]);
    Inc(zeile);
    seDFarbe2.Value := StrToInt(sl[zeile]);
    Inc(zeile);
    seDFarbe3.Value := StrToInt(sl[zeile]);
    Inc(zeile);
    edIntervall.Text := sl[zeile];
    Inc(zeile);
    if sl[zeile] = '0' then begin
      cbOBild.Checked := False;
    end
    else if sl[zeile] = '-1' then begin
      cbOBild.Checked := True;
    end;
    Inc(zeile);
    if sl[zeile] = '0' then begin
      cbPixel.Checked := False;
    end
    else if sl[zeile] = '-1' then begin
      cbPixel.Checked := True;
    end;
    Inc(zeile);
    if sl[zeile] = '0' then begin
      cbFS1.Checked := False;
    end
    else if sl[zeile] = '-1' then begin
      cbFS1.Checked := True;
    end;
    Inc(zeile);
    if sl[zeile] = '0' then begin
      cbFS2.Checked := False;
    end
    else if sl[zeile] = '-1' then begin
      cbFS2.Checked := True;
    end;
    Inc(zeile);
    if sl[zeile] = '0' then begin
      cbFS3.Checked := False;
    end
    else if sl[zeile] = '-1' then begin
      cbFS3.Checked := True;
    end;



  finally
    sl.Free
  end;

  StatusBox.Items.Add('Einstellungen geladen');
end;

procedure TfmHauptForm.Einstellungenspeichern1Click(Sender: TObject);
var sl: TStringList;
begin
  sl:= TStringList.Create;

  try
    sl.Add(Inttostr(sedPixel.Value));
    sl.Add(Inttostr(sePixPerObjekt.Value));
    sl.Add(Inttostr(seMaxAbstand.Value));
    sl.Add(Inttostr(seDFarbe1.Value));
    sl.Add(Inttostr(seDFarbe2.Value));
    sl.Add(IntToStr(seDFarbe3.Value));
    sl.Add(edIntervall.Text);
    sl.Add(BoolToStr(cbOBild.Checked));
    sl.Add(BoolToStr(cbPixel.Checked));
    sl.Add(BoolToStr(cbFS1.Checked));
    sl.Add(BoolToStr(cbFS2.Checked));
    sl.Add(BoolToStr(cbFS3.Checked));
    sl.SaveToFile('config.txt');
  finally
    sl.Free
  end;

  StatusBox.Items.Add('Einstellungen gespeichert');

end;

procedure TfmHauptForm.cbOBildClick(Sender: TObject);
begin
  OBildAnzeige := cbOBild.Checked;
end;

procedure TfmHauptForm.cbPixelClick(Sender: TObject);
begin
  PixelAnzeige := cbPixel.Checked;
end;

procedure TfmHauptForm.cbFS1Click(Sender: TObject);
var tdb: TDreiBool;
begin
  tdb := AuswertungObjekt.FarbschemaWahl;
  tdb[3] := cbFS1.Checked;
  AuswertungObjekt.FarbschemaWahl := tdb;
end;
procedure TfmHauptForm.cbFS2Click(Sender: TObject);
var tdb: TDreiBool;
begin
  tdb := AuswertungObjekt.FarbschemaWahl;
  tdb[2] := cbFS2.Checked;
  AuswertungObjekt.FarbschemaWahl := tdb;
end;
procedure TfmHauptForm.cbFS3Click(Sender: TObject);
var tdb: TDreiBool;
begin
  tdb := AuswertungObjekt.FarbschemaWahl;
  tdb[1] := cbFS3.Checked;
  AuswertungObjekt.FarbschemaWahl := tdb;
end;


end.
