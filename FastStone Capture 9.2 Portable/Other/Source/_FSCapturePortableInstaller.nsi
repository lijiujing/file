/*
http://www.faststonesoft.net/DN/FSCaptureSetup79.exe
http://www.faststonesoft.net/DN/FSCaptureSetup79.zip
http://www.faststonesoft.net/DN/FSCapture79.zip

http://www.faststonesoft.net/DN/FSCaptureSetup80.exe
http://www.faststonesoft.net/DN/FSCaptureSetup80.zip
http://www.faststonesoft.net/DN/FSCapture80.zip

*/
!define RELEASURL	"http://www.faststonesoft.net/DN"
!define APPSIZE	"2500" # kB
!define DLVER	"MultiVersion"
!define APPVER 	"0.0.0.0"
!define APPNAME "FastStone Capture"
!define APP 	"FSCapture"
!define DLNAME	"FastStone_Capture"
!define APPLANG	"En_Online"
!define FOLDER	"FSCapturePortable"
!define FINISHRUN ; Delete if not Finish pages
!define SOURCES ; Delete if no Sources
; !define DESCRIPTION	"Screen Capture" ; Delete if no AppInfo
!define INPUTBOX ; Delete if no InputBox

SetCompressor /SOLID lzma
SetCompressorDictSize 32

!include "..\_Include\Installer.nsh"

!insertmacro MUI_LANGUAGE "English"

Var InputVer
Var VER
Function nsDialogsPage
	nsDialogs::Create 1018
	Pop $0
	${NSD_CreateLabel} 0 0 100% 12u "Enter Version Number:"
	Pop $0
	${NSD_CreateText} 0 13u 100% 12u ""
	Pop $InputVer
	nsDialogs::Show
FunctionEnd
Function nsDialogsPageLeave
	${NSD_GetText} $InputVer $R0
StrCmp $R0 "" 0 +3
	MessageBox MB_ICONEXCLAMATION `You must enter a version number!`
Abort
	StrCpy $VER "$R0"
FunctionEnd

Section "${APPNAME} Portable" main
SectionIn RO
Call CheckConnected
	inetc::get "${RELEASURL}/${APP}Setup$VER.exe" "$TEMP\${APP}PortableTemp\${APP}Setup$VER.exe" /END
	Pop $0
StrCmp $0 "OK" +3
	MessageBox MB_USERICON "Download of ${APP}Setup$VER.exe: $0"
	Abort
	SetOutPath "$INSTDIR"
		File "..\..\..\${FOLDER}\${APP}Portable.exe"

	File "/oname=$TEMP\${APP}PortableTemp\7z.dll" "..\_Include\7-Zip\7z.dll"
	File "/oname=$TEMP\${APP}PortableTemp\7z.exe" "..\_Include\7-Zip\7z.exe"
	nsExec::Exec `"$TEMP\${APP}PortableTemp\7z.exe" x "$TEMP\${APP}PortableTemp\${APP}Setup$VER.exe" -aoa -o"$INSTDIR\App\${APP}" *.exe *.chm`

	; Delete "$TEMP\${APP}PortableTemp\${APP}$VER\LicenseAgreement.txt"
	; Delete "$TEMP\${APP}PortableTemp\${APP}$VER\Portable.db"
	; SetOutPath "$INSTDIR\App\${APP}"
	; CopyFiles /SILENT "$TEMP\${APP}PortableTemp\${APP}$VER\*.*" "$INSTDIR\App\${APP}"

!ifdef DESCRIPTION
Call AppInfo
!endif
!ifdef SOURCES
Call Sources
	SetOutPath "$INSTDIR\Other\_Include\7-Zip"
	File "..\_Include\7-Zip\7z.exe"
	File "..\_Include\7-Zip\7z.dll"
	SetOutPath "$INSTDIR\Other\Source"
	File "Portable.db"
	File "fsc.db"
!endif
!ifdef SOURCES & DESCRIPTION
Call SourceInfo
!endif

cancelled:
SectionEnd

Function .onGUIEnd
	RMDir "/r" "$TEMP\${APP}PortableTemp"
FunctionEnd
