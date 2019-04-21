;complete
InsertQuick(dbConnection,dbTable,PassedArray,Flush := "",BatchSize := 4194304,dbCreationInstructions := "")
{
	;BatchSize & dbCreationInstructions currently unused...!
	
	;internal usage variables to track progress
	static CurrentConnection := "" 
	static CurrentTable := ""
	static CurrentTableList := {}
	static CurrentColumnList := {}
	static CurrentSQL := ""
	static WriteSQL := 0
	
	If (CurrentTable != dbTable)  ;ensures we are working on the same table
	{	
		InsertQuick(dbConnection,CurrentTable,CurrentColumnList,"flush")
		if (dbTable = "")
			return
		TableCheck := %dbConnection%.Query("SELECT name FROM sqlite_master WHERE type='table';") ; TO GET TABLES
		
		for k,v in TableCheck["Rows"] ;builds own internal list of tables
			CurrentTableList[TableCheck["Rows",a_index,"_fields",1]] := 1 ; no need to check anything right now
		
		If !(CurrentTableList.HasKey(dbTable)) ;if the table doesn't exist, add it.
		{
			SQLt := "CREATE TABLE IF NOT EXISTS " sqlQuote(dbTable) " (`n"
			
			For k,v in PassedArray
			{
				SQLc .= sqlQuote(k) ",`n"
				CurrentColumnList[k] := 1 ;adds this key
			}
			
			If (SQLc != "")
				SQLt .= Trim(SQLc,",`n") "`n"
			else
				SQLt .= "TableIndex integer PRIMARY KEY AUTOINCREMENT`n"
			
			/*
				TODO - pass special table instructions
			*/
			SQLt .= ");"
			;clipboard := SQLt
			if (WriteSQL = 1)
				FileAppend, % Trim(sqlt, "`n") "`n", % A_ScriptDir "\sql\" StrReplace(dbTable,"|") " 1.txt"
			%dbConnection%.query(sqlt)
			CurrentTableList[dbtable] := 1
			
		}
		CurrentTable := dbTable
	}
	
	If (Flush = "flush") OR (Flush = "dump") ;AND (CurrentTable != "") ;resets intended SQL. Flush resets everything, dump keeps the table+keys
	{
		if (CurrentSQL != "")
		{
			For k,v in CurrentColumnList
			{
				SQLh .= sqlQuote(k) ","
			}
			SQLh := "INSERT OR IGNORE INTO " sqlQuote(CurrentTable) "(" RTrim(SQLh,",`n") ") VALUES`n"	
			if (WriteSQL = 1)
				FileAppend, % Trim(sqlh, "`n") "`n" RTrim(CurrentSQL,",`n") ";" "`n", % A_ScriptDir "\sql\" StrReplace(dbTable,"|") " 2.txt"
			;%dbConnection%.query("BEGIN TRANSACTION;`n" SQLh RTrim(CurrentSQL,",`n") ";" "`nCOMMIT;")
			%dbConnection%.query(SQLh RTrim(CurrentSQL,",`n") ";")
			
		}
		CurrentSQL := ""
		If (Flush = "flush")
		{
			CurrentTable := ""
			CurrentColumnList := {}
			CurrentTableList := {}
		}
		return
	}
	
	
	For k,v in PassedArray ;prescan to check for keys
	{
		If !(CurrentColumnList.HasKey(k)) ;checks that this list contains this key name - ensures we can insert properly
		{
			InsertQuick(dbConnection,dbTable,PassedArray,"dump") ;dumps statically held SQL before this instance
			/*
				Validation...!
				Check for the existance of this column
				1: Consult the static CurrentColumnList
				2: On fail to find, consult the CurrentTable's  pragma
				a: on success, add it to CurrentColumnList
				3: On fail to find, create the column and add it to the CurrentColumnList
			*/
			ColumnCheck := %dbConnection%.Query("SELECT * FROM " sqlQuote(dbTable) " WHERE " sqlQuote(k) " IS NULL;")
			;msgbox % dbtable "`n" st_printarr(ColumnCheck)
			;If !IsObject(ColumnCheck)
			if (WriteSQL = 1)
				FileAppend, % Trim("ALTER TABLE " sqlQuote(dbTable) " ADD COLUMN " sqlQuote(k) ";") "`n", % A_ScriptDir "\sql\" StrReplace(dbTable,"|") " 2.txt"
			%dbConnection%.query("ALTER TABLE " sqlQuote(dbTable) " ADD COLUMN " sqlQuote(k) ";")
			CurrentColumnList[k] := 1 ;adds this key
			InsertQuick(dbConnection,CurrentTable,PassedArray) ;launch a new instance with this new key
			return ;the work was done at a deeper level, so exit this instance
		}
	}
	For k,v in CurrentColumnList
	{
		ValueList .= sqlQuote(PassedArray[k]) ","
	}
	CurrentSQL .= "(" RTrim(ValueList,",") "),`n"
	;If (StrLen(CurrentSQL) >= 40960) ;BatchSize) ;larger batchsizes do not work at this time...!
	If (StrLen(CurrentSQL) >= BatchSize)
	{
		InsertQuick(dbConnection,dbTable,PassedArray,"dump")
	}
}

sqlQuote(value) { ;escapes the strings and corrects NULL values
	Return v:=(value != "") ? "'" StrReplace(value, "'", "''") "'" 
		: "NULL"
}

IQF() { ;InsertQuickFlush ... use as PassedArray for your final write to disk.
	static IQF := {} ;just an empty object. Really.
	return IQF ; jazz hands
}

getSql(table, records)
{
	; Get a list of all keys
	keys := {}
	for i, record in records
		for k, v in record
			keys[k] := 1
	
	; Convert key names into SQL
	for k in keys
		cols .= "," sqlQuote(k)
	cols := SubStr(cols, 2)
	
	; Convert records into SQL
	for i, record in records
	{
		fields := ""
		for k in keys ; Loop over 'keys' not 'record' to ensure consistent column order
			fields .= "," (record.HasKey(k) ? sqlQuote(record[k]) : "NULL")
		values .= ",`n(" SubStr(fields, 2) ")"
	}
	values := SubStr(values, 2)
	
	return Format("INSERT OR IGNORE INTO {} ({}) VALUES {}", sqlQuote(table), cols, values) ";"
}