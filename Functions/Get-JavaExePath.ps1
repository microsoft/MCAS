function Get-JavaExePath
{   
    [CmdletBinding()]
    param()

    try {
        Write-Verbose 'Checking installed programs list for an existing Java installation on this host.'    
        $javaProductGuid = (Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -match '^Java (?:8|9) Update \d{1,3}.*$'} | Sort-Object -Property Name -Descending | Select-Object -First 1).IdentifyingNumber
        
        if ($javaProductGuid) {
            Write-Verbose "Java is installed. Getting the installation location from HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$javaProductGuid"         
            $javaInstallationPath = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$javaProductGuid" -Name 'InstallLocation').InstallLocation.TrimEnd('\')
            Write-Verbose "Java installation path detected is $javaInstallationPath"

            Write-Verbose "Checking $javaInstallationPath for \bin\java.exe"
            if (Test-Path "$javaInstallationPath\bin\java.exe") {
                Write-Verbose "Found $javaInstallationPath\bin\java.exe"
                "$javaInstallationPath\bin\java.exe"
            }
            else {
                Write-Verbose "Could not find /bin/java.exe in $javaInstallationPath"
            }
        }
        else {
            Write-Verbose "Java was not found in the installed programs list"
        }
    }
    catch {
        Write-Warning 'Something went wrong attempting to detect the Java installation or its installation path. The error was $_'
    }
}