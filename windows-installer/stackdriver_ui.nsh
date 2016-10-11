;--------------------------------
; Shared UI, pages and configuration for Stackdriver installers.
;
; forceInstallDir: If true the installer will force the users
;     to install into the default install location.
;--------------------------------


!macro STACKDRIVER_UI forceInstallDir
;--------------------------------
; GLOBAL VARIABLES
;--------------------------------

!define UI_ICON "stackdriver_logo.ico"
!define UI_HEADER_IMAGE "stackdriver_header.bmp"
!define UI_WELCOME_IMAGE "stackdriver_welcome.bmp"
!define UI_LICENSE_FILE "stackdriver_license.txt"

;--------------------------------
; GENERAL CONFIGURATION 
;--------------------------------

; Don't show any branding text, branding is handled with MUI
; variables below.
BrandingText " "


;--------------------------------
; INCLUDES
;--------------------------------

; Used for the modern UI.
!include "MUI2.nsh"

; Used to disable the install path option.
!include "WinMessages.nsh"


;--------------------------------
; INSTALLER SETTINGS
;--------------------------------

; Set the default icon for the installer.
!define MUI_ICON "${UI_ICON}"

; Welcome page image
!define MUI_WELCOMEFINISHPAGE_BITMAP "${UI_WELCOME_IMAGE}"

; Show a header image for all pages that have headers.
; NOTE: This also sets the header image for the uninstaller.
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "${UI_HEADER_IMAGE}"
; Don't stretch the image as we have an exact fit.
!define MUI_HEADERIMAGE_BITMAP_NOSTRETCH
; Make the header text transparent and rely on the header.
!define MUI_HEADER_TRANSPARENT_TEXT

; Don't automatically advance to the final page after an install,
; this will allow users to look at the install details if they wish.
!define MUI_FINISHPAGE_NOAUTOCLOSE


;--------------------------------
; UNINSTALLER SETTINGS
;--------------------------------

; Set the default icon for the uninstaller.
!define MUI_UNICON "${UI_ICON}"

; Welcome page image.
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "${UI_WELCOME_IMAGE}"

; Don't automatically advance to the final page after an uninstall,
; this will allow users to look at the uninstall details if they wish.
!define MUI_UNFINISHPAGE_NOAUTOCLOSE


;--------------------------------
; INSTALLER PAGES
;--------------------------------

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "${UI_LICENSE_FILE}"
!define MUI_PAGE_CUSTOMFUNCTION_SHOW DisableInstallPathSelection
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH


;--------------------------------
; UNINSTALLER PAGES
;--------------------------------

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH


;--------------------------------
; INSTALLER FUNCTIONS
;--------------------------------

; Disables selection of the install location if 'forceInstallDir' is 'true'.
Function DisableInstallPathSelection
  ${If} ${forceInstallDir} == "true"
    ; Get the page directory window.
    FindWindow $0 "#32770" "" $HWNDPARENT
    
    ; Get the installer text box.
    GetDlgItem $1 $0 1019
    ; Set the installer text box to read only.
    SendMessage $1 ${EM_SETREADONLY} 1 0
    
    ; Get the installer browse button.
    GetDlgItem $1 $0 1001
    ; Disable the installer browse button.
    EnableWindow $1 0
  ${EndIf}
FunctionEnd

!macroend