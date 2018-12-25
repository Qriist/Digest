;complete
Determine_ISC_groups()
{
	global
	
	Loop,% Digest[ModFullName,"Decompile","itemstatcost"].length()
	{
		if (Digest[ModFullName,"Decompile","itemstatcost",a_index-1,"dgrp"] = 0)
		|| (Digest[ModFullName,"Decompile","itemstatcost",a_index-1,"dgrpstrpos"] = 5382)
			continue
		else
			dgrp := Digest[ModFullName,"Decompile","itemstatcost",a_index-1,"dgrp"] ;"|" Digest[ModFullName,"Decompile","itemstatcost",a_index-1,"dgrpfunc"]
		;~ dgrpfunc := Digest[ModFullName,"Decompile","itemstatcost",a_index-1,"dgrpfunc"]
		Digest[ModFullName,"Recompile","dgrp",dgrp,"dgrp"] .= a_index-1 ","
		
		;~ If Digest[ModFullName,"Decompile","itemstatcost",a_index-1,"dgrpfunc"] != 0
			;~ Digest[ModFullName,"Recompile","dgrp",dgrp,"dgrpfunc"] := Digest[ModFullName,"Decompile","itemstatcost",a_index-1,"dgrpfunc"]
		;~ if Digest[ModFullName,"Decompile","itemstatcost",a_index-1,"dgrpval"] != 0
			;~ Digest[ModFullName,"Recompile","dgrp",dgrp,"dgrpval"] := Digest[ModFullName,"Decompile","itemstatcost",a_index-1,"dgrpval"]		
		

		Digest[ModFullName,"Recompile","dgrp",dgrp,"dgrpstrpos"] := Digest[ModFullName,"Decompile","itemstatcost",a_index-1,"dgrpstrpos"]
		If Digest[ModFullName,"Decompile","itemstatcost",a_index-1,"dgrpstrneg"] != 5382
			Digest[ModFullName,"Recompile","dgrp",dgrp,"dgrpstrneg"] := Digest[ModFullName,"Decompile","itemstatcost",a_index-1,"dgrpstrneg"]
		If Digest[ModFullName,"Decompile","itemstatcost",a_index-1,"dgrpstr2"] != 5382
			Digest[ModFullName,"Recompile","dgrp",dgrp,"dgrpstr2"] := Digest[ModFullName,"Decompile","itemstatcost",a_index-1,"dgrpstr2"]
		descstrpos := Digest[ModFullName,"Decompile","itemstatcost",a_index-1,"descstrpos"]
		descstrpos := Digest[ModFullName,"String",mod_lng,"By Number", descstrpos "R"]

		Digest[ModFullName,"Recompile","dgrp",dgrp,"dgrpfunc"] := Digest[ModFullName,"Decompile","itemstatcost",a_index-1,"dgrpfunc"]
		Digest[ModFullName,"Recompile","dgrp",dgrp,"dgrpval"] := Digest[ModFullName,"Decompile","itemstatcost",a_index-1,"dgrpval"]
		;~ msgbox % descstrpos
		;~ msgbox % descstrpos
		;~ ExitApp
		;~ Digest[ModFullName,"Recompile","dgrp",dgrp,"Stats Replaced"] .= descstrpos ","
		;~ Digest[ModFullName,"Recompile","dgrp",dgrp,"dgrp"] .= a_index-1 ","
		
	}
	Loop,% Digest[ModFullName,"Recompile","dgrp"].length()
	{
		Digest[ModFullName,"Recompile","dgrp",a_index,"dgrp"] := Trim(Digest[ModFullName,"Recompile","dgrp",a_index,"dgrp"],",")
		;~ Digest[ModFullName,"Recompile","dgrp",a_index,"stats"] := Trim(Digest[ModFullName,"Recompile","dgrp",a_index,"stats"],",")
		;~ Digest[ModFullName,"Recompile","dgrp",dgrp,"Stats Replaced"] := Trim(Digest[ModFullName,"Recompile","dgrp",dgrp,"Stats Replaced"],",")
	}
	
	Loop,% Digest[ModFullName,"Recompile","dgrp"].length()
		;~ Digest[ModFullName,"Recompile","dgrp",-1,"dgrp"] .= a_index ":" Digest[ModFullName,"Recompile","dgrp",a_index,"dgrp"] "`n"
		Digest[ModFullName,"Recompile","dgrp",-1,"dgrp"] .= Digest[ModFullName,"Recompile","dgrp",a_index,"dgrp"] "`n"
	Digest[ModFullName,"Recompile","dgrp",-1,"dgrp"] := Trim(Digest[ModFullName,"Recompile","dgrp",-1,"dgrp"],"`n")
}
