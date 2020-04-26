//
//  BannersCollectionViewCell.swift
//  MrHow
//
//  Created by Dr Mohan Roop on 6/20/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit

class BannersCollectionViewCell: UICollectionViewCell
{
    
    @IBOutlet weak var star5: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var courseTitle: UILabel!
    @IBOutlet weak var imageview_banner: UIImageView!
    @IBOutlet weak var bannerPrice: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var categeoryName: UILabel!
    @IBOutlet weak var bagroundColor: UIView!
    
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
   
    
}
