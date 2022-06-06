//
//  CommonEnums.swift
//  SQL
//
//  Created by Neosoft on 01/06/22.
//

import Foundation

enum Tables {
    case userTable, otherTable, someOtherTable, productTable, UserInformation
}

enum ColumnTypes: String {
    case text = "Text"
    case int = "Int"
}

enum ColumnsForUserTable: Int {
    case id = 0, name, number, email, age, pic

//    var position: Int{
//        switch self {
//        case .id:
//            return 0
//        case .name:
//            return 1
//        case .number:
//            return 2
//        case .email:
//            return 3
//        case .age:
//            return 4
//        case .pic:
//            return 5
//        }
//    }
}

enum SQLiteQueryKeywords: String {
    case WHERE = "WHERE"
    case LIKE = "LIKE"
    case LIMIT = "LIMIT"
    case IN = "IN"
}
