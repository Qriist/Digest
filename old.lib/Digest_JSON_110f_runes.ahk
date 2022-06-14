;complete
Digest_JSON_110f_runes()
{
	global
	ItemsIndex=0
	If (Digest[ModFullName,"Recompile","Items"] = "")
	{
		For k, v in Digest[ModFullName,"Decompile","Armor"]
		{
			Digest[ModFullName,"Recompile","Items",ItemsIndex] := v
			ItemsIndex += 1
		}
		For k, v in Digest[ModFullName,"Decompile","Weapons"]
		{
			Digest[ModFullName,"Recompile","Items",ItemsIndex] := v
			ItemsIndex += 1
		}
		For k, v in Digest[ModFullName,"Decompile","Misc"]
		{
			Digest[ModFullName,"Recompile","Items",ItemsIndex] := v
			ItemsIndex += 1
		}
	}
	;~ array_gui(Digest[ModFullName,"Recompile","Items"])
	loop,% Digest[ModFullName,"Decompile",Module].length()
	{
		;~ If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		;~ {
			;~ GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			;~ StartTime := A_TickCount
		;~ }
		;Record size: 288
		RecordID := a_index 
		Decompile := Digest[ModFullName,"Decompile",Module,RecordID]
		Recompile := Digest[ModFullName,"Recompile",Module,RecordID] := {}
		if Decompile["complete"] = 0
			Recompile["Data"] .= "DISABLED!!!`n"
		if Decompile["server"] = 1
			Recompile["Data"] .= "SERVER ONLY!!!`n"
		Digest[ModFullName,"Recompile",Module,RecordID,"Data"] .= Digest[ModFullName,"String",mod_lng,"By Code",Decompile["Name"]] "`r`n"
		
		Digest[ModFullName,"Recompile",Module,RecordID,"Data"] .= "Allowed in: "
		Loop,6
		{
			itype := Decompile["itype" a_index]
			itype := Digest[ModFullName,"Decompile","itemtypes",itype+1,"code"]
			Recompile["Data"] .= itype ", "
		}
		Recompile["Data"] := Trim(Recompile["Data"],", ")
		Recompile["Data"] .= "`r`n"
		
		If (Decompile["etype1"] > 0) OR (Decompile["etype2"] > 0) OR (Decompile["etype3"] > 0) 
		{
			Digest[ModFullName,"Recompile",Module,RecordID,"Data"] .= "Forbidden in: "
			Loop,3
			{
				etype := Decompile["etype" a_index]
				etype := Digest[ModFullName,"Decompile","itemtypes",etype+1,"code"]
				Recompile["Data"] .= Decompile["etype" a_index] ", "
			}
			Recompile["Data"] := Trim(Recompile["Data"],", ")
			Recompile["Data"] .= "`n"
		}
		RL = 0
		Digest[ModFullName,"Recompile",Module,RecordID,"Data"] .= "Runes used: "
		Loop, 6
		{
			Rune := Decompile["Rune" a_index]
			If Digest[ModFullName,"Recompile","Items",Rune,"levelreq"] > RL
				RL := Digest[ModFullName,"Recompile","Items",Rune,"levelreq"]
			Rune := Digest[ModFullName,"Recompile","Items",Rune,"Code"]
			Rune := Digest[ModFullName,"String",Mod_LNG,"By Code",Trim(Rune)]
			;~ Msgbox % Decompile["Rune" a_index] "`n|" Digest[ModFullName,"Recompile","Items",Decompile["Rune" a_index],"Code"] "|`n" Digest[ModFullName,"String",Mod_LNG,"By Code",Trimrune]
			;~ msgbox % rune
			Rune := RegExReplace(Rune,"(ÿc.)")
			;~ ExitApp
			If Decompile["Rune" a_index] != 0
				Recompile["Data"] .= Rune " + "
			
		}
		Recompile["Data"] := Trim(Recompile["Data"],"+ ")
		Recompile["Data"] .= "`n"
		Recompile["Data"] .= "Min. Level: " RL "`n"
		Recompile["Data"] .= "T1C	|	T1P	|	Min	|	Max	|`n"
		Loop,7
		{
			
			if Decompile["T1Code" a_index] = -1
				continue
			T1Code := Decompile["T1Code" a_index]
			Recompile["Data"] .= T1Code a_tab "|" a_tab
			Recompile["Data"] .= Decompile["T1Param" a_index] a_tab "|" a_tab
			
			If Decompile["T1Param" a_index] != 0
			{
				T1Param := Decompile["T1Param" a_index]
				T1Param := Digest[ModFullName,"Decompile","skills",T1Param,"skilldesc"]
				T1Param := Digest[ModFullName,"Decompile","skilldesc",T1Param,"str name"]
				T1Param := Digest[ModFullName,"String",mod_lng,"By Number",T1Param "R"]
				props := T1Param ","
			}
			else
				props=
						
			Recompile["Data"] .= Decompile["T1Min" a_index] a_tab "|" a_tab
			Recompile["Data"] .= Decompile["T1Max" a_index] a_tab "|||" a_tab ;"`n"
			Loop, 7
			{
				
				if Digest[ModFullName,"Decompile","properties",T1Code,"stat" a_index] = 65535
					continue
				;~ If (a_index=1) and (T1Param != 0)
					;~ continue
				;at this point, need to look at properties\func1 to check for 5/6/7
				;~ if Digest[ModFullName,"Decompile","properties",T1C
				tprop := Digest[ModFullName,"Decompile","properties",T1Code,"stat" a_index]
				tprop := Digest[ModFullName,"Decompile","itemstatcost",tprop,"descstrpos"]
				
				if Digest[ModFullName,"String",mod_lng,"By Number", tprop "R"] != ""
					tprop := Digest[ModFullName,"String",mod_lng,"By Number", tprop "R"]
				else ; if Digest[ModFullName,"String",mod_lng,"By Number", tprop "R"] != ""
					tprop := "{{" tprop "}}"
				;~ Props .= Digest[ModFullName,"Decompile","properties",T1Code,"stat" a_index] ","
				;~ if T1Param !=0
					;~ Props .= T1Param ","
				;~ else
				If Digest[ModFullName,"Decompile","properties",T1Code,"func" a_index] != 1
					Props .= "[[" Digest[ModFullName,"Decompile","properties",T1Code,"func" a_index] "]]"
					Props .= tprop ","
			}
			Recompile["Data"] .= Props "`n"
		}
	}
}