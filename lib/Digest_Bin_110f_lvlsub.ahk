;complete
Digest_Bin_110f_lvlsub(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 348

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 348
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Type"] := Bin.ReadInt() 
		Record["File"] := Trim(Bin.Read(60))
		Record["CheckAll"] := Bin.ReadInt() 
		Record["BordType"] := Bin.ReadInt() 
		Record["Dt1Mask"] := Bin.ReadInt() 
		Record["GridSize"] := Bin.ReadInt() 
		;~ Bin.Read(204)
		Record["iPadding20"] := Bin.ReadInt() 
		Record["iPadding21"] := Bin.ReadInt() 
		Record["iPadding22"] := Bin.ReadInt() 
		Record["iPadding23"] := Bin.ReadInt() 
		Record["iPadding24"] := Bin.ReadInt() 
		Record["iPadding25"] := Bin.ReadInt() 
		Record["iPadding26"] := Bin.ReadInt() 
		Record["iPadding27"] := Bin.ReadInt() 
		Record["iPadding28"] := Bin.ReadInt() 
		Record["iPadding29"] := Bin.ReadInt() 
		Record["iPadding30"] := Bin.ReadInt() 
		Record["iPadding31"] := Bin.ReadInt() 
		Record["iPadding32"] := Bin.ReadInt() 
		Record["iPadding33"] := Bin.ReadInt() 
		Record["iPadding34"] := Bin.ReadInt() 
		Record["iPadding35"] := Bin.ReadInt() 
		Record["iPadding36"] := Bin.ReadInt() 
		Record["iPadding37"] := Bin.ReadInt() 
		Record["iPadding38"] := Bin.ReadInt() 
		Record["iPadding39"] := Bin.ReadInt() 
		Record["iPadding40"] := Bin.ReadInt() 
		Record["iPadding41"] := Bin.ReadInt() 
		Record["iPadding42"] := Bin.ReadInt() 
		Record["iPadding43"] := Bin.ReadInt() 
		Record["iPadding44"] := Bin.ReadInt() 
		Record["iPadding45"] := Bin.ReadInt() 
		Record["iPadding46"] := Bin.ReadInt() 
		Record["iPadding47"] := Bin.ReadInt() 
		Record["iPadding48"] := Bin.ReadInt() 
		Record["iPadding49"] := Bin.ReadInt() 
		Record["iPadding50"] := Bin.ReadInt() 
		Record["iPadding51"] := Bin.ReadInt() 
		Record["iPadding52"] := Bin.ReadInt() 
		Record["iPadding53"] := Bin.ReadInt() 
		Record["iPadding54"] := Bin.ReadInt() 
		Record["iPadding55"] := Bin.ReadInt() 
		Record["iPadding56"] := Bin.ReadInt() 
		Record["iPadding57"] := Bin.ReadInt() 
		Record["iPadding58"] := Bin.ReadInt() 
		Record["iPadding59"] := Bin.ReadInt() 
		Record["iPadding60"] := Bin.ReadInt() 
		Record["iPadding61"] := Bin.ReadInt() 
		Record["iPadding62"] := Bin.ReadInt() 
		Record["iPadding63"] := Bin.ReadInt() 
		Record["iPadding64"] := Bin.ReadInt() 
		Record["iPadding65"] := Bin.ReadInt() 
		Record["iPadding66"] := Bin.ReadInt() 
		Record["iPadding67"] := Bin.ReadInt() 
		Record["iPadding68"] := Bin.ReadInt() 
		Record["iPadding69"] := Bin.ReadInt() 
		Record["iPadding70"] := Bin.ReadInt() 
		Record["Prob0"] := Bin.ReadInt() 
		Record["Prob1"] := Bin.ReadInt() 
		Record["Prob2"] := Bin.ReadInt() 
		Record["Prob3"] := Bin.ReadInt() 
		Record["Prob4"] := Bin.ReadInt() 
		Record["Trials0"] := Bin.ReadInt() 
		Record["Trials1"] := Bin.ReadInt() 
		Record["Trials2"] := Bin.ReadInt() 
		Record["Trials3"] := Bin.ReadInt() 
		Record["Trials4"] := Bin.ReadInt() 
		Record["Max0"] := Bin.ReadInt() 
		Record["Max1"] := Bin.ReadInt() 
		Record["Max2"] := Bin.ReadInt() 
		Record["Max3"] := Bin.ReadInt() 
		Record["Max4"] := Bin.ReadInt() 
		Record["Expansion"] := Bin.ReadInt()
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		
		Kill=iPadding|71,Prob|5,Trials|5,Max|5
		RecordKill(Record,Kill,0,,-1)
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}