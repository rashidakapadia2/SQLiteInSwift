//
//  FormViewController.swift
//  SQL
//
//  Created by Neosoft on 24/05/22.
//

import UIKit

class FormViewController: UIViewController {
    //MARK:- IBOutlets
    @IBOutlet weak var imgPic: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtNumber: UITextField!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    
    var isUpdateUserData: Bool = false
    var id: Int?
    var user: User = User()
    
    lazy var viewModel: FormViewModelType = FormViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSave.buttonDecor()
        setUpNavBar()
        tapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isUpdateUserData {
            txtName.text = user.name
            txtEmail.text = user.email
            txtNumber.text = user.number
            txtAge.text = "\(user.age!)"
        }
    }
    
    func tapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped(gestureRecognizer:)))
        imgPic.isUserInteractionEnabled = true
        imgPic.addGestureRecognizer(tap)
    }
    @objc func imgTapped(gestureRecognizer: UITapGestureRecognizer) {
        print("IMG TAPPED")
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true)
    }
    
    @IBAction func btnTapped(_ sender: Any) {
        let img = imgPic.image
        let imgData : Data = (img?.pngData())!
        let imgString = imgData.base64EncodedString()
        if validation() {
            if isUpdateUserData {
                let dataModel = sendingDataToModel(id: id!, name: txtName.text ?? "", num: txtNumber.text ?? "", mail: txtEmail.text ?? "", age: Int(txtAge.text!) ?? 0, pic: imgString)
                let tableDataModel = viewModel.convertDataToModel(isUpdatingData: isUpdateUserData, user: dataModel)
                viewModel.updateTableDataInDatabase(model: tableDataModel, success: { print("DATA UPDATED SUCCESSFULLY") }){ err in
                    print(err)
                }
            }
            else{
                let dataModel = sendingDataToModel(id: nil, name: txtName.text ?? "", num: txtNumber.text ?? "", mail: txtEmail.text ?? "", age: Int(txtAge.text!) ?? 0, pic: imgString)
                let tableDataModel = viewModel.convertDataToModel(isUpdatingData: isUpdateUserData, user: dataModel)
                viewModel.insertTableDataInDatabase(model: tableDataModel, success: { print("DATA INSERTED SUCCESSFULLY") }){ err in
                    print(err)
                }
            }
        }
        else {
            //MARK:- Alert
            showGeneralAlert()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func validation() -> Bool {
        if ((txtName.text?.isEmpty) == true) {
            return false
        }
        //        else if ((txtEmail.text?.isEmpty) == true) {
        //            return false
        //        }else if ((txtNumber.text?.isEmpty) == true) {
        //            return false
        //        }
        //        else if ((txtAge.text?.isEmpty) == true) {
        //            return false
        //        }
        //        else if isValidEmail(email: txtEmail.text!) == false {
        //            return false
        //        }
        //        else if isValidNumber(number: txtNumber.text!) == false {
        //            return false
        //        }
        //        else if isValidNumber(number: txtAge.text!) == false {
        //            return false
        //        }
        //        else if imgPic.image == UIImage(systemName: "photo.artframe") {
        //            print("IMG NOT THERE")
        //            return false
        //        }
        return true
    }
}

//MARK:- ImagePickerDelegate
extension FormViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imagePicker = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imgPic.image = imagePicker
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
