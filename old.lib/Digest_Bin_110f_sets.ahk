;complete
Digest_Bin_110f_sets(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 296
	
	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 296
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["wSetId"] := Bin.ReadUShort() 
		Record["name"] := Bin.ReadUShort() 
		Record["version"] := Bin.ReadUInt() 
		Record["iPadding2"] := Bin.ReadUInt() 
		Record["dwSetItems"] := Bin.ReadUInt() 
		Record["PCode2a"] := Bin.ReadInt() 
		Record["PParam2a"] := Bin.ReadInt() 
		Record["PMin2a"] := Bin.ReadInt() 
		Record["PMax2a"] := Bin.ReadInt() 
		Record["PCode2b"] := Bin.ReadInt() 
		Record["PParam2b"] := Bin.ReadInt() 
		Record["PMin2b"] := Bin.ReadInt() 
		Record["PMax2b"] := Bin.ReadInt() 
		Record["PCode3a"] := Bin.ReadInt() 
		Record["PParam3a"] := Bin.ReadInt() 
		Record["PMin3a"] := Bin.ReadInt() 
		Record["PMax3a"] := Bin.ReadInt() 
		Record["PCode3b"] := Bin.ReadInt() 
		Record["PParam3b"] := Bin.ReadInt() 
		Record["PMin3b"] := Bin.ReadInt() 
		Record["PMax3b"] := Bin.ReadInt() 
		Record["PCode4a"] := Bin.ReadInt() 
		Record["PParam4a"] := Bin.ReadInt() 
		Record["PMin4a"] := Bin.ReadInt() 
		Record["PMax4a"] := Bin.ReadInt() 
		Record["PCode4b"] := Bin.ReadInt() 
		Record["PParam4b"] := Bin.ReadInt() 
		Record["PMin4b"] := Bin.ReadInt() 
		Record["PMax4b"] := Bin.ReadInt() 
		Record["PCode5a"] := Bin.ReadInt() 
		Record["PParam5a"] := Bin.ReadInt() 
		Record["PMin5a"] := Bin.ReadInt() 
		Record["PMax5a"] := Bin.ReadInt() 
		Record["PCode5b"] := Bin.ReadInt() 
		Record["PParam5b"] := Bin.ReadInt() 
		Record["PMin5b"] := Bin.ReadInt() 
		Record["PMax5b"] := Bin.ReadInt() 
		Record["FCode1"] := Bin.ReadInt() 
		Record["FParam1"] := Bin.ReadInt() 
		Record["FMin1"] := Bin.ReadInt() 
		Record["FMax1"] := Bin.ReadInt() 
		Record["FCode2"] := Bin.ReadInt() 
		Record["FParam2"] := Bin.ReadInt() 
		Record["FMin2"] := Bin.ReadInt() 
		Record["FMax2"] := Bin.ReadInt() 
		Record["FCode3"] := Bin.ReadInt() 
		Record["FParam3"] := Bin.ReadInt() 
		Record["FMin3"] := Bin.ReadInt() 
		Record["FMax3"] := Bin.ReadInt() 
		Record["FCode4"] := Bin.ReadInt() 
		Record["FParam4"] := Bin.ReadInt() 
		Record["FMin4"] := Bin.ReadInt() 
		Record["FMax4"] := Bin.ReadInt() 
		Record["FCode5"] := Bin.ReadInt() 
		Record["FParam5"] := Bin.ReadInt() 
		Record["FMin5"] := Bin.ReadInt() 
		Record["FMax5"] := Bin.ReadInt() 
		Record["FCode6"] := Bin.ReadInt() 
		Record["FParam6"] := Bin.ReadInt() 
		Record["FMin6"] := Bin.ReadInt() 
		Record["FMax6"] := Bin.ReadInt() 
		Record["FCode7"] := Bin.ReadInt() 
		Record["FParam7"] := Bin.ReadInt() 
		Record["FMin7"] := Bin.ReadInt() 
		Record["FMax7"] := Bin.ReadInt() 
		Record["FCode8"] := Bin.ReadInt() 
		Record["FParam8"] := Bin.ReadInt() 
		Record["FMin8"] := Bin.ReadInt() 
		Record["FMax8"] := Bin.ReadInt() 
		Record["iPadding68"] := Bin.ReadUInt() 
		Record["iPadding69"] := Bin.ReadUInt() 
		Record["iPadding70"] := Bin.ReadUInt() 
		Record["iPadding71"] := Bin.ReadUInt() 
		Record["iPadding72"] := Bin.ReadUInt() 
		Record["iPadding73"] := Bin.ReadUInt()
		
		InsertQuick("DigestDB","Decompile | " module,Record)		
		
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}