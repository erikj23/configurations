
Function Get-PseAwsSubnets {
    $Orgs = Get-PseAwsOrgAccounts    
    foreach ($AwsAccount in $Orgs) {
        $StsRole = Set-PseAWSCredential -RoleArn "arn:aws:iam::$($AwsAccount.Id):role/AUTH-ReadOnly"
        if ($StsRole) {            
            $AwsSubnets = Get-EC2Subnet -Credential $StsRole
            foreach ($AwsSubnet in $AwsSubnets) {
                $AwsVpc = Get-EC2Vpc -VpcID $AwsSubnet.VpcId -Credential $StsRole
                $Subnet = $AwsSubnet.CidrBlock | Get-Subnet                
                [PSCustomObject]@{
                    AwsAccount       = $AwsAccount.Name
                    AwsAccountId     = $AwsAccount.Id
                    AvailabilityZone = $AwsSubnet.AvailabilityZone
                    ADDomain         = $AwsVpc.Tags[0].Value # may have more than one domain
                    VpcId            = $AwsSubnet.VpcId
                    CidrBlock        = $AwsSubnet.CidrBlock
                    Range            = $Subnet.Range
                    SubnetMask       = $Subnet.SubnetMask
                }   
            }
        }
    }
}

Get-PseSubnets