//
//  OrderTableViewCell.swift
//  A-ZSpares
//
//  Created by volive solutions on 06/05/19.
//  Copyright © 2019 volive solutions. All rights reserved.
//

import UIKit

class PseudoHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!

    func setExpanded() {
         headerLbl.isHidden = true
        //statusButton.setImage(#imageLiteral(resourceName: "Faq_1"), for: .normal)
    }

    func setCollapsed() {
         headerLbl.isHidden = false
       
       // statusButton.setImage(#imageLiteral(resourceName: "Faq_2"), for: .normal)
    }
}
