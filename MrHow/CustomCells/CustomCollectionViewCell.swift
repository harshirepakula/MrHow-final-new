//
//  CustomCollectionViewCell.swift
//  MrHow
//
//  Created by volivesolutions on 21/05/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//
//
//


import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    

    @IBOutlet weak var imageOfferName: UILabel!
    
    @IBOutlet weak var articleLike: UIButton!
    @IBOutlet weak var imageview_banner: UIImageView!
    @IBOutlet weak var imageview_offer: UIImageView!
    @IBOutlet weak var lbl_mainTitle: UILabel!
    @IBOutlet weak var view_back: UIView!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_priceDummy: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var articleLikes: UILabel!
    @IBOutlet weak var noOfPurchasesLbl: UILabel!
    @IBOutlet weak var articleDate: UILabel!
    @IBOutlet weak var articleComments: UILabel!
    @IBOutlet weak var articleWriter: UILabel!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleViews: UILabel!
    
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       
        
    }
    
    
    
}
