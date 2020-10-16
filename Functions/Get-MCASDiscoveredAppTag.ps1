<#
.Synopsis
    Gets a list of tags based on application ID.
.DESCRIPTION
    This function retrives a count of tags applied to a discovered app.
.EXAMPLE
    PS C:\> Get-MCASDiscoveredAppTag -appId $appId

    id           count Identity
    --           ----- --------
    Sanctioned       0
    Unsanctioned     1
    None             0

    Retrieves a count of the application tags applied the specified discovered app.

.EXAMPLE
    PS C:\> Get-MCASDiscoveredApp -StreamId $streamid -Category SECURITY | select name,@{N='Total (MB)';E={"{0:N2}" -f ($_.trafficTotalBytes/1MB)}}

    id           count Identity
    --           ----- --------
    Sanctioned       2
    Unsanctioned     1
    None             0

    In this example, our $appId variable contains multiple comma seperated ID's.

#>
function Get-MCASDiscoveredAppTag {
   [CmdletBinding()]
   param (
       # Specifies the credential object containing tenant as username (e.g. 'contoso.us.portal.cloudappsecurity.com') and the 64-character hexadecimal Oauth token as the password.
       [Parameter(Mandatory=$false)]
       [ValidateNotNullOrEmpty()]
       [System.Management.Automation.PSCredential]$Credential = $CASCredential,

       # Limits the results by app ID, for example '11114'. The app ID can be found in the URL bar of the console when looking at a Discovered App.
       [Parameter(ParameterSetName='List', Mandatory=$false, Position=0)]
       [ValidatePattern("[0-9][0-9][0-9][0-9][0-9]")]
       [ValidateNotNullOrEmpty()]
       [int[]]$appId
   )

      # Construct a default body
      $body = @{skip = 0}

      # Construct a filter set from parameters
      $filterSet = @()      

      if ($appId){ 
         $filterSet += @{'appId' = @{} 
         }
         $filterName = "appId"
      }

      if ($appId) { 
         $filterSet.($filterName).add('eq', $appId ) 
      }
   
      # Request
      try {
         $response = Invoke-MCASRestMethod -Credential $Credential -Path "/cas/api/v1/discovery/discovered_apps/tags/" -Method Post -filterSet $filterSet -Body $body
      }
      catch {
         throw "Error calling MCAS API. The exception was: $_"
      }

      $response = $response.data

      try {
         Write-Verbose "Adding alias property to results, if appropriate"
         $response = $response | Add-Member -MemberType AliasProperty -Name Identity -Value 'appId' -PassThru
      }
      catch {}

      $response
   }

