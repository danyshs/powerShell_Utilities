# GLOBAL VARIABLES

## EXAMPLES
#$global:path_steam = "E:/Steam/config/config.vdf"

#$global:urlAliases = @{
#    "ds1" = "https://danyshs.work/"
#    "ds2" = "https://danyshs.work/projects/"
#}

#$global:priorityNames = @('Danysh', 'Alt')

#$global:numberToName = [ordered]@{
#    '1' = 'Alt1'
#    '2' = 'MyName'
#    '3' = 'Alt2'
#}

#$global:KeyToName = @{
#    '102983093'= 'MyName'
#    '12319584' = 'Alt1' 
#    '1403290' = 'Alt2' 
#}

$global:approved_formats = @(
############################################################
".md", ".tex", ".docx", ".pdf",".txt", ".epub", ".mobi", ".doc",
# Data formats
".xml", ".json", ".yml", ".yaml", ".csv",".ini", ".cfg", ".conf",
############################################################
# Scripting and programming languages
#".sh", ".ps1", ".psm1", ".bat", ".php", ".cpp", ".c", ".h", ".hpp", ".cs",
#".java", ".swift", ".go", ".pl", ".lua", ".r", ".m",
#".asm", ".v", ".vhdl", ".sql", ".js", ".ts", ".tsx",
#".jsx", ".r", ".py", "ipynb"
############################################################
# Image formats
".jpeg", ".jpg", ".png", ".ico", ".svg", ".psd",".gif", ".bmp", ".tiff", ".webp",
############################################################
# Video formats
".mp4",".avi", ".mkv", ".flv", ".mov", ".wmv",
############################################################
# Audio formats
".mp3", ".wav", ".flac", ".aac", ".ogg", ".m4a",
############################################################
# Web formats
".html", ".css",
############################################################
# Binary and executable formats
".exe", ".db", ".dbf",".msi",
############################################################
# Archive formats
".zip", ".rar", ".tar", ".gz", ".bz2", ".7z",
############################################################
# Spreadsheet and presentation formats
".xls", ".xlsx", ".ppt", ".pptx")

$global:nameToKey = @{}
$global:KeyToName.GetEnumerator() | ForEach-Object { $global:nameToKey[$_.Value] = $_.Key }

# DOT SOURCING
Get-ChildItem "$HOME\Documents\PowerShell\Custom\" -Filter *.ps1 | ForEach-Object {
    . $_.FullName
}

. "$HOME\Documents\PowerShell\configs.ps1"

#. "$HOME\Documents\PowerShell\Custom\avengers.ps1"
#. "$HOME\Documents\PowerShell\Custom\my_sfsSelect.ps1"
#. "$HOME\Documents\PowerShell\Custom\ohmyposhConfig.ps1"
#. "$HOME\Documents\PowerShell\Custom\appStarters.ps1"
#. "$HOME\Documents\PowerShell\Custom\gitCommands.ps1"
#. "$HOME\Documents\PowerShell\Custom\treeFuncs.ps1"
#. "$HOME\Documents\PowerShell\Custom\explorerLauncher.ps1"

# MODULE IMPORT
Import-Module Piglet

# FUNCTIONS
function cd...  { cd ..\.. }
function cd.... { cd ..\..\.. }

function ds_gitRefresh {
    gitrefresh -sourceAlias "dsgl" -destinationAlias "dsgh" -sourceRepoName "nextjs-portfolio-pageview-counter" -destinationRepoName "danyshs_work" -dkey $global:my_github_key}

function coding_place {

    param(
        [string]$mypath
    )
        $mypath = (Get-Alias -Name $mypath).Definition

    if(Test-Path $mypath){
    cd $mypath
    }
    else{
    "Couldnt cd to $mypath sowwy"
    }
}

# ALIASES
Set-Alias -Name ref -Value '. $PROFILE' 
Set-Alias -Name pwshcus -Value C:\Users\danys\Documents\PowerShell\Custom
Set-Alias -Name pwshhome -Value C:\Users\danys\Documents\PowerShell
Set-Alias -Name personal_dir -Value E:\Coding\Personal
Set-Alias -Name work_dir -Value E:\Coding\Personal\ActualPersonal
Set-Alias -Name resume_dir -Value E:\Coding\Personal\ActualPersonal\Resume
Set-Alias -Name web_dir -Value E:\Coding\Personal\ActualPersonal\danyshs_work\nextjs-portfolio-pageview-counter
Set-Alias -Name cdto -Value coding_place
Set-Alias -Name tree -Value Show-TreeWithColor
Set-Alias -Name steam -Value Start-Steam
Set-Alias -Name settings -Value Start-Settings
Set-Alias -Name nsettings -Value Start-nSettings
Set-Alias -Name opera -Value Start-Opera
Set-Alias -Name discord -Value Start-Discord
Set-Alias -Name spotify -Value Start-Spotify
Set-Alias -Name avengers -Value Open-MultipleOperaUrls
Set-Alias -Name dsweb -Value Start-Website_Editing
Set-Alias -Name sfs -Value my_Sfs_Select
Set-Alias -Name gita -Value gitadd
Set-Alias -Name gitc -Value gitcommit
Set-Alias -Name gitp -Value gitpush
Set-Alias -Name gitac -Value gitaddcommentfunc
Set-Alias -Name gitpc -Value gitpushcommentfunc
Set-Alias -Name aex -Value aliased_explorerLaunch
Set-Alias -Name ex -Value explorerLaunch 

Import-Module -Name Microsoft.WinGet.CommandNotFound

