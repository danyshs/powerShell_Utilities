function my_Sfs_Select {
    param (
        [string]$name,
        [switch]$list,
        [switch]$curr
    )

    Stop-Process -Name "steam" -ErrorAction SilentlyContinue

    # Read the file content
    $content = Get-Content -Path $path_steam -Raw

    $splitContent = $content -split '(?s)"AuthorizedDevice".*"Authentication"'

    $beforeCon = $splitContent[0] + '"AuthorizedDevice"{
        '
    $afterCon = '} "Authentication"' + $splitContent[1] 

    $authorizedDeviceSection = $content -match '(?s)"AuthorizedDevice".*"Authentication"' ? $Matches[0] : ""

    # Extract the keys and their corresponding blocks
    $mymatches = [regex]::Matches($authorizedDeviceSection, '"(\d+)"\s*\{([^}]*)\}')

    # Save the original order of keys
    $originalOrder = $mymatches | ForEach-Object { $_.Groups[1].Value }

    if ($list) {
        $namesList = $global:numberToName.Values
        return $namesList
    }
    
    if ($curr) {
        $currentOrder = $mymatches | ForEach-Object { $_.Groups[1].Value }
        $reorderedList = $currentOrder | ForEach-Object { 
            $global:KeyToName[$_]
        }
        return $reorderedList
    }

    # If a name is provided, reorder the blocks based on the name parameter
    if ($name -and $global:nameToKey.ContainsKey($name)) {
        $key = $global:nameToKey[$name]
        $mymatches = $mymatches | Sort-Object { $_.Groups[1].Value -eq $key } -Descending
    }
    else {
        Write-Output "The name '$name' does not align with any keys in the list."
        return
    }

    # Always put priority names at the top
    $priorityKeys = $global:priorityNames | ForEach-Object { $global:nameToKey[$_] }
    $mymatches = $mymatches | Sort-Object { $priorityKeys -contains $_.Groups[1].Value } -Descending

    # Write the reordered blocks back to the file
    $reorderedContent = ""
    foreach ($match in $mymatches) {
        $reorderedContent += "`"$($match.Groups[1].Value)`" {$($match.Groups[2].Value)}" + "`r`n"
    }

    Set-Content -Path $path_steam -Value ($beforeCon + $reorderedContent + $afterCon)
        
    $finalOrder = $mymatches | ForEach-Object { $_.Groups[1].Value }
        
    # Compare the original order with the final order
    if (($originalOrder -join ",").Trim() -eq ($finalOrder -join ",").Trim()) {
        Write-Output ($name + " not moved to the top as it is already there")
    }
    else {
        Write-Output ($name + " moved to the top.")
    }
}