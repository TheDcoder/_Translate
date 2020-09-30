#include <AutoItConstants.au3>
#include <Debug.au3>
#include <FileConstants.au3>

Global Const $ECI = @ScriptDir & '\eci\build\eci.exe'

Main()

Func Main()
	Local $sScript = FileOpenDialog("Select Script", @WorkingDir, 'AutoIt Script (*.au3)', $FD_FILEMUSTEXIST)
	If @error Then Return
	Local $aStrings = ExtractStrings($sScript)

	Local $sTable = GenerateTranslationTable($aStrings)
	Local $sTableFile = FileSaveDialog("Save translation table", @WorkingDir, 'Tab Separated Values (*.tsv)|All (*.*)', 0, 'translations.tsv')
	If @error Then Return
	Local $hTableFile = FileOpen($sTableFile, $FO_OVERWRITE + $FO_UTF8_NOBOM)
	FileWrite($hTableFile, $sTable)
	FileClose($hTableFile)
EndFunc

Func ExtractStrings($sFile)
	Local $sCmd = StringFormat('"%s" "%s"', $ECI, $sFile)
	Local $iPID = Run($sCmd, @WorkingDir, @SW_HIDE, $STDOUT_CHILD)
	Local $sOutput
	Do
		$sOutput &= StdoutRead($iPID)
	Until @error
	Return StringSplit($sOutput, @CRLF)
EndFunc

Func GenerateTranslationTable(ByRef $aStrings)
	Local $sTable
	For $i = 1 To $aStrings[0]
		If StringIsSpace($aStrings[$i]) Or StringLen($aStrings[$i]) = 0 Then ContinueLoop
		$sTable &= $aStrings[$i] & @TAB & $aStrings[$i] & @LF
	Next
	Return $sTable
EndFunc
