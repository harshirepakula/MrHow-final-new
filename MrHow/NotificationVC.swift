//
//  NotificationVC.swift
//  MrHow
//
//  Created by volivesolutions on 15/05/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit
import Alamofire

let AppMainColor  = UIColor(red: 13/255, green: 205/255, blue: 120/255, alpha: 1.0)

class NotificationVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var unreadView: NSLayoutConstraint!
    @IBOutlet weak var unreadNotificationsLbl: UILabel!
    
    var titleArray = [String]()
    var textArray = [String]()
    var typeArray = [String]()
    var seen_statusArray = [String]()
    var nameArray = [String]()
    var profile_picArray = [String]()
    var created_onArray = [String]()
    var timeArray = [String]()
    var unreadNotifications : String! = ""
   
    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"

    @IBOutlet weak var tableViewList: UITableView!
    
    @IBOutlet weak var view_unReadNotifiCount: UIView!
    
     var fontStyle = ""
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        tableViewList.rowHeight = UITableView.automaticDimension
        tableViewList.estimatedRowHeight = UITableView.automaticDimension
     print(tableViewList.rowHeight)
        print(tableViewList.estimatedRowHeight)
        
    }
    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = true
         notificationsToShow()
        
        if language == "en"
        {
            fontStyle = "Poppins-SemiBold"
        }else
        {
            fontStyle = "29LTBukra-Bold"
        }
        
        if let aSize = UIFont(name:fontStyle, size:18) {
            
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: aSize]
            
            self.navigationItem.title = languageChangeString(a_str: "Notifications")
            print("font changed")
            
        }
        
        
        
        
    }
    
    
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Back Button
    
    @IBAction func backBarBtnTap(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
     // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
      
        return titleArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = self.tableViewList.dequeueReusableCell(withIdentifier: "NotificationsTableViewCell", for: indexPath) as! NotificationsTableViewCell
        
        
        
        
        if language == "ar"
        {
            
            GeneralFunctions.labelCustom_RTReg(labelName: cell.titleLbl, fontSize: 15)
            GeneralFunctions.labelCustom_RTReg(labelName: cell.timeLbl, fontSize: 12)
            
            GeneralFunctions.labelCustom_RTReg(labelName: cell.nameLbl, fontSize: 14)
            
            
        }
        else if language == "en"
        {
            GeneralFunctions.labelCustom_LTMedium(labelName:  cell.titleLbl, fontSize: 15)
            GeneralFunctions.labelCustom_LTMedium(labelName: cell.timeLbl, fontSize: 12)
            
            GeneralFunctions.labelCustom_LTMedium(labelName: cell.nameLbl, fontSize: 14)
            
        }
        
        
        //cell.messageLbl.text = textArray[indexPath.row]
        cell.nameLbl.text = titleArray[indexPath.row]
        cell.titleLbl.text = textArray[indexPath.row]
        cell.timeLbl.text = timeArray[indexPath.row]
        cell.profilePic.sd_setImage(with: URL (string:profile_picArray[indexPath.row]))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        
    }
    
    
    
    //notifications service call
    
    func notificationsToShow()
    {
        
            if Reachability.isConnectedToNetwork()
            {
                MobileFixServices.sharedInstance.loader(view: self.view)
                
                let notificationsData = "\(base_path)services/notifications?"
               
                
                 //https://volive.in/mrhow_dev/services/notifications?api_key=1762019&lang=en&user_id=8
        
                  let myuserID = UserDefaults.standard.object(forKey: USER_ID) ?? ""
                let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
                let parameters: Dictionary<String, Any> = [ "api_key" :APIKEY,"lang":language,"user_id":myuserID ]
                
                Alamofire.request(notificationsData, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                    if let responseData = response.result.value as? Dictionary<String, Any>{
                        
                        print(responseData)
                        let status = responseData["status"] as! Int
                        let message = responseData["message"] as! String
                        if status == 1
                        {
                            if let unread = responseData["unread"] as? String
                            {
                                self.unreadNotifications = unread
                                if self.unreadNotifications != "0"
                                {
                                self.unreadNotificationsLbl.text = String(format: "%@%@%@", (self.unreadNotifications ?? "0")," ",languageChangeString(a_str: "Messages Unread") ?? "")
                                }
                                else
                                {
                                    self.unreadView.constant = 0
                                    self.view.layoutIfNeeded()
                                }
                                    //("\(self.unreadNotifications ?? "0") Messages Unread")
                                
                            }
                            if let response1 = responseData["data"] as? [[String:Any]]
                            {
                                
                                if(self.titleArray.count > 0)||(self.textArray.count > 0)||(self.typeArray.count > 0)||(self.seen_statusArray.count > 0)||(self.nameArray.count > 0)||(self.profile_picArray.count > 0)||(self.created_onArray.count > 0)||(self.timeArray.count > 0)
                                {
                                    self.titleArray.removeAll()
                                    self.textArray.removeAll()
                                    self.typeArray.removeAll()
                                    self.seen_statusArray.removeAll()
                                    self.nameArray.removeAll()
                                    self.profile_picArray.removeAll()
                                    self.created_onArray.removeAll()
                                    self.timeArray.removeAll()
                                  }
                                
                            MobileFixServices.sharedInstance.dissMissLoader()
                                for i in 0..<response1.count
                                {
                                    if let  profile_pic = response1[i]["profile_pic"] as? String
                                    {
                                        self.profile_picArray.append(base_path+profile_pic)
                                        
                                    }
                                    if let text = response1[i]["text"] as? String
                                    {
                                        self.textArray.append(text)
                                        
                                    }
                                    
                                    
                                    if let created_on = response1[i]["created_on"] as? String
                                    {
                                        self.created_onArray.append(created_on)
                                    }
                                    if let time = response1[i]["time"] as? String
                                    {
                                        self.timeArray.append(time)
                                        
                                    }
                                    if let name = response1[i]["name"] as? String
                                    {
                                        self.nameArray.append(name)
                                    }
                                    if let seen_status = response1[i]["seen_status"] as? String
                                    {
                                        self.seen_statusArray.append(seen_status)
                                        
                                    }
                                    if let type = response1[i]["type"] as? String
                                    {
                                        self.typeArray.append(type)
                                    }
                                    
                                   
                                    if let title = response1[i]["title"] as? String
                                    {
                                        self.titleArray.append(title)
                                    }
                                   
                                }
                                DispatchQueue.main.async {
                                    
                                    self.tableViewList.reloadData()
                                }
                                
                            }
                            
                            
                        }
                        else
                        {
                            MobileFixServices.sharedInstance.dissMissLoader()
                            self.view_unReadNotifiCount.backgroundColor = UIColor.white
                            self.showToastForAlert(message:message,style: style1)
                        }
                        
                    }
                    
                }
                
            }
            else{
                MobileFixServices.sharedInstance.dissMissLoader()
                showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!,style: style1)
            }
        }
        
        
}



