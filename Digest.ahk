FileEncoding UTF-8-RAW 
;====================================================================================================
EndingWhiteSpaceTrim(StringToTrim)
{
	Loop,
	{
		If (SubStr(StringToTrim,0)=a_space) OR (SubStr(StringToTrim,0)=a_tab) OR (SubStr(StringToTrim,0)="`n") OR (SubStr(StringToTrim,0)="`r")
		{
			StringTrimRight,StringToTrim,StringToTrim,1
		}
		else
			break
	}
	return StringToTrim
}





;====================================================================================================
StringUpper(StringToUp)
{
	StringUpper,StringtoUp,StringToUp
	return StringToUp
}





;====================================================================================================
st_printArr(array, depth=5, indentLevel="")
{
   for k,v in Array
   {
      list.= indentLevel "[" k "]"
      if (IsObject(v) && depth>1)
         list.="`n" st_printArr(v, depth-1, indentLevel . "    ")
      Else
         list.=" => " v
      list.="`n"
   }
   return rtrim(list)
}





;====================================================================================================
FileSize(file)
{
	FileGetSize,FileSizeReturned,%file%
	return FileSizeReturned
}





;====================================================================================================
MPQ_Extract(MPQ_list,FileMaskToExtractFromMPQ,PathToExtractToDisk,UseFullPathing:=1,UseExternalListFile:="",Debug:=0)
{
	;~ Load order: MPQ_list[a_index]
	;~ Priority order: MPQ_list[mpq_list.length()+1-a_index]
	
	;~ Debug stops:
	
	
	If UseFullPathing=1
		activefull := "/fp"
	else
		activefull :=
	If UseExternalListFile!=""
		ExLF := "/lf" a_space """" UseExternalListFile """"
	else
		ExLF := 
	mopaq_script := 
	
	Loop % MPQ_list.length()
	{
		If a_index=1
		{
			mopaq_script .= "openpatch" a_space """" MPQ_list[a_index] """" 
		}
		else
		{
			mopaq_script .= a_space """" MPQ_list[a_index] """"
		}
	}	
	mopaq_script .= a_space ExLF "`n"
		
		;~ msgbox,,a,MPQeditor.exe extract %FileMaskToExtractFromMPQ% "%PathToExtractToDisk%" %activefull%	
		 ;~ RunWait,%A_ScriptDir%\MPQeditor.exe extract "%a_loopfield%" %FileMaskToExtractFromMPQ% "%PathToExtractToDisk%" %activefull%
		
	
	mopaq_script .= "extract" a_space """" MPQ_list[1] """" a_space FileMaskToExtractFromMPQ a_space """" PathToExtractToDisk """" a_space activefull  "`n"
	mopaq_script .= "close"
	;~ msgbox % "extract" a_space """" MPQ_list[1] """" a_space FileMaskToExtractFromMPQ a_space """" PathToExtractToDisk """" a_space activefull "`n"
	;~ pause

	FileDelete,%A_ScriptDir%\mopaq_script
	FileAppend,%mopaq_script%,%A_ScriptDir%\mopaq_script
		If Debug=1
		Pause
	else if debug =2
		ExitApp
	;~ msgbox % mopaq_script
	;~ IfExist,%a_scriptdir%\ListFiles\listfile.mpq
		;~ msgbox % mopaq_script
	RunWait,%A_ScriptDir%\MPQeditor.exe console "%A_ScriptDir%\mopaq_script"
	If Debug=1
	{
		MsgBox,Paused at Mopaq Script execution...
		Pause
	}
	FileDelete,%A_ScriptDir%\mopaq_script
	return
}








;====================================================================================================
;~ FileCopy(Source,Destination,Overwrite := 0)
;~ {
    ;~ FileCopy, %SourcePattern%, %DestinationFolder%, %Overwrite%
    ;~ ErrorCount := ErrorLevel
    ;~ return ErrorCount
;~ }
;====================================================================================================
;====================================================================================================
;====================================================================================================
;====================================================================================================
;====================================================================================================
;====================================================================================================
;====================================================================================================















;====================================================================================================
/*!
	Library: ObjCSV Library
		AutoHotkey_L (AHK) functions to load from CSV files, sort, display and save collections of records using the
		Object data type.  
		  
		* Read and save files in any delimited format (CSV, semi-colon, tab delimited, single-line or multi-line, etc.).
		* Display, edit and read Collections in GUI ListView objects.
		* Export Collection to fixed-width, HTML or XML files.
		  
		For more info on CSV files, see
		[http://en.wikipedia.org/wiki/Comma-separated_values](http://en.wikipedia.org/wiki/Comma-separated_values).  
		  
		Written by Jean Lalonde ([JnLlnd](http://www.autohotkey.com/board/user/4880-jnllnd/) on AHK forum) using
		AutoHotkey_L v1.1.09.03+ ([http://l.autohotkey.net/](http://l.autohotkey.net/))  
		  
		### ONLINE MATERIAL
		* [Home of this library is on GitHub](https://github.com/JnLlnd/ObjCSV)
		* [The most up-to-date version of this AHK file on GitHub](https://raw.github.com/JnLlnd/ObjCSV/master/Lib/ObjCSV.ahk)
		* [Online ObjCSV Library Help](http://code.jeanlalonde.ca/ahk/ObjCSV/ObjCSV-doc/)
		* [Topic about this library on AutoHotkey forum](http://www.autohotkey.com/board/topic/96618-lib-objcsv-library-v01-library-to-load-and-save-csv-files-tofrom-objects-and-listview/)
		  
		### INSTRUCTIONS
			Copy this script in a file named ObjCSV.ahk and save this file in one of these \Lib folders:
				* %A_ScriptDir%\Lib\
				* %A_MyDocuments%\AutoHotkey\Lib\
				* \[path to the currently running AutoHotkey_L.exe]\Lib\
			  
			You can use the functions in this library by calling ObjCSV_FunctionName (no #Include required)
		  
		### VERSIONS HISTORY
			0.5.7  2016-12-20  In ObjCSV_CSV2Collection, if blnHeader is false (0) and strFieldNames is empty, strFieldNames returns the "C" field names created by the function.  
			0.5.6  2016-10-20  Stop trimming data value read from CSV file. Addition of blnTrim parameter to ObjCSV_ReturnDSVObjectArray
			(true by default for backward compatibility).  
			0.5.5  2016-08-28  Optional parameter strEol to ObjCSV_Collection2CSV and ObjCSV_Collection2Fixed now empty by default.
			If not provided, end-of-lines character(s) are detected in value to replace. The first end-of-lines character(s) found is used
			for remaining fields and records.  
            0.5.4  2016-08-23  Add optional parameter strEol to ObjCSV_Collection2CSV and ObjCSV_Collection2Fixed to set end-of-line
			character(s) in fields when line-breaks are replaced.  
			0.5.3  2016-08-21  Fix bug with blnAlwaysEncapsulate in ObjCSV_Collection2CSV.  
			0.5.2  2016-07-24  Add an option to ObjCSV_Collection2CSV and blnAlwaysEncapsulate functions to force encapsulation of all values.  
			0.5.1  2016-06-06  In ObjCSV_CSV2Collection if the ByRef parameter is empty, the file encoding is returned only for UTF-8 or
			UTF-16 encoded files (no BOM) because other types (ANSI or UTF-n-RAW) files cannot be differentiated by the AHK engine.  
			0.5.0  2016-05-23  Addition of file encoding optional parameter to ObjCSV_CSV2Collection, ObjCSV_Collection2CSV,
			ObjCSV_Collection2Fixed, ObjCSV_Collection2HTML and ObjCSV_Collection2XML. In ObjCSV_CSV2Collection if the ByRef parameter is
			empty, it is returned with the detected file encoding.  
			0.4.1  2014-03-05  Import files with equal sign before opening field encasulator to indicate text data or formula not to be
			interpreted as numeric when imported by XL (eg. ...;="12345";...). This is an XL-only CSV feature, not a standard CSV feature.  
			0.4.0  2013-12-29  Improved file system error handling (upgrade recommended). Compatibility breaker: review ErrorLevel codes only.  
			0.3.2  2013-11-27  Check presence of ROWS delimiters in HTML export template  
			0.3.1  2013-10-10  Fix ProgressStop missing bug, fix numeric column names bug  
			0.3.0  2013-10-07  Removed strRecordDelimiter, strOmitChars and strEndOfLine parameters. Replaced by ``r``n (CR-LF). 
			Compatibility breaker. Review functions calls for ObjCSV_CSV2Collection, ObjCSV_Collection2CSV, ObjCSV_Collection2Fixed, 
			ObjCSV_Collection2HTML, ObjCSV_Collection2XML, ObjCSV_Format4CSV and ObjCSV_ReturnDSVObjectArray  
			0.2.8  2013-10-06  Fix bug in progress start and stop  
			0.2.7  2013-10-06  Memory management optimization and introduction of ErrorLevel results  
			0.2.6  2013-09-29  Display progress using Progress bar or Status bar, customize progress messages, doc converted to GenDocs 3.0  
			0.2.5  2013-09-26  Optimize large variables management in save functions (2CSV, 2Fixed, 2HTML and 2XML),
			optimize progress bars refresh rates  
			0.2.4  2013-09-25  Fix a bug adding progress bar in ObjCSV_ListView2Collection  
			0.2.3  2013-09-20  Fix a bug when importing files with duplicate field names, reformating long lines of
			code  
			0.2.2  2013-09-15  Export to fixed-width (ObjCSV_Collection2Fixed), HTML (ObjCSV_Collection2HTML) and XML
			(ObjCSV_Collection2XML)  
			0.1.3  2013-09-08  Multi-line replacement character at load time in ObjCSV_CSV2Collection  
			0.1.2  2013-09-05  Standardize boolean parameters to 0/1 (not True/False) and without double-quotes  
			0.1.1  2013-08-26  First release

	Author: By Jean Lalonde
	Version: v0.5.7 (2016-12-20)
*/


;================================================
ObjCSV_CSV2Collection(strFilePath, ByRef strFieldNames, blnHeader := 1, blnMultiline := 1, intProgressType := 0
	, strFieldDelimiter := ",", strEncapsulator := """", strEolReplacement := "", strProgressText := "", ByRef strFileEncoding := "")
/*!
	Function: ObjCSV_CSV2Collection(strFilePath, ByRef strFieldNames [, blnHeader = 1, blnMultiline = 1, intProgressType = 0, strFieldDelimiter = ",", strEncapsulator = """", strEolReplacement = "", strProgressText := "", ByRef strFileEncoding := ""])
		Transfer the content of a CSV file to a collection of objects. Field names are taken from the first line of
		the file or from the strFieldNameReplacement parameter. If taken from the file, fields names are returned by
		the ByRef variable strFieldNames. Delimiters are configurable.

	Parameters:
		strFilePath - Path of the file to load, which is assumed to be in A_WorkingDir if an absolute path isn't specified.
		strFieldNames - (ByRef) Input: Names for object keys if blnHeader if false. Names must appear in the same order as they appear in the file, separated by the strFieldDelimiter character (see below). If names are not provided and blnHeader is false, "C" + column numbers are used as object keys, starting at 1, and strFieldNames will return the "C" names. Empty by default. Output: See "Returns:" below.
		blnHeader - (Optional) If true (or 1), the objects key names are taken from the header of the CSV file (first line of the file). If blnHeader if false (or 0), the first line is considered as data (see strFieldNames). True (or 1) by default.
		blnMultiline - (Optional) If true (or 1), multi-line fields are supported. Multi-line fields include line breaks (end-of-line characters) which are usualy considered as delimiters for records (lines of data). Multi-line fields must be enclosed by the strEncapsulator character (usualy double-quote, see below). True by default. NOTE-1: If you know that your CSV file does NOT include multi-line fields, turn this option to false (or 0) to allow handling of larger files and improve performance (RegEx experts, help needed! See the function code for details). NOTE-2: If blnMultiline is True, you can use the strEolReplacement parameter to specify a character (or string) that will be converted to line-breaks if found in the CSV file.
		intProgressType - (Optional) If 1, a progress bar is displayed. If -1, -2 or -n, the part "n" of the status bar is updated with the progress in percentage. See also strProgressText below. By default, no progress bar or status (0).
		strFieldDelimiter - (Optional) Field delimiter in the CSV file. One character, usually comma (default value) or tab. According to locale setting of software (e.g. MS Office) or user preferences, delimiter can be semi-colon (;), pipe (|), space, etc. NOTE-1: End-of-line characters (`n or `r) are prohibited as field separator since they are used as record delimiters. NOTE-2: Using the Trim function, %A_Space% and %A_Tab% (when tab is not a delimiter) are removed from the beginning and end of all field names and data.
		strEncapsulator - (Optional) Character (usualy double-quote) used in the CSV file to embed fields that include at least one of these special characters: line-breaks, field delimiters or the encapsulator character itself. In this last case, the encapsulator character must be doubled in the string. For example: "one ""quoted"" word". All fields and headers in the CSV file can be encapsulated, if desired by the file creator. Double-quote by default.
		strEolReplacement - (Optional) Character (or string) that will be converted to line-breaks if found in the CSV file. Replacements occur only when blnMultiline is True. Empty by default.
		strProgressText - (Optional) Text to display in the progress bar or in the status bar. For status bar progress, the string "##" is replaced with the percentage of progress. See also intProgressType above. Empty by default.
		strFileEncoding - (ByRef, Optional) File encoding: ANSI, UTF-8, UTF-16, UTF-8-RAW, UTF-16-RAW or CPnnnn (nnnn being a code page numeric identifier - see [https://autohotkey.com/docs/commands/FileEncoding.htm](https://autohotkey.com/docs/commands/FileEncoding.htm). Empty by default (using current encoding). If a literal value or a filled variable is passed as parameter, this value is used to set reading encoding. If an empty variable is passed to the ByRef parameter, the detected file encoding is returned in the ByRef variable.

	Returns:
		This functions returns an object that contains an array of objects. This collection of objects can be viewed as a table in a database. Each object in the collection is like a record (or a line) in a table. These records are, in fact, associative arrays which contain a list key-value pairs. Key names are like field names (or column names) in the table. Key names are taken in the header of the CSV file, if it exists. Keys can be strings or integers, while values can be of any type that can be expressed as text. The records can be read using the syntax obj[1], obj[2] (...). Field values can be read using the syntax obj[1].keyname or, when field names contain spaces, obj[1]["key name"]. The "Loop, Parse" and "For key, value in array" commands allow to easily browse the content of these objects.
		
		If blnHeader is true (or 1), the ByRef parameter strFieldNames returns a string containing the field names (object keys) read from the first line of the CSV file, in the format and in the order they appear in the file. If a field name is empty, it is replaced with "Empty_" and its field number.  If a field name is duplicated, the field number is added to the duplicate name.  If blnHeader is false (or 0), the value of strFieldNames is unchanged by the function except if strFieldNames is empty. In this case, strFieldNames will return the "C" field names created by this function.
		
		If an empty variable is passed to the ByRef parameter strFileEncoding, returns the detected file encoding.

		At the end of execution, the function sets ErrorLevel to: 0 No error / 1 Out of memory / 2 Memory limit / 3 No unused character for replacement (returned by sub-function Prepare4Multilines) / 255 Unknown error. If the function produces an "Memory limit reached" error, increase the #MaxMem value (see the help file).
*/
{
	objCollection := Object() ; object that will be returned by the function (a collection or array of objects)
	objHeader := Object() ; holds the keys (fields name) of the objects in the collection
	if !StrLen(strFileEncoding) and IsByRef(strFileEncoding) ; an empty variable was passed to strFileEncoding, detect the encoding
	{
		objFile := FileOpen(strFilePath, "r") ; open the file read-only
		strFileEncoding := (InStr(objFile.Encoding, "UTF-") ? objFile.Encoding : "")
		objFile.Close()
		objFile := ""
	}
	strPreviousFileEncoding := A_FileEncoding
	FileEncoding, % (strFileEncoding = "ANSI" ? "" : strFileEncoding) ; empty string to encode ANSI
	try
		FileRead, strData, %strFilePath% ; FileRead ignores #MaxMem and just reads the whole file into a variable
	catch e
	{
		if InStr(e.message, "Out of memory")
			ErrorLevel := 1 ; Out of memory
		else
			ErrorLevel := 255 ; Unknown error
		if (intProgressType)
			ProgressStop(intProgressType)
		FileEncoding, %strPreviousFileEncoding%
		return
	}
	FileEncoding, %strPreviousFileEncoding%
	if blnMultiline
	{
		chrEolReplacement := Prepare4Multilines(strData, strEncapsulator, intProgressType, strProgressText . " (1/2)")
			; replace `n (but keep the `r) to make sure each record temporarily stands on a single line *** not tested on Unix files
		if (ErrorLevel)
		{
			if (intProgressType)
				ProgressStop(intProgressType)
			return
		}
	}
	strData := Trim(strData, "`r`n")
		; remove empty line (record) at the beginning or end of the string, if present *** not tested on Unix files
	if (intProgressType)
	{
		intMaxProgress := StrLen(strData)
		intProgressBatchSize := ProgressBatchSize(intMaxProgress)
		intProgressIndex := 0
		intProgressThisBatch := 0
		if blnMultiline
			strProgressText := strProgressText . " (2/2)"
		ProgressStart(intProgressType, intMaxProgress, strProgressText)
	}
	Loop, Parse, strData, `n, `r ; read each line (record) of the CSV file
	{
		StringReplace, strThisLine, A_LoopField, % "=" . strEncapsulator, %strEncapsulator%, All
		intProgressIndex := intProgressIndex + StrLen(strThisLine) + 2
		intProgressThisBatch := intProgressThisBatch + StrLen(strThisLine) + 2
			; augment intProgressIndex of len of line + 2 for cr-lf
		if (intProgressType AND (intProgressThisBatch > intProgressBatchSize))
		{
			ProgressUpdate(intProgressType, intProgressIndex, intMaxProgress, strProgressText)
				; update progress bar only every %intProgressBatchSize% records
			intProgressThisBatch := 0
		}
		if (A_Index = 1) and (blnHeader) ; we have an header to read
		{
			objHeader := ObjCSV_ReturnDSVObjectArray(strThisLine, strFieldDelimiter, strEncapsulator)
				; returns an object array from the first line of the delimited-separated-value file
			strFieldNamesMatchList := strFieldDelimiter
			Loop, % objHeader.MaxIndex() ; check if fields names are empty or duplicated
			{
				if !StrLen(objHeader[A_Index]) ; field name is empty
					objHeader[A_Index] := "Empty_" . A_Index ; use field number as field name
				else
					if InStr(strFieldNamesMatchList, strFieldDelimiter . objHeader[A_Index] . strFieldDelimiter)
						; field name is duplicate
						objHeader[A_Index] := objHeader[A_Index] . "_" . A_Index ; add field number to field name
				strFieldNamesMatchList := strFieldNamesMatchList . objHeader[A_Index] . strFieldDelimiter
			}
			strFieldNames := ""
			for intIndex, strFieldName in objHeader ; returns the updated field names to the ByRef parameter
				strFieldNames := strFieldNames . ObjCSV_Format4CSV(strFieldName, strFieldDelimiter, strEncapsulator)
					. strFieldDelimiter
			StringTrimRight, strFieldNames, strFieldNames, 1 ; remove extra field delimiter
			if !(objHeader.MaxIndex()) ; we don't have an object, something went wrong
			{
				if (intProgressType)
					ProgressStop(intProgressType)
				ErrorLevel := 255 ; Unknown error
				return ; returns no object
			}
		}
		else
		{
			if (A_Index = 1)
			{
				; If we get here, bnHeader is false so there is no header in the CSV file
				if !StrLen(strFieldNames)
					; We must build the header
				{
					for intIndex, strFieldData in ObjCSV_ReturnDSVObjectArray(strThisLine, strFieldDelimiter, strEncapsulator, false)
						strFieldNames := strFieldNames . (StrLen(strFieldNames) ? strFieldDelimiter : "") . "C" . A_Index
							; build strFieldNames to use as header and to return to caller
					objHeader := ObjCSV_ReturnDSVObjectArray(strFieldNames, strFieldDelimiter, strEncapsulator)
				}
				; We have values in strFieldNames. Get field names from strFieldNames.
				objHeader := ObjCSV_ReturnDSVObjectArray(strFieldNames, strFieldDelimiter, strEncapsulator)
					; returns an object array from the delimited-separated-value strFieldNames string
			}
			objData := Object() ; object of one record in the collection
			for intIndex, strFieldData in ObjCSV_ReturnDSVObjectArray(strThisLine, strFieldDelimiter, strEncapsulator, false)
				; returns an object array from each line of the delimited-separated-value file
			{
				if blnMultiline
				{
					StringReplace, strFieldData, strFieldData, %chrEolReplacement%, `n, 1
						; put back all original `n in each field, if present
					StringReplace, strFieldData, strFieldData, %strEolReplacement%, `r`n, 1
						; replace all user-supplied replacement character with end-of-line (`r`n), if present *** not tested on Unix files
				}
				objData[objHeader[A_Index]] := strFieldData ; we always have field names in objHeader[A_Index]
			}
			objCollection.Insert(objData) ; add the object (record) to the collection
		}
	}
	if (intProgressType)
		ProgressStop(intProgressType)
	objHeader := ; release object
	ErrorLevel := 0
	return objCollection
}
;================================================



;================================================
ObjCSV_Collection2CSV(objCollection, strFilePath, blnHeader := 0, strFieldOrder := "", intProgressType := 0
	, blnOverwrite := 0, strFieldDelimiter := ",", strEncapsulator := """", strEolReplacement := ""
	, strProgressText := "", strFileEncoding := "", blnAlwaysEncapsulate := 0, strEol := "")
/*!
	Function: ObjCSV_Collection2CSV(objCollection, strFilePath [, blnHeader = 0, strFieldOrder = "", intProgressType = 0, blnOverwrite = 0, strFieldDelimiter = ",", strEncapsulator = """", strEolReplacement = "", strProgressText = "", strFileEncoding := "", blnAlwaysEncapsulate] := 0, strEol := "")
		Transfer the selected fields from a collection of objects to a CSV file. Field names taken from key names are optionally included in the CSV file. Delimiters are configurable.

	Parameters:
		objCollection - Object containing an array of objects (or collection). Objects in the collection are associative arrays which contain a list key-value pairs. See ObjCSV_CSV2Collection returned value for details.
		strFilePath - The name of the CSV file, which is assumed to be in %A_WorkingDir% if an absolute path isn't specified.
		blnHeader - (Optional) If true, the key names in the collection objects are inserted as header of the CSV file. Fields names are delimited by the strFieldDelimiter character.
		strFieldOrder - (Optional) List of field to include in the CSV file and the order of these fields in the file. Fields names must be separated by the strFieldDelimiter character and, if required, encapsulated by the strEncapsulator character. If empty, all fields are included. Empty by default.
		intProgressType - (Optional) If 1, a progress bar is displayed. If -1, -2 or -n, the part "n" of the status bar is updated with the progress in percentage. See also strProgressText below. By default, no progress bar or status (0).
		blnOverwrite - (Optional) If true (or 1), overwrite existing files. If false (or 0), content is appended to the existing file. False (or 0) by default. NOTE: If content is appended to an existing file, fields names and order should be the same as in the existing file.
		strFieldDelimiter - (Optional) Delimiter inserted between fields in the CSV file. Also used as delimiter in the above parameter strFieldOrder. One character, usually comma, tab or semi-colon. You can choose other delimiters like pipe (|), space, etc. Comma by default. NOTE: End-of-line characters (`n or `r) are prohibited as field separator since they are used as record delimiters.
		strEncapsulator - (Optional) One character (usualy double-quote) inserted in the CSV file to embed fields that include at least one of these special characters: line-breaks, field delimiters or the encapsulator character itself. In this last case, the encapsulator character is doubled in the string. For example: "one ""quoted"" word". Double-quote by default.
		strEolReplacement - (Optional) When empty, multi-line fields are saved unchanged. If not empty, end-of-line in multi-line fields are replaced by the character or string strEolReplacement. Empty by default. NOTE: Strings including replaced end-of-line will still be encapsulated with the strEncapsulator character.
		strProgressText - (Optional) Text to display in the progress bar or in the status bar. For status bar progress, the string "##" is replaced with the percentage of progress. See also intProgressType above. Empty by default.
		strFileEncoding - (Optional) File encoding: ANSI, UTF-8, UTF-16, UTF-8-RAW, UTF-16-RAW or CPnnnn (a code page with numeric identifier nnn - see [https://autohotkey.com/docs/commands/FileEncoding.htm](https://autohotkey.com/docs/commands/FileEncoding.htm)). Empty by default (system default ANSI code page).
		blnAlwaysEncapsulate - (Optional) If true (or 1), always encapsulate values with field encapsulator. If false (or 0), fields are encapsulated only if required (see strEncapsulator above). False (or 0) by default.
		strEol - (Optional) If strEolReplacement is used, character(s) that mark end-of-lines in multi-line fields. Use "`r`n" (carriage-return + line-feed, ASCII 13 & 10), "`n" (line-feed, ASCII 10) or "`r" (carriage-return, ASCII 13). If the parameter is empty, the content is searched to detect the first end-of-lines character(s) detected in the string (in the order "`r`n", "`n", "`r"). The first end-of-lines character(s) found is used for remaining fields and records. Empty by default.

	Returns:
		At the end of execution, the function sets ErrorLevel to: 0 No error / 1 File system error. For system errors, check A_LastError and google "windows system error codes".
*/
{
	strData := ""
	intMax := objCollection.MaxIndex()
	if (intProgressType)
	{
		intProgressBatchSize := ProgressBatchSize(intMax)
		ProgressStart(intProgressType, intMax, strProgressText)
	}
	if (blnHeader) ; put the field names (header) in the first line of the CSV file
	{
		if !StrLen(strFieldOrder)
			; we don't have a header, so we take field names from the first record of objCollection,
			; in their natural order 
		{
			for strFieldName, strValue in objCollection[1]
				strFieldOrder := strFieldOrder . ObjCSV_Format4CSV(strFieldName, strFieldDelimiter, strEncapsulator, blnAlwaysEncapsulate)
					. strFieldDelimiter
			StringTrimRight, strFieldOrder, strFieldOrder, 1 ; remove extra field delimiter
		}
		strData := strFieldOrder . "`r`n" ; put this header as first line of the file
	}
	if (blnOverwrite)
		FileDelete, %strFilePath%
	if StrLen(strFieldOrder) ; we put only these fields, in this order
		objHeader := ObjCSV_ReturnDSVObjectArray(strFieldOrder, strFieldDelimiter, strEncapsulator)
			; parse strFieldOrder handling encapsulated field names
	Loop, %intMax% ; for each record in the collection
	{
		strRecord := "" ; line to add to the CSV file
		if !Mod(A_Index, intProgressBatchSize) ; update progress bar and save every %intProgressBatchSize% records
		{
			if (intProgressType)
				ProgressUpdate(intProgressType, A_index, intMax, strProgressText)
			If !SaveBatch(strData, strFilePath, intProgressType, strFileEncoding)
				return
			strData := ""
		}
		if StrLen(strFieldOrder) ; we put only these fields, in this order
		{
			intLineNumber := A_Index
			for intColIndex, strFieldName in objHeader
			{
				strValue := CheckEolReplacement(objCollection[intLineNumber][Trim(strFieldName)], strEolReplacement, strEol)
				strRecord := strRecord . ObjCSV_Format4CSV(strValue, strFieldDelimiter, strEncapsulator, blnAlwaysEncapsulate) . strFieldDelimiter
			}
		}
		else ; we put all fields in the record (I assume the order of fields is the same for each object)
			for strFieldName, strValue in objCollection[A_Index]
			{
				strValue := ObjCSV_Format4CSV(strValue, strFieldDelimiter, strEncapsulator, blnAlwaysEncapsulate)
				strValue := CheckEolReplacement(strValue, strEolReplacement, strEol)
				strRecord := strRecord . ObjCSV_Format4CSV(strValue, strFieldDelimiter, strEncapsulator, blnAlwaysEncapsulate) . strFieldDelimiter
			}
		StringTrimRight, strRecord, strRecord, 1 ; remove extra field delimiter
		strData := strData . strRecord . "`r`n"
	}
	If !SaveBatch(strData, strFilePath, intProgressType, strFileEncoding)
		return
	if (intProgressType)
		ProgressStop(intProgressType)
	return
}
;================================================



;================================================
ObjCSV_Collection2Fixed(objCollection, strFilePath, strWidth, blnHeader := 0, strFieldOrder := "", intProgressType := 0
	, blnOverwrite := 0, strFieldDelimiter := ",", strEncapsulator := """", strEolReplacement := ""
	, strProgressText := "", strFileEncoding := "", strEol := "")
/*!
	Function: ObjCSV_Collection2Fixed(objCollection, strFilePath, strWidth [, blnHeader = 0, strFieldOrder = "", intProgressType = 0, blnOverwrite = 0, strFieldDelimiter = ",", strEncapsulator = """", strEolReplacement = "", strProgressText = "", strFileEncoding := "", strEol := ""])
		Transfer the selected fields from a collection of objects to a fixed-width file. Field names taken from key names are optionnaly included the file. Width are determined by the delimited string strWidth. Field names and data fields shorter than their width are padded with trailing spaces. Field names and data fields longer than their width are truncated at their maximal width.

	Parameters:
		objCollection - Object containing an array of objects (or collection). Objects in the collection are associative arrays which contain a list key-value pairs. See ObjCSV_CSV2Collection returned value for details.
		strFilePath - The name of the fixed-width destination file, which is assumed to be in %A_WorkingDir% if an absolute path isn't specified.
		strWidth - Width for each field. Each numeric values must be in the same order as strFieldOrder and separated by the strFieldDelimiter character.
		blnHeader - (Optional) If true, the field names in the collection objects are inserted as header of the file, padded or truncated according to each field's width. NOTE: If field names are longer than their fixed-width they will be truncated as well.
		strFieldOrder - (Optional) List of field to include in the file and the order of these fields in the file. Fields names must be separated by the strFieldDelimiter character and, if required, encapsulated by the strEncapsulator character. If empty, all fields are included. Empty by default.
		intProgressType - (Optional) If 1, a progress bar is displayed. If -1, -2 or -n, the part "n" of the status bar is updated with the progress in percentage. See also strProgressText below. By default, no progress bar or status (0).
		blnOverwrite - (Optional) If true (or 1), overwrite existing files. If false (or 0), content is appended to the existing file. False (or 0) by default. NOTE: If content is appended to an existing file, fields names and order should be the same as in the existing file.
		strFieldDelimiter - (Optional) Delimiter inserted between fields names in the strFieldOrder parameter and fields width in the strWidth parameter. This delimiter is NOT used in the file data. One character, usually comma, tab or semi-colon. You can choose other delimiters like pipe (|), space, etc. Comma by default. NOTE: End-of-line characters (`n or `r) are prohibited as field separator since they are used as record delimiters.
		strEncapsulator - (Optional) One character (usualy double-quote) inserted in the strFieldOrder parameter to embed field names that include at least one of these special characters: line-breaks, field delimiters or the encapsulator character itself. In this last case, the encapsulator character is doubled in the string. For example: "one ""quoted"" word". Double-quote by default. This delimiter is NOT used in the file data.
		strEolReplacement - (Optional) A fixed-width file should not include end-of-line within data. If it does and if a strEolReplacement is provided, end-of-line in multi-line fields are replaced by the string strEolReplacement and this (or these) characters are included in the fixed-width character count. Empty by default.
		strProgressText - (Optional) Text to display in the progress bar or in the status bar. For status bar progress, the string "##" is replaced with the percentage of progress. See also intProgressType above. Empty by default.
		strFileEncoding - (Optional) File encoding: ANSI, UTF-8, UTF-16, UTF-8-RAW, UTF-16-RAW or CPnnnn (a code page with numeric identifier nnn - see [https://autohotkey.com/docs/commands/FileEncoding.htm](https://autohotkey.com/docs/commands/FileEncoding.htm)). Empty by default (system default ANSI code page).
		strEol - (Optional) If strEolReplacement is used, character(s) that mark end-of-lines in multi-line fields. Use "`r`n" (carriage-return + line-feed, ASCII 13 & 10), "`n" (line-feed, ASCII 10) or "`r" (carriage-return, ASCII 13). If the parameter is empty, the content is searched to detect the first end-of-lines character(s) detected in the string (in the order "`r`n", "`n", "`r"). The first end-of-lines character(s) found is used for remaining fields and records. Empty by default.
	Returns:
		At the end of execution, the function sets ErrorLevel to: 0 No error / 1 File system error. For system errors, check A_LastError and google "windows system error codes".
*/
{
	StringSplit, arrIntWidth, strWidth, %strFieldDelimiter%
		; get width for each field in the pseudo-array arrIntWidth, so %arrIntWidth1% or arrIntWidth%intColIndex%
	strData := "" ; string to save in the fixed-width file
	intMax := objCollection.MaxIndex()
	if (intProgressType)
	{
		intProgressBatchSize := ProgressBatchSize(intMax)
		ProgressStart(intProgressType, intMax, strProgressText)
	}
	if (blnHeader) ; put the field names (header) in the first line of the file
	{
		strHeaderFixed := ""
		if StrLen(strFieldOrder) ; convert DSV string to fixed-width
		{
			for intColIndex, strFieldName in ObjCSV_ReturnDSVObjectArray(strFieldOrder, strFieldDelimiter, strEncapsulator)
				; parse strFieldOrder handling encapsulated field names
				strHeaderFixed := strHeaderFixed . MakeFixedWidth(strFieldName, arrIntWidth%intColIndex%)
					; add fixed-width field name for each column
		}
		else
			; we dont have a header, so we take field names from the first record of objCollection,
			; in their natural order
		{
			intColIndex := 1
			for strFieldName, strValue in objCollection[1]
			{
				strHeaderFixed := strHeaderFixed . MakeFixedWidth(strFieldName, arrIntWidth%intColIndex%)
					; add fixed-width field name for each column
				intColIndex := intColIndex + 1
			}
		}
		strData := strHeaderFixed . "`r`n" ; put this header as first line of the file
	}
	if (blnOverwrite)
		FileDelete, %strFilePath%
	Loop, %intMax% ; for each record in the collection
	{
		strRecord := "" ; line to add to the file
		if !Mod(A_Index, intProgressBatchSize) ; update progress bar and save every %intProgressBatchSize% records
		{
			if (intProgressType)
				ProgressUpdate(intProgressType, A_index, intMax, strProgressText)
			If !SaveBatch(strData, strFilePath, intProgressType, strFileEncoding)
				return
			strData := ""
		}
		if StrLen(strFieldOrder) ; we put only these fields, in this order
		{
			intLineNumber := A_Index
			for intColIndex, strFieldName in ObjCSV_ReturnDSVObjectArray(strFieldOrder, strFieldDelimiter, strEncapsulator)
				; parse strFieldOrder handling encapsulated field names
			{
				strValue := CheckEolReplacement(objCollection[intLineNumber][Trim(strFieldName)], strEolReplacement, strEol)
				strRecord := strRecord . MakeFixedWidth(strValue, arrIntWidth%intColIndex%)
					; add fixed-width data field for each column
			}
		}
		else ; we put all fields in the record (I assume the order of fields is the same for each object)
		{
			intColIndex := 1
			for strFieldName, strValue in objCollection[A_Index]
			{
				strValue := CheckEolReplacement(strValue, strEolReplacement, strEol)
				strRecord := strRecord . MakeFixedWidth(strValue, arrIntWidth%intColIndex%)
					; add fixed-width data field for each column
				intColIndex := intColIndex + 1
			}
		}
		strData := strData . strRecord . "`r`n" ; add record to the file
	}
	If !SaveBatch(strData, strFilePath, intProgressType, strFileEncoding)
		return
	if (intProgressType)
		ProgressStop(intProgressType)
	return
}
;================================================



;================================================
ObjCSV_Collection2HTML(objCollection, strFilePath, strTemplateFile, strTemplateEncapsulator := "~", intProgressType := 0
	, blnOverwrite := 0, strProgressText := "", strFileEncoding := "")
/*!
	Function: ObjCSV_Collection2HTML(objCollection, strFilePath, strTemplateFile [, strTemplateEncapsulator = ~, intProgressType = 0, blnOverwrite = 0, strProgressText = "", strFileEncoding := ""])
		Builds an HTML file based on a template file where variable names are replaced with the content in each record of the collection.

	Parameters:
		objCollection - Object containing an array of objects (or collection). Objects in the collection are associative arrays which contain a list key-value pairs. See ObjCSV_CSV2Collection returned value for details.
		strFilePath - The name of the HTML file, which is assumed to be in %A_WorkingDir% if an absolute path isn't specified. This path and name of the file can be inserted in the HTML template as described below.
		strTemplateFile - The name of the HTML template file used to create the HTML file, which is assumed to be in %A_WorkingDir% if an absolute path isn't specified. In the template, markups and variables are encapsulated by the strTemplateEncapsulator parameter (single charater of your choice). Markups and variables are not case sensitive unless StringCaseSense has been turned on. The template is divided in three sections: the header template (from the start of the file to the start of the row template), the row template (delimited by the markups ROWS and /ROWS) and the footer template (from the end of the row template to the end of the file). The row template is repeated in the output file for each record in the collection. Field names encapsulated by the strTemplateEncapsulator parameter are replaced by the matching data in each record.  Additionally, in the header and footer, the following variables encapsulated by the strTemplateEncapsulator are replaced by parts of the strFilePath parameter: FILENAME (file name without its path, but including its extension), DIR (drive letter or share name, if present, and directory of the file, final backslash excluded), EXTENSION (file's extension, dot excluded), NAMENOEXT (file name without its path, dot and extension) and DRIVE (drive letter or server name, if present). Finally, in the row template, ROWNUMBER is replaced by the current row number. This simple example, where each record has two fields named "Field1" and "Field2" and the strTemplateEncapsulator is ~ (tilde), shows the use of the various markups and variables:
			> <HEAD>
			>   <TITLE>~NAMENOEXT~</TITLE>
			> </HEAD>
			> <BODY>
			>   <H1>~FILENAME~</H1>
			>   <TABLE>
			>     <TR>
			>       <TH>Row #</TH><TH>Field One</TH><TH>Field Two</TH>
			>     </TR>
			> ~ROWS~
			>     <TR>
			>       <TD>~ROWNUMBER~</TD><TD>~Field1~</TD><TD>~Field2~</TD>
			>     </TR>
			> ~/ROWS~
			>   </TABLE>
			>   Source: ~DIR~\~FILENAME~
			> </BODY>
		strTemplateEncapsulator - (Optional) One character used to encapsulate markups and variable names in the template. By default ~ (tilde).
		intProgressType - (Optional) If 1, a progress bar is displayed. If -1, -2 or -n, the part "n" of the status bar is updated with the progress in percentage. See also strProgressText below. By default, no progress bar or status (0).
		blnOverwrite - (Optional) If true (or 1), overwrite existing files. If false (or 0) and the output file exists, the function ends without writing the output file. False (or 0) by default.
		strProgressText - (Optional) Text to display in the progress bar or in the status bar. For status bar progress, the string "##" is replaced with the percentage of progress. See also intProgressType above. Empty by default.
		strFileEncoding - (Optional) File encoding: ANSI, UTF-8, UTF-16, UTF-8-RAW, UTF-16-RAW or CPnnnn (a code page with numeric identifier nnn - see [https://autohotkey.com/docs/commands/FileEncoding.htm](https://autohotkey.com/docs/commands/FileEncoding.htm)). Empty by default (system default ANSI code page).

	Returns:
		At the end of execution, the function sets ErrorLevel to: 0 No error / 1 File system error / 2 No HTML template / 3 Invalid encapsulator / 4 No ~ROWS~ start delimiter / 5 No ~/ROWS~ end delimiter / 6 File exists and should not be overwritten. For system errors, check A_LastError and google "windows system error codes".
*/
{
	if (FileExist(strFilePath) and !blnOverwrite)
		ErrorLevel := 6 ; File exists and should not be overwritten
	if !FileExist(strTemplateFile)
		ErrorLevel := 2 ; No HTML template
	if StrLen(strTemplateEncapsulator) <> 1
		ErrorLevel := 3 ; Invalid encapsulator
	if (ErrorLevel)
		return
	strPreviousFileEncoding := A_FileEncoding
	FileEncoding, % (strFileEncoding = "ANSI" ? "" : strFileEncoding) ; empty string to encode ANSI
	FileRead, strTemplate, %strTemplateFile%
	FileEncoding, %strPreviousFileEncoding%
	intPos := InStr(strTemplate, strTemplateEncapsulator . "ROWS" . strTemplateEncapsulator)
		; start of the row template
	if (intPos = 0)
		ErrorLevel := 4 ; No ~ROWS~ start delimiter
	strTemplateHeader :=  SubStr(strTemplate, 1, intPos - 1) ; extract header
	strTemplate :=  SubStr(strTemplate, intPos + 6) ; remove header template from template string
	intPos := InStr(strTemplate, strTemplateEncapsulator . "/ROWS" . strTemplateEncapsulator)
		; end of the row template
	if (intPos = 0)
		ErrorLevel := 5 ; No ~/ROWS~ end delimiter
	if (ErrorLevel)
		return
	strTemplateRow :=  SubStr(strTemplate, 1, intPos - 1) ; extract row template
	strTemplate :=  SubStr(strTemplate, intPos + 7) ; remove row template from template string
	strTemplateFooter := strTemplate ; remaining of the template string is the footer template
	strData := MakeHTMLHeaderFooter(strTemplateHeader, strFilePath, strTemplateEncapsulator)
		; replace variables in the header template and initialize the HTML data string
	intMax := objCollection.MaxIndex()
	if (intProgressType)
	{
		intProgressBatchSize := ProgressBatchSize(intMax)
		ProgressStart(intProgressType, intMax, strProgressText)
	}
	if (blnOverwrite)
		FileDelete, %strFilePath% ; delete existing file if present, no error if missing
	Loop, %intMax% ; for each record in the collection
	{
		if !Mod(A_Index, intProgressBatchSize) ; update progress bar and save every %intProgressBatchSize% records
		{
			if (intProgressType)
				ProgressUpdate(intProgressType, A_index, intMax, strProgressText)
			If !SaveBatch(strData, strFilePath, intProgressType, strFileEncoding)
				return
			strData := ""
		}
		strData := strData . MakeHTMLRow(strTemplateRow, objCollection[A_Index], A_Index, strTemplateEncapsulator) 
			. "`r`n" ; replace variables in the row template and append to the HTML data string
	}
	strData := strData . MakeHTMLHeaderFooter(strTemplateFooter, strFilePath, strTemplateEncapsulator)
		; replace variables in the footer template and append to the HTML data string
	If !SaveBatch(strData, strFilePath, intProgressType, strFileEncoding)
		return
	if (intProgressType)
		ProgressStop(intProgressType)
	ErrorLevel := 0
	return
}
;================================================



;================================================
ObjCSV_Collection2XML(objCollection, strFilePath, intProgressType := 0, blnOverwrite := 0, strProgressText := "", strFileEncoding := "")
/*!
	Function: ObjCSV_Collection2XML(objCollection, strFilePath [, intProgressType = 0, blnOverwrite = 0, strProgressText = "", strFileEncoding := ""])
		Builds an XML file from the content of the collection. The calling script must ensure that field names and field data comply with the rules of XML syntax. This simple example, where each record has two fields named "Field1" and "Field2", shows the XML output format:
			> <?xml version='1.0'?>
			> <XMLExport>
			>   <Record>
			>     <Field1>Value Row 1 Col 1</Field1>
			>     <Field2>Value Row 1 Col 2</Field1>
			>   </Record>
			>   <Record>
			>     <Field1>Value Row 2 Col 1</Field1>
			>     <Field2>Value Row 2 Col 2</Field1>
			>   </Record>
			> </XMLExport>

	Parameters:
		objCollection - Object containing an array of objects (or collection). Objects in the collection are associative arrays which contain a list key-value pairs. See ObjCSV_CSV2Collection returned value for details.
		strFilePath - The name of the XML file, which is assumed to be in %A_WorkingDir% if an absolute path isn't specified.
		intProgressType - (Optional) If 1, a progress bar is displayed. If -1, -2 or -n, the part "n" of the status bar is updated with the progress in percentage. See also strProgressText below. By default, no progress bar or status (0).
		blnOverwrite - (Optional) If true (or 1), overwrite existing files. If false (or 0) and the output file exists, the function ends without writing the output file. False (or 0) by default.
		strProgressText - (Optional) Text to display in the progress bar or in the status bar. For status bar progress, the string "##" is replaced with the percentage of progress. See also intProgressType above. Empty by default.
		strFileEncoding - (Optional) File encoding: ANSI, UTF-8, UTF-16, UTF-8-RAW, UTF-16-RAW or CPnnnn (a code page with numeric identifier nnn - see [https://autohotkey.com/docs/commands/FileEncoding.htm](https://autohotkey.com/docs/commands/FileEncoding.htm)). Empty by default (system default ANSI code page).

	Returns:
		At the end of execution, the function sets ErrorLevel to: 0 No error / 1 File system error / 2 File exists and should not be overwritten. For system errors, check A_LastError and google "windows system error codes".
*/
{
	if (FileExist(strFilePath) and !blnOverwrite)
	{
		if (intProgressType)
			ProgressStop(intProgressType)
		ErrorLevel := 2 ; File exists and should not be overwritten
		return
	}
	strData := "<?xml version='1.0'?>`r`n<XMLExport>`r`n"
		; initialize the XML data string with XML header
	intMax := objCollection.MaxIndex()
	if (intProgressType)
	{
		intProgressBatchSize := ProgressBatchSize(intMax)
		ProgressStart(intProgressType, intMax, strProgressText)
	}
	if (blnOverwrite)
		FileDelete, %strFilePath% ; delete existing file if present, no error if missing
	Loop, %intMax% ; for each record in the collection
	{
		if !Mod(A_Index, intProgressBatchSize) ; update progress bar and save every %intProgressBatchSize% records
		{
			if (intProgressType)
				ProgressUpdate(intProgressType, A_index, intMax, strProgressText)
			If !SaveBatch(strData, strFilePath, intProgressType, strFileEncoding)
				return
			strData := ""
		}
		strData := strData . MakeXMLRow(objCollection[A_Index])
			; append XML for this row to the XML data string
	}
	strData := strData . "</XMLExport>`r`n" ; append XML footer to the XML data string
	If !SaveBatch(strData, strFilePath, intProgressType, strFileEncoding)
		return
	if (intProgressType)
		ProgressStop(intProgressType)
	ErrorLevel := 0
	return
}
;================================================



;================================================
ObjCSV_Collection2ListView(objCollection, strGuiID := "", strListViewID := "", strFieldOrder := ""
	, strFieldDelimiter := ",", strEncapsulator := """", strSortFields := "", strSortOptions := ""
	, intProgressType := 0, strProgressText := "")
/*!
	Function: ObjCSV_Collection2ListView(objCollection [, strGuiID = "", strListViewID = "", strFieldOrder = "", strFieldDelimiter = ",", strEncapsulator = """", strSortFields = "", strSortOptions = "", intProgressType = 0, strProgressText = ""])
		Transfer the selected fields from a collection of objects to ListView. The collection can be sorted by the function. Field names taken from the objects keys are used as header for the ListView. NOTE-1: Due to an AHK limitation, files with more that 200 fields will not be transfered to a ListView. NOTE-2: Although up to 8191 characters of text can be stored in each cell of a ListView, only the first 260 characters are displayed (no lost data under 8192 characters).

	Parameters:
		objCollection - Object containing an array of objects (or collection). Objects in the collection are associative arrays which contain a list key-value pairs. See ObjCSV_CSV2Collection returned value for details. NOTE: Multi-line fields can be inserted in a ListView and retreived from a ListView. However, take note that end-of-lines will not be visible in cells with current version of AHK_L (v1.1.09.03).
		strGuiID - (Optional) Name of the Gui that contains the ListView where the collection will be displayed. If empty, the last default Gui is used. Empty by default. NOTE: If a Gui name is provided, this Gui will remain the default Gui at the termination of the function.
		strListViewID - (Optional) Name of the target ListView where the collection will be displayed. If empty, the last default ListView is used. The target ListView should be empty or should contain data in the same columns number and order than the data to display. If this is not respected, new columns will be added to the right of existing columns and new rows will be added at the bottom of existing data. Empty by default. NOTE-1: Performance is greatly improved if we provide the ListView ID because we avoid redraw during import. NOTE-2: If a ListView name is provided, this ListView will remain the default at the termination of the function.
		strFieldOrder - (Optional) List of field to include in the ListView and the order of these columns. Fields names must be separated by the strFieldDelimiter character. If empty, all fields are included. Empty by default.
		strFieldDelimiter - (Optional) Delimiter of the fields in the strFieldOrder parameter. One character, usually comma, but can also be tab, semi-colon, pipe (|), space, etc. Comma by default.
		strEncapsulator - (Optional) One character (usualy double-quote) possibly used in the in the strFieldOrder string to embed fields that would include special characters (as described above).
		strSortFields - (Optional) Field(s) value(s) used to sort the collection before its insertion in the ListView. To sort on more than one field, concatenate field names with the + character (e.g. "LastName+FirstName"). Faster sort can be obtained by manualy clicking on columns headers in the ListView after the collection has been inserted. Empty by default.
		strSortOptions - (Optional) Sorting options to apply to the sort command above. A string of zero or more of the option letters (in any order, with optional spaces in between). Most frequently used are R (reverse order) and N (numeric sort). All AHK_L sort options are supported. See [http://l.autohotkey.net/docs/commands/Sort.htm](http://l.autohotkey.net/docs/commands/Sort.htm) for more options. Empty by default.
		intProgressType - (Optional) If 1, a progress bar is displayed. If -1, -2 or -n, the part "n" of the status bar is updated with the progress in percentage. See also strProgressText below. By default, no progress bar or status (0).
		strProgressText - (Optional) Text to display in the progress bar or in the status bar. For status bar progress, the string "##" is replaced with the percentage of progress. See also intProgressType above. Empty by default.

	Returns:
		At the end of execution, the function sets ErrorLevel to: 0 No error / 1 More than 200 columns.
*/
{
	objHeader := Object() ; holds the keys (fields name) of the objects in the collection
	if StrLen(strSortFields)
	{
		objCollection := ObjCSV_SortCollection(objCollection, strSortFields, strSortOptions, intProgressType
			, strProgressText . " (1/2)")
		strProgressText := strProgressText . " (2/2)"
	}
	intMax := objCollection.MaxIndex()
	if (intProgressType)
	{
		intProgressBatchSize := ProgressBatchSize(intMax)
		ProgressStart(intProgressType, intMax, strProgressText)
	}
	if StrLen(strGuiID)
		Gui, %strGuiID%:Default
	if StrLen(strListViewID)
		GuiControl, -Redraw, %strListViewID% ; stop drawing the ListView during import
	if StrLen(strListViewID)
		Gui, ListView, %strListViewID% ; sets the default ListView in the default Gui
	if !StrLen(strFieldOrder)
		; if we dont have fields restriction or order, take all fields in their natural order in the first records
	{
		for strFieldName, strValue in objCollection[1] ; use the first record to get the field names
			strFieldOrder := strFieldOrder . strFieldName . strFieldDelimiter
		StringTrimRight, strFieldOrder, strFieldOrder, 1 ; remove extra field delimiter
	}
	objHeader := ObjCSV_ReturnDSVObjectArray(strFieldOrder, strFieldDelimiter, strEncapsulator)
		; returns an object array from a delimited-separated-value string
	if objHeader.MaxIndex() > 200 ; ListView cannot display more that 200 columns
	{
		if (intProgressType)
			ProgressStop(intProgressType)
		ErrorLevel := 1 ; More than 200 columns
		return ; displays nothing in the ListView
	}
	for intIndex, strFieldName in objHeader
	{
		LV_GetText(strExistingFieldName, 0, intIndex) ; line 0 returns column names
		if (Trim(strFieldName) <> strExistingFieldName)
			LV_InsertCol(intIndex, "", Trim(strFieldName))
	}
	loop, %intMax%
	{
		if (intProgressType) and !Mod(A_index, intProgressBatchSize)
			ProgressUpdate(intProgressType, A_index, intMax, strProgressText)
				; update progress bar only every %intProgressBatchSize% records
		intRowNumber := A_Index
		arrFields := Array() ; will contain the values for each cell of a new row
		for intIndex, strFieldName in objHeader
			arrFields[intIndex] := objCollection[intRowNumber][Trim(strFieldName)]
				; for each field, in the specified order, add the data to the array
		LV_Add("", arrFields*) ; put each item of the array in cells of a new ListView row
		; "arrFields*" is allowed because LV_Add is a variadic function
		; (see http://www.autohotkey.com/board/topic/92531-lv-add-to-add-an-array/)
	}
	Loop, % arrFields.MaxIndex()
		LV_ModifyCol(A_Index, "AutoHdr") ; adjust width of each column according to their content
	if StrLen(strListViewID)
		GuiControl, +Redraw, %strListViewID% ; redraw the ListView
	if (intProgressType)
		ProgressStop(intProgressType)
	Gui, Show
	objHeader := ; release object
	ErrorLevel := 0
}
;================================================



;================================================
ObjCSV_ListView2Collection(strGuiID := "", strListViewID := "", strFieldOrder := "", strFieldDelimiter := ","
	, strEncapsulator := """", intProgressType := 0, strProgressText := "")
/*!
	Function: ObjCSV_ListView2Collection([strGuiID = "", strListViewID = "", strFieldOrder = "", strFieldDelimiter = ",", strEncapsulator = """", intProgressType = 0, strProgressText = ""])
		Transfer the selected lines of the selected columns of a ListView to a collection of objects. Lines are transfered in the order they appear in the ListView. Column headers are used as objects keys.

	Parameters:
		strGuiID - (Optional) Name of the Gui that contains the ListView where is the data to transfer. If empty, the last default Gui is used. Empty by default. NOTE: If a Gui name is provided, this Gui will remain the default Gui at the termination of the function.
		strListViewID - (Optional) Name of the target ListView where is the data to transfer. If empty, the last default ListView is used. If one or more rows in the ListView are selected, only these rows will be inserted in the collection. Empty by default. NOTE: If a ListView name is provided, this ListView will remain the default at the termination of the function.
		strFieldOrder - (Optional) Name of the fields (or ListView columns) to insert in the collection records. Names are separated by the strFieldDelimiter character (see below). If empty, all fields are transfered. Empty by default.
		strFieldDelimiter - (Optional) Delimiter of the fields in the strFieldOrder parameter. One character, usually comma, but can also be tab, semi-colon, pipe (|), space, etc. Comma by default.
		strEncapsulator - (Optional) One character (usualy double-quote) possibly used in the in the strFieldOrder string to embed fields data or field names that would include special characters (as described above).
		intProgressType - (Optional) If 1, a progress bar is displayed. If -1, -2 or -n, the part "n" of the status bar is updated with the progress in percentage. See also strProgressText below. By default, no progress bar or status (0).
		strProgressText - (Optional) Text to display in the progress bar or in the status bar. For status bar progress, the string "##" is replaced with the percentage of progress. See also intProgressType above. Empty by default.

	Returns:
		This functions returns an object that contains a collection (or array of objects). See ObjCSV_CSV2Collection returned value for details.
*/
{
	objCollection := Object() ; object that will be returned by the function (a collection or array of objects)
	if StrLen(strGuiID)
		Gui, %strGuiID%:Default
	if StrLen(strListViewID)
		Gui, ListView, %strListViewID%
	intNbCols := LV_GetCount("Column") ; get the number of columns in the ListView
	intNbRows := LV_GetCount() ; get the number of lines in the ListView
	intNbRowsSelected := LV_GetCount("Selected")
	blnSelected := (intNbRowsSelected > 0) ; we will read only selected rows
	if (intProgressType)
	{
		if (blnSelected)
		{
			intProgressBatchSize := ProgressBatchSize(intNbRowsSelected)
			intNbRowsProgress:= intNbRowsSelected
		}
		else
		{
			intProgressBatchSize := ProgressBatchSize(intNbRows)
			intNbRowsProgress:= intNbRows
		}
		ProgressStart(intProgressType, intNbRowsProgress, strProgressText)
	}
	objHeaderPositions := Object()
		; holds the keys (fields name) of the objects in the collection and their position in the ListView
	; build an object array with field names and their position in the ListView header
	loop, %intNbCols%
	{
		LV_GetText(strFieldHeader, 0, A_Index)
		objHeaderPositions.Insert(strFieldHeader, A_Index)
	}
	if !(StrLen(strFieldOrder)) ; if empty, we build strFieldOrder from the ListView header
	{
		loop, %intNbCols%
		{
			LV_GetText(strFieldHeader, 0, A_Index)
			strFieldOrder := strFieldOrder . ObjCSV_Format4CSV(strFieldHeader, strFieldDelimiter, strEncapsulator)
				. strFieldDelimiter ; handle field named with special characters requiring encapsulation
		}
		StringTrimRight, strFieldOrder, strFieldOrder, 1
	}
	intRowNumber := 0 ; scan each row or selected row of the ListView
	Loop
	{
		if (intProgressType) and !Mod(A_index, intProgressBatchSize)
			ProgressUpdate(intProgressType, A_index, intNbRowsProgress, strProgressText)
				; update progress bar only every %intProgressBatchSize% records
		if (blnSelected)
			intRowNumber := LV_GetNext(intRowNumber) ; get next selected row number
		else
			intRowNumber := intRowNumber + 1 ; get next row number
		if (not intRowNumber) OR (intRowNumber > intNbRows)
			; we passed the last row or the last selected row of the ListView
			break
		objData := Object() ; add row data to a new object in the collection
		for intIndex, strFieldName in ObjCSV_ReturnDSVObjectArray(strFieldOrder, strFieldDelimiter, strEncapsulator)
			; parse strFieldOrder handling encapsulated fields
		{
			LV_GetText(strFieldData, intRowNumber, objHeaderPositions[Trim(strFieldName)])
				; get data from cell at row number/header position ListView
			objData[strFieldName] := strFieldData ; put data in the appropriate field of the new row
		}
		objCollection.Insert(objData)
	}
	if (intProgressType)
		ProgressStop(intProgressType)
	objHeaderPositions := ; release object
	return objCollection
}
;================================================



;================================================
ObjCSV_SortCollection(objCollection, strSortFields, strSortOptions := "", intProgressType := 0, strProgressText := "")
/*!
	Function: ObjCSV_SortCollection(objCollection, strSortFields [, strSortOptions = "", intProgressType = 0, strProgressText = ""])
		Scan a collection of objects, sort the collection on one or more field and return sorted collection. Standard AHK_L sort options are supported.

	Parameters:
		objCollection - Object containing an array of objects (or collection). Objects in the collection are associative arrays which contain a list key-value pairs. See ObjCSV_CSV2Collection returned value for details.
		strSortFields - Name(s) of the field(s) to use as sort criteria. To sort on more than one field, concatenate field names with the + character (e.g. "LastName+FirstName").
		strSortOptions - (Optional) Sorting options to apply to the sort command. A string of zero or more of the option letters (in any order, with optional spaces in between). Most frequently used are R (reverse order) and N (numeric sort). All AHK_L sort options are supported. See [http://l.autohotkey.net/docs/commands/Sort.htm](http://l.autohotkey.net/docs/commands/Sort.htm) for more options. Empty by default.
		intProgressType - (Optional) If 1, a progress bar is displayed. If -1, -2 or -n, the part "n" of the status bar is updated with the progress in percentage. See also strProgressText below. By default, no progress bar or status (0).
		strProgressText - (Optional) Text to display in the progress bar or in the status bar. For status bar progress, the string "##" is replaced with the percentage of progress. See also intProgressType above. Empty by default.

	Returns:
		This functions returns an object that contains the array (or collection) of objects of objCollection sorted on strSortFields. See ObjCSV_CSV2Collection returned value for details.
*/
{
	objCollectionSorted := Object()
		; Array (or collection) of sorted objects returned by this function.
		; See ObjCSV_CSV2Collection returned value for details.
	objCollectionSorted.SetCapacity(objCollection.MaxIndex())
	strIndexDelimiter := "|" ;
	intTotalRecords := objCollection.MaxIndex()
	if (intProgressType)
	{
		intProgressBatchSize := ProgressBatchSize(intTotalRecords)
		ProgressStart(intProgressType, intTotalRecords, strProgressText)
	}
	strIndex := ""
	; The variable strIndex is a multi-line string used as an index to sort the collection.
	; Each line of the index contains the sort values and record numbers separated by the pipe (|) character.
	; For example:
	;   value_one|1
	;   value_two|2
	;   value_three|3
	; This string is sorted using the standard AHK_L Sort command:
	;   value_one|1
	;   value_three|3
	;   value_two|2
	; The sorted string is used as an index to sort the records in objCollectionSorted according to the sorting
	; values. In our example, the objects will be added to the sorted collection in this order: 1, 3, 2.
	;
	; Because strIndex can be quite large, we gain performance by splitting the string in substrings of around 300 kb.
	; See discussion on AHK forum
	; http://www.autohotkey.com/board/topic/92832-tip-large-strings-performance-or-divide-to-conquer/
	intOptimalSizeOfSubstrings := 300000 ; found by trial and error - no impact on results if not the optimal size
	strSubstring := ""
	Loop, %intTotalRecords% ; populate index substrings
	{
		intRecordNumber := A_Index
		if (intProgressType) and !Mod(A_index, intProgressBatchSize)
			ProgressUpdate(intProgressType, A_index, intTotalRecords, strProgressText)
				; update progress bar only every %intProgressBatchSize% records
		if InStr(strSortFields, "+")
		{
			strSortingValue := ""
			Loop, Parse, strSortFields, +
				strSortingValue := strSortingValue . objCollection[intRecordNumber][A_LoopField] . "+"
		}
		else
			strSortingValue := objCollection[intRecordNumber][strSortFields]
		StringReplace, strSortingValue, strSortingValue, %strIndexDelimiter%, , 1
			; suppress all index delimiters inside sorting values
		StringReplace, strSortingValue, strSortingValue, `n, , 1
			; suppress all end-of-lines characters inside sorting values 
		strSubstring := strSubstring . strSortingValue . strIndexDelimiter . intRecordNumber . "`n"
		if StrLen(strSubstring) > intOptimalSizeOfSubstrings
		{
			strIndex := strIndex . strSubstring ; add this substring to the final string
			strSubstring := "" ; start a new substring
		}
	}
	strIndex := strIndex . strSubstring ; add the last substring to the final string
	StringTrimRight, strIndex, strIndex, 1
	Sort, strIndex, %strSortOptions%
	Loop, Parse, strIndex, `n
	{
		StringSplit, arrRecordKey, A_LoopField, %strIndexDelimiter%
			; get the record numbers in the original collection in the order the have to be inserted
			; in the sorted collection
		objCollectionSorted.Insert(objCollection[arrRecordKey2])
	}
	if (intProgressType)
		ProgressStop(intProgressType)
	return objCollectionSorted
}
;================================================



;================================================
ObjCSV_Format4CSV(strF4C, strFieldDelimiter := ",", strEncapsulator := """", blnAlwaysEncapsulate := 0)
/*!
	Function: ObjCSV_Format4CSV(strF4C [, strFieldDelimiter = ",", strEncapsulator = """"])
		Add encapsulator before and after strF4C if the string includes line breaks, field delimiter or field encapsulator. Encapsulated field encapsulators are doubled.
		  
	Parameters:
		strF4C - String to convert to CSV format
		strFieldDelimiter - (Optional) Field delimiter. One character, usually comma (default value) or tab.
		strEncapsulator - (Optional) Character (usualy double-quote) used in the CSV file to embed fields that include at least one of these special characters: line-breaks, field delimiters or the encapsulator character itself. In this last case, the encapsulator character must be doubled in the string. For example: "one ""quoted"" word". Double-quote by default.
		blnAlwaysEncapsulate - (Optional) If true (or 1), always encapsulate values with field encapsulator. If false (or 0), fields are encapsulated only if required (see strEncapsulator above). False (or 0) by default.

	Returns:
		String with required encapsulator.
		
	Remarks:
		Based on Format4CSV by Rhys ([http://www.autohotkey.com/forum/topic27233.html](http://www.autohotkey.com/forum/topic27233.html)).  
		  
		Added the strFieldDelimiter parameter to make it work with separators other than comma.  
		Added the strEncapsulator parameter to make it work with other encapsultors than double-quotes.
*/
{
	Reformat := blnAlwaysEncapsulate ; was False before the new parameter blnAlwaysEncapsulate - assume String is OK unless caller wants to encasulate anyway
	IfInString, strF4C, `n ; Check for linefeeds
		Reformat := True ; String must be bracketed by double-quotes
	IfInString, strF4C, `r ; Check for linefeeds
		Reformat := True
	IfInString, strF4C, %strFieldDelimiter% ; Check for field delimiter
		Reformat := True
	if InStr(strF4C, strEncapsulator) or (blnAlwaysEncapsulate)
	{
		Reformat := True
		StringReplace, strF4C, strF4C, %strEncapsulator%, %strEncapsulator%%strEncapsulator%, All
		; The original encapsulator need to be double encapsulator
	}
   /*
   IfInString, strF4C, %strEncapsulator% ; Check for encapsulator
   {
      Reformat:=True
      StringReplace, strF4C, strF4C, %strEncapsulator%, %strEncapsulator%%strEncapsulator%, All
		; The original encapsulator need to be double encapsulator
   }
   */
	If (Reformat)
		strF4C = %strEncapsulator%%strF4C%%strEncapsulator% ; If needed, bracket the string in encapsulators
	Return, strF4C
}
;================================================



;================================================
ObjCSV_ReturnDSVObjectArray(strCurrentDSVLine, strDelimiter := ",", strEncapsulator := """", blnTrim := true)
/*!
	Function: ObjCSV_ReturnDSVObjectArray(strCurrentDSVLine, strDelimiter = ",", strEncapsulator = """")
		Returns an object array from a delimiter-separated string.
		  
	Parameters:
		strCurrentDSVLine - String to convert to an object array
		strDelimiter - (Optional) Field strDelimiter. One character, usually comma (default value) or tab.
		strEncapsulator - (Optional) Character (usualy double-quote) used in the CSV file to embed fields that include at least one of these special characters: line-breaks, field strDelimiters or the strEncapsulator character itself. In this last case, the strEncapsulator character must be doubled in the string. For example: "one ""quoted"" word". Double-quote by default.
		blnTrim - Remove extra spaces at beginning and end of array item. True by default for backward compatibility.

	Returns:
		Returns an object array from a strDelimiter-separated string.

		At the end of execution, the function sets ErrorLevel to: 0 No error / 1 Invalid strDelimiter or strEncapsulator.
		
	Remarks:
		Based on ReturnDSVArray by DerRaphael (thanks for regex hard work).  
		See strDelimiter Seperated Values by DerRaphael ([http://www.autohotkey.com/forum/post-203280.html#203280](http://www.autohotkey.com/forum/post-203280.html#203280)).
*/
{
	objReturnObject := Object()             ; create a local object array that will be returned by the function
	if ((StrLen(strDelimiter)!=1)||(StrLen(strEncapsulator)!=1))
	{
		ErrorLevel := 1
		return                              ; return empty object indicating an error
	}
	strPreviousFormat := A_FormatInteger    ; save current interger format
	SetFormat,integer,H                     ; needed for escaping the RegExNeedle properly
	d := SubStr(ASC(strDelimiter)+0,2)         ; used as hex notation in the RegExNeedle
	e := SubStr(ASC(strEncapsulator)+0,2)      ; used as hex notation in the RegExNeedle
	SetFormat,integer,%strPreviousFormat%   ; restore previous integer format

	p0 := 1                                 ; Start of search at char p0 in DSV Line
	fieldCount := 0                         ; start off with empty fields.
	strCurrentDSVLine .= strDelimiter             ; Add strDelimiter, otherwise last field
	;                                         won't get recognized
	Loop
	{
		RegExNeedle := "\" d "(?=(?:[^\" e "]*\" e "[^\" e "]*\" e ")*(?![^\" e "]*\" e "))"
		p1 := RegExMatch(strCurrentDSVLine,RegExNeedle,tmp,p0)
		; p1 contains now the position of our current delimitor in a 1-based index
		fieldCount++                        ; add count
		field := SubStr(strCurrentDSVLine,p0,p1-p0)
		; This is the Line you'll have to change if you want different treatment
		; otherwise your resulting fields from the DSV data Line will be stored in an object array
		if (SubStr(field,1,1)=strEncapsulator)
		{
			; This is the exception handling for removing any doubled strEncapsulators and
			; leading/trailing strEncapsulator chars
			field := RegExReplace(field,"^\" e "|\" e "$")
			StringReplace,field,field,% strEncapsulator strEncapsulator,%strEncapsulator%, All
		}
		objReturnObject.Insert(blnTrim ? Trim(field) : field) ; add an item in the object array and assign our value to it
		;                                                       blnTrim and Trim not in the original ReturnDSVArray but added for my script needs
		if (p1=0)
		{                                   ; p1 is 0 when no more delimitor chars have been found
			 objReturnObject.Remove()       ; so remove last item in the object array due to last appended delimitor
			 Break                          ; and exit Loop
		} Else
			p0 := p1 + 1                    ; set the start of our RegEx Search to last result
	}                                       ; added by one
	ErrorLevel := 0
	return objReturnObject                  ; return the object array to the function caller
}



;******************************************************************************************************************** 
; INTERNAL FUNCTIONS
;******************************************************************************************************************** 

Prepare4Multilines(ByRef strCsvData, strFieldEncapsulator := """", intProgressType := 0, strProgressText := "")
/*
	Function: Prepare4Multilines(ByRef strCsvData [, strFieldEncapsulator = """", intProgressType = 0, strProgressText = ""])
		Replace end-of-line characters (`n) in field data in strCsvData with a replacement character in order to make data rows stand on a single-line before they are processed by the "Loop, Parse" command. A safe replacement character (absent from the strCsvData string) is automatically determined by the function.

	Parameters:
		strCsvData - (ByRef) Input: Data string to process. Output: See "Returns:" below. 
		strFieldEncapsulator - (Optional) Character used in the strCsvData data to embed fields that include line-breaks. Double-quote by default.
		intProgressType - (Optional) If 1, a progress bar is displayed. If -1, -2 or -n, the part "n" of the status bar is updated with the progress in percentage. See also strProgressText below. By default, no progress bar or status (0).
		strProgressText - (Optional) Text to display in the progress bar or in the status bar. For status bar progress, the string "##" is replaced with the percentage of progress. See also intProgressType above. Empty by default.

	Returns:
		The function returns the replacement character for end-of-lines. Usualy � (inverted exclamation mark, ASCII 161) or the next available safe character: � (ASCII 162), � (ASCII 163), � (ASCII 164), etc.  The caller of this function *must* save this value in a variable and *must* do the reverse replacement with `n at the appropriate step inside a "Loop, Parse" command.  
		  
		The ByRef parameter strCsvData returns the data string with all end-of-line characters (`n) replaced with the safe replacement character.

		At the end of execution, the function sets ErrorLevel to: 0 No error / 2 Memory limit / 3 No unused character for replacement (returned by sub-function GetFirstUnusedAsciiCode) / 255 Unknown error. If the function produces an "Memory limit reached" error, increase the #MaxMem value (see the help file).
*/
/*
CALL-FOR-HELP!
	#1 This function uses a very rudimentary algorithm to do the replacements only when the end-of-line charaters are
	enclosed between double-quotes. I'm confident my code is safe. But there is certainly a more efficient way to
	accomplish this: RegEx command or another approach? Any help appreciated here :-)
	#2 Need help to test it / make sure this work with ASCII files produced on Unix or Mac systems
	see http://peterbenjamin.com/seminars/crossplatform/texteol.html)
*/
{
	if (intProgressType)
	{
		intMaxProgress := StrLen(strCsvData)
		intProgressBatchSize := ProgressBatchSize(intMaxProgress)
		if (intProgressBatchSize < 8192)
			intProgressBatchSize := 8192
		ProgressStart(intProgressType, intMaxProgress, strProgressText)
	}
	intEolReplacementAsciiCode := GetFirstUnusedAsciiCode(strCsvData) ; Usualy � (inverted exclamation mark, ASCII 161)
	if (ErrorLevel) ; No unused character for replacement
		return
	try
		strTestMemCapacity := strCsvData ; test if we have enough room inside #MaxMem to create a copy of strCsvData
	catch e
	{
		if InStr(e.message, "Memory limit")
			ErrorLevel := 2 ; File too large (Memory limit reached - see #MaxMem in the help file)
		else
			ErrorLevel := 255 ; Unknown error
		return
	}
	strTestMemCapacity := "" ; release memory used by strTestMemCapacity
	blnInsideEncapsulators := false
	Loop, Parse, strCsvData
		; parsing on a temporary copy of strCsvData -  so we can update the original strCsvData inside the loop
	{
		if (intProgressType AND !Mod(A_Index, intProgressBatchSize))
			ProgressUpdate(intProgressType, A_index, intMaxProgress, strProgressText)
		if (A_Index = 1)
			strCsvData := ""
		if (blnInsideEncapsulators AND A_Loopfield = "`n")
			strCsvData := strCsvData . Chr(intEolReplacementAsciiCode)
		else
			strCsvData := strCsvData . A_Loopfield
		if (A_Loopfield = strFieldEncapsulator)
			blnInsideEncapsulators := !blnInsideEncapsulators ; beginning or end of encapsulated text
	}
	if (intProgressType)
		ProgressStop(intProgressType)
	ErrorLevel := 0
	return Chr(intEolReplacementAsciiCode)
}



GetFirstUnusedAsciiCode(ByRef strData, intAscii := 161)
/*
Summary: Returns the ASCII code of the first character absent from the strData string, starting at ASCII code intAscii.
By default, � (inverted exclamation mark ASCII 161) or the next available character: � (ASCII 162), � (ASCII 163),
� (ASCII 164), etc.

At the end of execution, the function sets ErrorLevel to: 0 No error / 3 No unused character.

NOTE: Despite the use of ByRef for the parameter strData, the string is unchanged by the function. ByRef is used only
to optimize memory usage by this function.
*/
{
	Loop
		if InStr(strData, Chr(intAscii))
			intAscii := intAscii + 1
		else if (intAscii > 255) ; no more candidate to check
		{
			intAscii := 0
			ErrorLevel := 3 ; No unused character
			return
		}
		else
			break
	ErrorLevel := 0
	return intAscii
}



SaveBatch(strData, strFilePath, intProgressType, strFileEncoding)
{
	strPreviousFileEncoding := A_FileEncoding
	FileEncoding, % (strFileEncoding = "ANSI" ? "" : strFileEncoding) ; empty string to encode ANSI
	
	loop
	{
		FileAppend, %strData%, %strFilePath%
		if ErrorLevel
			Sleep, 20
	}
	until !ErrorLevel or (A_Index > 50) ; after 1 second (20ms x 50), we have a problem

	If (ErrorLevel) and (intProgressType)
		ProgressStop(intProgressType)
	FileEncoding, %strPreviousFileEncoding%

	return !ErrorLevel
}



MakeFixedWidth(strFixed, intWidth)
{
	while StrLen(strFixed) < intWidth
		strFixed := strFixed . " " ; pad with space
	return SubStr(strFixed, 1, intWidth) ; or truncate
}



MakeHTMLHeaderFooter(strTemplate, strFilePath, strEncapsulator)
{
	SplitPath, strFilePath, strFileName, strDir, strExtension, strNameNoExt, strDrive
	StringReplace, strOutput, strTemplate, %strEncapsulator%FILENAME%strEncapsulator%, %strFileName%, All
	StringReplace, strOutput, strOutput, %strEncapsulator%DIR%strEncapsulator%, %strDir%, All
	StringReplace, strOutput, strOutput, %strEncapsulator%EXTENSION%strEncapsulator%, %strExtension%, All
	StringReplace, strOutput, strOutput, %strEncapsulator%NAMENOEXT%strEncapsulator%, %strNameNoExt%, All
	StringReplace, strOutput, strOutput, %strEncapsulator%DRIVE%strEncapsulator%, %strDrive%, All
	return %strOutput%
}



MakeHTMLRow(strTemplate, objRow, intRow, strEncapsulator)
{
	StringReplace, strOutput, strTemplate, %strEncapsulator%ROWNUMBER%strEncapsulator%, %intRow%, All
	for strFieldName, strValue in objRow
		StringReplace, strOutput, strOutput, %strEncapsulator%%strFieldName%%strEncapsulator%, %strValue%, All
	return %strOutput%
}



MakeXMLRow(objRow)
{
	strOutput := A_Tab . "<Record>`r`n"
	for strFieldName, strValue in objRow
		strOutput := strOutput . A_Tab . A_Tab . "<" . strFieldName .  ">" . strValue . "</" . strFieldName .  ">`r`n"
	strOutput := strOutput . A_Tab . "</Record>`r`n"
	return %strOutput%
}



ProgressBatchSize(intMax)
{
	intSize := Round(intMax / 100)
	if (intSize < 100)
		intSize := 100
	return intSize
}



ProgressStart(intType, intMax, strText)
{
	Gui, +Disabled
	if (intType = 1)
		Progress, R0-%intMax% FS8 A, %strText%, , , MS Sans Serif
	else
	{
		StringReplace, strText, strText, ##, 0
		SB_SetText(strText, -intType)
	}
}



ProgressUpdate(intType, intActual, intMax, strText)
{
	if (intType = 1)
		Progress, %intActual%
	else
	{
		StringReplace, strText, strText, ##, % Round(intActual*100/intMax)
		SB_SetText(strText, -intType)
	}
}



ProgressStop(intType)
{
	Gui, -Disabled
	if (intType = 1)
		Progress, Off
	else
		SB_SetText("", -intType)
}



CheckEolReplacement(strData, strEolReplacement, ByRef strEol)
{
	if StrLen(strEolReplacement) ; multiline field eol replacement
	{
		if !StrLen(strEol)
			strEol := GetEolCharacters(strData) ; if found, strEol will be re-used for next records
		if StrLen(strEol)
			StringReplace, strData, strData, %strEol%, %strEolReplacement%, All ; handle multiline data fields
	}
	return strData
}



GetEolCharacters(strData)
; search to detect the first end-of-lines character(s) detected in the string (in the order "`r`n", "`n", "`r"). Returns empty if none is found.
{
	strEolCandidates := "`r`n|`n|`r"
	loop, Parse, strEolCandidates, |
		if InStr(strData, A_LoopField)
			return A_LoopField
	return := "" ; return empty if no end-of-line detected
}


/*
IsBOM(ByRef str)
; Based on HotKeyIt (https://autohotkey.com/board/topic/93295-dynarun/#entry592328)
; MsgBox % DownloadedString:=NoBOM(DownloadToString("http://learningone.ahk4.net/Temp/Test3.ahk"))
{
	if (0xBFBBEF = NumGet(&str, "UInt") & 0xFFFFFF)
		return 3
	else if (0xFFFE = NumGet(&str, "UShort") || 0xFEFF = NumGet(&str, "UShort"))
		return 2
	else
		return 0
}



NoBOM(ByRef str)
; Based on HotKeyIt (https://autohotkey.com/board/topic/93295-dynarun/#entry592328)
{
	if (0xBFBBEF = NumGet(&str, "UInt") & 0xFFFFFF)
		return str := StrGet(&str + 3, "UTF-8")
	else if (0xFFFE = NumGet(&str, "UShort") || 0xFEFF = NumGet(&str, "UShort"))
		return str := SubStr(&str + 2, "UTF-16")
	else
		return str
}
*/






;====================================================================================================
;Robert's INI library
;Version 1.7
#noenv	;Increases the speed of the library due to the large amount of dynamic variables.
SetBatchLines -1	;Increases the overall speed of the script.
;-1 : Error, INI format is wrong
;-2 : Error, Sec not found
;-3 : Error, Key not found
;-4 : Error, Invalid optional paramater
;-5 : Error, Sec already exists
;-6 : Error, Key already exists
;-9 : Error, Reference number is already set
;-10 : Error, Reference number is invalid
;-11 : Error, Unable to read ini file
;-12 : Error, Unable to write ini file
;-13 : Error, Unable to delete existing ini file
;-14 : Error, Unable to rename temp ini file
;-15 : Error, Ini already exists
;Full function list at bottom


RIni_Create(RVar, Correct_Errors=1)
{
	Global
	
	If (RVar = "")
		Return -10
	If (RIni_%RVar%_Is_Set != "")
		Return -9
	If (Correct_Errors = 1)
		RIni_%RVar%_Fix_Errors := 1
	Else If (Correct_Errors != 0)
		Return -4
	RIni_%RVar%_Is_Set := 1
	, RIni_Unicode_Modifier := A_IsUnicode ? 2 : 1
	, RIni_%RVar%_Section_Number := 1
}


RIni_Shutdown(RVar)
{
	Global
	Local Sec
	
	If (RIni_%RVar%_Is_Set = "")
		Return -10
	If %RVar%_First_Comments
		VarSetCapacity(%RVar%_First_Comments, 0)
	Loop, % RIni_%RVar%_Section_Number
	{
		If (RIni_%RVar%_%A_Index% != ""){
			Sec := RIni_CalcMD5(RIni_%RVar%_%A_Index%)
			, VarSetCapacity(RIni_%RVar%_%A_Index%, 0)
			, VarSetCapacity(RIni_%RVar%_%Sec%_Number, 0)
			, VarSetCapacity(RIni_%RVar%_%Sec%_Is_Set, 0)
			If %RVar%_%Sec%_Lone_Line_Comments
				VarSetCapacity(%RVar%_%Sec%_Lone_Line_Comments, 0)
			If %RVar%_%Sec%_Comment
				VarSetCapacity(%RVar%_%Sec%_Comment, 0)
			If (%RVar%_All_%Sec%_Keys){
				Loop, Parse, %RVar%_All_%Sec%_Keys, `n
				{
					If A_Loopfield =
						Continue
					If (%RVar%_%Sec%_%A_LoopField%_Name != "")
						VarSetCapacity(%RVar%_%Sec%_%A_LoopField%_Name, 0)
					If (%RVar%_%Sec%_%A_LoopField%_Value != "")
						VarSetCapacity(%RVar%_%Sec%_%A_LoopField%_Value, 0)
					If %RVar%_%Sec%_%A_LoopField%_Comment
						VarSetCapacity(%RVar%_%Sec%_%A_LoopField%_Comment, 0)
				}
				VarSetCapacity(%RVar%_All_%Sec%_Keys, 0)
			}
		}
	}

	If RIni_%RVar%_Fix_Errors
		VarSetCapacity(RIni_%RVar%_Fix_Errors, 0)
	VarSetCapacity(RIni_%RVar%_Is_Set, 0)
	, VarSetCapacity(RIni_%RVar%_Section_Number, 0)
}


RIni_Read(RVar, File, Correct_Errors=1, Remove_Inline_Key_Comments=0, Remove_Lone_Line_Comments=0, Remove_Inline_Section_Comments=0, Treat_Duplicate_Sections=1, Treat_Duplicate_Keys=1, Read_Blank_Sections=1, Read_Blank_Keys=1, Trim_Spaces_From_Values=0, ByRef RIni_Read_Var = "")
{
	;Treat_Duplicate_Sections
	;1 - Skip
	;2 - Append
	;3 - Replace
	;4 - Add new keys
	;Treat_Duplicate_Keys
	;1 - Skip
	;2 - Append
	;3 - Replace
	Global
	Local Has_Equal, Sec, Key, P_1, P_2, Section_Skip, C_Pos, Section_Append, T_Sections, T_Section, E, T_LoopField, Errored_Lines, T_Value
	Local T_Section_Number, TSec, TKey, T_Section_Name
	
	If (RVar = "")
		Return -10
	If (RIni_%RVar%_Is_Set != "")
		Return -9
	
	If (RIni_Read_Var = "")
	{
		FileRead, RIni_Read_Var, %File%
		If Errorlevel
			Return -11
	}
	If (Correct_Errors = 1)
		RIni_%RVar%_Fix_Errors := 1
	Else If (Correct_Errors != 0)
		Return -4
	RIni_Unicode_Modifier := A_IsUnicode ? 2 : 1
	, RIni_%RVar%_Is_Set := 1
	, RIni_%RVar%_Section_Number := 1
	
	Loop, Parse, RIni_Read_Var, `n, `r
	{
		If A_LoopField =
			Continue
		T_LoopField = %A_LoopField%
		If (SubStr(T_Loopfield, 1, 1) = ";"){
			If !Section_Skip
			{
				If !Remove_Lone_Line_Comments
				{
					If Sec
						%RVar%_%Sec%_Lone_Line_Comments .= A_LoopField "`n"
					Else
						%RVar%_First_Comments .= A_LoopField "`n"
				}
			}
			Continue
		}
		Has_Equal := InStr(A_Loopfield, "=")
		If (!Has_Equal and InStr(A_LoopField, "[") and InStr(A_LoopField, "]")){
			Section_Skip := 0
			, Section_Append := 0
			, P_1 := InStr(A_LoopField, "[")
			, P_2 := Instr(A_LoopField, "]")
			, T_Section := Sec
			, T_Section_Name := TSec
			, TSec := SubStr(A_LoopField, P_1+1, P_2-P_1-1)
			, Sec := RIni_CalcMD5(TSec)
			
			If (T_Section)
				If (T_Section != Sec)
					If (!Read_Blank_Sections and !%RVar%_%T_Section%_Lone_Line_Comments and !%RVar%_%T_Section%_Comment and !%RVar%_All_%T_Section%_Keys)
						RIni_DeleteSection(RVar, T_Section_Name)
			
			If (RIni_%RVar%_%Sec%_Is_Set){
				If (Treat_Duplicate_Sections = 1)
					Section_Skip := 1
				Else If (Treat_Duplicate_Sections = 2){
					Section_Append := 1
					If InStr(A_LoopField, ";")
						If !Remove_Inline_Section_Comments
							%RVar%_%Sec%_Comment .= SubStr(A_Loopfield, P_2+1)
				} Else If (Treat_Duplicate_Sections = 3){
					If (E := RIni_DeleteSection(RVar, TSec))
						Return E
					RIni_AddSection(RVar, TSec)
					If InStr(A_LoopField, ";")
						If !Remove_Inline_Section_Comments
							%RVar%_%Sec%_Comment := SubStr(A_Loopfield, P_2+1)
				} Else If (Treat_Duplicate_Sections = 4)
					Section_Append := 2
				
				Continue
			} Else {
				If InStr(A_LoopField, ";")
					If !Remove_Inline_Section_Comments
						%RVar%_%Sec%_Comment := SubStr(A_Loopfield, P_2+1)
				
				RIni_AddSection(RVar, TSec)
			}
			Continue
		}
		If Has_Equal
		{
			If (!Sec)
			{
				If (RIni_%RVar%_Fix_Errors)
				{
					Errored_Lines .= (Errored_Lines = "" ? "" : ",") A_Index
					
					Continue
				}
				VarSetCapacity(RIni_%RVar%_Fix_Errors, 0)
				, VarSetCapacity(RIni_Unicode_Modifier, 0)
				, VarSetCapacity(RIni_%RVar%_Is_Set, 0)
				
				Return -1
			}
			If Section_Skip
				Continue
			TKey := SubStr(A_LoopField, 1, Has_Equal-1)
			, Key := RIni_CalcMD5(TKey)
			
			If (InStr("`n" %RVar%_All_%Sec%_Keys, "`n" Key "`n"))
			{
				If (Section_Append = 2)
					Continue
				Else If (Section_Append = 1){
					C_Pos := InStr(A_LoopField, ";")
					If (C_Pos){
						If !Remove_Inline_Key_Comments
							%RVar%_%Sec%_%Key%_Comment .= SubStr(A_LoopField, C_Pos)
						%RVar%_%Sec%_%Key%_Value .= SubStr(A_LoopField, Has_Equal+1, C_Pos-Has_Equal-1)
					} Else
						%RVar%_%Sec%_%Key%_Value .= SubStr(A_Loopfield, Has_Equal+1)
				} Else If (Treat_Duplicate_Keys = 1)
					Continue
				Else If (Treat_Duplicate_Keys = 2){
					C_Pos := InStr(A_LoopField, ";")
					If (C_Pos){
						If !Remove_Inline_Key_Comments
							%RVar%_%Sec%_%Key%_Comment .= SubStr(A_LoopField, C_Pos)
						%RVar%_%Sec%_%Key%_Value .= SubStr(A_LoopField, Has_Equal+1, C_Pos-Has_Equal-1)
					} Else
						%RVar%_%Sec%_%Key%_Value .= SubStr(A_Loopfield, Has_Equal+1)
				} Else If (Treat_Duplicate_Keys = 3){
					RIni_DeleteKey(RVar, TSec, TKey)
					, %RVar%_All_%Sec%_Keys .= Key "`n"
					, C_Pos := InStr(A_LoopField, ";")
					If (C_Pos){
						If !Remove_Inline_Key_Comments
							%RVar%_%Sec%_%Key%_Comment := SubStr(A_LoopField, C_Pos)
						%RVar%_%Sec%_%Key%_Value := SubStr(A_LoopField, Has_Equal+1, C_Pos-Has_Equal-1)
					} Else
						%RVar%_%Sec%_%Key%_Value := SubStr(A_Loopfield, Has_Equal+1)
					
					%RVar%_%Sec%_%Key%_Name := TKey
				}
				If (Trim_Spaces_From_Values)
					T_Value := %RVar%_%Sec%_%Key%_Value
					, %RVar%_%Sec%_%Key%_Value = %T_Value%
			} Else {
				C_Pos := InStr(A_LoopField, ";")
				If (C_Pos){
					If !Remove_Inline_Key_Comments
						%RVar%_%Sec%_%Key%_Comment := SubStr(A_LoopField, C_Pos)
					%RVar%_%Sec%_%Key%_Value := SubStr(A_LoopField, Has_Equal+1, C_Pos-Has_Equal-1)
				} Else {
					%RVar%_%Sec%_%Key%_Value := SubStr(A_Loopfield, Has_Equal+1)
					If (!Read_Blank_Keys and %RVar%_%Sec%_%Key%_Value != "")
						Continue
				}
				If (Trim_Spaces_From_Values)
					T_Value := %RVar%_%Sec%_%Key%_Value
					, %RVar%_%Sec%_%Key%_Value = %T_Value%
				
				%RVar%_All_%Sec%_Keys .= Key "`n"
				, %RVar%_%Sec%_%Key%_Name := TKey
			}
			Continue
		}
		If (RIni_%RVar%_Fix_Errors)
			Errored_Lines .= (Errored_Lines = "" ? "" : ",") A_Index
	}
	VarSetCapacity(RIni_Read_Var, 0)
	If Errored_Lines
		Return Errored_Lines
}


RIni_Write(RVar, File, Newline="`r`n", Write_Blank_Sections=1, Write_Blank_Keys=1, Space_Sections=1, Space_Keys=0, Remove_Valuewlines=1, Overwrite_If_Exists=1, Addwline_At_End=0)
{
	Global
	Local Write_Ini, Sec, Length, Temp_Write_Ini, T_Time, T_Section, T_Key, T_Value, T_Size, E, T_Write_Section
	
	If !RIni_%RVar%_Is_Set
		Return -10
	If (Newline != "`n" and Newline != "`r" and Newline != "`r`n" and Newline != "`n`r")
		Return -4
	
	T_Size := RIni_GetTotalSize(RVar, Newline)
	If (T_Size < 0)
		Return T_Size
	If Space_Sections
		T_Size += 1*1024*1024
	If Space_Keys
		T_Size += 1*1024*1024
	VarSetCapacity(Write_Ini, T_Size)
	If (%RVar%_First_Comments){
		Loop, parse, %RVar%_First_Comments, `n, `r
		{
			If A_LoopField =
				Continue
			Write_Ini .= A_LoopField Newline
		}
	}
	
	Loop, % RIni_%RVar%_Section_Number
	{
		If (RIni_%RVar%_%A_Index% != ""){
			If (T_Write_Section != ""){
				If Space_Sections
					Write_Ini .= Newline
			}
			T_Write_Section := RIni_%RVar%_%A_Index%
			T_Section := RIni_CalcMD5(T_Write_Section)
			
			If %RVar%_%T_Section%_Comment
				Write_Ini .= "[" T_Write_Section "]" %RVar%_%T_Section%_Comment Newline
			Else {
				If (!Write_Blank_Sections and !%RVar%_All_%T_Section%_Keys and !%RVar%_%T_Section%_Lone_Line_Comments)
					Continue
				Write_Ini .= "[" T_Write_Section "]" Newline
			}
			If (%RVar%_All_%T_Section%_Keys){
				Loop, Parse, %RVar%_All_%T_Section%_Keys, `n
				{
					If A_LoopField = 
						Continue
					If (T_Key){
						If Space_Keys
							Write_Ini .= Newline
					}
					T_Key := %RVar%_%T_Section%_%A_LoopField%_Name
					T_Value := %RVar%_%T_Section%_%A_LoopField%_Value
					If (Remove_Valuewlines){
						If InStr(T_Value, "`n")
							StringReplace, T_Value, T_Value, `n, ,A
						If InStr(T_Value, "`r")
							StringReplace, T_Value, T_Value, `r, ,A
					}
					If %RVar%_%T_Section%_%A_LoopField%_Comment
						Write_Ini .= T_Key "=" T_Value %RVar%_%T_Section%_%A_LoopField%_Comment Newline
					Else {
						If (!Write_Blank_Keys and T_Value = "")
							Continue
						Write_Ini .= T_Key "=" T_Value Newline
					}
				}
			}
			If (%RVar%_%T_Section%_Lone_Line_Comments){
				Loop, parse, %RVar%_%T_Section%_Lone_Line_Comments, `n, `r
				{
					If A_LoopField =
						Continue
					Write_Ini .= A_LoopField Newline
				}
			}
		}
	}
	If (!Addwline_At_End and StrLen(Write_Ini) < (63 * 1024 * 1024))
		Write_Ini := SubStr(Write_Ini, 1, StrLen(Write_Ini)-StrLen(Newline))
	IfExist, %File%
	{
		If !Overwrite_If_Exists
			Return -15
		T_Time := A_Now
		If A_IsUnicode
			FileAppend, %Write_Ini%, %A_Temp%\%T_Time%.ini, UTF-8
		Else
			FileAppend, %Write_Ini%, %A_Temp%\%T_Time%.ini
		If ErrorLevel
			Return -12
		FileDelete, %File%
		If ErrorLevel
			Return -13
		FileMove, %A_Temp%\%T_Time%.ini, %File%
		If ErrorLevel
			Return -14
	} Else {
		If A_IsUnicode
			FileAppend, %Write_Ini%, %File%, UTF-8
		Else
			FileAppend, %Write_Ini%, %File%
		If ErrorLevel
			Return -12
	}
	Write_Ini := ""
}


RIni_AddSection(RVar, Sec)
{
	Global
	Local T_Section_Number, TSec
	
	If !RIni_%RVar%_Is_Set
		Return -10
	
	TSec := RIni_CalcMD5(Sec)		
	If RIni_%RVar%_%TSec%_Is_Set
		Return -5
	RIni_%RVar%_%TSec%_Is_Set := 1
	T_Section_Number := RIni_%RVar%_Section_Number
	RIni_%RVar%_%TSec%_Number := T_Section_Number
	RIni_%RVar%_%T_Section_Number% := Sec
	RIni_%RVar%_Section_Number ++
}


RIni_AddKey(RVar, Sec, Key)
{
	Global
	Local E, TKey, TSec
	
	If !RIni_%RVar%_Is_Set
		Return -10
	TSec := Sec
	Sec := RIni_CalcMD5(TSec)
	If (!RIni_%RVar%_%Sec%_Is_Set){
		If !RIni_%RVar%_Fix_Errors
			Return -2
		RIni_AddSection(RVar, TSec)
	}
	TKey := Key
	Key := RIni_CalcMD5(TKey)
	If (InStr("`n" %RVar%_All_%Sec%_Keys, "`n" Key "`n"))
		Return -6
	%RVar%_All_%Sec%_Keys .= Key "`n"
	%RVar%_%Sec%_%Key%_Name := TKey
}


RIni_AppendValue(RVar, Sec, Key, Value, Trim_Spaces_From_Value=0, Removewlines=1)
{
	Global
	Static TSec, TKey, MD5Sec, MD5Key
	Local E
	
	If !RIni_%RVar%_Is_Set
		Return -10
	If (TSec != Sec)
		TSec := Sec
		, MD5Sec := RIni_CalcMD5(TSec)
	If (!RIni_%RVar%_%MD5Sec%_Is_Set){
		If !RIni_%RVar%_Fix_Errors
			Return -2
		RIni_AddSection(RVar, TSec)
	}
	If (TKey != Key)
		TKey := Key
		, MD5Key := RIni_CalcMD5(TKey)
	If (!InStr("`n" %RVar%_All_%MD5Sec%_Keys, "`n" MD5Key "`n")){
		If !RIni_%RVar%_Fix_Errors
			Return -3
		%RVar%_All_%MD5Sec%_Keys .= MD5Key "`n"
		%RVar%_%MD5Sec%_%MD5Key%_Name := TKey
	}
	If (Removewlines){
		If InStr(Value, "`n")
			StringReplace, Value, Value, `n, ,A
		If InStr(Value, "`r")
			StringReplace, Value, Value, `r, ,A
	}
	If Trim_Spaces_From_Value
		Value = %Value%
	%RVar%_%MD5Sec%_%MD5Key%_Value .= Value
}


RIni_ExpandSectionKeys(RVar, Sec, Amount=1)
{
	Global
	Local Temp_All_Section_Keys, Length, E, TSec
	
	If !RIni_%RVar%_Is_Set
		Return -10
	TSec := Sec
	Sec := RIni_CalcMD5(TSec)
	
	If (!RIni_%RVar%_%Sec%_Is_Set){
		If !RIni_%RVar%_Fix_Errors
			Return -2
		RIni_AddSection(RVar, TSec)
	}
	Length := StrLen(%RVar%_All_%Sec%_Keys)
	VarSetCapacity(Temp_All_Section_Keys, RIni_Unicode_Modifier*Length)
	Temp_All_Section_Keys .= %RVar%_All_%Sec%_Keys
	VarSetCapacity(%RVar%_All_%Sec%_Keys, Round(RIni_Unicode_Modifier*(Length+Amount*(1*1024*1024))))
	%RVar%_All_%Sec%_Keys .= Temp_All_Section_Keys
}


RIni_ContractSectionKeys(RVar, Sec)
{
	Global
	Local Temp_All_Section_Keys, Length
	
	Sec := RIni_CalcMD5(Sec)
	Length := StrLen(%RVar%_All_%Sec%_Keys)
	VarSetCapacity(Temp_All_Section_Keys, RIni_Unicode_Modifier*Length)
	Temp_All_Section_Keys .= %RVar%_All_%Sec%_Keys
	VarSetCapacity(%RVar%_All_%Sec%_Keys, 0)
	VarSetCapacity(%RVar%_All_%Sec%_Keys, RIni_Unicode_Modifier*Length)
	%RVar%_All_%Sec%_Keys .= Temp_All_Section_Keys
}


RIni_ExpandKeyValue(RVar, Sec, Key, Amount=1)
{
	Global
	Local Temp_Key_value, Length, E, TSec, TKey
	
	If !RIni_%RVar%_Is_Set
		Return -10
	TSec := Sec
	Sec := RIni_CalcMD5(TSec)
	
	If (!RIni_%RVar%_%Sec%_Is_Set){
		If !RIni_%RVar%_Fix_Errors
			Return -2
		RIni_AddSection(RVar, Sec)
	}
	TKey := Key
	Key := RIni_CalcMD5(TKey)
	
	If (!InStr("`n" %RVar%_All_%Sec%_Keys, "`n" Key "`n")){
		If !RIni_%RVar%_Fix_Errors
			Return -3
		%RVar%_All_%Sec%_Keys .= Key "`n"
		%RVar%_%Sec%_%Key%_Name := TKey
	}
	If (%RVar%_%Sec%_%Key%_Value = "")
		VarSetCapacity(%RVar%_%Sec%_%Key%_Value, Round(RIni_Unicode_Modifier*Amount*(1*1024*1024)))
	Else {
		Length := StrLen(%RVar%_%Sec%_%Key%_Value)
		VarSetCapacity(Temp_Key_value, RIni_Unicode_Modifier*Length)
		Temp_Key_value .= %RVar%_%Sec%_%Key%_Value
		varSetCapacity(%RVar%_%Sec%_%Key%_Value, Round(RIni_Unicode_Modifier*(Length+Amount*(1*1024*1024))))
		%RVar%_%Sec%_%Key%_Value .= Temp_Key_value
	}
}


RIni_ContractKeyValue(RVar, Sec, Key)
{
	Global
	Local Temp_Key_value, Length, TSec, TKey
	
	TSec := Sec
	Sec := RIni_CalcMD5(TSec)
	
	TKey := Key
	Key := RIni_CalcMD5(TKey)
	
	If (%RVar%_%Sec%_%Key%_Value = "")
		VarSetCapacity(%RVar%_%Sec%_%Key%_Value, 0)
	Else {
		Length := StrLen(%RVar%_%Sec%_%Key%_Value)
		VarSetCapacity(Temp_Key_value, RIni_Unicode_Modifier*Length)
		Temp_Key_value .= %RVar%_%Sec%_%Key%_Value
		VarSetCapacity(%RVar%_%Sec%_%Key%_Value, 0)
		varSetCapacity(%RVar%_%Sec%_%Key%_Value, RIni_Unicode_Modifier*Length)
		%RVar%_%Sec%_%Key%_Value .= Temp_Key_value
	}
}


RIni_SetKeyValue(RVar, Sec, Key, Value, Trim_Spaces_From_Value=0, Removewlines=1)
{
	Global
	Local E, TSec, TKey
	
	If !RIni_%RVar%_Is_Set
		Return -10
	TSec := Sec
	Sec := RIni_CalcMD5(TSec)
	
	If (!RIni_%RVar%_%Sec%_Is_Set){
		If !RIni_%RVar%_Fix_Errors
			Return -2
		RIni_AddSection(RVar, TSec)
	}
	TKey := Key
	Key := RIni_CalcMD5(TKey)
	
	If (!InStr("`n" %RVar%_All_%Sec%_Keys, "`n" Key "`n")){
		If !RIni_%RVar%_Fix_Errors
			Return -3
		%RVar%_All_%Sec%_Keys .= Key "`n"
		%RVar%_%Sec%_%Key%_Name := TKey
	}
	If (Removewlines){
		If InStr(Value, "`n")
			StringReplace, Value, Value, `n, ,A
		If InStr(Value, "`r")
			StringReplace, Value, Value, `r, ,A
	}
	If Trim_Spaces_From_Value
		Value = %Value%
	%RVar%_%Sec%_%Key%_Value := Value
}


RIni_DeleteSection(RVar, Sec)
{
	Global
	Local Position, T_Section_Number
	
	If !RIni_%RVar%_Is_Set
		Return -10
	Sec := RIni_CalcMD5(Sec)
	
	If (RIni_%RVar%_%Sec%_Is_Set){
		T_Section_Number := RIni_%RVar%_%Sec%_Number
		VarSetCapacity(RIni_%RVar%_%T_Section_Number%, 0)
		VarSetCapacity(RIni_%RVar%_%Sec%_Is_Set, 0)
		VarSetCapacity(RIni_%RVar%_%Sec%_Number, 0)
		If (%RVar%_All_%Sec%_Keys){
			Loop, Parse, %RVar%_All_%Sec%_Keys, `n
			{
				If A_LoopField =
					Continue
				VarSetCapacity(%RVar%_%Sec%_%A_LoopField%_Name, 0)
				If (%RVar%_%Sec%_%A_LoopField%_Value != "")
					VarSetCapacity(%RVar%_%Sec%_%A_LoopField%_Value, 0)
				If %RVar%_%Sec%_%A_LoopField%_Comment
					VarSetCapacity(%RVar%_%Sec%_%A_LoopField%_Comment, 0)
			}
			VarSetCapacity(%RVar%_All_%Sec%_Keys, 0)
		}
		If %RVar%_%Sec%_Comment
			VarSetCapacity(%RVar%_%Sec%_Comment, 0)
		If %RVar%_%Sec%_Lone_Line_Comments
			VarSetCapacity(%RVar%_%Sec%_Lone_Line_Comments, 0)
	} Else
		Return -2
}


RIni_DeleteKey(RVar, Sec, Key)
{
	Global
	Local Position, TSec, TKey
	
	If !RIni_%RVar%_Is_Set
		Return -10
	TSec := Sec
	Sec := RIni_CalcMD5(TSec)
	
	If !RIni_%RVar%_%Sec%_Is_Set
		Return -2
	TKey := Key
	Key := RIni_CalcMD5(TKey)
	
	If (%RVar%_All_%Sec%_Keys){
		If (Key = SubStr(%RVar%_All_%Sec%_Keys, 1, Instr(%RVar%_All_%Sec%_Keys, "`n")-1)){
			%RVar%_All_%Sec%_Keys := SubStr(%RVar%_All_%Sec%_Keys, InStr(%RVar%_All_%Sec%_Keys, "`n")+1)
		} Else {
			Position := InStr(%RVar%_All_%Sec%_Keys, "`n" Key "`n")
			If !Position
				Return -3
			%RVar%_All_%Sec%_Keys := SubStr(%RVar%_All_%Sec%_Keys, 1, Position) SubStr(%RVar%_All_%Sec%_Keys, Position+2+StrLen(Key))
			If Errorlevel
				Return -3
		}
		VarSetCapacity(%RVar%_%Sec%_%Key%_Name, 0)
		If (%RVar%_%Sec%_%Key%_Value != "")
			VarSetCapacity(%RVar%_%Sec%_%Key%_Value, 0)
		If %RVar%_%Sec%_%Key%_Comment
			VarSetCapacity(%RVar%_%Sec%_%Key%_Comment, 0)
	} Else
		Return -3
}



RIni_GetSections(RVar, Delimiter=",")
{
	Global
	Local T_Sections
	
	If !RIni_%RVar%_Is_Set
		Return -10
	Loop, % RIni_%RVar%_Section_Number
	{
		If (RIni_%RVar%_%A_Index%){
			If T_Sections
				T_Sections .= Delimiter RIni_%RVar%_%A_Index%
			Else
				T_Sections := RIni_%RVar%_%A_Index%
		}
	}
	Return T_Sections
}


RIni_GetSectionKeys(RVar, Sec, Delimiter=",")
{
	Global
	Local T_Section_Keys
	
	If !RIni_%RVar%_Is_Set
		Return -10
	Sec := RIni_CalcMD5(Sec)
	
	If !RIni_%RVar%_%Sec%_Is_Set
		Return -2
	If (%RVar%_All_%Sec%_Keys){
		Loop, Parse, %RVar%_All_%Sec%_Keys, `n
		{
			If A_LoopField =
				Continue
			T_Section_Keys .= (A_Index = 1 ? "" : Delimiter) %RVar%_%Sec%_%A_LoopField%_Name
		}
		
		Return T_Section_Keys
	}
}


RIni_GetKeyValue(RVar, Sec, Key, Default_Return="")
{
	Global
	
	If (!RIni_%RVar%_Is_Set)
		Return Default_Return = "" ? -10 : Default_Return
	Sec := RIni_CalcMD5(Sec)
	
	If !RIni_%RVar%_%Sec%_Is_Set
		Return Default_Return = "" ? -2 : Default_Return
	Key := RIni_CalcMD5(Key)
	
	If (%RVar%_All_%Sec%_Keys){
		If (!InStr("`n" %RVar%_All_%Sec%_Keys, "`n" Key "`n"))
			Return Default_Return = "" ? -3 : Default_Return
		If (%RVar%_%Sec%_%Key%_Value != "")
			Return %RVar%_%Sec%_%Key%_Value
		Else
			Return Default_Return
	} Else
		Return Default_Return = "" ? -3 : Default_Return
}


RIni_CopyKeys(From_RVar, To_RVar, From_Section, To_Section, Treat_Duplicate_Keys=2, Copy_Key_Values=1, Copy_Key_Comments=1, Copy_Blank_Keys=1)
{
	;Treat_Duplicate_? = 1 : Skip
	;Treat_Duplicate_? = 2 : Append
	;Treat_Duplicate_? = 3 : Replace
	Global
	Local E, TTo_Section
	
	If (From_RVar = "" Or !RIni_%From_RVar%_Is_Set)
		Return -10
	
	If (To_RVar = "")
		Return -10
	If (!RIni_%To_RVar%_Is_Set){
		If !RIni_%From_RVar%_Fix_Errors
			Return -10
		RIni_Create(To_RVar)
	}
	If (Treat_Duplicate_Keys != 1 and Treat_Duplicate_Keys != 2 and Treat_Duplicate_Keys != 3)
		Return -4
	From_Section := RIni_CalcMD5(From_Section)
	
	TTo_Section := To_Section
	To_Section := RIni_CalcMD5(TTo_Section)
	
	If !RIni_%From_RVar%_%From_Section%_Is_Set
		Return -2
	
	If (!RIni_%To_RVar%_%To_Section%_Is_Set){
		If !RIni_%To_RVar%_Fix_Errors
			Return -2
		RIni_AddSection(To_RVar, TTo_Section)
	}
	
	If (%From_RVar%_All_%From_Section%_Keys){
		Loop, Parse, %From_RVar%_All_%From_Section%_Keys, `n
		{
			If A_Loopfield = 
				Continue
			If (!Copy_Blank_Keys and %From_RVar%_%From_Section%_%A_Loopfield%_Value != 0 and !%From_RVar%_%From_Section%_%A_Loopfield%_Value and !%From_RVar%_%From_Section%_%A_Loopfield%_Comment) 
				Continue
			If (!InStr("`n" %To_RVar%_All_%To_Section%_Keys, "`n" A_LoopField "`n")){
				%To_RVar%_All_%To_Section%_Keys .= A_LoopField "`n"
				%To_RVar%_%To_Section%_%A_LoopField%_Name := %From_RVar%_%From_Section%_%A_LoopField%_Name
				If (%From_RVar%_%From_Section%_%A_Loopfield%_Value != "" and Copy_Key_Values)
					%To_RVar%_%To_Section%_%A_Loopfield%_Value := %From_RVar%_%From_Section%_%A_Loopfield%_Value
				If (%From_RVar%_%From_Section%_%A_Loopfield%_Comment and Copy_Key_Comments)
					%To_RVar%_%To_Section%_%A_Loopfield%_Comment := %From_RVar%_%From_Section%_%A_Loopfield%_Comment
			} Else {
				If (Treat_Duplicate_Keys = 1)
					Continue
				If (Treat_Duplicate_Keys = 2){
					If (%From_RVar%_%From_Section%_%A_Loopfield%_Value != "" and Copy_Key_Values)
						%To_RVar%_%To_Section%_%A_Loopfield%_Value .= %From_RVar%_%From_Section%_%A_Loopfield%_Value
					If (%From_RVar%_%From_Section%_%A_Loopfield%_Comment and Copy_Key_Comments)
						%To_RVar%_%To_Section%_%A_Loopfield%_Comment .= %From_RVar%_%From_Section%_%A_Loopfield%_Comment
				}
				If (Treat_Duplicate_Keys = 3){
					If (%From_RVar%_%From_Section%_%A_Loopfield%_Value != "" and Copy_Key_Values)
						%To_RVar%_%To_Section%_%A_Loopfield%_Value := %From_RVar%_%From_Section%_%A_Loopfield%_Value
					If (%From_RVar%_%From_Section%_%A_Loopfield%_Comment and Copy_Key_Comments)
						%To_RVar%_%To_Section%_%A_Loopfield%_Comment := %From_RVar%_%From_Section%_%A_Loopfield%_Comment
				}
			}
		}
	}
}


RIni_Merge(From_RVar, To_RVar, Treat_Duplicate_Sections=1, Treat_Duplicate_Keys=2, Merge_Blank_Sections=1, Merge_Blank_Keys=1)
{
	;Treat_Duplicate_? = 1 : Skip
	;Treat_Duplicate_? = 2 : Append
	;Treat_Duplicate_? = 3 : Replace
	Global
	Local From_Section, E, T_Section_Number, TFrom_Section
	
	If (From_RVar = "" Or !RIni_%From_RVar%_Is_Set)
		Return -10
	
	If (To_RVar = "")
		Return -10
	If (!RIni_%To_RVar%_Is_Set){
		If !RIni_%From_RVar%_Fix_Errors
			Return -10
		RIni_Create(To_RVar)
	}
	If (Treat_Duplicate_Sections != 1 and Treat_Duplicate_Sections != 2 and Treat_Duplicate_Sections != 3)
		Return -4
	If (Treat_Duplicate_Keys != 1 and Treat_Duplicate_Keys != 2 and Treat_Duplicate_Keys != 3)
		Return -4
	If %From_RVar%_First_Comments
		%To_RVar%_First_Comments .= %From_RVar%_First_Comments

	Loop, % RIni_%From_RVar%_Section_Number
	{
		If (RIni_%From_RVar%_%A_Index% != ""){
			TFrom_Section := RIni_%From_RVar%_%A_Index%
			From_Section := RIni_CalcMD5(TFrom_Section)
			
			If (!Merge_Blank_Sections and !%From_RVar%_%From_Section%_Lone_Line_Comments and !%From_RVar%_%From_Section%_Comment and !%From_RVar%_All_%From_Section%_Keys)
				Continue
			If (!RIni_%To_RVar%_%From_Section%_Is_Set){
				RIni_AddSection(To_RVar, TFrom_Section)
				
				If %From_RVar%_%From_Section%_Comment
					%To_RVar%_%From_Section%_Comment := %From_RVar%_%From_Section%_Comment
					If %From_RVar%_%From_Section%_Lone_Line_Comments
						%To_RVar%_%From_Section%_Lone_Line_Comments := %From_RVar%_%From_Section%_Lone_Line_Comments
				If (%From_RVar%_All_%From_Section%_Keys){
					Loop, Parse, %From_RVar%_All_%From_Section%_Keys, `n
					{
						If A_Loopfield = 
							Continue
						
						If (!Merge_Blank_Keys and %From_RVar%_%From_Section%_%A_Loopfield%_Value = "" !%From_RVar%_%From_Section%_%A_LoopField%_Comment)
							Continue
						If (!InStr("`n" %To_RVar%_All_%From_Section%_Keys, "`n" A_LoopField "`n")){
							%To_RVar%_All_%From_Section%_Keys .= A_LoopField "`n"
							%To_RVar%_%From_Section%_%A_LoopField%_Name := %From_RVar%_%From_Section%_%A_Loopfield%_Name
							If (%From_RVar%_%From_Section%_%A_Loopfield%_Value != "")
								%To_RVar%_%From_Section%_%A_Loopfield%_Value := %From_RVar%_%From_Section%_%A_Loopfield%_Value
							If %From_RVar%_%From_Section%_%A_LoopField%_Comment
								%To_RVar%_%From_Section%_%A_LoopField%_Comment := %From_RVar%_%From_Section%_%A_LoopField%_Comment
						} Else {
							If (Treat_Duplicate_Keys = 1)
								Continue
							If (Treat_Duplicate_Keys = 2){
								If (%From_RVar%_%From_Section%_%A_Loopfield%_Value != "")
									%To_RVar%_%From_Section%_%A_Loopfield%_Value .= %From_RVar%_%From_Section%_%A_Loopfield%_Value
								If %From_RVar%_%From_Section%_%A_LoopField%_Comment
									%To_RVar%_%From_Section%_%A_LoopField%_Comment .= %From_RVar%_%From_Section%_%A_LoopField%_Comment
							}
							If (Treat_Duplicate_Keys = 3){
								If (%From_RVar%_%From_Section%_%A_Loopfield%_Value != "")
									%To_RVar%_%From_Section%_%A_Loopfield%_Value := %From_RVar%_%From_Section%_%A_Loopfield%_Value
								If %From_RVar%_%From_Section%_%A_LoopField%_Comment
									%To_RVar%_%From_Section%_%A_LoopField%_Comment := %From_RVar%_%From_Section%_%A_LoopField%_Comment
							}
						}
					}
				}
			} Else {
				If (Treat_Duplicate_Sections = 1)
						Continue
				If (Treat_Duplicate_Sections = 2){
					If %From_RVar%_%From_Section%_Comment
						%To_RVar%_%From_Section%_Comment .= %From_RVar%_%From_Section%_Comment
					If %From_RVar%_%From_Section%_Lone_Line_Comments
						%To_RVar%_%From_Section%_Lone_Line_Comments .= %From_RVar%_%From_Section%_Lone_Line_Comments
					If (%From_RVar%_All_%From_Section%_Keys){
						Loop, Parse, %From_RVar%_All_%From_Section%_Keys, `n
						{
							If A_Loopfield = 
								Continue
							If (!Merge_Blank_Keys and %From_RVar%_%From_Section%_%A_Loopfield%_Value != 0 and !%From_RVar%_%From_Section%_%A_Loopfield%_Value and !%From_RVar%_%From_Section%_%A_LoopField%_Comment)
								Continue
							If (!InStr("`n" %To_RVar%_All_%From_Section%_Keys, "`n" A_LoopField "`n")){
								%To_RVar%_All_%From_Section%_Keys .= A_LoopField "`n"
								%To_RVar%_%From_Section%_%A_LoopField%_Name := %From_RVar%_%From_Section%_%A_Loopfield%_Name
								If (%From_RVar%_%From_Section%_%A_Loopfield%_Value != "")
									%To_RVar%_%From_Section%_%A_Loopfield%_Value := %From_RVar%_%From_Section%_%A_Loopfield%_Value
								If %From_RVar%_%From_Section%_%A_LoopField%_Comment
									%To_RVar%_%From_Section%_%A_LoopField%_Comment := %From_RVar%_%From_Section%_%A_LoopField%_Comment
							} Else {
								If (Treat_Duplicate_Keys = 1)
									Continue
								If (Treat_Duplicate_Keys = 2){
									If (%From_RVar%_%From_Section%_%A_Loopfield%_Value != "")
										%To_RVar%_%From_Section%_%A_Loopfield%_Value .= %From_RVar%_%From_Section%_%A_Loopfield%_Value
									If %From_RVar%_%From_Section%_%A_LoopField%_Comment
										%To_RVar%_%From_Section%_%A_LoopField%_Comment .= %From_RVar%_%From_Section%_%A_LoopField%_Comment
								}
								If (Treat_Duplicate_Keys = 3){
									If (%From_RVar%_%From_Section%_%A_Loopfield%_Value != "")
										%To_RVar%_%From_Section%_%A_Loopfield%_Value := %From_RVar%_%From_Section%_%A_Loopfield%_Value
									If %From_RVar%_%From_Section%_%A_LoopField%_Comment
										%To_RVar%_%From_Section%_%A_LoopField%_Comment := %From_RVar%_%From_Section%_%A_LoopField%_Comment
								}
							}
						}
					}
				}
				If (Treat_Duplicate_Sections = 3){
					If (E := RIni_DeleteSection(To_RVar, TFrom_Section))
						Return E
					RIni_AddSection(To_RVar, TFrom_Section)
					If %From_RVar%_%From_Section%_Comment
						%To_RVar%_%From_Section%_Comment := %From_RVar%_%From_Section%_Comment
					If %From_RVar%_%From_Section%_Lone_Line_Comments
						%To_RVar%_%From_Section%_Lone_Line_Comments := %From_RVar%_%From_Section%_Lone_Line_Comments
					If (%From_RVar%_All_%From_Section%_Keys){
						%To_RVar%_All_%From_Section%_Keys := %From_RVar%_All_%From_Section%_Keys
						Loop, Parse, %From_RVar%_All_%From_Section%_Keys, `n
						{
							If A_Loopfield = 
								Continue
							If (!Merge_Blank_Keys and %From_RVar%_%From_Section%_%A_Loopfield%_Value = "" !%From_RVar%_%From_Section%_%A_LoopField%_Comment)
								Continue
							%To_RVar%_%From_Section%_%A_LoopField%_Name := %From_RVar%_%From_Section%_%A_Loopfield%_Name
							If (%From_RVar%_%From_Section%_%A_Loopfield%_Value != "")
								%To_RVar%_%From_Section%_%A_Loopfield%_Value := %From_RVar%_%From_Section%_%A_Loopfield%_Value
							If %From_RVar%_%From_Section%_%A_LoopField%_Comment
								%To_RVar%_%From_Section%_%A_LoopField%_Comment := %From_RVar%_%From_Section%_%A_LoopField%_Comment
						}
					}
				}
			}
		}
	}
}


RIni_ToVariable(RVar, ByRef Variable, Newline="`r`n", Add_Blank_Sections=1, Add_Blank_Keys=1, Space_Sections=0, Space_Keys=0, Remove_Valuewlines=1)
{
	Global
	Local Sec, Length, Key, Value, T_Section, TKey, T_Value
	
	If (!RIni_%RVar%_Is_Set)
		Return -10
	
	If (Newline != "`n" and Newline != "`r" and Newline != "`r`n" and Newline != "`n`r")
		Return -4
	If (%RVar%_First_Comments){
		Loop, parse, %RVar%_First_Comments, `n, `r
		{
			If A_LoopField =
				Continue
			Variable .= A_LoopField Newline
		}
	}

	Loop, % RIni_%RVar%_Section_Number
	{
		If (RIni_%RVar%_%A_Index% != ""){
			If (Sec){
				If Space_Sections
					Variable .= Newline
			}
			
			T_Section := RIni_%RVar%_%A_Index%
			Sec := RIni_CalcMD5(T_Section)
			
			If (%RVar%_%Sec%_Comment)
				Variable .= "[" T_Section "]" %RVar%_%Sec%_Comment Newline
			Else {
				If (!Add_Blank_Sections And !%RVar%_All_%Sec%_Keys And !%RVar%_%Sec%_Lone_Line_Comments)
					Continue
				Variable .= "[" T_Section "]" Newline
			}
			
			Loop, Parse, %RVar%_All_%Sec%_Keys, `n
			{
				If A_LoopField = 
					Continue
				If (TKey){
					If Space_Keys
						Variable .= Newline
				}
				TKey := %RVar%_%Sec%_%A_LoopField%_Name
				
				T_Value := ""
				If (%RVar%_%Sec%_%A_LoopField%_Value != ""){
					T_Value := %RVar%_%Sec%_%A_LoopField%_Value
					If (Remove_Valuewlines){
						If InStr(T_Value, "`n")
							StringReplace, T_Value, T_Value, `n, ,A
						If InStr(T_Value, "`r")
							StringReplace, T_Value, T_Value, `r, ,A
					}
				}
				If %RVar%_%Sec%_%A_LoopField%_Comment
					Variable .= TKey "=" T_Value %RVar%_%Sec%_%A_LoopField%_Comment Newline
				Else {
					If (!Add_Blank_Keys and T_Value != "")
						Continue
					Variable .= TKey "=" T_Value Newline
				}
			}
			If (%RVar%_%Sec%_Lone_Line_Comments){
				Loop, parse, %RVar%_%Sec%_Lone_Line_Comments, `n, `r
				{
					If A_LoopField =
						Continue
					Variable .= A_LoopField Newline
				}
			}
		}
	}

	If StrLen(Variable) < (63 * 1024 * 1024)
		Variable := SubStr(Variable, 1, StrLen(Variable)-StrLen(Newline))
}


RIni_GetKeysValues(RVar, ByRef Values, Key, Delimiter=",", Default_Return="")
{
	Global
	Local T_Section
	
	If (!RIni_%RVar%_Is_Set)
		Return Default_Return = "" ? -10 : Default_Return
	Key := RIni_CalcMD5(Key)
	
	Loop, % RIni_%RVar%_Section_Number
	{
		If (RIni_%RVar%_%A_Index% != ""){
			T_Section := RIni_CalcMD5(RIni_%RVar%_%A_Index%)
			If (%RVar%_%T_Section%_%Key%_Value != "")
				Values .= (Values = "" ? "" : Delimiter) %RVar%_%T_Section%_%Key%_Value
		}
	}
	
	Return Values = "" ? Default_Return : Values
}


RIni_AppendTopComments(RVar, Comments)
{
	Global
	
	If (!RIni_%RVar%_Is_Set)
		Return -10
	If (InStr(Comments, "`n") or InStr(Comments, "`r")){
		Loop, parse, Comments, `n, `r
		{
			If A_LoopField =
				Continue
			%RVar%_First_Comments .= ";" A_LoopField "`n"
		}
	} Else
		%RVar%_First_Comments .= ";" Comments "`n"
}


RIni_SetTopComments(RVar, Comments)
{
	Global
	
	If (!RIni_%RVar%_Is_Set)
		Return -10
	If (InStr(Comments, "`n") or InStr(Comments, "`r")){
		%RVar%_First_Comments := ""
		Loop, parse, Comments, `n, `r
		{
			If A_LoopField =
				Continue
			%RVar%_First_Comments .= ";" A_LoopField "`n"
		}
	} Else
		%RVar%_First_Comments := ";" Comments "`n"
}


RIni_AppendSectionComment(RVar, Sec, Comment)
{
	Global
	Local TSec
	
	If (!RIni_%RVar%_Is_Set)
		Return -10
	TSec := Sec
	Sec := RIni_CalcMD5(TSec)
	
	If (!RIni_%RVar%_%Sec%_Is_Set){
		If !RIni_%RVar%_Fix_Errors
			Return -2
		RIni_AddSection(RVar, TSec)
	}
	If (InStr(Comment, "`n") or InStr(Comment, "`r")){
		Loop, parse, Comment, `n, `r
		{
			If A_LoopField =
				Continue
			If %RVar%_%Sec%_Comment
				%RVar%_%Sec%_Comment .= A_LoopField
			Else
				%RVar%_%Sec%_Comment .= ";" A_LoopField
		}
	} Else {
		If %RVar%_%Sec%_Comment
			%RVar%_%Sec%_Comment .= Comment
		Else
			%RVar%_%Sec%_Comment .= ";" Comment
	}
}


RIni_SetSectionComment(RVar, Sec, Comment)
{
	Global
	Local TSec
	
	If (!RIni_%RVar%_Is_Set)
		Return -10
	TSec := Sec
	Sec := RIni_CalcMD5(TSec)
	
	If (!RIni_%RVar%_%Sec%_Is_Set){
		If !RIni_%RVar%_Fix_Errors
			Return -2
		RIni_AddSection(RVar, TSec)
	}
	If (InStr(Comment, "`n") or InStr(Comment, "`r")){
		%RVar%_%Sec%_Comment := ""
		Loop, parse, Comment, `n, `r
		{
			If A_LoopField =
				Continue
			If %RVar%_%Sec%_Comment
				%RVar%_%Sec%_Comment .= A_LoopField
			Else
				%RVar%_%Sec%_Comment .= ";" A_LoopField
		}
	} Else
		%RVar%_%Sec%_Comment := ";" Comment
}


RIni_AppendSectionLLComments(RVar, Sec, Comments)
{
	Global
	Local TSec
	
	If (!RIni_%RVar%_Is_Set)
		Return -10
	TSec := Sec
	Sec := RIni_CalcMD5(TSec)
	
	If (!RIni_%RVar%_%Sec%_Is_Set){
		If !RIni_%RVar%_Fix_Errors
			Return -2
		RIni_AddSection(RVar, TSec)
	}
	If (InStr(Comments, "`n") or InStr(Comments, "`r")){
		Loop, parse, Comments, `n, `r
		{
			If A_LoopField =
				Continue
			If %RVar%_%Sec%_Lone_Line_Comments
				%RVar%_%Sec%_Lone_Line_Comments .= A_LoopField "`n"
			Else
				%RVar%_%Sec%_Lone_Line_Comments .= ";" A_LoopField "`n"
		}
	} Else {
		If %RVar%_%Sec%_Lone_Line_Comments
			%RVar%_%Sec%_Lone_Line_Comments .= Comments "`n"
		Else
			%RVar%_%Sec%_Lone_Line_Comments .= ";" Comments "`n"
	}
}


RIni_SetSectionLLComments(RVar, Sec, Comments)
{
	Global
	Local TSec
	
	If (!RIni_%RVar%_Is_Set)
		Return -10
	TSec := Sec
	Sec := RIni_CalcMD5(Sec)
	
	If (!RIni_%RVar%_%Sec%_Is_Set){
		If !RIni_%RVar%_Fix_Errors
			Return -2
		RIni_AddSection(RVar, TSec)
	}
	If (InStr(Comments, "`n") or InStr(Comments, "`r")){
		%RVar%_%Sec%_Lone_Line_Comments := ""
		Loop, parse, Comments, `n, `r
		{
			If A_LoopField =
				Continue
			If %RVar%_%Sec%_Lone_Line_Comments
				%RVar%_%Sec%_Lone_Line_Comments .= A_LoopField "`n"
			Else
				%RVar%_%Sec%_Lone_Line_Comments .= ";" A_LoopField "`n"
		}
	} Else
		%RVar%_%Sec%_Lone_Line_Comments := ";" Comments "`n"
}


RIni_AppendKeyComment(RVar, Sec, Key, Comment)
{
	Global
	Local TSec, TKey
	
	If (!RIni_%RVar%_Is_Set)
		Return -10
	TSec := Sec
	Sec := RIni_CalcMD5(Sec)
	
	If (!RIni_%RVar%_%Sec%_Is_Set){
		If !RIni_%RVar%_Fix_Errors
			Return -2
		RIni_AddSection(RVar, TSec)
	}
	TKey := Key
	Key := RIni_CalcMD5(TKey)
	
	If (!InStr("`n" %RVar%_All_%Sec%_Keys, "`n" Key "`n")){
		If !RIni_%RVar%_Fix_Errors
			Return -3
		%RVar%_All_%Sec%_Keys .= Key "`n"
		%RVar%_%Sec%_%Key%_Name := TKey
	}
	If (InStr(Comment, "`n") or InStr(Comment, "`r")){
		Loop, parse, Comment, `n, `r
		{
			If A_LoopField =
				Continue
			If %RVar%_%Sec%_%Key%_Comment
				%RVar%_%Sec%_%Key%_Comment .= A_LoopField
			Else
				%RVar%_%Sec%_%Key%_Comment .= ";" A_LoopField
		}
	} Else {
		If %RVar%_%Sec%_%Key%_Comment
			%RVar%_%Sec%_%Key%_Comment .= Comment
		Else
			%RVar%_%Sec%_%Key%_Comment .= ";" Comment
	}
}


RIni_SetKeyComment(RVar, Sec, Key, Comment)
{
	Global
	Local TSec, TKey
	If (!RIni_%RVar%_Is_Set)
		Return -10
	TSec := Sec
	Sec := RIni_CalcMD5(TSec)
	
	If (!RIni_%RVar%_%Sec%_Is_Set){
		If !RIni_%RVar%_Fix_Errors
			Return -2
		RIni_AddSection(RVar, TSec)
	}
	TKey := Key
	Key := RIni_CalcMD5(TKey)
	
	If (!InStr("`n" %RVar%_All_%Sec%_Keys, "`n" Key "`n")){
		If !RIni_%RVar%_Fix_Errors
			Return -3
		%RVar%_All_%Sec%_Keys .= Key "`n"
		%RVar%_%Sec%_%Key%_Name := TKey
	}
	If (InStr(Comment, "`n") or InStr(Comment, "`r")){
		%RVar%_%Sec%_%Key%_Comment := ""
		Loop, parse, Comment, `n, `r
		{
			If A_LoopField =
				Continue
			If %RVar%_%Sec%_%Key%_Comment
				%RVar%_%Sec%_%Key%_Comment .= A_LoopField
			Else
				%RVar%_%Sec%_%Key%_Comment .= ";" A_LoopField
		}
	} Else
		%RVar%_%Sec%_%Key%_Comment := ";" Comment
}


RIni_GetTopComments(RVar, Delimiter="`r`n", Default_Return="")
{
	Global
	Local To_Return
	
	If (!RIni_%RVar%_Is_Set)
		Return Default_Return = "" ? -10 : Default_Return
	If (%RVar%_First_Comments){
		Loop, parse, %RVar%_First_Comments, `n, `r
		{
			If A_Loopfield =
				Continue
			If To_Return
				To_Return .= Delimiter A_LoopField
			Else
				To_Return := A_LoopField
		}
		Return To_Return = "" ? Default_Return : To_Return
	}
}


RIni_GetSectionComment(RVar, Sec, Default_Return="")
{
	Global
	
	If (!RIni_%RVar%_Is_Set)
		Return Default_Return = "" ? -10 : Default_Return
	Sec := RIni_CalcMD5(Sec)
	
	If !RIni_%RVar%_%Sec%_Is_Set
		Return Default_Return = "" ? -2 : Default_Return
	If %RVar%_%Sec%_Comment
		Return %RVar%_%Sec%_Comment
	Else
		Return Default_Return
}


RIni_GetSectionLLComments(RVar, Sec, Delimiter="`r`n", Default_Return="")
{
	Global
	Local To_Return
	
	If (!RIni_%RVar%_Is_Set)
		Return Default_Return = "" ? -10 : Default_Return
	Sec := RIni_CalcMD5(Sec)
	
	If !RIni_%RVar%_%Sec%_Is_Set
		Return Default_Return = "" ? -2 : Default_Return
	If (%RVar%_%Sec%_Lone_Line_Comments){
		Loop, parse, %RVar%_%Sec%_Lone_Line_Comments, `n, `r
		{
			If A_Loopfield =
				Continue
			If To_Return
				To_Return .= Delimiter A_LoopField
			Else
				To_Return := A_LoopField
		}
		Return Default_Return = "" ? To_Return : Default_Return
	} Else
		Return Default_Return
}


RIni_GetKeyComment(RVar, Sec, Key, Default_Return="")
{
	Global
	
	If (!RIni_%RVar%_Is_Set)
		Return Default_Return = "" ? -10 : Default_Return
	Sec := RIni_CalcMD5(Sec)
	
	If !RIni_%RVar%_%Sec%_Is_Set
		Return Default_Return = "" ? -2 : Default_Return
	Key := RIni_CalcMD5(Key)
	
	If (%RVar%_All_%Sec%_Keys){
		If (!InStr("`n" %RVar%_All_%Sec%_Keys, "`n" Key "`n"))
			Return Default_Return = "" ? -3 : Default_Return
		If %RVar%_%Sec%_%Key%_Comment
			Return %RVar%_%Sec%_%Key%_Comment
		Else
			Return Default_Return
	} Else
		Return Default_Return = "" ? -3 : Default_Return
}


RIni_GetTotalSize(RVar, Newline="`r`n", Default_Return="")
{
	Global
	Local Total_Size = 0, Sec, T_Section, T_Key, Newline_Length
	
	If (!RIni_%RVar%_Is_Set)
		Return Default_Return = "" ? -10 : Default_Return
	Newline_Length := StrLen(Newline)
	If (%RVar%_First_Comments){
		Loop, parse, %RVar%_First_Comments, `n, `r
		{
			If A_LoopField =
				Continue
			Total_Size += StrLen(A_LoopField) + Newline_Length
		}
	}

	Loop, % RIni_%RVar%_Section_Number
	{
		If (RIni_%RVar%_%A_Index% != ""){
			T_Section := RIni_%RVar%_%A_Index%
			Sec := RIni_CalcMD5(T_Section)
			
			If %RVar%_%Sec%_Comment
				Total_Size += 2 + StrLen(T_Section) + StrLen(%RVar%_%Sec%_Comment) + Newline_Length
			Else
				Total_Size += 2 + StrLen(T_Section) + Newline_Length
			
			If (%RVar%_All_%Sec%_Keys){
				Loop, Parse, %RVar%_All_%Sec%_Keys, `n
				{
					If A_LoopField = 
						Continue	
					
					Total_Size += StrLen(%RVar%_%Sec%_%A_LoopField%_Name) + 1 + Newline_Length
					If (%RVar%_%Sec%_%A_LoopField%_Value != "")
						Total_Size += StrLen(%RVar%_%Sec%_%A_LoopField%_Value)
					If %RVar%_%Sec%_%A_LoopField%_Comment
						Total_Size += StrLen(%RVar%_%Sec%_%A_LoopField%_Comment)
				}
			}
			If (%RVar%_%A_LoopField%_Lone_Line_Comments){
				Loop, parse, %RVar%_%A_LoopField%_Lone_Line_Comments, `n, `r
				{
					If A_LoopField =
						Continue
					Total_Size += StrLen(A_LoopField) + Newline_Length
				}
			}
		}
	}

	If (Total_Size = "")
		Total_Size = 0
	Return RIni_Unicode_Modifier * Total_Size
}


RIni_GetSectionSize(RVar, Sec, Newline="`r`n", Default_Return="")
{
	Global
	Local Total_Size = 0, TSec, T_Key, Newline_Length
	
	If (!RIni_%RVar%_Is_Set)
		Return Default_Return = "" ? -10 : Default_Return
	Newline_Length := StrLen(Newline)
	TSec := Sec
	Sec := RIni_CalcMD5(Sec)
	
	If !RIni_%RVar%_%Sec%_Is_Set
		Return Default_Return = "" ? -2 : Default_Return
	
	If %RVar%_%Sec%_Comment
		Total_Size += 2 + StrLen(TSec) + StrLen(%RVar%_%Sec%_Comment) + Newline_Length
	Else
		Total_Size += 2 + StrLen(TSec) + Newline_Length
	If (%RVar%_All_%Sec%_Keys){
		Loop, Parse, %RVar%_All_%Sec%_Keys, `n
		{
			If A_LoopField =
				Continue
			
			Total_Size += StrLen(%RVar%_%Sec%_%A_LoopField%_Name) + 1 + Newline_Length
			If (%RVar%_%Sec%_%A_LoopField%_Value != "")
				Total_Size += StrLen(%RVar%_%Sec%_%A_LoopField%_Value)
			If %RVar%_%Sec%_%A_LoopField%_Comment
				Total_Size += StrLen(%RVar%_%Sec%_%A_LoopField%_Comment)
		}
	}
	If (%RVar%_%Sec%_Lone_Line_Comments){
		Loop, parse, %RVar%_%Sec%_Lone_Line_Comments, `n, `r
		{
			If A_LoopField =
				Continue
			Total_Size += StrLen(A_LoopField) + Newline_Length
		}
	}
	If (Total_Size = "")
		Total_Size = 0
	Return RIni_Unicode_Modifier * Total_Size
}


RIni_GetKeySize(RVar, Sec, Key, Newline="`r`n", Default_Return="")
{
	Global
	Local Total_Size, TKey, Newline_Length, TSec
	RVar = %RVar%
	If (!RIni_%RVar%_Is_Set)
		Return Default_Return = "" ? -10 : Default_Return
	Newline_Length := StrLen(Newline)
	TSec := Sec
	Sec := RIni_CalcMD5(Sec)
	
	If !RIni_%RVar%_%Sec%_Is_Set
		Return Default_Return = "" ? -2 : Default_Return
	
	If (%RVar%_All_%Sec%_Keys){
		TKey := Key
		Key := RIni_CalcMD5(TKey)
		
		If (!InStr("`n" %RVar%_All_%Sec%_Keys, "`n" Key "`n"))
			Return Default_Return = "" ? -3 : Default_Return
		
		Total_Size += StrLen(TKey) + 1 + Newline_Length
		If (%RVar%_%Sec%_%Key%_Value != "")
			Total_Size += StrLen(%RVar%_%Sec%_%Key%_Value)
		If %RVar%_%Sec%_%Key%_Comment
			Total_Size += StrLen(%RVar%_%Sec%_%Key%_Comment)
		Return RIni_Unicode_Modifier * Total_Size
	} Else
		Return Default_Return = "" ? -3 : Default_Return
}


RIni_VariableToRIni(RVar, ByRef Variable, Correct_Errors=1, Remove_Inline_Key_Comments=0, Remove_Lone_Line_Comments=0, Remove_Inline_Section_Comments=0, Treat_Duplicate_Sections=1, Treat_Duplicate_Keys=1, Read_Blank_Sections=1, Read_Blank_Keys=1, Trim_Spaces_From_Values=0)
{
	Return RIni_Read(RVar, File, Correct_Errors, Remove_Inline_Key_Comments, Remove_Lone_Line_Comments, Remove_Inline_Section_Comments, Treat_Duplicate_Sections, Treat_Duplicate_Keys, Read_Blank_Sections, Read_Blank_Keys, Trim_Spaces_From_Values, Variable)
}


RIni_CopySectionNames(From_RVar, To_RVar, Treat_Duplicate_Sections=1, CopySection_Comments=1, Copy_Blank_Sections=1)
{
	;Treat_Duplicate_Sections
	;1 - Skip
	;2 - Replace
	Global
	Local E, TSec, Sec
	
	If (From_RVar = "" Or !RIni_%From_RVar%_Is_Set)
		Return -10
	
	If (To_RVar = "")
		Return -10
	If (!RIni_%To_RVar%_Is_Set){
		If !RIni_%From_RVar%_Fix_Errors
			Return -10
		RIni_Create(To_RVar)
	}

	Loop, % RIni_%From_RVar%_Section_Number
	{
		If (RIni_%From_RVar%_%A_Index% != ""){
			TSec := RIni_%From_RVar%_%A_Index%
			Sec := RIni_CalcMD5(TSec)

			If (!Copy_Blank_Sections and !%From_RVar%_%Sec%_Lone_Line_Comments and !%From_RVar%_%Sec%_Comment and !%From_RVar%_All_%Sec%_Keys)
				Continue
			If (RIni_%To_RVar%_%Sec%_Is_Set){
				If (Treat_Duplicate_Sections = 1)
					Continue
				Else If (Treat_Duplicate_Sections = 2) {
					If (E := RIni_DeleteSection(To_RVar, TSec))
						Return E
					
					RIni_AddSection(To_RVar, TSec)
					If (CopySection_Comments){
						If %From_RVar%_%Sec%_Lone_Line_Comments
							%To_RVar%_%Sec%_Lone_Line_Comments := %From_RVar%_%Sec%_Lone_Line_Comments
						If %From_RVar%_%Sec%_Comment
							%To_RVar%_%Sec%_Comment := %From_RVar%_%Sec%_Comment
					}
				}
			} Else {
				RIni_AddSection(To_RVar, TSec)
				If (CopySection_Comments){
					If %From_RVar%_%Sec%_Lone_Line_Comments
						%To_RVar%_%Sec%_Lone_Line_Comments := %From_RVar%_%Sec%_Lone_Line_Comments
					If %From_RVar%_%Sec%_Comment
						%To_RVar%_%Sec%_Comment := %From_RVar%_%Sec%_Comment
				}
			}
		}
	}
}


RIni_CopySection(From_RVar, To_RVar, From_Section, To_Section, Copy_Lone_Line_Comments=1, CopySection_Comment=1, Copy_Key_Values=1, Copy_Key_Comments=1, Copy_Blank_Keys=1)
{
	;Treat_Duplicate_? = 1 : Skip
	;Treat_Duplicate_? = 2 : Append
	;Treat_Duplicate_? = 3 : Replace
	Global
	Local TSec, Sec, TFrom_Section, TTo_Section
	
	If (From_RVar = "" Or !RIni_%From_RVar%_Is_Set)
		Return -10
	
	If (To_RVar = "")
		Return -10
	If (!RIni_%To_RVar%_Is_Set){
		If !RIni_%From_RVar%_Fix_Errors
			Return -10
		RIni_Create(To_RVar)
	}
	TFrom_Section := From_Section
	From_Section := RIni_CalcMD5(TFrom_Section)
	
	TTo_Section := To_Section
	To_Section := RIni_CalcMD5(TTo_Section)
	
	If !RIni_%From_RVar%_%From_Section%_Is_Set
		Return -2
	
	If !RIni_%To_RVar%_%To_Section%_Is_Set
		RIni_AddSection(To_RVar, TTo_Section)
	Else
		Return -5
	
	If (Copy_Lone_Line_Comments and %From_RVar%_%From_Section%_Lone_Line_Comments)
		%From_RVar%_%To_Section%_Lone_Line_Comments := %From_RVar%_%From_Section%_Lone_Line_Comments
	If (CopySection_Comment and %From_RVar%_%From_Section%_Comment)
		%From_RVar%_%To_Section%_Comment := %From_RVar%_%From_Section%_Comment
	
	If (%From_RVar%_All_%From_Section%_Keys){
		Loop, Parse, %From_RVar%_All_%From_Section%_Keys, `n
		{
			If A_Loopfield = 
				Continue
			If (!Copy_Blank_Keys and %From_RVar%_%From_Section%_%A_Loopfield%_Value = "" and !%From_RVar%_%From_Section%_%A_Loopfield%_Comment) 
				Continue
			If (%From_RVar%_%From_Section%_%A_Loopfield%_Value != "" and Copy_Key_Values)
				%To_RVar%_%To_Section%_%A_Loopfield%_Value := %From_RVar%_%From_Section%_%A_Loopfield%_Value
			If (%From_RVar%_%From_Section%_%A_Loopfield%_Comment and Copy_Key_Comments)
				%To_RVar%_%To_Section%_%A_Loopfield%_Comment := %From_RVar%_%From_Section%_%A_Loopfield%_Comment
			%To_RVar%_All_%To_Section%_Keys .= A_Loopfield "`n"
			%To_RVar%_%To_Section%_%A_LoopField%_Name := %From_RVar%_%From_Section%_%A_LoopField%_Name
		}
	}
}


RIni_CloneKey(From_RVar, To_RVar, From_Section, To_Section, From_Key, To_Key)
{
	Global
	Local TTo_Section
	
	If (From_RVar = "" Or !RIni_%From_RVar%_Is_Set)
		Return -10
	
	If (To_RVar = "")
		Return -10
	If (!RIni_%To_RVar%_Is_Set){
		If !RIni_%From_RVar%_Fix_Errors
			Return -10
		RIni_Create(To_RVar)
	}
	From_Section := RIni_CalcMD5(From_Section)
	
	If !RIni_%From_RVar%_%From_Section%_Is_Set
		Return -2
	From_Key := RIni_CalcMD5(From_Key)
	
	If (!InStr("`n" %From_RVar%_All_%From_Section%_Keys, "`n" From_Key "`n"))
		Return -3
	
	TTo_Section := To_Section
	To_Section := RIni_CalcMD5(TTo_Section)
	
	If (!RIni_%To_RVar%_%To_Section%_Is_Set){
		If !RIni_%To_RVar%_Fix_Errors
			Return -2
		RIni_AddSection(To_RVar, TTo_Section)
	}
	
	To_Key := RIni_CalcMD5(To_Key)
	
	If (InStr("`n" %To_RVar%_All_%To_section%_Keys, "`n" To_Key "`n"))
		Return -6
	%To_RVar%_All_%To_section%_Keys .= To_Key "`n"
	%To_RVar%_%To_Section%_%To_Key%_Name := %From_RVar%_%From_Section%_%From_Key%_Name
	If (%From_RVar%_%From_Section%_%From_Key%_Value != ""){
		%To_RVar%_%To_Section%_%To_Key%_Value := %From_RVar%_%From_Section%_%From_Key%_Value
	}
	If (%From_RVar%_%From_Section%_%From_Key%_Comment){
		%To_RVar%_%To_Section%_%To_Key%_Comment := %From_RVar%_%From_Section%_%From_Key%_Comment
	}
}


RIni_RenameSection(RVar, From_Section, To_Section)
{
	Global
	Local E, TFrom_Section, TTo_Section
	
	If !RIni_%RVar%_Is_Set
		Return -10
	TFrom_Section := From_Section
	, From_Section := RIni_CalcMD5(TFrom_Section)
	
	If !RIni_%RVar%_%From_Section%_Is_Set
		Return -2
	
	TTo_Section := To_Section
	, To_Section := RIni_CalcMD5(TTo_Section)
	
	If RIni_%RVar%_%To_Section%_Is_Set
		Return -5
	RIni_AddSection(RVar, TTo_section)
	If %RVar%_%From_Section%_Comment
		%RVar%_%to_Section%_Comment := %RVar%_%From_Section%_Comment
	If %RVar%_%From_Section%_Lone_Line_Comments
		%RVar%_%to_Section%_Lone_Line_Comments := %RVar%_%From_Section%_Lone_Line_Comments
	If (%RVar%_All_%From_Section%_Keys){
		Loop, Parse, %RVar%_All_%From_Section%_Keys, `n
		{
			%RVar%_All_%To_section%_Keys .= A_LoopField "`n"
			%RVar%_%To_Section%_%A_LoopField%_Name := %RVar%_%From_Section%_%A_LoopField%_Name
			If (%RVar%_%From_Section%_%A_LoopField%_Value != "")
				%RVar%_%To_Section%_%A_LoopField%_Value := %RVar%_%From_Section%_%A_LoopField%_Value
			If %RVar%_%From_Section%_%A_LoopField%_Comment
				%RVar%_%To_Section%_%A_LoopField%_Comment := %RVar%_%From_Section%_%A_LoopField%_Comment
		}
	}
	If (E := RIni_DeleteSection(RVar, TFrom_Section))
		Return E
}


RIni_RenameKey(RVar, Sec, From_Key, To_Key)
{
	Global
	Local E, TSec, TFrom_Key
	
	If !RIni_%RVar%_Is_Set
		Return -10
	TSec := Sec
	, Sec := RIni_CalcMD5(TSec)
	
	If !RIni_%RVar%_%Sec%_Is_Set
		Return -2
	TFrom_Key := From_Key
	, From_Key := RIni_CalcMD5(TFrom_Key)
	
	If (!InStr("`n" %RVar%_All_%Sec%_Keys, "`n" From_Key "`n"))
		Return -3
	
	To_Key := RIni_CalcMD5(To_Key)
	
	If (InStr("`n" %RVar%_All_%Sec%_Keys, "`n" To_Key "`n"))
		Return -6
	%RVar%_All_%Sec%_Keys .= To_Key "`n"
	, %RVar%_%Sec%_%To_Key%_Name := %RVar%_%Sec%_%From_Key%_Name
	If (%RVar%_%Sec%_%From_Key%_Value != "")
		%RVar%_%Sec%_%To_Key%_Value := %RVar%_%Sec%_%From_Key%_Value
	If %RVar%_%Sec%_%From_Key%_Comment
		%RVar%_%Sec%_%To_Key%_Comment := %RVar%_%Sec%_%From_Key%_Comment
	If (E := RIni_DeleteKey(RVar, TSec, TFrom_Key))
		Return E
}


RIni_SortSections(RVar, Sort_Type="")
{
	Global
	Local T_Sections, T_Section_Number, Sec
	
	If !RIni_%RVar%_Is_Set
		Return -10
	VarSetCapacity(T_Sections, RIni_Unicode_Modifier*32*1024*1024)
	Loop, % RIni_%RVar%_Section_Number
	{
		If (RIni_%RVar%_%A_Index% != ""){
			T_Section_Number := RIni_%RVar%_%A_Index%
			, Sec := RIni_CalcMD5(RIni_%RVar%_%A_Index%)
			, T_Sections .= T_Section_Number "`n"
			, VarSetCapacity(RIni_%RVar%_%A_Index%, 0)
			, VarSetCapacity(RIni_%RVar%_%Sec%_Is_Set, 0)
			, VarSetCapacity(RIni_%RVar%_%Sec%_Number, 0)
		}
	}
	If (T_Sections){
		RIni_%RVar%_Section_Number := 1
		Sort, T_Sections, % Sort_Type
		Loop, Parse, T_Sections, `n
		{
			If A_LoopField =
				Continue
			Sec := RIni_CalcMD5(A_LoopField)
			, RIni_%RVar%_%Sec%_Is_Set := 1
			, T_Section_Number := RIni_%RVar%_Section_Number
			, RIni_%RVar%_%Sec%_Number := T_Section_Number
			, RIni_%RVar%_%T_Section_Number% := A_LoopField
			, RIni_%RVar%_Section_Number ++
		}
	}
}

RIni_SortKeys(RVar, Sec, Sort_Type="")
{
	Global
	
	If !RIni_%RVar%_Is_Set
		Return -10
	Sec := RIni_CalcMD5(Sec)
	
	If !%RVar%_All_%Sec%_Keys
		Return -2
	Sort, %RVar%_All_%Sec%_Keys, % Sort_Type
}


RIni_AddSectionsAsKeys(RVar, To_Section, Include_To_Section=0, Convert_Comments=1, Treat_Duplicate_Keys=1, Blank_Key_Values_On_Replace=1)
{
	;Treat_Duplicate_Keys
	;1 - Skip
	;2 - Append
	;3 - Replace
	Global
	Local T_Section, TTo_Section
	
	If !RIni_%RVar%_Is_Set
		Return -10
	TTo_Section := To_Section
	To_Section := RIni_CalcMD5(TTo_Section)
	
	If (!RIni_%RVar%_%To_Section%_Is_Set){
		If !RIni_%RVar%_Fix_Errors
			Return -2
		RIni_AddSection(RVar, TTo_Section)
	}
	
	Loop, % RIni_%RVar%_Section_Number
	{
		If (RIni_%RVar%_%A_Index% != ""){
			T_Section := RIni_CalcMD5(RIni_%RVar%_%A_Index%)
			If (!Include_To_Section and T_Section = To_Section)
				Continue
			If (InStr("`n" %RVar%_All_%To_Section%_Keys, "`n" T_Section "`n")){
				If (Treat_Duplicate_Keys = 1){
					Continue
				} Else If (Treat_duplicate_Keys = 2){
					If (Convert_Comments and %RVar%_%T_Section%_Comment)
						%RVar%_%To_Section%_%T_Section%_Comment .= %RVar%_%T_Section%_Comment
				} Else if (Treat_duplicate_Keys = 3){
					If (Convert_Comments){
						If %RVar%_%T_Section%_Comment
							%RVar%_%To_Section%_%T_Section%_Comment := %RVar%_%T_Section%_Comment
						Else if %RVar%_%To_Section%_%T_Section%_Comment
							%RVar%_%To_Section%_%T_Section%_Comment := ""
					}
					If (Blank_Key_Values_On_Replace and %RVar%_%To_Section%_%T_Section%_Value != "")
						%RVar%_%To_Section%_%T_Section%_Value := ""
				}
			} Else {
				%RVar%_All_%To_Section%_Keys .= T_Section "`n"
				%RVar%_%To_Section%_%T_Section%_Name := RIni_%RVar%_%A_Index%
				If %RVar%_%T_Section%_Comment
					%RVar%_%To_Section%_%T_Section%_Comment := %RVar%_%T_Section%_Comment
			}
		}
	}
}


RIni_AddKeysAsSections(RVar, From_Section, Include_From_Section=0, Treat_Duplicate_Sections=1, Convert_Comments=1, Blank_Sections_On_Replace=1)
{
	;Treat_Duplicate_Sections
	;1 - Skip
	;2 - Append
	;3 - Replace
	Global
	Local T_Section, TFrom_Section
	
	If !RIni_%RVar%_Is_Set
		Return -10
	TFrom_Section := From_Section
	From_Section := RIni_CalcMD5(TFrom_Section)
	
	If !RIni_%RVar%_%From_Section%_Is_Set
		Return -2
	If !%RVar%_All_%From_Section%_Keys
		Return -3
	Loop, Parse, %RVar%_All_%From_Section%_Keys, `n
	{
		If (A_LoopField = "" or A_LoopField = From_Section)
			Continue
		
		If (RIni_%RVar%_%A_LoopField%_Is_Set){
			If (Treat_Duplicate_Sections = 1)
				Continue
			Else If (Treat_Duplicate_Sections = 2){
				If (Convert_Comments and %RVar%_%From_Section%_%A_LoopField%_Comment)
					%RVar%_%A_LoopField%_Comment .= %RVar%_%From_Section%_%A_LoopField%_Comment
			} Else If (Treat_Duplicate_Sections = 3){
				If (Convert_Comments){
					If %RVar%_%From_Section%_%A_LoopField%_Comment
						%RVar%_%A_LoopField%_Comment := %RVar%_%From_Section%_%A_LoopField%_Comment
					Else If %RVar%_%A_LoopField%_Comment
						%RVar%_%A_LoopField%_Comment := ""
				}
				If (Blank_Sections_On_Replace and %RVar%_All_%A_LoopField%_Keys){
					T_Section := A_LoopField
					Loop, Parse, %RVar%_All_%T_Section%_Keys, `n
					{
						VarSetCapacity(%RVar%_%T_Section%_%A_LoopField%_Name, 0)
						If (%RVar%_%T_Section%_%A_LoopField%_Value != "")
							VarSetCapacity(%RVar%_%T_Section%_%A_LoopField%_Value, 0)
						If %RVar%_%T_Section%_%A_LoopField%_Comment
							VarSetCapacity(%RVar%_%T_Section%_%A_LoopField%_Comment, 0)
					}
					VarSetCapacity(%RVar%_All_%T_Section%_Keys, 0)
				}
			}
		} Else {
			RIni_AddSection(RVar, %RVar%_%From_Section%_%A_LoopField%_Name)
			If %RVar%_%From_Section%_%A_LoopField%_Comment
				%RVar%_%A_LoopField%_Comment := %RVar%_%From_Section%_%A_LoopField%_Comment
		}
	}
	If (Include_From_Section and InStr("`n" %RVar%_All_%From_Section%_Keys, "`n" From_Section "`n")){
		If (Treat_Duplicate_Sections = 1)
			Return
		Else If (Treat_Duplicate_Sections = 2){
			If %RVar%_%From_Section%_%From_Section%_Comment
				%RVar%_%From_Section%_Comment .= %RVar%_%From_Section%_%From_Section%_Comment
		} Else If (Treat_Duplicate_Sections = 3){
			If (Convert_Comments){
				If %RVar%_%From_Section%_%From_Section%_Comment
					%RVar%_%From_Section%_Comment := %RVar%_%From_Section%_%From_Section%_Comment
				Else If %RVar%_%From_Section%_Comment
					VarSetCapacity(%RVar%_%From_Section%_Comment, 0)
			}
			If (Blank_Sections_On_Replace){
				Loop, Parse, %RVar%_All_%From_Section%_Keys, `n
				{
					VarSetCapacity(%RVar%_%From_Section%_%A_LoopField%_Name, 0)
					If (%RVar%_%From_Section%_%A_LoopField%_Value != "")
						VarSetCapacity(%RVar%_%From_Section%_%A_LoopField%_Value, 0)
					If %RVar%_%From_Section%_%A_LoopField%_Comment
						VarSetCapacity(%RVar%_%From_Section%_%A_LoopField%_Comment, 0)
				}
				VarSetCapacity(%RVar%_All_%From_Section%_Keys, 0)
			}
		}
	}
}


RIni_AlterSectionKeys(RVar, Sec, Alter_How=1)
{
	;Alter_How
	;1 - Delete
	;2 - Erase values
	;3 - Erase comments
	;4 - Erase values and comments
	Global
	
	If !RIni_%RVar%_Is_Set
		Return -10
	
	Sec := RIni_CalcMD5(Sec)
	
	If !RIni_%RVar%_%Sec%_Is_Set
		Return -2
	If !%RVar%_All_%Sec%_Keys
		Return
	If (Alter_How = 1){
		Loop, Parse, %RVar%_All_%Sec%_Keys, `n
		{
			VarSetCapacity(%RVar%_%Sec%_%A_LoopField%_Name, 0)
			If (%RVar%_%Sec%_%A_LoopField%_Value != "")
				VarSetCapacity(%RVar%_%Sec%_%A_LoopField%_Value, 0)
			If %RVar%_%Sec%_%A_LoopField%_Comment
				VarSetCapacity(%RVar%_%Sec%_%A_LoopField%_Comment, 0)
		}
		VarSetCapacity(%RVar%_All_%Sec%_Keys, 0)
	} Else If (Alter_How = 2){
		Loop, Parse, %RVar%_All_%Sec%_Keys, `n
		{
			If (%RVar%_%Sec%_%A_LoopField%_Value != "")
				VarSetCapacity(%RVar%_%Sec%_%A_LoopField%_Value, 0)
		}
	} Else If (Alter_How = 3){
		Loop, Parse, %RVar%_All_%Sec%_Keys, `n
		{
			If %RVar%_%Sec%_%A_LoopField%_Comment
				VarSetCapacity(%RVar%_%Sec%_%A_LoopField%_Comment, 0)
		}
	} Else If (Alter_How = 4){
		Loop, Parse, %RVar%_All_%Sec%_Keys, `n
		{
			If (%RVar%_%Sec%_%A_LoopField%_Value != "")
				VarSetCapacity(%RVar%_%Sec%_%A_LoopField%_Value, 0)
			If %RVar%_%Sec%_%A_LoopField%_Comment
				VarSetCapacity(%RVar%_%Sec%_%A_LoopField%_Comment, 0)
		}
	}
}


RIni_CountSections(RVar)
{
	Global
	Local Number = 0
	Loop, % RIni_%RVar%_Section_Number
		If (RIni_%RVar%_%A_Index% != "")
			Number++
	
	Return Number
}

RIni_CountKeys(RVar, Sec="")
{
	Global
	Local Number = 0, T_Section
	
	If !RIni_%RVar%_Is_Set
		Return -10
	Sec := RIni_CalcMD5(Sec)
	
	If (Sec){
		Loop, % RIni_%RVar%_Section_Number
		{
			If (RIni_%RVar%_%A_Index% != ""){
				Sec := RIni_CalcMD5(RIni_%RVar%_%A_Index%)
				If (%RVar%_All_%Sec%_Keys){
					StringReplace, %RVar%_All_%Sec%_Keys, %RVar%_All_%Sec%_Keys, `n, `n, UseErrorLevel
					Number += ErrorLevel
				}
			}
		}
	} else {
		If (%RVar%_All_%Sec%_Keys){
			StringReplace, %RVar%_All_%Sec%_Keys, %RVar%_All_%Sec%_Keys, `n, `n, UseErrorLevel
			Number += ErrorLevel
		}
	}
	Return Number
}


RIni_AutoKeyList(RVar, Sec, List, List_Delimiter, Key_Prefix="Key", Returnw_Keys_List=1, New_Key_Delimiter=",", Trim_Spaces_From_Value=0)
{
	Global
	Static Number = 1, S_Section
	Local T_Value, New_Keys, TSec, TKey, Key
	
	If !RIni_%RVar%_Is_Set
		Return -10
	If (List_Delimiter != "`n" and List_Delimiter != "`r" and List_Delimiter != "`n`r" and List_Delimiter != "`r`n")
		Return -4
	TSec := Sec
	, Sec := RIni_CalcMD5(TSec)
	
	If (!RIni_%RVar%_%Sec%_Is_Set){
		If !RIni_%RVar%_Fix_Errors
			Return -2
		RIni_AddSection(RVar, TSec)
	}
	If Returnw_Keys_List
		VarSetCapacity(New_Keys, Ceil(StrLen(List) / StrLen(SubStr(List, 1, InStr(List, List_Delimiter))) * (StrLen(Key_Prefix)+2)) * RIni_Unicode_Modifier)
	If (S_Section != Sec)
		S_Section := Sec
		, Number = 1
	
	Loop, Parse, List, `n, `r
	{
		If A_LoopField =
			Continue
		Loop
		{
			TKey := Key_Prefix Number
			, Key := RIni_CalcMD5(TKey)
			
			If InStr("`n" %RVar%_All_%Sec%_Keys, "`n" Key "`n")
				Number ++
			Else
				Break
		}
		
		%RVar%_All_%Sec%_Keys .= Key "`n"
		, %RVar%_%Sec%_%Key%_Name := TKey
		If (Returnw_Keys_List)
			New_Keys .= New_Key_Delimiter TKey
		
		If (Trim_Spaces_From_Value)
			%RVar%_%Sec%_%Key%_Value = %A_LoopField%
		Else
			%RVar%_%Sec%_%Key%_Value := A_LoopField
	}
	
	Number++
	If Returnw_Keys_List
		Return New_Keys
}


RIni_SwapSections(RVar, Section_1, Section_2)
{
	Global
	Local T_Section, N, E, TSection_1, TSection_2, TT_Section
	
	If !RIni_%RVar%_Is_Set
		Return -10
	
	TSection_1 := Section_1
	, Section_1 := RIni_CalcMD5(TSection_1)
	If !RIni_%RVar%_%Section_1%_Is_Set
			Return -2
	
	TSection_2 := Section_2
	, Section_2 := RIni_CalcMD5(TSection_2)
	If !RIni_%RVar%_%Section_2%_Is_Set
			Return -2
	
	Loop
	{
		TT_Section := A_Now A_MSec
		, T_Section := RIni_CalcMD5(TT_Section)
		If !RIni_%RVar%_%T_Section%_Is_Set
			Break
		Else
			Sleep 1
	}
	
	If (E := RIni_RenameSection(RVar, TSection_1, TT_Section))
		Return E
	If (E := RIni_RenameSection(RVar, TSection_2, TSection_1))
		Return E
	If (E := RIni_RenameSection(RVar, TT_Section, TSection_2))
		Return E
}


RIni_ExportKeysToGlobals(RVar, Sec, Replace_If_Exists=0, Replace_Spaces_with="_")
{
	Global
	Local TKey
	
	If !RIni_%RVar%_Is_Set
		Return -10
	Sec := RIni_CalcMD5(Sec)
	If !RIni_%RVar%_%Sec%_Is_Set
		Return -2
	If !%RVar%_All_%Sec%_Keys
		Return -3
	Loop, Parse, %RVar%_All_%Sec%_Keys, `n
	{
		If A_LoopField =
			continue
		TKey := %RVar%_%Sec%_%A_Loopfield%_Name
		If (InStr(TKey, A_Space))
			StringReplace, TKey, TKey, %A_Space%, %Replace_Spaces_with%, A
		If (!Replace_If_Exists And %TKey% != "")
			Continue
		%TKey% := %RVar%_%Sec%_%A_LoopField%_Value
	}
}


RIni_SectionExists(RVar, Sec)
{
	Global
	
	If !RIni_%RVar%_Is_Set
		Return 0
	Sec := RIni_CalcMD5(Sec)
	Return RIni_%RVar%_%Sec%_Is_Set ? 1 : 0
}


RIni_KeyExists(RVar, Sec, Key)
{
	Global
	
	If !RIni_%RVar%_Is_Set
		Return -10
	Sec := RIni_CalcMD5(Sec)
	If !RIni_%RVar%_%Sec%_Is_Set
		Return 0
	Key := RIni_CalcMD5(Key)
	Return InStr("`n" %RVar%_All_%Sec%_Keys, "`n" Key "`n") ? 1 : 0
}


RIni_FindKey(RVar, Key)
{
	Global
	Local TSec, Sec
	
	If !RIni_%RVar%_Is_Set
		Return -10
	Key := RIni_CalcMD5(Key)
	Loop, % RIni_%RVar%_Section_Number
	{
		If (RIni_%RVar%_%A_Index% != ""){
			TSec := RIni_%RVar%_%A_Index%
			, Sec := RIni_CalcMD5(TSec)
			
			If (InStr("`n" %RVar%_All_%Sec%_Keys, "`n" Key "`n"))
				Return TSec
		}
	}
}


RIni_CalcMD5(_String)
{
	Global RIni_Unicode_Modifier
	Static MD5_CTX
	
	StringUpper, _String, _String
	
	Ptr := A_IsUnicode ? "UPtr" : "UInt"
	, VarSetCapacity(MD5_CTX, 104, 0)
	, DllCall("advapi32\MD5Init", Ptr, &MD5_CTX)
	, DllCall("advapi32\MD5Update", Ptr, &MD5_CTX, Ptr, &_String, "UInt", StrLen(_String) * RIni_Unicode_Modifier)
	, DllCall("advapi32\MD5Final", Ptr, &MD5_CTX)
	, MD5 .= NumGet(MD5_CTX, 88, "UChar")
	, MD5 .= NumGet(MD5_CTX, 89, "UChar")
	, MD5 .= NumGet(MD5_CTX, 90, "UChar")
	, MD5 .= NumGet(MD5_CTX, 91, "UChar")
	, MD5 .= NumGet(MD5_CTX, 92, "UChar")
	, MD5 .= NumGet(MD5_CTX, 93, "UChar")
	, MD5 .= NumGet(MD5_CTX, 94, "UChar")
	, MD5 .= NumGet(MD5_CTX, 95, "UChar")
	, MD5 .= NumGet(MD5_CTX, 96, "UChar")
	, MD5 .= NumGet(MD5_CTX, 97, "UChar")
	, MD5 .= NumGet(MD5_CTX, 98, "UChar")
	, MD5 .= NumGet(MD5_CTX, 99, "UChar")
	, MD5 .= NumGet(MD5_CTX, 100, "UChar")
	, MD5 .= NumGet(MD5_CTX, 101, "UChar")
	, MD5 .= NumGet(MD5_CTX, 102, "UChar")
	, MD5 .= NumGet(MD5_CTX, 103, "UChar")	
	
	Return MD5
}



/*
RIni_Create(RVar, Correct_Errors=1)
RIni_Shutdown(RVar)
RIni_Read(RVar, File, Correct_Errors=1, Remove_Inline_Key_Comments=0, Remove_Lone_Line_Comments=0, Remove_Inline_Section_Comments=0, Treat_Duplicate_Sections=1, Treat_Duplicate_Keys=1, Read_Blank_Sections=1, Read_Blank_Keys=1, Trim_Spaces_From_Values=0)
RIni_Write(RVar, File, Newline="`r`n", Write_Blank_Sections=1, Write_Blank_Keys=1, Space_Sections=1, Space_Keys=0, Remove_Valuewlines=1, Overwrite_If_Exists=1, Addwline_At_End=0)
RIni_AddSection(RVar, Sec)
RIni_AddKey(RVar, Sec, Key)
RIni_AppendValue(RVar, Sec, Key, Value, Trim_Spaces_From_Value=0, Removewlines=1)
RIni_ExpandSectionKeys(RVar, Sec, Amount=1)
RIni_ContractSectionKeys(RVar, Sec)
RIni_ExpandKeyValue(RVar, Sec, Key, Amount=1)
RIni_ContractKeyValue(RVar, Sec, Key)
RIni_SetKeyValue(RVar, Sec, Key, Value, Trim_Spaces_From_Value=0, Removewlines=1)
RIni_DeleteSection(RVar, Sec)
RIni_DeleteKey(RVar, Sec, Key)
RIni_GetSections(RVar, Delimiter=",")
RIni_GetSectionKeys(RVar, Sec, Delimiter=",")
RIni_GetKeyValue(RVar, Sec, Key, Default_Return="")
RIni_CopyKeys(From_RVar, To_RVar, From_Section, To_Section, Treat_Duplicate_Keys=2, Copy_Key_Values=1, Copy_Key_Comments=1, Copy_Blank_Keys=1)
RIni_Merge(From_RVar, To_RVar, Treat_Duplicate_Sections=1, Treat_Duplicate_Keys=2, Merge_Blank_Sections=1, Merge_Blank_Keys=1)
RIni_ToVariable(RVar, ByRef Variable, Newline="`r`n", Add_Blank_Sections=1, Add_Blank_Keys=1, Space_Sections=0, Space_Keys=0, Remove_Valuewlines=1)
RIni_GetKeysValues(RVar, ByRef Values, Key, Delimiter=",", Default_Return="")
RIni_AppendTopComments(RVar, Comments)
RIni_SetTopComments(RVar, Comments)
RIni_AppendSectionComment(RVar, Sec, Comment)
RIni_SetSectionComment(RVar, Sec, Comment)
RIni_AppendSectionLLComments(RVar, Sec, Comments)
RIni_SetSectionLLComments(RVar, Sec, Comments)
RIni_AppendKeyComment(RVar, Sec, Key, Comment)
RIni_SetKeyComment(RVar, Sec, Key, Comment)
RIni_GetTopComments(RVar, Delimiter="`r`n", Default_Return="")
RIni_GetSectionComment(RVar, Sec, Default_Return="")
RIni_GetSectionLLComments(RVar, Sec, Delimiter="`r`n", Default_Return="")
RIni_GetKeyComment(RVar, Sec, Key, Default_Return="")
RIni_GetTotalSize(RVar, Newline="`r`n", Default_Return="")
RIni_GetSectionSize(RVar, Sec, Newline="`r`n", Default_Return="")
RIni_GetKeySize(RVar, Sec, Key, Newline="`r`n", Default_Return="")
RIni_VariableToRIni(RVar, ByRef Variable, Correct_Errors=1, Remove_Inline_Key_Comments=0, Remove_Lone_Line_Comments=0, Remove_Inline_Section_Comments=0, Treat_Duplicate_Sections=1, Treat_Duplicate_Keys=1, Read_Blank_Sections=1, Read_Blank_Keys=1, Trim_Spaces_From_Values=0)
RIni_CopySectionNames(From_RVar, To_RVar, Treat_Duplicate_Sections=1, CopySection_Comments=1, Copy_Blank_Sections=1)
RIni_CopySection(From_RVar, To_RVar, From_Section, To_Section, Copy_Lone_Line_Comments=1, CopySection_Comment=1, Copy_Key_Values=1, Copy_Key_Comments=1, Copy_Blank_Keys=1)
RIni_CloneKey(From_RVar, To_RVar, From_Section, To_Section, From_Key, To_Key)
RIni_RenameSection(RVar, From_Section, To_Section)
RIni_RenameKey(RVar, Sec, From_Key, To_Key)
RIni_SortSections(RVar, Sort_Type="")
RIni_SortKeys(RVar, Sec, Sort_Type="")
RIni_AddSectionsAsKeys(RVar, To_Section, Include_To_Section=0, Convert_Comments=1, Treat_Duplicate_Keys=1, Blank_Key_Values_On_Replace=1)
RIni_AddKeysAsSections(RVar, From_Section, Include_From_Section=0, Treat_Duplicate_Sections=1, Convert_Comments=1, Blank_Sections_On_Replace=1)
RIni_AlterSectionKeys(RVar, Sec, Alter_How=1)
RIni_CountSections(RVar)
RIni_CountKeys(RVar, Sec="")
RIni_AutoKeyList(RVar, Sec, List, List_Delimiter, Key_Prefix="Key", Returnw_Keys_List=1, New_Key_Delimiter=",", Trim_Spaces_From_Value=0)
RIni_SwapSections(RVar, Section_1, Section_2)
RIni_ExportKeysToGlobals(RVar, Sec, Replace_If_Exists=0, Replace_Spaces_with="_")
RIni_SectionExists(RVar, Sec)
RIni_KeyExists(RVar, Sec, Key)
RIni_FindKey(RVar, Key)
*/


/**
 * Lib: JSON.ahk
 *     JSON lib for AutoHotkey.
 * Version:
 *     v2.1.3 [updated 04/18/2016 (MM/DD/YYYY)]
 * License:
 *     WTFPL [http://wtfpl.net/]
 * Requirements:
 *     Latest version of AutoHotkey (v1.1+ or v2.0-a+)
 * Installation:
 *     Use #Include JSON.ahk or copy into a function library folder and then
 *     use #Include <JSON>
 * Links:
 *     GitHub:     - https://github.com/cocobelgica/AutoHotkey-JSON
 *     Forum Topic - http://goo.gl/r0zI8t
 *     Email:      - cocobelgica <at> gmail <dot> com
 */


/**
 * Class: JSON
 *     The JSON object contains methods for parsing JSON and converting values
 *     to JSON. Callable - NO; Instantiable - YES; Subclassable - YES;
 *     Nestable(via #Include) - NO.
 * Methods:
 *     Load() - see relevant documentation before method definition header
 *     Dump() - see relevant documentation before method definition header
 */
class JSON
{
    /**
     * Method: Load
     *     Parses a JSON string into an AHK value
     * Syntax:
     *     value := JSON.Load( text [, reviver ] )
     * Parameter(s):
     *     value      [retval] - parsed value
     *     text    [in, ByRef] - JSON formatted string
     *     reviver   [in, opt] - function object, similar to JavaScript's
     *                           JSON.parse() 'reviver' parameter
     */
    class Load extends JSON.Functor
    {
        Call(self, ByRef text, reviver:="")
        {
            this.rev := IsObject(reviver) ? reviver : false
        ; Object keys(and array indices) are temporarily stored in arrays so that
        ; we can enumerate them in the order they appear in the document/text instead
        ; of alphabetically. Skip if no reviver function is specified.
            this.keys := this.rev ? {} : false

            static quot := Chr(34), bashq := "\" . quot
                 , json_value := quot . "{[01234567890-tfn"
                 , json_value_or_array_closing := quot . "{[]01234567890-tfn"
                 , object_key_or_object_closing := quot . "}"

            key := ""
            is_key := false
            root := {}
            stack := [root]
            next := json_value
            pos := 0

            while ((ch := SubStr(text, ++pos, 1)) != "") {
                if InStr(" `t`r`n", ch)
                    continue
                if !InStr(next, ch, 1)
                    this.ParseError(next, text, pos)

                holder := stack[1]
                is_array := holder.IsArray

                if InStr(",:", ch) {
                    next := (is_key := !is_array && ch == ",") ? quot : json_value

                } else if InStr("}]", ch) {
                    ObjRemoveAt(stack, 1)
                    next := stack[1]==root ? "" : stack[1].IsArray ? ",]" : ",}"

                } else {
                    if InStr("{[", ch) {
                    ; Check if Array() is overridden and if its return value has
                    ; the 'IsArray' property. If so, Array() will be called normally,
                    ; otherwise, use a custom base object for arrays
                        static json_array := Func("Array").IsBuiltIn || ![].IsArray ? {IsArray: true} : 0
                    
                    ; sacrifice readability for minor(actually negligible) performance gain
                        (ch == "{")
                            ? ( is_key := true
                              , value := {}
                              , next := object_key_or_object_closing )
                        ; ch == "["
                            : ( value := json_array ? new json_array : []
                              , next := json_value_or_array_closing )
                        
                        ObjInsertAt(stack, 1, value)

                        if (this.keys)
                            this.keys[value] := []
                    
                    } else {
                        if (ch == quot) {
                            i := pos
                            while (i := InStr(text, quot,, i+1)) {
                                value := StrReplace(SubStr(text, pos+1, i-pos-1), "\\", "\u005c")

                                static tail := A_AhkVersion<"2" ? 0 : -1
                                if (SubStr(value, tail) != "\")
                                    break
                            }

                            if (!i)
                                this.ParseError("'", text, pos)

                              value := StrReplace(value,  "\/",  "/")
                            , value := StrReplace(value, bashq, quot)
                            , value := StrReplace(value,  "\b", "`b")
                            , value := StrReplace(value,  "\f", "`f")
                            , value := StrReplace(value,  "\n", "`n")
                            , value := StrReplace(value,  "\r", "`r")
                            , value := StrReplace(value,  "\t", "`t")

                            pos := i ; update pos
                            
                            i := 0
                            while (i := InStr(value, "\",, i+1)) {
                                if !(SubStr(value, i+1, 1) == "u")
                                    this.ParseError("\", text, pos - StrLen(SubStr(value, i+1)))

                                uffff := Abs("0x" . SubStr(value, i+2, 4))
                                if (A_IsUnicode || uffff < 0x100)
                                    value := SubStr(value, 1, i-1) . Chr(uffff) . SubStr(value, i+6)
                            }

                            if (is_key) {
                                key := value, next := ":"
                                continue
                            }
                        
                        } else {
                            value := SubStr(text, pos, i := RegExMatch(text, "[\]\},\s]|$",, pos)-pos)

                            static number := "number", integer :="integer"
                            if value is %number%
                            {
                                if value is %integer%
                                    value += 0
                            }
                            else if (value == "true" || value == "false")
                                value := %value% + 0
                            else if (value == "null")
                                value := ""
                            else
                            ; we can do more here to pinpoint the actual culprit
                            ; but that's just too much extra work.
                                this.ParseError(next, text, pos, i)

                            pos += i-1
                        }

                        next := holder==root ? "" : is_array ? ",]" : ",}"
                    } ; If InStr("{[", ch) { ... } else

                    is_array? key := ObjPush(holder, value) : holder[key] := value

                    if (this.keys && this.keys.HasKey(holder))
                        this.keys[holder].Push(key)
                }
            
            } ; while ( ... )

            return this.rev ? this.Walk(root, "") : root[""]
        }

        ParseError(expect, ByRef text, pos, len:=1)
        {
            static quot := Chr(34), qurly := quot . "}"
            
            line := StrSplit(SubStr(text, 1, pos), "`n", "`r").Length()
            col := pos - InStr(text, "`n",, -(StrLen(text)-pos+1))
            msg := Format("{1}`n`nLine:`t{2}`nCol:`t{3}`nChar:`t{4}"
            ,     (expect == "")     ? "Extra data"
                : (expect == "'")    ? "Unterminated string starting at"
                : (expect == "\")    ? "Invalid \escape"
                : (expect == ":")    ? "Expecting ':' delimiter"
                : (expect == quot)   ? "Expecting object key enclosed in double quotes"
                : (expect == qurly)  ? "Expecting object key enclosed in double quotes or object closing '}'"
                : (expect == ",}")   ? "Expecting ',' delimiter or object closing '}'"
                : (expect == ",]")   ? "Expecting ',' delimiter or array closing ']'"
                : InStr(expect, "]") ? "Expecting JSON value or array closing ']'"
                :                      "Expecting JSON value(string, number, true, false, null, object or array)"
            , line, col, pos)

            static offset := A_AhkVersion<"2" ? -3 : -4
            throw Exception(msg, offset, SubStr(text, pos, len))
        }

        Walk(holder, key)
        {
            value := holder[key]
            if IsObject(value) {
                for i, k in this.keys[value] {
                    ; check if ObjHasKey(value, k) ??
                    v := this.Walk(value, k)
                    if (v != JSON.Undefined)
                        value[k] := v
                    else
                        ObjDelete(value, k)
                }
            }
            
            return this.rev.Call(holder, key, value)
        }
    }

    /**
     * Method: Dump
     *     Converts an AHK value into a JSON string
     * Syntax:
     *     str := JSON.Dump( value [, replacer, space ] )
     * Parameter(s):
     *     str        [retval] - JSON representation of an AHK value
     *     value          [in] - any value(object, string, number)
     *     replacer  [in, opt] - function object, similar to JavaScript's
     *                           JSON.stringify() 'replacer' parameter
     *     space     [in, opt] - similar to JavaScript's JSON.stringify()
     *                           'space' parameter
     */
    class Dump extends JSON.Functor
    {
        Call(self, value, replacer:="", space:="")
        {
            this.rep := IsObject(replacer) ? replacer : ""

            this.gap := ""
            if (space) {
                static integer := "integer"
                if space is %integer%
                    Loop, % ((n := Abs(space))>10 ? 10 : n)
                        this.gap .= " "
                else
                    this.gap := SubStr(space, 1, 10)

                this.indent := "`n"
            }

            return this.Str({"": value}, "")
        }

        Str(holder, key)
        {
            value := holder[key]

            if (this.rep)
                value := this.rep.Call(holder, key, ObjHasKey(holder, key) ? value : JSON.Undefined)

            if IsObject(value) {
            ; Check object type, skip serialization for other object types such as
            ; ComObject, Func, BoundFunc, FileObject, RegExMatchObject, Property, etc.
                static type := A_AhkVersion<"2" ? "" : Func("Type")
                if (type ? type.Call(value) == "Object" : ObjGetCapacity(value) != "") {
                    if (this.gap) {
                        stepback := this.indent
                        this.indent .= this.gap
                    }

                    is_array := value.IsArray
                ; Array() is not overridden, rollback to old method of
                ; identifying array-like objects. Due to the use of a for-loop
                ; sparse arrays such as '[1,,3]' are detected as objects({}). 
                    if (!is_array) {
                        for i in value
                            is_array := i == A_Index
                        until !is_array
                    }

                    str := ""
                    if (is_array) {
                        Loop, % value.Length() {
                            if (this.gap)
                                str .= this.indent
                            
                            v := this.Str(value, A_Index)
                            str .= (v != "") ? v . "," : "null,"
                        }
                    } else {
                        colon := this.gap ? ": " : ":"
                        for k in value {
                            v := this.Str(value, k)
                            if (v != "") {
                                if (this.gap)
                                    str .= this.indent

                                str .= this.Quote(k) . colon . v . ","
                            }
                        }
                    }

                    if (str != "") {
                        str := RTrim(str, ",")
                        if (this.gap)
                            str .= stepback
                    }

                    if (this.gap)
                        this.indent := stepback

                    return is_array ? "[" . str . "]" : "{" . str . "}"
                }
            
            } else ; is_number ? value : "value"
                return ObjGetCapacity([value], 1)=="" ? value : this.Quote(value)
        }

        Quote(string)
        {
            static quot := Chr(34), bashq := "\" . quot

            if (string != "") {
                  string := StrReplace(string,  "\",  "\\")
                ; , string := StrReplace(string,  "/",  "\/") ; optional in ECMAScript
                , string := StrReplace(string, quot, bashq)
                , string := StrReplace(string, "`b",  "\b")
                , string := StrReplace(string, "`f",  "\f")
                , string := StrReplace(string, "`n",  "\n")
                , string := StrReplace(string, "`r",  "\r")
                , string := StrReplace(string, "`t",  "\t")

                static rx_escapable := A_AhkVersion<"2" ? "O)[^\x20-\x7e]" : "[^\x20-\x7e]"
                while RegExMatch(string, rx_escapable, m)
                    string := StrReplace(string, m.Value, Format("\u{1:04x}", Ord(m.Value)))
            }

            return quot . string . quot
        }
    }

    /**
     * Property: Undefined
     *     Proxy for 'undefined' type
     * Syntax:
     *     undefined := JSON.Undefined
     * Remarks:
     *     For use with reviver and replacer functions since AutoHotkey does not
     *     have an 'undefined' type. Returning blank("") or 0 won't work since these
     *     can't be distnguished from actual JSON values. This leaves us with objects.
     *     Replacer() - the caller may return a non-serializable AHK objects such as
     *     ComObject, Func, BoundFunc, FileObject, RegExMatchObject, and Property to
     *     mimic the behavior of returning 'undefined' in JavaScript but for the sake
     *     of code readability and convenience, it's better to do 'return JSON.Undefined'.
     *     Internally, the property returns a ComObject with the variant type of VT_EMPTY.
     */
    Undefined[]
    {
        get {
            static empty := {}, vt_empty := ComObject(0, &empty, 1)
            return vt_empty
        }
    }

    class Functor
    {
        __Call(method, ByRef arg, args*)
        {
        ; When casting to Call(), use a new instance of the "function object"
        ; so as to avoid directly storing the properties(used across sub-methods)
        ; into the "function object" itself.
            if IsObject(method)
                return (new this).Call(method, arg, args*)
            else if (method == "")
                return (new this).Call(arg, args*)
        }
    }
}
uriDecode(str) {
    Loop
 If RegExMatch(str, "i)(?<=%)[\da-f]{1,2}", hex)
    StringReplace, str, str, `%%hex%, % Chr("0x" . hex), All
    Else Break
 Return, str
}
 
UriEncode(Uri, RE="[0-9A-Za-z]"){
    VarSetCapacity(Var,StrPut(Uri,"UTF-8"),0),StrPut(Uri,&Var,"UTF-8")
    While Code:=NumGet(Var,A_Index-1,"UChar")
    Res.=(Chr:=Chr(Code))~=RE?Chr:Format("%{:02X}",Code)
    Return,Res  
}
;~ D2 text color codes
;~ ÿc1 = red
;~ ÿc2 = bright green
;~ ÿc3 = Magic blue
;~ ÿc4 = Unique gold
;~ ÿc5 = dark gray
;~ ÿc6 = black
;~ ÿc7 = Brighter Unique Gold ?
;~ ÿc8 = Crafted orange
;~ ÿc9 = Rare yellow
;~ ÿc0 = Normal white
;~ ÿc! = grey
;~ ÿc" = grey
;~ ÿc+ = white
;~ ÿc< = medium green
;~ ÿc; = purple
;~ ÿc: = dark green
;~ ÿc. = white

;=============================================================================================================================
;FOR CORE 1.10F

;The following functions define parsing the txt files into each decompiled language.

;FOR CORE 1.10F
;=============================================================================================================================
;;;Simple functions, just copy the file.
;~ Digest_Txt_110f_arena()
;~ Digest_Txt_110f_armtype()
;~ Digest_Txt_110f_automagic()
;~ Digest_Txt_110f_automap()
;~ Digest_Txt_110f_belts()
;~ Digest_Txt_110f_bodylocs()
;~ Digest_Txt_110f_books()
;~ Digest_Txt_110f_charstats()
;~ Digest_Txt_110f_chartemplate() [maybe]
;~ Digest_Txt_110f_colors()
;~ Digest_Txt_110f_compcode() [maybe]
;~ Digest_Txt_110f_composit()
;~ Digest_Txt_110f_cubemod()
;~ Digest_Txt_110f_cubetype()
;~ Digest_Txt_110f_DifficultyLevels()
;~ Digest_Txt_110f_elemtypes()
;~ Digest_Txt_110f_events()
Digest_Txt_110f_experience(FileToParse,LanguageToParse,TableCodesArray,FileToSave)
{
}
;~ Digest_Txt_110f_hiredesc()
;~ Digest_Txt_110f_hireling()
;~ Digest_Txt_110f_hitclass()
;~ Digest_Txt_110f_inventory()







Digest_Txt_110f_armor(FileToParse,LanguageToParse,TableCodesArray,FileToSave) ;done
{
	txtfile := ObjCSV_CSV2Collection(FileToParse,TxtHeaders,1,,,a_tab)
	;Array containing the entirety of the txtfile
	
	;Array containing the unique headers for this txtfile
	TxtHeadersSplit := (StrSplit(TxtHeaders,a_tab))
	
	NewTxt :=
	;~ msgbox % st_printarr(TxtHeadersSplit)
	Loop, % TxtHeadersSplit.length()
	{
		TxtHeadersNoUnderscore := StrSplit(TxtHeadersSplit[a_index],"_")
		NewTxt .= TxtHeadersNoUnderscore[1] A_Tab
	}
	StringTrimRight,NewTxt,NewTxt,1
	NewTxt .= "`r`n"
	;~ clipboard := NewTxt
	;~ ExitApp
	
	
	;~ msgbox % st_printarr(StrSplit(TxtHeaders,a_tab))
	;Loop through the text headers to clean up and generate the 

	Loop,% txtfile.length()
	{
		;Array containing the items of this specific line.
		TxtLine := txtfile[a_index]
		TxtLineIndex := a_index
		;~ msgbox % st_printarr(txtline)
		;~ Clipboard := st_printarr(txtline)

		;Begin looping through the text headers to generate the correct listing order
		Loop, % TxtHeadersSplit.length()
		{
			;~ msgbox % "|" TxtHeadersSplit[a_index] "|"
			;~ ExitApp
			;~ msgbox % TxtLine[TxtHeadersSplit[a_index]]
			If Trim(TxtHeadersSplit[a_index]) = "name"
			{
									
				
				if TableCodesArray[LanguageToParse,txtfile[TxtLineIndex,"code"]]!=""
				{
					;~ msgbox % TableCodesArray[LanguageToParse,txtfile[TxtLineIndex,"code"]]
				;~ ExitApp
					NewTxt .= TableCodesArray[LanguageToParse,txtfile[TxtLineIndex,"code"]] a_tab ; name
				}
				else if  TableCodesArray["ENG",txtfile[TxtLineIndex,"code"]]!=""
					NewTxt .= TableCodesArray["ENG",txtfile[TxtLineIndex,"code"]] a_tab ; ENGLISH name
				Else
					NewTxt .= txtfile[TxtLineIndex,"name"] a_tab ; name stays unchanged
				;~ MsgBox % NewTxt
				continue
			}
			;~ if a_index != TxtHeadersSplit.length()
				NewTxt .=  TxtLine[TxtHeadersSplit[a_index]] a_tab
			;~ else
				;~ NewTxt .=  TxtLine[TxtHeadersSplit[a_index]]
		}
		StringTrimRight,NewTxt,NewTxt,1
		NewTxt .= "`r`n" ; EOL
	}
		FileDelete,%FileToSave%
	FileAppend,%NewTxt%,%FileToSave%
	return
}
;~ Digest_Txt_110f_cubemain()
;~ Digest_Txt_110f_gamble()
Digest_Txt_110f_gems(FileToParse,LanguageToParse,TableCodesArray,FileToSave) ;done
{
		txtfile := ObjCSV_CSV2Collection(FileToParse,TxtHeaders,1,,,a_tab)
	;Array containing the entirety of the txtfile
	
	;Array containing the unique headers for this txtfile
	TxtHeadersSplit := (StrSplit(TxtHeaders,a_tab))
	
	NewTxt :=
	;~ msgbox % st_printarr(TxtHeadersSplit)
	Loop, % TxtHeadersSplit.length()
	{
		TxtHeadersNoUnderscore := StrSplit(TxtHeadersSplit[a_index],"_")
		NewTxt .= TxtHeadersNoUnderscore[1] A_Tab
	}
	StringTrimRight,NewTxt,NewTxt,1
	NewTxt .= "`r`n"
	;~ clipboard := NewTxt
	;~ ExitApp
	
	
	;~ msgbox % st_printarr(StrSplit(TxtHeaders,a_tab))
	;Loop through the text headers to clean up and generate the 

	Loop,% txtfile.length()
	{
		;Array containing the items of this specific line.
		TxtLine := txtfile[a_index]
		TxtLineIndex := a_index
		;~ msgbox % st_printarr(txtline)
		;~ Clipboard := st_printarr(txtline)

		;Begin looping through the text headers to generate the correct listing order
		Loop, % TxtHeadersSplit.length()
		{
			;~ msgbox % "|" TxtHeadersSplit[a_index] "|"
			;~ ExitApp
			;~ msgbox % TxtLine[TxtHeadersSplit[a_index]]
			If Trim(TxtHeadersSplit[a_index]) = "ItemType"
			{
									
				
				if TableCodesArray[LanguageToParse,txtfile[TxtLineIndex,"code"]]!=""
				{
					;~ msgbox % TableCodesArray[LanguageToParse,txtfile[TxtLineIndex,"code"]]
				;~ ExitApp
					NewTxt .= TableCodesArray[LanguageToParse,txtfile[TxtLineIndex,"code"]] a_tab ; name
				}
				else if  TableCodesArray["ENG",txtfile[TxtLineIndex,"code"]]!=""
					NewTxt .= TableCodesArray["ENG",txtfile[TxtLineIndex,"code"]] a_tab ; ENGLISH name
				Else
					NewTxt .= txtfile[TxtLineIndex,"name"] a_tab ; name stays unchanged
				;~ MsgBox % NewTxt
				continue
			}
			;~ if a_index != TxtHeadersSplit.length()
				NewTxt .=  TxtLine[TxtHeadersSplit[a_index]] a_tab
			;~ else
				;~ NewTxt .=  TxtLine[TxtHeadersSplit[a_index]]
		}
		StringTrimRight,NewTxt,NewTxt,1
		NewTxt .= "`r`n" ; EOL
	}
		FileDelete,%FileToSave%
	FileAppend,%NewTxt%,%FileToSave%
	return
}
;~ Digest_Txt_110f_itemratio()
;~ Digest_Txt_110f_itemscode()
;~ Digest_Txt_110f_itemstatcost()
Digest_Txt_110f_itemtypes(FileToParse,LanguageToParse,TableCodesArray,FileToSave)
{
		txtfile := ObjCSV_CSV2Collection(FileToParse,TxtHeaders,1,,,a_tab)
	;Array containing the entirety of the txtfile
	
	;Array containing the unique headers for this txtfile
	TxtHeadersSplit := (StrSplit(TxtHeaders,a_tab))
	
	NewTxt :=
	;~ msgbox % st_printarr(TxtHeadersSplit)
	Loop, % TxtHeadersSplit.length()
	{
		TxtHeadersNoUnderscore := StrSplit(TxtHeadersSplit[a_index],"_")
		NewTxt .= TxtHeadersNoUnderscore[1] A_Tab
	}
	StringTrimRight,NewTxt,NewTxt,1
	NewTxt .= "`r`n"
	;~ clipboard := NewTxt
	;~ ExitApp
	
	
	;~ msgbox % st_printarr(StrSplit(TxtHeaders,a_tab))
	;Loop through the text headers to clean up and generate the 

	Loop,% txtfile.length()
	{
		;Array containing the items of this specific line.
		TxtLine := txtfile[a_index]
		TxtLineIndex := a_index
		;~ msgbox % st_printarr(txtline)
		;~ Clipboard := st_printarr(txtline)

		;Begin looping through the text headers to generate the correct listing order
		Loop, % TxtHeadersSplit.length()
		{
			;~ msgbox % "|" TxtHeadersSplit[a_index] "|"
			;~ ExitApp
			;~ msgbox % TxtLine[TxtHeadersSplit[a_index]]
			If Trim(TxtHeadersSplit[a_index]) = "ItemType"
			{
									
				
				if TableCodesArray[LanguageToParse,txtfile[TxtLineIndex,"code"]]!=""
				{
					;~ msgbox % TableCodesArray[LanguageToParse,txtfile[TxtLineIndex,"code"]]
				;~ ExitApp
					NewTxt .= TableCodesArray[LanguageToParse,txtfile[TxtLineIndex,"code"]] a_tab ; name
				}
				else if  TableCodesArray["ENG",txtfile[TxtLineIndex,"code"]]!=""
					NewTxt .= TableCodesArray["ENG",txtfile[TxtLineIndex,"code"]] a_tab ; ENGLISH name
				Else
					NewTxt .= txtfile[TxtLineIndex,"name"] a_tab ; name stays unchanged
				;~ MsgBox % NewTxt
				continue
			}
			;~ if a_index != TxtHeadersSplit.length()
				NewTxt .=  TxtLine[TxtHeadersSplit[a_index]] a_tab
			;~ else
				;~ NewTxt .=  TxtLine[TxtHeadersSplit[a_index]]
		}
		StringTrimRight,NewTxt,NewTxt,1
		NewTxt .= "`r`n" ; EOL
	}
		FileDelete,%FileToSave%
	FileAppend,%NewTxt%,%FileToSave%
	return
}
;~ Digest_Txt_110f_levels()
;~ Digest_Txt_110f_lowqualityitems()
;~ Digest_Txt_110f_LvlMaze()
;~ Digest_Txt_110f_lvlprest()
;~ Digest_Txt_110f_LvlSub()
;~ Digest_Txt_110f_lvltypes()
;~ Digest_Txt_110f_LvlWarp()
;~ Digest_Txt_110f_MagicPrefix()
;~ Digest_Txt_110f_MagicSuffix()
Digest_Txt_110f_misc(FileToParse,LanguageToParse,TableCodesArray,FileToSave)
{
	txtfile := ObjCSV_CSV2Collection(FileToParse,TxtHeaders,1,,,a_tab)
	;Array containing the entirety of the txtfile
	
	;Array containing the unique headers for this txtfile
	TxtHeadersSplit := (StrSplit(TxtHeaders,a_tab))
	
	NewTxt :=
	;~ msgbox % st_printarr(TxtHeadersSplit)
	Loop, % TxtHeadersSplit.length()
	{
		TxtHeadersNoUnderscore := StrSplit(TxtHeadersSplit[a_index],"_")
		NewTxt .= TxtHeadersNoUnderscore[1] A_Tab
	}
	StringTrimRight,NewTxt,NewTxt,1
	NewTxt .= "`r`n"
	;~ clipboard := NewTxt
	;~ ExitApp
	
	
	;~ msgbox % st_printarr(StrSplit(TxtHeaders,a_tab))
	;Loop through the text headers to clean up and generate the 

	Loop,% txtfile.length()
	{
		;Array containing the items of this specific line.
		TxtLine := txtfile[a_index]
		TxtLineIndex := a_index
		;~ msgbox % st_printarr(txtline)
		;~ Clipboard := st_printarr(txtline)

		;Begin looping through the text headers to generate the correct listing order
		Loop, % TxtHeadersSplit.length()
		{
			;~ msgbox % "|" TxtHeadersSplit[a_index] "|"
			;~ ExitApp
			;~ msgbox % TxtLine[TxtHeadersSplit[a_index]]
			If Trim(TxtHeadersSplit[a_index]) = "*name"
			{
									
				
				if TableCodesArray[LanguageToParse,txtfile[TxtLineIndex,"code"]]!=""
				{
					;~ msgbox % TableCodesArray[LanguageToParse,txtfile[TxtLineIndex,"code"]]
				;~ ExitApp
					NewTxt .= TableCodesArray[LanguageToParse,txtfile[TxtLineIndex,"code"]] a_tab ; name
				}
				else if  TableCodesArray["ENG",txtfile[TxtLineIndex,"code"]]!=""
					NewTxt .= TableCodesArray["ENG",txtfile[TxtLineIndex,"code"]] a_tab ; ENGLISH name
				Else
					NewTxt .= txtfile[TxtLineIndex,"name"] a_tab ; name stays unchanged
				;~ MsgBox % NewTxt
				continue
			}
			;~ if a_index != TxtHeadersSplit.length()
				NewTxt .=  TxtLine[TxtHeadersSplit[a_index]] a_tab
			;~ else
				;~ NewTxt .=  TxtLine[TxtHeadersSplit[a_index]]
		}
		StringTrimRight,NewTxt,NewTxt,1
		NewTxt .= "`r`n" ; EOL
	}
	FileDelete,%FileToSave%
	FileAppend,%NewTxt%,%FileToSave%
	return
}
;~ Digest_Txt_110f_MissCalc()
;~ Digest_Txt_110f_misscode()
;~ Digest_Txt_110f_missiles()
;~ Digest_Txt_110f_monai()
;~ Digest_Txt_110f_monequip()
;~ Digest_Txt_110f_monitempercent()
;~ Digest_Txt_110f_monlvl()
;~ Digest_Txt_110f_monmode()
;~ Digest_Txt_110f_monname()
;~ Digest_Txt_110f_monplace()
;~ Digest_Txt_110f_monpreset()
;~ Digest_Txt_110f_monprop()
;~ Digest_Txt_110f_monseq()
;~ Digest_Txt_110f_monsounds()
;~ Digest_Txt_110f_monstats()
;~ Digest_Txt_110f_monstats2()
;~ Digest_Txt_110f_montype()
;~ Digest_Txt_110f_monumod()
;~ Digest_Txt_110f_npc()
;~ Digest_Txt_110f_objects()
;~ Digest_Txt_110f_objgroup()
;~ Digest_Txt_110f_objmode()
;~ Digest_Txt_110f_objtype()
;~ Digest_Txt_110f_overlay()
;~ Digest_Txt_110f_pettype()
;~ Digest_Txt_110f_playerclass()
;~ Digest_Txt_110f_plrmode()
;~ Digest_Txt_110f_plrtype()
;~ Digest_Txt_110f_properties()
;~ Digest_Txt_110f_qualityitems()
;~ Digest_Txt_110f_RarePrefix()
;~ Digest_Txt_110f_RareSuffix()
Digest_Txt_110f_runes(FileToParse,LanguageToParse,TableCodesArray,FileToSave)
{
	txtfile := ObjCSV_CSV2Collection(FileToParse,TxtHeaders,1,,,a_tab)
	TxtHeadersSplit := (StrSplit(TxtHeaders,a_tab))
	NewTxt :=
	Loop, % TxtHeadersSplit.length()
	{
		TxtHeadersNoUnderscore := StrSplit(TxtHeadersSplit[a_index],"_")
		NewTxt .= TxtHeadersNoUnderscore[1] A_Tab
	}
	StringTrimRight,NewTxt,NewTxt,1
	NewTxt .= "`r`n"
	Loop,% txtfile.length()
	{
		TxtLine := txtfile[a_index]
		TxtLineIndex := a_index
		Loop, % TxtHeadersSplit.length()
		{
			;~ msgbox % TxtHeadersSplit[a_index]
			If Trim(TxtHeadersSplit[a_index]) = "*runes"
			{
				
				;~ RunesTxt := 
				;~ if txtfile[TxtLineIndex,"rune3"]=""
					;~ continue
					;~ txtfile[TxtLineIndex,"rune1"] = rune code referenced on this table
					;~ TableCodesArray[LanguageToParse,txtfile[TxtLineIndex,"rune1"]] = Rune name determined using the above rune code
				Loop
				{
					if txtfile[TxtLineIndex,"rune" a_index]!=""
					{
						If a_index=1
						{
							NewTxt .= Trim(TableCodesArray[LanguageToParse,txtfile[TxtLineIndex,"rune" a_index]])
							;~ msgbox % TableCodesArray[LanguageToParse,txtfile[TxtLineIndex,"rune" a_index]]
						}
						else
							NewTxt .= a_space "+" a_space Trim(TableCodesArray[LanguageToParse,txtfile[TxtLineIndex,"rune" a_index]]) 
					}
					else
						break
				}
				;~ NewTxt .= RunesTxt
				;~ if TableCodesArray[LanguageToParse,txtfile[TxtLineIndex,"code"]]!=""
				;~ {
					;~ NewTxt .= TableCodesArray[LanguageToParse,txtfile[TxtLineIndex,"code"]] a_tab ; name
				;~ }
				;~ else if  TableCodesArray["ENG",txtfile[TxtLineIndex,"code"]]!=""
					;~ NewTxt .= TableCodesArray["ENG",txtfile[TxtLineIndex,"code"]] a_tab ; ENGLISH name
				;~ Else
					;~ NewTxt .= txtfile[TxtLineIndex,"name"] a_tab ; name stays unchanged
				;~ continue
				NewTxt .= a_tab
			}
			else
				NewTxt .=  TxtLine[TxtHeadersSplit[a_index]] a_tab
		}
		StringTrimRight,NewTxt,NewTxt,1
		NewTxt .= "`r`n" ; EOL
	}
		FileDelete,%FileToSave%
	FileAppend,%NewTxt%,%FileToSave%
	return
}
;~ Digest_Txt_110f_setitems()


Digest_Txt_110f_sets()
{
	;Requires a pre-emptive run WITH the string tbls.
	;Or possibly last.
}

;~ Digest_Txt_110f_shrines()
;~ Digest_Txt_110f_skillcalc()
;~ Digest_Txt_110f_skilldesc()
;~ Digest_Txt_110f_skilldesccode()
;~ Digest_Txt_110f_skills()
;~ Digest_Txt_110f_skillscode()
;~ Digest_Txt_110f_SoundEnviron()
;~ Digest_Txt_110f_sounds()
;~ Digest_Txt_110f_states()
;~ Digest_Txt_110f_storepage()
;~ Digest_Txt_110f_superuniques()
;~ Digest_Txt_110f_treasureclass()
;~ Digest_Txt_110f_TreasureClassEx()
;~ Digest_Txt_110f_uniqueappellation()
Digest_Txt_110f_uniqueitems(FileToParse,LanguageToParse,TableCodesArray,FileToSave)
{
	txtfile := ObjCSV_CSV2Collection(FileToParse,TxtHeaders,1,,,a_tab)
	TxtHeadersSplit := (StrSplit(TxtHeaders,a_tab))
	NewTxt :=
	Loop, % TxtHeadersSplit.length()
	{
		TxtHeadersNoUnderscore := StrSplit(TxtHeadersSplit[a_index],"_")
		NewTxt .= TxtHeadersNoUnderscore[1] A_Tab
	}
	StringTrimRight,NewTxt,NewTxt,1
	NewTxt .= "`r`n"
	Loop,% txtfile.length()
	{
		TxtLine := txtfile[a_index]
		TxtLineIndex := a_index
		Loop, % TxtHeadersSplit.length()
		{
			If Trim(TxtHeadersSplit[a_index]) = "*type"
			{
				;~ Determine index name
				if TableCodesArray[LanguageToParse,txtfile[TxtLineIndex,"index"]]!=""
				{
					IndexName := TableCodesArray[LanguageToParse,txtfile[TxtLineIndex,"index"]] ; a_tab ; name
				}
				else if  TableCodesArray["ENG",txtfile[TxtLineIndex,"index"]]!=""
					IndexName := TableCodesArray["ENG",txtfile[TxtLineIndex,"index"]] ;a_tab ; ENGLISH name
				Else
					IndexName := txtfile[TxtLineIndex,"index"] ;a_tab ; name stays unchanged
				
				
				;~ Determine code name
				if TableCodesArray[LanguageToParse,txtfile[TxtLineIndex,"code"]]!=""
				{
					CodeName := TableCodesArray[LanguageToParse,txtfile[TxtLineIndex,"code"]] ; a_tab ; name
				}
				else if  TableCodesArray["ENG",txtfile[TxtLineIndex,"code"]]!=""
					CodeName := TableCodesArray["ENG",txtfile[TxtLineIndex,"code"]] ;a_tab ; ENGLISH name
				Else
					CodeName := txtfile[TxtLineIndex,"code"] ;a_tab ; name stays unchanged
				
				If Trim(IndexName) = Trim(CodeName)
						NewTxt .=  CodeName a_tab
				else
					NewTxt .= IndexName a_space CodeName a_tab
				continue
			}
				
					NewTxt .=  TxtLine[TxtHeadersSplit[a_index]] a_tab
				
				
		}
		StringTrimRight,NewTxt,NewTxt,1
		NewTxt .= "`r`n" ; EOL
	}
		FileDelete,%FileToSave%
	FileAppend,%NewTxt%,%FileToSave%
	return
}
;~ Digest_Txt_110f_uniqueprefix()
;~ Digest_Txt_110f_uniquesuffix()
;~ Digest_Txt_110f_uniquetitle()
;~ Digest_Txt_110f_weaponclass()
Digest_Txt_110f_weapons(FileToParse,LanguageToParse,TableCodesArray,FileToSave)
{
	txtfile := ObjCSV_CSV2Collection(FileToParse,TxtHeaders,1,,,a_tab)
	;Array containing the entirety of the txtfile
	
	;Array containing the unique headers for this txtfile
	TxtHeadersSplit := (StrSplit(TxtHeaders,a_tab))
	
	NewTxt :=
	;~ msgbox % st_printarr(TxtHeadersSplit)
	Loop, % TxtHeadersSplit.length()
	{
		TxtHeadersNoUnderscore := StrSplit(TxtHeadersSplit[a_index],"_")
		NewTxt .= TxtHeadersNoUnderscore[1] A_Tab
	}
	StringTrimRight,NewTxt,NewTxt,1
	NewTxt .= "`r`n"
	;~ clipboard := NewTxt
	;~ ExitApp
	
	
	;~ msgbox % st_printarr(StrSplit(TxtHeaders,a_tab))
	;Loop through the text headers to clean up and generate the 

	Loop,% txtfile.length()
	{
		;Array containing the items of this specific line.
		TxtLine := txtfile[a_index]
		TxtLineIndex := a_index
		;~ msgbox % st_printarr(txtline)
		;~ Clipboard := st_printarr(txtline)

		;Begin looping through the text headers to generate the correct listing order
		Loop, % TxtHeadersSplit.length()
		{
			;~ msgbox % "|" TxtHeadersSplit[a_index] "|"
			;~ ExitApp
			;~ msgbox % TxtLine[TxtHeadersSplit[a_index]]
			If Trim(TxtHeadersSplit[a_index]) = "name"
			{
									
				
				if TableCodesArray[LanguageToParse,txtfile[TxtLineIndex,"code"]]!=""
				{
					;~ msgbox % TableCodesArray[LanguageToParse,txtfile[TxtLineIndex,"code"]]
				;~ ExitApp
					NewTxt .= TableCodesArray[LanguageToParse,txtfile[TxtLineIndex,"code"]] a_tab ; name
				}
				else if  TableCodesArray["ENG",txtfile[TxtLineIndex,"code"]]!=""
					NewTxt .= TableCodesArray["ENG",txtfile[TxtLineIndex,"code"]] a_tab ; ENGLISH name
				Else
					NewTxt .= txtfile[TxtLineIndex,"name"] a_tab ; name stays unchanged
				;~ MsgBox % NewTxt
				continue
			}
			;~ if a_index != TxtHeadersSplit.length()
				NewTxt .=  TxtLine[TxtHeadersSplit[a_index]] a_tab
			;~ else
				;~ NewTxt .=  TxtLine[TxtHeadersSplit[a_index]]
		}
		StringTrimRight,NewTxt,NewTxt,1
		NewTxt .= "`r`n" ; EOL
	}
	FileDelete,%FileToSave%
	FileAppend,%NewTxt%,%FileToSave%
	return
}



;~ Digest_Txt110f_Runes()
;~ Digest_Txt110f_Gems()
;~ Digest_Txt110f_Runewords()
;~ Digest_Txt110f_Sets()
;~ Digest_Txt110f_Uniques()
;~ Digest_Txt110f_Merces()











































































;Basic template for lots of modules. See Digest_Txt_110f_armor for comments
;~ Digest_Txt_110f_armor(FileToParse,LanguageToParse,TableCodesArray,FileToSave)
;~ {
	;~ txtfile := ObjCSV_CSV2Collection(FileToParse,TxtHeaders,1,,,a_tab)
	;~ TxtHeadersSplit := (StrSplit(TxtHeaders,a_tab))
	;~ NewTxt :=
	;~ Loop, % TxtHeadersSplit.length()
	;~ {
		;~ TxtHeadersNoUnderscore := StrSplit(TxtHeadersSplit[a_index],"_")
		;~ NewTxt .= TxtHeadersNoUnderscore[1] A_Tab
	;~ }
	;~ StringTrimRight,NewTxt,NewTxt,1
	;~ NewTxt .= "`r`n"
	;~ Loop,% txtfile.length()
	;~ {
		;~ TxtLine := txtfile[a_index]
		;~ TxtLineIndex := a_index
		;~ Loop, % TxtHeadersSplit.length()
		;~ {
			;~ If Trim(TxtHeadersSplit[a_index]) = "ItemType"
			;~ {
				;~ if TableCodesArray[LanguageToParse,txtfile[TxtLineIndex,"code"]]!=""
				;~ {
					;~ NewTxt .= TableCodesArray[LanguageToParse,txtfile[TxtLineIndex,"code"]] a_tab ; name
				;~ }
				;~ else if  TableCodesArray["ENG",txtfile[TxtLineIndex,"code"]]!=""
					;~ NewTxt .= TableCodesArray["ENG",txtfile[TxtLineIndex,"code"]] a_tab ; ENGLISH name
				;~ Else
					;~ NewTxt .= txtfile[TxtLineIndex,"name"] a_tab ; name stays unchanged
				;~ continue
			;~ }
				;~ NewTxt .=  TxtLine[TxtHeadersSplit[a_index]] a_tab
		;~ }
		;~ StringTrimRight,NewTxt,NewTxt,1
		;~ NewTxt .= "`r`n" ; EOL
	;~ }
		;~ FileDelete,%FileToSave%
	;~ FileAppend,%NewTxt%,%FileToSave%
	;~ return
;~ }

;***********************************************************
;~ Function list follows.
;~ These are all present above.

;~ Digest_Txt110f_arena()
;~ Digest_Txt110f_armor()
;~ Digest_Txt110f_armtype()
;~ Digest_Txt110f_automagic()
;~ Digest_Txt110f_automap()
;~ Digest_Txt110f_belts()
;~ Digest_Txt110f_bodylocs()
;~ Digest_Txt110f_books()
;~ Digest_Txt110f_charstats()
;~ Digest_Txt110f_chartemplate()
;~ Digest_Txt110f_colors()
;~ Digest_Txt110f_compcode()
;~ Digest_Txt110f_composit()
;~ Digest_Txt110f_cubemain()
;~ Digest_Txt110f_cubemod()
;~ Digest_Txt110f_cubetype()
;~ Digest_Txt110f_DifficultyLevels()
;~ Digest_Txt110f_elemtypes()
;~ Digest_Txt110f_events()
;~ Digest_Txt110f_Experience()
;~ Digest_Txt110f_gamble()
;~ Digest_Txt110f_gems()
;~ Digest_Txt110f_hiredesc()
;~ Digest_Txt110f_hireling()
;~ Digest_Txt110f_hitclass()
;~ Digest_Txt110f_inventory()
;~ Digest_Txt110f_itemratio()
;~ Digest_Txt110f_itemscode()
;~ Digest_Txt110f_itemstatcost()
;~ Digest_Txt110f_itemtypes()
;~ Digest_Txt110f_levels()
;~ Digest_Txt110f_lowqualityitems()
;~ Digest_Txt110f_LvlMaze()
;~ Digest_Txt110f_lvlprest()
;~ Digest_Txt110f_LvlSub()
;~ Digest_Txt110f_lvltypes()
;~ Digest_Txt110f_LvlWarp()
;~ Digest_Txt110f_MagicPrefix()
;~ Digest_Txt110f_MagicSuffix()
;~ Digest_Txt110f_misc()
;~ Digest_Txt110f_MissCalc()
;~ Digest_Txt110f_misscode()
;~ Digest_Txt110f_missiles()
;~ Digest_Txt110f_monai()
;~ Digest_Txt110f_monequip()
;~ Digest_Txt110f_monitempercent()
;~ Digest_Txt110f_monlvl()
;~ Digest_Txt110f_monmode()
;~ Digest_Txt110f_monname()
;~ Digest_Txt110f_monplace()
;~ Digest_Txt110f_monpreset()
;~ Digest_Txt110f_monprop()
;~ Digest_Txt110f_monseq()
;~ Digest_Txt110f_monsounds()
;~ Digest_Txt110f_monstats()
;~ Digest_Txt110f_monstats2()
;~ Digest_Txt110f_montype()
;~ Digest_Txt110f_monumod()
;~ Digest_Txt110f_npc()
;~ Digest_Txt110f_objects()
;~ Digest_Txt110f_objgroup()
;~ Digest_Txt110f_objmode()
;~ Digest_Txt110f_objtype()
;~ Digest_Txt110f_overlay()
;~ Digest_Txt110f_pettype()
;~ Digest_Txt110f_playerclass()
;~ Digest_Txt110f_plrmode()
;~ Digest_Txt110f_plrtype()
;~ Digest_Txt110f_properties()
;~ Digest_Txt110f_qualityitems()
;~ Digest_Txt110f_RarePrefix()
;~ Digest_Txt110f_RareSuffix()
;~ Digest_Txt110f_runes()
;~ Digest_Txt110f_setitems()
;~ Digest_Txt110f_sets()
;~ Digest_Txt110f_shrines()
;~ Digest_Txt110f_skillcalc()
;~ Digest_Txt110f_skilldesc()
;~ Digest_Txt110f_skilldesccode()
;~ Digest_Txt110f_skills()
;~ Digest_Txt110f_skillscode()
;~ Digest_Txt110f_SoundEnviron()
;~ Digest_Txt110f_sounds()
;~ Digest_Txt110f_states()
;~ Digest_Txt110f_storepage()
;~ Digest_Txt110f_superuniques()
;~ Digest_Txt110f_treasureclass()
;~ Digest_Txt110f_TreasureClassEx()
;~ Digest_Txt110f_uniqueappellation()
;~ Digest_Txt110f_uniqueitems()
;~ Digest_Txt110f_uniqueprefix()
;~ Digest_Txt110f_uniquesuffix()
;~ Digest_Txt110f_uniquetitle()
;~ Digest_Txt110f_weaponclass()
;~ Digest_Txt110f_weapons()

;~ #Include DigestBinModules.ahk
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
;complete
Digest_Bin_110f_arena(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 28

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 28
		RecordID := a_index
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Suicide"] := Bin.ReadInt() 
		Record["PlayerKill"] := Bin.ReadInt() 
		Record["PlayerKillPercent"] := Bin.ReadInt() 
		Record["MonsterKill"] := Bin.ReadInt() 
		Record["PlayerDeath"] := Bin.ReadInt() 
		Record["PlayerDeathPercent"] := Bin.ReadInt() 
		Record["MonsterDeath"] := Bin.ReadInt()
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_armor(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 424

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 424
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["flippyfile"] := Trim(Bin.Read(32))
		Record["invfile"] := Trim(Bin.Read(32))
		Record["uniqueinvfile"] := Trim(Bin.Read(32))
		Record["setinvfile"] := Trim(Bin.Read(32))
		Record["code"] := Trim(Bin.Read(4))
		Record["normcode"] := Trim(Bin.Read(4))
		Record["ubercode"] := Trim(Bin.Read(4))
		Record["ultracode"] := Trim(Bin.Read(4))
		Record["alternategfx"] := Trim(Bin.Read(4))
		Record["iPadding37"] := Bin.ReadUInt() 
		Record["iPadding38"] := Bin.ReadUInt() 
		Record["iPadding39"] := Bin.ReadUInt() 
		Record["iPadding40"] := Bin.ReadUInt() 
		Record["iPadding41"] := Bin.ReadUInt() 
		Record["iPadding42"] := Bin.ReadUInt() 
		Record["iPadding43"] := Bin.ReadUInt() 
		Record["iPadding44"] := Bin.ReadUInt() 
		Record["iPadding45"] := Bin.ReadUInt() 
		Record["iPadding46"] := Bin.ReadUInt() 
		Record["iPadding47"] := Bin.ReadUInt() 
		Record["iPadding48"] := Bin.ReadUInt() 
		Record["iPadding49"] := Bin.ReadUInt() 
		Record["iPadding50"] := Bin.ReadUInt() 
		Record["minac"] := Bin.ReadUInt() 
		Record["maxac"] := Bin.ReadUInt() 
		Record["gamble cost"] := Bin.ReadUInt() 
		Record["speed"] := Bin.ReadUInt() 
		Record["bitfield1"] := Bin.ReadUInt() 
		Record["cost"] := Bin.ReadUInt() 
		Record["minstack"] := Bin.ReadUInt() 
		Record["maxstack"] := Bin.ReadUInt() 
		Record["iPadding59"] := Bin.ReadUInt() 
		Record["gemoffset"] := Bin.ReadUInt() 
		Record["namestr"] := Bin.ReadUShort() 
		Record["version"] := Bin.ReadUChar() 
		Record["iPadding61"] := Bin.ReadUChar() 
		Record["auto prefix"] := Bin.ReadUShort() 
		Record["missiletype"] := Bin.ReadUShort() 
		Record["rarity"] := Bin.ReadUChar() 
		Record["level"] := Bin.ReadUChar() 
		Record["mindam"] := Bin.ReadUChar() 
		Record["maxdam"] := Bin.ReadUChar() 
		Record["iPadding64"] := Bin.ReadUInt() 
		Record["iPadding65"] := Bin.ReadUShort() 
		Record["StrBonus"] := Bin.ReadUShort() 
		Record["DexBonus"] := Bin.ReadUShort() 
		Record["reqstr"] := Bin.ReadUShort() 
		Record["reqdex"] := Bin.ReadUShort() 
		Record["absorbs"] := Bin.ReadUChar() 
		Record["invwidth"] := Bin.ReadUChar() 
		Record["invheight"] := Bin.ReadUChar() 
		Record["block"] := Bin.ReadUChar() 
		Record["durability"] := Bin.ReadUChar() 
		Record["nodurability"] := Bin.ReadUChar() 
		Record["iPadding69"] := Bin.ReadUChar() 
		Record["component"] := Bin.ReadUChar() 
		Record["rArm"] := Bin.ReadUChar() 
		Record["lArm"] := Bin.ReadUChar() 
		Record["Torso"] := Bin.ReadUChar() 
		Record["Legs"] := Bin.ReadUChar() 
		Record["rSPad"] := Bin.ReadUChar() 
		Record["lSPad"] := Bin.ReadUChar() 
		Record["iPadding71"] := Bin.ReadUChar() 
		Record["useable"] := Bin.ReadUChar() 
		Record["type"] := Bin.ReadUShort() 
		Record["type2"] := Bin.ReadUShort() 
		Record["iPadding72"] := Bin.ReadUShort() 
		Record["dropsound"] := Bin.ReadUShort() 
		Record["usesound"] := Bin.ReadUShort() 
		Record["dropsfxframe"] := Bin.ReadUChar() 
		Record["unique"] := Bin.ReadUChar() 
		Record["quest"] := Bin.ReadUShort() 
		Record["transparent"] := Bin.ReadUChar() 
		Record["transtbl"] := Bin.ReadUChar() 
		Record["iPadding75"] := Bin.ReadUChar() 
		Record["lightradius"] := Bin.ReadUChar() 
		Record["belt"] := Bin.ReadUShort() 
		Record["stackable"] := Bin.ReadUChar() 
		Record["spawnable"] := Bin.ReadUChar() 
		Record["iPadding77"] := Bin.ReadUChar() 
		Record["durwarning"] := Bin.ReadUChar() 
		Record["qntwarning"] := Bin.ReadUChar() 
		Record["hasinv"] := Bin.ReadUChar() 
		Record["gemsockets"] := Bin.ReadUChar() 
		Record["iPadding78"] := Trim(Bin.Read(3))
		Record["iPadding79"] := Trim(Bin.Read(2))
		Record["gemapplytype"] := Bin.ReadUChar() 
		Record["levelreq"] := Bin.ReadUChar() 
		Record["magic lvl"] := Bin.ReadUChar() 
		Record["Transform"] := Bin.ReadUChar() 
		Record["InvTrans"] := Bin.ReadUChar() 
		Record["compactsave"] := Bin.ReadUChar() 
		Record["SkipName"] := Bin.ReadUChar() 
		Record["nameable"] := Bin.ReadUChar() 
		Record["AkaraMin"] := Bin.ReadUChar() 
		Record["GheedMin"] := Bin.ReadUChar() 
		Record["CharsiMin"] := Bin.ReadUChar() 
		Record["FaraMin"] := Bin.ReadUChar() 
		Record["LysanderMin"] := Bin.ReadUChar() 
		Record["DrognanMin"] := Bin.ReadUChar() 
		Record["HraltiMin"] := Bin.ReadUChar() 
		Record["AlkorMin"] := Bin.ReadUChar() 
		Record["OrmusMin"] := Bin.ReadUChar() 
		Record["ElzixMin"] := Bin.ReadUChar() 
		Record["AshearaMin"] := Bin.ReadUChar() 
		Record["CainMin"] := Bin.ReadUChar() 
		Record["HalbuMin"] := Bin.ReadUChar() 
		Record["JamellaMin"] := Bin.ReadUChar() 
		Record["MalahMin"] := Bin.ReadUChar() 
		Record["LarzukMin"] := Bin.ReadUChar() 
		Record["DrehyaMin"] := Bin.ReadUChar() 
		Record["AkaraMax"] := Bin.ReadUChar() 
		Record["GheedMax"] := Bin.ReadUChar() 
		Record["CharsiMax"] := Bin.ReadUChar() 
		Record["FaraMax"] := Bin.ReadUChar() 
		Record["LysanderMax"] := Bin.ReadUChar() 
		Record["DrognanMax"] := Bin.ReadUChar() 
		Record["HraltiMax"] := Bin.ReadUChar() 
		Record["AlkorMax"] := Bin.ReadUChar() 
		Record["OrmusMax"] := Bin.ReadUChar() 
		Record["ElzixMax"] := Bin.ReadUChar() 
		Record["AshearaMax"] := Bin.ReadUChar() 
		Record["CainMax"] := Bin.ReadUChar() 
		Record["HalbuMax"] := Bin.ReadUChar() 
		Record["JamellaMax"] := Bin.ReadUChar() 
		Record["MalahMax"] := Bin.ReadUChar() 
		Record["LarzukMax"] := Bin.ReadUChar() 
		Record["DrehyaMax"] := Bin.ReadUChar() 
		Record["AkaraMagicMin"] := Bin.ReadUChar() 
		Record["GheedMagicMin"] := Bin.ReadUChar() 
		Record["CharsiMagicMin"] := Bin.ReadUChar() 
		Record["FaraMagicMin"] := Bin.ReadUChar() 
		Record["LysanderMagicMin"] := Bin.ReadUChar() 
		Record["DrognanMagicMin"] := Bin.ReadUChar() 
		Record["HraltiMagicMin"] := Bin.ReadUChar() 
		Record["AlkorMagicMin"] := Bin.ReadUChar() 
		Record["OrmusMagicMin"] := Bin.ReadUChar() 
		Record["ElzixMagicMin"] := Bin.ReadUChar() 
		Record["AshearaMagicMin"] := Bin.ReadUChar() 
		Record["CainMagicMin"] := Bin.ReadUChar() 
		Record["HalbuMagicMin"] := Bin.ReadUChar() 
		Record["JamellaMagicMin"] := Bin.ReadUChar() 
		Record["MalahMagicMin"] := Bin.ReadUChar() 
		Record["LarzukMagicMin"] := Bin.ReadUChar() 
		Record["DrehyaMagicMin"] := Bin.ReadUChar() 
		Record["AkaraMagicMax"] := Bin.ReadUChar() 
		Record["GheedMagicMax"] := Bin.ReadUChar() 
		Record["CharsiMagicMax"] := Bin.ReadUChar() 
		Record["FaraMagicMax"] := Bin.ReadUChar() 
		Record["LysanderMagicMax"] := Bin.ReadUChar() 
		Record["DrognanMagicMax"] := Bin.ReadUChar() 
		Record["HraltiMagicMax"] := Bin.ReadUChar() 
		Record["AlkorMagicMax"] := Bin.ReadUChar() 
		Record["OrmusMagicMax"] := Bin.ReadUChar() 
		Record["ElzixMagicMax"] := Bin.ReadUChar() 
		Record["AshearaMagicMax"] := Bin.ReadUChar() 
		Record["CainMagicMax"] := Bin.ReadUChar() 
		Record["HalbuMagicMax"] := Bin.ReadUChar() 
		Record["JamellaMagicMax"] := Bin.ReadUChar() 
		Record["MalahMagicMax"] := Bin.ReadUChar() 
		Record["LarzukMagicMax"] := Bin.ReadUChar() 
		Record["DrehyaMagicMax"] := Bin.ReadUChar() 
		Record["AkaraMagicLvl"] := Bin.ReadUChar() 
		Record["GheedMagicLvl"] := Bin.ReadUChar() 
		Record["CharsiMagicLvl"] := Bin.ReadUChar() 
		Record["FaraMagicLvl"] := Bin.ReadUChar() 
		Record["LysanderMagicLvl"] := Bin.ReadUChar() 
		Record["DrognanMagicLvl"] := Bin.ReadUChar() 
		Record["HraltiMagicLvl"] := Bin.ReadUChar() 
		Record["AlkorMagicLvl"] := Bin.ReadUChar() 
		Record["OrmusMagicLvl"] := Bin.ReadUChar() 
		Record["ElzixMagicLvl"] := Bin.ReadUChar() 
		Record["AshearaMagicLvl"] := Bin.ReadUChar() 
		Record["CainMagicLvl"] := Bin.ReadUChar() 
		Record["HalbuMagicLvl"] := Bin.ReadUChar() 
		Record["JamellaMagicLvl"] := Bin.ReadUChar() 
		Record["MalahMagicLvl"] := Bin.ReadUChar() 
		Record["LarzukMagicLvl"] := Bin.ReadUChar() 
		Record["DrehyaMagicLvl"] := Bin.ReadUChar() 
		Record["iPadding102"] := Bin.ReadUChar() 
		Record["NightmareUpgrade"] := Trim(Bin.Read(4))
		Record["HellUpgrade"] := Trim(Bin.Read(4))
		Record["iPadding105"] := Bin.ReadUInt()
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		
		Kill=AkaraMin,GheedMin,CharsiMin,FaraMin,LysanderMin,DrognanMin,HraltiMin,AlkorMin,OrmusMin,ElzixMin,AshearaMin,CainMin,HalbuMin,JamellaMin,MalahMin,LarzukMin,DrehyaMin,AkaraMax,GheedMax,CharsiMax,FaraMax,LysanderMax,DrognanMax,HraltiMax,AlkorMax,OrmusMax,ElzixMax,AshearaMax,CainMax,HalbuMax,JamellaMax,MalahMax,LarzukMax,DrehyaMax,AkaraMagicMin,GheedMagicMin,CharsiMagicMin,FaraMagicMin,LysanderMagicMin,DrognanMagicMin,HraltiMagicMin,AlkorMagicMin,OrmusMagicMin,ElzixMagicMin,AshearaMagicMin,CainMagicMin,HalbuMagicMin,JamellaMagicMin,MalahMagicMin,LarzukMagicMin,DrehyaMagicMin,AkaraMagicMax,GheedMagicMax,CharsiMagicMax,FaraMagicMax,LysanderMagicMax,DrognanMagicMax,HraltiMagicMax,AlkorMagicMax,OrmusMagicMax,ElzixMagicMax,AshearaMagicMax,CainMagicMax,HalbuMagicMax,JamellaMagicMax,MalahMagicMax,LarzukMagicMax,DrehyaMagicMax,iPadding|100,absorbs,auto prefix,belt,block,compactsave,component,gemsockets,legs,lightradius,maxdam,maxstack,mindam,minstack,missletype,nodurability,qntwarning,quest,
		RecordKill(Record,Kill,0)
		
		Kill=iPadding|105
		RecordKill(Record,Kill,"")
		
		Kill=AkaraMagicLvl,GheedMagicLvl,CharsiMagicLvl,FaraMagicLvl,LysanderMagicLvl,DrognanMagicLvl,HraltiMagicLvl,AlkorMagicLvl,OrmusMagicLvl,ElzixMagicLvl,AshearaMagicLvl,CainMagicLvl,HalbuMagicLvl,JamellaMagicLvl,MalahMagicLvl,LarzukMagicLvl,DrehyaMagicLvl
		RecordKill(Record,Kill,255)
		
		Kill=iPadding|105
		RecordKill(Record,Kill,4294967295)
		
		Kill=NightmareUpgrade,HellUpgrade
		RecordKill(Record,Kill,"xxx")
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_armtype(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 52

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 52
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Name"] := Bin.Read(32) 
		Record["Token"] := Bin.Read(20)
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_automagic(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 144

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 144
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Name"] := Bin.Read(32) 
		Record["TblIndex"] := Bin.ReadUShort() 
		Record["version"] := Bin.ReadUShort() 
		Record["mod1code"] := Bin.ReadUInt() 
		Record["mod1param"] := Bin.ReadUInt() 
		Record["mod1min"] := Bin.ReadUInt() 
		Record["mod1max"] := Bin.ReadUInt() 
		Record["mod2code"] := Bin.ReadUInt() 
		Record["mod2param"] := Bin.ReadUInt() 
		Record["mod2min"] := Bin.ReadUInt() 
		Record["mod2max"] := Bin.ReadUInt() 
		Record["mod3code"] := Bin.ReadUInt() 
		Record["mod3param"] := Bin.ReadUInt() 
		Record["mod3min"] := Bin.ReadUInt() 
		Record["mod3max"] := Bin.ReadUInt() 
		Record["spawnable"] := Bin.ReadUChar() 
		Record["iPadding21"] := Bin.ReadUChar() 
		Record["transformcolor"] := Bin.ReadUShort() 
		Record["level"] := Bin.ReadUInt() 
		Record["group"] := Bin.ReadUInt() 
		Record["maxlevel"] := Bin.ReadUInt() 
		Record["rare"] := Bin.ReadUChar() 
		Record["levelreq"] := Bin.ReadUChar() 
		Record["classspecific"] := Bin.ReadUChar() 
		Record["class"] := Bin.ReadUChar() 
		Record["classlevelreq"] := Bin.ReadUShort() 
		Record["itype1"] := Bin.ReadUShort() 
		Record["itype2"] := Bin.ReadUShort() 
		Record["itype3"] := Bin.ReadUShort() 
		Record["itype4"] := Bin.ReadUShort() 
		Record["itype5"] := Bin.ReadUShort() 
		Record["itype6"] := Bin.ReadUShort() 
		Record["itype7"] := Bin.ReadUShort() 
		Record["etype1"] := Bin.ReadUShort() 
		Record["etype2"] := Bin.ReadUShort() 
		Record["etype3"] := Bin.ReadUShort() 
		Record["etype4"] := Bin.ReadUShort() 
		Record["etype5"] := Bin.ReadUShort() 
		Record["frequency"] := Bin.ReadUShort() 
		Record["divide"] := Bin.ReadUInt() 
		Record["multiply"] := Bin.ReadUInt() 
		Record["add"] := Bin.ReadUInt()
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		
		Kill=itype|7,etype|5
		RecordKill(Record,kill,0)
		
		Kill=itype|7,etype|5
		RecordKill(Record,kill,65535)
		
		Kill=mod$code|15
		KillDepend=mod$param,mod$min,mod$max
		RecordKill(Record,kill,4294967295,KillDepend,,"$")
		
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_automap(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 44

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 44
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["LevelName"] := Bin.Read(16) 
		Record["TileName"] := Bin.Read(8) 
		Record["Style"] := Bin.ReadUChar() 
		Record["StartSequence"] := Bin.ReadChar() 
		Record["EndSequence"] := Bin.ReadChar() 
		Record["Padding6"] := Bin.ReadUChar() 
		Loop,4
			Record["Cel" a_index] := Bin.ReadInt() 
		
		Kill=cel|4
		RecordKill(Record,kill,-1)
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_belts(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 264

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 264
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Id"] := Bin.ReadUInt() 
		Record["numboxes"] := Bin.ReadUInt() 
		Loop,16
		{
			Record["box" a_index "left"] := Bin.ReadUInt() 
			Record["box" a_index "right"] := Bin.ReadUInt() 
			Record["box" a_index "top"] := Bin.ReadUInt() 
			Record["box" a_index "bottom"] := Bin.ReadUInt() 
		}
		
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_bodylocs(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 4

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 4
		RecordID := a_index
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_books(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 32

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 32
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Name"] := Bin.ReadUShort() 
		Record["SpellIcon"] := Bin.ReadChar() 
		Record["iPadding0"] := Bin.ReadUChar() 
		Record["pSpell"] := Bin.ReadUInt() 
		Record["ScrollSkill"] := Bin.ReadUInt() 
		Record["BookSkill"] := Bin.ReadUInt() 
		Record["BaseCost"] := Bin.ReadUInt() 
		Record["CostPerCharge"] := Bin.ReadUInt() 
		Record["ScrollSpellCode"] := Bin.Read(4) 
		Record["BookSpellCode"] := Bin.Read(4)
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_charstats(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 196
	SkillTabNum := 0
	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 196
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["head"] := Bin.Read(32)
		Record["class"] := Bin.Read(16)
		Record["str"] := Bin.ReadUChar() 
		Record["dex"] := Bin.ReadUChar() 
		Record["int"] := Bin.ReadUChar() 
		Record["vit"] := Bin.ReadUChar() 
		Record["stamina"] := Bin.ReadUChar() 
		Record["hpadd"] := Bin.ReadUChar() 
		Record["PercentStr"] := Bin.ReadUChar() 
		Record["PercentInt"] := Bin.ReadUChar() 
		Record["PercentDex"] := Bin.ReadUChar() 
		Record["PercentVit"] := Bin.ReadUChar() 
		Record["ManaRegen"] := Bin.ReadUChar() 
		Record["bUnknown"] := Bin.ReadUChar() 
		Record["ToHitFactor"] := Bin.ReadInt() 
		Record["WalkVelocity"] := Bin.ReadUChar() 
		Record["RunVelocity"] := Bin.ReadUChar() 
		Record["RunDrain"] := Bin.ReadUChar() 
		Record["LifePerLevel"] := Bin.ReadUChar() 
		Record["StaminaPerLevel"] := Bin.ReadUChar() 
		Record["ManaPerLevel"] := Bin.ReadUChar() 
		Record["LifePerVitality"] := Bin.ReadUChar() 
		Record["StaminaPerVitality"] := Bin.ReadUChar() 
		Record["ManaPerMagic"] := Bin.ReadUChar() 
		Record["BlockFactor"] := Bin.ReadUChar() 
		Record["acPadding"] := Bin.Read(2) 
		Record["baseWClass"] := Bin.Read(4)
		Record["StatPerLevel"] := Bin.ReadUChar() 
		Record["iPadding1"] := Bin.ReadUChar() 
		Record["StrAllSkills"] := Bin.ReadUShort() 
		
		Record["StrSkillTab1"] := Bin.ReadUShort() 
		Digest[ModFullName,"Recompile","SkillTab",SkillTabNum] := Record["StrSkillTab1"]
		Digest[ModFullName,"Recompile","SkillTab",SkillTabNum " class"] := Record["class"]
		SkillTabNum := SkillTabNum + 1
		
		Record["StrSkillTab2"] := Bin.ReadUShort() 
		Digest[ModFullName,"Recompile","SkillTab",SkillTabNum] := Record["StrSkillTab2"]
		Digest[ModFullName,"Recompile","SkillTab",SkillTabNum " class"] := Record["class"]
		SkillTabNum := SkillTabNum + 1
		
		Record["StrSkillTab3"] := Bin.ReadUShort() 
		Digest[ModFullName,"Recompile","SkillTab",SkillTabNum] := Record["StrSkillTab3"]
		Digest[ModFullName,"Recompile","SkillTab",SkillTabNum " class"] := Record["class"]
		SkillTabNum := SkillTabNum + 1
		
		Record["StrClassOnly"] := Bin.ReadUShort() 
		Loop,10
		{
			Record["item" a_index] := Bin.Read(4)
			Record["item" a_index "loc"] := Bin.ReadUChar() 
			Record["item" a_index "count"] := Bin.ReadUChar() 
			Bin.Read(2)
		}
		Record["StartSkill"] := Bin.ReadUShort() 
		Loop, 10
			Record["Skill " a_index] := Bin.ReadUShort() 
		
		Record["acTail"] := Bin.read(2)
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		
		Kill=Skill|10
		RecordKill(Record,kill,0)
		
		Kill=item$|15
		KillDepend=item$loc,item$count
		RecordKill(Record,kill,"    ",KillDepend,,"$")
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_chartemplate(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 240

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 240
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Name"] := Bin.Read(30) 
		Record["Class"] := Bin.ReadUChar() 
		Record["Level"] := Bin.ReadUChar() 
		Record["Act"] := Bin.ReadUChar() 
		Record["str"] := Bin.ReadUChar() 
		Record["dex"] := Bin.ReadUChar() 
		Record["int"] := Bin.ReadUChar() 
		Record["vit"] := Bin.ReadUChar() 
		Record["Mana"] := Bin.ReadUChar() 
		Record["Hitpoints"] := Bin.ReadUChar() 
		Record["ManaRegenBonus"] := Bin.ReadUChar() 
		Record["Velocity"] := Bin.ReadUChar() 
		Record["AttackRate"] := Bin.ReadUChar() 
		Record["OtherRate"] := Bin.ReadUShort() 
		Record["RightSkill"] := Bin.ReadUInt() 
		Loop,9
			Record["Skill" a_index] := Bin.ReadUInt() 
		Record["Skill2"] := Bin.ReadUInt() 
		Record["Skill3"] := Bin.ReadUInt() 
		Record["Skill4"] := Bin.ReadUInt() 
		Record["Skill5"] := Bin.ReadUInt() 
		Record["Skill6"] := Bin.ReadUInt() 
		Record["Skill7"] := Bin.ReadUInt() 
		Record["Skill8"] := Bin.ReadUInt() 
		Record["Skill9"] := Bin.ReadUInt() 
		Loop, 9
			Record["SkillLevel" a_index] := Bin.ReadUInt() 
		Record["SkillLevel2"] := Bin.ReadUInt() 
		Record["SkillLevel3"] := Bin.ReadUInt() 
		Record["SkillLevel4"] := Bin.ReadUInt() 
		Record["SkillLevel5"] := Bin.ReadUInt() 
		Record["SkillLevel6"] := Bin.ReadUInt() 
		Record["SkillLevel7"] := Bin.ReadUInt() 
		Record["SkillLevel8"] := Bin.ReadUInt() 
		Record["SkillLevel9"] := Bin.ReadUInt() 
		Loop,15
		{
			Record["item" a_index] := Bin.Read(4) 
			Record["item" a_index "loc"] := Bin.ReadUChar() 
			Record["item" a_index "count"] := Bin.ReadUChar() 
			Record["iPadding31"] := 
	Bin.ReadUShort() 
		}
		Record["item2"] := Bin.Read(4) 
		Record["item2loc"] := Bin.ReadUChar() 
		Record["item2count"] := Bin.ReadUChar() 
		Record["iPadding33"] := Bin.ReadUShort() 
		Record["item3"] := Bin.Read(4) 
		Record["item3loc"] := Bin.ReadUChar() 
		Record["item3count"] := Bin.ReadUChar() 
		Record["iPadding35"] := Bin.ReadUShort() 
		Record["item4"] := Bin.Read(4) 
		Record["item4loc"] := Bin.ReadUChar() 
		Record["item4count"] := Bin.ReadUChar() 
		Record["iPadding37"] := Bin.ReadUShort() 
		Record["item5"] := Bin.Read(4) 
		Record["item5loc"] := Bin.ReadUChar() 
		Record["item5count"] := Bin.ReadUChar() 
		Record["iPadding39"] := Bin.ReadUShort() 
		Record["item6"] := Bin.Read(4) 
		Record["item6loc"] := Bin.ReadUChar() 
		Record["item6count"] := Bin.ReadUChar() 
		Record["iPadding41"] := Bin.ReadUShort() 
		Record["item7"] := Bin.Read(4) 
		Record["item7loc"] := Bin.ReadUChar() 
		Record["item7count"] := Bin.ReadUChar() 
		Record["iPadding43"] := Bin.ReadUShort() 
		Record["item8"] := Bin.Read(4) 
		Record["item8loc"] := Bin.ReadUChar() 
		Record["item8count"] := Bin.ReadUChar() 
		Record["iPadding45"] := Bin.ReadUShort() 
		Record["item9"] := Bin.Read(4) 
		Record["item9loc"] := Bin.ReadUChar() 
		Record["item9count"] := Bin.ReadUChar() 
		Record["iPadding47"] := Bin.ReadUShort() 
		Record["item10"] := Bin.Read(4) 
		Record["item10loc"] := Bin.ReadUChar() 
		Record["item10count"] := Bin.ReadUChar() 
		Record["iPadding49"] := Bin.ReadUShort() 
		Record["item11"] := Bin.Read(4) 
		Record["item11loc"] := Bin.ReadUChar() 
		Record["item11count"] := Bin.ReadUChar() 
		Record["iPadding51"] := Bin.ReadUShort() 
		Record["item12"] := Bin.Read(4) 
		Record["item12loc"] := Bin.ReadUChar() 
		Record["item12count"] := Bin.ReadUChar() 
		Record["iPadding53"] := Bin.ReadUShort() 
		Record["item13"] := Bin.Read(4) 
		Record["item13loc"] := Bin.ReadUChar() 
		Record["item13count"] := Bin.ReadUChar() 
		Record["iPadding55"] := Bin.ReadUShort() 
		Record["item14"] := Bin.Read(4) 
		Record["item14loc"] := Bin.ReadUChar() 
		Record["item14count"] := Bin.ReadUChar() 
		Record["iPadding57"] := Bin.ReadUShort() 
		Record["item15"] := Bin.Read(4) 
		Record["item15loc"] := Bin.ReadUChar() 
		Record["item15count"] := Bin.ReadUChar() 
		Record["iPadding59"] := Bin.ReadUShort()
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		Kill=Skill|9,SkillLevel|9
		RecordKill(Record,kill,0)
		
		Kill=item$|15
		KillDepend=item$loc,item$count
		RecordKill(Record,kill,0,KillDepend,,"$")
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_colors(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 4

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 4
		RecordID := a_index
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_compcode(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 4

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 4
		RecordID := a_index
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_composit(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 52

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 52
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Name"] := Bin.Read(32) 
		Record["Token"] := Bin.Read(20)
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_cubemain(BinToDecompile)
{
	global
	
	MODNUM=1
	
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Seek(4)
	RecordSize := 328
	;~ msgbox % Digest.GetCapacity()
	
	;~ msgbox % Digest.GetCapacity()
	
	QualityList :=strsplit("low,nor,hiq,mag,set,rar,uni,crf,tmp",",")
	
	;~ MsgBox % (Bin.Length  - 4) / RecordSize
	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 1000 ) OR if (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 328
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["ModNum"] := ModNum ; For DBA
		Record["RecordID"] := RecordID ; For DBA
		
		Record["enabled"] := Bin.ReadUChar() 
		Record["ladder"] := Bin.ReadUChar() 
		Record["min diff"] := Bin.ReadUChar() 
		Record["class"] := Bin.ReadUChar() 
		Record["op"] := Bin.ReadUInt() 
		Record["param"] := Bin.ReadUInt() 
		Record["value"] := Bin.ReadUInt() 
		Record["numinputs"] := Bin.ReadUShort() 
		Record["version"] := Bin.ReadUShort() 
		
		/*
			BEGIN BITFIELD OPERATIONS
		*/
		Loop,7
		{
			ItemIndex := a_index
			Record["input " ItemIndex " Input Flags"] := ToBin(Bin.ReadUChar(),2)
			Record["input " ItemIndex " Item Type"] := ToBin(Bin.ReadUChar(),2)
			Record["input " ItemIndex " Input"] := Bin.ReadUShort()
			Record["input " ItemIndex " Input ID"] := Bin.ReadUShort()
			Record["input " ItemIndex " Quality"] := Bin.ReadUChar()
			Record["input " ItemIndex " Quantity"] := Bin.ReadUChar()
			
				;~ BYTE nInputFlags;               //0x00
				;~ 1	upg		upgrades item (nor>exc>eli)
				;~ 2			itemcode (for consumables?) 
				;~ 3	noe		Non etheral only
				;~ 4	eth		Etheral only
				;~ 5	sock	Socketed only
				;~ 6	nos		Non socketed only
				;~ 7	*		unique or set item directly referenced ( by name )
				;~ 8	any		use any item of this type
			
			
				;~ BYTE nItemType;                  //0x01
				;~ 1	*N/A*	
				;~ 2	*N/A*
				;~ 3	*N/A*
				;~ 4	*N/A*
				;~ 5	nru		no runes
				;~ 6	eli		elite tier
				;~ 7	exc		exceptional tier
				;~ 8	bas		basic tier
				;~ if (input " ItemIndex " =1) AND (substr(Record["input " ItemIndex " Input Flags"],4,1) !=0)
			;~ msgbox % Record["input " ItemIndex " Input Flags"] "`n" RecordID+1
			
			
				;~ WORD wItem;                     //0x02
			
			
				;~ WORD wItemID;                  //0x04
			
			
				;~ BYTE nQuality;                  //0x06
				;~ controls the required item type of this input
				;~ 00	(no special properties required)
				;~ 01	low
				;~ 02	nor
				;~ 03	hiq
				;~ 04	mag
				;~ 05	set
				;~ 06	rar
				;~ 07	uni
				;~ 08	crf
				;~ 09	tmp
			
			
				;~ BYTE nQuantity;                  //0x07
				;~ Controls the qty=x parameter
				;~ Single digit that corresponds directly to the 0-255 number
				;~ but! if the input exists (ie, you are calling for this input) then a 0 is treated as a defacto 1 in the game.
			
			
			;Properties order: Input OR ITEMID, any, eli|exc|bas, eth|noe, Quality, upg, sock|nos, nru, qty
			/*
				Input
			*/
			If Record["input " ItemIndex " Input ID"] !=0
			{
				Record["input " ItemIndex] := "INPUTID " Record["input " ItemIndex " Input ID"]
			}
			else if Record["input " ItemIndex " Input"] !=0
			{
				Record["input " ItemIndex] := "INPUT " Record["input " ItemIndex " Input"]
				If Record["input " ItemIndex] = "INPUT 65535"
					Record["input " ItemIndex] := "any"
			}
			else
				Record["input " ItemIndex] := ""
					;~ continue
			
			
			/*
				eli|exc|bas
			*/
			If SubStr(Record["input " ItemIndex " Item Type"],6,1)=1
				Record["input " ItemIndex] .= ",eli"
			else If SubStr(Record["input " ItemIndex " Item Type"],7,1)=1
				Record["input " ItemIndex] .= ",exc"
			else If SubStr(Record["input " ItemIndex " Item Type"],8,1)=1
				Record["input " ItemIndex] .= ",bas"
			
			/*
				Quality
			*/
			if  QualityList[Record["input " ItemIndex " Quality"]] > 0
				Record["input " ItemIndex] .= "," QualityList[Record["input " ItemIndex " Quality"]]
			
			/*
				eth|noe
			*/
			If SubStr(Record["input " ItemIndex " Input Flags"],3,1) = 1
				Record["input " ItemIndex] .= ",noe"
			else if SubStr(Record["input " ItemIndex " Input Flags"],4,1) =1
				Record["input " ItemIndex] .= ",eth"
			
			/*
				sock|nos
			*/
			If SubStr(Record["input " ItemIndex " Input Flags"],5,1) = 1
				Record["input " ItemIndex] .= ",sock"
			else if SubStr(Record["input " ItemIndex " Input Flags"],6,1) = 1 
				Record["input " ItemIndex] .= ",nos"
			
			/*
				nru
			*/
			If substr(Record["input " ItemIndex " Item Type"],5,1) = 1 
				Record["input " ItemIndex] .= ",nru"
			/*
				qty
			*/
			If Record["input " ItemIndex " Quantity"] > 0
				Record["input " ItemIndex] .= ",qty=" Record["input " ItemIndex " Quantity"]
			
			/*
				any
			*/
			
			
			If (SubStr(Record["input " ItemIndex " Input Flags"],8,1) = 1)
				Record["input " ItemIndex] .= ",any"
			if StrSplit(Record["input " ItemIndex],",").length() > 1
				Record["input " ItemIndex] := """" Record["input " ItemIndex] """"
			;~ if StrSplit(Record["input " ItemIndex],",").length() > 0
				;~ If (SubStr(Record["input " ItemIndex " Input Flags"],2,1) = 1)
				;~ if InStr(Record["input " ItemIndex],"any")
				;~ if !InStr(Record["input " ItemIndex],",qty=")
				;~ if Record["input " itemindex] != ""
			;~ testarr[recordid+1,a_index] := Record["input " itemindex]
		}
		;~ Loop,7
		;~ testarr[recordid+1] := Record["input 2"]
		/*
			CEASE BITFIELD OPERATIONS
		*/
		
		
		
		
		
		
		
		
		
		
		;~ RecordID+1 is used to align the record number with the row number as viewed in AFJ Sheet.
		;~ If you are using a viewer that does not count the header row as row 1 you can safely remove the +1
		
		;~ The number in the "Literal String" is used only to visually order the bytes and holds no special meaning.
		;~ */
		;~ testarr[RecordID+1,"1 - Input Flags"] := ToBin(Bin.ReadUChar(),2) ; ToBin() converts the input byte(s) into a binary string
		;~ testarr[RecordID+1,"2 - 
		;~ testarr[RecordID+1,"2 - Item Type"] := Bin.ReadUChar()
		;~ if testarr[RecordID+1,"2 - Item Type"] = 0
			;~ testarr[RecordID+1,"2 - Item Type"] := []
		
		;~ testarr[RecordID+1,"3 - 
		;~ testarr[RecordID+1,"4 - 
		;~ If testarr[RecordID+1,"4 - Input ID"] = 0
			;~ testarr[RecordID+1,"4 - Input ID"] := [] ; blank the array element and remove the ability to expand if there's nothing to see.
		
		;~ testarr[RecordID+1,"5 - 
		;~ if testarr[RecordID+1,"5 - Quality"] = 0
			;~ testarr[RecordID+1,"5 - Quality"] := []
		
		;~ testarr[RecordID+1,"6 - 
		;~ If testarr[RecordID+1,"6 - Quantity"] = 0
			;~ testarr[RecordID+1,"6 - Quantity"] := []
		
		;Set Flags to the particular variable you are working with.
		;~ Flags := testarr[RecordID+1,"1 - Input Flags"]
		;~ Flags := testarr[RecordID+1,"2 - Item Type"]
		;~ Flags := testarr[RecordID+1,"3 - Input"]
		;~ Flags := testarr[RecordID+1,"4 - Input ID"]
		;~ Flags := testarr[RecordID+1,"5 - Quality"]
		;~ Flags := testarr[RecordID+1,"6 - Quantity"]
		
		;SubStr() retrieves a particular char/set of chars in the string.
		;In this instance, it is used to pull a certain flag and remove all array keys that don't match.
		;SubStr(String, StartingPos [, Length])
		;~ If Flags = 
		;~ If (substr(Flags,2,1)  != 1)
		;~ {
			;~ testarr.pop()
		;~ }
		/*
			
			
			enum CUBEIN_FLAGS
			{
			;byte1
				CUBEFLAG_IN_USEANY        = 1,    // any
				CUBEFLAG_IN_ITEMCODE    = 2,
				CUBEFLAG_IN_NOSOCKET    = 4,    // nos
				CUBEFLAG_IN_SOCKETED    = 8,    // sock
				CUBEFLAG_IN_ETHEREAL    = 16,    // eth
				CUBEFLAG_IN_NOETHEREAL    = 32,    // noe
				CUBEFLAG_IN_SPECIAL        = 64,    // unique or set item directly referenced ( by name )
				CUBEFLAG_IN_UPGRADED     = 128,    // upg
			;byte2
				CUBEFLAG_IN_NORMAL        = 256,    // bas
				CUBEFLAG_IN_EXCEPTIONAL    = 512,    // exc
				CUBEFLAG_IN_ELITE        = 1024,    // eli
				CUBEFLAG_IN_NORUNES        = 2048,    // nru
				// 4096 - 32768 aren't used
			};
			
			
		*/
		
		for Index, oABC in ["", "b ", "c "]
		{
			Record[oABC "output"] := ""
			/*
				struct D2CubeOutputItem
				{
					BYTE nItemFlags;               //0x00
					1	mod			CUBEFLAG_COPYMODS
					2	sock		CUBEFLAG_SOCKET
					3	eth			CUBEFLAG_ETHEREAL
					4	*			CUBEFLAG_SPECIAL
					5	uns			CUBEFLAG_UNSOCKET
					6	rem			CUBEFLAG_REMOVE
					7	reg			CUBEFLAG_NORMAL
					8	exc			CUBEFLAG_EXEPTIONAL
					BYTE nItemType;                  //0x01
					1	eli			CUBEFLAG_ELITE
					2	rep			CUBEFLAG_REPAIR
					3	rch			CUBEFLAG_RECHARGE
					4	*unused*
					5	*unused*
					6	*unused*
					7	*unused*
					8	*unused*
					WORD wItem;                     //0x02
					WORD wItemID;                  //0x04
					BYTE nQuality;                  //0x06
					BYTE nQuantity;                  //0x07
					BYTE nType;                     //0x08
					BYTE nLvl;                     //0x09
					BYTE nPLvl;                     //0x0A
					BYTE nILvl;                     //0x0B
					WORD wPrefixId;                  //0x0C
					WORD unk0x0E;                  //0x0E
					WORD unk0x10;                  //0x10
					WORD wSuffixId;                  //0x12
				};
			*/
			Record[oABC "output ItemFlags"] := Bin.ReadUChar() 
			Record[oABC "output ItemType"] := Bin.ReadUChar() 
			Record[oABC "output Item"] := Bin.ReadUShort() 
			Record[oABC "output ItemID"] := Bin.ReadUShort() 
			Record[oABC "output Quality"] := Bin.ReadUChar() 
			Record[oABC "output Quantity"] := Bin.ReadUChar() 
			Record[oABC "output Type"] := Bin.ReadUChar() 
			Record[oABC "output Lvl"] := Bin.ReadUChar() 
			Record[oABC "output PLvl"] := Bin.ReadUChar() 
			Record[oABC "output ILvl"] := Bin.ReadUChar() 
			Record[oABC "output PrefixID"] := Bin.ReadUShort() 
			Record[oABC "output unk0x0E"] := Bin.ReadUShort() 
			Record[oABC "output unk0x10"] := Bin.ReadUShort() 
			Record[oABC "output SuffixId"] := Bin.ReadUShort() 
			;~ if Record[oABC "output Type"] > 200
			;~ if Record[oABC "output Type"] < 254
			;~ if Record[oABC "output Type"] != 252
							;~ if Record[oABC "output Type"] != 253
			
				;~ msgbox % Record[oABC "output Type"]
			;~ if Record[oABC "output ItemType"] !=0
							;~ msgbox % Record[oABC "output Type"] "`n" recordid
;~ if ( 255 == Record[oABC "output Type"] )
				;~ {
			Record[oABC "output"] .= "usetype"
					;~ msgbox % recordid
				;~ }
			/*else
				BEGIN BITFIELD OPERATIONS
			*/
			;~ if ( 0 == Record[oABC "output ItemFlags"] 
			;~ && 0 == Record[oABC "output ItemType"] 
			;~ && 0 == Record[oABC "output Quality"] 
			;~ && 0 == Record[oABC "output Quantity"] 
			;~ && 0 == Record[oABC "output PrefixID"] 
			;~ && 0 == Record[oABC "output SuffixId"] )
			;~ if ( Record[oABC "output ItemFlags"] + Record[oABC "output ItemType"] + Record[oABC "output Quality"] + Record[oABC "output Quantity"] + Record[oABC "output PrefixID"] + Record[oABC "output SuffixId"] = 0)
			;~ {
			if ( 255 == Record[oABC "output Type"] )
				Record[oABC "output"] .= "usetype"
			else if ( 254 == Record[oABC "output Type"] )
				Record[oABC "output"] .= "useitem"
			else if ( 1 == Record[oABC "output Type"] )
				Record[oABC "output"] .= "Cow Portal"
			else if ( 2 == Record[oABC "output Type"] )
				Record[oABC "output"] .= "Pandemonium Portal"
			else if ( 3 == Record[oABC "output Type"] )
				Record[oABC "output"] .= "Pandemonium Finale Portal"
			else if ( 0 != Record[oABC "output ItemID"] )
				Record[oABC "output"] .= "ITEMID|" Record[oABC "output ItemID"]
			else if ( 0 != Record[oABC "output Item"] )
				Record[oABC "output"] .= "ITEM|" Record[oABC "output Item"]
			
			if ( 0 != (0x04 & Record[oABC "output ItemFlags"] ) )
				Record[oABC "output"] .= ",eth"				
			if ( 0 != (0x01 & Record[oABC "output ItemFlags"] ) )
				Record[oABC "output"] .= ",mod"
			if ( 0 != (0x80 & Record[oABC "output ItemFlags"] ) )
				Record[oABC "output"] .= ",exc"
			if ( 0 != (0x10 & Record[oABC "output ItemFlags"] ) )
				Record[oABC "output"] .= ",uns"
			if ( 0 != (0x20 & Record[oABC "output ItemFlags"] ) )
				Record[oABC "output"] .= ",rem"
			if ( 0 != (0x01 & Record[oABC "output ItemType"] ) )
				Record[oABC "output"] .= ",eli"
			if ( 0 != (0x02 & Record[oABC "output ItemType"] ) )
				Record[oABC "output"] .= ",rep"
			if ( 0 != (0x04 & Record[oABC "output ItemType"] ) )
				Record[oABC "output"] .= ",rch"
			If Record[oABC "output Quality"] > 0
				Record[oABC "output"] .= "," QualityList[Record[oABC "output Quality"]]
			If Record[oABC "output PrefixID"] > 0
				Record[oABC "output"] .= ",pre=" Record[oABC "output PrefixID"]
			If Record[oABC "output SuffixId"] > 0
				Record[oABC "output"] .= ",suf=" Record[oABC "output SuffixId"]
			
				;~ if ( 0 == (0x02 & Record[oABC "output ItemFlags"] ) && 
			if ( 0 != (0x02 & Record[oABC "output ItemFlags"] ) )
				Record[oABC "output"] .= ",sock=" Record[oABC "output Quantity"]
			else if ( 0 < Record[oABC "output Quantity"] )
				Record[oABC "output"] .= ",qty=" Record[oABC "output Quantity"]
				;~ If Record[oABC "output"] != ""
				;~ if Instr(Record[oABC "output"],"use")
				;~ if ( 0 != Record[oABC "output ItemID"] )
					;~ testarr[recordid+1,a_index] := Record[oABC "output"]
					;~ WORD wItem;                     //0x02
					;~ WORD wItemID;                  //0x04
					;~ BYTE nQuality;                  //0x06
					;~ BYTE nQuantity;                  //0x07
					;~ BYTE nType;                     //0x08
					;~ BYTE nLvl;                     //0x09
					;~ BYTE nPLvl;                     //0x0A
					;~ BYTE nILvl;                     //0x0B
					;~ WORD wPrefixId;                  //0x0C
					;~ WORD unk0x0E;                  //0x0E
					;~ WORD unk0x10;                  //0x10
					;~ WORD wSuffixId;                  //0x12
			
			
			
			/*
				CEASE BITFIELD OPERATIONS
			*/
			If a_index=1
				Record["iPadding24"] := Bin.ReadUInt() 
			else if a_index=2
				Record["iPadding45"] := Bin.ReadUInt()
			else
				Record["iPadding66"] := Bin.ReadUInt()
			
			Record[oABC "mod 1"] := Bin.ReadUInt() 
			Record[oABC "mod 1 param"] := Bin.ReadUShort() 
			Record[oABC "mod 1 min"] := Bin.ReadShort() 
			Record[oABC "mod 1 max"] := Bin.ReadShort() 
			Record[oABC "mod 1 chance"] := Bin.ReadUShort() 
			Record[oABC "mod 2"] := Bin.ReadUInt() 
			Record[oABC "mod 2 param"] := Bin.ReadUShort() 
			Record[oABC "mod 2 min"] := Bin.ReadShort() 
			Record[oABC "mod 2 max"] := Bin.ReadShort() 
			Record[oABC "mod 2 chance"] := Bin.ReadUShort() 
			Record[oABC "mod 3"] := Bin.ReadUInt() 
			Record[oABC "mod 3 param"] := Bin.ReadUShort() 
			Record[oABC "mod 3 min"] := Bin.ReadShort() 
			Record[oABC "mod 3 max"] := Bin.ReadShort() 
			Record[oABC "mod 3 chance"] := Bin.ReadUShort() 
			Record[oABC "mod 4"] := Bin.ReadUInt() 
			Record[oABC "mod 4 param"] := Bin.ReadUShort() 
			Record[oABC "mod 4 min"] := Bin.ReadShort() 
			Record[oABC "mod 4 max"] := Bin.ReadShort() 
			Record[oABC "mod 4 chance"] := Bin.ReadUShort() 
			Record[oABC "mod 5"] := Bin.ReadUInt() 
			Record[oABC "mod 5 param"] := Bin.ReadUShort() 
			Record[oABC "mod 5 min"] := Bin.ReadShort() 
			Record[oABC "mod 5 max"] := Bin.ReadShort() 
			Record[oABC "mod 5 chance"] := Bin.ReadUShort() 
		}
		
		;Build the SQL table for this module
		if (RecordID = 1)
		{
			;~ continue
			;~ SQLKeys := []
			For k,v in Record
			{
				if k in modnum,recordid
					continue
				Digest[ModFullName,"Keys","Decompile",Module] .= "'" k "',"
				;~ SQLKeys[k] := ""
			}
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
			
			tablename := "Decompile | " module
			tablename = test
			SQLt := "CREATE TABLE IF NOT EXISTS '" tablename "'(`n"
				;~ . "TableIndex integer PRIMARY KEY AUTOINCREMENT,"
				. "ModNum," ;Disable with DBA
				. "RecordID," ;Disable with DBA
				. Digest[ModFullName,"Keys","Decompile",Module] "`n"
				;~ . "CONSTRAINT '" tablename "' UNIQUE ('RecordID','ModNum')
				. ");`n"
				;~ SQLt := "BEGIN TRANSACTION;`n" SQLt "COMMIT;"
			;~ DigestDB.Exec(SQLt)
			
			;~ SQLt=
			;~ ParamList := RTrim("'ModNum','RecordID'," Digest[ModFullName,"Keys","Decompile",Module],",") ;bulk load
			;~ ParamList := "'ModNum','RecordID'," Digest[ModFullName,"Keys","Decompile",Module],",")
			;~ msgbox % ParamList
			;~ ParamList := StrReplace(ParamList,"','","',':")
						;~ msgbox % ParamList
			;~ qry = CREATE TABLE '%Table%'( column_1 data_type PRIMARY KEY, column_2 data_type NOT NULL, column_3 data_type DEFAULT 0, table_constraint)
			;~ Clipboard := SQLt
			create_table := DigestDB.Query(SQLt)
			;~ SQL := "INSERT INTO 'Decompile | " module "'(" ParamList ") VALUES `n"
			;~ DigestDB.exe(SQL)
			
			
		}
;~ continue
		Loop,7
		{
			Kill := "input " a_index " Input"
			KillDepend := "input " a_index " Input Flags,input " a_index " Item Type,input " a_index " Input ID,input " a_index " Quality,input " a_index " Quantity"
			RecordKill(Record,kill,0,killdepend,,,,1)
		}
		
		for Index, oABC in ["", "b ", "c "]
		{
			kill := oABC "mod $|5"
			killdepend := oABC "mod $ param," 
				. oABC "mod $ min,"
				. oABC "mod $ max,"
				. oABC "mod $ chance"
			RecordKill(Record,kill,4294967295,killdepend,,"$",,1)
			
			Kill := oABC "output Item"
			KillDepend := oABC "output ItemFlags,"
				. oABC "output ItemType,"
				. oABC "output ItemID,"
				. oABC "output Quality,"
				. oABC "output Quantity,"
				. oABC "output Type,"
				. oABC "output Lvl,"
				. oABC "output PLvl,"
				. oABC "output ILvl,"
				. oABC "output PrefixID," oABC "output SuffixId"
			RecordKill(Record,kill,0,killdepend,,,,1)
		}
		;~ For k,v in Digest[ModFullName,"Decompile",Module,RecordID]
		;~ RecordCache.Add(Record)
		;~ if !Mod(A_Index,25)
			;~ DigestDB.InsertMany(RecordCache,tablename)
		DigestDB.Insert(Record,tablename)
		msgbox % st_printArr(Record)
		continue
		;SQL write operations
		ParamList=
		ValueList=
		For k,v in Digest[ModFullName,"Decompile",Module,RecordID]
		{
			if (Record[k] = "")
			{
				Record[k] := Digest[ModFullName,"Decompile",Module,RecordID,k] := ""
				continue
			}
			KeyCounter += 1
			KeySize += StrLen(v)
			ParamList .= "'" StrReplace(k,"'","''") "',"
			ValueList .= "'" StrReplace(v,"'","''") "',"
		}
		;~ SQL .= "INSERT INTO 'Decompile | " module "'(" RTrim(ParamList,",") ") VALUES (" RTrim(ValueList,",") ");`n"
		DigestDB.exec(SQL)
		continue
		
		;~ ValueList=
		;~ For k,v in SQLKeys
		;~ {
			;~ if (Record[k] = "")
			;~ {
				;~ Record[k] := Digest[ModFullName,"Decompile",Module,RecordID,k] := ""
				;~ ValueList .= "NULL,"	
				;~ continue
			;~ }
			;~ ValueList .= "'" StrReplace(Record[k],"'","''") "',"			
		;~ }
		;~ msgbox % RTrim(ValueList,",")
		;~ continue
		;below is essentially functional, but inefficient
		
		ValueList=
		For k,v in SQLKeys
		{
			if (Record[k] = "")
			{
				Record[k] := Digest[ModFullName,"Decompile",Module,RecordID,k] := ""
				ValueList .= "NULL,"
				continue
			}
			KeyCounter += 1
			KeySize += StrLen(Record[k])
			ValueList .= "'" StrReplace(Record[k],"'","''") "',"
		}
		SQL .= "('" ModNum "','" RecordID "'," RTrim(ValueList,",") "),`n"
		;~ Clipboard := SQL
		;~ ExitApp
		;~ if (StrLen(SQL) > 5242880)
		;~ {
			;~ DigestDB.Exec("BEGIN TRANSACTION;`n" SQL "COMMIT;")
			;~ DigestDB.Exec(SQL)
			;~ sql=
		;~ }
		
		;StrPut tests
		;~ StrPutVar("INSERT INTO 'Decompile | " module "'(" RTrim(ParamList,",") ") VALUES (" RTrim(ValueList,",") ");`n", SQL, "CP0")
		
	}
	;~ SQL := RTrim(SQL,",`n") ";`n"
	;~ SQL := "BEGIN TRANSACTION;`n" SQL "COMMIT;"
	;~ DigestDB.Exec(SQL)
	;~ FileDelete,%A_ScriptDir%\_sql.txt
	;~ FileAppend,% SQL,%A_ScriptDir%\_sql.txt
	;~ sql=
		;~ msgbox % Digest.GetCapacity()
		;~ DigestDB.InsertMany(Digest[ModFullName,"Decompile",Module], tablename)
		;~ StartSQLTime := A_TickCount
	DigestDB.InsertMany(RecordCache, tablename)
				;~ msgbox % (A_TickCount - StartSQLTime) / 1000 / ((Bin.Length  - 4) / RecordSize)
}
;complete
Digest_Bin_110f_cubemod(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 0

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 0
		RecordID := a_index
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_cubetype(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 0

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 0
		RecordID := a_index
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_difficultylevels(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 88

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 88
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["ResistPenalty"] := Bin.ReadInt() 
		Record["DeathExpPenalty"] := Bin.ReadUInt() 
		Record["UberCodeOddsNormal"] := Bin.ReadUInt() 
		Record["UberCodeOddsGood"] := Bin.ReadUInt() 
		Record["MonsterSkillBonus"] := Bin.ReadUInt() 
		Record["MonsterFreezeDivisor"] := Bin.ReadUInt() 
		Record["MonsterColdDivisor"] := Bin.ReadUInt() 
		Record["AiCurseDivisor"] := Bin.ReadUInt() 
		Record["UltraCodeOddsNormal"] := Bin.ReadUInt() 
		Record["UltraCodeOddsGood"] := Bin.ReadUInt() 
		Record["LifeStealDivisor"] := Bin.ReadUInt() 
		Record["ManaStealDivisor"] := Bin.ReadUInt() 
		Record["UniqueDamageBonus"] := Bin.ReadUInt() 
		Record["ChampionDamageBonus"] := Bin.ReadUInt() 
		Record["HireableBossDamagePercent"] := Bin.ReadUInt() 
		Record["MonsterCEDamagePercent"] := Bin.ReadUInt() 
		Record["StaticFieldMin"] := Bin.ReadUInt() 
		Record["GambleRare"] := Bin.ReadUInt() 
		Record["GambleSet"] := Bin.ReadUInt() 
		Record["GambleUnique"] := Bin.ReadUInt() 
		Record["GambleUber"] := Bin.ReadUInt() 
		Record["GambleUltra"] := Bin.ReadUInt()
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_elemtypes(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 4

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 4
		RecordID := a_index
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["code"] := Trim(Bin.Read(4))
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_events(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 2

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 2
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["event"] := Bin.ReadUShort()
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_experience(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 32

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 32
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Amazon"] := Bin.ReadUInt() 
		Record["Sorceress"] := Bin.ReadUInt() 
		Record["Necromancer"] := Bin.ReadUInt() 
		Record["Paladin"] := Bin.ReadUInt() 
		Record["Barbarian"] := Bin.ReadUInt() 
		Record["Druid"] := Bin.ReadUInt() 
		Record["Assassin"] := Bin.ReadUInt() 
		Record["ExpRatio"] := Bin.ReadUInt()
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_gamble(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 12

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 12
		RecordID := a_index
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_gems(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 192

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 192
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["name"] := Bin.Read(32) 
		Record["letter"] := Bin.Read(8) 
		Record["code"] := Bin.ReadUInt() 
		Record["iPadding11"] := Bin.ReadUShort() 
		Record["nummods"] := Bin.ReadUChar() 
		Record["transform"] := Bin.ReadUChar() 
		Record["weaponMod1Code"] := Bin.ReadUInt() 
		Record["weaponMod1Param"] := Bin.ReadUInt() 
		Record["weaponMod1Min"] := Bin.ReadInt() 
		Record["weaponMod1Max"] := Bin.ReadInt() 
		Record["weaponMod2Code"] := Bin.ReadUInt() 
		Record["weaponMod2Param"] := Bin.ReadUInt() 
		Record["weaponMod2Min"] := Bin.ReadInt() 
		Record["weaponMod2Max"] := Bin.ReadInt() 
		Record["weaponMod3Code"] := Bin.ReadUInt() 
		Record["weaponMod3Param"] := Bin.ReadUInt() 
		Record["weaponMod3Min"] := Bin.ReadInt() 
		Record["weaponMod3Max"] := Bin.ReadInt() 
		Record["helmMod1Code"] := Bin.ReadUInt() 
		Record["helmMod1Param"] := Bin.ReadUInt() 
		Record["helmMod1Min"] := Bin.ReadInt() 
		Record["helmMod1Max"] := Bin.ReadInt() 
		Record["helmMod2Code"] := Bin.ReadUInt() 
		Record["helmMod2Param"] := Bin.ReadUInt() 
		Record["helmMod2Min"] := Bin.ReadInt() 
		Record["helmMod2Max"] := Bin.ReadInt() 
		Record["helmMod3Code"] := Bin.ReadUInt() 
		Record["helmMod3Param"] := Bin.ReadUInt() 
		Record["helmMod3Min"] := Bin.ReadInt() 
		Record["helmMod3Max"] := Bin.ReadInt() 
		Record["shieldMod1Code"] := Bin.ReadUInt() 
		Record["shieldMod1Param"] := Bin.ReadUInt() 
		Record["shieldMod1Min"] := Bin.ReadInt() 
		Record["shieldMod1Max"] := Bin.ReadInt() 
		Record["shieldMod2Code"] := Bin.ReadUInt() 
		Record["shieldMod2Param"] := Bin.ReadUInt() 
		Record["shieldMod2Min"] := Bin.ReadInt() 
		Record["shieldMod2Max"] := Bin.ReadInt() 
		Record["shieldMod3Code"] := Bin.ReadUInt() 
		Record["shieldMod3Param"] := Bin.ReadUInt() 
		Record["shieldMod3Min"] := Bin.ReadInt() 
		Record["shieldMod3Max"] := Bin.ReadInt()
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		
		Kill=weaponmod$code|15
		KillDepend=weaponmod$param,weaponmod$min,weaponmod$max
		RecordKill(Record,kill,4294967295,KillDepend,,"$")
		
		Kill=helmmod$code|15
		KillDepend=helmmod$param,helmmod$min,helmmod$max
		RecordKill(Record,kill,4294967295,KillDepend,,"$")
		
		Kill=shieldmod$code|15
		KillDepend=shieldmod$param,shieldmod$min,shieldmod$max
		RecordKill(Record,kill,4294967295,KillDepend,,"$")
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_hiredesc(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 4

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 4
		RecordID := a_index
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_hireling(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 280

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 280
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Version"] := Bin.ReadUInt() 
		Record["Id"] := Bin.ReadUInt() 
		Record["Class"] := Bin.ReadUInt() 
		Record["Act"] := Bin.ReadUInt() 
		Record["Difficulty"] := Bin.ReadUInt() 
		Record["Seller"] := Bin.ReadUInt() 
		Record["Gold"] := Bin.ReadUInt() 
		Record["Level"] := Bin.ReadUInt() 
		Record["Exp/Lvl"] := Bin.ReadUInt() 
		Record["HP"] := Bin.ReadUInt() 
		Record["HP/Lvl"] := Bin.ReadUInt() 
		Record["Defense"] := Bin.ReadUInt() 
		Record["Def/Lvl"] := Bin.ReadUInt() 
		Record["Str"] := Bin.ReadUInt() 
		Record["Str/Lvl"] := Bin.ReadUInt() 
		Record["Dex"] := Bin.ReadUInt() 
		Record["Dex/Lvl"] := Bin.ReadUInt() 
		Record["AR"] := Bin.ReadUInt() 
		Record["AR/Lvl"] := Bin.ReadUInt() 
		Record["Share"] := Bin.ReadUInt() 
		Record["Dmg-Min"] := Bin.ReadUInt() 
		Record["Dmg-Max"] := Bin.ReadUInt() 
		Record["Dmg/Lvl"] := Bin.ReadUInt() 
		Record["Resist"] := Bin.ReadUInt() 
		Record["Resist/Lvl"] := Bin.ReadUInt() 
		Record["DefaultChance"] := Bin.ReadUInt() 
		Record["Head"] := Bin.ReadUInt() 
		Record["Torso"] := Bin.ReadUInt() 
		Record["Weapon"] := Bin.ReadUInt() 
		Record["Shield"] := Bin.ReadUInt() 
		Record["Skill1"] := Bin.ReadUInt() 
		Record["Skill2"] := Bin.ReadUInt() 
		Record["Skill3"] := Bin.ReadUInt() 
		Record["Skill4"] := Bin.ReadUInt() 
		Record["Skill5"] := Bin.ReadUInt() 
		Record["Skill6"] := Bin.ReadUInt() 
		Record["Chance1"] := Bin.ReadUInt() 
		Record["Chance2"] := Bin.ReadUInt() 
		Record["Chance3"] := Bin.ReadUInt() 
		Record["Chance4"] := Bin.ReadUInt() 
		Record["Chance5"] := Bin.ReadUInt() 
		Record["Chance6"] := Bin.ReadUInt() 
		Record["ChancePerLvl1"] := Bin.ReadUInt() 
		Record["ChancePerLvl2"] := Bin.ReadUInt() 
		Record["ChancePerLvl3"] := Bin.ReadUInt() 
		Record["ChancePerLvl4"] := Bin.ReadUInt() 
		Record["ChancePerLvl5"] := Bin.ReadUInt() 
		Record["ChancePerLvl6"] := Bin.ReadUInt() 
		Record["Mode1"] := Bin.ReadUChar() 
		Record["Mode2"] := Bin.ReadUChar() 
		Record["Mode3"] := Bin.ReadUChar() 
		Record["Mode4"] := Bin.ReadUChar() 
		Record["Mode5"] := Bin.ReadUChar() 
		Record["Mode6"] := Bin.ReadUChar() 
		Record["Level1"] := Bin.ReadUChar() 
		Record["Level2"] := Bin.ReadUChar() 
		Record["Level3"] := Bin.ReadUChar() 
		Record["Level4"] := Bin.ReadUChar() 
		Record["Level5"] := Bin.ReadUChar() 
		Record["Level6"] := Bin.ReadUChar() 
		Record["LvlPerLvl1"] := Bin.ReadUChar() 
		Record["LvlPerLvl2"] := Bin.ReadUChar() 
		Record["LvlPerLvl3"] := Bin.ReadUChar() 
		Record["LvlPerLvl4"] := Bin.ReadUChar() 
		Record["LvlPerLvl5"] := Bin.ReadUChar() 
		Record["LvlPerLvl6"] := Bin.ReadUChar() 
		Record["HireDesc"] := Bin.ReadUChar() 
		Record["NameFirst"] := Trim(Bin.Read(32))
		Record["NameLast"] := Trim(Bin.Read(37))
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_hitclass(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 4

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 4
		RecordID := a_index
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_inventory(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 240

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 240
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["invLeft"] := Bin.ReadInt() 
		Record["invRight"] := Bin.ReadInt() 
		Record["invTop"] := Bin.ReadInt() 
		Record["invBottom"] := Bin.ReadInt() 
		Record["gridX"] := Bin.ReadChar() 
		Record["gridY"] := Bin.ReadChar() 
		Record["iPadding4"] := Bin.ReadUShort() 
		Record["gridLeft"] := Bin.ReadInt() 
		Record["gridRight"] := Bin.ReadInt() 
		Record["gridTop"] := Bin.ReadInt() 
		Record["gridBottom"] := Bin.ReadInt() 
		Record["gridBoxWidth"] := Bin.ReadChar() 
		Record["gridBoxHeight"] := Bin.ReadChar() 
		Record["iPadding9"] := Bin.ReadUShort() 
		Record["rArmLeft"] := Bin.ReadInt() 
		Record["rArmRight"] := Bin.ReadInt() 
		Record["rArmTop"] := Bin.ReadInt() 
		Record["rArmBottom"] := Bin.ReadInt() 
		Record["rArmWidth"] := Bin.ReadChar() 
		Record["rArmHeight"] := Bin.ReadChar() 
		Record["iPadding14"] := Bin.ReadUShort() 
		Record["torsoLeft"] := Bin.ReadInt() 
		Record["torsoRight"] := Bin.ReadInt() 
		Record["torsoTop"] := Bin.ReadInt() 
		Record["torsoBottom"] := Bin.ReadInt() 
		Record["torsoWidth"] := Bin.ReadChar() 
		Record["torsoHeight"] := Bin.ReadChar() 
		Record["iPadding19"] := Bin.ReadUShort() 
		Record["lArmLeft"] := Bin.ReadInt() 
		Record["lArmRight"] := Bin.ReadInt() 
		Record["lArmTop"] := Bin.ReadInt() 
		Record["lArmBottom"] := Bin.ReadInt() 
		Record["lArmWidth"] := Bin.ReadChar() 
		Record["lArmHeight"] := Bin.ReadChar() 
		Record["iPadding24"] := Bin.ReadUShort() 
		Record["headLeft"] := Bin.ReadInt() 
		Record["headRight"] := Bin.ReadInt() 
		Record["headTop"] := Bin.ReadInt() 
		Record["headBottom"] := Bin.ReadInt() 
		Record["headWidth"] := Bin.ReadChar() 
		Record["headHeight"] := Bin.ReadChar() 
		Record["iPadding29"] := Bin.ReadUShort() 
		Record["neckLeft"] := Bin.ReadInt() 
		Record["neckRight"] := Bin.ReadInt() 
		Record["neckTop"] := Bin.ReadInt() 
		Record["neckBottom"] := Bin.ReadInt() 
		Record["neckWidth"] := Bin.ReadChar() 
		Record["neckHeight"] := Bin.ReadChar() 
		Record["iPadding34"] := Bin.ReadUShort() 
		Record["rHandLeft"] := Bin.ReadInt() 
		Record["rHandRight"] := Bin.ReadInt() 
		Record["rHandTop"] := Bin.ReadInt() 
		Record["rHandBottom"] := Bin.ReadInt() 
		Record["rHandWidth"] := Bin.ReadChar() 
		Record["rHandHeight"] := Bin.ReadChar() 
		Record["iPadding39"] := Bin.ReadUShort() 
		Record["lHandLeft"] := Bin.ReadInt() 
		Record["lHandRight"] := Bin.ReadInt() 
		Record["lHandTop "] := Bin.ReadInt() 
		Record["lHandBottom"] := Bin.ReadInt() 
		Record["lHandWidth"] := Bin.ReadChar() 
		Record["lHandHeight"] := Bin.ReadChar() 
		Record["iPadding44"] := Bin.ReadUShort() 
		Record["beltLeft"] := Bin.ReadInt() 
		Record["beltRight"] := Bin.ReadInt() 
		Record["beltTop"] := Bin.ReadInt() 
		Record["beltBottom"] := Bin.ReadInt() 
		Record["beltWidth"] := Bin.ReadChar() 
		Record["beltHeight"] := Bin.ReadChar() 
		Record["iPadding49"] := Bin.ReadUShort() 
		Record["feetLeft"] := Bin.ReadInt() 
		Record["feetRight"] := Bin.ReadInt() 
		Record["feetTop"] := Bin.ReadInt() 
		Record["feetBottom"] := Bin.ReadInt() 
		Record["feetWidth"] := Bin.ReadChar() 
		Record["feetHeight"] := Bin.ReadChar() 
		Record["iPadding54"] := Bin.ReadUShort() 
		Record["glovesLeft"] := Bin.ReadInt() 
		Record["glovesRight"] := Bin.ReadInt() 
		Record["glovesTop"] := Bin.ReadInt() 
		Record["glovesBottom"] := Bin.ReadInt() 
		Record["glovesWidth"] := Bin.ReadChar() 
		Record["glovesHeight"] := Bin.ReadChar() 
		Record["iPadding59"] := Bin.ReadUShort()
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_itemratio(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 68

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 68
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Unique"] := Bin.ReadUInt() 
		Record["UniqueDivisor"] := Bin.ReadUInt() 
		Record["UniqueMin"] := Bin.ReadUInt() 
		Record["Rare"] := Bin.ReadUInt() 
		Record["RareDivisor"] := Bin.ReadUInt() 
		Record["RareMin"] := Bin.ReadUInt() 
		Record["Set"] := Bin.ReadUInt() 
		Record["SetDivisor"] := Bin.ReadUInt() 
		Record["SetMin"] := Bin.ReadUInt() 
		Record["Magic"] := Bin.ReadUInt() 
		Record["MagicDivisor"] := Bin.ReadUInt() 
		Record["MagicMin"] := Bin.ReadUInt() 
		Record["HiQuality"] := Bin.ReadUInt() 
		Record["HiQualityDivisor"] := Bin.ReadUInt() 
		Record["Normal"] := Bin.ReadUInt() 
		Record["NormalDivisor"] := Bin.ReadUInt() 
		Record["Version"] := Bin.ReadUShort() 
		Record["Uber"] := Bin.ReadUChar() 
		Record["Class Specific"] := Bin.ReadUChar()
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_itemscode(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 0

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 0
		RecordID := a_index
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_itemstatcost(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Seek(4)
	RecordSize := 324

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 324
		;BITFIELDS ARE PRESENT!
		RecordID := a_index-1
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["ID"] := Bin.ReadUInt() 
		Record["CombinedBits1"] := Bin.ReadUChar() 
		Record["CombinedBits2"] := Bin.ReadUChar() 
		
		;Start bitfield operations
		Flags := Record["CombinedBits1"] Record["CombinedBits2"]
		If Flags = 
		msgbox,YOU HAVE NOT FIXED THE BITFIELDS FOR MODULE %module%.
		Record["iPadding1_1"] := substr(Flags,3,3) 
		Record["direct"] := substr(Flags,4,1) 
		Record["itemspecific"] := substr(Flags,5,1) 
		Record["damagerelated"] := substr(Flags,6,1) 
		Record["Signed"] := substr(Flags,7,1) 
		Record["Send Other"] := substr(Flags,8,1) 
		Record["iPadding1"] := substr(Flags,9,1) 
		Record["iPadding1_3"] := substr(Flags,10,1) 
		Record["CSvSigned"] := substr(Flags,11,1) 
		Record["Saved"] := substr(Flags,12,1) 
		Record["fCallback"] := substr(Flags,13,1) 
		Record["fMin"] := substr(Flags,14,1) 
		Record["UpdateAnimRate"] := substr(Flags,15,1) 
		Record["iPadding1_2"] := substr(Flags,16,1) 
		Record["iPadding1"] := Trim(Bin.Read(2))
		Record["Send Bits"] := Bin.ReadUChar() 
		Record["Send Param Bits"] := Bin.ReadUChar() 
		Record["CSvBits"] := Bin.ReadUChar() 
		Record["CSvParam"] := Bin.ReadUChar() 
		Record["Divide"] := Bin.ReadUInt() 
		Record["Multiply"] := Bin.ReadInt() 
		Record["Add"] := Bin.ReadUInt() 
		Record["ValShift"] := Bin.ReadUChar() 
		Record["Save Bits"] := Bin.ReadUChar() 
		Record["1.09-Save Bits"] := Bin.ReadUChar() 
		Record["bUnKnown"] := Bin.ReadUChar() 
		Record["Save Add"] := Bin.ReadInt() 
		Record["1.09-Save Add"] := Bin.ReadInt() 
		Record["Save Param Bits"] := Bin.ReadUInt() 
		Record["iPadding10"] := Bin.ReadUInt() 
		Record["MinAccr"] := Bin.ReadUInt() 
		Record["Encode"] := Bin.ReadUChar() 
		Record["bUnKnown2"] := Bin.ReadUChar() 
		Record["maxstat"] := Bin.ReadUShort() 
		Record["descpriority"] := Bin.ReadUShort() 
		Record["descfunc"] := Bin.ReadUChar() 
		Record["descval"] := Bin.ReadUChar() 
		Record["descstrpos"] := Bin.ReadUShort() 
		Record["descstrneg"] := Bin.ReadUShort() 
		Record["descstr2"] := Bin.ReadUShort() 
		Record["dgrp"] := Bin.ReadUShort() 
		Record["dgrpfunc"] := Bin.ReadUChar() 
		Record["dgrpval"] := Bin.ReadUChar() 
		Record["dgrpstrpos"] := Bin.ReadUShort() 
		Record["dgrpstrneg"] := Bin.ReadUShort() 
		Record["dgrpstr2"] := Bin.ReadUShort() 
		Record["itemevent1"] := Bin.ReadUShort() 
		Record["itemevent2"] := Bin.ReadUShort() 
		Record["itemeventfunc1"] := Bin.ReadUShort() 
		Record["itemeventfunc2"] := Bin.ReadUShort() 
		Record["keepzero"] := Bin.ReadUInt() 
		Record["op"] := Bin.ReadUChar() 
		Record["op param"] := Bin.ReadUChar() 
		Record["op base"] := Bin.ReadUShort() 
		Record["op stat1"] := Bin.ReadUShort() 
		Record["op stat2"] := Bin.ReadUShort() 
		Record["op stat3"] := Bin.ReadUShort() 
		Record["iPadding23"] := Bin.ReadUShort() 
		Record["iPadding24"] := Bin.ReadUInt() 
		Record["iPadding25"] := Bin.ReadUInt() 
		Record["iPadding26"] := Bin.ReadUInt() 
		Record["iPadding27"] := Bin.ReadUInt() 
		Record["iPadding28"] := Bin.ReadUInt() 
		Record["iPadding29"] := Bin.ReadUInt() 
		Record["iPadding30"] := Bin.ReadUInt() 
		Record["iPadding31"] := Bin.ReadUInt() 
		Record["iPadding32"] := Bin.ReadUInt() 
		Record["iPadding33"] := Bin.ReadUInt() 
		Record["iPadding34"] := Bin.ReadUInt() 
		Record["iPadding35"] := Bin.ReadUInt() 
		Record["iPadding36"] := Bin.ReadUInt() 
		Record["iPadding37"] := Bin.ReadUInt() 
		Record["iPadding38"] := Bin.ReadUInt() 
		Record["iPadding39"] := Bin.ReadUInt() 
		Record["iPadding40"] := Bin.ReadUInt() 
		Record["iPadding41"] := Bin.ReadUInt() 
		Record["iPadding42"] := Bin.ReadUInt() 
		Record["iPadding43"] := Bin.ReadUInt() 
		Record["iPadding44"] := Bin.ReadUInt() 
		Record["iPadding45"] := Bin.ReadUInt() 
		Record["iPadding46"] := Bin.ReadUInt() 
		Record["iPadding47"] := Bin.ReadUInt() 
		Record["iPadding48"] := Bin.ReadUInt() 
		Record["iPadding49"] := Bin.ReadUInt() 
		Record["iPadding50"] := Bin.ReadUInt() 
		Record["iPadding51"] := Bin.ReadUInt() 
		Record["iPadding52"] := Bin.ReadUInt() 
		Record["iPadding53"] := Bin.ReadUInt() 
		Record["iPadding54"] := Bin.ReadUInt() 
		Record["iPadding55"] := Bin.ReadUInt() 
		Record["iPadding56"] := Bin.ReadUInt() 
		Record["iPadding57"] := Bin.ReadUInt() 
		Record["iPadding58"] := Bin.ReadUInt() 
		Record["iPadding59"] := Bin.ReadUInt() 
		Record["iPadding60"] := Bin.ReadUInt() 
		Record["iPadding61"] := Bin.ReadUInt() 
		Record["iPadding62"] := Bin.ReadUInt() 
		Record["iPadding63"] := Bin.ReadUInt() 
		Record["iPadding64"] := Bin.ReadUInt() 
		Record["iPadding65"] := Bin.ReadUInt() 
		Record["iPadding66"] := Bin.ReadUInt() 
		Record["iPadding67"] := Bin.ReadUInt() 
		Record["iPadding68"] := Bin.ReadUInt() 
		Record["iPadding69"] := Bin.ReadUInt() 
		Record["iPadding70"] := Bin.ReadUInt() 
		Record["iPadding71"] := Bin.ReadUInt() 
		Record["iPadding72"] := Bin.ReadUInt() 
		Record["iPadding73"] := Bin.ReadUInt() 
		Record["iPadding74"] := Bin.ReadUInt() 
		Record["iPadding75"] := Bin.ReadUInt() 
		Record["iPadding76"] := Bin.ReadUInt() 
		Record["iPadding77"] := Bin.ReadUInt() 
		Record["iPadding78"] := Bin.ReadUInt() 
		Record["iPadding79"] := Bin.ReadUInt() 
		Record["stuff"] := Bin.ReadUInt()
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		
		Kill := "op"
		KillDepend := "op base,op param,op stat1,op stat2,op stat3,bUknown"
		RecordKill(Record,kill,0,KillDepend)
		
		kill := "itemevent|2,maxstat,op base,op stat|3"
		RecordKill(Record,kill,65535,,,"$")

		Kill := "stuff,op param,itemeventfunc|2,iPadding|79"
		RecordKill(Record,kill,0)
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_itemtypes(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Seek(4)
	RecordSize := 228

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 228
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Code"] := Trim(Bin.Read(4))
		Record["Equiv1"] := Bin.ReadUShort() 
		Record["Equiv2"] := Bin.ReadUShort() 
		Record["Repair"] := Bin.ReadUChar() 
		Record["Body"] := Bin.ReadUChar() 
		Record["BodyLoc1"] := Bin.ReadUChar() 
		Record["BodyLoc2"] := Bin.ReadUChar() 
		Record["Shoots"] := Bin.ReadUShort() 
		Record["Quiver"] := Bin.ReadUShort() 
		Record["Throwable"] := Bin.ReadUChar() 
		Record["Reload"] := Bin.ReadUChar() 
		Record["ReEquip"] := Bin.ReadUChar() 
		Record["AutoStack"] := Bin.ReadUChar() 
		Record["Magic"] := Bin.ReadUChar() 
		Record["Rare"] := Bin.ReadUChar() 
		Record["Normal"] := Bin.ReadUChar() 
		Record["Charm"] := Bin.ReadUChar() 
		Record["Gem"] := Bin.ReadUChar() 
		Record["Beltable"] := Bin.ReadUChar() 
		Record["MaxSock1"] := Bin.ReadUChar() 
		Record["MaxSock25"] := Bin.ReadUChar() 
		Record["MaxSock40"] := Bin.ReadUChar() 
		Record["TreasureClass"] := Bin.ReadUChar() 
		Record["Rarity"] := Bin.ReadUChar() 
		Record["StaffMods"] := Bin.ReadUChar() 
		Record["CostFormula"] := Bin.ReadUChar() 
		Record["Class"] := Bin.ReadUChar() 
		Record["StorePage"] := Bin.ReadUChar() 
		Record["VarInvGfx"] := Bin.ReadUChar() 
		Record["InvGfx1"] := Trim(Bin.Read(32))
		Record["InvGfx2"] := Trim(Bin.Read(32))
		Record["InvGfx3"] := Trim(Bin.Read(32))
		Record["InvGfx4"] := Trim(Bin.Read(32))
		Record["InvGfx5"] := Trim(Bin.Read(32))
		Record["InvGfx6"] := Trim(Bin.Read(32))
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_leveldefs(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 156

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 156
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["QuestFlag"] := Bin.ReadInt() 
		Record["QuestFlagEx"] := Bin.ReadInt() 
		Record["Layer"] := Bin.ReadInt() 
		Record["SizeX"] := Bin.ReadInt() 
		Record["SizeX(N)"] := Bin.ReadInt() 
		Record["SizeX(H)"] := Bin.ReadInt() 
		Record["SizeY"] := Bin.ReadInt() 
		Record["SizeY(N)"] := Bin.ReadInt() 
		Record["SizeY(H)"] := Bin.ReadInt() 
		Record["OffsetX"] := Bin.ReadInt() 
		Record["OffsetY"] := Bin.ReadInt() 
		Record["Depend"] := Bin.ReadInt() 
		Record["DrlgType"] := Bin.ReadInt() 
		Record["LevelType"] := Bin.ReadInt() 
		Record["SubType"] := Bin.ReadInt() 
		Record["SubTheme"] := Bin.ReadInt() 
		Record["SubWaypoint"] := Bin.ReadInt() 
		Record["SubShrine"] := Bin.ReadInt() 
		Record["Vis0"] := Bin.ReadInt() 
		Record["Vis1"] := Bin.ReadInt() 
		Record["Vis2"] := Bin.ReadInt() 
		Record["Vis3"] := Bin.ReadInt() 
		Record["Vis4"] := Bin.ReadInt() 
		Record["Vis5"] := Bin.ReadInt() 
		Record["Vis6"] := Bin.ReadInt() 
		Record["Vis7"] := Bin.ReadInt() 
		Record["Warp0"] := Bin.ReadInt() 
		Record["Warp1"] := Bin.ReadInt() 
		Record["Warp2"] := Bin.ReadInt() 
		Record["Warp3"] := Bin.ReadInt() 
		Record["Warp4"] := Bin.ReadInt() 
		Record["Warp5"] := Bin.ReadInt() 
		Record["Warp6"] := Bin.ReadInt() 
		Record["Warp7"] := Bin.ReadInt() 
		Record["Intensity"] := Bin.ReadUChar() 
		Record["Red"] := Bin.ReadUChar() 
		Record["Green"] := Bin.ReadUChar() 
		Record["Blue"] := Bin.ReadUChar() 
		Record["Portal"] := Bin.ReadInt() 
		Record["Position"] := Bin.ReadInt() 
		Record["SaveMonsters"] := Bin.ReadUChar() 
		Record["LOSDraw"] := Bin.ReadInt()
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_levels(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 544

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 544
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Id"] := Bin.ReadUShort() 
		Record["Pal"] := Bin.ReadUChar() 
		Record["Act"] := Bin.ReadUChar() 
		Record["Teleport"] := Bin.ReadUChar() 
		Record["Rain"] := Bin.ReadUChar() 
		Record["Mud"] := Bin.ReadUChar() 
		Record["NoPer"] := Bin.ReadUChar() 
		Record["IsInside"] := Bin.ReadUChar() 
		Record["DrawEdges"] := Bin.ReadUChar() 
		Record["iPadding2"] := Bin.ReadUShort() 
		Record["WarpDist"] := Bin.ReadUInt() 
		Record["MonLvl1"] := Bin.ReadUShort() 
		Record["MonLvl2"] := Bin.ReadUShort() 
		Record["MonLvl3"] := Bin.ReadUShort() 
		Record["MonLvl1Ex"] := Bin.ReadUShort() 
		Record["MonLvl2Ex"] := Bin.ReadUShort() 
		Record["MonLvl3Ex"] := Bin.ReadUShort() 
		Record["MonDen"] := Bin.ReadUInt() 
		Record["MonDen(N)"] := Bin.ReadUInt() 
		Record["MonDen(H)"] := Bin.ReadUInt() 
		Record["MonUMin"] := Bin.ReadUChar() 
		Record["MonUMin(N)"] := Bin.ReadUChar() 
		Record["MonUMin(H)"] := Bin.ReadUChar() 
		Record["MonUMax"] := Bin.ReadUChar() 
		Record["MonUMax(N)"] := Bin.ReadUChar() 
		Record["MonUMax(H)"] := Bin.ReadUChar() 
		Record["MonWndr"] := Bin.ReadUChar() 
		Record["MonSpcWalk"] := Bin.ReadUChar() 
		Record["Quest"] := Bin.ReadUChar() 
		Record["rangedspawn"] := Bin.ReadUChar() 
		Record["NumMon"] := Bin.ReadUShort() 
		Record["iPadding13"] := Bin.ReadUShort() 
		Record["mon1"] := Bin.ReadUShort() 
		Record["mon2"] := Bin.ReadUShort() 
		Record["mon3"] := Bin.ReadUShort() 
		Record["mon4"] := Bin.ReadUShort() 
		Record["mon5"] := Bin.ReadUShort() 
		Record["mon6"] := Bin.ReadUShort() 
		Record["mon7"] := Bin.ReadUShort() 
		Record["mon8"] := Bin.ReadUShort() 
		Record["mon9"] := Bin.ReadUShort() 
		Record["mon10"] := Bin.ReadUShort() 
		Record["mon11"] := Bin.ReadUShort() 
		Record["mon12"] := Bin.ReadUShort() 
		Record["mon13"] := Bin.ReadUShort() 
		Record["mon14"] := Bin.ReadUShort() 
		Record["mon15"] := Bin.ReadUShort() 
		Record["mon16"] := Bin.ReadUShort() 
		Record["mon17"] := Bin.ReadUShort() 
		Record["mon18"] := Bin.ReadUShort() 
		Record["mon19"] := Bin.ReadUShort() 
		Record["mon20"] := Bin.ReadUShort() 
		Record["mon21"] := Bin.ReadUShort() 
		Record["mon22"] := Bin.ReadUShort() 
		Record["mon23"] := Bin.ReadUShort() 
		Record["mon24"] := Bin.ReadUShort() 
		Record["mon25"] := Bin.ReadUShort() 
		Record["nmon1"] := Bin.ReadUShort() 
		Record["nmon2"] := Bin.ReadUShort() 
		Record["nmon3"] := Bin.ReadUShort() 
		Record["nmon4"] := Bin.ReadUShort() 
		Record["nmon5"] := Bin.ReadUShort() 
		Record["nmon6"] := Bin.ReadUShort() 
		Record["nmon7"] := Bin.ReadUShort() 
		Record["nmon8"] := Bin.ReadUShort() 
		Record["nmon9"] := Bin.ReadUShort() 
		Record["nmon10"] := Bin.ReadUShort() 
		Record["nmon11"] := Bin.ReadUShort() 
		Record["nmon12"] := Bin.ReadUShort() 
		Record["nmon13"] := Bin.ReadUShort() 
		Record["nmon14"] := Bin.ReadUShort() 
		Record["nmon15"] := Bin.ReadUShort() 
		Record["nmon16"] := Bin.ReadUShort() 
		Record["nmon17"] := Bin.ReadUShort() 
		Record["nmon18"] := Bin.ReadUShort() 
		Record["nmon19"] := Bin.ReadUShort() 
		Record["nmon20"] := Bin.ReadUShort() 
		Record["nmon21"] := Bin.ReadUShort() 
		Record["nmon22"] := Bin.ReadUShort() 
		Record["nmon23"] := Bin.ReadUShort() 
		Record["nmon24"] := Bin.ReadUShort() 
		Record["nmon25"] := Bin.ReadUShort() 
		Record["umon1"] := Bin.ReadUShort() 
		Record["umon2"] := Bin.ReadUShort() 
		Record["umon3"] := Bin.ReadUShort() 
		Record["umon4"] := Bin.ReadUShort() 
		Record["umon5"] := Bin.ReadUShort() 
		Record["umon6"] := Bin.ReadUShort() 
		Record["umon7"] := Bin.ReadUShort() 
		Record["umon8"] := Bin.ReadUShort() 
		Record["umon9"] := Bin.ReadUShort() 
		Record["umon10"] := Bin.ReadUShort() 
		Record["umon11"] := Bin.ReadUShort() 
		Record["umon12"] := Bin.ReadUShort() 
		Record["umon13"] := Bin.ReadUShort() 
		Record["umon14"] := Bin.ReadUShort() 
		Record["umon15"] := Bin.ReadUShort() 
		Record["umon16"] := Bin.ReadUShort() 
		Record["umon17"] := Bin.ReadUShort() 
		Record["umon18"] := Bin.ReadUShort() 
		Record["umon19"] := Bin.ReadUShort() 
		Record["umon20"] := Bin.ReadUShort() 
		Record["umon21"] := Bin.ReadUShort() 
		Record["umon22"] := Bin.ReadUShort() 
		Record["umon23"] := Bin.ReadUShort() 
		Record["umon24"] := Bin.ReadUShort() 
		Record["umon25"] := Bin.ReadUShort() 
		Record["cmon1"] := Bin.ReadUShort() 
		Record["cmon2"] := Bin.ReadUShort() 
		Record["cmon3"] := Bin.ReadUShort() 
		Record["cmon4"] := Bin.ReadUShort() 
		Record["cpct1"] := Bin.ReadUShort() 
		Record["cpct2"] := Bin.ReadUShort() 
		Record["cpct3"] := Bin.ReadUShort() 
		Record["cpct4"] := Bin.ReadUShort() 
		Record["camt4"] := Bin.ReadUShort() 
		Record["iPadding55"] := Bin.ReadUShort() 
		Record["iPadding56"] := Bin.ReadUInt() 
		Record["Waypoint"] := Bin.ReadUChar() 
		Record["ObjGrp0"] := Bin.ReadUChar() 
		Record["ObjGrp1"] := Bin.ReadUChar() 
		Record["ObjGrp2"] := Bin.ReadUChar() 
		Record["ObjGrp3"] := Bin.ReadUChar() 
		Record["ObjGrp4"] := Bin.ReadUChar() 
		Record["ObjGrp5"] := Bin.ReadUChar() 
		Record["ObjGrp6"] := Bin.ReadUChar() 
		Record["ObjGrp7"] := Bin.ReadUChar() 
		Record["ObjPrb0"] := Bin.ReadUChar() 
		Record["ObjPrb1"] := Bin.ReadUChar() 
		Record["ObjPrb2"] := Bin.ReadUChar() 
		Record["ObjPrb3"] := Bin.ReadUChar() 
		Record["ObjPrb4"] := Bin.ReadUChar() 
		Record["ObjPrb5"] := Bin.ReadUChar() 
		Record["ObjPrb6"] := Bin.ReadUChar() 
		Record["ObjPrb7"] := Bin.ReadUChar() 
		Record["LevelName"] := Trim(Bin.Read(40))
		Record["LevelWarp"] := Trim(Bin.Read(40))
		Record["EntryFile"] := Trim(Bin.Read(39))
		;~ Bin.Read(164)
		Record["iPadding91"] := Bin.ReadUInt() 
		Record["iPadding92"] := Bin.ReadUInt() 
		Record["iPadding93"] := Bin.ReadUInt() 
		Record["iPadding94"] := Bin.ReadUInt() 
		Record["iPadding95"] := Bin.ReadUInt() 
		Record["iPadding96"] := Bin.ReadUInt() 
		Record["iPadding97"] := Bin.ReadUInt() 
		Record["iPadding98"] := Bin.ReadUInt() 
		Record["iPadding99"] := Bin.ReadUInt() 
		Record["iPadding100"] := Bin.ReadUInt() 
		Record["iPadding101"] := Bin.ReadUInt() 
		Record["iPadding102"] := Bin.ReadUInt() 
		Record["iPadding103"] := Bin.ReadUInt() 
		Record["iPadding104"] := Bin.ReadUInt() 
		Record["iPadding105"] := Bin.ReadUInt() 
		Record["iPadding106"] := Bin.ReadUInt() 
		Record["iPadding107"] := Bin.ReadUInt() 
		Record["iPadding108"] := Bin.ReadUInt() 
		Record["iPadding109"] := Bin.ReadUInt() 
		Record["iPadding110"] := Bin.ReadUInt() 
		Record["iPadding111"] := Bin.ReadUInt() 
		Record["iPadding112"] := Bin.ReadUInt() 
		Record["iPadding113"] := Bin.ReadUInt() 
		Record["iPadding114"] := Bin.ReadUInt() 
		Record["iPadding115"] := Bin.ReadUInt() 
		Record["iPadding116"] := Bin.ReadUInt() 
		Record["iPadding117"] := Bin.ReadUInt() 
		Record["iPadding118"] := Bin.ReadUInt() 
		Record["iPadding119"] := Bin.ReadUInt() 
		Record["iPadding120"] := Bin.ReadUInt() 
		Record["iPadding121"] := Bin.ReadUInt() 
		Record["iPadding122"] := Bin.ReadUInt() 
		Record["iPadding123"] := Bin.ReadUInt() 
		Record["iPadding124"] := Bin.ReadUInt() 
		Record["iPadding125"] := Bin.ReadUInt() 
		Record["iPadding126"] := Bin.ReadUInt() 
		Record["iPadding127"] := Bin.ReadUInt() 
		Record["iPadding128"] := Bin.ReadUInt() 
		Record["iPadding129"] := Bin.ReadUInt() 
		Record["iPadding130"] := Bin.ReadUInt() 
		Record["iPadding131"] := Bin.ReadUInt() 
		Record["Themes"] := Bin.ReadUInt() 
		Record["FloorFilter"] := Bin.ReadUInt() 
		Record["BlankScreen"] := Bin.ReadUInt() 
		Record["SoundEnv"] := Bin.ReadUInt()
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		
		kill=mon|25,nmon|25,umon|25,cmon|4
		RecordKill(Record,Kill,65535)
		
		kill=iPadding|131,cpct|4
		RecordKill(Record,Kill,0)
		
		kill=ObjGrp|8,ObjPrb
		RecordKill(Record,Kill,0,,-1)
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_lowqualityitems(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 34

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 34
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Name"] := Trim(Bin.Read(34))
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_lvlmaze(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 28

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 28
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Level"] := Bin.ReadUInt() 
		Record["Rooms"] := Bin.ReadUInt() 
		Record["Rooms(N)"] := Bin.ReadUInt() 
		Record["Rooms(H)"] := Bin.ReadUInt() 
		Record["SizeX"] := Bin.ReadUInt() 
		Record["SizeY"] := Bin.ReadUInt() 
		Record["Merge"] := Bin.ReadUInt()
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_lvlprest(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 432

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 432
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Def"] := Bin.ReadInt() 
		Record["LevelId"] := Bin.ReadInt() 
		Record["Populate"] := Bin.ReadInt() 
		Record["Logicals"] := Bin.ReadInt() 
		Record["Outdoors"] := Bin.ReadInt() 
		Record["Animate"] := Bin.ReadInt() 
		Record["KillEdge"] := Bin.ReadInt() 
		Record["FillBlanks"] := Bin.ReadInt() 
		Record["Expansion"] := Bin.ReadInt() 
		Record["iPadding9"] := Bin.ReadInt() 
		Record["SizeX"] := Bin.ReadInt() 
		Record["SizeY"] := Bin.ReadInt() 
		Record["AutoMap"] := Bin.ReadInt() 
		Record["Scan"] := Bin.ReadInt() 
		Record["Pops"] := Bin.ReadInt() 
		Record["PopPad"] := Bin.ReadInt() 
		Record["Files"] := Bin.ReadInt() 
		Record["File1"] := Trim(Bin.Read(60))
		Record["File2"] := Trim(Bin.Read(60))
		Record["File3"] := Trim(Bin.Read(60))
		Record["File4"] := Trim(Bin.Read(60))
		Record["File5"] := Trim(Bin.Read(60))
		Record["File6"] := Trim(Bin.Read(60))
		Record["Dt1Mask"] := Bin.ReadInt()
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		Kill=LevelId,Populate,Logicals,Outdoors,Animate,KillEdge,FillBlanks,Expansion,iPadding9,SizeX,SizeY,Scan,Pops,PopPad,File|6
		RecordKill(Record,Kill,0)
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_lvlsub(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 348

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 348
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Type"] := Bin.ReadInt() 
		Record["File"] := Trim(Bin.Read(60))
		Record["CheckAll"] := Bin.ReadInt() 
		Record["BordType"] := Bin.ReadInt() 
		Record["Dt1Mask"] := Bin.ReadInt() 
		Record["GridSize"] := Bin.ReadInt() 
		;~ Bin.Read(204)
		Record["iPadding20"] := Bin.ReadInt() 
		Record["iPadding21"] := Bin.ReadInt() 
		Record["iPadding22"] := Bin.ReadInt() 
		Record["iPadding23"] := Bin.ReadInt() 
		Record["iPadding24"] := Bin.ReadInt() 
		Record["iPadding25"] := Bin.ReadInt() 
		Record["iPadding26"] := Bin.ReadInt() 
		Record["iPadding27"] := Bin.ReadInt() 
		Record["iPadding28"] := Bin.ReadInt() 
		Record["iPadding29"] := Bin.ReadInt() 
		Record["iPadding30"] := Bin.ReadInt() 
		Record["iPadding31"] := Bin.ReadInt() 
		Record["iPadding32"] := Bin.ReadInt() 
		Record["iPadding33"] := Bin.ReadInt() 
		Record["iPadding34"] := Bin.ReadInt() 
		Record["iPadding35"] := Bin.ReadInt() 
		Record["iPadding36"] := Bin.ReadInt() 
		Record["iPadding37"] := Bin.ReadInt() 
		Record["iPadding38"] := Bin.ReadInt() 
		Record["iPadding39"] := Bin.ReadInt() 
		Record["iPadding40"] := Bin.ReadInt() 
		Record["iPadding41"] := Bin.ReadInt() 
		Record["iPadding42"] := Bin.ReadInt() 
		Record["iPadding43"] := Bin.ReadInt() 
		Record["iPadding44"] := Bin.ReadInt() 
		Record["iPadding45"] := Bin.ReadInt() 
		Record["iPadding46"] := Bin.ReadInt() 
		Record["iPadding47"] := Bin.ReadInt() 
		Record["iPadding48"] := Bin.ReadInt() 
		Record["iPadding49"] := Bin.ReadInt() 
		Record["iPadding50"] := Bin.ReadInt() 
		Record["iPadding51"] := Bin.ReadInt() 
		Record["iPadding52"] := Bin.ReadInt() 
		Record["iPadding53"] := Bin.ReadInt() 
		Record["iPadding54"] := Bin.ReadInt() 
		Record["iPadding55"] := Bin.ReadInt() 
		Record["iPadding56"] := Bin.ReadInt() 
		Record["iPadding57"] := Bin.ReadInt() 
		Record["iPadding58"] := Bin.ReadInt() 
		Record["iPadding59"] := Bin.ReadInt() 
		Record["iPadding60"] := Bin.ReadInt() 
		Record["iPadding61"] := Bin.ReadInt() 
		Record["iPadding62"] := Bin.ReadInt() 
		Record["iPadding63"] := Bin.ReadInt() 
		Record["iPadding64"] := Bin.ReadInt() 
		Record["iPadding65"] := Bin.ReadInt() 
		Record["iPadding66"] := Bin.ReadInt() 
		Record["iPadding67"] := Bin.ReadInt() 
		Record["iPadding68"] := Bin.ReadInt() 
		Record["iPadding69"] := Bin.ReadInt() 
		Record["iPadding70"] := Bin.ReadInt() 
		Record["Prob0"] := Bin.ReadInt() 
		Record["Prob1"] := Bin.ReadInt() 
		Record["Prob2"] := Bin.ReadInt() 
		Record["Prob3"] := Bin.ReadInt() 
		Record["Prob4"] := Bin.ReadInt() 
		Record["Trials0"] := Bin.ReadInt() 
		Record["Trials1"] := Bin.ReadInt() 
		Record["Trials2"] := Bin.ReadInt() 
		Record["Trials3"] := Bin.ReadInt() 
		Record["Trials4"] := Bin.ReadInt() 
		Record["Max0"] := Bin.ReadInt() 
		Record["Max1"] := Bin.ReadInt() 
		Record["Max2"] := Bin.ReadInt() 
		Record["Max3"] := Bin.ReadInt() 
		Record["Max4"] := Bin.ReadInt() 
		Record["Expansion"] := Bin.ReadInt()
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		
		Kill=iPadding|71,Prob|5,Trials|5,Max|5
		RecordKill(Record,Kill,0,,-1)
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_lvltypes(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 1928

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 1928
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Loop,32
			Record["File " a_index] := Bin.Read(60) 
		Record["Act"] := Bin.ReadUInt() 
		Record["Expansion"] := Bin.ReadUInt()
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		
		Kill=File |32
		RecordKill(Record,Kill,0)
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_lvlwarp(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 48

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 48
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Id"] := Bin.ReadInt() 
		Record["SelectX"] := Bin.ReadInt() 
		Record["SelectY"] := Bin.ReadInt() 
		Record["SelectDX"] := Bin.ReadInt() 
		Record["SelectDY"] := Bin.ReadInt() 
		Record["ExitWalkX"] := Bin.ReadInt() 
		Record["ExitWalkY"] := Bin.ReadInt() 
		Record["OffsetX"] := Bin.ReadInt() 
		Record["OffsetY"] := Bin.ReadInt() 
		Record["LitVersion"] := Bin.ReadInt() 
		Record["Tiles"] := Bin.ReadInt() 
		Record["Direction"] := Bin.Read(4)
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_magicprefix(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 144

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 144
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Name"] := Bin.Read(32) 
		Record["iPadding8"] := Bin.ReadUShort() 
		Record["version"] := Bin.ReadUShort() 
		Record["mod1code"] := Bin.ReadUInt() 
		Record["mod1param"] := Bin.ReadInt() 
		Record["mod1min"] := Bin.ReadInt() 
		Record["mod1max"] := Bin.ReadInt() 
		Record["mod2code"] := Bin.ReadUInt() 
		Record["mod2param"] := Bin.ReadInt() 
		Record["mod2min"] := Bin.ReadInt() 
		Record["mod2max"] := Bin.ReadInt() 
		Record["mod3code"] := Bin.ReadUInt() 
		Record["mod3param"] := Bin.ReadInt() 
		Record["mod3min"] := Bin.ReadInt() 
		Record["mod3max"] := Bin.ReadInt() 
		Record["spawnable"] := Bin.ReadUShort() 
		Record["transformcolor"] := Bin.ReadUShort() 
		Record["level"] := Bin.ReadUShort() 
		Record["iPadding22"] := Bin.ReadUShort() 
		Record["group"] := Bin.ReadUInt() 
		Record["maxlevel"] := Bin.ReadUInt() 
		Record["rare"] := Bin.ReadUChar() 
		Record["levelreq"] := Bin.ReadUChar() 
		Record["classspecific"] := Bin.ReadUChar() 
		Record["class"] := Bin.ReadUChar() 
		Record["classlevelreq"] := Bin.ReadUShort() 
		Record["itype1"] := Bin.ReadUShort() 
		Record["itype2"] := Bin.ReadUShort() 
		Record["itype3"] := Bin.ReadUShort() 
		Record["itype4"] := Bin.ReadUShort() 
		Record["itype5"] := Bin.ReadUShort() 
		Record["itype6"] := Bin.ReadUShort() 
		Record["itype7"] := Bin.ReadUShort() 
		Record["etype1"] := Bin.ReadUShort() 
		Record["etype2"] := Bin.ReadUShort() 
		Record["etype3"] := Bin.ReadUShort() 
		Record["etype4"] := Bin.ReadUShort() 
		Record["etype5"] := Bin.ReadUShort() 
		Record["frequency"] := Bin.ReadUShort() 
		Record["divide"] := Bin.ReadUInt() 
		Record["multiply"] := Bin.ReadUInt() 
		Record["add"] := Bin.ReadUInt()
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		
		Kill=itype|7,etype|5
		RecordKill(Record,kill,0)
		
		Kill=itype|7,etype|5
		RecordKill(Record,kill,65535)
		
		Kill=mod$code|15
		KillDepend=mod$param,mod$min,mod$max
		RecordKill(Record,kill,4294967295,KillDepend,,"$")
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_magicsuffix(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 144

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 144
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Name"] := Bin.Read(32) 
		Record["iPadding8"] := Bin.ReadUShort() 
		Record["version"] := Bin.ReadUShort() 
		Record["mod1code"] := Bin.ReadUInt() 
		Record["mod1param"] := Bin.ReadInt() 
		Record["mod1min"] := Bin.ReadInt() 
		Record["mod1max"] := Bin.ReadInt() 
		Record["mod2code"] := Bin.ReadUInt() 
		Record["mod2param"] := Bin.ReadInt() 
		Record["mod2min"] := Bin.ReadInt() 
		Record["mod2max"] := Bin.ReadInt() 
		Record["mod3code"] := Bin.ReadUInt() 
		Record["mod3param"] := Bin.ReadInt() 
		Record["mod3min"] := Bin.ReadInt() 
		Record["mod3max"] := Bin.ReadInt() 
		Record["spawnable"] := Bin.ReadUShort() 
		Record["transformcolor"] := Bin.ReadUShort() 
		Record["level"] := Bin.ReadUShort() 
		Record["iPadding22"] := Bin.ReadUShort() 
		Record["group"] := Bin.ReadUInt() 
		Record["maxlevel"] := Bin.ReadUInt() 
		Record["rare"] := Bin.ReadUChar() 
		Record["levelreq"] := Bin.ReadUChar() 
		Record["classspecific"] := Bin.ReadUChar() 
		Record["class"] := Bin.ReadUChar() 
		Record["classlevelreq"] := Bin.ReadUShort() 
		Record["itype1"] := Bin.ReadUShort() 
		Record["itype2"] := Bin.ReadUShort() 
		Record["itype3"] := Bin.ReadUShort() 
		Record["itype4"] := Bin.ReadUShort() 
		Record["itype5"] := Bin.ReadUShort() 
		Record["itype6"] := Bin.ReadUShort() 
		Record["itype7"] := Bin.ReadUShort() 
		Record["etype1"] := Bin.ReadUShort() 
		Record["etype2"] := Bin.ReadUShort() 
		Record["etype3"] := Bin.ReadUShort() 
		Record["etype4"] := Bin.ReadUShort() 
		Record["etype5"] := Bin.ReadUShort() 
		Record["frequency"] := Bin.ReadUShort() 
		Record["divide"] := Bin.ReadUInt() 
		Record["multiply"] := Bin.ReadUInt() 
		Record["add"] := Bin.ReadUInt()
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		
		Kill=itype|7,etype|5
		RecordKill(Record,kill,0)
		
		Kill=itype|7,etype|5
		RecordKill(Record,kill,65535)
		
		Kill=mod$code|15
		KillDepend=mod$param,mod$min,mod$max
		RecordKill(Record,kill,4294967295,KillDepend,,"$")
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_misc(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 424

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 424
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["flippyfile"] := Trim(Bin.Read(32))
		Record["invfile"] := Trim(Bin.Read(32))
		Record["uniqueinvfile"] := Trim(Bin.Read(32)) 
		Record["acPadding"] := Trim(Bin.Read(32))
		Record["code"] := Trim(Bin.Read(4))
		Record["acPad2"] := Trim(Bin.Read(12))
		Record["alternategfx"] := Trim(Bin.Read(4))
		Record["pSpell"] := Bin.ReadUInt() 
		Record["state"] := Bin.ReadUShort() 
		Record["cstate1"] := Bin.ReadUShort() 
		Record["cstate2"] := Bin.ReadUShort() 
		Record["stat1"] := Bin.ReadUShort() 
		Record["stat2"] := Bin.ReadUShort() 
		Record["stat3"] := Bin.ReadUShort() 
		Record["calc1"] := Bin.ReadUInt() 
		Record["calc2"] := Bin.ReadUInt() 
		Record["calc3"] := Bin.ReadUInt() 
		Record["len"] := Bin.ReadUInt() 
		Record["spelldesc"] := Bin.ReadUShort() 
		Record["spelldescstr"] := Bin.ReadUShort() 
		Record["spelldesccalc"] := Bin.ReadUInt() 
		Record["BetterGem"] := Trim(Bin.Read(4))
		Record["acPad6"] := Trim(Bin.Read(8))
		Record["TMogType"] := Trim(Bin.Read(4))
		Record["acPad7"] := Trim(Bin.Read(8))
		Record["gamble cost"] := Bin.ReadUInt() 
		Record["speed"] := Bin.ReadUChar() 
		Record["acPad9"] := Trim(Bin.Read(3))
		Record["bitfield1"] := Bin.ReadUChar() 
		Record["acPad10"] := Trim(Bin.Read(3))
		Record["cost"] := Bin.ReadUInt() 
		Record["minstack"] := Bin.ReadUInt() 
		Record["maxstack"] := Bin.ReadUInt() 
		Record["spawnstack"] := Bin.ReadUInt() 
		Record["gemoffset"] := Bin.ReadUShort() 
		Record["acPad12"] := Trim(Bin.Read(2))
		Record["namestr"] := Bin.ReadUShort() 
		Record["version"] := Bin.ReadUChar() 
		Record["acPad13"] := Trim(Bin.Read(1))
		Record["auto prefix"] := Bin.ReadUShort() 
		Record["missiletype"] := Bin.ReadUChar() 
		Record["bPad"] := Bin.ReadUChar() 
		Record["rarity"] := Bin.ReadUChar() 
		Record["level"] := Bin.ReadUChar() 
		Record["mindam"] := Bin.ReadUChar() 
		Record["maxdam"] := Bin.ReadUChar() 
		Record["acPad14"] := Trim(Bin.Read(15))
		Record["invwidth"] := Bin.ReadUChar() 
		Record["invheight"] := Bin.ReadUChar() 
		Record["acPad15"] := Trim(Bin.Read(2))
		Record["nodurability"] := Bin.ReadUChar() 
		Record["bPad2"] := Bin.ReadUChar() 
		Record["component"] := Bin.ReadUChar() 
		Record["acPad16"] := Trim(Bin.Read(7))
		Record["useable"] := Bin.ReadUChar() 
		Record["type"] := Bin.ReadUShort() 
		Record["type2"] := Bin.ReadUShort() 
		Record["acPad17"] := Trim(Bin.Read(2))
		Record["dropsound"] := Bin.ReadUShort() 
		Record["usesound"] := Bin.ReadUShort() 
		Record["dropsfxframe"] := Bin.ReadUChar() 
		Record["unique"] := Bin.ReadUChar() 
		Record["quest"] := Bin.ReadUChar() 
		Record["questdiffcheck"] := Bin.ReadUChar() 
		Record["transparent"] := Bin.ReadUChar() 
		Record["transtbl"] := Bin.ReadUChar() 
		Record["bPad4"] := Bin.ReadUChar() 
		Record["lightradius"] := Bin.ReadUChar() 
		Record["belt"] := Bin.ReadUChar() 
		Record["autobelt"] := Bin.ReadUChar() 
		Record["stackable"] := Bin.ReadUChar() 
		Record["spawnable"] := Bin.ReadUChar() 
		Record["spellicon"] := Bin.ReadChar() 
		Record["durwarning"] := Bin.ReadUChar() 
		Record["qntwarning"] := Bin.ReadUChar() 
		Record["hasinv"] := Bin.ReadUChar() 
		Record["gemsockets"] := Bin.ReadUChar() 
		Record["Transmogrify"] := Bin.ReadUChar() 
		Record["TMogMin"] := Bin.ReadUChar() 
		Record["TMogMax"] := Bin.ReadUChar() 
		Record["acPad18"] := Trim(Bin.Read(2))
		Record["gemapplytype"] := Bin.ReadUChar() 
		Record["levelreq"] := Bin.ReadUChar() 
		Record["bPad5"] := Bin.ReadUChar() 
		Record["Transform"] := Bin.ReadUChar() 
		Record["InvTrans"] := Bin.ReadUChar() 
		Record["compactsave"] := Bin.ReadUChar() 
		Record["SkipName"] := Bin.ReadUChar() 
		Record["Nameable"] := Bin.ReadUChar() 
		Record["AkaraMin"] := Bin.ReadUChar() 
		Record["GheedMin"] := Bin.ReadUChar() 
		Record["CharsiMin"] := Bin.ReadUChar() 
		Record["FaraMin"] := Bin.ReadUChar() 
		Record["LysanderMin"] := Bin.ReadUChar() 
		Record["DrognanMin"] := Bin.ReadUChar() 
		Record["HraltiMin"] := Bin.ReadUChar() 
		Record["AlkorMin"] := Bin.ReadUChar() 
		Record["OrmusMin"] := Bin.ReadUChar() 
		Record["ElzixMin"] := Bin.ReadUChar() 
		Record["AshearaMin"] := Bin.ReadUChar() 
		Record["CainMin"] := Bin.ReadUChar() 
		Record["HalbuMin"] := Bin.ReadUChar() 
		Record["JamellaMin"] := Bin.ReadUChar() 
		Record["MalahMin"] := Bin.ReadUChar() 
		Record["LarzukMin"] := Bin.ReadUChar() 
		Record["DrehyaMin"] := Bin.ReadUChar() 
		Record["AkaraMax"] := Bin.ReadUChar() 
		Record["GheedMax"] := Bin.ReadUChar() 
		Record["CharsiMax"] := Bin.ReadUChar() 
		Record["FaraMax"] := Bin.ReadUChar() 
		Record["LysanderMax"] := Bin.ReadUChar() 
		Record["DrognanMax"] := Bin.ReadUChar() 
		Record["HraltiMax"] := Bin.ReadUChar() 
		Record["AlkorMax"] := Bin.ReadUChar() 
		Record["OrmusMax"] := Bin.ReadUChar() 
		Record["ElzixMax"] := Bin.ReadUChar() 
		Record["AshearaMax"] := Bin.ReadUChar() 
		Record["CainMax"] := Bin.ReadUChar() 
		Record["HalbuMax"] := Bin.ReadUChar() 
		Record["JamellaMax"] := Bin.ReadUChar() 
		Record["MalahMax"] := Bin.ReadUChar() 
		Record["LarzukMax"] := Bin.ReadUChar() 
		Record["DrehyaMax"] := Bin.ReadUChar() 
		Record["AkaraMagicMin"] := Bin.ReadUChar() 
		Record["GheedMagicMin"] := Bin.ReadUChar() 
		Record["CharsiMagicMin"] := Bin.ReadUChar() 
		Record["FaraMagicMin"] := Bin.ReadUChar() 
		Record["LysanderMagicMin"] := Bin.ReadUChar() 
		Record["DrognanMagicMin"] := Bin.ReadUChar() 
		Record["HraltiMagicMin"] := Bin.ReadUChar() 
		Record["AlkorMagicMin"] := Bin.ReadUChar() 
		Record["OrmusMagicMin"] := Bin.ReadUChar() 
		Record["ElzixMagicMin"] := Bin.ReadUChar() 
		Record["AshearaMagicMin"] := Bin.ReadUChar() 
		Record["CainMagicMin"] := Bin.ReadUChar() 
		Record["HalbuMagicMin"] := Bin.ReadUChar() 
		Record["JamellaMagicMin"] := Bin.ReadUChar() 
		Record["MalahMagicMin"] := Bin.ReadUChar() 
		Record["LarzukMagicMin"] := Bin.ReadUChar() 
		Record["DrehyaMagicMin"] := Bin.ReadUChar() 
		Record["AkaraMagicMax"] := Bin.ReadUChar() 
		Record["GheedMagicMax"] := Bin.ReadUChar() 
		Record["CharsiMagicMax"] := Bin.ReadUChar() 
		Record["FaraMagicMax"] := Bin.ReadUChar() 
		Record["LysanderMagicMax"] := Bin.ReadUChar() 
		Record["DrognanMagicMax"] := Bin.ReadUChar() 
		Record["HraltiMagicMax"] := Bin.ReadUChar() 
		Record["AlkorMagicMax"] := Bin.ReadUChar() 
		Record["OrmusMagicMax"] := Bin.ReadUChar() 
		Record["ElzixMagicMax"] := Bin.ReadUChar() 
		Record["AshearaMagicMax"] := Bin.ReadUChar() 
		Record["CainMagicMax"] := Bin.ReadUChar() 
		Record["HalbuMagicMax"] := Bin.ReadUChar() 
		Record["JamellaMagicMax"] := Bin.ReadUChar() 
		Record["MalahMagicMax"] := Bin.ReadUChar() 
		Record["LarzukMagicMax"] := Bin.ReadUChar() 
		Record["DrehyaMagicMax"] := Bin.ReadUChar() 
		Record["AkaraMagicLvl"] := Bin.ReadUChar() 
		Record["GheedMagicLvl"] := Bin.ReadUChar() 
		Record["CharsiMagicLvl"] := Bin.ReadUChar() 
		Record["FaraMagicLvl"] := Bin.ReadUChar() 
		Record["LysanderMagicLvl"] := Bin.ReadUChar() 
		Record["DrognanMagicLvl"] := Bin.ReadUChar() 
		Record["HraltiMagicLvl"] := Bin.ReadUChar() 
		Record["AlkorMagicLvl"] := Bin.ReadUChar() 
		Record["OrmusMagicLvl"] := Bin.ReadUChar() 
		Record["ElzixMagicLvl"] := Bin.ReadUChar() 
		Record["AshearaMagicLvl"] := Bin.ReadUChar() 
		Record["CainMagicLvl"] := Bin.ReadUChar() 
		Record["HalbuMagicLvl"] := Bin.ReadUChar() 
		Record["JamellaMagicLvl"] := Bin.ReadUChar() 
		Record["MalahMagicLvl"] := Bin.ReadUChar() 
		Record["LarzukMagicLvl"] := Bin.ReadUChar() 
		Record["DrehyaMagicLvl"] := Bin.ReadUChar() 
		Record["bPad6"] := Bin.ReadUChar() 
		Record["NightmareUpgrade"] := Trim(Bin.Read(4))
		Record["HellUpgrade"] := Trim(Bin.Read(4))
		Record["PermStoreItem"] := Bin.ReadUChar() 
		Record["multibuy"] := Bin.ReadUChar() 
		Record["acPad20"] := Trim(Bin.Read(2))
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		Kill=AkaraMin,GheedMin,CharsiMin,FaraMin,LysanderMin,DrognanMin,HraltiMin,AlkorMin,OrmusMin,ElzixMin,AshearaMin,CainMin,HalbuMin,JamellaMin,MalahMin,LarzukMin,DrehyaMin,AkaraMax,GheedMax,CharsiMax,FaraMax,LysanderMax,DrognanMax,HraltiMax,AlkorMax,OrmusMax,ElzixMax,AshearaMax,CainMax,HalbuMax,JamellaMax,MalahMax,LarzukMax,DrehyaMax,AkaraMagicMin,GheedMagicMin,CharsiMagicMin,FaraMagicMin,LysanderMagicMin,DrognanMagicMin,HraltiMagicMin,AlkorMagicMin,OrmusMagicMin,ElzixMagicMin,AshearaMagicMin,CainMagicMin,HalbuMagicMin,JamellaMagicMin,MalahMagicMin,LarzukMagicMin,DrehyaMagicMin,AkaraMagicMax,GheedMagicMax,CharsiMagicMax,FaraMagicMax,LysanderMagicMax,DrognanMagicMax,HraltiMagicMax,AlkorMagicMax,OrmusMagicMax,ElzixMagicMax,AshearaMagicMax,CainMagicMax,HalbuMagicMax,JamellaMagicMax,MalahMagicMax,LarzukMagicMax,DrehyaMagicMax,AkaraMagicLvl,GheedMagicLvl,CharsiMagicLvl,FaraMagicLvl,LysanderMagicLvl,DrognanMagicLvl,HraltiMagicLvl,AlkorMagicLvl,OrmusMagicLvl,ElzixMagicLvl,AshearaMagicLvl,CainMagicLvl,HalbuMagicLvl,JamellaMagicLvl,MalahMagicLvl,LarzukMagicLvl,DrehyaMagicLvl
		RecordKill(Record,Kill,0)
		
		Kill=stat|3,cstate|2
		RecordKill(Record,Kill,65535)
		
		Kill=calc|3,len,spelldesccalc
		RecordKill(Record,Kill,4294967295)
		
		Kill=acPadding,acPad|20,bPad|6
		RecordKill(Record,Kill,"")
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_misscalc(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 4

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 4
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["code"] := Trim(Bin.Read(4))
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_misscode(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 0

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 0
		RecordID := a_index
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_monai(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 2

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 2
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Index"] := Bin.ReadUShort()
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_monequip(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 28

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 28
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["monster"] := Bin.ReadUShort() 
		Record["level"] := Bin.ReadUShort() 
		Record["oninit"] := Bin.ReadUInt() 
		Record["item1"] := Trim(Bin.Read(4))
		Record["item2"] := Trim(Bin.Read(4))
		Record["item3"] := Trim(Bin.Read(4))
		Record["loc1"] := Bin.ReadUChar() 
		Record["loc2"] := Bin.ReadUChar() 
		Record["loc3"] := Bin.ReadUChar() 
		Record["mod1"] := Bin.ReadUChar() 
		Record["mod2"] := Bin.ReadUChar() 
		Record["mod3"] := Bin.ReadUChar() 
		Record["iPadding6"] := Bin.ReadUShort()
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_monitempercent(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 4

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 4
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["HeartPercent"] := Bin.ReadUChar() 
		Record["BodyPartPercent"] := Bin.ReadUChar() 
		Record["TreasureClassPercent"] := Bin.ReadUChar() 
		Record["ComponentPercent"] := Bin.ReadUChar()
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_monlvl(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 120

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 120
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["AC"] := Bin.ReadUInt() 
		Record["AC(N)"] := Bin.ReadUInt() 
		Record["AC(H)"] := Bin.ReadUInt() 
		Record["L-AC"] := Bin.ReadUInt() 
		Record["L-AC(N)"] := Bin.ReadUInt() 
		Record["L-AC(H)"] := Bin.ReadUInt() 
		Record["TH"] := Bin.ReadUInt() 
		Record["TH(N)"] := Bin.ReadUInt() 
		Record["TH(H)"] := Bin.ReadUInt() 
		Record["L-TH"] := Bin.ReadUInt() 
		Record["L-TH(N)"] := Bin.ReadUInt() 
		Record["L-TH(H)"] := Bin.ReadUInt() 
		Record["HP"] := Bin.ReadUInt() 
		Record["HP(N)"] := Bin.ReadUInt() 
		Record["HP(H)"] := Bin.ReadUInt() 
		Record["L-HP"] := Bin.ReadUInt() 
		Record["L-HP(N)"] := Bin.ReadUInt() 
		Record["L-HP(H)"] := Bin.ReadUInt() 
		Record["DM"] := Bin.ReadUInt() 
		Record["DM(N)"] := Bin.ReadUInt() 
		Record["DM(H)"] := Bin.ReadUInt() 
		Record["L-DM"] := Bin.ReadUInt() 
		Record["L-DM(N)"] := Bin.ReadUInt() 
		Record["L-DM(H)"] := Bin.ReadUInt() 
		Record["XP"] := Bin.ReadUInt() 
		Record["XP(N)"] := Bin.ReadUInt() 
		Record["XP(H)"] := Bin.ReadUInt() 
		Record["L-XP"] := Bin.ReadUInt() 
		Record["L-XP(N)"] := Bin.ReadUInt() 
		Record["L-XP(H)"] := Bin.ReadUInt()
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_monmode(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 52

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 52
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["name"] := Trim(Bin.Read(32))
		Record["token"] := Trim(Bin.Read(20))
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_monplace(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 2

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 2
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Id"] := Bin.ReadUShort()
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_monpreset(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 4

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 4
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Act"] := Bin.ReadUChar() 
		Record["iPadding0"] := Bin.ReadUChar() 
		Record["Place"] := Bin.ReadUShort()
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_monprop(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 312

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 312
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Id"] := Bin.ReadUInt() 
		Record["prop1"] := Bin.ReadInt() 
		Record["par1"] := Bin.ReadInt() 
		Record["min1"] := Bin.ReadInt() 
		Record["max1"] := Bin.ReadInt() 
		Record["prop2"] := Bin.ReadInt() 
		Record["par2"] := Bin.ReadInt() 
		Record["min2"] := Bin.ReadInt() 
		Record["max2"] := Bin.ReadInt() 
		Record["prop3"] := Bin.ReadInt() 
		Record["par3"] := Bin.ReadInt() 
		Record["min3"] := Bin.ReadInt() 
		Record["max3"] := Bin.ReadInt() 
		Record["prop4"] := Bin.ReadInt() 
		Record["par4"] := Bin.ReadInt() 
		Record["min4"] := Bin.ReadInt() 
		Record["max4"] := Bin.ReadInt() 
		Record["prop5"] := Bin.ReadInt() 
		Record["par5"] := Bin.ReadInt() 
		Record["min5"] := Bin.ReadInt() 
		Record["max5"] := Bin.ReadInt() 
		Record["prop6"] := Bin.ReadInt() 
		Record["par6"] := Bin.ReadInt() 
		Record["min6"] := Bin.ReadInt() 
		Record["max6"] := Bin.ReadInt() 
		Record["prop1 (N)"] := Bin.ReadInt() 
		Record["par1 (N)"] := Bin.ReadInt() 
		Record["min1 (N)"] := Bin.ReadInt() 
		Record["max1 (N)"] := Bin.ReadInt() 
		Record["prop2 (N)"] := Bin.ReadInt() 
		Record["par2 (N)"] := Bin.ReadInt() 
		Record["min2 (N)"] := Bin.ReadInt() 
		Record["max2 (N)"] := Bin.ReadInt() 
		Record["prop3 (N)"] := Bin.ReadInt() 
		Record["par3 (N)"] := Bin.ReadInt() 
		Record["min3 (N)"] := Bin.ReadInt() 
		Record["max3 (N)"] := Bin.ReadInt() 
		Record["prop4 (N)"] := Bin.ReadInt() 
		Record["par4 (N)"] := Bin.ReadInt() 
		Record["min4 (N)"] := Bin.ReadInt() 
		Record["max4 (N)"] := Bin.ReadInt() 
		Record["prop5 (N)"] := Bin.ReadInt() 
		Record["par5 (N)"] := Bin.ReadInt() 
		Record["min5 (N)"] := Bin.ReadInt() 
		Record["max5 (N)"] := Bin.ReadInt() 
		Record["prop6 (N)"] := Bin.ReadInt() 
		Record["par6 (N)"] := Bin.ReadInt() 
		Record["min6 (N)"] := Bin.ReadInt() 
		Record["max6 (N)"] := Bin.ReadInt() 
		Record["prop1 (H)"] := Bin.ReadInt() 
		Record["par1 (H)"] := Bin.ReadInt() 
		Record["min1 (H)"] := Bin.ReadInt() 
		Record["max1 (H)"] := Bin.ReadInt() 
		Record["prop2 (H)"] := Bin.ReadInt() 
		Record["par2 (H)"] := Bin.ReadInt() 
		Record["min2 (H)"] := Bin.ReadInt() 
		Record["max2 (H)"] := Bin.ReadInt() 
		Record["prop3 (H)"] := Bin.ReadInt() 
		Record["par3 (H)"] := Bin.ReadInt() 
		Record["min3 (H)"] := Bin.ReadInt() 
		Record["max3 (H)"] := Bin.ReadInt() 
		Record["prop4 (H)"] := Bin.ReadInt() 
		Record["par4 (H)"] := Bin.ReadInt() 
		Record["min4 (H)"] := Bin.ReadInt() 
		Record["max4 (H)"] := Bin.ReadInt() 
		Record["prop5 (H)"] := Bin.ReadInt() 
		Record["par5 (H)"] := Bin.ReadInt() 
		Record["min5 (H)"] := Bin.ReadInt() 
		Record["max5 (H)"] := Bin.ReadInt() 
		Record["prop6 (H)"] := Bin.ReadInt() 
		Record["par6 (H)"] := Bin.ReadInt() 
		Record["min6 (H)"] := Bin.ReadInt() 
		Record["max6 (H)"] := Bin.ReadInt() 
		Record["chance1"] := Bin.ReadUChar() 
		Record["chance2"] := Bin.ReadUChar() 
		Record["chance3"] := Bin.ReadUChar() 
		Record["chance4"] := Bin.ReadUChar() 
		Record["chance5"] := Bin.ReadUChar() 
		Record["chance6"] := Bin.ReadUChar() 
		Record["chance1 (N)"] := Bin.ReadUChar() 
		Record["chance2 (N)"] := Bin.ReadUChar() 
		Record["chance3 (N)"] := Bin.ReadUChar() 
		Record["chance4 (N)"] := Bin.ReadUChar() 
		Record["chance5 (N)"] := Bin.ReadUChar() 
		Record["chance6 (N)"] := Bin.ReadUChar() 
		Record["chance1 (H)"] := Bin.ReadUChar() 
		Record["chance2 (H)"] := Bin.ReadUChar() 
		Record["chance3 (H)"] := Bin.ReadUChar() 
		Record["chance4 (H)"] := Bin.ReadUChar() 
		Record["chance5 (H)"] := Bin.ReadUChar() 
		Record["chance6 (H)"] := Bin.ReadUChar() 
		Record["iPadding77"] := Bin.ReadUShort()
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_monseq(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 6

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 6
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["iPadding0"] := Bin.ReadUShort() 
		Record["mode"] := Bin.ReadUChar() 
		Record["frame"] := Bin.ReadUChar() 
		Record["dir"] := Bin.ReadUChar() 
		Record["event"] := Bin.ReadUChar()
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_monsounds(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 148

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 148
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["iPadding0"] := Bin.ReadUInt() 
		Record["Attack1"] := Bin.ReadUInt() 
		Record["Att1Del"] := Bin.ReadUInt() 
		Record["Att1Prb"] := Bin.ReadUInt() 
		Record["Weapon1"] := Bin.ReadUInt() 
		Record["Wea1Del"] := Bin.ReadUInt() 
		Record["Wea1Vol"] := Bin.ReadUInt() 
		Record["Attack2"] := Bin.ReadUInt() 
		Record["Att2Del"] := Bin.ReadUInt() 
		Record["Att2Prb"] := Bin.ReadUInt() 
		Record["Weapon2"] := Bin.ReadUInt() 
		Record["Wea2Del"] := Bin.ReadUInt() 
		Record["Wea2Vol"] := Bin.ReadUInt() 
		Record["HitSound"] := Bin.ReadUInt() 
		Record["HitDelay"] := Bin.ReadUInt() 
		Record["DeathSound"] := Bin.ReadUInt() 
		Record["DeaDelay"] := Bin.ReadUInt() 
		Record["Skill1"] := Bin.ReadUInt() 
		Record["Skill2"] := Bin.ReadUInt() 
		Record["Skill3"] := Bin.ReadUInt() 
		Record["Skill4"] := Bin.ReadUInt() 
		Record["Footstep"] := Bin.ReadUInt() 
		Record["FootstepLayer"] := Bin.ReadUInt() 
		Record["FsCnt"] := Bin.ReadUInt() 
		Record["FsOff"] := Bin.ReadUInt() 
		Record["FsPrb"] := Bin.ReadUInt() 
		Record["Neutral"] := Bin.ReadUInt() 
		Record["NeuTime"] := Bin.ReadUInt() 
		Record["Init"] := Bin.ReadUInt() 
		Record["Taunt"] := Bin.ReadUInt() 
		Record["Flee"] := Bin.ReadUInt() 
		Record["CvtMo1"] := Bin.ReadUChar() 
		Record["CvtTgt1"] := Bin.ReadUChar() 
		Record["iPadding31"] := Bin.Read(2) 
		Record["CvtSk1"] := Bin.ReadUInt() 
		Record["CvtMo2"] := Bin.ReadUChar() 
		Record["CvtTgt2"] := Bin.ReadUChar() 
		Record["iPadding33"] := Bin.Read(2) 
		Record["CvtSk2"] := Bin.ReadUInt() 
		Record["CvtMo3"] := Bin.ReadUChar() 
		Record["CvtTgt3"] := Bin.ReadUChar() 
		Record["iPadding35"] := Bin.Read(2) 
		Record["CvtSk3"] := Bin.ReadUInt()
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_monstats(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 423

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 423
		;BITFIELDS ARE PRESENT!
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["hcIdx"] := Bin.ReadUShort() 
		Record["BaseId"] := Bin.ReadUShort() 
		Record["NextInClass"] := Bin.ReadUShort() 
		Record["NameStr"] := Bin.ReadUShort() 
		Record["DescStr"] := Bin.ReadUShort() 
		Record["iPadding2"] := Bin.ReadUShort() 
		Record["BitCombined1"] := Bin.ReadUChar() 
		Record["BitCombined2"] := Bin.ReadUChar() 
		Record["BitCombined3"] := Bin.ReadUChar() 
		Record["BitCombined4"] := Bin.ReadUChar() 
		
		;Start bitfield operations
		Flags := Record["BitCombined1"] Record["BitCombined2"] Record["BitCombined3"] Record["BitCombined4"]
		Record["primeevil"] := substr(Flags,1,1) 
		Record["boss"] := substr(Flags,2,1) 
		Record["BossXfer"] := substr(Flags,3,1) 
		Record["SetBoss"] := substr(Flags,4,1) 
		Record["opendoors"] := substr(Flags,5,1) 
		Record["noRatio"] := substr(Flags,6,1) 
		Record["isMelee"] := substr(Flags,7,1) 
		Record["isSpawn"] := substr(Flags,8,1) 
		Record["killable"] := substr(Flags,9,1) 
		Record["flying"] := substr(Flags,10,1) 
		Record["demon"] := substr(Flags,11,1) 
		Record["hUndead"] := substr(Flags,12,1) 
		Record["lUndead"] := substr(Flags,13,1) 
		Record["inTown"] := substr(Flags,14,1) 
		Record["interact"] := substr(Flags,15,1) 
		Record["npc"] := substr(Flags,16,1) 
		Record["placespawn"] := substr(Flags,17,1) 
		Record["zoo"] := substr(Flags,18,1) 
		Record["genericSpawn"] := substr(Flags,19,1) 
		Record["deathDmg"] := substr(Flags,20,1) 
		Record["petIgnore"] := substr(Flags,21,1) 
		Record["neverCount"] := substr(Flags,22,1) 
		Record["nomultishot"] := substr(Flags,23,1) 
		Record["switchai"] := substr(Flags,24,1) 
		Record["iPadding3"] := substr(Flags,27,3) 
		Record["rangedtype"] := substr(Flags,28,1) 
		Record["noAura"] := substr(Flags,29,1) 
		Record["NoShldBlock"] := substr(Flags,30,1) 
		Record["enabled"] := substr(Flags,31,1) 
		Record["inventory"] := substr(Flags,32,1) 
		Record["Code"] := Trim(Bin.Read(4))
		Record["MonSound"] := Bin.ReadUShort() 
		Record["UMonSound"] := Bin.ReadUShort() 
		Record["MonStatsEx"] := Bin.ReadUShort() 
		Record["MonProp"] := Bin.ReadUShort() 
		Record["MonType"] := Bin.ReadUShort() 
		Record["AI"] := Bin.ReadUShort() 
		Record["spawn"] := Bin.ReadUShort() 
		Record["spawnx"] := Bin.ReadChar() 
		Record["spawny"] := Bin.ReadChar() 
		Record["spawnmode"] := Bin.ReadUShort() 
		Record["minion1"] := Bin.ReadUShort() 
		Record["minion2"] := Bin.ReadUShort() 
		Record["iPadding10"] := Bin.ReadUShort() 
		Record["PartyMin"] := Bin.ReadUChar() 
		Record["PartyMax"] := Bin.ReadUChar() 
		Record["Rarity"] := Bin.ReadUChar() 
		Record["MinGrp"] := Bin.ReadUChar() 
		Record["MaxGrp"] := Bin.ReadUChar() 
		Record["sparsePopulate"] := Bin.ReadUChar() 
		Record["Velocity"] := Bin.ReadUShort() 
		Record["Run"] := Bin.ReadUShort() 
		Record["iPadding13"] := Bin.ReadUShort() 
		Record["iPadding14"] := Bin.ReadUShort() 
		Record["MissA1"] := Bin.ReadUShort() 
		Record["MissA2"] := Bin.ReadUShort() 
		Record["MissS1"] := Bin.ReadUShort() 
		Record["MissS2"] := Bin.ReadUShort() 
		Record["MissS3"] := Bin.ReadUShort() 
		Record["MissS4"] := Bin.ReadUShort() 
		Record["MissC"] := Bin.ReadUShort() 
		Record["MissSQ"] := Bin.ReadUShort() 
		Record["iPadding18"] := Bin.ReadUShort() 
		Record["Align"] := Bin.ReadUChar() 
		Record["TransLvl"] := Bin.ReadUChar() 
		Record["threat"] := Bin.ReadUChar() 
		Record["aidel"] := Bin.ReadUChar() 
		Record["aidel(N)"] := Bin.ReadUChar() 
		Record["aidel(H)"] := Bin.ReadUChar() 
		Record["aidist"] := Bin.ReadUChar() 
		Record["aidist(N)"] := Bin.ReadUChar() 
		Record["aidist(H)"] := Bin.ReadUChar() 
		Record["iPadding21"] := Bin.ReadUChar() 
		Record["aip1"] := Bin.ReadUShort() 
		Record["aip1(N)"] := Bin.ReadUShort() 
		Record["aip1(H)"] := Bin.ReadUShort() 
		Record["aip2"] := Bin.ReadUShort() 
		Record["aip2(N)"] := Bin.ReadUShort() 
		Record["aip2(H)"] := Bin.ReadUShort() 
		Record["aip3"] := Bin.ReadUShort() 
		Record["aip3(N)"] := Bin.ReadUShort() 
		Record["aip3(H)"] := Bin.ReadUShort() 
		Record["aip4"] := Bin.ReadUShort() 
		Record["aip4(N)"] := Bin.ReadUShort() 
		Record["aip4(H)"] := Bin.ReadUShort() 
		Record["aip5"] := Bin.ReadUShort() 
		Record["aip5(N)"] := Bin.ReadUShort() 
		Record["aip5(H)"] := Bin.ReadUShort() 
		Record["aip6"] := Bin.ReadUShort() 
		Record["aip6(N)"] := Bin.ReadUShort() 
		Record["aip6(H)"] := Bin.ReadUShort() 
		Record["aip7"] := Bin.ReadUShort() 
		Record["aip7(N)"] := Bin.ReadUShort() 
		Record["aip7(H)"] := Bin.ReadUShort() 
		Record["aip8"] := Bin.ReadUShort() 
		Record["aip8(N)"] := Bin.ReadUShort() 
		Record["aip8(H)"] := Bin.ReadUShort() 
		Record["TreasureClass1"] := Bin.ReadUShort() 
		Record["TreasureClass2"] := Bin.ReadUShort() 
		Record["TreasureClass3"] := Bin.ReadUShort() 
		Record["TreasureClass4"] := Bin.ReadUShort() 
		Record["TreasureClass1(N)"] := Bin.ReadUShort() 
		Record["TreasureClass2(N)"] := Bin.ReadUShort() 
		Record["TreasureClass3(N)"] := Bin.ReadUShort() 
		Record["TreasureClass4(N)"] := Bin.ReadUShort() 
		Record["TreasureClass1(H)"] := Bin.ReadUShort() 
		Record["TreasureClass2(H)"] := Bin.ReadUShort() 
		Record["TreasureClass3(H)"] := Bin.ReadUShort() 
		Record["TreasureClass4(H)"] := Bin.ReadUShort() 
		Record["TCQuestId"] := Bin.ReadUChar() 
		Record["TCQuestCP"] := Bin.ReadUChar() 
		Record["Drain"] := Bin.ReadUChar() 
		Record["Drain(N)"] := Bin.ReadUChar() 
		Record["Drain(H)"] := Bin.ReadUChar() 
		Record["ToBlock"] := Bin.ReadUChar() 
		Record["ToBlock(N)"] := Bin.ReadUChar() 
		Record["ToBlock(H)"] := Bin.ReadUChar() 
		Record["Crit"] := Bin.ReadUShort() 
		Record["SkillDamage"] := Bin.ReadUShort() 
		Record["Level"] := Bin.ReadUShort() 
		Record["Level(N)"] := Bin.ReadUShort() 
		Record["Level(H)"] := Bin.ReadUShort() 
		Record["minHP"] := Bin.ReadUShort() 
		Record["MinHP(N)"] := Bin.ReadUShort() 
		Record["MinHP(H)"] := Bin.ReadUShort() 
		Record["maxHP"] := Bin.ReadUShort() 
		Record["MaxHP(N)"] := Bin.ReadUShort() 
		Record["MaxHP(H)"] := Bin.ReadUShort() 
		Record["AC"] := Bin.ReadUShort() 
		Record["AC(N)"] := Bin.ReadUShort() 
		Record["AC(H)"] := Bin.ReadUShort() 
		Record["A1TH"] := Bin.ReadUShort() 
		Record["A1TH(N)"] := Bin.ReadUShort() 
		Record["A1TH(H)"] := Bin.ReadUShort() 
		Record["A2TH"] := Bin.ReadUShort() 
		Record["A2TH(N)"] := Bin.ReadUShort() 
		Record["A2TH(H)"] := Bin.ReadUShort() 
		Record["S1TH"] := Bin.ReadUShort() 
		Record["S1TH(N)"] := Bin.ReadUShort() 
		Record["S1TH(H)"] := Bin.ReadUShort() 
		Record["Exp"] := Bin.ReadUShort() 
		Record["Exp(N)"] := Bin.ReadUShort() 
		Record["Exp(H)"] := Bin.ReadUShort() 
		Record["A1MinD"] := Bin.ReadUShort() 
		Record["A1MinD(N)"] := Bin.ReadUShort() 
		Record["A1MinD(H)"] := Bin.ReadUShort() 
		Record["A1MaxD"] := Bin.ReadUShort() 
		Record["A1MaxD(N)"] := Bin.ReadUShort() 
		Record["A1MaxD(H)"] := Bin.ReadUShort() 
		Record["A2MinD"] := Bin.ReadUShort() 
		Record["A2MinD(N)"] := Bin.ReadUShort() 
		Record["A2MinD(H)"] := Bin.ReadUShort() 
		Record["A2MaxD"] := Bin.ReadUShort() 
		Record["A2MaxD(N)"] := Bin.ReadUShort() 
		Record["A2MaxD(H)"] := Bin.ReadUShort() 
		Record["S1MinD"] := Bin.ReadUShort() 
		Record["S1MinD(N)"] := Bin.ReadUShort() 
		Record["S1MinD(H)"] := Bin.ReadUShort() 
		Record["S1MaxD"] := Bin.ReadUShort() 
		Record["S1MaxD(N)"] := Bin.ReadUShort() 
		Record["S1MaxD(H)"] := Bin.ReadUShort() 
		Record["El1Mode"] := Bin.ReadUChar() 
		Record["El2Mode"] := Bin.ReadUChar() 
		Record["El3Mode"] := Bin.ReadUChar() 
		Record["El1Type"] := Bin.ReadUChar() 
		Record["El2Type"] := Bin.ReadUChar() 
		Record["El3Type"] := Bin.ReadUChar() 
		Record["El1Pct"] := Bin.ReadUChar() 
		Record["El1Pct(N)"] := Bin.ReadUChar() 
		Record["El1Pct(H)"] := Bin.ReadUChar() 
		Record["El2Pct"] := Bin.ReadUChar() 
		Record["El2Pct(N)"] := Bin.ReadUChar() 
		Record["El2Pct(H)"] := Bin.ReadUChar() 
		Record["El3Pct"] := Bin.ReadUChar() 
		Record["El3Pct(N)"] := Bin.ReadUChar() 
		Record["El3Pct(H)"] := Bin.ReadUChar() 
		Record["iPadding67"] := Bin.ReadUChar() 
		Record["El1MinD"] := Bin.ReadUShort() 
		Record["El1MinD(N)"] := Bin.ReadUShort() 
		Record["El1MinD(H)"] := Bin.ReadUShort() 
		Record["El2MinD"] := Bin.ReadUShort() 
		Record["El2MinD(N)"] := Bin.ReadUShort() 
		Record["El2MinD(H)"] := Bin.ReadUShort() 
		Record["El3MinD"] := Bin.ReadUShort() 
		Record["El3MinD(N)"] := Bin.ReadUShort() 
		Record["El3MinD(H)"] := Bin.ReadUShort() 
		Record["El1MaxD"] := Bin.ReadUShort() 
		Record["El1MaxD(N)"] := Bin.ReadUShort() 
		Record["El1MaxD(H)"] := Bin.ReadUShort() 
		Record["El2MaxD"] := Bin.ReadUShort() 
		Record["El2MaxD(N)"] := Bin.ReadUShort() 
		Record["El2MaxD(H)"] := Bin.ReadUShort() 
		Record["El3MaxD"] := Bin.ReadUShort() 
		Record["El3MaxD(N)"] := Bin.ReadUShort() 
		Record["El3MaxD(H)"] := Bin.ReadUShort() 
		Record["El1Dur"] := Bin.ReadUShort() 
		Record["El1Dur(N)"] := Bin.ReadUShort() 
		Record["El1Dur(H)"] := Bin.ReadUShort() 
		Record["El2Dur"] := Bin.ReadUShort() 
		Record["El2Dur(N)"] := Bin.ReadUShort() 
		Record["El2Dur(H)"] := Bin.ReadUShort() 
		Record["El3Dur"] := Bin.ReadUShort() 
		Record["El3Dur(N)"] := Bin.ReadUShort() 
		Record["El3Dur(H)"] := Bin.ReadUShort() 
		Record["ResDm"] := Bin.ReadShort() 
		Record["ResDm(N)"] := Bin.ReadShort() 
		Record["ResDm(H)"] := Bin.ReadShort() 
		Record["ResMa"] := Bin.ReadShort() 
		Record["ResMa(N)"] := Bin.ReadShort() 
		Record["ResMa(H)"] := Bin.ReadShort() 
		Record["ResFi"] := Bin.ReadShort() 
		Record["ResFi(N)"] := Bin.ReadShort() 
		Record["ResFi(H)"] := Bin.ReadShort() 
		Record["ResLi"] := Bin.ReadShort() 
		Record["ResLi(N)"] := Bin.ReadShort() 
		Record["ResLi(H)"] := Bin.ReadShort() 
		Record["ResCo"] := Bin.ReadShort() 
		Record["ResCo(N)"] := Bin.ReadShort() 
		Record["ResCo(H)"] := Bin.ReadShort() 
		Record["ResPo"] := Bin.ReadShort() 
		Record["ResPo(N)"] := Bin.ReadShort() 
		Record["ResPo(H)"] := Bin.ReadShort() 
		Record["coldeffect"] := Bin.ReadChar() 
		Record["coldeffect(N)"] := Bin.ReadChar() 
		Record["coldeffect(H)"] := Bin.ReadChar() 
		Record["iPadding90"] := Bin.ReadUChar() 
		Record["SendSkills"] := Bin.ReadUInt() 
		Record["Skill1"] := Bin.ReadUShort() 
		Record["Skill2"] := Bin.ReadUShort() 
		Record["Skill3"] := Bin.ReadUShort() 
		Record["Skill4"] := Bin.ReadUShort() 
		Record["Skill5"] := Bin.ReadUShort() 
		Record["Skill6"] := Bin.ReadUShort() 
		Record["Skill7"] := Bin.ReadUShort() 
		Record["Skill8"] := Bin.ReadUShort() 
		Record["Sk1modeType"] := Bin.ReadUChar() 
		Record["Sk2modeType"] := Bin.ReadUChar() 
		Record["Sk3modeType"] := Bin.ReadUChar() 
		Record["Sk4modeType"] := Bin.ReadUChar() 
		Record["Sk5modeType"] := Bin.ReadUChar() 
		Record["Sk6modeType"] := Bin.ReadUChar() 
		Record["Sk7modeType"] := Bin.ReadUChar() 
		Record["Sk8modeType"] := Bin.ReadUChar() 
		Record["Sk1mode"] := Bin.ReadUShort() 
		Record["Sk2mode"] := Bin.ReadUShort() 
		Record["Sk3mode"] := Bin.ReadUShort() 
		Record["Sk4mode"] := Bin.ReadUShort() 
		Record["Sk5mode"] := Bin.ReadUShort() 
		Record["Sk6mode"] := Bin.ReadUShort() 
		Record["Sk7mode"] := Bin.ReadUShort() 
		Record["Sk8mode"] := Bin.ReadUShort() 
		Record["Sk1lvl"] := Bin.ReadUChar() 
		Record["Sk2lvl"] := Bin.ReadUChar() 
		Record["Sk3lvl"] := Bin.ReadUChar() 
		Record["Sk4lvl"] := Bin.ReadUChar() 
		Record["Sk5lvl"] := Bin.ReadUChar() 
		Record["Sk6lvl"] := Bin.ReadUChar() 
		Record["Sk7lvl"] := Bin.ReadUChar() 
		Record["Sk8lvl"] := Bin.ReadUChar() 
		Record["DamageRegen"] := Bin.ReadUInt() 
		Record["SplEndDeath"] := Bin.ReadUChar() 
		Record["SplGetModeChart"] := Bin.ReadUChar() 
		Record["SplEndGeneric"] := Bin.ReadUChar() 
		Record["SplClientEnd"] := Bin.ReadUChar()
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_monstats2(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 308

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 308
		;BITFIELDS ARE PRESENT!
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Id"] := Bin.ReadUInt() 
		Record["BitCombined1"] := Bin.ReadUChar() 
		Record["BitCombined2"] := Bin.ReadUChar() 
		Record["BitCombined3"] := Bin.ReadUChar() 
		
		;Start bitfield operations
		Flags := Record["BitCombined1"] Record["BitCombined2"] Record["BitCombined3"]
		Record["corpseSel"] := substr(Flags,1,1) 
		Record["shiftSel"] := substr(Flags,2,1) 
		Record["noSel"] := substr(Flags,3,1) 
		Record["alSel"] := substr(Flags,4,1) 
		Record["isSel"] := substr(Flags,5,1) 
		Record["noOvly"] := substr(Flags,6,1) 
		Record["noMap"] := substr(Flags,7,1) 
		Record["noGfxHitTest"] := substr(Flags,8,1) 
		Record["noUniqueShift"] := substr(Flags,9,1) 
		Record["Shadow"] := substr(Flags,10,1) 
		Record["critter"] := substr(Flags,11,1) 
		Record["soft"] := substr(Flags,12,1) 
		Record["large"] := substr(Flags,13,1) 
		Record["small"] := substr(Flags,14,1) 
		Record["isAtt"] := substr(Flags,15,1) 
		Record["revive"] := substr(Flags,16,1) 
		Record["iPadding1_2"] := substr(Flags,19,3) 
		Record["unflatDead"] := substr(Flags,20,1) 
		Record["deadCol"] := substr(Flags,21,1) 
		Record["objCol"] := substr(Flags,22,1) 
		Record["inert"] := substr(Flags,23,1) 
		Record["compositeDeath"] := substr(Flags,24,1) 
		Record["iPadding1"] := Bin.ReadUChar() 
		Record["SizeX"] := Bin.ReadUChar() 
		Record["SizeY"] := Bin.ReadUChar() 
		Record["spawnCol"] := Bin.ReadUChar() 
		Record["Height"] := Bin.ReadUChar() 
		Record["OverlayHeight"] := Bin.ReadUChar() 
		Record["pixHeight"] := Bin.ReadUChar() 
		Record["MeleeRng"] := Bin.ReadUChar() 
		Record["iPadding3"] := Bin.ReadUChar() 
		Record["BaseW"] := Trim(Bin.Read(4))
		Record["HitClass"] := Bin.ReadUChar() 
		Record["HDvNum"] := Bin.ReadUChar() 
		Record["TRvNum"] := Bin.ReadUChar() 
		Record["LGvNum"] := Bin.ReadUChar() 
		Record["RavNum"] := Bin.ReadUChar() 
		Record["LavNum"] := Bin.ReadUChar() 
		Record["RHvNum"] := Bin.ReadUChar() 
		Record["LHvNum"] := Bin.ReadUChar() 
		Record["SHvNum"] := Bin.ReadUChar() 
		Record["S1vNum"] := Bin.ReadUChar() 
		Record["S2vNum"] := Bin.ReadUChar() 
		Record["S3vNum"] := Bin.ReadUChar() 
		Record["S4vNum"] := Bin.ReadUChar() 
		Record["S5vNum"] := Bin.ReadUChar() 
		Record["S6vNum"] := Bin.ReadUChar() 
		Record["S7vNum"] := Bin.ReadUChar() 
		Record["S8vNum"] := Bin.ReadUChar() 
		Record["iPadding9"] := Bin.ReadUChar() 
		Record["HDv"] := Trim(Bin.Read(12))
		Record["TRv"] := Trim(Bin.Read(12))
		Record["LGv"] := Trim(Bin.Read(12))
		Record["Rav"] := Trim(Bin.Read(12))
		Record["Lav"] := Trim(Bin.Read(12))
		Record["RHv"] := Trim(Bin.Read(12))
		Record["LHv"] := Trim(Bin.Read(12))
		Record["SHv"] := Trim(Bin.Read(12))
		Record["S1v"] := Trim(Bin.Read(12))
		Record["S2v"] := Trim(Bin.Read(12))
		Record["S3v"] := Trim(Bin.Read(12))
		Record["S4v"] := Trim(Bin.Read(12))
		Record["S5v"] := Trim(Bin.Read(12))
		Record["S6v"] := Trim(Bin.Read(12))
		Record["S7v"] := Trim(Bin.Read(12))
		Record["S8v"] := Trim(Bin.Read(12))
		Record["iPadding57"] := Bin.ReadUShort() 
		Record["BitCombined4"] := Bin.ReadUChar() 
		Record["BitCombined5"] := Bin.ReadUChar() 
		Record["SH"] := substr(Flags,25,1) 
		Record["LH"] := substr(Flags,26,1) 
		Record["RH"] := substr(Flags,27,1) 
		Record["LA"] := substr(Flags,28,1) 
		Record["RA"] := substr(Flags,29,1) 
		Record["LG"] := substr(Flags,30,1) 
		Record["TR"] := substr(Flags,31,1) 
		Record["HD"] := substr(Flags,32,1) 
		Record["S8"] := substr(Flags,33,1) 
		Record["S7"] := substr(Flags,34,1) 
		Record["S6"] := substr(Flags,35,1) 
		Record["S5"] := substr(Flags,36,1) 
		Record["S4"] := substr(Flags,37,1) 
		Record["S3"] := substr(Flags,38,1) 
		Record["S2"] := substr(Flags,39,1) 
		Record["S1"] := substr(Flags,40,1) 
		Record["iPadding58"] := Bin.Read(2) 
		Record["TotalPieces"] := Bin.ReadUInt() 
		Record["BitCombined6"] := Bin.ReadUChar() 
		Record["BitCombined7"] := Bin.ReadUChar() 
		Record["mSC"] := substr(Flags,41,1) 
		Record["mBL"] := substr(Flags,42,1) 
		Record["mA2"] := substr(Flags,43,1) 
		Record["mA1"] := substr(Flags,44,1) 
		Record["mGH"] := substr(Flags,45,1) 
		Record["mWL"] := substr(Flags,46,1) 
		Record["mNU"] := substr(Flags,47,1) 
		Record["mDT"] := substr(Flags,48,1) 
		Record["mRN"] := substr(Flags,49,1) 
		Record["mSQ"] := substr(Flags,50,1) 
		Record["mKB"] := substr(Flags,51,1) 
		Record["mDD"] := substr(Flags,52,1) 
		Record["mS4"] := substr(Flags,53,1) 
		Record["mS3"] := substr(Flags,54,1) 
		Record["mS2"] := substr(Flags,55,1) 
		Record["mS1"] := substr(Flags,56,1) 
		Record["iPadding60"] := Bin.ReadUShort() 
		Record["dDT"] := Bin.ReadUChar() 
		Record["dNU"] := Bin.ReadUChar() 
		Record["dWL"] := Bin.ReadUChar() 
		Record["dGH"] := Bin.ReadUChar() 
		Record["dA1"] := Bin.ReadUChar() 
		Record["dA2"] := Bin.ReadUChar() 
		Record["dBL"] := Bin.ReadUChar() 
		Record["dSC"] := Bin.ReadUChar() 
		Record["dS1"] := Bin.ReadUChar() 
		Record["dS2"] := Bin.ReadUChar() 
		Record["dS3"] := Bin.ReadUChar() 
		Record["dS4"] := Bin.ReadUChar() 
		Record["dDD"] := Bin.ReadUChar() 
		Record["dKB"] := Bin.ReadUChar() 
		Record["dSQ"] := Bin.ReadUChar() 
		Record["dRN"] := Bin.ReadUChar() 
		Record["BitCombined8"] := Bin.ReadUChar() 
		Record["BitCombined9"] := Bin.ReadUChar() 
		Record["SCmv"] := substr(Flags,57,1) 
		Record["iPadding65_1"] := substr(Flags,58,1) 
		Record["A2mv"] := substr(Flags,59,1) 
		Record["A1mv"] := substr(Flags,60,1) 
		Record["iPadding65"] := substr(Flags,64,4) 
		Record["iPadding65_2"] := substr(Flags,68,4) 
		Record["S4mv"] := substr(Flags,69,1) 
		Record["S3mv"] := substr(Flags,70,1) 
		Record["S2mv"] := substr(Flags,71,1) 
		Record["S1mv"] := substr(Flags,72,1) 
		Record["iPadding65"] := Bin.Read(2) 
		Record["InfernoLen"] := Bin.ReadUChar() 
		Record["InfernoAnim"] := Bin.ReadUChar() 
		Record["InfernoRollback"] := Bin.ReadUChar() 
		Record["ResurrectMode"] := Bin.ReadUChar() 
		Record["ResurrectSkill"] := Bin.ReadUShort() 
		Record["htTop"] := Bin.ReadShort() 
		Record["htLeft"] := Bin.ReadShort() 
		Record["htWidth"] := Bin.ReadShort() 
		Record["htHeight"] := Bin.ReadShort() 
		Record["iPadding69"] := Bin.ReadUShort() 
		Record["automapCel"] := Bin.ReadUInt() 
		Record["localBlood"] := Bin.ReadUChar() 
		Record["Bleed"] := Bin.ReadUChar() 
		Record["Light"] := Bin.ReadUChar() 
		Record["light-r"] := Bin.ReadUChar() 
		Record["light-g"] := Bin.ReadUChar() 
		Record["light-b"] := Bin.ReadUChar() 
		Record["Utrans"] := Bin.ReadUChar() 
		Record["Utrans(N)"] := Bin.ReadUChar() 
		Record["Utrans(H)"] := Bin.ReadUChar() 
		Record["acPaddding"] := Bin.Read(3) 
		Record["Heart"] := Trim(Bin.Read(4))
		Record["BodyPart"] := Trim(Bin.Read(4))
		Record["restore"] := Bin.ReadUInt()
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_montype()
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 12

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 12
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["iPadding0"] := Bin.ReadUShort() 
		Record["equiv1"] := Bin.ReadUShort() 
		Record["equiv2"] := Bin.ReadUShort() 
		Record["equiv3"] := Bin.ReadUShort() 
		Record["strsing"] := Bin.ReadUShort() 
		Record["strplur"] := Bin.ReadUShort()
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_monumod(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 32

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 32
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["id"] := Bin.ReadUInt() 
		Record["version"] := Bin.ReadUShort() 
		Record["enabled"] := Bin.ReadUChar() 
		Record["xfer"] := Bin.ReadUChar() 
		Record["champion"] := Bin.ReadUChar() 
		Record["fPick"] := Bin.ReadUChar() 
		Record["exclude1"] := Bin.ReadUShort() 
		Record["exclude2"] := Bin.ReadUShort() 
		Record["cpick"] := Bin.ReadUShort() 
		Record["cpick (N)"] := Bin.ReadUShort() 
		Record["cpick (H)"] := Bin.ReadUShort() 
		Record["upick"] := Bin.ReadUShort() 
		Record["upick (N)"] := Bin.ReadUShort() 
		Record["upick (H)"] := Bin.ReadUShort() 
		Record["iPadding6"] := Bin.ReadUShort() 
		Record["constants"] := Bin.ReadUInt()
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_npc(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 76

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 76
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["npc"] := Bin.ReadUInt() 
		Record["sell mult"] := Bin.ReadUInt() 
		Record["buy mult"] := Bin.ReadUInt() 
		Record["rep mult"] := Bin.ReadUInt() 
		Record["questflag A"] := Bin.ReadUInt() 
		Record["questflag B"] := Bin.ReadUInt() 
		Record["questflag C"] := Bin.ReadUInt() 
		Record["questsellmult A"] := Bin.ReadUInt() 
		Record["questsellmult B"] := Bin.ReadUInt() 
		Record["questsellmult C"] := Bin.ReadUInt() 
		Record["questbuymult A"] := Bin.ReadUInt() 
		Record["questbuymult B"] := Bin.ReadUInt() 
		Record["questbuymult C"] := Bin.ReadUInt() 
		Record["questrepmult A"] := Bin.ReadUInt() 
		Record["questrepmult B"] := Bin.ReadUInt() 
		Record["questrepmult C"] := Bin.ReadUInt() 
		Record["max buy"] := Bin.ReadUInt() 
		Record["max buy (N)"] := Bin.ReadUInt() 
		Record["max buy (H)"] := Bin.ReadUInt()
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_objects(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 448

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 448
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Name"] := Bin.Read(64) 
		Record["iPadding16"] := Bin.ReadUInt() 
		Record["iPadding17"] := Bin.ReadUInt() 
		Record["iPadding18"] := Bin.ReadUInt() 
		Record["iPadding19"] := Bin.ReadUInt() 
		Record["iPadding20"] := Bin.ReadUInt() 
		Record["iPadding21"] := Bin.ReadUInt() 
		Record["iPadding22"] := Bin.ReadUInt() 
		Record["iPadding23"] := Bin.ReadUInt() 
		Record["iPadding24"] := Bin.ReadUInt() 
		Record["iPadding25"] := Bin.ReadUInt() 
		Record["iPadding26"] := Bin.ReadUInt() 
		Record["iPadding27"] := Bin.ReadUInt() 
		Record["iPadding28"] := Bin.ReadUInt() 
		Record["iPadding29"] := Bin.ReadUInt() 
		Record["iPadding30"] := Bin.ReadUInt() 
		Record["iPadding31"] := Bin.ReadUInt() 
		Record["iPadding32"] := Bin.ReadUInt() 
		Record["iPadding33"] := Bin.ReadUInt() 
		Record["iPadding34"] := Bin.ReadUInt() 
		Record["iPadding35"] := Bin.ReadUInt() 
		Record["iPadding36"] := Bin.ReadUInt() 
		Record["iPadding37"] := Bin.ReadUInt() 
		Record["iPadding38"] := Bin.ReadUInt() 
		Record["iPadding39"] := Bin.ReadUInt() 
		Record["iPadding40"] := Bin.ReadUInt() 
		Record["iPadding41"] := Bin.ReadUInt() 
		Record["iPadding42"] := Bin.ReadUInt() 
		Record["iPadding43"] := Bin.ReadUInt() 
		Record["iPadding44"] := Bin.ReadUInt() 
		Record["iPadding45"] := Bin.ReadUInt() 
		Record["iPadding46"] := Bin.ReadUInt() 
		Record["iPadding47"] := Bin.ReadUInt() 
		Record["Token"] := Trim(Bin.Read(3))
		Record["SpawnMax"] := Bin.ReadUChar() 
		Record["Selectable0"] := Bin.ReadUChar() 
		Record["Selectable1"] := Bin.ReadUChar() 
		Record["Selectable2"] := Bin.ReadUChar() 
		Record["Selectable3"] := Bin.ReadUChar() 
		Record["Selectable4"] := Bin.ReadUChar() 
		Record["Selectable5"] := Bin.ReadUChar() 
		Record["Selectable6"] := Bin.ReadUChar() 
		Record["Selectable7"] := Bin.ReadUChar() 
		Record["TrapProb"] := Bin.ReadUInt() 
		Record["SizeX"] := Bin.ReadUInt() 
		Record["SizeY"] := Bin.ReadUInt() 
		Record["FrameCnt0"] := Bin.ReadUInt() 
		Record["FrameCnt1"] := Bin.ReadUInt() 
		Record["FrameCnt2"] := Bin.ReadUInt() 
		Record["FrameCnt3"] := Bin.ReadUInt() 
		Record["FrameCnt4"] := Bin.ReadUInt() 
		Record["FrameCnt5"] := Bin.ReadUInt() 
		Record["FrameCnt6"] := Bin.ReadUInt() 
		Record["FrameCnt7"] := Bin.ReadUInt() 
		Record["FrameDelta0"] := Bin.ReadUShort() 
		Record["FrameDelta1"] := Bin.ReadUShort() 
		Record["FrameDelta2"] := Bin.ReadUShort() 
		Record["FrameDelta3"] := Bin.ReadUShort() 
		Record["FrameDelta4"] := Bin.ReadUShort() 
		Record["FrameDelta5"] := Bin.ReadUShort() 
		Record["FrameDelta6"] := Bin.ReadUShort() 
		Record["FrameDelta7"] := Bin.ReadUShort() 
		Record["CycleAnim0"] := Bin.ReadUChar() 
		Record["CycleAnim1"] := Bin.ReadUChar() 
		Record["CycleAnim2"] := Bin.ReadUChar() 
		Record["CycleAnim3"] := Bin.ReadUChar() 
		Record["CycleAnim4"] := Bin.ReadUChar() 
		Record["CycleAnim5"] := Bin.ReadUChar() 
		Record["CycleAnim6"] := Bin.ReadUChar() 
		Record["CycleAnim7"] := Bin.ReadUChar() 
		Record["Lit0"] := Bin.ReadUChar() 
		Record["Lit1"] := Bin.ReadUChar() 
		Record["Lit2"] := Bin.ReadUChar() 
		Record["Lit3"] := Bin.ReadUChar() 
		Record["Lit4"] := Bin.ReadUChar() 
		Record["Lit5"] := Bin.ReadUChar() 
		Record["Lit6"] := Bin.ReadUChar() 
		Record["Lit7"] := Bin.ReadUChar() 
		Record["BlocksLight0"] := Bin.ReadUChar() 
		Record["BlocksLight1"] := Bin.ReadUChar() 
		Record["BlocksLight2"] := Bin.ReadUChar() 
		Record["BlocksLight3"] := Bin.ReadUChar() 
		Record["BlocksLight4"] := Bin.ReadUChar() 
		Record["BlocksLight5"] := Bin.ReadUChar() 
		Record["BlocksLight6"] := Bin.ReadUChar() 
		Record["BlocksLight7"] := Bin.ReadUChar() 
		Record["HasCollision0"] := Bin.ReadUChar() 
		Record["HasCollision1"] := Bin.ReadUChar() 
		Record["HasCollision2"] := Bin.ReadUChar() 
		Record["HasCollision3"] := Bin.ReadUChar() 
		Record["HasCollision4"] := Bin.ReadUChar() 
		Record["HasCollision5"] := Bin.ReadUChar() 
		Record["HasCollision6"] := Bin.ReadUChar() 
		Record["HasCollision7"] := Bin.ReadUChar() 
		Record["IsAttackable0"] := Bin.ReadUChar() 
		Record["Start0"] := Bin.ReadUChar() 
		Record["Start1"] := Bin.ReadUChar() 
		Record["Start2"] := Bin.ReadUChar() 
		Record["Start3"] := Bin.ReadUChar() 
		Record["Start4"] := Bin.ReadUChar() 
		Record["Start5"] := Bin.ReadUChar() 
		Record["Start6"] := Bin.ReadUChar() 
		Record["Start7"] := Bin.ReadUChar() 
		Record["OrderFlag0"] := Bin.ReadUChar() 
		Record["OrderFlag1"] := Bin.ReadUChar() 
		Record["OrderFlag2"] := Bin.ReadUChar() 
		Record["OrderFlag3"] := Bin.ReadUChar() 
		Record["OrderFlag4"] := Bin.ReadUChar() 
		Record["OrderFlag5"] := Bin.ReadUChar() 
		Record["OrderFlag6"] := Bin.ReadUChar() 
		Record["OrderFlag7"] := Bin.ReadUChar() 
		Record["EnvEffect"] := Bin.ReadUChar() 
		Record["IsDoor"] := Bin.ReadUChar() 
		Record["BlocksVis"] := Bin.ReadUChar() 
		Record["Orientation"] := Bin.ReadUChar() 
		Record["PreOperate"] := Bin.ReadUChar() 
		Record["Trans"] := Bin.ReadUChar() 
		Record["Mode0"] := Bin.ReadUChar() 
		Record["Mode1"] := Bin.ReadUChar() 
		Record["Mode2"] := Bin.ReadUChar() 
		Record["Mode3"] := Bin.ReadUChar() 
		Record["Mode4"] := Bin.ReadUChar() 
		Record["Mode5"] := Bin.ReadUChar() 
		Record["Mode6"] := Bin.ReadUChar() 
		Record["Mode7"] := Bin.ReadUChar() 
		Record["iPadding81"] := Bin.ReadUChar() 
		Record["Xoffset"] := Bin.ReadInt() 
		Record["Yoffset"] := Bin.ReadInt() 
		Record["Draw"] := Bin.ReadUChar() 
		Record["HD"] := Bin.ReadUChar() 
		Record["TR"] := Bin.ReadUChar() 
		Record["LG"] := Bin.ReadUChar() 
		Record["RA"] := Bin.ReadUChar() 
		Record["LA"] := Bin.ReadUChar() 
		Record["RH"] := Bin.ReadUChar() 
		Record["LH"] := Bin.ReadUChar() 
		Record["SH"] := Bin.ReadUChar() 
		Record["S1"] := Bin.ReadUChar() 
		Record["S2"] := Bin.ReadUChar() 
		Record["S3"] := Bin.ReadUChar() 
		Record["S4"] := Bin.ReadUChar() 
		Record["S5"] := Bin.ReadUChar() 
		Record["S6"] := Bin.ReadUChar() 
		Record["S7"] := Bin.ReadUChar() 
		Record["S8"] := Bin.ReadUChar() 
		Record["TotalPieces"] := Bin.ReadUChar() 
		Record["Xspace"] := Bin.ReadChar() 
		Record["Yspace"] := Bin.ReadChar() 
		Record["Red"] := Bin.ReadUChar() 
		Record["Green"] := Bin.ReadUChar() 
		Record["Blue"] := Bin.ReadUChar() 
		Record["SubClass"] := Bin.ReadUChar() 
		Record["NameOffset"] := Bin.ReadInt() 
		Record["iPadding91"] := Bin.ReadUChar() 
		Record["MonsterOK"] := Bin.ReadUChar() 
		Record["OperateRange"] := Bin.ReadUChar() 
		Record["ShrineFunction"] := Bin.ReadUChar() 
		Record["Act"] := Bin.ReadUChar() 
		Record["Lockable"] := Bin.ReadUChar() 
		Record["Gore"] := Bin.ReadUChar() 
		Record["Restore"] := Bin.ReadUChar() 
		Record["RestoreVirgins"] := Bin.ReadUChar() 
		Record["Sync"] := Bin.ReadUChar() 
		Record["iPadding93_1"] := Trim(Bin.Read(2))
		Record["Parm0"] := Bin.ReadInt() 
		Record["Parm1"] := Bin.ReadInt() 
		Record["Parm2"] := Bin.ReadInt() 
		Record["Parm3"] := Bin.ReadInt() 
		Record["Parm4"] := Bin.ReadInt() 
		Record["Parm5"] := Bin.ReadInt() 
		Record["Parm6"] := Bin.ReadInt() 
		Record["Parm7"] := Bin.ReadInt() 
		Record["nTgtFX"] := Bin.ReadUChar() 
		Record["nTgtFY"] := Bin.ReadUChar() 
		Record["nTgtBX"] := Bin.ReadUChar() 
		Record["nTgtBY"] := Bin.ReadUChar() 
		Record["Damage"] := Bin.ReadUChar() 
		Record["CollisionSubst"] := Bin.ReadUChar() 
		Record["iPadding103"] := Bin.ReadUShort() 
		Record["Left"] := Bin.ReadInt() 
		Record["Top"] := Bin.ReadInt() 
		Record["Width"] := Bin.ReadInt() 
		Record["Height"] := Bin.ReadInt() 
		Record["Beta"] := Bin.ReadUChar() 
		Record["InitFn"] := Bin.ReadUChar() 
		Record["PopulateFn"] := Bin.ReadUChar() 
		Record["OperateFn"] := Bin.ReadUChar() 
		Record["ClientFn"] := Bin.ReadUChar() 
		Record["Overlay"] := Bin.ReadUChar() 
		Record["BlockMissile"] := Bin.ReadUChar() 
		Record["DrawUnder"] := Bin.ReadUChar() 
		Record["OpenWarp"] := Bin.ReadUInt() 
		Record["AutoMap"] := Bin.ReadUInt()
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		
		Kill := "iPadding|104,SpawnMax,Selectable|8,TrapProb,SizeX,SizeY,FrameCnt|8,FrameDelta|8,CycleAnim|8,Lit|8,BlocksLight|8,HasCollision|8,IsAttackable0,Start|8,OrderFlag|8,EnvEffect,IsDoor,BlocksVis,Orientation,PreOperate,Trans,Mode|8,Xoffset,Yoffset,Draw,HD,TR,LG,RA,LA,RH,LH,SH,S|9,TotalPieces,Xspace,Yspace,Red,Green,Blue,SubClass,NameOffset,MonsterOK,OperateRange,ShrineFunction,Lockable,Gore,Restore,RestoreVirgins,Sync,iPadding93_1,Parm|8,nTgtFX,nTgtFY,nTgtBX,nTgtBY,Damage,CollisionSubst,Left,Top,Width,Height,Beta,InitFn,PopulateFn,OperateFn,ClientFn,Overlay,BlockMissile,DrawUnder,OpenWarp,AutoMap"
		RecordKill(Record,kill,0,,-1)
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_objgroup(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 52

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 52
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["ID0"] := Bin.ReadUInt() 
		Record["ID1"] := Bin.ReadUInt() 
		Record["ID2"] := Bin.ReadUInt() 
		Record["ID3"] := Bin.ReadUInt() 
		Record["ID4"] := Bin.ReadUInt() 
		Record["ID5"] := Bin.ReadUInt() 
		Record["ID6"] := Bin.ReadUInt() 
		Record["ID7"] := Bin.ReadUInt() 
		Record["DENSITY0"] := Bin.ReadUChar() 
		Record["DENSITY1"] := Bin.ReadUChar() 
		Record["DENSITY2"] := Bin.ReadUChar() 
		Record["DENSITY3"] := Bin.ReadUChar() 
		Record["DENSITY4"] := Bin.ReadUChar() 
		Record["DENSITY5"] := Bin.ReadUChar() 
		Record["DENSITY6"] := Bin.ReadUChar() 
		Record["DENSITY7"] := Bin.ReadUChar() 
		Record["PROB0"] := Bin.ReadUChar() 
		Record["PROB1"] := Bin.ReadUChar() 
		Record["PROB2"] := Bin.ReadUChar() 
		Record["PROB3"] := Bin.ReadUChar() 
		Record["PROB4"] := Bin.ReadUChar() 
		Record["PROB5"] := Bin.ReadUChar() 
		Record["PROB6"] := Bin.ReadUChar() 
		Record["PROB7"] := Bin.ReadUChar() 
		Record["SHRINES"] := Bin.ReadUChar() 
		Record["WELLS"] := Bin.ReadUChar() 
		Record["iPadding12"] := Bin.ReadUShort()
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		
		Kill=ID|8,DENSITY|8,PROB|8,SHRINES,WELLS,iPadding12
		RecordKill(Record,kill,0,,-1)
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_objmode(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 52

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 52
		RecordID := a_index 
		Digest[ModFullName,"Decompile",Module,RecordID,"Name"] := Trim(Bin.Read(32))
		Digest[ModFullName,"Decompile",Module,RecordID,"Token"] := Trim(Bin.Read(20))
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_objtype(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 52

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 52
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Name"] := Trim(Bin.Read(32))
		Record["Token"] := Trim(Bin.Read(20))
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_overlay(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 132

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 132
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Filename"] := Trim(Bin.Read(64))
		Record["version"] := Bin.ReadUShort() 
		Record["Frames"] := Bin.ReadUInt() 
		Record["PreDraw"] := Bin.ReadUInt() 
		Record["1ofN"] := Bin.ReadUInt() 
		Record["Dir"] := Bin.ReadUChar() 
		Record["Open"] := Bin.ReadUChar() 
		Record["Beta"] := Bin.ReadUShort() 
		Record["Xoffset"] := Bin.ReadInt() 
		Record["Yoffset"] := Bin.ReadInt() 
		Record["Height1"] := Bin.ReadInt() 
		Record["Height2"] := Bin.ReadInt() 
		Record["Height3"] := Bin.ReadInt() 
		Record["Height4"] := Bin.ReadInt() 
		Record["AnimRate"] := Bin.ReadUInt() 
		Record["InitRadius"] := Bin.ReadUInt() 
		Record["Radius"] := Bin.ReadUInt() 
		Record["LoopWaitTime"] := Bin.ReadUInt() 
		Record["Trans"] := Bin.ReadUChar() 
		Record["Red"] := Bin.ReadUChar() 
		Record["Green"] := Bin.ReadUChar() 
		Record["Blue"] := Bin.ReadUChar() 
		Record["NumDirections"] := Bin.ReadUChar() 
		Record["LocalBlood"] := Bin.ReadUChar()
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_playerclass(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 4

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 4
		RecordID := a_index
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_plrmode(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 52

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 52
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Name"] := Trim(Bin.Read(32))
		Record["Token"] := Trim(Bin.Read(20))
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_plrtype(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 52

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 52
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Name"] := Trim(Bin.Read(32))
		Record["Token"] := Trim(Bin.Read(20))
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_properties(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 46

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 46
		RecordID := a_index-1
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["code"] := Bin.ReadUShort() 
		Record["set1"] := Bin.ReadUChar() 
		Record["set2"] := Bin.ReadUChar() 
		Record["set3"] := Bin.ReadUChar() 
		Record["set4"] := Bin.ReadUChar() 
		Record["set5"] := Bin.ReadUChar() 
		Record["set6"] := Bin.ReadUChar() 
		Record["set7"] := Bin.ReadUChar() 
		Record["iPadding2"] := Bin.ReadUChar() 
		Record["val1"] := Bin.ReadUShort() 
		Record["val2"] := Bin.ReadUShort() 
		Record["val3"] := Bin.ReadUShort() 
		Record["val4"] := Bin.ReadUShort() 
		Record["val5"] := Bin.ReadUShort() 
		Record["val6"] := Bin.ReadUShort() 
		Record["val7"] := Bin.ReadUShort() 
		Record["func1"] := Bin.ReadUChar() 
		Record["func2"] := Bin.ReadUChar() 
		Record["func3"] := Bin.ReadUChar() 
		Record["func4"] := Bin.ReadUChar() 
		Record["func5"] := Bin.ReadUChar() 
		Record["func6"] := Bin.ReadUChar() 
		Record["func7"] := Bin.ReadUChar() 
		Record["iPadding7"] := Bin.ReadUChar() 
		Record["stat1"] := Bin.ReadUShort() 
		Record["stat2"] := Bin.ReadUShort() 
		Record["stat3"] := Bin.ReadUShort() 
		Record["stat4"] := Bin.ReadUShort() 
		Record["stat5"] := Bin.ReadUShort() 
		Record["stat6"] := Bin.ReadUShort() 
		Record["stat7"] := Bin.ReadUShort()
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		
		kill=iPadding2,iPadding7,func|7,set|7,val|7
		RecordKill(Record,Kill,0)
		
		kill=stat|7
		RecordKill(Record,Kill,65535)
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_qualityitems(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 112

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 112
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["armor"] := Bin.ReadUChar() 
		Record["weapon"] := Bin.ReadUChar() 
		Record["shield"] := Bin.ReadUChar() 
		Record["scepter"] := Bin.ReadUChar() 
		Record["wand"] := Bin.ReadUChar() 
		Record["staff"] := Bin.ReadUChar() 
		Record["bow"] := Bin.ReadUChar() 
		Record["boots"] := Bin.ReadUChar() 
		Record["gloves"] := Bin.ReadUChar() 
		Record["belt"] := Bin.ReadUChar() 
		Record["nummods"] := Bin.ReadUChar() 
		Record["iPadding2"] := Bin.ReadUChar() 
		Record["mod1code"] := Bin.ReadUInt() 
		Record["mod1param"] := Bin.ReadUInt() 
		Record["mod1min"] := Bin.ReadUInt() 
		Record["mod1max"] := Bin.ReadUInt() 
		Record["mod2code"] := Bin.ReadUInt() 
		Record["mod2param"] := Bin.ReadUInt() 
		Record["mod2min"] := Bin.ReadUInt() 
		Record["mod2max"] := Bin.ReadUInt() 
		Record["effect1"] := Trim(Bin.Read(32))
		Record["effect2"] := Trim(Bin.Read(32))
		Record["iPadding27"] := Bin.ReadUInt()
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_rareprefix(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 72

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 72
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["iPadding0"] := Bin.ReadUInt() 
		Record["iPadding1"] := Bin.ReadUInt() 
		Record["iPadding2"] := Bin.ReadUInt() 
		Record["iPadding3"] := Bin.ReadUShort() 
		Record["version"] := Bin.ReadUShort() 
		Record["itype1"] := Bin.ReadUShort() 
		Record["itype2"] := Bin.ReadUShort() 
		Record["itype3"] := Bin.ReadUShort() 
		Record["itype4"] := Bin.ReadUShort() 
		Record["itype5"] := Bin.ReadUShort() 
		Record["itype6"] := Bin.ReadUShort() 
		Record["itype7"] := Bin.ReadUShort() 
		Record["etype1"] := Bin.ReadUShort() 
		Record["etype2"] := Bin.ReadUShort() 
		Record["etype3"] := Bin.ReadUShort() 
		Record["etype4"] := Bin.ReadUShort() 
		Record["name"] := Trim(Bin.Read(32))
		Record["iPadding17"] := Bin.ReadUShort()
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		Kill=itype|7,etype|4
		RecordKill(Record,kill,0)
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_raresuffix(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 72

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 72
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["iPadding0"] := Bin.ReadUInt() 
		Record["iPadding1"] := Bin.ReadUInt() 
		Record["iPadding2"] := Bin.ReadUInt() 
		Record["iPadding3"] := Bin.ReadUShort() 
		Record["version"] := Bin.ReadUShort() 
		Record["itype1"] := Bin.ReadUShort() 
		Record["itype2"] := Bin.ReadUShort() 
		Record["itype3"] := Bin.ReadUShort() 
		Record["itype4"] := Bin.ReadUShort() 
		Record["itype5"] := Bin.ReadUShort() 
		Record["itype6"] := Bin.ReadUShort() 
		Record["itype7"] := Bin.ReadUShort() 
		Record["etype1"] := Bin.ReadUShort() 
		Record["etype2"] := Bin.ReadUShort() 
		Record["etype3"] := Bin.ReadUShort() 
		Record["etype4"] := Bin.ReadUShort() 
		Record["name"] := Trim(Bin.Read(32))
		Record["iPadding17"] := Bin.ReadUShort()
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		Kill=itype|7,etype|4
		RecordKill(Record,kill,0)
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_runes(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Seek(4)
	RecordSize := 288

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 288
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Name"] := Trim(Bin.Read(64))
		Record["Rune Name"] := Trim(Bin.Read(64))
		Record["complete"] := Bin.ReadUChar() 
		Record["server"] := Bin.ReadUChar() 
		Record["iPadding32"] := Bin.ReadUShort() 
		Record["iPadding33"] := Bin.ReadUShort() 

		Record["itype1"] := Bin.ReadUShort() 
		Record["itype2"] := Bin.ReadUShort() 
		Record["itype3"] := Bin.ReadUShort() 
		Record["itype4"] := Bin.ReadUShort() 
		Record["itype5"] := Bin.ReadUShort() 
		Record["itype6"] := Bin.ReadUShort() 
		Record["etype1"] := Bin.ReadUShort() 
		Record["etype2"] := Bin.ReadUShort() 
		Record["etype3"] := Bin.ReadUShort() 
		Record["Rune1"] := Bin.ReadUInt() 
		Record["Rune2"] := Bin.ReadUInt() 
		Record["Rune3"] := Bin.ReadUInt() 
		Record["Rune4"] := Bin.ReadUInt() 
		Record["Rune5"] := Bin.ReadUInt() 
		Record["Rune6"] := Bin.ReadUInt() 
		Record["T1Code1"] := Bin.ReadInt() 
		Record["T1Param1"] := Bin.ReadInt() 
		Record["T1Min1"] := Bin.ReadInt() 
		Record["T1Max1"] := Bin.ReadInt() 
		Record["T1Code2"] := Bin.ReadInt() 
		Record["T1Param2"] := Bin.ReadInt() 
		Record["T1Min2"] := Bin.ReadInt() 
		Record["T1Max2"] := Bin.ReadInt() 
		Record["T1Code3"] := Bin.ReadInt() 
		Record["T1Param3"] := Bin.ReadInt() 
		Record["T1Min3"] := Bin.ReadInt() 
		Record["T1Max3"] := Bin.ReadInt() 
		Record["T1Code4"] := Bin.ReadInt() 
		Record["T1Param4"] := Bin.ReadInt() 
		Record["T1Min4"] := Bin.ReadInt() 
		Record["T1Max4"] := Bin.ReadInt() 
		Record["T1Code5"] := Bin.ReadInt() 
		Record["T1Param5"] := Bin.ReadInt() 
		Record["T1Min5"] := Bin.ReadInt() 
		Record["T1Max5"] := Bin.ReadInt() 
		Record["T1Code6"] := Bin.ReadInt() 
		Record["T1Param6"] := Bin.ReadInt() 
		Record["T1Min6"] := Bin.ReadInt() 
		Record["T1Max6"] := Bin.ReadInt() 
		Record["T1Code7"] := Bin.ReadInt() 
		Record["T1Param7"] := Bin.ReadInt() 
		Record["T1Min7"] := Bin.ReadInt() 
		Record["T1Max7"] := Bin.ReadInt()
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		
		kill=itype|6,etype|3,server,complete
		RecordKill(Record,kill,0)
		
		kill=Rune|6
		RecordKill(Record,kill,4294967295)
		
		kill=T1Code|7
		killdepend=T1Param,T1Min,T1Max
		RecordKill(Record,kill,-1,killdepend)
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_setitems(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 440

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 440
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["wSetItemId"] := Bin.ReadUShort() 
		Record["index"] := Trim(Bin.Read(32))
		Record["iPadding8"] := Bin.ReadUShort() 
		Record["dwTblIndex"] := Bin.ReadUInt() 
		Record["item"] := Trim(Bin.Read(4))
		Record["set"] := Bin.ReadUInt() 
		Record["lvl"] := Bin.ReadUShort() 
		Record["lvl req"] := Bin.ReadUShort() 
		Record["rarity"] := Bin.ReadUInt() 
		Record["cost mult"] := Bin.ReadUInt() 
		Record["cost add"] := Bin.ReadUInt() 
		Record["chrtransform"] := Bin.ReadUChar() 
		Record["invtransform"] := Bin.ReadUChar() 
		Record["flippyfile"] := Trim(Bin.Read(32))
		Record["invfile"] := Trim(Bin.Read(32))
		Record["dropsound"] := Bin.ReadUShort() 
		Record["usesound"] := Bin.ReadUShort() 
		Record["dropsfxframe"] := Bin.ReadUChar() 
		Record["add func"] := Bin.ReadUChar() 
		Record["prop1"] := Bin.ReadInt() 
		Record["par1"] := Bin.ReadInt() 
		Record["min1"] := Bin.ReadInt() 
		Record["max1"] := Bin.ReadInt() 
		Record["prop2"] := Bin.ReadInt() 
		Record["par2"] := Bin.ReadInt() 
		Record["min2"] := Bin.ReadInt() 
		Record["max2"] := Bin.ReadInt() 
		Record["prop3"] := Bin.ReadInt() 
		Record["par3"] := Bin.ReadInt() 
		Record["min3"] := Bin.ReadInt() 
		Record["max3"] := Bin.ReadInt() 
		Record["prop4"] := Bin.ReadInt() 
		Record["par4"] := Bin.ReadInt() 
		Record["min4"] := Bin.ReadInt() 
		Record["max4"] := Bin.ReadInt() 
		Record["prop5"] := Bin.ReadInt() 
		Record["par5"] := Bin.ReadInt() 
		Record["min5"] := Bin.ReadInt() 
		Record["max5"] := Bin.ReadInt() 
		Record["prop6"] := Bin.ReadInt() 
		Record["par6"] := Bin.ReadInt() 
		Record["min6"] := Bin.ReadInt() 
		Record["max6"] := Bin.ReadInt() 
		Record["prop7"] := Bin.ReadInt() 
		Record["par7"] := Bin.ReadInt() 
		Record["min7"] := Bin.ReadInt() 
		Record["max7"] := Bin.ReadInt() 
		Record["prop8"] := Bin.ReadInt() 
		Record["par8"] := Bin.ReadInt() 
		Record["min8"] := Bin.ReadInt() 
		Record["max8"] := Bin.ReadInt() 
		Record["prop9"] := Bin.ReadInt() 
		Record["par9"] := Bin.ReadInt() 
		Record["min9"] := Bin.ReadInt() 
		Record["max9"] := Bin.ReadInt() 
		Record["aprop1a"] := Bin.ReadInt() 
		Record["apar1a"] := Bin.ReadInt() 
		Record["amin1a"] := Bin.ReadInt() 
		Record["amax1a"] := Bin.ReadInt() 
		Record["aprop1b"] := Bin.ReadInt() 
		Record["apar1b"] := Bin.ReadInt() 
		Record["amin1b"] := Bin.ReadInt() 
		Record["amax1b"] := Bin.ReadInt() 
		Record["aprop2a"] := Bin.ReadInt() 
		Record["apar2a"] := Bin.ReadInt() 
		Record["amin2a"] := Bin.ReadInt() 
		Record["amax2a"] := Bin.ReadInt() 
		Record["aprop2b"] := Bin.ReadInt() 
		Record["apar2b"] := Bin.ReadInt() 
		Record["amin2b"] := Bin.ReadInt() 
		Record["amax2b"] := Bin.ReadInt() 
		Record["aprop3a"] := Bin.ReadInt() 
		Record["apar3a"] := Bin.ReadInt() 
		Record["amin3a"] := Bin.ReadInt() 
		Record["amax3a"] := Bin.ReadInt() 
		Record["aprop3b"] := Bin.ReadInt() 
		Record["apar3b"] := Bin.ReadInt() 
		Record["amin3b"] := Bin.ReadInt() 
		Record["amax3b"] := Bin.ReadInt() 
		Record["aprop4a"] := Bin.ReadInt() 
		Record["apar4a"] := Bin.ReadInt() 
		Record["amin4a"] := Bin.ReadInt() 
		Record["amax4a"] := Bin.ReadInt() 
		Record["aprop4b"] := Bin.ReadInt() 
		Record["apar4b"] := Bin.ReadInt() 
		Record["amin4b"] := Bin.ReadInt() 
		Record["amax4b"] := Bin.ReadInt() 
		Record["aprop5a"] := Bin.ReadInt() 
		Record["apar5a"] := Bin.ReadInt() 
		Record["amin5a"] := Bin.ReadInt() 
		Record["amax5a"] := Bin.ReadInt() 
		Record["aprop5b"] := Bin.ReadInt() 
		Record["apar5b"] := Bin.ReadInt() 
		Record["amin5b"] := Bin.ReadInt() 
		Record["amax5b"] := Bin.ReadInt()
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_sets(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 296

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 296
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["wSetId"] := Bin.ReadUShort() 
		Record["name"] := Bin.ReadUShort() 
		Record["version"] := Bin.ReadUInt() 
		Record["iPadding2"] := Bin.ReadUInt() 
		Record["dwSetItems"] := Bin.ReadUInt() 
		Record["PCode2a"] := Bin.ReadInt() 
		Record["PParam2a"] := Bin.ReadInt() 
		Record["PMin2a"] := Bin.ReadInt() 
		Record["PMax2a"] := Bin.ReadInt() 
		Record["PCode2b"] := Bin.ReadInt() 
		Record["PParam2b"] := Bin.ReadInt() 
		Record["PMin2b"] := Bin.ReadInt() 
		Record["PMax2b"] := Bin.ReadInt() 
		Record["PCode3a"] := Bin.ReadInt() 
		Record["PParam3a"] := Bin.ReadInt() 
		Record["PMin3a"] := Bin.ReadInt() 
		Record["PMax3a"] := Bin.ReadInt() 
		Record["PCode3b"] := Bin.ReadInt() 
		Record["PParam3b"] := Bin.ReadInt() 
		Record["PMin3b"] := Bin.ReadInt() 
		Record["PMax3b"] := Bin.ReadInt() 
		Record["PCode4a"] := Bin.ReadInt() 
		Record["PParam4a"] := Bin.ReadInt() 
		Record["PMin4a"] := Bin.ReadInt() 
		Record["PMax4a"] := Bin.ReadInt() 
		Record["PCode4b"] := Bin.ReadInt() 
		Record["PParam4b"] := Bin.ReadInt() 
		Record["PMin4b"] := Bin.ReadInt() 
		Record["PMax4b"] := Bin.ReadInt() 
		Record["PCode5a"] := Bin.ReadInt() 
		Record["PParam5a"] := Bin.ReadInt() 
		Record["PMin5a"] := Bin.ReadInt() 
		Record["PMax5a"] := Bin.ReadInt() 
		Record["PCode5b"] := Bin.ReadInt() 
		Record["PParam5b"] := Bin.ReadInt() 
		Record["PMin5b"] := Bin.ReadInt() 
		Record["PMax5b"] := Bin.ReadInt() 
		Record["FCode1"] := Bin.ReadInt() 
		Record["FParam1"] := Bin.ReadInt() 
		Record["FMin1"] := Bin.ReadInt() 
		Record["FMax1"] := Bin.ReadInt() 
		Record["FCode2"] := Bin.ReadInt() 
		Record["FParam2"] := Bin.ReadInt() 
		Record["FMin2"] := Bin.ReadInt() 
		Record["FMax2"] := Bin.ReadInt() 
		Record["FCode3"] := Bin.ReadInt() 
		Record["FParam3"] := Bin.ReadInt() 
		Record["FMin3"] := Bin.ReadInt() 
		Record["FMax3"] := Bin.ReadInt() 
		Record["FCode4"] := Bin.ReadInt() 
		Record["FParam4"] := Bin.ReadInt() 
		Record["FMin4"] := Bin.ReadInt() 
		Record["FMax4"] := Bin.ReadInt() 
		Record["FCode5"] := Bin.ReadInt() 
		Record["FParam5"] := Bin.ReadInt() 
		Record["FMin5"] := Bin.ReadInt() 
		Record["FMax5"] := Bin.ReadInt() 
		Record["FCode6"] := Bin.ReadInt() 
		Record["FParam6"] := Bin.ReadInt() 
		Record["FMin6"] := Bin.ReadInt() 
		Record["FMax6"] := Bin.ReadInt() 
		Record["FCode7"] := Bin.ReadInt() 
		Record["FParam7"] := Bin.ReadInt() 
		Record["FMin7"] := Bin.ReadInt() 
		Record["FMax7"] := Bin.ReadInt() 
		Record["FCode8"] := Bin.ReadInt() 
		Record["FParam8"] := Bin.ReadInt() 
		Record["FMin8"] := Bin.ReadInt() 
		Record["FMax8"] := Bin.ReadInt() 
		Record["iPadding68"] := Bin.ReadUInt() 
		Record["iPadding69"] := Bin.ReadUInt() 
		Record["iPadding70"] := Bin.ReadUInt() 
		Record["iPadding71"] := Bin.ReadUInt() 
		Record["iPadding72"] := Bin.ReadUInt() 
		Record["iPadding73"] := Bin.ReadUInt()
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_shrines(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 184

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 184
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Code"] := Bin.ReadUInt() 
		Record["Arg0"] := Bin.ReadUInt() 
		Record["Arg1"] := Bin.ReadUInt() 
		Record["Duration in frames"] := Bin.ReadUInt() 
		Record["reset time in minutes"] := Bin.ReadUChar() 
		Record["rarity"] := Bin.ReadUChar() 
		Record["view name"] :=Trim(Bin.Read(32))
		Record["niftyphrase"] := Trim(Bin.Read(32))
		Bin.Read(96)
		Record["iPadding20"] := Bin.ReadUShort()
		Record["iPadding21"] := Bin.ReadUInt() 
		Record["iPadding22"] := Bin.ReadUInt() 
		Record["iPadding23"] := Bin.ReadUInt() 
		Record["iPadding24"] := Bin.ReadUInt() 
		Record["iPadding25"] := Bin.ReadUInt() 
		Record["iPadding26"] := Bin.ReadUInt() 
		Record["iPadding27"] := Bin.ReadUInt() 
		Record["iPadding28"] := Bin.ReadUInt() 
		Record["iPadding29"] := Bin.ReadUInt() 
		Record["iPadding30"] := Bin.ReadUInt() 
		Record["iPadding31"] := Bin.ReadUInt() 
		Record["iPadding32"] := Bin.ReadUInt() 
		Record["iPadding33"] := Bin.ReadUInt() 
		Record["iPadding34"] := Bin.ReadUInt() 
		Record["iPadding35"] := Bin.ReadUInt() 
		Record["iPadding36"] := Bin.ReadUInt() 
		Record["iPadding37"] := Bin.ReadUInt() 
		Record["iPadding38"] := Bin.ReadUInt() 
		Record["iPadding39"] := Bin.ReadUInt() 
		Record["iPadding40"] := Bin.ReadUInt() 
		Record["iPadding41"] := Bin.ReadUInt() 
		Record["iPadding42"] := Bin.ReadUInt() 
		Record["iPadding43"] := Bin.ReadUInt() 
		Record["iPadding44"] := Bin.ReadUShort() 
		Record["effectclass"] := Bin.ReadUShort() 
		Record["LevelMin"] := Bin.ReadUShort() 
		Record["iPadding45"] := 
Bin.ReadUShort()
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_skillcalc(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 4

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 4
		RecordID := a_index
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_skilldesc(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 288
	
	for k,v in Digest[ModFullName,"String"]
		{
			DummySearch := StringCodeToNumber(Digest[ModFullName,"String"],k,"dummy")
			break
		}
		
	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		} 
		;Record size: 288
		RecordID := a_index-1
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["SkillDesc"] := Bin.ReadUShort() 
		Record["SkillPage"] := Bin.ReadUChar() 
		Record["SkillRow"] := Bin.ReadUChar() 
		Record["SkillColumn"] := Bin.ReadUChar() 
		Record["ListRow"] := Bin.ReadUChar() 
		Record["ListPool"] := Bin.ReadUChar() 
		Record["IconCel"] := Bin.ReadUChar() 
		Record["str name"] := Bin.ReadUShort() 
		Record["str short"] := Bin.ReadUShort() 
		Record["str long"] := Bin.ReadUShort() 
		Record["str alt"] := Bin.ReadUShort() 
		Record["str mana"] := Bin.ReadUShort() 
		Record["descdam"] := Bin.ReadUShort() 
		Record["descatt"] := Bin.ReadUShort() 
		Record["acPadding20_1"] := Bin.ReadChar() 
		Record["acPadding20_2"] := Bin.ReadChar() 
		Record["ddam calc1"] := Bin.ReadUInt() 
		Record["ddam calc2"] := Bin.ReadUInt() 
		Record["p1dmelem"] := Bin.ReadUChar() 
		Record["p2dmelem"] := Bin.ReadUChar() 
		Record["p3dmelem"] := Bin.ReadUChar() 
		Record["acPadding2"] := Bin.ReadChar() 
		Record["p1dmmin"] := Bin.ReadUInt() 
		Record["p2dmmin"] := Bin.ReadUInt() 
		Record["p3dmmin"] := Bin.ReadUInt() 
		Record["p1dmmax"] := Bin.ReadUInt() 
		Record["p2dmmax"] := Bin.ReadUInt() 
		Record["p3dmmax"] := Bin.ReadUInt() 
		Record["descmissile1"] := Bin.ReadUShort() 
		Record["descmissile2"] := Bin.ReadUShort() 
		Record["descmissile3"] := Bin.ReadUShort() 
		Record["descline1"] := Bin.ReadUChar() 
		Record["descline2"] := Bin.ReadUChar() 
		Record["descline3"] := Bin.ReadUChar() 
		Record["descline4"] := Bin.ReadUChar() 
		Record["descline5"] := Bin.ReadUChar() 
		Record["descline6"] := Bin.ReadUChar() 
		Record["dsc2line1"] := Bin.ReadUChar() 
		Record["dsc2line2"] := Bin.ReadUChar() 
		Record["dsc2line3"] := Bin.ReadUChar() 
		Record["dsc2line4"] := Bin.ReadUChar() 
		Record["dsc3line1"] := Bin.ReadUChar() 
		Record["dsc3line2"] := Bin.ReadUChar() 
		Record["dsc3line3"] := Bin.ReadUChar() 
		Record["dsc3line4"] := Bin.ReadUChar() 
		Record["dsc3line5"] := Bin.ReadUChar() 
		Record["dsc3line6"] := Bin.ReadUChar() 
		Record["dsc3line7"] := Bin.ReadUChar() 
		Record["bPadding20"] := Bin.ReadUChar() 
		Record["desctexta1"] := Bin.ReadUShort() 
		Record["desctexta2"] := Bin.ReadUShort() 
		Record["desctexta3"] := Bin.ReadUShort() 
		Record["desctexta4"] := Bin.ReadUShort() 
		Record["desctexta5"] := Bin.ReadUShort() 
		Record["desctexta6"] := Bin.ReadUShort() 
		Record["dsc2texta1"] := Bin.ReadUShort() 
		Record["dsc2texta2"] := Bin.ReadUShort() 
		Record["dsc2texta3"] := Bin.ReadUShort() 
		Record["dsc2texta4"] := Bin.ReadUShort() 
		Record["dsc3texta1"] := Bin.ReadUShort() 
		Record["dsc3texta2"] := Bin.ReadUShort() 
		Record["dsc3texta3"] := Bin.ReadUShort() 
		Record["dsc3texta4"] := Bin.ReadUShort() 
		Record["dsc3texta5"] := Bin.ReadUShort() 
		Record["dsc3texta6"] := Bin.ReadUShort() 
		Record["dsc3texta7"] := Bin.ReadUShort() 
		Record["desctextb1"] := Bin.ReadUShort() 
		Record["desctextb2"] := Bin.ReadUShort() 
		Record["desctextb3"] := Bin.ReadUShort() 
		Record["desctextb4"] := Bin.ReadUShort() 
		Record["desctextb5"] := Bin.ReadUShort() 
		Record["desctextb6"] := Bin.ReadUShort() 
		Record["dsc2textb1"] := Bin.ReadUShort() 
		Record["dsc2textb2"] := Bin.ReadUShort() 
		Record["dsc2textb3"] := Bin.ReadUShort() 
		Record["dsc2textb4"] := Bin.ReadUShort() 
		Record["dsc3textb1"] := Bin.ReadUShort() 
		Record["dsc3textb2"] := Bin.ReadUShort() 
		Record["dsc3textb3"] := Bin.ReadUShort() 
		Record["dsc3textb4"] := Bin.ReadUShort() 
		Record["dsc3textb5"] := Bin.ReadUShort() 
		Record["dsc3textb6"] := Bin.ReadUShort() 
		Record["dsc3textb7"] := Bin.ReadUShort() 
		Record["desccalca1"] := Bin.ReadUInt() 
		Record["desccalca2"] := Bin.ReadUInt() 
		Record["desccalca3"] := Bin.ReadUInt() 
		Record["desccalca4"] := Bin.ReadUInt() 
		Record["desccalca5"] := Bin.ReadUInt() 
		Record["desccalca6"] := Bin.ReadUInt() 
		Record["dsc2calca1"] := Bin.ReadUInt() 
		Record["dsc2calca2"] := Bin.ReadUInt() 
		Record["dsc2calca3"] := Bin.ReadUInt() 
		Record["dsc2calca4"] := Bin.ReadUInt() 
		Record["dsc3calca1"] := Bin.ReadUInt() 
		Record["dsc3calca2"] := Bin.ReadUInt() 
		Record["dsc3calca3"] := Bin.ReadUInt() 
		Record["dsc3calca4"] := Bin.ReadUInt() 
		Record["dsc3calca5"] := Bin.ReadUInt() 
		Record["dsc3calca6"] := Bin.ReadUInt() 
		Record["dsc3calca7"] := Bin.ReadUInt() 
		Record["desccalcb1"] := Bin.ReadUInt() 
		Record["desccalcb2"] := Bin.ReadUInt() 
		Record["desccalcb3"] := Bin.ReadUInt() 
		Record["desccalcb4"] := Bin.ReadUInt() 
		Record["desccalcb5"] := Bin.ReadUInt() 
		Record["desccalcb6"] := Bin.ReadUInt() 
		Record["dsc2calcb1"] := Bin.ReadUInt() 
		Record["dsc2calcb2"] := Bin.ReadUInt() 
		Record["dsc2calcb3"] := Bin.ReadUInt() 
		Record["dsc2calcb4"] := Bin.ReadUInt() 
		Record["dsc3calcb1"] := Bin.ReadUInt() 
		Record["dsc3calcb2"] := Bin.ReadUInt() 
		Record["dsc3calcb3"] := Bin.ReadUInt() 
		Record["dsc3calcb4"] := Bin.ReadUInt() 
		Record["dsc3calcb5"] := Bin.ReadUInt() 
		Record["dsc3calcb6"] := Bin.ReadUInt() 
		Record["dsc3calcb7"] := Bin.ReadUInt()
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		Kill=descline|6,dsc2line|4,dsc3line|7,p$dmelem|3,SkillColumn,SkillPage,SkillRow,ListPool,ListRow,acPadding2,bPadding20,acPadding20_1,acPadding20_2
		RecordKill(Record,kill,0,,,"$")
		
		Kill=descmissile|3
		RecordKill(Record,kill,65535)
		
		Kill=ddam calc|2,p$dmelem|3,p$dmmin|3,p$dmmax|3,desccalca|6,dsc2calca|4,dsc3calca|7,desccalcb|6,dsc2calcb|4,dsc3calcb|7
		RecordKill(Record,kill,4294967295,KillDepend,,"$")
		
		Kill=desctexta|6,dsc2texta|4,dsc3texta|7,desctextb|6,dsc2textb|4,dsc3textb|7,str name,str short,str long,str alt,str mana
		RecordKill(Record,Kill,DummySearch)
		
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_skilldesccode(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 0

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 0
		RecordID := a_index
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_skills(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Seek(4)
	RecordSize := 572

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		} 
		;Record size: 572
		;BITFIELDS ARE PRESENT!
		RecordID := a_index-1
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Id"] := Bin.ReadUInt() 
		Record["BitCombined"] := Bin.ReadUInt() 
		Record["BitCombined2"] := Bin.ReadUInt() 
		
		;Start bitfield operations
		Flags := Record["BitCombined"] Record["BitCombined2"]
		Record["interrupt"] := substr(Flags,1,1) 
		Record["leftskill"] := substr(Flags,2,1) 
		Record["ItemTgtDo"] := substr(Flags,3,1) 
		Record["AttackNoMana"] := substr(Flags,4,1) 
		Record["TargetItem"] := substr(Flags,5,1) 
		Record["TargetAlly"] := substr(Flags,6,1) 
		Record["TargetPet"] := substr(Flags,7,1) 
		Record["TargetCorpse"] := substr(Flags,8,1) 
		Record["SearchOpenXY"] := substr(Flags,9,1) 
		Record["SearchEnemyNear"] := substr(Flags,10,1) 
		Record["SearchEnemyXY"] := substr(Flags,11,1) 
		Record["TargetableOnly"] := substr(Flags,12,1) 
		Record["UseAttackRate"] := substr(Flags,13,1) 
		Record["durability"] := substr(Flags,14,1) 
		Record["enhanceable"] := substr(Flags,15,1) 
		Record["noammo"] := substr(Flags,16,1) 
		Record["immediate"] := substr(Flags,17,1) 
		Record["weaponsnd"] := substr(Flags,18,1) 
		Record["stsounddelay"] := substr(Flags,19,1) 
		Record["stsuccessonly"] := substr(Flags,20,1) 
		Record["repeat"] := substr(Flags,21,1) 
		Record["InGame"] := substr(Flags,22,1) 
		Record["Kick"] := substr(Flags,23,1) 
		Record["InTown"] := substr(Flags,24,1) 
		Record["prgstack"] := substr(Flags,25,1) 
		Record["periodic"] := substr(Flags,26,1) 
		Record["aura"] := substr(Flags,27,1) 
		Record["passive"] := substr(Flags,28,1) 
		Record["finishing"] := substr(Flags,29,1) 
		Record["progressive"] := substr(Flags,30,1) 
		Record["lob"] := substr(Flags,31,1) 
		Record["decquant"] := substr(Flags,32,1) 
		Record["iPadding2"] := substr(Flags,57,25) 
		Record["warp"] := substr(Flags,58,1) 
		Record["usemanaondo"] := substr(Flags,59,1) 
		Record["scroll"] := substr(Flags,60,1) 
		Record["general"] := substr(Flags,61,1) 
		Record["ItemCltCheckStart"] := substr(Flags,62,1) 
		Record["ItemCheckStart"] := substr(Flags,63,1) 
		Record["TgtPlaceCheck"] := substr(Flags,64,1) 
		Record["charclass"] := Bin.ReadUChar() 
		Record["iPadding3_1"] := Bin.ReadUChar() 
		Record["iPadding3_2"] := Bin.ReadUChar() 
		Record["iPadding3_3"] := Bin.ReadUChar() 
		Record["anim"] := Bin.ReadUChar() 
		Record["monanim"] := Bin.ReadUChar() 
		Record["seqtrans"] := Bin.ReadUChar() 
		Record["seqnum"] := Bin.ReadUChar() 
		Record["range"] := Bin.ReadUChar() 
		Record["SelectProc"] := Bin.ReadUChar() 
		Record["seqinput"] := Bin.ReadUShort() 
		Record["itypea1"] := Bin.ReadUShort() 
		Record["itypea2"] := Bin.ReadUShort() 
		Record["itypea3"] := Bin.ReadUShort() 
		Record["itypeb1"] := Bin.ReadUShort() 
		Record["itypeb2"] := Bin.ReadUShort() 
		Record["itypeb3"] := Bin.ReadUShort() 
		Record["etypea1"] := Bin.ReadUShort() 
		Record["etypea2"] := Bin.ReadUShort() 
		Record["etypeb1"] := Bin.ReadUShort() 
		Record["etypeb2"] := Bin.ReadUShort() 
		Record["srvstfunc"] := Bin.ReadUShort() 
		Record["srvdofunc"] := Bin.ReadUShort() 
		Record["srvprgfunc1"] := Bin.ReadUShort() 
		Record["srvprgfunc2"] := Bin.ReadUShort() 
		Record["srvprgfunc3"] := Bin.ReadUShort() 
		Record["iPadding13"] := Bin.ReadUShort() 
		Record["prgcalc1"] := Bin.ReadUInt() 
		Record["prgcalc2"] := Bin.ReadUInt() 
		Record["prgcalc3"] := Bin.ReadUInt() 
		Record["prgdam"] := Bin.ReadUShort() 
		Record["srvmissile"] := Bin.ReadUShort() 
		Record["srvmissilea"] := Bin.ReadUShort() 
		Record["srvmissileb"] := Bin.ReadUShort() 
		Record["srvmissilec"] := Bin.ReadUShort() 
		Record["srvoverlay"] := Bin.ReadUShort() 
		Record["aurafilter"] := Bin.ReadUInt() 
		Record["aurastat1"] := Bin.ReadUShort() 
		Record["aurastat2"] := Bin.ReadUShort() 
		Record["aurastat3"] := Bin.ReadUShort() 
		Record["aurastat4"] := Bin.ReadUShort() 
		Record["aurastat5"] := Bin.ReadUShort() 
		Record["aurastat6"] := Bin.ReadUShort() 
		Record["auralencalc"] := Bin.ReadUInt() 
		Record["aurarangecalc"] := Bin.ReadUInt() 
		Record["aurastatcalc1"] := Bin.ReadUInt() 
		Record["aurastatcalc2"] := Bin.ReadUInt() 
		Record["aurastatcalc3"] := Bin.ReadUInt() 
		Record["aurastatcalc4"] := Bin.ReadUInt() 
		Record["aurastatcalc5"] := Bin.ReadUInt() 
		Record["aurastatcalc6"] := Bin.ReadUInt() 
		Record["aurastate"] := Bin.ReadUShort() 
		Record["auratargetstate"] := Bin.ReadUShort() 
		Record["auraevent1"] := Bin.ReadUShort() 
		Record["auraevent2"] := Bin.ReadUShort() 
		Record["auraevent3"] := Bin.ReadUShort() 
		Record["auraeventfunc1"] := Bin.ReadUShort() 
		Record["auraeventfunc2"] := Bin.ReadUShort() 
		Record["auraeventfunc3"] := Bin.ReadUShort() 
		Record["auratgtevent"] := Bin.ReadUShort() 
		Record["auratgteventfunc"] := Bin.ReadUShort() 
		Record["passivestate"] := Bin.ReadUShort() 
		Record["passiveitype"] := Bin.ReadUShort() 
		Record["passivestat1"] := Bin.ReadUShort() 
		Record["passivestat2"] := Bin.ReadUShort() 
		Record["passivestat3"] := Bin.ReadUShort() 
		Record["passivestat4"] := Bin.ReadUShort() 
		Record["passivestat5"] := Bin.ReadUShort() 
		Record["iPadding40"] := Bin.ReadUShort() 
		Record["passivecalc1"] := Bin.ReadUInt() 
		Record["passivecalc2"] := Bin.ReadUInt() 
		Record["passivecalc3"] := Bin.ReadUInt() 
		Record["passivecalc4"] := Bin.ReadUInt() 
		Record["passivecalc5"] := Bin.ReadUInt() 
		Record["passiveevent"] := Bin.ReadUShort() 
		Record["passiveeventfunc"] := Bin.ReadUShort() 
		Record["summon"] := Bin.ReadUShort() 
		Record["pettype"] := Bin.ReadUChar() 
		Record["summode"] := Bin.ReadUChar() 
		Record["petmax"] := Bin.ReadUInt() 
		Record["sumskill1"] := Bin.ReadUShort() 
		Record["sumskill2"] := Bin.ReadUShort() 
		Record["sumskill3"] := Bin.ReadUShort() 
		Record["sumskill4"] := Bin.ReadUShort() 
		Record["sumskill5"] := Bin.ReadUShort() 
		Record["iPadding51"] := Bin.ReadUShort() 
		Record["sumsk1calc"] := Bin.ReadUInt() 
		Record["sumsk2calc"] := Bin.ReadUInt() 
		Record["sumsk3calc"] := Bin.ReadUInt() 
		Record["sumsk4calc"] := Bin.ReadUInt() 
		Record["sumsk5calc"] := Bin.ReadUInt() 
		Record["sumumod"] := Bin.ReadUShort() 
		Record["sumoverlay"] := Bin.ReadUShort() 
		Record["cltmissile"] := Bin.ReadUShort() 
		Record["cltmissilea"] := Bin.ReadUShort() 
		Record["cltmissileb"] := Bin.ReadUShort() 
		Record["cltmissilec"] := Bin.ReadUShort() 
		Record["cltmissiled"] := Bin.ReadUShort() 
		Record["cltstfunc"] := Bin.ReadUShort() 
		Record["cltdofunc"] := Bin.ReadUShort() 
		Record["cltprgfunc1"] := Bin.ReadUShort() 
		Record["cltprgfunc2"] := Bin.ReadUShort() 
		Record["cltprgfunc3"] := Bin.ReadUShort() 
		Record["stsound"] := Bin.ReadUShort() 
		Record["stsoundclass"] := Bin.ReadUShort() 
		Record["dosound"] := Bin.ReadUShort() 
		Record["dosound a"] := Bin.ReadUShort() 
		Record["dosound b"] := Bin.ReadUShort() 
		Record["castoverlay"] := Bin.ReadUShort() 
		Record["tgtoverlay"] := Bin.ReadUShort() 
		Record["tgtsound"] := Bin.ReadUShort() 
		Record["prgoverlay"] := Bin.ReadUShort() 
		Record["prgsound"] := Bin.ReadUShort() 
		Record["cltoverlaya"] := Bin.ReadUShort() 
		Record["cltoverlayb"] := Bin.ReadUShort() 
		Record["cltcalc1"] := Bin.ReadUInt() 
		Record["cltcalc2"] := Bin.ReadUInt() 
		Record["cltcalc3"] := Bin.ReadUInt() 
		Record["ItemTarget"] := Bin.ReadUChar() 
		Record["iPadding72"] := Bin.ReadUChar() 
		Record["ItemCastSound"] := Bin.ReadUShort() 
		Record["ItemCastOverlay"] := Bin.ReadUShort() 
		Record["iPadding73"] := Bin.ReadUShort() 
		Record["perdelay"] := Bin.ReadUInt() 
		Record["maxlvl"] := Bin.ReadUShort() 
		Record["ResultFlags"] := Bin.ReadUShort() 
		Record["HitFlags"] := Bin.ReadUInt() 
		Record["HitClass"] := Bin.ReadUInt() 
		Record["calc1"] := Bin.ReadUInt() 
		Record["calc2"] := Bin.ReadUInt() 
		Record["calc3"] := Bin.ReadUInt() 
		Record["calc4"] := Bin.ReadUInt() 
		Record["Param1"] := Bin.ReadInt() 
		Record["Param2"] := Bin.ReadInt() 
		Record["Param3"] := Bin.ReadInt() 
		Record["Param4"] := Bin.ReadInt() 
		Record["Param5"] := Bin.ReadInt() 
		Record["Param6"] := Bin.ReadInt() 
		Record["Param7"] := Bin.ReadInt() 
		Record["Param8"] := Bin.ReadInt() 
		Record["weapsel"] := Bin.ReadUShort() 
		Record["ItemEffect"] := Bin.ReadUShort() 
		Record["ItemCltEffect"] := Bin.ReadUShort() 
		Record["iPadding91"] := Bin.ReadUShort() 
		Record["skpoints"] := Bin.ReadUInt() 
		Record["reqlevel"] := Bin.ReadUShort() 
		Record["reqstr"] := Bin.ReadUShort() 
		Record["reqdex"] := Bin.ReadUShort() 
		Record["reqint"] := Bin.ReadUShort() 
		Record["reqvit"] := Bin.ReadUShort() 
		Record["reqskill1"] := Bin.ReadUShort() 
		Record["reqskill2"] := Bin.ReadUShort() 
		Record["reqskill3"] := Bin.ReadUShort() 
		Record["startmana"] := Bin.ReadUShort() 
		Record["minmana"] := Bin.ReadUShort() 
		Record["manashift"] := Bin.ReadUShort() 
		Record["mana"] := Bin.ReadUShort() 
		Record["lvlmana"] := Bin.ReadShort() 
		Record["attackrank"] := Bin.ReadUChar() 
		Record["LineOfSight"] := Bin.ReadUChar() 
		Record["delay"] := Bin.ReadUInt() 
		Record["skilldesc"] := Bin.ReadUShort() 
		Record["iPadding101"] := Bin.ReadUShort() 
		Record["ToHit"] := Bin.ReadUInt() 
		Record["LevToHit"] := Bin.ReadUInt() 
		Record["ToHitCalc"] := Bin.ReadUInt() 
		Record["HitShift"] := Bin.ReadUChar() 
		Record["SrcDam"] := Bin.ReadUChar() 
		Record["iPadding105"] := Bin.ReadUShort() 
		Record["MinDam"] := Bin.ReadUInt() 
		Record["MaxDam"] := Bin.ReadUInt() 
		Record["MinLevDam1"] := Bin.ReadUInt() 
		Record["MinLevDam2"] := Bin.ReadUInt() 
		Record["MinLevDam3"] := Bin.ReadUInt() 
		Record["MinLevDam4"] := Bin.ReadUInt() 
		Record["MinLevDam5"] := Bin.ReadUInt() 
		Record["MaxLevDam1"] := Bin.ReadUInt() 
		Record["MaxLevDam2"] := Bin.ReadUInt() 
		Record["MaxLevDam3"] := Bin.ReadUInt() 
		Record["MaxLevDam4"] := Bin.ReadUInt() 
		Record["MaxLevDam5"] := Bin.ReadUInt() 
		Record["DmgSymPerCalc"] := Bin.ReadUInt() 
		Record["EType"] := Bin.ReadUShort() 
		Record["iPadding119"] := Bin.ReadUShort() 
		Record["EMin"] := Bin.ReadUInt() 
		Record["EMax"] := Bin.ReadUInt() 
		Record["EMinLev1"] := Bin.ReadUInt() 
		Record["EMinLev2"] := Bin.ReadUInt() 
		Record["EMinLev3"] := Bin.ReadUInt() 
		Record["EMinLev4"] := Bin.ReadUInt() 
		Record["EMinLev5"] := Bin.ReadUInt() 
		Record["EMaxLev1"] := Bin.ReadUInt() 
		Record["EMaxLev2"] := Bin.ReadUInt() 
		Record["EMaxLev3"] := Bin.ReadUInt() 
		Record["EMaxLev4"] := Bin.ReadUInt() 
		Record["EMaxLev5"] := Bin.ReadUInt() 
		Record["EDmgSymPerCalc"] := Bin.ReadUInt() 
		Record["ELen"] := Bin.ReadUInt() 
		Record["ELevLen1"] := Bin.ReadUInt() 
		Record["ELevLen2"] := Bin.ReadUInt() 
		Record["ELevLen3"] := Bin.ReadUInt() 
		Record["ELenSymPerCalc"] := Bin.ReadUInt() 
		Record["restrict"] := Bin.ReadUShort() 
		Record["State1"] := Bin.ReadUShort() 
		Record["State2"] := Bin.ReadUShort() 
		Record["State3"] := Bin.ReadUShort() 
		Record["aitype"] := Bin.ReadUShort() 
		Record["aibonus"] := Bin.ReadShort() 
		Record["cost mult"] := Bin.ReadUInt() 
		Record["cost add"] := Bin.ReadUInt()
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		
		Kill=iPadding|119,auraeventfunc|3,auratgteventfunc,cltprgfunc|3,dosound,dosound a,dosound b,ELevLen1|3,EMax,EMaxLev|5,EMin,EMinLev|5,etypea|2,etypeb|2,itypea|3,itypeb|3,MaxDam,MaxLevDam|5,MinDam,MinLevDam|5,Param|8,srvprgfunc|3
		RecordKill(Record,kill,0)
		
		Kill=auraevent|3,aurastat|6,aurastate,auratargetstate,auratgtevent,castoverlay,cltmissile,cltmissilea,cltmissileb,cltmissilec,cltmissiled,cltoverlaya,cltoverlayb,ItemCastOverlay,passiveevent,passivestat|5,passivestate,prgoverlay,reqskill|3,srvmissile,srvmissilea,srvmissileb,srvmissilec,srvoverlay,State|3,summon,sumoverlay,sumskill|5,tgtoverlay
		RecordKill(Record,Kill,65535)
		
		Kill=auralencalc,aurarangecalc,aurastatcalc|6,calc|4,cltcalc|3,delay,DmgSymPerCalc,EDmgSymPerCalc,ELenSymPerCalc,passivecalc|5,perdelay,petmax,prgcalc|3,skpoints,ToHitCalc
		RecordKill(Record,Kill,4294967295)
		
		kill=sumsk$calc|5
		RecordKill(Record,Kill,4294967295,,,"$")
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_skillscode(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Seek(4)
	RecordSize := 0

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 0
		RecordID := a_index
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_sounds(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 2

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 2
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Index"] := Bin.ReadUShort()
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_storepage(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 4

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 4
		RecordID := a_index
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_superuniques(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 52

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 52
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["wHcIdx"] := Bin.ReadUShort() 
		Record["Name"] := Bin.ReadUShort() 
		Record["Class"] := Bin.ReadUInt() 
		Record["hcIdx"] := Bin.ReadUInt() 
		Record["Mod1"] := Bin.ReadUInt() 
		Record["Mod2"] := Bin.ReadUInt() 
		Record["Mod3"] := Bin.ReadUInt() 
		Record["MonSound"] := Bin.ReadUInt() 
		Record["MinGrp"] := Bin.ReadUInt() 
		Record["MaxGrp"] := Bin.ReadUInt() 
		Record["AutoPos"] := Bin.ReadUChar() 
		Record["EClass"] := Bin.ReadUChar() 
		Record["Stacks"] := Bin.ReadUChar() 
		Record["Replaceable"] := Bin.ReadUChar() 
		Record["Utrans"] := Bin.ReadUChar() 
		Record["Utrans(N)"] := Bin.ReadUChar() 
		Record["Utrans(H)"] := Bin.ReadUChar() 
		Record["iPadding10"] := Bin.ReadUChar() 
		Record["TC"] := Bin.ReadUShort() 
		Record["TC(N)"] := Bin.ReadUShort() 
		Record["TC(H)"] := Bin.ReadUShort() 
		Record["iPadding12"] := Bin.ReadUShort()
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_temp(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 0

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 0
		RecordID := a_index
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_treasureclassex(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 736

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 736
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Picks"] := Bin.ReadInt() 
		Record["group"] := Bin.ReadShort() 
		Record["level"] := Bin.ReadShort() 
		Record["Magic"] := Bin.ReadShort() 
		Record["Rare"] := Bin.ReadShort() 
		Record["Set"] := Bin.ReadShort() 
		Record["Unique"] := Bin.ReadShort() 
		Record["iPadding12"] := Bin.ReadInt() 
		Record["NoDrop"] := Bin.ReadInt() 
		Record["Prob1"] := Bin.ReadInt() 
		Record["Prob2"] := Bin.ReadInt() 
		Record["Prob3"] := Bin.ReadInt() 
		Record["Prob4"] := Bin.ReadInt() 
		Record["Prob5"] := Bin.ReadInt() 
		Record["Prob6"] := Bin.ReadInt() 
		Record["Prob7"] := Bin.ReadInt() 
		Record["Prob8"] := Bin.ReadInt() 
		Record["Prob9"] := Bin.ReadInt() 
		Record["Prob10"] := Bin.ReadInt()
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		
		Kill=Picks,group,level,Magic,Rare,Set,Unique,iPadding12,NoDrop,Prob|10
		RecordKill(Record,Kill,0)
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_uniqueappellation(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 2

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 2
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Name"] := Bin.ReadUShort()
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_uniqueitems(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 332

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 332
		;BITFIELDS ARE PRESENT!
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["iPadding0"] := Bin.ReadUShort() 
		Record["index"] := Bin.Read(32) 
		Record["iPadding8"] := Bin.ReadUShort() 
		Record["version"] := Bin.ReadUInt() 
		Record["code"] := Bin.Read(4) 
		Record["BitCombined"] := Bin.ReadUChar() 
		
		;Start bitfield operations
		Flags := Record["BitCombined"]
		;~ If Flags = 
		;~ msgbox,YOU HAVE NOT FIXED THE BITFIELDS FOR MODULE %module%.
		Record["iPadding11"] := substr(Flags,4,4) 
		Record["ladder"] := substr(Flags,5,1) 
		Record["carry1"] := substr(Flags,6,1) 
		Record["nolimit"] := substr(Flags,7,1) 
		Record["enabled"] := substr(Flags,8,1) 
		Record["iPadding11"] := Trim(Bin.Read(3))
		Record["rarity"] := Bin.ReadUInt() 
		Record["lvl"] := Bin.ReadUShort() 
		Record["lvl req"] := Bin.ReadUShort() 
		Record["chrtransform"] := Bin.ReadUChar() 
		Record["invtransform"] := Bin.ReadUChar() 
		Record["flippyfile"] := Trim(Bin.Read(32))
		Record["invfile"] := Trim(Bin.Read(32))
		Record["iPadding30"] := Bin.ReadUShort() 
		Record["cost mult"] := Bin.ReadUInt() 
		Record["cost add"] := Bin.ReadUInt() 
		Record["dropsound"] := Bin.ReadUShort() 
		Record["usesound"] := Bin.ReadUShort() 
		Record["dropsfxframe"] := Bin.ReadUInt() 
		Record["prop1"] := Bin.ReadInt() 
		Record["par1"] := Bin.ReadInt() 
		Record["min1"] := Bin.ReadInt() 
		Record["max1"] := Bin.ReadInt() 
		Record["prop2"] := Bin.ReadInt() 
		Record["par2"] := Bin.ReadInt() 
		Record["min2"] := Bin.ReadInt() 
		Record["max2"] := Bin.ReadInt() 
		Record["prop3"] := Bin.ReadInt() 
		Record["par3"] := Bin.ReadInt() 
		Record["min3"] := Bin.ReadInt() 
		Record["max3"] := Bin.ReadInt() 
		Record["prop4"] := Bin.ReadInt() 
		Record["par4"] := Bin.ReadInt() 
		Record["min4"] := Bin.ReadInt() 
		Record["max4"] := Bin.ReadInt() 
		Record["prop5"] := Bin.ReadInt() 
		Record["par5"] := Bin.ReadInt() 
		Record["min5"] := Bin.ReadInt() 
		Record["max5"] := Bin.ReadInt() 
		Record["prop6"] := Bin.ReadInt() 
		Record["par6"] := Bin.ReadInt() 
		Record["min6"] := Bin.ReadInt() 
		Record["max6"] := Bin.ReadInt() 
		Record["prop7"] := Bin.ReadInt() 
		Record["par7"] := Bin.ReadInt() 
		Record["min7"] := Bin.ReadInt() 
		Record["max7"] := Bin.ReadInt() 
		Record["prop8"] := Bin.ReadInt() 
		Record["par8"] := Bin.ReadInt() 
		Record["min8"] := Bin.ReadInt() 
		Record["max8"] := Bin.ReadInt() 
		Record["prop9"] := Bin.ReadInt() 
		Record["par9"] := Bin.ReadInt() 
		Record["min9"] := Bin.ReadInt() 
		Record["max9"] := Bin.ReadInt() 
		Record["prop10"] := Bin.ReadInt() 
		Record["par10"] := Bin.ReadInt() 
		Record["min10"] := Bin.ReadInt() 
		Record["max10"] := Bin.ReadInt() 
		Record["prop11"] := Bin.ReadInt() 
		Record["par11"] := Bin.ReadInt() 
		Record["min11"] := Bin.ReadInt() 
		Record["max11"] := Bin.ReadInt() 
		Record["prop12"] := Bin.ReadInt() 
		Record["par12"] := Bin.ReadInt() 
		Record["min12"] := Bin.ReadInt() 
		Record["max12"] := Bin.ReadInt()
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		
		Kill=iPadding30,iPadding0
		RecordKill(Record,kill,0)
		
		Kill=iPadding11
		RecordKill(Record,kill,"")
		
		Kill=prop|12
		killdepend=par,min,max
		RecordKill(Record,kill,-1,killdepend)
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_uniqueprefix(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 2

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 2
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Name"] := Bin.ReadUShort()
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_uniquesuffix(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 2

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 2
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Name"] := Bin.ReadUShort()
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_uniquetitle(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 2

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 2
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["Name"] := Bin.ReadUShort()
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
	
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
		
	}
}
;complete
Digest_Bin_110f_weapons(BinToDecompile)
{
	global
	Bin := FileOpen(BinToDecompile,"r")
	Bin.Read(4)
	RecordSize := 424

	loop, % (Bin.Length  - 4) / RecordSize
	{
		If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		{
			GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			StartTime := A_TickCount
		}
		;Record size: 424
		RecordID := a_index 
		Record := Digest[ModFullName,"Decompile",Module,RecordID] := {}
		Record["flippyfile"] := Trim(Bin.Read(32))
		Record["invfile"] := Trim(Bin.Read(32))
		Record["uniqueinvfile"] := Trim(Bin.Read(32))
		Record["setinvfile"] := Trim(Bin.Read(32))
		Record["code"] := Trim(Bin.Read(4))
		Record["normcode"] := Trim(Bin.Read(4))
		Record["ubercode"] := Trim(Bin.Read(4))
		Record["ultracode"] := Trim(Bin.Read(4)) 
		Record["alternateGfx"] := Trim(Bin.Read(4))
		Record["iPadding37"] := Bin.ReadUInt() 
		Record["iPadding38"] := Bin.ReadUInt() 
		Record["iPadding39"] := Bin.ReadUInt() 
		Record["iPadding40"] := Bin.ReadUInt() 
		Record["iPadding41"] := Bin.ReadUInt() 
		Record["iPadding42"] := Bin.ReadUInt() 
		Record["iPadding43"] := Bin.ReadUInt() 
		Record["iPadding44"] := Bin.ReadUInt() 
		Record["iPadding45"] := Bin.ReadUInt() 
		Record["iPadding46"] := Bin.ReadUInt() 
		Record["iPadding47"] := Bin.ReadUInt() 
		Record["wclass"] := Trim(Bin.Read(4))
		Record["2handedwclass"] := Trim(Bin.Read(4))
		Record["iPadding50"] := Bin.ReadUInt() 
		Record["iPadding51"] := Bin.ReadUInt() 
		Record["iPadding52"] := Bin.ReadUInt() 
		Record["gamble cost"] := Bin.ReadUInt() 
		Record["speed"] := Bin.ReadShort() 
		Record["iPadding54"] := Trim(Bin.Read(2))
		Record["bitfield1"] := Bin.ReadUChar() 
		Record["iPadding55"] := Trim(Bin.Read(3))
		Record["cost"] := Bin.ReadUInt() 
		Record["minstack"] := Bin.ReadUInt() 
		Record["maxstack"] := Bin.ReadUInt() 
		Record["spawnstack"] := Bin.ReadUInt() 
		Record["gemoffset"] := Bin.ReadUChar() 
		Record["iPadding60"] := Trim(Bin.Read(3))
		Record["namestr"] := Bin.ReadUShort() 
		Record["version"] := Bin.ReadUShort() 
		Record["auto prefix"] := Bin.ReadUShort() 
		Record["missiletype"] := Bin.ReadUShort() 
		Record["rarity"] := Bin.ReadUChar() 
		Record["level"] := Bin.ReadUChar() 
		Record["mindam"] := Bin.ReadUChar() 
		Record["maxdam"] := Bin.ReadUChar() 
		Record["minmisdam"] := Bin.ReadUChar() 
		Record["maxmisdam"] := Bin.ReadUChar() 
		Record["2handmindam"] := Bin.ReadUChar() 
		Record["2handmaxdam"] := Bin.ReadUChar() 
		Record["rangeadder"] := Bin.ReadUShort() 
		Record["StrBonus"] := Bin.ReadUShort() 
		Record["DexBonus"] := Bin.ReadUShort() 
		Record["reqstr"] := Bin.ReadUShort() 
		Record["reqdex"] := Bin.ReadUShort() 
		Record["iPadding67"] := Bin.ReadUChar() 
		Record["invwidth"] := Bin.ReadUChar() 
		Record["invheight"] := Bin.ReadUChar() 
		Record["iPadding68"] := Bin.ReadUChar() 
		Record["durability"] := Bin.ReadUChar() 
		Record["nodurability"] := Bin.ReadUChar() 
		Record["iPadding69"] := Bin.ReadUChar() 
		Record["component"] := Bin.ReadUChar() 
		Record["iPadding69_1"] := Trim(Bin.Read(2))
		Record["iPadding70"] := Bin.ReadUInt() 
		Record["2handed"] := Bin.ReadUChar() 
		Record["useable"] := Bin.ReadUChar() 
		Record["type"] := Bin.ReadUShort() 
		Record["type2"] := Bin.ReadUShort() 
		Record["iPadding72"] := Bin.ReadUShort() 
		Record["dropsound"] := Bin.ReadUShort() 
		Record["usesound"] := Bin.ReadUShort() 
		Record["dropsfxframe"] := Bin.ReadUChar() 
		Record["unique"] := Bin.ReadUChar() 
		Record["quest"] := Bin.ReadUChar() 
		Record["questdiffcheck"] := Bin.ReadUChar() 
		Record["transparent"] := Bin.ReadUChar() 
		Record["transtbl"] := Bin.ReadUChar() 
		Record["iPadding75"] := Bin.ReadUChar() 
		Record["lightradius"] := Bin.ReadUChar() 
		Record["belt"] := Bin.ReadUChar() 
		Record["iPadding76"] := Bin.ReadUChar() 
		Record["stackable"] := Bin.ReadUChar() 
		Record["spawnable"] := Bin.ReadUChar() 
		Record["iPadding77"] := Bin.ReadUChar() 
		Record["durwarning"] := Bin.ReadUChar() 
		Record["qntwarning"] := Bin.ReadUChar() 
		Record["hasinv"] := Bin.ReadUChar() 
		Record["gemsockets"] := Bin.ReadUChar() 
		Record["iPadding78"] := Trim(Bin.Read(3))
		Record["hit class"] := Bin.ReadUChar() 
		Record["1or2handed"] := Bin.ReadUChar() 
		Record["gemapplytype"] := Bin.ReadUChar() 
		Record["levelreq"] := Bin.ReadUChar() 
		Record["magic lvl"] := Bin.ReadUChar() 
		Record["Transform"] := Bin.ReadUChar() 
		Record["InvTrans"] := Bin.ReadUChar() 
		Record["compactsave"] := Bin.ReadUChar() 
		Record["SkipName"] := Bin.ReadUChar() 
		Record["Nameable"] := Bin.ReadUChar() 
		Record["AkaraMin"] := Bin.ReadUChar() 
		Record["GheedMin"] := Bin.ReadUChar() 
		Record["CharsiMin"] := Bin.ReadUChar() 
		Record["FaraMin"] := Bin.ReadUChar() 
		Record["LysanderMin"] := Bin.ReadUChar() 
		Record["DrognanMin"] := Bin.ReadUChar() 
		Record["HraltiMin"] := Bin.ReadUChar() 
		Record["AlkorMin"] := Bin.ReadUChar() 
		Record["OrmusMin"] := Bin.ReadUChar() 
		Record["ElzixMin"] := Bin.ReadUChar() 
		Record["AshearaMin"] := Bin.ReadUChar() 
		Record["CainMin"] := Bin.ReadUChar() 
		Record["HalbuMin"] := Bin.ReadUChar() 
		Record["JamellaMin"] := Bin.ReadUChar() 
		Record["MalahMin"] := Bin.ReadUChar() 
		Record["LarzukMin"] := Bin.ReadUChar() 
		Record["DrehyaMin"] := Bin.ReadUChar() 
		Record["AkaraMax"] := Bin.ReadUChar() 
		Record["GheedMax"] := Bin.ReadUChar() 
		Record["CharsiMax"] := Bin.ReadUChar() 
		Record["FaraMax"] := Bin.ReadUChar() 
		Record["LysanderMax"] := Bin.ReadUChar() 
		Record["DrognanMax"] := Bin.ReadUChar() 
		Record["HraltiMax"] := Bin.ReadUChar() 
		Record["AlkorMax"] := Bin.ReadUChar() 
		Record["OrmusMax"] := Bin.ReadUChar() 
		Record["ElzixMax"] := Bin.ReadUChar() 
		Record["AshearaMax"] := Bin.ReadUChar() 
		Record["CainMax"] := Bin.ReadUChar() 
		Record["HalbuMax"] := Bin.ReadUChar() 
		Record["JamellaMax"] := Bin.ReadUChar() 
		Record["MalahMax"] := Bin.ReadUChar() 
		Record["LarzukMax"] := Bin.ReadUChar() 
		Record["DrehyaMax"] := Bin.ReadUChar() 
		Record["AkaraMagicMin"] := Bin.ReadUChar() 
		Record["GheedMagicMin"] := Bin.ReadUChar() 
		Record["CharsiMagicMin"] := Bin.ReadUChar() 
		Record["FaraMagicMin"] := Bin.ReadUChar() 
		Record["LysanderMagicMin"] := Bin.ReadUChar() 
		Record["DrognanMagicMin"] := Bin.ReadUChar() 
		Record["HraltiMagicMin"] := Bin.ReadUChar() 
		Record["AlkorMagicMin"] := Bin.ReadUChar() 
		Record["OrmusMagicMin"] := Bin.ReadUChar() 
		Record["ElzixMagicMin"] := Bin.ReadUChar() 
		Record["AshearaMagicMin"] := Bin.ReadUChar() 
		Record["CainMagicMin"] := Bin.ReadUChar() 
		Record["HalbuMagicMin"] := Bin.ReadUChar() 
		Record["JamellaMagicMin"] := Bin.ReadUChar() 
		Record["MalahMagicMin"] := Bin.ReadUChar() 
		Record["LarzukMagicMin"] := Bin.ReadUChar() 
		Record["DrehyaMagicMin"] := Bin.ReadUChar() 
		Record["AkaraMagicMax"] := Bin.ReadUChar() 
		Record["GheedMagicMax"] := Bin.ReadUChar() 
		Record["CharsiMagicMax"] := Bin.ReadUChar() 
		Record["FaraMagicMax"] := Bin.ReadUChar() 
		Record["LysanderMagicMax"] := Bin.ReadUChar() 
		Record["DrognanMagicMax"] := Bin.ReadUChar() 
		Record["HraltiMagicMax"] := Bin.ReadUChar() 
		Record["AlkorMagicMax"] := Bin.ReadUChar() 
		Record["OrmusMagicMax"] := Bin.ReadUChar() 
		Record["ElzixMagicMax"] := Bin.ReadUChar() 
		Record["AshearaMagicMax"] := Bin.ReadUChar() 
		Record["CainMagicMax"] := Bin.ReadUChar() 
		Record["HalbuMagicMax"] := Bin.ReadUChar() 
		Record["JamellaMagicMax"] := Bin.ReadUChar() 
		Record["MalahMagicMax"] := Bin.ReadUChar() 
		Record["LarzukMagicMax"] := Bin.ReadUChar() 
		Record["DrehyaMagicMax"] := Bin.ReadUChar() 
		Record["AkaraMagicLvl"] := Bin.ReadUChar() 
		Record["GheedMagicLvl"] := Bin.ReadUChar() 
		Record["CharsiMagicLvl"] := Bin.ReadUChar() 
		Record["FaraMagicLvl"] := Bin.ReadUChar() 
		Record["LysanderMagicLvl"] := Bin.ReadUChar() 
		Record["DrognanMagicLvl"] := Bin.ReadUChar() 
		Record["HraltiMagicLvl"] := Bin.ReadUChar() 
		Record["AlkorMagicLvl"] := Bin.ReadUChar() 
		Record["OrmusMagicLvl"] := Bin.ReadUChar() 
		Record["ElzixMagicLvl"] := Bin.ReadUChar() 
		Record["AshearaMagicLvl"] := Bin.ReadUChar() 
		Record["CainMagicLvl"] := Bin.ReadUChar() 
		Record["HalbuMagicLvl"] := Bin.ReadUChar() 
		Record["JamellaMagicLvl"] := Bin.ReadUChar() 
		Record["MalahMagicLvl"] := Bin.ReadUChar() 
		Record["LarzukMagicLvl"] := Bin.ReadUChar() 
		Record["DrehyaMagicLvl"] := Bin.ReadUChar() 
		Record["iPadding102"] := Bin.ReadUChar() 
		Record["NightmareUpgrade"] := Trim(Bin.Read(4))
		Record["HellUpgrade"] := Trim(Bin.Read(4))
		Record["PermStoreItem"] := Bin.ReadUInt()
		
		if a_index = 1
		{
			For k,v in Record
				Digest[ModFullName,"Keys","Decompile",Module] .= k ","
			Digest[ModFullName,"Keys","Decompile",Module] := RTrim(Digest[ModFullName,"Keys","Decompile",Module],",")
		}
		
		Kill=AkaraMin,GheedMin,CharsiMin,FaraMin,LysanderMin,DrognanMin,HraltiMin,AlkorMin,OrmusMin,ElzixMin,AshearaMin,CainMin,HalbuMin,JamellaMin,MalahMin,LarzukMin,DrehyaMin,AkaraMax,GheedMax,CharsiMax,FaraMax,LysanderMax,DrognanMax,HraltiMax,AlkorMax,OrmusMax,ElzixMax,AshearaMax,CainMax,HalbuMax,JamellaMax,MalahMax,LarzukMax,DrehyaMax,AkaraMagicMin,GheedMagicMin,CharsiMagicMin,FaraMagicMin,LysanderMagicMin,DrognanMagicMin,HraltiMagicMin,AlkorMagicMin,OrmusMagicMin,ElzixMagicMin,AshearaMagicMin,CainMagicMin,HalbuMagicMin,JamellaMagicMin,MalahMagicMin,LarzukMagicMin,DrehyaMagicMin,AkaraMagicMax,GheedMagicMax,CharsiMagicMax,FaraMagicMax,LysanderMagicMax,DrognanMagicMax,HraltiMagicMax,AlkorMagicMax,OrmusMagicMax,ElzixMagicMax,AshearaMagicMax,CainMagicMax,HalbuMagicMax,JamellaMagicMax,MalahMagicMax,LarzukMagicMax,DrehyaMagicMax,AkaraMagicLvl,GheedMagicLvl,CharsiMagicLvl,FaraMagicLvl,LysanderMagicLvl,DrognanMagicLvl,HraltiMagicLvl,AlkorMagicLvl,OrmusMagicLvl,ElzixMagicLvl,AshearaMagicLvl,CainMagicLvl,HalbuMagicLvl,JamellaMagicLvl,MalahMagicLvl,LarzukMagicLvl,DrehyaMagicLvl,iPadding|102
		RecordKill(Record,Kill,0)
		
		Kill=iPadding|105
		RecordKill(Record,Kill,4294967295)
		
		Kill=iPadding|102
		RecordKill(Record,Kill,"")
		
		For k,v in Record
		{
			KeyCounter += 1
			KeySize += StrLen(v)
		}
	}
}
;complete
Digest_JSON_110f_runes()
{
	global
	ItemsIndex=0
	If Digest[ModFullName,"Recompile","Items"] = ""
	{
		For k, v in Digest[ModFullName,"Decompile","Armor"]
		{
			Digest[ModFullName,"Recompile","Items",ItemsIndex] := v
			ItemsIndex += 1
		}
		For k, v in Digest[ModFullName,"Decompile","Weapons"]
		{
			Digest[ModFullName,"Recompile","Items",ItemsIndex] := v
			ItemsIndex += 1
		}
		For k, v in Digest[ModFullName,"Decompile","Misc"]
		{
			Digest[ModFullName,"Recompile","Items",ItemsIndex] := v
			ItemsIndex += 1
		}
	}
	;~ array_gui(Digest[ModFullName,"Recompile","Items"])
	loop,% Digest[ModFullName,"Decompile",Module].length()
	{
		;~ If ( (A_TickCount - StartTime) >= 10 ) OR (a_index=1)
		;~ {
			;~ GuiControl, , Text3, % "Decoding Bins...`n" Module " ( " ModuleNum " / " Binorder.Length() " )" "`nRecord: " a_index "/" ((StrSplit((Bin.Length  - 4)  / RecordSize,"`.")[1])) " ("  StrSplit(a_index/ ((Bin.Length  - 4)  / RecordSize) * 100,"`.")[1] "%)"
			;~ StartTime := A_TickCount
		;~ }
		;Record size: 288
		RecordID := a_index 
		Decompile := Digest[ModFullName,"Decompile",Module,RecordID]
		Recompile := Digest[ModFullName,"Recompile",Module,RecordID] := {}
		if Decompile["complete"] = 0
			Recompile["Data"] .= "DISABLED!!!`n"
		if Decompile["server"] = 1
			Recompile["Data"] .= "SERVER ONLY!!!`n"
		Digest[ModFullName,"Recompile",Module,RecordID,"Data"] .= Digest[ModFullName,"String",mod_lng,"By Code",Decompile["Name"]] "`r`n"
		
		Digest[ModFullName,"Recompile",Module,RecordID,"Data"] .= "Allowed in: "
		Loop,6
		{
			itype := Decompile["itype" a_index]
			itype := Digest[ModFullName,"Decompile","itemtypes",itype+1,"code"]
			Recompile["Data"] .= itype ", "
		}
		Recompile["Data"] := Trim(Recompile["Data"],", ")
		Recompile["Data"] .= "`r`n"
		
		If (Decompile["etype1"] > 0) OR (Decompile["etype2"] > 0) OR (Decompile["etype3"] > 0) 
		{
			Digest[ModFullName,"Recompile",Module,RecordID,"Data"] .= "Forbidden in: "
			Loop,3
			{
				etype := Decompile["etype" a_index]
				etype := Digest[ModFullName,"Decompile","itemtypes",etype+1,"code"]
				Recompile["Data"] .= Decompile["etype" a_index] ", "
			}
			Recompile["Data"] := Trim(Recompile["Data"],", ")
			Recompile["Data"] .= "`n"
		}
		RL = 0
		Digest[ModFullName,"Recompile",Module,RecordID,"Data"] .= "Runes used: "
		Loop, 6
		{
			Rune := Decompile["Rune" a_index]
			If Digest[ModFullName,"Recompile","Items",Rune,"levelreq"] > RL
				RL := Digest[ModFullName,"Recompile","Items",Rune,"levelreq"]
			Rune := Digest[ModFullName,"Recompile","Items",Rune,"Code"]
			Rune := Digest[ModFullName,"String",Mod_LNG,"By Code",Trim(Rune)]
			;~ Msgbox % Decompile["Rune" a_index] "`n|" Digest[ModFullName,"Recompile","Items",Decompile["Rune" a_index],"Code"] "|`n" Digest[ModFullName,"String",Mod_LNG,"By Code",Trimrune]
			;~ msgbox % rune
			Rune := RegExReplace(Rune,"(ÿc.)")
			;~ ExitApp
			If Decompile["Rune" a_index] != 0
				Recompile["Data"] .= Rune " + "
			
		}
		Recompile["Data"] := Trim(Recompile["Data"],"+ ")
		Recompile["Data"] .= "`n"
		Recompile["Data"] .= "Min. Level: " RL "`n"
		Recompile["Data"] .= "T1C	|	T1P	|	Min	|	Max	|`n"
		Loop,7
		{
			
			if Decompile["T1Code" a_index] = -1
				continue
			T1Code := Decompile["T1Code" a_index]
			Recompile["Data"] .= T1Code a_tab "|" a_tab
			Recompile["Data"] .= Decompile["T1Param" a_index] a_tab "|" a_tab
			
			If Decompile["T1Param" a_index] != 0
			{
				T1Param := Decompile["T1Param" a_index]
				T1Param := Digest[ModFullName,"Decompile","skills",T1Param,"skilldesc"]
				T1Param := Digest[ModFullName,"Decompile","skilldesc",T1Param,"str name"]
				T1Param := Digest[ModFullName,"String",mod_lng,"By Number",T1Param "R"]
				props := T1Param ","
			}
			else
				props=
						
			Recompile["Data"] .= Decompile["T1Min" a_index] a_tab "|" a_tab
			Recompile["Data"] .= Decompile["T1Max" a_index] a_tab "|||" a_tab ;"`n"
			Loop, 7
			{
				
				if Digest[ModFullName,"Decompile","properties",T1Code,"stat" a_index] = 65535
					continue
				;~ If (a_index=1) and (T1Param != 0)
					;~ continue
				;at this point, need to look at properties\func1 to check for 5/6/7
				;~ if Digest[ModFullName,"Decompile","properties",T1C
				tprop := Digest[ModFullName,"Decompile","properties",T1Code,"stat" a_index]
				tprop := Digest[ModFullName,"Decompile","itemstatcost",tprop,"descstrpos"]
				
				if Digest[ModFullName,"String",mod_lng,"By Number", tprop "R"] != ""
					tprop := Digest[ModFullName,"String",mod_lng,"By Number", tprop "R"]
				else ; if Digest[ModFullName,"String",mod_lng,"By Number", tprop "R"] != ""
					tprop := "{{" tprop "}}"
				;~ Props .= Digest[ModFullName,"Decompile","properties",T1Code,"stat" a_index] ","
				;~ if T1Param !=0
					;~ Props .= T1Param ","
				;~ else
				If Digest[ModFullName,"Decompile","properties",T1Code,"func" a_index] != 1
					Props .= "[[" Digest[ModFullName,"Decompile","properties",T1Code,"func" a_index] "]]"
					Props .= tprop ","
			}
			Recompile["Data"] .= Props "`n"
		}
	}
}
;complete
Format_descfunc_string(f,p,vn,vx,sx,sy,d,opparam)
{
/*
f = the function # passed
p = the T1Param value
vn = the T1Min value
vx = the T1Max value
sx = the resolved string to work on
sy = the resolved second string to work on
d = the descval for the given item
opparam = 

descval 
0 : no value is displayed (like 
1 : value is displayed first (like '+5 to strength') 
2 : string is displayed first, then value (like 'strength +5') 
Function used to display the stat. There are numerous ones, I didnt yet test all yet. 
some values and what they display (descval used: 1, see below): 
*/
	sx := Trim(sx)
	sy := Trim(sy)

	_sx := a_space sx
	sx_ := sx A_Space
	_sy := a_space sy
	sy_ := sy a_space
	;~ if vn != vx
		;~ avg = 1
	;~ else
		;~ avg = 0
	vr := "(" vn " to " vx ")" ;value range
	vz := Round((vn + vx) / 2) ;value average (rounded)
	vzb := a_space "[" vz "]" ; value average in brackets
	if OpParam=""
		OpParam=8
	if (f = 0) OR (f = "")
		return
	else if f = 1 ; +[value] [string] 
	{
		if InStr(s,"%d")
		{	
			s:=(d=1) ? "+" StrReplace(s,"%d",vr,1) 
			: (d=2) ? 
			: d ? sx
		}
		else if d = 1
			s := "+" vr _sx vzb
		else if d = 2
			s := sx_ "+" vr vzb
		else
			s := sx
	}
	else if f = 2 ; [value]% [string] 
	{
		if d = 1
			s := vr "%" _sx vzb
		else if d = 2
			s := sx_ vr "%" vzb
		else
			s := sx
	}
	else if f = 3 ; [value] [string] 
	{
		if d = 1
			s := vr _sx vzb
		else if d = 2
			s := sx_ vr vzb
		else
			s := sx
	}
	else if f = 4 ; +[value]% [string] 
	{
		if d = 1
			s := "+" vr "%" _sx vzb
		else if d = 2
			s := sx_ "+" vr "%" vzb
		else
			s := sx
	}
	else if f = 5 ; [value/1.28]% [string] // used for howl 
	{
		;redefine values for edge case
		vn := vn/1.28 
		vx := vx/1.28
		vr := "(" vn " to " vx ")"
		vz := Round((vn + vx) / 2)
		vzb := a_space "[" vz "]"
		
		if d = 1
			s := vr "%" _sx vzb
		else if d = 2
			s:= sx_ vr "%" vzb
		else
			s := sx
	}
	else if f = 6 ; +[value] [string] [string2] 
	{
		;redefine values for edge case
		if (p = 0)
		{
			vn := RTrim(vn / (2 ** OpParam),"0")
			vx := RTrim(vx / (2 ** OpParam),"0")
			vn := Trim(RTrim(vn,"0"),".")
			vx := Trim(RTrim(vx,"0"),".")
			vr := "(" vn " to " vx ")" ;value range
			vz := RTrim((vn + vx) / 2,"0") ;value average (rounded)
			vzb := a_space "[" vz "]" ; value average in brackets
		}
		else 
		{
			vn := RTrim(p / (2** OpParam),"0")
			vx := RTrim(p / (2** OpParam),"0")
			vn := Trim(RTrim(vn,"0"),".")
			vx := Trim(RTrim(vx,"0"),".")
			vr := "(" vn " to " vx ")" ;value range
			vz := Rtrim((vn + vx) / 2,"0") ;value average (rounded)
			vzb := a_space "[" vz "]" ; value average in brackets
		}
		
		if d = 1
			s:= "+" vr _sx _sy vzb
		else if d = 2
			s:= sx_ sy_ "+" vr vzb
		else
			s:= sx_ sy
	}
	else if f = 7 ; [value]% [string] [string2] 
	{
		;redefine values for edge case
		if (p = 0)
		{
			vn := RTrim(vn / (2 ** OpParam),"0")
			vx := RTrim(vx / (2 ** OpParam),"0")
			vn := Trim(RTrim(vn,"0"),".")
			vx := Trim(RTrim(vx,"0"),".")
			vr := "(" vn " to " vx ")" ;value range
			vz := RTrim((vn + vx) / 2,"0") ;value average (rounded)
			vzb := a_space "[" vz "]" ; value average in brackets
		}
		else 
		{
			vn := RTrim(p / (2** OpParam),"0")
			vx := RTrim(p / (2** OpParam),"0")
			vn := Trim(RTrim(vn,"0"),".")
			vx := Trim(RTrim(vx,"0"),".")
			vr := "(" vn " to " vx ")" ;value range
			vz := Rtrim((vn + vx) / 2,"0") ;value average (rounded)
			vzb := a_space "[" vz "]" ; value average in brackets
		}
		if d = 1
			s:= vr "%" _sx _sy vzb
		else if d = 2
			s:= sx_ sy_ vr "%" vzb
		else
			s:= sx_ sy
	}
	else if f = 8 ; +[value]% [string] [string2] 
	{
		;redefine values for edge case
		if (p = 0)
		{
			vn := RTrim(vn / (2 ** OpParam),"0")
			vx := RTrim(vx / (2 ** OpParam),"0")
			vn := Trim(RTrim(vn,"0"),".")
			vx := Trim(RTrim(vx,"0"),".")
			vr := "(" vn " to " vx ")" ;value range
			vz := RTrim((vn + vx) / 2,"0") ;value average (rounded)
			vzb := a_space "[" vz "]" ; value average in brackets
		}
		else 
		{
			vn := RTrim(p / (2** OpParam),"0")
			vx := RTrim(p / (2** OpParam),"0")
			vn := Trim(RTrim(vn,"0"),".")
			vx := Trim(RTrim(vx,"0"),".")
			vr := "(" vn " to " vx ")" ;value range
			vz := Rtrim((vn + vx) / 2,"0") ;value average (rounded)
			vzb := a_space "[" vz "]" ; value average in brackets
		}
		if d = 1
			s:= "+" vr "%" _sx _sy vzb
		else if d = 2
			s:= sx_ sy_ "+" vr "%" vzb
		else
			s:= sx_ sy
	}
	else if f = 9 ; [value] [string] [string2] 
	{
		;redefine values for edge case
		if (p = 0)
		{
			vn := vn / (2 ** OpParam)
			vx := vx / (2 ** OpParam)
			vn := Trim(RTrim(vn,"0"),".")
			vx := Trim(RTrim(vx,"0"),".")
			vr := "(" vn " to " vx ")" ;value range
			vz := RTrim((vn + vx) / 2,"0") ;value average (rounded)
			vzb := a_space "[" vz "]" ; value average in brackets
		}
		else 
		{
				vn := p / (2** OpParam)
				vx := p / (2** OpParam)
				vn := Trim(RTrim(vn,"0"),".")
				vx := Trim(RTrim(vx,"0"),".")
				vr := "(" vn " to " vx ")" ;value range
				vz := Rtrim((vn + vx) / 2,"0") ;value average (rounded)
				vzb := a_space "[" vz "]" ; value average in brackets
		}
		if d = 1
			s:= vr _sx _sy vzb
		else if d = 2
			s:= sx_ vr _sy vzb
		else
			s:= sx_ sy
	}
	else if f = 10 ; [value/1.28]% [string] [string2] 
	{
		;redefine values for edge case
		vn := vn/1.28 
		vx := vx/1.28
		vr := "(" vn " to " vx ")"
		vz := Round((vn + vx) / 2)
		vzb := a_space "[" vz "]"
		
		if d = 1
			s := vr "%" _sx _sy vzb
		else if d = 2
			s:= sx_ vr "%" vzb
		else
			s := sx_ sy
	}
	else if f = 11 ; Repairs 1 durability in [100/value] seconds 
	{
		;redefine values for edge case
		vn := Round(100/p)
		;~ vx := 100/25
		;~ vr := "(" vn " to " vx ")"
		;~ vz := Round((vn + vx) / 2)
		;~ vzb := a_space "[" vz "]"
		
		if d = 1
			s := StrReplace(sx,"%d",vn)
		else if d = 2
			s := StrReplace(sx,"%d",vn)
		else
			s := StrReplace(sx,"%d",vn)
	}
	else if f = 12 ; +[value] [string] // used for stupidity, freeze 
	{
		if d = 1
			s := "+" vr sx vzb
		else if d = 2
			s := sx_ "+" vr vzb
		else
			s := sx
	}
	else if f = 13 ; +[value] to [class] skill levels 
	{
		if p = 0
		{
			s := "+" vr " to " sx_ "Skills" vzb
		}
		else
		{
			s := "+" p " to random class skill levels"
		}
	}
	else if f = 14 ; +[value] to [skilltab] skills ([class] only) 
	{
			sx := StrReplace(sx,"%d",vr)
			s := sx " (" sy_ "only)" vzb
	}
	else if f = 15 ; [chance]% to case [slvl] [skill] on [event] 
	{
		s := StrReplace(sx,"%d%",vn)
		s := StrReplace(s,"%d",vx)
		s := StrReplace(s,"%s",p)
	}
	else if f = 16 ; Level %d %s Aura When Equipped 
	{
		s := StrReplace(sx,"%d%",vn)
		s := StrReplace(s,"%d",vr)
		s := StrReplace(s,"%s",p) vzb
	}
	else if f = 17 ; [value] [string1] (Increases near [time]) 
	{
		p:=(p=0) ? "(Increases During Daytime)"
		: (p=1) ? "(Increases Near Dusk)"
		: (p=2) ? "(Increases During Nighttime)"
		: (p=3) ? "(Increases Near Dawn)"
		: p ; if p isn't any of the above, keep same value
		
		if d = 1
			s := "+" vr _sx a_space p vzb
		else if d = 2
			s := "f " f " placeholder d" d " | " sx  vzb
		else
			s := "f " f " placeholder d" d " | " sx vzb
	}
	else if f = 18 ; [value]% [string1] (Increases near [time]) 
	{
		p:=(p=0) ? "(Increases During Daytime)"
		: (p=1) ? "(Increases Near Dusk)"
		: (p=2) ? "(Increases During Nighttime)"
		: (p=3) ? "(Increases Near Dawn)"
		: p ; if p isn't any of the above, keep same value

		if d = 1
			s := "+" vr "%" _sx a_space p vzb
		else if d = 2
			s := "f " f " placeholder d" d " | " sx vzb
		else
			s := "f " f " placeholder d" d " | " sx vzb
		;~ msgbox % "vr:"vr "`nvn:" vn "`nvx:" vx "`nsx:" sx "`nsy:" sy "`np:" p "`nd:" d
	}
	else if f = 19 ; this is used by stats that use Blizzard's sprintf implementation (if you don't know what that is, it won't be of interest to you eitherway I guess), look at how prismatic is setup, the string is the format that gets passed to their sprintf spinoff. 
	{
		if d = 1
			s := "f " f " placeholder d" d " | " sx vzb
		else if d = 2
			s := "f " f " placeholder d" d " | " sx vzb
		else
			s := StrReplace(sx,"%d",vr) vzb
			;~ s := "f " f " placeholder d" d " | " sx vzb
	}
	else if f = 20 ; [value * -1]% [string1] 
	{
		;redefine values for edge case
		vn := vn * -1
		vx := vx * -1
		vr := "(" vn " to " vx ")"
		vz := Round((vn + vx) / 2)
		vzb := a_space "[" vz "]"
		
		if d = 1
			s:=  vr "%" _sx vzb
		else if d = 2
			s:= sx_ vr "%" vzb
		else
			s:= sx
	}
	else if f = 21 ; [value * -1] [string1] 
	{
		;redefine values for edge case
		vn := vn * -1
		vx := vx * -1
		vr := "(" vn " to " vx ")"
		vz := Round((vn + vx) / 2)
		vzb := a_space "[" vz "]"
		
		if d = 1
			s:=  vr _sx vzb
		else if d = 2
			s:= sx_ vr vzb
		else
			s:= sx
	}
	else if f = 22 ; [value]% [string1] [montype] (warning: this is bugged in vanilla and doesn't work properly, see CE forum) 
	{
		if d = 1
			s := "f " f " placeholder d" d " | " sx vzb
		else if d = 2
			s := "f " f " placeholder d" d " | " sx vzb
		else
			s := "f " f " placeholder d" d " | " sx vzb
	}
	else if f = 23 ; [value]% [string1] [monster] 
	{
		if d = 1
			s := vr "%" _sx _sy vzb
		else if d = 2
			s := "f " f " placeholder d" d " | " sx vzb
		else
			s := "f " f " placeholder d" d " | " sx vzb
	}
	else if f = 24 ; used for charges, we all know how that desc looks icon_wink.gif 
	{
		s := vn _sx a_space vx a_space p
	}
	else if f = 25 ; not used by vanilla, present in the code but I didn't test it yet 
	{
		if d = 1
		{
			s := "f " f " placeholder d" d " | " sx vzb
		}
		else if d = 2
		{
			s := "f " f " placeholder d" d " | " sx vzb
		}
		else
		{
			s := "f " f " placeholder d" d " | " sx vzb
		}
	}
	else if f = 26 ; not used by vanilla, present in the code but I didn't test it yet 
	{
		if d = 1
		{
			s := "f " f " placeholder d" d " | " sx vzb
		}
		else if d = 2
		{
			s := "f " f " placeholder d" d " | " sx vzb
		}
		else
		{
			s := "f " f " placeholder d" d " | " sx vzb
		}
	}
	else if f = 27 ; +[value] to [skill] ([class] Only) 
	{
		if d = 1
		{
			s := "f " f " placeholder d" d " | " sx_ sy_ p vzb
		}
		else if d = 2
		{
			s := "f " f " placeholder d" d " | " sx_ sy_ p vzb
		}
		else
		{
			s := "+" vr " to " p " (" sx_ "only)" vzb
		}
		if sx = 
			s := StrReplace(s," only", "Oskill")
	}
	else if f = 28 ; +[value] to [skill] 
	{
		if d = 1
			s := "+" vr _sx vzb
		else if d = 2
			s := sx_ "+" vr vzb
		else
			s := "+" vr " to " p vzb
	}
	else if (f = -5) || (f = -6) || (f = -7)
	{
		s := StrReplace(sx,"%d%",vn)
		s := StrReplace(s,"%d",vx)
		s .= vzb
	}
	else
	{
		s := "Unknown descfunc: " d ". sx: [" sx "] sy: [" sy "] vn|vx: " vn "|" vx vzb
	}
	
	
	if (vn = vx) ;cleanup check, replace value range with a single value, remove value average
	{
		s := StrReplace(s,vr,vx)
		s := Trim(StrReplace(s,vzb))
	}
	if (s = "an evil force")
		s := s " {{desc:" f "}}"
	return s ;return the finished string
	
}





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
; ======================================================================================================================
; Function:         Class definitions as wrappers for SQLite3.dll to work with SQLite DBs.
; AHK version:      1.1.23.01
; Tested on:        Win 10 Pro (x64), SQLite 3.7.13
; Version:          0.0.01.00/2011-08-10/just me
;                   0.0.02.00/2012-08-10/just me   -  Added basic BLOB support
;                   0.0.03.00/2012-08-11/just me   -  Added more advanced BLOB support
;                   0.0.04.00/2013-06-29/just me   -  Added new methods AttachDB and DetachDB
;                   0.0.05.00/2013-08-03/just me   -  Changed base class assignment
;                   0.0.06.00/2016-01-28/just me   -  Fixed version check, revised parameter initialization.
;                   0.0.07.00/2016-03-28/just me   -  Added support for PRAGMA statements.
; Remarks:          Names of "private" properties / methods are prefixed with an underscore,
;                   they must not be set / called by the script!
;                   
;                   SQLite3.dll file is assumed to be in the script's folder, otherwise you have to
;                   provide an INI-File SQLiteDB.ini in the script's folder containing the path:
;                   [Main]
;                   DllPath=Path to SQLite3.dll
;
;                   Encoding of SQLite DBs is assumed to be UTF-8
;                   Minimum supported SQLite3.dll version is 3.6
;                   Download the current version of SQLite3.dll (and also SQlite3.exe) from www.sqlite.org
; ======================================================================================================================
; This software is provided 'as-is', without any express or implied warranty.
; In no event will the authors be held liable for any damages arising from the
; use of this software.
; ======================================================================================================================
; CLASS SQliteDB - SQLiteDB main class
; ======================================================================================================================
Class SQLiteDB Extends SQLiteDB.BaseClass {
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; PRIVATE Properties and Methods ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; ===================================================================================================================
   ; BaseClass - SQLiteDB base class
   ; ===================================================================================================================
   Class BaseClass {
      Static Version := ""
      Static _SQLiteDLL := A_ScriptDir . "\SQLite3.dll"
      Static _RefCount := 0
      Static _MinVersion := "3.6"
   }
   ; ===================================================================================================================
   ; CLASS _Table
   ; Object returned from method GetTable()
   ; _Table is an independent object and does not need SQLite after creation at all.
   ; ===================================================================================================================
   Class _Table {
      ; ----------------------------------------------------------------------------------------------------------------
      ; CONSTRUCTOR  Create instance variables
      ; ----------------------------------------------------------------------------------------------------------------
      __New() {
          This.ColumnCount := 0          ; Number of columns in the result table         (Integer)
          This.RowCount := 0             ; Number of rows in the result table            (Integer)     
          This.ColumnNames := []         ; Names of columns in the result table          (Array)
          This.Rows := []                ; Rows of the result table                      (Array of Arrays)
          This.HasNames := False         ; Does var ColumnNames contain names?           (Bool)
          This.HasRows := False          ; Does var Rows contain rows?                   (Bool)
          This._CurrentRow := 0          ; Row index of last returned row                (Integer)
      }
      ; ----------------------------------------------------------------------------------------------------------------
      ; METHOD GetRow      Get row for RowIndex
      ; Parameters:        RowIndex    - Index of the row to retrieve, the index of the first row is 1
      ;                    ByRef Row   - Variable to pass out the row array
      ; Return values:     On failure  - False
      ;                    On success  - True, Row contains a valid array
      ; Remarks:           _CurrentRow is set to RowIndex, so a subsequent call of NextRow() will return the
      ;                    following row.
      ; ----------------------------------------------------------------------------------------------------------------
      GetRow(RowIndex, ByRef Row) {
         Row := ""
         If (RowIndex < 1 || RowIndex > This.RowCount)
            Return False
         If !This.Rows.HasKey(RowIndex)
            Return False
         Row := This.Rows[RowIndex]
         This._CurrentRow := RowIndex
         Return True
      }
      ; ----------------------------------------------------------------------------------------------------------------
      ; METHOD Next        Get next row depending on _CurrentRow
      ; Parameters:        ByRef Row   - Variable to pass out the row array
      ; Return values:     On failure  - False, -1 for EOR (end of rows)
      ;                    On success  - True, Row contains a valid array
      ; ----------------------------------------------------------------------------------------------------------------
      Next(ByRef Row) {
         Row := ""
         If (This._CurrentRow >= This.RowCount)
            Return -1
         This._CurrentRow += 1
         If !This.Rows.HasKey(This._CurrentRow)
            Return False
         Row := This.Rows[This._CurrentRow]
         Return True
      }
      ; ----------------------------------------------------------------------------------------------------------------
      ; METHOD Reset       Reset _CurrentRow to zero
      ; Parameters:        None
      ; Return value:      True
      ; ----------------------------------------------------------------------------------------------------------------
      Reset() {
         This._CurrentRow := 0
         Return True
      }
   }  
   ; ===================================================================================================================
   ; CLASS _RecordSet
   ; Object returned from method Query()
   ; The records (rows) of a recordset can be accessed sequentially per call of Next() starting with the first record.
   ; After a call of Reset() calls of Next() will start with the first record again.
   ; When the recordset isn't needed any more, call Free() to free the resources.
   ; The lifetime of a recordset depends on the lifetime of the related SQLiteDB object.
   ; ===================================================================================================================
   Class _RecordSet {
      ; ----------------------------------------------------------------------------------------------------------------
      ; CONSTRUCTOR  Create instance variables
      ; ----------------------------------------------------------------------------------------------------------------
      __New() {
          This.ColumnCount := 0          ; Number of columns                             (Integer)
          This.ColumnNames := []         ; Names of columns in the result table          (Array)
          This.HasNames := False         ; Does var ColumnNames contain names?           (Bool)
          This.HasRows := False          ; Does _RecordSet contain rows?                 (Bool)
          This.CurrentRow := 0           ; Index of current row                          (Integer)
          This.ErrorMsg := ""            ; Last error message                            (String)
          This.ErrorCode := 0            ; Last SQLite error code / ErrorLevel           (Variant)
          This._Handle := 0              ; Query handle                                  (Pointer)
          This._DB := {}                 ; SQLiteDB object                               (Object) 
      }
      ; ----------------------------------------------------------------------------------------------------------------
      ; METHOD Next        Get next row of query result
      ; Parameters:        ByRef Row   - Variable to store the row array
      ; Return values:     On success  - True, Row contains the row array
      ;                    On failure  - False, ErrorMsg / ErrorCode contain additional information
      ;                                  -1 for EOR (end of records)
      ; ----------------------------------------------------------------------------------------------------------------
      Next(ByRef Row) {
         Static SQLITE_NULL := 5
         Static SQLITE_BLOB := 4
         Static EOR := -1
         Row := ""
         This.ErrorMsg := ""
         This.ErrorCode := 0
         If !(This._Handle) {
            This.ErrorMsg := "Invalid query handle!"
            Return False
         }
         RC := DllCall("SQlite3.dll\sqlite3_step", "Ptr", This._Handle, "Cdecl Int")
         If (ErrorLevel) {
            This.ErrorMsg := "DLLCall sqlite3_step failed!"
            This.ErrorCode := ErrorLevel
            Return False
         }
         If (RC <> This._DB._ReturnCode("SQLITE_ROW")) {
            If (RC = This._DB._ReturnCode("SQLITE_DONE")) {
               This.ErrorMsg := "EOR"
               This.ErrorCode := RC
               Return EOR
            }
            This.ErrorMsg := This._DB.ErrMsg()
            This.ErrorCode := RC
            Return False
         }
         RC := DllCall("SQlite3.dll\sqlite3_data_count", "Ptr", This._Handle, "Cdecl Int")
         If (ErrorLevel) {
            This.ErrorMsg := "DLLCall sqlite3_data_count failed!"
            This.ErrorCode := ErrorLevel
            Return False
         }
         If (RC < 1) {
            This.ErrorMsg := "RecordSet is empty!"
            This.ErrorCode := This._DB._ReturnCode("SQLITE_EMPTY")
            Return False
         }
         Row := []
         Loop, %RC% {
            Column := A_Index - 1
            ColumnType := DllCall("SQlite3.dll\sqlite3_column_type", "Ptr", This._Handle, "Int", Column, "Cdecl Int")
            If (ErrorLevel) {
               This.ErrorMsg := "DLLCall sqlite3_column_type failed!"
               This.ErrorCode := ErrorLevel
               Return False
            }
            If (ColumnType = SQLITE_NULL) {
               Row[A_Index] := ""
            } Else If (ColumnType = SQLITE_BLOB) {
               BlobPtr := DllCall("SQlite3.dll\sqlite3_column_blob", "Ptr", This._Handle, "Int", Column, "Cdecl UPtr")
               BlobSize := DllCall("SQlite3.dll\sqlite3_column_bytes", "Ptr", This._Handle, "Int", Column, "Cdecl Int")
               If (BlobPtr = 0) || (BlobSize = 0) {
                  Row[A_Index] := ""
               } Else {
                  Row[A_Index] := {}
                  Row[A_Index].Size := BlobSize
                  Row[A_Index].Blob := ""
                  Row[A_Index].SetCapacity("Blob", BlobSize)
                  Addr := Row[A_Index].GetAddress("Blob")
                  DllCall("Kernel32.dll\RtlMoveMemory", "Ptr", Addr, "Ptr", BlobPtr, "Ptr", BlobSize)
               }
            } Else {
               StrPtr := DllCall("SQlite3.dll\sqlite3_column_text", "Ptr", This._Handle, "Int", Column, "Cdecl UPtr")
               If (ErrorLevel) {
                  This.ErrorMsg := "DLLCall sqlite3_column_text failed!"
                  This.ErrorCode := ErrorLevel
                  Return False
               }
               Row[A_Index] := StrGet(StrPtr, "UTF-8")
            }
         }
         This.CurrentRow += 1
         Return True
      }
      ; ----------------------------------------------------------------------------------------------------------------
      ; METHOD Reset       Reset the result pointer
      ; Parameters:        None
      ; Return values:     On success  - True
      ;                    On failure  - False, ErrorMsg / ErrorCode contain additional information
      ; Remarks:           After a call of this method you can access the query result via Next() again.
      ; ----------------------------------------------------------------------------------------------------------------
      Reset() {
         This.ErrorMsg := ""
         This.ErrorCode := 0
         If !(This._Handle) {
            This.ErrorMsg := "Invalid query handle!"
            Return False
         }
         RC := DllCall("SQlite3.dll\sqlite3_reset", "Ptr", This._Handle, "Cdecl Int")
         If (ErrorLevel) {
            This.ErrorMsg := "DLLCall sqlite3_reset failed!"
            This.ErrorCode := ErrorLevel
            Return False
         }
         If (RC) {
            This.ErrorMsg := This._DB._ErrMsg()
            This.ErrorCode := RC
            Return False
         }
         This.CurrentRow := 0
         Return True
      }
      ; ----------------------------------------------------------------------------------------------------------------
      ; METHOD Free        Free query result
      ; Parameters:        None
      ; Return values:     On success  - True
      ;                    On failure  - False, ErrorMsg / ErrorCode contain additional information
      ; Remarks:           After the call of this method further access on the query result is impossible.
      ; ----------------------------------------------------------------------------------------------------------------
      Free() {
         This.ErrorMsg := ""
         This.ErrorCode := 0
         If !(This._Handle)
            Return True
         RC := DllCall("SQlite3.dll\sqlite3_finalize", "Ptr", This._Handle, "Cdecl Int")
         If (ErrorLevel) {
            This.ErrorMsg := "DLLCall sqlite3_finalize failed!"
            This.ErrorCode := ErrorLevel
            Return False
         }
         If (RC) {
            This.ErrorMsg := This._DB._ErrMsg()
            This.ErrorCode := RC
            Return False
         }
         This._DB._Queries.Remove(This._Handle)
         This._Handle := 0
         Return True
      }
   }
   ; ===================================================================================================================
   ; CONSTRUCTOR __New
   ; ===================================================================================================================
   __New() {
      This._Path := ""                  ; Database path                                 (String)
      This._Handle := 0                 ; Database handle                               (Pointer)
      This._Queries := {}               ; Valid queries                                 (Object)
      If (This.Base._RefCount = 0) {
         SQLiteDLL := This.Base._SQLiteDLL
         If !FileExist(SQLiteDLL)
            If FileExist(A_ScriptDir . "\SQLiteDB.ini") {
               IniRead, SQLiteDLL, %A_ScriptDir%\SQLiteDB.ini, Main, DllPath, %SQLiteDLL%
               This.Base._SQLiteDLL := SQLiteDLL
         }
         If !(DLL := DllCall("LoadLibrary", "Str", This.Base._SQLiteDLL, "UPtr")) {
            MsgBox, 16, SQLiteDB Error, % "DLL " . SQLiteDLL . " does not exist!"
            ExitApp
         }
         This.Base.Version := StrGet(DllCall("SQlite3.dll\sqlite3_libversion", "Cdecl UPtr"), "UTF-8")
         SQLVersion := StrSplit(This.Base.Version, ".")
         MinVersion := StrSplit(This.Base._MinVersion, ".")
         If (SQLVersion[1] < MinVersion[1]) || ((SQLVersion[1] = MinVersion[1]) && (SQLVersion[2] < MinVersion[2])){
            DllCall("FreeLibrary", "Ptr", DLL)
            MsgBox, 16, SQLite ERROR, % "Version " . This.Base.Version .  " of SQLite3.dll is not supported!`n`n"
                                      . "You can download the current version from www.sqlite.org!"
            ExitApp
         }
      }
      This.Base._RefCount += 1
   }
   ; ===================================================================================================================
   ; DESTRUCTOR __Delete
   ; ===================================================================================================================
   __Delete() {
      If (This._Handle)
         This.CloseDB()
      This.Base._RefCount -= 1
      If (This.Base._RefCount = 0) {
         If (DLL := DllCall("GetModuleHandle", "Str", This.Base._SQLiteDLL, "UPtr"))
            DllCall("FreeLibrary", "Ptr", DLL)
      }
   }
   ; ===================================================================================================================
   ; PRIVATE _StrToUTF8
   ; ===================================================================================================================
   _StrToUTF8(Str, ByRef UTF8) {
      VarSetCapacity(UTF8, StrPut(Str, "UTF-8"), 0)
      StrPut(Str, &UTF8, "UTF-8")
      Return &UTF8
   }
   ; ===================================================================================================================
   ; PRIVATE _UTF8ToStr
   ; ===================================================================================================================
   _UTF8ToStr(UTF8) {
      Return StrGet(UTF8, "UTF-8")
   }
   ; ===================================================================================================================
   ; PRIVATE _ErrMsg
   ; ===================================================================================================================
   _ErrMsg() {
      If (RC := DllCall("SQlite3.dll\sqlite3_errmsg", "Ptr", This._Handle, "Cdecl UPtr"))
         Return StrGet(&RC, "UTF-8")
      Return ""
   }
   ; ===================================================================================================================
   ; PRIVATE _ErrCode
   ; ===================================================================================================================
   _ErrCode() {
      Return DllCall("SQlite3.dll\sqlite3_errcode", "Ptr", This._Handle, "Cdecl Int")
   }
   ; ===================================================================================================================
   ; PRIVATE _Changes
   ; ===================================================================================================================
   _Changes() {
      Return DllCall("SQlite3.dll\sqlite3_changes", "Ptr", This._Handle, "Cdecl Int")
   }
   ; ===================================================================================================================
   ; PRIVATE _Returncode
   ; ===================================================================================================================
   _ReturnCode(RC) {
      Static RCODE := {SQLITE_OK: 0          ; Successful result
                     , SQLITE_ERROR: 1       ; SQL error or missing database
                     , SQLITE_INTERNAL: 2    ; NOT USED. Internal logic error in SQLite
                     , SQLITE_PERM: 3        ; Access permission denied
                     , SQLITE_ABORT: 4       ; Callback routine requested an abort
                     , SQLITE_BUSY: 5        ; The database file is locked
                     , SQLITE_LOCKED: 6      ; A table in the database is locked
                     , SQLITE_NOMEM: 7       ; A malloc() failed
                     , SQLITE_READONLY: 8    ; Attempt to write a readonly database
                     , SQLITE_INTERRUPT: 9   ; Operation terminated by sqlite3_interrupt()
                     , SQLITE_IOERR: 10      ; Some kind of disk I/O error occurred
                     , SQLITE_CORRUPT: 11    ; The database disk image is malformed
                     , SQLITE_NOTFOUND: 12   ; NOT USED. Table or record not found
                     , SQLITE_FULL: 13       ; Insertion failed because database is full
                     , SQLITE_CANTOPEN: 14   ; Unable to open the database file
                     , SQLITE_PROTOCOL: 15   ; NOT USED. Database lock protocol error
                     , SQLITE_EMPTY: 16      ; Database is empty
                     , SQLITE_SCHEMA: 17     ; The database schema changed
                     , SQLITE_TOOBIG: 18     ; String or BLOB exceeds size limit
                     , SQLITE_CONSTRAINT: 19 ; Abort due to constraint violation
                     , SQLITE_MISMATCH: 20   ; Data type mismatch
                     , SQLITE_MISUSE: 21     ; Library used incorrectly
                     , SQLITE_NOLFS: 22      ; Uses OS features not supported on host
                     , SQLITE_AUTH: 23       ; Authorization denied
                     , SQLITE_FORMAT: 24     ; Auxiliary database format error
                     , SQLITE_RANGE: 25      ; 2nd parameter to sqlite3_bind out of range
                     , SQLITE_NOTADB: 26     ; File opened that is not a database file
                     , SQLITE_ROW: 100       ; sqlite3_step() has another row ready
                     , SQLITE_DONE: 101}     ; sqlite3_step() has finished executing
      Return RCODE.HasKey(RC) ? RCODE[RC] : ""
   }
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; PUBLIC Interface ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; ===================================================================================================================
   ; Properties
   ; ===================================================================================================================
    ErrorMsg := ""              ; Error message                           (String) 
    ErrorCode := 0              ; SQLite error code / ErrorLevel          (Variant)
    Changes := 0                ; Changes made by last call of Exec()     (Integer)
    SQL := ""                   ; Last executed SQL statement             (String)
   ; ===================================================================================================================
   ; METHOD OpenDB         Open a database
   ; Parameters:           DBPath      - Path of the database file
   ;                       Access      - Wanted access: "R"ead / "W"rite
   ;                       Create      - Create new database in write mode, if it doesn't exist
   ; Return values:        On success  - True
   ;                       On failure  - False, ErrorMsg / ErrorCode contain additional information
   ; Remarks:              If DBPath is empty in write mode, a database called ":memory:" is created in memory
   ;                       and deletet on call of CloseDB.
   ; ===================================================================================================================
   OpenDB(DBPath, Access := "W", Create := True) {
      Static SQLITE_OPEN_READONLY  := 0x01 ; Database opened as read-only
      Static SQLITE_OPEN_READWRITE := 0x02 ; Database opened as read-write
      Static SQLITE_OPEN_CREATE    := 0x04 ; Database will be created if not exists
      Static MEMDB := ":memory:"
      This.ErrorMsg := ""
      This.ErrorCode := 0
      HDB := 0
      If (DBPath = "")
         DBPath := MEMDB
      If (DBPath = This._Path) && (This._Handle)
         Return True
      If (This._Handle) {
         This.ErrorMsg := "You must first close DB " . This._Path . "!"
         Return False
      }
      Flags := 0
      Access := SubStr(Access, 1, 1)
      If (Access <> "W") && (Access <> "R")
         Access := "R"
      Flags := SQLITE_OPEN_READONLY
      If (Access = "W") {
         Flags := SQLITE_OPEN_READWRITE
         If (Create)
            Flags |= SQLITE_OPEN_CREATE
      }
      This._Path := DBPath
      This._StrToUTF8(DBPath, UTF8)
      RC := DllCall("SQlite3.dll\sqlite3_open_v2", "Ptr", &UTF8, "PtrP", HDB, "Int", Flags, "Ptr", 0, "Cdecl Int")
      If (ErrorLevel) {
         This._Path := ""
         This.ErrorMsg := "DLLCall sqlite3_open_v2 failed!"
         This.ErrorCode := ErrorLevel
         Return False
      }
      If (RC) {
         This._Path := ""
         This.ErrorMsg := This._ErrMsg()
         This.ErrorCode := RC
         Return False
      }
      This._Handle := HDB
      Return True
   }
   ; ===================================================================================================================
   ; METHOD CloseDB        Close database
   ; Parameters:           None
   ; Return values:        On success  - True
   ;                       On failure  - False, ErrorMsg / ErrorCode contain additional information
   ; ===================================================================================================================
   CloseDB() {
      This.ErrorMsg := ""
      This.ErrorCode := 0
      This.SQL := ""
      If !(This._Handle)
         Return True
      For Each, Query in This._Queries
         DllCall("SQlite3.dll\sqlite3_finalize", "Ptr", Query, "Cdecl Int")
      RC := DllCall("SQlite3.dll\sqlite3_close", "Ptr", This._Handle, "Cdecl Int")
      If (ErrorLevel) {
         This.ErrorMsg := "DLLCall sqlite3_close failed!"
         This.ErrorCode := ErrorLevel
         Return False
      }
      If (RC) {
         This.ErrorMsg := This._ErrMsg()
         This.ErrorCode := RC
         Return False
      }
      This._Path := ""
      This._Handle := ""
      This._Queries := []
      Return True
   }
   ; ===================================================================================================================
   ; METHOD AttachDB       Add another database file to the current database connection
   ;                       http://www.sqlite.org/lang_attach.html
   ; Parameters:           DBPath      - Path of the database file
   ;                       DBAlias     - Database alias name used internally by SQLite
   ; Return values:        On success  - True
   ;                       On failure  - False, ErrorMsg / ErrorCode contain additional information
   ; ===================================================================================================================
   AttachDB(DBPath, DBAlias) {
      Return This.Exec("ATTACH DATABASE '" . DBPath . "' As " . DBAlias . ";")
   }
   ; ===================================================================================================================
   ; METHOD DetachDB       Detaches an additional database connection previously attached using AttachDB()
   ;                       http://www.sqlite.org/lang_detach.html
   ; Parameters:           DBAlias     - Database alias name used with AttachDB()
   ; Return values:        On success  - True
   ;                       On failure  - False, ErrorMsg / ErrorCode contain additional information
   ; ===================================================================================================================
   DetachDB(DBAlias) {
      Return This.Exec("DETACH DATABASE " . DBAlias . ";")
   }
   ; ===================================================================================================================
   ; METHOD Exec           Execute SQL statement
   ; Parameters:           SQL         - Valid SQL statement
   ;                       Callback    - Name of a callback function to invoke for each result row coming out
   ;                                     of the evaluated SQL statements.
   ;                                     The function must accept 4 parameters:
   ;                                     1: SQLiteDB object
   ;                                     2: Number of columns
   ;                                     3: Pointer to an array of pointers to columns text
   ;                                     4: Pointer to an array of pointers to column names
   ;                                     The address of the current SQL string is passed in A_EventInfo.
   ;                                     If the callback function returns non-zero, DB.Exec() returns SQLITE_ABORT
   ;                                     without invoking the callback again and without running any subsequent
   ;                                     SQL statements.  
   ; Return values:        On success  - True, the number of changed rows is given in property Changes
   ;                       On failure  - False, ErrorMsg / ErrorCode contain additional information
   ; ===================================================================================================================
   Exec(SQL, Callback := "") {
      This.ErrorMsg := ""
      This.ErrorCode := 0
      This.SQL := SQL
      If !(This._Handle) {
         This.ErrorMsg := "Invalid dadabase handle!"
         Return False
      }
      CBPtr := 0
      Err := 0
      If (FO := Func(Callback)) && (FO.MinParams = 4)
         CBPtr := RegisterCallback(Callback, "F C", 4, &SQL)
      This._StrToUTF8(SQL, UTF8)
      RC := DllCall("SQlite3.dll\sqlite3_exec", "Ptr", This._Handle, "Ptr", &UTF8, "Int", CBPtr, "Ptr", Object(This)
                  , "PtrP", Err, "Cdecl Int")
      CallError := ErrorLevel
      If (CBPtr)
         DllCall("Kernel32.dll\GlobalFree", "Ptr", CBPtr)
      If (CallError) {
         This.ErrorMsg := "DLLCall sqlite3_exec failed!"
         This.ErrorCode := CallError
         Return False
      }
      If (RC) {
         This.ErrorMsg := StrGet(Err, "UTF-8")
         This.ErrorCode := RC
         DllCall("SQlite3.dll\sqlite3_free", "Ptr", Err, "Cdecl")
         Return False
      }
      This.Changes := This._Changes()
      Return True
   }
   ; ===================================================================================================================
   ; METHOD GetTable       Get complete result for SELECT query
   ; Parameters:           SQL         - SQL SELECT statement
   ;                       ByRef TB    - Variable to store the result object (TB _Table)
   ;                       MaxResult   - Number of rows to return:
   ;                          0          Complete result (default)
   ;                         -1          Return only RowCount and ColumnCount
   ;                         -2          Return counters and array ColumnNames
   ;                          n          Return counters and ColumnNames and first n rows
   ; Return values:        On success  - True, TB contains the result object
   ;                       On failure  - False, ErrorMsg / ErrorCode contain additional information
   ; ===================================================================================================================
   GetTable(SQL, ByRef TB, MaxResult := 0) {
      TB := ""
      This.ErrorMsg := ""
      This.ErrorCode := 0
      This.SQL := SQL
      If !(This._Handle) {
         This.ErrorMsg := "Invalid dadabase handle!"
         Return False
      }
      If !RegExMatch(SQL, "i)^\s*(SELECT|PRAGMA)\s") {
         This.ErrorMsg := "Method " . A_ThisFunc . " requires a query statement!"
         Return False
      }
      Names := ""
      Err := 0, RC := 0, GetRows := 0
      I := 0, Rows := Cols := 0
      Table := 0
      If MaxResult Is Not Integer
         MaxResult := 0
      If (MaxResult < -2)
         MaxResult := 0
      This._StrToUTF8(SQL, UTF8)
      RC := DllCall("SQlite3.dll\sqlite3_get_table", "Ptr", This._Handle, "Ptr", &UTF8, "PtrP", Table
                  , "IntP", Rows, "IntP", Cols, "PtrP", Err, "Cdecl Int")
      If (ErrorLevel) {
         This.ErrorMsg := "DLLCall sqlite3_get_table failed!"
         This.ErrorCode := ErrorLevel
         Return False
      }
      If (RC) {
         This.ErrorMsg := StrGet(Err, "UTF-8")
         This.ErrorCode := RC
         DllCall("SQlite3.dll\sqlite3_free", "Ptr", Err, "Cdecl")
         Return False
      }
      TB := new This._Table
      TB.ColumnCount := Cols
      TB.RowCount := Rows
      If (MaxResult = -1) {
         DllCall("SQlite3.dll\sqlite3_free_table", "Ptr", Table, "Cdecl")
         If (ErrorLevel) {
            This.ErrorMsg := "DLLCall sqlite3_free_table failed!"
            This.ErrorCode := ErrorLevel
            Return False
         }
         Return True
      }
      If (MaxResult = -2)
         GetRows := 0
      Else If (MaxResult > 0) && (MaxResult <= Rows)
         GetRows := MaxResult
      Else
         GetRows := Rows
      Offset := 0
      Names := Array()
      Loop, %Cols% {
         Names[A_Index] := StrGet(NumGet(Table+0, Offset, "UPtr"), "UTF-8")
         Offset += A_PtrSize
      }
      TB.ColumnNames := Names
      TB.HasNames := True
      Loop, %GetRows% {
         I := A_Index
         TB.Rows[I] := []
         Loop, %Cols% {
            TB.Rows[I][A_Index] := StrGet(NumGet(Table+0, Offset, "UPtr"), "UTF-8")
            Offset += A_PtrSize
         }
      }
      If (GetRows)
         TB.HasRows := True
      DllCall("SQlite3.dll\sqlite3_free_table", "Ptr", Table, "Cdecl")
      If (ErrorLevel) {
         TB := ""
         This.ErrorMsg := "DLLCall sqlite3_free_table failed!"
         This.ErrorCode := ErrorLevel
         Return False
      }
      Return True
   }
   ; ===================================================================================================================
   ; METHOD Query          Get "recordset" object for prepared SELECT query
   ; Parameters:           SQL         - SQL SELECT statement
   ;                       ByRef RS    - Variable to store the result object (Class _RecordSet)
   ; Return values:        On success  - True, RS contains the result object
   ;                       On failure  - False, ErrorMsg / ErrorCode contain additional information
   ; ===================================================================================================================
   Query(SQL, ByRef RS) {
      RS := ""
      This.ErrorMsg := ""
      This.ErrorCode := 0
      This.SQL := SQL
      ColumnCount := 0
      HasRows := False
      If !(This._Handle) {
         This.ErrorMsg := "Invalid dadabase handle!"
         Return False
      }
      If !RegExMatch(SQL, "i)^\s*(SELECT|PRAGMA)\s|") {
         This.ErrorMsg := "Method " . A_ThisFunc . " requires a query statement!"
         Return False
      }
      Query := 0
      This._StrToUTF8(SQL, UTF8)
      RC := DllCall("SQlite3.dll\sqlite3_prepare_v2", "Ptr", This._Handle, "Ptr", &UTF8, "Int", -1
                  , "PtrP", Query, "Ptr", 0, "Cdecl Int")
      If (ErrorLeveL) {
         This.ErrorMsg := "DLLCall sqlite3_prepare_v2 failed!"
         This.ErrorCode := ErrorLevel
         Return False
      }
      If (RC) {
         This.ErrorMsg := This._ErrMsg()
         This.ErrorCode := RC
         Return False
      }
      RC := DllCall("SQlite3.dll\sqlite3_column_count", "Ptr", Query, "Cdecl Int")
      If (ErrorLevel) {
         This.ErrorMsg := "DLLCall sqlite3_column_count failed!"
         This.ErrorCode := ErrorLevel
         Return False
      }
      If (RC < 1) {
         This.ErrorMsg := "Query result is empty!"
         This.ErrorCode := This._ReturnCode("SQLITE_EMPTY")
         Return False
      }
      ColumnCount := RC
      Names := []
      Loop, %RC% {
         StrPtr := DllCall("SQlite3.dll\sqlite3_column_name", "Ptr", Query, "Int", A_Index - 1, "Cdecl UPtr")
         If (ErrorLevel) {
            This.ErrorMsg := "DLLCall sqlite3_column_name failed!"
            This.ErrorCode := ErrorLevel
            Return False
         }
         Names[A_Index] := StrGet(StrPtr, "UTF-8")
      }
      RC := DllCall("SQlite3.dll\sqlite3_step", "Ptr", Query, "Cdecl Int")
      If (ErrorLevel) {
         This.ErrorMsg := "DLLCall sqlite3_step failed!"
         This.ErrorCode := ErrorLevel
         Return False
      }
      If (RC = This._ReturnCode("SQLITE_ROW"))
         HasRows := True
      RC := DllCall("SQlite3.dll\sqlite3_reset", "Ptr", Query, "Cdecl Int")
      If (ErrorLevel) {
         This.ErrorMsg := "DLLCall sqlite3_reset failed!"
         This.ErrorCode := ErrorLevel
         Return False
      }
      RS := new This._RecordSet
      RS.ColumnCount := ColumnCount
      RS.ColumnNames := Names
      RS.HasNames := True
      RS.HasRows := HasRows
      RS._Handle := Query
      RS._DB := This
      This._Queries[Query] := Query
      Return True
   }
   ; ===================================================================================================================
   ; METHOD LastInsertRowID   Get the ROWID of the last inserted row
   ; Parameters:              ByRef RowID - Variable to store the ROWID
   ; Return values:           On success  - True, RowID contains the ROWID
   ;                          On failure  - False, ErrorMsg / ErrorCode contain additional information
   ; ===================================================================================================================
   LastInsertRowID(ByRef RowID) {
      This.ErrorMsg := ""
      This.ErrorCode := 0
      This.SQL := ""
      If !(This._Handle) {
         This.ErrorMsg := "Invalid dadabase handle!"
         Return False
      }
      RowID := 0
      RC := DllCall("SQlite3.dll\sqlite3_last_insert_rowid", "Ptr", This._Handle, "Cdecl Int64")
      If (ErrorLevel) {
         This.ErrorMsg := "DLLCall sqlite3_last_insert_rowid failed!"
         This.ErrorCode := ErrorLevel
         Return False
      }
      RowID := RC
      Return True
   }
   ; ===================================================================================================================
   ; METHOD TotalChanges   Get the number of changed rows since connecting to the database
   ; Parameters:           ByRef Rows  - Variable to store the number of rows
   ; Return values:        On success  - True, Rows contains the number of rows
   ;                       On failure  - False, ErrorMsg / ErrorCode contain additional information
   ; ===================================================================================================================
   TotalChanges(ByRef Rows) {
      This.ErrorMsg := ""
      This.ErrorCode := 0
      This.SQL := ""
      If !(This._Handle) {
         This.ErrorMsg := "Invalid dadabase handle!"
         Return False
      }
      Rows := 0
      RC := DllCall("SQlite3.dll\sqlite3_total_changes", "Ptr", This._Handle, "Cdecl Int")
      If (ErrorLevel) {
         This.ErrorMsg := "DLLCall sqlite3_total_changes failed!"
         This.ErrorCode := ErrorLevel
         Return False
      }
      Rows := RC
      Return True
   }
   ; ===================================================================================================================
   ; METHOD SetTimeout     Set the timeout to wait before SQLITE_BUSY or SQLITE_IOERR_BLOCKED is returned,
   ;                       when a table is locked.
   ; Parameters:           TimeOut     - Time to wait in milliseconds
   ; Return values:        On success  - True
   ;                       On failure  - False, ErrorMsg / ErrorCode contain additional information
   ; ===================================================================================================================
   SetTimeout(Timeout := 1000) {
      This.ErrorMsg := ""
      This.ErrorCode := 0
      This.SQL := ""
      If !(This._Handle) {
         This.ErrorMsg := "Invalid dadabase handle!"
         Return False
      }
      If Timeout Is Not Integer
         Timeout := 1000
      RC := DllCall("SQlite3.dll\sqlite3_busy_timeout", "Ptr", This._Handle, "Cdecl Int")
      If (ErrorLevel) {
         This.ErrorMsg := "DLLCall sqlite3_busy_timeout failed!"
         This.ErrorCode := ErrorLevel
         Return False
      }
      If (RC) {
         This.ErrorMsg := This._ErrMsg()
         This.ErrorCode := RC
         Return False
      }
      Return True
   }
   ; ===================================================================================================================
   ; METHOD EscapeStr      Escapes special characters in a string to be used as field content
   ; Parameters:           Str         - String to be escaped
   ;                       Quote       - Add single quotes around the outside of the total string (True / False)
   ; Return values:        On success  - True
   ;                       On failure  - False, ErrorMsg / ErrorCode contain additional information
   ; ===================================================================================================================
   EscapeStr(ByRef Str, Quote := True) {
      This.ErrorMsg := ""
      This.ErrorCode := 0
      This.SQL := ""
      If !(This._Handle) {
         This.ErrorMsg := "Invalid dadabase handle!"
         Return False
      }
      If Str Is Number
         Return True
      OP := Quote ? "%Q" : "%q"
      This._StrToUTF8(Str, UTF8)
      Ptr := DllCall("SQlite3.dll\sqlite3_mprintf", "Ptr", &OP, "Ptr", &UTF8, "Cdecl UPtr")
      If (ErrorLevel) {
         This.ErrorMsg := "DLLCall sqlite3_mprintf failed!"
         This.ErrorCode := ErrorLevel
         Return False
      }
      Str := This._UTF8ToStr(Ptr)
      DllCall("SQlite3.dll\sqlite3_free", "Ptr", Ptr, "Cdecl")
      Return True
   }
   ; ===================================================================================================================
   ; METHOD StoreBLOB      Use BLOBs as parameters of an INSERT/UPDATE/REPLACE statement.
   ; Parameters:           SQL         - SQL statement to be compiled
   ;                       BlobArray   - Array of objects containing two keys/value pairs:
   ;                                     Addr : Address of the (variable containing the) BLOB.
   ;                                     Size : Size of the BLOB in bytes.
   ; Return values:        On success  - True
   ;                       On failure  - False, ErrorMsg / ErrorCode contain additional information
   ; Remarks:              For each BLOB in the row you have to specify a ? parameter within the statement. The
   ;                       parameters are numbered automatically from left to right starting with 1.
   ;                       For each parameter you have to pass an object within BlobArray containing the address
   ;                       and the size of the BLOB.
   ; ===================================================================================================================
   StoreBLOB(SQL, BlobArray) {
      Static SQLITE_STATIC := 0
      Static SQLITE_TRANSIENT := -1
      This.ErrorMsg := ""
      This.ErrorCode := 0
      If !(This._Handle) {
         This.ErrorMsg := "Invalid dadabase handle!"
         Return False
      }
      If !RegExMatch(SQL, "i)^\s*(INSERT|UPDATE|REPLACE)\s") {
         This.ErrorMsg := A_ThisFunc . " requires an INSERT/UPDATE/REPLACE statement!"
         Return False
      }
      Query := 0
      This._StrToUTF8(SQL, UTF8)
      RC := DllCall("SQlite3.dll\sqlite3_prepare_v2", "Ptr", This._Handle, "Ptr", &UTF8, "Int", -1
                  , "PtrP", Query, "Ptr", 0, "Cdecl Int")
      If (ErrorLeveL) {
         This.ErrorMsg := A_ThisFunc . ": DLLCall sqlite3_prepare_v2 failed!"
         This.ErrorCode := ErrorLevel
         Return False
      }
      If (RC) {
         This.ErrorMsg := A_ThisFunc . ": " . This._ErrMsg()
         This.ErrorCode := RC
         Return False
      }
      For BlobNum, Blob In BlobArray {
         If !(Blob.Addr) || !(Blob.Size) {
            This.ErrorMsg := A_ThisFunc . ": Invalid parameter BlobArray!"
            This.ErrorCode := ErrorLevel
            Return False
         }
         RC := DllCall("SQlite3.dll\sqlite3_bind_blob", "Ptr", Query, "Int", BlobNum, "Ptr", Blob.Addr
                     , "Int", Blob.Size, "Ptr", SQLITE_STATIC, "Cdecl Int")
         If (ErrorLeveL) {
            This.ErrorMsg := A_ThisFunc . ": DLLCall sqlite3_prepare_v2 failed!"
            This.ErrorCode := ErrorLevel
            Return False
         }
         If (RC) {
            This.ErrorMsg := A_ThisFunc . ": " . This._ErrMsg()
            This.ErrorCode := RC
            Return False
         }
      }
      RC := DllCall("SQlite3.dll\sqlite3_step", "Ptr", Query, "Cdecl Int")
      If (ErrorLevel) {
         This.ErrorMsg := A_ThisFunc . ": DLLCall sqlite3_step failed!"
         This.ErrorCode := ErrorLevel
         Return False
      }
      If (RC) && (RC <> This._ReturnCode("SQLITE_DONE")) {
         This.ErrorMsg := A_ThisFunc . ": " . This._ErrMsg()
         This.ErrorCode := RC
         Return False
      }
      RC := DllCall("SQlite3.dll\sqlite3_finalize", "Ptr", Query, "Cdecl Int")
      If (ErrorLevel) {
         This.ErrorMsg := A_ThisFunc . ": DLLCall sqlite3_finalize failed!"
         This.ErrorCode := ErrorLevel
         Return False
      }
      If (RC) {
         This.ErrorMsg := A_ThisFunc . ": " . This._ErrMsg()
         This.ErrorCode := RC
         Return False
      }
      Return True
   }
}
Process,close,SQLiteStudio.exe
FileDelete, Digest.db*
connectionString := A_ScriptDir "\Digest.db"
DigestDB := DBA.DataBaseFactory.OpenDataBase("SQLite", connectionString)
DigestDB.Query("PRAGMA journal_mode=WAL;")
DigestDB.Query("PRAGMA synchronous = 0;")
;~ DigestDB.Query("PRAGMA page_size = 65536;")


;~ DigestDB.Query("PRAGMA journal_mode=OFF;")

;D2 mpq load order:
;~ d2data.mpq
;~ d2char.mpq
;~ d2sfx.mpq
;~ d2speech.mpq
;~ d2music.mpq
;~ d2video.mpq
;~ d2delta.mpq
;~ d2kfixup.mpq
;~ d2exp.mpq
;~ d2xvideo.mpq
;~ d2xtalk.mpq
;~ d2xmusic.mpq
;~ patch_d2.mpq
;~ ModPatch_d2.mpq
;~ D2SE_1.mpq
;~ D2SE_2.mpq
;~ D2SE_3.mpq
;~ direct_txt.mpq
;~ various stuff
OnExit, ExitRoutine

#MaxMem,4095 
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetBatchLines, -1
;~ ListLines, Off

SetWorkingDir, %A_ScriptDir%\..  ; Ensures a consistent starting directory.
DiabloIIDir = %a_WorkingDir%
d2_old_patches=d2data,d2char,d2sfx,d2speech,d2music,d2video,d2delta,d2kfixup,d2exp,d2xvideo,d2xtalk,d2xmusic
ModNameStripChars=\/:?*"<>|
Gui, XML: New, +MinSizex250
Gui, Add, Picture,w250 h60 center,DigestPicture
Gui, Add, Text, w250 BackgroundTrans center vText1,Stage -1
Gui, Add, Text, w250 BackgroundTrans center vText2,Compiling (listfile) from each MPQ...
Gui, Add, Text, w250 h50 BackgroundTrans center vText3,Please wait...
Gui, Show,autosize center,Digest Processor
goto,Stage0

;Build the MPQ listfile
FileRead,MasterListFile, %a_scriptdir%\ListFiles\MasterListFile.txt
FileDelete,%a_scriptdir%\ListFiles\listfile.mpq
Loop,Files,%DiabloIIDir%\*.mpq,R
{
	MPQ_Chain := []
	MPQ_Chain.push(A_LoopFileLongPath)
	MPQ_Extract(MPQ_Chain,"(listfile)",a_scriptdir "\Working\",0)
	GuiControl, ,  Text3,%A_LoopFileDir%\%A_LoopFileName%
	
	FileRead,listtemp, %A_ScriptDir%\Working\(listfile)
	MasterListFile .= listtemp
	FileDelete,%A_ScriptDir%\Working\(listfile)
	IfExist,%A_ScriptDir%\listfiles\zzzzz%A_NowUTC%.txt
		Sleep,1000
	FileMove,%A_ScriptDir%\Working\(listfile),%A_ScriptDir%\listfiles\zzzzz%A_NowUTC%.txt
}
GuiControl, , Text2,Compiling all listfiles into a master list...
GuiControl, , Text3,
Loop,Files,%a_scriptdir%\ListFiles\*.txt
{
	FileRead,listtemp,%a_loopfilelongpath%
	MasterListFile .= "`r`n" listtemp
}
listtemp=
GuiControl, , Text2,Appending raw file names to compiled list...
Loop,Files,%DiabloIIDir%\MODS\*,D
{
	ModFolder := A_LoopFileLongPath
	;~ ModBase := A_LoopFileName
			GuiControl, , Text3,Scanning: %A_LoopFileName%

	Loop,Files,%ModFolder%\*,R
	{
		StringReplace,RelName,a_loopfilelongpath,%ModFolder%`\
		MasterListFile .= relname "`r`n"
	}
}
GuiControl, , Text2,Finalizing compiled list...
GuiControl, , Text3,
Sort,MasterListFile,U D`n
	
	
	

FileDelete,%A_ScriptDir%\masterlisttemp.txt
FileAppend,%MasterListFile%,%A_ScriptDir%\masterlisttemp.txt
FileMove,%A_ScriptDir%\masterlisttemp.txt,%a_scriptdir%\ListFiles\MasterListFile.txt,1
MasterListFile=

Stage0:
;~ GoToMod=1.10f
;~ GoToMod=The Forces of Darkness
;~ GoToMod=Reign of Shadow
;~ GoToMod=Pagan Heart
;~ GoToMod=Aftermath
;~ GoToMod=Hell Unleashed
;~ GoToMod=Eastern Sun Rises
;~ GoToMod=Median XL
;~ GoToMod=Le Royaume des Ombres (beta)
;~ GoToMod=Zy-El [4.5]
GoToMod=Snej
;~ GoToMod=Battle for Elements
;~ GoToMod=Blackened
;Build the MPQ list

Loop,Files,%DiabloIIDir%\MODS\*,D
{
	StringCaseSense,on

	If a_loopfilename!=%gotomod%
		continue
	Digest := {}
	;~ VarSetCapacity(Digest)
	;~ VarSetCapacity(Digest,50000000)

	MPQ_Chain := []
	MPQ_New := []
	MPQ_Old := []
	FileGetAttrib, DirSearch, %A_LoopFileLongPath%
	IfInString,DirSearch,D
			MOD_DIR := a_loopfilename
	else
		continue
	IfNotExist,%DiabloIIDir%\MODS\%MOD_DIR%\D2SE_SETUP.ini
		continue
	
	
	RIni_Read(1,DiabloIIDir "\MODS\"  MOD_DIR "\D2SE_SETUP.ini")
	If RIni_KeyExists(1, "Protected", "D2Core")
		D2Core := RIni_GetKeyValue(1, "Protected", "D2Core")
	If RIni_KeyExists(1, "Protected", "ModName")
		ModName := RIni_GetKeyValue(1, "Protected", "ModName")
	If RIni_KeyExists(1, "Protected", "ModTitle")
		ModTitle := RIni_GetKeyValue(1, "Protected", "ModTitle")
	If RIni_KeyExists(1, "Protected", "ModMajorVersion")
		ModMajorVersion := RIni_GetKeyValue(1, "Protected", "ModMajorVersion")
	If RIni_KeyExists(1, "Protected", "ModMinorVersion")
		ModMinorVersion := RIni_GetKeyValue(1, "Protected", "ModMinorVersion")
	If RIni_KeyExists(1, "Protected", "ModRevision")
		ModRevision := RIni_GetKeyValue(1, "Protected", "ModRevision")
	If RIni_KeyExists(1, "Protected", "ModBanner")
		ModBanner := RIni_GetKeyValue(1, "Protected", "ModBanner")
	IfExist,%DiabloIIDir%\MODS\%MOD_DIR%\D2Mod.ini
		RIni_Read(2,DiabloIIDir "\MODS\"  MOD_DIR "\D2Mod.ini")
	StringReplace,D2CoreStripped,D2Core,`.,,all



	StringCaseSense,off

	Loop,parse,d2_old_patches,`,
	{
		IfExist,%DiabloIIDir%\%A_LoopField%.mpq
		{
			MPQ_Chain.push(DiabloIIDir "\" A_LoopField ".mpq")
			MPQ_Old.push(DiabloIIDir "\" A_LoopField ".mpq")
		}
	}
	;~ ;Load vanilla patch_d2
	
	


	If (ModName!=ModTitle) AND (ModTitle!="")
		ModFullName := EndingWhiteSpaceTrim(ModName) a_space "(" EndingWhiteSpaceTrim(EndingWhiteSpaceTrim(ModTitle) ")" a_space "[" EndingWhiteSpaceTrim(ModMajorVersion)   EndingWhiteSpaceTrim(ModMinorVersion)   EndingWhiteSpaceTrim(ModRevision)) "]"
	Else 
		ModFullName := EndingWhiteSpaceTrim(ModName)  a_space "[" EndingWhiteSpaceTrim(EndingWhiteSpaceTrim(ModMajorVersion)   EndingWhiteSpaceTrim(ModMinorVersion)   EndingWhiteSpaceTrim(ModRevision)) "]"
	Loop,parse,ModNameStripChars
		StringReplace,ModFullName,ModFullName,%a_loopfield%,,all
	GuiControl, ,DigestPicture,%DiabloIIDir%\MODS\%MOD_DIR%\%modbanner%
	GuiControl, , Text1,%ModFullName%
	GuiControl, , Text2,Stage 0
	GuiControl, , Text3,Building MPQ chains...
	Loop,10
		StringReplace,ModFullName,ModFullName,%a_space%%a_space%,%a_space%,All
	StringReplace,ModFullName,ModFullName,%a_space%.,.,All
	StringReplace,ModFullName,ModFullName,.%a_space%,.,All
	StringReplace,ModFullName,ModFullName,%a_space%-,-,All
	StringReplace,ModFullName,ModFullName,-%a_space%,-,All
	ModFullName := trim(ModFullName,a_space)
	
	
	;Conditional check to skip processing bins from this mod
	
	
	IfExist,%DiabloIIDir%\D2SE\CORES\%D2Core%\patch_d2.mpq
	{
		MPQ_Chain.push(DiabloIIDir "\D2SE\CORES\" D2Core "\patch_d2.mpq")
		MPQ_Old.push(DiabloIIDir "\D2SE\CORES\" D2Core "\patch_d2.mpq")
	}
	
	
	;Load Mod Patch_D2
	IniRead,ModUsePatch_D2,C:\Users\Qriist\Desktop\Diablo II\MODS\%MOD_DIR%\D2SE_SETUP.ini,Protected,ModUsePatch_D2
	If (ModUsePatch_D2 = 1) AND FileExist(DiabloIIDir "\MODS\"  MOD_DIR "\patch_d2.mpq")
	{
		MPQ_Chain.push(DiabloIIDir "\MODS\" MOD_DIR "\patch_d2.mpq")
		MPQ_New.push(DiabloIIDir "\MODS\" MOD_DIR "\patch_d2.mpq")
	}




	;Begin loading additional mpqs; 
	;TODO - condense the following
	{
		
		IniRead,ModMPQ1,C:\Users\Qriist\Desktop\Diablo II\MODS\%MOD_DIR%\D2SE_SETUP.ini,Protected,ModMPQ1
		IfExist,C:\Users\Qriist\Desktop\Diablo II\MODS\%MOD_DIR%\%ModMPQ1%
		{
			MPQ_Chain.push(DiabloIIDir "\MODS\" MOD_DIR "\" ModMPQ1)
			MPQ_New.push(DiabloIIDir "\MODS\" MOD_DIR "\" ModMPQ1)
		}

		IniRead,ModMPQ2,C:\Users\Qriist\Desktop\Diablo II\MODS\%MOD_DIR%\D2SE_SETUP.ini,Protected,ModMPQ2
		IfExist,C:\Users\Qriist\Desktop\Diablo II\MODS\%MOD_DIR%\%ModMPQ2%
		{
			MPQ_Chain.push(DiabloIIDir "\MODS\" MOD_DIR "\" ModMPQ2)
			MPQ_New.push(DiabloIIDir "\MODS\" MOD_DIR "\" ModMPQ2)
		}
		
		IniRead,ModMPQ3,C:\Users\Qriist\Desktop\Diablo II\MODS\%MOD_DIR%\D2SE_SETUP.ini,Protected,ModMPQ3
		IfExist,C:\Users\Qriist\Desktop\Diablo II\MODS\%MOD_DIR%\%ModMPQ3%
		{
			MPQ_Chain.push(DiabloIIDir "\MODS\" MOD_DIR "\" ModMPQ3)
			MPQ_New.push(DiabloIIDir "\MODS\" MOD_DIR "\" ModMPQ3)
		}
	}
	
	;Load D2Mod mpqs.
	IniRead,ModUseD2Mod,C:\Users\Qriist\Desktop\Diablo II\MODS\%MOD_DIR%\D2SE_SETUP.ini,Protected,ModUseD2Mod
	If (ModUseD2Mod = 1)
	{	
		If FileExist(DiabloIIDir "\MODS\"  MOD_DIR "\D2Mod.mpq")
		{
			MPQ_Chain.push(DiabloIIDir "\MODS\" MOD_DIR "\D2Mod.mpq")
			MPQ_New.push(DiabloIIDir "\MODS\" MOD_DIR "\D2Mod.mpq")
		}
		
		If FileExist(DiabloIIDir "\MODS\"  MOD_DIR "\D2ModPatch.mpq")
		{
			MPQ_Chain.push(DiabloIIDir "\MODS\" MOD_DIR "\D2ModPatch.mpq")
			MPQ_New.push(DiabloIIDir "\MODS\" MOD_DIR "\D2ModPatch.mpq")
		}
	}
	
	;Create temporary direct_txt.mpq for insertion into the mpq chain
	FileDelete,%a_scriptdir%\Working\direct_txt.mpq
	if FileExist(DiabloIIDir "\MODS\" MOD_DIR "\Data\" )
	{
		RunWait,%A_ScriptDir%\mpqeditor.exe new "%a_scriptdir%\Working\direct_txt.mpq" %direct_txt_count%
		RunWait,%A_ScriptDir%\mpqeditor.exe add "%a_scriptdir%\Working\direct_txt.mpq" "%DiabloIIDir%\MODS\%MOD_DIR%\Data\" "Data\" /auto /r
		MPQ_Chain.push( A_ScriptDir "\Working\direct_txt.mpq" )
		MPQ_New.push( A_ScriptDir "\Working\direct_txt.mpq" )
	}
	
	;Debug loop to ensure the mpq chain is in the correct order. This is LOAD order, and is served to MPQ_Extract like this.
	;~ Loop % mpq_chain.length()
		;~ msgbox % MPQ_Chain[a_index]
		;~ MsgBox % st_printarr(MPQ_Chain)
		;~ MsgBox % st_printarr(MPQ_New)
	;And in reverse. This is PRIORITY order. Not generally needed.
	;~ Loop % mpq_chain.length()
		;~ msgbox % MPQ_Chain[mpq_chain.length()+1-a_index]
	GuiControl, , Text1,%ModFullName%
	GuiControl, , Text2,Stage 1
	GuiControl, , Text3,Extracting Tbls...
	TblListArray := []
	TblListArray.push("string")
	TblListArray.push("patchstring")
	TblListArray.push("expansionstring")
	;Check for enabled D2Mod and enabled Nefex
	;TODO - check Nefex system structure - WHAT MODS USE THIS?
	;~ IfExist,%DiabloIIDir%\MODS\D2Mod.ini
		;~ RIni_Read(2,DiabloIIDir "\MODS\"  MOD_DIR "\D2Mod.ini")
	If  (RIni_GetKeyValue(1, "Protected", "ModUseD2Mod")=1) AND FileExist((DiabloIIDir "\MODS\"  MOD_DIR "\D2Mod.ini"))
	{
		CustomTbl := RIni_GetSectionKeys(2, "CustomTbl")
		Loop,parse,CustomTbl,`,
		{
			If RIni_GetKeyValue(2, "CustomTbl",a_loopfield)
			{
				TblToAdd := RIni_GetKeyValue(2, "CustomTbl",a_loopfield)
				SplitPath,tbltoadd,,,,TblBase
				TblListArray.push(TblBase)
			}
		}
	}
	
	;For now, only doing ENG. My sanity depends on it.
	;Need to gather list of languages to decompile
	;To do this:
	;A) extract *.tbl from mod MPQs only. (MPQ_new)
	;B) fill in any missing tbls from that language's full-chain locale
	;C) search later vanilla patch_d2's for missing tbls and cross your fingers that it works.
	;D) on the offchance that no suitable file is available, default to ENG*
	
	;*
	;*ENG crossreferencing is currently not implemented in order to actually do other stuff.
	
	
	;clean up any old data caused from early termination
	FileRemoveDir,%a_scriptdir%\tblConv\data\,1

	;A) Extract tables
	;EXTRACT
	MPQ_Extract(MPQ_new, "*\local\lng\*.tbl" ,a_scriptdir "\TblConv\",1,A_ScriptDir "\ListFiles\MasterListFile.txt",0) ; TESTING
	;~ MPQ_Extract(MPQ_new, "*\local\lng\ENG\*.tbl" ,a_scriptdir "\TblConv\",0,A_ScriptDir "\ListFiles\MasterListFile.txt",0)
	;~ Pause
	;~ RunWait,%a_scriptdir%\MPQEditor.exe extract "%a_loopfield%" *.tbl "%a_scriptdir%\TblConv" /fp,,hide
		;~ Pause

	;B) Determine present tbls, extract anything missing from full-chain
	;Process tables into the array IN THIS ORDER: 
	;		Check for D2mod.ini then load:
	;		string -> expansionstring -> patchstring -> 
	;		D2modIni_1 -> D2modIni_2 -> etc     // This should probably be a function using Rini to get potentially variable numbers of tbls.
	;		

	
	;TODO - implement adding tbls from the mod system inis.
	;D2 MOD complete
	;Nefex incomplete
	;Dark Alliance incomplete
	;~ msgbox % st_printarr(TblListArray)
	
	ModLngArray := []
	
	;Extract the tbls 
	IfNotExist,%a_scriptdir%\Working\%ModFullName%\TXT\tblscomplete
	{
		
		Loop,%a_scriptdir%\TblConv\data\Local\lng\*,1
		{
			;Loops through the languages, using the foldername as the current language
			Mod_LNG := StringUpper(a_LoopFileName)
			if mod_lng != eng
				continue
			GuiControl, , Text3,Converting tbls for language: %Mod_LNG%...
			ModLngArray.push(Mod_LNG)
			FileCreateDir,%a_scriptdir%\Working\%ModFullName%\%Mod_LNG%
			FileDelete,%a_scriptdir%\TblConv\*.tbl
			Loop,% TblListArray.length()
			{
				;Copy from current language, if possible
				If FileExist(a_scriptdir "\TblConv\data\local\lng\" mod_lng "\" TblListArray[a_index] ".tbl")
				{
					FileCopy, % a_scriptdir "\TblConv\data\local\lng\" mod_lng "\" TblListArray[a_index] ".tbl", % a_scriptdir "\TblConv\"
				}
				
				;If it still doesn't exist, extract from the full chain for this language
				else If !FileExist(a_scriptdir "\TblConv\" TblListArray[a_index] ".tbl")
				{
					MPQ_Extract(MPQ_chain,"*\local\lng\" Mod_LNG "\" TblListArray[a_index] ".tbl",a_scriptdir "\TblConv\",0,A_ScriptDir "\ListFiles\MasterListFile.txt",0)
				}				

				;If it still doesn't exist, copy from English
				else If !FileExist(a_scriptdir "\TblConv\" TblListArray[a_index] ".tbl")
				{
					FileCopy, % a_scriptdir "\TblConv\data\local\lng\ENG\" TblListArray[a_index] ".tbl", % a_scriptdir "\TblConv\"
				}
				
				;If it still doesn't exist, extract from the full chain for English
				else If !FileExist(a_scriptdir "\TblConv\" TblListArray[a_index] ".tbl")
				{
					MPQ_Extract(MPQ_chain,"*\local\lng\ENG\" TblListArray[a_index] ".tbl",a_scriptdir "\TblConv\",0,A_ScriptDir "\ListFiles\MasterListFile.txt",0)
				}
				
				;If it still doesn't exist, you broke it.
			}
			
			;~ msgbox % TblListArray.length()
			
			;~ ;Check for missing tables and conditionally extract the English versions 
			;~ ;Later, as each code is checked during txt generation:
				;~ ; A) Check that languange's code
				;~ ; B) If absent, check the English array
				;~ ; C) If not found in either location simply print the code.
			RunWait,%A_ScriptDir%\TblConv\ToTxt.exe
			FileCopy,%A_ScriptDir%\TblConv\*.txt,%A_ScriptDir%\Template\,1
			;~ ExitApp
			Tbloffset=0
			
			Loop, % TblListArray.length()
			{
				StringReplace,temp,% TblListArray[a_index],%a_space%,,All
				If FileExist(a_scriptdir "\TblConv\" temp ".txt")
				{
					CurrentTxt := FileOpen(A_ScriptDir "\TblConv\" temp ".txt","r").read()
					Loop,Parse,CurrentTxt,`n,`r
					{
						singlecode := StrSplit(A_LoopField,a_tab,a_space)
						if (Tbloffset = 10000) ;and (Tbloffset <= 20000)
						{
							;~ If (Digest[ModFullName,"String",Mod_LNG,"By Code",singlecode[1]] = "")
								Digest[ModFullName,"String",Mod_LNG,"By Code",singlecode[1]] := singlecode[2]
								;~ Digest[ModFullName,"String",Mod_LNG,"Code to Number",a_index-1+Tbloffset] := singlecode[1]
								;~ Digest[ModFullName,"String",Mod_LNG,"Number to Code",singlecode[1]] := a_index-1+Tbloffset
						}
						else
							If (Digest[ModFullName,"String",Mod_LNG,"By Code",singlecode[1]] = "")
							{
								Digest[ModFullName,"String",Mod_LNG,"By Code",singlecode[1]] := singlecode[2]
								;~ Digest[ModFullName,"String",Mod_LNG,"Code to Number",a_index-goto1+Tbloffset] := singlecode[1]
							}
						;~ Digest[ModFullName,"String",Mod_LNG,"Number to Code",singlecode[1]] := a_index-1+Tbloffset
						Digest[ModFullName,"String",Mod_LNG,"By Number",a_index-1+Tbloffset "C"] := singlecode[1]
						Digest[ModFullName,"String",Mod_LNG,"By Number",a_index-1+Tbloffset "R"] := singlecode[2]
					}
				}
				Tbloffset+=10000
			}
			;~ msgbox % Digest[ModFullName,"String",Mod_LNG,"By Code","r13"]
			;~ ExitApp
			;~ FileDelete,test.txt
			;~ FileAppend,% st_printarr(Digest[ModFullName,"String",Mod_LNG,"By Number"]),test.txt
			;~ FileAppend,% st_printarr(Digest),test.txt
			;~ run,test.txt
			;~ ExitApp
			;~ Loop,Parse,% TableCodesArray["*RAW",Mod_LNG],`n,`r
			;~ {
				;~ singlecode := StrSplit(A_LoopField,a_tab)
				;~ If TableCodesArray[Mod_LNG,singlecode[1]] = singlecode[2]
					;~ TempAppend .= singlecode[1] a_tab singlecode[2] "`r`n"
			;~ }
				
					
			;~ FileMove,%a_scriptdir%\TblConv\*.txt,%a_scriptdir%\template\,1
			;~ tempAppend := TableCodesArray["*RAW",Mod_LNG]
			
			;~ FileAppend,%tempappend%,%a_scriptdir%\template\string.txt
			;~ RunWait,%a_scriptdir%\bin2txt-h.exe -file sets,%a_scriptdir%\
			;~ RunWait,%a_scriptdir%\bin2txt.exe -file sets,%a_scriptdir%\
			;~ FileMove,%a_scriptdir%\txt\*.txt,%a_scriptdir%\Working\%ModFullName%\TXT\,1
			;~ FileDelete,%a_scriptdir%\template\*string.txt
			;~ FileDelete,%a_scriptdir%\Working\%ModFullName%\TXT\DigestString_%Mod_LNG%.txt
			;~ FileAppend,%tempappend%,%a_scriptdir%\Working\%ModFullName%\TXT\DigestString_%Mod_LNG%.txt
			;~ tempAppend :=
			;~ if mod_lng=eng
				;~ msgbox, check tbl
		}
		;~ FileAppend,,%a_scriptdir%\Working\%ModFullName%\TXT\tblscomplete
	}
	;~ else
	;~ {
		;~ ;TODO - rewrite this to accomodate previous json method.
		;~ Loop,%a_scriptdir%\Working\%ModFullName%\TXT\DigestString_*.txt
		;~ {
			;~ Mod_LNG := StrSplit(a_LoopFileName, "_")
			;~ Mod_LNG := StrSplit(Mod_LNG[2], ".")
			
			;~ Mod_LNG := StringUpper(Mod_LNG[1])
			;~ ModLngArray.push(Mod_LNG)
			;~ if mod_lng != eng
				;~ continue
			;~ GuiControl, , Text3,Reading previously converted tbls for language: %Mod_LNG%...
			;~ CurrentTxt := FileOpen(A_LoopFileLongPath,"r").read()
			;~ Loop,Parse,CurrentTxt,`n,`r
				;~ {
					;~ singlecode := StrSplit(A_LoopField,a_tab)
					;~ TableCodesArray[Mod_LNG,singlecode[1]] := singlecode[2]
				;~ }
		;~ }
	;~ }
		
		;~ msgbox % st_printarr(tbllistarray)
		
		
		FileDelete, %a_scriptdir%\bin\*
		FileDelete, %a_scriptdir%\txt\*
		GuiControl, , Text1,%ModFullName%
		GuiControl, , Text2,Stage 2
		GuiControl, , Text3,Extracting Bins...
		;~ MPQ_Extract(MPQ_list,FileMaskToExtractFromMPQ,PathToExtractToDisk,UseFullPathing:=1)
		IfNotExist,%a_scriptdir%\Working\%ModFullName%\TXT\binscomplete
		{
			;EXTRACT
			MPQ_Extract(MPQ_chain,"*Global\excel*.bin",A_ScriptDir "\bin\",0,A_ScriptDir "\ListFiles\MasterListFile.txt")
			GuiControl, , Text3,Decompiling Bins...
			
			
			BinOrder := []
			loop,%A_scriptdir%\bin\*.bin
			{
				SplitPath,a_loopfilename,,,,BinBase
				BinOrder.push(BinBase)
			}
			;~ module=cubemain
			;~ Digest_Bin_110f_cubemain(a_scriptdir "\bin\cubemain.bin")
			;~ array_gui(Digest)
			;~ ExitApp
			FileDelete,%A_ScriptDir%\_*lib_*.txt
			FileEncoding,CP0
			;~ FileDelete,%a_scriptdir%\Digest.db*
			;~ DigestDB := New SQLiteDB
			;~ DigestDB.OpenDB(A_ScriptDir "\Digest.db")
			

			;~ msgbox here
							;~ FileDelete,%a_scriptdir%\%ModFullName%.json

			Loop, % BinOrder.length()
			{
				Module := Binorder[a_index]
				;~ msgbox % Binorder[a_index]
				ModuleNum := a_index
				if module!=cubemain
					continue
				Digest_Function_Selector("Bin",Module,D2CoreStripped,a_scriptdir "\bin\" module ".bin")

				;~ Digest_Bin_110f_%Module%(a_scriptdir "\bin\" module ".bin")
				;~ FileAppend,% JSON.dump(digest),%a_scriptdir%\%ModFullName%.json
				;~ msgbox % JSON.dump(digest)
				ExitApp
				;~ Module := "Digest_Bin_110f_" Binorder[a_index]
				;~ %Module%(a_scriptdir "\bin\" module ".bin")
				
				;The following function is for quick testing of data output ONLY.
				;Will need to build output txt modules for each bin
				;~ FileDelete,%A_ScriptDir%\_*lib_%module%*.txt
				;~ if isfunc("Digest_Bin_110f_" Module)
				;~ {
					;~ pause
					;~ ObjCSV_Collection2CSV(Digest[ModFullName,"Decompile",Module], A_ScriptDir "\_lib_" module ".txt", 1,SheetHeaders(Module),0,0,a_tab)
					;~ ObjCSV_Collection2CSV(Digest[ModFullName,"Decompile",Module], A_ScriptDir "\_nhlib_" module ".txt", 1,,0,0,a_tab)
				;~ }
				;~ pause
				;~ If strlen(testlib) > 2
					;~ msgbox,check
					;~ FileAppend,% testlib,% A_ScriptDir "\lib_" module ".txt"
					;~ MsgBox % st_printarr(Digest[ModFullName,"Decompile"])
			}
			;~ Loop, % BinOrder.length()
			;~ {
				;~ Module := Binorder[a_index]
				;~ Digest_Txt_110f_%module%()
			;~ }
			/*
			Required pre-Recompile functions follow
			*/
			Determine_ISC_groups()
			
			
			
			/*
			End of pre-Recompile functions
			*/
			module=runes
			mod_lng=ENG
			;~ Digest_JSON_110f_runes()
			;~ st_printarr(digest[ModFullName,Decompile])
			
			;~ Digest_SQL_Flatten(Digest)
			;~ ExitApp
			;~ FileDelete,%A_ScriptDir%\%ModFullName%.json
			;~ JDump := st_printarr(Digest)
			;~ JDump := BuildJson(Digest)
			;~ JDump := JSON.dump(digest)
			;~ msgbox % strlen(JDump)

			;~ FileAppend,% JSON.dump(digest),%a_scriptdir%\%ModFullName%.json
			;~ ObjDump(A_ScriptDir "\" ModFullName ".json",Digest)
			;~ FileAppend, % st_printarr(digest),%a_scriptdir%\test.json
			;~ array_gui(Digest[ModFullName,"String"])
				;~ array_gui(Digest[ModFullName,"Recompile",Module])
				;~ ExitApp
			;~ msgbox % st_printarr(Digest[ModFullName,"Recompile",Module])
			;~ eol := st_printarr(Digest[ModFullName,"Recompile",Module])
			;~ Clipboard := st_printarr(Digest[ModFullName,"Keys"])
			;~ digest=
			;~ VarSetCapacity,Digest,0
			;~ Run,%a_scriptdir%\bin2txt-h.exe,%a_scriptdir%,, ;hide
			;~ run,%A_ScriptDir%\_temp_Digest_JSON_110f_runes.ahk,%A_ScriptDir%
			;~ runwait,%A_ScriptDir%\_temp_Digest_SQL_Flatten.ahk,%A_ScriptDir%
			;~ FileDelete,%a_scriptdir%\Digest.db
			;~ Digest_SQL_Flatten(Digest)
			ExitApp
			FileCreateDir,%a_scriptdir%\Working\%ModFullName%\TXT\
			RunWait,%A_ScriptDir%\template\template.exe,%A_ScriptDir%\template,hide
			
			
			
			If ErrorLevel != 0
			{
				Gui,Font,cRED
				GuiControl, , Text3,Deep analysis required, this will take a LONG time and output may not be accurate...
				Loop,Files,%a_scriptdir%\bin\*.bin
					bincount := %a_index%
				Loop,Files,%a_scriptdir%\bin\*.bin
				{
					GuiControl, , cRED Text3,Deep analysis required`, this will take a LONG time... (%a_index%/%bincount%)
					SplitPath,a_loopfilelongpath,BinName,BinDir,BinExt,BinBase,BinDrive
					RunWait,%a_scriptdir%\bin2txt-h.exe -file "%BinBase%",%A_ScriptDir%,hide
					If (FileSize(a_scriptdir "\txt\" BinBase ".txt")!=0) AND if (ErrorLevel=0)
					{
						FileMove,%a_scriptdir%\txt\%BinBase%.txt,%a_scriptdir%\txt\Qriist_%BinBase%.txt
					}
				}
				Loop,Files,%a_scriptdir%\txt\Qriist_*.txt
				{
					SplitPath,a_loopfilelongpath,TxtName,TxtDir,TxtExt,TxtBase,TxtDrive
					StringReplace,TxtBase,TxtBase,Qriist_
					FileMove,a_loopfilelongpath,%TxtDir%\%TxtBase%.txt
				}
			}
			;~ FileMove,%a_scriptdir%\txt\*.txt,%a_scriptdir%\Working\%ModFullName%\TXT,1
			FileAppend,binscomplete,%a_scriptdir%\Working\%ModFullName%\TXT\binscomplete
		}
	
	Gui,Font,
	
	
	
	;~ ExitApp
	
	
	
	
	D2Core=1.10f
	StringReplace,D2CoreStripped,D2Core,`.,,all
	;~ msgbox % D2CoreStripped
	
	;Begin populating txt files...
	GuiControl, , Text2,Stage 3
	Loop, % ModLngArray.length()
	{
		MOD_LNG := ModLngArray[a_index]
		if Mod_Lng!=eng
			continue
		GuiControl, , Text3,Gathering info for language: %Mod_LNG%... `nAlso extracting gfx as needed...`nParsing Armor, Weapons, Misc...
		JsonArray := []
		
		;Need to gather basic info about the items in the mod.
		Digest_Json_%D2CoreStripped%_weapons(A_ScriptDir "\Working\" Modfullname "\TXT\weapons.txt",JsonArray,TableCodesArray,A_ScriptDir "\Working\" Modfullname "\" Mod_LNG "\weapons.txt")
		Digest_Json_%D2CoreStripped%_armor(A_ScriptDir "\Working\" Modfullname "\TXT\armor.txt",JsonArray,TableCodesArray,A_ScriptDir "\Working\" Modfullname "\" Mod_LNG "\armor.txt")
		Digest_Json_%D2CoreStripped%_misc(A_ScriptDir "\Working\" Modfullname "\TXT\misc.txt",JsonArray,TableCodesArray,A_ScriptDir "\Working\" Modfullname "\" Mod_LNG "\misc.txt")
		Digest_Json_%D2CoreStripped%_gems(A_ScriptDir "\Working\" Modfullname "\TXT\gems.txt",JsonArray,TableCodesArray,A_ScriptDir "\Working\" Modfullname "\" Mod_LNG "\gems.txt")
		
		
		
		;;;Modules that just copy the text over
		;~ Digest_Txt_110f_arena()
		;~ Digest_Txt_110f_armtype()
		;~ Digest_Txt_110f_automap()
		;~ Digest_Txt_110f_belts
		;~ Digest_Txt_110f_bodylocs
		Digest_Txt_%D2CoreStripped%_experience(A_ScriptDir "\Working\" Modfullname "\TXT\experience.txt",JsonArray,TableCodesArray,A_ScriptDir "\Working\" Modfullname "\" Mod_LNG "\Experience.txt")



		
		
		;;;Modules with actual text transformations
		
		Digest_Txt_%D2CoreStripped%_runes(A_ScriptDir "\Working\" Modfullname "\TXT\runes.txt",JsonArray,TableCodesArray,A_ScriptDir "\Working\" Modfullname "\" Mod_LNG "\runes.txt")
		Digest_Txt_%D2CoreStripped%_uniqueitems(A_ScriptDir "\Working\" Modfullname "\TXT\uniqueitems.txt",JsonArray,TableCodesArray,A_ScriptDir "\Working\" Modfullname "\" Mod_LNG "\uniqueitems.txt")
		;~ Digest_Txt_110f_automagic
		
		
		
		
		;;;Modules that REQUIRE the given language's strings.
		Digest_Txt_110f_sets()

		
		
		
		
		;;;Not yet working
		;~ Digest_Txt_%D2CoreStripped%_itemtypes(A_ScriptDir "\Working\" Modfullname "\TXT\itemtypes.txt",MOD_LNG,TableCodesArray,A_ScriptDir "\Working\" Modfullname "\" Mod_LNG "\itemtypes.txt") ;not working yet
	}
	;~ Digest_Txt110f_itemtypes()

	;~ FileAppend,%arraycheck%,arraycheck.txt
	ExitApp
	;~ Loop,Parse,
	msgbox % st_printarr(TableCodesArray["*RAW"])
	{
	}
	
	
	
	
	;~ msgbox % st_printarr(MPQ_new)
	;Check only the patchfiles for tbls -> this determines the languages that are present.
	;~ msgbox % st_printarr(ModLngArray)
	;~ Loop % ModLngArray.length()
	;~ {
		;~ MPQ_Extract(MPQ_new,"*\local\lng\*" ModLngArray[a_index] "\*.tbl",a_scriptdir "\TblConv\",1,A_ScriptDir "\ListFiles\MasterListFile.txt",0)
	;~ }
	

		;~ ExitApp
		
		Loop,Parse,tbllist,`,
		{
			break
			;~ MsgBox % a_loopfield
			IfNotExist,%a_scriptdir%\TblConv\data\Local\lng\%Mod_LNG%\%A_LoopField%.tbl
			{
				MPQ_Extract(mpq_chain,"*" StringUpper(Mod_LNG) "\" A_LoopField ".tbl",A_ScriptDir "\TblConv\",1,A_ScriptDir "\ListFiles\MasterListFile.txt")
				
				;C) fallback on later vanilla updates
				IfNotExist,%a_scriptdir%\TblConv\data\Local\lng\%Mod_LNG%\%A_LoopField%.tbl
				{
					Loop,%DiabloIIDir%\D2SE\CORES\*.mpq,,1
					{
						MPQ_Extract(a_loopfilelongpath,"*" StringUpper(Mod_LNG) "\" A_LoopField ".tbl",A_ScriptDir "\TblConv\data\Local\lng\" Mod_LNG "\",0,A_ScriptDir "\ListFiles\MasterListFile.txt")
						IfExist,,%a_scriptdir%\TblConv\data\Local\lng\%Mod_LNG%\%A_LoopField%.tbl
							break
					}
				}
				;D) fallback on ENG tables
				IfNotExist,%a_scriptdir%\TblConv\data\Local\lng\%Mod_LNG%\%A_LoopField%.tbl
					MPQ_Extract(PriorityMPQLast,"*ENG\" A_LoopField ".tbl",A_ScriptDir "\TblConv\data\Local\lng\" Mod_LNG "\",0,A_ScriptDir "\ListFiles\MasterListFile.txt")
			}
			
		
		}
		FileDelete,%a_scriptdir%\TblConv\*.txt
		FileMove,%a_scriptdir%\TblConv\data\Local\lng\%Mod_LNG%\*.tbl, %A_ScriptDir%\TblConv\,1
		;Do a final check of any extracted tbl files from the mod folder itself (for the current language only)
		FileCopy,%DiabloIIDir%\MODS\%Mod_dir%\Data\local\LNG\%mod_lng%\*.tbl,%a_scriptdir%\TblConv\,1

		RunWait,%a_scriptdir%\TblConv\ToTxt.exe,%a_scriptdir%\TblConv\,hide
		FileDelete,%a_scriptdir%\TblConv\*.tbl
		FileMove,%a_scriptdir%\TblConv\patchstring.txt,%a_scriptdir%\Working\%ModFullName%\%Mod_LNG%\,1
		FileMove,%a_scriptdir%\TblConv\expansionstring.txt,%a_scriptdir%\Working\%ModFullName%\%Mod_LNG%\,1
		FileMove,%a_scriptdir%\TblConv\String.txt,%a_scriptdir%\Working\%ModFullName%\%Mod_LNG%\,1
	
	
	FileRemoveDir,%a_scriptdir%\TblConv\data,1


	

	bindir := StringUpper( a_scriptdir "\bin\" )
	;~ MPQ_Extract(PriorityMPQLast,"*global\excel\*.bin","" bindir "",0,A_ScriptDir "\ListFiles\MasterListFile.txt")
	FileCopy,%DiabloIIDir%\Mods\%ModFullName%\Data\global\excel\*.bin,%a_scriptdir%\bin\,1

	StringTrimRight,MOD_LNG_LIST,MOD_LNG_LIST,1
	StringSplit,MOD_LNG_NUMBER,MOD_LNG_LIST,|
	MsgBox % MOD_LNG_LIST
	GuiControl, , Text1,%ModFullName%
	GuiControl, , Text2,Stage 3
	GuiControl, , Text3,Decompiling bins...	
	
	FileDelete,%a_scriptdir%\template\patchstring.txt
	FileDelete,%a_scriptdir%\template\expansionstring.txt
	FileDelete,%a_scriptdir%\template\String.txt
	RunWait,%A_ScriptDir%\bin2txt-h.exe,%A_ScriptDir%
	If errorlevel != 0
	{
		Loop,%a_scriptdir%\bin\*.bin
		{
			SplitPath,a_loopfilelongpath,BinName,BinDir,BinExt,BinBase,BinDrive
			GuiControl, , Text1,%Mod_Dir% ... deep analysis ...
			GuiControl, , Text2,This will take a LONG time, results may not be accurate...
			GuiControl, , Text3,Decompiling %BinBase%...
			RunWait,%a_scriptdir%\bin2txt-h.exe -file %BinBase%,%a_scriptdir%
		}
	}
	;~ FileMove,%A_ScriptDir%\txt\*.txt,%a_scriptdir%\Working\%ModFullName%\TXT\,1
	IfNotExist,%a_scriptdir%\Working\%ModFullName%\binscomplete
		FileAppend,binscomplete,%a_scriptdir%\Working\%ModFullName%\binscomplete
	
	GuiControl, , Text1,%ModFullName%
	GuiControl, , Text2,Stage 4
	GuiControl, , Text3,Parsing tbls to create proper txts for each language
	Pause
	Loop,Parse,MOD_LNG_LIST,`|
	{
		GuiControl, , Text3,Parsing tbls to create proper txts for each language... ( Lang: %A_LoopField% -> #%a_index%/%MOD_LNG_NUMBER0% )
		StringUpper,MOD_LNG,a_loopfield
		msgbox % "check for" mod_lng
		;~ FileCreateDir,
		
	}
	
	d2_new_patches=
	MOD_LNG_LIST=
	ExitApp
}
ExitApp

















;~ StringReplace,cliptemp,PriorityMPQLast,`n,%a_space%,All
;~ StringReplace,Clipboard,cliptemp,%DiabloIIDir%,..,All
;~ msgbox % PriorityMPQLast
Loop,Parse,PriorityMPQLast,`n
{
	
	;~ SplitPath,PriorityMPQLast,MPQName,MPQDir,MPQExt,MPQBase,MPQDrive
	RunWait,%a_scriptdir%\MPQEditor.exe extract %a_loopfield% *.bin "%a_scriptdir%\bin\"  ;/listfile "%a_scriptdir%\ListFiles\MasterListFile.txt"
	;~ RunWait,%a_scriptdir%\MPQEditor.exe extract %a_loopfield% *.txt "%a_scriptdir%\Working\"  /fp 	;~ /listfile 
	If MPQBase in %d2_old_patches%
	{
		;~ MsgBox % MPQBase
		continue
	}
	RunWait,%a_scriptdir%\MPQEditor.exe extract %a_loopfield% *.tbl "%a_scriptdir%\TblConv\" /fp
	;~ MsgBox,%a_scriptdir%\MPQEditor.exe extract %a_loopfield% *.bin "%a_scriptdir%\bin\"  
	;~ ExitApp
}
GuiControl, , Text1,%ModFullName%
GuiControl, , Text2,
GuiControl, , Text3,Processing Tbl files...
RunWait,%A_ScriptDir%\TblConv\ToTxt.bat,%A_ScriptDir%\TblConv\
;~ ExitApp
FileDelete,%A_ScriptDir%\TblConv\*.tbl
FileMove,%A_ScriptDir%\TblConv\*.txt,%a_scriptdir%\txt\,1

GuiControl, , Text1,%ModFullName%
GuiControl, , Text2,
GuiControl, , Text3,Decompiling bins...
 
RunWait,%a_scriptdir%\bin2txt-h.exe,%a_scriptdir%


;~ RunWait,%a_scriptdir%\MPQEditor.exe /merged %MergedMPQ% extract patch_d2.mpq *.tbl "%a_scriptdir%\Working\" /fp
;~ RunWait,



;~ Loop,*.dc6,,1
;~ {
	;~ Total_Dc6 := A_Index
;~ }
;~ msgbox % Total_Dc6
ExitApp
Loop,*.dc6,,1
{
	CurrentImagePercent := a_index / Total_Dc6 * 100
	SplitPath,a_loopfilelongpath,ImageName,ImageDir,ImageExt,ImageBase
	ImageDirRelative =%ImageDir%
	StringReplace,ImageDirRelative,ImageDirRelative,%A_scriptdir%
	GuiControl, , Text1,%ImageDirRelative%\%ImageName% ;Scraping data for %SetName% [%SetCode%]...
	GuiControl, , Text3,%a_index% / %Total_Dc6% (%CurrentImagePercent%`%)
	;~ RunWait,%a_scriptdir%\dc6con.exe "%a_loopfilelongpath%",,hide
	;~ RunWait,C:\Users\Qriist\Desktop\Utilities\IrfanView\i_view64.exe "%ImageDir%\%ImageBase%.pcx" /convert="%ImageDir%\%ImageBase%.png" /silent
}
ExitApp


esc::
goto,ExitRoutine

ExitRoutine:
Process,close,MPQEditor.exe
run, C:\Users\Qriist\Desktop\Recom\Tools\SQLiteStudio\SQLiteStudio.exe
ExitApp

;temporary hosting of the txt module for testing


RecordKill(RecordArray,RecordsToKill,ValueToKill,DependantKill := "",KillLoopOffset := 0,SplitHere := "",Transformative := "",PassNull := "")
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
toBin(i, s = 0, c = 0) {
	l := StrLen(i := Abs(i + u := i < 0))
	Loop, % Abs(s) + !s * l << 2
		b := u ^ 1 & i // (1 << c++) . b
	Return, b
}
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
;complete
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
	return ;If not found, fail silently
}