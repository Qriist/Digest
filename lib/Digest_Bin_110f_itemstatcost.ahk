;complete
Digest_Bin_110f_itemstatcost(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Seek(4)
	RecordSize := 324

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 324
		;BITFIELDS ARE PRESENT!
		RecordID := a_index-1
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["ID"] := Bin.ReadUInt() 
		Record["CombinedBits1"] := Bin.ReadUChar() 
		Record["CombinedBits2"] := Bin.ReadUChar() 
		
		;Start bitfield operations
		Flags := Record["CombinedBits1"] Record["CombinedBits2"]
		If Flags = 
		msgbox,YOU HAVE NOT FIXED THE BITFIELDS FOR MODULE %module%.
		Record["iPadding1_1"] := substr(Flags,3,3) 
		Record["direct"] := substr(Flags,4,1) 
		Record["itemspecific"] := substr(Flags,5,1) 
		Record["damagerelated"] := substr(Flags,6,1) 
		Record["Signed"] := substr(Flags,7,1) 
		Record["Send Other"] := substr(Flags,8,1) 
		Record["iPadding1"] := substr(Flags,9,1) 
		Record["iPadding1_3"] := substr(Flags,10,1) 
		Record["CSvSigned"] := substr(Flags,11,1) 
		Record["Saved"] := substr(Flags,12,1) 
		Record["fCallback"] := substr(Flags,13,1) 
		Record["fMin"] := substr(Flags,14,1) 
		Record["UpdateAnimRate"] := substr(Flags,15,1) 
		Record["iPadding1_2"] := substr(Flags,16,1) 
		Record["iPadding1"] := Trim(Bin.Read(2))
		Record["Send Bits"] := Bin.ReadUChar() 
		Record["Send Param Bits"] := Bin.ReadUChar() 
		Record["CSvBits"] := Bin.ReadUChar() 
		Record["CSvParam"] := Bin.ReadUChar() 
		Record["Divide"] := Bin.ReadUInt() 
		Record["Multiply"] := Bin.ReadInt() 
		Record["Add"] := Bin.ReadUInt() 
		Record["ValShift"] := Bin.ReadUChar() 
		Record["Save Bits"] := Bin.ReadUChar() 
		Record["1.09-Save Bits"] := Bin.ReadUChar() 
		Record["bUnKnown"] := Bin.ReadUChar() 
		Record["Save Add"] := Bin.ReadInt() 
		Record["1.09-Save Add"] := Bin.ReadInt() 
		Record["Save Param Bits"] := Bin.ReadUInt() 
		Record["iPadding10"] := Bin.ReadUInt() 
		Record["MinAccr"] := Bin.ReadUInt() 
		Record["Encode"] := Bin.ReadUChar() 
		Record["bUnKnown2"] := Bin.ReadUChar() 
		Record["maxstat"] := Bin.ReadUShort() 
		Record["descpriority"] := Bin.ReadUShort() 
		Record["descfunc"] := Bin.ReadUChar() 
		Record["descval"] := Bin.ReadUChar() 
		Record["descstrpos"] := Bin.ReadUShort() 
		Record["descstrneg"] := Bin.ReadUShort() 
		Record["descstr2"] := Bin.ReadUShort() 
		Record["dgrp"] := Bin.ReadUShort() 
		Record["dgrpfunc"] := Bin.ReadUChar() 
		Record["dgrpval"] := Bin.ReadUChar() 
		Record["dgrpstrpos"] := Bin.ReadUShort() 
		Record["dgrpstrneg"] := Bin.ReadUShort() 
		Record["dgrpstr2"] := Bin.ReadUShort() 
		Record["itemevent1"] := Bin.ReadUShort() 
		Record["itemevent2"] := Bin.ReadUShort() 
		Record["itemeventfunc1"] := Bin.ReadUShort() 
		Record["itemeventfunc2"] := Bin.ReadUShort() 
		Record["keepzero"] := Bin.ReadUInt() 
		Record["op"] := Bin.ReadUChar() 
		Record["op param"] := Bin.ReadUChar() 
		Record["op base"] := Bin.ReadUShort() 
		Record["op stat1"] := Bin.ReadUShort() 
		Record["op stat2"] := Bin.ReadUShort() 
		Record["op stat3"] := Bin.ReadUShort() 
		Record["iPadding23"] := Bin.ReadUShort() 
		Record["iPadding24"] := Bin.ReadUInt() 
		Record["iPadding25"] := Bin.ReadUInt() 
		Record["iPadding26"] := Bin.ReadUInt() 
		Record["iPadding27"] := Bin.ReadUInt() 
		Record["iPadding28"] := Bin.ReadUInt() 
		Record["iPadding29"] := Bin.ReadUInt() 
		Record["iPadding30"] := Bin.ReadUInt() 
		Record["iPadding31"] := Bin.ReadUInt() 
		Record["iPadding32"] := Bin.ReadUInt() 
		Record["iPadding33"] := Bin.ReadUInt() 
		Record["iPadding34"] := Bin.ReadUInt() 
		Record["iPadding35"] := Bin.ReadUInt() 
		Record["iPadding36"] := Bin.ReadUInt() 
		Record["iPadding37"] := Bin.ReadUInt() 
		Record["iPadding38"] := Bin.ReadUInt() 
		Record["iPadding39"] := Bin.ReadUInt() 
		Record["iPadding40"] := Bin.ReadUInt() 
		Record["iPadding41"] := Bin.ReadUInt() 
		Record["iPadding42"] := Bin.ReadUInt() 
		Record["iPadding43"] := Bin.ReadUInt() 
		Record["iPadding44"] := Bin.ReadUInt() 
		Record["iPadding45"] := Bin.ReadUInt() 
		Record["iPadding46"] := Bin.ReadUInt() 
		Record["iPadding47"] := Bin.ReadUInt() 
		Record["iPadding48"] := Bin.ReadUInt() 
		Record["iPadding49"] := Bin.ReadUInt() 
		Record["iPadding50"] := Bin.ReadUInt() 
		Record["iPadding51"] := Bin.ReadUInt() 
		Record["iPadding52"] := Bin.ReadUInt() 
		Record["iPadding53"] := Bin.ReadUInt() 
		Record["iPadding54"] := Bin.ReadUInt() 
		Record["iPadding55"] := Bin.ReadUInt() 
		Record["iPadding56"] := Bin.ReadUInt() 
		Record["iPadding57"] := Bin.ReadUInt() 
		Record["iPadding58"] := Bin.ReadUInt() 
		Record["iPadding59"] := Bin.ReadUInt() 
		Record["iPadding60"] := Bin.ReadUInt() 
		Record["iPadding61"] := Bin.ReadUInt() 
		Record["iPadding62"] := Bin.ReadUInt() 
		Record["iPadding63"] := Bin.ReadUInt() 
		Record["iPadding64"] := Bin.ReadUInt() 
		Record["iPadding65"] := Bin.ReadUInt() 
		Record["iPadding66"] := Bin.ReadUInt() 
		Record["iPadding67"] := Bin.ReadUInt() 
		Record["iPadding68"] := Bin.ReadUInt() 
		Record["iPadding69"] := Bin.ReadUInt() 
		Record["iPadding70"] := Bin.ReadUInt() 
		Record["iPadding71"] := Bin.ReadUInt() 
		Record["iPadding72"] := Bin.ReadUInt() 
		Record["iPadding73"] := Bin.ReadUInt() 
		Record["iPadding74"] := Bin.ReadUInt() 
		Record["iPadding75"] := Bin.ReadUInt() 
		Record["iPadding76"] := Bin.ReadUInt() 
		Record["iPadding77"] := Bin.ReadUInt() 
		Record["iPadding78"] := Bin.ReadUInt() 
		Record["iPadding79"] := Bin.ReadUInt() 
		Record["stuff"] := Bin.ReadUInt()
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		
		Kill := "op"
		KillDepend := "op base,op param,op stat1,op stat2,op stat3,bUknown"
		RecordKill(Record,kill,0,KillDepend)
		
		kill := "itemevent|2,maxstat,op base,op stat|3"
		RecordKill(Record,kill,65535,,,"$")

		Kill := "stuff,op param,itemeventfunc|2,iPadding|79"
		RecordKill(Record,kill,0)
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}