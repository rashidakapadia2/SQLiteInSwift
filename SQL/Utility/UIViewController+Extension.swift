//
//  UIViewController+Extension.swift
//  SQL
//
//  Created by Neosoft on 26/05/22.
//

import Foundation
import UIKit

extension UIViewController {
    //Alert with Title, Message and dismiss button
    func showGeneralAlert() {
        let alert = UIAlertController(title: "Please fill all fields", message: "There was some error, please try again", preferredStyle: .alert )
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true)
    }
    
    func setUpNavBar() {
        self.navigationController?.navigationItem.backButtonTitle = " "
    }
}
