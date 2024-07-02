function Set-ScreenOrientation {
  param (
    [int]$screen,
    [string]$state
  )

  # Load the necessary assemblies
  Add-Type -AssemblyName System.Windows.Forms
  Add-Type -TypeDefinition @"
        using System;
        using System.Runtime.InteropServices;

        public class ScreenRotation
        {
            [DllImport("user32.dll")]
            public static extern int EnumDisplaySettings(string deviceName, int modeNum, ref DEVMODE devMode);

            [DllImport("user32.dll")]
            public static extern int ChangeDisplaySettingsEx(string lpszDeviceName, ref DEVMODE lpDevMode, IntPtr hwnd, uint dwflags, IntPtr lParam);

            [StructLayout(LayoutKind.Sequential)]
            public struct DEVMODE
            {
                private const int CCHDEVICENAME = 32;
                private const int CCHFORMNAME = 32;
                [MarshalAs(UnmanagedType.ByValTStr, SizeConst = CCHDEVICENAME)]
                public string dmDeviceName;
                public short dmSpecVersion;
                public short dmDriverVersion;
                public short dmSize;
                public short dmDriverExtra;
                public int dmFields;
                public int dmPositionX;
                public int dmPositionY;
                public int dmDisplayOrientation;
                public int dmDisplayFixedOutput;
                public short dmColor;
                public short dmDuplex;
                public short dmYResolution;
                public short dmTTOption;
                public short dmCollate;
                [MarshalAs(UnmanagedType.ByValTStr, SizeConst = CCHFORMNAME)]
                public string dmFormName;
                public short dmLogPixels;
                public int dmBitsPerPel;
                public int dmPelsWidth;
                public int dmPelsHeight;
                public int dmDisplayFlags;
                public int dmDisplayFrequency;
                public int dmICMMethod;
                public int dmICMIntent;
                public int dmMediaType;
                public int dmDitherType;
                public int dmReserved1;
                public int dmReserved2;
                public int dmPanningWidth;
                public int dmPanningHeight;
            }
        }
"@

  # Map state to numerical orientation
  $orientationMap = @{
    'u' = 0  # Landscape
    'l' = 1  # Portrait
    'd' = 2  # Landscape [Flipped]
    'r' = 3  # Portrait [Flipped]
  }

  $rorientationMap = @{}
  $orientationMap.GetEnumerator() | ForEach-Object { $rorientationMap[$_.Value] = $_.Key }
  # Validate the state parameter
  if (-not $orientationMap.ContainsKey($state)) {
    Write-Error "Invalid orientation state. Please use 'u', 'l', 'd', or 'r'."
    return
  }

  $newOrientation = $orientationMap[$state]

  # Get the target monitor
  $monitors = [System.Windows.Forms.Screen]::AllScreens
  Write-Host "Detected $($monitors.Count) monitor(s)"

  if ($monitors.Count -eq 0) {
    Write-Error "No monitors detected. This script may require elevated privileges."
    return
  }

  if ($screen -lt 1 -or $screen -gt $monitors.Count) {
    Write-Error "Invalid screen number. Please choose a number between 1 and $($monitors.Count)."
    return
  }
  
  $targetMonitor = $monitors[$screen - 1]
  
  # Prepare the DEVMODE structure
  $dm = New-Object ScreenRotation+DEVMODE
  $dm.dmSize = [System.Runtime.InteropServices.Marshal]::SizeOf($dm)
  $dm.dmDeviceName = $targetMonitor.DeviceName
  Write-Host "Selected Monitor $($screen)"
  Write-Host "Selected $($targetMonitor.DeviceName)"
  
  # Get the current display settings
  $enumResult = [ScreenRotation]::EnumDisplaySettings($targetMonitor.DeviceName, -1, [ref]$dm)
  if ($enumResult -eq 0) {
    Write-Error "Failed to get current display settings. Error code: $($enumResult)"
    return
  }

  Write-Host "Current orientation: $($rorientationMap[$dm.dmDisplayOrientation])"
  Write-Host "Attempting to set orientation state to: $state"

  # If the new orientation requires a swap of width and height
  if (($dm.dmDisplayOrientation -eq 0 -or $dm.dmDisplayOrientation -eq 2) -and ($newOrientation -eq 1 -or $newOrientation -eq 3)) {
    $temp = $dm.dmPelsWidth
    $dm.dmPelsWidth = $dm.dmPelsHeight
    $dm.dmPelsHeight = $temp
  }
  elseif (($dm.dmDisplayOrientation -eq 1 -or $dm.dmDisplayOrientation -eq 3) -and ($newOrientation -eq 0 -or $newOrientation -eq 2)) {
    $temp = $dm.dmPelsHeight
    $dm.dmPelsHeight = $dm.dmPelsWidth
    $dm.dmPelsWidth = $temp
  }

  # Set the new orientation
  $dm.dmDisplayOrientation = $newOrientation

  # Apply the new settings
  $result = [ScreenRotation]::ChangeDisplaySettingsEx($targetMonitor.DeviceName, [ref]$dm, [IntPtr]::Zero, 0, [IntPtr]::Zero)

  switch ($result) {
    0 { Write-Host "Screen orientation changed successfully." }
    1 { Write-Warning "The computer must be restarted for the graphics mode to work." }
    -1 { Write-Error "The display driver failed the specified graphics mode." }
    -2 { Write-Error "The graphics mode is not supported. This could be due to hardware limitations or driver issues." }
    -3 { Write-Error "Unable to write settings to the registry." }
    -4 { Write-Error "An invalid set of flags was passed in." }
    -5 { Write-Error "An invalid parameter was passed in. This can include an invalid flag or combination of flags." }
    -6 { Write-Error "The settings change was unsuccessful because the system is DualView capable." }
    default { Write-Error "An unknown error occurred. Error code: $result" }
  }
}
