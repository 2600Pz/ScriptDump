if (!(Test-Path "home:\usmt")) {
    New-PSDrive -name "home" -PSProvider FileSystem -Root "\\fs04\homes$\watsoj340" | Out-Null
}
Set-Location home:\usmt | Out-Null

while ($true) {
    $dataStore = (Read-host -Prompt "Enter the data store name to load")
    if (Test-Path "\\fs04\homes$\watsoj340\$dataStore") {
        break
    } else {
        Write-Host "Data store not found. Please try again." -ForegroundColor Yellow
    }
}

.\loadstate.exe \\fs04\homes$\watsoj340\$dataStore /i:MigDocs.xml /i:MigUser.xml /c