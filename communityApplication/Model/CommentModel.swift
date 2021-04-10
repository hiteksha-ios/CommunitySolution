//
//  CommentModel.swift
//  communityApplication
//
//  Created by Om on 08/04/21.
//

import Foundation
import Firebase


class CommentModel: NSObject {
    
    var comment: String?
    var createdAt: Date?
    var uid: String?
    func toFireBase() -> [String: Any] {
        return [
            "comment": comment ?? "",
            "createdAt": createdAt ?? Date(),
            "uid": uid ?? ""
        ]
    }
    //fromFirebase
    func fromFireBase(userDict: [String: AnyObject]) {
        comment = userDict["comment"] as? String
        createdAt = Date(timeIntervalSince1970: TimeInterval((userDict["createdAt"] as! Timestamp).seconds))
        uid = userDict["uid"] as? String
    }
}
