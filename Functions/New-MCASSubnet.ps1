function New-MCASSubnet
{
    [CmdletBinding()]
    [Alias('Add-CASSubnet')]
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

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=1)]
        [ValidateNotNullOrEmpty()]
        [subnet_category]$Category,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=2)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Subnets,

        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true,Position=3)]
        [ValidateNotNullOrEmpty()]
        [string]$Organization,

        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true,Position=4)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Tags,

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
        If ($Tags) {
            $Body = [ordered]@{'name'=$Name;'category'=($Category -as [int]);'organization'=$Organization;'subnets'=$Subnets;'tags'=$Tags}
        }
        Else {
            $Body = [ordered]@{'name'=$Name;'category'=($Category -as [int]);'organization'=$Organization;'subnets'=$Subnets}
        }

        Try {
            $Response = Invoke-MCASRestMethod2 -Uri "https://$TenantUri/cas/api/v1/subnet/create_rule/" -Token $Token -Method Post -Body $Body
        }
            Catch {
                Throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
            }
        
        Write-Verbose "Checking response for success" 
        If ($Response.StatusCode -eq '200') {
            Write-Verbose "Successfully deleted subnet $NameOrIdTargeted" 
        }
        Else {
            Write-Verbose "Something went wrong attempting to delete subnet $NameOrIdTargeted" 
            Write-Error "Something went wrong attempting to delete subnet $NameOrIdTargeted"
        }  

        $Response = $Response.content | ConvertFrom-Json

        If (!$Quiet) {
            $Response
        }
    }
    End {
    }
}
