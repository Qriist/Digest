;complete
Digest_Bin_110f_lvlwarp(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 48
	
	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 48
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Id"] := Bin.ReadInt() 
		Record["SelectX"] := Bin.ReadInt() 
		Record["SelectY"] := Bin.ReadInt() 
		Record["SelectDX"] := Bin.ReadInt() 
		Record["SelectDY"] := Bin.ReadInt() 
		Record["ExitWalkX"] := Bin.ReadInt() 
		Record["ExitWalkY"] := Bin.ReadInt() 
		Record["OffsetX"] := Bin.ReadInt() 
		Record["OffsetY"] := Bin.ReadInt() 
		Record["LitVersion"] := Bin.ReadInt() 
		Record["Tiles"] := Bin.ReadInt() 
		Record["Direction"] := Bin.Read(4)
		
		
		InsertQuick("DigestDB","Decompile | " module,Record)		
		
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}