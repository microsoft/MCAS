<#
.Synopsis
<<<<<<< refs/remotes/origin/PSCore-nonWindows-CASCredential-handling
   Exports an MCAS credential (usually from the $CASCredential session variable) to a local file

.DESCRIPTION
   Exports an MCAS credential (usually from the $CASCredential session variable) to a local file

.EXAMPLE
    PS C:\> Export-MCASCredential

.FUNCTIONALITY
   Export-MCASCredential returns nothing.
=======
    Exports an MCAS credential object (usually from the $CASCredential variable) to a file on non-Windows machines running Powershell (Core)
.DESCRIPTION
    <ADD DESCRIPTION HERE>
.EXAMPLE
    PS C:\> Export-MCASCredential

>>>>>>> new file and related exports
#>
function Export-MCASCredential {
    [CmdletBinding()]
    param
    (
<<<<<<< refs/remotes/origin/PSCore-nonWindows-CASCredential-handling
        # Specifies the app for which to retrieve the integer id value.
        [Parameter(Mandatory=$true, ValueFromPipeline=$false, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,
        
        # Specifies the app for which to retrieve the integer id value.
        [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [SecureString] $Credential = $CASCredential
    )
    {
        #change for commit

        #$username = 'jpdemo18.portal.cloudappsecurity.com'
        #$password = 'RV9LSkJAHhcBWlwdAV9AXVtOQwFMQ0BaS05fX1xKTFpdRltWAUxAQlNMGkkWFhYbGhscGkkbG0lLHksaHRoaSkkeHRxOShocGU0WGBpLSUtNG05LTR4XHRkdHxYaFhYaS01LH00eHUoc'
        #$credential = New-Object System.Management.Automation.PSCredential($username,$password)

        #$Key = (3,4,2,3,56,34,254,222,1,1,2,23,42,54,33,233,1,34,2,7,6,5,35,43)       
        #$s  | ConvertFrom-SecureString -Key $Key 

        $nonWindowsCredential = New-Object -TypeName psobject -Property @{
            UserName = $Credential.UserName
            Password = $Credential.GetNetworkCredential().Password
        }
        
        try {
            Export-Clixml -Path $Path -InputObject $nonWindowsCredential
        }
        catch {
            throw "The following error occurred when trying to export the credential object: $_"
        }
    }
=======
    )

>>>>>>> new file and related exports
}