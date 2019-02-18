function Invoke-FilePickerDialog
{   
    [CmdletBinding()]
    param
    (
        # Specifies the directory in which the picker will begin
        [string]$InitialDirectory = $PWD,

        # Specifies the file filter to be used
        [string]$Filter = 'All files|*.*',

        # Specifies the title for the dialog window
        [string]$Title
        )
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null

    $filePicker = New-Object System.Windows.Forms.OpenFileDialog
    
    Write-Verbose "InitialDirectory for file picker is $InitialDirectory"
    Write-Verbose "Filter for file picker is $Filter"
    $filePicker.initialDirectory = $InitialDirectory
    $filePicker.filter = $Filter
    $filePicker.title = $Title
    $filePicker.ShowDialog() | Out-Null
    
    $filePicker.filename
}