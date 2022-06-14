class class_consolelogger{
	static hConsoleOut := ""
	static stdin := ""
	static stdout := ""
	static logPath := ""
	static logHandle := ""
	register(logPath := "",logEncoding := "UTF-16"){
		DllCall("AllocConsole")
		,this.hConsoleOut := DllCall("GetStdHandle", "uint", -11, Ptr)
		,this.stdout := FileOpen("*", "w `n")
		,this.stdin := FileOpen("*","r `n")
		
		SplitPath,A_ScriptFullPath,ScriptName,ScriptDir,ScriptExt,ScriptBase,ScriptDrive
		if (logPath = "")
			logPath := a_scriptdir "\logs\" ScriptBase " [" A_NowUTC "]" ".txt"
		
		SplitPath,LogPath,LogName,LogDir,LogExt,LogBase,LogDrive
		FileCreateDir, % logDir
		,this.logpath := logpath	
		,this.logHandle := FileOpen(this.logpath,"a",logEncoding)	;opens in append mode to allow updating old log files
	}
	log(byref input){
		this.consoleLog(input)
		,this.fileLog(input)
	}
	SetWritingColor(Color := 0){
		return DllCall("SetConsoleTextAttribute", "uPtr", this.hConsoleOut, "UShort", color)
	}
	fileLog(byref input){
		this.logHandle.write("[" A_NowUTC "]" a_tab input "`n")
		;DllCall("FlushFileBuffers", "Ptr", this.logHandle.__Handle)	;slow
		,this.logHandle.__Handle	;fast
	}
	consoleLog(byref input){
		this.stdout.write(input "`n")
		,this.stdout.read(0)		
	}
	changeLogPath(byref newPath := "",logEncoding := "UTF-16"){
		if (newPath = ""){
			SplitPath,A_ScriptFullPath,ScriptName,ScriptDir,ScriptExt,ScriptBase,ScriptDrive
			newPath := a_scriptdir "\logs\" ScriptBase " [" A_NowUTC "]" ".txt"
		}
		
		SplitPath,newPath,LogName,LogDir,LogExt,LogBase,LogDrive
		FileCreateDir, % LogDir
		if InStr(FileExist(LogPath),"D"){
			this.logHandle.close()
			,this.logPath := newPath
			,this.logHandle := FileOpen(this.logpath,"a",logEncoding)
			return 1	;success	
		}
		return 0	;failure
	}
}

