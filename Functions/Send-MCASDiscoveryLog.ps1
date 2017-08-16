<#
.Synopsis
   Uploads a proxy/firewall log file to a Cloud App Security tenant for discovery.
.DESCRIPTION
   Send-MCASDiscoveryLog uploads an edge device log file to be analyzed for SaaS discovery by Cloud App Security.

   When using Send-MCASDiscoveryLog, you must provide a log file by name/path and a log file type, which represents the source firewall or proxy device type. Also required is the name of the discovery data source with which the uploaded log should be associated; this can be created in the console.

   Send-MCASDiscoveryLog does not return any value

.EXAMPLE
   Send-MCASDiscoveryLog -LogFile C:\Users\Alice\MyFirewallLog.log -LogType CISCO_IRONPORT_PROXY -DiscoveryDataSource 'My CAS Discovery Data Source'

   This uploads the MyFirewallLog.log file to CAS for discovery, indicating that it is of the CISCO_IRONPORT_PROXY log format, and associates it with the data source name called 'My CAS Discovery Data Source'

.FUNCTIONALITY
   Uploads a proxy/firewall log file to a Cloud App Security tenant for discovery.
#>
function Send-MCASDiscoveryLog
{
    [CmdletBinding()]
    [Alias('Send-CASDiscoveryLog')]
    Param
    (
        # The full path of the Log File to be uploaded, such as 'C:\mylogfile.log'.
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [Validatescript({Test-Path $_})]
        [string]$LogFile,

        # Specifies the source device type of the log file.
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, Position=1)]
        [ValidateNotNullOrEmpty()]
        [device_type[]]$LogType,

        # Specifies the discovery data source name as reflected in your CAS console, such as 'US West Microsoft ASA'.
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$DiscoveryDataSource,

        # Specifies that the uploaded log file should be deleted after the upload operation completes.
        [alias("dts")]
        [switch]$Delete,

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
        # Get just the file name, for when full path is specified
        Try
        {
            $FileName = (Get-Item $LogFile).Name
        }
            Catch
            {
                Throw "Could not get $LogFile : $_"
            }

        #region GET UPLOAD URL
        Try
        {
            # Get an upload URL for the file
            $GetUploadUrlResponse = Invoke-RestMethod -Uri "https://$TenantUri/api/v1/discovery/upload_url/?filename=$FileName&source=$LogType" -Headers @{Authorization = "Token $Token"} -Method Get -UseBasicParsing

            $UploadUrl = $GetUploadUrlResponse.url
        }
            Catch
            {
                If ($_ -like 'The remote server returned an error: (404) Not Found.')
                {
                    Throw "404 - Not Found: $Identity. Check to ensure the -Identity and -TenantUri parameters are valid."
                }
                ElseIf ($_ -like 'The remote server returned an error: (403) Forbidden.')
                {
                    Throw '403 - Forbidden: Check to ensure the -Credential and -TenantUri parameters are valid and that the specified credential is authorized to perform the requested action.'
                }
                ElseIf ($_ -match "The remote name could not be resolved: ")
                {
                    Throw "The remote name could not be resolved: '$TenantUri' Check to ensure the -TenantUri parameter is valid."
                }
                Else
                {
                    Throw "Unknown exception when attempting to contact the Cloud App Security REST API: $_"
                }
            }
        #endregion GET UPLOAD URL

        #region UPLOAD LOG FILE

        # Set appropriate transfer encoding header info based on log file size
        If (($GetUploadUrlResponse.provider -eq 'azure') -and ($LogFileBlob.Length -le 64mb))
        {
            $FileUploadHeader = @{'x-ms-blob-type'='BlockBlob'}
        }
        ElseIf (($GetUploadUrlResponse.provider -eq 'azure') -and ($LogFileBlob.Length -gt 64mb))
        {
            $FileUploadHeader = @{'Transfer-Encoding'='chunked'}
        }

        Try
        {
            # Upload the log file to the target URL obtained earlier, using appropriate headers
            If ($FileUploadHeader)
            {
                If (Test-Path $LogFile) {Invoke-RestMethod -Uri $UploadUrl -InFile $LogFile -Headers $FileUploadHeader -Method Put -UseBasicParsing -ErrorAction Stop}
            }
            Else
            {
                If (Test-Path $LogFile) {Invoke-RestMethod -Uri $UploadUrl -InFile $LogFile -Method Put -UseBasicParsing -ErrorAction Stop}
            }
        }
            Catch
            {
                If ($_ -like 'The remote server returned an error: (404) Not Found.')
                {
                    Throw "404 - Not Found: $Identity. Check to ensure the -Identity and -TenantUri parameters are valid."
                }
                ElseIf ($_ -like 'The remote server returned an error: (403) Forbidden.')
                {
                    Throw '403 - Forbidden: Check to ensure the -Credential and -TenantUri parameters are valid and that the specified credential is authorized to perform the requested action.'
                }
                ElseIf ($_ -match "The remote name could not be resolved: ")
                {
                    Throw "The remote name could not be resolved: '$TenantUri' Check to ensure the -TenantUri parameter is valid."
                }
                Else
                {
                    Throw "File upload failed: $_"
                }
            }
        #endregion UPLOAD LOG FILE

        #region FINALIZE UPLOAD
        Try
        {
            # Finalize the upload
            $FinalizeUploadResponse = Invoke-RestMethod -Uri "https://$TenantUri/api/v1/discovery/done_upload/" -Headers @{Authorization = "Token $Token"} -Body @{'uploadUrl'=$UploadUrl;'inputStreamName'=$DiscoveryDataSource} -Method Post -UseBasicParsing -ErrorAction Stop
        }
            Catch
            {
                If ($_ -like 'The remote server returned an error: (404) Not Found.')
                {
                    Throw "404 - Not Found: $Identity. Check to ensure the -Identity and -TenantUri parameters are valid."
                }
                ElseIf ($_ -like 'The remote server returned an error: (403) Forbidden.')
                {
                    Throw '403 - Forbidden: Check to ensure the -Credential and -TenantUri parameters are valid and that the specified credential is authorized to perform the requested action.'
                }
                ElseIf ($_ -match "The remote name could not be resolved: ")
                {
                    Throw "The remote name could not be resolved: '$TenantUri' Check to ensure the -TenantUri parameter is valid."
                }
                ElseIf ($_ -match "The remote server returned an error: (400) Bad Request.")
                {
                    Throw "400 - Bad Request: Ensure the -DiscoveryDataSource parameter specifies a valid data source name that you have created in the CAS web console."
                }
                Else
                {
                    Throw "Unknown exception when attempting to contact the Cloud App Security REST API: $_"
                }
            }
        #endregion FINALIZE UPLOAD

        Try
        {
            # Delete the file
            If ($Delete) {Remove-Item $LogFile -Force -ErrorAction Stop}
        }
            Catch
            {
                Throw "Could not delete $LogFile : $_"
            }
    }
    End
    {
    }
}
