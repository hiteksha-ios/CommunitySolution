//
//  LoginPresenter.swift
//  communityApplication
//
//  Created by Om on 08/04/21.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit



protocol LoginViewPresenter: class {
    func loginError(errorMessage: String)
    func loginSuccessfully()
}

class LoginPresenter {
    
    weak var view: LoginViewPresenter?
    let db = Firestore.firestore()
    
    init(with view: LoginViewPresenter) {
        self.view = view
    }
    func LoginWithEmailPassword(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                AppUtil.onHideProgressView()
                self.view?.loginError(errorMessage: error?.localizedDescription ?? "")
            } else {
                AppUtil.onHideProgressView()
                if Auth.auth().currentUser!.isEmailVerified {
                    // we must get user information from firebase database//
                    self.db.collection("users").document(Auth.auth().currentUser?.uid ?? "").getDocument { (document, eror) in
                        if let document = document,document.exists {
                            print("user exists")
                            AppUtil.onHideProgressView()
                            let userDict = document.data()! as [String: AnyObject]
                            let user: UserModel = UserModel()
                            user.fromFireBase(userDict: userDict)
                            AppUtil.gUser = user
                            self.view?.loginSuccessfully()
                        }else {
                            self.view?.loginError(errorMessage: "user does not exist.")
                        }
                    }
                } else {
                    self.view?.loginError(errorMessage: "Please check your mail box for verification.")
                }
            }
        }
    }
    
    func signInWithCredintial(credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (result, error) in
            if let err =  error {
                AppUtil.onHideProgressView()
                print(err.localizedDescription)
                self.view?.loginError(errorMessage: error?.localizedDescription ?? "")
                return
            }
            let nUser: UserModel = UserModel()
            nUser.uid = (result?.user.uid)
            nUser.email = (result?.user.email)
            nUser.profileImage = ProfileConstArray.randomElement()
            nUser.name = (result?.user.displayName ?? result?.user.email?.components(separatedBy: "@").first)
            nUser.username = (result?.user.displayName ?? result?.user.email?.components(separatedBy: "@").first)
            nUser.createdAt = Date()
            AppUtil.gUser = nUser
            
            //check User data already exists or not
            self.db.collection("users").document(result?.user.uid ?? "").getDocument { (document, eror) in
                if let document = document,document.exists {
                    print("user exists")
                    AppUtil.onHideProgressView()
                    AppUtil.gUser = nUser
                    self.view?.loginSuccessfully()
                }else {
                    self.db.collection("users").document(Auth.auth().currentUser!.uid).setData(nUser.toFireBase()) { err in
                        if let err = err {
                            AppUtil.onHideProgressView()
                            print("Error adding user: \(err)")
                        } else {
                            print("user added to database")
                            AppUtil.onHideProgressView()
                            AppUtil.gUser = nUser
                            self.view?.loginSuccessfully()
                        }
                    }
                }
                
            }
        }
    }
}
