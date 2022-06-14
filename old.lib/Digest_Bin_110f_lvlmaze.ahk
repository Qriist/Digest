;complete
Digest_Bin_110f_lvlmaze(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 28
	
	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 28
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Level"] := Bin.ReadUInt() 
		Record["Rooms"] := Bin.ReadUInt() 
		Record["Rooms(N)"] := Bin.ReadUInt() 
		Record["Rooms(H)"] := Bin.ReadUInt() 
		Record["SizeX"] := Bin.ReadUInt() 
		Record["SizeY"] := Bin.ReadUInt() 
		Record["Merge"] := Bin.ReadUInt()
		
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		InsertQuick("DigestDB","Decompile | " module,Record)		
		
		
	}
}