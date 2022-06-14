#Include <class_EasyIni>
#Include <class_digest>
#Include <class_SQLiteDB>
#Include <functions>
#Include <string_things>
#Include <LibCrypt>
#Include <SingleRecordSQL>
#Include <class_consoleLogger>
#MaxMem 4096
#NoEnv
#Persistent
SendMode, Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetBatchLines,-1
FileEncoding UTF-8-RAW 

DigestIni := class_easyIni(a_scriptdir "\Digest.ini")
if (Digestini["Digest","Diablo II Dir"] = "")
{
	Digestini["Digest","Diablo II Dir"] := FileSelectFolder()
	DigestIni.save(a_scriptdir "\Digest.ini")
}

Digest := new class_digest
Digest.init(Digestini["Digest","Diablo II Dir"],DigestIni["Custom Tbl Load"],a_scriptdir "\Digest.db") ;clean temp folder, set base D2 dir, init db
Digest.scanForMods()
Digest.createMasterListFile()
Digest.decompileAllMods()