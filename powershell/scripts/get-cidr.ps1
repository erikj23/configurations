
#cidr request
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#
$ie = New-Object -com internetexplorer.application;
$ie.Visible = $true
$ie.navigate("https://cidr.xyz/")