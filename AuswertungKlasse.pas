// Unit AuswertungKlasse
// fuer Projekt USBKamera
//
// aufgebaut fuer:
// Modul Programmiersprachen II, WiSe 2015/16
// Versionen 0-1.06: Autor = S. Behr, FH Muenster
// Erweiterungen: Version 1.xx: Autor =

unit AuswertungKlasse;

interface

uses VCL.Graphics, System.Types, SysUtils, VCL.Forms, GlobaleTypen;


type TAuswertung = class
  strict private
    fdeltaPixel: Integer;
    fdeltaFarbe1, fdeltaFarbe2, fdeltaFarbe3: Integer;
    fFarbschemaWahl: TDreiBool;
    procedure FarbAuswertung(bm: TBitmap);
    procedure ObjektAuswertung;
  public
    { Public-Deklarationen }
    MaxAbstand: Integer;
    PixelProObjekt: Integer;
    Rechteck: TRect;

    ersterd: boolean;

    PixelAnzahl: Integer;
    PixelListe: array of TPunkt;
    GesamtPixel: Integer;

    ObjektListe: array of TObjekt;
    ObjektAnzahl: Integer;

    GrosseObjekte: array of TGrossesObjekt;
    Spielfeld: array[0..3] of TFPoint;

    PosNeu: array[0..2*ANZAHL_ROBOTER-1] of TFPoint;
    PosAlt: array[0..2*ANZAHL_ROBOTER-1] of TFPoint;

    SollKalibrieren: Boolean;

    property deltaPixel: Integer write fdeltaPixel;
    property deltaFarbe1: Integer write fdeltaFarbe1;
    property deltaFarbe2: Integer write fdeltaFarbe2;
    property deltaFarbe3: Integer write fdeltaFarbe3;
    property FarbschemaWahl: TDreiBool read fFarbschemaWahl write fFarbschemaWahl;

    constructor Create(dpix, dfarb1, dfarb2, dfarb3, ppo, maxab: Integer; fs: TDreiBool);
    procedure Arbeitsschritt(can: TCanvas; bm: TBitmap);
end;

var AuswertungObjekt: TAuswertung;

implementation



// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// Create
// Initialisierung von Attributen des Objektes
constructor TAuswertung.Create(dpix, dfarb1, dfarb2, dfarb3, ppo, maxab: Integer; fs: TDreiBool);
begin
  deltaPixel := dpix;
  deltaFarbe1 := dfarb1;
  deltaFarbe2 := dfarb2;
  PixelProObjekt := ppo;
  MaxAbstand := maxab;
  SollKalibrieren := False;

  ersterd:= True; // erster Durchgang

  FarbschemaWahl := fs;

  // Array fuer gefundene Pixel
  // ggf. dynamisch erweiterbar
  SetLength(PixelListe, MAX_PIXELLISTE); // maximale Anzahl, Performance
  PixelAnzahl := 0;

  // Array fuer gefundene 'Objekte' = Farbflächen
  // ggf. dynamisch erweiterbar
  SetLength(ObjektListe, MAX_OBJEKTANZAHL);
  ObjektAnzahl := 0;
end;



// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// Arbeitsschritt
// Canvas aus Panel besorgen, daraus auszuwertendes Bitmap bereitstellen
// Auswertungsroutine aufrufen und Infos darstellen
procedure TAuswertung.Arbeitsschritt(can: TCanvas; bm: TBitmap);
begin

  Application.ProcessMessages;

  // Bitmap zur Auswertung bereitstellen
  bm.Canvas.CopyRect(Rechteck, can, Rechteck);

  // ein kompletter Bildauswertungsschritt
  // Auswertung der Pixel --> Farben finden
  FarbAuswertung(bm);

  // Auswertung der Farbpunkte --> Objekte finden
  ObjektAuswertung;

end;







// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// FarbAuswertung
// Pixel gerastert (deltaPixel) durchlaufen und bewerten,
// ob es in PixelListe aufgenommen werden kann
// derzeit: drei Farbschemata prüfen
procedure TAuswertung.FarbAuswertung;
var b,h, bmh, bmb, offsetx, offsety: UInt32;
    pBGR24Bytes: PBGR24;
    BGR24Bytes: TBGR24;
    delta1, delta2,delta3, fs: Integer;
    b1, b2, b3, b4, b5, b6, b7, b8: Boolean;
    farbschema: TFarbSchema;
begin
  GesamtPixel := 0;

  offsetx := fdeltaPixel;
  offsety := offsetx;
  delta1 := fdeltaFarbe1;  // farbabstaende "TEAM 1"
  delta2 := fdeltaFarbe2;  // farbabstaende "TEAM 2"
  delta3 := fdeltaFarbe3;  // farbabstande "Spielfeld"

  bmh := bm.Height;
  bmb := bm.Width;

  PixelAnzahl := 0;

  // Auswahl-Booleans vorsetzen
  b1:= True; b2:= True; b3:= True; b4:= True;
  b5:= True; b6:= True; b7:= True; b8:= True;

  // farbschema vorsetzen
  farbschema := fsRot;



  h := 0;
  while h <= bmh-1 do
  begin
    // Scanline ist deutlich schneller als Pixels[] !
    pBGR24Bytes := bm.ScanLine[h];

    b := 0;
    while b <= bmb-1 do
    begin
      // Pixel bzgl. drei Farbschemata untersuchen
      for fs := 1 to 3 do
      begin
        // nur auswerten, wenn entsprechendes Attribut gesetzt
        if fFarbschemaWahl[fs] then
        begin
          BGR24Bytes := pBGR24Bytes^;
          case fs of
            1:
            begin
            // Schema Gelb: nur gelbfarbene Pixel uebernehmen
              b1 := True; //(BGR24Bytes.R - BGR24Bytes.B) > delta3;
              b2 := True; //(BGR24Bytes.G - BGR24Bytes.B) > delta3;
              b3 := True; //BGR24Bytes.R > 100;
              b4 := True; //BGR24Bytes.G > 100;
              b5 := BGR24Bytes.B < 60;
              b6 := True;
              b7 := BGR24Bytes.R + delta3 > 150;
              b8 := BGR24Bytes.G + delta3 > 150;
              farbschema := fsGelb;
            end;

            2:
            begin
            // Schema Gruen: nur besonders gruene Pixel uebernehmen
              b1 := (BGR24Bytes.G - BGR24Bytes.R) > delta2;
              b2 := (BGR24Bytes.G - BGR24Bytes.B) > delta2;
              b3 := BGR24Bytes.R < 180;
              b4 := BGR24Bytes.G > 50;
              b5 := BGR24Bytes.B < 180;
              b6 := True;
              b7 := True;
              b8 := True;
              farbschema := fsGruen;
            end;

            3:
            begin
            // Schema Blau: nur blaue Pixel uebernehmen
              b1 := (BGR24Bytes.B - BGR24Bytes.R) > delta1;
              b2 := (BGR24Bytes.B - BGR24Bytes.G) > delta1;
              b3 := BGR24Bytes.R < 180;
              b4 := BGR24Bytes.G < 180;
              b5 := BGR24Bytes.B > 50;
              b6 := True;
              b7 := True;
              b8 := True;
              farbschema := fsBlau;
            end;

{           4:
            begin
            // Schema Rot: nur besonders rote Pixel uebernehmen
              b1 := (BGR24Bytes.R - BGR24Bytes.G) > delta1;
              b2 := (BGR24Bytes.R - BGR24Bytes.B) > delta1;
              b3 := BGR24Bytes.G < 180;
              b4 := BGR24Bytes.B < 180;
              b5 := BGR24Bytes.R > 50;
              b6 := True;
              b7 := True;
              b8 := True;
              farbschema := fsRot;
            end;

            5:
            begin
            // Schema Schwarz: nur schwarze Pixel uebernehmen
              b1 := BGR24Bytes.B < 50;
              b2 := BGR24Bytes.G < 50;
              b3 := BGR24Bytes.R < 50;
              b4 := True;
              b5 := True;
              b6 := True;
              b7 := True;
              b8 := True;
              farbschema := fsSchwarz;
            end;
}
          end;

          // Auswahl des Pixels
          if  b1 and b2 and b3 and b4 and b5 and b6 and b7 and b8 then
          begin
              // alle Auswahlkriterien erfuellt!
              PixelListe[PixelAnzahl].Position.X := b;
              PixelListe[PixelAnzahl].Position.Y := h;
              PixelListe[PixelAnzahl].SuchOffen := True;
              PixelListe[PixelAnzahl].FarbSchema := farbschema;

              if PixelAnzahl < MAX_PIXELLISTE then Inc(PixelAnzahl);
              // ggf. dynamisch Nachladen
          end;
        end;
      end;

      // neuer Breiten-Laufindex, neue Pixeladresse, Zaehler inkr.
      b := b + offsetx;
      pBGR24Bytes := Pointer(UInt32(pBGR24Bytes)+3*offsetx);
      Inc(GesamtPixel);
    end;
    // neuer Hoehen-Laufindex
    h := h + offsety;
    Application.ProcessMessages;
  end;
end;



// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// ObjektAuswertung
// ordnet die Farbpunkte in PixelListe in Objekten an
procedure TAuswertung.ObjektAuswertung;
var pixs, objs, feld, spielf, robos1, robos2, i, j, minimum: Integer;
    tmp: TGrossesObjekt;
    tmp2: Integer;
    xsortiert, ysortiert: array[0..3] of Integer;

function Euklid(Punkt1, Punkt2: TFPoint): Double;
begin
  Result := Sqrt((Punkt1.X - Punkt2.X)*(Punkt1.X - Punkt2.X) + (Punkt1.Y - Punkt2.Y)*(Punkt1.Y - Punkt2.Y));
end;


// eingebettete Abstandsfunktion
function Abstand(MaxDist: Integer): Boolean;
    var i, dist: Integer;
    begin
      Result := False;

      // hier sind verschiedene Abstandsnormen definierbar
      // Betragsnorm bzgl. Objekt-Mittelpunkt:
      { Result :=  (Abs(PixelListe[pixs].Position.X - ObjektListe[objs].Mittelpunkt.X) +
                    Abs(PixelListe[pixs].Position.Y - ObjektListe[objs].Mittelpunkt.Y))
                   < MaxDist;
      }
      // Minimaler Abstand zu den Objekt-Punkten:
      i := ObjektListe[objs].AnzahlPunkte-1;
      while (i >= 0) and (not Result) do
      begin
        dist := Round(Abs(PixelListe[ObjektListe[objs].PunkteIndizes[i]].Position.X -
                        PixelListe[pixs].Position.X) +
                     Abs(PixelListe[ObjektListe[objs].PunkteIndizes[i]].Position.Y -
                        PixelListe[pixs].Position.Y));
        // dist := Euklid(PixelListe[ObjektListe[objs].PunkteIndizes[i]].Position, PixelListe[pixs].Position);
        Result := dist < MaxDist;
        Dec(i);
      end;
    end;

    procedure Swap(var x,y: Integer); overload;
    begin
      x:=x xor y;
      y:=x xor y;
      x:=x xor y;
    end;

    procedure Swap(var x,y: TFPoint); overload;
    var dummy: TFPoint;
    begin
      dummy := x;
      x := y;
      y := dummy;
    end;

begin

  ObjektAnzahl := 0;

  for pixs := 0 to PixelAnzahl-1 do
  begin
    if ObjektAnzahl = 0 then
    begin
       // erstes Objekt mit erstem Punkt initialisieren
       ObjektListe[0].Mittelpunkt := PixelListe[pixs].Position;
       ObjektListe[0].AnzahlPunkte := 1;
       SetLength(ObjektListe[0].PunkteIndizes, OBJEKTINDIZES); // ggf. nachladen!
       ObjektListe[0].PunkteIndizes[0] := 0;  // erster Punkt im ersten Objekt
       ObjektListe[0].IstGross := False;
       ObjektListe[0].FarbSchema := PixelListe[pixs].FarbSchema;
       ObjektAnzahl := 1;

       PixelListe[pixs].SuchOffen := False;
    end
    else
    begin
      if PixelListe[pixs].SuchOffen then
      begin
        objs := ObjektAnzahl-1;
        while (objs >= 0) and PixelListe[pixs].SuchOffen do
        begin
          if Abstand(MaxAbstand) and (PixelListe[pixs].FarbSchema = ObjektListe[objs].FarbSchema) then
          begin
            // Pixel wird nahem Objekt mit gleichem Farbschema zugeordnet
            PixelListe[pixs].SuchOffen := False;

            // PunktIndex in Objekt aufnehmen und ggf. PunkteListe erweitern
            ObjektListe[objs].PunkteIndizes[ObjektListe[objs].AnzahlPunkte] := pixs;

            if ObjektListe[objs].AnzahlPunkte < OBJEKTINDIZES - 1 then
               Inc(ObjektListe[objs].AnzahlPunkte); // ggf. Nachladen
          end;
          Dec(objs);
        end;

        // kein passendes Objekt zu Punkt gefunden --> neues Objekt anlegen:
        if PixelListe[pixs].SuchOffen then
        begin
           ObjektListe[ObjektAnzahl].Mittelpunkt := PixelListe[pixs].Position;
           ObjektListe[ObjektAnzahl].AnzahlPunkte := 1;
           SetLength(ObjektListe[ObjektAnzahl].PunkteIndizes, OBJEKTINDIZES); // ggf. nachladen!
           ObjektListe[ObjektAnzahl].PunkteIndizes[0] := pixs;  // erster Punkt im ersten Objekt
           ObjektListe[ObjektAnzahl].IstGross := False;
           ObjektListe[ObjektAnzahl].FarbSchema := PixelListe[pixs].FarbSchema;

           if ObjektAnzahl < MAX_OBJEKTANZAHL-1 then
              Inc(ObjektAnzahl);
           PixelListe[pixs].SuchOffen := False;
        end;
      end;
    end;
  end;

  // pruefen ob Objekt genug Pixel hat --> 'gross'
  // dann: Mittelwert berechnen und in
  // dyn. Array GrosseObjekte aufnehmen
  SetLength(GrosseObjekte, 0);
  for objs := 0 to ObjektAnzahl-1 do
  begin
    with ObjektListe[objs] do
    begin
      IstGross := AnzahlPunkte > PixelProObjekt;
      if IstGross then
      begin
        Mittelpunkt.X := 0;
        Mittelpunkt.Y := 0;
        for pixs := 0 to AnzahlPunkte-1 do
        begin
          Mittelpunkt.X := Mittelpunkt.X + PixelListe[PunkteIndizes[pixs]].Position.X;
          Mittelpunkt.Y := Mittelpunkt.Y + PixelListe[PunkteIndizes[pixs]].Position.Y;
        end;
        Mittelpunkt.X := Mittelpunkt.X / AnzahlPunkte;
        Mittelpunkt.Y := Mittelpunkt.Y / AnzahlPunkte;

        SetLength(GrosseObjekte, Length(GrosseObjekte)+1);
        GrosseObjekte[Length(GrosseObjekte)-1].Mittelpunkt := Mittelpunkt;
        GrosseObjekte[Length(GrosseObjekte)-1].FarbSchema := FarbSchema;
        GrosseObjekte[Length(GrosseObjekte)-1].AnzahlPunkte := AnzahlPunkte;

      end;
    end;
  end;


  // Liste der Großen Objekte nach Größe sortieren

  for i := Low(GrosseObjekte) to High(GrosseObjekte)-1 do
  begin
    minimum := i;
    for j := i + 1 to High(GrosseObjekte) do
    begin
      if GrosseObjekte[j].AnzahlPunkte < GrosseObjekte[minimum].AnzahlPunkte then
        minimum := j;
    end;

    if i <> minimum then
    begin
      tmp := GrosseObjekte[i];
      GrosseObjekte[i] := GrosseObjekte[minimum];
      GrosseObjekte[minimum] := tmp;
    end;

  end;

  spielf := 0;    //spielfeld finden

  if SollKalibrieren then
  begin

    // Ecken suchen
    for i := Low(GrosseObjekte) to High(GrosseObjekte) do begin
      if (GrosseObjekte[i].FarbSchema = fsGelb) then begin
            Spielfeld[spielf] := GrosseObjekte[i].Mittelpunkt;
            inc(spielf);
            if spielf >= 4 then begin
              SollKalibrieren := False;
              Break;
            end;
      end;
    end;

    for i := Low(Spielfeld) to High(Spielfeld) do
    begin
      xsortiert[i] := i;
      ysortiert[i] := i;
    end;

    // Ecken sortieren (x)
    for i := Low(xsortiert) to High(xsortiert)-1 do
    begin
      minimum := i;
      for j := i + 1 to High(xsortiert) do
      begin
        if Spielfeld[xsortiert[j]].x < Spielfeld[xsortiert[minimum]].x then
          minimum := j;
      end;

      if i <> minimum then
        Swap(xsortiert[i], xsortiert[minimum]);
    end;

    // Ecken sortieren (y)
    for i := Low(ysortiert) to High(ysortiert)-1 do
    begin
      minimum := i;
      for j := i + 1 to High(ysortiert) do
      begin
        if Spielfeld[ysortiert[j]].y < Spielfeld[ysortiert[minimum]].y then
          minimum := j;
      end;

      if i <> minimum then
        Swap(ysortiert[i], ysortiert[minimum]);
    end;

    for i := Low(Spielfeld) to High(Spielfeld) - 1 do
      for j := i+1 to High(Spielfeld) do
        case i of
          1:
            if j in ([xsortiert[0], xsortiert[1]] * [ysortiert[0], ysortiert[1]]) then
            begin
              Swap(Spielfeld[i], Spielfeld[j]);
              Break;
            end;
          2:
            if j in ([xsortiert[0], xsortiert[1]] * [ysortiert[2], ysortiert[3]]) then
            begin
              Swap(Spielfeld[i], Spielfeld[j]);
              Break;
            end;
          3:
            if j in ([xsortiert[2], xsortiert[3]] * [ysortiert[2], ysortiert[3]]) then
            begin
              Swap(Spielfeld[i], Spielfeld[j]);
              Break;
            end;
        end;
    {for i := Low(Spielfeld) to High(Spielfeld) do
    begin
      if (    (i = xsortiert[0]) or i = xsortiert[1])
            and (Spielfeld[i].X = xsortiert[1].X))
          and
           (Spielfeld[i] = ysortiert[0]) or (Spielfeld[i] = ysortiert[1])) then
        if i <> 0 then
        begin
          tmp2 := Spielfeld[i];
          Spielfeld[i] := Spielfeld[0];
          Spielfeld[0] := tmp2;
          Break;
        end;
    end;

    for i := Low(Spielfeld)+1 to High(Spielfeld) do
    begin
      if ( (Spielfeld[i] = xsortiert[0]) or (Spielfeld[i] = xsortiert[1])
            and (Spielfeld[i] = ysortiert[2]) or (Spielfeld[i] = ysortiert[3])) then
        if i <> 1 then
        begin
          tmp2 := Spielfeld[i];
          Spielfeld[i] := Spielfeld[1];
          Spielfeld[1] := tmp2;
          Break;
        end;
    end;

    for i := Low(Spielfeld)+2 to High(Spielfeld) do
    begin
      if ( (Spielfeld[i] = xsortiert[2]) or (Spielfeld[i] = xsortiert[3])
            and (Spielfeld[i] = ysortiert[2]) or (Spielfeld[i] = ysortiert[3])) then
        if i <> 2 then
        begin
          tmp2 := Spielfeld[i];
          Spielfeld[i] := Spielfeld[2];
          Spielfeld[2] := tmp2;
          Break;
        end;
    end;}

  end;


  // pruefen ob das Objekt TEAM 1, oder TEAM 2 angehört
  //dann: in Array PosAlt einfügen

  robos1 := 0;
  robos2 := 0;

  if ersterd then begin
    for feld := Low(GrosseObjekte) to High(GrosseObjekte) do begin
      if (GrosseObjekte[feld].FarbSchema = fsBlau) and (robos1 < ANZAHL_ROBOTER) then begin
        PosAlt[robos1] := GrosseObjekte[feld].Mittelpunkt;
        inc(robos1);
      end
      else if (GrosseObjekte[feld].FarbSchema = fsGruen) and (robos2 < ANZAHL_ROBOTER) then begin
        PosAlt[robos2+ANZAHL_ROBOTER] := GrosseObjekte[feld].Mittelpunkt;
        inc(robos2);
      end;
    end;
    if (robos1 = ANZAHL_ROBOTER) and (robos2 = ANZAHL_ROBOTER) then
      ersterd := False;
  end

  else
    for i := Low(PosNeu) to High(PosNeu) do begin
      minimum := -1;
      for feld := Low(GrosseObjekte) to High(GrosseObjekte) do begin
        if ((GrosseObjekte[feld].FarbSchema = fsBlau) and (i < ANZAHL_ROBOTER))
        or ((GrosseObjekte[feld].FarbSchema = fsGruen) and (i >= ANZAHL_ROBOTER)) then begin
          if minimum = -1 then begin
            PosNeu[i] := GrosseObjekte[feld].Mittelpunkt;
            minimum := feld;
          end
          else if Euklid(PosNeu[i], PosAlt[i]) > Euklid(GrosseObjekte[feld].Mittelpunkt, PosAlt[i]) then begin
            PosNeu[i] := GrosseObjekte[feld].Mittelpunkt;
            minimum := feld;
          end;
        end;

        if Euklid(PosNeu[i], PosAlt[i]) > 50 then
          PosNeu[i] := PosAlt[i];

      end;
    end;

end;

end.
