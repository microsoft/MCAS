<#
.Synopsis
    Get-MCASReport retrieves a list of built-in reports from the Cloud App Security tenant.
.DESCRIPTION
    Retrieves a reports list from the built-in reports of an MCAS tenant.
.EXAMPLE
    PS C:\> Get-MCASReport | select FriendlyName,report_category

    FriendlyName                           report_category
    ------------                           ---------------
    Privileged Users                       User Management
    Browser Use                            Security
    Outbound Sharing by Domain             Data Management
    Data Sharing Overview                  Data Management
    Salesforce Special Privileged Accounts User Management
    Owners of Shared Files                 Data Management
    Inactive Accounts

    This example retrives the reports list, showing the friendly name of the report and its category.

.EXAMPLE
    PS C:\> Get-MCASReport | Get-MCASReportContent

    This example retrives the reports list and pipes the list into the Get-MCASReportContent command to get the data for each one.
#>function Get-MCASReport {
    [CmdletBinding()]
    param
    (
        # Specifies the credential object containing tenant as username (e.g. 'contoso.us.portal.cloudappsecurity.com') and the 64-character hexadecimal Oauth token as the password.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential = $CASCredential
    )

    # Get the matching items and handle errors
    try {
        $response = Invoke-MCASRestMethod -Credential $Credential -Path "/cas/api/reports/" -Method Get
    }
    catch {
        throw "Error calling MCAS API. The exception was: $_"
    }

    $response = $response.data

    try {
        $response = $response | Add-Member -MemberType AliasProperty -Name Identity -Value _id -PassThru | ForEach-Object {Add-Member -InputObject $_ -MemberType NoteProperty -Name FriendlyName -Value $ReportsListReverse.Get_Item($_.non_entities_report) -PassThru}
    }
    catch {}
    
    $response
}