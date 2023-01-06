//
//  Preferences.swift
//  New
//
//  Created by Tom Bluewater on 11/11/16.
//  Copyright © 2016 Tom Bluewater. All rights reserved.
//

import Foundation

class Preferences {
    static func createData(path: String) {
        var statement: OpaquePointer? = nil
        sqlite3_open(path, &statement)
        let sqlCreate = "CREATE TABLE IF NOT EXISTS data (ID INTEGER PRIMARY KEY AUTOINCREMENT, field text, value text)"
        sqlite3_exec(statement, (sqlCreate as NSString).utf8String, nil, nil, nil)
        //sqlite3_close(statement)
        
        // Start Inserting fields
        for i in 0..<99 {
            if sqlite3_open(path, &statement) == SQLITE_OK {
                let sqlInsert = "INSERT INTO data (field,value) VALUES (?,?)"
                if sqlite3_prepare_v2(statement, sqlInsert, -1, &statement, nil) != SQLITE_OK {
                    //let errMsg = String.init(validatingUTF8: sqlite3_errmsg(statement))
                    //print("error preparing insert: \(errMsg)")
                }
                sqlite3_bind_text(statement, 1, "Value" + String(i), -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
                
                if i == 32 {
                    sqlite3_bind_text(statement, 2, "0", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) // enter a special value in "0"
				}
				else if i == 6 {
					sqlite3_bind_text(statement, 2, "1", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) // enter a special value in "0"
				}
                else {
                    sqlite3_bind_text(statement, 2, "0", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
                }
                
                sqlite3_step(statement)
                sqlite3_finalize(statement)
            }
        }
        //sqlite3_close(statement)
        // End Inserting fields
    }
    
    static func openDatabase(path: String) -> OpaquePointer? {
        var db: OpaquePointer? = nil
        if sqlite3_open(path, &db) == SQLITE_OK {
            return db
        } else {
            return nil
        }
    }
    
    static func readData(path: String, field: String) -> String {
        var statement: OpaquePointer? = nil
        var value = String()
        if let db = openDatabase(path: path) {
            let sql = "Select value FROM data WHERE field = ?"
            if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
                sqlite3_bind_text(statement, 1, field, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    value = ((sqlite3_column_text(statement, 0)) != nil) ? String(cString: sqlite3_column_text(statement, 0)) : ""
                }
                sqlite3_finalize(statement)
            }
            sqlite3_close(db)
			statement = nil
        }
        return value
    }
    
    static func updateData(path: String, field: String, value: String) {
        var statement: OpaquePointer? = nil
        if let db = openDatabase(path: path) {
            let sql = "UPDATE data SET value = ? WHERE field = ?"
            if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
                sqlite3_bind_text(statement, 1, value, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
                sqlite3_bind_text(statement, 2, field, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
                //sqlite3_bind_text(statement, 1, value.cString(using: .utf8), -1, nil)
                //sqlite3_bind_text(statement, 2, field.cString(using: .utf8), -1, nil)
                if sqlite3_step(statement) == SQLITE_DONE {
                    //print("DONE!!!")
                } else {
                    print("UGGHH!!!")
                }
                sqlite3_finalize(statement)
            }
            sqlite3_close(db)
			statement = nil
        }
    }
}

/*
 Value0 - show tellView
 Value1 - preferencesOption1: Don't show instructions in user's guide
 Value2 - preferencesOption2: Don't prompt me for confirmation when opening the default web browser
 Value3 - preferencesOption3: Skip HOME at startup
 Value4 - preferencesOption4: Don't prompt me for confirmation when deleting a backup data file
 Value5 - preferencesOption5: Don't syntax-highlight tag phrases
 Value6 - preferencesOption6: Run a code content search case-insensitively
 Value7 - preferencesOption7: Don't clear attachment paths when importing a group
 Value8 - preferencesOption8: Don't prompt me for confirmation when deleting a group
 Value9 - preferencesOption9: Don't prompt me for confirmation when deleting a code snippet
 Value10 - preferencesOption10: Don't prompt me for confirmation when deleting the selected picture
 Value11 - preferencesOption11: Don't automatically insert the http protocol when adding a new URL
 Value12 - preferencesOption12: List code snippet titles with alternating row colors
 Value13 - preferencesOption13: Don't play back camera shutter sound when copying code text into system clipboard
 Value14 - preferencesOption14: Don't remember the last keyword for 'Find'
 Value15 - preferencesOption15: Filter code snippet titles based on the string case-sensitively
 Value16 - preferencesOption16: Filter code snippet titles continuously based on the string as I type
 Value17 - preferencesOption17
 Value18 - preferencesOption18
 Value19 - preferencesOption19
 Value20 - preferencesOption20
 Value21 - preferencesOption21
 Value22 - preferencesOption22
 Value23 - preferencesOption23
 Value24 - preferencesOption24
 Value25
 Value26
 Value27
 Value28
 Value29
 Value30 - tempOpenPath
 Value31 - tempSavePath
 Value32 - user interface
 Value33
 Value34
 Value35
 Value36
 Value37
 Value38
 Value39
 Value40
 Value40
 Value41
 Value42
 Value43
 Value44
 Value45
 Value46
 Value47
 Value48
 Value49
 Value50
 */

/*
 READ: let pref1 = Preferences.readData(path: prefFile, field: "Value1")
 WRITE: Preferences.updateData(path: prefFile, field: "Value1", value: newStr)
 */

