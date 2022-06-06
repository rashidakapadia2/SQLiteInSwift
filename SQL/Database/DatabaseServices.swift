//
//  DatabaseServices.swift
//  SQL
//
//  Created by Neosoft on 24/05/22.
//

import Foundation
import SQLite3

protocol DatabaseServicesType {
    func insertDataInDatabase(userInfo: [TableDataModel],success: @escaping GeneralClosure, failure: @escaping ErrorClosure)
    func updateDataInDatabase(userInfo: [TableDataModel],success: @escaping GeneralClosure, failure: @escaping ErrorClosure)
    func deleteDataInDatabase(lastHalfQuery: String,success: @escaping GeneralClosure, failure: @escaping ErrorClosure)
    func readDataFromDatabase(success: @escaping ([[TableDataModel]]) -> (), failure: @escaping ErrorClosure)
    func filterDataInDatabase(lastHalfQuery: String, success: @escaping SuccessClosure, failure: @escaping ErrorClosure)
    func paginationOfDataInDatabase(lastHalfQuery: String, success: @escaping SuccessClosure, failure: @escaping ErrorClosure)
}

class DatabaseServices: DatabaseServicesType {
    private init() {
        createTableInDatabase()
    }
    static let shared = DatabaseServices()
    let tableName: String = "\(Tables.UserInformation)"
    private var updateParameter = ColumnsForUserTable.id.rawValue
    private let paramName = "\(ColumnsForUserTable.id)"
    
    //Setting structure to create table
    private let userTable = [
        QueryModel(column_name: "id",column_type: .int,key: true),
        QueryModel(column_name: "name",column_type: .text,key: false),
        QueryModel(column_name: "number",column_type: .text,key: false),
        QueryModel(column_name: "email",column_type: .text,key: false),
        QueryModel(column_name: "age",column_type: .int,key: false),
        QueryModel(column_name: "pic",column_type: .text,key: false)
    ]
    
    //Setting structure to pass data
    private let userInformation = [
        TableDataModel(column_name: .id, column_type: .int, value: ""),
        TableDataModel(column_name: ColumnsForUserTable.name, column_type: .text, value: ""),
        TableDataModel(column_name: ColumnsForUserTable.number, column_type: .text, value: ""),
        TableDataModel(column_name: ColumnsForUserTable.email, column_type: .text, value: ""),
        TableDataModel(column_name: ColumnsForUserTable.age, column_type: .int, value: ""),
        TableDataModel(column_name: ColumnsForUserTable.pic, column_type: .text, value: "")
    ] as [TableDataModel]
    
    private func createTableInDatabase() {
        DatabaseManager.shared.createTable(tblName: "\(tableName)", columns: userTable) {
            print("Table creation success")
        } failure: { err in
            print(err)
        }
    }
    func insertDataInDatabase(userInfo: [TableDataModel],success: @escaping GeneralClosure, failure: @escaping ErrorClosure) {
        DatabaseManager.shared.insertDataInSQLite(tblName: "\(tableName)",columns: userInfo, success: success, failure: failure)
    }
    func updateDataInDatabase(userInfo: [TableDataModel],success: @escaping GeneralClosure, failure: @escaping ErrorClosure){
        DatabaseManager.shared.updateDataInSQLite(tblName: "\(tableName)",columns: userInfo, position: updateParameter, success: success, failure: failure)
    }
    func deleteDataInDatabase(lastHalfQuery: String,success: @escaping GeneralClosure, failure: @escaping ErrorClosure){
        DatabaseManager.shared.deleteDataFromSQLite(tblName: "\(tableName)",lastHalfQuery: "\(lastHalfQuery)", success: success, failure: failure)
    }
    func readDataFromDatabase(success: @escaping SuccessClosure, failure: @escaping ErrorClosure){
        DatabaseManager.shared.readDataFromSQLite(tblName: "\(tableName)",columns: userInformation,successClosure: success, errorClosure: failure)
    }
    func filterDataInDatabase(lastHalfQuery: String, success: @escaping SuccessClosure, failure: @escaping ErrorClosure){
        DatabaseManager.shared.filterDataFromSQLite(tblName: "\(tableName)", lastHalfQuery: lastHalfQuery, columns: userInformation, successClosure: success, errorClosure: failure)
    }
    func paginationOfDataInDatabase(lastHalfQuery: String, success: @escaping SuccessClosure, failure: @escaping ErrorClosure){
        DatabaseManager.shared.paginationInSQLite(tblName: "\(tableName)", lastHalfQuery: lastHalfQuery, columns: userInformation, successClosure: success, errorClosure: failure)
    }
}

