function Get-MCASRegionalUrl{
    [CmdletBinding()]
    param
    (
        # Specifies the CAS credential object containing the 64-character hexadecimal OAuth token used for authentication and authorization to the CAS tenant.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential = $CASCredential
    )
    process {

        # Get the matching alerts and handle errors
        try {
            $response = Invoke-MCASRestMethod -Credential $Credential -Path "/get_regional_url/" -Method Get        
        }
        catch {
            throw "Error calling MCAS API. The exception was: $_"
        }

        $response
    }
}