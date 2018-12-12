function New-MCASDiscoveryDataSource {
    [CmdletBinding()]
    param
    (
        # Specifies the credential object containing tenant as username (e.g. 'contoso.us.portal.cloudappsecurity.com') and the 64-character hexadecimal Oauth token as the password.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential = $CASCredential,

        # Specifies the name of the data source object to create
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateLength(1,64)]
        [ValidatePattern('^[A-Za-z\d-_]+$')]
        [string]$Name,
        
        # Specifies the appliance type to use for the format of the block script
        [Parameter(Mandatory=$true)]
        [device_type]$DeviceType,

        # Specifies the type of receiver to create. Possible Values: FTP|Syslog-UDP|Syslog-TCP
        [Parameter(Mandatory=$true)]
        [ValidateSet('FTP','FTPS','Syslog-UDP','Syslog-TCP','Syslog-TLS')]
        [string]$ReceiverType,

        # Specifies whether to replace the usernames with anonymized identifiers in MCAS (audited de-anonymization of these identifiers is possible)
        [switch]$AnonymizeUsers
    )

    $body = [ordered]@{'anonymizeUsers'=$AnonymizeUsers;'displayName'=$Name;'logType'=($DeviceType -as [int]);}
    
    switch ($ReceiverType) {
        'FTP' {
            $body.Add('receiverType','ftp')
            $body.Add('receiverTypeFull','ftp')
        }
        'FTPS' {
            $body.Add('receiverType','ftps')
            $body.Add('receiverTypeFull','ftps')
        }
        'Syslog-UDP' {
            $body.Add('protocol','udp')
            $body.Add('receiverType','syslog')
            $body.Add('receiverTypeFull','syslog-udp')
        }
        'Syslog-TCP' {
            $body.Add('protocol','tcp')
            $body.Add('receiverType','syslog')
            $body.Add('receiverTypeFull','syslog-tcp')
        }
        'Syslog-TLS' {
            $body.Add('protocol','tls')
            $body.Add('receiverType','syslog')
            $body.Add('receiverTypeFull','syslog-tls')
        }
    }

    try {
        $response = Invoke-MCASRestMethod -Credential $Credential -Path "/cas/api/v1/discovery/data_sources/" -Method Post -Body $body
    }
    catch {
        throw "Error calling MCAS API. The exception was: $_"
    }
}