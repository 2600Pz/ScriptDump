$user = (read-host -prompt "Enter the username of the account to be saved")

New-PSDrive -name "home" -PSProvider FileSystem -Root '\\fs04\homes$\WatsoJ340' | Out-null

Set-Location home:\usmt | Out-Null

.\scanstate.exe '\\fs04\homes$\watsoj340\'$user /i:MigDocs.xml /i:MigUser.xml /ue:*\* /ui:$user /c