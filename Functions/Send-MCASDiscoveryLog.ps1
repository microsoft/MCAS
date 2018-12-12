<#
.Synopsis
   Uploads a proxy/firewall log file to a Cloud App Security tenant for discovery.
.DESCRIPTION
   Send-MCASDiscoveryLog uploads an edge device log file to be analyzed for SaaS discovery by Cloud App Security.

   When using Send-MCASDiscoveryLog, you must provide a log file by name/path and a log file type, which represents the source firewall or proxy device type. Also required is the name of the discovery data source with which the uploaded log should be associated; this can be created in the console.

   Send-MCASDiscoveryLog does not return any value

.EXAMPLE
   PS C:\> Send-MCASDiscoveryLog -LogFile C:\Users\Alice\MyFirewallLog.log -LogType CISCO_IRONPORT_PROXY -DiscoveryDataSource 'My CAS Discovery Data Source'

   This uploads the MyFirewallLog.log file to CAS for discovery, indicating that it is of the CISCO_IRONPORT_PROXY log format, and associates it with the data source name called 'My CAS Discovery Data Source'

.FUNCTIONALITY
   Uploads a proxy/firewall log file to a Cloud App Security tenant for discovery.
#>
function Send-MCASDiscoveryLog {
    [CmdletBinding()]
    param
    (
        # Specifies the credential object containing tenant as username (e.g. 'contoso.us.portal.cloudappsecurity.com') and the 64-character hexadecimal Oauth token as the password.
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential = $CASCredential,
                
        # The full path of the Log File to be uploaded, such as 'C:\mylogfile.log'.
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, Position=0)]
        [Validatescript({Test-Path $_})]
        [Validatescript({(Get-Item $_).Length -le 5GB})]
        [alias("FullName")]
        [string]$LogFile,

        # Specifies the source device type of the log file.
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, Position=1)]
        [ValidateNotNullOrEmpty()]
        [device_type]$LogType,

        # Specifies the discovery data source name as reflected in your CAS console, such as 'US West Microsoft ASA'.
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$DiscoveryDataSource,

        # Specifies that the uploaded log file should be made into a snapshot report, in which case the value provided for -DiscoveryDataSource will become the snapshot report name.
        [switch]$UploadAsSnapshot,

        # Specifies that the uploaded log file should be deleted after the upload operation completes.
        [alias("dts")]
        [switch]$Delete
    )
    begin {}
    process
    {
        Write-Verbose "Checking for the file $LogFile"
        try {            
            $fileName = (Get-Item $LogFile).Name
            $fileSize = (Get-Item $LogFile).Length
        }
        catch {
            throw "Could not get $LogFile : $_"
        }


        Write-Verbose "Requesting a target URL to which $LogFile can be uploaded"
        try {            
            $getUploadUrlResponse = Invoke-MCASRestMethod -Credential $Credential -Path "/api/v1/discovery/upload_url/?filename=$fileName&source=$LogType" -Method Get

            $uploadUrl = $getUploadUrlResponse.url            
        }
        catch {
            throw "Something went wrong trying to get the target URL for $LogFile. The exception was: $_"
        }
        Write-Verbose "The target URL to which $LogFile will be uploaded is $uploadUrl"
        

        Write-Verbose "Setting the transfer mode based on log file size"
        if (($getUploadUrlResponse.provider -eq 'azure') -and ($fileSize -le 64mb)) {
            $fileUploadHeader = @{'x-ms-blob-type'='BlockBlob'}
            Write-Verbose "The file is 64MB or smaller, so the following header and value will be used: x-ms-blob-type: BlockBlob"
        }
        elseif (($getUploadUrlResponse.provider -eq 'azure') -and ($fileSize -gt 64mb)) {
            $fileUploadHeader = @{'Transfer-Encoding'='chunked'}
            Write-Verbose "The file is larger than 64MB, so the following header and value will be used: Transfer-Encoding: chunked"
        }


        Write-Verbose "The file $LogFile will now be uploaded to $uploadUrl"
        try
        {            
            $fileUploadResponse = Invoke-RestMethod -Uri $uploadUrl -InFile $LogFile -Headers $fileUploadHeader -Method Put -UseBasicParsing
        }
        catch {
            throw "File upload failed. The exception was: $_"
        }
        Write-Verbose "The upload of file $LogFile seems to have succeeded"


        if ($UploadAsSnapshot) {
            Write-Verbose 'The parameter -UploadAsSnapshot was specified, so the message body will include the "uploadAsSnapshot" parameter'
            $body = @{'uploadUrl'=$uploadUrl;'inputStreamName'=$DiscoveryDataSource;'uploadAsSnapshot'=$true}
        }
        else {
            Write-Verbose 'The parameter -UploadAsSnapshot was not specified, so the message body will not include the "uploadAsSnapshot" parameter'
            $body = @{'uploadUrl'=$uploadUrl;'inputStreamName'=$DiscoveryDataSource}
        }


        Write-Verbose "The upload of $LogFile will now be finalized"
        try {
            $finalizeUploadResponse = Invoke-MCASRestMethod -Credential $Credential -Path "/api/v1/discovery/done_upload/" -Body $body -Method Post
        }
        catch {
            throw "Something went wrong trying to finalize the upload of $LogFile. The exception was: $_"
        }
        Write-Verbose "The finalizing of the upload of $LogFile seems to have succeeded"


        if ($Delete) {
            Write-Verbose "The -Delete parameter was specified, so $LogFile will now be deleted"
            try {
                Remove-Item $LogFile -Force
            }
            catch {
                Write-Warning "The file $LogFile could not be deleted. The exception was: $_"
            }
            Write-Verbose "The deletion of $LogFile seems to have succeeded"
        }
    }
    end {}
}