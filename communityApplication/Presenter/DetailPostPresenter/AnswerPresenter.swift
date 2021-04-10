//
//  AnswerPresenter.swift
//  communityApplication
//
//  Created by Om on 08/04/21.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import SVProgressHUD


protocol AnswerViewPresenter: class {
    func dataUploadedSuccessfully()
}

class AnswerPresenter {
    
    weak var view: AnswerViewPresenter?
    let db = Firestore.firestore()
    var postId: String?
    
    init(with view: AnswerViewPresenter) {
        self.view = view
    }
    func storeImage(answer: String,image: UIImageView) {
        let storageRef = Storage.storage().reference().child("Solution/\(Auth.auth().currentUser?.uid ?? "")_\(Date().timeIntervalSince1970).png")
        
        if let uploadData = image.image!.pngData(){
            _ = storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    print(error?.localizedDescription ?? "")
                    SVProgressHUD.dismiss()
                    return
                }
                print(metadata)
                storageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        SVProgressHUD.dismiss()
                        return
                    }
                    self.addAnswerToDataBase(answerTitle: answer,imageUrl: downloadURL.absoluteString)
                }
            }
        }
    }
    func addAnswerToDataBase(answerTitle: String,imageUrl: String = "") {
        let answer: AnswerModel = AnswerModel()
        answer.answer = answerTitle
        answer.uid = Auth.auth().currentUser?.uid ?? ""
        answer.answerImageUrl = imageUrl
        answer.createdAt = Date()
        self.db.collection("post/\(postId ?? "")/answers").addDocument(data: answer.toFireBase()) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                AppUtil.shared.getUserInfo(uid: Auth.auth().currentUser?.uid ?? "") { (user) in
                    self.db.collection("users").document(Auth.auth().currentUser?.uid ?? "").updateData(["answerCount": ((user.answerCount ?? 0) + 1)])
                }
            }
        }
    }
}


