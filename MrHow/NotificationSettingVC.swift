//
//  NotificationSettingVC.swift
//  MrHow
//
//  Created by volivesolutions on 16/05/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit
import Alamofire

class NotificationSettingVC: UIViewController {
    
    var followTrainer  = ""
    var personalRecommen = ""
    var trainerChecked = Bool()
    var personnelChecked = Bool()
    
    @IBOutlet weak var trainerUpdateBtn: UIButton!
    @IBOutlet weak var recommendationsBtn: UIButton!
    
    @IBOutlet weak var personnelRecSt: UILabel!
    @IBOutlet weak var followTrainerSt: UILabel!
    
     let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
    var fontStyle = ""
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
            self.navigationItem.title = languageChangeString(a_str: "Notifications")
            print("font changed")
            
        }
        
        if language == "ar"
        {
            
            GeneralFunctions.labelCustom_RTReg(labelName: followTrainerSt, fontSize: 14)
            GeneralFunctions.labelCustom_RTReg(labelName: personnelRecSt, fontSize: 14)
            
            
        }
        else if language == "en"
        {
            GeneralFunctions.labelCustom_LTMedium(labelName: followTrainerSt, fontSize: 14)
            GeneralFunctions.labelCustom_LTMedium(labelName: personnelRecSt, fontSize: 14)
            
        }
        
        

        followTrainerSt.text = languageChangeString(a_str: "Following trainers updates")
        personnelRecSt.text = languageChangeString(a_str: "Personalized recommendations")
        if self.followTrainer == "1"
        {
            self.trainerUpdateBtn.setImage(UIImage(named: "on"), for: UIControl.State.normal)
        }
        else
        {
            self.trainerUpdateBtn.setImage(UIImage(named: "off"), for: UIControl.State.normal)
        }
        if self.personalRecommen == "1"
        {
            self.recommendationsBtn.setImage(UIImage(named: "on"), for: UIControl.State.normal)
        }
        else
        {
            self.recommendationsBtn.setImage(UIImage(named: "off"), for: UIControl.State.normal)
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
       
        if followTrainer == "1"
        {
            trainerChecked = true
        }
        else if followTrainer == "0"
        {
            trainerChecked = false
        }
        
        if personalRecommen == "1"
        {
            personnelChecked = true
        }
        else if personalRecommen == "0"
        {
            personnelChecked = false
        }
        
        
    }
    
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
   
    @IBAction func trainerUpdatesBtnTap(_ sender: Any)
    {
       
        
        trainerChecked = !trainerChecked
        if trainerChecked == true
        {
            self.trainerUpdateBtn.setImage(UIImage(named: "on"), for: UIControl.State.normal)
            followTrainer = "1"
            updateNotifications()
        }
        else{
             self.trainerUpdateBtn.setImage(UIImage(named: "off"), for: UIControl.State.normal)
            followTrainer = "0"
            updateNotifications()
        }
     
    }
    
    
    @IBAction func personnelRecommendationsBtn(_ sender: Any) {
        
        personnelChecked = !personnelChecked
        if personnelChecked == true
        {
            self.recommendationsBtn.setImage(UIImage(named: "on"), for: UIControl.State.normal)
            personalRecommen = "1"
            updateNotifications()
        }
        else{
            self.recommendationsBtn.setImage(UIImage(named: "off"), for: UIControl.State.normal)
            personalRecommen = "0"
            updateNotifications()
        }
    }
    

    
    // notifications setting post method
    
    
    func updateNotifications()
    {
        //internet connection
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
            let notificationsSetting = "\(base_path)services/update_notification_settings"
           
            //            https://volive.in/mrhow_dev/services/update_notification_settings
            
            //            Params:
            //            api_key:1762019
            //            lang:en
            //            user_id:
            //            trainer_updates:(1=on,0=off)
            //            recommendations:(1=on,0=off)
            
             let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
           
            
             let myuserID = UserDefaults.standard.object(forKey: USER_ID) ?? ""
            
            let parameters: Dictionary<String, Any> = [ "lang" : language,"api_key":APIKEY,"user_id":myuserID,"trainer_updates":followTrainer,"recommendations":personalRecommen]
            
            print(parameters)
            Alamofire.request(notificationsSetting, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                if let responseData = response.result.value as? Dictionary<String, Any>
                {
                    print(responseData)
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    if status == 1
                    {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.showToastForAlert(message: message,style: style1)
                            
                       
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
