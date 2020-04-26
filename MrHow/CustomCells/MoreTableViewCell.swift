//
//  MoreTableViewCell.swift
//  MrHow
//
//  Created by volivesolutions on 15/06/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit

class MoreTableViewCell: UITableViewCell {
    
    
    @IBOutlet var moreTableComment: UILabel!
    
    @IBOutlet var commentDis: UILabel!
    @IBOutlet var commentTimeName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
