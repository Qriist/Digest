;complete
Digest_Bin_110f_itemtypes(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Seek(4)
	RecordSize := 228

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 228
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Code"] := Trim(Bin.Read(4))
		Record["Equiv1"] := Bin.ReadUShort() 
		Record["Equiv2"] := Bin.ReadUShort() 
		Record["Repair"] := Bin.ReadUChar() 
		Record["Body"] := Bin.ReadUChar() 
		Record["BodyLoc1"] := Bin.ReadUChar() 
		Record["BodyLoc2"] := Bin.ReadUChar() 
		Record["Shoots"] := Bin.ReadUShort() 
		Record["Quiver"] := Bin.ReadUShort() 
		Record["Throwable"] := Bin.ReadUChar() 
		Record["Reload"] := Bin.ReadUChar() 
		Record["ReEquip"] := Bin.ReadUChar() 
		Record["AutoStack"] := Bin.ReadUChar() 
		Record["Magic"] := Bin.ReadUChar() 
		Record["Rare"] := Bin.ReadUChar() 
		Record["Normal"] := Bin.ReadUChar() 
		Record["Charm"] := Bin.ReadUChar() 
		Record["Gem"] := Bin.ReadUChar() 
		Record["Beltable"] := Bin.ReadUChar() 
		Record["MaxSock1"] := Bin.ReadUChar() 
		Record["MaxSock25"] := Bin.ReadUChar() 
		Record["MaxSock40"] := Bin.ReadUChar() 
		Record["TreasureClass"] := Bin.ReadUChar() 
		Record["Rarity"] := Bin.ReadUChar() 
		Record["StaffMods"] := Bin.ReadUChar() 
		Record["CostFormula"] := Bin.ReadUChar() 
		Record["Class"] := Bin.ReadUChar() 
		Record["StorePage"] := Bin.ReadUChar() 
		Record["VarInvGfx"] := Bin.ReadUChar() 
		Record["InvGfx1"] := Trim(Bin.Read(32))
		Record["InvGfx2"] := Trim(Bin.Read(32))
		Record["InvGfx3"] := Trim(Bin.Read(32))
		Record["InvGfx4"] := Trim(Bin.Read(32))
		Record["InvGfx5"] := Trim(Bin.Read(32))
		Record["InvGfx6"] := Trim(Bin.Read(32))
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