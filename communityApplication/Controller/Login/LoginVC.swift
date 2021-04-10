//
//  LoginVC.swift
//  communityApplication
//
//  Created by Aravind on 31/01/2021.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit


class LoginVC: UIViewController {

    @IBOutlet weak var emailTF: customUITextField!
    @IBOutlet weak var passwordTF: customUITextField!
    @IBOutlet weak var googleUB: UIButton!
    @IBOutlet weak var loginUB: UIButton!
    @IBOutlet weak var facebookUB: UIButton!
    
    let db = Firestore.firestore()
    let loginManager = LoginManager()
    
    lazy var presenter = LoginPresenter(with: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "goToTabBar", sender: nil)
            return
            
        }
        googleUB.layer.cornerRadius = googleUB.frame.height / 2.0
        loginUB.layer.cornerRadius = loginUB.frame.height / 2.0
        facebookUB.layer.cornerRadius = facebookUB.frame.height / 2.0
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
    @IBAction func onTapLoginUB(_ sender: Any) {
        let email = emailTF.text!
        let password = passwordTF.text!
        if !email.emailValidation() {
            print("please input validate email.")
            return
        }
        if password.count < 6 {
            print("Password must be over 6 digits.")
            return
        }
        AppUtil.onShowProgressView(name: "Login...")
        presenter.LoginWithEmailPassword(email: email, password: password)
    }
    
    
    @IBAction func ongTapGoogleUB(_ sender: Any) {
        print("On Tapped Google Button")
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func onTapFacebookUB(_ sender: UIButton) {
        print("On Tapped FaceBook Button")
        if let _ = AccessToken.current {
            loginManager.logOut()
            
        } else {
            loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
                guard error == nil else {
                    self.loginError(errorMessage: error!.localizedDescription)
                    return
                    
                }
                guard let result = result, !result.isCancelled else {
                    print("User cancelled login")
                    return
                }
                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                self.presenter.signInWithCredintial(credential: credential)
            }
        }
        
    }
}

extension LoginVC: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        AppUtil.onShowProgressView(name: "Loading...")
        if error != nil {
            AppUtil.onHideProgressView()
            print(error.debugDescription)
        } else {
            guard let authentication = user.authentication else {return}
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            self.presenter.signInWithCredintial(credential: credential)
        }
    }
    
}


extension LoginVC: LoginViewPresenter {
    func loginError(errorMessage: String) {
        self.popupAlert(title: "Error", message: errorMessage, actionTitles: ["Okay"], actions:[{action1 in
            self.dismiss(animated: true, completion: nil)
        }])
    }
    
    func loginSuccessfully() {
        self.performSegue(withIdentifier: "goToTabBar", sender: nil)
    }
    
    
}
