Speaky 0.1.0 - offline dictation for Windows 10/11 (x64)

INSTALL
  1. Keep this folder where you can find it, for example C:\Apps\Speaky.
  2. Open PowerShell in this folder.
  3. Run:
       powershell -ExecutionPolicy Bypass -File install.ps1

  That copies the app to %LOCALAPPDATA%\Speaky and adds a desktop and Start
  menu shortcut. Speaky then lives in the tray.

FIRST RUN
  Click "Download model" in the Settings window (about 550 MB, once). The app
  works offline afterwards.

USE
  Default shortcut: Ctrl+Alt+Space.
  Hold it while you speak, or switch to "Tap to toggle" in Settings and tap
  once to start, once to stop.

UNINSTALL
  powershell -ExecutionPolicy Bypass -File install.ps1 -Uninstall
  Add -Purge to delete the downloaded models as well.

PRIVACY
  Audio never leaves the machine. The only network access is the one-time model
  download. Settings: %APPDATA%\Speaky. Models: %LOCALAPPDATA%\Speaky\models.

The zipped build is unsigned, so SmartScreen may warn on first launch.
Choose "More info" then "Run anyway".
