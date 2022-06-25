#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetBatchLines, -1
#Include <string_things>
#include <json>

props(readType,unsigned := 1,readLength := "",bitfield := ""){
    if (readType = ""){
        msgbox % "readType not set"
        ExitApp
    }
	Switch readType{
		case "ReadInt","Int","readUInt","UInt":{
			readLength := 4
			lengthCounter(4)
		}
		case "read":{
			if (readLength = "")
				msgbox % "read command with unset length"
			lengthCounter(readLength)
		}
		case "ReadUShort","short","readshort","uShort":{
			readLength := 2
			lengthCounter(readLength)
		}
		case "readuchar","ReadChar":{
			readLength := 1
			lengthCounter(readLength)
		}
		Default:{
			msgbox % "UNKNOWN READ TYPE: " readtype
		}
	}
	Switch readType{
		case "readUint","readushort","readuchar":{
			unsigned := 1
		}
	}
	retObj := {"readType":readType,"unsigned":unsigned,"readLength":readLength}
	if (bitfield != ""){
		retObj["bitfield"] := []
		retObj["bitfield"] := bitfield(bitfield)
		
	}
	return retObj
}

lengthCounter(inputCount := ""){
	static tally := 0
	If (inputCount = ""){
		oldtally := tally
		tally := 0
		return oldtally
	}
	tally += inputCount
}

bitprops(name,Visible := 1){
	return {"name":name,"visible":Visible}
}
bitfield(bf){
	Switch bf {
		Case "1.10f|MonStats2 Flags 1" : {
			retBf := []
			For k,v in strsplit("corpseSel,shiftSel,noSel,alSel,isSel,noOvly,noMap,noGfxHitTest,noUniqueShift,Shadow,critter,soft,large,small,isAtt,revive,1.10f|MonStats2 Flags 1 bit 17,1.10f|MonStats2 Flags 1 bit 18,1.10f|MonStats2 Flags 1 bit 19,unflatDead,deadCol,objCol,inert,compositeDeath,1.10f|MonStats2 Flags 1 bit 25,1.10f|MonStats2 Flags 1 bit 26,1.10f|MonStats2 Flags 1 bit 27,1.10f|MonStats2 Flags 1 bit 28,1.10f|MonStats2 Flags 1 bit 29,1.10f|MonStats2 Flags 1 bit 30,1.10f|MonStats2 Flags 1 bit 31,1.10f|MonStats2 Flags 1 bit 32",","){
				retBf[k] := bitprops(v,((InStr(v,"MonStats2 Flags")=0)?1:0))
			}
			;msgbox % clipboard := st_printarr(retbf)
			return retBf
		}
		Case "1.10f|MonStats2 Flags 2" : {
			retBf := []
			For k,v in strsplit("mSC,mBL,mA2,mA1,mGH,mWL,mNU,mDT,mRN,mSQ,mKB,mDD,mS4,mS3,mS2,mS1,1.10f|MonStats2 Flags 2 bit 17,1.10f|MonStats2 Flags 2 bit 18,1.10f|MonStats2 Flags 2 bit 19,1.10f|MonStats2 Flags 2 bit 20",","){
				retBf[k] := bitprops(v,((InStr(v,"MonStats2 Flags")=0)?1:0))
			}
			;msgbox % clipboard := st_printarr(retbf)
			return retBf
		}
		Case "1.10f|MonStats2 Flags 3" : {
			retBf := []
			For k,v in strsplit("mSC,mBL,mA2,mA1,mGH,mWL,mNU,mDT,mRN,mSQ,mKB,mDD,mS4,mS3,mS2,mS1,1.10f|MonStats2 Flags 3 bit 17,1.10f|MonStats2 Flags 3 bit 18,1.10f|MonStats2 Flags 3 bit 19,1.10f|MonStats2 Flags 3 bit 20,1.10f|MonStats2 Flags 3 bit 21,1.10f|MonStats2 Flags 3 bit 22,1.10f|MonStats2 Flags 3 bit 23,1.10f|MonStats2 Flags 3 bit 24,1.10f|MonStats2 Flags 3 bit 25,1.10f|MonStats2 Flags 3 bit 26,1.10f|MonStats2 Flags 3 bit 27,1.10f|MonStats2 Flags 3 bit 28,1.10f|MonStats2 Flags 3 bit 29,1.10f|MonStats2 Flags 3 bit 30,1.10f|MonStats2 Flags 3 bit 31,1.10f|MonStats2 Flags 3 bit 32",","){
				retBf[k] := bitprops(v,((InStr(v,"MonStats2 Flags")=0)?1:0))
			}
			;msgbox % clipboard := st_printarr(retbf)
			return retBf
		}
		Case "1.10f|MonStats2 Flags 4" : {
			retBf := []
			For k,v in strsplit("SCmv,1.10f|MonStats2 Flags 4 bit 2,A2mv,A1mv,1.10f|MonStats2 Flags 4 bit 5,1.10f|MonStats2 Flags 4 bit 6,1.10f|MonStats2 Flags 4 bit 7,1.10f|MonStats2 Flags 4 bit 8,1.10f|MonStats2 Flags 4 bit 9,1.10f|MonStats2 Flags 4 bit 10,1.10f|MonStats2 Flags 4 bit 11,1.10f|MonStats2 Flags 4 bit 12,S4mv,S3mv,S2mv,S1mv,1.10f|MonStats2 Flags 4 bit 17,1.10f|MonStats2 Flags 4 bit 18,1.10f|MonStats2 Flags 4 bit 19,1.10f|MonStats2 Flags 4 bit 20,1.10f|MonStats2 Flags 4 bit 21,1.10f|MonStats2 Flags 4 bit 22,1.10f|MonStats2 Flags 4 bit 23,1.10f|MonStats2 Flags 4 bit 24,1.10f|MonStats2 Flags 4 bit 25,1.10f|MonStats2 Flags 4 bit 26,1.10f|MonStats2 Flags 4 bit 27,1.10f|MonStats2 Flags 4 bit 28,1.10f|MonStats2 Flags 4 bit 29,1.10f|MonStats2 Flags 4 bit 30,1.10f|MonStats2 Flags 4 bit 31,1.10f|MonStats2 Flags 4 bit 32",","){
				retBf[k] := bitprops(v,((InStr(v,"MonStats2 Flags")=0)?1:0))
			}
			;msgbox % clipboard := st_printarr(retbf)
			return retBf
		}
	}
}



outJson := {} 

{	;arena
	fieldorder := "Suicide,PlayerKill,PlayerKillPercent,MonsterKill,PlayerDeath,PlayerDeathPercent,MonsterDeath"
	outJson["arena","1.10f","Field Order"] := StrSplit(fieldorder,",")
	outJson["arena","1.10f","Fields","Suicide"] := props("int")
	outJson["arena","1.10f","Fields","PlayerKill"] := props("int")
	outJson["arena","1.10f","Fields","PlayerKillPercent"] := props("int")
	outJson["arena","1.10f","Fields","MonsterKill"] := props("int")
	outJson["arena","1.10f","Fields","PlayerDeath"] := props("int")
	outJson["arena","1.10f","Fields","PlayerDeathPercent"] := props("int")
	outJson["arena","1.10f","Fields","MonsterDeath"] := props("int")
	outJson["arena","1.10f","Record Length"] := lengthCounter()
}



FileOpen(a_scriptdir "\outJson.json","w").write(json.dump(outjson))
