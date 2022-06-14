;complete
Digest_Bin_110f_charstats(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 196
	SkillTabNum := 0
	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 196
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["head"] := Trim(Bin.Read(32))
		Record["class"] := Trim(Bin.Read(16))
		Record["str"] := Bin.ReadUChar() 
		Record["dex"] := Bin.ReadUChar() 
		Record["int"] := Bin.ReadUChar() 
		Record["vit"] := Bin.ReadUChar() 
		Record["stamina"] := Bin.ReadUChar() 
		Record["hpadd"] := Bin.ReadUChar() 
		Record["PercentStr"] := Bin.ReadUChar() 
		Record["PercentInt"] := Bin.ReadUChar() 
		Record["PercentDex"] := Bin.ReadUChar() 
		Record["PercentVit"] := Bin.ReadUChar() 
		Record["ManaRegen"] := Bin.ReadUChar() 
		Record["bUnknown"] := Bin.ReadUChar() 
		Record["ToHitFactor"] := Bin.ReadInt() 
		Record["WalkVelocity"] := Bin.ReadUChar() 
		Record["RunVelocity"] := Bin.ReadUChar() 
		Record["RunDrain"] := Bin.ReadUChar() 
		Record["LifePerLevel"] := Bin.ReadUChar() 
		Record["StaminaPerLevel"] := Bin.ReadUChar() 
		Record["ManaPerLevel"] := Bin.ReadUChar() 
		Record["LifePerVitality"] := Bin.ReadUChar() 
		Record["StaminaPerVitality"] := Bin.ReadUChar() 
		Record["ManaPerMagic"] := Bin.ReadUChar() 
		Record["BlockFactor"] := Bin.ReadUChar() 
		Record["acPadding"] := Trim(Bin.Read(2))
		Record["baseWClass"] := Trim(Bin.Read(4))
		Record["StatPerLevel"] := Bin.ReadUChar() 
		Record["iPadding1"] := Bin.ReadUChar() 
		Record["StrAllSkills"] := Bin.ReadUShort() 
		
		Record["StrSkillTab1"] := Bin.ReadUShort() 
		Digest[ModFullName,"Recompile","SkillTab",SkillTabNum] := Record["StrSkillTab1"]
		Digest[ModFullName,"Recompile","SkillTab",SkillTabNum " class"] := Record["class"]
		SkillTabNum := SkillTabNum + 1
		
		Record["StrSkillTab2"] := Bin.ReadUShort() 
		Digest[ModFullName,"Recompile","SkillTab",SkillTabNum] := Record["StrSkillTab2"]
		Digest[ModFullName,"Recompile","SkillTab",SkillTabNum " class"] := Record["class"]
		SkillTabNum := SkillTabNum + 1
		
		Record["StrSkillTab3"] := Bin.ReadUShort() 
		Digest[ModFullName,"Recompile","SkillTab",SkillTabNum] := Record["StrSkillTab3"]
		Digest[ModFullName,"Recompile","SkillTab",SkillTabNum " class"] := Record["class"]
		SkillTabNum := SkillTabNum + 1
		
		Record["StrClassOnly"] := Bin.ReadUShort() 
		Loop,10
		{
			Record["item" a_index] := Trim(Bin.Read(4))
			Record["item" a_index "loc"] := Bin.ReadUChar() 
			Record["item" a_index "count"] := Bin.ReadUChar() 
			Bin.Read(2)
		}
		Record["StartSkill"] := Bin.ReadUShort() 
		Loop, 10
			Record["Skill " a_index] := Bin.ReadUShort() 
		
		Record["acTail"] := Bin.read(2)
		
		Kill=Skill|10
		RecordKill(Record,kill,0)
		
		Kill=item$|15
		KillDepend=item$loc,item$count
		RecordKill(Record,kill,"    ",KillDepend,,"$")
		
		InsertQuick("DigestDB","Decompile | " module,Record)		
		
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}