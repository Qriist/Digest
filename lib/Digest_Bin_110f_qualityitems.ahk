;complete
Digest_Bin_110f_qualityitems(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 112
	
	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 112
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["armor"] := Bin.ReadUChar() 
		Record["weapon"] := Bin.ReadUChar() 
		Record["shield"] := Bin.ReadUChar() 
		Record["scepter"] := Bin.ReadUChar() 
		Record["wand"] := Bin.ReadUChar() 
		Record["staff"] := Bin.ReadUChar() 
		Record["bow"] := Bin.ReadUChar() 
		Record["boots"] := Bin.ReadUChar() 
		Record["gloves"] := Bin.ReadUChar() 
		Record["belt"] := Bin.ReadUChar() 
		Record["nummods"] := Bin.ReadUChar() 
		Record["iPadding2"] := Bin.ReadUChar() 
		Record["mod1code"] := Bin.ReadUInt() 
		Record["mod1param"] := Bin.ReadUInt() 
		Record["mod1min"] := Bin.ReadUInt() 
		Record["mod1max"] := Bin.ReadUInt() 
		Record["mod2code"] := Bin.ReadUInt() 
		Record["mod2param"] := Bin.ReadUInt() 
		Record["mod2min"] := Bin.ReadUInt() 
		Record["mod2max"] := Bin.ReadUInt() 
		Record["effect1"] := Trim(Bin.Read(32))
		Record["effect2"] := Trim(Bin.Read(32))
		Record["iPadding27"] := Bin.ReadUInt()
		
		
		InsertQuick("DigestDB","Decompile | " module,Record)		
		
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}