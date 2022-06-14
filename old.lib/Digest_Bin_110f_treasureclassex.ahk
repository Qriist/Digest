;complete
Digest_Bin_110f_treasureclassex(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 736
	
	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 736
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Picks"] := Bin.ReadInt() 
		Record["group"] := Bin.ReadShort() 
		Record["level"] := Bin.ReadShort() 
		Record["Magic"] := Bin.ReadShort() 
		Record["Rare"] := Bin.ReadShort() 
		Record["Set"] := Bin.ReadShort() 
		Record["Unique"] := Bin.ReadShort() 
		Record["iPadding12"] := Bin.ReadInt() 
		Record["NoDrop"] := Bin.ReadInt() 
		Record["Prob1"] := Bin.ReadInt() 
		Record["Prob2"] := Bin.ReadInt() 
		Record["Prob3"] := Bin.ReadInt() 
		Record["Prob4"] := Bin.ReadInt() 
		Record["Prob5"] := Bin.ReadInt() 
		Record["Prob6"] := Bin.ReadInt() 
		Record["Prob7"] := Bin.ReadInt() 
		Record["Prob8"] := Bin.ReadInt() 
		Record["Prob9"] := Bin.ReadInt() 
		Record["Prob10"] := Bin.ReadInt()
		
		
		Kill=Picks,group,level,Magic,Rare,Set,Unique,iPadding12,NoDrop,Prob|10
		RecordKill(Record,Kill,0)
		
		InsertQuick("DigestDB","Decompile | " module,Record)		
		
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}