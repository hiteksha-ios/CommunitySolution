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

class PostUserProfileVC: UIViewController {
    
    @IBOutlet weak var userImagewView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userJoiningTimeLabel: UILabel!
    @IBOutlet weak var totalAnswerLabel: UILabel!
    @IBOutlet weak var totalQuetionLabel: UILabel!
    
    @IBOutlet weak var postTableView: UITableView!
    
    @IBOutlet weak var heightOfPostTableView: NSLayoutConstraint!
    
    
    @IBOutlet weak var noPostView: UIView!
    
    
    lazy var presenter = PostUserProfilePresenter(with: self)
    var userId: String?
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        userImagewView.layer.cornerRadius = userImagewView.frame.size.width/2
        presenter.getUserData(id: userId ?? "")
    }
}

extension PostUserProfileVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailPostVC  = storyboard?.instantiateViewController(identifier: "DetailPostVC") as? DetailPostVC else {
            fatalError("view controller not created")
        }
        detailPostVC.postData = presenter.postData[indexPath.row]
        navigationController?.pushViewController(detailPostVC, animated: true)
    }
}

extension PostUserProfileVC: UITableViewDataSource {
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
}


extension PostUserProfileVC: PostUserProfileViewPresenter {
    
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
