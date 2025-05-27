$Host.UI.RawUI.WindowTitle = "OperaGX_109.0.5097_NoUpdateInstaller"

#Set background color, get console size, and clear the console with background color
[System.Console]::BackgroundColor = [System.ConsoleColor]::Black
[System.Console]::ForegroundColor = [System.ConsoleColor]::White
$width = [System.Console]::WindowWidth
$height = [System.Console]::WindowHeight
for ($i = 0; $i -lt $height; $i++) {
    Write-Host (" " * $width)
}

$installURL = "https://ftp.opera.com/ftp/pub/opera_gx/109.0.5097.142/win/Opera_GX_109.0.5097.142_Setup_x64.exe"
$installerEXE = "$env:USERPROFILE\Downloads\Opera_GX_109.0.5097.142_Setup_x64.exe"
$installerLNK = "$env:USERPROFILE\Downloads\Opera_GX_109.0.5097.142_Setup_x64.lnk"
$installerShortcutArg = "--launchopera=0"
$expectedHash = "fc869c764b9dc20abab60b104a559b197f606b9fffa0c6175959357669f67cee"
$desktopShortcut = Join-Path ([Environment]::GetFolderPath("Desktop")) "Opera GX Browser.lnk"
$startMenuProgramsPath = Join-Path $env:APPDATA "Microsoft\Windows\Start Menu\Programs"

#Uninstall warning
Write-Host "Please uninstall Opera GX before continuing. I recommend backing up your passwords, bookmarks, and user data. Select 'Delete my Opera user data' when uninstalling."
Write-Host "(Profiles from newer versions of Opera GX may work, but a warning message will pop up every time the program opens. If you're okay with this, leave this box unticked)"
Write-Host "`nPress any key to download Opera GX 109.0.5097.142..." -NoNewline -ForegroundColor Yellow
[void][System.Console]::ReadKey($true); Write-Host "`n"

#Check if $installerEXE exists. If it does, continue. If not, download it.
if (Test-Path $installerEXE) {
    Write-Host "Found existing installer at: $installerEXE"
} else {
    #Download OperaGX
    Write-Host  "Downloading from: $installURL `nSaving to: $installerEXE"
    Start-BitsTransfer -Source "$installURL" -Destination "$installerEXE"
}

#Check hash of $installerEXE, compare to $expectedHash
$actualHash = (Get-FileHash $installerEXE -Algorithm SHA256).Hash
if ($actualHash -eq $expectedHash) {
    Write-Host "`nFile hash matches. OperaGX has been downloaded successfully." -ForegroundColor Green
    Write-Host "(Expected hash: https://www.virustotal.com/gui/file/fc869c764b9dc20abab60b104a559b197f606b9fffa0c6175959357669f67cee)" -ForegroundColor Green
} else {
    Write-Host "`nFile hash mismatch! Download may be corrupted or tampered. Download and install manually using the link below:`n$installURL`n`nAnd follow the manual install guide:`nhttps://github.com/fosterbarnes/OperaGX-OG-UI-NoUpdate/tree/main#manual-install" -ForegroundColor Red
    Write-Host "`nPress any key to exit..." -NoNewline -ForegroundColor Yellow
    [void][System.Console]::ReadKey($true)
    exit 1
}

#Create shortcut with arguments. Validate its creation
Write-Host "`nCreating installer shortcut with argument: $installerShortcutArg (Prevents OperaGX from opening after install)"
$shortcutPath = $installerLNK
$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($shortcutPath)
$Shortcut.TargetPath = $installerEXE
$Shortcut.Arguments = $installerShortcutArg
$Shortcut.WorkingDirectory = Split-Path $installerEXE
$Shortcut.WindowStyle = 1
$Shortcut.Description = "Install Opera GX without launching it"
$Shortcut.Save()
if (Test-Path $shortcutPath) {
    Write-Host "Shortcut created successfully: $shortcutPath" -ForegroundColor Green
} else {
    Write-Host "Failed to create shortcut. Download and install manually using the link below:`n$installURL`n`nAnd follow the manual install guide:`nhttps://github.com/fosterbarnes/OperaGX-OG-UI-NoUpdate/tree/main#manual-install" -ForegroundColor Red
    Write-Host "Press any key to exit..." -NoNewline -ForegroundColor Yellow
    [void][System.Console]::ReadKey($true)
    exit 1
}

#Install Opera GX
Write-Host "`nPress any key to start installing OperaGX. Go through the installer normally and COME BACK to this window when finished. Use the default install location (C:\Users\*Username*\AppData\Local\Programs\Opera GX)" -NoNewline -ForegroundColor Yellow
[void][System.Console]::ReadKey($true)
Start-Process -FilePath "$installerLNK"

#Post-Install. Add "--disable-update" to all opera shortcuts
Write-Host "`n`nPress any key AFTER the installer window closes..." -NoNewline -ForegroundColor Yellow
[void][System.Console]::ReadKey($true); Write-Host "`n"

#Append desktop and start menu shortcuts with "--disable-update"
Write-Host "Appending shortcuts with argument: --disable-update (Prevents OperaGX from updating itself when launched)`n"
$WshShell2 = New-Object -ComObject WScript.Shell
foreach ($startMenuShortcutPath in @($desktopShortcut) + 
    (Get-ChildItem $startMenuProgramsPath -Filter "*.lnk" -Recurse | Where-Object { $_.BaseName -like "*Opera GX Browser*" } | Select-Object -ExpandProperty FullName)) {
    if (-not (Test-Path $startMenuShortcutPath)) {
        Write-Host "Shortcut not found: $startMenuShortcutPath. Download and install manually using the link below:`n$installURL`n`nAnd follow the manual install guide:`nhttps://github.com/fosterbarnes/OperaGX-OG-UI-NoUpdate/tree/main#manual-install" -ForegroundColor Red
        Write-Host "Press any key to exit..." -NoNewline -ForegroundColor Yellow
        [void][System.Console]::ReadKey($true)
        exit 1
    }
    $Shortcut2 = $WshShell2.CreateShortcut($startMenuShortcutPath)
    if ($Shortcut2.Arguments -and $Shortcut2.Arguments.Contains("--disable-update")) {
        Write-Host "Shortcut already has --disable-update: $startMenuShortcutPath" -ForegroundColor Green
        continue
    }
    if ([string]::IsNullOrWhiteSpace($Shortcut2.Arguments)) {
        $Shortcut2.Arguments = "--disable-update"
    } else {
        $Shortcut2.Arguments = $Shortcut2.Arguments.Trim() + " --disable-update"
    }
    $Shortcut2.Save()
    Write-Host "Updated shortcut: $startMenuShortcutPath" -ForegroundColor Green
}

#Disable opera_autoupdate.exe
$opera_autoupdate = Join-Path $env:LOCALAPPDATA "Programs\Opera GX\109.0.5097.142\opera_autoupdate.exe"
Write-Host "`nDisabling opera_autoupdate.exe..."
if (Test-Path $opera_autoupdate) { 
    Rename-Item $opera_autoupdate "$opera_autoupdate.off"
    Write-Host "Renamed opera_autoupdate.exe to opera_autoupdate.exe.off" -ForegroundColor Green
} else { 
    Write-Host "opera_autoupdate.exe not found: $opera_autoupdate. Download and install manually using the link below:`n$installURL`n`nAnd follow the manual install guide:`nhttps://github.com/fosterbarnes/OperaGX-OG-UI-NoUpdate/tree/main#manual-install" -ForegroundColor Red
    Write-Host "Press any key to exit..." -NoNewline -ForegroundColor Yellow
    [void][System.Console]::ReadKey($true)
    exit 1
    }

#Disable opera_gx_splash.exe
[System.Console]::ForegroundColor = [System.ConsoleColor]::Yellow
$response = Read-Host "`nWould you like to disable the Opera GX splash screen? (Y/N)"
[System.Console]::ForegroundColor = [System.ConsoleColor]::White
if ($response -match '^[Yy]$') {
    $opera_gx_splash = Join-Path $env:LOCALAPPDATA "Programs\Opera GX\109.0.5097.142\opera_gx_splash.exe"
    Write-Host "`nDisabling opera_gx_splash.exe..."
        if (Test-Path $opera_gx_splash) { 
        Rename-Item $opera_gx_splash "$opera_gx_splash.off"
        Write-Host "Renamed opera_gx_splash.exe to opera_gx_splash.off" -ForegroundColor Green
        } else { 
            Write-Host "opera_gx_splash not found: $opera_gx_splash. Download and install manually using the link below:`n$installURL`n`nAnd follow the manual install guide:`n https://github.com/fosterbarnes/OperaGX-OG-UI-NoUpdate/tree/main#manual-install" -ForegroundColor Red
            Write-Host "Press any key to exit..." -NoNewline
            [void][System.Console]::ReadKey($true)
            exit 1
    }
}

#Task scheduler walkthrough
Write-Host "`nNext, we need to open task scheduler and delete two entries (Opera GX scheduled assistant Autoupdate & Opera GX scheduled Autoupdate). You'll need to right click on these two entries and select 'Delete'. If you don't see any tasks, click 'Task Scheduler Library' in the top left."
Write-Host "Press any key to open task scheduler. COME BACK to this window when finished..." -NoNewline -ForegroundColor Yellow; Write-Host "`n" 
[void][System.Console]::ReadKey($true)
Start-Process taskschd.msc
Write-Host "Press any key when done with task scheduler..." -NoNewline -ForegroundColor Yellow; Write-Host "`n"
[void][System.Console]::ReadKey($true)

#Cleanup
[System.Console]::ForegroundColor = [System.ConsoleColor]::Yellow
$response2 = Read-Host "Would you like to cleanup installer files? (Y/N)"
[System.Console]::ForegroundColor = [System.ConsoleColor]::White
if ($response2 -match '^[Yy]$') {
    $shell = New-Object -ComObject Shell.Application
    Write-Host "`nMoving $installerEXE to the recycle bin..."
    $shell.Namespace((Split-Path $installerEXE)).ParseName((Split-Path $installerEXE -Leaf)).InvokeVerb("delete")
    if (Test-Path $installerEXE) {
        Write-Host "$installerEXE failed to be recycled." -ForegroundColor Red
    } else{
        Write-Host "$installerEXE has been recycled."-ForegroundColor Green
    }
    Write-Host "Moving $installerLNK to the recycle bin..."
    $shell.Namespace((Split-Path $installerLNK)).ParseName((Split-Path $installerLNK -Leaf)).InvokeVerb("delete")
        if (Test-Path $installerLNK) {
        Write-Host "$installerLNK failed to be recycled."-ForegroundColor Red
    } else{
        Write-Host "$installerLNK has been recycled."-ForegroundColor Green
    }
}

#Done
Write-Host "`nOpera GX 109.0.5097.142 has been successfully installed with auto-update disabled. Enjoy the OG UI!!" -ForegroundColor Green
Write-Host "If you made a backup of your bookmarks/passwords, you can restore those now" -ForegroundColor Green
Write-Host "`nPress any key to exit..." -NoNewline -ForegroundColor Yellow
[void][System.Console]::ReadKey($true)
exit