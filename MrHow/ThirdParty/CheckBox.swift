//
//  CheckBox.swift
//  MrHow
//
//  Created by volivesolutions on 31/05/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import Foundation

class CheckBox: UIButton {
    // Images
    let checkedImage = UIImage(named: "Group 3128")! as UIImage
    let uncheckedImage = UIImage(named: "Rectangle 2062")! as UIImage
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControl.State.normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
