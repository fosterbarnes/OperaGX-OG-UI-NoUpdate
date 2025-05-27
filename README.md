# OperaGX-OG-UI-NoUpdate
Installs Opera GX 109.0.5097.142 for Windows and disables auto-update. This is not the latest version of Opera GX with the old UI, but it subjectively feels smoother than versions 112.0.5197.60-115.0.5322.124 

# How it Works
## Automatic Install (Windows 10/11):
1. Open Windows Powershell or Powershell 7 as administrator (search windows for "powershell". Right-click "Windows Powershell" and open as administrator)
2. Copy the following then paste by right clicking the Powershell window. Press 'a', 'enter', then 'enter' again
  ```
  Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass; iex (irm https://is.gd/OperaGX_OG_UI_109)
  ```
3. Follow the on screen guide

  <details>
  <summary>Automatic Install Alternative</summary>

  Alternatively, download [OperaGX_109.0.5097_NoUpdateInstaller.ps1](https://github.com/fosterbarnes/OperaGX-OG-UI-NoUpdate/releases/download/1.0/OperaGX_109.0.5097_NoUpdateInstaller.ps1) from [Releases](https://github.com/fosterbarnes/OperaGX-OG-UI-NoUpdate/releases),   Copy the following then paste by right clicking the Powershell window. Press 'a', 'enter', then 'enter' again
  ```
  Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass; cd "$HOME\Downloads"; ./OperaGX_109.0.5097_NoUpdateInstaller.ps1
  ```

  </details>

## Manual Install (Windows 10/11):
  Please uninstall Opera GX before continuing. I recommend backing up your passwords, bookmarks, and user data. Select 'Delete my Opera user data' when uninstalling. Profiles from newer versions of Opera GX may work, but a warning message will pop up every time the   program opens. If you're okay with this, leave this box unticked.
  
 1. Download Opera 109.0.5097.142 from [https://ftp.opera.com/ftp/pub/opera_gx/109.0.5097.142/win/Opera_GX_109.0.5097.142_Setup_x64.exe](https://ftp.opera.com/ftp/pub/opera_gx/109.0.5097.142/win/Opera_GX_109.0.5097.142_Setup_x64.exe)
 2. Right click `Opera_GX_109.0.5097.142_Setup_x64.exe` and select "Create Shortcut" (On Windows 11, select "Show more options" to see this)
 3. Right click the newly created shortcut (`Opera_GX_109.0.5097.142_Setup_x64.exe - Shortcut`) and select "Properties"
 4. To the right of "Target", add
  ```
   --launchopera=0
  ```
  then click "OK". Make sure there is a space between `...Setup_x64.exe` and `--launchopera=0`
  `Ex: C:\Users\Foster\Downloads\Opera_GX_109.0.5097.142_Setup_x64.exe --launchopera=0`
  
  ![explorer_8UAjXSzsJD](https://github.com/user-attachments/assets/f6f149bf-f10e-468a-81b0-7a4a30cc0551)
  
  5. Run this new shortcut by double clicking it (`Opera_GX_109.0.5097.142_Setup_x64.exe - Shortcut`). Install Opera GX
  6. When the installer closes, find the `Opera GX Browser` shortcut on your desktop. Right-click it and select "Properties"
  7. To the right of "Target", add 
  ```
   --disable-update
  ```
  then click "OK". Make sure there is a space between ...\launcher.exe" and --disable-update
 `Ex: "C:\Users\Foster\AppData\Local\Programs\Opera GX\launcher.exe" --disable-update`
  
  ![explorer_JBzroDVJW9](https://github.com/user-attachments/assets/4eff7e85-d182-45d3-bfe9-191086803f57)
  
  8. Press Win+R (Windows key & 'R' at the same time). Copy and paste:
  ```
  %USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs
  ```
  then press enter.
  
  9. Find `Opera GX Browser` then right-click it and select properties
  10. To the right of "Target", add 
  ```
   --disable-update
  ```
  then click "OK". Make sure there is a space between `...\launcher.exe"` and `--disable-update`
  `Ex: "C:\Users\Foster\AppData\Local\Programs\Opera GX\launcher.exe" --disable-update`
  
  ![explorer_JBzroDVJW9](https://github.com/user-attachments/assets/4eff7e85-d182-45d3-bfe9-191086803f57)
  
  11. Press Win+R (Windows key & 'R' at the same time). Copy and paste:
  ```
  %LocalAppData%\Programs\Opera GX\109.0.5097.142
  ```
  then press enter.
  
  12. Rename `opera_autoupdate.exe` to `opera_autoupdate.exe.off` (If you just see opera_autoupdate with no ".exe", click "View" in file explorer and tick the box that says "File name extensions")
  13. Optionally, rename `opera_gx_splash.exe` to `opera_gx_splash.exe.off` if you prefer the splash screen to be disabled
  14. Search Windows for "task scheduler" and open it. If you don't see any tasks, click "Task Scheduler Library. Right-click and delete both OperaGX tasks.

  All done, Enjoy the OG UI with auto-update disabled! If you made a backup of your bookmarks/passwords, you should restore those now.
