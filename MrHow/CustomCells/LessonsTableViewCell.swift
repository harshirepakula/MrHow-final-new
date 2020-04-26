//
//  LessonsTableViewCell.swift
//  MrHow
//
//  Created by volivesolutions on 15/06/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit
import AVFoundation

class LessonsTableViewCell: UITableViewCell {

    @IBOutlet var lessonDuration: UILabel!
    @IBOutlet var lessonIntro: UILabel!
    
   
    @IBOutlet weak var lessonImg: VideoView!
    @IBOutlet var noOfLessons: UILabel!
    
    @IBOutlet weak var showBtn: UIButton!
    
    @IBOutlet weak var materialName: UILabel!
    @IBOutlet weak var materialImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // lessonImg.player?.allowsExternalPlayback = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
