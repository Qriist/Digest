;complete
Digest_Bin_110f_runes(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Seek(4)
	RecordSize := 288

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 288
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Name"] := Trim(Bin.Read(64))
		Record["Rune Name"] := Trim(Bin.Read(64))
		Record["complete"] := Bin.ReadUChar() 
		Record["server"] := Bin.ReadUChar() 
		Record["iPadding32"] := Bin.ReadUShort() 
		Record["iPadding33"] := Bin.ReadUShort() 

		Record["itype1"] := Bin.ReadUShort() 
		Record["itype2"] := Bin.ReadUShort() 
		Record["itype3"] := Bin.ReadUShort() 
		Record["itype4"] := Bin.ReadUShort() 
		Record["itype5"] := Bin.ReadUShort() 
		Record["itype6"] := Bin.ReadUShort() 
		Record["etype1"] := Bin.ReadUShort() 
		Record["etype2"] := Bin.ReadUShort() 
		Record["etype3"] := Bin.ReadUShort() 
		Record["Rune1"] := Bin.ReadUInt() 
		Record["Rune2"] := Bin.ReadUInt() 
		Record["Rune3"] := Bin.ReadUInt() 
		Record["Rune4"] := Bin.ReadUInt() 
		Record["Rune5"] := Bin.ReadUInt() 
		Record["Rune6"] := Bin.ReadUInt() 
		Record["T1Code1"] := Bin.ReadInt() 
		Record["T1Param1"] := Bin.ReadInt() 
		Record["T1Min1"] := Bin.ReadInt() 
		Record["T1Max1"] := Bin.ReadInt() 
		Record["T1Code2"] := Bin.ReadInt() 
		Record["T1Param2"] := Bin.ReadInt() 
		Record["T1Min2"] := Bin.ReadInt() 
		Record["T1Max2"] := Bin.ReadInt() 
		Record["T1Code3"] := Bin.ReadInt() 
		Record["T1Param3"] := Bin.ReadInt() 
		Record["T1Min3"] := Bin.ReadInt() 
		Record["T1Max3"] := Bin.ReadInt() 
		Record["T1Code4"] := Bin.ReadInt() 
		Record["T1Param4"] := Bin.ReadInt() 
		Record["T1Min4"] := Bin.ReadInt() 
		Record["T1Max4"] := Bin.ReadInt() 
		Record["T1Code5"] := Bin.ReadInt() 
		Record["T1Param5"] := Bin.ReadInt() 
		Record["T1Min5"] := Bin.ReadInt() 
		Record["T1Max5"] := Bin.ReadInt() 
		Record["T1Code6"] := Bin.ReadInt() 
		Record["T1Param6"] := Bin.ReadInt() 
		Record["T1Min6"] := Bin.ReadInt() 
		Record["T1Max6"] := Bin.ReadInt() 
		Record["T1Code7"] := Bin.ReadInt() 
		Record["T1Param7"] := Bin.ReadInt() 
		Record["T1Min7"] := Bin.ReadInt() 
		Record["T1Max7"] := Bin.ReadInt()
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		
		kill=itype|6,etype|3,server,complete
		RecordKill(Record,kill,0)
		
		kill=Rune|6
		RecordKill(Record,kill,4294967295)
		
		kill=T1Code|7
		killdepend=T1Param,T1Min,T1Max
		RecordKill(Record,kill,-1,killdepend)
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}