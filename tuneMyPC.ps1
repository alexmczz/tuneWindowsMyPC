$date = Get-Date
$user_update = Read-Host "Would you like to install windows update module? y|n: "

if($user_update.ToLower() -eq 'y'){
    
    install-module PSwindowsUpdate
    Update-MpSignature
    Write-Host 'Windows update Module Installed $date' -ForegroundColor Yellow 
}else{
    Write-Host "oki :) " -ForegroundColor Green
}

$install_update = Read-Host "Would you like to contiue? y|n: "

if($install_update.ToLower() -eq 'y'){
    Write-Host 'Retrieving update...' -ForegroundColor Yellow
    Get-WindowsUpdate
    Write-Host 'Update Recieved!' -ForegroundColor Green
    Write-Host 'Update Start' -ForegroundColor White -BackgroundColor Gray
    Install-WindowsUpdate
    write-host 'Update Complete!' -ForegroundColor Yellow
}else{
    Write-host "oki :)" -ForegroundColor Green 
}


$fileSys_scan = Read-Host 'Would you like to tune up your system? y|n: '
if($fileSys_scan.ToLower() -eq 'y'){
    Write-Host 'FileSystem scan start' -ForegroundColor White -BackgroundColor Yellow
    sfc /scannow
    Optimize-Volume -DriveLetter C -Analyze -Verbose
    Optimize-Volume -DriveLetter C -Defrag -Verbose
    Optimize-Volume -DriveLetter C -ReTrim -Verbose
    Write-Host 'FileSystem scan complete' -ForegroundColor white -BackgroundColor Green
}else{
    Write-Host 'oki' -ForegroundColor Yellow
}

$get_secure = Read-Host "Would you like to perform quick security scan? y|n: "
if($get_secure.ToLower() -eq 'y'){
    $get_sec_type = Read-Host "Would you like a quick or full scan? 1|2: "
    if($get_sec_type -eq '1'){
        Start-MpScan -ScanType QuickScan
    }else{
    Start-MpScan -ScanType FullScan
    }
}else{
    write-host 'oh oki ' -ForegroundColor Red
}
