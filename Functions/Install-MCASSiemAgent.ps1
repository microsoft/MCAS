<#
.Synopsis
    Install-MCASSiemAgent downloads and installs Java, downloads and unzips the MCAS SIEM Agent JAR file, and creates a scheduled task to auto-start the agent on startup. (This works on 64-bit Windows hosts only.)
.DESCRIPTION
    Auto-deploy the MCAS SIEM Agent.
.EXAMPLE
    Install-MCASSiemAgent -UseInteractiveJavaSetup -Token 'ZV9LS...dGBwb'

    This example will auto-deploy the MCAS SIEM Agent with the user experiencing an interactive Java installation process

.EXAMPLE
    Install-MCASSiemAgent -TargetFolder 'C:\MCAS' -Force -Token 'ZV9LS...dGBwb'

    This example will auto-deploy the MCAS SIEM Agent in the C:\MCAS folder with no user interaction.

#>
function Install-MCASSiemAgent {
    [CmdletBinding()]
    param
    (
        # Token to be used by this SIEM agent to communicate with MCAS (provided during SIEM Agent creation in the MCAS console)
        [Parameter(Mandatory=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({$_ -match $MCAS_TOKEN_VALIDATION_PATTERN})]
        [string]$Token,

        # Proxy address to be used for this SIEM agent for outbound communication to the MCAS service in the cloud
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string]$ProxyHost,

        # Proxy port number to be used for this SIEM agent to egress to MCAS cloud service (only applies if -ProxyHost is also used, default = 8080)
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(1,65535)]
        [int]$ProxyPort = 8080,

        # Target folder for installation of the SIEM Agent (default = "C:\MCAS-SIEM-Agent")
        [ValidateNotNullOrEmpty()]
        [string]$TargetFolder = 'C:\MCAS-SIEM-Agent',

        # Specifies whether to install Java interactively, if/when it is automatically installed. If this is not used, Java setup will be run silently
        [switch]$UseInteractiveJavaSetup,

        # Specifies whether to auto-download and silently install Java, if Java is not found on the machine
        [switch]$Force,

        # Specifies whether to start the SIEM Agent after installation
        [switch]$StartNow
    )

    # Check system requirements
    Write-Verbose 'Checking for 64-bit Windows host'
    try {
        $sysInfo = Get-CimInstance Win32_OperatingSystem | Select-Object  Caption,OSArchitecture
        $isWindows = $sysInfo.Caption -cmatch 'Windows'
        $is64Bit = $sysInfo.OSArchitecture -cmatch '64-bit'
        }
    catch {
        throw 'Error detecting host information. This command only works on 64-bit Windows hosts.'
    } 
    if (-not ($isWindows -and $is64Bit)) {
        throw 'This does not appear to be a 64-bit Windows host. This command only works on 64-bit Windows hosts.'
    }
    Write-Verbose 'This host does appear to be running 64-bit Windows. Proceeding'


    # Check for the SIEM agent folder and .jar file
    Write-Verbose "Checking for an existing SIEM Agent JAR file in $TargetFolder"
    if (-not (Test-Path "$TargetFolder\mcas-siemagent-*-signed.jar")) {
        Write-Verbose "A JAR file for the MCAS SIEM Agent was not found in $TargetFolder"
        
        @($TargetFolder, "$TargetFolder\Logs") | ForEach-Object {
            Write-Verbose "Checking for $_"
            if (-not (Test-Path $_)) {
                Write-Verbose "$_ was not found, creating it"
                try {
                    New-Item -ItemType Directory -Path $_ -Force | Out-Null
                }
                catch {
                    throw "An error occurred creating $_. The error was $_"
                }
            }
        }
        
        Write-Verbose "Downloading and extracting the latest MCAS SIEM Agent JAR file to $pwd"
        $jarFile = Get-MCASSiemAgentJarFile

        Write-Verbose "Moving the MCAS SIEM Agent JAR file to $TargetFolder"
        Move-Item -Path "$jarFile" -Destination $TargetFolder -Force
    }


    # Get the installation location of the latest Java engine that is installed, if there is one installed
    $javaExePath = Get-JavaExePath


    # If Java is not found, download and install it
    if (-not $javaExePath) {
        if (-not $Force) {
            # Prompt user for confirmation before proceeding with automatic Java download and installation
            if ((Read-Host 'CONFIRM: No Java installation was detected. Java will now be automatically downloaded and installed Java. Do you wish to continue?`n[Y] Yes or [N] No (default is "No"').ToLower() -ne 'y') {
                Write-Verbose "User chose not to proceed with automatic Java download and installation. Exiting"
                return
            }
            Write-Verbose "User chose to proceed with automatic Java download and installation. Continuing"
        }
        
        # Download Java
        $javaSetupFileName = Get-JavaInstallationPackage

        # Install Java
        try {
            if ($UseInteractiveJavaSetup) {
                Write-Verbose "Starting interactive Java setup"
                Start-Process  "$javaSetupFileName" -Wait
            }
            else {
                Write-Verbose "Starting silent Java setup"
                Start-Process "$$javaSetupFileName" -ArgumentList '/s' -Wait
            }
        }
        catch {
            throw "Something went wrong attempting to run the Java setup package. The error was $_"
        }
        Write-Verbose "Java setup seems to have finished"      
        
        Write-Verbose "Cleaning up the Java setup package"
        try {
            Remove-Item "$javaSetupFileName" -Force
        }
        catch {
            Write-Warning ('Failed to clean up the Java setup exe file ({0})' -f "$javaSetupFileName")
        }

        # Get the installation location of the newly installed Java engine
        $javaExePath = Get-JavaExePath
    }


    # Check again for Java, which should be there now
    Write-Verbose "Checking again for Java, which should be there now"
    if (-not $javaExePath) {
        throw "There seems to still be a problem with the Java installation, it could not be found"
    }

    # Assemble the Java arguments
    if ($ProxyHost) {
        $javaArgs = '-jar {0} --logsDirectory {1} --token {2} --proxy {3}:{4} ' -f "$TargetFolder\$jarFile","$TargetFolder\Logs",$Token,$ProxyHost,$ProxyPort
    }
    else {
        $javaArgs = '-jar {0} --logsDirectory {1} --token {2}' -f "$TargetFolder\$jarFile","$TargetFolder\Logs",$Token
    }
    Write-Verbose "Arguments to be used for Java will be $javaArgs"


    # Create a scheduled task to auto-run the MCAS SIEM Agent
    Write-Verbose 'Creating an MCAS SIEM Agent scheduled task that will automatically run as SYSTEM upon startup on this host'
    try {               
        # Assemble the components of the scheduled task
        $taskName = 'MCAS SIEM Agent'     
        $taskAction = New-ScheduledTaskAction -Execute $javaExePath -WorkingDirectory $TargetFolder -Argument $javaArgs
        $taskPrincipal = New-ScheduledTaskPrincipal -Id Author -LogonType S4U -ProcessTokenSidType Default -UserId SYSTEM
        $taskTrigger = New-ScheduledTaskTrigger -AtStartup
        $taskSettings = New-ScheduledTaskSettingsSet -DontStopIfGoingOnBatteries -DontStopOnIdleEnd -AllowStartIfOnBatteries -ExecutionTimeLimit 0
        
        # Create the scheduled task in the root folder of the tasks library
        $task = Register-ScheduledTask -TaskName $taskName -Action $taskAction -Principal $taskPrincipal -Description $taskName -Trigger $taskTrigger -Settings $taskSettings
    }
    catch {
        throw ('Something went wrong when creating the scheduled task named {0}' -f $taskName)
    }

    # Start the scheduled task
    if ($StartNow -and $task) {
        Write-Verbose 'Starting the MCAS SIEM Agent scheduled task'
        try {
            Start-ScheduledTask $task
        }
        catch {
            throw ('Something went wrong when starting the scheduled task named {0}' -f $taskName)
        }    
    }
}