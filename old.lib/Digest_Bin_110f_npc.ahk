;complete
Digest_Bin_110f_npc(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 76
	
	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 76
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["npc"] := Bin.ReadUInt() 
		Record["sell mult"] := Bin.ReadUInt() 
		Record["buy mult"] := Bin.ReadUInt() 
		Record["rep mult"] := Bin.ReadUInt() 
		Record["questflag A"] := Bin.ReadUInt() 
		Record["questflag B"] := Bin.ReadUInt() 
		Record["questflag C"] := Bin.ReadUInt() 
		Record["questsellmult A"] := Bin.ReadUInt() 
		Record["questsellmult B"] := Bin.ReadUInt() 
		Record["questsellmult C"] := Bin.ReadUInt() 
		Record["questbuymult A"] := Bin.ReadUInt() 
		Record["questbuymult B"] := Bin.ReadUInt() 
		Record["questbuymult C"] := Bin.ReadUInt() 
		Record["questrepmult A"] := Bin.ReadUInt() 
		Record["questrepmult B"] := Bin.ReadUInt() 
		Record["questrepmult C"] := Bin.ReadUInt() 
		Record["max buy"] := Bin.ReadUInt() 
		Record["max buy (N)"] := Bin.ReadUInt() 
		Record["max buy (H)"] := Bin.ReadUInt()
		
		
		InsertQuick("DigestDB","Decompile | " module,Record)		
		
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}