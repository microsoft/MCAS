function Get-MCASActivityTypes
{
    [CmdletBinding()]
    [Alias('Get-CASActivityTypes')]
    Param
    (
        # Specifies the URL of your CAS tenant, for example 'contoso.portal.cloudappsecurity.com'.
        [Parameter(Mandatory=$false)]
        [ValidateScript({(($_.StartsWith('https://') -eq $false) -and ($_.EndsWith('.adallom.com') -or $_.EndsWith('.cloudappsecurity.com')))})]
        [string]$TenantUri,

        # Specifies the CAS credential object containing the 64-character hexadecimal OAuth token used for authentication and authorization to the CAS tenant.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential,

        # Limits the results to items related to the specified service IDs, such as 11161,11770 (for Office 365 and Google Apps, respectively).
        [Parameter(ParameterSetName='List', Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern('^\d{5}$')]
        [Alias("Service","Services")]
        [int]$AppId
    )
    Begin {
        Try {$TenantUri = Select-MCASTenantUri}
            Catch {Throw $_}

        Try {$Token = Select-MCASToken}
            Catch {Throw $_}
    }
    Process {
        # Get the matching alerts and handle errors
        Try {
            $Response = Invoke-MCASRestMethod2 -Uri "https://$TenantUri/cas/api/audits/type/?servicesFilter=eq(i%3A$AppId%2C)&max=500&search=" -Token $Token -Method Get
        }
        Catch {
            Throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
        }

        # Get the response parts and format we need
        $Response = $Response.content
        
        $Response = $Response | ConvertFrom-Json
                
        $Response = $Response.data 

        $Response = $Response | Add-Member -NotePropertyName 'app' -NotePropertyValue ($AppId -as [mcas_app]) -PassThru
        
        $Response = $Response | select name,app,types,id

        $Response
    }
    End {
    }
}
