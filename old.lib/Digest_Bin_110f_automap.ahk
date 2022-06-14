;complete
Digest_Bin_110f_automap(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 44
	
	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 44
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["LevelName"] := Trim(Bin.Read(16))
		Record["TileName"] := Trim(Bin.Read(8))
		Record["Style"] := Bin.ReadUChar() 
		Record["StartSequence"] := Bin.ReadChar() 
		Record["EndSequence"] := Bin.ReadChar() 
		Record["Padding6"] := Bin.ReadUChar() 
		Loop,4
			Record["Cel" a_index] := Bin.ReadInt() 
		
		Kill := "cel|4,"
			. "StartSequence,"
			. "EndSequence"
		RecordKill(Record,kill,-1)
		
		Kill := "Padding6"
		RecordKill(Record,Kill,0)
		
		InsertQuick("DigestDB","Decompile | " module,Record)		
		
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}