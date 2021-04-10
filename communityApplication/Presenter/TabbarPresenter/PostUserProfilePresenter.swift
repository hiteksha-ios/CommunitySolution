//
//  PostUserProfilePresenter.swift
//  communityApplication
//
//  Created by Om on 08/04/21.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import SVProgressHUD


protocol PostUserProfileViewPresenter: class {
    func getPostDataSuccessfully()
    func userInfoGetSuccessfully()
}

class PostUserProfilePresenter {
    
    weak var view: PostUserProfileViewPresenter?
    let db = Firestore.firestore()
    var postData = [PostModel]()
    var user: UserModel = UserModel()
    
    init(with view: PostUserProfileViewPresenter) {
        self.view = view
    }
    func getUserData(id: String) {
        self.db.collection("users").document(id).addSnapshotListener { (document, error) in
            guard let currentUserData = document else {
                print("Error fetching documents: \(error?.localizedDescription ?? "")")
                return
            }
            let userDict = currentUserData.data()! as [String: AnyObject]
            self.user.fromFireBase(userDict: userDict)
            self.view?.userInfoGetSuccessfully()
        }
        getpost(uid: id)
    }
    func getpost(uid: String) {
        self.db.collection("post")
            .whereField("uid", isEqualTo: uid)
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
