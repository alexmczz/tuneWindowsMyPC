$date = Get-Date 

function step_by_step_tune {
    <#
    ******************************************************
    step by step tune up on pc, starts with installing
    modules needed through tune up, and asks you manually
    what scans or updates you would like to do.
    ******************************************************
    #>
    $user_update = Read-Host "Would you like to install windows update module? y|n: "

    if($user_update.ToLower() -eq 'y') {
        try {
            # installs windows update module and security scans
            install-module PSwindowsUpdate -ErrorAction Stop
            Update-MpSignature -ErrorAction Stop
            Write-Host 'Windows update Module Installed ' $date -ForegroundColor Yellow 
        }
        catch {
            Write-Error "An error occurred while installing windows update module or updating signatures: $_"
        }
    } else {
        Write-Host "oki :)" -ForegroundColor Green
    }

    $install_update = Read-Host "Would you like to continue? y|n: "

    if($install_update.ToLower() -eq 'y') {
        try {
            Write-Host 'Retrieving update...' -ForegroundColor Yellow
            Get-WindowsUpdate -ErrorAction Stop
            Write-Host 'Update Received!' -ForegroundColor Green
            Write-Host 'Update Start' -ForegroundColor White -BackgroundColor Gray
            Install-WindowsUpdate -ErrorAction Stop
            Write-Host 'Update Complete!' -ForegroundColor Yellow
        }
        catch {
            Write-Error "An error occurred while retrieving or installing updates: $_"
        }
    } else {
        Write-host "oki :)" -ForegroundColor Green 
    }

    $fileSys_scan = Read-Host 'Would you like to tune up your system? y|n: '
    if($fileSys_scan.ToLower() -eq 'y') {
        try {
            Write-Host 'FileSystem scan start ' $date -ForegroundColor White -BackgroundColor Yellow
            # scans file system defrags and trims C drive(c is most likely the boot sector)
            sfc /scannow
            Optimize-Volume -DriveLetter C -Analyze -Verbose
            Optimize-Volume -DriveLetter C -Defrag -Verbose
            Optimize-Volume -DriveLetter C -ReTrim -Verbose
            Write-Host 'FileSystem scan complete' -ForegroundColor White -BackgroundColor Green
        }
        catch {
            Write-Error "An error occurred while scanning and optimizing the file system: $_"
        }
    } else {
        Write-Host 'oki' -ForegroundColor Yellow
    }

    $get_secure = Read-Host "Would you like to perform quick security scan? y|n: "
    if($get_secure.ToLower() -eq 'y') {
        $get_sec_type = Read-Host "Would you like a quick or full scan? 1|2: "
        if($get_sec_type -eq '1') {
            try {
                # quick scan
                Start-MpScan -ScanType QuickScan -ErrorAction Stop
                Write-Host "Quick Scan Finished" -ForegroundColor Green
            }
            catch {
                Write-Error "An error occurred while performing quick scan: $_"
            }
        } else {
            try {
                # full scan
                Start-MpScan -ScanType FullScan -ErrorAction Stop
                Write-Host "Full Scan Finished" -ForegroundColor Green
            }
            catch {
                Write-Error "An error occurred while performing full scan: $_"
            }
        }
    } else {
        write-host 'oh oki ' -ForegroundColor Red
    }
}

function automate_tune {

    <#
    ******************************************************
    automated integrity scans, updates and, security scans
    ******************************************************
    #>

    #grabs and runs windows updates
    Write-Host 'Retrieving update...' -ForegroundColor Yellow
    Get-WindowsUpdate
    Write-Host 'Update Recieved!' -ForegroundColor Green
    Write-Host 'Update Start' -ForegroundColor White -BackgroundColor Gray
    Install-WindowsUpdate
    write-host 'Update Complete!' -ForegroundColor Yellow
    Write-Host 'FileSystem scan start '$date -ForegroundColor White 
    -BackgroundColor Yellow
    #scans file system defrags and trims C drive(c is most likely the boot sector)
    sfc /scannow
    Optimize-Volume -DriveLetter C -Analyze -Verbose
    Optimize-Volume -DriveLetter C -Defrag -Verbose
    Optimize-Volume -DriveLetter C -ReTrim -Verbose
    Start-MpScan -ScanType FullScan
    Write-Host "Scan Finished" -ForegroundColor Green
    ipconfig /flushdns

}

function power_enhance{
    #sets power config to ultimate performance
    powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
    #restart pc to initialize changes made to the system
    $userRes = Read-Host "Would you like to restart now? y|n: "
    if($userRes.ToLower() -eq 'y'){
        write-host "restarting your pc now" -ForegroundColor Green
        #restarts pc without wait time
        shutdown -r -t 0
    }else{
        write-host "Don't forget to restart your pc to initialize the power config changes" -ForegroundColor Yellow
    }
}


$currentuser = $env:USERNAME
$currentuserprofile = $env:USERPROFILE

if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "User '$currentuser' running script as administrator from '$currentuserprofile'."
    $user_response = read-host "Press Enter to continue or any key to quit:"
    if($user_response -eq ''){
        $choice = read-host "Press Enter 1 for manual tuneup 2 for for auto tuneup"
        if($choice -eq '1'){
            step_by_step_tune
            write-host "Setting Power to Ultimate Performance"
            power_enhance
        }else{
            automate_tune
            power_enhance
        }
    }else{
        Write-Host "Good bye!" -ForegroundColor Yellow
    }
} else {
    Write-Warning "User '$currentuser' does not have administrator privileges. Please run this script as an administrator."
}

