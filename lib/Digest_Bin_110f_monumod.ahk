;complete
Digest_Bin_110f_monumod(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 32
	
	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 32
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["id"] := Bin.ReadUInt() 
		Record["version"] := Bin.ReadUShort() 
		Record["enabled"] := Bin.ReadUChar() 
		Record["xfer"] := Bin.ReadUChar() 
		Record["champion"] := Bin.ReadUChar() 
		Record["fPick"] := Bin.ReadUChar() 
		Record["exclude1"] := Bin.ReadUShort() 
		Record["exclude2"] := Bin.ReadUShort() 
		Record["cpick"] := Bin.ReadUShort() 
		Record["cpick (N)"] := Bin.ReadUShort() 
		Record["cpick (H)"] := Bin.ReadUShort() 
		Record["upick"] := Bin.ReadUShort() 
		Record["upick (N)"] := Bin.ReadUShort() 
		Record["upick (H)"] := Bin.ReadUShort() 
		Record["iPadding6"] := Bin.ReadUShort() 
		Record["constants"] := Bin.ReadUInt()
		
		
		InsertQuick("DigestDB","Decompile | " module,Record)		
		
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}