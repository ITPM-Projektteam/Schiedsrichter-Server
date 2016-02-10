unit Transformator;

interface

  uses ClientUndServer, Math, SysUtils;

  type
    TSpielfeld = Array[1..4] of TPosition; // Die Eckpunkte eines Spielfelds in der Reihenfolge: unten links, oben links, oben rechts, unten rechts.

    // Rechnet Punkte von Bildkoordinaten in relative Spielfeldkoordinaten um (Vektoren aus [0-1]^2, falls der Bildpunkt im Spielfeld liegt).
    TTransformator = class
      private
        Eckpunkte: TSpielfeld; // Die Eckpunkte des Spielfelds in Bildkoordinaten
        t: Array[1..6] of Double; // Zwischenterme für die Transformation, die für alle Bildpunkte gleich sind
        ax, ay: Double; // Koeffizienten der quadratischen Gleichung für x und y

      public
        procedure kalibrieren(pEckpunkte: TSpielfeld); // Bereitet den Transformator vor, Bildpunkte zu dem angegebenen Spielfeld zu berechnen.
        function transformieren(Bildpunkt: TPosition): TPosition; // Rechnet einen bestimmten Bildpunkt um.
    end;

implementation

{ TTransformator }

procedure TTransformator.kalibrieren(pEckpunkte: TSpielfeld);
begin
  Eckpunkte := pEckpunkte;

  t[1] := Eckpunkte[1].x - Eckpunkte[2].x;
  t[2] := Eckpunkte[1].y - Eckpunkte[2].y;
  t[3] := Eckpunkte[1].y - Eckpunkte[2].y + Eckpunkte[3].y - Eckpunkte[4].y;
  t[4] := Eckpunkte[1].x - Eckpunkte[2].x + Eckpunkte[3].x - Eckpunkte[4].x;
  t[5] := Eckpunkte[4].y - Eckpunkte[1].y;
  t[6] := Eckpunkte[4].x - Eckpunkte[1].x;

  ay :=  t[1]*t[3] - t[2]*t[4];
  ax := -t[6]*t[3] + t[5]*t[4];
end;

function TTransformator.transformieren(Bildpunkt: TPosition): TPosition;
var
  dx, dy: Double; // Die x- und y-Abstände des Bildpunktes zu Eckpunkte[1]
  bx, cx, by, cy: Double; // Koeffizienten der quadratischen Gleichungen für x und y;
begin
  dx := Bildpunkt.x - Eckpunkte[1].x;
  dy := Bildpunkt.y - Eckpunkte[1].y;

  by := t[1]*t[5] + t[3]*dx -t[2]*t[6] - t[4]*dy;
  cy := t[5]*dx - t[6]*dy;

  bx := t[6]*t[2] + t[3]*dx - t[5]*t[1] - t[4]*dy;
  cx := t[1]*dy - t[2]*dx;

  if (ax=0) then
    Result.x := -cx/bx
  else
    Result.x := (-bx - Sqrt(bx*bx - 4*ax*cx)) / 2*ax;

  if (ay=0) then
    Result.y := -cy/by
  else
    Result.y := (-by - Sqrt(by*by - 4*ay*cy)) / 2*ay;
end;

end.
