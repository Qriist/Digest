#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Include SheetHeaders.ahk
FileEncoding,UTF-8-RAW
BinSets := FileOpen("sets.bin","r")

ModArray := []

Modname=mxl
mod_lng=ENG
ModArray[Modname,mod_lng,"Sets","Count"] := BinSets.readUShort() 
BinSets.readUShort() ;padding

NewTxt := Digest_Header_110f_Sets() "`r`n"
Loop,
{
	ModArray[Modname,mod_lng,"Sets",a_index,"Set ID"] := BinSets.readUShort()  ;~ WORD wSetId;                  //0x00
	ModArray[Modname,mod_lng,"Sets",a_index,"Set Tbl Index"] := BinSets.readUShort()  ;~ WORD wTblIndex;                  //0x02
	
	;Set the following 2 array items for easy lookup.
	;~ ModArray[Modname,mod_lng,"Sets by Number/String",ModArray[Modname,mod_lng,"Sets",a_index,"Set ID"]] := *set string code*
	;~ ModArray[Modname,mod_lng,"Sets by Number/Name",ModArray[Modname,mod_lng,"Sets",a_index,"Set ID"]] := *resolved set name*
	
	
	ModArray[Modname,mod_lng,"Sets",a_index,"Version"] := BinSets.ReadUInt()  	 ;~ DWORD dwVersion;               //0x04
	BinSets.ReadUInt()   ;~ DWORD unk0x08;                  //0x08 ; unused, advance
	ModArray[Modname,mod_lng,"Sets",a_index,"dwSetItems"] := BinSets.ReadUInt()    ;~ DWORD dwSetItems;               //0x0C'
	
	NewTxt .= ModArray[Modname,mod_lng,"Sets",a_index,"Set ID"] A_Tab
	NewTxt .= ModArray[Modname,mod_lng,"Sets",a_index,"Set Tbl Index"] A_Tab
	NewTxt .= ModArray[Modname,mod_lng,"Sets",a_index,"Version"] a_tab
	NewTxt .= ModArray[Modname,mod_lng,"Sets",a_index,"dwSetItems"] A_Tab
	
	
	ModArray[Modname,mod_lng,"Sets",a_index,"dwPCode2a"] := BinSets.ReadUInt()    ;~ DWORD dwPCode2a;               //0x10
	ModArray[Modname,mod_lng,"Sets",a_index,"dwPPar2a"] := BinSets.ReadUInt()    ;~ DWORD dwPPar2a;                  //0x14
	ModArray[Modname,mod_lng,"Sets",a_index,"dwPMin2a"] := BinSets.ReadUInt()    ;~ DWORD dwPMin2a;                  //0x18
	ModArray[Modname,mod_lng,"Sets",a_index,"dwPMax2a"] := BinSets.ReadUInt()    ;~ DWORD dwPMax2a;                  //0x1C
	If (ModArray[Modname,mod_lng,"Sets",a_index,"dwPPar2a"]!=0) OR (ModArray[Modname,mod_lng,"Sets",a_index,"dwPMin2a"]!=0) OR (ModArray[Modname,mod_lng,"Sets",a_index,"dwPMax2a"]!=0)
	{
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwPCode2a"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwPPar2a"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwPMin2a"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwPMax2a"],uint) a_tab
	}
	else
		loop,4
			NewTxt .= a_tab


	ModArray[Modname,mod_lng,"Sets",a_index,"dwPCode2b"] := BinSets.ReadUInt()    ;~ DWORD dwPCode2b;               //0x20
	ModArray[Modname,mod_lng,"Sets",a_index,"dwPPar2b"] := BinSets.ReadUInt()    ;~ DWORD dwPPar2b;                  //0x24
	ModArray[Modname,mod_lng,"Sets",a_index,"dwPMin2b"] := BinSets.ReadUInt()    ;~ DWORD dwPMin2b;                  //0x28
	ModArray[Modname,mod_lng,"Sets",a_index,"dwPMax2b"] := BinSets.ReadUInt()    ;~ DWORD dwPMax2b;                  //0x2C
	If (ModArray[Modname,mod_lng,"Sets",a_index,"dwPPar2b"]!=0) OR (ModArray[Modname,mod_lng,"Sets",a_index,"dwPMin2b"]!=0) OR (ModArray[Modname,mod_lng,"Sets",a_index,"dwPMax2b"]!=0)
	{
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwPCode2b"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwPPar2b"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwPMin2b"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwPMax2b"],uint) a_tab
	}
	else
		loop,4
			NewTxt .= a_tab
		
	ModArray[Modname,mod_lng,"Sets",a_index,"dwPCode3a"] := BinSets.ReadUInt()    ;~ DWORD dwPCode3a;               //0x30
	ModArray[Modname,mod_lng,"Sets",a_index,"dwPPar3a"] := BinSets.ReadUInt()    ;~ DWORD dwPPar3a;                  //0x34
	ModArray[Modname,mod_lng,"Sets",a_index,"dwPMin3a"] := BinSets.ReadUInt()    ;~ DWORD dwPMin3a;                  //0x38
	ModArray[Modname,mod_lng,"Sets",a_index,"dwPMax3a"] := BinSets.ReadUInt()    ;~ DWORD dwPMax3a;                  //0x3C
	If (ModArray[Modname,mod_lng,"Sets",a_index,"dwPPar3a"]!=0) OR (ModArray[Modname,mod_lng,"Sets",a_index,"dwPMin3a"]!=0) OR (ModArray[Modname,mod_lng,"Sets",a_index,"dwPMax3a"]!=0)
	{
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwPCode3a"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwPPar3a"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwPMin3a"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwPMax3a"],uint) a_tab
	}
	else
		loop,4
			NewTxt .= a_tab

	
	
	ModArray[Modname,mod_lng,"Sets",a_index,"dwPCode3b"] := BinSets.ReadUInt()    ;~ DWORD dwPCode3b;               //0x40
	ModArray[Modname,mod_lng,"Sets",a_index,"dwPPar3b"] := BinSets.ReadUInt()    ;~ DWORD dwPPar3b;                  //0x44
	ModArray[Modname,mod_lng,"Sets",a_index,"dwPMin3b"] := BinSets.ReadUInt()    ;~ DWORD dwPMin3b;                  //0x48
	ModArray[Modname,mod_lng,"Sets",a_index,"dwPMax3b"] := BinSets.ReadUInt()    ;~ DWORD dwPMax3b;                  //0x4C
	If (ModArray[Modname,mod_lng,"Sets",a_index,"dwPPar3b"]!=0) OR (ModArray[Modname,mod_lng,"Sets",a_index,"dwPMin3b"]!=0) OR (ModArray[Modname,mod_lng,"Sets",a_index,"dwPMax3b"]!=0)
	{
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwPCode3b"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwPPar3b"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwPMin3b"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwPMax3b"],uint) a_tab
	}
	else
		loop,4
			NewTxt .= a_tab
	ModArray[Modname,mod_lng,"Sets",a_index,"dwPCode4a"] := BinSets.ReadUInt()    ;~ DWORD dwPCode4a;               //0x50
	ModArray[Modname,mod_lng,"Sets",a_index,"dwPPar4a"] := BinSets.ReadUInt()    ;~ DWORD dwPPar4a;                  //0x54
	ModArray[Modname,mod_lng,"Sets",a_index,"dwPMin4a"] := BinSets.ReadUInt()    ;~ DWORD dwPMin4a;                  //0x58
	ModArray[Modname,mod_lng,"Sets",a_index,"dwPMax4a"] := BinSets.ReadUInt()    ;~ DWORD dwPMax4a;                  //0x5C
	If (ModArray[Modname,mod_lng,"Sets",a_index,"dwPPar4a"]!=0) OR (ModArray[Modname,mod_lng,"Sets",a_index,"dwPMin4a"]!=0) OR (ModArray[Modname,mod_lng,"Sets",a_index,"dwPMax4a"]!=0)
	{
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwPCode4a"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwPPar4a"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwPMin4a"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwPMax4a"],uint) a_tab
	}
	else
	loop,4
			NewTxt .= a_tab
	ModArray[Modname,mod_lng,"Sets",a_index,"dwPCode4b"] := BinSets.ReadUInt()    ;~ DWORD dwPCode4b;               //0x60
	ModArray[Modname,mod_lng,"Sets",a_index,"dwPPar4b"] := BinSets.ReadUInt()    ;~ DWORD dwPPar4b;                  //0x64
	ModArray[Modname,mod_lng,"Sets",a_index,"dwPMin4b"] := BinSets.ReadUInt()    ;~ DWORD dwPMin4b;                  //0x68
	ModArray[Modname,mod_lng,"Sets",a_index,"dwPMax4b"] := BinSets.ReadUInt()    ;~ DWORD dwPMax4b;                  //0x6C
		If (ModArray[Modname,mod_lng,"Sets",a_index,"dwPPar4b"]!=0) OR (ModArray[Modname,mod_lng,"Sets",a_index,"dwPMin4b"]!=0) OR (ModArray[Modname,mod_lng,"Sets",a_index,"dwPMax4b"]!=0)
	{
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwPCode4b"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwPPar4b"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwPMin4b"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwPMax4b"],uint) a_tab
	}
	else
	loop,4
			NewTxt .= a_tab
	ModArray[Modname,mod_lng,"Sets",a_index,"dwPCode5a"] := BinSets.ReadUInt()    ;~ DWORD dwPCode5a;               //0x70
	ModArray[Modname,mod_lng,"Sets",a_index,"dwPPar5a"] := BinSets.ReadUInt()    ;~ DWORD dwPPar5a;                  //0x74
	ModArray[Modname,mod_lng,"Sets",a_index,"dwPMin5a"] := BinSets.ReadUInt()    ;~ DWORD dwPMin5a;                  //0x78
	ModArray[Modname,mod_lng,"Sets",a_index,"dwPMax5a"] := BinSets.ReadUInt()    ;~ DWORD dwPMax5a;                  //0x7C
		If (ModArray[Modname,mod_lng,"Sets",a_index,"dwPPar5a"]!=0) OR (ModArray[Modname,mod_lng,"Sets",a_index,"dwPMin5a"]!=0) OR (ModArray[Modname,mod_lng,"Sets",a_index,"dwPMax5a"]!=0)
	{
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwPCode5a"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwPPar5a"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwPMin5a"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwPMax5a"],uint) a_tab
	}
	else
	loop,4
			NewTxt .= a_tab
	ModArray[Modname,mod_lng,"Sets",a_index,"dwPCode5b"] := BinSets.ReadUInt()    ;~ DWORD dwPCode5b;               //0x80
	ModArray[Modname,mod_lng,"Sets",a_index,"dwPPar5b"] := BinSets.ReadUInt()    ;~ DWORD dwPPar5b;                  //0x84
	ModArray[Modname,mod_lng,"Sets",a_index,"dwPMin5b"] := BinSets.ReadUInt()    ;~ DWORD dwPMin5b;                  //0x88
	ModArray[Modname,mod_lng,"Sets",a_index,"dwPMax5b"] := BinSets.ReadUInt()    ;~ DWORD dwPMax5b;                  //0x8C
		If (ModArray[Modname,mod_lng,"Sets",a_index,"dwPPar5b"]!=0) OR (ModArray[Modname,mod_lng,"Sets",a_index,"dwPMin5b"]!=0) OR (ModArray[Modname,mod_lng,"Sets",a_index,"dwPMax5b"]!=0)
	{
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwPCode5b"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwPPar5b"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwPMin5b"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwPMax5b"],uint) a_tab
	}
	else
	loop,4
			NewTxt .= a_tab
	ModArray[Modname,mod_lng,"Sets",a_index,"dwFCode1"] := BinSets.ReadUInt()    ;~ DWORD dwFCode1;                  //0x90
	ModArray[Modname,mod_lng,"Sets",a_index,"dwFPar1"] := BinSets.ReadUInt()    ;~ DWORD dwFPar1;                  //0x94
	ModArray[Modname,mod_lng,"Sets",a_index,"dwFMin1"] := BinSets.ReadUInt()    ;~ DWORD dwFMin1;                  //0x98
	ModArray[Modname,mod_lng,"Sets",a_index,"dwFMax1"] := BinSets.ReadUInt()    ;~ DWORD dwFMax1;                  //0x9C
	If (ModArray[Modname,mod_lng,"Sets",a_index,"dwFPar1"]!=0) OR (ModArray[Modname,mod_lng,"Sets",a_index,"dwFMin1"]!=0) OR (ModArray[Modname,mod_lng,"Sets",a_index,"dwFMax1"]!=0)
	{
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwFCode1"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwFPar1"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwFMin1"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwFMax1"],uint) a_tab
	}
	else
		loop,4
			NewTxt .= a_tab
	
	ModArray[Modname,mod_lng,"Sets",a_index,"dwFCode2"] := BinSets.ReadUInt()    ;~ DWORD dwFCode2;                  //0xA0
	ModArray[Modname,mod_lng,"Sets",a_index,"dwFPar2"] := BinSets.ReadUInt()    ;~ DWORD dwFPar2;                  //0xA4
	ModArray[Modname,mod_lng,"Sets",a_index,"dwFMin2"] := BinSets.ReadUInt()    ;~ DWORD dwFMin2;                  //0xA8
	ModArray[Modname,mod_lng,"Sets",a_index,"dwFMax2"] := BinSets.ReadUInt()    ;~ DWORD dwFMax2;                  //0xAC
	If (ModArray[Modname,mod_lng,"Sets",a_index,"dwFPar2"]!=0) OR (ModArray[Modname,mod_lng,"Sets",a_index,"dwFMin2"]!=0) OR (ModArray[Modname,mod_lng,"Sets",a_index,"dwFMax2"]!=0)
	{
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwFCode2"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwFPar2"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwFMin2"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwFMax2"],uint) a_tab
	}
	else
		loop,4
			NewTxt .= a_tab
			;~ Clipboard := NewTxt
	
	
	ModArray[Modname,mod_lng,"Sets",a_index,"dwFCode3"] := BinSets.ReadUInt()    ;~ DWORD dwFCode3;                  //0xB0
	ModArray[Modname,mod_lng,"Sets",a_index,"dwFPar3"] := BinSets.ReadUInt()    ;~ DWORD dwFPar3;                  //0xB4
	ModArray[Modname,mod_lng,"Sets",a_index,"dwFMin3"] := BinSets.ReadUInt()    ;~ DWORD dwFMin3;                  //0xB8
	ModArray[Modname,mod_lng,"Sets",a_index,"dwFMax3"] := BinSets.ReadUInt()    ;~ DWORD dwFMax3;                  //0xBC
	If (ModArray[Modname,mod_lng,"Sets",a_index,"dwFPar3"]!=0) OR (ModArray[Modname,mod_lng,"Sets",a_index,"dwFMin3"]!=0) OR (ModArray[Modname,mod_lng,"Sets",a_index,"dwFMax3"]!=0)
	{
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwFCode3"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwFPar3"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwFMin3"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwFMax3"],uint) a_tab
	}
	else
		loop,4
			NewTxt .= a_tab
			;~ Clipboard := NewTxt
	
	
	
	ModArray[Modname,mod_lng,"Sets",a_index,"dwFCode4"] := BinSets.ReadUInt()    ;~ DWORD dwFCode4;                  //0xC0
	ModArray[Modname,mod_lng,"Sets",a_index,"dwFPar4"] := BinSets.ReadUInt()    ;~ DWORD dwFPar4;                  //0xC4
	ModArray[Modname,mod_lng,"Sets",a_index,"dwFMin4"] := BinSets.ReadUInt()    ;~ DWORD dwFMin4;                  //0xC8
	ModArray[Modname,mod_lng,"Sets",a_index,"dwFMax4"] := BinSets.ReadUInt()    ;~ DWORD dwFMax4;                  //0xCC
	If (ModArray[Modname,mod_lng,"Sets",a_index,"dwFPar4"]!=0) OR (ModArray[Modname,mod_lng,"Sets",a_index,"dwFMin4"]!=0) OR (ModArray[Modname,mod_lng,"Sets",a_index,"dwFMax4"]!=0)
	{
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwFCode4"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwFPar4"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwFMin4"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwFMax4"],uint) a_tab
	}
	else
		loop,4
			NewTxt .= a_tab
			;~ Clipboard := NewTxt
	
	
	
	ModArray[Modname,mod_lng,"Sets",a_index,"dwFCode5"] := BinSets.ReadUInt()    ;~ DWORD dwFCode5;                  //0xD0
	ModArray[Modname,mod_lng,"Sets",a_index,"dwFPar5"] := BinSets.ReadUInt()    ;~ DWORD dwFPar5;                  //0xD4
	ModArray[Modname,mod_lng,"Sets",a_index,"dwFMin5"] := BinSets.ReadUInt()    ;~ DWORD dwFMin5;                  //0xD8
	ModArray[Modname,mod_lng,"Sets",a_index,"dwFMax5"] := BinSets.ReadUInt()    ;~ DWORD dwFMax5;                  //0xDC
	If (ModArray[Modname,mod_lng,"Sets",a_index,"dwFPar5"]!=0) OR (ModArray[Modname,mod_lng,"Sets",a_index,"dwFMin5"]!=0) OR (ModArray[Modname,mod_lng,"Sets",a_index,"dwFMax5"]!=0)
	{
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwFCode5"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwFPar5"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwFMin5"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwFMax5"],uint) a_tab
	}
	else
		loop,4
			NewTxt .= a_tab
			;~ Clipboard := NewTxt
	
	
	
	ModArray[Modname,mod_lng,"Sets",a_index,"dwFCode6"] := BinSets.ReadUInt()    ;~ DWORD dwFCode6;                  //0xE0
	ModArray[Modname,mod_lng,"Sets",a_index,"dwFPar6"] := BinSets.ReadUInt()    ;~ DWORD dwFPar6;                  //0xE4
	ModArray[Modname,mod_lng,"Sets",a_index,"dwFMin6"] := BinSets.ReadUInt()    ;~ DWORD dwFMin6;                  //0xE8
	ModArray[Modname,mod_lng,"Sets",a_index,"dwFMax6"] := BinSets.ReadUInt()    ;~ DWORD dwFMax6;                  //0xEC
	If (ModArray[Modname,mod_lng,"Sets",a_index,"dwFPar6"]!=0) OR (ModArray[Modname,mod_lng,"Sets",a_index,"dwFMin6"]!=0) OR (ModArray[Modname,mod_lng,"Sets",a_index,"dwFMax6"]!=0)
	{
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwFCode6"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwFPar6"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwFMin6"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwFMax6"],uint) a_tab
	}
	else
		loop,4
			NewTxt .= a_tab
			;~ Clipboard := NewTxt
	
	
	
	ModArray[Modname,mod_lng,"Sets",a_index,"dwFCode7"] := BinSets.ReadUInt()    ;~ DWORD dwFCode7;                  //0xF0
	ModArray[Modname,mod_lng,"Sets",a_index,"dwFPar7"] := BinSets.ReadUInt()    ;~ DWORD dwFPar7;                  //0xF4
	ModArray[Modname,mod_lng,"Sets",a_index,"dwFMin7"] := BinSets.ReadUInt()    ;~ DWORD dwFMin7;                  //0xF8
	ModArray[Modname,mod_lng,"Sets",a_index,"dwFMax7"] := BinSets.ReadUInt()    ;~ DWORD dwFMax7;                  //0xFC
	If (ModArray[Modname,mod_lng,"Sets",a_index,"dwFPar7"]!=0) OR (ModArray[Modname,mod_lng,"Sets",a_index,"dwFMin7"]!=0) OR (ModArray[Modname,mod_lng,"Sets",a_index,"dwFMax7"]!=0)
	{
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwFCode7"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwFPar7"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwFMin7"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwFMax7"],uint) a_tab
	}
	else
		loop,4
			NewTxt .= a_tab
			;~ Clipboard := NewTxt
	
	
	
	ModArray[Modname,mod_lng,"Sets",a_index,"dwFCode8"] := BinSets.ReadUInt()    ;~ DWORD dwFCode8;                  //0x100
	ModArray[Modname,mod_lng,"Sets",a_index,"dwFPar8"] := BinSets.ReadUInt()    ;~ DWORD dwFPar8;                  //0x104
	ModArray[Modname,mod_lng,"Sets",a_index,"dwFMin8"] := BinSets.ReadUInt()    ;~ DWORD dwFMin8;                  //0x108
	ModArray[Modname,mod_lng,"Sets",a_index,"dwFMax8"] := BinSets.ReadUInt()    ;~ DWORD dwFMax8;                  //0x10C
	If (ModArray[Modname,mod_lng,"Sets",a_index,"dwFPar8"]!=0) OR (ModArray[Modname,mod_lng,"Sets",a_index,"dwFMin8"]!=0) OR (ModArray[Modname,mod_lng,"Sets",a_index,"dwFMax8"]!=0)
	{
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwFCode8"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwFPar8"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwFMin8"],uint) a_tab
		NewTxt .= LimitWrap(ModArray[Modname,mod_lng,"Sets",a_index,"dwFMax8"],uint) a_tab
	}
	else
		loop,4
			NewTxt .= a_tab
			;~ Clipboard := NewTxt
	
	
	
	ModArray[Modname,mod_lng,"Sets",a_index,"pSetItem1"] := BinSets.ReadUInt() ;~ NewTxt .= BinSets.ReadUInt() a_tab   ;~ D2SetItemsTxt* pSetItem1;         //0x110
	ModArray[Modname,mod_lng,"Sets",a_index,"pSetItem2"] := BinSets.ReadUInt() ;~ NewTxt .= BinSets.ReadUInt() a_tab   ;~ D2SetItemsTxt* pSetItem2;         //0x114
	ModArray[Modname,mod_lng,"Sets",a_index,"pSetItem3"] := BinSets.ReadUInt() ;~ NewTxt .= BinSets.ReadUInt() a_tab   ;~ D2SetItemsTxt* pSetItem3;         //0x118
	ModArray[Modname,mod_lng,"Sets",a_index,"pSetItem4"] := BinSets.ReadUInt() ;~ NewTxt .= BinSets.ReadUInt() a_tab	 ;~ D2SetItemsTxt* pSetItem4;         //0x11C
	ModArray[Modname,mod_lng,"Sets",a_index,"pSetItem5"] := BinSets.ReadUInt() ;~ NewTxt .= BinSets.ReadUInt() a_tab   ;~ D2SetItemsTxt* pSetItem5;         //0x120
	ModArray[Modname,mod_lng,"Sets",a_index,"pSetItem6"] := BinSets.ReadUInt() ;~ NewTxt .= BinSets.ReadUInt() a_tab   ;~ D2SetItemsTxt* pSetItem6;         //0x124
	Loop,6
		NewTxt .= a_tab
		;should pull from setitems.txt, will wait until actually working on that.
		;~ NewTxt .= ModArray[Modname,mod_lng,"Sets",a_index,"pSetItem" a_index] a_tab
	NewTxt .= "0`r`n" ;EOL
	if ModArray[Modname,mod_lng,"Sets",a_index,"Set ID"]=15
	{
		NewTxt .= "Expansion"
		For cat in ModArray[Modname,mod_lng,"Sets",a_index]
			NewTxt .= a_tab
		;~ StringTrimRight,newtxt,newtxt,6
		
		NewTxt .= "`r`n" ;EOL
	}
	If BinSets.ateof !=0
		break
}
FileDelete,lib_sets.txt
FileAppend,%newtxt%,lib_sets.txt
;~ msgbox % BinSetsNumber+1
;~ msgbox % binsets.pos()


ExitApp
limitWrap(value,utype)
{
	If (utype = uint) AND  (value = 4294967295)
	{
		value=
	}
	return value
}

;~ Array_Gui(ModArray)
