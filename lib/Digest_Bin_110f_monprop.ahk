;complete
Digest_Bin_110f_monprop(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 312

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 312
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Id"] := Bin.ReadUInt() 
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
		Record["prop1 (N)"] := Bin.ReadInt() 
		Record["par1 (N)"] := Bin.ReadInt() 
		Record["min1 (N)"] := Bin.ReadInt() 
		Record["max1 (N)"] := Bin.ReadInt() 
		Record["prop2 (N)"] := Bin.ReadInt() 
		Record["par2 (N)"] := Bin.ReadInt() 
		Record["min2 (N)"] := Bin.ReadInt() 
		Record["max2 (N)"] := Bin.ReadInt() 
		Record["prop3 (N)"] := Bin.ReadInt() 
		Record["par3 (N)"] := Bin.ReadInt() 
		Record["min3 (N)"] := Bin.ReadInt() 
		Record["max3 (N)"] := Bin.ReadInt() 
		Record["prop4 (N)"] := Bin.ReadInt() 
		Record["par4 (N)"] := Bin.ReadInt() 
		Record["min4 (N)"] := Bin.ReadInt() 
		Record["max4 (N)"] := Bin.ReadInt() 
		Record["prop5 (N)"] := Bin.ReadInt() 
		Record["par5 (N)"] := Bin.ReadInt() 
		Record["min5 (N)"] := Bin.ReadInt() 
		Record["max5 (N)"] := Bin.ReadInt() 
		Record["prop6 (N)"] := Bin.ReadInt() 
		Record["par6 (N)"] := Bin.ReadInt() 
		Record["min6 (N)"] := Bin.ReadInt() 
		Record["max6 (N)"] := Bin.ReadInt() 
		Record["prop1 (H)"] := Bin.ReadInt() 
		Record["par1 (H)"] := Bin.ReadInt() 
		Record["min1 (H)"] := Bin.ReadInt() 
		Record["max1 (H)"] := Bin.ReadInt() 
		Record["prop2 (H)"] := Bin.ReadInt() 
		Record["par2 (H)"] := Bin.ReadInt() 
		Record["min2 (H)"] := Bin.ReadInt() 
		Record["max2 (H)"] := Bin.ReadInt() 
		Record["prop3 (H)"] := Bin.ReadInt() 
		Record["par3 (H)"] := Bin.ReadInt() 
		Record["min3 (H)"] := Bin.ReadInt() 
		Record["max3 (H)"] := Bin.ReadInt() 
		Record["prop4 (H)"] := Bin.ReadInt() 
		Record["par4 (H)"] := Bin.ReadInt() 
		Record["min4 (H)"] := Bin.ReadInt() 
		Record["max4 (H)"] := Bin.ReadInt() 
		Record["prop5 (H)"] := Bin.ReadInt() 
		Record["par5 (H)"] := Bin.ReadInt() 
		Record["min5 (H)"] := Bin.ReadInt() 
		Record["max5 (H)"] := Bin.ReadInt() 
		Record["prop6 (H)"] := Bin.ReadInt() 
		Record["par6 (H)"] := Bin.ReadInt() 
		Record["min6 (H)"] := Bin.ReadInt() 
		Record["max6 (H)"] := Bin.ReadInt() 
		Record["chance1"] := Bin.ReadUChar() 
		Record["chance2"] := Bin.ReadUChar() 
		Record["chance3"] := Bin.ReadUChar() 
		Record["chance4"] := Bin.ReadUChar() 
		Record["chance5"] := Bin.ReadUChar() 
		Record["chance6"] := Bin.ReadUChar() 
		Record["chance1 (N)"] := Bin.ReadUChar() 
		Record["chance2 (N)"] := Bin.ReadUChar() 
		Record["chance3 (N)"] := Bin.ReadUChar() 
		Record["chance4 (N)"] := Bin.ReadUChar() 
		Record["chance5 (N)"] := Bin.ReadUChar() 
		Record["chance6 (N)"] := Bin.ReadUChar() 
		Record["chance1 (H)"] := Bin.ReadUChar() 
		Record["chance2 (H)"] := Bin.ReadUChar() 
		Record["chance3 (H)"] := Bin.ReadUChar() 
		Record["chance4 (H)"] := Bin.ReadUChar() 
		Record["chance5 (H)"] := Bin.ReadUChar() 
		Record["chance6 (H)"] := Bin.ReadUChar() 
		Record["iPadding77"] := Bin.ReadUShort()
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