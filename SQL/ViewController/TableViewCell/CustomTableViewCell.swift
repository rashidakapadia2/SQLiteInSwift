//
//  CustomTableViewCell.swift
//  SQL
//
//  Created by Neosoft on 25/05/22.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

   
    @IBOutlet weak var imgPicDisplay: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    
    @IBOutlet weak var lblAge: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(name: String, email: String, number: String, age: Int, pic: Data) {
        lblName.text = name
        lblEmail.text = email
        lblNumber.text = number
        lblAge.text = "\(age)"
        imgPicDisplay.image = UIImage(data: pic)
    }
    
}
