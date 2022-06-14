;complete
Digest_Bin_110f_overlay(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 132
	
	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 132
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Filename"] := Trim(Bin.Read(64))
		Record["version"] := Bin.ReadUShort() 
		Record["Frames"] := Bin.ReadUInt() 
		Record["PreDraw"] := Bin.ReadUInt() 
		Record["1ofN"] := Bin.ReadUInt() 
		Record["Dir"] := Bin.ReadUChar() 
		Record["Open"] := Bin.ReadUChar() 
		Record["Beta"] := Bin.ReadUShort() 
		Record["Xoffset"] := Bin.ReadInt() 
		Record["Yoffset"] := Bin.ReadInt() 
		Record["Height1"] := Bin.ReadInt() 
		Record["Height2"] := Bin.ReadInt() 
		Record["Height3"] := Bin.ReadInt() 
		Record["Height4"] := Bin.ReadInt() 
		Record["AnimRate"] := Bin.ReadUInt() 
		Record["InitRadius"] := Bin.ReadUInt() 
		Record["Radius"] := Bin.ReadUInt() 
		Record["LoopWaitTime"] := Bin.ReadUInt() 
		Record["Trans"] := Bin.ReadUChar() 
		Record["Red"] := Bin.ReadUChar() 
		Record["Green"] := Bin.ReadUChar() 
		Record["Blue"] := Bin.ReadUChar() 
		Record["NumDirections"] := Bin.ReadUChar() 
		Record["LocalBlood"] := Bin.ReadUChar()
		
		InsertQuick("DigestDB","Decompile | " module,Record)		
		
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}