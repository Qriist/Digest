;complete
Digest_Bin_110f_superuniques(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 52
	
	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 52
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["wHcIdx"] := Bin.ReadUShort() 
		Record["Name"] := Bin.ReadUShort() 
		Record["Class"] := Bin.ReadUInt() 
		Record["hcIdx"] := Bin.ReadUInt() 
		Record["Mod1"] := Bin.ReadUInt() 
		Record["Mod2"] := Bin.ReadUInt() 
		Record["Mod3"] := Bin.ReadUInt() 
		Record["MonSound"] := Bin.ReadUInt() 
		Record["MinGrp"] := Bin.ReadUInt() 
		Record["MaxGrp"] := Bin.ReadUInt() 
		Record["AutoPos"] := Bin.ReadUChar() 
		Record["EClass"] := Bin.ReadUChar() 
		Record["Stacks"] := Bin.ReadUChar() 
		Record["Replaceable"] := Bin.ReadUChar() 
		Record["Utrans"] := Bin.ReadUChar() 
		Record["Utrans(N)"] := Bin.ReadUChar() 
		Record["Utrans(H)"] := Bin.ReadUChar() 
		Record["iPadding10"] := Bin.ReadUChar() 
		Record["TC"] := Bin.ReadUShort() 
		Record["TC(N)"] := Bin.ReadUShort() 
		Record["TC(H)"] := Bin.ReadUShort() 
		Record["iPadding12"] := Bin.ReadUShort()
		
		
		InsertQuick("DigestDB","Decompile | " module,Record)		
		
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}