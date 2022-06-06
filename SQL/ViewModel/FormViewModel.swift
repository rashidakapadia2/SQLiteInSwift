//
//  FormViewModel.swift
//  SQL
//
//  Created by Neosoft on 27/05/22.
//

import Foundation
import UIKit

protocol ViewModelType {
    func convertDataToModel(isUpdatingData: Bool,user: User) -> [TableDataModel]
    func deleteTableDataFromDatabase(id: Int, success: @escaping GeneralClosure, failure: @escaping ErrorClosure)
    func readTableDataFromDatabase( success: @escaping ([[TableDataModel]]) -> (), failure: @escaping ErrorClosure)
    func filterTableDataInDatabase(col_pos: String, col_val: String ,success: @escaping SuccessClosure, failure: @escaping ErrorClosure)
    func ageFilter(col_name: String ,success: @escaping SuccessClosure, failure: @escaping ErrorClosure)
    func paginationTableDataInDatabase(pageNo: Int, cellQnty: Int ,success: @escaping SuccessClosure, failure: @escaping ErrorClosure)
    func paginationIndexArray(idx: Int)
    func getPaginationIndexArray() -> [Int]
    var paginationIdxArr: [Int] { get set }
}
protocol FormViewModelType {
    func insertTableDataInDatabase(model: [TableDataModel], success: @escaping GeneralClosure, failure: @escaping ErrorClosure)
    func updateTableDataInDatabase(model: [TableDataModel], success: @escaping GeneralClosure, failure: @escaping ErrorClosure)
    func convertDataToModel(isUpdatingData: Bool,user: User) -> [TableDataModel]
}

class FormViewModel: ViewModelType,FormViewModelType {
    lazy var databaseService: DatabaseServicesType = DatabaseServices.shared
    
    //Custom delete query
//    private var lastHalfQuery: String = "id ="
//    private var filterLastHalfQuery: String = "LIKE"
//    private var paginationLastHalfQuery: String = "LIMIT "
    var paginationIdxArr = [Int](arrayLiteral: 0)
    
    //TableDataModel(column_name: ColumnsForUserTable.id, column_type: .int, value: "\(user.id ?? 0)"),
    func convertDataToModel(isUpdatingData: Bool,user: User) -> [TableDataModel]{
        if !isUpdatingData {
            let userInfo = [TableDataModel(column_name: ColumnsForUserTable.name, column_type: .text, value: user.name ?? ""),
                            TableDataModel(column_name: ColumnsForUserTable.number, column_type: .text, value: user.number ?? ""),
                            TableDataModel(column_name: ColumnsForUserTable.email, column_type: .text, value: user.email ?? ""),
                            TableDataModel(column_name: ColumnsForUserTable.age, column_type: .int, value: "\(user.age!)"),
                            TableDataModel(column_name: ColumnsForUserTable.pic, column_type: .text, value: user.pic ?? "")
            ] as [TableDataModel]
            return userInfo
        }
        else {
            let userInfo = [TableDataModel(column_name: ColumnsForUserTable.id, column_type: .int, value: "\(user.id ?? 0)"),
                            TableDataModel(column_name: ColumnsForUserTable.name, column_type: .text, value: user.name ?? ""),
                            TableDataModel(column_name: ColumnsForUserTable.number, column_type: .text, value: user.number ?? ""),
                            TableDataModel(column_name: ColumnsForUserTable.email, column_type: .text, value: user.email ?? ""),
                            TableDataModel(column_name: ColumnsForUserTable.age, column_type: .int, value: "\(user.age!)"),
                            TableDataModel(column_name: ColumnsForUserTable.pic, column_type: .text, value: user.pic ?? "")
            ] as [TableDataModel]
            return userInfo
        }
    }
    
    func insertTableDataInDatabase(model: [TableDataModel], success: @escaping GeneralClosure, failure: @escaping ErrorClosure){
        databaseService.insertDataInDatabase(userInfo: model, success: success, failure: failure)
    }
    func updateTableDataInDatabase(model: [TableDataModel], success: @escaping GeneralClosure, failure: @escaping ErrorClosure){
        databaseService.updateDataInDatabase(userInfo: model, success: success, failure: failure)
    }
    func deleteTableDataFromDatabase(id: Int, success: @escaping GeneralClosure, failure: @escaping ErrorClosure){        databaseService.deleteDataInDatabase(lastHalfQuery: "\(SQLiteQueryKeywords.WHERE.rawValue) id= \(id)", success: success, failure: failure)
    }
    func readTableDataFromDatabase( success: @escaping SuccessClosure, failure: @escaping ErrorClosure){
        databaseService.readDataFromDatabase(success: success, failure: failure)
    }
    func filterTableDataInDatabase(col_pos: String, col_val: String ,success: @escaping SuccessClosure, failure: @escaping ErrorClosure){
        databaseService.filterDataInDatabase(lastHalfQuery: "\(SQLiteQueryKeywords.WHERE.rawValue) \(col_pos) \(SQLiteQueryKeywords.LIKE.rawValue) '%\(col_val)%'", success: success, failure: failure)
    }
    func ageFilter(col_name: String ,success: @escaping SuccessClosure, failure: @escaping ErrorClosure){
        databaseService.filterDataInDatabase(lastHalfQuery: "\(SQLiteQueryKeywords.WHERE.rawValue) \(col_name) >= 18", success: success, failure: failure)
    }
    func paginationTableDataInDatabase(pageNo: Int, cellQnty: Int ,success: @escaping SuccessClosure, failure: @escaping ErrorClosure){
        databaseService.paginationOfDataInDatabase(lastHalfQuery: "\(SQLiteQueryKeywords.WHERE.rawValue) \(pageNo),\(cellQnty)", success: success, failure: failure)
    }
    
   func paginationIndexArray(idx: Int){
        print(paginationIdxArr)
        paginationIdxArr.append(idx)
    }
    func getPaginationIndexArray() -> [Int] {
       return paginationIdxArr
    }
}

