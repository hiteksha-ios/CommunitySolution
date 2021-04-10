//
//  AppUtil.swift
//  communityApplication
//
//  Created by Aravind on 11/02/2021.
//

import Foundation
import SVProgressHUD
import FirebaseFirestore
import FirebaseAuth

class AppUtil: NSObject {
    static let shared = AppUtil()
    static var gUser: UserModel = UserModel()
    let db = Firestore.firestore()
    static func onShowProgressView (name: String) {
        SVProgressHUD.show(withStatus: name) // progressbar text//
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setForegroundColor(.blue) // progressbar color//
        SVProgressHUD.setBackgroundColor(UIColor.black.withAlphaComponent(0.0))
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setRingNoTextRadius(20.0)
        SVProgressHUD.setRingThickness(3.0)
        SVProgressHUD.setDefaultAnimationType(.flat)
    }
    
    static func onHideProgressView () {
        SVProgressHUD.dismiss()
    }
    
    func getUserInfo(uid: String,completionHandler: @escaping (UserModel)->Void)
    {
        let user: UserModel = UserModel()
        self.db.collection("users").document(uid).getDocument { (document, eror) in
            if let document = document,document.exists {
                print("user exists")
                let userDict = document.data()! as [String: AnyObject]
                user.fromFireBase(userDict: userDict)
                completionHandler(user)
            }else {
                //completionHandler(user)
                print("user does not exist")
            }
        }
    }
}
