;complete
Digest_Bin_110f_inventory(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 240

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 240
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["invLeft"] := Bin.ReadInt() 
		Record["invRight"] := Bin.ReadInt() 
		Record["invTop"] := Bin.ReadInt() 
		Record["invBottom"] := Bin.ReadInt() 
		Record["gridX"] := Bin.ReadChar() 
		Record["gridY"] := Bin.ReadChar() 
		Record["iPadding4"] := Bin.ReadUShort() 
		Record["gridLeft"] := Bin.ReadInt() 
		Record["gridRight"] := Bin.ReadInt() 
		Record["gridTop"] := Bin.ReadInt() 
		Record["gridBottom"] := Bin.ReadInt() 
		Record["gridBoxWidth"] := Bin.ReadChar() 
		Record["gridBoxHeight"] := Bin.ReadChar() 
		Record["iPadding9"] := Bin.ReadUShort() 
		Record["rArmLeft"] := Bin.ReadInt() 
		Record["rArmRight"] := Bin.ReadInt() 
		Record["rArmTop"] := Bin.ReadInt() 
		Record["rArmBottom"] := Bin.ReadInt() 
		Record["rArmWidth"] := Bin.ReadChar() 
		Record["rArmHeight"] := Bin.ReadChar() 
		Record["iPadding14"] := Bin.ReadUShort() 
		Record["torsoLeft"] := Bin.ReadInt() 
		Record["torsoRight"] := Bin.ReadInt() 
		Record["torsoTop"] := Bin.ReadInt() 
		Record["torsoBottom"] := Bin.ReadInt() 
		Record["torsoWidth"] := Bin.ReadChar() 
		Record["torsoHeight"] := Bin.ReadChar() 
		Record["iPadding19"] := Bin.ReadUShort() 
		Record["lArmLeft"] := Bin.ReadInt() 
		Record["lArmRight"] := Bin.ReadInt() 
		Record["lArmTop"] := Bin.ReadInt() 
		Record["lArmBottom"] := Bin.ReadInt() 
		Record["lArmWidth"] := Bin.ReadChar() 
		Record["lArmHeight"] := Bin.ReadChar() 
		Record["iPadding24"] := Bin.ReadUShort() 
		Record["headLeft"] := Bin.ReadInt() 
		Record["headRight"] := Bin.ReadInt() 
		Record["headTop"] := Bin.ReadInt() 
		Record["headBottom"] := Bin.ReadInt() 
		Record["headWidth"] := Bin.ReadChar() 
		Record["headHeight"] := Bin.ReadChar() 
		Record["iPadding29"] := Bin.ReadUShort() 
		Record["neckLeft"] := Bin.ReadInt() 
		Record["neckRight"] := Bin.ReadInt() 
		Record["neckTop"] := Bin.ReadInt() 
		Record["neckBottom"] := Bin.ReadInt() 
		Record["neckWidth"] := Bin.ReadChar() 
		Record["neckHeight"] := Bin.ReadChar() 
		Record["iPadding34"] := Bin.ReadUShort() 
		Record["rHandLeft"] := Bin.ReadInt() 
		Record["rHandRight"] := Bin.ReadInt() 
		Record["rHandTop"] := Bin.ReadInt() 
		Record["rHandBottom"] := Bin.ReadInt() 
		Record["rHandWidth"] := Bin.ReadChar() 
		Record["rHandHeight"] := Bin.ReadChar() 
		Record["iPadding39"] := Bin.ReadUShort() 
		Record["lHandLeft"] := Bin.ReadInt() 
		Record["lHandRight"] := Bin.ReadInt() 
		Record["lHandTop "] := Bin.ReadInt() 
		Record["lHandBottom"] := Bin.ReadInt() 
		Record["lHandWidth"] := Bin.ReadChar() 
		Record["lHandHeight"] := Bin.ReadChar() 
		Record["iPadding44"] := Bin.ReadUShort() 
		Record["beltLeft"] := Bin.ReadInt() 
		Record["beltRight"] := Bin.ReadInt() 
		Record["beltTop"] := Bin.ReadInt() 
		Record["beltBottom"] := Bin.ReadInt() 
		Record["beltWidth"] := Bin.ReadChar() 
		Record["beltHeight"] := Bin.ReadChar() 
		Record["iPadding49"] := Bin.ReadUShort() 
		Record["feetLeft"] := Bin.ReadInt() 
		Record["feetRight"] := Bin.ReadInt() 
		Record["feetTop"] := Bin.ReadInt() 
		Record["feetBottom"] := Bin.ReadInt() 
		Record["feetWidth"] := Bin.ReadChar() 
		Record["feetHeight"] := Bin.ReadChar() 
		Record["iPadding54"] := Bin.ReadUShort() 
		Record["glovesLeft"] := Bin.ReadInt() 
		Record["glovesRight"] := Bin.ReadInt() 
		Record["glovesTop"] := Bin.ReadInt() 
		Record["glovesBottom"] := Bin.ReadInt() 
		Record["glovesWidth"] := Bin.ReadChar() 
		Record["glovesHeight"] := Bin.ReadChar() 
		Record["iPadding59"] := Bin.ReadUShort()
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