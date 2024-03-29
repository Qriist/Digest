;complete
Digest_Bin_110f_difficultylevels(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 88
	
	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 88
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["ResistPenalty"] := Bin.ReadInt() 
		Record["DeathExpPenalty"] := Bin.ReadUInt() 
		Record["UberCodeOddsNormal"] := Bin.ReadUInt() 
		Record["UberCodeOddsGood"] := Bin.ReadUInt() 
		Record["MonsterSkillBonus"] := Bin.ReadUInt() 
		Record["MonsterFreezeDivisor"] := Bin.ReadUInt() 
		Record["MonsterColdDivisor"] := Bin.ReadUInt() 
		Record["AiCurseDivisor"] := Bin.ReadUInt() 
		Record["UltraCodeOddsNormal"] := Bin.ReadUInt() 
		Record["UltraCodeOddsGood"] := Bin.ReadUInt() 
		Record["LifeStealDivisor"] := Bin.ReadUInt() 
		Record["ManaStealDivisor"] := Bin.ReadUInt() 
		Record["UniqueDamageBonus"] := Bin.ReadUInt() 
		Record["ChampionDamageBonus"] := Bin.ReadUInt() 
		Record["HireableBossDamagePercent"] := Bin.ReadUInt() 
		Record["MonsterCEDamagePercent"] := Bin.ReadUInt() 
		Record["StaticFieldMin"] := Bin.ReadUInt() 
		Record["GambleRare"] := Bin.ReadUInt() 
		Record["GambleSet"] := Bin.ReadUInt() 
		Record["GambleUnique"] := Bin.ReadUInt() 
		Record["GambleUber"] := Bin.ReadUInt() 
		Record["GambleUltra"] := Bin.ReadUInt()
		
		InsertQuick("DigestDB","Decompile | " module,Record)		
		
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}