[Setup]
AppName=SpawnPVP Launcher
AppPublisher=SpawnPVP
UninstallDisplayName=SpawnPVP
AppVersion=${project.version}
AppSupportURL=https://SpawnPVP.net/
DefaultDirName={localappdata}\SpawnPVP

; ~30 mb for the repo the launcher downloads
ExtraDiskSpaceRequired=30000000
ArchitecturesAllowed=arm64
PrivilegesRequired=lowest

WizardSmallImageFile=${basedir}/app_small.bmp
WizardImageFile=${basedir}/left.bmp
SetupIconFile=${basedir}/app.ico
UninstallDisplayIcon={app}\SpawnPVP.exe

Compression=lzma2
SolidCompression=yes

OutputDir=${basedir}
OutputBaseFilename=SpawnPVPSetupAArch64

[Tasks]
Name: DesktopIcon; Description: "Create a &desktop icon";

[Files]
Source: "${basedir}\build\win-aarch64\SpawnPVP.exe"; DestDir: "{app}"
Source: "${basedir}\build\win-aarch64\SpawnPVP.jar"; DestDir: "{app}"
Source: "${basedir}\build\win-aarch64\launcher_aarch64.dll"; DestDir: "{app}"
Source: "${basedir}\build\win-aarch64\config.json"; DestDir: "{app}"
Source: "${basedir}\build\win-aarch64\jre\*"; DestDir: "{app}\jre"; Flags: recursesubdirs
Source: "${basedir}\app.ico"; DestDir: "{app}"
Source: "${basedir}\left.bmp"; DestDir: "{app}"
Source: "${basedir}\app_small.bmp"; DestDir: "{app}"

[Icons]
; start menu
Name: "{userprograms}\SpawnPVP\SpawnPVP"; Filename: "{app}\SpawnPVP.exe"
Name: "{userprograms}\SpawnPVP\SpawnPVP (configure)"; Filename: "{app}\SpawnPVP.exe"; Parameters: "--configure"
Name: "{userprograms}\SpawnPVP\SpawnPVP (safe mode)"; Filename: "{app}\SpawnPVP.exe"; Parameters: "--safe-mode"
Name: "{userdesktop}\SpawnPVP"; Filename: "{app}\SpawnPVP.exe"; Tasks: DesktopIcon

[Run]
Filename: "{app}\SpawnPVP.exe"; Parameters: "--postinstall"; Flags: nowait
Filename: "{app}\SpawnPVP.exe"; Description: "&Open SpawnPVP"; Flags: postinstall skipifsilent nowait

[InstallDelete]
; Delete the old jvm so it doesn't try to load old stuff with the new vm and crash
Type: filesandordirs; Name: "{app}\jre"
; previous shortcut
Type: files; Name: "{userprograms}\SpawnPVP.lnk"

[UninstallDelete]
Type: filesandordirs; Name: "{%USERPROFILE}\.SpawnPVP\repository2"
; includes install_id, settings, etc
Type: filesandordirs; Name: "{app}"

[Code]
#include "upgrade.pas"
#include "usernamecheck.pas"
#include "dircheck.pas"