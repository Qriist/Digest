Digest_Bin_110f_pettype(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 224

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 224
		;BITFIELDS ARE PRESENT!
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["idx"] := Bin.ReadUInt() 
		Record["CombinedBit"] := Bin.ReadUChar() 
		
		;Start bitfield operations
		Flags := 
		If Flags = 
		msgbox,YOU HAVE NOT FIXED THE BITFIELDS FOR MODULE %module%.
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		;~ Record["iPadding1"] := substr(Flags,2,2) 
		Record["drawhp"] := substr(Flags,3,1) 
		Record["automap"] := substr(Flags,4,1) 
		Record["unsummon"] := substr(Flags,5,1) 
		Record["partysend"] := substr(Flags,6,1) 
		Record["range"] := substr(Flags,7,1) 
		Record["warp"] := substr(Flags,8,1) 
		;~ Record["iPadding1"] := 
		Bin.Read(3) 
		Record["group"] := Bin.ReadUShort() 
		Record["basemax"] := Bin.ReadUShort() 
		Record["name"] := Bin.ReadUShort() 
		Record["icontype"] := Bin.ReadUChar() 
		Record["baseicon"] := Trim(Bin.Read(32))
		Record["micon1"] := Trim(Bin.Read(32))
		Record["micon2"] := Trim(Bin.Read(32))
		Record["micon3"] := Trim(Bin.Read(32))
		Record["micon4"] := Trim(Bin.Read(32))
		;~ Record["iPadding43"] := 
		Bin.ReadUChar() 
		;~ Record["iPadding44"] := 
		Bin.ReadUShort() 
		Record["mclass1"] := Bin.ReadUShort() 
		Record["mclass2"] := Bin.ReadUShort() 
		Record["mclass3"] := Bin.ReadUShort() 
		Record["mclass4"] := Bin.ReadUShort() 
		;~ Record["iPadding46"] := 
		Bin.ReadUShort() 
		;~ Record["iPadding47"] := 
		Bin.ReadUInt() 
		;~ Record["iPadding48"] := 
		Bin.ReadUInt() 
		;~ Record["iPadding49"] := 
		Bin.ReadUInt() 
		;~ Record["iPadding50"] := 
		Bin.ReadUInt() 
		;~ Record["iPadding51"] := 
		Bin.ReadUInt() 
		;~ Record["iPadding52"] := 
		Bin.ReadUInt() 
		;~ Record["iPadding53"] := 
		Bin.ReadUInt() 
		;~ Record["iPadding54"] := 
		Bin.ReadUInt() 
		;~ Record["iPadding55"] := 
		Bin.ReadUInt()
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