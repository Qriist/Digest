GetParameterString(p)
{
	If p != 0
	;~ If Decompile["T1Param" T1_index] != 0
	{
		T1Param := p
		T1Param := Digest[ModFullName,"Decompile","skills",T1Param,"skilldesc"]
		T1Param := Digest[ModFullName,"Decompile","skilldesc",T1Param,"str name"]
		T1Param := Digest[ModFullName,"String",mod_lng,"By Number",T1Param "R"]
		props := T1Param
	}
	else
		props=
	return props
}