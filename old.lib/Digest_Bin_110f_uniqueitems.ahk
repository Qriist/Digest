;complete
Digest_Bin_110f_uniqueitems(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 332
	
	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 332
		;BITFIELDS ARE PRESENT!
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["iPadding0"] := Bin.ReadUShort() 
		Record["index"] := Bin.Read(32) 
		Record["iPadding8"] := Bin.ReadUShort() 
		Record["version"] := Bin.ReadUInt() 
		Record["code"] := Bin.Read(4) 
		Record["BitCombined"] := Bin.ReadUChar() 
		
		;Start bitfield operations
		Flags := Record["BitCombined"]
		;~ If Flags = 
		;~ msgbox,YOU HAVE NOT FIXED THE BITFIELDS FOR MODULE %module%.
		Record["iPadding11"] := substr(Flags,4,4) 
		Record["ladder"] := substr(Flags,5,1) 
		Record["carry1"] := substr(Flags,6,1) 
		Record["nolimit"] := substr(Flags,7,1) 
		Record["enabled"] := substr(Flags,8,1) 
		Record["iPadding11"] := Trim(Bin.Read(3))
		Record["rarity"] := Bin.ReadUInt() 
		Record["lvl"] := Bin.ReadUShort() 
		Record["lvl req"] := Bin.ReadUShort() 
		Record["chrtransform"] := Bin.ReadUChar() 
		Record["invtransform"] := Bin.ReadUChar() 
		Record["flippyfile"] := Trim(Bin.Read(32))
		Record["invfile"] := Trim(Bin.Read(32))
		Record["iPadding30"] := Bin.ReadUShort() 
		Record["cost mult"] := Bin.ReadUInt() 
		Record["cost add"] := Bin.ReadUInt() 
		Record["dropsound"] := Bin.ReadUShort() 
		Record["usesound"] := Bin.ReadUShort() 
		Record["dropsfxframe"] := Bin.ReadUInt() 
		Record["prop1"] := Bin.ReadInt() 
		Record["par1"] := Bin.ReadInt() 
		Record["min1"] := Bin.ReadInt() 
		Record["max1"] := Bin.ReadInt() 
		Record["prop2"] := Bin.ReadInt() 
		Record["par2"] := Bin.ReadInt() 
		Record["min2"] := Bin.ReadInt() 
		Record["max2"] := Bin.ReadInt() 
		Record["prop3"] := Bin.ReadInt() 
		Record["par3"] := Bin.ReadInt() 
		Record["min3"] := Bin.ReadInt() 
		Record["max3"] := Bin.ReadInt() 
		Record["prop4"] := Bin.ReadInt() 
		Record["par4"] := Bin.ReadInt() 
		Record["min4"] := Bin.ReadInt() 
		Record["max4"] := Bin.ReadInt() 
		Record["prop5"] := Bin.ReadInt() 
		Record["par5"] := Bin.ReadInt() 
		Record["min5"] := Bin.ReadInt() 
		Record["max5"] := Bin.ReadInt() 
		Record["prop6"] := Bin.ReadInt() 
		Record["par6"] := Bin.ReadInt() 
		Record["min6"] := Bin.ReadInt() 
		Record["max6"] := Bin.ReadInt() 
		Record["prop7"] := Bin.ReadInt() 
		Record["par7"] := Bin.ReadInt() 
		Record["min7"] := Bin.ReadInt() 
		Record["max7"] := Bin.ReadInt() 
		Record["prop8"] := Bin.ReadInt() 
		Record["par8"] := Bin.ReadInt() 
		Record["min8"] := Bin.ReadInt() 
		Record["max8"] := Bin.ReadInt() 
		Record["prop9"] := Bin.ReadInt() 
		Record["par9"] := Bin.ReadInt() 
		Record["min9"] := Bin.ReadInt() 
		Record["max9"] := Bin.ReadInt() 
		Record["prop10"] := Bin.ReadInt() 
		Record["par10"] := Bin.ReadInt() 
		Record["min10"] := Bin.ReadInt() 
		Record["max10"] := Bin.ReadInt() 
		Record["prop11"] := Bin.ReadInt() 
		Record["par11"] := Bin.ReadInt() 
		Record["min11"] := Bin.ReadInt() 
		Record["max11"] := Bin.ReadInt() 
		Record["prop12"] := Bin.ReadInt() 
		Record["par12"] := Bin.ReadInt() 
		Record["min12"] := Bin.ReadInt() 
		Record["max12"] := Bin.ReadInt()
		
		Kill=iPadding30,iPadding0
		RecordKill(Record,kill,0)
		
		Kill=iPadding11
		RecordKill(Record,kill,"")
		
		Kill=prop|12
		killdepend=par,min,max
		RecordKill(Record,kill,-1,killdepend)
		
		InsertQuick("DigestDB","Decompile | " module,Record)		
		
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}