//
//  StudioDetailsTableViewCell.swift
//  MrHow
//
//  Created by Suman Guntuka on 14/06/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit

class StudioDetailsTableViewCell: UITableViewCell {
    
  
    @IBOutlet weak var outerLine: UILabel!
    @IBOutlet weak var likesBtn: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var noOfLikes: UILabel!
    @IBOutlet weak var noOfSubComments: UILabel!
    @IBOutlet weak var messageDes: UILabel!
    
    
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
