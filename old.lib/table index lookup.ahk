FileEncoding,UTF-8-RAW
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%\..\TblConv\  ; Ensures a consistent starting directory.
FileRead,WeaponsBin,*C %a_scriptdir%\weapons.bin
TableCodesArrayByNumber := []
TableCodesArray := []
TableCodesArrayByNumber["English","Counts","String"] := 0
TableCodesArrayByNumber["English","Counts","Expansionstring"] := 0
TableCodesArrayByNumber["English","Counts","Patchstring"] := 0

FileRead,temp,%A_ScriptDir%\..\TblConv\string.txt
Loop,parse,temp,`n,`r
{
	TheString := StrSplit(a_loopfield,a_tab)
	TableCodesArrayByNumber["English","String",a_index] := TheString[1]
	;~ TableCodesArrayByNumber["English","Counts","String"] += 1
	TableCodesArray["English",TheString[1]] := TheString[2]
		;~ if TheString[2] = Holy Shock
		;~ msgbox % a_index
}
;~ TableCodesArrayByNumber["English","Counts","String"] -= 1

FileRead,temp,%A_ScriptDir%\..\TblConv\expansionstring.txt
Loop,parse,temp,`n,`r
{
	if a_loopfield=""
		continue
	TheString := StrSplit(a_loopfield,a_tab)
	TableCodesArrayByNumber["English","String",a_index+20000] := TheString[1]
	;~ TableCodesArrayByNumber["English","Counts","Expansionstring"] += 1
	TableCodesArray["English",TheString[1]] := TheString[2]
}
;~ TableCodesArrayByNumber["English","Counts","expansionstring"] -= 1

FileRead,temp,%A_ScriptDir%\..\TblConv\patchstring.txt
Loop,parse,temp,`n,`r
{
	if a_loopfield=""
		continue

	TheString := StrSplit(a_loopfield,a_tab)
	TableCodesArrayByNumber["English","String",a_index+10000] := TheString[1]
	;~ TableCodesArrayByNumber["English","Counts","patchstring"] += 1
	TableCodesArray["English",TheString[1]] := TheString[2]
	;~ if TheString[2] = Holy Shock
		;~ msgbox % a_index+10000
}
;~ TableCodesArrayByNumber["English","Counts","patchstring"] -= 1
;~ msgbox %  st_printarr(TableCodesArrayByNumber)
;~ FileAppend,%test%,test.txt
;~ fileread,expansionstring,
;~ RegExMatch,WeaponsBin,








;~ if the tbl index is < the max lines in String.txt ->
	;~ use that number in String.txt.

;~ if "10000" is <= the tbl index in Patchstring.txt ->
	;~ AND the id minus "10000" is < Patchstring.txt ->
		;~ use that number in Patchstring.txt

;~ if "20000" is <= the tbl index in Expansionstring.txt ->
	;~ AND the id minus "20000" is < Expansionstring.txt ->
		;~ use that number in Expansionstring.txt
		
		InputBox,checknumber
		checknumber += 1
		msgbox % TableCodesArrayByNumber["English","string",checknumber] "`n`n`n" TableCodesArray["English",TableCodesArrayByNumber["English","string",checknumber]]
		
	;~ if ( id < m_iStringCount )
    ;~ {
        ;~ pcResult = m_astString[id].vString;
    ;~ }
		;~ If checknumber < TableCodesArrayByNumber["English","Counts","string"]
			;~ if TableCodesArrayByNumber["English","string",checknumber]!=""
			;~ {
				;~ msgbox % "String`n" TableCodesArrayByNumber["English","string",checknumber]
				;~ Clipboard := TableCodesArrayByNumber["English","string",checknumber]
			;~ }
    ;~ if ( 10000 <= id && (id - 10000) < m_iPatchStringCount )
    ;~ {
        ;~ pcResult = m_astPatchString[id - 10000].vString;
    ;~ }
	
		;~ If (10000 <= checknumber) && (checknumber - 10000) < TableCodesArrayByNumber["English","Counts","patchstring"]
			;~ if TableCodesArrayByNumber["English","patchstring",checknumber]!=""
			;~ {
				;~ msgbox % "Patch`n" TableCodesArrayByNumber["English","patchstring",checknumber-10000]
				;~ Clipboard := TableCodesArrayByNumber["English","patchstring",checknumber]
			;~ }

    ;~ if ( 20000 <= id && (id - 20000) < m_iExpansionsStringCount )
    ;~ {
        ;~ pcResult = m_astExpansionsString[id - 20000].vString;
    ;~ }
		;~ If (20000 <= checknumber) && (checknumber - 20000) < TableCodesArrayByNumber["English","Counts","expansionstring"]
			;~ if TableCodesArrayByNumber["English","expansionstring",checknumber]!=""
			;~ {
				;~ msgbox % "Exp`n" TableCodesArrayByNumber["English","expansionstring",checknumber-20000]
				;~ Clipboard := TableCodesArrayByNumber["English","expansionstring",checknumber]
			;~ }
		
		;~ Clipboard := 
		;~ msgbox % st_printArr(TableCodesArrayByNumber)
		test := st_printArr(TableCodesArrayByNumber)
		FileDelete,test.txt
		FileAppend,%test%,test.txt
		
		
ExitApp
st_printArr(array, depth=5, indentLevel="")
{
   for k,v in Array
   {
      list.= indentLevel "[" k "]"
      if (IsObject(v) && depth>1)
         list.="`n" st_printArr(v, depth-1, indentLevel . "    ")
      Else
         list.=" => " v
      list.="`n"
   }
   return rtrim(list)
}