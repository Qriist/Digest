#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetBatchLines, -1
#include <cjson>
#Include <singlerecordsql>
#include <functions>
#Include <string_things>

inputJson := FileOpen(A_Scriptdir "\outJson.json","r").read()
jsonArr := json.load(inputJson)

compileArr := []

;create the raw table SQL
For k,v in jsonArr {
    bin := k
;    msgbox % bin
    outTable := a_tab a_tab "CREATE TABLE [Decompile | " bin "] (`n"
        .   a_tab a_tab a_tab "[ModNum]" a_tab "INTEGER,`n"
        .   a_tab a_tab a_tab "[RecordID]" a_tab "INTEGER,`n"
    for k,v in v {
        version := k
        for k,v in jsonArr[bin,version,"Field Order"]{
            field := v
            if !jsonArr[bin,version,"Fields",field].HasKey("bitfield"){
                if InStr(outTable,a_tab "[" field "]")
                    Continue
                outTable .= a_tab a_tab a_tab "[" field "]" a_tab sqliteTypeMapping(jsonArr[bin,version,"Fields",field,"readType"],jsonArr[bin,version,"Fields",field,"readLength"]) (a_index=jsonArr[bin,version,"Field Order"].count()?"":",") "`n"
            } else {
                bitfieldArr := jsonArr[bin,version,"Fields",field,"bitfield"]
                for k,v in bitfieldArr{
                    bitfield := bitfieldArr[k,"name"]
                    visible := bitfieldArr[k,"visible"]
                    if InStr(outTable,a_tab "[" bitfield "]")
                        Continue
                    If !visible ;skip useless fields - these are usually named by me
                        Continue
                    outTable .= a_tab a_tab a_tab "[" bitfield "]" a_tab sqliteTypeMapping("int",1) ",`n"   ;unconditionally prepare for the next field
                }
                if (a_index = jsonArr[bin,version,"Field Order"].count())
                    outTable .= Trim(outTable, ",`n") "`n"  ;trim the comma off if a bitfield happens to be the last column of the table
            }
            
        }
    }
    outTable .= a_tab a_tab  "``);"   ;escaping the ) so the method builds correctly
    compileArr.push(outTable) 
}

;begin writing the AHK methods
autocompile := FileOpen(A_ScriptDir "\lib\digest\class_digest_initDB_autocompiled.ahk", "w")
for k,v in compileArr{
    out := a_tab "pushDB = `n"
    out .= a_tab "(`n"
    out .= v "`n"
    out .= a_tab ")`n"
    out .= a_tab "retObj.push(pushDB)`n`n"
    ;msgbox % out
    autocompile.write(out)
}
autocompile.Close()
;msgbox % outTable
ExitApp

sqliteTypeMapping(inputType,readLength){
    switch inputType {
        case "int","ReadUInt","ReadUShort","ReadUChar","ReadShort" : {
            return "INTEGER"
        }
        case "read" : {
            return "STRING (" readLength ")"
        }

        Default: {
            msgbox % "UNHANDLED TYPE: " inputType "`n" "readLength: " readLength "`n`nWILL EXIT"
            ExitApp
        }
    }
}