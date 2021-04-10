//
//  EditProfilePresenter.swift
//  communityApplication
//
//  Created by Om on 08/04/21.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import SVProgressHUD


protocol EditProfileViewPresenter: class {
    func saveSuccessfully()
}

class EditProfilePresenter {
    
    weak var view: EditProfileViewPresenter?
    let db = Firestore.firestore()
    var postData = [PostModel]()
    var user: UserModel = UserModel()
    
    init(with view: EditProfileViewPresenter) {
        self.view = view
    }
    func storeImage(userName: String,image: UIImageView) {
        let storageRef = Storage.storage().reference().child("user_profiles/\(Auth.auth().currentUser?.uid ?? "")_\(Date().timeIntervalSince1970).png")
        
        if let uploadData = image.image!.pngData(){
            _ = storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    print(error?.localizedDescription ?? "")
                    SVProgressHUD.dismiss()
                    return
                }
                print(metadata)
                storageRef.downloadURL { [self] (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        SVProgressHUD.dismiss()
                        return
                    }
                    print(downloadURL.absoluteString)
                    self.saveEditChangesOfUser(userName: userName,imageUrl: downloadURL.absoluteString)
                }
            }
        }
    }
    func saveEditChangesOfUser(userName: String,imageUrl:String = "") {
        var dataArray = [String: Any]()
        if imageUrl == "" {
            dataArray = ["name": userName]
        }else {
            dataArray = ["name": userName,
                         "profileImage": imageUrl
            ]
        }
        self.db.collection("users").document(Auth.auth().currentUser?.uid ?? "").updateData(dataArray)
    }
}
