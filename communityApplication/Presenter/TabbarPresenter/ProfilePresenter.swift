//
//  ProfilePresenter.swift
//  communityApplication
//
//  Created by Om on 08/04/21.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import SVProgressHUD


protocol ProfileViewPresenter: class {
    func getPostDataSuccessfully()
    func userInfoGetSuccessfully()
}

class ProfilePresenter {
    
    weak var view: ProfileViewPresenter?
    let db = Firestore.firestore()
    var postData = [PostModel]()
    var user: UserModel = UserModel()
    
    init(with view: ProfileViewPresenter) {
        self.view = view
    }
    func getUserData() {
        self.db.collection("users").document(Auth.auth().currentUser?.uid ?? "").addSnapshotListener { (document, error) in
            guard let currentUserData = document else {
                print("Error fetching documents: \(error?.localizedDescription ?? "")")
                return
            }
            let userDict = currentUserData.data()! as [String: AnyObject]
            self.user.fromFireBase(userDict: userDict)
            self.view?.userInfoGetSuccessfully()
        }
        getpost()
    }
    func getpost() {
        self.db.collection("post")
            .whereField("uid", isEqualTo: Auth.auth().currentUser?.uid ?? "")
            .addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error?.localizedDescription ?? "")")
                    return
                }
                self.postData.removeAll()
                for document in documents {
                    print("\(document.documentID) => \(document.data())")
                    let results = document.data() as [String : AnyObject]
                    let post: PostModel = PostModel()
                    post.fromFireBase(userDict: results, postId: document.documentID)
                    self.postData.append(post)
                }
                self.view?.getPostDataSuccessfully()
            }
    }
}
