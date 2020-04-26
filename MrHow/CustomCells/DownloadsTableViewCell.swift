//
//  DownloadsTableViewCell.swift
//  MrHow
//
//  Created by Dr Mohan Roop on 8/5/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit

class DownloadsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var materialImg: UIImageView!
    @IBOutlet weak var materialName: UILabel!
    
    @IBOutlet weak var removeBtn: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
