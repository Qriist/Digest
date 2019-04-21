;complete
Digest_Bin_110f_properties(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 46
	
	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 46
		RecordID := a_index-1
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["code"] := Bin.ReadUShort() 
		Record["set1"] := Bin.ReadUChar() 
		Record["set2"] := Bin.ReadUChar() 
		Record["set3"] := Bin.ReadUChar() 
		Record["set4"] := Bin.ReadUChar() 
		Record["set5"] := Bin.ReadUChar() 
		Record["set6"] := Bin.ReadUChar() 
		Record["set7"] := Bin.ReadUChar() 
		Record["iPadding2"] := Bin.ReadUChar() 
		Record["val1"] := Bin.ReadUShort() 
		Record["val2"] := Bin.ReadUShort() 
		Record["val3"] := Bin.ReadUShort() 
		Record["val4"] := Bin.ReadUShort() 
		Record["val5"] := Bin.ReadUShort() 
		Record["val6"] := Bin.ReadUShort() 
		Record["val7"] := Bin.ReadUShort() 
		Record["func1"] := Bin.ReadUChar() 
		Record["func2"] := Bin.ReadUChar() 
		Record["func3"] := Bin.ReadUChar() 
		Record["func4"] := Bin.ReadUChar() 
		Record["func5"] := Bin.ReadUChar() 
		Record["func6"] := Bin.ReadUChar() 
		Record["func7"] := Bin.ReadUChar() 
		Record["iPadding7"] := Bin.ReadUChar() 
		Record["stat1"] := Bin.ReadUShort() 
		Record["stat2"] := Bin.ReadUShort() 
		Record["stat3"] := Bin.ReadUShort() 
		Record["stat4"] := Bin.ReadUShort() 
		Record["stat5"] := Bin.ReadUShort() 
		Record["stat6"] := Bin.ReadUShort() 
		Record["stat7"] := Bin.ReadUShort()
		
		kill=iPadding2,iPadding7,func|7,set|7,val|7
		RecordKill(Record,Kill,0)
		
		kill=stat|7
		RecordKill(Record,Kill,65535)
		
		InsertQuick("DigestDB","Decompile | " module,Record)		
		
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}