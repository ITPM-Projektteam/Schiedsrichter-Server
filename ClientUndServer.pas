unit ClientUndServer;

interface

  uses GlobaleTypen;

  type
    TPakettyp = (ABBRUCH_DURCH_SERVER, ANMELDUNG, ANMELDUNG_ERFOLGREICH, ANMELDUNG_FEHLGESCHLAGEN, MELDUNG_GEFANGEN, SPIELBEGINN);
    TTeam = (TEAM_ROT, TEAM_BLAU);
    TFehlerart = (ALLGEMEINER_PROTOKOLLFEHLER, FALSCHE_VERSION, TEAM_SCHON_ANGEMELDET, UNGUELTIGE_ROBOTER_ID);

    TPosition = record
      x, y: Double;
    end;

    // Die Statusinformationen, die in festen Abstšnden an die Steuerungsserver der Spieler geschickt werden.
    TSpielstatus = record
      Zeit: TDateTime; //< Der Zeitpunkt der Messung der Positionen
      Punktestand: Array[TTeam] of Integer; //< Die aktuellen Punkte beider Teams
      Roboterpositionen: Array[TTeam] of Array[1..ANZAHL_ROBOTER] of TPosition; //< Die Positionen der Roboter beider Teams
      RoboterIstAktiv: Array[TTeam] of Array[1..ANZAHL_ROBOTER] of Boolean; //< Gibt an welche Roboter gerade aktiv sind
    end;

implementation

end.
