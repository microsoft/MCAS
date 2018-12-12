<#
.Synopsis
    Get-MCASReportContent retrieves built-in reports from Cloud App Security.
.DESCRIPTION
    Retrieves report data from the built-in reports.
.EXAMPLE
    PS C:\> Get-MCASReportContent -ReportName 'Browser Use' | select @{N='Browser';E={$_.unique_identifier}}, @{N='User Count';E={$_.record_data.users.count}} | sort -Property 'User Count' -Descending

    Browser                               User Count
    -------                               ----------
    chrome_53.0.2785.143                           4
    chrome_54.0.2840.71                            4
    unknown_                                       4
    microsoft bits_7.8                             3
    microsoft exchange_                            3
    microsoft exchange rpc_                        2
    edge_14.14393                                  2
    ie_11.0                                        2
    microsoft onenote_16.0.7369.5783               1
    apache-httpclient_4.3.5                        1
    ie_9                                           1
    skype for business_16.0.7369.2038              1
    mobile safari_10.0                             1
    microsoft web application companion_           1
    chrome_54.0.2840.87                            1
    microsoft excel_1.26.1007                      1
    microsoft skydrivesync_17.3.6517.0809          1

    This example retrives the Browser Use report, shows the browser name and user count columns, and sorts by user count descending.
#>
function Get-MCASReportContent {
    [CmdletBinding()]
    param
    (
        # Fetches a report by its unique name identifier.
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Browser Use','Privileged Users','Salesforce Special Privileged Accounts','Data Sharing Overview','Outbound Sharing by Domain')]
        [Alias("FriendlyName")]
        [string]$ReportName,
                
        # Specifies the credential object containing tenant as username (e.g. 'contoso.us.portal.cloudappsecurity.com') and the 64-character hexadecimal Oauth token as the password.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential = $CASCredential
    )
    process
    {
        $target = $ReportsList.$ReportName

        # Get the matching items and handle errors
        try {
            Write-Verbose "Retrieving report $target"
            $response = Invoke-MCASRestMethod -Credential $Credential -Path "/cas/api/reports/$target/" -Method Get
        }
        catch {
            throw "Error calling MCAS API. The exception was: $_"
        }

        $response = $response.data
       
        $response
    }
}