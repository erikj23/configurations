
# copy if absent
If (-not (test-path $profile)) { 
 cp ~\git\configurations\powershell\Microsoft.PowerShell_profile.ps1 ~\documents\windowspowershell\
 new-item -path ~\documents\windowspowershell\private -type directory
}

# add default scripts to env:path
$env:path += ";~\git\configurations\powershell\scripts"
$env:path += ";~\documents\windowspowershell\scripts"

# create data variables
#$erik = new-object -typename System.Object


# local changes
