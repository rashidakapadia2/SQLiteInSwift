//
//  TableModel.swift
//  SQL
//
//  Created by Neosoft on 26/05/22.
//

import Foundation


struct QueryModel {
    var column_name: String
    var column_type: ColumnTypes
    var key: Bool
}

struct TableDataModel {
    var column_name: ColumnsForUserTable
    var column_type: ColumnTypes
    var value: String
}






