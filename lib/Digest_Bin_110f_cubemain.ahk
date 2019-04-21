;complete
Digest_Bin_110f_cubemain(BinToDecompile)
{
	global
	
	MODNUM=1
	
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Seek(4)
	RecordSize := 328
	;~ msgbox % Digest.GetCapacity()
	
	;~ msgbox % Digest.GetCapacity()
	
	static QualityList := strsplit("low,nor,hiq,mag,set,rar,uni,crf,tmp",",")
	
	;~ MsgBox % (Bin.Length  - 4) / RecordSize
	Digest[ModFullName,"Decompile",Module] := {}
	Digest[ModFullName,"Decompile",Module].SetCapacity((Bin.Length  - 4) / RecordSize)
	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 1000 ) OR if (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 328
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["ModNum"] := ModNum ; For DBA
		Record["RecordID"] := RecordID ; For DBA
		
		Record["enabled"] := Bin.ReadUChar() 
		Record["ladder"] := Bin.ReadUChar() 
		Record["min diff"] := Bin.ReadUChar() 
		Record["class"] := Bin.ReadUChar() 
		Record["op"] := Bin.ReadUInt() 
		Record["param"] := Bin.ReadUInt() 
		Record["value"] := Bin.ReadUInt() 
		Record["numinputs"] := Bin.ReadUShort() 
		Record["version"] := Bin.ReadUShort() 
		
		/*
			BEGIN BITFIELD OPERATIONS
		*/
		Loop,7
		{
			ItemIndex := a_index
			Record["input " ItemIndex " Input Flags"] := ToBin(Bin.ReadUChar(),2)
			Record["input " ItemIndex " Item Type"] := ToBin(Bin.ReadUChar(),2)
			Record["input " ItemIndex " Input"] := Bin.ReadUShort()
			Record["input " ItemIndex " Input ID"] := Bin.ReadUShort()
			Record["input " ItemIndex " Quality"] := Bin.ReadUChar()
			Record["input " ItemIndex " Quantity"] := Bin.ReadUChar()
			
				;~ BYTE nInputFlags;               //0x00
				;~ 1	upg		upgrades item (nor>exc>eli)
				;~ 2			itemcode (for consumables?) 
				;~ 3	noe		Non etheral only
				;~ 4	eth		Etheral only
				;~ 5	sock	Socketed only
				;~ 6	nos		Non socketed only
				;~ 7	*		unique or set item directly referenced ( by name )
				;~ 8	any		use any item of this type
			
			
				;~ BYTE nItemType;                  //0x01
				;~ 1	*N/A*	
				;~ 2	*N/A*
				;~ 3	*N/A*
				;~ 4	*N/A*
				;~ 5	nru		no runes
				;~ 6	eli		elite tier
				;~ 7	exc		exceptional tier
				;~ 8	bas		basic tier
				;~ if (input " ItemIndex " =1) AND (substr(Record["input " ItemIndex " Input Flags"],4,1) !=0)
			;~ msgbox % Record["input " ItemIndex " Input Flags"] "`n" RecordID+1
			
			
				;~ WORD wItem;                     //0x02
			
			
				;~ WORD wItemID;                  //0x04
			
			
				;~ BYTE nQuality;                  //0x06
				;~ controls the required item type of this input
				;~ 00	(no special properties required)
				;~ 01	low
				;~ 02	nor
				;~ 03	hiq
				;~ 04	mag
				;~ 05	set
				;~ 06	rar
				;~ 07	uni
				;~ 08	crf
				;~ 09	tmp
			
			
				;~ BYTE nQuantity;                  //0x07
				;~ Controls the qty=x parameter
				;~ Single digit that corresponds directly to the 0-255 number
				;~ but! if the input exists (ie, you are calling for this input) then a 0 is treated as a defacto 1 in the game.
			
			
			;Properties order: Input OR ITEMID, any, eli|exc|bas, eth|noe, Quality, upg, sock|nos, nru, qty
			/*
				Input
			*/
			If Record["input " ItemIndex " Input ID"] !=0
			{
				Record["input " ItemIndex] := "INPUTID " Record["input " ItemIndex " Input ID"]
			}
			else if Record["input " ItemIndex " Input"] !=0
			{
				Record["input " ItemIndex] := "INPUT " Record["input " ItemIndex " Input"]
				If Record["input " ItemIndex] = "INPUT 65535"
					Record["input " ItemIndex] := "any"
			}
			else
				Record["input " ItemIndex] := ""
					;~ continue
			
			
			/*
				eli|exc|bas
			*/
			If SubStr(Record["input " ItemIndex " Item Type"],6,1)=1
				Record["input " ItemIndex] .= ",eli"
			else If SubStr(Record["input " ItemIndex " Item Type"],7,1)=1
				Record["input " ItemIndex] .= ",exc"
			else If SubStr(Record["input " ItemIndex " Item Type"],8,1)=1
				Record["input " ItemIndex] .= ",bas"
			
			/*
				Quality
			*/
			if  QualityList[Record["input " ItemIndex " Quality"]] > 0
				Record["input " ItemIndex] .= "," QualityList[Record["input " ItemIndex " Quality"]]
			
			/*
				eth|noe
			*/
			If SubStr(Record["input " ItemIndex " Input Flags"],3,1) = 1
				Record["input " ItemIndex] .= ",noe"
			else if SubStr(Record["input " ItemIndex " Input Flags"],4,1) =1
				Record["input " ItemIndex] .= ",eth"
			
			/*
				sock|nos
			*/
			If SubStr(Record["input " ItemIndex " Input Flags"],5,1) = 1
				Record["input " ItemIndex] .= ",sock"
			else if SubStr(Record["input " ItemIndex " Input Flags"],6,1) = 1 
				Record["input " ItemIndex] .= ",nos"
			
			/*
				nru
			*/
			If substr(Record["input " ItemIndex " Item Type"],5,1) = 1 
				Record["input " ItemIndex] .= ",nru"
			/*
				qty
			*/
			If Record["input " ItemIndex " Quantity"] > 0
				Record["input " ItemIndex] .= ",qty=" Record["input " ItemIndex " Quantity"]
			
			/*
				any
			*/
			
			
			If (SubStr(Record["input " ItemIndex " Input Flags"],8,1) = 1)
				Record["input " ItemIndex] .= ",any"
			if StrSplit(Record["input " ItemIndex],",").length() > 1
				Record["input " ItemIndex] := """" Record["input " ItemIndex] """"
			;~ if StrSplit(Record["input " ItemIndex],",").length() > 0
				;~ If (SubStr(Record["input " ItemIndex " Input Flags"],2,1) = 1)
				;~ if InStr(Record["input " ItemIndex],"any")
				;~ if !InStr(Record["input " ItemIndex],",qty=")
				;~ if Record["input " itemindex] != ""
			;~ testarr[recordid+1,a_index] := Record["input " itemindex]
		}
		;~ Loop,7
		;~ testarr[recordid+1] := Record["input 2"]
		/*
			CEASE BITFIELD OPERATIONS
		*/
		
		
		
		
		
		
		
		
		
		
		;~ RecordID+1 is used to align the record number with the row number as viewed in AFJ Sheet.
		;~ If you are using a viewer that does not count the header row as row 1 you can safely remove the +1
		
		;~ The number in the "Literal String" is used only to visually order the bytes and holds no special meaning.
		;~ */
		;~ testarr[RecordID+1,"1 - Input Flags"] := ToBin(Bin.ReadUChar(),2) ; ToBin() converts the input byte(s) into a binary string
		;~ testarr[RecordID+1,"2 - 
		;~ testarr[RecordID+1,"2 - Item Type"] := Bin.ReadUChar()
		;~ if testarr[RecordID+1,"2 - Item Type"] = 0
			;~ testarr[RecordID+1,"2 - Item Type"] := []
		
		;~ testarr[RecordID+1,"3 - 
		;~ testarr[RecordID+1,"4 - 
		;~ If testarr[RecordID+1,"4 - Input ID"] = 0
			;~ testarr[RecordID+1,"4 - Input ID"] := [] ; blank the array element and remove the ability to expand if there's nothing to see.
		
		;~ testarr[RecordID+1,"5 - 
		;~ if testarr[RecordID+1,"5 - Quality"] = 0
			;~ testarr[RecordID+1,"5 - Quality"] := []
		
		;~ testarr[RecordID+1,"6 - 
		;~ If testarr[RecordID+1,"6 - Quantity"] = 0
			;~ testarr[RecordID+1,"6 - Quantity"] := []
		
		;Set Flags to the particular variable you are working with.
		;~ Flags := testarr[RecordID+1,"1 - Input Flags"]
		;~ Flags := testarr[RecordID+1,"2 - Item Type"]
		;~ Flags := testarr[RecordID+1,"3 - Input"]
		;~ Flags := testarr[RecordID+1,"4 - Input ID"]
		;~ Flags := testarr[RecordID+1,"5 - Quality"]
		;~ Flags := testarr[RecordID+1,"6 - Quantity"]
		
		;SubStr() retrieves a particular char/set of chars in the string.
		;In this instance, it is used to pull a certain flag and remove all array keys that don't match.
		;SubStr(String, StartingPos [, Length])
		;~ If Flags = 
		;~ If (substr(Flags,2,1)  != 1)
		;~ {
			;~ testarr.pop()
		;~ }
		/*
			
			
			enum CUBEIN_FLAGS
			{
			;byte1
				CUBEFLAG_IN_USEANY        = 1,    // any
				CUBEFLAG_IN_ITEMCODE    = 2,
				CUBEFLAG_IN_NOSOCKET    = 4,    // nos
				CUBEFLAG_IN_SOCKETED    = 8,    // sock
				CUBEFLAG_IN_ETHEREAL    = 16,    // eth
				CUBEFLAG_IN_NOETHEREAL    = 32,    // noe
				CUBEFLAG_IN_SPECIAL        = 64,    // unique or set item directly referenced ( by name )
				CUBEFLAG_IN_UPGRADED     = 128,    // upg
			;byte2
				CUBEFLAG_IN_NORMAL        = 256,    // bas
				CUBEFLAG_IN_EXCEPTIONAL    = 512,    // exc
				CUBEFLAG_IN_ELITE        = 1024,    // eli
				CUBEFLAG_IN_NORUNES        = 2048,    // nru
				// 4096 - 32768 aren't used
			};
			
			
		*/
		
		for Index, oABC in ["", "b ", "c "]
		{
			Record[oABC "output"] := ""
			/*
				struct D2CubeOutputItem
				{
					BYTE nItemFlags;               //0x00
					1	mod			CUBEFLAG_COPYMODS
					2	sock		CUBEFLAG_SOCKET
					3	eth			CUBEFLAG_ETHEREAL
					4	*			CUBEFLAG_SPECIAL
					5	uns			CUBEFLAG_UNSOCKET
					6	rem			CUBEFLAG_REMOVE
					7	reg			CUBEFLAG_NORMAL
					8	exc			CUBEFLAG_EXEPTIONAL
					BYTE nItemType;                  //0x01
					1	eli			CUBEFLAG_ELITE
					2	rep			CUBEFLAG_REPAIR
					3	rch			CUBEFLAG_RECHARGE
					4	*unused*
					5	*unused*
					6	*unused*
					7	*unused*
					8	*unused*
					WORD wItem;                     //0x02
					WORD wItemID;                  //0x04
					BYTE nQuality;                  //0x06
					BYTE nQuantity;                  //0x07
					BYTE nType;                     //0x08
					BYTE nLvl;                     //0x09
					BYTE nPLvl;                     //0x0A
					BYTE nILvl;                     //0x0B
					WORD wPrefixId;                  //0x0C
					WORD unk0x0E;                  //0x0E
					WORD unk0x10;                  //0x10
					WORD wSuffixId;                  //0x12
				};
			*/
			Record[oABC "output ItemFlags"] := Bin.ReadUChar() 
			Record[oABC "output ItemType"] := Bin.ReadUChar() 
			Record[oABC "output Item"] := Bin.ReadUShort() 
			Record[oABC "output ItemID"] := Bin.ReadUShort() 
			Record[oABC "output Quality"] := Bin.ReadUChar() 
			Record[oABC "output Quantity"] := Bin.ReadUChar() 
			Record[oABC "output Type"] := Bin.ReadUChar() 
			Record[oABC "output Lvl"] := Bin.ReadUChar() 
			Record[oABC "output PLvl"] := Bin.ReadUChar() 
			Record[oABC "output ILvl"] := Bin.ReadUChar() 
			Record[oABC "output PrefixID"] := Bin.ReadUShort() 
			Record[oABC "output unk0x0E"] := Bin.ReadUShort() 
			Record[oABC "output unk0x10"] := Bin.ReadUShort() 
			Record[oABC "output SuffixId"] := Bin.ReadUShort() 
			;~ if Record[oABC "output Type"] > 200
			;~ if Record[oABC "output Type"] < 254
			;~ if Record[oABC "output Type"] != 252
							;~ if Record[oABC "output Type"] != 253
			
				;~ msgbox % Record[oABC "output Type"]
			;~ if Record[oABC "output ItemType"] !=0
							;~ msgbox % Record[oABC "output Type"] "`n" recordid
;~ if ( 255 == Record[oABC "output Type"] )
				;~ {
			Record[oABC "output"] .= "usetype"
					;~ msgbox % recordid
				;~ }
			/*else
				BEGIN BITFIELD OPERATIONS
			*/
			;~ if ( 0 == Record[oABC "output ItemFlags"] 
			;~ && 0 == Record[oABC "output ItemType"] 
			;~ && 0 == Record[oABC "output Quality"] 
			;~ && 0 == Record[oABC "output Quantity"] 
			;~ && 0 == Record[oABC "output PrefixID"] 
			;~ && 0 == Record[oABC "output SuffixId"] )
			;~ if ( Record[oABC "output ItemFlags"] + Record[oABC "output ItemType"] + Record[oABC "output Quality"] + Record[oABC "output Quantity"] + Record[oABC "output PrefixID"] + Record[oABC "output SuffixId"] = 0)
			;~ {
			if ( 255 == Record[oABC "output Type"] )
				Record[oABC "output"] .= "usetype"
			else if ( 254 == Record[oABC "output Type"] )
				Record[oABC "output"] .= "useitem"
			else if ( 1 == Record[oABC "output Type"] )
				Record[oABC "output"] .= "Cow Portal"
			else if ( 2 == Record[oABC "output Type"] )
				Record[oABC "output"] .= "Pandemonium Portal"
			else if ( 3 == Record[oABC "output Type"] )
				Record[oABC "output"] .= "Pandemonium Finale Portal"
			else if ( 0 != Record[oABC "output ItemID"] )
				Record[oABC "output"] .= "ITEMID|" Record[oABC "output ItemID"]
			else if ( 0 != Record[oABC "output Item"] )
				Record[oABC "output"] .= "ITEM|" Record[oABC "output Item"]
			
			if ( 0 != (0x04 & Record[oABC "output ItemFlags"] ) )
				Record[oABC "output"] .= ",eth"				
			if ( 0 != (0x01 & Record[oABC "output ItemFlags"] ) )
				Record[oABC "output"] .= ",mod"
			if ( 0 != (0x80 & Record[oABC "output ItemFlags"] ) )
				Record[oABC "output"] .= ",exc"
			if ( 0 != (0x10 & Record[oABC "output ItemFlags"] ) )
				Record[oABC "output"] .= ",uns"
			if ( 0 != (0x20 & Record[oABC "output ItemFlags"] ) )
				Record[oABC "output"] .= ",rem"
			if ( 0 != (0x01 & Record[oABC "output ItemType"] ) )
				Record[oABC "output"] .= ",eli"
			if ( 0 != (0x02 & Record[oABC "output ItemType"] ) )
				Record[oABC "output"] .= ",rep"
			if ( 0 != (0x04 & Record[oABC "output ItemType"] ) )
				Record[oABC "output"] .= ",rch"
			If Record[oABC "output Quality"] > 0
				Record[oABC "output"] .= "," QualityList[Record[oABC "output Quality"]]
			If Record[oABC "output PrefixID"] > 0
				Record[oABC "output"] .= ",pre=" Record[oABC "output PrefixID"]
			If Record[oABC "output SuffixId"] > 0
				Record[oABC "output"] .= ",suf=" Record[oABC "output SuffixId"]
			
				;~ if ( 0 == (0x02 & Record[oABC "output ItemFlags"] ) && 
			if ( 0 != (0x02 & Record[oABC "output ItemFlags"] ) )
				Record[oABC "output"] .= ",sock=" Record[oABC "output Quantity"]
			else if ( 0 < Record[oABC "output Quantity"] )
				Record[oABC "output"] .= ",qty=" Record[oABC "output Quantity"]
				;~ If Record[oABC "output"] != ""
				;~ if Instr(Record[oABC "output"],"use")
				;~ if ( 0 != Record[oABC "output ItemID"] )
					;~ testarr[recordid+1,a_index] := Record[oABC "output"]
					;~ WORD wItem;                     //0x02
					;~ WORD wItemID;                  //0x04
					;~ BYTE nQuality;                  //0x06
					;~ BYTE nQuantity;                  //0x07
					;~ BYTE nType;                     //0x08
					;~ BYTE nLvl;                     //0x09
					;~ BYTE nPLvl;                     //0x0A
					;~ BYTE nILvl;                     //0x0B
					;~ WORD wPrefixId;                  //0x0C
					;~ WORD unk0x0E;                  //0x0E
					;~ WORD unk0x10;                  //0x10
					;~ WORD wSuffixId;                  //0x12
			
			
			
			/*
				CEASE BITFIELD OPERATIONS
			*/
			If a_index=1
				Record["iPadding24"] := Bin.ReadUInt() 
			else if a_index=2
				Record["iPadding45"] := Bin.ReadUInt()
			else
				Record["iPadding66"] := Bin.ReadUInt()
			
			Record[oABC "mod 1"] := Bin.ReadUInt() 
			Record[oABC "mod 1 param"] := Bin.ReadUShort() 
			Record[oABC "mod 1 min"] := Bin.ReadShort() 
			Record[oABC "mod 1 max"] := Bin.ReadShort() 
			Record[oABC "mod 1 chance"] := Bin.ReadUShort() 
			Record[oABC "mod 2"] := Bin.ReadUInt() 
			Record[oABC "mod 2 param"] := Bin.ReadUShort() 
			Record[oABC "mod 2 min"] := Bin.ReadShort() 
			Record[oABC "mod 2 max"] := Bin.ReadShort() 
			Record[oABC "mod 2 chance"] := Bin.ReadUShort() 
			Record[oABC "mod 3"] := Bin.ReadUInt() 
			Record[oABC "mod 3 param"] := Bin.ReadUShort() 
			Record[oABC "mod 3 min"] := Bin.ReadShort() 
			Record[oABC "mod 3 max"] := Bin.ReadShort() 
			Record[oABC "mod 3 chance"] := Bin.ReadUShort() 
			Record[oABC "mod 4"] := Bin.ReadUInt() 
			Record[oABC "mod 4 param"] := Bin.ReadUShort() 
			Record[oABC "mod 4 min"] := Bin.ReadShort() 
			Record[oABC "mod 4 max"] := Bin.ReadShort() 
			Record[oABC "mod 4 chance"] := Bin.ReadUShort() 
			Record[oABC "mod 5"] := Bin.ReadUInt() 
			Record[oABC "mod 5 param"] := Bin.ReadUShort() 
			Record[oABC "mod 5 min"] := Bin.ReadShort() 
			Record[oABC "mod 5 max"] := Bin.ReadShort() 
			Record[oABC "mod 5 chance"] := Bin.ReadUShort() 
		}
		
		Loop,7
		{
			Kill := "input " a_index " Input"
			KillDepend := "input " a_index " Input Flags,"
				. "input " a_index " Item Type,"
				. "input " a_index " Input ID,"
				. "input " a_index " Quality,"
				. "input " a_index " Quantity"
			RecordKill(Record,kill,0,killdepend)
		}
		
		for Index, oABC in ["", "b ", "c "]
		{
			Kill := oABC "mod $|5"
			KillDepend := oABC "mod $ param," 
				. oABC "mod $ min,"
				. oABC "mod $ max,"
				. oABC "mod $ chance"
			RecordKill(Record,Kill,4294967295,KillDepend,,"$")
			
			Kill := oABC "output Item"
			KillDepend := oABC "output ItemFlags,"
				. oABC "output ItemType,"
				. oABC "output ItemID,"
				. oABC "output Quality,"
				. oABC "output Quantity,"
				. oABC "output Type,"
				. oABC "output Lvl,"
				. oABC "output PLvl,"
				. oABC "output ILvl,"
				. oABC "output PrefixID," 
				. oABC "output SuffixId"
			RecordKill(Record,Kill,0,KillDepend)
			
			Kill := oABC "output unk0x0E,"
				. oABC "output unk0x10"
			RecordKill(Record,Kill,0)
		}
		
		Kill := "iPadding24,"
			. "iPadding45,"
			. "iPadding66"
		RecordKill(Record,Kill,0)
		
		Kill := "class"
		RecordKill(Record,Kill,255)
		
		InsertQuick("DigestDB","Decompile | " module,Record)
	}
}

