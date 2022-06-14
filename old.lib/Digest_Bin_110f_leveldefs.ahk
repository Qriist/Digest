;complete
Digest_Bin_110f_leveldefs(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 156
	
	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 156
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["QuestFlag"] := Bin.ReadInt() 
		Record["QuestFlagEx"] := Bin.ReadInt() 
		Record["Layer"] := Bin.ReadInt() 
		Record["SizeX"] := Bin.ReadInt() 
		Record["SizeX(N)"] := Bin.ReadInt() 
		Record["SizeX(H)"] := Bin.ReadInt() 
		Record["SizeY"] := Bin.ReadInt() 
		Record["SizeY(N)"] := Bin.ReadInt() 
		Record["SizeY(H)"] := Bin.ReadInt() 
		Record["OffsetX"] := Bin.ReadInt() 
		Record["OffsetY"] := Bin.ReadInt() 
		Record["Depend"] := Bin.ReadInt() 
		Record["DrlgType"] := Bin.ReadInt() 
		Record["LevelType"] := Bin.ReadInt() 
		Record["SubType"] := Bin.ReadInt() 
		Record["SubTheme"] := Bin.ReadInt() 
		Record["SubWaypoint"] := Bin.ReadInt() 
		Record["SubShrine"] := Bin.ReadInt() 
		Record["Vis0"] := Bin.ReadInt() 
		Record["Vis1"] := Bin.ReadInt() 
		Record["Vis2"] := Bin.ReadInt() 
		Record["Vis3"] := Bin.ReadInt() 
		Record["Vis4"] := Bin.ReadInt() 
		Record["Vis5"] := Bin.ReadInt() 
		Record["Vis6"] := Bin.ReadInt() 
		Record["Vis7"] := Bin.ReadInt() 
		Record["Warp0"] := Bin.ReadInt() 
		Record["Warp1"] := Bin.ReadInt() 
		Record["Warp2"] := Bin.ReadInt() 
		Record["Warp3"] := Bin.ReadInt() 
		Record["Warp4"] := Bin.ReadInt() 
		Record["Warp5"] := Bin.ReadInt() 
		Record["Warp6"] := Bin.ReadInt() 
		Record["Warp7"] := Bin.ReadInt() 
		Record["Intensity"] := Bin.ReadUChar() 
		Record["Red"] := Bin.ReadUChar() 
		Record["Green"] := Bin.ReadUChar() 
		Record["Blue"] := Bin.ReadUChar() 
		Record["Portal"] := Bin.ReadInt() 
		Record["Position"] := Bin.ReadInt() 
		Record["SaveMonsters"] := Bin.ReadUChar() 
		Record["LOSDraw"] := Bin.ReadInt()
		
		InsertQuick("DigestDB","Decompile | " module,Record)		
		
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}