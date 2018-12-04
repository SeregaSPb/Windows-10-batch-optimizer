@ECHO OFF
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
COLOR 0A
ECHO ********** Windows 10 batch optimizer
REM  ********** Options 
REM  ********** Настройки 

REM 1-Disable autoupdate,2-ask for download and install, 3-ask for reboot, 4-automatic update
REM 1-отлючить автоматическое обновление,2-спрашивать о загрузке и установке, 3-спрашивать о перезагрузке, 4-автоматическое обновление
SET AutoUpdateN=2

REM if system on SSD drive - set 0, HDD - 3
REM Если система на SSD диске - установите 0, HDD - 3
SET Prefetch=0

REM Computer name
REM Имя компьютера
SET MyComputerName=Home-PC

REM Unused IP adress (для перенаправлений)
REM Неиспользуемый IP (for redirects)
SET NOURL=127.0.0.0
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
ECHO ********** Regystry backup COPY to C:/RegBackup/Backup.reg 
REM  ********** Сделать копию реестра в C:/RegBackup/Backup.reg 

SETLOCAL
SET RegBackup=%SYSTEMDRIVE%\RegBackup
IF NOT EXIST "%RegBackup%" md "%RegBackup%"
IF EXIST "%RegBackup%\HKLM.reg" DEL "%RegBackup%\HKLM.reg"
REG export HKLM "%RegBackup%\HKLM.reg"
IF EXIST "%RegBackup%\HKCU.reg" DEL "%RegBackup%\HKCU.reg"
REG export HKCU "%RegBackup%\HKCU.reg"
IF EXIST "%RegBackup%\HKCR.reg" DEL "%RegBackup%\HKCR.reg"
REG export HKCR "%RegBackup%\HKCR.reg"
IF EXIST "%RegBackup%\HKU.reg" DEL "%RegBackup%\HKU.reg"
REG export HKU "%RegBackup%\HKU.reg"
IF EXIST "%RegBackup%\HKCC.reg" DEL "%RegBackup%\HKCC.reg"
REG export HKCC "%RegBackup%\HKCC.reg"
IF EXIST "%RegBackup%\Backup.reg" DEL "%RegBackup%\Backup.reg"
COPY "%RegBackup%\HKLM.reg"+"%RegBackup%\HKCU.reg"+"%RegBackup%\HKCR.reg"+"%RegBackup%\HKU.reg"+"%RegBackup%\HKCC.reg" "%RegBackup%\Backup.reg"
DEL "%RegBackup%\HKLM.reg"
DEL "%RegBackup%\HKCU.reg"
DEL "%RegBackup%\HKCR.reg"
DEL "%RegBackup%\HKU.reg"
DEL "%RegBackup%\HKCC.reg"

ECHO ********** Disable UAC
REM  ********** Отключить контроль учетных записей

REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d 0 /f

REM  Block hosts, add firewall rules. 
REM  Блокировать нежелательные веб узлы в hosts и брандмауэре.
GOTO BLOCK
:REG

ECHO ********** Don't allow Windows 10 to repair itself from Windows Update
REM  ********** Запретить Windows 10 восстановить себя от Windows Update

REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Servicing" /v "UseWindowsUpdate" /t REG_DWORD /d 2 /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Servicing" /v "LocalSourcePath" /t REG_EXPAND_SZ /d %NOURL% /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Servicing" /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy Objects\{7C0F6EBB-E44C-48D1-82A9-0561C4650831}Machine\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Servicing" /v "UseWindowsUpdate" /t REG_DWORD /d 2 /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy Objects\{7C0F6EBB-E44C-48D1-82A9-0561C4650831}Machine\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Servicing" /v "LocalSourcePath" /t REG_EXPAND_SZ /d %NOURL% /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy Objects\{7C0F6EBB-E44C-48D1-82A9-0561C4650831}Machine\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Servicing" /v "**del.RepairContentServerSource" /t REG_SZ /d " " /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy Objects\{7C0F6EBB-E44C-48D1-82A9-0561C4650831}Machine\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Servicing" /f

ECHO ********** Disable tasks
REM  ********** Отключить ненужные задачи в планировщике

SCHTASKS /Change /TN "\Microsoft\Windows\WS\WSTask" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\Work Folders\Work Folders Maintenance Work" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\Work Folders\Work Folders Logon Synchronization" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\WOF\WIM-Hash-Validation" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\WOF\WIM-Hash-Management" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\WindowsUpdate\sih" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\Windows Filtering Platform\BfeOnServiceStartTypeChange" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\Windows Error Reporting\QueueReporting" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\WDI\ResolutionHost" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\Sysmain\WsSwapAssessmentTask" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\Sysmain\ResPriStaticDbSync" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\SoftwareProtectionPlatform\SvcRestartTaskNetwork" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\SoftwareProtectionPlatform\SvcRestartTaskLogon" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\SoftwareProtectionPlatform\SvcRestartTask" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\Shell\IndexerAutomaticMaintenance" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\SettingSync\NetworkStateChangeTask" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\SettingSync\BackgroundUploadTask" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\RemoteAssistance\RemoteAssistanceTask" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\PI\Sqm-Tasks" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\NetTrace\GatherNetworkInfo" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\Maps\MapsUpdateTask" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\Maps\MapsToastTask" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\Maintenance\WinSAT" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\FileHistory\File History (maintenance mode)" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\File Classification Infrastructure\Property Definition Sync" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\File Classification Infrastructure\Property Definition Sync" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\Feedback\Siuf\DmClient" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\CertificateServicesClient\UserTask-Roam" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\Autochk\Proxy" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\AppxDeploymentClient\Pre-staged app cleanup" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\Application Experience\StartupAppTask" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\Application Experience\ProgramDataUpdater" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Windows\AppID\SmartScreenSpecific" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Office\OfficeTelemetryAgentLogOn" /DISABLE
SCHTASKS /Change /TN "\Microsoft\Office\OfficeTelemetryAgentFallBack" /DISABLE

ECHO ********** Disable NVIDIA Telemetry
ECHO ********** Отключить сбор данных NVIDIA

SCHTASKS /Change /TN "\NvTmMon_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" /Disable 
SCHTASKS /Change /TN "\NvTmRep_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" /Disable
SCHTASKS /Change /TN "\NvTmRepOnLogon_{B2FE1952-0186-46C3-BAEC-A80AA35AC5B8}" /Disable

ECHO ********** Configure privacy
REM  ********** Настроить конфиденциальность

REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d %Prefetch% /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferUpgrade" /t REG_DWORD /d 0 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v "NoLockScreen" /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\NetworkConnectivityStatusIndicator" /v "NoActiveProbe" /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Maps" /v "AutoDownloadAndUpdateMapData" /t REG_DWORD /d 0 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableWindowsLocationProvider" /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocationScripting" /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocation" /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameUX" /v "DownloadGameInfo" /t REG_DWORD /d 0 /f
REG ADD "HKLM\Software\Policies\Microsoft\Windows\FileHistory" /v "Disabled" /t REG_DWORD /d "1" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsSyncWithDevices" /t REG_DWORD /d 2 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessTrustedDevices" /t REG_DWORD /d 2 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessRadios" /t REG_DWORD /d 2 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessMotion" /t REG_DWORD /d 2 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessMicrophone" /t REG_DWORD /d 2 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessMessaging" /t REG_DWORD /d 2 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessLocation" /t REG_DWORD /d 2 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessEmail" /t REG_DWORD /d 2 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessContacts" /t REG_DWORD /d 2 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessCamera" /t REG_DWORD /d 2 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessCallHistory" /t REG_DWORD /d 2 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessCalendar" /t REG_DWORD /d 2 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessAccountInfo" /t REG_DWORD /d 2 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Messenger\Client" /v "CEIP" /t REG_DWORD /d 2 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "AllowInputPersonalization" /t REG_DWORD /d 0 /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v "DownloadMode" /t REG_DWORD /d 0 /f
REG ADD "HKLM\SOFTWARE\Microsoft\Internet Explorer\Main" /v "RunOnceHasShown" /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Microsoft\Internet Explorer\Main" /v "RunOnceComplete" /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Microsoft\Internet Explorer\Main" /v "DisableFirstRunCustomize" /t REG_DWORD /d 1 /f
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\WindowsMediaPlayer" /v "PreventMusicFileMetadataRetrieval" /t REG_DWORD /d 1 /f
REG ADD "HKCU\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /v "NoToastApplicationNotification" /t REG_DWORD /d "1" /f
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\Messenger\Client" /v "CEIP" /t REG_DWORD /d 2 /f
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" /v "RunOnceHasShown" /t REG_DWORD /d 1 /f
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" /v "DisableFirstRunCustomize" /t REG_DWORD /d 1 /f
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d 1 /f
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d 1 /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d 0 /f
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SoftLandingEnabled" /t REG_DWORD /d "0" /f
REG ADD "HKCU\SOFTWARE\Microsoft\Internet Explorer\Main" /v "Start Page Redirect Cache" /t REG_SZ /d "http://www.google.com" /f
REG ADD "HKCU\SOFTWARE\Microsoft\Internet Explorer\Main" /v "Search Page" /t REG_SZ /d "http://www.google.com" /f
REG ADD "HKCU\SOFTWARE\Microsoft\Internet Explorer\Main" /v "RunOnceHasShown" /t REG_DWORD /d 1 /f
REG ADD "HKCU\SOFTWARE\Microsoft\Internet Explorer\Main" /v "RunOnceComplete" /t REG_DWORD /d 1 /f
REG ADD "HKCU\SOFTWARE\Microsoft\Internet Explorer\Main" /v "DoNotTrack" /t REG_DWORD /d 1 /f
REG ADD "HKCU\SOFTWARE\Microsoft\Internet Explorer\Main" /v "DisableFirstRunCustomize" /t REG_DWORD /d 1 /f

ECHO ********** Disable Remote Assistance
REM  ********** Отключить удаленный помощник

REG ADD "HKLM\System\CurrentControlSet\Control\Remote Assistance" /v "fAllowToGetHelp" /t REG_DWORD /d "0" /f
REG ADD "HKLM\System\CurrentControlSet\Control\Remote Assistance" /v "fAllowFullControl" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Windows NT\Terminal Services" /v "fDenyTSConnections" /t REG_DWORD /d "1" /f
REG ADD "HKLM\Software\Policies\Microsoft\Windows NT\Terminal Services" /v "fAllowUnsolicitedFullControl" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Windows NT\Terminal Services" /v "fAllowUnsolicited" /t REG_DWORD /d "0" /f
REG ADD "HKLM\Software\Policies\Microsoft\Windows NT\Terminal Services" /v "fAllowToGetHelp" /t REG_DWORD /d "0" /f

ECHO ********** Disable sync
REM  ********** Отключить синхронизацию

REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableWindowsSettingSyncUserOverride" /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableWindowsSettingSync" /t REG_DWORD /d 2 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableWebBrowserSettingSyncUserOverride" /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableWebBrowserSettingSync" /t REG_DWORD /d 2 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSyncOnPaidNetwork" /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableStartLayoutSettingSyncUserOverride" /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableStartLayoutSettingSync" /t REG_DWORD /d 2 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSyncUserOverride" /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSync" /t REG_DWORD /d 2 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisablePersonalizationSettingSyncUserOverride" /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisablePersonalizationSettingSync" /t REG_DWORD /d 2 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableDesktopThemeSettingSyncUserOverride" /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableDesktopThemeSettingSync" /t REG_DWORD /d 2 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableCredentialsSettingSyncUserOverride" /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableCredentialsSettingSync" /t REG_DWORD /d 2 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableAppSyncSettingSyncUserOverride" /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableAppSyncSettingSync" /t REG_DWORD /d 2 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableApplicationSettingSyncUserOverride" /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v "DisableApplicationSettingSync" /t REG_DWORD /d 2 /f

ECHO ********** Lock Screen No Camera
REM  ********** Отключить камеру на экране блокировки

REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v "NoLockScreenCamera" /t REG_DWORD /d 1 /f

ECHO ********** Disable Password reveal button
REM  ********** Отключить кнопку раскрытия пароля

REG ADD "HKCU\SOFTWARE\Policies\Microsoft\Windows\CredUI" /v "DisablePasswordReveal" /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\CredUI" /v "DisablePasswordReveal" /t REG_DWORD /d 1 /f

ECHO ********** Disable DomainPicturePassword
REM  ********** Отключить пароль для изображения домена

REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "BlockDomainPicturePassword" /t REG_DWORD /d 1 /f

ECHO ********** Disable handwriting data sharing
REM  ********** Отключить совместное использование данных рукописного ввода

REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\TabletPC" /v "PreventHandwritingDataSharing" /t REG_DWORD /d 1 /f

ECHO ********** No Web/Bing Search
REM  ********** Отключить поиск Bing

REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWebOverMeteredConnections" /t REG_DWORD /d 0 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /t REG_DWORD /d 0 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchSafeSearch" /t REG_DWORD /d 3 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchPrivacy" /t REG_DWORD /d 3 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowSearchToUseLocation" /t REG_DWORD /d 0 /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d 0 /f

ECHO ********** Suppress Microsoft Feedback
REM  ********** Подавлять отзывы Microsoft

REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d 1 /f
REG ADD "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d 0 /f
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\Assistance\Client\1.0" /v "NoExplicitFeedback" /t REG_DWORD /d 1 /f

ECHO ********** Don't allow SpyNet
REM  ********** Отключить SpyNet

REG ADD "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" /v " SpyNetReporting" /t REG_DWORD /d 0 /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" /v " SubmitSamplesConsent" /t REG_DWORD /d 0 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SpynetReporting" /t REG_DWORD /d 0 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SubmitSamplesConsent" /t REG_DWORD /d 2 /f

ECHO ********** Disable Policies
REM  ********** Отключить нежелательные групповые политики

REG Delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Id" /f
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d 0 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\WMDRM" /v "DisableOnline" /t REG_DWORD /d 1 /
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "DontSendAdditionalData" /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "AutoApproveOSDumps" /t REG_DWORD /d 0 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableSmartScreen" /t REG_DWORD /d 0 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "DisableHHDEP" /t REG_DWORD /d 0 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete" /v "AutoSuggest" /t REG_SZ /d "no" /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableSoftLanding" /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v "DisabledByGroupPolicy" /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableBehaviorMonitoring" /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\SearchCompanion" /v "DisableContentFileUpdates" /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting\DW" /v "DWNoSecondLevelCollection" /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting\DW" /v "DWNoFileCollection" /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting\DW" /v "DWNoExternalURL" /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Assistance\Client\1.0" /v "NoActiveHelp" /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d 0 /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d 0 /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d 0 /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d 0 /f
REG ADD "HKCU\SOFTWARE\Microsoft\Personalization\Settings" /v "AcceptedPrivacyPolicy" /t REG_DWORD /d 0 /f
REG ADD "HKCU\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" /v "HarvestContacts" /t REG_DWORD /d 0 /f
REG ADD "HKCU\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d 1 /f
REG ADD "HKCU\SOFTWARE\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d 1 /f
REG ADD "HKCU\Control Panel\International\User Profile" /v "HttpAcceptLanguageOptOut" /t REG_DWORD /d 1 /f

ECHO ********** Remove Telemetry and Data Collection and Disable Cortana
REM  ********** Удалить телеметрию сбора данных, отключает Кортану

REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableUAR" /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableInventory" /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t REG_DWORD /d 0 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d 0 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\SQMClient" /v "CorporateSQMURL" /t REG_SZ /d 127.0.0.1 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v DontOfferThroughWUAU /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Application-Experience/Steps-Recorder" /v "Enabled" /t REG_DWORD /d 0 /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Application-Experience/Program-Telemetry" /v "Enabled" /t REG_DWORD /d 0 /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Application-Experience/Program-Inventory" /v "Enabled" /t REG_DWORD /d 0 /f 
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Application-Experience/Program-Compatibility-Troubleshooter" /v "Enabled" /t REG_DWORD /d 0 /f 
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Application-Experience/Program-Compatibility-Assistant/Trace" /v "Enabled" /t REG_DWORD /d 0 /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Application-Experience/Program-Compatibility-Assistant/Compatibility-Infrastructure-Debug" /v "Enabled" /t REG_DWORD /d 0 /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Application-Experience/Program-Compatibility-Assistant/Analytic" /v "Enabled" /t REG_DWORD /d 0 /f 
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Application-Experience/Program-Compatibility-Assistant" /v "Enabled" /t REG_DWORD /d 0 /f 
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /v PreventDeviceMetadataFromNetwork /t REG_DWORD /d 1 /f
REG ADD "HKLM\COMPONENTS\DerivedData\Components\amd64_microsoft-windows-c..lemetry.lib.cortana_31bf3856ad364e35_10.0.10240.16384_none_40ba2ec3d03bceb0" /v "f!proactive-telemetry-inter_58073761d33f144b" /t REG_DWORD /d 0 /f
REG ADD "HKLM\COMPONENTS\DerivedData\Components\amd64_microsoft-windows-c..lemetry.lib.cortana_31bf3856ad364e35_10.0.10240.16384_none_40ba2ec3d03bceb0" /v "f!proactive-telemetry-event_8ac43a41e5030538" /t REG_DWORD /d 0 /f
REG ADD "HKLM\COMPONENTS\DerivedData\Components\amd64_microsoft-windows-c..lemetry.lib.cortana_31bf3856ad364e35_10.0.10240.16384_none_40ba2ec3d03bceb0" /v "f!proactive-telemetry.js" /t REG_DWORD /d 0 /f
REG ADD "HKLM\COMPONENTS\DerivedData\Components\amd64_microsoft-windows-c..lemetry.lib.cortana_31bf3856ad364e35_10.0.10240.16384_none_40ba2ec3d03bceb0" /v "f!dss-winrt-telemetry.js" /t REG_DWORD /d 0 /f
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" /v "RunOnceComplete" /t REG_DWORD /d 1 /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "CortanaEnabled" /t REG_DWORD /d 0 /f

ECHO ********** Disable logging
REM  ********** Отключить сбор данных

REG ADD "HKLM\System\CurrentControlSet\Control\WMI\Autologger\WiFiSession" /v "Start" /t REG_DWORD /d 0 /f
REG ADD "HKLM\System\CurrentControlSet\Control\WMI\Autologger\WdiContextLog" /v "Start" /t REG_DWORD /d 0 /f
REG ADD "HKLM\System\CurrentControlSet\Control\WMI\Autologger\UBPM" /v "Start" /t REG_DWORD /d 0 /f
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\TCPIPLOGGER" /v "Start" /t REG_DWORD /d 0 /f
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\SQMLogger" /v "Start" /t REG_DWORD /d 0 /f
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\ReadyBoot" /v "Start" /t REG_DWORD /d 0 /f
REG ADD "HKLM\System\CurrentControlSet\Control\WMI\Autologger\NtfsLog" /v "Start" /t REG_DWORD /d 0 /f
REG ADD "HKLM\System\CurrentControlSet\Control\WMI\Autologger\LwtNetLog" /v "Start" /t REG_DWORD /d 0 /f
REG ADD "HKLM\System\CurrentControlSet\Control\WMI\Autologger\FaceUnlock" /v "Start" /t REG_DWORD /d 0 /f
REG ADD "HKLM\System\CurrentControlSet\Control\WMI\Autologger\FaceRecoTel" /v "Start" /t REG_DWORD /d 0 /f
REG ADD "HKLM\System\CurrentControlSet\Control\WMI\Autologger\EventLog-System" /v "Start" /t REG_DWORD /d 0 /f
REG ADD "HKLM\System\CurrentControlSet\Control\WMI\Autologger\EventLog-Security" /v "Start" /t REG_DWORD /d 0 /f
REG ADD "HKLM\System\CurrentControlSet\Control\WMI\Autologger\DefenderAuditLogger" /v "Start" /t REG_DWORD /d 0 /f
REG ADD "HKLM\System\CurrentControlSet\Control\WMI\Autologger\DefenderApiLogger" /v "Start" /t REG_DWORD /d 0 /f
REG ADD "HKLM\System\CurrentControlSet\Control\WMI\Autologger\Circular Kernel Context Logger" /v "Start" /t REG_DWORD /d 0 /f
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" /v "Start" /t REG_DWORD /d 0 /f
REG ADD "HKLM\System\CurrentControlSet\Control\WMI\Autologger\Audio" /v "Start" /t REG_DWORD /d 0 /f
REG ADD "HKLM\System\CurrentControlSet\Control\WMI\Autologger\AppModel" /v "Start" /t REG_DWORD /d 0 /f

ECHO ********** Disable pre-release features or settings
REM  ********** Отключить пресс-релиз функции

REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v "AllowBuildPreview" /t REG_DWORD /d 0 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v "EnableConfigFlighting" /t REG_DWORD /d 0 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v "EnableExperimentation" /t REG_DWORD /d 0 /f

ECHO ********** Disable services
REM  ********** Отключить службы

SC config "CscService" start= disabled
SC config "MapsBroker" start= disabled
SC config "CertPropSvc" start= disabled
SC config "wscsvc" start= demand
SC config "SystemEventsBroker" start= demand
SC config "tiledatamodelsvc" start= demand
SC config "WerSvc" start= demand

ECHO ********** Delete services
REM  ********** Удалить службы

PowerShell -Command "Get-Service DiagTrack | Set-Service -StartupType Disabled"
PowerShell -Command "Get-Service dmwappushservice | Set-Service -StartupType Disabled"
PowerShell -Command "Get-Service diagnosticshub.standardcollector.service | Set-Service -StartupType Disabled"
PowerShell -Command "Get-Service DPS | Set-Service -StartupType Disabled"
PowerShell -Command "Get-Service RemoteRegistry | Set-Service -StartupType Disabled"
PowerShell -Command "Get-Service TrkWks | Set-Service -StartupType Disabled"
PowerShell -Command "Get-Service WMPNetworkSvc | Set-Service -StartupType Disabled"
PowerShell -Command "Get-Service WSearch | Set-Service -StartupType Disabled"
PowerShell -Command "Get-Service SysMain | Set-Service -StartupType Disabled"
SC config "DiagTrack" start= disabled
SC config "dmwappushservice" start= disabled
SC config "diagnosticshub.standardcollector.service" start= disabled
SC config "DPS " start= disabled
SC config "RemoteRegistry" start= disabled
SC config "TrkWks" start= disabled
SC config "WMPNetworkSvc" start= disabled
SC config "WSearch" start= disabled
SC config "SysMain" start= disabled
NET STOP DiagTrack
NET STOP diagnosticshub.standardcollector.service
NET STOP dmwappushservice
NET STOP DPS
NET STOP RemoteRegistry
NET STOP TrkWks
NET STOP WMPNetworkSvc
NET STOP WSearch
NET STOP SysMain
SC delete DiagTrack
SC delete "diagnosticshub.standardcollector.service"
SC delete "dmwappushservice"
SC delete "DPS"
SC delete "RemoteRegistry"
SC delete "TrkWks"
SC delete "WMPNetworkSvc"
SC delete "WSearch"
SC delete "SysMain"

ECHO ********** Disable Office telemetry
REM  ********** Отключить телеметрию MS Office
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\office\15.0\osm" /v "enablefileobfuscation" /t REG_DWORD /d 1 /f
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\office\15.0\osm" /v "enablelogging" /t REG_DWORD /d 0 /f
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\office\15.0\osm" /v "enableupload" /t REG_DWORD /d 0 /f
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\common" /v "qmenable" /t REG_DWORD /d 0 /f
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\common" /v "sendcustomerdata" /t REG_DWORD /d 0 /f
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\common" /v "updatereliabilitydata" /t REG_DWORD /d 0 /f
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\common\feedback" /v "enabled" /t REG_DWORD /d 0 /f
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\common\feedback" /v "includescreenshot" /t REG_DWORD /d 0 /f
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\common\internet" /v "useonlinecontent" /t REG_DWORD /d 0 /f
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\common\ptwatson" /v "ptwoptin" /t REG_DWORD /d 0 /f
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\osm" /v "enablefileobfuscation" /t REG_DWORD /d 1 /f
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\osm" /v "enablelogging" /t REG_DWORD /d 0 /f
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\osm" /v "enableupload" /t REG_DWORD /d 0 /f
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\osm\preventedapplications" /v "accesssolution" /t REG_DWORD /d 1 /f
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\osm\preventedapplications" /v "olksolution" /t REG_DWORD /d 1 /f
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\osm\preventedapplications" /v "onenotesolution" /t REG_DWORD /d 1 /f
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\osm\preventedapplications" /v "pptsolution" /t REG_DWORD /d 1 /f
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\osm\preventedapplications" /v "projectsolution" /t REG_DWORD /d 1 /f
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\osm\preventedapplications" /v "publishersolution" /t REG_DWORD /d 1 /f
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\osm\preventedapplications" /v "visiosolution" /t REG_DWORD /d 1 /f
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\osm\preventedapplications" /v "wdsolution" /t REG_DWORD /d 1 /f
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\osm\preventedapplications" /v "xlsolution" /t REG_DWORD /d 1 /f
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\osm\preventedsolutiontypes" /v "agave" /t REG_DWORD /d 1 /f
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\osm\preventedsolutiontypes" /v "appaddins" /t REG_DWORD /d 1 /f
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\osm\preventedsolutiontypes" /v "comaddins" /t REG_DWORD /d 1 /f
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\osm\preventedsolutiontypes" /v "documentfiles" /t REG_DWORD /d 1 /f
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\osm\preventedsolutiontypes" /v "templatefiles" /t REG_DWORD /d 1 /f
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\excel\security" /v "blockcontentexecutionfrominternet" /t REG_DWORD /d 1 /f
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\outlook\security" /v "level" /t REG_DWORD /d 2 /f
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\powerpoint\security" /v "blockcontentexecutionfrominternet" /t REG_DWORD /d 1 /f
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\office\16.0\word\security" /v "blockcontentexecutionfrominternet" /t REG_DWORD /d 0 /f

ECHO ********** Disable Skype telemetry
REM  ********** Отключить телеметрию Skype
REG ADD "HKCU\SOFTWARE\Microsoft\Tracing\WPPMediaPerApp\Skype\ETW" /v "TraceLevelThreshold" /t REG_DWORD /d 0 /f
REG ADD "HKCU\SOFTWARE\Microsoft\Tracing\WPPMediaPerApp\Skype" /v "EnableTracing" /t REG_DWORD /d 0 /f
REG ADD "HKCU\SOFTWARE\Microsoft\Tracing\WPPMediaPerApp\Skype\ETW" /v "EnableTracing" /t REG_DWORD /d 0 /f
REG ADD "HKCU\SOFTWARE\Microsoft\Tracing\WPPMediaPerApp\Skype" /v "WPPFilePath" /t REG_SZ /d "%%SYSTEMDRIVE%%\TEMP\Tracing\WPPMedia" /f
REG ADD "HKCU\SOFTWARE\Microsoft\Tracing\WPPMediaPerApp\Skype\ETW" /v "WPPFilePath" /t REG_SZ /d "%%SYSTEMDRIVE%%\TEMP\WPPMedia" /f

ECHO ********** Disable and delete search and indexes
REM  ********** Отключить и удалить интернет-поиск и индексы

DEL "C:\ProgramData\Microsoft\Search\Data\Applications\Windows\Windows.edb" /s
DEL "C:\ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl" /s
ATTRIB -r "C:\ProgramData\Microsoft\Search\Data\Applications\Windows\Windows.edb"
ECHO "" > C:\ProgramData\Microsoft\Search\Data\Applications\Windows\Windows.edb
ATTRIB +r "C:\ProgramData\Microsoft\Search\Data\Applications\Windows\Windows.edb"
ATTRIB -r "C:\ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl"
ECHO "" > C:\ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl
ATTRIB +r "C:\ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl"

ECHO ********** Remove Retail Demo
REM  ********** Удалить Demo контент

REG Delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{12D4C69E-24AD-4923-BE19-31321C43A767}" /f
takeown /f %ProgramData%\Microsoft\Windows\RetailDemo /r /d y
icacls %ProgramData%\Microsoft\Windows\RetailDemo /grant Administrators:F /T
rd /s /q %ProgramData%\Microsoft\Windows\RetailDemo
takeown /f "C:\Windows\SystemApps\Microsoft.Windows.CloudExperienceHost_cw5n1h2txyewy\RetailDemo" /r /d y
icacls "C:\Windows\SystemApps\Microsoft.Windows.CloudExperienceHost_cw5n1h2txyewy\RetailDemo" /grant Administrators:F /T
rd /s /q "C:\Windows\SystemApps\Microsoft.Windows.CloudExperienceHost_cw5n1h2txyewy\RetailDemo" 

ECHO ********** Delete OneDrive
REM  ********** Удалить OneDrive

REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v DisableFileSyncNGSC /t REG_DWORD /d 1 /f
TASKKILL /f /im OneDrive.exe
%SystemRoot%\System32\OneDriveSetup.exe /uninstall
%SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall
rd "%UserProfile%\OneDrive" /Q /S
rd "%LocalAppData%\Microsoft\OneDrive" /Q /S
rd "%ProgramData%\Microsoft OneDrive" /Q /S
rd "C:\OneDriveTemp" /Q /S
REG Delete "HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f
REG Delete "HKEY_CLASSES_ROOT\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f
REG Delete "HKCU\SOFTWARE\Classes\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f /reg:32
REG Delete "HKCU\SOFTWARE\Classes\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f /reg:64
REG Delete "HKLM\SOFTWARE\Classes\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f /reg:32
REG Delete "HKLM\SOFTWARE\Classes\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f /reg:64
REG Delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{A52BBA46-E9E1-435f-B3D9-28DAA648C0F6}" /f
REG Delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSyncNGSC" /f
REG Delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{339719B5-8C47-4894-94C2-D8F77ADD44A6}" /f
REG Delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{767E6811-49CB-4273-87C2-20F355E1085B}" /f
REG Delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{C3F2459E-80D6-45DC-BFEF-1F769F2BE730}" /f
REG Delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{24D89E24-2F19-4534-9DDE-6A6671FBB8FE}" /f

ECHO ********** Disables unwanted Windows features
REM  ********** Отключить нежелательные свойства Windows

PowerShell -Command Disable-WindowsOptionalFeature -Online -NoRestart -FeatureName "Internet-Explorer-Optional-amd64"
PowerShell -Command Disable-WindowsOptionalFeature -Online -NoRestart -FeatureName "MediaPlayback"
PowerShell -Command Disable-WindowsOptionalFeature -Online -NoRestart -FeatureName "WindowsMediaPlayer"
PowerShell -Command Disable-WindowsOptionalFeature -Online -NoRestart -FeatureName "WorkFolders-Client"

ECHO ********** Delete other Apps
REM  ********** Удалить и другие приложения Metro

PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object DisplayName -eq Microsoft.3DBuilder | Remove-AppxProvisionedPackage -Online"
PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object DisplayName -eq Microsoft.BingFinance | Remove-AppxProvisionedPackage -Online"
PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object DisplayName -eq Microsoft.BingNews | Remove-AppxProvisionedPackage -Online"
PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object DisplayName -eq Microsoft.Getstarted | Remove-AppxProvisionedPackage -Online"
PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object DisplayName -eq Microsoft.MicrosoftOfficeHub | Remove-AppxProvisionedPackage -Online"
PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object DisplayName -eq Microsoft.MicrosoftSolitaireCollection | Remove-AppxProvisionedPackage -Online"
PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object DisplayName -eq Microsoft.Office.OneNote | Remove-AppxProvisionedPackage -Online"
PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object DisplayName -eq Microsoft.SkypeApp | Remove-AppxProvisionedPackage -Online"
PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object DisplayName -eq Microsoft.WindowsPhone | Remove-AppxProvisionedPackage -Online"
PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object DisplayName -eq Microsoft.XboxApp | Remove-AppxProvisionedPackage -Online"
PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object DisplayName -eq Microsoft.ZuneMusic | Remove-AppxProvisionedPackage -Online"
PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object DisplayName -eq Microsoft.ZuneVideo | Remove-AppxProvisionedPackage -Online"
PowerShell -Command "Get-AppxPackage *Microsoft* | Remove-AppxPackage"
PowerShell -Command "Get-AppXProvisionedPackage -online | Remove-AppxProvisionedPackage -online"
PowerShell -Command "Get-AppXPackage | Remove-AppxPackage"
PowerShell -Command "Get-AppXPackage -User  | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage -AllUsers | Remove-AppxPackage"

ECHO ********** Remove folders from This PC or MyComputer menu
REM  ********** Удалить папки из Компьютер

ECHO ********** Remove 3D Objects
REM  ********** Удалить 3D объекты

REG Delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f
REG Delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f

ECHO ********** Remove CameraRollLibrary
REM  ********** Удалить CameraRollLibrary

REG Delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{2B20DF75-1EDA-4039-8097-38798227D5B7}" /f

ECHO ********** Remove from MyComputer menu Music
REM  ********** Удалить из меню MyComputer Музыка

REG Delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" /f
REG Delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" /f

REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f
REG ADD "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f

ECHO ********** Remove from MyComputer menu Pictures
REM  ********** Удалить из меню MyComputer Изображения

REG Delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" /f
REG Delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f
REG ADD "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f

ECHO ********** Remove from MyComputer menu Videos
REM  ********** Удалить из меню MyComputer Видео

REG Delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}" /f
REG Delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f
REG ADD "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f

ECHO ********** Remove from MyComputer menu Documents
REM  ********** Удалить из меню MyComputer Документы

REG Delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af}" /f
REG Delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af}" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f
REG ADD "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f

ECHO ********** Remove from MyComputer menu Downloads
REM  ********** Удалить из меню MyComputer Загрузки

REG Delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}" /f
REG Delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f
REG ADD "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f

ECHO ********** Remove from MyComputer menu Desktop
REM  ********** Удалить из меню MyComputer Рабочий стол

REG Delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}" /f
REG Delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}" /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f
REG ADD "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f

ECHO ********** Rename Computer
REM  ********** Переименовать компьютер

REG ADD HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName /v ComputerName /t REG_SZ /d %MyComputerName% /f
REG ADD HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ActiveComputerName\ /v ComputerName /t REG_SZ /d %MyComputerName% /f
REG ADD HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\ /v Hostname /t REG_SZ /d %MyComputerName% /f
REG ADD HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\ /v "NV Hostname" /t REG_SZ /d %MyComputerName% /f

ECHO ********** Add "Take Ownership" in context menu
REM  ********** Добавить "Стать Владельцем" в контекстное меню

REG ADD "HKCR\*\shell\runas" /ve /t REG_SZ /d "Take ownership" /f
REG ADD "HKCR\*\shell\runas" /v "HasLUAShield" /t REG_SZ /d "" /f
REG ADD "HKCR\*\shell\runas" /v "NoWorkingDirectory" /t REG_SZ /d "" /f
REG ADD "HKCR\*\shell\runas\command" /ve /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" && icacls \"%%1\" /grant administrators:F" /f
REG ADD "HKCR\*\shell\runas\command" /v "IsolatedCommand" /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" && icacls \"%%1\" /grant administrators:F" /f
REG ADD "HKCR\Directory\shell\runas" /ve /t REG_SZ /d "Take ownership" /f
REG ADD "HKCR\Directory\shell\runas" /v "HasLUAShield" /t REG_SZ /d "" /f
REG ADD "HKCR\Directory\shell\runas" /v "NoWorkingDirectory" /t REG_SZ /d "" /f
REG ADD "HKCR\Directory\shell\runas\command" /ve /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" /r /d y && icacls \"%%1\" /grant administrators:F /t" /f
REG ADD "HKCR\Directory\shell\runas\command" /v "IsolatedCommand" /t REG_SZ /d "cmd.exe /c takeown /f \"%%1\" /r /d y && icacls \"%%1\" /grant administrators:F /t" /f

ECHO ********** Set Auto Logon
REM  ********** Установить автоматический вход в систему

REG ADD "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "AutoAdminLogon" /t REG_DWORD /d 1 /f

ECHO ********** Disable Test mode
REM  ********** Отключить Тестовый режим"

bcdedit /set TESTSIGNING OFF

ECHO ********** Remove Logon screen wallpaper
REM  ********** Убрать обои на экране входа

REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "DisableLogonBackgroundImage" /t REG_DWORD /d 1 /f

ECHO ********** Show Computer shortcut on desktop
REM  ********** Показать ярлык компьютер на рабочем столе

REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d 0 /f

ECHO ********** Underline keyboard shortcuts and access keys
REM  ********** Подчеркнуть сочетания клавиш и клавиши доступа

REG ADD "HKCU\Control Panel\Accessibility\Keyboard Preference" /v "On" /t REG_SZ /d 1 /f

ECHO ********** SET Windows Explorer to start on This PC instead of Quick Access
REM  ********** Установить Проводник Windows для начала работы

REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d 1 /f

ECHO ********** Hide the search box from taskbar
REM  ********** Скрыть окно поиска из панели задач

REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d 0 /f
REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d 0 /f

ECHO ********** Disable MRU lists (jump lists) of XAML apps in Start Menu
REM  ********** Отключить списки приложений XAML в меню Пуск

REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackDocs" /t REG_DWORD /d 0 /f

ECHO ********** Show file extensions
REM  ********** Показать расширения файлов

REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d 0 /f

ECHO ********** Show hidden extension
REM  ********** Показать скрытые расширения

REG ADD "HKCR\lnkfile" /v "NeverShowExt" /f
REG ADD "HKCR\IE.AssocFile.URL" /v "NeverShowExt" /f
REG ADD "HKCR\IE.AssocFile.WEBSITE" /v "NeverShowExt" /f
REG ADD "HKCR\InternetShortcut" /v "NeverShowExt" /f
REG ADD "HKCR\Microsoft.Website" /v "NeverShowExt" /f
REG ADD "HKCR\piffile" /v "NeverShowExt" /f
REG ADD "HKCR\SHCmdFile" /v "NeverShowExt" /f
REG ADD "HKCR\LibraryFolder" /v "NeverShowExt" /f

ECHO ********** Use Windows Photo Viewer to open photo files
REM  ********** Использовать Photo Viewer, чтобы открыть файлы фотографий

REG ADD "HKCU\SOFTWARE\Classes\.jpg" /v REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f
REG ADD "HKCU\SOFTWARE\Classes\.jpeg" /v REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f
REG ADD "HKCU\SOFTWARE\Classes\.gif" /v REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f
REG ADD "HKCU\SOFTWARE\Classes\.png" /v REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f
REG ADD "HKCU\SOFTWARE\Classes\.bmp" /v REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f
REG ADD "HKCU\SOFTWARE\Classes\.tiff" /v REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f
REG ADD "HKCU\SOFTWARE\Classes\.ico" /v REG_SZ /d "PhotoViewer.FileAssoc.Tiff" /f
REG ADD "HKCR\Applications\photoviewer.dll\shell\open" /v "MuiVerb" /t REG_SZ /d "@photoviewer.dll,-3043" /f
REG ADD "HKCR\Applications\photoviewer.dll\shell\open\DropTarget" /v "Clsid" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f
REG ADD "HKCR\Applications\photoviewer.dll\shell\print\DropTarget" /v "Clsid" /t REG_SZ /d "{60fd46de-f830-4894-a628-6fa81bc0190d}" /f
REG ADD "HKCR\Applications\photoviewer.dll\shell\open\command" /v "%%%%SystemRoot%%%%\System32\rundll32.exe " /t REG_EXPAND_SZ /d ", ImageView_Fullscreen %%%%1" /f
REG ADD "HKCR\Applications\photoviewer.dll\shell\open\command" /v "%%%%ProgramFiles%%%%\Windows Photo Viewer\PhotoViewer.dll" /t REG_EXPAND_SZ /d ", ImageView_Fullscreen %%%%1" /f
REG ADD "HKCR\Applications\photoviewer.dll\shell\print\command" /v "%%%%SystemRoot%%%%\System32\rundll32.exe " /t REG_EXPAND_SZ /d ", ImageView_Fullscreen %%%%1" /f
REG ADD "HKCR\Applications\photoviewer.dll\shell\print\command" /v "%%%%ProgramFiles%%%%\Windows Photo Viewer\PhotoViewer.dll" /t REG_EXPAND_SZ /d ", ImageView_Fullscreen %%%%1" /f

ECHO ********** Turn OFF Sticky Keys when SHIFT is pressed 5 times
REM  ********** Выключите залипания клавиш SHIFT при нажатии 5 раз

REG ADD "HKCU\Control Panel\Accessibility\StickyKeys" /v "Flags" /t REG_SZ /d "506" /f

ECHO ********** Turn OFF Filter Keys when SHIFT is pressed for 8 seconds
REM  ********** Выключить Фильтр клавиш, когда SHIFT нажата в течение 8 секунд

REG ADD "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Flags" /t REG_SZ /d "122" /f

ECHO ********** Change Clock and Date formats 24H, metric (Sign out required to see changes)
REM  ********** Изменить формат часов и даты 24 часа, метрическая система

REG ADD "HKCU\Control Panel\International" /v "iMeasure" /t REG_SZ /d "0" /f
REG ADD "HKCU\Control Panel\International" /v "iNegCurr" /t REG_SZ /d "1" /f
REG ADD "HKCU\Control Panel\International" /v "iTime" /t REG_SZ /d "1" /f
REG ADD "HKCU\Control Panel\International" /v "sShortDate" /t REG_SZ /d "dd.MM.yyyy" /f
REG ADD "HKCU\Control Panel\International" /v "sShortTime" /t REG_SZ /d "HH:mm" /f
REG ADD "HKCU\Control Panel\International" /v "sTimeFormat" /t REG_SZ /d "H:mm:ss" /f

ECHO ********** Google as default search
REM  ********** Google - поиск по умолчанию

REG ADD "HKCU\SOFTWARE\Microsoft\Internet Explorer\SearchScopes" /v "DefaultScope" /t REG_SZ /d "{89418666-DF74-4CAC-A2BD-B69FB4A0228A}" /f
REG ADD "HKCU\SOFTWARE\Microsoft\Internet Explorer\SearchScopes\{89418666-DF74-4CAC-A2BD-B69FB4A0228A}" /f
REG ADD "HKCU\SOFTWARE\Microsoft\Internet Explorer\SearchScopes\{89418666-DF74-4CAC-A2BD-B69FB4A0228A}" /v "DisplayName" /t REG_SZ /d "Google" /f
REG ADD "HKCU\SOFTWARE\Microsoft\Internet Explorer\SearchScopes\{89418666-DF74-4CAC-A2BD-B69FB4A0228A}" /v "FaviconURL" /t REG_SZ /d "http://www.google.com/favicon.ico" /f
REG ADD "HKCU\SOFTWARE\Microsoft\Internet Explorer\SearchScopes\{89418666-DF74-4CAC-A2BD-B69FB4A0228A}" /v "FaviconURLFallback" /t REG_SZ /d "http://www.google.com/favicon.ico" /f
REG ADD "HKCU\SOFTWARE\Microsoft\Internet Explorer\SearchScopes\{89418666-DF74-4CAC-A2BD-B69FB4A0228A}" /v "OSDFileURL" /t REG_SZ /d "http://www.iegallery.com/en-us/AddOns/DownloadAddOn?resourceId=813" /f
REG ADD "HKCU\SOFTWARE\Microsoft\Internet Explorer\SearchScopes\{89418666-DF74-4CAC-A2BD-B69FB4A0228A}" /v "ShowSearchSuggestions" /t REG_DWORD /d 1 /f
REG ADD "HKCU\SOFTWARE\Microsoft\Internet Explorer\SearchScopes\{89418666-DF74-4CAC-A2BD-B69FB4A0228A}" /v "SuggestionsURL" /t REG_SZ /d "http://clients5.google.com/complete/search?q={searchTerms}&client=ie8&mw={ie:maxWidth}&sh={ie:sectionHeight}&rh={ie:rowHeight}&inputencoding={inputEncoding}&outputencoding={outputEncoding}" /f
REG ADD "HKCU\SOFTWARE\Microsoft\Internet Explorer\SearchScopes\{89418666-DF74-4CAC-A2BD-B69FB4A0228A}" /v "SuggestionsURLFallback" /t REG_SZ /d "http://clients5.google.com/complete/search?hl={language}&q={searchTerms}&client=ie8&inputencoding={inputEncoding}&outputencoding={outputEncoding}" /f
REG ADD "HKCU\SOFTWARE\Microsoft\Internet Explorer\SearchScopes\{89418666-DF74-4CAC-A2BD-B69FB4A0228A}" /v "TopResultURLFallback" /t REG_SZ /d "" /f
REG ADD "HKCU\SOFTWARE\Microsoft\Internet Explorer\SearchScopes\{89418666-DF74-4CAC-A2BD-B69FB4A0228A}" /v "URL" /t REG_SZ /d "http://www.google.com/search?q={searchTerms}&sourceid=ie7&rls=com.microsoft:{language}:{referrer:source}&ie={inputEncoding?}&oe={outputEncoding?}" /f

ECHO ********** Windows Update - only directly from Microsoft
REM  ********** Обновление Windows - получать только непосредственно от Microsoft

REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v "DODownloadMode" /t REG_DWORD /d 0 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v "DODownloadMode" /t REG_DWORD /d 0 /f

ECHO ********** Windows Update
REM  ********** Обновление Windows

NET STOP wuauserv
SCHTASKS /Change /TN "\Microsoft\Windows\WindowsUpdate\Automatic App Update" /DISABLE
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AutoInstallMinorUpdates" /t REG_DWORD /d 0 /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t REG_DWORD /d %AutoUpdateN% /f
REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d 0 /f
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v "AUOptions" /t REG_DWORD /d %AutoUpdateN% /f
NET START wuauserv

ECHO ********** Disable Reboot after Windows Updates are installed
REM  ********** Отключить перезагрузку после установки обновлений Windows

SCHTASKS /Change /TN "Microsoft\Windows\UpdateOrchestrator\Reboot" /Disable
ren "%WinDir%\System32\Tasks\Microsoft\Windows\UpdateOrchestrator\Reboot" "Reboot.bak"
md "%WinDir%\System32\Tasks\Microsoft\Windows\UpdateOrchestrator\Reboot"
SCHTASKS /Change /TN "Microsoft\Windows\UpdateOrchestrator\Reboot" /Disable

ECHO ********** Disable shares your WiFi network login
REM  ********** Отключить общие ресурсы Wi-Fi сети

REG ADD "HKLM\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" /v "value" /t REG_DWORD /d 0 /f
REG ADD "HKLM\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" /v "value" /t REG_DWORD /d 0 /f

ECHO ********** Prevent from creating LNK files in the Recents folder
REM  ********** Предотвратить создание ярлыков в папке Недавние

REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsHistory" /t REG_DWORD /d 1 /f

ECHO ********** Remove the Previous Versions tab in file Properties
REM  ********** Удалить вкладку Предыдущие версии в свойствах файла

REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v NoPreviousVersionsPage /t REG_DWORD /d 1 /f

ECHO ********** Delay Taskbar pop-ups to 10 seconds
REM  ********** Задержка всплывающих окон панели задач - 10 секунд

REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ExtendedUIHoverTime" /t REG_DWORD /d "10000" /f

ECHO ********** Disable Notification Center Completely in Windows 10.reg
REM  ********** Отключить центр уведомлений в Windows 10

REG ADD "HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows Defender" /v "DisableRoutinelyTakingAction" /t REG_DWORD /d 1 /f
REG ADD "HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows Defender\Policy Manager" /f
REG ADD "HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d 1 /f
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /t REG_DWORD /d 1 /f

ECHO ********** Disable SMB Protocol (sharing files and printers)
REM  ********** Отключить протокол SMB (общий доступ к файлам и принтерам)

REG ADD "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v SMB1 /t REG_DWORD /d 0 /f
REG ADD "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v SMB2 /t REG_DWORD /d 0 /f
dism /online /norestart /disable-feature /featurename:SMB1Protocol
wmic service where "Name LIKE '%%lanmanserver%%'" call StopService
wmic service where "Name LIKE '%%lanmanserver%%'" call ChangeStartMode Disabled

ECHO ********** Clean Junk files and thumbcache
REM  ********** Очистить временные файлы и кэш иконокp

taskkill /f /im explorer.exe
timeout 2 /nobreak>nul
DEL /F /S /Q /A %LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db
DEL /f /s /q %systemdrive%\*.tmp
DEL /f /s /q %systemdrive%\*._mp
DEL /f /s /q %systemdrive%\*.log
DEL /f /s /q %systemdrive%\*.gid
DEL /f /s /q %systemdrive%\*.chk
DEL /f /s /q %systemdrive%\*.old
DEL /f /s /q %systemdrive%\recycled\*.*
DEL /f /s /q %systemdrive%\$Recycle.Bin\*.*
DEL /f /s /q %windir%\*.bak
DEL /f /s /q %windir%\prefetch\*.*
rd /s /q %windir%\temp & md %windir%\temp
DEL /f /q %userprofile%\cookies\*.*
DEL /f /q %userprofile%\recent\*.*
DEL /f /s /q "%userprofile%\Local Settings\Temporary Internet Files\*.*"
DEL /f /s /q "%userprofile%\Local Settings\Temp\*.*"
DEL /f /s /q "%userprofile%\recent\*.*"
timeout 2 /nobreak>nul
start explorer.exe

ECHO ********** Clean autostart regystry
REM  ********** Очистить автозапуск в реестре

REG DELETE HKSU\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce /f
REG DELETE HKSU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /f
REG DELETE HKSU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies /f
REG DELETE HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce /f
REG DELETE HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run /f
REG DELETE HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunServicesOnce /f
REG DELETE HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunServices /f
REG DELETE HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx /f
REG DELETE HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /f

ECHO ********** Clean autostart folders
REM  ********** Очистить папки автозагрузки

PUSHD "%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
2>Nul RD /S/Q "%USERPROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
POPD
PUSHD "%SystemDrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"
2>Nul RD /S/Q "%SystemDrive%\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"
POPD

ECHO ********** All installed updates will be permanent and cannot be uninstalled after running this command
REM  ********** Выполняет в образе операции очистки, восстановления и сброс базы - все установленные обновления Windows будут постоянными и не могут быть удалены

DISM /online /Cleanup-Image /StartComponentCleanup /ResetBase

GOTO RESTART

:BLOCK
ECHO ********** Block hosts
REM  ********** Блокировать нежелательные веб узлы в файл hosts

COPY "%WINDIR%\system32\drivers\etc\hosts" "%WINDIR%\system32\drivers\etc\hosts.backup.txt"
ATTRIB -r "%WINDIR%\system32\drivers\etc\hosts"
SET HOSTS=%WINDIR%\System32\drivers\etc\hosts
FIND /C /I "www.msn.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% www.msn.com>>%HOSTS%
FIND /C /I "www.msftncsi.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% www.msftncsi.com>>%HOSTS%
FIND /C /I "www.msdn.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% www.msdn.com>>%HOSTS%
FIND /C /I "www.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% www.microsoft.com>>%HOSTS%
FIND /C /I "www.bing.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% www.bing.com>>%HOSTS%
FIND /C /I "wustats.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% wustats.microsoft.com>>%HOSTS%
FIND /C /I "wns.notify.windows.com.akadns.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% wns.notify.windows.com.akadns.net>>%HOSTS%
FIND /C /I "windowsupdate.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% windowsupdate.microsoft.com>>%HOSTS%
FIND /C /I "windowsupdate.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% windowsupdate.com>>%HOSTS%
FIND /C /I "win10.ipv6.microsoft.com.nsatc.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% win10.ipv6.microsoft.com.nsatc.net>>%HOSTS%
FIND /C /I "win10.ipv6.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% win10.ipv6.microsoft.com>>%HOSTS%
FIND /C /I "wildcard.appex-rf.msn.com.edgesuite.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% wildcard.appex-rf.msn.com.edgesuite.net>>%HOSTS%
FIND /C /I "wes.df.telemetry.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% wes.df.telemetry.microsoft.com>>%HOSTS%
FIND /C /I "watson.telemetry.microsoft.com.nsatc.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% watson.telemetry.microsoft.com.nsatc.net>>%HOSTS%
FIND /C /I "watson.telemetry.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% watson.telemetry.microsoft.com>>%HOSTS%
FIND /C /I "watson.ppe.telemetry.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% watson.ppe.telemetry.microsoft.com>>%HOSTS%
FIND /C /I "watson.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% watson.microsoft.com>>%HOSTS%
FIND /C /I "watson.live.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% watson.live.com>>%HOSTS%
FIND /C /I "vortex.data.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% vortex.data.microsoft.com>>%HOSTS%
FIND /C /I "vortex-win.data.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% vortex-win.data.microsoft.com>>%HOSTS%
FIND /C /I "vortex-sandbox.data.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% vortex-sandbox.data.microsoft.com>>%HOSTS%
FIND /C /I "vortex-cy2.metron.live.com.nsatc.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% vortex-cy2.metron.live.com.nsatc.net>>%HOSTS%
FIND /C /I "vortex-bn2.metron.live.com.nsatc.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% vortex-bn2.metron.live.com.nsatc.net>>%HOSTS%
FIND /C /I "view.atdmt.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% view.atdmt.com>>%HOSTS%
FIND /C /I "v10.vortex-win.data.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% v10.vortex-win.data.microsoft.com>>%HOSTS%
FIND /C /I "v10.vortex-win.data.metron.life.com.nsatc.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% v10.vortex-win.data.metron.life.com.nsatc.net>>%HOSTS%
FIND /C /I "update.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% update.microsoft.com>>%HOSTS%
FIND /C /I "ui.skype.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% ui.skype.com>>%HOSTS%
FIND /C /I "travel.tile.appex.bing.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% travel.tile.appex.bing.com>>%HOSTS%
FIND /C /I "telemetry.urs.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% telemetry.urs.microsoft.com>>%HOSTS%
FIND /C /I "telemetry.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% telemetry.microsoft.com>>%HOSTS%
FIND /C /I "telemetry.appex.bing.net:443" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% telemetry.appex.bing.net:443>>%HOSTS%
FIND /C /I "telemetry.appex.bing.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% telemetry.appex.bing.net>>%HOSTS%
FIND /C /I "telecommand.telemetry.microsoft.com.nsatc.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% telecommand.telemetry.microsoft.com.nsatc.net>>%HOSTS%
FIND /C /I "telecommand.telemetry.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% telecommand.telemetry.microsoft.com>>%HOSTS%
FIND /C /I "survey.watson.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% survey.watson.microsoft.com>>%HOSTS%
FIND /C /I "support.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% support.microsoft.com>>%HOSTS%
FIND /C /I "statsfe2.ws.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% statsfe2.ws.microsoft.com>>%HOSTS%
FIND /C /I "statsfe2.update.microsoft.com.akadns.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% statsfe2.update.microsoft.com.akadns.net>>%HOSTS%
FIND /C /I "statsfe1.ws.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% statsfe1.ws.microsoft.com>>%HOSTS%
FIND /C /I "static.2mdn.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% static.2mdn.net>>%HOSTS%
FIND /C /I "ssw.live.com.nsatc.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% ssw.live.com.nsatc.net>>%HOSTS%
FIND /C /I "ssw.live.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% ssw.live.com>>%HOSTS%
FIND /C /I "sqm.telemetry.microsoft.com.nsatc.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% sqm.telemetry.microsoft.com.nsatc.net>>%HOSTS%
FIND /C /I "sqm.telemetry.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% sqm.telemetry.microsoft.com>>%HOSTS%
FIND /C /I "sqm.df.telemetry.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% sqm.df.telemetry.microsoft.com>>%HOSTS%
FIND /C /I "sls.update.microsoft.com.akadns.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% sls.update.microsoft.com.akadns.net>>%HOSTS%
FIND /C /I "skydrive.wns.windows.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% skydrive.wns.windows.com>>%HOSTS%
FIND /C /I "skyapi.skyprod.akadns.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% skyapi.skyprod.akadns.net>>%HOSTS%
FIND /C /I "skyapi.live.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% skyapi.live.net>>%HOSTS%
FIND /C /I "settings.data.glbdns2.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% settings.data.glbdns2.microsoft.com>>%HOSTS%
FIND /C /I "settings-win.data.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% settings-win.data.microsoft.com>>%HOSTS%
FIND /C /I "settings-sandbox.data.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% settings-sandbox.data.microsoft.com>>%HOSTS%
FIND /C /I "services.wes.df.telemetry.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% services.wes.df.telemetry.microsoft.com>>%HOSTS%
FIND /C /I "secure.flashtalking.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% secure.flashtalking.com>>%HOSTS%
FIND /C /I "secure.adnxs.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% secure.adnxs.com>>%HOSTS%
FIND /C /I "schemas.microsoft.akadns.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% schemas.microsoft.akadns.net>>%HOSTS%
FIND /C /I "sO.2mdn.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% sO.2mdn.net>>%HOSTS%
FIND /C /I "s.gateway.messenger.live.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% s.gateway.messenger.live.com>>%HOSTS%
FIND /C /I "reports.wes.df.telemetry.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% reports.wes.df.telemetry.microsoft.com>>%HOSTS%
FIND /C /I "register.mesh.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% register.mesh.com>>%HOSTS%
FIND /C /I "redir.metaservices.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% redir.metaservices.microsoft.com>>%HOSTS%
FIND /C /I "rad.msn.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% rad.msn.com>>%HOSTS%
FIND /C /I "rad.live.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% rad.live.com>>%HOSTS%
FIND /C /I "pricelist.skype.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% pricelist.skype.com>>%HOSTS%
FIND /C /I "preview.msn.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% preview.msn.com>>%HOSTS%
FIND /C /I "pre.footprintpredict.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% pre.footprintpredict.com>>%HOSTS%
FIND /C /I "office.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% office.microsoft.com>>%HOSTS%
FIND /C /I "oca.telemetry.microsoft.com.nsatc.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% oca.telemetry.microsoft.com.nsatc.net>>%HOSTS%
FIND /C /I "oca.telemetry.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% oca.telemetry.microsoft.com>>%HOSTS%
FIND /C /I "msntest.serving-sys.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% msntest.serving-sys.com>>%HOSTS%
FIND /C /I "msnbot-65-55-108-23.search.msn.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% msnbot-65-55-108-23.search.msn.com>>%HOSTS%
FIND /C /I "msn.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% msn.com>>%HOSTS%
FIND /C /I "msftncsi.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% msftncsi.com>>%HOSTS%
FIND /C /I "msedge.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% msedge.net>>%HOSTS%
FIND /C /I "msdn.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% msdn.microsoft.com>>%HOSTS%
FIND /C /I "msdn.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% msdn.com>>%HOSTS%
FIND /C /I "microsoftupdate.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% microsoftupdate.microsoft.com>>%HOSTS%
FIND /C /I "microsoftupdate.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% microsoftupdate.com>>%HOSTS%
FIND /C /I "microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% microsoft.com>>%HOSTS%
FIND /C /I "m.hotmail.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% m.hotmail.com>>%HOSTS%
FIND /C /I "m.adnxs.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% m.adnxs.com>>%HOSTS%
FIND /C /I "login.live.com.nsatc.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% login.live.com.nsatc.net>>%HOSTS%
FIND /C /I "login.live.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% login.live.com>>%HOSTS%
FIND /C /I "live.rads.msn.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% live.rads.msn.com>>%HOSTS%
FIND /C /I "lb1.www.ms.akadns.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% lb1.www.ms.akadns.net>>%HOSTS%
FIND /C /I "ipv6.msftncsi.com.edgesuite.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% ipv6.msftncsi.com.edgesuite.net>>%HOSTS%
FIND /C /I "ipv6.msftncsi.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% ipv6.msftncsi.com>>%HOSTS%
FIND /C /I "i1.services.social.microsoft.com.nsatc.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% i1.services.social.microsoft.com.nsatc.net>>%HOSTS%
FIND /C /I "i1.services.social.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% i1.services.social.microsoft.com>>%HOSTS%
FIND /C /I "h1.msn.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% h1.msn.com>>%HOSTS%
FIND /C /I "go.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% go.microsoft.com>>%HOSTS%
FIND /C /I "g.msn.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% g.msn.com>>%HOSTS%
FIND /C /I "flex.msn.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% flex.msn.com>>%HOSTS%
FIND /C /I "feedback.windows.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% feedback.windows.com>>%HOSTS%
FIND /C /I "feedback.search.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% feedback.search.microsoft.com>>%HOSTS%
FIND /C /I "feedback.microsoft-hohm.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% feedback.microsoft-hohm.com>>%HOSTS%
FIND /C /I "fe3.delivery.mp.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% fe3.delivery.mp.microsoft.com>>%HOSTS%
FIND /C /I "fe3.delivery.dsp.mp.microsoft.com.nsatc.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% fe3.delivery.dsp.mp.microsoft.com.nsatc.net>>%HOSTS%
FIND /C /I "fe2.update.microsoft.com.akadns.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% fe2.update.microsoft.com.akadns.net>>%HOSTS%
FIND /C /I "en-us.appex-rf.msn.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% en-us.appex-rf.msn.com>>%HOSTS%
FIND /C /I "ec.atdmt.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% ec.atdmt.com>>%HOSTS%
FIND /C /I "download.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% download.microsoft.com>>%HOSTS%
FIND /C /I "dns.msftncsi.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% dns.msftncsi.com>>%HOSTS%
FIND /C /I "directory.services.live.com.akadns.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% directory.services.live.com.akadns.net>>%HOSTS%
FIND /C /I "directory.services.live.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% directory.services.live.com>>%HOSTS%
FIND /C /I "diagnostics.support.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% diagnostics.support.microsoft.com>>%HOSTS%
FIND /C /I "df.telemetry.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% df.telemetry.microsoft.com>>%HOSTS%
FIND /C /I "db3aqu.atdmt.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% db3aqu.atdmt.com>>%HOSTS%
FIND /C /I "cs1.wpc.v0cdn.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% cs1.wpc.v0cdn.net>>%HOSTS%
FIND /C /I "corpext.msitadfs.glbdns2.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% corpext.msitadfs.glbdns2.microsoft.com>>%HOSTS%
FIND /C /I "corp.sts.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% corp.sts.microsoft.com>>%HOSTS%
FIND /C /I "compatexchange.cloudapp.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% compatexchange.cloudapp.net>>%HOSTS%
FIND /C /I "client.wns.windows.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% client.wns.windows.com>>%HOSTS%
FIND /C /I "choice.microsoft.com.nsatc.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% choice.microsoft.com.nsatc.net>>%HOSTS%
FIND /C /I "choice.microsoft.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% choice.microsoft.com>>%HOSTS%
FIND /C /I "cds26.ams9.msecn.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% cds26.ams9.msecn.net>>%HOSTS%
FIND /C /I "cdn.atdmt.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% cdn.atdmt.com>>%HOSTS%
FIND /C /I "c.msn.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% c.msn.com>>%HOSTS%
FIND /C /I "c.atdmt.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% c.atdmt.com>>%HOSTS%
FIND /C /I "bs.serving-sys.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% bs.serving-sys.com>>%HOSTS%
FIND /C /I "bl3302geo.storage.dkyprod.akadns.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% bl3302geo.storage.dkyprod.akadns.net>>%HOSTS%
FIND /C /I "bl3302.storage.live.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% bl3302.storage.live.com>>%HOSTS%
FIND /C /I "b.rad.msn.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% b.rad.msn.com>>%HOSTS%
FIND /C /I "b.ads2.msads.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% b.ads2.msads.net>>%HOSTS%
FIND /C /I "b.ads1.msn.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% b.ads1.msn.com>>%HOSTS%
FIND /C /I "az512334.vo.msecnd.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% az512334.vo.msecnd.net>>%HOSTS%
FIND /C /I "az361816.vo.msecnd.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% az361816.vo.msecnd.net>>%HOSTS%
FIND /C /I "apps.skype.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% apps.skype.com>>%HOSTS%
FIND /C /I "any.edge.bing.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% any.edge.bing.com>>%HOSTS%
FIND /C /I "americas2.notify.windows.com.akadns.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% americas2.notify.windows.com.akadns.net>>%HOSTS%
FIND /C /I "aka-cdn-ns.adtech.de" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% aka-cdn-ns.adtech.de>>%HOSTS%
FIND /C /I "aidps.atdmt.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% aidps.atdmt.com>>%HOSTS%
FIND /C /I "ads1.msn.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% ads1.msn.com>>%HOSTS%
FIND /C /I "ads1.msads.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% ads1.msads.net>>%HOSTS%
FIND /C /I "ads.msn.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% ads.msn.com>>%HOSTS%
FIND /C /I "adnxs.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% adnxs.com>>%HOSTS%
FIND /C /I "adnexus.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% adnexus.net>>%HOSTS%
FIND /C /I "ad.doubleclick.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% ad.doubleclick.net>>%HOSTS%
FIND /C /I "ac3.msn.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% ac3.msn.com>>%HOSTS%
FIND /C /I "a978.i6g1.akamai.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% a978.i6g1.akamai.net>>%HOSTS%
FIND /C /I "a.rad.msn.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% a.rad.msn.com>>%HOSTS%
FIND /C /I "a.ads2.msn.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% a.ads2.msn.com>>%HOSTS%
FIND /C /I "a.ads2.msads.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% a.ads2.msads.net>>%HOSTS%
FIND /C /I "a.ads1.msn.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% a.ads1.msn.com>>%HOSTS%
FIND /C /I "a-msedge.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% a-msedge.net>>%HOSTS%
FIND /C /I "a-0009.a-msedge.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% a-0009.a-msedge.net>>%HOSTS%
FIND /C /I "a-0008.a-msedge.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% a-0008.a-msedge.net>>%HOSTS%
FIND /C /I "a-0007.a-msedge.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% a-0007.a-msedge.net>>%HOSTS%
FIND /C /I "a-0006.a-msedge.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% a-0006.a-msedge.net>>%HOSTS%
FIND /C /I "a-0005.a-msedge.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% a-0005.a-msedge.net>>%HOSTS%
FIND /C /I "a-0004.a-msedge.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% a-0004.a-msedge.net>>%HOSTS%
FIND /C /I "a-0003.a-msedge.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% a-0003.a-msedge.net>>%HOSTS%
FIND /C /I "a-0002.a-msedge.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% a-0002.a-msedge.net>>%HOSTS%
FIND /C /I "a-0001.a-msedge.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% a-0001.a-msedge.net>>%HOSTS%
FIND /C /I "OneSettings-bn2.metron.live.com.nsatc.net" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% OneSettings-bn2.metron.live.com.nsatc.net>>%HOSTS%
FIND /C /I "BN1WNS2011508.wns.windows.com" %HOSTS%
IF %ERRORLEVEL% NEQ 0 ECHO ^%NOURL% BN1WNS2011508.wns.windows.com>>%HOSTS%
ATTRIB +r "%WINDIR%\system32\drivers\etc\hosts"

ECHO ********** Add firewall rules. Block unwanted IP addresses.
REM  ********** Добавление правил брандмауэра. Блокировка нежелательных IP адресов.

NETSH advfirewall set allprofiles state on
NETSH advfirewall firewall add rule name="telemetry_www.trust.office365.com" dir=out action=block remoteip=64.4.6.100 enable=yes
NETSH advfirewall firewall add rule name="telemetry_www.moskisvet.com.c.footprint.net" dir=out action=block remoteip=8.253.37.126 enable=yes
NETSH advfirewall firewall add rule name="telemetry_www.moskisvet.com.c.footprint.net" dir=out action=block remoteip=198.78.208.254 enable=yes
NETSH advfirewall firewall add rule name="telemetry_www.cisco.com" dir=out action=block remoteip=198.135.3.118 enable=yes
NETSH advfirewall firewall add rule name="telemetry_wusonprem.ipv6.microsoft.com.akadns.net" dir=out action=block remoteip=157.56.106.189 enable=yes
NETSH advfirewall firewall add rule name="telemetry_wns.windows.com" dir=out action=block remoteip=40.77.229.0-40.77.229.255 enable=yes
NETSH advfirewall firewall add rule name="telemetry_wes.df.telemetry.microsoft.com" dir=out action=block remoteip=65.52.100.93 enable=yes
NETSH advfirewall firewall add rule name="telemetry_wdcpeurope.microsoft.akadns.net" dir=out action=block remoteip=137.117.235.16 enable=yes
NETSH advfirewall firewall add rule name="telemetry_watson.telemetry.microsoft.com" dir=out action=block remoteip=40.77.228.92 enable=yes
NETSH advfirewall firewall add rule name="telemetry_watson.ppe.telemetry.microsoft.com" dir=out action=block remoteip=65.52.100.11 enable=yes
NETSH advfirewall firewall add rule name="telemetry_watson.microsoft.com.nsatc.net" dir=out action=block remoteip=65.52.108.154 enable=yes
NETSH advfirewall firewall add rule name="telemetry_watson.live.com" dir=out action=block remoteip=207.46.223.94 enable=yes
NETSH advfirewall firewall add rule name="telemetry_vortex-db5.metron.live.com.nsatc.net" dir=out action=block remoteip=191.232.139.5 enable=yes
NETSH advfirewall firewall add rule name="telemetry_vd.vidfuture.com" dir=out action=block remoteip=66.225.197.197 enable=yes
NETSH advfirewall firewall add rule name="telemetry_v4ncsi.msedge.net" dir=out action=block remoteip=13.107.4.52 enable=yes
NETSH advfirewall firewall add rule name="telemetry_v20-asimov-win.vortex.data.microsoft.com.akadns.net" dir=out action=block remoteip=64.4.54.254 enable=yes
NETSH advfirewall firewall add rule name="telemetry_v10-win.vortex.data.microsoft.com.akadns.net" dir=out action=block remoteip=111.221.29.254 enable=yes
NETSH advfirewall firewall add rule name="telemetry_us.vortex-win.data.microsoft.com" dir=out action=block remoteip=40.90.136.33 enable=yes
NETSH advfirewall firewall add rule name="telemetry_urs.microsoft.com.nsatc.net" dir=out action=block remoteip=157.55.233.125,192.232.139.180 enable=yes
NETSH advfirewall firewall add rule name="telemetry_trouter-neu-a.cloudapp.net" dir=out action=block remoteip=13.69.188.18 enable=yes
NETSH advfirewall firewall add rule name="telemetry_trouter-easia-a.dc.trouter.io" dir=out action=block remoteip=13.75.106.0 enable=yes
NETSH advfirewall firewall add rule name="telemetry_telemetry.microsoft.com" dir=out action=block remoteip=65.52.100.9 enable=yes
NETSH advfirewall firewall add rule name="telemetry_telemetry.appex.search.prod.ms.akadns.net" dir=out action=block remoteip=168.61.24.141 enable=yes
NETSH advfirewall firewall add rule name="telemetry_telemetry.appex.bing.net" dir=out action=block remoteip=65.52.161.64,168.63.108.233 enable=yes
NETSH advfirewall firewall add rule name="telemetry_telecommand.telemetry.microsoft.com" dir=out action=block remoteip=65.55.252.92 enable=yes
NETSH advfirewall firewall add rule name="telemetry_tapeytapey.com" dir=out action=block remoteip=2.21.246.26 enable=yes
NETSH advfirewall firewall add rule name="telemetry_t.urs.microsoft.com.nsatc.net" dir=out action=block remoteip=64.4.54.167,65.55.44.85 enable=yes
NETSH advfirewall firewall add rule name="telemetry_t.urs.microsoft.com" dir=out action=block remoteip=131.253.40.37 enable=yes
NETSH advfirewall firewall add rule name="telemetry_survey.watson.microsoft.com" dir=out action=block remoteip=207.68.166.254 enable=yes
NETSH advfirewall firewall add rule name="telemetry_statsfe2-df.ws.microsoft.com.nsatc.net" dir=out action=block remoteip=134.170.115.60 enable=yes
NETSH advfirewall firewall add rule name="telemetry_statsfe2.ws.microsoft.com.nsatc.net" dir=out action=block remoteip=131.253.14.153 enable=yes
NETSH advfirewall firewall add rule name="telemetry_statsfe2.ws.microsoft.com" dir=out action=block remoteip=207.46.114.61 enable=yes
NETSH advfirewall firewall add rule name="telemetry_statsfe2.update.microsoft.com.akadns.net" dir=out action=block remoteip=65.52.108.153 enable=yes
NETSH advfirewall firewall add rule name="telemetry_stats.update.microsoft.com.nsatc.net" dir=out action=block remoteip=64.4.54.22 enable=yes
NETSH advfirewall firewall add rule name="telemetry_static.sl-reverse.com" dir=out action=block remoteip=169.54.179.156 enable=yes
NETSH advfirewall firewall add rule name="telemetry_ssw.live.com.nsatc.net" dir=out action=block remoteip=207.46.7.252 enable=yes
NETSH advfirewall firewall add rule name="telemetry_ssw.live.com" dir=out action=block remoteip=207.46.101.29 enable=yes
NETSH advfirewall firewall add rule name="telemetry_sqm.msn.com" dir=out action=block remoteip=65.55.252.93 enable=yes
NETSH advfirewall firewall add rule name="telemetry_sqm.df.telemetry.microsoft.com" dir=out action=block remoteip=65.52.100.94 enable=yes
NETSH advfirewall firewall add rule name="telemetry_sonybank.net" dir=out action=block remoteip=2.21.246.24 enable=yes
NETSH advfirewall firewall add rule name="telemetry_settings-win-ppe.data.microsoft.com" dir=out action=block remoteip=40.77.226.248 enable=yes
NETSH advfirewall firewall add rule name="telemetry_settings-sandbox.data.microsoft.com" dir=out action=block remoteip=111.221.29.177 enable=yes
NETSH advfirewall firewall add rule name="telemetry_settings-sandbox.data.glbdns2.microsoft.com" dir=out action=block remoteip=191.232.140.76 enable=yes
NETSH advfirewall firewall add rule name="telemetry_services.wes.df.telemetry.microsoft.com" dir=out action=block remoteip=65.52.100.92 enable=yes
NETSH advfirewall firewall add rule name="telemetry_service.xbox.com" dir=out action=block remoteip=157.55.129.21 enable=yes
NETSH advfirewall firewall add rule name="telemetry_secure-ams.adnxs.com" dir=out action=block remoteip=37.252.163.244,37.252.163.106 enable=yes
NETSH advfirewall firewall add rule name="telemetry_secure.flashtalking.com" dir=out action=block remoteip=95.101.244.134 enable=yes
NETSH advfirewall firewall add rule name="telemetry_schemas.microsoft.akadns.net" dir=out action=block remoteip=65.54.226.187 enable=yes
NETSH advfirewall firewall add rule name="telemetry_sact.atdmt.com" dir=out action=block remoteip=94.245.121.177 enable=yes
NETSH advfirewall firewall add rule name="telemetry_s0.2mdn.net" dir=out action=block remoteip=172.217.21.166 enable=yes
NETSH advfirewall firewall add rule name="telemetry_s.outlook.com" dir=out action=block remoteip=134.170.3.199 enable=yes
NETSH advfirewall firewall add rule name="telemetry_rmads.msn.com" dir=out action=block remoteip=157.56.23.91 enable=yes
NETSH advfirewall firewall add rule name="telemetry_reports.wes.df.telemetry.microsoft.com" dir=out action=block remoteip=65.52.100.91 enable=yes
NETSH advfirewall firewall add rule name="telemetry_redir.metaservices.microsoft.com" dir=out action=block remoteip=194.44.4.200,194.44.4.208,2.21.246.42,2.21.246.58 enable=yes
NETSH advfirewall firewall add rule name="telemetry_realgames.cn" dir=out action=block remoteip=65.55.57.27 enable=yes
NETSH advfirewall firewall add rule name="telemetry_pipe.skype.com" dir=out action=block remoteip=40.115.1.44 enable=yes
NETSH advfirewall firewall add rule name="telemetry_perthnow.com.au" dir=out action=block remoteip=2.21.246.8 enable=yes
NETSH advfirewall firewall add rule name="telemetry_osiprod-weu-snow-000.cloudapp.net" dir=out action=block remoteip=23.97.178.173 enable=yes
NETSH advfirewall firewall add rule name="telemetry_oca.watson.data.microsoft.com.akadns.net" dir=out action=block remoteip=64.4.54.153 enable=yes
NETSH advfirewall firewall add rule name="telemetry_oca.telemetry.microsoft.com.nsatc.net" dir=out action=block remoteip=65.55.252.63 enable=yes
NETSH advfirewall firewall add rule name="telemetry_nt-c.ns.nsatc.net" dir=out action=block remoteip=8.254.119.155 enable=yes
NETSH advfirewall firewall add rule name="telemetry_nt-b.ns.nsatc.net" dir=out action=block remoteip=8.254.92.155 enable=yes
NETSH advfirewall firewall add rule name="telemetry_ns3.msft.net" dir=out action=block remoteip=192.221.113.53 enable=yes
NETSH advfirewall firewall add rule name="telemetry_ns3.a-msedge.net" dir=out action=block remoteip=131.253.21.1 enable=yes
NETSH advfirewall firewall add rule name="telemetry_ns2.a-msedge.net" dir=out action=block remoteip=204.79.197.2 enable=yes
NETSH advfirewall firewall add rule name="telemetry_ns1.gslb.com" dir=out action=block remoteip=8.19.31.10 enable=yes
NETSH advfirewall firewall add rule name="telemetry_ns1.a-msedge.net" dir=out action=block remoteip=204.79.197.1 enable=yes
NETSH advfirewall firewall add rule name="telemetry_nl-1.ns.nsatc.net" dir=out action=block remoteip=4.23.39.155 enable=yes
NETSH advfirewall firewall add rule name="telemetry_nexus.officeapps.live.com" dir=out action=block remoteip=40.76.8.142,23.101.14.229,207.46.153.155 enable=yes
NETSH advfirewall firewall add rule name="telemetry_next-services.windows.akadns.net" dir=out action=block remoteip=134.170.30.202 enable=yes
NETSH advfirewall firewall add rule name="telemetry_new_wns.windows.com" dir=out action=block remoteip=131.253.21.0-131.253.47.255 enable=yes
NETSH advfirewall firewall add rule name="telemetry_msnbot-65-55-108-23.search.msn.com" dir=out action=block remoteip=65.55.108.23 enable=yes
NETSH advfirewall firewall add rule name="telemetry_msnbot-64-4-54-18.search.msn.com" dir=out action=block remoteip=64.4.54.18 enable=yes
NETSH advfirewall firewall add rule name="telemetry_msnbot-207-46-194-46.search.msn.com" dir=out action=block remoteip=207.46.194.46 enable=yes
NETSH advfirewall firewall add rule name="telemetry_msnbot-207-46-194-33.search.msn.com" dir=out action=block remoteip=207.46.194.33 enable=yes
NETSH advfirewall firewall add rule name="telemetry_msnbot-207-46-194-29.search.msn.com" dir=out action=block remoteip=207.46.194.29 enable=yes
NETSH advfirewall firewall add rule name="telemetry_msnbot-207-46-194-25.search.msn.com" dir=out action=block remoteip=207.46.194.25 enable=yes
NETSH advfirewall firewall add rule name="telemetry_msnbot-207-46-194-14.search.msn.com" dir=out action=block remoteip=207.46.194.14 enable=yes
NETSH advfirewall firewall add rule name="telemetry_msedge.net" dir=out action=block remoteip=204.79.19.197 enable=yes
NETSH advfirewall firewall add rule name="telemetry_ms1-ib.adnxs.com" dir=out action=block remoteip=37.252.163.88 enable=yes
NETSH advfirewall firewall add rule name="telemetry_modern.watson.data.microsoft.com.akadns.net" dir=out action=block remoteip=65.55.252.43,65.52.108.29,65.55.252.202 enable=yes
NETSH advfirewall firewall add rule name="telemetry_mm.bing.net" dir=out action=block remoteip=204.79.197.200 enable=yes
NETSH advfirewall firewall add rule name="telemetry_microsoft22.com" dir=out action=block remoteip=52.178.178.16 enable=yes
NETSH advfirewall firewall add rule name="telemetry_microsoft21.com" dir=out action=block remoteip=65.55.64.54 enable=yes
NETSH advfirewall firewall add rule name="telemetry_microsoft20.com" dir=out action=block remoteip=40.80.145.27 enable=yes
NETSH advfirewall firewall add rule name="telemetry_microsoft17.com" dir=out action=block remoteip=40.80.145.78 enable=yes
NETSH advfirewall firewall add rule name="telemetry_microsoft16.com" dir=out action=block remoteip=23.99.116.116 enable=yes
NETSH advfirewall firewall add rule name="telemetry_microsoft15.com" dir=out action=block remoteip=77.67.29.176 enable=yes
NETSH advfirewall firewall add rule name="telemetry_microsoft14.com" dir=out action=block remoteip=65.55.223.0-65.55.223.255 enable=yes
NETSH advfirewall firewall add rule name="telemetry_microsoft13.com" dir=out action=block remoteip=65.39.117.230 enable=yes
NETSH advfirewall firewall add rule name="telemetry_microsoft12.com" dir=out action=block remoteip=64.4.23.0-64.4.23.255 enable=yes
NETSH advfirewall firewall add rule name="telemetry_microsoft11.com" dir=out action=block remoteip=23.223.20.82 enable=yes
NETSH advfirewall firewall add rule name="telemetry_microsoft10.com" dir=out action=block remoteip=213.199.179.0-213.199.179.255 enable=yes
NETSH advfirewall firewall add rule name="telemetry_microsoft09.com" dir=out action=block remoteip=2.22.61.66 enable=yes
NETSH advfirewall firewall add rule name="telemetry_microsoft08.com" dir=out action=block remoteip=195.138.255.0-195.138.255.255 enable=yes
NETSH advfirewall firewall add rule name="telemetry_microsoft07.com" dir=out action=block remoteip=157.55.56.0-157.55.56.255 enable=yes
NETSH advfirewall firewall add rule name="telemetry_microsoft06.com" dir=out action=block remoteip=157.55.52.0-157.55.52.255 enable=yes
NETSH advfirewall firewall add rule name="telemetry_microsoft05.com" dir=out action=block remoteip=157.55.236.0-157.55.236.255 enable=yes
NETSH advfirewall firewall add rule name="telemetry_microsoft04.com" dir=out action=block remoteip=157.55.235.0-157.55.235.255 enable=yes
NETSH advfirewall firewall add rule name="telemetry_microsoft03.com" dir=out action=block remoteip=157.55.130.0-157.55.130.255 enable=yes
NETSH advfirewall firewall add rule name="telemetry_microsoft02.com" dir=out action=block remoteip=111.221.64.0-111.221.127.255 enable=yes
NETSH advfirewall firewall add rule name="telemetry_microsoft01.com" dir=out action=block remoteip=11.221.29.253 enable=yes
NETSH advfirewall firewall add rule name="telemetry_microsoft.com" dir=out action=block remoteip=104.96.147.3 enable=yes
NETSH advfirewall firewall add rule name="telemetry_mediaroomsds.microsoft.com" dir=out action=block remoteip=134.170.185.70 enable=yes
NETSH advfirewall firewall add rule name="telemetry_media.blinkbox.com.c.footprint.net" dir=out action=block remoteip=206.33.58.254 enable=yes
NETSH advfirewall firewall add rule name="telemetry_m.adnxs.com" dir=out action=block remoteip=37.252.170.141 enable=yes
NETSH advfirewall firewall add rule name="telemetry_legacy.watson.data.microsoft.com.akadns.net" dir=out action=block remoteip=65.55.252.71 enable=yes
NETSH advfirewall firewall add rule name="telemetry_inside.microsoftmse.com" dir=out action=block remoteip=65.55.39.10 enable=yes
NETSH advfirewall firewall add rule name="telemetry_iact.atdmt.com" dir=out action=block remoteip=94.245.121.178 enable=yes
NETSH advfirewall firewall add rule name="telemetry_i4.services.social.microsoft.com" dir=out action=block remoteip=104.79.134.225 enable=yes
NETSH advfirewall firewall add rule name="telemetry_i1.services.social.microsoft.com" dir=out action=block remoteip=23.74.190.252,104.82.22.249 enable=yes
NETSH advfirewall firewall add rule name="telemetry_hp-comm.ca.msn.com" dir=out action=block remoteip=40.127.139.224 enable=yes
NETSH advfirewall firewall add rule name="telemetry_helloaddress.com" dir=out action=block remoteip=2.21.246.10 enable=yes
NETSH advfirewall firewall add rule name="telemetry_globalns2.appnexus.net" dir=out action=block remoteip=8.19.31.11 enable=yes
NETSH advfirewall firewall add rule name="telemetry_geo-prod.dodsp.mp.microsoft.com.nsatc.net" dir=out action=block remoteip=191.232.139.212 enable=yes
NETSH advfirewall firewall add rule name="telemetry_geo-prod.do.dsp.mp.microsoft.com" dir=out action=block remoteip=40.77.226.217-40.77.226.224 enable=yes
NETSH advfirewall firewall add rule name="telemetry_geo.settings.data.microsoft.com.akadns.net" dir=out action=block remoteip=64.4.0.0-64.4.63.255 enable=yes
NETSH advfirewall firewall add rule name="telemetry_float.2655.bm-impbus.prod.ams1.adnexus.net" dir=out action=block remoteip=37.252.163.215 enable=yes
NETSH advfirewall firewall add rule name="telemetry_float.2113.bm-impbus.prod.ams1.adnexus.net" dir=out action=block remoteip=37.252.163.3 enable=yes
NETSH advfirewall firewall add rule name="telemetry_float.1334.bm-impbus.prod.fra1.adnexus.net" dir=out action=block remoteip=37.252.170.82 enable=yes
NETSH advfirewall firewall add rule name="telemetry_float.1332.bm-impbus.prod.fra1.adnexus.net" dir=out action=block remoteip=37.252.170.81 enable=yes
NETSH advfirewall firewall add rule name="telemetry_float.1143.bm-impbus.prod.fra1.adnexus.net" dir=out action=block remoteip=37.252.170.1 enable=yes
NETSH advfirewall firewall add rule name="telemetry_flex.msn.com" dir=out action=block remoteip=207.46.194.8 enable=yes
NETSH advfirewall firewall add rule name="telemetry_fesweb1.ch1d.binginternal.com" dir=out action=block remoteip=131.253.14.76 enable=yes
NETSH advfirewall firewall add rule name="telemetry_fe3.delivery.dsp.mp.microsoft.com.nsatc.net" dir=out action=block remoteip=64.4.54.18 enable=yes
NETSH advfirewall firewall add rule name="telemetry_fd-rad-msn-com.a-0004.a-msedge.net" dir=out action=block remoteip=204.79.197.206 enable=yes
NETSH advfirewall firewall add rule name="telemetry_fashiontamils.com" dir=out action=block remoteip=69.64.34.185 enable=yes
NETSH advfirewall firewall add rule name="telemetry_exch-eu.atdmt.com.nsatc.net" dir=out action=block remoteip=94.245.121.179,94.245.121.176 enable=yes
NETSH advfirewall firewall add rule name="telemetry_evoke-windowsservices-tas.msedge.net" dir=out action=block remoteip=13.107.5.88 enable=yes
NETSH advfirewall firewall add rule name="telemetry_eu.vortex-win.data.microsoft.com" dir=out action=block remoteip=191.232.139.254 enable=yes
NETSH advfirewall firewall add rule name="telemetry_es-1.ns.nsatc.net" dir=out action=block remoteip=8.254.34.155 enable=yes
NETSH advfirewall firewall add rule name="telemetry_edge-atlas-shv-01-cdg2.facebook.com" dir=out action=block remoteip=179.60.192.10 enable=yes
NETSH advfirewall firewall add rule name="telemetry_e8218.ce.akamaiedge.net" dir=out action=block remoteip=23.57.107.27 enable=yes
NETSH advfirewall firewall add rule name="telemetry_e6845.ce.akamaiedge.net" dir=out action=block remoteip=23.57.101.163 enable=yes
NETSH advfirewall firewall add rule name="telemetry_dub109-afx.ms.a-0009.a-msedge.net" dir=out action=block remoteip=204.79.197.211 enable=yes
NETSH advfirewall firewall add rule name="telemetry_dps.msn.com" dir=out action=block remoteip=131.253.14.121 enable=yes
NETSH advfirewall firewall add rule name="telemetry_dmd.metaservices.microsoft.com.akadns.net" dir=out action=block remoteip=52.160.91.170 enable=yes
NETSH advfirewall firewall add rule name="telemetry_dmd.metaservices.microsoft.com.akadns.net" dir=out action=block remoteip=40.112.210.171 enable=yes
NETSH advfirewall firewall add rule name="telemetry_dmd.metaservices.microsoft.com" dir=out action=block remoteip=40.87.63.92,40.80.145.78,40.80.145.38,40.80.145.27,40.112.213.22 enable=yes
NETSH advfirewall firewall add rule name="telemetry_diagnostics.support.microsoft.com" dir=out action=block remoteip=134.170.52.151 enable=yes
NETSH advfirewall firewall add rule name="telemetry_diagnostics.support.microsoft.akadns.net" dir=out action=block remoteip=157.56.121.89 enable=yes
NETSH advfirewall firewall add rule name="telemetry_df.telemetry.microsoft.com" dir=out action=block remoteip=65.52.100.7 enable=yes
NETSH advfirewall firewall add rule name="telemetry_descargas.diximedia.es.c.footprint.net" dir=out action=block remoteip=185.13.160.61 enable=yes
NETSH advfirewall firewall add rule name="telemetry_deploy.static.akamaitechnologies.com" dir=out action=block remoteip=23.218.212.69 enable=yes
NETSH advfirewall firewall add rule name="telemetry_deploy.akamaitechnologies.com" dir=out action=block remoteip=95.100.38.95 enable=yes
NETSH advfirewall firewall add rule name="telemetry_db5.wns.notify.windows.com.akadns.net" dir=out action=block remoteip=40.77.226.246,40.77.226.247 enable=yes
NETSH advfirewall firewall add rule name="telemetry_db5.vortex.data.microsoft.com.akadns.net" dir=out action=block remoteip=40.77.226.250 enable=yes
NETSH advfirewall firewall add rule name="telemetry_db5.settings.data.microsoft.com.akadns.net" dir=out action=block remoteip=40.77.226.249,191.232.139.253 enable=yes
NETSH advfirewall firewall add rule name="telemetry_db5.displaycatalog.md.mp.microsoft.com.akadns.net" dir=out action=block remoteip=40.77.229.125 enable=yes
NETSH advfirewall firewall add rule name="telemetry_db3wns2011111.wns.windows.com" dir=out action=block remoteip=157.56.124.87 enable=yes
NETSH advfirewall firewall add rule name="telemetry_dart.l.doubleclick.net" dir=out action=block remoteip=173.194.113.219,173.194.113.220,173.194.113.219,216.58.209.166,172.217.20.134 enable=yes
NETSH advfirewall firewall add rule name="telemetry_cy2.settings.data.microsoft.com.akadns.net" dir=out action=block remoteip=64.4.54.253,13.78.188.147 enable=yes
NETSH advfirewall firewall add rule name="telemetry_cs697.wac.thetacdn.net" dir=out action=block remoteip=192.229.233.249 enable=yes
NETSH advfirewall firewall add rule name="telemetry_cs479.wac.edgecastcdn.net" dir=out action=block remoteip=68.232.35.139 enable=yes
NETSH advfirewall firewall add rule name="telemetry_corpext.msitadfs.glbdns2.microsoft.com" dir=out action=block remoteip=131.107.113.238 enable=yes
NETSH advfirewall firewall add rule name="telemetry_compatexchange.cloudapp.net" dir=out action=block remoteip=23.99.10.11 enable=yes
NETSH advfirewall firewall add rule name="telemetry_colonialtoolset.com" dir=out action=block remoteip=208.84.0.53 enable=yes
NETSH advfirewall firewall add rule name="telemetry_col130-afx.ms.a-0008.a-msedge.net" dir=out action=block remoteip=204.79.197.210 enable=yes
NETSH advfirewall firewall add rule name="telemetry_co4.telecommand.telemetry.microsoft.com.akadns.net" dir=out action=block remoteip=65.55.252.190 enable=yes
NETSH advfirewall firewall add rule name="telemetry_cn.msn.fr" dir=out action=block remoteip=23.102.21.4 enable=yes
NETSH advfirewall firewall add rule name="telemetry_choice.microsoft.com.nsatc.net" dir=out action=block remoteip=65.55.128.81,157.56.91.77 enable=yes
NETSH advfirewall firewall add rule name="telemetry_chinamobileltd.com" dir=out action=block remoteip=211.137.82.38 enable=yes
NETSH advfirewall firewall add rule name="telemetry_cdn.energetichabits.com" dir=out action=block remoteip=93.184.220.20 enable=yes
NETSH advfirewall firewall add rule name="telemetry_cdn.deezer.com.c.footprint.net" dir=out action=block remoteip=8.254.209.254 enable=yes
NETSH advfirewall firewall add rule name="telemetry_cannon-construction.co.uk" dir=out action=block remoteip=93.184.220.29 enable=yes
NETSH advfirewall firewall add rule name="telemetry_candycrushsoda.king.com" dir=out action=block remoteip=185.48.81.162 enable=yes
NETSH advfirewall firewall add rule name="telemetry_c.nine.com.au" dir=out action=block remoteip=207.46.194.10 enable=yes
NETSH advfirewall firewall add rule name="telemetry_c.microsoft.akadns.net" dir=out action=block remoteip=134.170.188.139 enable=yes
NETSH advfirewall firewall add rule name="telemetry_bsnl.eyeblaster.akadns.net" dir=out action=block remoteip=82.199.80.141 enable=yes
NETSH advfirewall firewall add rule name="telemetry_bots.teams.skype.com" dir=out action=block remoteip=13.107.3.128 enable=yes
NETSH advfirewall firewall add rule name="telemetry_bn2.vortex.data.microsoft.com.akadns.net" dir=out action=block remoteip=65.55.44.109 enable=yes
NETSH advfirewall firewall add rule name="telemetry_blu173-mail-live-com.a-0006.a-msedge.net" dir=out action=block remoteip=204.79.197.208 enable=yes
NETSH advfirewall firewall add rule name="telemetry_beta.t.urs.microsoft.com" dir=out action=block remoteip=157.56.74.250 enable=yes
NETSH advfirewall firewall add rule name="telemetry_bay175-mail-live-com.a-0007.a-msedge.net" dir=out action=block remoteip=204.79.197.209 enable=yes
NETSH advfirewall firewall add rule name="telemetry_b.ns.nsatc.net" dir=out action=block remoteip=198.78.208.155 enable=yes
NETSH advfirewall firewall add rule name="telemetry_auth.nym2.appnexus.net" dir=out action=block remoteip=68.67.155.138 enable=yes
NETSH advfirewall firewall add rule name="telemetry_auth.lax1.appnexus.net" dir=out action=block remoteip=68.67.133.169 enable=yes
NETSH advfirewall firewall add rule name="telemetry_auth.ams1.appnexus.net" dir=out action=block remoteip=37.252.164.5 enable=yes
NETSH advfirewall firewall add rule name="telemetry_assets2.parliament.uk.c.footprint.net" dir=out action=block remoteip=192.221.106.126 enable=yes
NETSH advfirewall firewall add rule name="telemetry_assets.dishonline.com.c.footprint.net" dir=out action=block remoteip=207.123.56.252 enable=yes
NETSH advfirewall firewall add rule name="telemetry_asimov-sandbox.vortex.data.microsoft.com.akadns.net" dir=out action=block remoteip=64.4.54.32 enable=yes
NETSH advfirewall firewall add rule name="telemetry_array204-prod.dodsp.mp.microsoft.com.nsatc.net" dir=out action=block remoteip=65.52.0.0-65.52.255.255 enable=yes
NETSH advfirewall firewall add rule name="telemetry_apnic.net" dir=out action=block remoteip=221.232.247.2,222.216.3.213 enable=yes
NETSH advfirewall firewall add rule name="telemetry_a-msedge.net" dir=out action=block remoteip=204.79.197.204 enable=yes
NETSH advfirewall firewall add rule name="telemetry_ams1-ib.adnxs.com" dir=out action=block remoteip=37.252.163.207,37.252.162.228,37.252.162.216 enable=yes
NETSH advfirewall firewall add rule name="telemetry_ampudc.udc0.glbdns2.microsoft.com" dir=out action=block remoteip=137.116.81.24 enable=yes
NETSH advfirewall firewall add rule name="telemetry_akadns.info" dir=out action=block remoteip=157.56.96.54 enable=yes
NETSH advfirewall firewall add rule name="telemetry_ads.msn.com" dir=out action=block remoteip=157.56.91.82,157.56.23.91,104.82.14.146,207.123.56.252,185.13.160.61,8.254.209.254,65.55.128.80,8.12.207.125 enable=yes
NETSH advfirewall firewall add rule name="telemetry_adnxs.com" dir=out action=block remoteip=37.252.170.80,37.252.170.142,37.252.170.140,37.252.169.43 enable=yes
NETSH advfirewall firewall add rule name="telemetry_ad.doubleclick.net" dir=out action=block remoteip=172.217.20.230 enable=yes
NETSH advfirewall firewall add rule name="telemetry_acyfdr.explicit.bing.net" dir=out action=block remoteip=204.79.197.201 enable=yes
NETSH advfirewall firewall add rule name="telemetry_a.msft.net" dir=out action=block remoteip=208.76.45.53 enable=yes

ECHO ********** Block ports (security)
REM  ********** Блокировка портов (безопасность)

NETSH advfirewall firewall add rule name="Block_TCP-69" dir=in action=block protocol=tcp localport=69 enable=yes
NETSH advfirewall firewall add rule name="Block_TCP-135" dir=in action=block protocol=tcp localport=135 enable=yes
NETSH advfirewall firewall add rule name="Block_TCP-137" dir=in action=block protocol=tcp localport=137 enable=yes
NETSH advfirewall firewall add rule name="Block_TCP-138" dir=in action=block protocol=tcp localport=138 enable=yes
NETSH advfirewall firewall add rule name="Block_TCP-139" dir=in action=block protocol=tcp localport=139 enable=yes
NETSH advfirewall firewall add rule name="Block_TCP-445" dir=in action=block protocol=tcp localport=445 enable=yes
NETSH advfirewall firewall add rule name="Block_TCP-1025" dir=in action=block protocol=tcp localport=1025 enable=yes
NETSH advfirewall firewall add rule name="Block_TCP-4444" dir=in action=block protocol=tcp localport=4444 enable=yes
NETSH advfirewall firewall add rule name="Block_TCP-5000" dir=in action=block protocol=tcp localport=5000 enable=yes
GOTO REG

:RESTART
ECHO ********** Reboot
REM  ********** Перезагрузка

SHUTDOWN -r -t 00
