<#
.Synopsis
   Returns an application's id (integer) given its name.
.DESCRIPTION
   Get-MCASAppId gets the unique identifier integer value that represents an app in MCAS.

.EXAMPLE
    PS C:\> Get-MCASAppId -AppName Microsoft_Cloud_App_Security
    20595

.FUNCTIONALITY
   Get-MCASAppId is intended to return the id of an app when the app name is provided as input.
#>
function Get-MCASAppId {
    [CmdletBinding()]
    param
    (
        # Specifies the app for which to retrieve the integer id value.
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [mcas_app]$AppName
    )
    process
    {
        $AppName -as [int]
    }
}