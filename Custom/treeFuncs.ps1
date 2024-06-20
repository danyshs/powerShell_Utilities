function Display-Tree {
    param (
        [string]$currentPath,
        [string]$indent = "",
        [switch]$all,
        [switch]$nall,
        [string]$find,
        [switch]$nofile,
        [switch]$nalias,
        [switch]$help
    )

    # Get directories and files in the current path
    $directories = Get-ChildItem -Path $currentPath -Directory

    if($find){
        if($find){
            $files = Get-ChildItem -Path $currentPath -File -Recurse | Where-Object { $_.Name -match $find }
        }
    }
    else{$files = Get-ChildItem -Path $currentPath -File | Where-Object {
        if($all){$true}
        if($nall){$_.Extension -notin $approved_formats}
        else{$_.Extension -in $approved_formats}
    }
    }

    # Display directories
    foreach ($dir in $directories) {
    $subFiles = Get-ChildItem -Path $dir.FullName -File -Recurse | Where-Object { $_.Name -match $find }
        if($subFiles.Count -gt 0){
            Write-Host "$indent| " -NoNewline -ForegroundColor Magenta
            Write-Host $dir.Name -ForegroundColor Cyan
            Display-Tree -currentPath $dir.FullName -indent "$indent-" -all:$all -nall:$nall -find:$find -nofile:$nofile
        }
    }

    # Display files
    if (-not $nofile){
        foreach ($file in $files) {
            if ($file.DirectoryName -eq $currentPath) {
                Write-Host "$indent|= " -NoNewline -ForegroundColor DarkMagenta
                Write-Host $file.Name -ForegroundColor Green
            }
        }
    }
}

function Show-TreeWithColor {
    param (
        [string]$curPath = ".",
        [switch]$list,
        [switch]$all,
        [switch]$nall,
        [string]$find,
        [switch]$nofile,
        [switch]$nalias,
        [switch]$help
    )

    if (-not $nalias) {
        $alias = Get-Alias -Name $curPath -ErrorAction SilentlyContinue
        if ($null -ne $alias) {
            $curPath = $alias.Definition
        }
        elseif (-not (Test-Path $curPath)) {
            Write-Host "Path not found: $curPath" -ForegroundColor Red
            return
        }
    }

    if ($help) {
        Write-Host @"
Show-TreeWithColor Parameters:
  -path: The path to start the tree from. Default is the current directory.
  -list: List the FINDSTR functions.
  -all: If present, display all files.
  -nall: If present, display files not in the approved formats.
  -find: The string to find in file names.
  -nofile: If present, only display directories, not files.
  -nalias: If present, assume directory is NOT potentially an alias.
  -help: If present, display this help message and do nothing else.

"@
        return
    }
    if ($list) {
        Write-Host "List of FINDSTR Functions:" -ForegroundColor Yellow
Write-Host @"
FINDSTR Functions:
  Syntax: FINDSTR string(s) [pathname(s)] [options]

  Basic Syntax and Usage
  Basic Command: FINDSTR string(s) [pathname(s)] [/R] [/C:"string"] [/G:StringsFile] [/F:file] [/D:DirList] [/A:color] [/OFF[LINE]] [options]

  Options:
  string(s):        Text to search for, each word is a separate search.
  pathname(s):      The file(s) to search.
  /C:"string":      Use string as a literal search string.
  /R:               Evaluate as a regular expression.
  /G:StringsFile:   Get search string from a file.
  /F:file:          Get a list of filenames to search from a file.
  /D:DirList:       Search a comma-delimited list of directories.
  /A:color:         Display filenames in color (2 hex digits).

  Key Options and Their Use
  /I:               Case-Insensitive Search
  /S:               Search Subfolders
  /P:               Skip Files with Non-Printable Characters
  /OFF[LINE]:       Do Not Skip Offline Files
  /L:               Literal Search Strings
  /B:               Match Pattern at Beginning of Line
  /E:               Match Pattern at End of Line
  /X:               Match Exactly
  /V:               Exclude Matching Lines
  /N:               Include Line Numbers
  /M:               Print Only Filenames
  /O:               Include Character Offsets

  Regular Expressions and Metacharacters:
  .:                Wildcard for any character.
  *:                Zero or more occurrences of the previous character or class.
  ^:                Beginning of line.
  '$':              End of line.
  [class]:          Any one character in the set.
  [^class]:         Any one character not in the set.
  [x-y]:            Any characters within the specified range.
  \x:               Literal use of metacharacter x.
  \<xyz:            Beginning of word.
  xyz\>:            End of word.
  ?:                Matches exactly one character.
  +:                Matches one or more occurrences of the previous character or class.
  |:                Acts as an OR operator.
  ():               Groups characters or expressions together.
"@ -ForegroundColor White
    }
    else{
        Write-Host $path -ForegroundColor Yellow
        Display-Tree -currentPath $curPath -all:$all -nall:$nall -find:$find -nofile:$nofile
    }
}