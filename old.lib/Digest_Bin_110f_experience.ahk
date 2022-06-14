;complete
Digest_Bin_110f_experience(BinToDecompile)
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
		Record["Amazon"] := Bin.ReadUInt() 
		Record["Sorceress"] := Bin.ReadUInt() 
		Record["Necromancer"] := Bin.ReadUInt() 
		Record["Paladin"] := Bin.ReadUInt() 
		Record["Barbarian"] := Bin.ReadUInt() 
		Record["Druid"] := Bin.ReadUInt() 
		Record["Assassin"] := Bin.ReadUInt() 
		Record["ExpRatio"] := Bin.ReadUInt()
		
		InsertQuick("DigestDB","Decompile | " module,Record)		
		
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}