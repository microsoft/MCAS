function Get-MCASPolicy
{
    [CmdletBinding()]
    [Alias('Get-CASPolicy')]
    Param
    (
        # Fetches a policy by its unique identifier.
        [Parameter(ParameterSetName='Fetch', Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        #[ValidatePattern({^[A-Fa-f0-9]{24}$})]
        [Alias("_id")]
        [string]$Identity,

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
        # Fetch mode should happen once for each item from the pipeline, so it goes in the 'Process' block
        If ($Identity)
        {
            Try {
                # Fetch the item by its id
                $Response = Invoke-MCASRestMethod2 -Uri "https://$TenantUri/cas/api/v1/policies/$Identity/" -Method Get -Token $Token
            }
                Catch {
                    Throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
                }

            $Response = $Response.content | ConvertFrom-Json
            
            If (($Response | Get-Member).name -contains '_id') {
                $Response = $Response | Add-Member -MemberType AliasProperty -Name Identity -Value _id -PassThru
            }
            
            $Response
        }
    }
    End
    {
        If (!$Identity) # Only run remainder of this end block if listing all policies
        {
            # List mode logic only needs to happen once, so it goes in the 'End' block for efficiency

            # Get the matching items and handle errors
            Try {
                $Response = Invoke-MCASRestMethod2 -Uri "https://$TenantUri/cas/api/v1/policies/" -Method Get -Token $Token
            }
                Catch {
                    Throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
                }

            $Response = $Response | ConvertFrom-Json
            
            $Response = Invoke-MCASResponseHandling -Response $Response

            $Response
        }
    }
}
