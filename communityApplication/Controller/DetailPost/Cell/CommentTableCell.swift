//
//  CommentTableCell.swift
//  communityApplication
//
//  Created by Om on 31/03/21.
//

import UIKit

class CommentTableCell: UITableViewCell {

    @IBOutlet weak var commentTimeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commewntUserNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setData(model: CommentModel) {
        AppUtil.shared.getUserInfo(uid: model.uid ?? "") { user in
            self.commewntUserNameLabel.text = "- \(user.name ?? "")"
        }
        commentLabel.text = model.comment
        commentTimeLabel.text = model.createdAt?.timeAgoDisplay()
    }

}
