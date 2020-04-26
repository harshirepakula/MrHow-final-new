//
//  VideoQualityVC.swift
//  MrHow
//
//  Created by volivesolutions on 16/05/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit
import Alamofire

class VideoQualityVC: UIViewController {

    
    @IBOutlet weak var Btn360: UIButton!
    @IBOutlet weak var btn480p: UIButton!
    @IBOutlet weak var btn720p: UIButton!
    @IBOutlet weak var btn1080p: UIButton!
    @IBOutlet weak var autoBtn: UIButton!
    
    @IBOutlet weak var lbl360: UILabel!
    @IBOutlet weak var lbl480: UILabel!
    @IBOutlet weak var lbl1080: UILabel!
    @IBOutlet weak var lbl720: UILabel!
    @IBOutlet weak var lblAuto: UILabel!
    
    @IBOutlet weak var imgView1080: UIImageView!
    @IBOutlet weak var imgView360: UIImageView!
    
    @IBOutlet weak var imgView720: UIImageView!
    @IBOutlet weak var imgView480: UIImageView!
    @IBOutlet weak var imgViewAuto: UIImageView!
    
    var fontStyle = ""
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if language == "en"
        {
            fontStyle = "Poppins-SemiBold"
        }else
        {
            fontStyle = "29LTBukra-Bold"
        }
        
        if let aSize = UIFont(name: fontStyle, size: 18) {
            
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: aSize]
            
            self.navigationItem.title = languageChangeString(a_str: "Video Quality")
            print("font changed")
            
        }
        
        self.lbl360.text = languageChangeString(a_str: "360p")
        self.lbl480.text = languageChangeString(a_str: "480p")
        self.lbl720.text = languageChangeString(a_str: "720p")
        self.lbl1080.text = languageChangeString(a_str: "1080p (Best)")
        self.lblAuto.text = languageChangeString(a_str: "Auto")
        
        if language == "ar"
        {
            
            GeneralFunctions.labelCustom_RTReg(labelName: lbl360, fontSize: 13)
            GeneralFunctions.labelCustom_RTReg(labelName: lbl480, fontSize: 13)
            GeneralFunctions.labelCustom_RTReg(labelName: lbl720, fontSize: 13)
            GeneralFunctions.labelCustom_RTReg(labelName: lbl1080, fontSize: 13)
            GeneralFunctions.labelCustom_RTReg(labelName: lblAuto, fontSize: 13)
            
        }
        else if language == "en"
        {
            
            GeneralFunctions.labelCustom_LTReg(labelName: lbl360, fontSize: 13)
            GeneralFunctions.labelCustom_LTReg(labelName: lbl480, fontSize: 13)
            GeneralFunctions.labelCustom_LTReg(labelName: lbl720, fontSize: 13)
            GeneralFunctions.labelCustom_LTReg(labelName: lbl1080, fontSize: 13)
            GeneralFunctions.labelCustom_LTReg(labelName: lblAuto, fontSize: 13)
            
        }
        
    }
    
    

    
    // MARK: - Back Button
    
    @IBAction func backBarBtnTap(_ sender: Any)
    {
       self.navigationController?.popViewController(animated: true)
        
    }
    
    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
      
        
        self.tabBarController?.tabBar.isHidden = true
        
        if downloadVideoQuality == languageChangeString(a_str: "360p")
        {
            // Btn360.setImage(UIImage(named: "correct"), for: UIControl.State.normal)
            imgView360.image = UIImage(named: "correct")
            lbl360.textColor = ThemeColor
            lbl480.textColor = UIColor.black
            lbl720.textColor = UIColor.black
            lblAuto.textColor = UIColor.black
            lbl1080.textColor = UIColor.black
        }
        else if downloadVideoQuality == languageChangeString(a_str: "480p")
        {
            //btn480p.setImage(UIImage(named: "correct"), for: UIControl.State.normal)
            imgView480.image = UIImage(named: "correct")
            lbl480.textColor = ThemeColor
            lbl360.textColor = UIColor.black
            lbl720.textColor = UIColor.black
            lblAuto.textColor = UIColor.black
            lbl1080.textColor = UIColor.black
        }
        else if downloadVideoQuality == languageChangeString(a_str: "720p")
           
        {
            //btn720p.setImage(UIImage(named: "correct"), for: UIControl.State.normal)
            imgView720.image = UIImage(named: "correct")
            lbl720.textColor = ThemeColor
            lbl360.textColor = UIColor.black
            lbl480.textColor = UIColor.black
            lblAuto.textColor = UIColor.black
            lbl1080.textColor = UIColor.black
        }
        else if downloadVideoQuality == "1080"
        {
            imgView1080.image = UIImage(named: "correct")
            lbl1080.textColor = ThemeColor
            lbl720.textColor = UIColor.black
            lbl360.textColor = UIColor.black
            lbl480.textColor = UIColor.black
            lblAuto.textColor = UIColor.black
            
        }
        else if downloadVideoQuality == languageChangeString(a_str: "auto")
        {
            imgViewAuto.image = UIImage(named: "correct")
            lblAuto.textColor = ThemeColor
            lbl1080.textColor = UIColor.black
            lbl720.textColor = UIColor.black
            lbl360.textColor = UIColor.black
            lbl480.textColor = UIColor.black
        }
        
        
        
        
    }
    
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
   

    
    
    @IBAction func buttonCilcked(_ sender: UIButton) {
        
        let buttonArray = [Btn360,btn480p,btn720p,btn1080p,autoBtn]
        
        buttonArray.forEach{
            
            $0?.isSelected = false
            //$0?.setImage(UIImage(named: ""), for: UIControl.State.normal)
        }
        
        sender.isSelected = true
     
        if sender == Btn360 {
            downloadVideoQuality = languageChangeString(a_str: "360p") ?? ""
            lbl360.textColor = ThemeColor
            lbl480.textColor = UIColor.black
            lbl720.textColor = UIColor.black
            lblAuto.textColor = UIColor.black
            lbl1080.textColor = UIColor.black
            imgView360.image = UIImage(named: "correct")
            imgView480.image = UIImage(named: "")
            imgView720.image = UIImage(named: "")
            imgView1080.image = UIImage(named: "")
            imgViewAuto.image = UIImage(named: "")
        }else if sender == btn480p{
            downloadVideoQuality = languageChangeString(a_str: "480p") ?? ""
            lbl480.textColor = ThemeColor
            lbl360.textColor = UIColor.black
            lbl720.textColor = UIColor.black
            lblAuto.textColor = UIColor.black
            lbl1080.textColor = UIColor.black
            imgView360.image = UIImage(named: "")
            imgView480.image = UIImage(named: "correct")
            imgView720.image = UIImage(named: "")
            imgView1080.image = UIImage(named: "")
            imgViewAuto.image = UIImage(named: "")
        }else if sender == btn720p{
            downloadVideoQuality = languageChangeString(a_str: "720p") ?? ""
            lbl720.textColor = ThemeColor
            lbl480.textColor = UIColor.black
            lbl360.textColor = UIColor.black
            lblAuto.textColor = UIColor.black
            lbl1080.textColor = UIColor.black
            imgView360.image = UIImage(named: "")
            imgView480.image = UIImage(named: "")
            imgView720.image = UIImage(named: "correct")
            imgView1080.image = UIImage(named: "")
            imgViewAuto.image = UIImage(named: "")
        }else if sender == btn1080p{
            downloadVideoQuality = "1080"
            lbl1080.textColor = ThemeColor
            lbl720.textColor = UIColor.black
            lbl480.textColor = UIColor.black
            lbl360.textColor = UIColor.black
            lblAuto.textColor = UIColor.black
            imgView360.image = UIImage(named: "")
            imgView480.image = UIImage(named: "")
            imgView720.image = UIImage(named: "")
            imgView1080.image = UIImage(named: "correct")
            imgViewAuto.image = UIImage(named: "")
            
        }else if sender == autoBtn{
            downloadVideoQuality = languageChangeString(a_str: "Auto") ?? ""
            lblAuto.textColor = ThemeColor
            lbl1080.textColor = UIColor.black
            lbl720.textColor = UIColor.black
            lbl480.textColor = UIColor.black
            lbl360.textColor = UIColor.black
            imgView360.image = UIImage(named: "")
            imgView480.image = UIImage(named: "")
            imgView720.image = UIImage(named: "")
            imgView1080.image = UIImage(named: "")
            imgViewAuto.image = UIImage(named: "correct")
        }

    }
    
    
    
}
