;complete
Digest_Bin_110f_lvltypes(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 1928
	
	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 1928
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Loop,32
			Record["File " a_index] := Bin.Read(60) 
		Record["Act"] := Bin.ReadUInt() 
		Record["Expansion"] := Bin.ReadUInt()
		
		Kill=File |32
		RecordKill(Record,Kill,0)
		
		InsertQuick("DigestDB","Decompile | " module,Record)		
		
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}