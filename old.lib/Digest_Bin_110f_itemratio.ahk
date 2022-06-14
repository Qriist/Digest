;complete
Digest_Bin_110f_itemratio(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 68
	
	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 68
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Unique"] := Bin.ReadUInt() 
		Record["UniqueDivisor"] := Bin.ReadUInt() 
		Record["UniqueMin"] := Bin.ReadUInt() 
		Record["Rare"] := Bin.ReadUInt() 
		Record["RareDivisor"] := Bin.ReadUInt() 
		Record["RareMin"] := Bin.ReadUInt() 
		Record["Set"] := Bin.ReadUInt() 
		Record["SetDivisor"] := Bin.ReadUInt() 
		Record["SetMin"] := Bin.ReadUInt() 
		Record["Magic"] := Bin.ReadUInt() 
		Record["MagicDivisor"] := Bin.ReadUInt() 
		Record["MagicMin"] := Bin.ReadUInt() 
		Record["HiQuality"] := Bin.ReadUInt() 
		Record["HiQualityDivisor"] := Bin.ReadUInt() 
		Record["Normal"] := Bin.ReadUInt() 
		Record["NormalDivisor"] := Bin.ReadUInt() 
		Record["Version"] := Bin.ReadUShort() 
		Record["Uber"] := Bin.ReadUChar() 
		Record["Class Specific"] := Bin.ReadUChar()
		
		InsertQuick("DigestDB","Decompile | " module,Record)		
		
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}