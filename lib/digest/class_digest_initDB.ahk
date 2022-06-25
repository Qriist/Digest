initDB(){
	retObj := []
	pushDB = 
    (
        CREATE TABLE Mods (
            modId               INTEGER PRIMARY KEY
                                        UNIQUE,
            _filepath,
            _isCore,
            _shortDir,
            D2Core,
            ModName,
            ModTitle,
            ModMajorVersion,
            ModMinorVersion,
            ModRevision,
            ModBanner,
            ModReadme,
            ModHP,
            ModBoard,
            Modable,
            ModAllowHC,
            ModAllowSPFeature,
            ModUseD2SE,
            D2SEDllName,
            ModUseD2SEUtility,
            ModUseNefex,
            ModUseD2Mod,
            ModUseD2Extra,
            D2SEUtility,
            ModAllowD2SEUtility,
            ModAllowPlugY,
            ModUsePatch_D2,
            ModMPQ1,
            ModMPQ2,
            ModMPQ3,
            RealmGateway,
            RealmTimezone,
            RealmGatewayName,
            RealmSelected,
            RealmPort,
            ModDescription,
            UpdateFile,
            UpdateMirror1,
            UpdateMirror2,
            UpdateMirror3,
            _modHash                    UNIQUE
        `);
    )
	retObj.push(pushDB)
	
	pushDB = 
    (
        CREATE TABLE Strings (
            stringId    INTEGER PRIMARY KEY,
            modId       INTEGER,
            languageId  INTEGER,
            stringIndex INTEGER,
            stringCode  TEXT,
            stringText  TEXT
        `);
    )
	retObj.push(pushDB)
	
	pushDB = 
    (
        CREATE TABLE Languages (
            languageId   INTEGER PRIMARY KEY,
            languageText TEXT    UNIQUE
        `);
    )
	retObj.push(pushDB)
	
	#Include %A_ScriptDir%\lib\digest\class_digest_initDB_autocompiled.ahk
	return retObj
}