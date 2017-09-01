function Get-MCASReport
{
    [CmdletBinding()]
    [Alias('Get-CASReport')]
    Param
    (
        # Specifies the URL of your CAS tenant, for example 'contoso.portal.cloudappsecurity.com'.
        [Parameter(Mandatory=$false)]
        [ValidateScript({($_.EndsWith('.portal.cloudappsecurity.com') -or $_.EndsWith('.adallom.com'))})]
        [string]$TenantUri,

        # Specifies the CAS credential object containing the 64-character hexadecimal OAuth token used for authentication and authorization to the CAS tenant.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential
    )

    Try {$TenantUri = Select-MCASTenantUri}
        Catch {Throw $_}

    Try {$Token = Select-MCASToken}
        Catch {Throw $_}

    # Get the matching items and handle errors
    Try {
        $Response = Invoke-MCASRestMethod2 -Uri "https://$TenantUri/api/reports/" -Method Post -Token $Token
    }
        Catch {
            Throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
        }

    $Response = ($Response | ConvertFrom-Json).data
    
    $Response = $Response | ForEach-Object {Add-Member -InputObject $_ -MemberType NoteProperty -Name FriendlyName -Value $ReportsListReverse.Get_Item($_.report_name) -PassThru}

    $Response    
}