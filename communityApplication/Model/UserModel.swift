//
//  UserModel.swift
//  communityApplication
//
//  Created by Aravind on 11/02/2021.

import Foundation
import Firebase

class UserModel: NSObject {
    var createdAt: Date? //this is user id from firebase//
    var email: String?
    var name: String?
    var profileImage: String?
    var token: String?
    var uid: String?
    var username: String?
    var answerCount: Int?
    var postCount: Int?
    func toFireBase() -> [String: Any] {
        return [
            "createdAt": createdAt ?? Date(),
            "email": email ?? "",
            "name": name ?? "",
            "profileImage": profileImage ?? "",
            "token": token ?? "",
            "uid": uid ?? "",
            "username": username ?? "",
            "answerCount": answerCount ?? 0,
            "postCount": postCount ?? 0
        ]
    }
    //fromFirebase
    func fromFireBase(userDict: [String: AnyObject]) {
        createdAt = Date(timeIntervalSince1970: TimeInterval((userDict["createdAt"] as! Timestamp).seconds))
        email = userDict["email"] as? String
        name = userDict["name"] as? String
        profileImage = userDict["profileImage"] as? String
        token = userDict["token"] as? String
        uid = userDict["uid"] as? String
        username = userDict["username"] as? String
        answerCount = userDict["answerCount"] as? Int
        postCount = userDict["postCount"] as? Int
    }
}
