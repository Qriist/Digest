#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetBatchLines, -1
#Include <string_things>
#include <json>

;regex to extract field order in n++
;\toutJson\[(?:".+",){3}"(.+)"].+(\r\n)?

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
{	;armor
	fieldorder := "flippyfile,invfile,uniqueinvfile,setinvfile,code,normcode,ubercode,ultracode,alternategfx,iPadding37,iPadding38,iPadding39,iPadding40,iPadding41,iPadding42,iPadding43,iPadding44,iPadding45,iPadding46,iPadding47,iPadding48,iPadding49,iPadding50,minac,maxac,gamble cost,speed,bitfield1,cost,minstack,maxstack,iPadding59,gemoffset,namestr,version,iPadding61,auto prefix,missiletype,rarity,level,mindam,maxdam,iPadding64,iPadding65,StrBonus,DexBonus,reqstr,reqdex,absorbs,invwidth,invheight,block,durability,nodurability,iPadding69,component,rArm,lArm,Torso,Legs,rSPad,lSPad,iPadding71,useable,type,type2,iPadding72,dropsound,usesound,dropsfxframe,unique,quest,transparent,transtbl,iPadding75,lightradius,belt,stackable,spawnable,iPadding77,durwarning,qntwarning,hasinv,gemsockets,iPadding78,iPadding79,gemapplytype,levelreq,magic lvl,Transform,InvTrans,compactsave,SkipName,nameable,AkaraMin,GheedMin,CharsiMin,FaraMin,LysanderMin,DrognanMin,HraltiMin,AlkorMin,OrmusMin,ElzixMin,AshearaMin,CainMin,HalbuMin,JamellaMin,MalahMin,LarzukMin,DrehyaMin,AkaraMax,GheedMax,CharsiMax,FaraMax,LysanderMax,DrognanMax,HraltiMax,AlkorMax,OrmusMax,ElzixMax,AshearaMax,CainMax,HalbuMax,JamellaMax,MalahMax,LarzukMax,DrehyaMax,AkaraMagicMin,GheedMagicMin,CharsiMagicMin,FaraMagicMin,LysanderMagicMin,DrognanMagicMin,HraltiMagicMin,AlkorMagicMin,OrmusMagicMin,ElzixMagicMin,AshearaMagicMin,CainMagicMin,HalbuMagicMin,JamellaMagicMin,MalahMagicMin,LarzukMagicMin,DrehyaMagicMin,AkaraMagicMax,GheedMagicMax,CharsiMagicMax,FaraMagicMax,LysanderMagicMax,DrognanMagicMax,HraltiMagicMax,AlkorMagicMax,OrmusMagicMax,ElzixMagicMax,AshearaMagicMax,CainMagicMax,HalbuMagicMax,JamellaMagicMax,MalahMagicMax,LarzukMagicMax,DrehyaMagicMax,AkaraMagicLvl,GheedMagicLvl,CharsiMagicLvl,FaraMagicLvl,LysanderMagicLvl,DrognanMagicLvl,HraltiMagicLvl,AlkorMagicLvl,OrmusMagicLvl,ElzixMagicLvl,AshearaMagicLvl,CainMagicLvl,HalbuMagicLvl,JamellaMagicLvl,MalahMagicLvl,LarzukMagicLvl,DrehyaMagicLvl,iPadding102,NightmareUpgrade,HellUpgrade,iPadding105"
	outJson["armor","1.10f","Field Order"] := StrSplit(fieldorder,",")
	outJson["armor","1.10f","Fields","flippyfile"] := props("read",,32)
	outJson["armor","1.10f","Fields","invfile"] := props("Read",,32)
	outJson["armor","1.10f","Fields","uniqueinvfile"] := props("read",,32)
	outJson["armor","1.10f","Fields","setinvfile"] := props("read",,32)
	outJson["armor","1.10f","Fields","code"] := props("read",,4)
	outJson["armor","1.10f","Fields","normcode"] := props("read",,4)
	outJson["armor","1.10f","Fields","ubercode"] := props("read",,4)
	outJson["armor","1.10f","Fields","ultracode"] := props("read",,4)
	outJson["armor","1.10f","Fields","alternategfx"] := props("read",,4)
	outJson["armor","1.10f","Fields","iPadding37"] := props("ReadUInt")
	outJson["armor","1.10f","Fields","iPadding38"] := props("ReadUInt")
	outJson["armor","1.10f","Fields","iPadding39"] := props("ReadUInt")
	outJson["armor","1.10f","Fields","iPadding40"] := props("ReadUInt")
	outJson["armor","1.10f","Fields","iPadding41"] := props("ReadUInt")
	outJson["armor","1.10f","Fields","iPadding42"] := props("ReadUInt")
	outJson["armor","1.10f","Fields","iPadding43"] := props("ReadUInt")
	outJson["armor","1.10f","Fields","iPadding44"] := props("ReadUInt")
	outJson["armor","1.10f","Fields","iPadding45"] := props("ReadUInt")
	outJson["armor","1.10f","Fields","iPadding46"] := props("ReadUInt")
	outJson["armor","1.10f","Fields","iPadding47"] := props("ReadUInt")
	outJson["armor","1.10f","Fields","iPadding48"] := props("ReadUInt")
	outJson["armor","1.10f","Fields","iPadding49"] := props("ReadUInt")
	outJson["armor","1.10f","Fields","iPadding50"] := props("ReadUInt")
	outJson["armor","1.10f","Fields","minac"] := props("ReadUInt")
	outJson["armor","1.10f","Fields","maxac"] := props("ReadUInt")
	outJson["armor","1.10f","Fields","gamble cost"] := props("ReadUInt")
	outJson["armor","1.10f","Fields","speed"] := props("ReadUInt")
	outJson["armor","1.10f","Fields","bitfield1"] := props("ReadUInt")
	outJson["armor","1.10f","Fields","cost"] := props("ReadUInt")
	outJson["armor","1.10f","Fields","minstack"] := props("ReadUInt")
	outJson["armor","1.10f","Fields","maxstack"] := props("ReadUInt")
	outJson["armor","1.10f","Fields","iPadding59"] := props("ReadUInt")
	outJson["armor","1.10f","Fields","gemoffset"] := props("ReadUInt")
	outJson["armor","1.10f","Fields","namestr"] := props("ReadUShort")
	outJson["armor","1.10f","Fields","version"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","iPadding61"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","auto prefix"] := props("ReadUShort")
	outJson["armor","1.10f","Fields","missiletype"] := props("ReadUShort")
	outJson["armor","1.10f","Fields","rarity"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","level"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","mindam"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","maxdam"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","iPadding64"] := props("ReadUInt")
	outJson["armor","1.10f","Fields","iPadding65"] := props("ReadUShort")
	outJson["armor","1.10f","Fields","StrBonus"] := props("ReadUShort")
	outJson["armor","1.10f","Fields","DexBonus"] := props("ReadUShort")
	outJson["armor","1.10f","Fields","reqstr"] := props("ReadUShort")
	outJson["armor","1.10f","Fields","reqdex"] := props("ReadUShort")
	outJson["armor","1.10f","Fields","absorbs"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","invwidth"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","invheight"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","block"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","durability"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","nodurability"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","iPadding69"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","component"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","rArm"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","lArm"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","Torso"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","Legs"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","rSPad"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","lSPad"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","iPadding71"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","useable"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","type"] := props("ReadUShort")
	outJson["armor","1.10f","Fields","type2"] := props("ReadUShort")
	outJson["armor","1.10f","Fields","iPadding72"] := props("ReadUShort")
	outJson["armor","1.10f","Fields","dropsound"] := props("ReadUShort")
	outJson["armor","1.10f","Fields","usesound"] := props("ReadUShort")
	outJson["armor","1.10f","Fields","dropsfxframe"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","unique"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","quest"] := props("ReadUShort")
	outJson["armor","1.10f","Fields","transparent"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","transtbl"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","iPadding75"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","lightradius"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","belt"] := props("ReadUShort")
	outJson["armor","1.10f","Fields","stackable"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","spawnable"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","iPadding77"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","durwarning"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","qntwarning"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","hasinv"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","gemsockets"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","iPadding78"] := props("Read",,3)
	outJson["armor","1.10f","Fields","iPadding79"] := props("Read",,2)
	outJson["armor","1.10f","Fields","gemapplytype"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","levelreq"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","magic lvl"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","Transform"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","InvTrans"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","compactsave"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","SkipName"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","nameable"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","AkaraMin"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","GheedMin"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","CharsiMin"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","FaraMin"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","LysanderMin"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","DrognanMin"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","HraltiMin"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","AlkorMin"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","OrmusMin"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","ElzixMin"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","AshearaMin"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","CainMin"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","HalbuMin"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","JamellaMin"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","MalahMin"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","LarzukMin"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","DrehyaMin"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","AkaraMax"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","GheedMax"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","CharsiMax"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","FaraMax"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","LysanderMax"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","DrognanMax"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","HraltiMax"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","AlkorMax"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","OrmusMax"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","ElzixMax"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","AshearaMax"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","CainMax"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","HalbuMax"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","JamellaMax"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","MalahMax"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","LarzukMax"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","DrehyaMax"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","AkaraMagicMin"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","GheedMagicMin"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","CharsiMagicMin"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","FaraMagicMin"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","LysanderMagicMin"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","DrognanMagicMin"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","HraltiMagicMin"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","AlkorMagicMin"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","OrmusMagicMin"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","ElzixMagicMin"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","AshearaMagicMin"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","CainMagicMin"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","HalbuMagicMin"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","JamellaMagicMin"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","MalahMagicMin"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","LarzukMagicMin"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","DrehyaMagicMin"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","AkaraMagicMax"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","GheedMagicMax"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","CharsiMagicMax"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","FaraMagicMax"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","LysanderMagicMax"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","DrognanMagicMax"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","HraltiMagicMax"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","AlkorMagicMax"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","OrmusMagicMax"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","ElzixMagicMax"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","AshearaMagicMax"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","CainMagicMax"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","HalbuMagicMax"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","JamellaMagicMax"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","MalahMagicMax"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","LarzukMagicMax"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","DrehyaMagicMax"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","AkaraMagicLvl"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","GheedMagicLvl"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","CharsiMagicLvl"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","FaraMagicLvl"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","LysanderMagicLvl"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","DrognanMagicLvl"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","HraltiMagicLvl"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","AlkorMagicLvl"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","OrmusMagicLvl"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","ElzixMagicLvl"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","AshearaMagicLvl"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","CainMagicLvl"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","HalbuMagicLvl"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","JamellaMagicLvl"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","MalahMagicLvl"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","LarzukMagicLvl"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","DrehyaMagicLvl"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","iPadding102"] := props("ReadUChar")
	outJson["armor","1.10f","Fields","NightmareUpgrade"] := props("read",,4)
	outJson["armor","1.10f","Fields","HellUpgrade"] := props("read",,4)
	outJson["armor","1.10f","Fields","iPadding105"] := props("ReadUInt")
	outJson["armor","1.10f","Record Length"] := lengthCounter()
	RecordKill =
	(
				For Index, NPC in ["Cain","Fara","Akara","Alkor","Elzix","Gheed","Halbu","Malah","Ormus","Charsi","Dreyha","Hralti","Larzuk","Asheara","Drognan","Jamella","Lysander"]
				{
					Kill := NPC "Min,"
						. NPC "Max,"
						. NPC "MagicMin,"
						. NPC "MagicMax"
					RecordKill(Record,Kill,0)
					
					Kill := NPC "MagicLvl"
					RecordKill(Record,Kill,255)			
				}
				
				Kill=iPadding|105
				RecordKill(Record,Kill,"")
				
				Kill=iPadding|105
				RecordKill(Record,Kill,4294967295)
				
				Kill=NightmareUpgrade,HellUpgrade
				RecordKill(Record,Kill,"xxx")
	)
	outJson["armor","1.10f","RecordKill"] := a_tab a_tab a_tab a_tab RecordKill
}

{	;monstats2
	fieldOrder := "MonStats2 Flags 1,SizeX,SizeY,spawnCol,Height,OverlayHeight,pixHeight,MeleeRng,iPadding3,BaseW,HitClass,HDvNum,TRvNum,LGvNum,RavNum,LavNum,RHvNum,LHvNum,SHvNum,S1vNum,S2vNum,S3vNum,S4vNum,S5vNum,S6vNum,S7vNum,S8vNum,iPadding9,HDv,TRv,LGv,Rav,Lav,RHv,LHv,SHv,S1v,S2v,S3v,S4v,S5v,S6v,S7v,S8v,iPadding57,MonStats2 Flags 2,TotalPieces,MonStats2 Flags 3,dDT,dNU,dWL,dGH,dA1,dA2,dBL,dSC,dS1,dS2,dS3,dS4,dDD,dKB,dSQ,dRN,MonStats2 Flags 4,InfernoLen,InfernoAnim,InfernoRollback,ResurrectMode,ResurrectSkill,htTop,htLeft,htWidth,htHeight,iPadding69,automapCel,localBlood,Bleed,Light,light-r,light-g,light-b,Utrans,Utrans(N),Utrans(H),acPaddding,Heart,BodyPart,restore"
	outJson["monstats2","1.10f","Field Order"] := StrSplit(fieldOrder,",")
	outJson["monstats2","1.10f","Fields","Id"] := props("ReadUInt")
	outJson["monstats2","1.10f","Fields","MonStats2 Flags 1"] := props("ReadUInt",,,"1.10f|MonStats2 Flags 1")
	outJson["monstats2","1.10f","Fields","SizeX"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","SizeY"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","spawnCol"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","Height"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","OverlayHeight"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","pixHeight"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","MeleeRng"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","iPadding3"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","BaseW"] := props("Read",,4)
	outJson["monstats2","1.10f","Fields","HitClass"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","HDvNum"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","TRvNum"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","LGvNum"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","RavNum"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","LavNum"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","RHvNum"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","LHvNum"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","SHvNum"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","S1vNum"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","S2vNum"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","S3vNum"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","S4vNum"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","S5vNum"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","S6vNum"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","S7vNum"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","S8vNum"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","iPadding9"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","HDv"] := props("Read",,12)
	outJson["monstats2","1.10f","Fields","TRv"] := props("Read",,12)
	outJson["monstats2","1.10f","Fields","LGv"] := props("Read",,12)
	outJson["monstats2","1.10f","Fields","Rav"] := props("Read",,12)
	outJson["monstats2","1.10f","Fields","Lav"] := props("Read",,12)
	outJson["monstats2","1.10f","Fields","RHv"] := props("Read",,12)
	outJson["monstats2","1.10f","Fields","LHv"] := props("Read",,12)
	outJson["monstats2","1.10f","Fields","SHv"] := props("Read",,12)
	outJson["monstats2","1.10f","Fields","S1v"] := props("Read",,12)
	outJson["monstats2","1.10f","Fields","S2v"] := props("Read",,12)
	outJson["monstats2","1.10f","Fields","S3v"] := props("Read",,12)
	outJson["monstats2","1.10f","Fields","S4v"] := props("Read",,12)
	outJson["monstats2","1.10f","Fields","S5v"] := props("Read",,12)
	outJson["monstats2","1.10f","Fields","S6v"] := props("Read",,12)
	outJson["monstats2","1.10f","Fields","S7v"] := props("Read",,12)
	outJson["monstats2","1.10f","Fields","S8v"] := props("Read",,12)
	outJson["monstats2","1.10f","Fields","iPadding57"] := props("ReadUShort")
	outJson["monstats2","1.10f","Fields","MonStats2 Flags 2"] := props("ReadUInt",,,"1.10f|MonStats2 Flags 2")	
	outJson["monstats2","1.10f","Fields","TotalPieces"] := props("ReadUInt")
	outJson["monstats2","1.10f","Fields","MonStats2 Flags 3"] := props("ReadUInt",,,"1.10f|MonStats2 Flags 3")
	outJson["monstats2","1.10f","Fields","dDT"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","dNU"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","dWL"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","dGH"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","dA1"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","dA2"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","dBL"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","dSC"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","dS1"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","dS2"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","dS3"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","dS4"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","dDD"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","dKB"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","dSQ"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","dRN"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","MonStats2 Flags 4"] := props("ReadUInt",,,"1.10f|MonStats2 Flags 4")
	outJson["monstats2","1.10f","Fields","InfernoLen"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","InfernoAnim"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","InfernoRollback"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","ResurrectMode"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","ResurrectSkill"] := props("ReadUShort")
	outJson["monstats2","1.10f","Fields","htTop"] := props("ReadShort")
	outJson["monstats2","1.10f","Fields","htLeft"] := props("ReadShort")
	outJson["monstats2","1.10f","Fields","htWidth"] := props("ReadShort")
	outJson["monstats2","1.10f","Fields","htHeight"] := props("ReadShort")
	outJson["monstats2","1.10f","Fields","iPadding69"] := props("ReadUShort")
	outJson["monstats2","1.10f","Fields","automapCel"] := props("ReadUInt")
	outJson["monstats2","1.10f","Fields","localBlood"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","Bleed"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","Light"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","light-r"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","light-g"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","light-b"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","Utrans"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","Utrans(N)"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","Utrans(H)"] := props("ReadUChar")
	outJson["monstats2","1.10f","Fields","acPaddding"] := props("Read",,3)
	outJson["monstats2","1.10f","Fields","Heart"] := props("Read",,4)
	outJson["monstats2","1.10f","Fields","BodyPart"] := props("Read",,4)
	outJson["monstats2","1.10f","Fields","restore"] := props("ReadUInt")
	outJson["monstats2","1.10f","Record Length"] := lengthCounter()
	
}
FileOpen(a_scriptdir "\outJson.json","w").write(json.dump(outjson))
