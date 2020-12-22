function Get-PseAwsEC2ResourceTypes {  
  Begin {
    $Orgs = Get-PseAwsOrgAccounts
    $UniqueResourceTypes = New-Object System.Collections.Generic.HashSet[string]
    
  }
  Process {      
    ForEach ($AwsAccount in $Orgs) {
      $StsRole = Set-PseAwsCredential -RoleArn "arn:aws:iam::$($AwsAccount.Id):role/AUTH-ReadOnly"
      if ($StsRole) {
        $AwsEC2Tags = Get-EC2Tag -Credential $StsRole
        ForEach ($AwsEC2Tag in $AwsEC2Tags) {
          # captures return value to prevent output
          if ($UniqueResourceTypes.Add($AwsEC2Tag.ResourceType.Value)) { }
        }
      }
    }
    Write-Output -InputObject $UniqueResourceTypes
  }
}

Get-PseAwsEC2ResourceTypes