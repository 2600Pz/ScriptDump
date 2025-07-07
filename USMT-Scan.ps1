Clear-Host

# Main Script
$usernamesToSave = @()
while ($true) {
    $username = Read-Host "Enter a username to save (or press Enter to finish)"
    if ([string]::IsNullOrWhiteSpace($username)) {
        if (!$usernamesToSave) {
            Write-Host "No usernames entered. Exiting script." -ForegroundColor Red
            exit
        } else {
            break
        }
    }
    $username = $username.Trim()
    if (!(test-path -path C:\Users\$username)) {
        Write-Host "Username '$username' does not exist as a local profile. Please enter a valid username." -ForegroundColor Yellow
        continue
    }
    if ($usernamesToSave -contains $username) {
        Write-Host "Username '$username' is already in the list. Please enter a different username" -ForegroundColor Yellow
        continue
    }
    $usernamesToSave += $username   
}


Clear-Host

$uiArgs = ""
foreach ($user in $usernamesToSave) {
    $uiArgs += "/ui:$user "
}

Write-Host -NoNewline "Username(s) selected for migration: " -ForegroundColor White

for ($i = 0; $i -lt $usernamesToSave.Count; $i++) {
    $username = $usernamesToSave[$i]
    Write-Host -NoNewline $username -ForegroundColor DarkCyan
    if ($i -lt $usernamesToSave.Count -1 ) {
        Write-Host -NoNewline ", " -ForegroundColor White
    } 
}
Write-Host ""
$width = (Get-Host).UI.RawUI.WindowSize.Width
    if ($width -eq 0) { $width = (Get-Host).UI.RawUI.BufferSize.Width}
Write-Host ("-" * $width) -ForegroundColor DarkGray

Write-Host "Continue?" -ForegroundColor Yellow
$choice = Read-Host "[Y] Yes [N] No (Default is 'Y')"
if (!($choice -eq 'Y' -or $choice -eq 'y' -or [string]::IsNullOrWhiteSpace($choice))) {
    Write-Host "Script canceled by user" -ForegroundColor Yellow
    exit
}

if (!(test-path -path home:\usmt)) {
    Write-Host "Creating new PSDrive with the name 'home'..."
    try {
        New-PSDrive -name "home" -PSProvider FileSystem -Root '\\fs04\homes$\WatsoJ340' -ErrorAction Stop | Out-null
        Write-Host "PSDrive created succesfully" -ForegroundColor Green
    } catch {
        Write-Host "Failed to create PSDrive: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Set-Location home:\usmt -ErrorAction stop | Out-Null

$firstUser = $usernamesToSave[0]
$destinationPath = "\\fs04\homes$\watsoj340\$firstUser"

Write-host "Migration store path: $destinationPath"

if (Test-Path -path \\fs04\homes$\watsoj340\$firstUser) {
    Write-Host -NoNewline "The migration store for "
    Write-Host -NoNewLine $firstUser -foregroundcolor DarkCyan
    Write-Host " already exists. Do you want to overwrite it?"
    $choice = Read-Host "[Y] Yes [N] No (Default: 'Y')"
    if ($choice -eq 'Y' -or $choice -eq 'y' -or [string]::IsNullOrWhiteSpace($choice)) {
        try {
            Invoke-Expression ".\scanstate.exe $destinationPath /i:MigDocs.xml /i:MigUser.xml /ue:*\* $uiArgs /o /c"

        } catch {
            Write-Host "Error occurred while running scanstate.exe: $_" -ForegroundColor Red
        }
    } else {
        Write-Host "Operation cancelled by user." -ForegroundColor Yellow
    } 
} else {
    try {
        Invoke-expression ".\scanstate.exe $destinationPath /i:MigDocs.xml /i:MigUser.xml /ue:*\* $uiArgs /c"
    } catch {
        Write-Host "Error occurred while running scanstate.exe: $_" -ForegroundColor Red
    }
}
