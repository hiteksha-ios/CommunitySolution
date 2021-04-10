//
//  UserPostCell.swift
//  communityApplication
//
//  Created by Om on 03/04/21.
//

import UIKit

class UserPostCell: UITableViewCell {

    @IBOutlet weak var totalAnswerLabel: UILabel!
    @IBOutlet weak var questionTitleLabel: UILabel!
    @IBOutlet weak var postedTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
