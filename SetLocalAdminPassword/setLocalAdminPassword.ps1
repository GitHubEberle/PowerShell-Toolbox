# Benutzername, Passwort und Beschreibung definieren
$userToCheck = "edv-install"
$newPassword = "5#irtXywRZe9"  # Ersetzen Sie dies durch Ihr gewünschtes Passwort
$userDescription = "Lokaler Administrator"  # Ersetzen Sie dies durch Ihre gewünschte Beschreibung

# Passwort in ein SecureString konvertieren
$securePassword = ConvertTo-SecureString -AsPlainText $newPassword -Force

try {
    # Überprüfen, ob der Benutzer existiert
    $user = Get-LocalUser -Name $userToCheck -ErrorAction Stop
    Write-Output "Benutzer '$userToCheck' existiert bereits. Passwort wird aktualisiert."

    # Aktualisieren des Passworts
    $user | Set-LocalUser -Password $securePassword
    Write-Output "Passwort für Benutzer '$userToCheck' wurde erfolgreich aktualisiert."

} catch [Microsoft.PowerShell.Commands.UserNotFoundException] {
    # Benutzer existiert nicht, also wird er erstellt
    New-LocalUser -Name $userToCheck -Password $securePassword -AccountNeverExpires -UserMayNotChangePassword -Description $userDescription
    Write-Output "Benutzer '$userToCheck' wurde erstellt mit der Beschreibung: '$userDescription'."

    # Benutzer zur Administratorengruppe hinzufügen
    Add-LocalGroupMember -Group "Administratoren" -Member $userToCheck
    Write-Output "Benutzer '$userToCheck' wurde zur Gruppe 'Administratoren' hinzugefügt."
    exit 0  # Erfolg
} catch {
    # Allgemeiner Fehler
    Write-Error "Ein Fehler ist aufgetreten: $_"
    exit 1  # Fehler
}