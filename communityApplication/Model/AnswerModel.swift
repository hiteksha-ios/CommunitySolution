//
//  AnswerModel.swift
//  communityApplication
//
//  Created by Om on 08/04/21.
//

import Foundation
import Firebase

class AnswerModel: NSObject {
    var id: String?
    var answer: String?
    var answerImageUrl: String?
    var createdAt: Date?
    var uid: String?
    func toFireBase() -> [String: Any] {
        return [
            "answer": answer ?? "",
            "answerImageUrl": answerImageUrl ?? "",
            "createdAt": createdAt ?? Date(),
            "uid": uid ?? ""
        ]
    }
    //fromFirebase
    func fromFireBase(userDict: [String: AnyObject],answerId: String) {
        id = answerId
        answer = userDict["answer"] as? String
        answerImageUrl = userDict["answerImageUrl"] as? String
        createdAt = Date(timeIntervalSince1970: TimeInterval((userDict["createdAt"] as! Timestamp).seconds))
        uid = userDict["uid"] as? String
    }
}
