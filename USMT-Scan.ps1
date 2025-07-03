$usernamesToSave = @()
while ($true) {
    $username = Read-Host "Enter a username to save (or press Enter to finish)"
    if ([string]::IsNullOrWhiteSpace($username)) {
        break
    }
    if (test-path -path C:\Users\$username) {
        continue
    } else {
        Write-Host "Username '$username' does not exist. Please enter a valid username."
        continue
    }
    if ($username -notin $usernamesToSave) {
        $usernamesToSave += $username
    } else {
        Write-Host "Username '$username' is already in the list. Please enter a different username."
    }
}

$uiArgs = ""
foreach ($user in $usernamesToSave) {
    $uiArgs += "/ui:$user "
}

if (test-path -path home:\usmt) {
    continue
} else {
    New-PSDrive -name "home" -PSProvider FileSystem -Root '\\fs04\homes$\WatsoJ340' | Out-null
}

Set-Location home:\usmt | Out-Null

$user1 = $usernamesToSave[0]

if (Test-Path -path \\fs04\homes$\watsoj340\$user1) {
    $choice = Read-Host -Prompt "The folder $user1 already exists. Do you want to overwrite it? (Y/N)"
    if ($choice -eq 'Y' -or $choice -eq 'y') {
        try {
            .\scanstate.exe \\fs04\homes$\watsoj340\$user1 /i:MigDocs.xml /i:MigUser.xml /ue:*\* $uiArgs /o /c
            return $true
        } catch {
            Write-Host "Error occurred while running scanstate.exe: $_" -ForegroundColor Red
            return $false
        }
    } else {
        Write-Host "Operation cancelled by user." -ForegroundColor Yellow
        return $false | Out-Null
    } 
} else {
    try {
        .\scanstate.exe \\fs04\homes$\watsoj340\$user1 /i:MigDocs.xml /i:MigUser.xml /ue:*\* $uiArgs /c
        return $true
    } catch {
        Write-Host "Error occurred while running scanstate.exe: $_" -ForegroundColor Red
        return $false
    }
}
