;complete
Digest_Bin_110f_objgroup(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 52

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 52
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["ID0"] := Bin.ReadUInt() 
		Record["ID1"] := Bin.ReadUInt() 
		Record["ID2"] := Bin.ReadUInt() 
		Record["ID3"] := Bin.ReadUInt() 
		Record["ID4"] := Bin.ReadUInt() 
		Record["ID5"] := Bin.ReadUInt() 
		Record["ID6"] := Bin.ReadUInt() 
		Record["ID7"] := Bin.ReadUInt() 
		Record["DENSITY0"] := Bin.ReadUChar() 
		Record["DENSITY1"] := Bin.ReadUChar() 
		Record["DENSITY2"] := Bin.ReadUChar() 
		Record["DENSITY3"] := Bin.ReadUChar() 
		Record["DENSITY4"] := Bin.ReadUChar() 
		Record["DENSITY5"] := Bin.ReadUChar() 
		Record["DENSITY6"] := Bin.ReadUChar() 
		Record["DENSITY7"] := Bin.ReadUChar() 
		Record["PROB0"] := Bin.ReadUChar() 
		Record["PROB1"] := Bin.ReadUChar() 
		Record["PROB2"] := Bin.ReadUChar() 
		Record["PROB3"] := Bin.ReadUChar() 
		Record["PROB4"] := Bin.ReadUChar() 
		Record["PROB5"] := Bin.ReadUChar() 
		Record["PROB6"] := Bin.ReadUChar() 
		Record["PROB7"] := Bin.ReadUChar() 
		Record["SHRINES"] := Bin.ReadUChar() 
		Record["WELLS"] := Bin.ReadUChar() 
		Record["iPadding12"] := Bin.ReadUShort()
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		
		Kill=ID|8,DENSITY|8,PROB|8,SHRINES,WELLS,iPadding12
		RecordKill(Record,kill,0,,-1)
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}