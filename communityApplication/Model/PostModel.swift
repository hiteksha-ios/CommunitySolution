//
//  PostModel.swift
//  communityApplication
//
//  Created by Aravind on 24/03/2021.
//

import Foundation
import Firebase


class PostModel: NSObject {
    
    var commentCount: Int?
    var id: String?
    var title: String?
    var descriptionTitle: String?
    var imageUrl: String?
    var uid: String?
    var createdAt: Date?
    
    func toFireBase() -> [String: Any] {
        return [
            "commentCount": commentCount ?? "",
            "title": title ?? "",
            "descriptionTitle": descriptionTitle ?? "",
            "imageUrl": imageUrl ?? "",
            "uid": uid ?? "",
            "createdAt": createdAt ?? Date()
        ]
    }
    //fromFirebase
    func fromFireBase(userDict: [String: AnyObject],postId: String) {
        id = postId
        commentCount = userDict["commentCount"] as? Int
        title = userDict["title"] as? String
        descriptionTitle = userDict["descriptionTitle"] as? String
        imageUrl = userDict["imageUrl"] as? String
        uid = userDict["uid"] as? String
        createdAt = Date(timeIntervalSince1970: TimeInterval((userDict["createdAt"] as! Timestamp).seconds))
    }
}
