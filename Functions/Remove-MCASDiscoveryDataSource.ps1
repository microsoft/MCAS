function Remove-MCASDiscoveryDataSource {
    [CmdletBinding()]
    param
    (
        # Specifies the credential object containing tenant as username (e.g. 'contoso.us.portal.cloudappsecurity.com') and the 64-character hexadecimal Oauth token as the password.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential = $CASCredential,

        # Specifies the name of the data source object to create
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,Position=0)]
        [alias("_id")]
        [string]$Identity
    )
    begin {
        Write-Verbose "Checking current data sources"
        $currentDataSources = Get-MCASDiscoveryDataSource -Credential $Credential
    }
    process {
        if ($currentDataSources.Identity.Contains($Identity)) {
            if (($currentDataSources | Where-Object {$_.Identity -eq $Identity}).receiverType -ne 'builtin') {
                try {
                    $response = Invoke-MCASRestMethod -Credential $Credential -Path "/api/v1/discovery/data_sources/$Identity/" -Method Delete
                }
                catch {
                    throw "Error calling MCAS API. The exception was: $_"
                }
            }
            else {
                Write-Warning "The data source with id $Identity is built-in and cannot be removed. It will be skipped."    
            }
        }
        else {
            Write-Warning "There is no data source with the id of $Identity. No changes were made."
        }   
    }
    end {
    }
}