;complete
Digest_Bin_110f_skilldesc(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 288
	
	for k,v in Digest[ModFullName,"String"]
	{
		DummySearch := StringCodeToNumber(Digest[ModFullName,"String"],k,"dummy")
		break
	}
	
	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		} 
		;Record size: 288
		RecordID := a_index-1
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["SkillDesc"] := Bin.ReadUShort() 
		Record["SkillPage"] := Bin.ReadUChar() 
		Record["SkillRow"] := Bin.ReadUChar() 
		Record["SkillColumn"] := Bin.ReadUChar() 
		Record["ListRow"] := Bin.ReadUChar() 
		Record["ListPool"] := Bin.ReadUChar() 
		Record["IconCel"] := Bin.ReadUChar() 
		Record["str name"] := Bin.ReadUShort() 
		Record["str short"] := Bin.ReadUShort() 
		Record["str long"] := Bin.ReadUShort() 
		Record["str alt"] := Bin.ReadUShort() 
		Record["str mana"] := Bin.ReadUShort() 
		Record["descdam"] := Bin.ReadUShort() 
		Record["descatt"] := Bin.ReadUShort() 
		Record["acPadding20_1"] := Bin.ReadChar() 
		Record["acPadding20_2"] := Bin.ReadChar() 
		Record["ddam calc1"] := Bin.ReadUInt() 
		Record["ddam calc2"] := Bin.ReadUInt() 
		Record["p1dmelem"] := Bin.ReadUChar() 
		Record["p2dmelem"] := Bin.ReadUChar() 
		Record["p3dmelem"] := Bin.ReadUChar() 
		Record["acPadding2"] := Bin.ReadChar() 
		Record["p1dmmin"] := Bin.ReadUInt() 
		Record["p2dmmin"] := Bin.ReadUInt() 
		Record["p3dmmin"] := Bin.ReadUInt() 
		Record["p1dmmax"] := Bin.ReadUInt() 
		Record["p2dmmax"] := Bin.ReadUInt() 
		Record["p3dmmax"] := Bin.ReadUInt() 
		Record["descmissile1"] := Bin.ReadUShort() 
		Record["descmissile2"] := Bin.ReadUShort() 
		Record["descmissile3"] := Bin.ReadUShort() 
		Record["descline1"] := Bin.ReadUChar() 
		Record["descline2"] := Bin.ReadUChar() 
		Record["descline3"] := Bin.ReadUChar() 
		Record["descline4"] := Bin.ReadUChar() 
		Record["descline5"] := Bin.ReadUChar() 
		Record["descline6"] := Bin.ReadUChar() 
		Record["dsc2line1"] := Bin.ReadUChar() 
		Record["dsc2line2"] := Bin.ReadUChar() 
		Record["dsc2line3"] := Bin.ReadUChar() 
		Record["dsc2line4"] := Bin.ReadUChar() 
		Record["dsc3line1"] := Bin.ReadUChar() 
		Record["dsc3line2"] := Bin.ReadUChar() 
		Record["dsc3line3"] := Bin.ReadUChar() 
		Record["dsc3line4"] := Bin.ReadUChar() 
		Record["dsc3line5"] := Bin.ReadUChar() 
		Record["dsc3line6"] := Bin.ReadUChar() 
		Record["dsc3line7"] := Bin.ReadUChar() 
		Record["bPadding20"] := Bin.ReadUChar() 
		Record["desctexta1"] := Bin.ReadUShort() 
		Record["desctexta2"] := Bin.ReadUShort() 
		Record["desctexta3"] := Bin.ReadUShort() 
		Record["desctexta4"] := Bin.ReadUShort() 
		Record["desctexta5"] := Bin.ReadUShort() 
		Record["desctexta6"] := Bin.ReadUShort() 
		Record["dsc2texta1"] := Bin.ReadUShort() 
		Record["dsc2texta2"] := Bin.ReadUShort() 
		Record["dsc2texta3"] := Bin.ReadUShort() 
		Record["dsc2texta4"] := Bin.ReadUShort() 
		Record["dsc3texta1"] := Bin.ReadUShort() 
		Record["dsc3texta2"] := Bin.ReadUShort() 
		Record["dsc3texta3"] := Bin.ReadUShort() 
		Record["dsc3texta4"] := Bin.ReadUShort() 
		Record["dsc3texta5"] := Bin.ReadUShort() 
		Record["dsc3texta6"] := Bin.ReadUShort() 
		Record["dsc3texta7"] := Bin.ReadUShort() 
		Record["desctextb1"] := Bin.ReadUShort() 
		Record["desctextb2"] := Bin.ReadUShort() 
		Record["desctextb3"] := Bin.ReadUShort() 
		Record["desctextb4"] := Bin.ReadUShort() 
		Record["desctextb5"] := Bin.ReadUShort() 
		Record["desctextb6"] := Bin.ReadUShort() 
		Record["dsc2textb1"] := Bin.ReadUShort() 
		Record["dsc2textb2"] := Bin.ReadUShort() 
		Record["dsc2textb3"] := Bin.ReadUShort() 
		Record["dsc2textb4"] := Bin.ReadUShort() 
		Record["dsc3textb1"] := Bin.ReadUShort() 
		Record["dsc3textb2"] := Bin.ReadUShort() 
		Record["dsc3textb3"] := Bin.ReadUShort() 
		Record["dsc3textb4"] := Bin.ReadUShort() 
		Record["dsc3textb5"] := Bin.ReadUShort() 
		Record["dsc3textb6"] := Bin.ReadUShort() 
		Record["dsc3textb7"] := Bin.ReadUShort() 
		Record["desccalca1"] := Bin.ReadUInt() 
		Record["desccalca2"] := Bin.ReadUInt() 
		Record["desccalca3"] := Bin.ReadUInt() 
		Record["desccalca4"] := Bin.ReadUInt() 
		Record["desccalca5"] := Bin.ReadUInt() 
		Record["desccalca6"] := Bin.ReadUInt() 
		Record["dsc2calca1"] := Bin.ReadUInt() 
		Record["dsc2calca2"] := Bin.ReadUInt() 
		Record["dsc2calca3"] := Bin.ReadUInt() 
		Record["dsc2calca4"] := Bin.ReadUInt() 
		Record["dsc3calca1"] := Bin.ReadUInt() 
		Record["dsc3calca2"] := Bin.ReadUInt() 
		Record["dsc3calca3"] := Bin.ReadUInt() 
		Record["dsc3calca4"] := Bin.ReadUInt() 
		Record["dsc3calca5"] := Bin.ReadUInt() 
		Record["dsc3calca6"] := Bin.ReadUInt() 
		Record["dsc3calca7"] := Bin.ReadUInt() 
		Record["desccalcb1"] := Bin.ReadUInt() 
		Record["desccalcb2"] := Bin.ReadUInt() 
		Record["desccalcb3"] := Bin.ReadUInt() 
		Record["desccalcb4"] := Bin.ReadUInt() 
		Record["desccalcb5"] := Bin.ReadUInt() 
		Record["desccalcb6"] := Bin.ReadUInt() 
		Record["dsc2calcb1"] := Bin.ReadUInt() 
		Record["dsc2calcb2"] := Bin.ReadUInt() 
		Record["dsc2calcb3"] := Bin.ReadUInt() 
		Record["dsc2calcb4"] := Bin.ReadUInt() 
		Record["dsc3calcb1"] := Bin.ReadUInt() 
		Record["dsc3calcb2"] := Bin.ReadUInt() 
		Record["dsc3calcb3"] := Bin.ReadUInt() 
		Record["dsc3calcb4"] := Bin.ReadUInt() 
		Record["dsc3calcb5"] := Bin.ReadUInt() 
		Record["dsc3calcb6"] := Bin.ReadUInt() 
		Record["dsc3calcb7"] := Bin.ReadUInt()
		
		Kill := "descline|6,"
			. "dsc2line|4,"
			. "dsc3line|7,"
			. "p$dmelem|3,"
			. "SkillColumn,"
			. "SkillPage,"
			. "SkillRow,"
			. "ListPool,"
			. "ListRow,"
			. "acPadding2,"
			. "bPadding20,"
			. "acPadding20_1,"
			. "acPadding20_2"
		RecordKill(Record,kill,0,,,"$")
		
		Kill := "descmissile|3"
		RecordKill(Record,kill,65535)
		
		Kill := "ddam calc|2,"
			. "p$dmelem|3,"
			. "p$dmmin|3,"
			. "p$dmmax|3,"
			. "desccalca|6,"
			. "dsc2calca|4,"
			. "dsc3calca|7,"
			. "desccalcb|6,"
			. "dsc2calcb|4,"
			. "dsc3calcb|7"
		RecordKill(Record,kill,4294967295,KillDepend,,"$")
		
		Kill := "desctexta|6,"
			. "dsc2texta|4,"
			. "dsc3texta|7,"
			. "desctextb|6,"
			. "dsc2textb|4,"
			. "dsc3textb|7,"
			. "str name,"
			. "str short,"
			. "str long,"
			. "str alt,"
			. "str mana"
		RecordKill(Record,Kill,DummySearch)
		
		InsertQuick("DigestDB","Decompile | " module,Record)		
		
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}