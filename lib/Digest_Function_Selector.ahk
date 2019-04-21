Digest_Function_Selector(Method,Module,CoreVersion,PassedFile)
{
	;Methods: Decompile,Recompile,String
	;PassedFile: a_scriptdir "\bin\" module ".bin"
	static KnownCores := ["114d"
	,"114b"
	,"113d"
	,"113c"
	,"113a"
	,"112a"
	,"111b"
	,"111"
	,"110s"
	,"110f"
	,"110b"
	,"110"
	,"109d"
	,"109b"
	,"109"
	,"108"
	,"107"]
	;~ ,"106" ;D2 Classic, possible future support.
	;~ ,"105b"
	;~ ,"104c"
	;~ ,"104b"
	;~ ,"103"
	;~ ,"102"
	;~ ,"101"
	;~ ,"100"]
	CoreTooHigh=1
	For k,v in KnownCores
	{
		;~ msgbox % "Digest_" Method "_" v "_" Module
		if (CoreTooHigh=1) ; This starts the selector at the appropriate version to walk back from
		{
			If (CoreVersion != v)
				continue
			Else
				CoreTooHigh=0
		}
		If isfunc("Digest_" Method "_" v "_" Module)
		{
			Digest_%Method%_%v%_%module%(PassedFile)
			return
		}
	}
	return "fail" ;If not found, fail silently
}