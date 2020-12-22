
using module PSE.ESS.AWS

Function Get-PseAwsEC2NonCompliantResourceTags {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string[]]$EC2ResourceTypes = @("instance"),
        # Includes optional tags maintained by server owners [projectname, applicationid, applicationname]
        [switch]$IncludeOptionalTags
    )
    Process {
        $Orgs = Get-PseAwsOrgAccounts
        ForEach ($AwsAccount in $Orgs) {
            $StsRole = Set-PseAwsCredential -RoleArn "arn:aws:iam::$($AwsAccount.Id):role/AUTH-ReadOnly"
            if ($StsRole) {
                ForEach ($EC2ResourceType in $EC2ResourceTypes) {
                    # to obtain property list of PseAwsResourceTag once
                    $NonCompliantResourceTags = [PseAwsResourceTag]::new()
                    $PropertyNames = ($NonCompliantResourceTags | Get-Member -MemberType Property).Name
                    switch -Exact ($EC2ResourceType) {
                        "instance" {
                            $EC2Instances = Get-EC2Instance -Credential $StsRole
                            ForEach ($EC2Instance in $EC2Instances) {
                                ForEach ($Instance in $EC2Instance.Instances) {
                                    $Tags = @{ }
                                    $Instance.Tags | ForEach-Object { $Tags.Add($_.Key, $_.Value) }
                                    if (-not ($Tags.Name -and $Tags.costcenter -and $Tags.workorder -and $Tags.appgroup -and $Tags.owner1 -and $Tags.owner2 -and $Tags.maintenance -and $Tags.createdby -and $Tags.whencreated -and $Tags.schedule)) {
                                        $NonCompliantResource = [PseAwsResourceTag]::new()
                                        $PropertyNames | ForEach-Object { $NonCompliantResource.$_ = $Tags.$_ }
                                        $NonCompliantResource | Add-Member NoteProperty -Name AccountName -Value $AwsAccount.Name
                                        $NonCompliantResource | Add-Member NoteProperty -Name AccountId -Value $AwsAccount.Id
                                        $NonCompliantResource | Add-Member NoteProperty -Name InstanceId -Value $Instance.InstanceId
                                        $NonCompliantResource | Write-Output
                                    }
                                }
                            }
                        }
                        
                        default { Write-Warning "EC2ResourceType[$($EC2ResourceType)] not supported" }
                    }
                }
                #$AwsEC2Tags = Get-EC2Tag -Credential $StsRole
                #ForEach ($AwsEC2Tag in $AwsEC2Tags) {
                #$Tags = @()
                # # ? if logic that determines if in table or array
                #$AwsEC2Tag | ForEach-Object { $Tags.Add($_.Key, $_.Value) }
                # only create object if it is missing one of them, pipe through

                #}
            }
            else { Write-Warning "STS failed" }
        }
    }
}

Get-PseAwsEC2NonCompliantResourceTags | Export-Csv -Path "~\Documents\Work\Excel\noncomp.csv" -NoTypeInformation
