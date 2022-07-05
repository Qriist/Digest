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

for k,v in jsonArr{
    bin := k
    out := "decompile_" bin "(ModID,coreVersion,binToDecompile){`n"
    indent := indentCode(1)
    out .= indent "Switch coreVersion {`n"
    for k,v in jsonArr[bin]{
        coreVersion := k
        indent := indentCode(2)
        out .= indent "case " chr(34) coreVersion chr(34) ":{`n"
        indent := indentCode(3)
        out .= indent "this.DigestDB.exec(" chr(34) "BEGIN TRANSACTION;" chr(34) ")`n"
        out .= indent "this.DigestDB.exec(" chr(34) "DELETE FROM [Decompile | " bin "] WHERE ModID = " chr(34) " ModID " chr(34) ";" chr(34) ")`n"
        out .= indent "bin := FileOpen(binToDecompile," chr(34) "r" chr(34) ")`n"
        out .= indent "bin.seek(4)`n"  ;gets past the bin header
        out .= indent "RecordSize := " jsonArr[bin,coreVersion,"Record Length"] "`n"
        out .= indent "loop, % (Bin.Length  - 4) / RecordSize {`n"
        indent := indentCode(4)
        out .= indent "RecordID := a_index`n"
        out .= indent "Record := this.binArr[" chr(34) "Decompile" chr(34) "," bin ",RecordID] := {}`n"
        out .= indent "Record[" chr(34) "ModID" chr(34) "] := " ModID "`n"
        out .= indent "Record[" chr(34) "RecordID" chr(34) "] := RecordID`n"
        for k,v in jsonArr[bin,coreVersion,"Field Order"]{
            field := v
            fieldArr := jsonArr[bin,coreVersion,"Fields",field]
            If !fieldArr.HasKey("bitfield"){
                If !(fieldArr["readType"] = "read")
                    out .= indent "Record[" chr(34) field chr(34) "] := bin." fieldArr["readType"] "(" (fieldArr["readType"]="read"?fieldArr["readLength"]:"") ")`n"
                Else
                    out .= indent "Record[" chr(34) field chr(34) "] := Trim(bin." fieldArr["readType"] "(" (fieldArr["readType"]="read"?fieldArr["readLength"]:"") "))`n"
            } else {
                out .= indent "flagRead := bin."  fieldArr["readType"] "()`n"
                for k,v in fieldArr["bitfield"]{
                    If v["visible"]
                        out .= indent "Record[" chr(34) v["name"] chr(34) "] := (flagRead >> " a_index ")`n"
                }
            }
        }
        If jsonArr[bin,coreVersion].HasKey("RecordKill")
        out .= jsonArr[bin,coreVersion,"RecordKill"] "`n"
        ;TODO - RecordKill stuff
        out .= indent "this.DigestDB.exec(SingleRecordSQL(" chr(34) "Decompile | " bin chr(34) ",Record))`n"
        indent := indentCode(3)
        out .= indent "}`n"
        out .= indent "this.DigestDB.exec(" chr(34) "COMMIT;" chr(34) ")`n"
        indent := indentCode(2)
        out .= indent "}`n"
    }
    out .= indent "Default:{`n"
    indent := indentCode(3)
    out .= indent "return 0`n"
    indent := indentCode(2)
    out .= indent "}`n"
    indent := indentCode(1)
    out .= indent "}`n"
    out .= "}`n"
    ;msgbox % clipboard := out
}


indentCode(num){
    loop, % num
        ret .= a_tab
    return ret
}