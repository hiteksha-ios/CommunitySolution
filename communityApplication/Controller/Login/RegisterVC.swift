//
//  RegisterVC.swift
//  communityApplication
//
//  Created by Aravind on 04/02/2021.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit

class RegisterVC: UIViewController {

    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var confirmPassWord: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var signInGoogleBtn: UIButton!
    @IBOutlet weak var signInFacebookBtn: UIButton!
    
    
    lazy var presenter = RegistrationPresenter(with: self)
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    let loginManager = LoginManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //write code here
        signInGoogleBtn.layer.cornerRadius = signInGoogleBtn.frame.height / 2.0
        registerBtn.layer.cornerRadius = registerBtn.frame.height / 2.0
        signInFacebookBtn.layer.cornerRadius = signInFacebookBtn.frame.height / 2.0

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapRegisterButton(_ sender: UIButton) {//
        
        let email = emailTxtField.text!
        let password = passwordTxtField.text!
        let rePassWord = confirmPassWord.text!
        if !email.emailValidation() {
            self.loginError(errorMessage: "please input validate email.")
            return
        }
        if password.count < 6 {
            self.loginError(errorMessage: "Password must be over 6 digits.")
            return
        }
        if password != rePassWord {
            self.loginError(errorMessage: "Insert correct password")
            return
        }
        AppUtil.onShowProgressView(name: "Registering")
        presenter.createUser(email: email, password: password)
    }
    
    
    @IBAction func tapSigninWithGoogle(_ sender: UIButton) {
        //write code here
        GIDSignIn.sharedInstance()?.signIn()
    }
   
    @IBAction func tapSignInWithFB(_ sender: UIButton) {
        //write code here
        if let _ = AccessToken.current {
            loginManager.logOut()
            
        } else {
            loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
                
                guard error == nil else {
                    // Error occurred
                    print(error!.localizedDescription)
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
    
    @IBAction func tapLoginBtn(_ sender: UIButton) {
        //write code here
        self.navigationController?.popViewController(animated: true)
    }

}

extension RegisterVC: GIDSignInDelegate {
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
extension RegisterVC: RegistrationViewPresenter {
    func loginError(errorMessage: String) {
        self.popupAlert(title: "Error", message: errorMessage, actionTitles: ["Okay"], actions:[{action1 in
            self.dismiss(animated: true, completion: nil)
        }])
    }
    
    func loginSuccessfully() {
        self.performSegue(withIdentifier: "goToTabBar", sender: nil)
    }
    
    
}
