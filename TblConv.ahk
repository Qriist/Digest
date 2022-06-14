#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetBatchLines, -1

;this is a placeholder script for testing while I work on porting the perl tbl converter to ahk.
;will eventually be wrapped into Digest as a method

;NEXT STEP: examine class_digest for whatever I actually want to return, and then have this function do that san perl wrapper

testfile := "expansionstring"
Fileopen(a_scriptdir "\" testfile ".txt","w").write(tblconv(a_scriptdir "\" testfile ".tbl"))   ;one liner to generate the file




tblconv(inputTblPath, retMode := 0){
    ;converted pretty much line by line from Mephansteras's 2001 standalone perl script. Idk where I found it.
    /* intro to the string.tbl format.
        # There are four main sections to the string.tbl file.
        # First, the header.  This is 21 bytes long.
        # Second, an array with two bytes per entry, that gives an index into the next table.  This allows lookups of strings by number.
        # Third, a hash array, with 17 bytes per entry, which has the pointers to the key and value strings, and has the strings sorted basically by hash value.  This allows lookups of strings by key.
        # Fourth, the actual strings themselves.
    */
    tbl := FileOpen(inputTblPath, "r", "UTF-8-Raw")

    ;21 byte header
    usCRC := tbl.ReadUShort()   ;This is usCRC, an unsigned short which contains the CRC (Cyclical Redundacy Check) which we don't care about.
    usNumElements := tbl.ReadUShort()   ;This is usNumElements, the total number of elements (key/value string pairs) in the file.
    iHashTableSize := tbl.ReadUInt()    ;This is iHashTableSize, the number of entries in the HashTable.  
                                        ;This has to be at least equal to usNumElements, and if higher it can speed up the hash table look up.  
                                        ;Blizzard has this number be 2 higher than usNumElements in the english version.  
                                        ;I just leave the hash table size the same as usNumElements, which is not optimal, but easier.
    unknownByte := tbl.ReadUChar()       ;I don't know what this is used for, I always set it to 1, which is what it is in the english version.
    dwIndexStart := tbl.ReadUInt()  ;This is dwIndexStart, the offset of the first byte of the actual strings.  
                                    ;This offset is from the start of the file, as are the other offsets mentioned herein.  
                                    ;We don't really need it when reading.
    missedHashMatch := tbl.ReadUInt()   ;When the number of times you have missed a match with a hash key equals this value, you give up because it is not there.  
                                        ;We don't care what this value was in the original.
    dwIndexEnd  := tbl.ReadUInt()   ;This is dwIndexEnd, the offset just after the last byte of the actual strings.

    ;Reading strings
    elements := []
    loop, % usNumElements{
        elements[a_index - 1] := tbl.ReadUShort()   ;0-based array
        ;msgbox % elements[a_index - 1]
    }

    keys := []
    values := []
    nodeStart := (21 + (usNumElements * 2))   ;Sets $nodeStart to the current offset we are at in the file.  This is equal to (21 + ($numElements * 2)).  This is the offset at the start of the hash table.
    
    ;!!!confirmed good values up to this point!!!
    

    loop, % usNumElements {
        idx := a_index - 1  ;0-based array
        tbl.Seek((nodeStart + (elements[idx] * 17)), 0)    ;Set the offset that we are reading from in the file to be (Start of Hash Table + (17 * the ith element in array elements)), 
                                                           ;meaning the start of the hash table entry that was indicated by entry #i in the previous table.
        bUsed := tbl.ReadUChar() ;This is bUsed, which is set to 1 if this entry is used.  
                        ;This may be set to 0 if this entry is just in there to add to the size of the hash table to get better performance.  
                        ;We just ignore it, assuming it is 1.  We could assert that it is one if we wanted, though.
        idxNum := tbl.ReadUShort()  ;This is the index number.  
                                    ;Basically, this should always be equal to the value of $i as we read it.  
                                    ;That is, the index in the previous array whose value is this index in this array.

        ;confirmed that (idx = idxnum)
        idxHash := tbl.ReadUInt()   ;This is the hash number.  
                                    ;This is the number you get from sending this entry's key string through the hashing algorithim.  
                                    ;We don't care about it right now.
        dwKeyOffset := tbl.ReadUInt()   ;This is dwKeyOffset, the offset of the key string.  
                                        ;The key is the same in every language.
        dwStringOffset := tbl.ReadUInt()    ;This is dwStringOffset, the offset to the value string.  
                                            ;The value is translated into the appropriate language.
        idxLength := tbl.ReadUShort()   ;read 2 bytes.  This is the length of the value string.

        tbl.Seek(dwKeyOffset, 0)    ;Go to the key's offset now.
        key := ""
        loop{
            nullTest := tbl.ReadUChar() ;read into local variable $key everything up to and including the next null byte.
            if (nullTest!=0)
                key .= chr(nullTest)    
            Else
                break   ;get rid of the trailing null byte on $key
        }

        tbl.Seek(dwStringOffset, 0)    ;Go to the key's offset now.
        string := ""
        loop{
            nullTest := tbl.ReadUChar() ;read into local variable $string everything up to and including the next null byte.
            if (nullTest!=0)
                string .= chr(nullTest)    
            Else
                break   ;get rid of the trailing null byte on $string
        }

        ;appears to create good values up to this point
        keys[idx] := key
        values[idx] := string
        
        ;cleaning inputs
        inkey := keys[idx]
        inkey := Trim(inkey,"`r")   ;Strip Carriage Return
        inkey := StrReplace(inkey, "`n", "}")   ;Replace Newlines with }
        inkey := StrReplace(inkey, a_tab , "\t")    ;Replace any Tabs with \t

        inval := values[idx]
        inval := Trim(inval,"`r")   ;Strip Carriage Return
        inval := StrReplace(inval, "`n", "}")   ;Replace Newlines with }
        inval := StrReplace(inval, a_tab , "\t")    ;Replace any Tabs with \t
        retStr .= inkey "`t" inval "`r`n"
    }
    return retStr
}