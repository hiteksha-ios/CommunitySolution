//
//  DetailPostPresenter.swift
//  communityApplication
//
//  Created by Om on 08/04/21.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import SVProgressHUD


protocol DetailPostViewPresenter: class {
    func getAnswerDataSuccessfully()
}

class DetailPostPresenter {
    
    weak var view: DetailPostViewPresenter?
    let db = Firestore.firestore()
    var postData = [PostModel]()
    var user: UserModel = UserModel()
    var answerData = [AnswerModel]()
    
    init(with view: DetailPostViewPresenter) {
        self.view = view
    }
    func getAnswers(postId: String) {
        self.db.collection("post/\(postId)/answers").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error?.localizedDescription ?? "")")
                return
            }
            self.updatePostData(Count: documents.count,id: postId)
            self.answerData.removeAll()
            for document in documents {
                print("\(document.documentID) => \(document.data())")
                let results = document.data() as [String: AnyObject]
                let data: AnswerModel = AnswerModel()
                data.fromFireBase(userDict: results,answerId: document.documentID)
                self.answerData.append(data)
            }
            self.view?.getAnswerDataSuccessfully()
        }
    }
    func updatePostData(Count: Int,id: String) {
        self.db.collection("post").document("\(id)").updateData([
            "commentCount": Count
            ])
    }
}

