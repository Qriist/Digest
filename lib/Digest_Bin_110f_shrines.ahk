;complete
Digest_Bin_110f_shrines(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 184

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 184
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Code"] := Bin.ReadUInt() 
		Record["Arg0"] := Bin.ReadUInt() 
		Record["Arg1"] := Bin.ReadUInt() 
		Record["Duration in frames"] := Bin.ReadUInt() 
		Record["reset time in minutes"] := Bin.ReadUChar() 
		Record["rarity"] := Bin.ReadUChar() 
		Record["view name"] :=Trim(Bin.Read(32))
		Record["niftyphrase"] := Trim(Bin.Read(32))
		Bin.Read(96)
		Record["iPadding20"] := Bin.ReadUShort()
		Record["iPadding21"] := Bin.ReadUInt() 
		Record["iPadding22"] := Bin.ReadUInt() 
		Record["iPadding23"] := Bin.ReadUInt() 
		Record["iPadding24"] := Bin.ReadUInt() 
		Record["iPadding25"] := Bin.ReadUInt() 
		Record["iPadding26"] := Bin.ReadUInt() 
		Record["iPadding27"] := Bin.ReadUInt() 
		Record["iPadding28"] := Bin.ReadUInt() 
		Record["iPadding29"] := Bin.ReadUInt() 
		Record["iPadding30"] := Bin.ReadUInt() 
		Record["iPadding31"] := Bin.ReadUInt() 
		Record["iPadding32"] := Bin.ReadUInt() 
		Record["iPadding33"] := Bin.ReadUInt() 
		Record["iPadding34"] := Bin.ReadUInt() 
		Record["iPadding35"] := Bin.ReadUInt() 
		Record["iPadding36"] := Bin.ReadUInt() 
		Record["iPadding37"] := Bin.ReadUInt() 
		Record["iPadding38"] := Bin.ReadUInt() 
		Record["iPadding39"] := Bin.ReadUInt() 
		Record["iPadding40"] := Bin.ReadUInt() 
		Record["iPadding41"] := Bin.ReadUInt() 
		Record["iPadding42"] := Bin.ReadUInt() 
		Record["iPadding43"] := Bin.ReadUInt() 
		Record["iPadding44"] := Bin.ReadUShort() 
		Record["effectclass"] := Bin.ReadUShort() 
		Record["LevelMin"] := Bin.ReadUShort() 
		Record["iPadding45"] := 
Bin.ReadUShort()
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