;complete
Digest_Bin_110f_belts(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 264
	
	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 264
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Id"] := Bin.ReadUInt() 
		Record["numboxes"] := Bin.ReadUInt() 
		Loop,16
		{
			Record["box" a_index "left"] := Bin.ReadUInt() 
			Record["box" a_index "right"] := Bin.ReadUInt() 
			Record["box" a_index "top"] := Bin.ReadUInt() 
			Record["box" a_index "bottom"] := Bin.ReadUInt() 
		}
		
		Kill := "Id,"
			. "box$left|16,"
			. "box$right|16,"
			. "box$top|16,"
			. "box$bottom|16"
		RecordKill(Record,Kill,0,,"$")
		InsertQuick("DigestDB","Decompile | " module,Record)		
		
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}