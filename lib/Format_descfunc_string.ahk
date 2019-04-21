;complete
Format_descfunc_string(f,p,vn,vx,sx,sy,d,opparam)
{
/*
f = the function # passed
p = the T1Param value
vn = the T1Min value
vx = the T1Max value
sx = the resolved string to work on
sy = the resolved second string to work on
d = the descval for the given item
opparam = 

descval 
0 : no value is displayed (like 
1 : value is displayed first (like '+5 to strength') 
2 : string is displayed first, then value (like 'strength +5') 
Function used to display the stat. There are numerous ones, I didnt yet test all yet. 
some values and what they display (descval used: 1, see below): 
*/
	sx := Trim(sx)
	sy := Trim(sy)

	_sx := a_space sx	;"shortcuts" to cleanup the equations
	sx_ := sx A_Space
	_sy := a_space sy
	sy_ := sy a_space
	;~ if vn != vx
		;~ avg = 1
	;~ else
		;~ avg = 0
	vr := "(" vn " to " vx ")" ;value range
	vz := Round((vn + vx) / 2) ;value average (rounded)
	vzb := a_space "[" vz "]" ; value average in brackets
	if OpParam=""
		OpParam=8
	if (f = 0) OR (f = "")
		return
	else if f = 1 ; +[value] [string] 
	{
		if InStr(s,"%d")
		{	
			s:=(d=1) ? "+" StrReplace(s,"%d",vr,1) 
			: (d=2) ? 
			: d ? sx
		}
		else if d = 1
			s := "+" vr _sx vzb
		else if d = 2
			s := sx_ "+" vr vzb
		else
			s := sx
	}
	else if f = 2 ; [value]% [string] 
	{
		if d = 1
			s := vr "%" _sx vzb
		else if d = 2
			s := sx_ vr "%" vzb
		else
			s := sx
	}
	else if f = 3 ; [value] [string] 
	{
		if d = 1
			s := vr _sx vzb
		else if d = 2
			s := sx_ vr vzb
		else
			s := sx
	}
	else if f = 4 ; +[value]% [string] 
	{
		if d = 1
			s := "+" vr "%" _sx vzb
		else if d = 2
			s := sx_ "+" vr "%" vzb
		else
			s := sx
	}
	else if f = 5 ; [value/1.28]% [string] // used for howl 
	{
		;redefine values for edge case
		vn := vn/1.28 
		vx := vx/1.28
		vr := "(" vn " to " vx ")"
		vz := Round((vn + vx) / 2)
		vzb := a_space "[" vz "]"
		
		if d = 1
			s := vr "%" _sx vzb
		else if d = 2
			s:= sx_ vr "%" vzb
		else
			s := sx
	}
	else if f = 6 ; +[value] [string] [string2] 
	{
		;redefine values for edge case
		if (p = 0)
		{
			vn := RTrim(vn / (2 ** OpParam),"0")
			vx := RTrim(vx / (2 ** OpParam),"0")
			vn := Trim(RTrim(vn,"0"),".")
			vx := Trim(RTrim(vx,"0"),".")
			vr := "(" vn " to " vx ")" ;value range
			vz := RTrim((vn + vx) / 2,"0") ;value average (rounded)
			vzb := a_space "[" vz "]" ; value average in brackets
		}
		else 
		{
			vn := RTrim(p / (2** OpParam),"0")
			vx := RTrim(p / (2** OpParam),"0")
			vn := Trim(RTrim(vn,"0"),".")
			vx := Trim(RTrim(vx,"0"),".")
			vr := "(" vn " to " vx ")" ;value range
			vz := Rtrim((vn + vx) / 2,"0") ;value average (rounded)
			vzb := a_space "[" vz "]" ; value average in brackets
		}
		
		if d = 1
			s:= "+" vr _sx _sy vzb
		else if d = 2
			s:= sx_ sy_ "+" vr vzb
		else
			s:= sx_ sy
	}
	else if f = 7 ; [value]% [string] [string2] 
	{
		;redefine values for edge case
		if (p = 0)
		{
			vn := RTrim(vn / (2 ** OpParam),"0")
			vx := RTrim(vx / (2 ** OpParam),"0")
			vn := Trim(RTrim(vn,"0"),".")
			vx := Trim(RTrim(vx,"0"),".")
			vr := "(" vn " to " vx ")" ;value range
			vz := RTrim((vn + vx) / 2,"0") ;value average (rounded)
			vzb := a_space "[" vz "]" ; value average in brackets
		}
		else 
		{
			vn := RTrim(p / (2** OpParam),"0")
			vx := RTrim(p / (2** OpParam),"0")
			vn := Trim(RTrim(vn,"0"),".")
			vx := Trim(RTrim(vx,"0"),".")
			vr := "(" vn " to " vx ")" ;value range
			vz := Rtrim((vn + vx) / 2,"0") ;value average (rounded)
			vzb := a_space "[" vz "]" ; value average in brackets
		}
		if d = 1
			s:= vr "%" _sx _sy vzb
		else if d = 2
			s:= sx_ sy_ vr "%" vzb
		else
			s:= sx_ sy
	}
	else if f = 8 ; +[value]% [string] [string2] 
	{
		;redefine values for edge case
		if (p = 0)
		{
			vn := RTrim(vn / (2 ** OpParam),"0")
			vx := RTrim(vx / (2 ** OpParam),"0")
			vn := Trim(RTrim(vn,"0"),".")
			vx := Trim(RTrim(vx,"0"),".")
			vr := "(" vn " to " vx ")" ;value range
			vz := RTrim((vn + vx) / 2,"0") ;value average (rounded)
			vzb := a_space "[" vz "]" ; value average in brackets
		}
		else 
		{
			vn := RTrim(p / (2** OpParam),"0")
			vx := RTrim(p / (2** OpParam),"0")
			vn := Trim(RTrim(vn,"0"),".")
			vx := Trim(RTrim(vx,"0"),".")
			vr := "(" vn " to " vx ")" ;value range
			vz := Rtrim((vn + vx) / 2,"0") ;value average (rounded)
			vzb := a_space "[" vz "]" ; value average in brackets
		}
		if d = 1
			s:= "+" vr "%" _sx _sy vzb
		else if d = 2
			s:= sx_ sy_ "+" vr "%" vzb
		else
			s:= sx_ sy
	}
	else if f = 9 ; [value] [string] [string2] 
	{
		;redefine values for edge case
		if (p = 0)
		{
			vn := vn / (2 ** OpParam)
			vx := vx / (2 ** OpParam)
			vn := Trim(RTrim(vn,"0"),".")
			vx := Trim(RTrim(vx,"0"),".")
			vr := "(" vn " to " vx ")" ;value range
			vz := RTrim((vn + vx) / 2,"0") ;value average (rounded)
			vzb := a_space "[" vz "]" ; value average in brackets
		}
		else 
		{
				vn := p / (2** OpParam)
				vx := p / (2** OpParam)
				vn := Trim(RTrim(vn,"0"),".")
				vx := Trim(RTrim(vx,"0"),".")
				vr := "(" vn " to " vx ")" ;value range
				vz := Rtrim((vn + vx) / 2,"0") ;value average (rounded)
				vzb := a_space "[" vz "]" ; value average in brackets
		}
		if d = 1
			s:= vr _sx _sy vzb
		else if d = 2
			s:= sx_ vr _sy vzb
		else
			s:= sx_ sy
	}
	else if f = 10 ; [value/1.28]% [string] [string2] 
	{
		;redefine values for edge case
		vn := vn/1.28 
		vx := vx/1.28
		vr := "(" vn " to " vx ")"
		vz := Round((vn + vx) / 2)
		vzb := a_space "[" vz "]"
		
		if d = 1
			s := vr "%" _sx _sy vzb
		else if d = 2
			s:= sx_ vr "%" vzb
		else
			s := sx_ sy
	}
	else if f = 11 ; Repairs 1 durability in [100/value] seconds 
	{
		;redefine values for edge case
		vn := Round(100/p)
		;~ vx := 100/25
		;~ vr := "(" vn " to " vx ")"
		;~ vz := Round((vn + vx) / 2)
		;~ vzb := a_space "[" vz "]"
		
		if d = 1
			s := StrReplace(sx,"%d",vn)
		else if d = 2
			s := StrReplace(sx,"%d",vn)
		else
			s := StrReplace(sx,"%d",vn)
	}
	else if f = 12 ; +[value] [string] // used for stupidity, freeze 
	{
		if d = 1
			s := "+" vr sx vzb
		else if d = 2
			s := sx_ "+" vr vzb
		else
			s := sx
	}
	else if f = 13 ; +[value] to [class] skill levels 
	{
		if p = 0
		{
			s := "+" vr " to " sx_ "Skills" vzb
		}
		else
		{
			s := "+" p " to random class skill levels"
		}
	}
	else if f = 14 ; +[value] to [skilltab] skills ([class] only) 
	{
			sx := StrReplace(sx,"%d",vr)
			s := sx " (" sy_ "only)" vzb
	}
	else if f = 15 ; [chance]% to case [slvl] [skill] on [event] 
	{
		s := StrReplace(sx,"%d%",vn)
		s := StrReplace(s,"%d",vx)
		s := StrReplace(s,"%s",p)
	}
	else if f = 16 ; Level %d %s Aura When Equipped 
	{
		s := StrReplace(sx,"%d%",vn)
		s := StrReplace(s,"%d",vr)
		s := StrReplace(s,"%s",p) vzb
	}
	else if f = 17 ; [value] [string1] (Increases near [time]) 
	{
		p:=(p=0) ? "(Increases During Daytime)"
		: (p=1) ? "(Increases Near Dusk)"
		: (p=2) ? "(Increases During Nighttime)"
		: (p=3) ? "(Increases Near Dawn)"
		: p ; if p isn't any of the above, keep same value
		
		if d = 1
			s := "+" vr _sx a_space p vzb
		else if d = 2
			s := "f " f " placeholder d" d " | " sx  vzb
		else
			s := "f " f " placeholder d" d " | " sx vzb
	}
	else if f = 18 ; [value]% [string1] (Increases near [time]) 
	{
		p:=(p=0) ? "(Increases During Daytime)"
		: (p=1) ? "(Increases Near Dusk)"
		: (p=2) ? "(Increases During Nighttime)"
		: (p=3) ? "(Increases Near Dawn)"
		: p ; if p isn't any of the above, keep same value

		if d = 1
			s := "+" vr "%" _sx a_space p vzb
		else if d = 2
			s := "f " f " placeholder d" d " | " sx vzb
		else
			s := "f " f " placeholder d" d " | " sx vzb
		;~ msgbox % "vr:"vr "`nvn:" vn "`nvx:" vx "`nsx:" sx "`nsy:" sy "`np:" p "`nd:" d
	}
	else if f = 19 ; this is used by stats that use Blizzard's sprintf implementation 
				;(if you don't know what that is, it won't be of interest to you eitherway I guess), 
				;look at how prismatic is setup, the string is the format that gets passed to their sprintf spinoff. 
	{
		if d = 1
			s := "f " f " placeholder d" d " | " sx vzb
		else if d = 2
			s := "f " f " placeholder d" d " | " sx vzb
		else
			s := StrReplace(sx,"%d",vr) vzb
			;~ s := "f " f " placeholder d" d " | " sx vzb
	}
	else if f = 20 ; [value * -1]% [string1] 
	{
		;redefine values for edge case
		vn := vn * -1
		vx := vx * -1
		vr := "(" vn " to " vx ")"
		vz := Round((vn + vx) / 2)
		vzb := a_space "[" vz "]"
		
		if d = 1
			s:=  vr "%" _sx vzb
		else if d = 2
			s:= sx_ vr "%" vzb
		else
			s:= sx
	}
	else if f = 21 ; [value * -1] [string1] 
	{
		;redefine values for edge case
		vn := vn * -1
		vx := vx * -1
		vr := "(" vn " to " vx ")"
		vz := Round((vn + vx) / 2)
		vzb := a_space "[" vz "]"
		
		if d = 1
			s:=  vr _sx vzb
		else if d = 2
			s:= sx_ vr vzb
		else
			s:= sx
	}
	else if f = 22 ; [value]% [string1] [montype] (warning: this is bugged in vanilla and doesn't work properly, see CE forum) 
	{
		if d = 1
			s := "f " f " placeholder d" d " | " sx vzb
		else if d = 2
			s := "f " f " placeholder d" d " | " sx vzb
		else
			s := "f " f " placeholder d" d " | " sx vzb
	}
	else if f = 23 ; [value]% [string1] [monster] 
	{
		if d = 1
			s := vr "%" _sx _sy vzb
		else if d = 2
			s := "f " f " placeholder d" d " | " sx vzb
		else
			s := "f " f " placeholder d" d " | " sx vzb
	}
	else if f = 24 ; used for charges, we all know how that desc looks icon_wink.gif 
	{
		s := vn _sx a_space vx a_space p
	}
	else if f = 25 ; not used by vanilla, present in the code but I didn't test it yet 
	{
		if d = 1
		{
			s := "f " f " placeholder d" d " | " sx vzb
		}
		else if d = 2
		{
			s := "f " f " placeholder d" d " | " sx vzb
		}
		else
		{
			s := "f " f " placeholder d" d " | " sx vzb
		}
	}
	else if f = 26 ; not used by vanilla, present in the code but I didn't test it yet 
	{
		if d = 1
		{
			s := "f " f " placeholder d" d " | " sx vzb
		}
		else if d = 2
		{
			s := "f " f " placeholder d" d " | " sx vzb
		}
		else
		{
			s := "f " f " placeholder d" d " | " sx vzb
		}
	}
	else if f = 27 ; +[value] to [skill] ([class] Only) 
	{
		if d = 1
		{
			s := "f " f " placeholder d" d " | " sx_ sy_ p vzb
		}
		else if d = 2
		{
			s := "f " f " placeholder d" d " | " sx_ sy_ p vzb
		}
		else
		{
			s := "+" vr " to " p " (" sx_ "only)" vzb
		}
		if sx = 
			s := StrReplace(s," only", "Oskill")
	}
	else if f = 28 ; +[value] to [skill] 
	{
		if d = 1
			s := "+" vr _sx vzb
		else if d = 2
			s := sx_ "+" vr vzb
		else
			s := "+" vr " to " p vzb
	}
	else if (f = -5) || (f = -6) || (f = -7)
	{
		s := StrReplace(sx,"%d%",vn)
		s := StrReplace(s,"%d",vx)
		s .= vzb
	}
	else
	{
		s := "Unknown descfunc: " d ". sx: [" sx "] sy: [" sy "] vn|vx: " vn "|" vx vzb
	}
	
	
	if (vn = vx) ;cleanup check, replace value range with a single value, remove value average
	{
		s := StrReplace(s,vr,vx)
		s := Trim(StrReplace(s,vzb))
	}
	if (s = "an evil force")
		s := s " {{desc:" f "}}"
	return s ;return the finished string
	
}




