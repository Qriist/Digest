;complete
Digest_Bin_110f_books(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 32

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 32
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Name"] := Bin.ReadUShort() 
		Record["SpellIcon"] := Bin.ReadChar() 
		Record["iPadding0"] := Bin.ReadUChar() 
		Record["pSpell"] := Bin.ReadUInt() 
		Record["ScrollSkill"] := Bin.ReadUInt() 
		Record["BookSkill"] := Bin.ReadUInt() 
		Record["BaseCost"] := Bin.ReadUInt() 
		Record["CostPerCharge"] := Bin.ReadUInt() 
		Record["ScrollSpellCode"] := Bin.Read(4) 
		Record["BookSpellCode"] := Bin.Read(4)
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}