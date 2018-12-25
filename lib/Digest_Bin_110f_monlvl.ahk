;complete
Digest_Bin_110f_monlvl(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 120

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 120
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["AC"] := Bin.ReadUInt() 
		Record["AC(N)"] := Bin.ReadUInt() 
		Record["AC(H)"] := Bin.ReadUInt() 
		Record["L-AC"] := Bin.ReadUInt() 
		Record["L-AC(N)"] := Bin.ReadUInt() 
		Record["L-AC(H)"] := Bin.ReadUInt() 
		Record["TH"] := Bin.ReadUInt() 
		Record["TH(N)"] := Bin.ReadUInt() 
		Record["TH(H)"] := Bin.ReadUInt() 
		Record["L-TH"] := Bin.ReadUInt() 
		Record["L-TH(N)"] := Bin.ReadUInt() 
		Record["L-TH(H)"] := Bin.ReadUInt() 
		Record["HP"] := Bin.ReadUInt() 
		Record["HP(N)"] := Bin.ReadUInt() 
		Record["HP(H)"] := Bin.ReadUInt() 
		Record["L-HP"] := Bin.ReadUInt() 
		Record["L-HP(N)"] := Bin.ReadUInt() 
		Record["L-HP(H)"] := Bin.ReadUInt() 
		Record["DM"] := Bin.ReadUInt() 
		Record["DM(N)"] := Bin.ReadUInt() 
		Record["DM(H)"] := Bin.ReadUInt() 
		Record["L-DM"] := Bin.ReadUInt() 
		Record["L-DM(N)"] := Bin.ReadUInt() 
		Record["L-DM(H)"] := Bin.ReadUInt() 
		Record["XP"] := Bin.ReadUInt() 
		Record["XP(N)"] := Bin.ReadUInt() 
		Record["XP(H)"] := Bin.ReadUInt() 
		Record["L-XP"] := Bin.ReadUInt() 
		Record["L-XP(N)"] := Bin.ReadUInt() 
		Record["L-XP(H)"] := Bin.ReadUInt()
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