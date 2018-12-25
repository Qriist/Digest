;complete
Digest_Bin_110f_lvlprest(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 432

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 432
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Def"] := Bin.ReadInt() 
		Record["LevelId"] := Bin.ReadInt() 
		Record["Populate"] := Bin.ReadInt() 
		Record["Logicals"] := Bin.ReadInt() 
		Record["Outdoors"] := Bin.ReadInt() 
		Record["Animate"] := Bin.ReadInt() 
		Record["KillEdge"] := Bin.ReadInt() 
		Record["FillBlanks"] := Bin.ReadInt() 
		Record["Expansion"] := Bin.ReadInt() 
		Record["iPadding9"] := Bin.ReadInt() 
		Record["SizeX"] := Bin.ReadInt() 
		Record["SizeY"] := Bin.ReadInt() 
		Record["AutoMap"] := Bin.ReadInt() 
		Record["Scan"] := Bin.ReadInt() 
		Record["Pops"] := Bin.ReadInt() 
		Record["PopPad"] := Bin.ReadInt() 
		Record["Files"] := Bin.ReadInt() 
		Record["File1"] := Trim(Bin.Read(60))
		Record["File2"] := Trim(Bin.Read(60))
		Record["File3"] := Trim(Bin.Read(60))
		Record["File4"] := Trim(Bin.Read(60))
		Record["File5"] := Trim(Bin.Read(60))
		Record["File6"] := Trim(Bin.Read(60))
		Record["Dt1Mask"] := Bin.ReadInt()
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		Kill=LevelId,Populate,Logicals,Outdoors,Animate,KillEdge,FillBlanks,Expansion,iPadding9,SizeX,SizeY,Scan,Pops,PopPad,File|6
		RecordKill(Record,Kill,0)
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}