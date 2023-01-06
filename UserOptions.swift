//
//  UserOptions.swift
//  New
//
//  Created by Tom Bluewater on 11/11/16.
//  Copyright © 2016 Tom Bluewater. All rights reserved.
//

import Foundation

class UserOptions {
    static func createData(path: String) {
        var statement: OpaquePointer? = nil
        sqlite3_open(path, &statement)
        let sqlCreate = "CREATE TABLE IF NOT EXISTS data (ID INTEGER PRIMARY KEY AUTOINCREMENT, field text, value text)"
        sqlite3_exec(statement, (sqlCreate as NSString).utf8String, nil, nil, nil)
        //sqlite3_close(statement)
        
        // Start Inserting fields
        for i in 0..<101 {
            if sqlite3_open(path, &statement) == SQLITE_OK {
                let sqlInsert = "INSERT INTO data (field,value) VALUES (?,?)"
                if sqlite3_prepare_v2(statement, sqlInsert, -1, &statement, nil) != SQLITE_OK {
                    //let errMsg = String.init(validatingUTF8: sqlite3_errmsg(statement))
                    //print("error preparing insert: \(errMsg)")
                }
                sqlite3_bind_text(statement, 1, "Value" + String(i), -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
                
				if i == 0 {
					sqlite3_bind_text(statement, 2, "5", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) // enter a special value in "0"
				}
				else if i == 1 {
					sqlite3_bind_text(statement, 2, "0", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) // enter a special value in "0"
				}
				else if i == 2 {
					sqlite3_bind_text(statement, 2, "Not important", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) // enter a special value in "0"
				}
				else if i == 3 {
					sqlite3_bind_text(statement, 2, "Important", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) // enter a special value in "0"
				}
				else if i == 4 {
					sqlite3_bind_text(statement, 2, "Very important", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) // enter a special value in "0"
				}
				else if i == 5 {
					sqlite3_bind_text(statement, 2, "Super important", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) // enter a special value in "0"
				}
				else if i == 6 {
					sqlite3_bind_text(statement, 2, "129", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) // enter a special value in "0"
				}
				else if i == 7 {
					sqlite3_bind_text(statement, 2, "90", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) // enter a special value in "0"
				}
				else if i == 8 {
					sqlite3_bind_text(statement, 2, "7", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) // enter a special value in "0"
				}
				else if i == 9 {
					sqlite3_bind_text(statement, 2, "61", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) // enter a special value in "0"
				}
				else if i == 10 {
					sqlite3_bind_text(statement, 2, "0", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) // enter a special value in "0"
				}
				else if i == 11 {
					sqlite3_bind_text(statement, 2, "Apple System UI Font", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) // enter a special value in "0"
				}
				else if i == 12 {
					sqlite3_bind_text(statement, 2, "0", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) // enter a special value in "0"
				}
				else if i == 13 {
					sqlite3_bind_text(statement, 2, "6", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) // enter a special value in "0"
				}
				else if i == 14 {
					sqlite3_bind_text(statement, 2, "58", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) // enter a special value in "0"
				}
				else if i == 15 {
					sqlite3_bind_text(statement, 2, "33", -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self)) // enter a special value in "0"
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
 Usage
 var tsecs = UserOptions.readData(path: optionFile, field: "Value20")
 UserOptions.updateData(path: optionFile, field: "Value20", value: newTsecs)
 
Value0 - Export format
Value1 - Export compression rate
Value2 - Level0 highlight name (not important)
Value3 - Level1 highlight name (important)
Value4 - Level2 highlight name (very important)
Value5 - Level3 highlight name (super important)
Value6 - Level0 highlight color (129)
Value7 - Level1 highlight color (90)
Value8 - Level2 highlight color (7)
Value9 - Level3 highlight color (61)
Value10 - sorting code index (0)
Value11 - code: font family name (0)
Value12 - code: font selection (0)
Value13 - code: font text size index (6)
Value14 - code: syntax color index (58)
Value15 - code: search match color index (33)
Value16 - find keys
Value17 - date format options
Value18
Value19
Value20 - Case-sensitive for FindViewController
Value21 - Case-sensitive for GlobalViewController
Value22 - Stack for GlobalViewController
Value23
Value24
Value25
Value26
Value27
Value28
Value29
Value30
Value31
Value32
Value33
Value34
Value35
Value36
Value37
Value38
Value39
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
Value50 - show menu
*/

/*
READ: let opt1 = UserOptions.readData(path: optionFile, field: "Value1")
WRITE: UserOptions.updateData(path: optionFile, field: "Value1", value: newStr)
*/

