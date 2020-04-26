//
//  VideoOptionsVC.swift
//  MrHow
//
//  Created by volivesolutions on 16/05/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit
import Alamofire

var continueInBackGround = "1"

var downloadVideoQuality = ""

class VideoOptionsVC: UIViewController {
    
    
    @IBOutlet weak var view_downloadQuality  : UIView!
    @IBOutlet weak var wifiDownloadBtn: UIButton!
    @IBOutlet weak var continueVideoBtn: UIButton!
    
    @IBOutlet weak var videoQualityLbl: UILabel!
    
    @IBOutlet weak var videoDownloadSt: UILabel!
    
    @IBOutlet weak var wifiSt: UILabel!
    
    @IBOutlet weak var backGroundVideoSt: UILabel!
    var downloasdViaWifi = ""
    var continueBackgroundVideo = ""
   
    var flag = Bool()
    var wifiBool = Bool()
    
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
            
            self.navigationItem.title = languageChangeString(a_str: "Video Options")
            print("font changed")
            
        }

        let tapQuality = UITapGestureRecognizer(target: self, action: #selector(VideoOptionsVC.tapFunction))
       view_downloadQuality.isUserInteractionEnabled = true
       view_downloadQuality.addGestureRecognizer(tapQuality)
        
        if language == "ar"
        {
            
            GeneralFunctions.labelCustom_RTReg(labelName: videoDownloadSt, fontSize: 14)
            GeneralFunctions.labelCustom_RTReg(labelName: wifiSt, fontSize: 14)
            GeneralFunctions.labelCustom_RTReg(labelName: backGroundVideoSt, fontSize: 14)
            GeneralFunctions.labelCustom_RTReg(labelName: videoQualityLbl, fontSize: 10)
            
        }
        else if language == "en"
        {
            
            GeneralFunctions.labelCustom_LTReg(labelName: videoDownloadSt, fontSize: 14)
            GeneralFunctions.labelCustom_LTReg(labelName: wifiSt, fontSize: 14)
            GeneralFunctions.labelCustom_LTReg(labelName: backGroundVideoSt, fontSize: 14)
            GeneralFunctions.labelCustom_LTReg(labelName: videoQualityLbl, fontSize: 10)
            
            
        }
        
         self.videoDownloadSt.text = languageChangeString(a_str: "Video Download quality")
         self.wifiSt.text = languageChangeString(a_str: "Download via Wifi Only")
         self.backGroundVideoSt.text = languageChangeString(a_str: "Continue Video in background")
        
    }
    
  
    // MARK: - Back Button
    
    @IBAction func backBarBtnTap(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
       
       videoOptionsData()
        
        videoQualityLbl.text = downloadVideoQuality
        videoQualityLbl.textColor = ThemeColor
        
        self.tabBarController?.tabBar.isHidden = true
       
        if downloasdViaWifi == "1"
        {
            wifiBool = true
            wifiDownloadBtn.setImage(UIImage(named: "on"), for: UIControl.State.normal)
        }
        else if downloasdViaWifi == "0"
        {
            wifiBool = false
            wifiDownloadBtn.setImage(UIImage(named: "off"), for: UIControl.State.normal)
        }
        if continueBackgroundVideo == "1"
        {
            flag = true
            continueInBackGround = "1"
            continueVideoBtn.setImage(UIImage(named: "on"), for: UIControl.State.normal)
        }
        else if continueBackgroundVideo == "0"
        {
            flag = false
            continueInBackGround = "0"
            continueVideoBtn.setImage(UIImage(named: "off"), for: UIControl.State.normal)
        }
        
        
    }
    
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - UITapGestureRecognizer
    
    @objc func tapFunction(sender:UITapGestureRecognizer)
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideoQualityVC") as! VideoQualityVC
       self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func backGroundVideoBtnTap(_ sender: Any)
    {
        if (!flag)
        {
            flag = true
            continueVideoBtn.setImage(UIImage(named: "on"), for: UIControl.State.normal)
            continueInBackGround = "1"
            continueBackgroundVideo = "1"
            
        }
        else
        {
            flag = false
            continueVideoBtn.setImage(UIImage(named: "off"), for: UIControl.State.normal)
            continueBackgroundVideo = "0"
            continueInBackGround = "0"
        }
        videoOptionsData()
    }
    
    
    
    @IBAction func downWiFiBtnTap(_ sender: Any)
    {
        if (!wifiBool)
        {
            wifiBool = true
            wifiDownloadBtn.setImage(UIImage(named: "on"), for: UIControl.State.normal)
            downloasdViaWifi = "1"
           
            
        }
        else
        {
            wifiBool = false
            wifiDownloadBtn.setImage(UIImage(named: "off"), for: UIControl.State.normal)
            downloasdViaWifi = "0"
            
        }
        videoOptionsData()
        
    }
    
    
    func videoOptionsData()
    {
        
        //internet connection
        
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let videoData = "\(base_path)services/usersettings"
            
            //https://www.volive.in/mrhow_dev/services/usersettings
             let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
            
            let myuserID = UserDefaults.standard.object(forKey: USER_ID) ?? ""
            
            let parameters: Dictionary<String, Any> = ["user_id" :myuserID,
                                                       "lang" : language,
                                                       "api_key":APIKEY,
                                                       "background_video":continueBackgroundVideo,
                                                       "video_quality":downloadVideoQuality,
                                                       "wifi_only":downloasdViaWifi,
                                                       ]
            
            
            
            print(parameters)
            Alamofire.request(videoData, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    print(responseData)
                    
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    
                    MobileFixServices.sharedInstance.dissMissLoader()
                    if status == 1
                    {
                        
                        //self.showToastForAlert(message: message)
                        
                    }
                    else
                    {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.showToastForAlert(message: message,style: style1)
                    }
                }
            }
        }
            
        else
        {
            MobileFixServices.sharedInstance.dissMissLoader()
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!,style: style1)
            
        }
        
    }
    
    
    
  
    
   

}
