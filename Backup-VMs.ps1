$username = Get-Content -Path .\username.txt
& "J:\Scripts\Hyper-V-Backup\Hyper-V-Backup.ps1" `
  -BackupTo J:\Hyper-V-Backups `
  -List .\vms.txt `
  -Keep 3 `
  -Compress `
  -L .\logs `
  -SendTo "lsilverman@trackabout.com" `
  -From "hyperv@trackabout.com" `
  -Smtp "smtp.postmarkapp.com" `
  -SmtpPort 587 `
  -User $username `
  -Pwd .\pwd.txt `
  -UseSsl `
  -NoPerms `
  -Verbose

$limit = (Get-Date).AddDays(-15)
$path = "J:\Scripts\Hyper-V-Backup\logs"

# Delete files older than the $limit.
Get-ChildItem -Path $path -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $limit } | Remove-Item -Force

# Delete any empty directories left behind after deleting the old files.
Get-ChildItem -Path $path -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse