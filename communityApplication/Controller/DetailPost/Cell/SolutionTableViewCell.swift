//
//  SolutionTableViewCell.swift
//  communityApplication
//
//  Created by Aravind on 23/03/2021.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class SolutionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var solutionLbl: UILabel!
    
    var userInfo: UserModel?
    let db = Firestore.firestore()
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = userImageView.frame.size.width/2
        userImageView.layer.borderWidth = 0
        userImageView.layer.borderColor = UIColor.black.cgColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setData(model: AnswerModel) {
        AppUtil.shared.getUserInfo(uid: model.uid ?? "") { user in
            self.userImageView.kf.setImage(with: URL(string: user.profileImage ?? ""),placeholder: UIImage(named: "profile_place"))
            self.userNameLbl.text = user.name ?? ""
        }
        timeLabel.text = model.createdAt?.timeAgoDisplay() ?? ""
        solutionLbl.text = model.answer
    }
}
