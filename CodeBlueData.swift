//
//  CodeBlueData.swift
//  CodeBlue 5
//
//  Created by Tom Bluewater on 11/14/16.
//  Copyright © 2016 Tom Bluewater. All rights reserved.
//

import Cocoa

class CodeBlueData {
    static func createData(path: String) {
        var statement: OpaquePointer? = nil
        sqlite3_open(path, &statement)
		let sqlCreate1 = "CREATE TABLE IF NOT EXISTS codegroup (ID INTEGER PRIMARY KEY AUTOINCREMENT, fieldtsecs text, fieldname text, fieldpic int, fieldtags text, versions text, place int)"
		let sqlCreate2 = "CREATE TABLE IF NOT EXISTS codechild (ID INTEGER PRIMARY KEY AUTOINCREMENT, fieldtsecs text, codetsecs text, title text, code text, highlightindex int, version text, imagePathString text, urlString text)"
		sqlite3_exec(statement, (sqlCreate1 as NSString).utf8String, nil, nil, nil)
		sqlite3_exec(statement, (sqlCreate2 as NSString).utf8String, nil, nil, nil)
    }
    
    static func closeDatabase(path: String) {
		// https://stackoverflow.com/questions/61189751/how-can-i-resolve-warning-message-bug-in-client-of-libsqlite3-dylib-database-i
        var statement: OpaquePointer? = nil
        if sqlite3_open(path, &statement) == SQLITE_OK {
            sqlite3_close(statement)
			statement = nil
        }
    }
    
    static func openDatabase(path: String) -> OpaquePointer? {
        var db: OpaquePointer? = nil
        if sqlite3_open(path, &db) == SQLITE_OK {
            return db
        } else {
            return nil
        }
    }
	
	
    /* Group */
	static func readAllGroups(path: String) -> [GroupModel] {
		var statement: OpaquePointer? = nil
		var models = [GroupModel]()
		
		if let db = openDatabase(path: path) {
			let sql = "Select fieldtsecs, fieldname, fieldpic, fieldtags, versions, place FROM codegroup"
			if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
				while (sqlite3_step(statement) == SQLITE_ROW) {
					let field0 = sqlite3_column_text(statement, 0) // fieldtsecs
					let field1 = sqlite3_column_text(statement, 1) // fieldname
					let field2 = sqlite3_column_int(statement, 2) // fieldpic
					let field3 = sqlite3_column_text(statement, 3) // fieldtags
					let field4 = sqlite3_column_text(statement, 4) // versions
					let field5 = sqlite3_column_int(statement, 5) // place
					let str0 = String(cString: UnsafeRawPointer(field0!).assumingMemoryBound(to: CChar.self))
					let str1 = String(cString: UnsafeRawPointer(field1!).assumingMemoryBound(to: CChar.self))
					//let str2 = String(cString: UnsafeRawPointer(field2!).assumingMemoryBound(to: CChar.self))
					let str3 = String(cString: UnsafeRawPointer(field3!).assumingMemoryBound(to: CChar.self))
					let str4 = String(cString: UnsafeRawPointer(field4!).assumingMemoryBound(to: CChar.self))
					//let str5 = String(cString: UnsafeRawPointer(field5!).assumingMemoryBound(to: CChar.self))
					let tags = str3.components(separatedBy: ",")
					var tagArray = [String]()
					for i in 0..<tags.count {
						let tag = tags[i].trimmingCharacters(in: .whitespacesAndNewlines)
						if tag != "" {
							if let replacement = tag.replaceAllWithArray(findArray: ["*", "\\"], str: "") {
								tagArray.append(replacement)
							} else {
								tagArray.append(tag)
							}
						}
					}
					let versionStr = str4.components(separatedBy: ",")
					var versionArray = [String]()
					for i in 0..<versionStr.count {
						let ver = versionStr[i].trimmingCharacters(in: .whitespacesAndNewlines)
						if ver != "" {
							if let replacement = ver.replaceAllWithArray(findArray: ["*", "\\"], str: "") {
								versionArray.append(replacement)
							} else {
								versionArray.append(ver)
							}
						}
					}
					let snippetCount = countSnippetData(path: path, fieldtsecs: str0)
					let groupModel = GroupModel(identifier: str0, name: str1, imageIndex: Int(field2), tags: tagArray, place: Int(field5), versions: versionArray, snippetCount: snippetCount ?? 0)
					models.append(groupModel)
				}
				sqlite3_finalize(statement)
			}
			if sqlite3_close(db) != SQLITE_OK {
				print("error closing database")
			}
			statement = nil
		} else {
			print("Database can't be opened.")
		}
		return models
	}
	
	static func readMergeGroups(path: String) -> [MergeGroup] {
		var statement: OpaquePointer? = nil
		var models = [MergeGroup]()
		
		if let db = openDatabase(path: path) {
			let sql = "Select fieldtsecs, fieldname, fieldpic, fieldtags, versions, place FROM codegroup"
			if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
				while (sqlite3_step(statement) == SQLITE_ROW) {
					let field0 = sqlite3_column_text(statement, 0) // fieldtsecs
					let field1 = sqlite3_column_text(statement, 1) // fieldname
					let field2 = sqlite3_column_int(statement, 2) // fieldpic
					let field3 = sqlite3_column_int(statement, 3) // place
					let str0 = String(cString: UnsafeRawPointer(field0!).assumingMemoryBound(to: CChar.self))
					let str1 = String(cString: UnsafeRawPointer(field1!).assumingMemoryBound(to: CChar.self))
					let mergeModel = MergeGroup(id: str0, name: str1, pictIndex: Int(field2), place: Int(field3))
					models.append(mergeModel)
				}
				sqlite3_finalize(statement)
			}
			if sqlite3_close(db) != SQLITE_OK {
				print("error closing database")
			}
			statement = nil
		} else {
			print("Database can't be opened.")
		}
		return models
	}
	
	static func insertGroup(path: String, fieldtsecs: String, fieldname: String, pictIndex: Int, fieldtags: String, versions: String, place: Int) {
		var statement: OpaquePointer? = nil
		if let db = openDatabase(path: path) {
			let sql = "INSERT INTO codegroup (fieldtsecs, fieldname, fieldpic, fieldtags, versions, place) VALUES (?, ?, ?, ?, ?, ?)"
			if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
				sqlite3_bind_text(statement, 1, fieldtsecs, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
				sqlite3_bind_text(statement, 2, fieldname, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
				sqlite3_bind_int(statement, 3, Int32(pictIndex))
				sqlite3_bind_text(statement, 4, fieldtags, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
				sqlite3_bind_text(statement, 5, versions, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
				sqlite3_bind_int(statement, 6, Int32(place))
				if sqlite3_step(statement) == SQLITE_DONE {
					//print("DONE!!!")
				} else {
					print("UGGHH!!!")
					let errorMessage = String.init(cString: sqlite3_errmsg(db))
					print("Error: \(errorMessage)")
				}
				
				//sqlite3_step(statement)
				sqlite3_finalize(statement)
			}
			if sqlite3_close(db) != SQLITE_OK {
				print("error closing database")
			}
			statement = nil
		} else {
			print("Database can't be opened.")
		}
	}
	
	static func updateGroup(path: String, name: String, pictIndex: Int, fieldtags: String, versions: String, place: Int, fieldID: String) {
		var statement: OpaquePointer? = nil
		if let db = openDatabase(path: path) {
			let sql = "UPDATE codegroup SET fieldname = ?, fieldpic = ?, fieldtags = ?, versions = ?, place = ? WHERE fieldtsecs = ?"
			if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
				sqlite3_bind_text(statement, 1, name, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
				sqlite3_bind_int(statement, 2, Int32(pictIndex))
				sqlite3_bind_text(statement, 3, fieldtags, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
				sqlite3_bind_text(statement, 4, versions, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
				sqlite3_bind_int(statement, 5, Int32(place))
				sqlite3_bind_text(statement, 6, fieldID, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
				
				if sqlite3_step(statement) == SQLITE_DONE {
					//print("DONE!!!")
				} else {
					print("UGGHH!!!")
					let errorMessage = String.init(cString: sqlite3_errmsg(db))
					print("Error: \(errorMessage)")
				}
				
				//sqlite3_step(statement)
				sqlite3_finalize(statement)
			}
			sqlite3_close(db)
			statement = nil
		} else {
			print("Database can't be opened.")
		}
	}
		
	static func updateGroupPlace(path: String, place: Int, fieldID: String) {
		var statement: OpaquePointer? = nil
		if let db = openDatabase(path: path) {
			let sql = "UPDATE codegroup SET place = ? WHERE fieldtsecs = ?"
			if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
				sqlite3_bind_int(statement, 1, Int32(place))
				sqlite3_bind_text(statement, 2, fieldID, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
				
				if sqlite3_step(statement) == SQLITE_DONE {
					//print("DONE!!!")
				} else {
					print("UGGHH!!!")
					let errorMessage = String.init(cString: sqlite3_errmsg(db))
					print("Error: \(errorMessage)")
				}
				
				//sqlite3_step(statement)
				sqlite3_finalize(statement)
			}
			sqlite3_close(db)
			statement = nil
		} else {
			print("Database can't be opened.")
		}
	}
	
	static func deleteGroupData(path: String, fieldTsecs: String) {
		var statement: OpaquePointer? = nil
		if let db = openDatabase(path: path) {
			let sql = "DELETE FROM codegroup WHERE fieldtsecs = '\(fieldTsecs)'"
			if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
				if sqlite3_step(statement) == SQLITE_DONE {
					//print("Successfully deleted row.")
				} else {
					print("Could not delete row.")
				}
				sqlite3_finalize(statement)
			}
			sqlite3_close(db)
			statement = nil
		} else {
			print("Database can't be opened.")
		}
	}
	
	static func countGroupData(path: String) -> Int? {
		// counting a record based on a new rec name: preventing the user from rating its own movie screenshot //
		var statement: OpaquePointer? = nil
		if let db = openDatabase(path: path) {
			let sql = "SELECT COUNT(*) FROM codegroup"
			if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
				if(sqlite3_step(statement) == SQLITE_ROW) {
					let r = sqlite3_column_int(statement, 0)
					sqlite3_finalize(statement)
					sqlite3_close(db)
					statement = nil
					return Int(r)
				}
			}
			sqlite3_close(db)
			statement = nil
		} else {
			print("Database can't be opened.")
		}
		return nil
	}
	
	static func readUniquePictData(path: String) -> [Int]? {
		var statement: OpaquePointer? = nil
		var intGroup = [Int]()
		
		if let db = openDatabase(path: path) {
			let sql = "Select fieldpic FROM codegroup"
			if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
				while (sqlite3_step(statement) == SQLITE_ROW) {
					let str0 = ((sqlite3_column_text(statement, 0)) != nil) ? String(cString: sqlite3_column_text(statement, 0)) : ""
					if str0.isInt() {
						if !intGroup.contains(Int(str0)!) {
							intGroup.append(Int(str0)!)
						}
					}
				}
				sqlite3_finalize(statement)
			}
			sqlite3_close(db)
			statement = nil
		} else {
			print("Database can't be opened.")
		}
		return intGroup
	}
	
	
	/* Snippets */
	static func queryCodeSnippets(path: String, groupID: String) -> [CodeModel] {
		var statement: OpaquePointer? = nil
		var codeModels = [CodeModel]()
		
		if let db = openDatabase(path: path) {
			let sql = "Select codetsecs, title, code, highlightindex, version, imagePathString, urlString FROM codechild WHERE fieldtsecs='\(groupID)'"
			if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
				while (sqlite3_step(statement) == SQLITE_ROW) {
					//let field0 = sqlite3_column_text(statement, 0) // fieldtsecs
					let field0 = sqlite3_column_text(statement, 0) // codetsecs
					let field1 = sqlite3_column_text(statement, 1) // title
					let field2 = sqlite3_column_text(statement, 2) // code
					let field3 = sqlite3_column_int(statement, 3) // highlightindex
					let field4 = sqlite3_column_text(statement, 4) // version
					let field5 = sqlite3_column_text(statement, 5) // imagePathString
					let field6 = sqlite3_column_text(statement, 6) // urlString
					//let str0 = String(cString: UnsafeRawPointer(field0!).assumingMemoryBound(to: CChar.self))
					let str0 = String(cString: UnsafeRawPointer(field0!).assumingMemoryBound(to: CChar.self))
					let str1 = String(cString: UnsafeRawPointer(field1!).assumingMemoryBound(to: CChar.self))
					let str2 = String(cString: UnsafeRawPointer(field2!).assumingMemoryBound(to: CChar.self))
					//let str3 = String(cString: UnsafeRawPointer(field3!).assumingMemoryBound(to: CChar.self))
					let str4 = String(cString: UnsafeRawPointer(field4!).assumingMemoryBound(to: CChar.self))
					let str5 = String(cString: UnsafeRawPointer(field5!).assumingMemoryBound(to: CChar.self))
					let str6 = String(cString: UnsafeRawPointer(field6!).assumingMemoryBound(to: CChar.self))
					let codeModel = CodeModel(fieldID: groupID, identifier: str0, title: str1, code: str2, version: str4, highlightIndex: Int(field3), imagePathString: str5, urlString: str6)
					codeModels.append(codeModel)
				}
				sqlite3_finalize(statement)
			}
			if sqlite3_close(db) != SQLITE_OK {
				print("error closing database")
			}
			statement = nil
		} else {
			print("Database can't be opened.")
		}
		return codeModels
	}
	
	static func queryOneCodeSnippet(path: String, codeID: String) -> SnippetModel? {
		var statement: OpaquePointer? = nil
		var snippetModel: SnippetModel?
		
		if let db = openDatabase(path: path) {
			let sql = "Select codetsecs, title, code, highlightindex, version, imagePathString, urlString FROM codechild WHERE codetsecs='\(codeID)'"
			if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
				while (sqlite3_step(statement) == SQLITE_ROW) {
					//let field0 = sqlite3_column_text(statement, 0) // fieldtsecs
					let field0 = sqlite3_column_text(statement, 0) // codetsecs
					let field1 = sqlite3_column_text(statement, 1) // title
					let field2 = sqlite3_column_text(statement, 2) // code
					let field3 = sqlite3_column_int(statement, 3) // highlightindex
					let field4 = sqlite3_column_text(statement, 4) // version
					let field5 = sqlite3_column_text(statement, 5) // imagePathString
					let field6 = sqlite3_column_text(statement, 6) // urlString
					//let str0 = String(cString: UnsafeRawPointer(field0!).assumingMemoryBound(to: CChar.self))
					let str0 = String(cString: UnsafeRawPointer(field0!).assumingMemoryBound(to: CChar.self))
					let str1 = String(cString: UnsafeRawPointer(field1!).assumingMemoryBound(to: CChar.self))
					let str2 = String(cString: UnsafeRawPointer(field2!).assumingMemoryBound(to: CChar.self))
					//let str3 = String(cString: UnsafeRawPointer(field3!).assumingMemoryBound(to: CChar.self))
					let str4 = String(cString: UnsafeRawPointer(field4!).assumingMemoryBound(to: CChar.self))
					let str5 = String(cString: UnsafeRawPointer(field5!).assumingMemoryBound(to: CChar.self))
					let str6 = String(cString: UnsafeRawPointer(field6!).assumingMemoryBound(to: CChar.self))
					snippetModel = SnippetModel(categoryID: "", snippetID: str0, title: str1, code: str2, version: str4, highlightIndex: Int(field3), imagePathString: str5, urlString: str6)
				}
				sqlite3_finalize(statement)
			}
			if sqlite3_close(db) != SQLITE_OK {
				print("error closing database")
			}
			statement = nil
			return snippetModel
		} else {
			print("Database can't be opened.")
		}
		return nil
	}
		
	static func findCodeSnippets1Key(path: String, key: String, groupID: String, caseSensitive: Bool) -> [CodeFindModel] {
		var statement: OpaquePointer? = nil
		var findModels = [CodeFindModel]()
		
		if let db = openDatabase(path: path) {
			let sql = "Select codetsecs, title, code, highlightindex FROM codechild WHERE fieldtsecs='\(groupID)'"
			if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
				while (sqlite3_step(statement) == SQLITE_ROW) {
					let field0 = sqlite3_column_text(statement, 0) // codetsecs
					let field1 = sqlite3_column_text(statement, 1) // title
					let field2 = sqlite3_column_text(statement, 2) // code
					let field3 = sqlite3_column_int(statement, 3) // highlightindex
					let str0 = String(cString: UnsafeRawPointer(field0!).assumingMemoryBound(to: CChar.self))
					let str1 = String(cString: UnsafeRawPointer(field1!).assumingMemoryBound(to: CChar.self))
					let str2 = String(cString: UnsafeRawPointer(field2!).assumingMemoryBound(to: CChar.self))
					if caseSensitive {
						if str2.contains(key) {
							let findModel = CodeFindModel(identifier: str0, title: str1, code: str2, highlightIndex: Int(field3))
							findModels.append(findModel)
						}
					} else {
						if str2.lowercased().contains(key.lowercased()) {
							let findModel = CodeFindModel(identifier: str0, title: str1, code: str2, highlightIndex: Int(field3))
							findModels.append(findModel)
						}
					}
				}
				sqlite3_finalize(statement)
			}
			if sqlite3_close(db) != SQLITE_OK {
				print("error closing database")
			}
			statement = nil
		} else {
			print("Database can't be opened.")
		}
		return findModels
	}
	
	static func findCodeSnippets2Keys(path: String, key0: String, key1: String, groupID: String, caseSensitive: Bool) -> [CodeFindModel] {
		var statement: OpaquePointer? = nil
		var findModels = [CodeFindModel]()
		
		if let db = openDatabase(path: path) {
			let sql = "Select codetsecs, title, code, highlightindex FROM codechild WHERE fieldtsecs='\(groupID)'"
			if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
				while (sqlite3_step(statement) == SQLITE_ROW) {
					let field0 = sqlite3_column_text(statement, 0) // codetsecs
					let field1 = sqlite3_column_text(statement, 1) // title
					let field2 = sqlite3_column_text(statement, 2) // code
					let field3 = sqlite3_column_int(statement, 3) // highlightindex
					let str0 = String(cString: UnsafeRawPointer(field0!).assumingMemoryBound(to: CChar.self))
					let str1 = String(cString: UnsafeRawPointer(field1!).assumingMemoryBound(to: CChar.self))
					let str2 = String(cString: UnsafeRawPointer(field2!).assumingMemoryBound(to: CChar.self))
					if caseSensitive {
						if str2.contains(key0) && str2.contains(key1) {
							let findModel = CodeFindModel(identifier: str0, title: str1, code: str2, highlightIndex: Int(field3))
							findModels.append(findModel)
						}
					} else {
						if str2.lowercased().contains(key0.lowercased()) && str2.lowercased().contains(key1.lowercased()) {
							let findModel = CodeFindModel(identifier: str0, title: str1, code: str2, highlightIndex: Int(field3))
							findModels.append(findModel)
						}
					}
				}
				sqlite3_finalize(statement)
			}
			if sqlite3_close(db) != SQLITE_OK {
				print("error closing database")
			}
			statement = nil
		} else {
			print("Database can't be opened.")
		}
		return findModels
	}
	
	static func findCodeSnippets3Keys(path: String, key0: String, key1: String, key2: String, groupID: String, caseSensitive: Bool) -> [CodeFindModel] {
		var statement: OpaquePointer? = nil
		var findModels = [CodeFindModel]()
		
		if let db = openDatabase(path: path) {
			let sql = "Select codetsecs, title, code, highlightindex FROM codechild WHERE fieldtsecs='\(groupID)'"
			if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
				while (sqlite3_step(statement) == SQLITE_ROW) {
					let field0 = sqlite3_column_text(statement, 0) // codetsecs
					let field1 = sqlite3_column_text(statement, 1) // title
					let field2 = sqlite3_column_text(statement, 2) // code
					let field3 = sqlite3_column_int(statement, 3) // highlightindex
					let str0 = String(cString: UnsafeRawPointer(field0!).assumingMemoryBound(to: CChar.self))
					let str1 = String(cString: UnsafeRawPointer(field1!).assumingMemoryBound(to: CChar.self))
					let str2 = String(cString: UnsafeRawPointer(field2!).assumingMemoryBound(to: CChar.self))
					if caseSensitive {
						if str2.contains(key0) && str2.contains(key1) && str2.contains(key2) {
							let findModel = CodeFindModel(identifier: str0, title: str1, code: str2, highlightIndex: Int(field3))
							findModels.append(findModel)
						}
					} else {
						if str2.lowercased().contains(key0.lowercased()) && str2.lowercased().contains(key1.lowercased()) && str2.lowercased().contains(key2.lowercased()) {
							let findModel = CodeFindModel(identifier: str0, title: str1, code: str2, highlightIndex: Int(field3))
							findModels.append(findModel)
						}
					}
				}
				sqlite3_finalize(statement)
			}
			if sqlite3_close(db) != SQLITE_OK {
				print("error closing database")
			}
			statement = nil
		} else {
			print("Database can't be opened.")
		}
		return findModels
	}
			
	static func globalCodeSnippets1Key(path: String, key: String, caseSensitive: Bool) -> [CodeGlobalModel] {
		var statement: OpaquePointer? = nil
		var globalModels = [CodeGlobalModel]()
		
		if let db = openDatabase(path: path) {
			let sql = "Select fieldtsecs, codetsecs, title, code, highlightindex FROM codechild"
			if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
				while (sqlite3_step(statement) == SQLITE_ROW) {
					let field0 = sqlite3_column_text(statement, 0) // fieldtsecs
					let field1 = sqlite3_column_text(statement, 1) // codetsecs
					let field2 = sqlite3_column_text(statement, 2) // title
					let field3 = sqlite3_column_text(statement, 3) // code
					let field4 = sqlite3_column_int(statement, 4) // highlightindex
					let str0 = String(cString: UnsafeRawPointer(field0!).assumingMemoryBound(to: CChar.self))
					let str1 = String(cString: UnsafeRawPointer(field1!).assumingMemoryBound(to: CChar.self))
					let str2 = String(cString: UnsafeRawPointer(field2!).assumingMemoryBound(to: CChar.self))
					let str3 = String(cString: UnsafeRawPointer(field3!).assumingMemoryBound(to: CChar.self))
					if caseSensitive {
						if str3.contains(key) {
							let globalModel = CodeGlobalModel(groupID: str0, identifier: str1, title: str2, code: str3, highlightIndex: Int(field4))
							globalModels.append(globalModel)
						}
					} else {
						if str3.lowercased().contains(key.lowercased()) {
							let globalModel = CodeGlobalModel(groupID: str0, identifier: str1, title: str2, code: str3, highlightIndex: Int(field4))
							globalModels.append(globalModel)
						}
					}
				}
				sqlite3_finalize(statement)
			}
			if sqlite3_close(db) != SQLITE_OK {
				print("error closing database")
			}
			statement = nil
		} else {
			print("Database can't be opened.")
		}
		return globalModels
	}
	
	static func globalCodeSnippets2Keys(path: String, key0: String, key1: String, caseSensitive: Bool) -> [CodeGlobalModel] {
		var statement: OpaquePointer? = nil
		var globalModels = [CodeGlobalModel]()
		
		if let db = openDatabase(path: path) {
			let sql = "Select fieldtsecs, codetsecs, title, code, highlightindex FROM codechild"
			if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
				while (sqlite3_step(statement) == SQLITE_ROW) {
					let field0 = sqlite3_column_text(statement, 0) // fieldtsecs
					let field1 = sqlite3_column_text(statement, 1) // codetsecs
					let field2 = sqlite3_column_text(statement, 2) // title
					let field3 = sqlite3_column_text(statement, 3) // code
					let field4 = sqlite3_column_int(statement, 4) // highlightindex
					let str0 = String(cString: UnsafeRawPointer(field0!).assumingMemoryBound(to: CChar.self))
					let str1 = String(cString: UnsafeRawPointer(field1!).assumingMemoryBound(to: CChar.self))
					let str2 = String(cString: UnsafeRawPointer(field2!).assumingMemoryBound(to: CChar.self))
					let str3 = String(cString: UnsafeRawPointer(field3!).assumingMemoryBound(to: CChar.self))
					if caseSensitive {
						if str3.contains(key0) && str3.contains(key1) {
							let globalModel = CodeGlobalModel(groupID: str0, identifier: str1, title: str2, code: str3, highlightIndex: Int(field4))
							globalModels.append(globalModel)
						}
					} else {
						if str3.lowercased().contains(key0.lowercased()) && str3.lowercased().contains(key1.lowercased()) {
							let globalModel = CodeGlobalModel(groupID: str0, identifier: str1, title: str2, code: str3, highlightIndex: Int(field4))
							globalModels.append(globalModel)
						}
					}
				}
				sqlite3_finalize(statement)
			}
			if sqlite3_close(db) != SQLITE_OK {
				print("error closing database")
			}
			statement = nil
		} else {
			print("Database can't be opened.")
		}
		return globalModels
	}
	
	static func globalCodeSnippets3Keys(path: String, key0: String, key1: String, key2: String, caseSensitive: Bool) -> [CodeGlobalModel] {
		var statement: OpaquePointer? = nil
		var globalModels = [CodeGlobalModel]()
		
		if let db = openDatabase(path: path) {
			let sql = "Select fieldtsecs, codetsecs, title, code, highlightindex FROM codechild"
			if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
				while (sqlite3_step(statement) == SQLITE_ROW) {
					let field0 = sqlite3_column_text(statement, 0) // fieldtsecs
					let field1 = sqlite3_column_text(statement, 1) // codetsecs
					let field2 = sqlite3_column_text(statement, 2) // title
					let field3 = sqlite3_column_text(statement, 3) // code
					let field4 = sqlite3_column_int(statement, 4) // highlightindex
					let str0 = String(cString: UnsafeRawPointer(field0!).assumingMemoryBound(to: CChar.self))
					let str1 = String(cString: UnsafeRawPointer(field1!).assumingMemoryBound(to: CChar.self))
					let str2 = String(cString: UnsafeRawPointer(field2!).assumingMemoryBound(to: CChar.self))
					let str3 = String(cString: UnsafeRawPointer(field3!).assumingMemoryBound(to: CChar.self))
					if caseSensitive {
						if str3.contains(key0) && str3.contains(key1) && str3.contains(key2) {
							let globalModel = CodeGlobalModel(groupID: str0, identifier: str1, title: str2, code: str3, highlightIndex: Int(field4))
							globalModels.append(globalModel)
						}
					} else {
						if str3.lowercased().contains(key0.lowercased()) && str3.lowercased().contains(key1.lowercased())  && str3.lowercased().contains(key2.lowercased()) {
							let globalModel = CodeGlobalModel(groupID: str0, identifier: str1, title: str2, code: str3, highlightIndex: Int(field4))
							globalModels.append(globalModel)
						}
					}
				}
				sqlite3_finalize(statement)
			}
			if sqlite3_close(db) != SQLITE_OK {
				print("error closing database")
			}
			statement = nil
		} else {
			print("Database can't be opened.")
		}
		return globalModels
	}
		
	static func insertCodeSnippet(path: String, fieldtsecs: String, codetsecs: String, title: String, code: String, highlightindex: Int, version: String, imagePathString: String, urlString: String) {
		var statement: OpaquePointer? = nil
		if let db = openDatabase(path: path) {
			let sql = "INSERT INTO codechild (fieldtsecs, codetsecs, title, code, highlightindex, version, imagePathString, urlString) VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
			if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
				sqlite3_bind_text(statement, 1, fieldtsecs, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
				sqlite3_bind_text(statement, 2, codetsecs, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
				sqlite3_bind_text(statement, 3, title, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
				sqlite3_bind_text(statement, 4, code, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
				sqlite3_bind_int(statement, 5, Int32(highlightindex))
				sqlite3_bind_text(statement, 6, version, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
				sqlite3_bind_text(statement, 7, imagePathString, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
				sqlite3_bind_text(statement, 8, urlString, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
				
				if sqlite3_step(statement) == SQLITE_DONE {
					//print("DONE!!!")
				} else {
					print("UGGHH!!!")
					let errorMessage = String.init(cString: sqlite3_errmsg(db))
					print("Error: \(errorMessage)")
				}
				
				//sqlite3_step(statement)
				sqlite3_finalize(statement)
			}
			if sqlite3_close(db) != SQLITE_OK {
				print("error closing database")
			}
			statement = nil
		} else {
			print("Database can't be opened.")
		}
	}
	
	static func deleteCodeSnippets(path: String, groupTsecs: String) {
		var statement: OpaquePointer? = nil
		if let db = openDatabase(path: path) {
			let sql = "DELETE FROM codechild WHERE fieldtsecs = '\(groupTsecs)'"
			if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
				if sqlite3_step(statement) == SQLITE_DONE {
					//print("Successfully deleted row.")
				} else {
					print("Could not delete row.")
				}
				sqlite3_finalize(statement)
			}
			sqlite3_close(db)
			statement = nil
		} else {
			print("Database can't be opened.")
		}
	}
	
	static func deleteCodeSnippet(path: String, codeID: String) {
		var statement: OpaquePointer? = nil
		if let db = openDatabase(path: path) {
			let sql = "DELETE FROM codechild WHERE codetsecs = '\(codeID)'"
			if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
				if sqlite3_step(statement) == SQLITE_DONE {
					//print("Successfully deleted row.")
				} else {
					print("Could not delete row.")
				}
				sqlite3_finalize(statement)
			}
			sqlite3_close(db)
			statement = nil
		} else {
			print("Database can't be opened.")
		}
	}
		
	static func updateCodeSnippetAll(path: String, title: String, code: String, highlightindex: Int, version: String, imagePathString: String, urlString: String, codeID: String) {
		var statement: OpaquePointer? = nil
		if let db = openDatabase(path: path) {
			let sql = "UPDATE codechild SET title = ?, code = ?, highlightindex = ?, version = ?, imagePathString = ?, urlString = ? WHERE codetsecs = ?"
			if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
				sqlite3_bind_text(statement, 1, title, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
				sqlite3_bind_text(statement, 2, code, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
				sqlite3_bind_int(statement, 3, Int32(highlightindex))
				sqlite3_bind_text(statement, 4, version, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
				sqlite3_bind_text(statement, 5, imagePathString, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
				sqlite3_bind_text(statement, 6, urlString, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
				sqlite3_bind_text(statement, 7, codeID, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
				
				if sqlite3_step(statement) == SQLITE_DONE {
					//print("DONE!!!")
				} else {
					print("UGGHH!!!")
					let errorMessage = String.init(cString: sqlite3_errmsg(db))
					print("Error: \(errorMessage)")
				}
				
				//sqlite3_step(statement)
				sqlite3_finalize(statement)
			}
			sqlite3_close(db)
			statement = nil
		} else {
			print("Database can't be opened.")
		}
	}
	
	static func updateCodeSnippetTitle(path: String, title: String, codeID: String) {
		var statement: OpaquePointer? = nil
		if let db = openDatabase(path: path) {
			let sql = "UPDATE codechild SET title = ? WHERE codetsecs = ?"
			if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
				sqlite3_bind_text(statement, 1, title, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
				sqlite3_bind_text(statement, 2, codeID, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
				
				if sqlite3_step(statement) == SQLITE_DONE {
					//print("DONE!!!")
				} else {
					print("UGGHH!!!")
					let errorMessage = String.init(cString: sqlite3_errmsg(db))
					print("Error: \(errorMessage)")
				}
				
				//sqlite3_step(statement)
				sqlite3_finalize(statement)
			}
			sqlite3_close(db)
			statement = nil
		} else {
			print("Database can't be opened.")
		}
	}
	
	static func updateCodeSnippetPaths(path: String, imagePathString: String, codeID: String) {
		var statement: OpaquePointer? = nil
		if let db = openDatabase(path: path) {
			let sql = "UPDATE codechild SET imagePathString = ? WHERE codetsecs = ?"
			if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
				sqlite3_bind_text(statement, 1, imagePathString, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
				sqlite3_bind_text(statement, 2, codeID, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
				
				if sqlite3_step(statement) == SQLITE_DONE {
					//print("DONE!!!")
				} else {
					print("UGGHH!!!")
					let errorMessage = String.init(cString: sqlite3_errmsg(db))
					print("Error: \(errorMessage)")
				}
				
				//sqlite3_step(statement)
				sqlite3_finalize(statement)
			}
			sqlite3_close(db)
			statement = nil
		} else {
			print("Database can't be opened.")
		}
	}
	
	static func updateCodeSnippetHighlight(path: String, highlightindex: Int, codeID: String) {
		var statement: OpaquePointer? = nil
		if let db = openDatabase(path: path) {
			let sql = "UPDATE codechild SET highlightindex = ? WHERE codetsecs = ?"
			if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
				sqlite3_bind_int(statement, 1, Int32(highlightindex))
				sqlite3_bind_text(statement, 2, codeID, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
				
				if sqlite3_step(statement) == SQLITE_DONE {
					//print("DONE!!!")
				} else {
					print("UGGHH!!!")
					let errorMessage = String.init(cString: sqlite3_errmsg(db))
					print("Error: \(errorMessage)")
				}
				
				//sqlite3_step(statement)
				sqlite3_finalize(statement)
			}
			sqlite3_close(db)
			statement = nil
		} else {
			print("Database can't be opened.")
		}
	}
	
	static func updateCodeSnippetVersion(path: String, version: String, codeID: String) {
		var statement: OpaquePointer? = nil
		if let db = openDatabase(path: path) {
			let sql = "UPDATE codechild SET version = ? WHERE codetsecs = ?"
			if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
				sqlite3_bind_text(statement, 1, version, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
				sqlite3_bind_text(statement, 2, codeID, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
				
				if sqlite3_step(statement) == SQLITE_DONE {
					//print("DONE!!!")
				} else {
					print("UGGHH!!!")
					let errorMessage = String.init(cString: sqlite3_errmsg(db))
					print("Error: \(errorMessage)")
				}
				
				//sqlite3_step(statement)
				sqlite3_finalize(statement)
			}
			sqlite3_close(db)
			statement = nil
		} else {
			print("Database can't be opened.")
		}
	}
	
	static func updateCodeSnippetsAllVersion(path: String, version: String, groupID: String) {
		var statement: OpaquePointer? = nil
		if let db = openDatabase(path: path) {
			let sql = "UPDATE codechild SET version = ? WHERE fieldtsecs = ?"
			if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
				sqlite3_bind_text(statement, 1, version, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
				sqlite3_bind_text(statement, 2, groupID, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
				
				if sqlite3_step(statement) == SQLITE_DONE {
					//print("DONE!!!")
				} else {
					print("UGGHH!!!")
					let errorMessage = String.init(cString: sqlite3_errmsg(db))
					print("Error: \(errorMessage)")
				}
				
				//sqlite3_step(statement)
				sqlite3_finalize(statement)
			}
			sqlite3_close(db)
			statement = nil
		} else {
			print("Database can't be opened.")
		}
	}
	
	static func updateCodeSnippetVersion(path: String, version: String, groupID: String) {
		var statement: OpaquePointer? = nil
		if let db = openDatabase(path: path) {
			let sql = "UPDATE codechild SET version = ? WHERE fieldtsecs = ?"
			if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
				sqlite3_bind_text(statement, 1, version, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
				sqlite3_bind_text(statement, 2, groupID, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
				
				if sqlite3_step(statement) == SQLITE_DONE {
					//print("DONE!!!")
				} else {
					print("UGGHH!!!")
					let errorMessage = String.init(cString: sqlite3_errmsg(db))
					print("Error: \(errorMessage)")
				}
				
				//sqlite3_step(statement)
				sqlite3_finalize(statement)
			}
			sqlite3_close(db)
			statement = nil
		} else {
			print("Database can't be opened.")
		}
	}
	
	static func changeCodeSnippetGroup(path: String, groupID: String, codeID: String) {
		var statement: OpaquePointer? = nil
		if let db = openDatabase(path: path) {
			let sql = "UPDATE codechild SET fieldtsecs = ? WHERE codetsecs = ?"
			if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
				sqlite3_bind_text(statement, 1, groupID, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
				sqlite3_bind_text(statement, 2, codeID, -1, unsafeBitCast(-1, to: sqlite3_destructor_type.self))
				
				if sqlite3_step(statement) == SQLITE_DONE {
					//print("DONE!!!")
				} else {
					print("UGGHH!!!")
					let errorMessage = String.init(cString: sqlite3_errmsg(db))
					print("Error: \(errorMessage)")
				}
				
				//sqlite3_step(statement)
				sqlite3_finalize(statement)
			}
			sqlite3_close(db)
			statement = nil
		} else {
			print("Database can't be opened.")
		}
	}
	
	static func countSnippets(path: String) -> Int? {
		var statement: OpaquePointer? = nil
		if let db = openDatabase(path: path) {
			let sql = "SELECT COUNT(*) FROM codechild"
			if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
				if(sqlite3_step(statement) == SQLITE_ROW) {
					let r = sqlite3_column_int(statement, 0)
					sqlite3_finalize(statement)
					sqlite3_close(db)
					statement = nil
					return Int(r)
				}
			}
			sqlite3_close(db)
			statement = nil
		} else {
			print("Database can't be opened.")
		}
		return nil
	}
	
	static func countSnippetData(path: String, fieldtsecs: String) -> Int? {
		var statement: OpaquePointer? = nil
		if let db = openDatabase(path: path) {
			let sql = "SELECT COUNT(*) FROM codechild WHERE fieldtsecs='\(fieldtsecs)'"
			if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
				if(sqlite3_step(statement) == SQLITE_ROW) {
					let r = sqlite3_column_int(statement, 0)
					sqlite3_finalize(statement)
					sqlite3_close(db)
					statement = nil
					return Int(r)
				}
			}
			sqlite3_close(db)
			statement = nil
		} else {
			print("Database can't be opened.")
		}
		return nil
	}
}

