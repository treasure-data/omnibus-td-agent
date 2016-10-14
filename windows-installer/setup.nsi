;--------------------------------
; Stackdriver Logging Agent Installer.
;
; Installs and starts the Stackdriver logging agent.
;--------------------------------


;--------------------------------
; GLOBAL VARIABLES
;--------------------------------

; Company or Publisher name.
!define COMPANY "Stackdriver"

; Software name used for display to users.
!define DISPLAY_NAME "${COMPANY} Logging Agent"

; Software name with no white space.
!define COMPRESSED_NAME "${COMPANY}LoggingAgent"

; Registry entry key to store arbitrary information.
!define REG_KEY "Software\${COMPANY}\LoggingAgent"

; Uninstaller registry key, used to register the agent.
!define STACKDRIVER_UNINST_REG_KEY "${UNINST_REG_KEY}\${COMPRESSED_NAME}"

; Absolute location of the uninstaller.
!define UNINSTALLER_LOCATION "$INSTDIR\uninstall.exe"

; Directory to install all files into.  This makes uninstall easier and safer.
!define MAIN_INSTDIR "$INSTDIR\Main"

; The name of fluentd config template file, this is bundled into the script.
!define FLUENTD_CONFIG_TEMPLATE "fluent-template.conf"

; Absolute location of the fluentd config file.
!define FLUENTD_CONFIG_LOCATION "$INSTDIR\fluent.conf"

; Name of the main zip file, this is bundled into the script.
!define ZIP_FILE "${COMPRESSED_NAME}.zip"


;--------------------------------
; GENERAL CONFIGURATION
;--------------------------------

; Needed to properly display all languages, may not work on older windows OSs.
Unicode true

; Name used for display throughout the installer.
Name "${DISPLAY_NAME}"

; Output location/name of the installer executable.
OutFile "${COMPRESSED_NAME}_unsigned.exe"

; Require admin level logs access, this is required as we need to read event logs.
RequestExecutionLevel admin


;--------------------------------
; INCLUDES
;--------------------------------

; General includes.
!include "FileFunc.nsh" ; Needed for GetSize
!include "StrFunc.nsh" ; Needed for StrTrimNewLines
!include "WordFunc.nsh" ; Needed for WordFind

; Stackdriver includes.
!include "stackdriver_language_util.nsh"
!include "stackdriver_ui.nsh"
!include "stackdriver_util.nsh"


;--------------------------------
; FUNCTIONS
;--------------------------------

; Define StrTrimNewLines function to use below.
${StrTrimNewLines}


;--------------------------------
; GENERAL UI SET UP
;--------------------------------

; Configures auto save for the users selected language. See stackdriver_language_util.nsh.
!insertmacro STACKDRIVER_SAVE_USER_LANGUAGE "${REG_KEY}"

; Configures the UI and pages for the installer. See stackdriver_ui.nsh.
!insertmacro STACKDRIVER_UI "true"

; Adds all supported languages. See stackdriver_language_util.nsh.
!insertmacro STACKDRIVER_INCLUDE_ALL_LANGUAGES


;--------------------------------
; INSTALLER FUNCTIONS
;--------------------------------

; Function called as soon as the installer is initialized, before the GUI.
Function .onInit
  ; Set the install directory, we cannot do this at compile time as we are
  ; using a runtime variable.
  ReadEnvStr $0 SYSTEMDRIVE
  StrCpy $INSTDIR "$0\${COMPRESSED_NAME}"

  ; Display the language selection dialog.
  !insertmacro MUI_LANGDLL_DISPLAY

  ; Check for a previously installed version.  If one exists
  ; prompt the user to remove it before continuing.
  ReadRegStr $0 SHCTX "${STACKDRIVER_UNINST_REG_KEY}" "UninstallString"
  ${If} $0 != ""
    ${RemoveOldVersion} "${DISPLAY_NAME}" $0
  ${EndIf}

  ; Temporary directory used during install and automatically cleaned up after.
  InitPluginsDir
FunctionEnd

; Verify the install directory is correct.  There is a bug in a gem
; that this install relies on: if the file path has a space in it, it
; will fail to install.  For now we disable the UI to change the path
; but also need to disable it here in case of silent installs.
Function .onVerifyInstDir
  ; Check that the install direcotry has not changed.  If it has, notify
  ; the user and abort.
  ReadEnvStr $0 SYSTEMDRIVE
  ${If} $INSTDIR != "$0\${COMPRESSED_NAME}"
    MessageBox MB_OK "Invalid install directory '$INSTDIR', must be '$0\${COMPRESSED_NAME}'"
    Abort
  ${EndIf}
FunctionEnd


;--------------------------------
; INSTALLER SECTIONS
;--------------------------------

Section "Install"
  ; Print messages to the details list view not the text (status) bar,
  ; this provides a cleaner install when files are being unzipped.
  SetDetailsPrint listonly

  ; Set output path for files to the install directory.
  SetOutPath $INSTDIR

  ; Add extra space to the size to account for the compressed file.
  ; Size is in KB. 100,000KB = 100MB
  AddSize 100000

  ; Include the icon file in the installer directory, this is used in
  ; the add/remove programs menu.
  File "${UI_ICON}"

  ; Include the custom fluentd config to capture windows event logs.
  File "${FLUENTD_CONFIG_TEMPLATE}"

  ; Include the main zip file.
  File "${ZIP_FILE}"

  ; Create an uninstaller and show status.
  ${Print} "Generating an uninstaller..."
  WriteUninstaller "${UNINSTALLER_LOCATION}"

  ; Extract the needed files and show status
  ${Print} "Extracting files to $INSTDIR..."
  nsisunz::Unzip "$OUTDIR\${ZIP_FILE}" "${MAIN_INSTDIR}"
  Pop $0

  ; Ensure the file unzipped if not notify the user and abort.
  ${If} $0 != "success"
    ${IfNot} ${Silent}
      MessageBox MB_OK "Failed to unzip: $0"
    ${EndIf}
    Abort
  ${EndIf}

  ; Delete the zip file after extraction.
  Delete "$OUTDIR\${ZIP_FILE}"

  ; Create a directory to store position files.
  CreateDirectory ${MAIN_INSTDIR}\pos

  ; Copy and update the fluentd config and show status, we cannot use most of
  ; the needed plugins that would do this in a better way as they do not work
  ; well with unicode on and fail (mostly silenely).
  ; NOTE: This is very dependent on the config.  It should have a
  ; place holder 'POS_FILE_PLACE_HOLDER' that will be replaced with a
  ; position file location in the current install directory.
  ${Print} "Updating configuration files..."

  ; ----- Begin update fluent config -----

  ; Be sure to clear any errors before file operations.
  ClearErrors

  ; Open the tempate config to read and create a new config file to write to.
  FileOpen $0 "$OUTDIR\${FLUENTD_CONFIG_TEMPLATE}" "r"
  FileOpen $1 "${FLUENTD_CONFIG_LOCATION}" "w"

  ; Write each file from the template config to the new config,
  ; updating each line as needed.
  loop:
    ; Read the next line, if we hit an error we are at the end of the file.
    FileRead $0 $2
    IfErrors done

    ; Trim out newlines as WordFind cannot handle them.
    ${StrTrimNewLines} $3 "$2"
    ; Count the number of 'POS_FILE_PLACE_HOLDER' instances.  It should only
    ; ever be 0 or 1.  We only have it in the template file once.
    ${WordFind} "$3" "POS_FILE_PLACE_HOLDER" "#" $4

    ; If we hit the place holder line replace it with the proper pos_file.
    ${If} $4 == "1"
      StrCpy $2 "  pos_file '${MAIN_INSTDIR}\pos\winevtlog.pos'$\r$\n"
    ${EndIf}

    ; Write the line to the config file.
    FileWrite $1 $2
    Goto loop

  ; We finished be sure to close the file handles.
  done:
    FileClose $0
    FileClose $1

  ; Delete the template config.
  Delete "$OUTDIR\${FLUENTD_CONFIG_TEMPLATE}"

  ; ----- End update fluent config -----

  ; Get the size of the install directory.  This is used to give a proper estimate
  ; in the add/remove programs menu.
  ; "/S=0K" Gets the size in KB
  ; $0 = size, $1 = number of files, $2 = number of directories.
  ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2

  ; Register the software so it will appear in the add/remove programs menu.
  ${Print} "Registering ${DISPLAY_NAME}..."
  ${RegisterUninstallSoftware} \
      "${DISPLAY_NAME}" "${UNINSTALLER_LOCATION}" "${UI_ICON}" "${COMPANY}" "$0"

  ; Update the paths in ruby files.
  ${ExecuteCommand} "${MAIN_INSTDIR}\bin\ruby.exe" "'${MAIN_INSTDIR}\bin\gem' \
    pristine --all --only-executables"

  ; Start the fluentd service and show status.
  ;   '--reg-winsvc i'          -> Install as a windows service
  ;   '--reg-winsvc-auto-start' -> Enables the service to auto start at boot
  ;   '--reg-winsvc-fluentdopt' -> Passes along the config file
  ${Print} "Starting the ${DISPLAY_NAME}..."
  ${ExecuteCommand} "${MAIN_INSTDIR}\bin\fluentd.bat" \
      "--reg-winsvc i --reg-winsvc-auto-start \
      --reg-winsvc-fluentdopt $\"-c $\'${FLUENTD_CONFIG_LOCATION}$\'$\""

  ; All done!
  ${Print} "Installation Complete"
SectionEnd


;--------------------------------
; UNINSTALLER FUNCTIONS
;--------------------------------

; Function called as soon as the uninstaller is initialized, before the GUI.
Function un.onInit
  ; Display the language selection dialog.
  !insertmacro MUI_UNGETLANGUAGE
FunctionEnd


;--------------------------------
; UNINSTALLER SECTIONS
;--------------------------------

Section "Uninstall"
  ; Print messages to the details list view not the text (status) bar,
  ; this provides a cleaner install when files are being removed.
  SetDetailsPrint listonly

  ; Stop the fluentd service and show status.
  ;   '--reg-winsvc u'          -> Uninstall
  ${UnPrint} "Stopping the ${DISPLAY_NAME}..."
  ${UnExecuteCommand} "${MAIN_INSTDIR}\bin\fluentd.bat" "--reg-winsvc u"

  ; Remove the software from the registry.
  ${UnPrint} "Unregistering the ${DISPLAY_NAME}..."
  ${RemoveRegisterUninstallSoftware} "${DISPLAY_NAME}"

  ; Clean up any other registry entires used.
  DeleteRegKey HKCU "${REG_KEY}"

  ${UnPrint} "Cleaning up files in $INSTDIR..."

  ; Delete all files in the main install directory.
  RMDir /r /REBOOTOK "${MAIN_INSTDIR}"

  ; Clean up all files not in the main directory.
  Delete /REBOOTOK "${UNINSTALLER_LOCATION}"
  Delete /REBOOTOK "${FLUENTD_CONFIG_LOCATION}"
  Delete /REBOOTOK "$INSTDIR\${UI_ICON}"

  ; Remove the install directory if it is empty.
  RMDir /REBOOTOK "$INSTDIR"

  ; All done!
  ${UnPrint} "Uninstallation Complete"
SectionEnd
