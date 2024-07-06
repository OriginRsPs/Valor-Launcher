[Setup]
AppName=BaseScape Launcher
AppPublisher=BaseScape
UninstallDisplayName=BaseScape
AppVersion=${project.version}
AppSupportURL=https://basescape.io/
DefaultDirName={localappdata}\BaseScape

; ~30 mb for the repo the launcher downloads
ExtraDiskSpaceRequired=30000000
ArchitecturesAllowed=x86 x64
PrivilegesRequired=lowest

WizardSmallImageFile=${basedir}/app_small.bmp
WizardImageFile=${basedir}/left.bmp
SetupIconFile=${basedir}/app.ico
UninstallDisplayIcon={app}\BaseScape.exe

Compression=lzma2
SolidCompression=yes

OutputDir=${basedir}
OutputBaseFilename=BaseScapeSetup32

[Tasks]
Name: DesktopIcon; Description: "Create a &desktop icon";

[Files]
Source: "${basedir}\build\win-x86\BaseScape.exe"; DestDir: "{app}"
Source: "${basedir}\build\win-x86\BaseScape.jar"; DestDir: "{app}"
Source: "${basedir}\build\win-x86\launcher_x86.dll"; DestDir: "{app}"
Source: "${basedir}\build\win-x86\config.json"; DestDir: "{app}"
Source: "${basedir}\build\win-x86\jre\*"; DestDir: "{app}\jre"; Flags: recursesubdirs
Source: "${basedir}\app.ico"; DestDir: "{app}"
Source: "${basedir}\left.bmp"; DestDir: "{app}"
Source: "${basedir}\app_small.bmp"; DestDir: "{app}"

[Icons]
; start menu
Name: "{userprograms}\BaseScape\BaseScape"; Filename: "{app}\BaseScape.exe"
Name: "{userprograms}\BaseScape\BaseScape (configure)"; Filename: "{app}\BaseScape.exe"; Parameters: "--configure"
Name: "{userprograms}\BaseScape\BaseScape (safe mode)"; Filename: "{app}\BaseScape.exe"; Parameters: "--safe-mode"
Name: "{userdesktop}\BaseScape"; Filename: "{app}\BaseScape.exe"; Tasks: DesktopIcon

[Run]
Filename: "{app}\BaseScape.exe"; Parameters: "--postinstall"; Flags: nowait
Filename: "{app}\BaseScape.exe"; Description: "&Open BaseScape"; Flags: postinstall skipifsilent nowait

[InstallDelete]
; Delete the old jvm so it doesn't try to load old stuff with the new vm and crash
Type: filesandordirs; Name: "{app}\jre"
; previous shortcut
Type: files; Name: "{userprograms}\BaseScape.lnk"

[UninstallDelete]
Type: filesandordirs; Name: "{%USERPROFILE}\.BaseScape\repository2"
; includes install_id, settings, etc
Type: filesandordirs; Name: "{app}"

[Code]
#include "upgrade.pas"
#include "usernamecheck.pas"
#include "dircheck.pas"