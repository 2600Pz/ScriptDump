$user = (Read-host -Prompt "Enter the username to load")

New-PSDrive -name "home" -PSProvider FileSystem -Root "\\fs04\homes$\watsoj340" | Out-Null

Set-Location home:\usmt | Out-Null

.\loadstate.exe '\\fs04\homes$\watsoj340\'$user /i:MigDocs.xml /i:MigUser.xml /c