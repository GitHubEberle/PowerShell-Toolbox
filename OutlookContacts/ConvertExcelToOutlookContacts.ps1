Import-Module ImportExcel

# Importieren Sie das Excel-Datenblatt in ein PowerShell-Objekt
$data = Import-Excel -Path "C:\Users\m.eberle\Desktop\vktelefon.xlsx"

# Definieren Sie die Spaltennamen
$columnNames = @("First Name", "Middle Name", "Last Name", "Title", "Suffix", "Nickname", "Given Yomi", "Surname Yomi", "E-mail Address", "E-mail 2 Address", "E-mail 3 Address", "Home Phone", "Home Phone 2", "Business Phone", "Business Phone 2", "Mobile Phone", "Car Phone", "Other Phone", "Primary Phone", "Pager", "Business Fax", "Home Fax", "Other Fax", "Company Main Phone", "Callback", "Radio Phone", "Telex", "TTY/TDD Phone", "IMAddress", "Job Title", "Department", "Company", "Office Location", "Manager's Name", "Assistant's Name", "Assistant's Phone", "Company Yomi", "Business Street", "Business City", "Business State", "Business Postal Code", "Business Country/Region", "Home Street", "Home City", "Home State", "Home Postal Code", "Home Country/Region", "Other Street", "Other City", "Other State", "Other Postal Code", "Other Country/Region", "Personal Web Page", "Spouse", "Schools", "Hobby", "Location", "Web Page", "Birthday", "Anniversary", "Notes")

# Erstellen Sie eine Liste, um alle Ihre neuen Objekte zu speichern
$csvObjects = @()

foreach ($row in $data) {
    # Erstellen Sie ein neues Objekt mit der gewünschten Struktur
    $csvObject = New-Object PSObject

    foreach ($columnName in $columnNames) {
        $csvObject | Add-Member -MemberType NoteProperty -Name $columnName -Value $(if ($row.PSObject.Properties.Name -contains $columnName) { $row."$columnName" } else { "" })
        Write-Host $columnName
    }

    $csvObjects += $csvObject
}

# Exportieren Sie die Liste der neuen Objekte in eine CSV-Datei
$csvObjects | Export-Csv -Path "C:\Users\m.eberle\Desktop\vktelefon.csv" -NoTypeInformation -Encoding UTF8