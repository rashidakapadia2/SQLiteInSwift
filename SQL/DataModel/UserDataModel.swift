//
//  UserDataModel.swift
//  SQL
//
//  Created by Neosoft on 24/05/22.
//

import Foundation
import SQLite3

struct User {
    var id: Int?
    var name: String?
    var number: String?
    var email: String?
    var age: Int?
    var pic: String?
    
    mutating func mapDataFromTableModel(tableModel: [TableDataModel]){
        self.id = Int(tableModel[ColumnsForUserTable.id.rawValue].value)
        self.name = tableModel[ColumnsForUserTable.name.rawValue].value
        self.number = tableModel[ColumnsForUserTable.number.rawValue].value
        self.email = tableModel[ColumnsForUserTable.email.rawValue].value
        self.age = Int(tableModel[ColumnsForUserTable.age.rawValue].value)
        self.pic = tableModel[ColumnsForUserTable.pic.rawValue].value
    }
}
