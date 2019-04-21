;complete
Digest_Bin_110f_gems(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 192
	
	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 192
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["name"] := Bin.Read(32) 
		Record["letter"] := Bin.Read(8) 
		Record["code"] := Bin.ReadUInt() 
		Record["iPadding11"] := Bin.ReadUShort() 
		Record["nummods"] := Bin.ReadUChar() 
		Record["transform"] := Bin.ReadUChar() 
		Record["weaponMod1Code"] := Bin.ReadUInt() 
		Record["weaponMod1Param"] := Bin.ReadUInt() 
		Record["weaponMod1Min"] := Bin.ReadInt() 
		Record["weaponMod1Max"] := Bin.ReadInt() 
		Record["weaponMod2Code"] := Bin.ReadUInt() 
		Record["weaponMod2Param"] := Bin.ReadUInt() 
		Record["weaponMod2Min"] := Bin.ReadInt() 
		Record["weaponMod2Max"] := Bin.ReadInt() 
		Record["weaponMod3Code"] := Bin.ReadUInt() 
		Record["weaponMod3Param"] := Bin.ReadUInt() 
		Record["weaponMod3Min"] := Bin.ReadInt() 
		Record["weaponMod3Max"] := Bin.ReadInt() 
		Record["helmMod1Code"] := Bin.ReadUInt() 
		Record["helmMod1Param"] := Bin.ReadUInt() 
		Record["helmMod1Min"] := Bin.ReadInt() 
		Record["helmMod1Max"] := Bin.ReadInt() 
		Record["helmMod2Code"] := Bin.ReadUInt() 
		Record["helmMod2Param"] := Bin.ReadUInt() 
		Record["helmMod2Min"] := Bin.ReadInt() 
		Record["helmMod2Max"] := Bin.ReadInt() 
		Record["helmMod3Code"] := Bin.ReadUInt() 
		Record["helmMod3Param"] := Bin.ReadUInt() 
		Record["helmMod3Min"] := Bin.ReadInt() 
		Record["helmMod3Max"] := Bin.ReadInt() 
		Record["shieldMod1Code"] := Bin.ReadUInt() 
		Record["shieldMod1Param"] := Bin.ReadUInt() 
		Record["shieldMod1Min"] := Bin.ReadInt() 
		Record["shieldMod1Max"] := Bin.ReadInt() 
		Record["shieldMod2Code"] := Bin.ReadUInt() 
		Record["shieldMod2Param"] := Bin.ReadUInt() 
		Record["shieldMod2Min"] := Bin.ReadInt() 
		Record["shieldMod2Max"] := Bin.ReadInt() 
		Record["shieldMod3Code"] := Bin.ReadUInt() 
		Record["shieldMod3Param"] := Bin.ReadUInt() 
		Record["shieldMod3Min"] := Bin.ReadInt() 
		Record["shieldMod3Max"] := Bin.ReadInt()
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		
		Kill=weaponmod$code|15
		KillDepend=weaponmod$param,weaponmod$min,weaponmod$max
		RecordKill(Record,kill,4294967295,KillDepend,,"$")
		
		Kill=helmmod$code|15
		KillDepend=helmmod$param,helmmod$min,helmmod$max
		RecordKill(Record,kill,4294967295,KillDepend,,"$")
		
		Kill=shieldmod$code|15
		KillDepend=shieldmod$param,shieldmod$min,shieldmod$max
		RecordKill(Record,kill,4294967295,KillDepend,,"$")
		
		
		InsertQuick("DigestDB","Decompile | " module,Record)		
		
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}