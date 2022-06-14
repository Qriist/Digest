﻿class class_digest {
	static pathToD2 := ""
	static tools := {"ladiks":A_ScriptDir "\tools\MPQEditor\MPQEditor.exe"
		,"ToTxt":A_ScriptDir "\tools\TblConv\ToTxt.exe"}
	static masterListFile := a_scriptdir "\cache\listfile\masterListFile.txt"
	static modList := []
	static oldPatches := StrSplit("d2data,d2char,d2sfx,d2speech,d2music,d2video,d2delta,d2kfixup,d2exp,d2xvideo,d2xtalk,d2xmusic",",")
	static customTbls := ""
	static modStringArr := []
	;static DigestDB := ""
	init(inputPathToD2,inputCustomTbls,inputDatabase){
		this.purgeTemp()
		this.registerD2Dir(inputPathToD2)
		this.DigestDB := new SQLiteDB
		If !this.DigestDB.opendb(a_scriptdir "\Digest.db")
			
		msgbox % "fail"
		;todo:	generate DB from scratch
		this.customTbls := inputCustomTbls
	}
	purgeTemp(){
		FileDelete, % A_ScriptDir "\temp\*"
		Loop, files,% A_ScriptDir "\temp\*", D
			FileRemoveDir, % A_LoopFileLongPath, 1
	}
	registerD2Dir(inputPathToD2){		
		this.pathToD2 := inputPathToD2
	}
	D2Dir(){
		return this.pathToD2
	}
	createMasterListFile(){
		FileCreateDir, % a_scriptdir "\cache\listfile\"
		Loop,files,a_scriptdir "\cache\listfile\*.txt"
			masterListFile .= FileOpen(a_loopfilelongpath,"r").read() "`n"
		Loop,files, % this.pathToD2 "\*.mpq",R
		{
			MPQ_Chain := []
			MPQ_Chain.push(A_LoopFileLongPath)
			this.MPQ_Extract(MPQ_Chain,"(listfile)",a_scriptdir "\temp\",0)
			if FileExist(a_scriptdir "\temp\(listfile)")
				masterListFile .= FileOpen(a_scriptdir "\temp\(listfile)","r").read() "`n"
			FileDelete, % a_scriptdir "\temp\(listfile)"
		}
		;msgbox % this.modList.count()
		for k,v in this.modList
		{
			;msgbox % currentMod
			currentMod := k
			loop, Files, % currentMod "\*",R
			{
				masterListFile .= StrReplace(A_LoopFileLongPath,currentMod "\") "`n"
				;msgbox % masterListFile
			}
		}
		sort,masterListFile,D`n U
		FileDelete, % a_scriptdir "\cache\listfile\*.txt"
		FileOpen(a_scriptdir "\cache\listfile\masterListFile.txt","w").write(masterListFile)
		this.purgeTemp()
	}	
	MPQ_Extract(MPQ_list,FileMaskToExtractFromMPQ,PathToExtractToDisk,UseFullPathing:=1,UseExternalListFile:="",Debug:=0)
	{
		;~ Load order: MPQ_list[a_index]
		;~ Priority order: MPQ_list[mpq_list.length()+1-a_index]		
		static mopaqLoc := A_ScriptDir "\temp\mopaq_script.txt"
		mopaq_script := ""
		
		Loop % MPQ_list.length()
			mopaq_script .= (a_index=1?"openpatch":"") a_space """" MPQ_list[a_index] """" 
		;{
		
			;If a_index=1
			;{
				;mopaq_script .= "openpatch" a_space """" MPQ_list[a_index] """" 
			;}
			;else
			;{
				;mopaq_script .= a_space """" MPQ_list[a_index] """"
			;}
		;}	
		mopaq_script .= a_space (UseExternalListFile=""?"":"/lf" a_space chr(34) UseExternalListFile chr(34)) "`n"
		
		;~ msgbox,,a,MPQeditor.exe extract %FileMaskToExtractFromMPQ% "%PathToExtractToDisk%" %activefull%	
		 ;~ RunWait,%A_ScriptDir%\MPQeditor.exe extract "%a_loopfield%" %FileMaskToExtractFromMPQ% "%PathToExtractToDisk%" %activefull%
		
		
		mopaq_script .= "extract" a_space """" MPQ_list[1] """" a_space FileMaskToExtractFromMPQ a_space """" PathToExtractToDisk """" a_space (UseFullPathing=1?"/fp":"")  "`n"
		mopaq_script .= "close"
		
		FileDelete,% mopaqLoc
		FileAppend,% mopaq_script , % mopaqLoc
		
		
		RunWait,% this.tools["ladiks"] " console " chr(34) mopaqLoc chr(34)
		If (Debug=1)
		{
			MsgBox,Paused at Mopaq Script execution...
			Pause
		}
		FileDelete,% mopaqLoc
	}
	scanForMods(){
		this.modList := []
		
		Loop, Files, % this.pathToD2 "\D2SE\CORES\*",D
			if FileExist(a_loopfilelongpath "\D2SE_SETUP.ini" )
			{
					;msgbox % here
				currentNum := (this.modList.count()+1)
				this.modList[currentNum] := class_EasyIni(a_loopfilelongpath "\D2SE_SETUP.ini")
				this.modList[currentNum,"_filepath"] := a_loopfilelongpath
				this.modList[currentNum,"_isCore"] := 1
				this.modList[currentNum,"_shortDir"] := A_LoopFileName				
			}
		Loop, Files, % this.pathToD2 "\MODS\*",D
			if FileExist(a_loopfilelongpath "\D2SE_SETUP.ini" )
			{
				currentNum := (this.modList.count()+1)
				this.modList[currentNum] := class_EasyIni(a_loopfilelongpath "\D2SE_SETUP.ini")
				this.modList[currentNum,"_filepath"] := a_loopfilelongpath	
				this.modList[currentNum,"_isCore"] := 0
				this.modList[currentNum,"_shortDir"] := A_LoopFileName
			}
		;MsgBox % clipboard := st_printarr(this.modlist)
	}
	decompileAllMods(){
		
		Loop,% this.modList.count(){
			modArr := []
			modArr["_filepath"] := this.modList[a_index,"_filepath"]
			modArr["_isCore"] := this.modList[a_index,"_isCore"]
			modArr["_shortDir"] := this.modList[a_index,"_shortDir"]
			modArr["D2Core"] := this.modList[a_index,"Protected","D2Core"]
			modArr["ModName"] := this.modList[a_index,"Protected","ModName"]
			modArr["ModTitle"] := this.modList[a_index,"Protected","ModTitle"]
			modArr["ModMajorVersion"] := this.modList[a_index,"Protected","ModMajorVersion"]
			modArr["ModMinorVersion"] := this.modList[a_index,"Protected","ModMinorVersion"]
			modArr["ModRevision"] := this.modList[a_index,"Protected","ModRevision"]
			modArr["ModBanner"] := this.modList[a_index,"Protected","ModBanner"]
			modArr["ModReadme"] := this.modList[a_index,"Protected","ModReadme"]
			modArr["ModHP"] := this.modList[a_index,"Protected","ModHP"]
			modArr["ModBoard"] := this.modList[a_index,"Protected","ModBoard"]
			modArr["Modable"] := this.modList[a_index,"Protected","Modable"]
			modArr["ModAllowHC"] := this.modList[a_index,"Protected","ModAllowHC"]
			modArr["ModAllowSPFeature"] := this.modList[a_index,"Protected","ModAllowSPFeature"]
			modArr["ModUseD2SE"] := this.modList[a_index,"Protected","ModUseD2SE"]
			modArr["D2SEDllName"] := this.modList[a_index,"Protected","D2SEDllName"]
			modArr["ModUseD2SEUtility"] := this.modList[a_index,"Protected","ModUseD2SEUtility"]
			modArr["ModUseNefex"] := this.modList[a_index,"Protected","ModUseNefex"]
			modArr["ModUseD2Mod"] := this.modList[a_index,"Protected","ModUseD2Mod"]
			modArr["ModUseD2Extra"] := this.modList[a_index,"Protected","ModUseD2Extra"]
			modArr["D2SEUtility"] := this.modList[a_index,"Protected","D2SEUtility"]
			modArr["ModAllowD2SEUtility"] := this.modList[a_index,"Protected","ModAllowD2SEUtility"]
			modArr["ModAllowSPFeature"] := this.modList[a_index,"Protected","ModAllowSPFeature"]
			modArr["ModAllowHC"] := this.modList[a_index,"Protected","ModAllowHC"]
			modArr["ModAllowPlugY"] := this.modList[a_index,"Protected","ModAllowPlugY"]
			modArr["ModUsePatch_D2"] := this.modList[a_index,"Protected","ModUsePatch_D2"]
			modArr["ModMPQ1"] := this.modList[a_index,"Protected","ModMPQ1"]
			modArr["ModMPQ2"] := this.modList[a_index,"Protected","ModMPQ2"]
			modArr["ModMPQ3"] := this.modList[a_index,"Protected","ModMPQ3"]
			modArr["RealmGateway"] := this.modList[a_index,"Protected","RealmGateway"]
			modArr["RealmTimezone"] := this.modList[a_index,"Protected","RealmTimezone"]
			modArr["RealmGatewayName"] := this.modList[a_index,"Protected","RealmGatewayName"]
			modArr["RealmSelected"] := this.modList[a_index,"Protected","RealmSelected"]
			modArr["RealmPort"] := this.modList[a_index,"Protected","RealmPort"]
			modArr["ModReadme"] := this.modList[a_index,"Protected","ModReadme"]
			modArr["ModDescription"] := this.modList[a_index,"Protected","ModDescription"]
			modArr["ModHP"] := this.modList[a_index,"Protected","ModHP"]
			modArr["ModBoard"] := this.modList[a_index,"Protected","ModBoard"]
			modArr["ModBanner"] := this.modList[a_index,"Protected","ModBanner"]
			modArr["UpdateFile"] := this.modList[a_index,"Protected","UpdateFile"]
			modArr["UpdateMirror1"] := this.modList[a_index,"Protected","UpdateMirror1"]
			modArr["UpdateMirror2"] := this.modList[a_index,"Protected","UpdateMirror2"]
			modArr["UpdateMirror3"] := this.modList[a_index,"Protected","UpdateMirror3"]
			modarr["_modHash"] := LC_SHA512(modArr["_filepath"] modArr["D2Core"] modArr["ModName"] modArr["ModTitle"] modArr["ModMajorVersion"] modArr["ModMinorVersion"] modArr["ModRevision"])
			If !this.DigestDB.exec(SingleRecordSQL("Mods",modarr,"_modHash"))
				msgbox % clipboard := SingleRecordSQL("Mods",modarr,"_modHash")
			
			this.decompileMod(modArr)
		}
	}
	decompileMod(byref modArr){
		If (modarr["d2core"] != "1.10f")	;limited until framework is complete
			return
		
		this.gatherMpqLists(modArr,mpqChain,mpqNew,mpqOld)
		this.gatherRawStrings(modarr,mpqChain)
		this.decompileBins(modArr,mpqChain)
		;msgbox % st_printarr(this.oldPatches)
	}
	gatherMpqLists(byref modArr,byref mpqChain,byref mpqNew,byref mpqOld){
		mpqChain := []
		mpqNew := []
		mpqOld := []
		
		loop, % this.oldPatches.count()	;create base list of existing vanilla mpqs
			if FileExist(this.pathToD2 "\" this.oldPatches[a_index] ".mpq"){
				mpqOld.push(this.pathToD2 "\"this.oldPatches[a_index] ".mpq")
				mpqChain.push(this.pathToD2 "\"this.oldPatches[a_index] ".mpq")
			}
		
		If FileExist(this.pathToD2 "\D2SE\CORES\" modArr["D2Core"] "\patch_d2.mpq"){	;add core patch
			mpqChain.push(this.pathToD2 "\D2SE\CORES\" modArr["D2Core"] "\patch_d2.mpq")
			mpqOld.push(this.pathToD2 "\D2SE\CORES\" modArr["D2Core"] "\patch_d2.mpq")
		}
		
		
		
		If (modArr["ModUsePatch_D2"] = 1)	;Load Mod Patch_D2
		&&	FileExist(modArr["_filepath"] "\patch_d2.mpq"){
			mpqChain.push(modArr["_filepath"] "\patch_d2.mpq")
			mpqNew.push(modArr["_filepath"] "\patch_d2.mpq")
		}
		
		
		Loop,3{	;load the D2SE-permitted mpqs
			if (modArr["ModMPQ" a_index] = "")
				Continue
			If FileExist(modArr["_filepath"] "\" modArr["ModMPQ" a_index]){
				mpqChain.push(modArr["_filepath"] "\" modArr["ModMPQ" a_index])
				mpqnew.push(modArr["_filepath"] "\" modArr["ModMPQ" a_index])
			}
		}
		
		if FileExist(modArr["_filepath"] "\Data\" )	;create patch from non-mpq files	-probably generally faster to check existing contents but this way is easier
		{
			FileDelete, % a_scriptdir "\temp\direct_txt.mpq"
			RunWait, % this.tools["ladiks"] " new " chr(34) a_scriptdir "\temp\direct_txt.mpq" chr(34)
			;clipboard := this.tools["ladiks"] " add " chr(34) a_scriptdir "\temp\direct_txt.mpq" chr(34) " " chr(34) modArr["_filepath"] "\Data\ Data\ /auto /r"
			RunWait,% this.tools["ladiks"] " add " chr(34) a_scriptdir "\temp\direct_txt.mpq" chr(34) " " chr(34) modArr["_filepath"] "\Data\" chr(34) " Data\ /auto /r"
			mpqChain.push( A_ScriptDir "\temp\direct_txt.mpq" )
			mpqnew.push( A_ScriptDir "\temp\direct_txt.mpq" )
			;msgbox % modArr["_filepath"]
		}
		
		
		
		;Debug loop to ensure the mpq chain is in the correct order. This is LOAD order, and is served to MPQ_Extract like this.
		;~ Loop % mpqChain.length()
			;~ msgbox % mpqChain[a_index]
			;~ MsgBox % st_printarr(mpqChain)
			;~ MsgBox % st_printarr(mpqnew)
		;And in reverse. This is PRIORITY order. Not generally needed.
		;~ Loop % mpqChain.length()
			;~ msgbox % MPQ_Chain[mpqChain.length()+1-a_index]
	}
	
	gatherRawStrings(byref modarr,byref mpqChain){
		
		If this.CustomTbls.HasKey(modArr["_shortdir"])	;use custom tbls; possibly a dreamlands thing?
		&&	!modArr["_isCore"]{
			TblListArray := StrSplit(this.CustomTbls[modArr["_shortdir"]],",")
		}
		else{
			TblListArray := []			
			TblListArray.push("string")
			TblListArray.push("patchstring")
			TblListArray.push("expansionstring")
		}
		
		
		If FileExist(modArr["_filepath"] "\D2Mod.ini")
		&& (modArr["ModUseD2Mod"] = 1)
		{
			checkD2ModTbls := class_EasyIni(modArr["_filepath"] "\D2Mod.ini")
			Loop,3{
				If (checkD2ModTbls["CustomTbl","table" a_index] != "")
					TblListArray.push(RegExReplace(checkD2ModTbls["CustomTbl","table" a_index],"\.tbl$"))
			}
		}
		
	;msgbox % "tbls are scanned, now they must be processed."
	;ExitApp
		;msgbox % modArr["_shortDir"] "`n" st_printArr(MODARR)
		
	;For now, only doing ENG. My sanity depends on it.
	;Need to gather list of languages to decompile
	;To do this:
	;A) extract *.tbl from mod MPQs only. (MPQ_new)
	;B) fill in any missing tbls from that language's full-chain locale
	;C) search later vanilla patch_d2's for missing tbls and cross your fingers that it works.
	;D) on the offchance that no suitable file is available, default to ENG*
		
	;*
	;*ENG crossreferencing is currently not implemented in order to actually do other stuff.
		
	;A) Extract tables
	;EXTRACT
		;MPQ_Extract(MPQ_new, "*\local\lng\*.tbl" ,a_scriptdir "\TblConv\",1,A_ScriptDir "\ListFiles\MasterListFile.txt",0) ; TESTING
	;~ MPQ_Extract(MPQ_new, "*\local\lng\ENG\*.tbl" ,a_scriptdir "\TblConv\",0,A_ScriptDir "\ListFiles\MasterListFile.txt",0)
	;~ Pause
		;~ Pause
		this.mpq_Extract(mpqChain,"*\local\lng\*.tbl",a_scriptdir "\temp\",1,this.masterListFile)	;extracts the tbls
		;msgbox % st_printArr(mpqChain)
		
		modLngArray := []
		Loop, Files, % a_scriptdir "\temp\data\Local\lng\*",D	;builds list of languages - only English right now
		{
			;Loops through the languages, using the foldername as the current language
			modLng := StringUpper(a_LoopFileName)
			if (modLng != "ENG")
				continue
			;modLngArray.push(modLng)
			modLngArray[modLng] := {}
		}
		
		FileDelete,% a_scriptdir "\tools\TblConv\*.txt"
		
		Tbloffset := 0
		;dumpArr := []
		this.DigestDB.exec("DELETE FROM strings WHERE modId=(SELECT modId FROM Mods WHERE _modHash='" modarr["_modHash"] "');")
		this.DigestDB.exec("BEGIN TRANSACTION;")
		
		for k,v in modLngArray {
			modLng := k
			;msgbox % modArr["_modId"]
			;msgbox % clipboard := SingleRecordSQL("Languages",{"languageText":modlng})
			this.DigestDB.exec(SingleRecordSQL("Languages",{"languageText":modlng}))			
			loop, % TblListArray.count(){
				;msgbox % clipboard := a_scriptdir "\temp\data\local\lng\" modlng "\" TblListArray[a_index] ".tbl"
				FileCopy, %  a_scriptdir "\temp\data\local\lng\" modlng "\" TblListArray[a_index] ".tbl", % a_scriptdir "\tools\TblConv\",1
				RunWait, % this.tools["totxt"]
				
				CurrentTxt := FileOpen(a_scriptdir "\tools\TblConv\" TblListArray[a_index] ".txt","r").read()
				Loop,Parse,CurrentTxt,`n,`r
				{
					singlecode := StrSplit(A_LoopField,a_tab,a_space)
					modLngArray[modlng,"String By Code",singlecode[1]] := singlecode[2]
					modLngArray[modlng,"Code By Number",a_index-1+Tbloffset] := singlecode[1]
					modLngArray[modlng,"String By Number",a_index-1+Tbloffset] := singlecode[2]
					dumpArr := {"modId":"(SELECT modId FROM Mods WHERE _modHash='" modarr["_modHash"] "')"
					,"languageId":"(SELECT languageId FROM languages WHERE languagetext='" modLng "')"
					,"stringIndex":(a_index-1+Tbloffset)
					,"stringCode":singlecode[1]
					,"stringText":singlecode[2]}
					this.DigestDB.exec(SingleRecordSQL("strings",dumparr,,,"modId,languageId"))
					;dumpArr["_modId"] := modArr["_modId"], 		
					
					;msgbox % Clipboard := SingleRecordSQL("strings",dumparr,,,"modId,languageId")
				}
				FileDelete, % a_scriptdir "\tools\TblConv\" TblListArray[a_index] ".txt"
				Tbloffset += 10000				
			}
			;msgbox % clipboard := st_printarr(modLngArray)
			
		}
		this.modStringArr := modLngArray
		this.DigestDB.exec("COMMIT;")
		;msgbox % "look"
		this.purgeTemp()
	}
	dumpRawStrings(){
		;this.DigestDB.exec("BEGIN TRANSACTION;")
		
		
		;this.DigestDB.exec("COMMIT;")
	}
	decompileBins(ByRef modArr,ByRef mpqChain){
		this.MPQ_Extract(mpqChain,"*.bin",a_scriptdir "\temp\",1)
		
		Loop,Files,% a_scriptdir "\temp\data\global\excel\*.bin"{
			SplitPath,a_loopfilelongpath,FileName,FileDir,FileExt,FileBase,FileDrive
			;this.decompileBin(FileBase,a_loopfile)
		}	
		this.purgeTemp()
	}
}