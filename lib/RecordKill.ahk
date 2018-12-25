RecordKill(RecordArray,RecordsToKill,ValueToKill,DependantKill := "",KillLoopOffset := 0,SplitHere := "")
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