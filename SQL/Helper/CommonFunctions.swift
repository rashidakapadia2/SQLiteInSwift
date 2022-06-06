//
//  CommonFunctions.swift
//  SQL
//
//  Created by Neosoft on 26/05/22.
//

import Foundation

func isValidEmail(email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: email)
}

func isValidPassword(password: String) -> Bool {
    let passwordRegex = "^(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{2,64}"
    let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
    return passwordTest.evaluate(with: password)
}

func isValidNumber(number: String) -> Bool {
    let numberRegEx = "^([0-9]*)$"
    let numberTest = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
    return numberTest.evaluate(with: number)
}

func sendingDataToModel(id: Int?, name: String, num: String, mail: String, age: Int, pic: String) -> User {
    var user = User()
    user.id = id
    user.name = name
    user.number = num
    user.email = mail
    user.age = age
    user.pic = pic
    return user
}
