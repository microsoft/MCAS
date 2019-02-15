function Import-MCASDynamicData {
    [CmdletBinding()]
    param
    (
        # Specifies the CAS credential object containing the 64-character hexadecimal OAuth token used for authentication and authorization to the CAS tenant.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential = $CASCredential
    )
    $Global:IPTagsList = @{}
    Get-MCASTag | ForEach-Object {
        try {
            $IPTagsList.Add(($_.Name.Replace(' ','_')),$_.id)
        }
        catch {}        
    }
}