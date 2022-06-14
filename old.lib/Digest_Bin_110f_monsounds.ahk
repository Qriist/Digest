;complete
Digest_Bin_110f_monsounds(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 148
	
	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 148
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["iPadding0"] := Bin.ReadUInt() 
		Record["Attack1"] := Bin.ReadUInt() 
		Record["Att1Del"] := Bin.ReadUInt() 
		Record["Att1Prb"] := Bin.ReadUInt() 
		Record["Weapon1"] := Bin.ReadUInt() 
		Record["Wea1Del"] := Bin.ReadUInt() 
		Record["Wea1Vol"] := Bin.ReadUInt() 
		Record["Attack2"] := Bin.ReadUInt() 
		Record["Att2Del"] := Bin.ReadUInt() 
		Record["Att2Prb"] := Bin.ReadUInt() 
		Record["Weapon2"] := Bin.ReadUInt() 
		Record["Wea2Del"] := Bin.ReadUInt() 
		Record["Wea2Vol"] := Bin.ReadUInt() 
		Record["HitSound"] := Bin.ReadUInt() 
		Record["HitDelay"] := Bin.ReadUInt() 
		Record["DeathSound"] := Bin.ReadUInt() 
		Record["DeaDelay"] := Bin.ReadUInt() 
		Record["Skill1"] := Bin.ReadUInt() 
		Record["Skill2"] := Bin.ReadUInt() 
		Record["Skill3"] := Bin.ReadUInt() 
		Record["Skill4"] := Bin.ReadUInt() 
		Record["Footstep"] := Bin.ReadUInt() 
		Record["FootstepLayer"] := Bin.ReadUInt() 
		Record["FsCnt"] := Bin.ReadUInt() 
		Record["FsOff"] := Bin.ReadUInt() 
		Record["FsPrb"] := Bin.ReadUInt() 
		Record["Neutral"] := Bin.ReadUInt() 
		Record["NeuTime"] := Bin.ReadUInt() 
		Record["Init"] := Bin.ReadUInt() 
		Record["Taunt"] := Bin.ReadUInt() 
		Record["Flee"] := Bin.ReadUInt() 
		Record["CvtMo1"] := Bin.ReadUChar() 
		Record["CvtTgt1"] := Bin.ReadUChar() 
		Record["iPadding31"] := Bin.Read(2) 
		Record["CvtSk1"] := Bin.ReadUInt() 
		Record["CvtMo2"] := Bin.ReadUChar() 
		Record["CvtTgt2"] := Bin.ReadUChar() 
		Record["iPadding33"] := Bin.Read(2) 
		Record["CvtSk2"] := Bin.ReadUInt() 
		Record["CvtMo3"] := Bin.ReadUChar() 
		Record["CvtTgt3"] := Bin.ReadUChar() 
		Record["iPadding35"] := Bin.Read(2) 
		Record["CvtSk3"] := Bin.ReadUInt()
		
		InsertQuick("DigestDB","Decompile | " module,Record)		
		
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}