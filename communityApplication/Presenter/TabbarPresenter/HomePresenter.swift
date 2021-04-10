//
//  HomePresenter.swift
//  communityApplication
//
//  Created by Om on 08/04/21.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth


protocol HomeViewPresenter: class {
    func getPostSuccessfully()
}

class HomePresenter {
    
    weak var view: HomeViewPresenter?
    let db = Firestore.firestore()
    var postData = [PostModel]()
    
    init(with view: HomeViewPresenter) {
        self.view = view
    }
    
    func retriveBulletinData() {
        db.collection("post")
            .addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error?.localizedDescription ?? "")")
                return
            }
            print(documents)
            self.postData.removeAll()
            for document in documents {
                print("\(document.documentID) => \(document.data())")
                let results = document.data() as [String : AnyObject]
                let post: PostModel = PostModel()
                post.fromFireBase(userDict: results,postId: document.documentID)
                self.postData.append(post)
            }
            self.view?.getPostSuccessfully()
        }
    }
}
