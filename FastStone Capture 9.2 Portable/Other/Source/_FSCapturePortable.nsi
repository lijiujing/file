; NSIS with Registry.nsh in Include and Registry.dll, FindProcDLL.dll, KillProcDLL.dll and SimpleSC.dll in Plugins

; **************************************************************************
; === Define constants ===
; **************************************************************************
!define VER "0.0.0.0"
!define APPNAME "FastStone Capture"
!define APP "FSCapture"
!define APPDIR "App\FSCapture"
!define APPEXE "FSCapture.exe"
!define APPSWITCH ""

	; !define REGKEY1 "HKEY_LOCAL_MACHINE\SOFTWARE\8322898"

; **************************************************************************
; === Best Compression ===
; **************************************************************************
SetCompressor /SOLID lzma
SetCompressorDictSize 32

; **************************************************************************
; === Includes ===
; **************************************************************************
!include "..\_Include\Launcher.nsh" 

; **************************************************************************
; === Set basic information ===
; **************************************************************************
Name "${APPNAME} Portable"
OutFile "..\..\..\${APP}Portable\${APP}Portable.exe"
Icon "${APP}.ico"

; **************************************************************************
; === Other Actions ===
; **************************************************************************
Function Init
File "/oname=$EXEDIR\${APPDIR}\Portable.db" Portable.db
IfFileExists "$EXEDIR\Data\${APP}\fsc.db" +3
CreateDirectory "$EXEDIR\Data\${APP}"
File "/oname=$EXEDIR\Data\${APP}\fsc.db" fsc.db
Rename "$EXEDIR\Data\${APP}\fsc.db" "$EXEDIR\${APPDIR}\fsc.db"
Rename "$EXEDIR\Data\${APP}\TBSettings.db" "$EXEDIR\${APPDIR}\TBSettings.db"
Rename "$EXEDIR\Data\${APP}\fsrec.db" "$EXEDIR\${APPDIR}\fsrec.db"
FunctionEnd

Function Close
Delete "$EXEDIR\${APPDIR}\Portable.db"
CreateDirectory "$EXEDIR\Data\${APP}"
Rename "$EXEDIR\${APPDIR}\fsc.db" "$EXEDIR\Data\${APP}\fsc.db"
Delete "$EXEDIR\Data\${APP}\fsc.bak"
Rename "$EXEDIR\${APPDIR}\fsc.bak" "$EXEDIR\Data\${APP}\fsc.bak"
Rename "$EXEDIR\${APPDIR}\TBSettings.db" "$EXEDIR\Data\${APP}\TBSettings.db"
Rename "$EXEDIR\${APPDIR}\fsrec.db" "$EXEDIR\Data\${APP}\fsrec.db"
FunctionEnd

; **************************************************************************
; ==== Running ====
; **************************************************************************

Section "Main"

	Call CheckStart

	Call Init

		Call SplashLogo
		Call Launch

	Call Restore

SectionEnd

Function Restore

	Call Close

FunctionEnd

;*************************************************************
;*=== Lancement ===*
;*************************************************************
Function Launch
SetOutPath "$EXEDIR\${APPDIR}"
${GetParameters} $0
ExecWait `"$EXEDIR\${APPDIR}\${APPEXE}"${APPSWITCH} $0`
WriteINIStr "$EXEDIR\Data\${APP}Portable.ini" "${APP}Portable" "GoodExit" "true"
newadvsplash::stop
FunctionEnd
