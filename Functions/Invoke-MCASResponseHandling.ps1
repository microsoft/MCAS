function Invoke-MCASResponseHandling
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true, Position=0)]
        $Response,

        [Parameter(Mandatory=$false, Position=1)]
        [string]$IdentityProperty='_id'
    )
    
    # For responses with zero results, set an empty collection as response rather than returning the response metadata
    If ($Response.total -eq 0) {
        $Response = @()
        Write-Verbose "Invoke-MCASResponseHandling: Response had zero results, returning an empty collection"
    }
    # For non-empty responses, get the data property only
    Else {
        $Response = $Response.data
        Write-Verbose "Invoke-MCASResponseHandling: Response had non-zero results, returning the data property of the response"
        
        # Add the .Identity property alias
        If (($null -ne $IdentityProperty) -and ($Response | Get-Member).name -contains $IdentityProperty) {
            $Response = $Response | Add-Member -MemberType AliasProperty -Name Identity -Value $IdentityProperty -PassThru
            Write-Verbose "Invoke-MCASResponseHandling: Added the 'Identity' property as an alias of the $IdentityProperty property"
        }
    }

    $Response
}
