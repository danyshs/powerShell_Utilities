function gitaddcommentfunc{
    param([string]$comment)
    if (-not $comment) {
        $comment = Read-Host "Enter a comment for the commit"
    }
    git add -A
    git commit -m "$comment"
}

function gitpushcommentfunc{
    param([string]$comment)
    if (-not $comment) {
        $comment = Read-Host "Enter a comment for the commit"
    }
    git push
}

function gitadd{
    git add
}

function gitcommit{
    git commit
}

function gitpush{
    git push
}

function update_site{
    git add .  
    git commit -am "Updating site"
    git push
}

function gitrefresh {
    param (
        [string]$sourceAlias,
        [string]$destinationAlias,
        [string]$sourceRepoName,
        [string]$destinationRepoName,
        [string]$skey,
        [string]$dkey
    )

    $tempDir = "E:/temp_clone"
    
    if (Test-Path $tempDir) {
        Remove-Item -Recurse -Force $tempDir
    }

    if(![string]::IsNullOrEmpty($skey)) {
        $sourceUrl = "https://$skey@$(($global:urlAliases[$sourceAlias]).TrimStart('https://'))"
    } else {
        $sourceUrl = $global:urlAliases[$sourceAlias]
    }
    
    if(![string]::IsNullOrEmpty($dkey)) {
        $destinationUrl = "https://$dkey@$(($global:urlAliases[$destinationAlias]).TrimStart('https://'))"
    } else {
        $destinationUrl = $global:urlAliases[$destinationAlias]
    }
        
    $sourceRepo = "$sourceUrl$sourceRepoName"
    $destinationRepo = "$destinationUrl$destinationRepoName.git"
    
    $currentDir = Get-Location

    try {

        git clone $sourceRepo $tempDir
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to clone $sourceRepo"
        }
        Write-Host "Successfully accessed source repository: $sourceRepo"

        if (Test-Path $tempDir) {
            Write-Host "Successfully created $tempDir"
        } else {
            Write-Host "Failed to create $tempDir"
        }

        Set-Location -Path $tempDir

        git remote remove origin
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to remove origin"
        }

        git remote add origin $destinationRepo
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to add new origin $destinationRepo"
        }
        Write-Host "Successfully accessed destination repository: $destinationRepo"

        # Force push the changes to the remote repository
        git push origin main --force
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to push to new origin"
        }

        git push -u origin --tags
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to push tags to new origin"
        }
    }
    catch {
        Write-Error $_
        return
    }
    finally {
        Set-Location -Path $currentDir
        if (Test-Path $tempDir) {
            Remove-Item -Recurse -Force $tempDir
        }
    }
}