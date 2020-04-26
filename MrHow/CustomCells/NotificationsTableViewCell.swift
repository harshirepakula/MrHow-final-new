//
//  NotificationsTableViewCell.swift
//  MrHow
//
//  Created by Dr Mohan Roop on 6/27/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit

class NotificationsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingViewHt: NSLayoutConstraint!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var createdOnLbl: UILabel!
    @IBOutlet weak var star5: UIImageView!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    
    @IBOutlet weak var replyBtn: UIButton!
    
    @IBOutlet weak var subCommentLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
