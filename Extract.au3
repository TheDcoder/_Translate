#include <AutoItConstants.au3>
#include <Debug.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>

Global Const $ECI = @ScriptDir & '\eci\build\eci.exe'

Main()

Func Main()
	Global $sScript = FileOpenDialog("Select Script", @WorkingDir, 'AutoIt Script (*.au3)', $FD_FILEMUSTEXIST)
	If @error Then Return
	Local $aStrings = ExtractStrings($sScript)
	If $aStrings[0] = 1 And $aStrings[1] = "" Then
		MsgBox($MB_ICONWARNING, "No translatable strings", "There were no translatable strings found in your script, please make sure you use the underscore function to wrap your translatable strings!")
		Return
	EndIf
	Global $sTableFile = FileSaveDialog("Save translation table", @WorkingDir, 'Tab Separated Values (*.tsv)|All (*.*)', 0, 'translations.tsv')
;i moved local sTablefile up because we must know what file we are updating.
	Local $sTable = GenerateTranslationTable($aStrings)
	If @error Then Return
	   ;removed $fo_overwrite because maybe we want to update the translation table with new strings.
	Local $hTableFile = FileOpen($sTableFile, $FO_UTF8_NOBOM+$FO_APPEND)
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
   local $ss
   if fileexists($stablefile) then
      $ss=fileread($stablefile) ;this is made to update a translation file with not existing translated strings that were added to the translated program later
endif
	Local $sTable
	For $i = 1 To $aStrings[0]
	   ;checking if a translation table have this string, as well as checking if a line is space or stringlen=0
		If StringIsSpace($aStrings[$i]) Or StringLen($aStrings[$i]) = 0 or stringinstr($ss,$aStrings[$i]) Then ContinueLoop
		$sTable &= $aStrings[$i] & @TAB & $aStrings[$i] & @LF
	 Next
	Return $sTable
EndFunc
