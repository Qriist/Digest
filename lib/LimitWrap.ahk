limitWrap(value,utype)
{
	If (utype = "uint") AND  (value = 4294967295)
	{
		value := ""
	}
	return value
}