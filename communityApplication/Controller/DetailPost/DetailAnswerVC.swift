//
//  DetailAnswerVC.swift
//  communityApplication
//
//  Created by Om on 31/03/21.
//

import UIKit
import Kingfisher
import FirebaseAuth
import FirebaseFirestore

class DetailAnswerVC: UIViewController {
    
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var heightOfCommentTableView: NSLayoutConstraint!
    
    @IBOutlet weak var addCommentView: UIView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var answerUsrNameLbl: UILabel!
    @IBOutlet weak var answerTimeLabel: UILabel!
    @IBOutlet weak var answerUserImageView: UIImageView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var answerImageView: UIImageView!
    
    @IBOutlet weak var commentTextView: customUITextView!
    
    lazy var presenter = DetailAnswerPresenter(with: self)
    var postId: String?
    var userInfo: UserModel?
    var answerData: AnswerModel?
    
    let db = Firestore.firestore()
    let alertController = UIAlertController()
    let textView = UITextView(frame: CGRect.zero)
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.postId = postId
        presenter.getComments(answerId: answerData?.id ?? "")
        
        commentTableView.delegate = self
        commentTableView.dataSource = self
        AppUtil.shared.getUserInfo(uid: answerData?.uid ?? "") { user in
            self.answerUsrNameLbl.text = user.name ?? ""
            self.answerUserImageView.kf.setImage(with: URL(string: user.profileImage ?? ""),placeholder: UIImage(named: "profile_place"))
        }
        answerTimeLabel.text = answerData?.createdAt?.timeAgoDisplay() ?? ""
        answerLabel.text = answerData?.answer ?? ""
        answerImageView.isHidden = answerData?.answerImageUrl == ""
        answerImageView.kf.setImage(with: URL(string: answerData?.answerImageUrl ?? ""))
        // Do any additional setup after loading the view.
    }
    @IBAction func onAddCommentButtonClick(_ sender: UIButton) {
        commentView.isHidden = false
        addCommentView.isHidden = true
    }
    @IBAction func onSendButtonClick(_ sender: UIButton) {
        if commentTextView.text.isEmpty {
            return
        }
        presenter.sendCommentToDataBase(CommentText: self.commentTextView.text ?? "", answerId: answerData?.id ?? "")
    }
    
    
}

extension DetailAnswerVC: UITableViewDelegate {
}

extension DetailAnswerVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        commentTableView.isHidden = (presenter.commentData.count == 0)
        return presenter.commentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableCell", for: indexPath) as! CommentTableCell
        cell.setData(model: presenter.commentData[indexPath.row])
        DispatchQueue.main.async {
            self.heightOfCommentTableView.constant = tableView.contentSize.height
        }
        return cell
    }
}


extension DetailAnswerVC : DetailAnswerViewPresenter {
    func commentSaveSuccessfully() {
        self.commentTextView.text = ""
        self.addCommentView.isHidden = false
        self.commentView.isHidden = true
    }
    
    func commentGetSuccessfully() {
        commentTableView.reloadData()
    }
    
    
}
