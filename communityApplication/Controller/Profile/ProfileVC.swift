//
//  ProfileVC.swift
//  communityApplication
//
//  Created by Om on 03/04/21.
//

import UIKit
import Kingfisher
import FirebaseAuth
import FirebaseFirestore
import FBSDKLoginKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var userImagewView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userJoiningTimeLabel: UILabel!
    @IBOutlet weak var totalAnswerLabel: UILabel!
    @IBOutlet weak var totalQuetionLabel: UILabel!
    @IBOutlet weak var postTableView: UITableView!
    @IBOutlet weak var heightOfPostTableView: NSLayoutConstraint!
    @IBOutlet weak var noPostView: UIView!
    
    
    lazy var presenter = ProfilePresenter(with: self)
    let db = Firestore.firestore()
    let loginManager = LoginManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        userImagewView.layer.cornerRadius = userImagewView.frame.size.width/2
        presenter.getUserData()

    }
    @IBAction func onClickLogoutButton(_ sender: UIBarButtonItem) {
        do {
            if let _ = AccessToken.current {
                loginManager.logOut()
            }
            try Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let loginvc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else {return}
            loginvc.modalPresentationStyle = .fullScreen
            self.present(loginvc, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func onClickEditButton(_ sender: UIButton) {
        guard let editProfileVC  = storyboard?.instantiateViewController(identifier: "EditProfileVC") as? EditProfileVC else {
            fatalError("view controller not created")
        }
        editProfileVC.userInfo = presenter.user
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
}

extension ProfileVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailPostVC  = storyboard?.instantiateViewController(identifier: "DetailPostVC") as? DetailPostVC else {
            fatalError("view controller not created")
        }
        detailPostVC.postData = presenter.postData[indexPath.row]
        navigationController?.pushViewController(detailPostVC, animated: true)
    }
}

extension ProfileVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noPostView.isHidden = !(presenter.postData.count == 0)
        postTableView.isHidden = (presenter.postData.count == 0)
        return presenter.postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserPostCell", for: indexPath) as! UserPostCell
        cell.questionTitleLabel.text = presenter.postData[indexPath.row].title
        cell.totalAnswerLabel.text = "\(presenter.postData[indexPath.row].commentCount ?? 0)"
        cell.postedTimeLabel.text = presenter.postData[indexPath.row].createdAt?.timeAgoDisplay() ?? ""
        DispatchQueue.main.async {
            self.heightOfPostTableView.constant = tableView.contentSize.height
        }
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            db.collection("post").document(presenter.postData[indexPath.row].id ?? "").delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    AppUtil.shared.getUserInfo(uid: Auth.auth().currentUser?.uid ?? "") { (user) in
                        self.db.collection("users").document(Auth.auth().currentUser?.uid ?? "").updateData(["postCount": ((user.postCount ?? 0) - 1)])
                    }
                    print("Document successfully removed!")
                }
            }
        }
    }
}



extension ProfileVC: ProfileViewPresenter {
    
    func getPostDataSuccessfully() {
        postTableView.reloadData()
    }
    func userInfoGetSuccessfully() {
        self.userImagewView.kf.setImage(with: URL(string: presenter.user.profileImage ?? ""),placeholder: UIImage(named: "profile_place"))
        self.userName.text = presenter.user.name ?? ""
        self.userJoiningTimeLabel.text = presenter.user.createdAt?.monthandYearCount()
        self.totalAnswerLabel.text = "\(presenter.user.answerCount ?? 0)"
        self.totalQuetionLabel.text = "\(presenter.user.postCount ?? 0)"
    }
    
}
