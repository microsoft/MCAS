<#
.Synopsis
   Exports an MCAS credential (usually from the $CASCredential session variable) to a local file

.DESCRIPTION
   Exports an MCAS credential (usually from the $CASCredential session variable) to a local file

.EXAMPLE
    PS C:\> Export-MCASCredential

.FUNCTIONALITY
   Export-MCASCredential returns nothing.
    Exports an MCAS credential object (usually from the $CASCredential variable) to a file on non-Windows machines running Powershell (Core)
.DESCRIPTION
    <ADD DESCRIPTION HERE>
.EXAMPLE
    PS C:\> Export-MCASCredential

#>
function Export-MCASCredential {
    [CmdletBinding()]
    param
    (
        # Specifies the app for which to retrieve the integer id value.
        [Parameter(Mandatory=$true, ValueFromPipeline=$false, Position=0)]
        [ValidateNotNullOrEmpty()]
        $Path,
        
        # Specifies the app for which to retrieve the integer id value.
        [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$MCASCredential = $CASCredential
    )
    process {
        $uri = $MCASCredential.UserName
        $p = ($MCASCredential.GetNetworkCredential().Password)

        Write-Verbose "Tenant URI is $uri"
        Write-Verbose "Token is $p"
        
        
        $nonWindowsCredential = New-Object -TypeName psobject -Property @{
            UserName = $uri
            Password = $p
            
            #GetNetworkCredential().username
            #GetNetworkCredential().Passsword
        }
        

        <#
        $nonWindowsCredential = [MCASCredential]@{
            username = $MCASCredential.UserName
            Password = ($MCASCredential.GetNetworkCredential().Password)
        }
        #>
       
        Write-Verbose "Export path is $Path"

        try {
            Export-Clixml -InputObject $nonWindowsCredential -Path $Path
        }
        catch {
            throw "The following error occurred when trying to export the credential object: $_"
        }
    }
}