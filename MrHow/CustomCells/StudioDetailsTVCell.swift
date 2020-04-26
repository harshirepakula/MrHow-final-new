//
//  StudioDetailsTVCell.swift
//  MrHow
//
//  Created by Dr Mohan Roop on 8/5/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit

class StudioDetailsTVCell: UITableViewCell {
    
    
    @IBOutlet weak var textViewHt: NSLayoutConstraint!
    
    @IBOutlet weak var detailsVideoBtn: UIButton!
    
    @IBOutlet weak var detailsvideoBtn: UIImageView!
    @IBOutlet weak var detailBackView: UIView!
    @IBOutlet weak var detailsBannerImg: UIImageView!
    
    @IBOutlet weak var detailDescripLbl: UILabel!
    
    
    @IBOutlet weak var detailDescrip: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
