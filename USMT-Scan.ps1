$user1 = (read-host -prompt "Enter the username of the account to be saved")

$confirm2ndUser = (Read-host -prompt "Do you need to save a second user? (Y/N)")

$usernamesToSave = @($user1)

if ($confirm2ndUser -eq 'Y' -or $confirm2ndUser -eq 'y') {
    $user2 = (read-host -prompt "Enter the username of the second account to be saved")
    $usernamesToSave += $user2
}

$uiArgs = ""
foreach ($user in $usernamesToSave) {
    $uiArgs += "/ui:$user "
}

New-PSDrive -name "home" -PSProvider FileSystem -Root '\\fs04\homes$\WatsoJ340' | Out-null

Set-Location home:\usmt | Out-Null

.\scanstate.exe \\fs04\homes$\watsoj340\$user1 /i:MigDocs.xml /i:MigUser.xml /ue:*\* $uiArgs /c