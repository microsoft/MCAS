function Remove-MCASSubnetAlpha
{
    [CmdletBinding()]
    [Alias('Remove-MCASSubnetAlpha')]
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

        [Parameter(ParameterSetName='ById',Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Identity,

        [Parameter(ParameterSetName='ByName',Mandatory=$true,ValueFromPipeline=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory=$false)]
        [Switch]$Quiet
    )
    Begin {
        Try {$TenantUri = Select-MCASTenantUri}
            Catch {Throw $_}

        Try {$Token = Select-MCASToken}
            Catch {Throw $_}
    }
    Process {
        If ($PSCmdlet.ParameterSetName -eq 'ByName') {
            Write-Verbose "Parameter set 'ByName' detected"
            Get-MCASSubnet -TenantUri $TenantUri | ForEach-Object {
                If ($_.Name -eq $Name) {
                    $SubnetId = $_.Identity
                    $NameOrIdTargeted = $Name
                }
            }
        }
        ElseIf ($PSCmdlet.ParameterSetName -eq 'ById') {
            Write-Verbose "Parameter set 'ById' detected"
            $SubnetId = $Identity
            $NameOrIdTargeted = $SubnetId
        }
        Else {
            Write-Verbose "Parameter set not detected"
            Write-Error "Could not determine identity of subnet to be deleted"
        }

        Try {
            $Response = Invoke-MCASRestMethod2 -Uri "https://$TenantUri/api/v1/subnet/$SubnetId/" -Token $Token -Method Delete 
        }
            Catch {
                Throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
            }
        
        Write-Verbose "Checking response for success" 
        If ($Response.StatusCode -eq '200') {
            $Success = $true
            Write-Verbose "Successfully deleted subnet $Name" 
        }
        Else {
            $Success = $false
            Write-Verbose "Something went wrong attempting to delete subnet $Name" 
            Write-Error "Something went wrong attempting to delete subnet $Name"
        }

        If (!$Quiet) {
            $Success
        }      
    }
    End {
    }
}
