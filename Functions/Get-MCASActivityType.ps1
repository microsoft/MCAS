<#
.Synopsis
   Lists the activity types that MCAS is aware of for a given application.
.DESCRIPTION
   Get-MCASActivityType lists the activity types that MCAS consumes for the specified app. MCAS activities can be filtered by these types allowing for granular policies to watch for very specific activity.

.EXAMPLE
    PS C:\> Get-MCASActivityType -AppId 20595

 category                                appId AppName
--------                                ----- -------
bind:Bind                               20595 Microsoft Cloud App Security
bind:Bind                               20595 Microsoft Cloud App Security
Consent:Grant                           20595 Microsoft Cloud App Security
Consent:Set                             20595 Microsoft Cloud App Security
...
...


.FUNCTIONALITY
   Get-MCASActivityType is intended to display the activity types that MCAS is aware of and can filter on. Activities that are unknown to MCAS will fall under the 'Unspecified' activity type.
#>
function Get-MCASActivityType {
    [CmdletBinding()]
    param
    (
        # Specifies the CAS credential object containing the 64-character hexadecimal OAuth token used for authentication and authorization to the CAS tenant.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential = $CASCredential,

        # Limits the results to items related to the specified service IDs, such as 11161,11770 (for Office 365 and G Suite, respectively).
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^\d{5}$')]
        [Alias("Service","Services")]
        [int]$AppId
    )
    process {

        # Get the matching alerts and handle errors
        try {
            $response = Invoke-MCASRestMethod -Credential $Credential -Path "/cas/api/v1/autocomplete/activity-types/?search=&service=eq(i%3A$AppId%2C)" -Method Get
            $response = $response.records.items | Select-Object category, appid, @{N='AppName';E={$_.Service_Name}} |Where-Object appId -eq $AppId | Sort-Object -Property category
            $response
        }
        catch {
            throw "Error calling MCAS API. The exception was: $_"
        }
    }
}