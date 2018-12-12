function Get-MCASSiemAgentJarFile
{
    [CmdletBinding()]
    param()

    Write-Verbose 'Attempting to download the MCAS SIEM Agent zip file from Microsoft Download Center...'
    try {
        $siemAgentDownloadUrl = ((Invoke-WebRequest -Uri 'https://www.microsoft.com/en-us/download/confirmation.aspx?id=54537' -UseBasicParsing).Links | Where-Object {$_.'data-bi-cN' -eq 'click here to download manually'} | Select-Object -First 1).href
        $siemAgentZipFileName = $siemAgentDownloadUrl.Split('/') | Select-Object -Last 1
        $siemAgentDownloadResult = Invoke-WebRequest -Uri $siemAgentDownloadUrl -UseBasicParsing -OutFile "$pwd\$siemAgentZipFileName"
        Write-Verbose "$siemAgentDownloadResult"

        Write-Verbose 'Attempting to extract the MCAS SIEM Agent jar file from the downloaded zip file.'
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::ExtractToDirectory("$pwd\$siemAgentZipFileName", $pwd)
        $jarFile = $siemAgentZipFileName.TrimEnd('.zip')
        Write-Verbose "The extracted MCAS SIEM Agent JAR file is $pwd\$jarFile"
    }
    catch {
        throw "Something went wrong when attempting to download or extract the MCAS SIEM Agent zip file. The error was: $_"
    }
    
    Write-Verbose 'Attempting to cleanup the MCAS SIEM Agent zip file.'
    try {
        Remove-Item "$pwd\$siemAgentZipFileName" -Force
    }
    catch {
        Write-Warning "Something went wrong when attempting to cleanup the MCAS SIEM Agent zip file. The error was: $_"
    } 
    
    "$pwd\$jarFile"
}