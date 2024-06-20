
function Open-MultipleOperaUrls {
    $urlKeys = @("dsgl", "dsgh", "dsli", "ds0", "ds1", "ds2")
    $urls = $urlKeys | ForEach-Object { $urlAliases[$_] }
    Start-Process $env:opera -ArgumentList $urls
}