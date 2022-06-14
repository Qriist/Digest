;complete
Digest_Bin_110f_arena(BinToDecompile)
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
		Record["Suicide"] := Bin.ReadInt() 
		Record["PlayerKill"] := Bin.ReadInt() 
		Record["PlayerKillPercent"] := Bin.ReadInt() 
		Record["MonsterKill"] := Bin.ReadInt() 
		Record["PlayerDeath"] := Bin.ReadInt() 
		Record["PlayerDeathPercent"] := Bin.ReadInt() 
		Record["MonsterDeath"] := Bin.ReadInt()
		
		InsertQuick("DigestDB","Decompile | " module,Record)		
		
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}