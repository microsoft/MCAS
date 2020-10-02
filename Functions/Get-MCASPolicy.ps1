function Get-MCASPolicy {
    [CmdletBinding()]
    param
    (
        # Fetches a policy by its unique identifier.
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [ValidatePattern({^[A-Fa-f0-9]{24}$})]
        [Alias("_id")]
        [string]$Identity,

        # Required when fetching a policy by ID
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("INLINE", "AUDIT", "ANOMALY_DETECTION", "NEW_SERVICE", "ANOMALY_DISCOVERY", "FILE", "MALWARE", "SESSION", "ACCESS", "APP_PERMISSION", "APP_PERMISSION_ANOMALY")]
        [string]$PolicyType,

        # Specifies the credential object containing tenant as username (e.g. 'contoso.us.portal.cloudappsecurity.com') and the 64-character hexadecimal Oauth token as the password.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential = $CASCredential
    )
    begin {
            $body = @{'skip' = 0; 'limit' = 100 } # Base request body
            #region ----------------------------FILTERING----------------------------
            $filterSet = @() # Filter set array

            # filters
               
            # ActionTypeName / ActionTypeNameNot
            if ($PolicyType){ 
                $filterSet += @{'type' = @{} 
                }
                $FilterName = "type"
            }
            # PolicyType
            if ($PolicyType) { $filterSet.($FilterName).add('eq', $PolicyType ) }
     

    }
    process
    {
        # Fetch mode should happen once for each item from the pipeline, so it goes in the 'Process' block
        if ($Identity)
        {
            try {
                # Fetch the item by its id
                $response = Invoke-MCASRestMethod -Credential $Credential -Path "/cas/api/v1/policies/$PolicyType/$Identity/" -Method Get
            }
            catch {
                throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
            }

            try {
                Write-Verbose "Adding alias property to results, if appropriate"
                $response = $response | Add-Member -MemberType AliasProperty -Name Identity -Value '_id' -PassThru
            }
            catch {}
            
            $response
        }
    }
    end
    {
        If (!$Identity) # Only run remainder of this end block if listing all policies
        {
            # List mode logic only needs to happen once, so it goes in the 'End' block for efficiency
            # Get the matching items and handle errors
            try {
           
                $response = Invoke-MCASRestMethod -Credential $Credential -Path "/cas/api/v1/policies/" -Body $body -Method Post -FilterSet $filterSet -Raw
            }
            catch {
                throw $_  #Exception handling is in Invoke-MCASRestMethod, so here we just want to throw it back up the call stack, with no additional logic
            }

            $response = ($response.Content | ConvertFrom-Json).data
            
            try {
                if($null -ne $response){
                Write-Verbose "Adding alias property to results, if appropriate"
                $response = $response | Add-Member -MemberType AliasProperty -Name Identity -Value '_id' -PassThru
                }
            }
            catch {}

            $response
        }
    }
}