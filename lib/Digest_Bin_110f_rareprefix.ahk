;complete
Digest_Bin_110f_rareprefix(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 72

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 72
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["iPadding0"] := Bin.ReadUInt() 
		Record["iPadding1"] := Bin.ReadUInt() 
		Record["iPadding2"] := Bin.ReadUInt() 
		Record["iPadding3"] := Bin.ReadUShort() 
		Record["version"] := Bin.ReadUShort() 
		Record["itype1"] := Bin.ReadUShort() 
		Record["itype2"] := Bin.ReadUShort() 
		Record["itype3"] := Bin.ReadUShort() 
		Record["itype4"] := Bin.ReadUShort() 
		Record["itype5"] := Bin.ReadUShort() 
		Record["itype6"] := Bin.ReadUShort() 
		Record["itype7"] := Bin.ReadUShort() 
		Record["etype1"] := Bin.ReadUShort() 
		Record["etype2"] := Bin.ReadUShort() 
		Record["etype3"] := Bin.ReadUShort() 
		Record["etype4"] := Bin.ReadUShort() 
		Record["name"] := Trim(Bin.Read(32))
		Record["iPadding17"] := Bin.ReadUShort()
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		Kill=itype|7,etype|4
		RecordKill(Record,kill,0)
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}