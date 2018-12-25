;complete
Digest_Bin_110f_weapons(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 424

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 424
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["flippyfile"] := Trim(Bin.Read(32))
		Record["invfile"] := Trim(Bin.Read(32))
		Record["uniqueinvfile"] := Trim(Bin.Read(32))
		Record["setinvfile"] := Trim(Bin.Read(32))
		Record["code"] := Trim(Bin.Read(4))
		Record["normcode"] := Trim(Bin.Read(4))
		Record["ubercode"] := Trim(Bin.Read(4))
		Record["ultracode"] := Trim(Bin.Read(4)) 
		Record["alternateGfx"] := Trim(Bin.Read(4))
		Record["iPadding37"] := Bin.ReadUInt() 
		Record["iPadding38"] := Bin.ReadUInt() 
		Record["iPadding39"] := Bin.ReadUInt() 
		Record["iPadding40"] := Bin.ReadUInt() 
		Record["iPadding41"] := Bin.ReadUInt() 
		Record["iPadding42"] := Bin.ReadUInt() 
		Record["iPadding43"] := Bin.ReadUInt() 
		Record["iPadding44"] := Bin.ReadUInt() 
		Record["iPadding45"] := Bin.ReadUInt() 
		Record["iPadding46"] := Bin.ReadUInt() 
		Record["iPadding47"] := Bin.ReadUInt() 
		Record["wclass"] := Trim(Bin.Read(4))
		Record["2handedwclass"] := Trim(Bin.Read(4))
		Record["iPadding50"] := Bin.ReadUInt() 
		Record["iPadding51"] := Bin.ReadUInt() 
		Record["iPadding52"] := Bin.ReadUInt() 
		Record["gamble cost"] := Bin.ReadUInt() 
		Record["speed"] := Bin.ReadShort() 
		Record["iPadding54"] := Trim(Bin.Read(2))
		Record["bitfield1"] := Bin.ReadUChar() 
		Record["iPadding55"] := Trim(Bin.Read(3))
		Record["cost"] := Bin.ReadUInt() 
		Record["minstack"] := Bin.ReadUInt() 
		Record["maxstack"] := Bin.ReadUInt() 
		Record["spawnstack"] := Bin.ReadUInt() 
		Record["gemoffset"] := Bin.ReadUChar() 
		Record["iPadding60"] := Trim(Bin.Read(3))
		Record["namestr"] := Bin.ReadUShort() 
		Record["version"] := Bin.ReadUShort() 
		Record["auto prefix"] := Bin.ReadUShort() 
		Record["missiletype"] := Bin.ReadUShort() 
		Record["rarity"] := Bin.ReadUChar() 
		Record["level"] := Bin.ReadUChar() 
		Record["mindam"] := Bin.ReadUChar() 
		Record["maxdam"] := Bin.ReadUChar() 
		Record["minmisdam"] := Bin.ReadUChar() 
		Record["maxmisdam"] := Bin.ReadUChar() 
		Record["2handmindam"] := Bin.ReadUChar() 
		Record["2handmaxdam"] := Bin.ReadUChar() 
		Record["rangeadder"] := Bin.ReadUShort() 
		Record["StrBonus"] := Bin.ReadUShort() 
		Record["DexBonus"] := Bin.ReadUShort() 
		Record["reqstr"] := Bin.ReadUShort() 
		Record["reqdex"] := Bin.ReadUShort() 
		Record["iPadding67"] := Bin.ReadUChar() 
		Record["invwidth"] := Bin.ReadUChar() 
		Record["invheight"] := Bin.ReadUChar() 
		Record["iPadding68"] := Bin.ReadUChar() 
		Record["durability"] := Bin.ReadUChar() 
		Record["nodurability"] := Bin.ReadUChar() 
		Record["iPadding69"] := Bin.ReadUChar() 
		Record["component"] := Bin.ReadUChar() 
		Record["iPadding69_1"] := Trim(Bin.Read(2))
		Record["iPadding70"] := Bin.ReadUInt() 
		Record["2handed"] := Bin.ReadUChar() 
		Record["useable"] := Bin.ReadUChar() 
		Record["type"] := Bin.ReadUShort() 
		Record["type2"] := Bin.ReadUShort() 
		Record["iPadding72"] := Bin.ReadUShort() 
		Record["dropsound"] := Bin.ReadUShort() 
		Record["usesound"] := Bin.ReadUShort() 
		Record["dropsfxframe"] := Bin.ReadUChar() 
		Record["unique"] := Bin.ReadUChar() 
		Record["quest"] := Bin.ReadUChar() 
		Record["questdiffcheck"] := Bin.ReadUChar() 
		Record["transparent"] := Bin.ReadUChar() 
		Record["transtbl"] := Bin.ReadUChar() 
		Record["iPadding75"] := Bin.ReadUChar() 
		Record["lightradius"] := Bin.ReadUChar() 
		Record["belt"] := Bin.ReadUChar() 
		Record["iPadding76"] := Bin.ReadUChar() 
		Record["stackable"] := Bin.ReadUChar() 
		Record["spawnable"] := Bin.ReadUChar() 
		Record["iPadding77"] := Bin.ReadUChar() 
		Record["durwarning"] := Bin.ReadUChar() 
		Record["qntwarning"] := Bin.ReadUChar() 
		Record["hasinv"] := Bin.ReadUChar() 
		Record["gemsockets"] := Bin.ReadUChar() 
		Record["iPadding78"] := Trim(Bin.Read(3))
		Record["hit class"] := Bin.ReadUChar() 
		Record["1or2handed"] := Bin.ReadUChar() 
		Record["gemapplytype"] := Bin.ReadUChar() 
		Record["levelreq"] := Bin.ReadUChar() 
		Record["magic lvl"] := Bin.ReadUChar() 
		Record["Transform"] := Bin.ReadUChar() 
		Record["InvTrans"] := Bin.ReadUChar() 
		Record["compactsave"] := Bin.ReadUChar() 
		Record["SkipName"] := Bin.ReadUChar() 
		Record["Nameable"] := Bin.ReadUChar() 
		Record["AkaraMin"] := Bin.ReadUChar() 
		Record["GheedMin"] := Bin.ReadUChar() 
		Record["CharsiMin"] := Bin.ReadUChar() 
		Record["FaraMin"] := Bin.ReadUChar() 
		Record["LysanderMin"] := Bin.ReadUChar() 
		Record["DrognanMin"] := Bin.ReadUChar() 
		Record["HraltiMin"] := Bin.ReadUChar() 
		Record["AlkorMin"] := Bin.ReadUChar() 
		Record["OrmusMin"] := Bin.ReadUChar() 
		Record["ElzixMin"] := Bin.ReadUChar() 
		Record["AshearaMin"] := Bin.ReadUChar() 
		Record["CainMin"] := Bin.ReadUChar() 
		Record["HalbuMin"] := Bin.ReadUChar() 
		Record["JamellaMin"] := Bin.ReadUChar() 
		Record["MalahMin"] := Bin.ReadUChar() 
		Record["LarzukMin"] := Bin.ReadUChar() 
		Record["DrehyaMin"] := Bin.ReadUChar() 
		Record["AkaraMax"] := Bin.ReadUChar() 
		Record["GheedMax"] := Bin.ReadUChar() 
		Record["CharsiMax"] := Bin.ReadUChar() 
		Record["FaraMax"] := Bin.ReadUChar() 
		Record["LysanderMax"] := Bin.ReadUChar() 
		Record["DrognanMax"] := Bin.ReadUChar() 
		Record["HraltiMax"] := Bin.ReadUChar() 
		Record["AlkorMax"] := Bin.ReadUChar() 
		Record["OrmusMax"] := Bin.ReadUChar() 
		Record["ElzixMax"] := Bin.ReadUChar() 
		Record["AshearaMax"] := Bin.ReadUChar() 
		Record["CainMax"] := Bin.ReadUChar() 
		Record["HalbuMax"] := Bin.ReadUChar() 
		Record["JamellaMax"] := Bin.ReadUChar() 
		Record["MalahMax"] := Bin.ReadUChar() 
		Record["LarzukMax"] := Bin.ReadUChar() 
		Record["DrehyaMax"] := Bin.ReadUChar() 
		Record["AkaraMagicMin"] := Bin.ReadUChar() 
		Record["GheedMagicMin"] := Bin.ReadUChar() 
		Record["CharsiMagicMin"] := Bin.ReadUChar() 
		Record["FaraMagicMin"] := Bin.ReadUChar() 
		Record["LysanderMagicMin"] := Bin.ReadUChar() 
		Record["DrognanMagicMin"] := Bin.ReadUChar() 
		Record["HraltiMagicMin"] := Bin.ReadUChar() 
		Record["AlkorMagicMin"] := Bin.ReadUChar() 
		Record["OrmusMagicMin"] := Bin.ReadUChar() 
		Record["ElzixMagicMin"] := Bin.ReadUChar() 
		Record["AshearaMagicMin"] := Bin.ReadUChar() 
		Record["CainMagicMin"] := Bin.ReadUChar() 
		Record["HalbuMagicMin"] := Bin.ReadUChar() 
		Record["JamellaMagicMin"] := Bin.ReadUChar() 
		Record["MalahMagicMin"] := Bin.ReadUChar() 
		Record["LarzukMagicMin"] := Bin.ReadUChar() 
		Record["DrehyaMagicMin"] := Bin.ReadUChar() 
		Record["AkaraMagicMax"] := Bin.ReadUChar() 
		Record["GheedMagicMax"] := Bin.ReadUChar() 
		Record["CharsiMagicMax"] := Bin.ReadUChar() 
		Record["FaraMagicMax"] := Bin.ReadUChar() 
		Record["LysanderMagicMax"] := Bin.ReadUChar() 
		Record["DrognanMagicMax"] := Bin.ReadUChar() 
		Record["HraltiMagicMax"] := Bin.ReadUChar() 
		Record["AlkorMagicMax"] := Bin.ReadUChar() 
		Record["OrmusMagicMax"] := Bin.ReadUChar() 
		Record["ElzixMagicMax"] := Bin.ReadUChar() 
		Record["AshearaMagicMax"] := Bin.ReadUChar() 
		Record["CainMagicMax"] := Bin.ReadUChar() 
		Record["HalbuMagicMax"] := Bin.ReadUChar() 
		Record["JamellaMagicMax"] := Bin.ReadUChar() 
		Record["MalahMagicMax"] := Bin.ReadUChar() 
		Record["LarzukMagicMax"] := Bin.ReadUChar() 
		Record["DrehyaMagicMax"] := Bin.ReadUChar() 
		Record["AkaraMagicLvl"] := Bin.ReadUChar() 
		Record["GheedMagicLvl"] := Bin.ReadUChar() 
		Record["CharsiMagicLvl"] := Bin.ReadUChar() 
		Record["FaraMagicLvl"] := Bin.ReadUChar() 
		Record["LysanderMagicLvl"] := Bin.ReadUChar() 
		Record["DrognanMagicLvl"] := Bin.ReadUChar() 
		Record["HraltiMagicLvl"] := Bin.ReadUChar() 
		Record["AlkorMagicLvl"] := Bin.ReadUChar() 
		Record["OrmusMagicLvl"] := Bin.ReadUChar() 
		Record["ElzixMagicLvl"] := Bin.ReadUChar() 
		Record["AshearaMagicLvl"] := Bin.ReadUChar() 
		Record["CainMagicLvl"] := Bin.ReadUChar() 
		Record["HalbuMagicLvl"] := Bin.ReadUChar() 
		Record["JamellaMagicLvl"] := Bin.ReadUChar() 
		Record["MalahMagicLvl"] := Bin.ReadUChar() 
		Record["LarzukMagicLvl"] := Bin.ReadUChar() 
		Record["DrehyaMagicLvl"] := Bin.ReadUChar() 
		Record["iPadding102"] := Bin.ReadUChar() 
		Record["NightmareUpgrade"] := Trim(Bin.Read(4))
		Record["HellUpgrade"] := Trim(Bin.Read(4))
		Record["PermStoreItem"] := Bin.ReadUInt()
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		
		Kill=AkaraMin,GheedMin,CharsiMin,FaraMin,LysanderMin,DrognanMin,HraltiMin,AlkorMin,OrmusMin,ElzixMin,AshearaMin,CainMin,HalbuMin,JamellaMin,MalahMin,LarzukMin,DrehyaMin,AkaraMax,GheedMax,CharsiMax,FaraMax,LysanderMax,DrognanMax,HraltiMax,AlkorMax,OrmusMax,ElzixMax,AshearaMax,CainMax,HalbuMax,JamellaMax,MalahMax,LarzukMax,DrehyaMax,AkaraMagicMin,GheedMagicMin,CharsiMagicMin,FaraMagicMin,LysanderMagicMin,DrognanMagicMin,HraltiMagicMin,AlkorMagicMin,OrmusMagicMin,ElzixMagicMin,AshearaMagicMin,CainMagicMin,HalbuMagicMin,JamellaMagicMin,MalahMagicMin,LarzukMagicMin,DrehyaMagicMin,AkaraMagicMax,GheedMagicMax,CharsiMagicMax,FaraMagicMax,LysanderMagicMax,DrognanMagicMax,HraltiMagicMax,AlkorMagicMax,OrmusMagicMax,ElzixMagicMax,AshearaMagicMax,CainMagicMax,HalbuMagicMax,JamellaMagicMax,MalahMagicMax,LarzukMagicMax,DrehyaMagicMax,AkaraMagicLvl,GheedMagicLvl,CharsiMagicLvl,FaraMagicLvl,LysanderMagicLvl,DrognanMagicLvl,HraltiMagicLvl,AlkorMagicLvl,OrmusMagicLvl,ElzixMagicLvl,AshearaMagicLvl,CainMagicLvl,HalbuMagicLvl,JamellaMagicLvl,MalahMagicLvl,LarzukMagicLvl,DrehyaMagicLvl,iPadding|102
		RecordKill(Record,Kill,0)
		
		Kill=iPadding|105
		RecordKill(Record,Kill,4294967295)
		
		Kill=iPadding|102
		RecordKill(Record,Kill,"")
		
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
	}
}