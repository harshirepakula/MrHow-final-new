//
//  ContentTableViewCell.swift
//  A-ZSpares
//
//  Created by volive solutions on 08/05/19.
//  Copyright © 2019 volive solutions. All rights reserved.
//

import UIKit

class ContentTableViewCell: UITableViewCell {

 
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var contentTextLbl: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
