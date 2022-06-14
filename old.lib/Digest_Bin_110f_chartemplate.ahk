;complete
Digest_Bin_110f_chartemplate(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 240
	
	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 240
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Name"] := Bin.Read(30) 
		Record["Class"] := Bin.ReadUChar() 
		Record["Level"] := Bin.ReadUChar() 
		Record["Act"] := Bin.ReadUChar() 
		Record["str"] := Bin.ReadUChar() 
		Record["dex"] := Bin.ReadUChar() 
		Record["int"] := Bin.ReadUChar() 
		Record["vit"] := Bin.ReadUChar() 
		Record["Mana"] := Bin.ReadUChar() 
		Record["Hitpoints"] := Bin.ReadUChar() 
		Record["ManaRegenBonus"] := Bin.ReadUChar() 
		Record["Velocity"] := Bin.ReadUChar() 
		Record["AttackRate"] := Bin.ReadUChar() 
		Record["OtherRate"] := Bin.ReadUShort() 
		Record["RightSkill"] := Bin.ReadUInt() 
		Loop,9
			Record["Skill" a_index] := Bin.ReadUInt() 
		Record["Skill2"] := Bin.ReadUInt() 
		Record["Skill3"] := Bin.ReadUInt() 
		Record["Skill4"] := Bin.ReadUInt() 
		Record["Skill5"] := Bin.ReadUInt() 
		Record["Skill6"] := Bin.ReadUInt() 
		Record["Skill7"] := Bin.ReadUInt() 
		Record["Skill8"] := Bin.ReadUInt() 
		Record["Skill9"] := Bin.ReadUInt() 
		Loop, 9
			Record["SkillLevel" a_index] := Bin.ReadUInt() 
		Record["SkillLevel2"] := Bin.ReadUInt() 
		Record["SkillLevel3"] := Bin.ReadUInt() 
		Record["SkillLevel4"] := Bin.ReadUInt() 
		Record["SkillLevel5"] := Bin.ReadUInt() 
		Record["SkillLevel6"] := Bin.ReadUInt() 
		Record["SkillLevel7"] := Bin.ReadUInt() 
		Record["SkillLevel8"] := Bin.ReadUInt() 
		Record["SkillLevel9"] := Bin.ReadUInt() 
		Loop,15
		{
			Record["item" a_index] := Bin.Read(4) 
			Record["item" a_index "loc"] := Bin.ReadUChar() 
			Record["item" a_index "count"] := Bin.ReadUChar() 
			Record["iPadding31"] := 
			Bin.ReadUShort() 
		}
		Record["item2"] := Bin.Read(4) 
		Record["item2loc"] := Bin.ReadUChar() 
		Record["item2count"] := Bin.ReadUChar() 
		Record["iPadding33"] := Bin.ReadUShort() 
		Record["item3"] := Bin.Read(4) 
		Record["item3loc"] := Bin.ReadUChar() 
		Record["item3count"] := Bin.ReadUChar() 
		Record["iPadding35"] := Bin.ReadUShort() 
		Record["item4"] := Bin.Read(4) 
		Record["item4loc"] := Bin.ReadUChar() 
		Record["item4count"] := Bin.ReadUChar() 
		Record["iPadding37"] := Bin.ReadUShort() 
		Record["item5"] := Bin.Read(4) 
		Record["item5loc"] := Bin.ReadUChar() 
		Record["item5count"] := Bin.ReadUChar() 
		Record["iPadding39"] := Bin.ReadUShort() 
		Record["item6"] := Bin.Read(4) 
		Record["item6loc"] := Bin.ReadUChar() 
		Record["item6count"] := Bin.ReadUChar() 
		Record["iPadding41"] := Bin.ReadUShort() 
		Record["item7"] := Bin.Read(4) 
		Record["item7loc"] := Bin.ReadUChar() 
		Record["item7count"] := Bin.ReadUChar() 
		Record["iPadding43"] := Bin.ReadUShort() 
		Record["item8"] := Bin.Read(4) 
		Record["item8loc"] := Bin.ReadUChar() 
		Record["item8count"] := Bin.ReadUChar() 
		Record["iPadding45"] := Bin.ReadUShort() 
		Record["item9"] := Bin.Read(4) 
		Record["item9loc"] := Bin.ReadUChar() 
		Record["item9count"] := Bin.ReadUChar() 
		Record["iPadding47"] := Bin.ReadUShort() 
		Record["item10"] := Bin.Read(4) 
		Record["item10loc"] := Bin.ReadUChar() 
		Record["item10count"] := Bin.ReadUChar() 
		Record["iPadding49"] := Bin.ReadUShort() 
		Record["item11"] := Bin.Read(4) 
		Record["item11loc"] := Bin.ReadUChar() 
		Record["item11count"] := Bin.ReadUChar() 
		Record["iPadding51"] := Bin.ReadUShort() 
		Record["item12"] := Bin.Read(4) 
		Record["item12loc"] := Bin.ReadUChar() 
		Record["item12count"] := Bin.ReadUChar() 
		Record["iPadding53"] := Bin.ReadUShort() 
		Record["item13"] := Bin.Read(4) 
		Record["item13loc"] := Bin.ReadUChar() 
		Record["item13count"] := Bin.ReadUChar() 
		Record["iPadding55"] := Bin.ReadUShort() 
		Record["item14"] := Bin.Read(4) 
		Record["item14loc"] := Bin.ReadUChar() 
		Record["item14count"] := Bin.ReadUChar() 
		Record["iPadding57"] := Bin.ReadUShort() 
		Record["item15"] := Bin.Read(4) 
		Record["item15loc"] := Bin.ReadUChar() 
		Record["item15count"] := Bin.ReadUChar() 
		Record["iPadding59"] := Bin.ReadUShort()
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		Kill=Skill|9,SkillLevel|9
		RecordKill(Record,kill,0)
		
		Kill=item$|15
		KillDepend=item$loc,item$count
		RecordKill(Record,kill,0,KillDepend,,"$")
		
		
		InsertQuick("DigestDB","Decompile | " module,Record)		
		
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}