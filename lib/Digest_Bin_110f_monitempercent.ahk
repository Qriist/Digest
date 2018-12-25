;complete
Digest_Bin_110f_monitempercent(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 4

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 4
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["HeartPercent"] := Bin.ReadUChar() 
		Record["BodyPartPercent"] := Bin.ReadUChar() 
		Record["TreasureClassPercent"] := Bin.ReadUChar() 
		Record["ComponentPercent"] := Bin.ReadUChar()
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