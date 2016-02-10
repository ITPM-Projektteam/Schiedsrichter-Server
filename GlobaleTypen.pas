// Unit GlobaleTypen
// fuer Projekt USBKamera
//
// aufgebaut fuer:
// Modul Programmiersprachen II, WiSe 2015/16
// Versionen 0-1.06: Autor = S. Behr, FH Muenster
// Erweiterungen: Version 1.xx: Autor =

unit GlobaleTypen;

interface


type TFarbSchema = (fsRot, fsGruen, fsBlau, fsGelb, fsSchwarz);

type TBGR24 = packed record
  B, G, R: Byte;   // Reihenfolge Blau, Gruen, Rot!!
end;

type TRGB24 = packed record
  R, G, B: Byte;   // Reihenfolge Rot, Gruen, Blau!!
end;
PBGR24 = ^TBGR24;
PRGB24 = ^TRGB24;

type TFPoint = record
  X: Double;
  Y: Double;
end;

type TPunkt = record
  Position : TFPoint;
  SuchOffen: Boolean;
  FarbSchema: TFarbSchema;
end;

type TObjekt = record
  Mittelpunkt : TFPoint;
  PunkteIndizes: array of Integer;
  AnzahlPunkte: Integer;
  IstGross: Boolean;
  FarbSchema: TFarbSchema;
end;

type TGrossesObjekt = record
  Mittelpunkt : TFPoint;
  AnzahlPunkte: Integer;
  FarbSchema: TFarbSchema;
end;

type TDreiBool = array[1..3] of Boolean;

// Konstanten fuer die Ergebnis-Arrays
const MAX_PIXELLISTE = 200000;// max. Anzahl Pixel gesamt
      MAX_OBJEKTANZAHL = 50;
      OBJEKTINDIZES = 100000; // max. Anzahl Punkte pro Objekt
      ANZAHL_ROBOTER = 4;
      PROTOKOLL_VERSION = 2;

// Konstanten fuer das Capturing
const
  WM_USER = $0400;
  WM_CAP_DRIVER_CONNECT = WM_USER + 10;
  WM_CAP_DRIVER_DISCONNECT = WM_USER + 11;
  WM_CAP_EDIT_COPY = WM_USER + 30;
  WM_CAP_DLG_VIDEOFORMAT = WM_USER + 41;
  WM_CAP_DLG_VIDEOSOURCE = WM_USER + 42;
  WM_CAP_SET_PREVIEW = WM_USER + 50;
  WM_CAP_SET_OVERLAY = WM_USER + 51;
  WM_CAP_SET_PREVIEWRATE = WM_USER + 52;
  WM_CAP_SET_SCALE = WM_USER + 53;


implementation

end.
