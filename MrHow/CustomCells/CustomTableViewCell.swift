//
//  CustomTableViewCell.swift
//  MrHow
//
//  Created by volivesolutions on 15/05/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageview_banner: UIImageView!
    
    @IBOutlet weak var imageofferName: UILabel!
    
    @IBOutlet weak var durationLbl: UILabel!
    
    @IBOutlet weak var tagLbl: UIImageView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var offerPriceLbl: UILabel!
   
    @IBOutlet weak var purchaseLbl: UILabel!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var btn_download: UIButton!
    @IBOutlet weak var courseNameLbl: UILabel!
    @IBOutlet weak var btn_certificate: UIButton!
    @IBOutlet weak var progressview_download: UIProgressView!
    @IBOutlet weak var lbl_downloadPercentage: UILabel!
    
    @IBOutlet weak var authorNameLbl: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
