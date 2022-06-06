//
//  SQLite.swift
//  SQL
//
//  Created by Neosoft on 24/05/22.
//

import Foundation
import SQLite3

typealias SuccessClosure = ([[TableDataModel]]) -> ()
public typealias GeneralClosure = () -> ()
public typealias ErrorClosure = (_ err: String) -> ()

open class DatabaseManager {
    
    fileprivate var db: OpaquePointer? = nil
    fileprivate var statement : OpaquePointer? = nil
    fileprivate var readConnection : OpaquePointer? = nil
    fileprivate var updateConnection : OpaquePointer? = nil
    fileprivate var writeConnection : OpaquePointer? = nil
    fileprivate var deleteConnection : OpaquePointer? = nil
    
    
    fileprivate var path: String = "UserDatabase"
    fileprivate var extention: String = "sqlite3"
    fileprivate var tableName: String = "UserInformation"
    
    static let shared = DatabaseManager()
    
    private init() {
        //MARK:- Creating Database upon initialization
        self.db = createDB()
    }
    //MARK:- To close file after deinitializaion
    deinit {
        print("DEINIT")
        closeDatabase()
    }
    
    //MARK:- Closing database
    func closeDatabase() {
        if (sqlite3_close(readConnection) == SQLITE_OK) {
            readConnection = nil
        }
        if (sqlite3_close(writeConnection) == SQLITE_OK) {
            writeConnection = nil
        }
        if (sqlite3_close(updateConnection) == SQLITE_OK) {
            updateConnection = nil
        }
        if (sqlite3_close(deleteConnection) == SQLITE_OK) {
            deleteConnection = nil
            statement = nil
            db = nil
        }
    }
    
    //MARK:- Getting DatabaseName
    open func getDatabaseName(name: String, extnsn: String){
        path = name
        extention = extnsn
    }
    //MARK:- Setting DatabaseName
    private func setDatabaseName() -> String {
        return path+"."+extention
    }
    //MARK:- Getting tableName
    open func getTableName(name: String){
        tableName = name
    }
    
    /* MARK:-
     * Method name: Create Database
     * Description:
     * Parameters: nil
     * Return: pointer
     */
    private func createDB() -> OpaquePointer? {
        var filePath: URL?
        do {
            filePath = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(setDatabaseName())
            print("FilePath created successfully")
            print(filePath)
        } catch {
            print("FilePath not created")
        }
        if sqlite3_open(filePath?.path, &db) == SQLITE_OK {
            print("Database created")
            return db
        }else{
            print("There was an error in creating database")
            return nil
        }
    }
    
    /* MARK:-
     * Method name: Create table inside database
     * Description: It is creating table based on QueryModel and custom model
     * Parameters: tblName(param takes name of table),columns(param takes array of struct QueryModel),
                    success(param is a closure), failure(param is a closure)
     * Return: nil
     */
    func createTable(tblName: String, columns: [QueryModel], success: @escaping GeneralClosure, failure: @escaping ErrorClosure) {
        var query = "CREATE TABLE IF NOT EXISTS \(tblName) ("
        var takeCount = 1
        for column in columns{
            let autoIncrement = "PRIMARY KEY AUTOINCREMENT"
            let primaryKeyConstraint = (column.key ? "" : "" )
            
            let string = column.column_name + " \(column.column_type.rawValue) " + primaryKeyConstraint
            query.append(contentsOf: string)
            if takeCount != columns.count {
                query.append(contentsOf: ",")
            }
            takeCount += 1
        }
        query.append(contentsOf: ");")
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                success()
            }else {
                failure("Table creation fail")
            }
        } else {
            failure("Table Preparation fail")
        }
    }
    
    /* MARK:-
     * Method name: Update data
     * Description: Func to update data
     * Parameters: tblName(param takes name of table),columns(param takes array of struct TableDataModel),
                    position(param takes position of column on which data is updated),
                    success(param is a closure), failure(param is a closure)
     * Return: nil
     */
    func updateDataInSQLite(tblName: String, columns: [TableDataModel], position: Int, success: @escaping GeneralClosure, failure: @escaping ErrorClosure) {
        //            let query = "UPDATE UserInformation SET name = '\(name)', number = '\(number)', email = '\(email)', age = '\(age)', pic = '\(pic)' WHERE id = '\(id)';"
        var query = "UPDATE \(tableName) SET "
        for column in columns {
            if column.column_name.rawValue == position {
                continue
            }
            let col_name = column.column_name
            let col_val = column.value
            if column.column_type == .int {
                query.append(contentsOf: "\(col_name) = \(col_val)")
            }
            else{
                query.append(contentsOf: "\(col_name) = '\(col_val)'")
            }
            if column.column_name != columns[columns.count-1].column_name {
                query.append(contentsOf: ", ")
            }
            
        }
        query.append(contentsOf: " WHERE \(columns[position].column_name) = '\(columns[position].value)';")
        if sqlite3_prepare_v2(db, query, -1, &updateConnection, nil) == SQLITE_OK{
            if sqlite3_step(updateConnection) == SQLITE_DONE {
                success()
            }else {
                failure("Data is not updated in table")
            }
        }else{
            failure("Query is not as per requirement")
        }
        sqlite3_finalize(updateConnection)
    }
    
    /* MARK:-
     * Method name: Delete data
     * Description: Func to delete data
     * Parameters: tblName(param takes name of table),lastHalfQuery(param takes string),
                    success(param is a closure), failure(param is a closure)
     * Return: nil
     */
    func deleteDataFromSQLite(tblName: String, lastHalfQuery: String, success: @escaping GeneralClosure, failure: @escaping ErrorClosure) {
        let query = "DELETE FROM \(tableName) \(lastHalfQuery);"
    
        if sqlite3_prepare_v2(db, query, -1, &deleteConnection, nil) == SQLITE_OK{
            if sqlite3_step(deleteConnection) == SQLITE_DONE {
                success()
            }else {
                failure("Data is not deleted in table")
            }
        }else{
            failure("Query is not as per requirement")
        }
        sqlite3_finalize(deleteConnection)
    }
    
    /* MARK:-
     * Method name: Insert data
     * Description: Func to insert data
     * Parameters: tblName(param takes name of table),columns(param takes array of struct TableDataModel),
                    success(param is a closure), failure(param is a closure)
     * Return: nil
     */
    func insertDataInSQLite(tblName: String,columns: [TableDataModel], success: @escaping GeneralClosure, failure: @escaping ErrorClosure) {
        var query = "INSERT INTO \(tableName) ("
        
        for column in columns {
            let string = "\(column.column_name)"
            query.append(contentsOf: string)
            if column.column_name != columns[columns.count-1].column_name {
                query.append(contentsOf: ", ")
            }
        }
        query.append(contentsOf: ") VALUES (")
        
        for column in columns {
            let string = "\(column.value)"
            if column.column_type == .int {
                query.append(contentsOf: "\(string)")
            }
            else{
                query.append(contentsOf: "'\(string)'")
            }
            if column.column_name != columns[columns.count-1].column_name {
                query.append(contentsOf: ", ")
            }
        }
        query.append(contentsOf: ");")
        
        print(query)
        
        if sqlite3_prepare_v2(db, query, -1, &writeConnection, nil) == SQLITE_OK {
            
            if sqlite3_step(writeConnection) == SQLITE_DONE {
                success()
            }
            else {
                failure("Data is not inserted in table")
            }
        } else {
            failure("Query is not as per requirement")
        }
        sqlite3_finalize(writeConnection)
    }
    
    /* MARK:-
     * Method name: Read data
     * Description: Func to read data
     * Parameters: tblName(param takes name of table),columns(param takes array of struct TableDataModel),
                    success(param is a closure), failure(param is a closure)
     * Return: nil
     */
    func readDataFromSQLite(tblName: String,columns: [TableDataModel],successClosure: @escaping SuccessClosure, errorClosure: @escaping ErrorClosure) {
        var mainList = [[TableDataModel]]()
        
        let query = "SELECT * FROM \(tableName);"
        
        if sqlite3_prepare_v2(db, query, -1, &readConnection, nil) == SQLITE_OK{
            while sqlite3_step(readConnection) == SQLITE_ROW {
                
                var dataArray = [TableDataModel]()
                
                for column in columns {
                    var data: TableDataModel = column
                    let position = column.column_name.rawValue
                    
                    switch column.column_type {
                    case .text:
                        let val = String(describing: String(cString: sqlite3_column_text(readConnection, Int32(position))))
                        data.value = val
                    case .int:
                        let val = Int(sqlite3_column_int(readConnection, Int32(position)))
                        data.value = String(val)
                    }
                    dataArray.append(data)
                }
                mainList.append(dataArray)
            }
        }
        sqlite3_finalize(readConnection)
        successClosure(mainList)
    }
    
    /* MARK:-
     * Method name: Filter data
     * Description: Func to filter data
     * Parameters: tblName(param takes name of table),columns(param takes array of struct TableDataModel),
                    success(param is a closure), failure(param is a closure)
     * Return: nil
     */
    func filterDataFromSQLite(tblName: String,lastHalfQuery: String, columns: [TableDataModel],successClosure: @escaping SuccessClosure, errorClosure: @escaping ErrorClosure) {
        var mainList = [[TableDataModel]]()
        
        let query = "SELECT * FROM \(tableName) \(lastHalfQuery);"
        print(query)
        
        if sqlite3_prepare_v2(db, query, -1, &readConnection, nil) == SQLITE_OK{
            while sqlite3_step(readConnection) == SQLITE_ROW {
                
                var dataArray = [TableDataModel]()
                
                for column in columns {
                    var data: TableDataModel = column
                    let position = column.column_name.rawValue
                    
                    switch column.column_type {
                    case .text:
                        let val = String(describing: String(cString: sqlite3_column_text(readConnection, Int32(position))))
                        data.value = val
                    case .int:
                        let val = Int(sqlite3_column_int(readConnection, Int32(position)))
                        data.value = String(val)
                    }
                    dataArray.append(data)
                }
                mainList.append(dataArray)
            }
        }
        sqlite3_finalize(readConnection)
        successClosure(mainList)
    }
    
    /* MARK:-
     * Method name: Filter data
     * Description: Func to filter data
     * Parameters: tblName(param takes name of table),columns(param takes array of struct TableDataModel),
                    success(param is a closure), failure(param is a closure)
     * Return: nil
     */
    func paginationInSQLite(tblName: String,lastHalfQuery: String, columns: [TableDataModel],successClosure: @escaping SuccessClosure, errorClosure: @escaping ErrorClosure) {
        var mainList = [[TableDataModel]]()
        
        let query = "SELECT * FROM \(tableName) \(lastHalfQuery) "
        print(query)
        
        if sqlite3_prepare_v2(db, query, -1, &readConnection, nil) == SQLITE_OK{
            while sqlite3_step(readConnection) == SQLITE_ROW {
                
                var dataArray = [TableDataModel]()
                
                for column in columns {
                    var data: TableDataModel = column
                    let position = column.column_name.rawValue
                    
                    switch column.column_type {
                    case .text:
                        let val = String(describing: String(cString: sqlite3_column_text(readConnection, Int32(position))))
                        data.value = val
                    case .int:
                        let val = Int(sqlite3_column_int(readConnection, Int32(position)))
                        data.value = String(val)
                    }
                    dataArray.append(data)
                }
                mainList.append(dataArray)
            }
        }
        sqlite3_finalize(readConnection)
        print(mainList)
            successClosure(mainList)
    }
}
