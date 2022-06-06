//
//  UIButton + Extension.swift
//  SQL
//
//  Created by Neosoft on 26/05/22.
//

import Foundation
import UIKit

extension UIButton {
    func buttonDecor() {
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.white.cgColor
    }
}

