//
//  RegistrationPresenter.swift
//  communityApplication
//
//  Created by Om on 08/04/21.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit



protocol RegistrationViewPresenter: class {
    func loginError(errorMessage: String)
    func loginSuccessfully()
}

class RegistrationPresenter {
    
    weak var view: RegistrationViewPresenter?
    let db = Firestore.firestore()
    
    init(with view: RegistrationViewPresenter) {
        self.view = view
    }
    func createUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            AppUtil.onHideProgressView()
            if error == nil {
                // register success, send email verificaiton to user's email//
                Auth.auth().currentUser?.sendEmailVerification(completion: { (err) in
                    if err == nil {
                        print("success..") // afte this, we must save user model to firebase...
                        let user: UserModel = UserModel()
                        user.uid = Auth.auth().currentUser!.uid
                        user.email = email
                        
                        user.uid = Auth.auth().currentUser!.uid
                        user.email = email
                        user.profileImage = ProfileConstArray.randomElement()
                        user.name = (email.components(separatedBy: "@").first)!
                        user.username = (email.components(separatedBy: "@").first)!
                        user.createdAt = Date()
                        self.db.collection("users").document(Auth.auth().currentUser!.uid).setData(user.toFireBase()) { err in
                            if let err = err {
                                print("Error adding document: \(err)")
                            } else {
                                AppUtil.gUser = user
                                self.view?.loginSuccessfully()
                            }
                        }
                    } else {
                        // failed to send email verification ///
                        print(err.debugDescription)
                    }
                })
            } else {
                // register failed//
                print(error.debugDescription)
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

