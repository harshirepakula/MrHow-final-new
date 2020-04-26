//
//  HashTagCollectionViewCell.swift
//  MrHow
//
//  Created by Dr Mohan Roop on 8/5/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit

class HashTagCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var hashTagLbl: UILabel!
    
    
    @IBOutlet weak var backView: UIView!
    
       override var isSelected: Bool {
            didSet {
                self.hashTagLbl.textColor = isSelected ? UIColor.white : UIColor.black
                self.backView.backgroundColor = isSelected ? ThemeColor : UIColor.white
            }
        }

    
}
