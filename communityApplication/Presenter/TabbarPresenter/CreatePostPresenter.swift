//
//  CreatePostPresenter.swift
//  communityApplication
//
//  Created by Om on 08/04/21.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import SVProgressHUD


protocol CreatePostViewPresenter: class {
    func dataUploadedSuccessfully()
}

class CreatePostPresenter {
    
    weak var view: CreatePostViewPresenter?
    let db = Firestore.firestore()
    
    init(with view: CreatePostViewPresenter) {
        self.view = view
    }
    func storeImage(title: String,question: String,image: UIImageView) {
        let storageRef = Storage.storage().reference().child("Problem/\(Auth.auth().currentUser?.uid ?? "")_\(Date().timeIntervalSince1970).png")
        
        if let uploadData = image.image!.pngData(){
            _ = storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                guard error != nil else {
                    // Uh-oh, an error occurred!
                    print(error?.localizedDescription ?? "")
                    SVProgressHUD.dismiss()
                    return
                }
                storageRef.downloadURL { [self] (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        SVProgressHUD.dismiss()
                        return
                    }
                    self.addProblemToDataBase(title: title, question: question,imageUrl: downloadURL.absoluteString)
                    
                }
            }
        }
    }
    func addProblemToDataBase(title: String,question: String,imageUrl: String = "") {
        let post: PostModel = PostModel()
        post.title = title
        post.descriptionTitle = question
        post.uid = Auth.auth().currentUser?.uid ?? ""
        post.imageUrl = imageUrl
        post.createdAt = Date()
        self.db.collection("post").addDocument(data: post.toFireBase()) { [self] err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                AppUtil.shared.getUserInfo(uid: Auth.auth().currentUser?.uid ?? "") { (user) in
                    self.db.collection("users").document(Auth.auth().currentUser?.uid ?? "").updateData(["postCount": ((user.postCount ?? 0) + 1)])
                }
                self.view?.dataUploadedSuccessfully()
            }
        }
    }
}
