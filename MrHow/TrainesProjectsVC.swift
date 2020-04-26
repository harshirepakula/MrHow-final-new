//
//  TrainesProjectsVC.swift
//  MrHow
//
//  Created by harshitha on 05/11/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit

class TrainesProjectsVC: UIViewController {
    
    @IBOutlet weak var projectImg: UIImageView!
    var imageToShow = ""
    
    var fontStyle = ""
    
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "ar"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if language == "en"
        {
            fontStyle = "Poppins-SemiBold"
        }else
        {
            fontStyle = "29LTBukra-Bold"
        }
        
        
        self.navigationController?.navigationBar.barTintColor = ThemeColor
        
        if let aSize = UIFont(name: fontStyle, size: 18) {
            
            
            self.navigationItem.title = languageChangeString(a_str: "Traines Projects")
            
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: aSize]
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = true
        
        self.projectImg.sd_setImage(with: URL (string:imageToShow))
    }
    
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    @IBAction func backBtnTap(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
