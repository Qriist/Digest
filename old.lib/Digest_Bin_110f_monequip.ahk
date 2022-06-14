;complete
Digest_Bin_110f_monequip(BinToDecompile)
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
		Record["monster"] := Bin.ReadUShort() 
		Record["level"] := Bin.ReadUShort() 
		Record["oninit"] := Bin.ReadUInt() 
		Record["item1"] := Trim(Bin.Read(4))
		Record["item2"] := Trim(Bin.Read(4))
		Record["item3"] := Trim(Bin.Read(4))
		Record["loc1"] := Bin.ReadUChar() 
		Record["loc2"] := Bin.ReadUChar() 
		Record["loc3"] := Bin.ReadUChar() 
		Record["mod1"] := Bin.ReadUChar() 
		Record["mod2"] := Bin.ReadUChar() 
		Record["mod3"] := Bin.ReadUChar() 
		Record["iPadding6"] := Bin.ReadUShort()
		
		Kill := "item|3"
		RecordKill(Record,Kill,"")
		
		Kill := "loc|3,"
			. "mod|3,"
			. "iPadding6,"
			. "Level,"
			. "oninit"
		RecordKill(Record,Kill,0)
		
		Kill := "monster"
		RecordKill(Record,Kill,65535)
		
		InsertQuick("DigestDB","Decompile | " module,Record)		
		
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}