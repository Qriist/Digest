Digest_Bin_110f_states(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 60

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 60
		;BITFIELDS ARE PRESENT!
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["id"] := Bin.ReadUShort() 
		Record["overlay1"] := Bin.ReadUShort() 
		Record["overlay2"] := Bin.ReadUShort() 
		Record["overlay3"] := Bin.ReadUShort() 
		Record["overlay4"] := Bin.ReadUShort() 
		Record["castoverlay"] := Bin.ReadUShort() 
		Record["removerlay"] := Bin.ReadUShort() 
		Record["pgsvoverlay"] := Bin.ReadUShort() 
		Record["CombinedBits1"] := Bin.ReadUChar() 
		Record["CombinedBits2"] := Bin.ReadUChar() 
		Record["CombinedBits3"] := Bin.ReadUChar() 
		Record["CombinedBits4"] := Bin.ReadUChar() 
		Record["CombinedBits5"] := Bin.ReadUChar() 
		
		;Start bitfield operations
		Flags := Record["CombinedBits1"] Record["CombinedBits2"] Record["CombinedBits3"] Record["CombinedBits4"] Record["CombinedBits5"]
		If Flags = 
		msgbox,YOU HAVE NOT FIXED THE BITFIELDS FOR MODULE %module%.
		Record["damblue"] := substr(Flags,1,1) 
		Record["remhit"] := substr(Flags,2,1) 
		Record["active"] := substr(Flags,3,1) 
		Record["pgsv"] := substr(Flags,4,1) 
		Record["transform"] := substr(Flags,5,1) 
		Record["hide"] := substr(Flags,6,1) 
		Record["aura"] := substr(Flags,7,1) 
		Record["nosend"] := substr(Flags,8,1) 
		Record["bossstaydeath"] := substr(Flags,9,1) 
		Record["monstaydeath"] := substr(Flags,10,1) 
		Record["plrstaydeath"] := substr(Flags,11,1) 
		Record["curable"] := substr(Flags,12,1) 
		Record["curse"] := substr(Flags,13,1) 
		Record["attred"] := substr(Flags,14,1) 
		Record["attblue"] := substr(Flags,15,1) 
		Record["damred"] := substr(Flags,16,1) 
		Record["rpblue"] := substr(Flags,17,1) 
		Record["rlblue"] := substr(Flags,18,1) 
		Record["rcblue"] := substr(Flags,19,1) 
		Record["rfblue"] := substr(Flags,20,1) 
		Record["armblue"] := substr(Flags,21,1) 
		Record["blue"] := substr(Flags,22,1) 
		Record["restrict"] := substr(Flags,23,1) 
		Record["disguise"] := substr(Flags,24,1) 
		Record["shatter"] := substr(Flags,25,1) 
		Record["exp"] := substr(Flags,26,1) 
		Record["rpred"] := substr(Flags,27,1) 
		Record["rlred"] := substr(Flags,28,1) 
		Record["rcred"] := substr(Flags,29,1) 
		Record["rfred"] := substr(Flags,30,1) 
		Record["armred"] := substr(Flags,31,1) 
		Record["stambarblue"] := substr(Flags,32,1) 
		Record["notondead"] := substr(Flags,33,1) 
		Record["meleeonly"] := substr(Flags,34,1) 
		Record["bossinv"] := substr(Flags,35,1) 
		Record["noclear"] := substr(Flags,36,1) 
		Record["nooverlays"] := substr(Flags,37,1) 
		Record["green"] := substr(Flags,38,1) 
		Record["udead"] := substr(Flags,39,1) 
		Record["life"] := substr(Flags,40,1) 
		;~ Record["iPadding5"] := 
		Bin.Read(3) 
		Record["stat"] := Bin.ReadUShort() 
		Record["setfunc"] := Bin.ReadUShort() 
		Record["remfunc"] := Bin.ReadUShort() 
		Record["group"] := Bin.ReadUShort() 
		Record["colorpri"] := Bin.ReadUChar() 
		Record["colorshift"] := Bin.ReadUChar() 
		Record["light-r"] := Bin.ReadUChar() 
		Record["light-g"] := Bin.ReadUChar() 
		Record["light-b"] := Bin.ReadUChar() 
		Record["iPadding9"] := Bin.ReadUChar() 
		Record["onsound"] := Bin.ReadUShort() 
		Record["offsound"] := Bin.ReadUShort() 
		Record["itemtype"] := Bin.ReadUShort() 
		Record["itemtrans"] := Bin.ReadUChar() 
		Record["gfxtype"] := Bin.ReadUChar() 
		Record["gfxclass"] := Bin.ReadUShort() 
		Record["cltevent"] := Bin.ReadUShort() 
		Record["clteventfunc"] := Bin.ReadUShort() 
		Record["cltactivefunc"] := Bin.ReadUShort() 
		Record["srvactivefunc"] := Bin.ReadUShort() 
		Record["skill"] := Bin.ReadUShort() 
		Record["missile"] := Bin.ReadUShort()
		
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