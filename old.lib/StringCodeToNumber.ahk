StringCodeToNumber(Record,mod_lng,code)
{
	/*
	Record = Digest[ModFullName,"String"]
	mod_lng = current languange
	code = Literal string to search for, aka "dummy"
	*/
	
	For k,v in Record[mod_lng,"By Number"]
	{
		if InStr(k,"R")
			DeDupe .= StrReplace(k,"R") ","
	}
	Sort,DeDupe, N D`,
	Loop,Parse,DeDupe,`,
	{
		if (Record[mod_lng,"By Number",a_loopfield "C"] = code)
			return a_loopfield
	}
}

;~ StringNumberToCode(Record,mod_lng,num)