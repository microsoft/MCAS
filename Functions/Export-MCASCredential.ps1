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
        $test = $CASCredential
    )
    process {

        #$Key = (3,4,2,3,56,34,254,222,1,1,2,23,42,54,33,233,1,34,2,7,6,5,35,43)       
        #$s  | ConvertFrom-SecureString -Key $Key 

        $uri = $test.UserName
        $p = ($test.GetNetworkCredential().Password)

        Write-Verbose "Tenant URI is $uri"
        Write-Verbose "Token is $p"
        
        #[string]$uri = $CASCredential.UserName
        #[string]$p = $CASCredential.GetNetworkCredential().Password
        
        $nonWindowsCredential = New-Object -TypeName psobject -Property @{
            UserName = $uri
            Password = $p
            
            #GetNetworkCredential().username
            #GetNetworkCredential().Passsword
        }

        #Add-Member ScriptMethod ToString { $this.Name }

        Write-Verbose ($nonWindowsCredential.Password)

        Write-Verbose "Export path is $Path"
        Export-Clixml -InputObject $nonWindowsCredential -Path $Path
        <#
        try {
            Export-Clixml -Path $Path -InputObject $nonWindowsCredential
        }
        catch {
            throw "The following error occurred when trying to export the credential object: $_"
        }
        #>
    }
}
