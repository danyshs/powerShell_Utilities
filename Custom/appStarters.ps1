function Start-Settings {
  nvim $PROFILE
}
function Start-cSettings {
  code $PROFILE
}

function Start-nSettings {
  notepad.exe $PROFILE
}

function Start-Sfs-Select {
  Stop-Process -Name "steam" -ErrorAction SilentlyContinue
  Start-Process "E:\Drivers\Sfs Select\sfs-select\windows\sfs-select.exe"
}

function Start-Discord {
  Start-Process $env:discord
}

function Start-Steam {
  Start-Process E:\Steam\steam.exe
}


function Start-Opera {
  param ([string]$arg1, [switch]$s)
  if ($s) {
    $url = "https://google.com/search?q=$arg1"
    $url = $url.Replace(' ', '+')
    Start-Process $env:opera -ArgumentList $url
  }
  elseif ($arg1) {
    if ($arg1 -notmatch '\.') {
      if ($urlAliases.ContainsKey($arg1)) {
        $arg1 = $urlAliases[$arg1]
      }
      else {
        $arg1 += ".com"
      }
    }
    Start-Process $env:opera -ArgumentList $arg1
  }
  else {
    Start-Process $env:opera
  }
}

function Start-Spotify {
  Start-Process "C:\Users\danys\AppData\Local\Microsoft\WindowsApps\SpotifyAB.SpotifyMusic_zpdnekdrzrea0\spotify.exe"
}

function Start-Godot {
  Start-Process "E:\Game_Development\Godot\Godot_v4.2.2-stable_win64.exe"
}

function Start-Wezterm-Config {
  Start-Process "C:\Users\danys\.config\wezterm\wezterm.lua"
}
