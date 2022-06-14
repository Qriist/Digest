class class_digest {
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
		
		;FileDelete,% a_scriptdir "\tools\TblConv\*.txt"
		
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
				;FileCopy, %  a_scriptdir "\temp\data\local\lng\" modlng "\" TblListArray[a_index] ".tbl", % a_scriptdir "\tools\TblConv\",1
				;RunWait, % this.tools["totxt"]
				
				;CurrentTxt := FileOpen(a_scriptdir "\tools\TblConv\" TblListArray[a_index] ".txt","r").read()

				CurrentTxt := this.tblConv_TblToTxt(a_scriptdir "\temp\data\local\lng\" modlng "\" TblListArray[a_index] ".tbl")
				;msgbox % CurrentTxt
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
				;FileDelete, % a_scriptdir "\tools\TblConv\" TblListArray[a_index] ".txt"
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
		
		Loop,Files,% a_scriptdir "\temp\data\global\excel\*.bin"
		{
			SplitPath,a_loopfilelongpath,FileName,FileDir,FileExt,FileBase,FileDrive
			;this.decompileBin(FileBase,a_loopfile)
		}	
		;this.purgeTemp()
	}
	tblConv_TblToTxt(inputTblPath){
		;converted pretty much line by line from Mephansteras's 2001 standalone perl script. Idk where I found it.
		/* intro to the string.tbl format.
			# There are four main sections to the string.tbl file.
			# First, the header.  This is 21 bytes long.
			# Second, an array with two bytes per entry, that gives an index into the next table.  This allows lookups of strings by number.
			# Third, a hash array, with 17 bytes per entry, which has the pointers to the key and value strings, and has the strings sorted basically by hash value.  This allows lookups of strings by key.
			# Fourth, the actual strings themselves.
		*/
		tbl := FileOpen(inputTblPath, "r", "UTF-8-Raw")

		;21 byte header
		usCRC := tbl.ReadUShort()   ;This is usCRC, an unsigned short which contains the CRC (Cyclical Redundacy Check) which we don't care about.
		usNumElements := tbl.ReadUShort()   ;This is usNumElements, the total number of elements (key/value string pairs) in the file.
		iHashTableSize := tbl.ReadUInt()    ;This is iHashTableSize, the number of entries in the HashTable.  
											;This has to be at least equal to usNumElements, and if higher it can speed up the hash table look up.  
											;Blizzard has this number be 2 higher than usNumElements in the english version.  
											;I just leave the hash table size the same as usNumElements, which is not optimal, but easier.
		unknownByte := tbl.ReadUChar()       ;I don't know what this is used for, I always set it to 1, which is what it is in the english version.
		dwIndexStart := tbl.ReadUInt()  ;This is dwIndexStart, the offset of the first byte of the actual strings.  
										;This offset is from the start of the file, as are the other offsets mentioned herein.  
										;We don't really need it when reading.
		missedHashMatch := tbl.ReadUInt()   ;When the number of times you have missed a match with a hash key equals this value, you give up because it is not there.  
											;We don't care what this value was in the original.
		dwIndexEnd  := tbl.ReadUInt()   ;This is dwIndexEnd, the offset just after the last byte of the actual strings.

		;Reading strings
		elements := []
		loop, % usNumElements{
			elements[a_index - 1] := tbl.ReadUShort()   ;0-based array
			;msgbox % elements[a_index - 1]
		}

		keys := []
		values := []
		nodeStart := (21 + (usNumElements * 2))   ;Sets $nodeStart to the current offset we are at in the file.  This is equal to (21 + ($numElements * 2)).  This is the offset at the start of the hash table.
		
		;!!!confirmed good values up to this point!!!
		

		loop, % usNumElements {
			idx := a_index - 1  ;0-based array
			tbl.Seek((nodeStart + (elements[idx] * 17)), 0)    ;Set the offset that we are reading from in the file to be (Start of Hash Table + (17 * the ith element in array elements)), 
															;meaning the start of the hash table entry that was indicated by entry #i in the previous table.
			bUsed := tbl.ReadUChar() ;This is bUsed, which is set to 1 if this entry is used.  
							;This may be set to 0 if this entry is just in there to add to the size of the hash table to get better performance.  
							;We just ignore it, assuming it is 1.  We could assert that it is one if we wanted, though.
			idxNum := tbl.ReadUShort()  ;This is the index number.  
										;Basically, this should always be equal to the value of $i as we read it.  
										;That is, the index in the previous array whose value is this index in this array.

			;confirmed that (idx = idxnum)
			idxHash := tbl.ReadUInt()   ;This is the hash number.  
										;This is the number you get from sending this entry's key string through the hashing algorithim.  
										;We don't care about it right now.
			dwKeyOffset := tbl.ReadUInt()   ;This is dwKeyOffset, the offset of the key string.  
											;The key is the same in every language.
			dwStringOffset := tbl.ReadUInt()    ;This is dwStringOffset, the offset to the value string.  
												;The value is translated into the appropriate language.
			idxLength := tbl.ReadUShort()   ;read 2 bytes.  This is the length of the value string.

			tbl.Seek(dwKeyOffset, 0)    ;Go to the key's offset now.
			key := ""
			loop{
				nullTest := tbl.ReadUChar() ;read into local variable $key everything up to and including the next null byte.

				if !nullTest    
					Break   ;get rid of the trailing null byte on $key
				key .= chr(nullTest)    
			}

			tbl.Seek(dwStringOffset, 0)    ;Go to the key's offset now.
			string := ""
			loop{
				nullTest := tbl.ReadUChar() ;read into local variable $string everything up to and including the next null byte.
				if !nullTest
					break   ;get rid of the trailing null byte on $string
				string .= chr(nullTest)    
			}

			;appears to create good values up to this point
			keys[idx] := key
			values[idx] := string
			
			;cleaning inputs
			inkey := keys[idx]
			inkey := Trim(inkey,"`r")   ;Strip Carriage Return
			inkey := StrReplace(inkey, "`n", "}")   ;Replace Newlines with }
			inkey := StrReplace(inkey, a_tab , "\t")    ;Replace any Tabs with \t

			inval := values[idx]
			inval := Trim(inval,"`r")   ;Strip Carriage Return
			inval := StrReplace(inval, "`n", "}")   ;Replace Newlines with }
			inval := StrReplace(inval, a_tab , "\t")    ;Replace any Tabs with \t
			retStr .= inkey "`t" inval "`r`n"
		}
		return retStr
	}
}
