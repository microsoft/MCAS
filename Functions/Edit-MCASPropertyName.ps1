function Edit-MCASPropertyName
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [string]$Data,    
    
        [Parameter(Mandatory=$true, Position=1)]
        [ValidateNotNullOrEmpty()]
        [string]$OldPropName,

        [Parameter(Mandatory=$true, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]$NewPropName
    )

    Write-Verbose "Edit-MCASPropertyName: Checking for property name collision in the response from MCAS for the following property names: $OldPropName and $NewPropName."
    
    # Patch for property name collisions
    If (Select-String -InputObject $Data -Pattern $OldPropName -CaseSensitive -Quiet) {
        Write-Verbose "Edit-MCASPropertyName: A property name collision was detected in the response from MCAS for the following property names: $OldPropName and $NewPropName. The $OldPropName property will be renamed to $NewPropName."
        $Output = $Data.Replace($OldPropName, $NewPropName)  

        Write-Verbose "Edit-MCASPropertyName: Modified response = $Output"
        $Output
    }
    Else {
        Write-Verbose "Edit-MCASPropertyName: No property name collision was detected in the response from MCAS for the following property names: $OldPropName and $NewPropName."
        $Data
    }
}