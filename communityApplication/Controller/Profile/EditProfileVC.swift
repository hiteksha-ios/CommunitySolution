//
//  EditProfileVc.swift
//  communityApplication
//
//  Created by Om on 03/04/21.
//

import UIKit
import Kingfisher
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SVProgressHUD

class EditProfileVC: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameTextField: customUITextField!
    @IBOutlet weak var emailTextField: customUITextField!
    
    lazy var presenter = EditProfilePresenter(with: self)
    var imagePicker = UIImagePickerController()
    var userInfo: UserModel?
    var isimageChange: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
        profileImageView.kf.setImage(with: URL(string: self.userInfo?.profileImage ?? ""),placeholder: UIImage(named: "profile_place"))
        usernameTextField.text = self.userInfo?.name ?? ""
        emailTextField.text = self.userInfo?.email ?? ""
        emailTextField.isEnabled = false

    }
    @IBAction func onProfileChangeButton(_ sender: Any) {
        imagePicker.modalPresentationStyle = UIModalPresentationStyle.currentContext
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func onSaveButtonClick(_ sender: Any) {
        if usernameTextField.text?.isEmpty ?? true {
            self.popupAlert(title: "Alert", message: "Please add name", actionTitles: ["Okay"], actions:[{action1 in
                self.dismiss(animated: true, completion: nil)
            }])
            return
        }
        if isimageChange {
            SVProgressHUD.show(withStatus: "Uploading..")
            presenter.storeImage(userName: usernameTextField.text ?? "", image: profileImageView)
            return
        }
        presenter.saveEditChangesOfUser(userName: usernameTextField.text ?? "")
    }
}


extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        isimageChange = true
        let tempImage:UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        profileImageView.image  = tempImage
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.dismiss(animated: true, completion: nil)
    }
}


extension EditProfileVC: EditProfileViewPresenter {
    func saveSuccessfully() {
        self.navigationController?.popViewController(animated: true)
    }
}
