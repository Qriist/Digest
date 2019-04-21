RecordKill(RecordArray,RecordsToKill,ValueToKill,DependantKill := "",KillLoopOffset := 0,SplitHere := "")
{
/*
RecordArray = name of the array to work on.
RecordsToKill = comma delimited list of key names to check for the given value. Spaces are significant. 
	Append a pipe (|) and a number to loop a given key with a number appended.
ValueToKill = If THAT value kill THIS key. Can be any string or text or numbers.
DependantKill = comma delimited list of key names to delete on a match in RecordsToKill. 
	Should probably only be used with a single RecordToKill. If RecordsToKill has a pipe, then this will loop in the same manner. No pipes here.
KillLoopOffset = a numeric adjustment to the loop to work on sequential numbers that don't start at 1
SplitHere = any single character that will split your string into 2 usable parts. If this is active then the number will REPLACE this string.
	Should probably not be in your key names.
*/
	RecordsToKill := StrSplit(RecordsToKill,",")
	For k,v in RecordsToKill
	{
		if InStr(v,"|")
		{
			If (SplitHere != "") AND (InStr(v,SplitHere))
			{
				Lv := StrSplit(StrSplit(v,"|")[1],SplitHere)[1]
				Lv2 := StrSplit(StrSplit(v,"|")[1],SplitHere)[2]
			}
			else
			{
				Lv := StrSplit(v,"|")[1]
				Lv2 := ""
			}	

			Loop, % StrSplit(v,"|")[2]
			{
				if (RecordArray[Lv (a_index + KillLoopOffset) Lv2] != ValueToKill)
					continue
				DeadRecNum := a_index
				RecordArray.Delete(Lv (a_index + KillLoopOffset) Lv2)
				Loop, % StrSplit(DependantKill,",").length()
				{
					If (SplitHere != "") AND (InStr(StrSplit(DependantKill,",")[a_index],SplitHere))
					{
						subkill := StrSplit(StrSplit(DependantKill,",")[a_index],SplitHere)[1]
						subkill2 := StrSplit(StrSplit(DependantKill,",")[a_index],SplitHere)[2]
					}
					else
						subkill := StrSplit(DependantKill,",")[a_index]
					RecordArray.Delete(subkill (DeadRecNum + KillLoopOffset) subkill2)
				}
			}
		}
		else
		{
			if (RecordArray[v] != ValueToKill)
				continue
			RecordArray.Delete(v)
			Loop, % StrSplit(DependantKill,",").length()
				RecordArray.Delete(StrSplit(DependantKill,",")[a_index])
		}
	}
}

RecordKillAdvanced(RecordArray,RecordsToKill,ValueToKill,DependantKill := "",KillLoopOffset := 0,SplitHere := "",Transformative := "",PassNull := "")
{
	RecordsToKill := StrSplit(RecordsToKill,",")
	For k,v in RecordsToKill
	{
		if InStr(v,"|")
		{
			If (SplitHere != "") AND (InStr(v,SplitHere))
			{
				Lv := StrSplit(StrSplit(v,"|")[1],SplitHere)[1]
				Lv2 := StrSplit(StrSplit(v,"|")[1],SplitHere)[2]
			}
			else
			{
				Lv := StrSplit(v,"|")[1]
				Lv2 := ""
			}	

			Loop, % StrSplit(v,"|")[2]
			{
				if (RecordArray[Lv (a_index + KillLoopOffset) Lv2] != ValueToKill)
					continue
				DeadRecNum := a_index
				;~ If (Transformative = "") and (PassNull = "")
					;~ RecordArray.Delete(Lv (a_index + KillLoopOffset) Lv2)
				;~ else
					RecordArray[Lv (a_index + KillLoopOffset) Lv2] := Transformative
				Loop, % StrSplit(DependantKill,",").length()
				{
					If (SplitHere != "") AND (InStr(StrSplit(DependantKill,",")[a_index],SplitHere))
					{
						subkill := StrSplit(StrSplit(DependantKill,",")[a_index],SplitHere)[1]
						subkill2 := StrSplit(StrSplit(DependantKill,",")[a_index],SplitHere)[2]
					}
					else
						subkill := StrSplit(DependantKill,",")[a_index]
				;~ If (Transformative = "") and (PassNull = "")
						;~ RecordArray.Delete(subkill (DeadRecNum + KillLoopOffset) subkill2)
					;~ else
						RecordArray[subkill (DeadRecNum + KillLoopOffset) subkill2] := Transformative
				}
			}
		}
		else
		{
			if (RecordArray[v] != ValueToKill)
				continue
			;~ If (Transformative = "") and (PassNull = "")
				;~ RecordArray.Delete(v)
			;~ else
				RecordArray[v] := Transformative
			Loop, % StrSplit(DependantKill,",").length()
				;~ If (Transformative = "") and (PassNull = "")
					;~ RecordArray.Delete(StrSplit(DependantKill,",")[a_index])
				;~ else
					RecordArray[StrSplit(DependantKill,",")[a_index]] := Transformative
		}
	}
}