#include <MsgBoxConstants.au3>
#include <StringConstants.au3>

$iniName = StringLeft(@ScriptName,StringLen(@ScriptName)-3) & "ini"

;Create INI-File
;  $bQuestWithNum = true
;  $sQuestDelim = "."
;  $bReplyWithNum = true
;  $sReplyDelim = ")"
;IniWrite(@ScriptDir & "\" & $iniName,"MAIN","QuestWithNum",$bQuestWithNum)
;IniWrite(@ScriptDir & "\" & $iniName,"MAIN","QuestDelim",$sQuestDelim)
;IniWrite(@ScriptDir & "\" & $iniName,"MAIN","ReplyWithNum",$bReplyWithNum)
;IniWrite(@ScriptDir & "\" & $iniName,"MAIN","ReplyDelim",$sReplyDelim)

MsgBox($MB_SYSTEMMODAL, "Автозаповнювач 1.1", "Підготуйте тести згідно наступних вимог:" & @CR _
             & " - текстовий файл" & @CR _
             & " - одне питання чи один варіант на рядок" & @CR _
             & " - питання розділені порожньою стрічкою" & @CR _
             & " - вірний варіант позначається * (зірочкою) в кінці стрічки" & @CR & @CR _
             & "Виділіть весь підготований текст і скопіюйте його в Буфер обміну." & @CR _
             & "Закрийте це повідомлення і перейдіть в Формування питань для вступних тестів з розпочатим новим тестом.")

$sData = ClipGet()
$aArray = StringSplit($sData, @CRLF, $STR_ENTIRESPLIT)

If $aArray[0]<6 Then
  MsgBox($MB_SYSTEMMODAL, "Упс", "Я знайшов лише меньше 6 рядочків (" & $aArray[0] & "). Це навіть не одне питання :(" & @CR _
               & "Спробуйте наступного разу.")
  Exit
EndIf

if FileExists(@ScriptDir & "\" & $iniName) Then
  $bQuestWithNum = IniRead(@ScriptDir & "\" & $iniName,"MAIN","QuestWithNum",true)
  $sQuestDelim = IniRead(@ScriptDir & "\" & $iniName,"MAIN","QuestDelim",".")
  $bReplyWithNum = IniRead(@ScriptDir & "\" & $iniName,"MAIN","ReplyWithNum",true)
  $sReplyDelim = IniRead(@ScriptDir & "\" & $iniName,"MAIN","ReplyDelim",")")
Else
  $bQuestWithNum = true
  $sQuestDelim = "."
  $bReplyWithNum = true
  $sReplyDelim = ")"
EndIf

$hWnd = WinWaitActive("Формування питань для вступних тестів", "",60)

for $i=1 to $aArray[0] Step 7
   ;MsgBox($MB_SYSTEMMODAL, "", "Rows: " & $i)
   if $bQuestWithNum Then
     $sRes = StringStripWS(StringTrimLeft($aArray[$i],StringInStr($aArray[$i],$sQuestDelim)),$STR_STRIPLEADING+$STR_STRIPTRAILING+$STR_STRIPSPACES)
   Else
     $sRes = StringStripWS($aArray[$i],$STR_STRIPLEADING+$STR_STRIPTRAILING+$STR_STRIPSPACES)
   EndIf   
   ControlSetText($hWnd, "", "[NAME:richTextBoxQuestion]", $sRes)
   for $q=1 to 5
	  if $bReplyWithNum then
		 $sRes = StringStripWS(StringTrimLeft($aArray[$i+$q],StringInStr($aArray[$i+$q],$sReplyDelim)),$STR_STRIPLEADING+$STR_STRIPTRAILING+$STR_STRIPSPACES)
	  Else
		 $sRes = StringStripWS($aArray[$i+$q],$STR_STRIPLEADING+$STR_STRIPTRAILING+$STR_STRIPSPACES)
	  EndIf
	  if StringRight($sRes,1)="*" Then
		 $sRes = StringTrimRight($sRes,1)
		 ControlClick($hWnd, "", "[NAME:radioButton" & $q & "]")
	  EndIf
	  ControlSetText($hWnd, "", "[NAME:richTextBoxVariant" & $q & "]", $sRes)
   next
   if StringIsSpace($aArray[$i+6]) Then ControlClick($hWnd, "", "[NAME:buttonAddQuestion]")
Next
ControlClick($hWnd, "", "[NAME:buttonSaveQuestion]")
