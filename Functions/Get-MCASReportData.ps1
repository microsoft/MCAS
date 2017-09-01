<#
.Synopsis
    Get-MCASReportData retrieves built-in reports from Cloud App Security.
.DESCRIPTION
    Retrieves report data from the built-in reports.
.EXAMPLE
    Get-MCASReportData -ReportName 'Browser Use' | select @{N='Browser';E={$_.unique_identifier}}, @{N='User Count';E={$_.record_data.users.count}} | sort -Property 'User Count' -Descending

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
function Get-MCASReportData
{
    [CmdletBinding()]
    [Alias('Get-CASReportData')]
    Param
    (
        # Fetches a report by its unique name identifier.
        [Parameter(Mandatory=$true,ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Activity by Location','Browser Use','IP Addresses','IP Addresses for Admins','OS Use','Strictly Remote Users','Cloud App Overview','Inactive Accounts','Privileged Users','Salesforce Special Privileged Accounts','User Logon','Data Sharing Overview','File Extensions','Orphan Files','Outbound Sharing by Domain','Owners of Shared Files','Personal User Accounts','Sensitive File Names')]
        [Alias("FriendlyName")]
        [string]$ReportName,
                
        # Specifies the URL of your CAS tenant, for example 'contoso.portal.cloudappsecurity.com'.
        [Parameter(Mandatory=$false)]
        [ValidateScript({($_.EndsWith('.portal.cloudappsecurity.com') -or $_.EndsWith('.adallom.com'))})]
        [string]$TenantUri,

        # Specifies the CAS credential object containing the 64-character hexadecimal OAuth token used for authentication and authorization to the CAS tenant.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential
    )
    Begin
    {
        Try {$TenantUri = Select-MCASTenantUri}
            Catch {Throw $_}

        Try {$Token = Select-MCASToken}
            Catch {Throw $_}
    }
    Process
    {
        $Target = $ReportsList.$ReportName

        # Get the matching items and handle errors
        Try {
            Write-Verbose "Retrieving report $Target"
            $Response = Invoke-MCASRestMethod2 -Uri "https://$TenantUri/api/reports/$Target/" -Token $Token -Method Get
            
        }
        Catch {
            Throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
        }

        $Response = ($Response.content | ConvertFrom-Json).data
       
        $Response
    }
    End
    {
    }
}
