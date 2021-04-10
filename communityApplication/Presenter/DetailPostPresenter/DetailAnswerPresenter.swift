//
//  DetailAnswerPresenter.swift
//  communityApplication
//
//  Created by Om on 08/04/21.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import SVProgressHUD


protocol DetailAnswerViewPresenter: class {
    func commentGetSuccessfully()
    func commentSaveSuccessfully()
}

class DetailAnswerPresenter {
    
    weak var view: DetailAnswerViewPresenter?
    let db = Firestore.firestore()
    var postId: String?
    var commentData = [CommentModel]()
    
    init(with view: DetailAnswerViewPresenter) {
        self.view = view
    }
    
    func getComments(answerId: String) {
        self.db.collection("post/\(postId ?? "")/answers/\(answerId)/comments").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error?.localizedDescription ?? "")")
                return
            }
            print(documents.count)
            print(documents)
            self.commentData.removeAll()
            for document in documents {
                print("\(document.documentID) => \(document.data())")
                let results = document.data() as [String: AnyObject]
                let data: CommentModel = CommentModel()
                data.fromFireBase(userDict: results)
                self.commentData.append(data)
            }
            self.view?.commentGetSuccessfully()
        }
    }
    func sendCommentToDataBase(CommentText: String,answerId: String) {
        let comment: CommentModel = CommentModel()
        comment.comment = CommentText
        comment.uid = Auth.auth().currentUser?.uid ?? ""
        comment.createdAt = Date()
        self.db.collection("post/\(self.postId ?? "")/answers/\(answerId)/comments").addDocument(data: comment.toFireBase()) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                self.view?.commentSaveSuccessfully()
            }
        }
    }
}



