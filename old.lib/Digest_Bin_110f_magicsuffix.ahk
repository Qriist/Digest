;complete
Digest_Bin_110f_magicsuffix(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 144
	
	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 144
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Name"] := Bin.Read(32) 
		Record["iPadding8"] := Bin.ReadUShort() 
		Record["version"] := Bin.ReadUShort() 
		Record["mod1code"] := Bin.ReadUInt() 
		Record["mod1param"] := Bin.ReadInt() 
		Record["mod1min"] := Bin.ReadInt() 
		Record["mod1max"] := Bin.ReadInt() 
		Record["mod2code"] := Bin.ReadUInt() 
		Record["mod2param"] := Bin.ReadInt() 
		Record["mod2min"] := Bin.ReadInt() 
		Record["mod2max"] := Bin.ReadInt() 
		Record["mod3code"] := Bin.ReadUInt() 
		Record["mod3param"] := Bin.ReadInt() 
		Record["mod3min"] := Bin.ReadInt() 
		Record["mod3max"] := Bin.ReadInt() 
		Record["spawnable"] := Bin.ReadUShort() 
		Record["transformcolor"] := Bin.ReadUShort() 
		Record["level"] := Bin.ReadUShort() 
		Record["iPadding22"] := Bin.ReadUShort() 
		Record["group"] := Bin.ReadUInt() 
		Record["maxlevel"] := Bin.ReadUInt() 
		Record["rare"] := Bin.ReadUChar() 
		Record["levelreq"] := Bin.ReadUChar() 
		Record["classspecific"] := Bin.ReadUChar() 
		Record["class"] := Bin.ReadUChar() 
		Record["classlevelreq"] := Bin.ReadUShort() 
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
		Record["etype5"] := Bin.ReadUShort() 
		Record["frequency"] := Bin.ReadUShort() 
		Record["divide"] := Bin.ReadUInt() 
		Record["multiply"] := Bin.ReadUInt() 
		Record["add"] := Bin.ReadUInt()
		
		
		Kill=itype|7,etype|5
		RecordKill(Record,kill,0)
		
		Kill=itype|7,etype|5
		RecordKill(Record,kill,65535)
		
		Kill=mod$code|15
		KillDepend=mod$param,mod$min,mod$max
		RecordKill(Record,kill,4294967295,KillDepend,,"$")
		
		
		InsertQuick("DigestDB","Decompile | " module,Record)		
		
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}