# GLOBAL VARIABLES
Set-Variable XDG_CONFIG_HOME=C:\Users\danys\.config

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


# DOT SOURCING
Get-ChildItem "$HOME\Documents\PowerShell\Custom\" -Filter *.ps1 | ForEach-Object {
  . $_.FullName
}

#. "$HOME\Documents\PowerShell\Custom\avengers.ps1"
#. "$HOME\Documents\PowerShell\Custom\my_sfsSelect.ps1"
#. "$HOME\Documents\PowerShell\Custom\ohmyposhConfig.ps1"
#. "$HOME\Documents\PowerShell\Custom\appStarters.ps1"
#. "$HOME\Documents\PowerShell\Custom\gitCommands.ps1"
#. "$HOME\Documents\PowerShell\Custom\treeFuncs.ps1"
#. "$HOME\Documents\PowerShell\Custom\explorerLauncher.ps1"

# SETUP
function setup {
  $profileDir = Split-Path -Parent $PROFILE
  $newFolder = "Custom"
  $newFolderPath = Join-Path -Path $profileDir -ChildPath $newFolder
  if (-not (Test-Path -Path $newFolderPath)) {
    New-Item -Path $newFolderPath -ItemType Directory
  }
}

# MODULE IMPORT
Import-Module Piglet
Import-Module PSReadLine

# FUNCTIONS
function cd... { Set-Location ..\.. }
function cd.... { Set-Location ..\..\.. }

<#function ds_gitRefresh {
  gitrefresh -sourceAlias "dsgl" -destinationAlias "dsgh" -sourceRepoName "nextjs-portfolio-pageview-counter" -destinationRepoName "danyshs_work" -dkey $global:my_github_key
}#>

function cdto {

  param(
    [string]$mypath
  )
  $mypath = (Get-Alias -Name $mypath).Definition

  if (Test-Path $mypath) {
    Set-Location $mypath
  }
  else {
    "Couldnt cd to $mypath ;w;"
  }
}

function acode {

  param(
    [string]$mypath
  )
  $mypath = (Get-Alias -Name $mypath).Definition

  if (Test-Path $mypath) {
    code $mypath
  }
  else {
    "Couldnt open VSCode to $mypath ;w;"
  }
}

function anvim {

  param(
    [string]$mypath
  )
  $mypath = (Get-Alias -Name $mypath).Definition

  if (Test-Path $mypath) {
    cd $mypath
    nvim
  }
  else {
    "Couldnt open VSCode to $mypath ;w;"
  }
}

function screenRotate {
  param (
    [string] $state = "u",
    [int] $screen = 1
  )    
  Set-ScreenOrientation -screen $screen -state $state
}

function r1u { screenRotate -screen 1 -state "u" }
function r1l { screenRotate -screen 1 -state "l" }
function r1r { screenRotate -screen 1 -state "r" }
function r1d { screenRotate -screen 1 -state "d" }
function r2u { screenRotate -screen 2 -state "u" }
function r2l { screenRotate -screen 2 -state "l" }
function r2r { screenRotate -screen 2 -state "r" }
function r2d { screenRotate -screen 2 -state "d" }

function letsGoTagging {
  & C:/Users/danys/AppData/Local/Programs/Python/Python312/python.exe e:/Coding/Personal/ActualPersonal/Email_Sorting/tag_all_emails.py
}

function runthis {
  & C:/Users/danys/AppData/Local/Programs/Python/Python312/python.exe e:/Coding/Personal/ActualPersonal/Email_Sorting/runThis.py
}

function hist {
  code (Get-PSReadlineOption).HistorySavePath
}
function testfunc {
  # Define the text with formatting
  param(
    [Parameter(Mandatory = $true)]
    [string]$prompt
  )

  $sendprompt = curl `
    -H 'Content-Type: application/json' `
    -d "{'contents':[{'parts':[{'text':'$prompt'}]}]}"`
    -X POST "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$my_gemini_key"

  # Extract text from the prompt
  $result = [regex]::Match($sendprompt, '"text":(.*?\\n")')

  # Remove leading and trailing quotes
  $text = $result.Groups[1].Value
  $text = $text -replace '^"|"$', ''  
  $text = $text -replace "\\'", "'"
  
  # Replace \n with line breaks
  $text = $text -replace '\\n', "`n"

  # Replace bolded text with green colored text
  $text = $text -creplace '\*\*(.*?)\*\*', "`e[1;32m`$1`e[0m"

  # Display the formatted text using Write-Host
  Write-Host $text

}
function Format-Text {
  param(
    [string]$text
  )

  # Replace bold with green text
  $text = $text -replace '\*\*(.*?)\*\*', { 
    [PSCustomObject]@{
      Object          = $_.Groups[1].Value
      ForegroundColor = [ConsoleColor]::Green
    }
  }

  # Replace italic with yellow text
  $text = $text -replace '\*(.*?)\*', { 
    [PSCustomObject]@{
      Object          = $_.Groups[1].Value
      ForegroundColor = [ConsoleColor]::Yellow
    }
  }

  # Handle strikethrough (approximation using dashes)
  $text = $text -replace '~~(.*?)~~', { 
    $strikethrough = $_.Groups[1].Value -replace '.', '$0-'
    [PSCustomObject]@{
      Object          = $strikethrough
      ForegroundColor = [ConsoleColor]::DarkGray
    }
  }

  # Handle inline code
  $text = $text -replace '`(.*?)`', { 
    [PSCustomObject]@{
      Object          = $_.Groups[1].Value
      BackgroundColor = [ConsoleColor]::DarkGray
      ForegroundColor = [ConsoleColor]::Cyan
    }
  }

  # Handle code blocks
  $text = $text -replace '```([\s\S]*?)```', {
    $codeBlock = $_.Groups[1].Value
    [PSCustomObject]@{
      Object          = "`n$codeBlock`n"
      BackgroundColor = [ConsoleColor]::DarkGray
      ForegroundColor = [ConsoleColor]::White
    }
  }

  # Handle headings
  $text = $text -replace '^(#+)\s*(.*)', {
    $level = $_.Groups[1].Value.Length
    $heading = $_.Groups[2].Value
    $color = switch ($level) {
      1 { [ConsoleColor]::Magenta }
      2 { [ConsoleColor]::Blue }
      3 { [ConsoleColor]::Cyan }
      default { [ConsoleColor]::White }
    }
    [PSCustomObject]@{
      Object          = "$('=' * $level) $heading $('=' * $level)"
      ForegroundColor = $color
    }
  }

  # Handle blockquotes
  $text = $text -replace '^>\s*(.*)', {
    [PSCustomObject]@{
      Object          = "│ $($_.Groups[1].Value)"
      ForegroundColor = [ConsoleColor]::DarkCyan
    }
  }

  # Handle horizontal rules
  $text = $text -replace '^---+$', {
    [PSCustomObject]@{
      Object          = "─" * $Host.UI.RawUI.WindowSize.Width
      ForegroundColor = [ConsoleColor]::DarkGray
    }
  }

  # Handle unordered lists
  $text = $text -replace '^\s*[\*\-\+]\s*(.*)', {
    [PSCustomObject]@{
      Object          = "• $($_.Groups[1].Value)"
      ForegroundColor = [ConsoleColor]::White
    }
  }

  # Handle ordered lists
  $text = $text -replace '^\s*(\d+)\.\s*(.*)', {
    [PSCustomObject]@{
      Object          = "$($_.Groups[1].Value). $($_.Groups[2].Value)"
      ForegroundColor = [ConsoleColor]::White
    }
  }

  # Handle links (show text and URL)
  $text = $text -replace '\[(.*?)\]\((.*?)\)', {
    [PSCustomObject]@{
      Object          = "$($_.Groups[1].Value) (URL: $($_.Groups[2].Value))"
      ForegroundColor = [ConsoleColor]::Blue
    }
  }

  # Split the text into lines and process each line
  $lines = $text -split "`n"
  foreach ($line in $lines) {
    if ($line -is [PSCustomObject]) {
      Write-Host $line.Object -ForegroundColor $line.ForegroundColor -BackgroundColor $line.BackgroundColor
    }
    else {
      Write-Host $line
    }
  }
}

function testfunc {
  param(
    [Parameter(Mandatory = $true)]
    [string]$prompt
  )

  # Write-Host "`n PROMPT ========================== `n $prompt `n=============================="

  $sendprompt = curl `
    -H 'Content-Type: application/json' `
    -d "{'contents':[{'parts':[{'text':'$prompt'}]}]}"`
    -X POST "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$my_gemini_key"



  # Write-Host "`n OUTPUT ========================== `n $sendprompt `n=============================="

  # Extract text from the response
  $result = [regex]::Match($sendprompt, '"text":\s*"((?:[^"\\]|\\.)*)"')

  $text = $result.Groups[1].Value
  Write-Host "`n PREPROCESSED TEXT ========================== `n $text `n=============================="

  # Remove specific HTML Unicode escape sequences
  $unicodeSequences = @("u003c", "u003e", "u002f")
  foreach ($sequence in $unicodeSequences) {
    $text = $text -replace "\\$sequence", ""
  }

  $text = $text -creplace '###\s(.*?)$', "`e[32m`$1`e[0m"     # Header 3 -> Green

  $text = $text -creplace '##\s(.*?)$', "`e[1;36m`$1`e[0m"     # Header 2 -> Cyan (bold)

  $text = $text -creplace '#\s(.*?)$', "`e[1;35m`$1`e[0m"    # Header 1 -> Magenta (bold)

  # Double-asterisk -> Green (excluding cases with * followed by whitespace)
  $text = $text -creplace '(?<![\*\s])\*\*(?!.*`n|\s)(.*?)\*\*(?![\*\s])', "`e[32;1m`$1`e[0m"

  # Italic (excluding cases with * followed by whitespace)
  $text = $text -creplace '(?<!\*)\*(?!.*`n|\s)(.*?)\*(?!\*)', "`e[3m`$1`e[0m"
  $text = $text -creplace '(?<!_)_(?!.*`n)([^_]+)_(?!_)', "`e[4m`$1`e[0m"           # Underline
  $text = $text -creplace '(?<!~)~~(?!.*`n)(.*?)~~(?!~)', "`e[9m`$1`e[0m"           # Strikethrough
  $text = $text -creplace '\[blue\](?!.*`n)(.*?)\[/blue\]', "`e[34m`$1`e[0m"   # Blue Color
  $text = $text -creplace '\[big\](?!.*`n)(.*?)\[/big\]', "`e[1m`$1`e[0m"     # Big Text
  $text = $text -creplace '\[small\](?!.*`n)(.*?)\[/small\]', "`e[2m`$1`e[0m" # Small Text
  
  # Write-Host "`n BOLDED ========================== `n $text `n=============================="

  # Correct the newlines
  $text = $text -replace '\\n', "`n"

  # Correct the slashes
  $text = $text -replace '\\\\', ""
  $text = $text -replace '\\\"', '"'

  # Remove the empty space from the start of the output
  $text = $text.TrimStart()

  # Display the formatted text using Write-Host
  Write-Host "`n`n"
  Write-Host "$text"
  
}
  # Write-Host "`n NEWLINED AND FINAL========================== `n $text `n=============================="

function touch {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromRemainingArguments)]
        [string[]]$PathsAndContent
    )
    $currentPath = $null
    $content = $null

    foreach ($item in $PathsAndContent) {
        if ($item.EndsWith('/') -or $item.EndsWith('\')) {
            # It's a directory
            $dirPath = $item.TrimEnd('/\')
            if (Test-Path -Path $dirPath -PathType Leaf) {
                Write-Error "Cannot create directory '$item'. A file with the same name already exists."
                return
            }
            if (!(Test-Path -Path $dirPath)) {
                New-Item -Path $dirPath -ItemType Directory | Out-Null
                Write-Host "Directory '$item' created."
            }
            $currentPath = $null
            $content = $null
        }
        elseif ($null -eq $currentPath) {
            # It's a file path
            if (Test-Path -Path "$item/" -PathType Container) {
                Write-Error "Cannot create file '$item'. A directory with the same name already exists."
                return
            }
            $currentPath = $item
        }
        else {
            # It's content for the current file
            $content = $item
        }

        if ($currentPath -and $content) {
            if (Test-Path -Path $currentPath -PathType Container) {
                Write-Error "Cannot add content to a directory: $currentPath"
                return
            }

            if (!(Test-Path -Path $currentPath)) {
                New-Item -Path $currentPath -ItemType File | Out-Null
                Write-Host "File '$currentPath' created."
            }

            Add-Content -Path $currentPath -Value $content
            Write-Host "Content appended to file '$currentPath'."

            $currentPath = $null
            $content = $null
        }
    }

    # Only a file path is provided -> create empty file
    if ($currentPath -and !$content) {
        if (Test-Path -Path "$currentPath/" -PathType Container) {
            Write-Error "Cannot create file '$currentPath'. A directory with the same name already exists."
            return
        }
        if (!(Test-Path -Path $currentPath)) {
            New-Item -Path $currentPath -ItemType File | Out-Null
            Write-Host "File '$currentPath' created."
        }
    }
}

function run {. -Path ($args[0])}

<#
function Test2Func {
  $text = @"
To ensure that your PowerShell script correctly applies ANSI escape codes for text formatting, especially when working with specific patterns like **bold**, *italic*, _underline_, ~~strikethrough~~, [blue]blue color[/blue], [big]big text[/big], and [small]small text[/small], you can refine your regex replacements and ANSI escape code sequences. Here’s how you can adjust and refine your script.

### Header 3     
## Header 2     
# Header 1      
"@

  $text = $text -creplace '# (.*?)$', "`e[1;35m`$1`e[0m"    # Header 1 -> Magenta (bold)
  $text = $text -creplace '## (.*?)$', "`e[1;36m`$1`e[0m"     # Header 2 -> Cyan (bold)
  $text = $text -creplace '### (.*?)$', "`e[32m`$1`e[0m"     # Header 3 -> Green

  $text = $text -creplace '\*\*(.*?)\*\*', "`e[32m`$1`e[0m"    # Double-asterisk -> Green

  $text = $text -creplace '\*(.*?)\*', "`e[3m`$1`e[0m"           # Italic
  $text = $text -creplace '_([^_]+)_', "`e[4m`$1`e[0m"           # Underline
  $text = $text -creplace '~~(.*?)~~', "`e[9m`$1`e[0m"           # Strikethrough
  $text = $text -creplace '\[blue\](.*?)\[/blue\]', "`e[34m`$1`e[0m"   # Blue Color
  $text = $text -creplace '\[big\](.*?)\[/big\]', "`e[1m`$1`e[0m"     # Big Text
  $text = $text -creplace '\[small\](.*?)\[/small\]', "`e[2m`$1`e[0m" # Small Text


  # Display the formatted text using Write-Host
  Write-Host $text
}#>
#Test2Func

# ALIASES
Set-Alias -Name rotate -Value screenRotate 
Set-Alias -Name tree -Value Show-TreeWithColor
Set-Alias -Name steam -Value Start-Steam
Set-Alias -Name settings -Value Start-Settings
Set-Alias -Name opera -Value Start-Opera
Set-Alias -Name discord -Value Start-Discord
Set-Alias -Name spotify -Value Start-Spotify
Set-Alias -Name avengers -Value Open-MultipleOperaUrls
Set-Alias -Name dsweb -Value Start-Website_Editing
Set-Alias -Name godot -Value Start-Godot
Set-Alias -Name wsettings -Value Start-Wezterm-Config
Set-Alias -Name sfs -Value my_Sfs_Select
Set-Alias -Name gita -Value gitadd
Set-Alias -Name gitc -Value gitcommit
Set-Alias -Name gitp -Value gitpush
Set-Alias -Name gitac -Value gitaddcommentfunc
Set-Alias -Name gitpc -Value gitpushcommentfunc
Set-Alias -Name aex -Value aliased_explorerLaunch
Set-Alias -Name ex -Value explorerLaunch 
<# 
Set-Alias -Name pwshcus -Value C:\Users\danys\Documents\PowerShell\Custom
Set-Alias -Name pwshhome -Value C:\Users\danys\Documents\PowerShell
Set-Alias -Name personal_dir -Value E:\Coding\Personal
Set-Alias -Name work_dir -Value E:\Coding\Personal\ActualPersonal
Set-Alias -Name resume_dir -Value E:\Coding\Personal\ActualPersonal\Resume
Set-Alias -Name web_dir -Value E:\Coding\Personal\ActualPersonal\danyshs_work\nextjs-portfolio-pageview-counter
Set-Alias -Name proj_gmail -Value E:\Coding\Personal\ActualPersonal\Email_Sorting
Set-Alias -Name proj_web -Value E:\Coding\Personal\ActualPersonal\danyshs_work2\danyshs_work_2.0
Set-Alias -Name proj_pwsh -Value C:\Users\danys\Documents\PowerShell\
#>

Import-Module -Name Microsoft.WinGet.CommandNotFound

