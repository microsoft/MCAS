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
        $exportCred = New-Object -TypeName psobject -Property @{
            UserName = ($MCASCredential.UserName)
            Password = ($MCASCredential.GetNetworkCredential().Password)
        }
        
        Write-Verbose "Export path is $Path"

        try {
            Export-Clixml -InputObject $exportCred -Path $Path
        }
        catch {
            throw "The following error occurred when trying to export the credential object: $_"
        }
    }
}