function Get-MCASSubnet
{
    [CmdletBinding()]
    [Alias('Get-CASSubnet')]
    Param
    (
        # Specifies the URL of your CAS tenant, for example 'contoso.portal.cloudappsecurity.com'.
        [Parameter(Mandatory=$false)]
        [ValidateScript({($_.EndsWith('.portal.cloudappsecurity.com') -or $_.EndsWith('.adallom.com'))})]
        [string]$TenantUri,

        # Specifies the CAS credential object containing the 64-character hexadecimal OAuth token used for authentication and authorization to the CAS tenant.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential,

        # Specifies the maximum number of results to retrieve when listing items matching the specified filter criteria.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateRange(1,100)]
        [int]$ResultSetSize = 100,

        # Specifies the number of records, from the beginning of the result set, to skip.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateScript({$_ -gt -1})]
        [int]$Skip = 0
        
    )
    
    Try {$TenantUri = Select-MCASTenantUri}
        Catch {Throw $_}

    Try {$Token = Select-MCASToken}
        Catch {Throw $_}

    $Body = @{'skip'=$Skip;'limit'=$ResultSetSize} # Base request body

    Try {
        $Response = Invoke-MCASRestMethod2 -Uri "https://$TenantUri/cas/api/v1/subnet/" -Token $Token -Method Post -Body $Body
    }
        Catch {
            Throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
        }

    # Get the response parts and format we need
    $Response = $Response.content 
    
    $Response = $Response | ConvertFrom-Json
    
    $Response = Invoke-MCASResponseHandling -Response $Response
    
    $Response
}
