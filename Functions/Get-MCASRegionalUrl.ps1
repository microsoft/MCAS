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
            #$response = Invoke-MCASRestMethod -Credential $Credential -Path "/get_regional_url/" -Method Get -Raw
            #$h =  @{Authorization = "Token S05CS0pCQAFaXAFfQF1bTkMBTENAWktOX19cSkxaXUZbVgFMQEJTG0obHhdMFxseS00bTUwfSksaGB0fTR9KGUodThoWThgWSRxNFhoeSUsYThpLHBwaSxlMTBcYTU1KSx4cThlLSw=="}
            $response = Invoke-WebRequest -Uri 'https://portal.cloudappsecurity.com/get_regional_url/' -Token $CASCredential.GetNetworkCredential().SecurePassword
        }
        catch {
            throw "Error calling MCAS API. The exception was: $_"
        }

        $response
    }
}