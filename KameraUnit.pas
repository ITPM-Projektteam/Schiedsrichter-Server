// Unit KameraUnit
// fuer Projekt USBKamera
//
// aufgebaut fuer:
// Modul Programmiersprachen II, WiSe 2015/16
// Versionen 0-1.06: Autor = S. Behr, FH Muenster
// Erweiterungen: Version 1.xx: Autor =

unit KameraUnit;

interface

uses Winapi.Windows, System.Types, Vcl.ExtCtrls, GlobaleTypen;

type TUSBKamera = class
  public
    KameraHandle: THandle;
    procedure KameraStarten(pan: TPanel);
    procedure DialogEinstellungen;
    procedure DialogFormat;
end;

  // MS-Betriebssystemroutine zur Erzeugung eines Capture-Ausgabefensters
function capCreateCaptureWindowA(lpszWindowName: PChar; dwStyle: dword;
  x, y, nWidth, nHeight: word; ParentWin: dword; nId: word): dword;
  stdcall external 'C:\Windows\System32\AVICAP32.DLL';
function capGetDriverDescriptionA(wDriverIndex: word; lpszName: LPSTR;
           cbName: Integer; lpszVer: LPSTR; cbVer: Integer): Boolean;
  stdcall external 'C:\Windows\System32\AVICAP32.DLL';

var USBKamera: TUSBKamera;

implementation

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// KameraStarten
// Methoden für das Starten der Bildaufnahme im Panel:

procedure TUSBKamera.KameraStarten(pan: TPanel);
begin
  // Funktion capCreateCaptureWindowA aus der AVICAP32.DLL von MS
  // erzeugt Handle auf Bild-Ausgabebereich
  //    (d. i. ein Verweis - eine von Windows verwaltete Integerzahl)
  // Paramter: lpszWindowName: Name des Ausgabebereichs, hier USBCam
  //           dwStyle: Window Style Konstante,
  //                            WS_CHILD=Unterfenster (keine Menuleiste)
  //                            WS_VISIBLE=Fenster ist sichtbar
  //           x,y: Position der oberen linken Ecke (hier: kein Abstand)
  //           nWidth, nHeight: (maximale!) Breite und Hoehe des Ausgabefensters
  //           hWnd: ParentWindow-Handle zu dem Windows-Bildschirmobjekt
  //                            eines Steuerelementes, das als Ausgabefenster
  //                            genutzt wird
  //           nId: Fenster_Id-Nummer, hier: 1


  KameraHandle := capCreateCaptureWindowA('USBCam', WS_CHILD or WS_VISIBLE, 0, 0,
                      pan.Width, pan.Height, pan.Handle, 1);


  // Funktion SendMessage wird verwendet, um Fenstern oder
  // dem Betriebssystem Nachrichten zu senden
  // hier: Einstellungen der Bilderfassung
  // die vordefinierten MS-Konstanten WM... wurden oben deklariert
  // Parameter: hWnd: Verweis auf empfangendes "Fenster"
  //            Msg:  zu sendende Nachricht als Konstante
  //            P1: erster Parameter der Nachricht
  //            P2: zweiter Parameter der Nachricht, hier immer = 0

  SendMessage(KameraHandle, WM_CAP_DRIVER_CONNECT, 0, 0);    // P1=0: Index des Cam-Treibers

  //SendMessage(handle, WM_CAP_SET_SCALE, 1, 0);

  SendMessage(KameraHandle, WM_CAP_SET_PREVIEWRATE, 30, 0);  // P1=30ms: Bildwiederholrate
  sendMessage(KameraHandle, WM_CAP_SET_OVERLAY, 1, 0);       // P1=1(True): Overlay der Grafikkarte nutzen
  SendMessage(KameraHandle, WM_CAP_SET_PREVIEW, 1, 0);       // P1=1(True): Daten der Kamera laufend zum
                                                             //             zum Vorschaufenster geben
                                                             // P1=0(False): nur ein Bild
end;


procedure TUSBKamera.DialogEinstellungen;
begin
  SendMessage(KameraHandle, WM_CAP_DLG_VIDEOSOURCE, 0, 0);    // P1=0: Index des Cam-Treibers
end;

procedure TUSBKamera.DialogFormat;
begin
  SendMessage(KameraHandle, WM_CAP_DLG_VIDEOFORMAT, 0, 0);    // P1=0: Index des Cam-Treibers
end;


initialization
  USBKamera := TUSBKamera.Create;

finalization
  USBKamera.Free;

end.
