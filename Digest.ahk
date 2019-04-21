FileEncoding UTF-8-RAW 
#Include DigestFunctions.ahk
#Include DigestTxtModules.ahk
;~ #Include DigestBinModules.ahk
#Include %a_scriptdir%\lib\include.ahk
#include %a_scriptdir%\lib\BuildJson.ahk
#Include %a_scriptdir%\Lib\SQLiteDB.ahk
#Include %a_scriptdir%\Lib\DBA.ahk
Process,close,SQLiteStudio.exe
Process, WaitClose, SQLiteStudio.exe
FileDelete, Digest.db*
FileDelete, % a_scriptdir "\sql\*.TXT"
connectionString := A_ScriptDir "\Digest.db"
DigestDB := DBA.DataBaseFactory.OpenDataBase("SQLite", connectionString)
DigestDB.Query("PRAGMA journal_mode=WAL;")
DigestDB.Query("PRAGMA synchronous = 0;")
;DB := new SQLiteDB
;DBFileName := A_ScriptDir . "\digest.DB"
;testQ := DigestDB.Query("PRAGMA table_info('Decompile | armor';") ;") ; TO GET TABLES
;testQ := DB.Query("PRAGMA table_info('Decompile | armor';") ;") ; TO GET TABLES


;testQ := DigestDB.Query(testR) 

;~ DigestDB.Query("PRAGMA page_size = 65536;")
;testQ := st_printarr(testq)
;clipboard := testQ
;msgbox % testQ
;exitapp
;

;~ DigestDB.Query("PRAGMA journal_mode=OFF;")

;D2 mpq load order:
;~ d2data.mpq
;~ d2char.mpq
;~ d2sfx.mpq
;~ d2speech.mpq
;~ d2music.mpq
;~ d2video.mpq
;~ d2delta.mpq
;~ d2kfixup.mpq
;~ d2exp.mpq
;~ d2xvideo.mpq
;~ d2xtalk.mpq
;~ d2xmusic.mpq
;~ patch_d2.mpq
;~ ModPatch_d2.mpq
;~ D2SE_1.mpq
;~ D2SE_2.mpq
;~ D2SE_3.mpq
;~ direct_txt.mpq
;~ various stuff
OnExit, ExitRoutine

#MaxMem,4095 
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetBatchLines, -1
;~ ListLines, Off

SetWorkingDir, %A_ScriptDir%\..  ; Ensures a consistent starting directory.
DiabloIIDir = %a_WorkingDir%
d2_old_patches=d2data,d2char,d2sfx,d2speech,d2music,d2video,d2delta,d2kfixup,d2exp,d2xvideo,d2xtalk,d2xmusic
ModNameStripChars=\/:?*"<>|
Gui, XML: New, +MinSizex250
Gui, Add, Picture,w250 h60 center,DigestPicture
Gui, Add, Text, w250 BackgroundTrans center vText1,Stage -1
Gui, Add, Text, w250 BackgroundTrans center vText2,Compiling (listfile) from each MPQ...
Gui, Add, Text, w250 h50 BackgroundTrans center vText3,Please wait...
Gui, Show,autosize center,Digest Processor 
goto,Stage0

;Build the MPQ listfile
FileRead,MasterListFile, %a_scriptdir%\ListFiles\MasterListFile.txt
;FileDelete,%a_scriptdir%\ListFiles\listfile.mpq
Loop,Files,%DiabloIIDir%\*.mpq,R
{
	MPQ_Chain := []
	MPQ_Chain.push(A_LoopFileLongPath)
	MPQ_Extract(MPQ_Chain,"(listfile)",a_scriptdir "\Working\",0)
	GuiControl, ,  Text3,%A_LoopFileDir%\%A_LoopFileName%
	
	FileRead,listtemp, %A_ScriptDir%\Working\(listfile)
	MasterListFile .= listtemp
	FileDelete,%A_ScriptDir%\Working\(listfile)
	IfExist,%A_ScriptDir%\listfiles\zzzzz%A_NowUTC%.txt
		Sleep,1000
	FileMove,%A_ScriptDir%\Working\(listfile),%A_ScriptDir%\listfiles\zzzzz%A_NowUTC%.txt
}
GuiControl, , Text2,Compiling all listfiles into a master list...
GuiControl, , Text3,
Loop,Files,%a_scriptdir%\ListFiles\*.txt
{
	FileRead,listtemp,%a_loopfilelongpath%
	MasterListFile .= "`r`n" listtemp
}
listtemp=
GuiControl, , Text2,Appending raw file names to compiled list...
Loop,Files,%DiabloIIDir%\MODS\*,D
{
	ModFolder := A_LoopFileLongPath
	;~ ModBase := A_LoopFileName
	GuiControl, , Text3,Scanning: %A_LoopFileName%
	
	Loop,Files,%ModFolder%\*,R
	{
		StringReplace,RelName,a_loopfilelongpath,%ModFolder%`\
		MasterListFile .= relname "`r`n"
	}
}
GuiControl, , Text2,Finalizing compiled list...
GuiControl, , Text3,
Sort,MasterListFile,U D`n



-
FileDelete,%A_ScriptDir%\masterlisttemp.txt
FileAppend,%MasterListFile%,%A_ScriptDir%\masterlisttemp.txt
FileMove,%A_ScriptDir%\masterlisttemp.txt,%a_scriptdir%\ListFiles\MasterListFile.txt,1
MasterListFile=

Stage0:
;~ GoToMod=1.10f
;~ GoToMod=The Forces of Darkness
GoToMod=Reign of Shadow
;GoToMod=Pagan Heart
;GoToMod=Aftermath
;GoToMod=Hell Unleashed - Oblivion
;GoToMod=Eastern Sun Rises
;~ GoToMod=Median XL
;GoToMod=Le Royaume des Ombres (beta)
;GoToMod=Zy-El [4.5]
;GoToMod=Snej
;GoToMod=Battle for Elements
;~ GoToMod=Blackened
;GoToMod=The Puppeteer
;GoToMod=Dark Alliance
;Build the MPQ list

Loop,Files,%DiabloIIDir%\MODS\*,D
{
	StringCaseSense,on
	
	If (a_loopfilename != gotomod) ;AND (gotomod != "")
		continue
	Digest := {}
	
	MPQ_Chain := []
	MPQ_New := []
	MPQ_Old := []
	FileGetAttrib, DirSearch, %A_LoopFileLongPath%
	IfInString,DirSearch,D
	MOD_DIR := a_loopfilename
	else
		continue
	IfNotExist,%DiabloIIDir%\MODS\%MOD_DIR%\D2SE_SETUP.ini
		continue
	
	
	RIni_Read(1,DiabloIIDir "\MODS\"  MOD_DIR "\D2SE_SETUP.ini")
	If RIni_KeyExists(1, "Protected", "D2Core")
		D2Core := RIni_GetKeyValue(1, "Protected", "D2Core")
	If RIni_KeyExists(1, "Protected", "ModName")
		ModName := RIni_GetKeyValue(1, "Protected", "ModName")
	If RIni_KeyExists(1, "Protected", "ModTitle")
		ModTitle := RIni_GetKeyValue(1, "Protected", "ModTitle")
	If RIni_KeyExists(1, "Protected", "ModMajorVersion")
		ModMajorVersion := RIni_GetKeyValue(1, "Protected", "ModMajorVersion")
	If RIni_KeyExists(1, "Protected", "ModMinorVersion")
		ModMinorVersion := RIni_GetKeyValue(1, "Protected", "ModMinorVersion")
	If RIni_KeyExists(1, "Protected", "ModRevision")
		ModRevision := RIni_GetKeyValue(1, "Protected", "ModRevision")
	If RIni_KeyExists(1, "Protected", "ModBanner")
		ModBanner := RIni_GetKeyValue(1, "Protected", "ModBanner")
	IfExist,%DiabloIIDir%\MODS\%MOD_DIR%\D2Mod.ini
	RIni_Read(2,DiabloIIDir "\MODS\"  MOD_DIR "\D2Mod.ini")
	StringReplace,D2CoreStripped,D2Core,`.,,all
	
	
	
	StringCaseSense,off
	
	Loop,parse,d2_old_patches,`,
	{
		IfExist,%DiabloIIDir%\%A_LoopField%.mpq
		{
			MPQ_Chain.push(DiabloIIDir "\" A_LoopField ".mpq")
			MPQ_Old.push(DiabloIIDir "\" A_LoopField ".mpq")
		}
	}
	;~ ;Load vanilla patch_d2
	
	
	
	
	If (ModName!=ModTitle) AND (ModTitle!="")
		ModFullName := EndingWhiteSpaceTrim(ModName) a_space "(" EndingWhiteSpaceTrim(EndingWhiteSpaceTrim(ModTitle) ")" a_space "[" EndingWhiteSpaceTrim(ModMajorVersion)   EndingWhiteSpaceTrim(ModMinorVersion)   EndingWhiteSpaceTrim(ModRevision)) "]"
	Else 
		ModFullName := EndingWhiteSpaceTrim(ModName)  a_space "[" EndingWhiteSpaceTrim(EndingWhiteSpaceTrim(ModMajorVersion)   EndingWhiteSpaceTrim(ModMinorVersion)   EndingWhiteSpaceTrim(ModRevision)) "]"
	Loop,parse,ModNameStripChars
		StringReplace,ModFullName,ModFullName,%a_loopfield%,,all
	GuiControl, ,DigestPicture,%DiabloIIDir%\MODS\%MOD_DIR%\%modbanner%
	GuiControl, , Text1,%ModFullName%
	GuiControl, , Text2,Stage 0
	GuiControl, , Text3,Building MPQ chains...
	Loop,10
		StringReplace,ModFullName,ModFullName,%a_space%%a_space%,%a_space%,All
	StringReplace,ModFullName,ModFullName,%a_space%.,.,All
	StringReplace,ModFullName,ModFullName,.%a_space%,.,All
	StringReplace,ModFullName,ModFullName,%a_space%-,-,All
	StringReplace,ModFullName,ModFullName,-%a_space%,-,All
	ModFullName := trim(ModFullName,a_space)
	
	
	;Conditional check to skip processing bins from this mod
	
	
	IfExist,%DiabloIIDir%\D2SE\CORES\%D2Core%\patch_d2.mpq
	{
		MPQ_Chain.push(DiabloIIDir "\D2SE\CORES\" D2Core "\patch_d2.mpq")
		MPQ_Old.push(DiabloIIDir "\D2SE\CORES\" D2Core "\patch_d2.mpq")
	}
	
	
	;Load Mod Patch_D2
	IniRead,ModUsePatch_D2,C:\Users\Qriist\Desktop\Diablo II\MODS\%MOD_DIR%\D2SE_SETUP.ini,Protected,ModUsePatch_D2
	If (ModUsePatch_D2 = 1) AND (FileExist(DiabloIIDir "\MODS\"  MOD_DIR "\patch_d2.mpq") != "")
	{
		MPQ_Chain.push(DiabloIIDir "\MODS\" MOD_DIR "\patch_d2.mpq")
		MPQ_New.push(DiabloIIDir "\MODS\" MOD_DIR "\patch_d2.mpq")
	}
	else if (ModUsePatch_D2 = 1) AND (FileExist(DiabloIIDir "\MODS\"  MOD_DIR "\patch_d2.mpq") = "")
		
	
	
	
	;Begin loading additional mpqs; 
	;TODO - condense the following
	{
		
		IniRead,ModMPQ1,C:\Users\Qriist\Desktop\Diablo II\MODS\%MOD_DIR%\D2SE_SETUP.ini,Protected,ModMPQ1
		IfExist,C:\Users\Qriist\Desktop\Diablo II\MODS\%MOD_DIR%\%ModMPQ1%
		{
			MPQ_Chain.push(DiabloIIDir "\MODS\" MOD_DIR "\" ModMPQ1)
			MPQ_New.push(DiabloIIDir "\MODS\" MOD_DIR "\" ModMPQ1)
		}
		
		IniRead,ModMPQ2,C:\Users\Qriist\Desktop\Diablo II\MODS\%MOD_DIR%\D2SE_SETUP.ini,Protected,ModMPQ2
		IfExist,C:\Users\Qriist\Desktop\Diablo II\MODS\%MOD_DIR%\%ModMPQ2%
		{
			MPQ_Chain.push(DiabloIIDir "\MODS\" MOD_DIR "\" ModMPQ2)
			MPQ_New.push(DiabloIIDir "\MODS\" MOD_DIR "\" ModMPQ2)
		}
		
		IniRead,ModMPQ3,C:\Users\Qriist\Desktop\Diablo II\MODS\%MOD_DIR%\D2SE_SETUP.ini,Protected,ModMPQ3
		IfExist,C:\Users\Qriist\Desktop\Diablo II\MODS\%MOD_DIR%\%ModMPQ3%
		{
			MPQ_Chain.push(DiabloIIDir "\MODS\" MOD_DIR "\" ModMPQ3)
			MPQ_New.push(DiabloIIDir "\MODS\" MOD_DIR "\" ModMPQ3)
		}
	}
	
	;Load D2Mod mpqs.
	IniRead,ModUseD2Mod,C:\Users\Qriist\Desktop\Diablo II\MODS\%MOD_DIR%\D2SE_SETUP.ini,Protected,ModUseD2Mod
	If (ModUseD2Mod = 1)
	{	
		If FileExist(DiabloIIDir "\MODS\"  MOD_DIR "\D2Mod.mpq")
		{
			MPQ_Chain.push(DiabloIIDir "\MODS\" MOD_DIR "\D2Mod.mpq")
			MPQ_New.push(DiabloIIDir "\MODS\" MOD_DIR "\D2Mod.mpq")
		}
		
		If FileExist(DiabloIIDir "\MODS\"  MOD_DIR "\D2ModPatch.mpq")
		{
			MPQ_Chain.push(DiabloIIDir "\MODS\" MOD_DIR "\D2ModPatch.mpq")
			MPQ_New.push(DiabloIIDir "\MODS\" MOD_DIR "\D2ModPatch.mpq")
		}
	}
	
	;Create temporary direct_txt.mpq for insertion into the mpq chain
	FileDelete,%a_scriptdir%\Working\direct_txt.mpq
	if FileExist(DiabloIIDir "\MODS\" MOD_DIR "\Data\" )
	{
		RunWait,%A_ScriptDir%\mpqeditor.exe new "%a_scriptdir%\Working\direct_txt.mpq" %direct_txt_count%
		RunWait,%A_ScriptDir%\mpqeditor.exe add "%a_scriptdir%\Working\direct_txt.mpq" "%DiabloIIDir%\MODS\%MOD_DIR%\Data\" "Data\" /auto /r
		MPQ_Chain.push( A_ScriptDir "\Working\direct_txt.mpq" )
		MPQ_New.push( A_ScriptDir "\Working\direct_txt.mpq" )
	}
	
	;Debug loop to ensure the mpq chain is in the correct order. This is LOAD order, and is served to MPQ_Extract like this.
	;~ Loop % mpq_chain.length()
		;~ msgbox % MPQ_Chain[a_index]
		;~ MsgBox % st_printarr(MPQ_Chain)
		;~ MsgBox % st_printarr(MPQ_New)
	;And in reverse. This is PRIORITY order. Not generally needed.
	;~ Loop % mpq_chain.length()
		;~ msgbox % MPQ_Chain[mpq_chain.length()+1-a_index]
	GuiControl, , Text1,%ModFullName%
	GuiControl, , Text2,Stage 1
	GuiControl, , Text3,Extracting Tbls...
	TblListArray := []
	If (GoToMod = "Dark Alliance")
		Loop,3
			TblListArray.push("DarkAlliance" a_index ".tbl")
	TblListArray.push("string")
	TblListArray.push("patchstring")
	TblListArray.push("expansionstring")
	;Check for enabled D2Mod and enabled Nefex
	;TODO - check Nefex system structure - WHAT MODS USE THIS?
	;~ IfExist,%DiabloIIDir%\MODS\D2Mod.ini
		;~ RIni_Read(2,DiabloIIDir "\MODS\"  MOD_DIR "\D2Mod.ini")
	If  (RIni_GetKeyValue(1, "Protected", "ModUseD2Mod")=1) AND FileExist((DiabloIIDir "\MODS\"  MOD_DIR "\D2Mod.ini"))
	{
		CustomTbl := RIni_GetSectionKeys(2, "CustomTbl")
		Loop,parse,CustomTbl,`,
		{
			If RIni_GetKeyValue(2, "CustomTbl",a_loopfield)
			{
				TblToAdd := RIni_GetKeyValue(2, "CustomTbl",a_loopfield)
				SplitPath,tbltoadd,,,,TblBase
				TblListArray.push(TblBase)
			}
		}
	}
	
	;msgbox % st_printArr(TblListArray)
	;For now, only doing ENG. My sanity depends on it.
	;Need to gather list of languages to decompile
	;To do this:
	;A) extract *.tbl from mod MPQs only. (MPQ_new)
	;B) fill in any missing tbls from that language's full-chain locale
	;C) search later vanilla patch_d2's for missing tbls and cross your fingers that it works.
	;D) on the offchance that no suitable file is available, default to ENG*
	
	;*
	;*ENG crossreferencing is currently not implemented in order to actually do other stuff.
	
	
	;clean up any old data caused from early termination
	FileRemoveDir,%a_scriptdir%\tblConv\data\,1
	
	;A) Extract tables
	;EXTRACT
	MPQ_Extract(MPQ_new, "*\local\lng\*.tbl" ,a_scriptdir "\TblConv\",1,A_ScriptDir "\ListFiles\MasterListFile.txt",0) ; TESTING
	;~ MPQ_Extract(MPQ_new, "*\local\lng\ENG\*.tbl" ,a_scriptdir "\TblConv\",0,A_ScriptDir "\ListFiles\MasterListFile.txt",0)
	;~ Pause
	;~ RunWait,%a_scriptdir%\MPQEditor.exe extract "%a_loopfield%" *.tbl "%a_scriptdir%\TblConv" /fp,,hide
		;~ Pause
	
	;B) Determine present tbls, extract anything missing from full-chain
	;Process tables into the array IN THIS ORDER: 
	;		Check for D2mod.ini then load:
	;		string -> expansionstring -> patchstring -> 
	;		D2modIni_1 -> D2modIni_2 -> etc     // This should probably be a function using Rini to get potentially variable numbers of tbls.
	;		
	
	
	;TODO - implement adding tbls from the mod system inis.
	;D2 MOD complete
	;Nefex incomplete
	;Dark Alliance incomplete
	;~ msgbox % st_printarr(TblListArray)
	
	ModLngArray := []
	
	;Extract the tbls 
	IfNotExist,%a_scriptdir%\Working\%ModFullName%\TXT\tblscomplete
	{
		
		Loop,%a_scriptdir%\TblConv\data\Local\lng\*,1
		{
			;Loops through the languages, using the foldername as the current language
			Mod_LNG := StringUpper(a_LoopFileName)
			if mod_lng != eng
				continue
			GuiControl, , Text3,Converting tbls for language: %Mod_LNG%...
			ModLngArray.push(Mod_LNG)
			FileCreateDir,%a_scriptdir%\Working\%ModFullName%\%Mod_LNG%
			FileDelete,%a_scriptdir%\TblConv\*.tbl
			Loop,% TblListArray.length()
			{
				;Copy from current language, if possible
				If FileExist(a_scriptdir "\TblConv\data\local\lng\" mod_lng "\" TblListArray[a_index] ".tbl")
				{
					FileCopy, % a_scriptdir "\TblConv\data\local\lng\" mod_lng "\" TblListArray[a_index] ".tbl", % a_scriptdir "\TblConv\"
				}
				
				;If it still doesn't exist, extract from the full chain for this language
				else If !FileExist(a_scriptdir "\TblConv\" TblListArray[a_index] ".tbl")
				{
					MPQ_Extract(MPQ_chain,"*\local\lng\" Mod_LNG "\" TblListArray[a_index] ".tbl",a_scriptdir "\TblConv\",0,A_ScriptDir "\ListFiles\MasterListFile.txt",0)
				}				
				
				;If it still doesn't exist, copy from English
				else If !FileExist(a_scriptdir "\TblConv\" TblListArray[a_index] ".tbl")
				{
					FileCopy, % a_scriptdir "\TblConv\data\local\lng\ENG\" TblListArray[a_index] ".tbl", % a_scriptdir "\TblConv\"
				}
				
				;If it still doesn't exist, extract from the full chain for English
				else If !FileExist(a_scriptdir "\TblConv\" TblListArray[a_index] ".tbl")
				{
					MPQ_Extract(MPQ_chain,"*\local\lng\ENG\" TblListArray[a_index] ".tbl",a_scriptdir "\TblConv\",0,A_ScriptDir "\ListFiles\MasterListFile.txt",0)
				}
				
				;If it still doesn't exist, you broke it.
			}
			
			;~ msgbox % TblListArray.length()
			
			;~ ;Check for missing tables and conditionally extract the English versions 
			;~ ;Later, as each code is checked during txt generation:
				;~ ; A) Check that languange's code
				;~ ; B) If absent, check the English array
				;~ ; C) If not found in either location simply print the code.
			RunWait,%A_ScriptDir%\TblConv\ToTxt.exe
			FileCopy,%A_ScriptDir%\TblConv\*.txt,%A_ScriptDir%\Template\,1
			;~ ExitApp
			Tbloffset=0
			
			Loop, % TblListArray.length()
			{
				StringReplace,temp,% TblListArray[a_index],%a_space%,,All
				If FileExist(a_scriptdir "\TblConv\" temp ".txt")
				{
					CurrentTxt := FileOpen(A_ScriptDir "\TblConv\" temp ".txt","r").read()
					Loop,Parse,CurrentTxt,`n,`r
					{
						singlecode := StrSplit(A_LoopField,a_tab,a_space)
						if (Tbloffset = 10000) ;and (Tbloffset <= 20000)
						{
							;~ If (Digest[ModFullName,"String",Mod_LNG,"By Code",singlecode[1]] = "")
							Digest[ModFullName,"String",Mod_LNG,"By Code",singlecode[1]] := singlecode[2]
								;~ Digest[ModFullName,"String",Mod_LNG,"Code to Number",a_index-1+Tbloffset] := singlecode[1]
								;~ Digest[ModFullName,"String",Mod_LNG,"Number to Code",singlecode[1]] := a_index-1+Tbloffset
						}
						else
							If (Digest[ModFullName,"String",Mod_LNG,"By Code",singlecode[1]] = "")
							{
								Digest[ModFullName,"String",Mod_LNG,"By Code",singlecode[1]] := singlecode[2]
								;~ Digest[ModFullName,"String",Mod_LNG,"Code to Number",a_index-goto1+Tbloffset] := singlecode[1]
							}
						;~ Digest[ModFullName,"String",Mod_LNG,"Number to Code",singlecode[1]] := a_index-1+Tbloffset
						Digest[ModFullName,"String",Mod_LNG,"By Number",a_index-1+Tbloffset "C"] := singlecode[1]
						Digest[ModFullName,"String",Mod_LNG,"By Number",a_index-1+Tbloffset "R"] := singlecode[2]
					}
				}
				Tbloffset+=10000
			}
			;~ msgbox % Digest[ModFullName,"String",Mod_LNG,"By Code","r13"]
			;~ ExitApp
			;~ FileDelete,test.txt
			;~ FileAppend,% st_printarr(Digest[ModFullName,"String",Mod_LNG,"By Number"]),test.txt
			;~ FileAppend,% st_printarr(Digest),test.txt
			;~ run,test.txt
			;~ ExitApp
			;~ Loop,Parse,% TableCodesArray["*RAW",Mod_LNG],`n,`r
			;~ {
				;~ singlecode := StrSplit(A_LoopField,a_tab)
				;~ If TableCodesArray[Mod_LNG,singlecode[1]] = singlecode[2]
					;~ TempAppend .= singlecode[1] a_tab singlecode[2] "`r`n"
			;~ }
			
			
			;~ FileMove,%a_scriptdir%\TblConv\*.txt,%a_scriptdir%\template\,1
			;~ tempAppend := TableCodesArray["*RAW",Mod_LNG]
			
			;~ FileAppend,%tempappend%,%a_scriptdir%\template\string.txt
			;~ RunWait,%a_scriptdir%\bin2txt-h.exe -file sets,%a_scriptdir%\
			;~ RunWait,%a_scriptdir%\bin2txt.exe -file sets,%a_scriptdir%\
			;~ FileMove,%a_scriptdir%\txt\*.txt,%a_scriptdir%\Working\%ModFullName%\TXT\,1
			;~ FileDelete,%a_scriptdir%\template\*string.txt
			;~ FileDelete,%a_scriptdir%\Working\%ModFullName%\TXT\DigestString_%Mod_LNG%.txt
			;~ FileAppend,%tempappend%,%a_scriptdir%\Working\%ModFullName%\TXT\DigestString_%Mod_LNG%.txt
			;~ tempAppend :=
			;~ if mod_lng=eng
				;~ msgbox, check tbl
		}
		;~ FileAppend,,%a_scriptdir%\Working\%ModFullName%\TXT\tblscomplete
	}
	;~ else
	;~ {
		;~ ;TODO - rewrite this to accomodate previous json method.
		;~ Loop,%a_scriptdir%\Working\%ModFullName%\TXT\DigestString_*.txt
		;~ {
			;~ Mod_LNG := StrSplit(a_LoopFileName, "_")
			;~ Mod_LNG := StrSplit(Mod_LNG[2], ".")
	
			;~ Mod_LNG := StringUpper(Mod_LNG[1])
			;~ ModLngArray.push(Mod_LNG)
			;~ if mod_lng != eng
				;~ continue
			;~ GuiControl, , Text3,Reading previously converted tbls for language: %Mod_LNG%...
			;~ CurrentTxt := FileOpen(A_LoopFileLongPath,"r").read()
			;~ Loop,Parse,CurrentTxt,`n,`r
				;~ {
					;~ singlecode := StrSplit(A_LoopField,a_tab)
					;~ TableCodesArray[Mod_LNG,singlecode[1]] := singlecode[2]
				;~ }
		;~ }
	;~ }
	
		;~ msgbox % st_printarr(tbllistarray)
	
	
	;FileDelete, %a_scriptdir%\bin\*
	;FileDelete, %a_scriptdir%\txt\*
	GuiControl, , Text1,%ModFullName%
	GuiControl, , Text2,Stage 2
	GuiControl, , Text3,Extracting Bins...
		;~ MPQ_Extract(MPQ_list,FileMaskToExtractFromMPQ,PathToExtractToDisk,UseFullPathing:=1)
	IfNotExist,%a_scriptdir%\Working\%ModFullName%\TXT\binscomplete
	{
			;EXTRACT
		MPQ_Extract(MPQ_chain,"*Global\excel*.bin",A_ScriptDir "\bin\",0,A_ScriptDir "\ListFiles\MasterListFile.txt")
		GuiControl, , Text3,Decompiling Bins...
		
		
		BinOrder := []
		loop,%A_scriptdir%\bin\*.bin
		{
			SplitPath,a_loopfilename,,,,BinBase
			BinOrder.push(BinBase)
		}
			;~ module=cubemain
			;~ Digest_Bin_110f_cubemain(a_scriptdir "\bin\cubemain.bin")
			;~ array_gui(Digest)
			;~ ExitApp
		FileDelete,%A_ScriptDir%\_*lib_*.txt
		FileEncoding,CP0
			;FileDelete,%a_scriptdir%\Digest.db*
			;DigestDB := New SQLiteDB
			;DigestDB.OpenDB(A_ScriptDir "\Digest.db")
		
		
			;~ msgbox here
							;~ FileDelete,%a_scriptdir%\%ModFullName%.json
		;msgbox % st_printArr(binorder)
		StartTime := A_TickCount
		Loop, % BinOrder.length()
		{
			Module := Binorder[a_index]
				;~ msgbox % Binorder[a_index]
			ModuleNum := a_index
			;StartgTime := A_TickCount
			;msgbox % module
			;If module in montype ;,_LevelsExtension
				;continue
			DecodeFunction := Digest_Function_Selector("Bin",Module,D2CoreStripped,a_scriptdir "\bin\" module ".bin")
			if (DecodeFunction = "fail")
			{
				FileDelete,a_scriptdir "\bin\" module ".bin"
				;continue
			}
			
			;if ((A_TickCount - StartgTime) > 0)
				;FileAppend,% ModFullName " : " module  " : Time Complete = " A_Now " : Duration = " (A_TickCount - StartgTime) / 1000 "`n",%a_scriptdir%\_timestamps.txt
			
				;The following function is for quick testing of data output ONLY.
				;Will need to build output txt modules for each bin
				;~ FileDelete,%A_ScriptDir%\_*lib_%module%*.txt
				;~ if isfunc("Digest_Bin_110f_" Module)
				;~ {
					;~ pause
					;~ ObjCSV_Collection2CSV(Digest[ModFullName,"Decompile",Module], A_ScriptDir "\_lib_" module ".txt", 1,SheetHeaders(Module),0,0,a_tab)
					;~ ObjCSV_Collection2CSV(Digest[ModFullName,"Decompile",Module], A_ScriptDir "\_nhlib_" module ".txt", 1,,0,0,a_tab)
				;~ }
				;~ pause
				;~ If strlen(testlib) > 2
					;~ msgbox,check
					;~ FileAppend,% testlib,% A_ScriptDir "\lib_" module ".txt"
					;~ MsgBox % st_printarr(Digest[ModFullName,"Decompile"])
			;InsertQuick("DigestDB","Decompile | " module,IQF(),"flush")
		}
		;msgbox % st_printarr(Digest[ModFullName,"Decompile",Module])
		;DummyFlush := {}
		;InsertQuick("DigestDB","",IQF(),"flush")
		;FileDelete,%a_scriptdir%\%ModFullName%.json
		;InsertQuick("DigestDB","","","flush")
		
		
			;~ Loop, % BinOrder.length()
			;~ {
				;~ Module := Binorder[a_index]
				;~ Digest_Txt_110f_%module%()
			;~ }
		/*
			Required pre-Recompile functions follow
		*/
		
		Determine_ISC_groups()
		
		
		/*
			End of pre-Recompile functions
		*/
		InsertQuick("DigestDB","",IQF(),"flush")
		
		;FileDelete,%a_scriptdir%\%ModFullName%.json
		;FileAppend,% JSON.dump(digest),%a_scriptdir%\%ModFullName%.json
		
		FileAppend,% ModFullName " : Time Complete = " A_Now " : Duration = " (A_TickCount - StartTime) / 1000 "`n",%a_scriptdir%\_timestamps.txt
		;If (a_loopfilename = gotomod) ;AND (gotomod != "")
			;ExitApp
		;Run, %a_scriptdir%\_temp_Digest_JSON_110f_runes.ahk
		exitapp
	}
}
		
		/*
		;ExitApp
		
		module=runes
		mod_lng=ENG
			;~ Digest_JSON_110f_runes()
			;~ st_printarr(digest[ModFullName,Decompile])
		
			;~ Digest_SQL_Flatten(Digest)
			;~ ExitApp
			;~ FileDelete,%A_ScriptDir%\%ModFullName%.json
			;~ JDump := st_printarr(Digest)
			;~ JDump := BuildJson(Digest)
			;~ JDump := JSON.dump(digest)
			;~ msgbox % strlen(JDump)
		
			;~ FileAppend,% JSON.dump(digest),%a_scriptdir%\%ModFullName%.json
			;~ ObjDump(A_ScriptDir "\" ModFullName ".json",Digest)
			;~ FileAppend, % st_printarr(digest),%a_scriptdir%\test.json
			;~ array_gui(Digest[ModFullName,"String"])
				;~ array_gui(Digest[ModFullName,"Recompile",Module])
				;~ ExitApp
			;~ msgbox % st_printarr(Digest[ModFullName,"Recompile",Module])
			;~ eol := st_printarr(Digest[ModFullName,"Recompile",Module])
			;~ Clipboard := st_printarr(Digest[ModFullName,"Keys"])
			;~ digest=
			;~ VarSetCapacity,Digest,0
			;~ Run,%a_scriptdir%\bin2txt-h.exe,%a_scriptdir%,, ;hide
			;~ run,%A_ScriptDir%\_temp_Digest_JSON_110f_runes.ahk,%A_ScriptDir%
			;~ runwait,%A_ScriptDir%\_temp_Digest_SQL_Flatten.ahk,%A_ScriptDir%
			;~ FileDelete,%a_scriptdir%\Digest.db
			;~ Digest_SQL_Flatten(Digest)
		;ExitApp
		FileCreateDir,%a_scriptdir%\Working\%ModFullName%\TXT\
		RunWait,%A_ScriptDir%\template\template.exe,%A_ScriptDir%\template,hide
		
		
		
		If ErrorLevel != 0
		{
			Gui,Font,cRED
			GuiControl, , Text3,Deep analysis required, this will take a LONG time and output may not be accurate...
			Loop,Files,%a_scriptdir%\bin\*.bin
				bincount := %a_index%
			Loop,Files,%a_scriptdir%\bin\*.bin
			{
				GuiControl, , cRED Text3,Deep analysis required`, this will take a LONG time... (%a_index%/%bincount%)
				SplitPath,a_loopfilelongpath,BinName,BinDir,BinExt,BinBase,BinDrive
				RunWait,%a_scriptdir%\bin2txt-h.exe -file "%BinBase%",%A_ScriptDir%,hide
				If (FileSize(a_scriptdir "\txt\" BinBase ".txt")!=0) AND if (ErrorLevel=0)
				{
					FileMove,%a_scriptdir%\txt\%BinBase%.txt,%a_scriptdir%\txt\Qriist_%BinBase%.txt
				}
			}
			Loop,Files,%a_scriptdir%\txt\Qriist_*.txt
			{
				SplitPath,a_loopfilelongpath,TxtName,TxtDir,TxtExt,TxtBase,TxtDrive
				StringReplace,TxtBase,TxtBase,Qriist_
				FileMove,a_loopfilelongpath,%TxtDir%\%TxtBase%.txt
			}
		}
			;~ FileMove,%a_scriptdir%\txt\*.txt,%a_scriptdir%\Working\%ModFullName%\TXT,1
		FileAppend,binscomplete,%a_scriptdir%\Working\%ModFullName%\TXT\binscomplete
	}
	
	Gui,Font,
	
	continue
	
	;ExitApp
	
	
	
	
	D2Core=1.10f
	StringReplace,D2CoreStripped,D2Core,`.,,all
	;~ msgbox % D2CoreStripped
	
	;Begin populating txt files...
	GuiControl, , Text2,Stage 3
	Loop, % ModLngArray.length()
	{
		MOD_LNG := ModLngArray[a_index]
		if Mod_Lng!=eng
			continue
		GuiControl, , Text3,Gathering info for language: %Mod_LNG%... `nAlso extracting gfx as needed...`nParsing Armor, Weapons, Misc...
		JsonArray := []
		
		;Need to gather basic info about the items in the mod.
		Digest_Json_%D2CoreStripped%_weapons(A_ScriptDir "\Working\" Modfullname "\TXT\weapons.txt",JsonArray,TableCodesArray,A_ScriptDir "\Working\" Modfullname "\" Mod_LNG "\weapons.txt")
		Digest_Json_%D2CoreStripped%_armor(A_ScriptDir "\Working\" Modfullname "\TXT\armor.txt",JsonArray,TableCodesArray,A_ScriptDir "\Working\" Modfullname "\" Mod_LNG "\armor.txt")
		Digest_Json_%D2CoreStripped%_misc(A_ScriptDir "\Working\" Modfullname "\TXT\misc.txt",JsonArray,TableCodesArray,A_ScriptDir "\Working\" Modfullname "\" Mod_LNG "\misc.txt")
		Digest_Json_%D2CoreStripped%_gems(A_ScriptDir "\Working\" Modfullname "\TXT\gems.txt",JsonArray,TableCodesArray,A_ScriptDir "\Working\" Modfullname "\" Mod_LNG "\gems.txt")
		
		
		
		;;;Modules that just copy the text over
		;~ Digest_Txt_110f_arena()
		;~ Digest_Txt_110f_armtype()
		;~ Digest_Txt_110f_automap()
		;~ Digest_Txt_110f_belts
		;~ Digest_Txt_110f_bodylocs
		Digest_Txt_%D2CoreStripped%_experience(A_ScriptDir "\Working\" Modfullname "\TXT\experience.txt",JsonArray,TableCodesArray,A_ScriptDir "\Working\" Modfullname "\" Mod_LNG "\Experience.txt")
		
		
		
		
		
		;;;Modules with actual text transformations
		
		Digest_Txt_%D2CoreStripped%_runes(A_ScriptDir "\Working\" Modfullname "\TXT\runes.txt",JsonArray,TableCodesArray,A_ScriptDir "\Working\" Modfullname "\" Mod_LNG "\runes.txt")
		Digest_Txt_%D2CoreStripped%_uniqueitems(A_ScriptDir "\Working\" Modfullname "\TXT\uniqueitems.txt",JsonArray,TableCodesArray,A_ScriptDir "\Working\" Modfullname "\" Mod_LNG "\uniqueitems.txt")
		;~ Digest_Txt_110f_automagic
		
		
		
		
		;;;Modules that REQUIRE the given language's strings.
		Digest_Txt_110f_sets()
		
		
		
		
		
		;;;Not yet working
		;~ Digest_Txt_%D2CoreStripped%_itemtypes(A_ScriptDir "\Working\" Modfullname "\TXT\itemtypes.txt",MOD_LNG,TableCodesArray,A_ScriptDir "\Working\" Modfullname "\" Mod_LNG "\itemtypes.txt") ;not working yet
	}
	;~ Digest_Txt110f_itemtypes()
	
	;~ FileAppend,%arraycheck%,arraycheck.txt
	;ExitApp
	;~ Loop,Parse,
	msgbox % st_printarr(TableCodesArray["*RAW"])
	{
	}
	
	
	
	
	;~ msgbox % st_printarr(MPQ_new)
	;Check only the patchfiles for tbls -> this determines the languages that are present.
	;~ msgbox % st_printarr(ModLngArray)
	;~ Loop % ModLngArray.length()
	;~ {
		;~ MPQ_Extract(MPQ_new,"*\local\lng\*" ModLngArray[a_index] "\*.tbl",a_scriptdir "\TblConv\",1,A_ScriptDir "\ListFiles\MasterListFile.txt",0)
	;~ }
	
	
		;~ ExitApp
	
	Loop,Parse,tbllist,`,
	{
		break
			;~ MsgBox % a_loopfield
		IfNotExist,%a_scriptdir%\TblConv\data\Local\lng\%Mod_LNG%\%A_LoopField%.tbl
		{
			MPQ_Extract(mpq_chain,"*" StringUpper(Mod_LNG) "\" A_LoopField ".tbl",A_ScriptDir "\TblConv\",1,A_ScriptDir "\ListFiles\MasterListFile.txt")
			
				;C) fallback on later vanilla updates
			IfNotExist,%a_scriptdir%\TblConv\data\Local\lng\%Mod_LNG%\%A_LoopField%.tbl
			{
				Loop,%DiabloIIDir%\D2SE\CORES\*.mpq,,1
				{
					MPQ_Extract(a_loopfilelongpath,"*" StringUpper(Mod_LNG) "\" A_LoopField ".tbl",A_ScriptDir "\TblConv\data\Local\lng\" Mod_LNG "\",0,A_ScriptDir "\ListFiles\MasterListFile.txt")
					IfExist,,%a_scriptdir%\TblConv\data\Local\lng\%Mod_LNG%\%A_LoopField%.tbl
					break
				}
			}
				;D) fallback on ENG tables
			IfNotExist,%a_scriptdir%\TblConv\data\Local\lng\%Mod_LNG%\%A_LoopField%.tbl
				MPQ_Extract(PriorityMPQLast,"*ENG\" A_LoopField ".tbl",A_ScriptDir "\TblConv\data\Local\lng\" Mod_LNG "\",0,A_ScriptDir "\ListFiles\MasterListFile.txt")
		}
		
		
	}
	FileDelete,%a_scriptdir%\TblConv\*.txt
	FileMove,%a_scriptdir%\TblConv\data\Local\lng\%Mod_LNG%\*.tbl, %A_ScriptDir%\TblConv\,1
		;Do a final check of any extracted tbl files from the mod folder itself (for the current language only)
	FileCopy,%DiabloIIDir%\MODS\%Mod_dir%\Data\local\LNG\%mod_lng%\*.tbl,%a_scriptdir%\TblConv\,1
	
	RunWait,%a_scriptdir%\TblConv\ToTxt.exe,%a_scriptdir%\TblConv\,hide
	FileDelete,%a_scriptdir%\TblConv\*.tbl
	FileMove,%a_scriptdir%\TblConv\patchstring.txt,%a_scriptdir%\Working\%ModFullName%\%Mod_LNG%\,1
	FileMove,%a_scriptdir%\TblConv\expansionstring.txt,%a_scriptdir%\Working\%ModFullName%\%Mod_LNG%\,1
	FileMove,%a_scriptdir%\TblConv\String.txt,%a_scriptdir%\Working\%ModFullName%\%Mod_LNG%\,1
	
	
	FileRemoveDir,%a_scriptdir%\TblConv\data,1
	
	
	
	
	bindir := StringUpper( a_scriptdir "\bin\" )
	;~ MPQ_Extract(PriorityMPQLast,"*global\excel\*.bin","" bindir "",0,A_ScriptDir "\ListFiles\MasterListFile.txt")
	FileCopy,%DiabloIIDir%\Mods\%ModFullName%\Data\global\excel\*.bin,%a_scriptdir%\bin\,1
	
	StringTrimRight,MOD_LNG_LIST,MOD_LNG_LIST,1
	StringSplit,MOD_LNG_NUMBER,MOD_LNG_LIST,|
	MsgBox % MOD_LNG_LIST
	GuiControl, , Text1,%ModFullName%
	GuiControl, , Text2,Stage 3
	GuiControl, , Text3,Decompiling bins...	
	
	FileDelete,%a_scriptdir%\template\patchstring.txt
	FileDelete,%a_scriptdir%\template\expansionstring.txt
	FileDelete,%a_scriptdir%\template\String.txt
	RunWait,%A_ScriptDir%\bin2txt-h.exe,%A_ScriptDir%
	If errorlevel != 0
	{
		Loop,%a_scriptdir%\bin\*.bin
		{
			SplitPath,a_loopfilelongpath,BinName,BinDir,BinExt,BinBase,BinDrive
			GuiControl, , Text1,%Mod_Dir% ... deep analysis ...
			GuiControl, , Text2,This will take a LONG time, results may not be accurate...
			GuiControl, , Text3,Decompiling %BinBase%...
			RunWait,%a_scriptdir%\bin2txt-h.exe -file %BinBase%,%a_scriptdir%
		}
	}
	;~ FileMove,%A_ScriptDir%\txt\*.txt,%a_scriptdir%\Working\%ModFullName%\TXT\,1
	IfNotExist,%a_scriptdir%\Working\%ModFullName%\binscomplete
		FileAppend,binscomplete,%a_scriptdir%\Working\%ModFullName%\binscomplete
	
	GuiControl, , Text1,%ModFullName%
	GuiControl, , Text2,Stage 4
	GuiControl, , Text3,Parsing tbls to create proper txts for each language
	Pause
	Loop,Parse,MOD_LNG_LIST,`|
	{
		GuiControl, , Text3,Parsing tbls to create proper txts for each language... ( Lang: %A_LoopField% -> #%a_index%/%MOD_LNG_NUMBER0% )
		StringUpper,MOD_LNG,a_loopfield
		msgbox % "check for" mod_lng
		;~ FileCreateDir,
		
	}
	
	d2_new_patches=
	MOD_LNG_LIST=
	;ExitApp
}
ExitApp

















;~ StringReplace,cliptemp,PriorityMPQLast,`n,%a_space%,All
;~ StringReplace,Clipboard,cliptemp,%DiabloIIDir%,..,All
;~ msgbox % PriorityMPQLast
Loop,Parse,PriorityMPQLast,`n
{
	
	;~ SplitPath,PriorityMPQLast,MPQName,MPQDir,MPQExt,MPQBase,MPQDrive
	RunWait,%a_scriptdir%\MPQEditor.exe extract %a_loopfield% *.bin "%a_scriptdir%\bin\"  ;/listfile "%a_scriptdir%\ListFiles\MasterListFile.txt"
	;~ RunWait,%a_scriptdir%\MPQEditor.exe extract %a_loopfield% *.txt "%a_scriptdir%\Working\"  /fp 	;~ /listfile 
	If MPQBase in %d2_old_patches%
	{
		;~ MsgBox % MPQBase
		continue
	}
	RunWait,%a_scriptdir%\MPQEditor.exe extract %a_loopfield% *.tbl "%a_scriptdir%\TblConv\" /fp
	;~ MsgBox,%a_scriptdir%\MPQEditor.exe extract %a_loopfield% *.bin "%a_scriptdir%\bin\"  
	;~ ExitApp
}
GuiControl, , Text1,%ModFullName%
GuiControl, , Text2,
GuiControl, , Text3,Processing Tbl files...
RunWait,%A_ScriptDir%\TblConv\ToTxt.bat,%A_ScriptDir%\TblConv\
;~ ExitApp
FileDelete,%A_ScriptDir%\TblConv\*.tbl
FileMove,%A_ScriptDir%\TblConv\*.txt,%a_scriptdir%\txt\,1

GuiControl, , Text1,%ModFullName%
GuiControl, , Text2,
GuiControl, , Text3,Decompiling bins...

RunWait,%a_scriptdir%\bin2txt-h.exe,%a_scriptdir%


;~ RunWait,%a_scriptdir%\MPQEditor.exe /merged %MergedMPQ% extract patch_d2.mpq *.tbl "%a_scriptdir%\Working\" /fp
;~ RunWait,



;~ Loop,*.dc6,,1
;~ {
	;~ Total_Dc6 := A_Index
;~ }
;~ msgbox % Total_Dc6
ExitApp
Loop,*.dc6,,1
{
	CurrentImagePercent := a_index / Total_Dc6 * 100
	SplitPath,a_loopfilelongpath,ImageName,ImageDir,ImageExt,ImageBase
	ImageDirRelative := ImageDir
	StringReplace,ImageDirRelative,ImageDirRelative,%A_scriptdir%
	GuiControl, , Text1,%ImageDirRelative%\%ImageName% ;Scraping data for %SetName% [%SetCode%]...
	GuiControl, , Text3,%a_index% / %Total_Dc6% (%CurrentImagePercent%`%)
	;~ RunWait,%a_scriptdir%\dc6con.exe "%a_loopfilelongpath%",,hide
	;~ RunWait,C:\Users\Qriist\Desktop\Utilities\IrfanView\i_view64.exe "%ImageDir%\%ImageBase%.pcx" /convert="%ImageDir%\%ImageBase%.png" /silent
}
ExitApp

*/
esc::
goto,ExitRoutine
return



ExitRoutine:
Process,close,MPQEditor.exe
run, C:\Users\Qriist\Desktop\Recom\Tools\SQLiteStudio\SQLiteStudio.exe
ExitApp

;temporary hosting of the txt module for testing


