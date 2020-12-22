
Import-Module -DisableNameChecking PSE.ESS.AWS
Function ConvertTo-EC2Filter {
  [CmdletBinding()]
  Param(
    [Parameter(
      ValueFromPipeline,
      ValueFromPipelineByPropertyName)]
    [HashTable]
    $Filter
  )
  Begin {
    $ec2Filter = @()
  }
  Process {

    $ec2Filter = Foreach ($key in $Filter.Keys) {
      @{
        name   = $key
        values = $Filter[$key]
      }
    }
  }
  End {
    $ec2Filter
  }
}

Function Test {
  param(
    [Parameter(Position = 0)]
    [string]$Optional,
    [Parameter(Position = 1, Mandatory = $true)]
    [string]$Required
  )
  Process {
    Write-Host $Required
    if ($PSBoundParameters.ContainsKey('Optional')) {
      Write-Host $Optional -ForegroundColor Cyan
    }
  }
}


Test { }
#Find-PseAwsEC2ResourceByTag -TagKey "Name" -TagValue "*AWOWPRCDV07V01*"