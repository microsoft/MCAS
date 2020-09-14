function Get-MCASOAuthApp {
    <#
    .Synopsis
       Get-MCASOAuthApp
    .DESCRIPTION
       Get-MCASOAuthApp retrives OAuth Apps that were granted permission 
    .EXAMPLE
    
        Get-MCASOAuthApp
    
    .EXAMPLE

    $AllOAuthApps = Get-MCASOAuthApp
    $FirstPartyNames = 'Microsoft', 'Microsoft Office Demos'
    $NotFirstParty = $AllOAuthApps | 
    Where publisher -NotIn $FirstPartyNames | 
    Select appName, _id, publisher, userCount, userInstallationCount, @{l='firstInstalled';e={(ConvertFrom-MCASTimestamp $_.firstInstalled)}}
    $NotFirstParty | Export-Csv -path C:\Temp\NotFirstPartyApps.csv

    The first command returns all OAuth apps and assigns to the AllOAuthApps variable
    The second command creates an array of First party app names
    The third command  will assigns a listing of all users for applications where the publisher is not first party to the NotFirstParty variable
    The fourth commaned exports the stored variable to a CSV

    .PARAMETER Credential
        Specifies the credential object containing tenant as username (e.g.
        'contoso.us.portal.cloudappsecurity.com') and the 64-character hexadecimal Oauth token as the password.
    #>
    
    
    [CmdletBinding()]
    param
    (
        # Specifies the credential object containing tenant as username (e.g. 'contoso.us.portal.cloudappsecurity.com') and the 64-character hexadecimal Oauth token as the password.
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential = $CASCredential,

        # Specifies the maximum number of results to retrieve when listing items matching the specified filter criteria. Set to 100 by default.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateRange(1,100)]
        [ValidateNotNullOrEmpty()]
        [int]$ResultSetSize = 100,

        # Specifies the number of records, from the beginning of the result set, to skip. Set to 0 by default.
        [Parameter(ParameterSetName='List', Mandatory=$false)]
        [ValidateScript({$_ -gt -1})]
        [int]$Skip = 0,

        [int]$App = 11161,

        [switch]$All
    )

    Begin{}
    Process{
            #Build JSON Body for Post Method
            $body = '{"skip":<Skip>,"limit":<Limit>,"filters":{"app":{"eq":<App>}},"sortField":"userCount","sortDirection":"desc","performAsyncTotal":true}' -replace "<Skip>",$skip
            $body = $body -replace "<Limit>",$ResultSetSize
            $body = $body -replace "<App>",$App
            $body = $body | ConvertFrom-Json

                    try {
                        $response = Invoke-MCASRestMethod -Credential $Credential -Path "/cas/api/v1/app_permissions/" -Body $body -Method Post
                        $response.data
                        if (($PSBoundParameters.ContainsKey('All')) -and ($response.hasNext -eq $true)){
                            $Skip = $Skip + 100
                            $body.skip = $Skip
                            while ($response.hasNext -eq $true) {
                                Write-Verbose "Has next value:$($response.hasNext)"
                                $response = Invoke-MCASRestMethod -Credential $Credential -Path "/cas/api/v1/app_permissions/" -Body $body -Method Post
                                Write-Verbose "Has next value:$($response.hasNext)"
                                $response.data
                                $Skip = $Skip + 100
                                $body.skip = $Skip
                            }
                        }
                    }
                    catch { throw "Error calling MCAS API. The exception was: $_" }
    }
    End{}
}