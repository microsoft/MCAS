function ConvertTo-MCASJsonFilterString {
    [CmdletBinding()]
    param ([Parameter(Mandatory=$true, Position=0)]$FilterSet)

    $temp = @()

    ForEach ($filter in $FilterSet) {
        $temp += ((($filter | ConvertTo-Json -Depth 4 -Compress).TrimEnd('}')).TrimStart('{'))
        }
    $rawJsonFilter = ('{'+($temp -join '},')+'}}')
    Write-Verbose "JSON filter string is $rawJsonFilter"

    $rawJsonFilter
}