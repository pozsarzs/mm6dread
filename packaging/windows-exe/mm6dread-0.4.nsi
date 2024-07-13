; Script generated by the HM NIS Edit Script Wizard.

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "MM6DRead"
!define PRODUCT_VERSION "0.4"
!define PRODUCT_PUBLISHER "Pozsár Zsolt"
!define PRODUCT_WEB_SITE "http://www.pozsarzs.hu"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\mm6dread.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

; MUI 1.67 compatible ------
!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

; Language Selection Dialog Settings
!define MUI_LANGDLL_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_LANGDLL_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_LANGDLL_REGISTRY_VALUENAME "NSIS:Language"

; Uninstaller pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "$(MUILicense)" 
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!define MUI_FINISHPAGE_RUN "$INSTDIR\mm6dread.exe"
!define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\documents\README"
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

; Language files
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "Hungarian"

; License Language
LicenseLangString MUILicense ${LANG_ENGLISH} "mm6dread\LICENCE"
LicenseLangString MUILicense ${LANG_HUNGARIAN} "mm6dread\LICENCE"

; MUI end ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "mm6dread-${PRODUCT_VERSION}-win32.exe"
InstallDir "$PROGRAMFILES\MM6DRead"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show

Function .onInit
  !insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd

Section "Main files" SEC01
  SetOutPath "$INSTDIR\documents"
  SetOverwrite try
  File "mm6dread\documents\authors"
  File "mm6dread\documents\install"
  File "mm6dread\documents\readme"
  File "mm6dread\documents\version"
  SetOutPath "$INSTDIR"
  File "mm6dread\mm6dread.exe"
  File "mm6dread\licence"
  File "mm6dread\readme.md"
  CreateShortCut "$DESKTOP\MM6DRead.lnk" "$INSTDIR\mm6dread.exe"
  CreateDirectory "$SMPROGRAMS\MM6DRead"
  CreateShortCut "$SMPROGRAMS\MM6DRead\MM6DRead.lnk" "$INSTDIR\mm6dread.exe"
SectionEnd

Section "Translate HU" SEC02
  SetOutPath "$INSTDIR\languages\hu"
  File "mm6dread\languages\hu\mm6dread.mo"
  File "mm6dread\languages\hu\mm6dread.po"
  SetOutPath "$INSTDIR\languages"
  File "mm6dread\languages\mm6dread.pot"
SectionEnd

Section -AdditionalIcons
  SetOutPath $INSTDIR
  CreateDirectory "$SMPROGRAMS\MM6DRead"
  CreateShortCut "$SMPROGRAMS\MM6DRead\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\mm6dread.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\mm6dread.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

; Section descriptions
  LangString DESC_Section1 ${LANG_ENGLISH} "Required files"
  LangString DESC_Section2 ${LANG_ENGLISH} "Hungarian translate"
  LangString DESC_Section1 ${LANG_HUNGARIAN} "K�telez� �llom�nyok"
  LangString DESC_Section2 ${LANG_HUNGARIAN} "Magyar ford�t�s"
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC01} $(DESC_Section1)
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC02} $(DESC_Section2)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

; Section uninstall
  Function un.onInit
  !insertmacro MUI_UNGETLANGUAGE
  FunctionEnd

Section Uninstall
  Delete "$INSTDIR\uninst.exe"
  Delete "$INSTDIR\readme.md"
  Delete "$INSTDIR\licence"
  Delete "$INSTDIR\mm6dread.exe"
  Delete "$INSTDIR\languages\mm6dread.pot"
  Delete "$INSTDIR\languages\hu\mm6dread.po"
  Delete "$INSTDIR\languages\hu\mm6dread.mo"
  Delete "$INSTDIR\documents\authors"
  Delete "$INSTDIR\documents\install"
  Delete "$INSTDIR\documents\readme"
  Delete "$INSTDIR\documents\version"

  Delete "$SMPROGRAMS\MM6DRead\Uninstall.lnk"
  Delete "$DESKTOP\MM6DRead.lnk"
  Delete "$SMPROGRAMS\MM6DRead\MM6DRead.lnk"

  RMDir "$SMPROGRAMS\MM6DRead"
  RMDir "$INSTDIR\languages\hu"
  RMDir "$INSTDIR\languages"
  RMDir "$INSTDIR\documents"
  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd
