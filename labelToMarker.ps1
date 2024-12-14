# Parametereinstellungen
param(
    [string]$s = ".\\",  # Standardordner, falls kein Pfad angegeben wird
    [string]$dt = ""      # Zusätzliche Standardwerte für die Textdatei
)

# Überprüfe, ob der angegebene Pfad existiert
if (-not (Test-Path -Path $s)) {
    Write-Error "Der angegebene Pfad existiert nicht: $s"
    exit 1
}

# Hole alle Bilddateien im angegebenen Ordner
$bilder = Get-ChildItem -Path $s -File -Include *.jpg, *.jpeg, *.png, *.gif, *.bmp

foreach ($bild in $bilder) {
    try {
        # Lade die Metadaten des Bildes
        $metadaten = [System.Drawing.Image]::FromFile($bild.FullName)

        # Extrahiere Schlagwörter (Tags) aus den Metadaten (falls vorhanden)
        $schlagwoerter = @()

        foreach ($propItem in $metadaten.PropertyItems) {
            if ($propItem.Id -eq 0x9286) { # 0x9286 steht für "UserComment" in den EXIF-Daten
                $schlagwoerter = [System.Text.Encoding]::ASCII.GetString($propItem.Value).TrimEnd([char]0).Split(",")
                break
            }
        }

        # Schliesse das Bild, um Ressourcensperren zu vermeiden
        $metadaten.Dispose()

        # Erstelle den neuen Dateinamen
        $neuerDateiname = "$($bild.BaseName).txt"

        # Vollständigen Pfad zur neuen Datei erstellen
        $neuerDateipfad = Join-Path -Path $s -ChildPath $neuerDateiname

        # Erstelle den Inhalt der Textdatei
        $inhalt = @()
        if ($schlagwoerter.Count -gt 0) {
            $inhalt += ($schlagwoerter -join ", ")
        } else {
            $inhalt += "Keine Schlagwörter gefunden"
        }

        # Füge die Default-Werte hinzu, falls angegeben
        if ($dt -ne "") {
            $inhalt += "`n$dt"
        }

        # Schreibe die Schlagwörter in die Textdatei
        [System.IO.File]::WriteAllText($neuerDateipfad, ($inhalt -join "`n"), [System.Text.Encoding]::UTF8)

    } catch {
        Write-Warning "Fehler beim Verarbeiten der Datei $($bild.FullName): $_"
    }
}

Write-Host "Skript abgeschlossen."