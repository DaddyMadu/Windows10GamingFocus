@echo off
title Pus
:: Admin check
net session >nul 2>&1
if %errorLevel% neq 0 (
    cls
    echo You must have administrator rights to continue...
    pause
    exit
)
cls
cd %systemroot%\system32
echo.
echo WARNING! MAKE RESTORE POINT BEFORE DEBLOATING
echo ***********************************
echo * *                             * *
echo.   Want to make a restore point?
echo * *                             * *
echo ***********************************
echo WARNING! MAKE RESTORE POINT BEFORE DEBLOATING
echo.
set /p choice=Enter choice [Y/N]: 
if /i "%choice%"=="Y" goto apply
if /i "%choice%"=="N" goto next
:apply
title Creating restore point...
echo Creating restore point...
:: wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Before speedup", 100, 12 > nul Some problem with it idk what
:: powershell -command Checkpoint-Computer -Description 'Before Speedup'"
powershell -command Checkpoint-Computer -Description "Before Speedup" -RestorePointType MODIFY_SETTINGS
if %errorLevel% neq 0 (
    echo ERROR! There was an error while creating a restore point.
    pause > nul
) else (
    echo Succesfully created restore point.
)
pause > nul
timeout /t 2 > nul
goto :next
:next
cls
echo Starting speedup...
title Pus
timeout /t 2 > nul
fsutil behavior set memoryusage 2
cls
timeout /t 2 > nul
cls
echo Hello! I want to recommend you a really good program for optimizing memory.
echo It will save RAM and enhance the overall Windows experience.
echo GitHub link: https://github.com/IgorMundstein/WinMemoryCleaner
echo Download link: https://github.com/IgorMundstein/WinMemoryCleaner/releases/latest/download/WinMemoryCleaner.exe
echo **************************
echo * *                    * *
echo.   Want to download it?
echo * *                    * *
echo **************************
echo. Press "Y" to apply.
echo. Press "N" to skip.
echo.

set /p choice=Enter choice [Y/N]:  
if /i "%choice%"=="Y" goto apply377
if /i "%choice%"=="N" goto next377

:apply377
cd /d "%~dp0"
cls
echo Downloading . . .
timeout /t 3 > nul
powershell -command "Invoke-WebRequest -Uri 'https://github.com/IgorMundstein/WinMemoryCleaner/releases/latest/download/WinMemoryCleaner.exe' -OutFile 'WinMemoryCleaner.exe'"
if %errorlevel% neq 0 (
    echo Error downloading the file. Please check your internet connection or try again later.
    pause
    exit
)
echo Downloaded! Filename: "WinMemoryCleaner.exe"
timeout /t 5 > nul
echo Recommended settings: Defaults + Run on startup + Start minimized + When the free memory is below 10% and every 2 hours
:next377
cls
echo *****************************
echo * *                       * *
echo.   Want to tweak registry?
echo * *                       * *
echo *****************************
echo. Press "Y" to apply.
echo. Press "N" to skip.
echo.
set /p choice=Enter choice [Y/N]:  
IF /I "%choice%"=="Y" goto apply
IF /I "%choice%"=="N" goto nextnoreg
echo.
:apply
REM ; To make Windows start faster
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /V HiberbootEnabled /T REG_dWORD /D 1 /F
REM ; Disable typing telemetry ;)
Powershell -Command "Get-ScheduledTask -TaskName Consolidator | Disable-ScheduledTask" >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackProgs" /d 0 /t REG_DWORD /f >nul
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\WcmSvc\wifinetworkmanager" /v "WiFiSenseCredShared" /d 0 /t REG_DWORD /f >nul
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\WcmSvc\wifinetworkmanager" /v "WiFiSenseOpen" /d 0 /t REG_DWORD /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Input\TIPC" /v "Enabled" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\SOFTWARE\Microsoft\Input\TIPC" /v "Enabled" /t REG_DWORD /d 0 /f >nul
schtasks /Change /TN "\Microsoft\Windows\Application Experience\AitAgent" /DISABLE >nul
schtasks /Change /TN "\Microsoft\Windows\Media Center\ehDRMInit" /DISABLE > nul
REM ; You're welcome for disabling these services you don't need
sc stop "diagnosticshub.standardcollector.service" > nul
sc config "diagnosticshub.standardcollector.service" start= disabled > nul
sc stop "DiagTrack" > nul
sc config "DiagTrack" start= disabled > nul
sc stop "ndu" > nul
sc config "ndu" start= disabled > nul
sc stop "RemoteRegistry" > nul
sc config "RemoteRegistry" start= disabled > nul
sc stop "Fax" > nul
sc config "Fax" start= disabled > nul
sc stop "fhsvc" > nul
sc config "fhsvc" start= disabled > nul
sc stop "pla" > nul
sc config "pla" start= disabled > nul
sc stop "WerSvc" > nul
sc config "WerSvc" start= disabled > nul
net stop "DusmSvc" > nul
sc stop "DusmSvc" > nul
sc config "DusmSvc" start= disabled > nul
sc stop "lfsvc" > nul
sc config "lfsvc" start= disabled > nul
sc stop "wercplsupport" > nul
sc config "wercplsupport" start= disabled > nul
sc stop "wlidsvc" > nul
sc config "wlidsvc" start= disabled > nul
sc stop "MapsBroker" > nul
sc config "MapsBroker" start= disabled > nul
sc stop "SEMgrSvc" > nul
sc config "SEMgrSvc" start= disabled > nul
sc stop "wisvc" > nul
sc config "wisvc" start= disabled > nul
sc stop "FontCache" > nul
sc config "FontCache" start= disabled > nul
sc stop "LSCNotify" > nul
sc config "LSCNotify" start= disabled > nul
sc stop "HpTouchpointAnalyticsService" > nul
sc config "HpTouchpointAnalyticsService" start= disabled > nul
sc stop "HPDiagsCap" > nul
sc config "HPDiagsCap" start= disabled > nul
sc stop "PhoneSvc" > nul
sc config "PhoneSvc" start= disabled > nul
sc stop "gupdate" > nul
sc config "gupdate" start= disabled > nul
sc stop "MozillaMaintenance" > nul
sc config "MozillaMaintenance" start= disabled > nul
REM ; LITTLE BCEDIT TWEAKS just for you :3
bcdedit /set useplatformclock No > nul
bcdedit /set useplatformtick No > nul
bcdedit /set disabledynamictick Yes > nul
bcdedit /set hypervisorlaunchtype off > nul
bcdedit /set firstmegabytepolicy UseAll > nul
bcdedit /set nolowmem Yes > nul
bcdedit /set allowedinmemorysettings 0 > nul
bcdedit /set tpmbootentropy ForceDisable > nul
bcdedit /set linearaddress57 OptOut > nul
bcdedit /set tscsyncpolicy Enhanced > nul
bcdedit /set nx AlwaysOff > nul
bcdedit /set bootmenupolicy legacy > nul
bcdedit /set isolatedcontext No > nul
cls
echo Want to disable WMPNetworkSvc service? (Windows Media Player Network Sharing Service)
echo.
set /p choice=Enter choice [Y/N]:  
IF /I "%choice%"=="Y" goto apply
IF /I "%choice%"=="N" goto 3548ezhrjg
echo.
:apply
sc stop "WMPNetworkSvc" > nul
sc config "WMPNetworkSvc" start= disabled > nul
:3548ezhrjg
cls
echo Want to disable WalletService service?
echo.
set /p choice=Enter choice [Y/N]:  
IF /I "%choice%"=="Y" goto apply
IF /I "%choice%"=="N" goto 3548ezhrjg124
echo.
:apply
sc stop "WalletService" > nul
sc config "WalletService" start= disabled > nul
:3548ezhrjg124
cls
echo Want to disable Bing search?
echo.
set /p choice=Enter choice [Y/N]:  
IF /I "%choice%"=="Y" goto apply
IF /I "%choice%"=="N" goto 3548ezhrjg12244
echo.
:apply
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d 0 /f > nul
:3548ezhrjg12244
echo Want to disable Xbox live network service and Xbox Live Auth Manager? (XboxNetApiSvc) Only needed when having an XBOX controller etc. XblAuthManager is needed when having an XBOX or if you want the XBOX program.
echo.
set /p choice=Enter choice [Y/N]:  
IF /I "%choice%"=="Y" goto apply
IF /I "%choice%"=="N" goto ainjd899aniojsd
echo.
:apply
sc stop "XblAuthManager" > nul
sc config "XblAuthManager" start= disabled > nul
sc stop "XboxNetApiSvc" > nul
sc config "XboxNetApiSvc" start= disabled > nul
:ainjd899aniojsd
cls
echo Want to uninstall Microsoft Edge? (The tool cant reinstall it)
echo.
set /p choice=Enter choice [Y/N]:  
IF /I "%choice%"=="Y" goto apply
IF /I "%choice%"=="N" goto 3548ezhrjg1241251
echo.
:apply
powershell "Get-AppxPackage -Name *MicrosoftEdge* | Remove-AppxPackage"
cls
echo Removing Registry entries . . . . .
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\MicrosoftEdgeElevationService" /v Start /t REG_DWORD /d 4 /f > nul
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Edge" /f > nul
:3548ezhrjg1241251
REM ; Some pre-hardening
reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v ChromeCleanupEnabled /t REG_SZ /d 0 /f > nul
reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v ChromeCleanupReportingEnabled /t REG_SZ /d 0 /f > nul
reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v MetricsReportingEnabled /t REG_SZ /d 0 /f > nul
set key624="HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\software_reporter_tool.exe"
reg query %key624% > nul 2>&1
if %errorlevel% neq 0 (
    reg add %key624% /f > nul
)
reg add %key624% /v Debugger /t REG_SZ /d "%windir%\System32\taskkill.exe" /f > nul
reg add "HKLM\SOFTWARE\Policies\Mozilla\Firefox" /v DisableTelemetry /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SOFTWARE\Policies\Mozilla\Firefox" /v DisableDefaultBrowserAgent /t REG_DWORD /d 1 /f > nul
reg add "HKCU\SOFTWARE\Microsoft\MediaPlayer\Preferences" /v UsageTracking /t REG_DWORD /d 0 /f > nul
reg add "HKCU\Software\Policies\Microsoft\WindowsMediaPlayer" /v PreventCDDVDMetadataRetrieval /t REG_DWORD /d 1 /f > nul
reg add "HKCU\Software\Policies\Microsoft\WindowsMediaPlayer" /v PreventMusicFileMetadataRetrieval /t REG_DWORD /d 1 /f > nul
reg add "HKCU\Software\Policies\Microsoft\WindowsMediaPlayer" /v PreventRadioPresetsRetrieval /t REG_DWORD /d 0 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\WMDRM" /v DisableOnline /t REG_DWORD /d 1 /f > nul
sc config WMPNetworkSvc start= disabled > nul
cls
cd %systemroot%\system32
echo ********************************************************************
echo * *                                                              * *
echo.   Want to debloat windows? (Remove automatically installed apps)
echo * *                                                              * *
echo ********************************************************************
echo. Press "Y" to apply
echo. Press "N" to skip
echo.
set /p choice=Enter choice [Y/N]: 
IF /I "%choice%"=="Y" goto apply
IF /I "%choice%"=="N" goto next
echo.
:apply
@echo off
REM ; Remove Background Tasks
reg delete "HKCR\Extensions\ContractId\Windows.BackgroundTasks\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y" /f > nul
reg delete "HKCR\Extensions\ContractId\Windows.BackgroundTasks\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0" /f > nul
reg delete "HKCR\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe" /f > nul
reg delete "HKCR\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy" /f > nul
reg delete "HKCR\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy" /f > nul
reg delete "HKCR\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy" /f > nul
REM ; Remove Windows File
reg delete "HKCR\Extensions\ContractId\Windows.File\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0" /f > nul
REM ; Remove Registry keys
reg delete "HKCR\Extensions\ContractId\Windows.Launch\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y" /f > nul
reg delete "HKCR\Extensions\ContractId\Windows.Launch\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0" /f > nul
reg delete "HKCR\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy" /f > nul
reg delete "HKCR\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy" /f > nul
reg delete "HKCR\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy" /f > nul
REM ; Remove Scheduled Tasks
reg delete "HKCR\Extensions\ContractId\Windows.PreInstalledConfigTask\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe" /f > nul
REM ; Remove Windows Protocol Keys
reg delete "HKCR\Extensions\ContractId\Windows.Protocol\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0" /f > nul
reg delete "HKCR\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy" /f > nul
reg delete "HKCR\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy" /f > nul
reg delete "HKCR\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy" /f > nul
REM ; Remove Windows Share Target
reg delete "HKCR\Extensions\ContractId\Windows.ShareTarget\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0" /f > nul
REM ; DELETE APPX PACKAGES
REM ; Remove specific AppX packages
powershell "Get-AppxPackage -Name Microsoft.BingNews | Remove-AppxPackage"
powershell "Get-AppxPackage -Name Microsoft.GetHelp | Remove-AppxPackage"
powershell "Get-AppxPackage -Name Microsoft.Getstarted | Remove-AppxPackage"
powershell "Get-AppxPackage -Name Microsoft.Messaging | Remove-AppxPackage"
powershell "Get-AppxPackage -Name Microsoft.Microsoft3DViewer | Remove-AppxPackage"
powershell "Get-AppxPackage -Name Microsoft.MicrosoftOfficeHub | Remove-AppxPackage"
powershell "Get-AppxPackage -Name Microsoft.MicrosoftSolitaireCollection | Remove-AppxPackage"
powershell "Get-AppxPackage -Name Microsoft.NetworkSpeedTest | Remove-AppxPackage"
powershell "Get-AppxPackage -Name Microsoft.News | Remove-AppxPackage"
powershell "Get-AppxPackage -Name Microsoft.Office.Lens | Remove-AppxPackage"
powershell "Get-AppxPackage -Name Microsoft.Office.OneNote | Remove-AppxPackage"
powershell "Get-AppxPackage -Name Microsoft.Office.Sway | Remove-AppxPackage"
powershell "Get-AppxPackage -Name Microsoft.OneConnect | Remove-AppxPackage"
powershell "Get-AppxPackage -Name Microsoft.People | Remove-AppxPackage"
powershell "Get-AppxPackage -Name Microsoft.Print3D | Remove-AppxPackage"
powershell "Get-AppxPackage -Name Microsoft.RemoteDesktop | Remove-AppxPackage"
powershell "Get-AppxPackage -Name Microsoft.SkypeApp | Remove-AppxPackage"
powershell "Get-AppxPackage -Name Microsoft.StorePurchaseApp | Remove-AppxPackage"
powershell "Get-AppxPackage -Name Microsoft.Office.Todo.List | Remove-AppxPackage"
powershell "Get-AppxPackage -Name Microsoft.Whiteboard | Remove-AppxPackage"
powershell "Get-AppxPackage -Name Microsoft.WindowsAlarms | Remove-AppxPackage"
powershell "Get-AppxPackage -Name microsoft.windowscommunicationsapps | Remove-AppxPackage"
powershell "Get-AppxPackage -Name Microsoft.WindowsFeedbackHub | Remove-AppxPackage"
powershell "Get-AppxPackage -Name Microsoft.WindowsMaps | Remove-AppxPackage"
powershell "Get-AppxPackage -Name Microsoft.WindowsSoundRecorder | Remove-AppxPackage"
powershell "Get-AppxPackage -Name Microsoft.Xbox.TCUI | Remove-AppxPackage"
powershell "Get-AppxPackage -Name Microsoft.XboxApp | Remove-AppxPackage"
powershell "Get-AppxPackage -Name Microsoft.XboxGameOverlay | Remove-AppxPackage"
powershell "Get-AppxPackage -Name Microsoft.XboxIdentityProvider | Remove-AppxPackage"
powershell "Get-AppxPackage -Name Microsoft.XboxSpeechToTextOverlay | Remove-AppxPackage"
powershell "Get-AppxPackage -Name Microsoft.ZuneMusic | Remove-AppxPackage"
powershell "Get-AppxPackage -Name Microsoft.ZuneVideo | Remove-AppxPackage"
echo Halfway there . . . . .
REM ; Remove Sponsored Windows 10 AppX Apps
powershell "Get-AppxPackage *EclipseManager* | Remove-AppxPackage"
powershell "Get-AppxPackage *ActiproSoftwareLLC* | Remove-AppxPackage"
powershell "Get-AppxPackage *AdobeSystemsIncorporated.AdobePhotoshopExpress* | Remove-AppxPackage"
powershell "Get-AppxPackage *Duolingo-LearnLanguagesforFree* | Remove-AppxPackage"
powershell "Get-AppxPackage *PandoraMediaInc* | Remove-AppxPackage"
powershell "Get-AppxPackage *CandyCrush* | Remove-AppxPackage"
powershell "Get-AppxPackage *BubbleWitch3Saga* | Remove-AppxPackage"
powershell "Get-AppxPackage *Wunderlist* | Remove-AppxPackage"
powershell "Get-AppxPackage *Flipboard* | Remove-AppxPackage"
powershell "Get-AppxPackage *Twitter* | Remove-AppxPackage"
powershell "Get-AppxPackage *Facebook* | Remove-AppxPackage"
powershell "Get-AppxPackage *Spotify* | Remove-AppxPackage"
powershell "Get-AppxPackage *Minecraft* | Remove-AppxPackage"
powershell "Get-AppxPackage *Royal Revolt* | Remove-AppxPackage"
powershell "Get-AppxPackage *Sway* | Remove-AppxPackage"
powershell "Get-AppxPackage *Speed Test* | Remove-AppxPackage"
powershell "Get-AppxPackage *Dolby* | Remove-AppxPackage"
REM ; Disable scheduled tasks
echo Disabling unnecessary scheduled tasks . . . . .
timeout /t 3 > nul
powershell "Disable-ScheduledTask -TaskName XblGameSaveTaskLogon"
powershell "Disable-ScheduledTask -TaskName XblGameSaveTask"
powershell "Disable-ScheduledTask -TaskName Consolidator"
powershell "Disable-ScheduledTask -TaskName UsbCeip"
powershell "Disable-ScheduledTask -TaskName DmClient"
powershell "Disable-ScheduledTask -TaskName DmClientOnScenarioDownload"
reg add HKCU\Software\Microsoft\Siuf /f > nul
reg add HKCU\Software\Microsoft\Siuf\Rules /f > nul
reg add HKCU\Software\Microsoft\Siuf\Rules\PeriodInNanoSeconds /v PeriodInNanoSeconds /t REG_DWORD /d 0 /f > nul
echo DONE! SUCCESSFULLY RAN DEBLOATER!
timeout /t 5 > nul
:next
cls
timeout /t 2 > nul
cls
cls
cd %systemroot%\system32
echo ***************************************
echo * *                                 * *
echo.   Want to disable power throttling?
echo * *                                 * *
echo ***************************************
echo. Press "Y" to apply
echo. Press "N" to skip
echo.
set /p choice=Enter choice [Y/N]: 
IF /I "%choice%"=="Y" goto apply
IF /I "%choice%"=="N" goto next
echo.
:apply
REM ; Disables Power Throttling
reg add "HKLM\SYSTEM\ControlSet001\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d "1" /f
reg add "HKLM\SYSTEM\ControlSet002\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d "1" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d "1" /f
goto :next
:next
cls
timeout /t 2 > nul
cls
cd %systemroot%\system32
echo ******************************************************
echo * *                                                * *
echo.   Want to display highly detailed status messages?
echo * *                                                * *
echo ******************************************************
echo. Press "Y" to apply
echo. Press "N" to skip
echo.
set /p choice=Enter choice [Y/N]: 
IF /I "%choice%"=="Y" goto apply
IF /I "%choice%"=="N" goto next
echo.
:apply
REM ; Display highly detailed status messages
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "VerboseStatus" /t REG_DWORD /d "1" /f
goto :next
:next
cls
timeout /t 2 > nul
cls
cd %systemroot%\system32
echo *********************************************************
echo * *                                                   * *
echo.   Want to enable hardware accelerated GPU scheduling?
echo * *                                                   * *
echo *********************************************************
echo. Press "Y" to apply
echo. Press "N" to skip
echo.
set /p choice=Enter choice [Y/N]: 
IF /I "%choice%"=="Y" goto apply
IF /I "%choice%"=="N" goto next
echo.
:apply
REM ; Enabling Hardware Accelerated GPU Scheduling
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /F /V "HwSchMode" /T REG_DWORD /d "2"
goto :next
:next
cls
timeout /t 2 > nul
cd %systemroot%\system32
echo *************************************
echo * *                               * *
echo.   Want to tweak GPU? (Video card)
echo * *                               * *
echo *************************************
echo. Press "Y" to apply
echo. Press "N" to skip
echo.
set /p choice=Enter choice [Y/N]: 
IF /I "%choice%"=="Y" goto apply
IF /I "%choice%"=="N" goto next
echo.
:apply
REM ; GPU tweaks
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NoLazyMode" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Background Only" /t REG_SZ /d "False" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d "18" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d "6" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f
REM ; Disables Font Chache
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\FontCache" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\FontCache3.0.0.0" /v "Start" /t REG_DWORD /d "4" /f
timeout /t 2 > nul
:next
cls
cd %systemroot%\system32
echo ****************************************************************************
echo * *                                                                      * *
echo.   Want to disable background applications? (Can speed up computer a lot)
echo * *                                                                      * *
echo ****************************************************************************
echo. Press "Y" to apply
echo. Press "N" to skip
echo.
set /p choice=Enter choice [Y/N]: 
IF /I "%choice%"=="Y" goto apply
IF /I "%choice%"=="N" goto next
echo.
:apply
REM ; Disables Backgroound applications
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d "1" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BackgroundAppGlobalToggle" /t REG_DWORD /d "0" /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Search" /v "BackgroundAppGlobalToggle" /t REG_DWORD /d 0 /f
goto :next
:next
cls
timeout /t 2 > nul
cd %systemroot%\system32
echo ************************************
echo * *                              * *
echo.   Want to tweak CPU? (Processor)
echo * *                              * *
echo ************************************
echo. Press "Y" to apply
echo. Press "N" to skip
echo.
set /p choice=Enter choice [Y/N]: 
IF /I "%choice%"=="Y" goto apply
IF /I "%choice%"=="N" goto next
echo.
:apply
REM ; Small CPU tweaks
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Executive" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\ModernSleep" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v "CoalescingTimerInterval" /t REG_DWORD /d "0" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\TimeBrokerSvc" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\CryptSvc" /v "Start" /t REG_DWORD /d "2" /f
REM ; Decreases the amount of background and Windows processes.
reg add "HKCU\Control Panel\Desktop" /v HungApptimeout /t REG_SZ /d 1000 /f > nul
goto :next
:next
cls
timeout /t 2 > nul
cd %systemroot%\system32
echo ********************************
echo * *                          * *
echo.   Want to disable aero peek?
echo * *                          * *
echo ********************************
echo. Press "Y" to apply
echo. Press "N" to skip
echo.
set /p choice=Enter choice [Y/N]: 
IF /I "%choice%"=="Y" goto apply
IF /I "%choice%"=="N" goto next
echo.
:apply
REM ; Disables aero peek
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d "0" /f
goto :next
:next
cls
cls
timeout /t 2 > nul
cd %systemroot%\system32
echo *******************************************
echo * *                                     * *
echo.   Want to disable activity history tab?
echo * *                                     * *
echo *******************************************
echo. Press "Y" to apply
echo. Press "N" to skip
echo.
set /p choice=Enter choice [Y/N]: 
IF /I "%choice%"=="Y" goto apply
IF /I "%choice%"=="N" goto next
echo.
:apply
REM ; Activity History tab
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "UploadUserActivities" /t REG_DWORD /d "0" /f
cls
goto :next
:next
cls
timeout /t 2 > nul
cd %systemroot%\system32
echo *********************************************************
echo * *                                                   * *
echo.   Want to enable hardware accelerated GPU scheduling?
echo * *                                                   * *
echo *********************************************************
echo. Press "Y" to apply
echo. Press "N" to skip
echo.
set /p choice=Enter choice [Y/N]: 
IF /I "%choice%"=="Y" goto apply
IF /I "%choice%"=="N" goto next
echo.
:apply
REM ; Enable hardware accelerated Gpu scheduling
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchedMode" /t REG_DWORD /d "2" /f
cls
goto :next
:next
cls
timeout /t 2 > nul
cd %systemroot%\system32
echo ****************************************************************
echo * *                                                          * *
echo.   Want to disable prelaunch? (Can make windows faster a lot)
echo * *                                                          * *
echo ****************************************************************
echo. Press "Y" to apply
echo. Press "N" to skip
echo.
set /p choice=Enter choice [Y/N]: 
IF /I "%choice%"=="Y" goto apply
IF /I "%choice%"=="N" goto next
echo.
:apply
REM ; Tweaks everything (disables prelaunch)
reg add "HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\MicrosoftEdge\Main" /v "AllowPrelaunch" /t REG_DWORD /d "0" /fű
goto :next
:next
cls
timeout /t 2 > nul
cd %systemroot%\system32
echo **********************************
echo * *                            * *
echo.   Want to make mouse smoother?
echo * *                            * *
echo **********************************
echo. Press "Y" to apply
echo. Press "N" to skip
echo.
set /p choice=Enter choice [Y/N]:  
IF /I "%choice%"=="Y" goto apply
IF /I "%choice%"=="N" goto next
echo.
:apply
REM ; Mouse tweaks
reg add "HKCU\Control Panel\Mouse" /v "SmoothMouseXCurve" /t REG_BINARY /d "000000000000000000a0000000000000004001000000000000800200000000000000050000000000" /f
reg add "HKCU\Control Panel\Mouse" /v "SmoothMouseYCurve" /t REG_BINARY /d "000000000000000066a6020000000000cd4c050000000000a0990a00000000003833150000000000" /f
goto :next
cls
:next
cls
timeout /t 2 > nul
cd %systemroot%\system32
echo ******************************************************************
echo * *                                                            * *
echo.   Want to enable transparency? (To make windows little better)
echo * *                                                            * *
echo ******************************************************************
echo. Press "Y" to apply
echo. Press "N" to skip
echo.
set /p choice=Enter choice [Y/N]: 
IF /I "%choice%"=="Y" goto apply
IF /I "%choice%"=="N" goto next
echo.
:apply
REM ; Visual Tweaks (Enables Transparency to make windows look litte better)
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d "1" /f
goto :next
:next
cls
timeout /t 2 > nul
cd %systemroot%\system32
echo *****************************************************************************
echo * *                                                                       * *
echo.   Want to make jpeg import quality to 100%? (Can slow your pc down a bit)
echo * *                                                                       * *
echo *****************************************************************************
echo. Press "Y" to apply
echo. Press "N" to skip
echo.
set /p choice=Enter choice [Y/N]: 
IF /I "%choice%"=="Y" goto apply
IF /I "%choice%"=="N" goto next
echo.
:apply
REM ; JPEG quality 100% :)
reg add "HKCU\Control Panel\Desktop" /v "JPEGImportQuality" /t REG_DWORD /d "100" /f
goto :next
:next
cls
timeout /t 2 > nul
cd %systemroot%\system32

echo *************************************************
echo * *                                           * *
echo.   Want to deny programs to acess to location?
echo * *                                           * *
echo *************************************************
echo. Press "Y" to apply
echo. Press "N" to skip
echo.
set /p choice=Enter choice [Y/N]: 
IF /I "%choice%"=="Y" goto apply
IF /I "%choice%"=="N" goto next
echo.
:apply
REM ; Dont let programs acess location
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v "Value" /t REG_SZ /d "Deny" /f
goto :next
:next
cls
timeout /t 2 > nul
cd %systemroot%\system32
echo ****************************************************
echo * *                                              * *
echo.   Disable storage power saving? (HDD wont sleep)
echo * *                                              * *
echo ****************************************************
echo. Press "Y" to apply
echo. Press "N" to skip
echo.
set /p choice=Enter choice [Y/N]:  
IF /I "%choice%"=="Y" goto apply
IF /I "%choice%"=="N" goto next
echo.
:apply
REM ; Disables Storage power saving
for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum" /s /f "StorPort"^| findstr "StorPort"') do reg add "%%i" /v "EnableIdlePowerManagement" /t REG_DWORD /d "0" /f
for %%i in (EnableHIPM EnableDIPM EnableHDDParking) do for /f %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services" /s /f "%%i" ^| findstr "HKEY"') do reg add "%%a" /v "%%i" /t REG_DWORD /d "0" /f
for %%i in (iaStorAC iaStorA iaStorAV) do for /f %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services" /s /f "%%i"^| findstr "HKEY"') do reg add "%%a\Parameters" /v "EnableAPM" /t REG_DWORD /d "0" /f
goto :next
:next
cls
timeout /t 2 > nul
cd %systemroot%\system32
echo **********************************
echo * *                            * *
echo.   Disable some visual effects?
echo * *                            * *
echo **********************************
echo. Press "Y" to apply
echo. Press "N" to skip
echo.
set /p choice=Enter choice [Y/N]:  
IF /I "%choice%"=="Y" goto apply
IF /I "%choice%"=="N" goto next
echo.
:apply
REM ; Visual effects
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d "3" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\AnimateMinMax" /v "DefaultApplied" /t REG_SZ /d "0" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\ControlAnimations" /v "DefaultApplied" /t REG_SZ /d "0" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\CursorShadow" /v "DefaultApplied" /t REG_SZ /d "0" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\DropShadow" /v "DefaultApplied" /t REG_SZ /d "0" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\DWMAeroPeekEnabled" /v "DefaultApplied" /t REG_SZ /d "0" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\DWMEnabled" /v "DefaultApplied" /t REG_DWORD /d "1" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\DWMSaveThumbnailEnabled" /v "DefaultApplied" /t REG_SZ /d "0" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\FontSmoothing" /v "DefaultApplied" /t REG_SZ /d "1" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\ListBoxSmoothScrolling" /v "DefaultApplied" /t REG_SZ /d "0" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\ListviewAlphaSelect" /v "DefaultApplied" /t REG_SZ /d "0" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\ListviewShadow" /v "DefaultApplied" /t REG_SZ /d "0" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\SelectionFade" /v "DefaultApplied" /t REG_SZ /d "0" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\TaskbarAnimations" /v "DefaultApplied" /t REG_SZ /d "0" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\ThumbnailsOrIcon" /v "DefaultApplied" /t REG_SZ /d "1" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\TooltipAnimation" /v "DefaultApplied" /t REG_SZ /d "0" /f
goto :next
cls
:next
cls
timeout /t 2 > nul
cd %systemroot%\system32
echo ******************************
echo * *                        * *
echo.   Want to disable GameDVR?
echo * *                        * *
echo ******************************
echo. Press "Y" to apply
echo. Press "N" to skip
echo.
set /p choice=Enter choice [Y/N]: 
IF /I "%choice%"=="Y" goto apply
IF /I "%choice%"=="N" goto next
echo.
:apply
:: Checks 32 or 64 bit system
reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32BIT || set OS=64BIT
if %OS%==32BIT call :32
if %OS%==64BIT call :64
:32
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d "0" /f
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowgameDVR" /t REG_DWORD /d "0" /f
call :done
:64
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d "0" /f
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\GameDVR" /v "AllowgameDVR" /t REG_DWORD /d "0" /f
call :done
:done
goto :next
:next
cls
timeout /t 2 > nul
cd %systemroot%\system32
echo *************************************
echo * *                               * *
echo.   Want to enable MSI mode on GPU?
echo * *                               * *
echo *************************************
echo. Press "Y" to apply
echo. Press "N" to skip
echo.
set /p choice=Enter choice [Y/N]: 
IF /I "%choice%"=="Y" goto apply
IF /I "%choice%"=="N" goto next
echo.
:apply
REM ; Enables MSI mode on GPU
for /f %%g in ('wmic path win32_videocontroller get PNPDeviceID ^| findstr /L "VEN_"') do (
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\%%g\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f 
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\%%g\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /t REG_DWORD /d "2" /f 
)
cls
goto :next
:next
cls
timeout /t 2 > nul
cd %systemroot%\system32
echo ************************************************************************************************
echo * *                                                                                          * *
echo.   Want to disable some tracking and ads in Windows (Make Windows safer) (Windows hardening)?
echo * *                                                                                          * *
echo ************************************************************************************************
echo. Press "Y" to apply
echo. Press "N" to skip
echo.
set /p choice=Enter choice [Y/N]: 
IF /I "%choice%"=="Y" goto apply
IF /I "%choice%"=="N" goto next
echo.
:apply
REM ; Windows hardering
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowSearchToUseLocation" /t REG_DWORD /d 0 /f
REM ; Google Chrome web hardering
REM ; Nvidia data telemetry ENDED
if exist "%ProgramFiles%\NVIDIA Corporation\Installer2\InstallerCore\NVI2.DLL" (
    rundll32 "%PROGRAMFILES%\NVIDIA Corporation\Installer2\InstallerCore\NVI2.DLL",UninstallPackage NvTelemetryContainer
    rundll32 "%PROGRAMFILES%\NVIDIA Corporation\Installer2\InstallerCore\NVI2.DLL",UninstallPackage NvTelemetry
)
del /s %SystemRoot%\System32\DriverStore\FileRepository\NvTelemetry*.dll
rmdir /s /q "%ProgramFiles(x86)%\NVIDIA Corporation\NvTelemetry" 2>nul
rmdir /s /q "%ProgramFiles%\NVIDIA Corporation\NvTelemetry" 2>nul
reg add "HKLM\SOFTWARE\NVIDIA Corporation\NvControlPanel2\Client" /v "OptInOrOutPreference" /t REG_DWORD /d 0 /f 
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\FTS" /v "EnableRID44231" /t REG_DWORD /d 0 /f 
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\FTS" /v "EnableRID64640" /t REG_DWORD /d 0 /f 
reg add "HKLM\SOFTWARE\NVIDIA Corporation\Global\FTS" /v "EnableRID66610" /t REG_DWORD /d 0 /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Global\Startup" /v "SendTelemetryData" /t REG_DWORD /d 0 /f
schtasks /change /TN NvTmMon_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8} /DISABLE
schtasks /change /TN NvTmRep_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8} /DISABLE
schtasks /change /TN NvTmRepOnLogon_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8} /DISABLE
PowerShell -ExecutionPolicy Unrestricted -Command "$serviceName = 'NvTelemetryContainer'; Write-Host "^""Disabling service: `"^""$serviceName`"^""."^""; <# -- 1. Skip if service does not exist #>; $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue; if(!$service) {; Write-Host "^""Service `"^""$serviceName`"^"" could not be not found, no need to disable it."^""; Exit 0; }; <# -- 2. Stop if running #>; if ($service.Status -eq [System.ServiceProcess.ServiceControllerStatus]::Running) {; Write-Host "^""`"^""$serviceName`"^"" is running, stopping it."^""; try {; Stop-Service -Name "^""$serviceName"^"" -Force -ErrorAction Stop; Write-Host "^""Stopped `"^""$serviceName`"^"" successfully."^""; } catch {; Write-Warning "^""Could not stop `"^""$serviceName`"^"", it will be stopped after reboot: $_"^""; }; } else {; Write-Host "^""`"^""$serviceName`"^"" is not running, no need to stop."^""; }; <# -- 3. Skip if already disabled #>; $startupType = $service.StartType <# Does not work before .NET 4.6.1 #>; if(!$startupType) {; $startupType = (Get-WmiObject -Query "^""Select StartMode From Win32_Service Where Name='$serviceName'"^"" -ErrorAction Ignore).StartMode; if(!$startupType) {; $startupType = (Get-WmiObject -Class Win32_Service -Property StartMode -Filter "^""Name='$serviceName'"^"" -ErrorAction Ignore).StartMode; }; }; if($startupType -eq 'Disabled') {; Write-Host "^""$serviceName is already disabled, no further action is needed"^""; }; <# -- 4. Disable service #>; try {; Set-Service -Name "^""$serviceName"^"" -StartupType Disabled -Confirm:$false -ErrorAction Stop; Write-Host "^""Disabled `"^""$serviceName`"^"" successfully."^""; } catch {; Write-Error "^""Could not disable `"^""$serviceName`"^"": $_"^""; }"
PowerShell -ExecutionPolicy Unrestricted -Command "$jsonfile = "^""$env:APPDATA\Code\User\settings.json"^""; if (!(Test-Path $jsonfile -PathType Leaf)) {; Write-Host "^""No updates. Settings file was not at $jsonfile"^""; exit 0; }; $json = Get-Content $jsonfile | Out-String | ConvertFrom-Json; $json | Add-Member -Type NoteProperty -Name 'telemetry.enableTelemetry' -Value $false -Force; $json | ConvertTo-Json | Set-Content $jsonfile"
PowerShell -ExecutionPolicy Unrestricted -Command "$jsonfile = "^""$env:APPDATA\Code\User\settings.json"^""; if (!(Test-Path $jsonfile -PathType Leaf)) {; Write-Host "^""No updates. Settings file was not at $jsonfile"^""; exit 0; }; $json = Get-Content $jsonfile | Out-String | ConvertFrom-Json; $json | Add-Member -Type NoteProperty -Name 'telemetry.enableCrashReporter' -Value $false -Force; $json | ConvertTo-Json | Set-Content $jsonfile"
PowerShell -ExecutionPolicy Unrestricted -Command "$jsonfile = "^""$env:APPDATA\Code\User\settings.json"^""; if (!(Test-Path $jsonfile -PathType Leaf)) {; Write-Host "^""No updates. Settings file was not at $jsonfile"^""; exit 0; }; $json = Get-Content $jsonfile | Out-String | ConvertFrom-Json; $json | Add-Member -Type NoteProperty -Name 'workbench.enableExperiments' -Value $false -Force; $json | ConvertTo-Json | Set-Content $jsonfile"
:: VISUAL STUDIO CLEANING :: CREDITS TO PRIVACY.SEXY
:: Clear directory contents  : "%LOCALAPPDATA%\Microsoft\VSCommon\14.0\SQM"
PowerShell -ExecutionPolicy Unrestricted -Command "$pathGlobPattern = "^""$($directoryGlob = '%LOCALAPPDATA%\Microsoft\VSCommon\14.0\SQM'; if ($directoryGlob.EndsWith('\*')) { $directoryGlob } elseif ($directoryGlob.EndsWith('\')) { "^""$($directoryGlob)*"^"" } else { "^""$($directoryGlob)\*"^"" } )"^""; $expandedPath = [System.Environment]::ExpandEnvironmentVariables($pathGlobPattern); Write-Host "^""Searching for items matching pattern: `"^""$($expandedPath)`"^""."^""; $deletedCount = 0; $failedCount = 0; $foundAbsolutePaths = @(); Write-Host 'Iterating files and directories recursively.'; try {; $foundAbsolutePaths += @(; Get-ChildItem -Path $expandedPath -Force -Recurse -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; try {; $foundAbsolutePaths += @(; Get-Item -Path $expandedPath -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; $foundAbsolutePaths = $foundAbsolutePaths | Select-Object -Unique | Sort-Object -Property { $_.Length } -Descending; if (!$foundAbsolutePaths) {; Write-Host 'Skipping, no items available.'; exit 0; }; Write-Host "^""Initiating processing of $($foundAbsolutePaths.Count) items from `"^""$expandedPath`"^""."^""; foreach ($path in $foundAbsolutePaths) {; if (-not (Test-Path $path)) { <# Re-check existence as prior deletions might remove subsequent items (e.g., subdirectories). #>; Write-Host "^""Successfully deleted: $($path) (already deleted)."^""; $deletedCount++; continue; }; try {; Remove-Item -Path $path -Force -Recurse -ErrorAction Stop; $deletedCount++; Write-Host "^""Successfully deleted: $($path)"^""; } catch {; $failedCount++; Write-Warning "^""Unable to delete $($path): $_"^""; }; }; Write-Host "^""Successfully deleted $($deletedCount) items."^""; if ($failedCount -gt 0) {; Write-Warning "^""Failed to delete $($failedCount) items."^""; }"
:: Clear directory contents  : "%LOCALAPPDATA%\Microsoft\VSCommon\15.0\SQM"
PowerShell -ExecutionPolicy Unrestricted -Command "$pathGlobPattern = "^""$($directoryGlob = '%LOCALAPPDATA%\Microsoft\VSCommon\15.0\SQM'; if ($directoryGlob.EndsWith('\*')) { $directoryGlob } elseif ($directoryGlob.EndsWith('\')) { "^""$($directoryGlob)*"^"" } else { "^""$($directoryGlob)\*"^"" } )"^""; $expandedPath = [System.Environment]::ExpandEnvironmentVariables($pathGlobPattern); Write-Host "^""Searching for items matching pattern: `"^""$($expandedPath)`"^""."^""; $deletedCount = 0; $failedCount = 0; $foundAbsolutePaths = @(); Write-Host 'Iterating files and directories recursively.'; try {; $foundAbsolutePaths += @(; Get-ChildItem -Path $expandedPath -Force -Recurse -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; try {; $foundAbsolutePaths += @(; Get-Item -Path $expandedPath -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; $foundAbsolutePaths = $foundAbsolutePaths | Select-Object -Unique | Sort-Object -Property { $_.Length } -Descending; if (!$foundAbsolutePaths) {; Write-Host 'Skipping, no items available.'; exit 0; }; Write-Host "^""Initiating processing of $($foundAbsolutePaths.Count) items from `"^""$expandedPath`"^""."^""; foreach ($path in $foundAbsolutePaths) {; if (-not (Test-Path $path)) { <# Re-check existence as prior deletions might remove subsequent items (e.g., subdirectories). #>; Write-Host "^""Successfully deleted: $($path) (already deleted)."^""; $deletedCount++; continue; }; try {; Remove-Item -Path $path -Force -Recurse -ErrorAction Stop; $deletedCount++; Write-Host "^""Successfully deleted: $($path)"^""; } catch {; $failedCount++; Write-Warning "^""Unable to delete $($path): $_"^""; }; }; Write-Host "^""Successfully deleted $($deletedCount) items."^""; if ($failedCount -gt 0) {; Write-Warning "^""Failed to delete $($failedCount) items."^""; }"
:: Clear directory contents  : "%LOCALAPPDATA%\Microsoft\VSCommon\16.0\SQM"
PowerShell -ExecutionPolicy Unrestricted -Command "$pathGlobPattern = "^""$($directoryGlob = '%LOCALAPPDATA%\Microsoft\VSCommon\16.0\SQM'; if ($directoryGlob.EndsWith('\*')) { $directoryGlob } elseif ($directoryGlob.EndsWith('\')) { "^""$($directoryGlob)*"^"" } else { "^""$($directoryGlob)\*"^"" } )"^""; $expandedPath = [System.Environment]::ExpandEnvironmentVariables($pathGlobPattern); Write-Host "^""Searching for items matching pattern: `"^""$($expandedPath)`"^""."^""; $deletedCount = 0; $failedCount = 0; $foundAbsolutePaths = @(); Write-Host 'Iterating files and directories recursively.'; try {; $foundAbsolutePaths += @(; Get-ChildItem -Path $expandedPath -Force -Recurse -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; try {; $foundAbsolutePaths += @(; Get-Item -Path $expandedPath -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; $foundAbsolutePaths = $foundAbsolutePaths | Select-Object -Unique | Sort-Object -Property { $_.Length } -Descending; if (!$foundAbsolutePaths) {; Write-Host 'Skipping, no items available.'; exit 0; }; Write-Host "^""Initiating processing of $($foundAbsolutePaths.Count) items from `"^""$expandedPath`"^""."^""; foreach ($path in $foundAbsolutePaths) {; if (-not (Test-Path $path)) { <# Re-check existence as prior deletions might remove subsequent items (e.g., subdirectories). #>; Write-Host "^""Successfully deleted: $($path) (already deleted)."^""; $deletedCount++; continue; }; try {; Remove-Item -Path $path -Force -Recurse -ErrorAction Stop; $deletedCount++; Write-Host "^""Successfully deleted: $($path)"^""; } catch {; $failedCount++; Write-Warning "^""Unable to delete $($path): $_"^""; }; }; Write-Host "^""Successfully deleted $($deletedCount) items."^""; if ($failedCount -gt 0) {; Write-Warning "^""Failed to delete $($failedCount) items."^""; }"
:: Clear directory contents  : "%LOCALAPPDATA%\Microsoft\VSCommon\17.0\SQM"
PowerShell -ExecutionPolicy Unrestricted -Command "$pathGlobPattern = "^""$($directoryGlob = '%LOCALAPPDATA%\Microsoft\VSCommon\17.0\SQM'; if ($directoryGlob.EndsWith('\*')) { $directoryGlob } elseif ($directoryGlob.EndsWith('\')) { "^""$($directoryGlob)*"^"" } else { "^""$($directoryGlob)\*"^"" } )"^""; $expandedPath = [System.Environment]::ExpandEnvironmentVariables($pathGlobPattern); Write-Host "^""Searching for items matching pattern: `"^""$($expandedPath)`"^""."^""; $deletedCount = 0; $failedCount = 0; $foundAbsolutePaths = @(); Write-Host 'Iterating files and directories recursively.'; try {; $foundAbsolutePaths += @(; Get-ChildItem -Path $expandedPath -Force -Recurse -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; try {; $foundAbsolutePaths += @(; Get-Item -Path $expandedPath -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; $foundAbsolutePaths = $foundAbsolutePaths | Select-Object -Unique | Sort-Object -Property { $_.Length } -Descending; if (!$foundAbsolutePaths) {; Write-Host 'Skipping, no items available.'; exit 0; }; Write-Host "^""Initiating processing of $($foundAbsolutePaths.Count) items from `"^""$expandedPath`"^""."^""; foreach ($path in $foundAbsolutePaths) {; if (-not (Test-Path $path)) { <# Re-check existence as prior deletions might remove subsequent items (e.g., subdirectories). #>; Write-Host "^""Successfully deleted: $($path) (already deleted)."^""; $deletedCount++; continue; }; try {; Remove-Item -Path $path -Force -Recurse -ErrorAction Stop; $deletedCount++; Write-Host "^""Successfully deleted: $($path)"^""; } catch {; $failedCount++; Write-Warning "^""Unable to delete $($path): $_"^""; }; }; Write-Host "^""Successfully deleted $($deletedCount) items."^""; if ($failedCount -gt 0) {; Write-Warning "^""Failed to delete $($failedCount) items."^""; }"
:: Clear directory contents  : "%LOCALAPPDATA%\Microsoft\VSApplicationInsights"
PowerShell -ExecutionPolicy Unrestricted -Command "$pathGlobPattern = "^""$($directoryGlob = '%LOCALAPPDATA%\Microsoft\VSApplicationInsights'; if ($directoryGlob.EndsWith('\*')) { $directoryGlob } elseif ($directoryGlob.EndsWith('\')) { "^""$($directoryGlob)*"^"" } else { "^""$($directoryGlob)\*"^"" } )"^""; $expandedPath = [System.Environment]::ExpandEnvironmentVariables($pathGlobPattern); Write-Host "^""Searching for items matching pattern: `"^""$($expandedPath)`"^""."^""; $deletedCount = 0; $failedCount = 0; $foundAbsolutePaths = @(); Write-Host 'Iterating files and directories recursively.'; try {; $foundAbsolutePaths += @(; Get-ChildItem -Path $expandedPath -Force -Recurse -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; try {; $foundAbsolutePaths += @(; Get-Item -Path $expandedPath -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; $foundAbsolutePaths = $foundAbsolutePaths | Select-Object -Unique | Sort-Object -Property { $_.Length } -Descending; if (!$foundAbsolutePaths) {; Write-Host 'Skipping, no items available.'; exit 0; }; Write-Host "^""Initiating processing of $($foundAbsolutePaths.Count) items from `"^""$expandedPath`"^""."^""; foreach ($path in $foundAbsolutePaths) {; if (-not (Test-Path $path)) { <# Re-check existence as prior deletions might remove subsequent items (e.g., subdirectories). #>; Write-Host "^""Successfully deleted: $($path) (already deleted)."^""; $deletedCount++; continue; }; try {; Remove-Item -Path $path -Force -Recurse -ErrorAction Stop; $deletedCount++; Write-Host "^""Successfully deleted: $($path)"^""; } catch {; $failedCount++; Write-Warning "^""Unable to delete $($path): $_"^""; }; }; Write-Host "^""Successfully deleted $($deletedCount) items."^""; if ($failedCount -gt 0) {; Write-Warning "^""Failed to delete $($failedCount) items."^""; }"
:: Clear directory contents  : "%PROGRAMDATA%\Microsoft\VSApplicationInsights"
PowerShell -ExecutionPolicy Unrestricted -Command "$pathGlobPattern = "^""$($directoryGlob = '%PROGRAMDATA%\Microsoft\VSApplicationInsights'; if ($directoryGlob.EndsWith('\*')) { $directoryGlob } elseif ($directoryGlob.EndsWith('\')) { "^""$($directoryGlob)*"^"" } else { "^""$($directoryGlob)\*"^"" } )"^""; $expandedPath = [System.Environment]::ExpandEnvironmentVariables($pathGlobPattern); Write-Host "^""Searching for items matching pattern: `"^""$($expandedPath)`"^""."^""; $deletedCount = 0; $failedCount = 0; $foundAbsolutePaths = @(); Write-Host 'Iterating files and directories recursively.'; try {; $foundAbsolutePaths += @(; Get-ChildItem -Path $expandedPath -Force -Recurse -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; try {; $foundAbsolutePaths += @(; Get-Item -Path $expandedPath -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; $foundAbsolutePaths = $foundAbsolutePaths | Select-Object -Unique | Sort-Object -Property { $_.Length } -Descending; if (!$foundAbsolutePaths) {; Write-Host 'Skipping, no items available.'; exit 0; }; Write-Host "^""Initiating processing of $($foundAbsolutePaths.Count) items from `"^""$expandedPath`"^""."^""; foreach ($path in $foundAbsolutePaths) {; if (-not (Test-Path $path)) { <# Re-check existence as prior deletions might remove subsequent items (e.g., subdirectories). #>; Write-Host "^""Successfully deleted: $($path) (already deleted)."^""; $deletedCount++; continue; }; try {; Remove-Item -Path $path -Force -Recurse -ErrorAction Stop; $deletedCount++; Write-Host "^""Successfully deleted: $($path)"^""; } catch {; $failedCount++; Write-Warning "^""Unable to delete $($path): $_"^""; }; }; Write-Host "^""Successfully deleted $($deletedCount) items."^""; if ($failedCount -gt 0) {; Write-Warning "^""Failed to delete $($failedCount) items."^""; }"
:: Clear directory contents  : "%TEMP%\Microsoft\VSApplicationInsights"
PowerShell -ExecutionPolicy Unrestricted -Command "$pathGlobPattern = "^""$($directoryGlob = '%TEMP%\Microsoft\VSApplicationInsights'; if ($directoryGlob.EndsWith('\*')) { $directoryGlob } elseif ($directoryGlob.EndsWith('\')) { "^""$($directoryGlob)*"^"" } else { "^""$($directoryGlob)\*"^"" } )"^""; $expandedPath = [System.Environment]::ExpandEnvironmentVariables($pathGlobPattern); Write-Host "^""Searching for items matching pattern: `"^""$($expandedPath)`"^""."^""; $deletedCount = 0; $failedCount = 0; $foundAbsolutePaths = @(); Write-Host 'Iterating files and directories recursively.'; try {; $foundAbsolutePaths += @(; Get-ChildItem -Path $expandedPath -Force -Recurse -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; try {; $foundAbsolutePaths += @(; Get-Item -Path $expandedPath -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; $foundAbsolutePaths = $foundAbsolutePaths | Select-Object -Unique | Sort-Object -Property { $_.Length } -Descending; if (!$foundAbsolutePaths) {; Write-Host 'Skipping, no items available.'; exit 0; }; Write-Host "^""Initiating processing of $($foundAbsolutePaths.Count) items from `"^""$expandedPath`"^""."^""; foreach ($path in $foundAbsolutePaths) {; if (-not (Test-Path $path)) { <# Re-check existence as prior deletions might remove subsequent items (e.g., subdirectories). #>; Write-Host "^""Successfully deleted: $($path) (already deleted)."^""; $deletedCount++; continue; }; try {; Remove-Item -Path $path -Force -Recurse -ErrorAction Stop; $deletedCount++; Write-Host "^""Successfully deleted: $($path)"^""; } catch {; $failedCount++; Write-Warning "^""Unable to delete $($path): $_"^""; }; }; Write-Host "^""Successfully deleted $($deletedCount) items."^""; if ($failedCount -gt 0) {; Write-Warning "^""Failed to delete $($failedCount) items."^""; }"
:: Clear directory contents  : "%APPDATA%\vstelemetry"
PowerShell -ExecutionPolicy Unrestricted -Command "$pathGlobPattern = "^""$($directoryGlob = '%APPDATA%\vstelemetry'; if ($directoryGlob.EndsWith('\*')) { $directoryGlob } elseif ($directoryGlob.EndsWith('\')) { "^""$($directoryGlob)*"^"" } else { "^""$($directoryGlob)\*"^"" } )"^""; $expandedPath = [System.Environment]::ExpandEnvironmentVariables($pathGlobPattern); Write-Host "^""Searching for items matching pattern: `"^""$($expandedPath)`"^""."^""; $deletedCount = 0; $failedCount = 0; $foundAbsolutePaths = @(); Write-Host 'Iterating files and directories recursively.'; try {; $foundAbsolutePaths += @(; Get-ChildItem -Path $expandedPath -Force -Recurse -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; try {; $foundAbsolutePaths += @(; Get-Item -Path $expandedPath -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; $foundAbsolutePaths = $foundAbsolutePaths | Select-Object -Unique | Sort-Object -Property { $_.Length } -Descending; if (!$foundAbsolutePaths) {; Write-Host 'Skipping, no items available.'; exit 0; }; Write-Host "^""Initiating processing of $($foundAbsolutePaths.Count) items from `"^""$expandedPath`"^""."^""; foreach ($path in $foundAbsolutePaths) {; if (-not (Test-Path $path)) { <# Re-check existence as prior deletions might remove subsequent items (e.g., subdirectories). #>; Write-Host "^""Successfully deleted: $($path) (already deleted)."^""; $deletedCount++; continue; }; try {; Remove-Item -Path $path -Force -Recurse -ErrorAction Stop; $deletedCount++; Write-Host "^""Successfully deleted: $($path)"^""; } catch {; $failedCount++; Write-Warning "^""Unable to delete $($path): $_"^""; }; }; Write-Host "^""Successfully deleted $($deletedCount) items."^""; if ($failedCount -gt 0) {; Write-Warning "^""Failed to delete $($failedCount) items."^""; }"
:: Clear directory contents  : "%PROGRAMDATA%\vstelemetry"
PowerShell -ExecutionPolicy Unrestricted -Command "$pathGlobPattern = "^""$($directoryGlob = '%PROGRAMDATA%\vstelemetry'; if ($directoryGlob.EndsWith('\*')) { $directoryGlob } elseif ($directoryGlob.EndsWith('\')) { "^""$($directoryGlob)*"^"" } else { "^""$($directoryGlob)\*"^"" } )"^""; $expandedPath = [System.Environment]::ExpandEnvironmentVariables($pathGlobPattern); Write-Host "^""Searching for items matching pattern: `"^""$($expandedPath)`"^""."^""; $deletedCount = 0; $failedCount = 0; $foundAbsolutePaths = @(); Write-Host 'Iterating files and directories recursively.'; try {; $foundAbsolutePaths += @(; Get-ChildItem -Path $expandedPath -Force -Recurse -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; try {; $foundAbsolutePaths += @(; Get-Item -Path $expandedPath -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; $foundAbsolutePaths = $foundAbsolutePaths | Select-Object -Unique | Sort-Object -Property { $_.Length } -Descending; if (!$foundAbsolutePaths) {; Write-Host 'Skipping, no items available.'; exit 0; }; Write-Host "^""Initiating processing of $($foundAbsolutePaths.Count) items from `"^""$expandedPath`"^""."^""; foreach ($path in $foundAbsolutePaths) {; if (-not (Test-Path $path)) { <# Re-check existence as prior deletions might remove subsequent items (e.g., subdirectories). #>; Write-Host "^""Successfully deleted: $($path) (already deleted)."^""; $deletedCount++; continue; }; try {; Remove-Item -Path $path -Force -Recurse -ErrorAction Stop; $deletedCount++; Write-Host "^""Successfully deleted: $($path)"^""; } catch {; $failedCount++; Write-Warning "^""Unable to delete $($path): $_"^""; }; }; Write-Host "^""Successfully deleted $($deletedCount) items."^""; if ($failedCount -gt 0) {; Write-Warning "^""Failed to delete $($failedCount) items."^""; }"
:: Clear directory contents  : "%TEMP%\VSFaultInfo"
PowerShell -ExecutionPolicy Unrestricted -Command "$pathGlobPattern = "^""$($directoryGlob = '%TEMP%\VSFaultInfo'; if ($directoryGlob.EndsWith('\*')) { $directoryGlob } elseif ($directoryGlob.EndsWith('\')) { "^""$($directoryGlob)*"^"" } else { "^""$($directoryGlob)\*"^"" } )"^""; $expandedPath = [System.Environment]::ExpandEnvironmentVariables($pathGlobPattern); Write-Host "^""Searching for items matching pattern: `"^""$($expandedPath)`"^""."^""; $deletedCount = 0; $failedCount = 0; $foundAbsolutePaths = @(); Write-Host 'Iterating files and directories recursively.'; try {; $foundAbsolutePaths += @(; Get-ChildItem -Path $expandedPath -Force -Recurse -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; try {; $foundAbsolutePaths += @(; Get-Item -Path $expandedPath -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; $foundAbsolutePaths = $foundAbsolutePaths | Select-Object -Unique | Sort-Object -Property { $_.Length } -Descending; if (!$foundAbsolutePaths) {; Write-Host 'Skipping, no items available.'; exit 0; }; Write-Host "^""Initiating processing of $($foundAbsolutePaths.Count) items from `"^""$expandedPath`"^""."^""; foreach ($path in $foundAbsolutePaths) {; if (-not (Test-Path $path)) { <# Re-check existence as prior deletions might remove subsequent items (e.g., subdirectories). #>; Write-Host "^""Successfully deleted: $($path) (already deleted)."^""; $deletedCount++; continue; }; try {; Remove-Item -Path $path -Force -Recurse -ErrorAction Stop; $deletedCount++; Write-Host "^""Successfully deleted: $($path)"^""; } catch {; $failedCount++; Write-Warning "^""Unable to delete $($path): $_"^""; }; }; Write-Host "^""Successfully deleted $($deletedCount) items."^""; if ($failedCount -gt 0) {; Write-Warning "^""Failed to delete $($failedCount) items."^""; }"
:: Clear directory contents  : "%TEMP%\VSFeedbackPerfWatsonData"
PowerShell -ExecutionPolicy Unrestricted -Command "$pathGlobPattern = "^""$($directoryGlob = '%TEMP%\VSFeedbackPerfWatsonData'; if ($directoryGlob.EndsWith('\*')) { $directoryGlob } elseif ($directoryGlob.EndsWith('\')) { "^""$($directoryGlob)*"^"" } else { "^""$($directoryGlob)\*"^"" } )"^""; $expandedPath = [System.Environment]::ExpandEnvironmentVariables($pathGlobPattern); Write-Host "^""Searching for items matching pattern: `"^""$($expandedPath)`"^""."^""; $deletedCount = 0; $failedCount = 0; $foundAbsolutePaths = @(); Write-Host 'Iterating files and directories recursively.'; try {; $foundAbsolutePaths += @(; Get-ChildItem -Path $expandedPath -Force -Recurse -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; try {; $foundAbsolutePaths += @(; Get-Item -Path $expandedPath -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; $foundAbsolutePaths = $foundAbsolutePaths | Select-Object -Unique | Sort-Object -Property { $_.Length } -Descending; if (!$foundAbsolutePaths) {; Write-Host 'Skipping, no items available.'; exit 0; }; Write-Host "^""Initiating processing of $($foundAbsolutePaths.Count) items from `"^""$expandedPath`"^""."^""; foreach ($path in $foundAbsolutePaths) {; if (-not (Test-Path $path)) { <# Re-check existence as prior deletions might remove subsequent items (e.g., subdirectories). #>; Write-Host "^""Successfully deleted: $($path) (already deleted)."^""; $deletedCount++; continue; }; try {; Remove-Item -Path $path -Force -Recurse -ErrorAction Stop; $deletedCount++; Write-Host "^""Successfully deleted: $($path)"^""; } catch {; $failedCount++; Write-Warning "^""Unable to delete $($path): $_"^""; }; }; Write-Host "^""Successfully deleted $($deletedCount) items."^""; if ($failedCount -gt 0) {; Write-Warning "^""Failed to delete $($failedCount) items."^""; }"
:: Clear directory contents  : "%TEMP%\VSFeedbackVSRTCLogs"
PowerShell -ExecutionPolicy Unrestricted -Command "$pathGlobPattern = "^""$($directoryGlob = '%TEMP%\VSFeedbackVSRTCLogs'; if ($directoryGlob.EndsWith('\*')) { $directoryGlob } elseif ($directoryGlob.EndsWith('\')) { "^""$($directoryGlob)*"^"" } else { "^""$($directoryGlob)\*"^"" } )"^""; $expandedPath = [System.Environment]::ExpandEnvironmentVariables($pathGlobPattern); Write-Host "^""Searching for items matching pattern: `"^""$($expandedPath)`"^""."^""; $deletedCount = 0; $failedCount = 0; $foundAbsolutePaths = @(); Write-Host 'Iterating files and directories recursively.'; try {; $foundAbsolutePaths += @(; Get-ChildItem -Path $expandedPath -Force -Recurse -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; try {; $foundAbsolutePaths += @(; Get-Item -Path $expandedPath -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; $foundAbsolutePaths = $foundAbsolutePaths | Select-Object -Unique | Sort-Object -Property { $_.Length } -Descending; if (!$foundAbsolutePaths) {; Write-Host 'Skipping, no items available.'; exit 0; }; Write-Host "^""Initiating processing of $($foundAbsolutePaths.Count) items from `"^""$expandedPath`"^""."^""; foreach ($path in $foundAbsolutePaths) {; if (-not (Test-Path $path)) { <# Re-check existence as prior deletions might remove subsequent items (e.g., subdirectories). #>; Write-Host "^""Successfully deleted: $($path) (already deleted)."^""; $deletedCount++; continue; }; try {; Remove-Item -Path $path -Force -Recurse -ErrorAction Stop; $deletedCount++; Write-Host "^""Successfully deleted: $($path)"^""; } catch {; $failedCount++; Write-Warning "^""Unable to delete $($path): $_"^""; }; }; Write-Host "^""Successfully deleted $($deletedCount) items."^""; if ($failedCount -gt 0) {; Write-Warning "^""Failed to delete $($failedCount) items."^""; }"
:: Clear directory contents  : "%TEMP%\VSFeedbackIntelliCodeLogs"
PowerShell -ExecutionPolicy Unrestricted -Command "$pathGlobPattern = "^""$($directoryGlob = '%TEMP%\VSFeedbackIntelliCodeLogs'; if ($directoryGlob.EndsWith('\*')) { $directoryGlob } elseif ($directoryGlob.EndsWith('\')) { "^""$($directoryGlob)*"^"" } else { "^""$($directoryGlob)\*"^"" } )"^""; $expandedPath = [System.Environment]::ExpandEnvironmentVariables($pathGlobPattern); Write-Host "^""Searching for items matching pattern: `"^""$($expandedPath)`"^""."^""; $deletedCount = 0; $failedCount = 0; $foundAbsolutePaths = @(); Write-Host 'Iterating files and directories recursively.'; try {; $foundAbsolutePaths += @(; Get-ChildItem -Path $expandedPath -Force -Recurse -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; try {; $foundAbsolutePaths += @(; Get-Item -Path $expandedPath -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; $foundAbsolutePaths = $foundAbsolutePaths | Select-Object -Unique | Sort-Object -Property { $_.Length } -Descending; if (!$foundAbsolutePaths) {; Write-Host 'Skipping, no items available.'; exit 0; }; Write-Host "^""Initiating processing of $($foundAbsolutePaths.Count) items from `"^""$expandedPath`"^""."^""; foreach ($path in $foundAbsolutePaths) {; if (-not (Test-Path $path)) { <# Re-check existence as prior deletions might remove subsequent items (e.g., subdirectories). #>; Write-Host "^""Successfully deleted: $($path) (already deleted)."^""; $deletedCount++; continue; }; try {; Remove-Item -Path $path -Force -Recurse -ErrorAction Stop; $deletedCount++; Write-Host "^""Successfully deleted: $($path)"^""; } catch {; $failedCount++; Write-Warning "^""Unable to delete $($path): $_"^""; }; }; Write-Host "^""Successfully deleted $($deletedCount) items."^""; if ($failedCount -gt 0) {; Write-Warning "^""Failed to delete $($failedCount) items."^""; }"
:: Clear directory contents  : "%TEMP%\VSRemoteControl"
PowerShell -ExecutionPolicy Unrestricted -Command "$pathGlobPattern = "^""$($directoryGlob = '%TEMP%\VSRemoteControl'; if ($directoryGlob.EndsWith('\*')) { $directoryGlob } elseif ($directoryGlob.EndsWith('\')) { "^""$($directoryGlob)*"^"" } else { "^""$($directoryGlob)\*"^"" } )"^""; $expandedPath = [System.Environment]::ExpandEnvironmentVariables($pathGlobPattern); Write-Host "^""Searching for items matching pattern: `"^""$($expandedPath)`"^""."^""; $deletedCount = 0; $failedCount = 0; $foundAbsolutePaths = @(); Write-Host 'Iterating files and directories recursively.'; try {; $foundAbsolutePaths += @(; Get-ChildItem -Path $expandedPath -Force -Recurse -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; try {; $foundAbsolutePaths += @(; Get-Item -Path $expandedPath -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; $foundAbsolutePaths = $foundAbsolutePaths | Select-Object -Unique | Sort-Object -Property { $_.Length } -Descending; if (!$foundAbsolutePaths) {; Write-Host 'Skipping, no items available.'; exit 0; }; Write-Host "^""Initiating processing of $($foundAbsolutePaths.Count) items from `"^""$expandedPath`"^""."^""; foreach ($path in $foundAbsolutePaths) {; if (-not (Test-Path $path)) { <# Re-check existence as prior deletions might remove subsequent items (e.g., subdirectories). #>; Write-Host "^""Successfully deleted: $($path) (already deleted)."^""; $deletedCount++; continue; }; try {; Remove-Item -Path $path -Force -Recurse -ErrorAction Stop; $deletedCount++; Write-Host "^""Successfully deleted: $($path)"^""; } catch {; $failedCount++; Write-Warning "^""Unable to delete $($path): $_"^""; }; }; Write-Host "^""Successfully deleted $($deletedCount) items."^""; if ($failedCount -gt 0) {; Write-Warning "^""Failed to delete $($failedCount) items."^""; }"
:: Clear directory contents  : "%TEMP%\Microsoft\VSFeedbackCollector"
PowerShell -ExecutionPolicy Unrestricted -Command "$pathGlobPattern = "^""$($directoryGlob = '%TEMP%\Microsoft\VSFeedbackCollector'; if ($directoryGlob.EndsWith('\*')) { $directoryGlob } elseif ($directoryGlob.EndsWith('\')) { "^""$($directoryGlob)*"^"" } else { "^""$($directoryGlob)\*"^"" } )"^""; $expandedPath = [System.Environment]::ExpandEnvironmentVariables($pathGlobPattern); Write-Host "^""Searching for items matching pattern: `"^""$($expandedPath)`"^""."^""; $deletedCount = 0; $failedCount = 0; $foundAbsolutePaths = @(); Write-Host 'Iterating files and directories recursively.'; try {; $foundAbsolutePaths += @(; Get-ChildItem -Path $expandedPath -Force -Recurse -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; try {; $foundAbsolutePaths += @(; Get-Item -Path $expandedPath -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; $foundAbsolutePaths = $foundAbsolutePaths | Select-Object -Unique | Sort-Object -Property { $_.Length } -Descending; if (!$foundAbsolutePaths) {; Write-Host 'Skipping, no items available.'; exit 0; }; Write-Host "^""Initiating processing of $($foundAbsolutePaths.Count) items from `"^""$expandedPath`"^""."^""; foreach ($path in $foundAbsolutePaths) {; if (-not (Test-Path $path)) { <# Re-check existence as prior deletions might remove subsequent items (e.g., subdirectories). #>; Write-Host "^""Successfully deleted: $($path) (already deleted)."^""; $deletedCount++; continue; }; try {; Remove-Item -Path $path -Force -Recurse -ErrorAction Stop; $deletedCount++; Write-Host "^""Successfully deleted: $($path)"^""; } catch {; $failedCount++; Write-Warning "^""Unable to delete $($path): $_"^""; }; }; Write-Host "^""Successfully deleted $($deletedCount) items."^""; if ($failedCount -gt 0) {; Write-Warning "^""Failed to delete $($failedCount) items."^""; }"
:: Clear directory contents  : "%TEMP%\VSTelem"
PowerShell -ExecutionPolicy Unrestricted -Command "$pathGlobPattern = "^""$($directoryGlob = '%TEMP%\VSTelem'; if ($directoryGlob.EndsWith('\*')) { $directoryGlob } elseif ($directoryGlob.EndsWith('\')) { "^""$($directoryGlob)*"^"" } else { "^""$($directoryGlob)\*"^"" } )"^""; $expandedPath = [System.Environment]::ExpandEnvironmentVariables($pathGlobPattern); Write-Host "^""Searching for items matching pattern: `"^""$($expandedPath)`"^""."^""; $deletedCount = 0; $failedCount = 0; $foundAbsolutePaths = @(); Write-Host 'Iterating files and directories recursively.'; try {; $foundAbsolutePaths += @(; Get-ChildItem -Path $expandedPath -Force -Recurse -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; try {; $foundAbsolutePaths += @(; Get-Item -Path $expandedPath -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; $foundAbsolutePaths = $foundAbsolutePaths | Select-Object -Unique | Sort-Object -Property { $_.Length } -Descending; if (!$foundAbsolutePaths) {; Write-Host 'Skipping, no items available.'; exit 0; }; Write-Host "^""Initiating processing of $($foundAbsolutePaths.Count) items from `"^""$expandedPath`"^""."^""; foreach ($path in $foundAbsolutePaths) {; if (-not (Test-Path $path)) { <# Re-check existence as prior deletions might remove subsequent items (e.g., subdirectories). #>; Write-Host "^""Successfully deleted: $($path) (already deleted)."^""; $deletedCount++; continue; }; try {; Remove-Item -Path $path -Force -Recurse -ErrorAction Stop; $deletedCount++; Write-Host "^""Successfully deleted: $($path)"^""; } catch {; $failedCount++; Write-Warning "^""Unable to delete $($path): $_"^""; }; }; Write-Host "^""Successfully deleted $($deletedCount) items."^""; if ($failedCount -gt 0) {; Write-Warning "^""Failed to delete $($failedCount) items."^""; }"
:: Clear directory contents  : "%TEMP%\VSTelem.Out"
PowerShell -ExecutionPolicy Unrestricted -Command "$pathGlobPattern = "^""$($directoryGlob = '%TEMP%\VSTelem.Out'; if ($directoryGlob.EndsWith('\*')) { $directoryGlob } elseif ($directoryGlob.EndsWith('\')) { "^""$($directoryGlob)*"^"" } else { "^""$($directoryGlob)\*"^"" } )"^""; $expandedPath = [System.Environment]::ExpandEnvironmentVariables($pathGlobPattern); Write-Host "^""Searching for items matching pattern: `"^""$($expandedPath)`"^""."^""; $deletedCount = 0; $failedCount = 0; $foundAbsolutePaths = @(); Write-Host 'Iterating files and directories recursively.'; try {; $foundAbsolutePaths += @(; Get-ChildItem -Path $expandedPath -Force -Recurse -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; try {; $foundAbsolutePaths += @(; Get-Item -Path $expandedPath -ErrorAction Stop | Select-Object -ExpandProperty FullName; ); } catch [System.Management.Automation.ItemNotFoundException] {; <# Swallow, do not run `Test-Path` before, it's unreliable for globs requiring extra permissions #>; }; $foundAbsolutePaths = $foundAbsolutePaths | Select-Object -Unique | Sort-Object -Property { $_.Length } -Descending; if (!$foundAbsolutePaths) {; Write-Host 'Skipping, no items available.'; exit 0; }; Write-Host "^""Initiating processing of $($foundAbsolutePaths.Count) items from `"^""$expandedPath`"^""."^""; foreach ($path in $foundAbsolutePaths) {; if (-not (Test-Path $path)) { <# Re-check existence as prior deletions might remove subsequent items (e.g., subdirectories). #>; Write-Host "^""Successfully deleted: $($path) (already deleted)."^""; $deletedCount++; continue; }; try {; Remove-Item -Path $path -Force -Recurse -ErrorAction Stop; $deletedCount++; Write-Host "^""Successfully deleted: $($path)"^""; } catch {; $failedCount++; Write-Warning "^""Unable to delete $($path): $_"^""; }; }; Write-Host "^""Successfully deleted $($deletedCount) items."^""; if ($failedCount -gt 0) {; Write-Warning "^""Failed to delete $($failedCount) items."^""; }"
:: END OF VISUAL STUDIO CLEANING :: CREDITS TO PRIVACY.SEXY
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" /v "1" /t REG_SZ /d "software_reporter_tool.exe" /f
reg add "HKLM\Software\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /v "NoGenTicket" /t "REG_DWORD" /d "1" /f
reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "MetricsReportingEnabled" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "ChromeCleanupReportingEnabled" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v AllowOutdatedPlugins /d "0" /t REG_DWORD /f
reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v DefaultCookiesSetting /d "0" /t REG_DWORD /f
reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v RemoteAccessHostAllowClientPairing /d "0" /t REG_DWORD /f
reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v CloudPrintProxyEnabled /d "0" /t REG_DWORD /f
reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v MetricsReportingEnabled /d "0" /t REG_DWORD /f
:: reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v SitePerProcess /d "1" /t REG_DWORD /f >nul Not needed for everyone
reg add "HKLM\Software\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f >nul
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Biometrics\FacialFeatures" /v "EnhancedAntiSpoofing" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\W32time\TimeProviders\NtpClient" /v "EventLogFlags" /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Assistance\Client\1.0" /v "NoExplicitFeedback" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Assistance\Client\1.0" /v "NoImplicitFeedback" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Assistance\Client\1.0" /v "NoOnlineAssist" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Assistance\Client\1.0" /v "NoActiveHelp" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\HandwritingErrorReports" /v "PreventHandwritingErrorReports" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\TabletPC" /v "PreventHandwritingDataSharing" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "AllowInputPersonalization" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports" /v "PreventHandwritingErrorReports" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\TabletPC" /v "PreventHandwritingDataSharing" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Internet Explorer\Safety\PrivacIE" /v "DisableLogging" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Internet Explorer\Safety\PrivacIE" /v "DisableLogging" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Internet Explorer\PhishingFilter" /v "EnabledV9" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Internet Explorer\PhishingFilter" /v "EnabledV9" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Internet Explorer\SQM" /v "DisableCustomerImprovementProgram" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Internet Explorer\SQM" /v "DisableCustomerImprovementProgram" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Internet Explorer" /v "AllowServicePoweredQSA" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Internet Explorer\DomainSuggestion" /v "Enabled" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Internet Explorer\SearchScopes" /v "TopResult" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Internet Explorer\Suggested Sites" /v "Enabled" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" /v "AutoSearch" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Internet Explorer\Main\WindowsSearch" /v "EnabledScopes" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Internet Explorer\ContinuousBrowsing" /v "Enabled" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" /v "DEPOff" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" /v "Isolation64Bit" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Internet Explorer\PrefetchPrerender" /v "Enabled" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Internet Explorer\Restrictions" /v "NoCrashDetection" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings" /v "CallLegacyWCMPolicies" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings" /v "EnableSSL3Fallback" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings" /v "PreventIgnoreCertErrors" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\MicrosoftEdge\Main" /v "PreventLiveTileDataCollection" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\EdgeUI" /v "DisableMFUTracking" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\EdgeUI" /v "DisableRecentApps" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\EdgeUI" /v "TurnOffBackstack" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "LimitEnhancedDiagnosticDataWindowsAnalytics" /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Explorer" /v "HidePeopleBar" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Windows Error Reporting" /v "DontSendAdditionalData" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting" /v "DoReport" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting" /v "ForceQueueMode" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting\DW" /v "DWNoExternalURL" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting\DW" /v "DWNoFileCollection" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting\DW" /v "DWNoSecondLevelCollection" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\PCHealth\HelpSvc" /v "Headlines" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\PCHealth\HelpSvc" /v "MicrosoftKBSearch" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Settings" /v "DisableSendGenericDriverNotFoundToWER" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Settings" /v "DisableSendRequestAdditionalSoftwareToWER" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "DontSendAdditionalData" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows NT\Terminal Services" /v "AllowSignedFiles" /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows NT\Terminal Services" /v "AllowUnsignedFiles" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Conferencing" /v "NoRDS" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\VisualStudio\Feedback" /v "DisableFeedbackDialog" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\VisualStudio\Feedback" /v "DisableEmailInput" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\VisualStudio\Feedback" /v "DisableScreenshotCapture" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service\WinRS" /v "AllowRemoteShellAccess" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v "CreateEncryptedOnlyTickets" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v "fAllowToGetHelp" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v "fAllowUnsolicited" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v "fDenyTSConnections" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services\Client" /v "fEnableUsbBlockDeviceBySetupClass" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services\Client" /v "fEnableUsbNoAckIsochWriteToDevice" /t REG_DWORD /d 80 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services\Client" /v "fEnableUsbSelectDeviceByInterface" /t REG_DWORD /d 1 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\StandardProfile\RemoteAdminSettings" /v "Enabled" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\StandardProfile\Services\RemoteDesktop" /v "Enabled" /t REG_DWORD /d 0 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall\StandardProfile\Services\UPnPFramework" /v "Enabled" /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\office\16.0\common\ptwatson" /v "ptwoptin" /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\office\16.0\firstrun" /v "bootedrtm" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\office\16.0\firstrun" /v "disablemovie" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\office\16.0\osm" /v "enablefileobfuscation" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\office\16.0\osm" /v "enablelogging" /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\office\16.0\osm" /v "enableupload" /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\office\16.0\osm\preventedapplications" /v "accesssolution" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\office\16.0\osm\preventedapplications" /v "olksolution" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\office\16.0\osm\preventedapplications" /v "onenotesolution" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\office\16.0\osm\preventedapplications" /v "pptsolution" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\office\16.0\osm\preventedapplications" /v "projectsolution" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\office\16.0\osm\preventedapplications" /v "publishersolution" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\office\16.0\osm\preventedapplications" /v "visiosolution" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\office\16.0\osm\preventedapplications" /v "wdsolution" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\office\16.0\osm\preventedapplications" /v "xlsolution" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\office\16.0\osm\preventedsolutiontypes" /v "agave" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\office\16.0\osm\preventedsolutiontypes" /v "appaddins" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\office\16.0\osm\preventedsolutiontypes" /v "comaddins" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\office\16.0\osm\preventedsolutiontypes" /v "documentfiles" /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\office\16.0\osm\preventedsolutiontypes" /v "templatefiles" /t REG_DWORD /d 1 /f
reg add "HKCU\SOFTWARE\Microsoft\Office\15.0\Outlook\Options\Mail" /v "EnableLogging" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Outlook\Options\Mail" /v "EnableLogging" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Office\15.0\Outlook\Options\Calendar" /v "EnableCalendarLogging" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Outlook\Options\Calendar" /v "EnableCalendarLogging" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Office\15.0\Word\Options" /v "EnableLogging" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Word\Options" /v "EnableLogging" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Policies\Microsoft\Office\15.0\OSM" /v "EnableLogging" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Policies\Microsoft\Office\16.0\OSM" /v "EnableLogging" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Policies\Microsoft\Office\15.0\OSM" /v "EnableUpload" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Policies\Microsoft\Office\16.0\OSM" /v "EnableUpload" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Office\Common\ClientTelemetry" /v "DisableTelemetry" /t REG_DWORD /d 1 /f
reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Common\ClientTelemetry" /v "DisableTelemetry" /t REG_DWORD /d 1 /f
reg add "HKCU\SOFTWARE\Microsoft\Office\Common\ClientTelemetry" /v "VerboseLogging" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Common\ClientTelemetry" /v "VerboseLogging" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Office\15.0\Common" /v "QMEnable" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Common" /v "QMEnable" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Office\15.0\Common\Feedback" /v "Enabled" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Office\16.0\Common\Feedback" /v "Enabled" /t REG_DWORD /d 0 /f
schtasks /change /TN "Microsoft\Office\OfficeTelemetryAgentFallBack" /DISABLE
schtasks /change /TN "Microsoft\Office\OfficeTelemetryAgentFallBack2016" /DISABLE
schtasks /change /TN "Microsoft\Office\OfficeTelemetryAgentLogOn" /DISABLE
schtasks /change /TN "Microsoft\Office\OfficeTelemetryAgentLogOn2016" /DISABLE
reg add "HKCU\SOFTWARE\Microsoft\MediaPlayer\Preferences" /v "UsageTracking" /t REG_DWORD /d 0 /f
setx DOTNET_CLI_TELEMETRY_OPTOUT 1
setx POWERSHELL_TELEMETRY_OPTOUT 1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\Network Protection" /v "EnableNetworkProtection" /t REG_DWORD /d 1 /f
schtasks /change /tn "\Microsoft\Windows\Windows Error Reporting\QueueReporting" /disable
REM ; CCLEANER HARDENING
reg add "HKCU\Software\Piriform\CCleaner" /v "Monitoring" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Piriform\CCleaner" /v "HelpImproveCCleaner" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Piriform\CCleaner" /v "SystemMonitoring" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Piriform\CCleaner" /v "UpdateAuto" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Piriform\CCleaner" /v "UpdateCheck" /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Piriform\CCleaner" /v "CheckTrialOffer" /t REG_DWORD /d 0 /f
reg add "HKLM\Software\Piriform\CCleaner" /v "(Cfg)HealthCheck" /t REG_DWORD /d 0 /f
reg add "HKLM\Software\Piriform\CCleaner" /v "(Cfg)QuickClean" /t REG_DWORD /d 0 /f
reg add "HKLM\Software\Piriform\CCleaner" /v "(Cfg)QuickCleanIpm" /t REG_DWORD /d 0 /f
reg add "HKLM\Software\Piriform\CCleaner" /v "(Cfg)GetIpmForTrial" /t REG_DWORD /d 0 /f
reg add "HKLM\Software\Piriform\CCleaner" /v "(Cfg)SoftwareUpdater" /t REG_DWORD /d 0 /f
reg add "HKLM\Software\Piriform\CCleaner" /v "(Cfg)SoftwareUpdaterIpm" /t REG_DWORD /d 0 /f
REM ; Deletes spy firewall rules, registry
powershell -Command "& {Get-NetFirewallRule | Where { $_.Group -like '*@{*' } | Remove-NetFirewallRule;}"
powershell -Command "& {Get-NetFirewallRule | Where { $_.Group -eq 'DiagTrack' } | Remove-NetFirewallRule;}"
powershell -Command "& {Get-NetFirewallRule | Where { $_.DisplayGroup -eq 'Delivery Optimization' } | Remove-NetFirewallRule;}"
powershell -Command "& {Get-NetFirewallRule | Where { $_.DisplayGroup -like 'Windows Media Player Network Sharing Service*' } | Remove-NetFirewallRule;}"
REM ; Disables Some Windows Tracking Via Firewall
Set-NetFirewallProfile -all
netsh advfirewall firewall add rule name="telemetry_vortex.data.microsoft.com" dir=out action=block remoteip=191.232.139.254 enable=yes
netsh advfirewall firewall add rule name="telemetry_telecommand.telemetry.microsoft.com" dir=out action=block remoteip=65.55.252.92 enable=yes
netsh advfirewall firewall add rule name="telemetry_oca.telemetry.microsoft.com" dir=out action=block remoteip=65.55.252.63 enable=yes
netsh advfirewall firewall add rule name="telemetry_sqm.telemetry.microsoft.com" dir=out action=block remoteip=65.55.252.93 enable=yes
netsh advfirewall firewall add rule name="telemetry_watson.telemetry.microsoft.com" dir=out action=block remoteip=65.55.252.43,65.52.108.29 enable=yes
netsh advfirewall firewall add rule name="telemetry_redir.metaservices.microsoft.com" dir=out action=block remoteip=194.44.4.200,194.44.4.208 enable=yes
netsh advfirewall firewall add rule name="telemetry_choice.microsoft.com" dir=out action=block remoteip=157.56.91.77 enable=yes
netsh advfirewall firewall add rule name="telemetry_df.telemetry.microsoft.com" dir=out action=block remoteip=65.52.100.7 enable=yes
netsh advfirewall firewall add rule name="telemetry_reports.wes.df.telemetry.microsoft.com" dir=out action=block remoteip=65.52.100.91 enable=yes
netsh advfirewall firewall add rule name="telemetry_wes.df.telemetry.microsoft.com" dir=out action=block remoteip=65.52.100.93 enable=yes
netsh advfirewall firewall add rule name="telemetry_services.wes.df.telemetry.microsoft.com" dir=out action=block remoteip=65.52.100.92 enable=yes
netsh advfirewall firewall add rule name="telemetry_sqm.df.telemetry.microsoft.com" dir=out action=block remoteip=65.52.100.94 enable=yes
netsh advfirewall firewall add rule name="telemetry_telemetry.microsoft.com" dir=out action=block remoteip=65.52.100.9 enable=yes
netsh advfirewall firewall add rule name="telemetry_watson.ppe.telemetry.microsoft.com" dir=out action=block remoteip=65.52.100.11 enable=yes
netsh advfirewall firewall add rule name="telemetry_telemetry.appex.bing.net" dir=out action=block remoteip=168.63.108.233 enable=yes
netsh advfirewall firewall add rule name="telemetry_telemetry.urs.microsoft.com" dir=out action=block remoteip=157.56.74.250 eable=yes
netsh advfirewall firewall add rule name="telemetry_settings-sandbox.data.microsoft.com" dir=out action=block remoteip=111.221.29.177 enable=yes
netsh advfirewall firewall add rule name="telemetry_vortex-sandbox.data.microsoft.com" dir=out action=block remoteip=64.4.54.32 enable=yes
netsh advfirewall firewall add rule name="telemetry_survey.watson.microsoft.com" dir=out action=block remoteip=207.68.166.254 enable=yes
netsh advfirewall firewall add rule name="telemetry_watson.live.com" dir=out action=block remoteip=207.46.223.94 enable=yes
netsh advfirewall firewall add rule name="telemetry_watson.microsoft.com" dir=out action=block remoteip=65.55.252.71 enable=yes
netsh advfirewall firewall add rule name="telemetry_statsfe2.ws.microsoft.com" dir=out action=block remoteip=64.4.54.22 enable=yes
netsh advfirewall firewall add rule name="telemetry_corpext.msitadfs.glbdns2.microsoft.com" dir=out action=block remoteip=131.107.113.238 enable=yes
netsh advfirewall firewall add rule name="telemetry_compatexchange.cloudapp.net" dir=out action=block remoteip=23.99.10.11 enable=yes
netsh advfirewall firewall add rule name="telemetry_cs1.wpc.v0cdn.net" dir=out action=block remoteip=68.232.34.200 enable=yes
netsh advfirewall firewall add rule name="telemetry_a-0001.a-msedge.net" dir=out action=block remoteip=204.79.197.200 enable=yes
netsh advfirewall firewall add rule name="telemetry_statsfe2.update.microsoft.com.akadns.net" dir=out action=block remoteip=64.4.54.22 enable=yes
netsh advfirewall firewall add rule name="telemetry_sls.update.microsoft.com.akadns.net" dir=out action=block remoteip=157.56.77.139 enable=yes
netsh advfirewall firewall add rule name="telemetry_fe2.update.microsoft.com.akadns.net" dir=out action=block remoteip=134.170.58.121,134.170.58.123,134.170.53.29,66.119.144.190,134.170.58.189,134.170.58.118,134.170.53.30,134.170.51.190 enable=yes
netsh advfirewall firewall add rule name="telemetry_diagnostics.support.microsoft.com" dir=out action=block remoteip=157.56.121.89 enable=yes
netsh advfirewall firewall add rule name="telemetry_corp.sts.microsoft.com" dir=out action=block remoteip=131.107.113.238 enable=yes
netsh advfirewall firewall add rule name="telemetry_statsfe1.ws.microsoft.com" dir=out action=block remoteip=134.170.115.60 enable=yes
netsh advfirewall firewall add rule name="telemetry_pre.footprintpredict.com" dir=out action=block remoteip=204.79.197.200 enable=yes
netsh advfirewall firewall add rule name="telemetry_i1.services.social.microsoft.com" dir=out action=block remoteip=104.82.22.249 enable=yes
netsh advfirewall firewall add rule name="telemetry_feedback.windows.com" dir=out action=block remoteip=134.170.185.70 enable=yes
netsh advfirewall firewall add rule name="telemetry_feedback.microsoft-hohm.com" dir=out action=block remoteip=64.4.6.100,65.55.39.10 enable=yes
netsh advfirewall firewall add rule name="telemetry_feedback.search.microsoft.com" dir=out action=block remoteip=157.55.129.21 enable=yes
netsh advfirewall firewall add rule name="telemetry_rad.msn.com" dir=out action=block remoteip=207.46.194.25 enable=yes
netsh advfirewall firewall add rule name="telemetry_preview.msn.com" dir=out action=block remoteip=23.102.21.4 enable=yes
netsh advfirewall firewall add rule name="telemetry_dart.l.doubleclick.net" dir=out action=block remoteip=173.194.113.220,173.194.113.219,216.58.209.166 enable=yes
netsh advfirewall firewall add rule name="telemetry_ads.msn.com" dir=out action=block remoteip=157.56.91.82,157.56.23.91,104.82.14.146,207.123.56.252,185.13.160.61,8.254.209.254 enable=yes
netsh advfirewall firewall add rule name="telemetry_a.ads1.msn.com" dir=out action=block remoteip=198.78.208.254,185.13.160.61 enable=yes
netsh advfirewall firewall add rule name="telemetry_global.msads.net.c.footprint.net" dir=out action=block remoteip=185.13.160.61,8.254.209.254,207.123.56.252 enable=yes
netsh advfirewall firewall add rule name="telemetry_az361816.vo.msecnd.net" dir=out action=block remoteip=68.232.34.200 enable=yes
netsh advfirewall firewall add rule name="telemetry_oca.telemetry.microsoft.com.nsatc.net" dir=out action=block remoteip=65.55.252.63 enable=yes
netsh advfirewall firewall add rule name="telemetry_reports.wes.df.telemetry.microsoft.com" dir=out action=block remoteip=65.52.100.91 enable=yes
netsh advfirewall firewall add rule name="telemetry_df.telemetry.microsoft.com" dir=out action=block remoteip=65.52.100.7 enable=yes
netsh advfirewall firewall add rule name="telemetry_cs1.wpc.v0cdn.net" dir=out action=block remoteip=68.232.34.200 enable=yes
netsh advfirewall firewall add rule name="telemetry_vortex-sandbox.data.microsoft.com" dir=out action=block remoteip=64.4.54.32 enable=yes
netsh advfirewall firewall add rule name="telemetry_pre.footprintpredict.com" dir=out action=block remoteip=204.79.197.200 enable=yes
netsh advfirewall firewall add rule name="telemetry_i1.services.social.microsoft.com" dir=out action=block remoteip=104.82.22.249 enable=yes
netsh advfirewall firewall add rule name="telemetry_ssw.live.com" dir=out action=block remoteip=207.46.101.29 enable=yes
netsh advfirewall firewall add rule name="telemetry_statsfe1.ws.microsoft.com" dir=out action=block remoteip=134.170.115.60 enable=yes
netsh advfirewall firewall add rule name="telemetry_msnbot-65-55-108-23.search.msn.com" dir=out action=block remoteip=65.55.108.23 enable=yes
netsh advfirewall firewall add rule name="telemetry_a23-218-212-69.deploy.static.akamaitechnologies.com" dir=out action=block remoteip=23.218.212.69 enable=yes
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v "DODownloadMode" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v "DODownloadMode" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\RemovalTools\MpGears" /v "SpyNetReportingLocation" /t REG_SZ /d "0" /f
reg add "HKLM\SOFTWARE\Microsoft\RemovalTools\MpGears" /v "HeartbeatTrackingIndex" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Microsoft\Input\Settings" /v "HarvestContacts" /t REG_DWORD /d "0" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSyncProviderNotifications" /t REG_DWORD /d "0" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackDocs" /t REG_DWORD /d "0" /f
reg add "HKLM\SYSTEM\ControlSet001\Control\Lsa\MSV1_0" /v "RestrictReceivingNTLMTraffic" /t REG_DWORD /d "2" /f
reg add "HKLM\SYSTEM\ControlSet002\Control\Lsa\MSV1_0" /v "RestrictReceivingNTLMTraffic" /t REG_DWORD /d "2" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0" /v "RestrictReceivingNTLMTraffic" /t REG_DWORD /d "2" /f
reg add "HKLM\SYSTEM\ControlSet001\Control\Lsa\MSV1_0" /v "RestrictSendingNTLMTraffic" /t REG_DWORD /d "2" /f
reg add "HKLM\SYSTEM\ControlSet002\Control\Lsa\MSV1_0" /v "RestrictSendingNTLMTraffic" /t REG_DWORD /d "2" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0" /v "RestrictSendingNTLMTraffic" /t REG_DWORD /d "2" /f
reg add "HKLM\SYSTEM\ControlSet001\Services\LanmanServer\Parameters" /v "SMB1" /t REG_DWORD /d "0" /f
reg add "HKLM\SYSTEM\ControlSet002\Services\LanmanServer\Parameters" /v "SMB1" /t REG_DWORD /d "0" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "SMB1" /t REG_DWORD /d "0" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackProgs" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" /v "SubmitSamplesConsent" /t REG_DWORD /d "2" /f
REM ; Disables unused services to safe power
schtasks /Change /TN "Microsoft\Windows\AppID\SmartScreenSpecific" /Disable
schtasks /Change /TN "Microsoft\Windows\Autochk\Proxy" /Disable
schtasks /Change /TN "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Disable
schtasks /Change /TN "Microsoft\Windows\FileHistory\File History (maintenance mode)" /Disable
schtasks /Change /TN "Microsoft\Windows\Maintenance\WinSAT" /Disable
schtasks /Change /TN "Microsoft\Windows\NetTrace\GatherNetworkInfo" /Disable
schtasks /Change /TN "Microsoft\Windows\PI\Sqm-Tasks" /Disable
schtasks /Change /TN "Microsoft\Windows\Time Synchronization\ForceSynchronizeTime" /Disable
schtasks /Change /TN "Microsoft\Windows\Time Synchronization\SynchronizeTime" /Disable
schtasks /Change /TN "Microsoft\Windows\Windows Error Reporting\QueueReporting" /Disable
cls & echo Building protection against Powershell 2.0 downgrade attacks . . . . .
dism /online /Disable-Feature /FeatureName:"MicrosoftWindowsPowerShellV2Root" /NoRestart
dism /online /Disable-Feature /FeatureName:"MicrosoftWindowsPowerShellV2" /NoRestart
cls & echo Disabling unsafe SMBv1 protocol
dism /online /Disable-Feature /FeatureName:"SMB1Protocol" /NoRestart
dism /Online /Disable-Feature /FeatureName:"SMB1Protocol-Client" /NoRestart
dism /Online /Disable-Feature /FeatureName:"SMB1Protocol-Server" /NoRestart
REM ; UPDATING SIGNATURES FOR WINDOWS DEFENDER .....
"%ProgramFiles%"\"Windows Defender"\MpCmdRun.exe -SignatureUpdate
REM ; ENABLING WINDOWS DEFENDER PUA FOR POTENTIONALLY UNVANTED APPS
powershell.exe Set-MpPreference -PUAProtection enable
REM ; OFFICE HARDENING
powershell.exe Add-MpPreference -AttackSurfaceReductionRules_Ids 75668C1F-73B5-4CF0-BB93-3ECF5CB7CC84 -AttackSurfaceReductionRules_Actions enable
powershell.exe Set-MpPreference -AttackSurfaceReductionRules_Ids D1E49AAC-8F56-4280-B9BA-993A6D -AttackSurfaceReductionRules_Actions Enabled
powershell.exe Add-MpPreference -AttackSurfaceReductionRules_Ids D4F940AB-401B-4EFC-AADC-AD5F3C50688A -AttackSurfaceReductionRules_Actions Enabled
powershell.exe Add-MpPreference -AttackSurfaceReductionRules_Ids 3B576869-A4EC-4529-8536-B80A7769E899 -AttackSurfaceReductionRules_Actions enable
REM ; Advanced protection against ransomware WINDOWS DEFENDER
powershell.exe Add-MpPreference -AttackSurfaceReductionRules_Ids C1DB55AB-C21A-4637-BB3F-A12568109D35 -AttackSurfaceReductionRules_Actions Enabled
cls
goto :next
:next
cls
timeout /t 2 > nul
cd %systemroot%\system32
echo ******************************
echo * *                        * *
echo.   Enable Windows Defender?
echo * *                        * *
echo ******************************
echo. Press "Y" to apply
echo. Press "N" to skip
echo.
set /p choice=Enter choice [Y/N]: 
IF /I "%choice%"=="Y" goto apply
IF /I "%choice%"=="N" goto next
echo.
:apply
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\Sense" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\WdNisSvc" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\WdFilter" /v "Start" /t REG_DWORD /d "2" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\WinDefend" /v "Start" /t REG_DWORD /d "2" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\SamSs" /v "Start" /t REG_DWORD /d "2" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\wscsvc" /v "Start" /t REG_DWORD /d "2" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\SgrmBroker" /v "Start" /t REG_DWORD /d "2" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\SecurityHealthService" /v "Start" /t REG_DWORD /d "3" /f
net start Sense
net start WdFilter
net start WdNisSvc
net start WinDefend
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender" /v "DisableAntiVirus" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender" /v "DisableRoutinelyTakingAction" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender" /v "OneTimeSqmDataSent" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SpyNetReporting" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SubmitSamplesConsent" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableBehaviorMonitoring" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableOnAccessProtection" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableScanOnRealtimeEnable" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\UX Configuration" /v "DisablePrivacyMode" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Scan" /v "AutomaticallyCleanAfterScan" /t REG_DWORD /d "1" /f
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance" /Enable
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Cleanup" /Enable
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" /Enable
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Verification" /Enable
reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontOfferThroughWUAU" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontReportInfectionInformation" /t REG_DWORD /d "0" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WdNisDrv" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WdFilter" /v "Start" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" /v "DisableAntiSpywareRealtimeProtection" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" /v "DpaDisabled" /t REG_DWORD /d "0" /f
:: reg add "HKLM\SOFTWARE\Microsoft\Windows Defender" /v "ProductStatus" /t REG_DWORD /d "0" /f
:: reg add "HKLM\SOFTWARE\Microsoft\Windows Defender" /v "ManagedDefenderProductType" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontReportInfectionInformation" /t REG_DWORD /d "0" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SecurityHealthService" /v "Start" /t REG_DWORD /d "3" /f
cls
goto :next
:next
cls
timeout /t 2 > nul
cd %systemroot%\system32
echo *******************************
echo * *                         * *
echo.   Disable Windows Defender?
echo * *                         * *
echo *******************************
echo. Press "Y" to apply
echo. Press "N" to skip
echo.
set /p choice=Enter choice [Y/N]: 
IF /I "%choice%"=="Y" goto apply
IF /I "%choice%"=="N" goto next
echo.
:apply
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\Sense" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\WdNisSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\WdFilter" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\WinDefend" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\SamSs" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\wscsvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\SgrmBroker" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\SecurityHealthService" /v "Start" /t REG_DWORD /d "4" /f
net stop Sense
net stop WdFilter
net stop WdNisSvc
net stop WinDefend
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender" /v "DisableAntiVirus" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender" /v "DisableRoutinelyTakingAction" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender" /v "OneTimeSqmDataSent" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SpyNetReporting" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SubmitSamplesConsent" /t REG_DWORD /d "2" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableBehaviorMonitoring" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableOnAccessProtection" /t REG_DWORD /d "2" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableScanOnRealtimeEnable" /t REG_DWORD /d "2" /f
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\UX Configuration" /v "DisablePrivacyMode" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Scan" /v "AutomaticallyCleanAfterScan" /t REG_DWORD /d "0" /f
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance" /Disable
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Cleanup" /Disable
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" /Disable
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Verification" /Disable
reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontOfferThroughWUAU" /t REG_DWORD /d "2" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontReportInfectionInformation" /t REG_DWORD /d "2" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WdNisDrv" /v "Start" /t REG_DWORD /d "2" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WdBoot" /v "Start" /t REG_DWORD /d "2" /f 
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WdFilter" /v "Start" /t REG_DWORD /d "2" /f
:: regsvr32 /s /u "%ProgramFiles%\Windows Defender\shellext.dll"
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" /v "DisableAntiSpywareRealtimeProtection" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" /v "DpaDisabled" /t REG_DWORD /d "1" /f
:: reg add "HKLM\SOFTWARE\Microsoft\Windows Defender" /v "ProductStatus" /t REG_DWORD /d "0" /f
:: reg add "HKLM\SOFTWARE\Microsoft\Windows Defender" /v "ManagedDefenderProductType" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontReportInfectionInformation" /t REG_DWORD /d "1" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SecurityHealthService" /v "Start" /t REG_DWORD /d "4" /f
cls
goto :next
:next
cls
echo ******************************
echo * *                        * *
echo.   Enable Windows Firewall?
echo * *                        * *
echo ******************************
echo. Press "Y" to apply
echo. Press "N" to skip
echo.
set /p choice=Enter choice [Y/N]: 
IF /I "%choice%"=="Y" goto apply
IF /I "%choice%"=="N" goto next
echo.
:apply
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\mpssvc" /v "Start" /t REG_DWORD /d "2" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\BFE" /v "Start" /t REG_DWORD /d "2" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile" /v "EnableFirewall" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile" /v "DisableNotifications" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile" /v "DoNotAllowExceptions" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile" /v "EnableFirewall" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile" /v "DisableNotifications" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile" /v "DoNotAllowExceptions" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile" /v "EnableFirewall" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile" /v "DisableNotifications" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile" /v "DoNotAllowExceptions" /t REG_DWORD /d "0" /f
cls
goto :next
:next
cls
echo *******************************
echo * *                         * *
echo.   Disable Windows Firewall?
echo * *                         * *
echo ********************************
echo. Press "Y" to apply
echo. Press "N" to skip
echo.
set /p choice=Enter choice [Y/N]: 
IF /I "%choice%"=="Y" goto apply
IF /I "%choice%"=="N" goto next
echo.
:apply
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\mpssvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\BFE" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile" /v "EnableFirewall" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile" /v "DisableNotifications" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile" /v "DoNotAllowExceptions" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile" /v "EnableFirewall" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile" /v "DisableNotifications" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile" /v "DoNotAllowExceptions" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile" /v "EnableFirewall" /t REG_DWORD /d "0" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile" /v "DisableNotifications" /t REG_DWORD /d "1" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile" /v "DoNotAllowExceptions" /t REG_DWORD /d "1" /f
goto :next
:next
cls
echo ***********************************
echo * *                             * *
echo.   Want to set High Performance?
echo * *                             * *
echo ***********************************
echo. Press "Y" to apply
echo. Press "N" to skip
echo.
set /p choice=Enter choice [Y/N]: 
IF /I "%choice%"=="Y" goto apply
IF /I "%choice%"=="N" goto next
echo.
:apply
powercfg setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
goto :next
:next
cls
echo **************************************************
echo * *                                            * *
echo.   Want to optimize SSD? (Only if you have SSD)
echo * *                                            * *
echo **************************************************
echo. Press "Y" to apply
echo. Press "N" to skip
echo.
set /p choice=Enter choice [Y/N]: 
IF /I "%choice%"=="Y" goto apply
IF /I "%choice%"=="N" goto next
echo.
:apply
Fsutil behavior query disabledeletenotify 0
cls
sc stop sysmain
cls
sc config sysmain start=disabled
reg add "HKLM\SYSTEM\CurrentControlSet\Services\defragsvc" /v "Start" /t REG_DWORD /d "4" /f
schtasks /Delete /TN "\Microsoft\Windows\Defrag\ScheduledDefrag" /F
goto :next
:next
cls
netsh int tcp set global autotuninglevel=normal > nul
netsh interface 6to4 set state disabled > nul
netsh int isatap set state disable > nul
netsh int tcp set global timestamps=disabled > nul
netsh int tcp set heuristics disabled > nul
netsh int tcp set global chimney=disabled > nul
netsh int tcp set global ecncapability=disabled > nul
netsh int tcp set global rsc=disabled > nul
netsh int tcp set global nonsackrttresiliency=disabled > nul
netsh int tcp set security mpp=disabled > nul
netsh int tcp set security profiles=disabled > nul
netsh int ip set global icmpredirects=disabled > nul
netsh int tcp set security mpp=disabled profiles=disabled > nul
netsh int ip set global multicastforwarding=disabled > nul
netsh int tcp set supplemental internet congestionprovider=ctcp > nul
netsh interface teredo set state disabled > nul
netsh winsock reset > nul
netsh int isatap set state disable > nul
netsh int ip set global taskoffload=disabled > nul
netsh int ip set global neighborcachelimit=4096 > nul
netsh int tcp set global dca=enabled > nul
netsh int tcp set global netdma=enabled > nul
PowerShell Disable-NetAdapterLso -Name "*" > nul
powershell "ForEach($adapter In Get-NetAdapter){Disable-NetAdapterPowerManagement -Name $adapter.Name -ErrorAction SilentlyContinue}" > nul
powershell "ForEach($adapter In Get-NetAdapter){Disable-NetAdapterLso -Name $adapter.Name -ErrorAction SilentlyContinue}" > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableICMPRedirect" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnablePMTUDiscovery" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "Tcp1323Opts" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpMaxDupAcks" /t REG_DWORD /d "2" /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpTimedWaitDelay" /t REG_DWORD /d "32" /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "GlobalMaxTcpWindowSize" /t REG_DWORD /d "8760" /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "TcpWindowSize" /t REG_DWORD /d "8760" /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxConnectionsPerServer" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "MaxUserPort" /t REG_DWORD /d "65534" /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "SackOpts" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DefaultTTL" /t REG_DWORD /d "64" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d "4294967295" /f > nul
ipconfig /flushdns > nul
REM ; Disable network power saving
for /f %%r in ('reg query "HKLM\SYSTEM\ControlSet001\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}" /f "PCI\VEN_" /d /s^|Findstr HKEY_') do (
reg add %%r /v "AutoDisableGigabit" /t REG_SZ /d "0" /f > nul
reg add %%r /v "EnableGreenEthernet" /t REG_SZ /d "0" /f > nul
reg add %%r /v "GigaLite" /t REG_SZ /d "0" /f > nul
reg add %%r /v "PowerSavingMode" /t REG_SZ /d "0" /f > nul
)
IF EXIST "%HomePath%\AppData\LocalLow\Temp" (
del /s /f /q %HomePath%\AppData\LocalLow\Temp\*.*
call :done
)
:done
:nextnoreg
echo Calculating how much space I can free up for you
set Folder="%USERPROFILE%\appdata\local\temp"
echo I can delete more than: & Call :GetSize %Folder% & echo junk files in temp folder
pause
:GetSize
(
echo wscript.echo GetSize("%~1"^)
echo Function GetSize(MyFolder^)
echo    Set fso = CreateObject("Scripting.FileSystemObject"^)
echo    Set objFolder= fso.GetFolder(MyFolder^)  
echo    GetSize = FormatSize(objFolder.Size^)
echo End Function
echo '*******************************************************************
echo 'Function to format a number into typical size scales
echo Function FormatSize(iSize^)
echo    aLabel = Array("bytes", "KB", "MB", "GB", "TB"^)
echo    For i = 0 to 4
echo        If iSize ^> 1024 Then
echo            iSize = iSize / 1024
echo        Else
echo            Exit For
echo        End If
echo    Next
echo    FormatSize = Round(iSize,2^) ^& " " ^& aLabel(i^)
echo End Function
echo '*******************************************************************
)>%tmp%\Size.vbs
Cscript /NoLogo %tmp%\Size.vbs
Del %tmp%\Size.vbs
echo Press anything to continue...
pause > nul
cls
cd /
echo.
echo Cleaning system junk files, please wait . . .
echo.
timeout /t 3 > nul
IF EXIST "%WinDir%\Temp" (
del /s /f /q %WinDir%\Temp\*.*
call :done
)
:done
cls
IF EXIST "%WinDir%\Prefetch" (
del /s /f /q %WinDir%\Prefetch\*.*
call :done
)
:done
cls
IF EXIST "%Temp%" (
del /s /f /q %Temp%\*.*
call :done
)
:done
cls
IF EXIST "%AppData%\Temp" (
del /s /f /q %AppData%\Temp\*.*
call :done
)
:done
cls
echo Cleaning system junk files, please wait . . .
echo Searching for temp files . . . (This may take a while) 10% DONE
del /f /s /q %systemdrive%\*.tmp
cls
echo Cleaning system junk files, please wait . . .
echo Searching for temp files . . . (This may take a while) 20% DONE
del /f /s /q %systemdrive%\*._mp
del "%LocalAppData%\Microsoft\Edge\User Data\Default\*history*." /s /f /q
del "%LocalAppData%\Microsoft\Edge\User Data\Default\LOG" /s /f /q
del "%LocalAppData%\Microsoft\Edge\User Data\Default\LOG.old" /s /f /q
del "%LocalAppData%\Microsoft\Edge\User Data\Default\Media History" /s /f /q
del "%LocalAppData%\Microsoft\Edge\User Data\Default\Media History-journal" /s /f /q
del "%LocalAppData%\Microsoft\Edge\User Data\Default\Network Action Predictor" /s /f /q
del "%LocalAppData%\Microsoft\Edge\User Data\Default\Network Action Predictor-journal" /s /f /q
del "%LocalAppData%\Microsoft\Edge\User Data\Default\Network Persistent State" /s /f /q
del "%LocalAppData%\Microsoft\Edge\User Data\Default\Reporting and NEL" /s /f /q
del "%LocalAppData%\Microsoft\Edge\User Data\Default\Reporting and NEL-journal" /s /f /q
del "%LocalAppData%\Microsoft\Edge\User Data\Default\QuotaManager" /s /f /q
del "%LocalAppData%\Microsoft\Edge\User Data\Default\QuotaManager-journal" /s /f /q
del "%LocalAppData%\Microsoft\Edge\User Data\Default\Shortcuts" /s /f /q
del "%LocalAppData%\Microsoft\Edge\User Data\Default\Shortcuts-journal" /s /f /q
del "%LocalAppData%\Microsoft\Edge\User Data\Default\Top Sites" /s /f /q
del "%LocalAppData%\Microsoft\Edge\User Data\Default\Top Sites-journal" /s /f /q
del "%LocalAppData%\Microsoft\Edge\User Data\Default\Visited Links" /s /f /q
del "%LocalAppData%\Microsoft\Edge\User Data\Default\Web Data" /s /f /q
del "%LocalAppData%\Microsoft\Edge\User Data\Default\Web Data-journal" /s /f /q
rd "%LocalAppData%\Microsoft\Edge\User Data\Default\AutofillStrikeDatabase" /s /q
rd "%LocalAppData%\Microsoft\Edge\User Data\Default\blob_storage" /s /q
rd "%LocalAppData%\Microsoft\Edge\User Data\Default\BudgetDatabase" /s /q
rd "%LocalAppData%\Microsoft\Edge\User Data\Default\Cache" /s /q
rd "%LocalAppData%\Microsoft\Edge\User Data\Default\Code Cache" /s /q
rd "%LocalAppData%\Microsoft\Edge\User Data\Default\Collections" /s /q
rd "%LocalAppData%\Microsoft\Edge\User Data\Default\data_reduction_proxy_leveldb" /s /q
rd "%LocalAppData%\Microsoft\Edge\User Data\Default\databases" /s /q
rd "%LocalAppData%\Microsoft\Edge\User Data\Default\File System" /s /q
rd "%LocalAppData%\Microsoft\Edge\User Data\Default\GPUCache" /s /q
rd "%LocalAppData%\Microsoft\Edge\User Data\Default\IndexedDB" /s /q
rd "%LocalAppData%\Microsoft\Edge\User Data\Default\Local Storage" /s /q
rd "%LocalAppData%\Microsoft\Edge\User Data\Default\Platform Notifications" /s /q
rd "%LocalAppData%\Microsoft\Edge\User Data\Default\Service Worker" /s /q	
rd "%LocalAppData%\Microsoft\Edge\User Data\Default\Session Storage" /s /q
rd "%LocalAppData%\Microsoft\Edge\User Data\Default\Sessions" /s /q
rd "%LocalAppData%\Microsoft\Edge\User Data\Default\shared_proto_db" /s /q
rd "%LocalAppData%\Microsoft\Edge\User Data\Default\Site Characteristics Database" /s /q
rd "%LocalAppData%\Microsoft\Edge\User Data\Default\VideoDecodeStats" /s /q
rd "%LocalAppData%\Microsoft\Windows\AppCache" /s /q
rd "%LocalAppData%\Microsoft\Windows\History" /s /q
rd "%LocalAppData%\Microsoft\Windows\IECompatCache" /s /q
rd "%LocalAppData%\Microsoft\Windows\IECompatUaCache" /s /q
rd "%LocalAppData%\Microsoft\Windows\INetCache" /s /q
rd "%LocalAppData%\Microsoft\Windows\INetCookies" /s /q
rd "%LocalAppData%\Microsoft\Windows\WebCache" /s /q
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 1
cls
echo Cleaning system junk files, please wait . . .
echo Searching for temp files . . . (This may take a while) 60% DONE
del /f /s /q %systemdrive%\*.log
cls
echo Cleaning system junk files, please wait . . .
echo Searching for temp files . . . (This may take a while) 70% DONE
del /f /s /q %systemdrive%\*.gid
cls
echo Cleaning system junk files, please wait . . .
echo Searching for temp files . . . (This may take a while) 80% DONE
del /f /s /q %systemdrive%\*.chk
cls
echo Cleaning system junk files, please wait . . .
echo Searching for temp files . . . (This may take a while)  90% DONE
del /f /s /q %systemdrive%\*.old
cls
del /f /s /q %systemdrive%\recycled\*.*
cls
echo Cleaning system junk files, please wait . . .
echo Searching for temp files . . . (This may take a while) 100% DONE
del /f /s /q %windir%\*.bak
cls
echo Cleaning system junk files, please wait . . .
del /f /s /q %windir%\prefetch\*.*
cls
echo Cleaning system junk files, please wait . . .
rd /s /q %windir%\temp & md %windir%\temp
cls
echo Cleaning system junk files, please wait . . .
del /f /q %userprofile%\cookies\*.*
cls
echo Cleaning system junk files, please wait . . .
del /f /q %userprofile%\recent\*.*
cls
echo Cleaning system junk files, please wait . . .
del /f /s /q "%userprofile%\Local Settings\Temporary Internet Files\*.*"
del /f /q "%userprofile%\AppData\Local\Microsoft\Windows\Temporary Internet Files\*.*"
cls
echo Cleaning system junk files, please wait . . .
del /f /s /q "%userprofile%\Local Settings\Temp\*.*"
cls
echo Cleaning system junk files, please wait . . .
del /f /s /q "%userprofile%\recent\*.*"
cls
echo Cleaning system junk files, please wait . . .
del /s /q %systemdrive%\$Recycle.bin
cls
echo Cleaning system junk files, please wait . . .
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 2
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 1
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8
echo Cleaning system junk files, please wait . . .
REM ; Dont worry :) It isnt deleting the drivers (these folders are only needed while driver is installed and these files can be more that 1gigabytes!)
del /s /f /q %SYSTEMDRIVE%\AMD\*.*
del /s /f /q %SYSTEMDRIVE%\NVIDIA\*.*
del /s /f /q %SYSTEMDRIVE%\INTEL\*.*
REM ; Deleting the whole folders
rd /s /q %SYSTEMDRIVE%\AMD
rd /s /q %SYSTEMDRIVE%\NVIDIA
rd /s /q %SYSTEMDRIVE%\INTEL
echo Cleaning system junk files, please wait . . .
cleanmgr /autoclean
echo Delete folders inside the temp folders.
pushd "C:\Windows\Temp"
rd /s /q . 2>nul
pushd %userprofile%\AppData\Local\Temp
rd /s /q . 2>nul
cls
cd/
echo **********************************
echo * *                            * *
echo.   Want to disable hibernation?
echo * *                            * *
echo **********************************
echo. Press "Y" to apply
echo. Press "N" to skip
echo.
set /p choice=Enter choice [Y/N]: 
IF /I "%choice%"=="Y" goto apply
IF /I "%choice%"=="N" goto next
echo.
:apply
echo Disabling hibernate . . .
timeout /t 3 > nul
powercfg.exe /hibernate off
reg add "HKLM\SYSTEM\ControlSet001\Control\Power" /v "HibernateEnabled" /t REG_DWORD /d "0" /f
reg add "HKLM\SYSTEM\ControlSet002\Control\Power" /v "HibernateEnabled" /t REG_DWORD /d "0" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v "HibernateEnabled" /t REG_DWORD /d "0" /f
goto :next
:next
cls
cd/
echo *******************************************************************
echo * *                                                             * *
echo.   Want to clear temp files on every startup automatically?
echo    A console window will appear on every startup to delete them.
echo * *                                                             * *
echo *******************************************************************
echo. Press "Y" to apply
echo. Press "N" to skip
echo.
set /p choice=Enter choice [Y/N]: 
IF /I "%choice%"=="Y" goto apply
IF /I "%choice%"=="N" goto next
echo.
:apply
cd "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup"
(
echo @echo off
echo pushd "%localappdata%\Temp"
echo del /S /Q "C:\Users\Skid\AppData\Local\Temp\*"
echo rd /s /q . 2>nul
echo pushd "C:\Windows\Temp"
echo del /S /Q "C:\Windows\Temp\*"
echo rd /s /q . 2>nul
echo exit
)>"ClearTEMPFilesOnStartup.bat"
cls
cd/
:: powershell "Get-AppxPackage *windowscommunicationsapps* | Remove-AppxPackage"
:: powershell "Get-AppxPackage Microsoft.Windows.Cortana | Remove-AppxPackage"
:: powershell "Get-AppxPackage *feedback* | Remove-AppxPackage"
:: powershell "Get-AppxPackage *bingsports* | Remove-AppxPackage"
:: powershell "Get-AppxPackage *windowsphone* | Remove-AppxPackage"
:: powershell "Get-AppxPackage *Microsoft.SkypeApp* | Remove-AppxPackage"
:: powershell "Get-AppxPackage *Microsoft.News* | Remove-AppxPackage"
:: powershell "Set-MpPreference -DisableRealtimeMonitoring $true"
:: powershell "Set-MpPreference -SubmitSamplesConsent NeverSend"
:: powershell "Set-MpPreference -MAPSReporting Disable"
:: cd /d "%~dp0"

@echo
cd/
del *.log /a /s /q /f
cls
cleanmgr /autoclean
net stop wuauserv
net stop UsoSvc
rd /s /q C:\Windows\SoftwareDistribution
md C:\Windows\SoftwareDistribution
net start wuauserv
net start UsoSvc
cls
:: if exist "C:\Program Files\CCleaner" (
:: cd "C:\Program Files\CCleaner"
:: CCleaner.exe /AUTO
:: call :ccleaner
:: )
:ccleaner
cls
powershell "Enable-MMAgent -mc"
cls
timeout /t 10 > nul
echo.
echo Done!
echo.
echo  
echo WARNING! IF YOU UPDATE WINDOWS YOU MAY NEED TO DO THE PROGRESS AGAIN . . .
echo.
echo Restart your computer to this to take effect.
echo Press anything to exit.
echo. & pause & exit > nul
