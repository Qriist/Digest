;complete
GetT1ParamString(p)
{
	global
	If p != 0
	{
		p := Digest[ModFullName,"Decompile","skills",p,"skilldesc"]
		p := Digest[ModFullName,"Decompile","skilldesc",p,"str name"]
		p := Digest[ModFullName,"String",mod_lng,"By Number",p "R"]
	}
	else
		p=
	return p
}