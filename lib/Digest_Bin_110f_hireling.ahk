;complete
Digest_Bin_110f_hireling(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 280
	
	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 280
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Version"] := Bin.ReadUInt() 
		Record["Id"] := Bin.ReadUInt() 
		Record["Class"] := Bin.ReadUInt() 
		Record["Act"] := Bin.ReadUInt() 
		Record["Difficulty"] := Bin.ReadUInt() 
		Record["Seller"] := Bin.ReadUInt() 
		Record["Gold"] := Bin.ReadUInt() 
		Record["Level"] := Bin.ReadUInt() 
		Record["Exp/Lvl"] := Bin.ReadUInt() 
		Record["HP"] := Bin.ReadUInt() 
		Record["HP/Lvl"] := Bin.ReadUInt() 
		Record["Defense"] := Bin.ReadUInt() 
		Record["Def/Lvl"] := Bin.ReadUInt() 
		Record["Str"] := Bin.ReadUInt() 
		Record["Str/Lvl"] := Bin.ReadUInt() 
		Record["Dex"] := Bin.ReadUInt() 
		Record["Dex/Lvl"] := Bin.ReadUInt() 
		Record["AR"] := Bin.ReadUInt() 
		Record["AR/Lvl"] := Bin.ReadUInt() 
		Record["Share"] := Bin.ReadUInt() 
		Record["Dmg-Min"] := Bin.ReadUInt() 
		Record["Dmg-Max"] := Bin.ReadUInt() 
		Record["Dmg/Lvl"] := Bin.ReadUInt() 
		Record["Resist"] := Bin.ReadUInt() 
		Record["Resist/Lvl"] := Bin.ReadUInt() 
		Record["DefaultChance"] := Bin.ReadUInt() 
		Record["Head"] := Bin.ReadUInt() 
		Record["Torso"] := Bin.ReadUInt() 
		Record["Weapon"] := Bin.ReadUInt() 
		Record["Shield"] := Bin.ReadUInt() 
		Record["Skill1"] := Bin.ReadUInt() 
		Record["Skill2"] := Bin.ReadUInt() 
		Record["Skill3"] := Bin.ReadUInt() 
		Record["Skill4"] := Bin.ReadUInt() 
		Record["Skill5"] := Bin.ReadUInt() 
		Record["Skill6"] := Bin.ReadUInt() 
		Record["Chance1"] := Bin.ReadUInt() 
		Record["Chance2"] := Bin.ReadUInt() 
		Record["Chance3"] := Bin.ReadUInt() 
		Record["Chance4"] := Bin.ReadUInt() 
		Record["Chance5"] := Bin.ReadUInt() 
		Record["Chance6"] := Bin.ReadUInt() 
		Record["ChancePerLvl1"] := Bin.ReadUInt() 
		Record["ChancePerLvl2"] := Bin.ReadUInt() 
		Record["ChancePerLvl3"] := Bin.ReadUInt() 
		Record["ChancePerLvl4"] := Bin.ReadUInt() 
		Record["ChancePerLvl5"] := Bin.ReadUInt() 
		Record["ChancePerLvl6"] := Bin.ReadUInt() 
		Record["Mode1"] := Bin.ReadUChar() 
		Record["Mode2"] := Bin.ReadUChar() 
		Record["Mode3"] := Bin.ReadUChar() 
		Record["Mode4"] := Bin.ReadUChar() 
		Record["Mode5"] := Bin.ReadUChar() 
		Record["Mode6"] := Bin.ReadUChar() 
		Record["Level1"] := Bin.ReadUChar() 
		Record["Level2"] := Bin.ReadUChar() 
		Record["Level3"] := Bin.ReadUChar() 
		Record["Level4"] := Bin.ReadUChar() 
		Record["Level5"] := Bin.ReadUChar() 
		Record["Level6"] := Bin.ReadUChar() 
		Record["LvlPerLvl1"] := Bin.ReadUChar() 
		Record["LvlPerLvl2"] := Bin.ReadUChar() 
		Record["LvlPerLvl3"] := Bin.ReadUChar() 
		Record["LvlPerLvl4"] := Bin.ReadUChar() 
		Record["LvlPerLvl5"] := Bin.ReadUChar() 
		Record["LvlPerLvl6"] := Bin.ReadUChar() 
		Record["HireDesc"] := Bin.ReadUChar() 
		Record["NameFirst"] := Trim(Bin.Read(32))
		Record["NameLast"] := Trim(Bin.Read(37))
		
		InsertQuick("DigestDB","Decompile | " module,Record)		
		
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}