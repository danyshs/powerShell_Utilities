
function aliased_explorerLaunch{
    param(
        [string]$mypath
    )
        $mypath = (Get-Alias -Name $mypath).Definition

    if(Test-Path $mypath){
    Start-Process explorer.exe -ArgumentList $mypath
    }
    else{
    "Couldnt launch $mypath sowwy"
    }
}

function explorerLaunch{
    param(
        [string]$mypath
    )
    if(Test-Path $mypath){
    Start-Process explorer.exe -ArgumentList $mypath
    }
    else{
    "Couldnt launch $mypath sowwy"
    }
}