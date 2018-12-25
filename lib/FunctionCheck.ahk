FunctionCheck(num,code,param,min,max,k,v,ugv := "")
{
	;~ before printing a stat, check if it has a dgrp - if yes, check if all stats with the same dgrp are available , if yes, check if all have the same value, if yes -> group, if not,print each
	/*
	rec = operating array
	num = function number
	code = T1Code
	param = T1Param
	min = T1Min
	max = T1Max
	ugv = Use Group Values; fetch the properties of a group, instead of a single 
	*/
	global
	;~ Digest := rec
	;~ for a,b in Digest
		;~ ModFullName := a
	tprop=
	;~ mod_lng = ENG
	

	;set a few values
		
		;~ msgbox % descstrpos "`n" DescStr2 "`n" DescFunc "`n" DescVal "`n" 
	if (ugv="")
	{
		tempcode := Digest[ModFullName,"Decompile","properties",code,"stat" k]
		;~ testvals .= tempcode
		
		descstrpos := Digest[ModFullName,"Decompile","itemstatcost",tempcode,"descstrpos"]
		descstrpos := Digest[ModFullName,"String",mod_lng,"By Number", descstrpos "R"]
		
		DescStr2 := Digest[ModFullName,"Decompile","itemstatcost",tempcode,"DescStr2"]
		DescStr2 := Digest[ModFullName,"String",mod_lng,"By Number", DescStr2 "R"]
		
		DescFunc := Digest[ModFullName,"Decompile","itemstatcost",tempcode,"DescFunc"]
		DescVal := Digest[ModFullName,"Decompile","itemstatcost",tempcode,"DescVal"]
	}
	else
	{
		tempcode := code ;Digest[ModFullName,"Recompile","dgrp",code,"stat1"]
		
		descstrpos := Digest[ModFullName,"Recompile","dgrp",k,"dgrpstrpos"]
		descstrpos := Digest[ModFullName,"String",mod_lng,"By Number", descstrpos "R"]
		;~ msgbox % descstrpos
		
		DescStr2 := Digest[ModFullName,"Recompile","dgrp",k,"DescStr2"]
		DescStr2 := Digest[ModFullName,"String",mod_lng,"By Number", DescStr2 "R"]
		
		DescFunc := Digest[ModFullName,"Recompile","dgrp",k,"dgrpfunc"]
		DescVal := Digest[ModFullName,"Recompile","dgrp",k,"dgrpval"]
		
		;~ DescFunc := Digest[ModFullName,"Decompile","itemstatcost",tempcode,"dgrpfunc"]
		;~ DescVal := Digest[ModFullName,"Decompile","itemstatcost",tempcode,"dgrpval"]
	}
	OpParam := Digest[ModFullName,"Decompile","itemstatcost",tempcode,"Op Param"]

	
	testvals := "num: " num "`n"
	testvals .= "code: " code "`n"
	testvals .= "param: " param "`n"
	testvals .= "min: " min "`n"
	testvals .= "max: " max "`n"
	testvals .= "k: " k "`n"
	testvals .= "v: " v "`n`n"
	testvals .= "tempcode: " tempcode "`n`n"
	testvals .= "DescStrPos: " descstrpos "`n"
	testvals .= "DescStr2: " DescStr2 "`n"
	testvals .= "DescFunc: " DescFunc "`n"
	testvals .= "DescVal: " DescVal "`n"
	;~ clipboard := testvals
	;~ if code=29
		;~ msgbox % testvals
	;~ ExitApp
	;~ If (num="") AND (DescFunc="")
		;~ return ; " {{func:" num "}} {{desc:" DescFunc "}}"
	If DescFunc=0
		return ;" {{func:" num "}} {{desc:" DescFunc "}}"
	If num = 0
		return ;" {{func:" num "}} {{desc:" DescFunc "}}"
	else If num = 1 ;Applies a value to a stat, can use SetX parameter.
	{
		if (ugv = "")
		{
		tempcode := Digest[ModFullName,"Decompile","properties",code,"stat" k]
		
		descstrpos := Digest[ModFullName,"Decompile","itemstatcost",tempcode,"descstrpos"]
		descstrpos := Digest[ModFullName,"String",mod_lng,"By Number", descstrpos "R"]

		DescStr2 := Digest[ModFullName,"Decompile","itemstatcost",tempcode,"DescStr2"]
		DescStr2 := Digest[ModFullName,"String",mod_lng,"By Number", DescStr2 "R"]
		
		DescFunc := Digest[ModFullName,"Decompile","itemstatcost",tempcode,"DescFunc"]
		DescVal := Digest[ModFullName,"Decompile","itemstatcost",tempcode,"DescVal"]
		}
		
	}
	else If num = 2 ;defensive function only, similar to 1 ??? 
	{
		
	}
	else If num = 3 ;Apply the same min-max range as used in the previous function block (see res-all). 
	{
		tprop := Digest[ModFullName,"Decompile","properties",code,"stat" k]
		tprop := Digest[ModFullName,"Decompile","itemstatcost",tprop,"descstrpos"]
		if Digest[ModFullName,"String",mod_lng,"By Number", tprop "R"] != ""
			tprop := Digest[ModFullName,"String",mod_lng,"By Number", tprop "R"]
		else 
			tprop := "{{" tprop "}}"
	}
	else If num = 4 ;not used ??? 
	{
	}
	else If num = 5 ;Dmg-min related ??? 
	{
		DescFunc := -5
		descstrpos := "Adds (%d% to %d) to Minimum Damage"
		;~ r := Format_descfunc_string(DescFunc,param,min,Max,descstrpos,DescStr2,DescVal)
		;~ return r
	}
	else If num = 6 ;Dmg-max related ??? 
	{
		DescFunc := -6
		descstrpos := "Adds (%d% to %d) to Maximum Damage"
		;~ r := Format_descfunc_string(DescFunc,param,min,Max,descstrpos,DescStr2,DescVal)
		;~ return r
	}
	else If num = 7 ;Dmg% related ??? 
	{
		DescFunc := -7
		descstrpos := "(%d% to %d)% Enhanced Damage"
		;~ r := Format_descfunc_string(DescFunc,param,min,Max,descstrpos,DescStr2,DescVal)
		;~ return r
	}
	else If num = 8 ;??? use for speed properties (ias, fcr, etc ...) 
	{
	}
	else If num = 9 ;Apply the same param and value in min-max range, as used in the previous function block. 
	{
	}
	else If num = 10 ;skilltab skill group ??? 
	{
		If T1Param != 0
			{
				T1Param_string := Digest[ModFullName,"Decompile","skills",T1Param,"skilldesc"]
				T1Param_string := Digest[ModFullName,"Decompile","skilldesc",T1Param_string,"str name"]
				T1Param_string := Digest[ModFullName,"String",mod_lng,"By Number",T1Param_string "R"]
			}
			;~ msgbox % T1Param_string
	}
	else If num = 11 ;event-based skills ??? 
	{
		;~ StringReplace,props,props,% T1Param ","
		;~ tprop := Digest[ModFullName,"Decompile","properties",T1Code,"stat" a_index]
		;~ tprop := Digest[ModFullName,"Decompile","itemstatcost",tprop,"descstrpos"]
		;~ if Digest[ModFullName,"String",mod_lng,"By Number", tprop "R"] != ""
			;~ tprop := Digest[ModFullName,"String",mod_lng,"By Number", tprop "R"]
		;~ else 
			;~ tprop := "{{" tprop "}}"
		;~ StringReplace,tprop,tprop,`%d`%,% Decompile["T1Min" T1_index]
		;~ StringReplace,tprop,tprop,`%d,% Decompile["T1Max" T1_index]
		;~ StringReplace,tprop,tprop,`%s,%T1Param_string%
		;~ Props .= tprop ", "
		;~ if DescFunc not in 6,7,8,9
		;~ {
			;~ msgbox % param
			param := Digest[ModFullName,"Decompile","skills",param,"skilldesc"]
			;~ msgbox % param
			param := Digest[ModFullName,"Decompile","skilldesc",param,"str name"]
			;~ msgbox % param
			param := Digest[ModFullName,"String",mod_lng,"By Number",param "R"]
			;~ msgbox % param
			
		;~ }
	}
	else If num = 12 ;random selection of parameters for parameter-based stat ??? 
	{
	}
	else If num = 13 ;durability-related ???
	{
	}
	else If num = 14 ;inventory positions on item ??? (related to socket) 
	{
		
	}
	else If num = 15 ;use min field only 
	{
		max := min
	}
	else If num = 16 ;use max field only 
	{
		min := max
	}
	else If num = 17 ;use param field only 
	{
		;~ Related to x% per level
		;~ Min/Max are range of divisors based on some stat
		;~ Where do I find the divided stat?
		;~ Also controls ignore target's defense?
		
	}
	else If num = 18 ;Related to /time properties. 
	{
		if (DescVal = 15)
		{
			param := Digest[ModFullName,"Decompile","skills",param,"skilldesc"]
			param := Digest[ModFullName,"Decompile","skilldesc",param,"str name"]
			param := Digest[ModFullName,"String",mod_lng,"By Number",param "R"]
		}
		else if  (DescVal != 24)
		{
		}
		else
		{
			min := param/8
			max := param/8
		}
	}
	else If num = 19 ;Related to charged item. 
	{
		descstrpos := "Charges of level"
		param := Digest[ModFullName,"Decompile","skills",param,"skilldesc"]
		param := Digest[ModFullName,"Decompile","skilldesc",param,"str name"]
		param := Digest[ModFullName,"String",mod_lng,"By Number",param "R"]
	}
	else If num = 20 ;Simple boolean stuff. Use by indestruct. 
	{
		;This assumes that this only applies to indestructible
		r := Digest[ModFullName,"String",mod_lng,"By Code","ModStre9s"]
		return r
	}
	else If num = 21 ;Add to group of skills, group determined by stat ID, uses ValX parameter. 
	{
	}
	else If num = 22 ;Individual skill, using param for skill ID, random between min-max. Also used for aura on equip.
	{
				;~ msgbox % testvals

					;~ If T1Param != 0
			;~ {
				;~ tparam := param
				if (descfunc = 27)
				{
					descstrpos := Digest[ModFullName,"Decompile","skills",param,"charclass"]
					descstrpos := Digest[ModFullName,"Decompile","charstats",descstrpos+1,"class"]
				}
				param := Digest[ModFullName,"Decompile","skills",param,"skilldesc"]
				param := Digest[ModFullName,"Decompile","skilldesc",param,"str name"]
				param := Digest[ModFullName,"String",mod_lng,"By Number",param "R"]
				;~ return r
				;~ props := T1Param_string ","
			;~ }
		;~ msgbox % testvals
		;~ tprop := Digest[ModFullName,"Decompile","properties",param,"stat" a_index]
		;~ msgbox % "properties " tprop
		;~ tprop := Digest[ModFullName,"Decompile","itemstatcost",tprop,"descstrpos"]
				;~ msgbox % "itemstatcost " tprop

		;~ if Digest[ModFullName,"String",mod_lng,"By Number", tprop "R"] != ""
			;~ param := Digest[ModFullName,"String",mod_lng,"By Number", tprop "R"]
		;~ else 
			;~ param := "{{" tprop "}}"
		;~ msgbox % param
		
	}
	else If num = 23 ;ethereal
	{
		return "Ethereal"
	}
	else If num = 24 ;property applied to character or target monster ??? 
	{
		DescStr2 := Digest[ModFullName,"Decompile","monstats",param+1,"NameStr"]
		DescStr2 := Digest[ModFullName,"String",mod_lng,"By Number",DescStr2 "R"]
	}
	;~ If (a_index=1) and (T1Param != 0)
		;~ continue
	;~ if Digest[ModFullName,"Decompile","properties",T1C
	;~ LastMin := 
	;~ If num in 1,3,5,6,7,11,20,22
		;~ continue
	
	
	
	tprop := Digest[ModFullName,"Decompile","properties",T1Code,"stat" k]
	tprop := Digest[ModFullName,"Decompile","itemstatcost",tprop,"descstrpos"]
	
	if Digest[ModFullName,"String",mod_lng,"By Number", tprop "R"] != ""
		tprop := Digest[ModFullName,"String",mod_lng,"By Number", tprop "R"]
	else ; if Digest[ModFullName,"String",mod_lng,"By Number", tprop "R"] != ""
		tprop := "{{" tprop "}}"
	;~ Props .= Digest[ModFullName,"Decompile","properties",T1Code,"stat" a_index] ","
	;~ if T1Param !=0
		;~ Props .= T1Param ","
	;~ else
		Props .= "[[" f "]]"
		Props .= tprop ", "
		;complete

	if DescFunc = 13 ;+Class skills
	{
		descstrpos := Digest[ModFullName,"Decompile","properties",code,"val" k]
		if descstrpos is not number
			descstrpos=0
		descstrpos := Digest[ModFullName,"Decompile","charstats",descstrpos+1,"class"]
		;~ descstrpos := Digest[ModFullName,"Decompile","charstats",param,"StrAllSkills"]
		;~ descstrpos := Digest[ModFullName,"String",mod_lng,"By Number",descstrpos "R"]
	}
	else if DescFunc = 14 ;+Skilltabs
	{
		descstrpos := Digest[ModFullName,"Recompile","SkillTab",param]
		descstrpos := Digest[ModFullName,"String",mod_lng,"By Number",descstrpos "R"]
		DescStr2 := Digest[ModFullName,"Recompile","SkillTab",param " class"]
	}
	;~ else if (DescFunc = 15) || (DescFunc = 16)
	;~ {
		;~ param := Digest[ModFullName,"Decompile","skills",param,"skilldesc"]
		;~ param := Digest[ModFullName,"Decompile","skilldesc",param,"str name"]
		;~ param := Digest[ModFullName,"String",mod_lng,"By Number",param "R"]
	;~ }
	else if (DescFunc = 17) || (DescFunc = 18)
	{
		
		param:=(param=0) ? Digest[ModFullName,"String",mod_lng,"By Code","ModStre9e"] ;"(Increases During Daytime)"
		: (param=1) ? Digest[ModFullName,"String",mod_lng,"By Code","ModStre9g"] ;"(Increases Near Dusk)"
		: (param=2) ? Digest[ModFullName,"String",mod_lng,"By Code","ModStre9d"] ;"(Increases During Nighttime)"
		: (param=3) ? Digest[ModFullName,"String",mod_lng,"By Code","ModStre9f"] ;"(Increases Near Dawn)"
		: param ; if p isn't any of the above, keep same value
	}
	;~ else if DescFunc = 23
	;~ {
		;~ DescStr2 := Digest[ModFullName,"Decompile","monstats",param,"NameStr"]
		;~ DescStr2 := Digest[ModFullName,"String",mod_lng,"By Number",DescStr2 "R"]
	;~ }
	;~ else if descfunc = 27
	;~ {
		;~ if (param != 255)
		;~ {
			;~ descstrpos := Digest[ModFullName,"Decompile","skills",param,"charclass"]
			;~ descstrpos := Digest[ModFullName,"Decompile","charstats",descstrpos+1,"class"]
		;~ }
		;~ else descstrpos =
		;~ if (param != 1)
		;~ {
			;~ param := Digest[ModFullName,"Decompile","skills",param,"skilldesc"]
			;~ param := Digest[ModFullName,"Decompile","skilldesc",param,"str name"]
			;~ param := Digest[ModFullName,"String",mod_lng,"By Number",param "R"]
		;~ }
	;~ }
	else if descFunc=28
	{
		descstrpos := GetParameterString(param)
				;~ msgbox % testvals

	}
	r := Format_descfunc_string(DescFunc,param,min,max,descstrpos,DescStr2,DescVal,OpParam)
	/*
	f = the function # passed; DescFunc
	p = the T1Param value
	vn = the T1Min value
	vx = the T1Max value
	sx = the resolved string to work on; descstrpos
	sy = the resolved second string to work on; DescStr2
	d = the descval for the given item
	*/
	;~ if num = 1 ; good
	;~ if num = 2 ; good
	;~ if num = 3 ; good
	;~ if num = 4 ; good
	;~ if num = 5 ; good
	;~ if num = 6 ; good
	;~ if num = 7 ; good
	;~ if num = 8 ; good
	;~ if num = 9 ; no cases
	;~ if num = 10
	;~ if num = 11
	;~ if num = 12
	;~ if num = 13
	;~ if num = 14
	;~ if num = 15
	;~ if num = 16
	;~ if num = 17
	;~ if num = 18
	;~ if num = 19
	;~ if num = 20
	;~ if num = 21
	;~ if num = 22
	;~ if num = 23
	;~ if num = 24		
	;~ if (DescFunc != 0)
	;~ if (DescFunc != 1)
	;~ if (DescFunc != 2)
	;~ if (DescFunc != 3)
	;~ if (DescFunc != 4)
	;~ if (DescFunc != 5)
	;~ if (DescFunc != 6)
	;~ if (DescFunc != 7)
	;~ if (DescFunc != 8)
	;~ if (DescFunc != 9)
	;~ if (DescFunc != 10)
	;~ if (DescFunc != 11)
	;~ if (DescFunc != 12)
	;~ if (DescFunc != 13)
	;~ if (DescFunc != 14)
	;~ if (DescFunc != 15)
	;~ if (DescFunc != 16)
	;~ if (DescFunc != 17)
	;~ if (DescFunc != 18)
	;~ if (DescFunc != 19)
	;~ if (DescFunc != 20)
	;~ if (DescFunc != 21)
	;~ if (DescFunc != 22)
	;~ if (DescFunc != 23)
	;~ if (DescFunc != 24)
		;~ msgbox % r "`n" DescFunc "`	n" num
		;~ if r = ""
			;~ return r " {{func:" num "}} {{desc:" DescFunc "}}"
			;~ msgbox % code
		;~ if InStr(r,",")
			;~ r := r " {{stat:" code "}}"
					;~ if num in 0
		if r !=
		;~ If DescFunc in 15
			return r  " {{func:" num "}} {{desc:" DescFunc "}}* {{ISC:" tempcode "}} {{d:" DescVal "}}"  a_space v
		;~ If DescFunc in -5,-6,-7,0,5,10,21,22,25,26,29,30
			;~ return r " {{func:" num "}} {{desc:" DescFunc "}}*"
		;~ else if num in -5,-6,-7,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30
			;~ msgbox % testvals "`n`n" r
			;~ return r " {{func:" num "}}* {{desc:" DescFunc "}}"
		;~ else
			;~ return r "{{func:" num "}} {{desc:" DescFunc "}}"
		
}

				;~ break
				/*
				Start enumerating functions
				1 - Applies a value to a stat, can use SetX parameter. 
				2 - defensive function only, similar to 1 ??? 
				3 - Apply the same min-max range as used in the previous function block (see res-all). 
				4 - not used ??? 
				5 - Dmg-min related ??? 
				6 - Dmg-max related ??? 
				7 - Dmg% related ??? 
				8 - ??? use for speed properties (ias, fcr, etc ...) 
				9 - Apply the same param and value in min-max range, as used in the previous function block. 
				10 - skilltab skill group ??? 
				11 - event-based skills ??? 
				12 - random selection of parameters for parameter-based stat ??? 
				13 - durability-related ??? 
				14 - inventory positions on item ??? (related to socket) 
				15 - use min field only 
				16 - use max field only 
				17 - use param field only 
				18 - Related to /time properties. 
				19 - Related to charged item. 
				20 - Simple boolean stuff. Use by indestruct. 
				21 - Add to group of skills, group determined by stat ID, uses ValX parameter. 
				22 - Individual skill, using param for skill ID, random between min-max. 
				23 - ethereal 
				24 - property applied to character or target monster ??? 
				25--32 can be used in custom code. Check plugin documentation for syntax.
				*/