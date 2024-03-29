;complete
Digest_Bin_110f_setitems(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 440
	
	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 440
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["wSetItemId"] := Bin.ReadUShort() 
		Record["index"] := Trim(Bin.Read(32))
		Record["iPadding8"] := Bin.ReadUShort() 
		Record["dwTblIndex"] := Bin.ReadUInt() 
		Record["item"] := Trim(Bin.Read(4))
		Record["set"] := Bin.ReadUInt() 
		Record["lvl"] := Bin.ReadUShort() 
		Record["lvl req"] := Bin.ReadUShort() 
		Record["rarity"] := Bin.ReadUInt() 
		Record["cost mult"] := Bin.ReadUInt() 
		Record["cost add"] := Bin.ReadUInt() 
		Record["chrtransform"] := Bin.ReadUChar() 
		Record["invtransform"] := Bin.ReadUChar() 
		Record["flippyfile"] := Trim(Bin.Read(32))
		Record["invfile"] := Trim(Bin.Read(32))
		Record["dropsound"] := Bin.ReadUShort() 
		Record["usesound"] := Bin.ReadUShort() 
		Record["dropsfxframe"] := Bin.ReadUChar() 
		Record["add func"] := Bin.ReadUChar() 
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
		Record["aprop1a"] := Bin.ReadInt() 
		Record["apar1a"] := Bin.ReadInt() 
		Record["amin1a"] := Bin.ReadInt() 
		Record["amax1a"] := Bin.ReadInt() 
		Record["aprop1b"] := Bin.ReadInt() 
		Record["apar1b"] := Bin.ReadInt() 
		Record["amin1b"] := Bin.ReadInt() 
		Record["amax1b"] := Bin.ReadInt() 
		Record["aprop2a"] := Bin.ReadInt() 
		Record["apar2a"] := Bin.ReadInt() 
		Record["amin2a"] := Bin.ReadInt() 
		Record["amax2a"] := Bin.ReadInt() 
		Record["aprop2b"] := Bin.ReadInt() 
		Record["apar2b"] := Bin.ReadInt() 
		Record["amin2b"] := Bin.ReadInt() 
		Record["amax2b"] := Bin.ReadInt() 
		Record["aprop3a"] := Bin.ReadInt() 
		Record["apar3a"] := Bin.ReadInt() 
		Record["amin3a"] := Bin.ReadInt() 
		Record["amax3a"] := Bin.ReadInt() 
		Record["aprop3b"] := Bin.ReadInt() 
		Record["apar3b"] := Bin.ReadInt() 
		Record["amin3b"] := Bin.ReadInt() 
		Record["amax3b"] := Bin.ReadInt() 
		Record["aprop4a"] := Bin.ReadInt() 
		Record["apar4a"] := Bin.ReadInt() 
		Record["amin4a"] := Bin.ReadInt() 
		Record["amax4a"] := Bin.ReadInt() 
		Record["aprop4b"] := Bin.ReadInt() 
		Record["apar4b"] := Bin.ReadInt() 
		Record["amin4b"] := Bin.ReadInt() 
		Record["amax4b"] := Bin.ReadInt() 
		Record["aprop5a"] := Bin.ReadInt() 
		Record["apar5a"] := Bin.ReadInt() 
		Record["amin5a"] := Bin.ReadInt() 
		Record["amax5a"] := Bin.ReadInt() 
		Record["aprop5b"] := Bin.ReadInt() 
		Record["apar5b"] := Bin.ReadInt() 
		Record["amin5b"] := Bin.ReadInt() 
		Record["amax5b"] := Bin.ReadInt()
		
		InsertQuick("DigestDB","Decompile | " module,Record)		
		
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}