;complete
Digest_Bin_110f_montype(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 12
	
	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 12
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["ModNum"] := ModNum ; For DBA
		Record["RecordID"] := RecordID ; For DBA
		Record["iPadding0"] := Bin.ReadUShort() 
		Record["equiv1"] := Bin.ReadUShort() 
		Record["equiv2"] := Bin.ReadUShort() 
		Record["equiv3"] := Bin.ReadUShort() 
		Record["strsing"] := Bin.ReadUShort() 
		Record["strplur"] := Bin.ReadUShort()
		
		InsertQuick("DigestDB","Decompile | " module,Record)		
		
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}