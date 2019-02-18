function Get-JavaInstallationPackage {
    [CmdletBinding()]
    param()
    
    try {
        Write-Verbose 'Getting download URL for the Java installation package.'
        $javaDownloadUrl = ((Invoke-WebRequest -Uri 'https://www.java.com/en/download/manual.jsp' -UseBasicParsing).links | Where-Object {$_.title -eq 'Download Java software for Windows (64-bit)'} | Select-Object -Last 1).href
        Write-Verbose "Download URL for the Java installation package is $javaDownloadUrl"

        if (Test-Path "$pwd\JavaSetup.tmp") {
            Write-Verbose "Cleaning up the existing download file at $pwd\JavaSetup.tmp before downloading"
            Remove-Item "$pwd\JavaSetup.tmp" -Force
        }
        
        Write-Verbose "Downloading the Java installation package to $pwd\JavaSetup.tmp"
        $javaDownloadResult = Invoke-WebRequest -Uri $javaDownloadUrl -UseBasicParsing -OutFile "$pwd\JavaSetup.tmp"
        
        Write-Verbose "Getting the Java installation package original filename"
        $javaSetupFileName = (Get-Item "$pwd\JavaSetup.tmp").VersionInfo.OriginalFilename
        Write-Verbose "The Java installation package original filename is $javaSetupFileName"

        if (Test-Path "$pwd\$javaSetupFileName") {
            Write-Verbose "Deleting the existing file $javaSetupFileName before renaming the downloaded package"
            Remove-Item "$pwd\$javaSetupFileName" -Force
        }
        
        Rename-Item -Path "$pwd\JavaSetup.tmp" -NewName "$pwd\$javaSetupFileName" -Force
    }
    catch {
        throw "Something went wrong getting the Java installation package. The error was $_"
    }

    "$pwd\$javaSetupFileName"
}