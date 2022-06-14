/****************************************************************************************
	Function: BuildJson(obj) 
		Builds a JSON string from an AutoHotkey object

	Parameters:
		obj - An AutoHotkey array or object, which can include nested objects.

	Remarks:
		Originally Obj2Str() by Coco,
		http://www.autohotkey.com/board/topic/93300-what-format-to-store-settings-in/page-2#entry588373
		
		Modified to use double quotes instead of single quotes and to leave numeric values
		unquoted.

	Returns:
		The JSON string
*/
BuildJson(obj) 
{
	str := "" , array := true
	for k in obj {
		if (k == A_Index)
			continue
		array := false
		break
	}
	for a, b in obj
		str .= (array ? "" : """" a """: ") . (IsObject(b) ? BuildJson(b) : IsNumber(b) ? b : """" b """") . ", "	
	str := RTrim(str, " ,")
	return (array ? "[" str "]" : "{" str "}")
}

/*!
	Function: IsNumber(Num)
		Checks if Num is a number.

	Returns:
		True if Num is a number, false if not
*/
IsNumber(Num)
{
	if Num is number
		return true
	else
		return false
}