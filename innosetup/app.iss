[Setup]
AppName=Wrath Launcher
AppPublisher=Wrath
UninstallDisplayName=Wrath
AppVersion=${project.version}
AppSupportURL=https://wrapthrsps.com/
DefaultDirName={localappdata}\Wrath

; ~30 mb for the repo the launcher downloads
ExtraDiskSpaceRequired=30000000
ArchitecturesAllowed=x64
PrivilegesRequired=lowest

WizardSmallImageFile=${basedir}/app_small.bmp
WizardImageFile=${basedir}/left.bmp
SetupIconFile=${basedir}/app.ico
UninstallDisplayIcon={app}\Wrath.exe

Compression=lzma2
SolidCompression=yes

OutputDir=${basedir}
OutputBaseFilename=WrathSetup

[Tasks]
Name: DesktopIcon; Description: "Create a &desktop icon";

[Files]
Source: "${basedir}\app.ico"; DestDir: "{app}"
Source: "${basedir}\left.bmp"; DestDir: "{app}"
Source: "${basedir}\app_small.bmp"; DestDir: "{app}"
Source: "${basedir}\build\win-x64\Wrath.exe"; DestDir: "{app}"
Source: "${basedir}\build\win-x64\Wrath.jar"; DestDir: "{app}"
Source: "${basedir}\build\win-x64\launcher_amd64.dll"; DestDir: "{app}"
Source: "${basedir}\build\win-x64\config.json"; DestDir: "{app}"
Source: "${basedir}\build\win-x64\jre\*"; DestDir: "{app}\jre"; Flags: recursesubdirs

[Icons]
; start menu
Name: "{userprograms}\Wrath\Wrath"; Filename: "{app}\Wrath.exe"
Name: "{userprograms}\Wrath\Wrath (configure)"; Filename: "{app}\Wrath.exe"; Parameters: "--configure"
Name: "{userprograms}\Wrath\Wrath (safe mode)"; Filename: "{app}\Wrath.exe"; Parameters: "--safe-mode"
Name: "{userdesktop}\Wrath"; Filename: "{app}\Wrath.exe"; Tasks: DesktopIcon

[Run]
Filename: "{app}\Wrath.exe"; Parameters: "--postinstall"; Flags: nowait
Filename: "{app}\Wrath.exe"; Description: "&Open Wrath"; Flags: postinstall skipifsilent nowait

[InstallDelete]
; Delete the old jvm so it doesn't try to load old stuff with the new vm and crash
Type: filesandordirs; Name: "{app}\jre"
; previous shortcut
Type: files; Name: "{userprograms}\Wrath.lnk"

[UninstallDelete]
Type: filesandordirs; Name: "{%USERPROFILE}\.Wrath\repository2"
; includes install_id, settings, etc
Type: filesandordirs; Name: "{app}"

[Code]
#include "upgrade.pas"
#include "usernamecheck.pas"
#include "dircheck.pas"