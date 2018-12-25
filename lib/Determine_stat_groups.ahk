;complete
Determine_stat_groups(StatsToSort,DgrpList)
{
	Stats := []
	GroupArray := StrSplit(DgrpList,"`n","`r")
	Loop,% GroupArray.length()
	{
		CurrentGroupList := GroupArray[a_index] ;Working on one line at a time of the number bank
		CurrentGroupArray := StrSplit(CurrentGroupList,",")	;Splits into individual IDs
		CurrentGroupLength := CurrentGroupArray.length()	;Number of IDs in the line
		CurrentCheckLength := CurrentGroupArray.length()
		Loop,% CurrentGroupLength
		{
			if RegExMatch(StatsToSort,"\b(" CurrentGroupArray[a_index] ")\b")
			{	
				CurrentCheckLength := CurrentCheckLength - 1
			}
		}
		If CurrentCheckLength = 0
		{
			Loop,% CurrentGroupLength
				StatsToSort := RegExReplace(StatsToSort,"\b(" CurrentGroupArray[a_index] ")\b",,,1)
			Stats["Group",a_index] := CurrentGroupList
		}
	}
	
	Loop,parse,StatsToSort,`,
	{
		if (a_loopfield != "")
			Stats["Single",a_index] := A_LoopField
		;~ if a_index > 7
			;~ msgbox % a_index
	}
	;~ msgbox % st_printarr(stats)
	return Stats
}