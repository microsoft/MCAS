<#
.Synopsis
    Get-MCASSiemAgent retrieves a list of available discovery streams.
.DESCRIPTION
    Discovery streams are used to separate or aggregate discovery data. Stream ID's are needed when pulling discovered app data.
.EXAMPLE
    PS C:\> (Get-MCASSiemAgent | ?{$_.displayName -eq 'Global View'})._id

    57869acdb4b3d5154f095af7

    This example retrives the global stream ID.
#>
function Get-MCASSiemAgent {
    [CmdletBinding()]
    param
    (
        # Specifies the credential object containing tenant as username (e.g. 'contoso.us.portal.cloudappsecurity.com') and the 64-character hexadecimal Oauth token as the password.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential = $CASCredential
    )
    
    try {
        $response = Invoke-MCASRestMethod -Credential $Credential -Path "/api/v1/agents/siem/" -Method Get
    }
    catch {
        throw "Error calling MCAS API. The exception was: $_"
    }

    $response = $response.data
    
    try {
        Write-Verbose "Adding alias property to results, if appropriate"
        $response = $response | Add-Member -MemberType AliasProperty -Name Identity -Value '_id' -PassThru
    }
    catch {}
        
    $response
}