function Connect-MCASService {
    [CmdletBinding()]
    param
    (
        # Specifies the CAS credential object containing the 64-character hexadecimal OAuth token used for authentication and authorization to the CAS tenant.
        #[Parameter(Mandatory=$false)]
        #[ValidateNotNullOrEmpty()]
        #[System.Management.Automation.PSCredential]$Credential = $CASCredential
    )

    return
}