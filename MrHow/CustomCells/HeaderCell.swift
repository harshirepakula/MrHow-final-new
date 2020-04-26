//
//  HeaderCell.swift
//  sample
//
//  Created by MuraliKrishna on 07/06/19.
//  Copyright © 2019 volive. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {
    
    @IBOutlet weak var sectionTitleLbl: UILabel!
    
    @IBOutlet weak var sectionViewAllBtn: UIButton!
    
    
    @IBOutlet weak var headerLbl: UILabel!
    
    
    @IBOutlet weak var sectionViewBtn: UIButton!
    
    
    @IBOutlet weak var headerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
