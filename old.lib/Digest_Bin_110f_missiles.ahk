Digest_Bin_110f_missiles(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 420

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 420
		;BITFIELDS ARE PRESENT!
		RecordID := a_index 
		Digest[ModFullName,"Decompile",Module,RecordID,"Id"] := Bin.ReadUInt() 
		Digest[ModFullName,"Decompile",Module,RecordID,"BitCombined"] := Bin.ReadUShort() 
		
		;Start bitfield operations
		Flags := Digest[ModFullName,"Decompile",Module,RecordID,"BitCombined"]
		;~ If Flags = 
		;~ msgbox,YOU HAVE NOT FIXED THE BITFIELDS FOR MODULE %module%.
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["MissileSkill"] := substr(Flags,1,1) 
		Record["Half2HSrc"] := substr(Flags,2,1) 
		Record["NoUniqueMod"] := substr(Flags,3,1) 
		Record["NoMultiShot"] := substr(Flags,4,1) 
		Record["SrcTown"] := substr(Flags,5,1) 
		Record["Town"] := substr(Flags,6,1) 
		Record["ReturnFire"] := substr(Flags,7,1) 
		Record["ApplyMastery"] := substr(Flags,8,1) 
		Record["SoftHit"] := substr(Flags,9,1) 
		Record["GetHit"] := substr(Flags,10,1) 
		Record["ClientSend"] := substr(Flags,11,1) 
		Record["CanDestroy"] := substr(Flags,12,1) 
		Record["CanSlow"] := substr(Flags,13,1) 
		Record["Pierce"] := substr(Flags,14,1) 
		Record["Explosion"] := substr(Flags,15,1) 
		Record["LastCollide"] := substr(Flags,16,1) 
		Record["wPadding"] := Bin.ReadUShort() 
		Record["pCltDoFunc"] := Bin.ReadUShort() 
		Record["pCltHitFunc"] := Bin.ReadUShort() 
		Record["pSrvDoFunc"] := Bin.ReadUShort() 
		Record["pSrvHitFunc"] := Bin.ReadUShort() 
		Record["pSrvDmgFunc"] := Bin.ReadUShort() 
		Record["TravelSound"] := Bin.ReadUShort() 
		Record["HitSound"] := Bin.ReadUShort() 
		Record["ExplosionMissile"] := Bin.ReadUShort() 
		Record["SubMissile1"] := Bin.ReadUShort() 
		Record["SubMissile2"] := Bin.ReadUShort() 
		Record["SubMissile3"] := Bin.ReadUShort() 
		Record["CltSubMissile1"] := Bin.ReadUShort() 
		Record["CltSubMissile2"] := Bin.ReadUShort() 
		Record["CltSubMissile3"] := Bin.ReadUShort() 
		Record["HitSubMissile1"] := Bin.ReadUShort() 
		Record["HitSubMissile2"] := Bin.ReadUShort() 
		Record["HitSubMissile3"] := Bin.ReadUShort() 
		Record["HitSubMissile4"] := Bin.ReadUShort() 
		Record["CltHitSubMissile1"] := Bin.ReadUShort() 
		Record["CltHitSubMissile2"] := Bin.ReadUShort() 
		Record["CltHitSubMissile3"] := Bin.ReadUShort() 
		Record["CltHitSubMissile4"] := Bin.ReadUShort() 
		Record["ProgSound"] := Bin.ReadUShort() 
		Record["ProgOverlay"] := Bin.ReadUShort() 
		Record["Param1"] := Bin.ReadInt() 
		Record["Param2"] := Bin.ReadInt() 
		Record["Param3"] := Bin.ReadInt() 
		Record["Param4"] := Bin.ReadInt() 
		Record["Param5"] := Bin.ReadInt() 
		Record["sHitPar1"] := Bin.ReadInt() 
		Record["sHitPar2"] := Bin.ReadInt() 
		Record["sHitPar3"] := Bin.ReadInt() 
		Record["CltParam1"] := Bin.ReadInt() 
		Record["CltParam2"] := Bin.ReadInt() 
		Record["CltParam3"] := Bin.ReadInt() 
		Record["CltParam4"] := Bin.ReadInt() 
		Record["CltParam5"] := Bin.ReadInt() 
		Record["cHitPar1"] := Bin.ReadInt() 
		Record["cHitPar2"] := Bin.ReadInt() 
		Record["cHitPar3"] := Bin.ReadInt() 
		Record["dParam1"] := Bin.ReadInt() 
		Record["dParam2"] := Bin.ReadInt() 
		Record["SrvCalc1"] := Bin.ReadUInt() 
		Record["CltCalc1"] := Bin.ReadUInt() 
		Record["SHitCalc1"] := Bin.ReadUInt() 
		Record["CHitCalc1"] := Bin.ReadUInt() 
		Record["DmgCalc1"] := Bin.ReadUInt() 
		Record["HitClass"] := Bin.ReadUShort() 
		Record["Range"] := Bin.ReadUShort() 
		Record["LevRange"] := Bin.ReadUShort() 
		Record["Vel"] := Bin.ReadUChar() 
		Record["VelLev"] := Bin.ReadUChar() 
		Record["MaxVel"] := Bin.ReadUShort() 
		Record["Accel"] := Bin.ReadShort() 
		Record["animrate"] := Bin.ReadUShort() 
		Record["xoffset"] := Bin.ReadShort() 
		Record["yoffset"] := Bin.ReadShort() 
		Record["zoffset"] := Bin.ReadShort() 
		Record["HitFlags"] := Bin.ReadUInt() 
		Record["ResultFlags"] := Bin.ReadUShort() 
		Record["KnockBack"] := Bin.ReadUChar() 
		;~ Record["bPadding3"] := 
		Bin.ReadChar() 
		Record["MinDamage"] := Bin.ReadUInt() 
		Record["MaxDamage"] := Bin.ReadUInt() 
		Record["MinLevDam1"] := Bin.ReadUInt() 
		Record["MinLevDam2"] := Bin.ReadUInt() 
		Record["MinLevDam3"] := Bin.ReadUInt() 
		Record["MinLevDam4"] := Bin.ReadUInt() 
		Record["MinLevDam5"] := Bin.ReadUInt() 
		Record["MaxLevDam1"] := Bin.ReadUInt() 
		Record["MaxLevDam2"] := Bin.ReadUInt() 
		Record["MaxLevDam3"] := Bin.ReadUInt() 
		Record["MaxLevDam4"] := Bin.ReadUInt() 
		Record["MaxLevDam5"] := Bin.ReadUInt() 
		Record["DmgSymPerCalc"] := Bin.ReadUInt() 
		Record["EType"] := Bin.ReadUInt() 
		Record["EMin"] := Bin.ReadUInt() 
		Record["Emax"] := Bin.ReadUInt() 
		Record["MinELev1"] := Bin.ReadUInt() 
		Record["MinELev2"] := Bin.ReadUInt() 
		Record["MinELev3"] := Bin.ReadUInt() 
		Record["MinELev4"] := Bin.ReadUInt() 
		Record["MinELev5"] := Bin.ReadUInt() 
		Record["MaxELev1"] := Bin.ReadUInt() 
		Record["MaxELev2"] := Bin.ReadUInt() 
		Record["MaxELev3"] := Bin.ReadUInt() 
		Record["MaxELev4"] := Bin.ReadUInt() 
		Record["MaxELev5"] := Bin.ReadUInt() 
		Record["EDmgSymPerCalc"] := Bin.ReadUInt() 
		Record["ELen"] := Bin.ReadUInt() 
		Record["ELevLen1"] := Bin.ReadUInt() 
		Record["ELevLen2"] := Bin.ReadUInt() 
		Record["ELevLen3"] := Bin.ReadUInt() 
		Record["CltSrcTown "] := Bin.ReadUChar() 
		Record["SrcDamage"] := Bin.ReadUChar() 
		Record["SrcMissDmg"] := Bin.ReadUChar() 
		Record["Holy"] := Bin.ReadUChar() 
		Record["Light"] := Bin.ReadUChar() 
		Record["Flicker"] := Bin.ReadUChar() 
		Record["Red"] := Bin.ReadUChar() 
		Record["Green"] := Bin.ReadUChar() 
		Record["Blue"] := Bin.ReadUChar() 
		Record["InitSteps"] := Bin.ReadUChar() 
		Record["Activate"] := Bin.ReadUChar() 
		Record["LoopAnim"] := Bin.ReadUChar() 
		Record["CelFile"] := Bin.Read(64) 
		Record["AnimLen"] := Bin.ReadUInt() 
		Record["RandStart"] := Bin.ReadUInt() 
		Record["SubLoop"] := Bin.ReadUChar() 
		Record["SubStart"] := Bin.ReadUChar() 
		Record["SubStop"] := Bin.ReadUChar() 
		Record["CollideType"] := Bin.ReadUChar() 
		Record["Collision"] := Bin.ReadUChar() 
		Record["ClientCol"] := Bin.ReadUChar() 
		Record["CollideKill"] := Bin.ReadUChar() 
		Record["CollideFriend"] := Bin.ReadUChar() 
		Record["NextHit"] := Bin.ReadUChar() 
		Record["NextDelay"] := Bin.ReadUChar() 
		Record["Size"] := Bin.ReadUChar() 
		Record["ToHit"] := Bin.ReadUChar() 
		Record["AlwaysExplode"] := Bin.ReadUChar() 
		Record["Trans"] := Bin.ReadUChar() 
		Record["Qty"] := Bin.ReadUShort() 
		Record["SpecialSetup"] := Bin.ReadUInt() 
		Record["Skill"] := Bin.ReadUShort() 
		Record["HitShift"] := Bin.ReadUShort() 
		;~ Record["iPadding3"] := 
		Bin.ReadUInt() 
		Record["DamageRate"] := Bin.ReadUInt() 
		Record["NumDirections"] := Bin.ReadUChar() 
		Record["AnimSpeed"] := Bin.ReadUChar() 
		Record["LocalBlood"] := Bin.ReadUChar() 
		Record["bUnKnown2"] := Bin.ReadUChar()
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