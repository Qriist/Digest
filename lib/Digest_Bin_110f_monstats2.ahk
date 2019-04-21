;complete
Digest_Bin_110f_monstats2(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 308
	
	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 308
		;BITFIELDS ARE PRESENT!
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Id"] := Bin.ReadUInt() 
		Record["BitCombined1"] := Bin.ReadUChar() 
		Record["BitCombined2"] := Bin.ReadUChar() 
		Record["BitCombined3"] := Bin.ReadUChar() 
		
		;Start bitfield operations
		Flags := Record["BitCombined1"] Record["BitCombined2"] Record["BitCombined3"]
		Record["corpseSel"] := substr(Flags,1,1) 
		Record["shiftSel"] := substr(Flags,2,1) 
		Record["noSel"] := substr(Flags,3,1) 
		Record["alSel"] := substr(Flags,4,1) 
		Record["isSel"] := substr(Flags,5,1) 
		Record["noOvly"] := substr(Flags,6,1) 
		Record["noMap"] := substr(Flags,7,1) 
		Record["noGfxHitTest"] := substr(Flags,8,1) 
		Record["noUniqueShift"] := substr(Flags,9,1) 
		Record["Shadow"] := substr(Flags,10,1) 
		Record["critter"] := substr(Flags,11,1) 
		Record["soft"] := substr(Flags,12,1) 
		Record["large"] := substr(Flags,13,1) 
		Record["small"] := substr(Flags,14,1) 
		Record["isAtt"] := substr(Flags,15,1) 
		Record["revive"] := substr(Flags,16,1) 
		Record["iPadding1_2"] := substr(Flags,19,3) 
		Record["unflatDead"] := substr(Flags,20,1) 
		Record["deadCol"] := substr(Flags,21,1) 
		Record["objCol"] := substr(Flags,22,1) 
		Record["inert"] := substr(Flags,23,1) 
		Record["compositeDeath"] := substr(Flags,24,1) 
		Record["iPadding1"] := Bin.ReadUChar() 
		Record["SizeX"] := Bin.ReadUChar() 
		Record["SizeY"] := Bin.ReadUChar() 
		Record["spawnCol"] := Bin.ReadUChar() 
		Record["Height"] := Bin.ReadUChar() 
		Record["OverlayHeight"] := Bin.ReadUChar() 
		Record["pixHeight"] := Bin.ReadUChar() 
		Record["MeleeRng"] := Bin.ReadUChar() 
		Record["iPadding3"] := Bin.ReadUChar() 
		Record["BaseW"] := Trim(Bin.Read(4))
		Record["HitClass"] := Bin.ReadUChar() 
		Record["HDvNum"] := Bin.ReadUChar() 
		Record["TRvNum"] := Bin.ReadUChar() 
		Record["LGvNum"] := Bin.ReadUChar() 
		Record["RavNum"] := Bin.ReadUChar() 
		Record["LavNum"] := Bin.ReadUChar() 
		Record["RHvNum"] := Bin.ReadUChar() 
		Record["LHvNum"] := Bin.ReadUChar() 
		Record["SHvNum"] := Bin.ReadUChar() 
		Record["S1vNum"] := Bin.ReadUChar() 
		Record["S2vNum"] := Bin.ReadUChar() 
		Record["S3vNum"] := Bin.ReadUChar() 
		Record["S4vNum"] := Bin.ReadUChar() 
		Record["S5vNum"] := Bin.ReadUChar() 
		Record["S6vNum"] := Bin.ReadUChar() 
		Record["S7vNum"] := Bin.ReadUChar() 
		Record["S8vNum"] := Bin.ReadUChar() 
		Record["iPadding9"] := Bin.ReadUChar() 
		Record["HDv"] := Trim(Bin.Read(12))
		Record["TRv"] := Trim(Bin.Read(12))
		Record["LGv"] := Trim(Bin.Read(12))
		Record["Rav"] := Trim(Bin.Read(12))
		Record["Lav"] := Trim(Bin.Read(12))
		Record["RHv"] := Trim(Bin.Read(12))
		Record["LHv"] := Trim(Bin.Read(12))
		Record["SHv"] := Trim(Bin.Read(12))
		Record["S1v"] := Trim(Bin.Read(12))
		Record["S2v"] := Trim(Bin.Read(12))
		Record["S3v"] := Trim(Bin.Read(12))
		Record["S4v"] := Trim(Bin.Read(12))
		Record["S5v"] := Trim(Bin.Read(12))
		Record["S6v"] := Trim(Bin.Read(12))
		Record["S7v"] := Trim(Bin.Read(12))
		Record["S8v"] := Trim(Bin.Read(12))
		Record["iPadding57"] := Bin.ReadUShort() 
		Record["BitCombined4"] := Bin.ReadUChar() 
		Record["BitCombined5"] := Bin.ReadUChar() 
		Record["SH"] := substr(Flags,25,1) 
		Record["LH"] := substr(Flags,26,1) 
		Record["RH"] := substr(Flags,27,1) 
		Record["LA"] := substr(Flags,28,1) 
		Record["RA"] := substr(Flags,29,1) 
		Record["LG"] := substr(Flags,30,1) 
		Record["TR"] := substr(Flags,31,1) 
		Record["HD"] := substr(Flags,32,1) 
		Record["S8"] := substr(Flags,33,1) 
		Record["S7"] := substr(Flags,34,1) 
		Record["S6"] := substr(Flags,35,1) 
		Record["S5"] := substr(Flags,36,1) 
		Record["S4"] := substr(Flags,37,1) 
		Record["S3"] := substr(Flags,38,1) 
		Record["S2"] := substr(Flags,39,1) 
		Record["S1"] := substr(Flags,40,1) 
		Record["iPadding58"] := Bin.Read(2) 
		Record["TotalPieces"] := Bin.ReadUInt() 
		Record["BitCombined6"] := Bin.ReadUChar() 
		Record["BitCombined7"] := Bin.ReadUChar() 
		Record["mSC"] := substr(Flags,41,1) 
		Record["mBL"] := substr(Flags,42,1) 
		Record["mA2"] := substr(Flags,43,1) 
		Record["mA1"] := substr(Flags,44,1) 
		Record["mGH"] := substr(Flags,45,1) 
		Record["mWL"] := substr(Flags,46,1) 
		Record["mNU"] := substr(Flags,47,1) 
		Record["mDT"] := substr(Flags,48,1) 
		Record["mRN"] := substr(Flags,49,1) 
		Record["mSQ"] := substr(Flags,50,1) 
		Record["mKB"] := substr(Flags,51,1) 
		Record["mDD"] := substr(Flags,52,1) 
		Record["mS4"] := substr(Flags,53,1) 
		Record["mS3"] := substr(Flags,54,1) 
		Record["mS2"] := substr(Flags,55,1) 
		Record["mS1"] := substr(Flags,56,1) 
		Record["iPadding60"] := Bin.ReadUShort() 
		Record["dDT"] := Bin.ReadUChar() 
		Record["dNU"] := Bin.ReadUChar() 
		Record["dWL"] := Bin.ReadUChar() 
		Record["dGH"] := Bin.ReadUChar() 
		Record["dA1"] := Bin.ReadUChar() 
		Record["dA2"] := Bin.ReadUChar() 
		Record["dBL"] := Bin.ReadUChar() 
		Record["dSC"] := Bin.ReadUChar() 
		Record["dS1"] := Bin.ReadUChar() 
		Record["dS2"] := Bin.ReadUChar() 
		Record["dS3"] := Bin.ReadUChar() 
		Record["dS4"] := Bin.ReadUChar() 
		Record["dDD"] := Bin.ReadUChar() 
		Record["dKB"] := Bin.ReadUChar() 
		Record["dSQ"] := Bin.ReadUChar() 
		Record["dRN"] := Bin.ReadUChar() 
		Record["BitCombined8"] := Bin.ReadUChar() 
		Record["BitCombined9"] := Bin.ReadUChar() 
		Record["SCmv"] := substr(Flags,57,1) 
		Record["iPadding65_1"] := substr(Flags,58,1) 
		Record["A2mv"] := substr(Flags,59,1) 
		Record["A1mv"] := substr(Flags,60,1) 
		Record["iPadding65"] := substr(Flags,64,4) 
		Record["iPadding65_2"] := substr(Flags,68,4) 
		Record["S4mv"] := substr(Flags,69,1) 
		Record["S3mv"] := substr(Flags,70,1) 
		Record["S2mv"] := substr(Flags,71,1) 
		Record["S1mv"] := substr(Flags,72,1) 
		Record["iPadding65"] := Bin.Read(2) 
		Record["InfernoLen"] := Bin.ReadUChar() 
		Record["InfernoAnim"] := Bin.ReadUChar() 
		Record["InfernoRollback"] := Bin.ReadUChar() 
		Record["ResurrectMode"] := Bin.ReadUChar() 
		Record["ResurrectSkill"] := Bin.ReadUShort() 
		Record["htTop"] := Bin.ReadShort() 
		Record["htLeft"] := Bin.ReadShort() 
		Record["htWidth"] := Bin.ReadShort() 
		Record["htHeight"] := Bin.ReadShort() 
		Record["iPadding69"] := Bin.ReadUShort() 
		Record["automapCel"] := Bin.ReadUInt() 
		Record["localBlood"] := Bin.ReadUChar() 
		Record["Bleed"] := Bin.ReadUChar() 
		Record["Light"] := Bin.ReadUChar() 
		Record["light-r"] := Bin.ReadUChar() 
		Record["light-g"] := Bin.ReadUChar() 
		Record["light-b"] := Bin.ReadUChar() 
		Record["Utrans"] := Bin.ReadUChar() 
		Record["Utrans(N)"] := Bin.ReadUChar() 
		Record["Utrans(H)"] := Bin.ReadUChar() 
		Record["acPaddding"] := Bin.Read(3) 
		Record["Heart"] := Trim(Bin.Read(4))
		Record["BodyPart"] := Trim(Bin.Read(4))
		Record["restore"] := Bin.ReadUInt()
		
		
		InsertQuick("DigestDB","Decompile | " module,Record)		
		
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}