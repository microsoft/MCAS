function Get-MCASIPTag{
    [CmdletBinding()]
    param
    (
        # Specifies the CAS credential object containing the 64-character hexadecimal OAuth token used for authentication and authorization to the CAS tenant.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential = $CASCredential,

        # Specifies the maximum number of results to retrieve when listing items matching the specified filter criteria.
        [Parameter(Mandatory=$false)]
        [ValidateRange(1,100)]
        [int]$ResultSetSize = 100,

        # Specifies the number of records, from the beginning of the result set, to skip.
        [Parameter(Mandatory=$false)]
        [ValidateScript({$_ -ge 0})]
        [int]$Skip = 0
    )
    process {

        # Get the matching alerts and handle errors
        try {
            $response = Invoke-MCASRestMethod -Credential $Credential -Path "/cas/api/tags/?enabledOnly=true&sort=name&sortDirectory=asc&target=ip" -Method Get # IP tag          
        }
        catch {
            throw "Error calling MCAS API. The exception was: $_"
        }

        Write-Verbose "Getting just the response property named 'data'"
        $response = $response.data

        try {
            Write-Verbose "Adding alias property to results, if appropriate"
            $response = $response | Add-Member -MemberType AliasProperty -Name Identity -Value '_id' -PassThru
        }
        catch {}

        $response
    }
}