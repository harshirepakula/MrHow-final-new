//
//  ProfileVC.swift
//  MrHow
//
//  Created by volivesolutions on 16/05/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit
import MessageUI
import Alamofire
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import FacebookLogin
import FacebookCore
import FBSDKLoginKit

import GoogleSignIn
import MOLH


class ProfileVC: UIViewController,MFMailComposeViewControllerDelegate {
    
    
    @IBOutlet weak var privateInformationImg: UIButton!
    @IBOutlet weak var videoOptionsImg: UIButton!
    @IBOutlet weak var notificationsImg: UIButton!
    
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var enrolledCourseLbl: UILabel!
    @IBOutlet weak var followTrainerLbl: UILabel!
    @IBOutlet weak var trainerView: UIView!
    @IBOutlet weak var enrolledSt: UILabel!
    @IBOutlet weak var followST: UILabel!
    @IBOutlet weak var registerAsTrainerLbl: UILabel!
    @IBOutlet weak var signoutBtn: UIButton!
    @IBOutlet weak var contactSt: UILabel!
    @IBOutlet weak var faqSt: UILabel!
    @IBOutlet weak var shareSt: UILabel!
    @IBOutlet weak var downloadSt: UILabel!
    @IBOutlet weak var aboutSt: UILabel!
    @IBOutlet weak var notificationSt: UILabel!
    @IBOutlet weak var videoOptionsSt: UILabel!
    @IBOutlet weak var privateST: UILabel!
    
     var pickedImage  = UIImage()
    var pickerImage  = UIImage()
    
    var fontStyle = ""
    var picker = UIImagePickerController()
    var user_idData = ""
    var nameData = ""
    var emailData = ""
    var phoneData = ""
    var genderData = ""
    var profile_picData = ""
    var video_qualityData = ""
    var wifi_onlyData = ""
    var background_videoData = ""
    var trainer_updatesData = ""
    var recommendationsData = ""
    var enrolled_coursesData = ""
    var followed_trainersData = ""
    var emailToSend : String = ""
    var unreadNotifications = ""
    var barButton : BBBadgeBarButtonItem?
    
    @IBOutlet weak var notificationBtn: UIBarButtonItem!
    
    let myuserID = UserDefaults.standard.object(forKey: USER_ID) ?? ""

    let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "ar"

    override func viewDidLoad() {
        super.viewDidLoad()

       
        contactUS()
        
        self.navigationController?.navigationBar.barTintColor = ThemeColor
        
        let customButton = UIButton(type: UIButton.ButtonType.custom)
        customButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        customButton.setImage(UIImage(named: "notification"), for: UIControl.State.normal)
        customButton.addTarget(self, action: #selector(notificationBtnTap), for: UIControl.Event.touchUpInside)
      
        barButton = BBBadgeBarButtonItem(customUIButton: customButton)
       
        barButton?.badgeBGColor = UIColor.white
        barButton?.badgeTextColor = UIColor.green
        barButton?.badgeOriginX = 0
        barButton?.badgeMinSize = 5
        barButton?.badgeOriginY = 0
        //barButton?.shouldHideBadgeAtZero = false
       self.navigationItem.rightBarButtonItem = barButton
      
       
    
        if language == "en"
        {
            fontStyle = "Poppins-SemiBold"
        }else
        {
            fontStyle = "29LTBukra-Bold"
        }
        
        if let aSize = UIFont(name:fontStyle , size: 18) {
            
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: aSize]
             self.navigationItem.title = languageChangeString(a_str: "Profile")
            print("font changed")
            
        }
        tabBarController?.tabBar.items?[0].title = languageChangeString(a_str: "Studio")
        tabBarController?.tabBar.items?[1].title = languageChangeString(a_str: "Discover")
        tabBarController?.tabBar.items?[2].title = languageChangeString(a_str: "My Courses")
        tabBarController?.tabBar.items?[3].title = languageChangeString(a_str: "Profile")
        
        self.privateST.text = languageChangeString(a_str: "Private Information")
        self.videoOptionsSt.text = languageChangeString(a_str: "Video Options")
        self.notificationSt.text = languageChangeString(a_str: "Notifications")
        self.aboutSt.text = languageChangeString(a_str: "About Us")
        self.shareSt.text = languageChangeString(a_str: "Share the App")
        self.faqSt.text = languageChangeString(a_str: "FAQs")
        self.contactSt.text = languageChangeString(a_str: "Contact us")
        self.enrolledSt.text = languageChangeString(a_str: "Enrolled Courses")
        self.followST.text = languageChangeString(a_str: "Followed trainers")
        
        self.registerAsTrainerLbl.text = languageChangeString(a_str: "Become MrHow Trainer")
        self.signoutBtn.setTitle(languageChangeString(a_str: "SIGN OUT"), for: UIControl.State.normal)
      
        if language == "ar"
        {
            
            GeneralFunctions.labelCustom_RTReg(labelName: enrolledSt, fontSize: 15)
            GeneralFunctions.labelCustom_RTReg(labelName: enrolledCourseLbl, fontSize: 15)
            GeneralFunctions.labelCustom_RTReg(labelName: followTrainerLbl, fontSize: 15)
            GeneralFunctions.labelCustom_RTReg(labelName: followST, fontSize: 15)
            GeneralFunctions.labelCustom_RTReg(labelName: privateST, fontSize: 16)
            GeneralFunctions.labelCustom_RTReg(labelName: videoOptionsSt, fontSize: 16)
            GeneralFunctions.labelCustom_RTReg(labelName: notificationSt, fontSize: 16)
            GeneralFunctions.labelCustom_RTReg(labelName: aboutSt, fontSize: 16)
            GeneralFunctions.labelCustom_RTReg(labelName: shareSt, fontSize: 16)
            GeneralFunctions.labelCustom_RTReg(labelName: faqSt, fontSize: 16)
            GeneralFunctions.labelCustom_RTReg(labelName: contactSt, fontSize: 16)
            GeneralFunctions.buttonCustom_RTBold(buttonName: signoutBtn, fontSize: 16)
            GeneralFunctions.labelCustom_RTReg(labelName: registerAsTrainerLbl, fontSize: 15)
            privateInformationImg.setImage(UIImage(named: "blackBack"), for: UIControl.State.normal)
            videoOptionsImg.setImage(UIImage(named: "blackBack"), for: UIControl.State.normal)
            notificationsImg.setImage(UIImage(named: "blackBack"), for: UIControl.State.normal)
            
        }
        else if language == "en"
        {
            GeneralFunctions.labelCustom_LTMedium(labelName: enrolledSt, fontSize: 15)
            GeneralFunctions.labelCustom_LTMedium(labelName: enrolledCourseLbl, fontSize: 15)
            GeneralFunctions.labelCustom_LTMedium(labelName: followTrainerLbl, fontSize: 15)
            GeneralFunctions.labelCustom_LTMedium(labelName: followST, fontSize: 15)
            GeneralFunctions.labelCustom_LTMedium(labelName: privateST, fontSize: 16)
            GeneralFunctions.labelCustom_LTMedium(labelName: videoOptionsSt, fontSize: 16)
            GeneralFunctions.labelCustom_LTMedium(labelName: notificationSt, fontSize: 16)
            GeneralFunctions.labelCustom_LTMedium(labelName: aboutSt, fontSize: 16)
            GeneralFunctions.labelCustom_LTMedium(labelName: shareSt, fontSize: 16)
            GeneralFunctions.labelCustom_LTMedium(labelName: faqSt, fontSize: 16)
            GeneralFunctions.labelCustom_LTMedium(labelName: contactSt, fontSize: 16)
            GeneralFunctions.buttonCustom_LTBold(buttonName: signoutBtn, fontSize: 16)
            GeneralFunctions.labelCustom_LTMedium(labelName: registerAsTrainerLbl, fontSize: 16)
            privateInformationImg.setImage(UIImage(named: "side"), for: UIControl.State.normal)
            videoOptionsImg.setImage(UIImage(named: "side"), for: UIControl.State.normal)
            notificationsImg.setImage(UIImage(named: "side"), for: UIControl.State.normal)
        
        }
        
    }
    
   @objc func notificationBtnTap()
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
   override func viewWillAppear(_ animated: Bool) {
    
        
        
        let tapRatings = UITapGestureRecognizer(target: self, action: #selector(tapFunction(sender:)))
        trainerView.isUserInteractionEnabled = true
        trainerView.addGestureRecognizer(tapRatings)
    
   NotificationCenter.default.addObserver(self, selector: #selector(notificationCount(_:)), name: NSNotification.Name(rawValue: "messageSent"), object: nil)
    
        profileDetails()
    
    }
    
    @objc func notificationCount(_ notification: Notification)
    {
        
        profileDetails()
    }
    
    
    
    
    
    @objc func tapFunction(sender:UITapGestureRecognizer)
    {

        
         let urlToGive = "\(base_path)home/switch_to_trainer?user_id=\(myuserID)" //"http://volive.in/mrhow_dev/home/switch_to_trainer?user_id=\(myuserID)"
              
        //"https://volive.in/mrhow_dev/"
        guard let url = URL(string: urlToGive) else { return }
            UIApplication.shared.open(url)
        }
    
    
      override func viewWillDisappear(_ animated: Bool) {
        
        // self.tabBarController?.tabBar.isHidden = true
    }
    
    
    // MARK: - Back Button
    
    @IBAction func backBarBtnTap(_ sender: Any)
    {
        navigationItem.hidesBackButton = true
        let stb = UIStoryboard(name: "Main", bundle: nil)
        let tabBar = stb.instantiateViewController(withIdentifier: "tabbar") as! TabBarControllerVC
        
        let nav = tabBar.viewControllers?[1] as! UINavigationController
        let studioVC = stb.instantiateViewController(withIdentifier: "DiscoverVC") as! DiscoverVC
        
        tabBar.selectedIndex = 1
        self.present(tabBar, animated: true) {
            nav.pushViewController(studioVC, animated: false)
        }
    }
    
    @IBAction func notificationBarBtnTap(_ sender: Any)
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func signOutBtnTap(_ sender: Any) {
        
      signoutService()
        
    }
    
    // signout service call
    
    func signoutService()
    {

            //internet connection
            
            if Reachability.isConnectedToNetwork()
            {
                MobileFixServices.sharedInstance.loader(view: self.view)
                
                let signOut = "\(base_path)services/logout"
                
               let myuserID = UserDefaults.standard.object(forKey: USER_ID) ?? ""
                let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
                let parameters: Dictionary<String, Any> =
                    ["lang" :language,"api_key":APIKEY,"user_id":myuserID
                                                          
                ]
                
                print(parameters)
                
                Alamofire.request(signOut, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                    if let responseData = response.result.value as? Dictionary<String, Any>{
                        print(responseData)
                        
                        let status = responseData["status"] as! Int
                        let message = responseData["message"] as! String
                        
                        MobileFixServices.sharedInstance.dissMissLoader()
                        if status == 1
                        {
                            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInVC") as! SignInVC

                            if  UserDefaults.standard.object(forKey:"loginType") as? String == "facebook"
                            {

                                 let loginManager = LoginManager()
                                let deletepermission = GraphRequest(graphPath: "me/permissions/", parameters: [:], httpMethod:.delete)
                                deletepermission.start(completionHandler: { (connection, result, error) in
                                    loginManager.logOut()
                                    loginManager.loginBehavior = .browser
                                    
                                    //https://www.facebook.com/logout.php?next=[YourAppURL]&access_token=[ValidAccessToken]

                                })
                              
                  
                            }else if UserDefaults.standard.object(forKey:"loginType") as? String == "google"
                            {
                                GIDSignIn.sharedInstance().signOut()
                            }
                            
                            // this is an instance function
                            
                            self.resetDefaults()
                            // MOLH.reset(transition: .transitionCrossDissolve)
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }
                        else
                        {
                            MobileFixServices.sharedInstance.dissMissLoader()
                          
                            self.showToastForAlert(message: message, style:style1)
                        }
                    }
                }
            }
                
            else
            {
                MobileFixServices.sharedInstance.dissMissLoader()
                showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!, style: style1)
                
            }
            
        }
    
    
   
    func resetDefaults() {
        
        let mycheck = UserDefaults.standard.object(forKey: "remeberValue") as? Int
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            if (key == "currentLanguage")
            {

            }
            else if(key == "userEmail" || key == "remeberValue" || key == "password")
            {
                if(mycheck == 0){

                    defaults.removeObject(forKey: key)

                }
            }
            else{

                    defaults.removeObject(forKey: key)

            }

        }

    }

    @IBAction func imageUploadAction(_ sender: Any) {
        let alert = UIAlertController(title: languageChangeString(a_str:"Choose Image"), message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: languageChangeString(a_str: "Camera"), style: .default){
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: languageChangeString(a_str:"Gallery"), style: .default){
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: languageChangeString(a_str:"Cancel"), style: .cancel){
            UIAlertAction in
        }
        
        // Add the actions
        self.picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }

    
    
    
    // MARK: - Video Button
    
    @IBAction func videoBtnTap(_ sender: Any)
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideoOptionsVC") as! VideoOptionsVC
        
        vc.downloasdViaWifi = self.wifi_onlyData
        vc.continueBackgroundVideo = self.background_videoData
         downloadVideoQuality = self.video_qualityData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
 
    
    
    @IBAction func contactBtnTap(_ sender: Any)
    {
            if MFMailComposeViewController.canSendMail()
            {
                contactUS()
                let mailComposeViewController = self.configuredMailComposeViewController()
                self.present(mailComposeViewController, animated: true, completion: nil)
                
               
           }
            else
            {
                self.showSendMailErrorAlert()
            }
        

    }
   
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        mailComposerVC.setToRecipients([self.emailToSend])
        mailComposerVC.setSubject(languageChangeString(a_str:"MrHow") ?? "")
        //mailComposerVC.setMessageBody("Sending E-mail", isHTML: false)
     
             return mailComposerVC
       }
    
    // contactus service call
    func contactUS()
    {
        
        if Reachability.isConnectedToNetwork()
        {
            
            MobileFixServices.sharedInstance.loader(view: self.view)
            let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
            
            let contactUs = "\(base_path)services/contact_email?"
            
            //https://volive.in/mrhow_dev/services/contact_email?api_key=1762019&lang=en
            
            let parameters: Dictionary<String, Any> = [ "api_key" :APIKEY , "lang":language]
            
            Alamofire.request(contactUs, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                
                if let responseData = response.result.value as? Dictionary<String, Any>{
                    //print(responseData)
                    
                    let status = responseData["status"] as! Int
                    let message = responseData["message"] as! String
                    if status == 1
                    {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        
                        if let responceData1 = responseData["data"] as? [String:AnyObject]
                        {
                            self.emailToSend = responceData1["email"] as? String ?? ""
                            
                        }
                        
                    }
                    else
                    {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.showToastForAlert(message: message, style: style1)
                    }
                }
            }
        }
        else{
            MobileFixServices.sharedInstance.dissMissLoader()
            
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!, style: style1)
            
        }
        
    }
    

    func showSendMailErrorAlert()
    {
        let sendMailErrorAlert = UIAlertView(title: languageChangeString(a_str:"Could Not Send Email"), message: languageChangeString(a_str:"Your device could not send e-mail.  Please check e-mail configuration and try again"), delegate: self, cancelButtonTitle: languageChangeString(a_str:"OK"))
         sendMailErrorAlert.show()
        
    }
    
    @IBAction func aboutUsBtnTap(_ sender: Any)
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC

        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    // MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        dismiss(animated: true, completion: nil)
    }

    

    @IBAction func questionBtnTap(_ sender: Any)
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FAQ_sViewController") as! FAQ_sViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func downLoadsBtnTap(_ sender: Any)
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DownloadsViewController") as! DownloadsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @IBAction func privateInformationBtnTap(_ sender: Any)
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PrivateInformationVC") as! PrivateInformationVC
        vc.email = self.emailData
        vc.phoneNumber = self.phoneData
        vc.gender = self.genderData
       
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func notifiSettingTap(_ sender: Any)
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationSettingVC") as! NotificationSettingVC
        vc.followTrainer  = self.trainer_updatesData
        vc.personalRecommen = self.recommendationsData
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
   
    
    @IBAction func shareTheAPPBtnTap(_ sender: UIButton)
    {
        let shareVC = UIActivityViewController(activityItems: ["Google.com"], applicationActivities: nil)
        shareVC.popoverPresentationController?.sourceView = self.view
        self.present(shareVC, animated: true, completion: nil)
    }
    
    
 // profiledata service call
    
    func profileDetails()
    {
            
            //internet connection
            
            if Reachability.isConnectedToNetwork()
            {
                MobileFixServices.sharedInstance.loader(view: self.view)
                
                let profile = "\(base_path)services/user_profile?"
                
                //https://volive.in/mrhow_dev/services/user_profile?api_key=1762019&lang=en&user_id=8
                
                let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
                
                
                
                let parameters: Dictionary<String, Any> = ["api_key":APIKEY,"lang" :language,"user_id":self.myuserID]
                
                print(parameters)
                
                Alamofire.request(profile, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                    if let responseData = response.result.value as? Dictionary<String, Any>{
                        print(responseData)
                        
                        let status = responseData["status"] as! Int
                        let message = responseData["message"] as! String
                        
                       
                        if status == 1
                        {
                            if let profileList = responseData["data"] as? [String:Any]
                            {
                                 if let profile_pic = profileList["profile_pic"] as? String
                                    {
                                        self.profile_picData = base_path+profile_pic
                                        UserDefaults.standard.set(self.profile_picData, forKey: "userImage")
                                  
                                     }

                                
                                    if let name = profileList["name"] as? String
                                    {
                                        self.nameData = name
                                        
                                    }
                                    if let email = profileList["email"] as? String
                                    {
                                        self.emailData = email
                                        
                                    }
                                    if let phone = profileList["phone"] as? String
                                    {
                                        self.phoneData = phone
                                        
                                    }
                                    if let gender = profileList["gender"] as? String
                                    {
                                        self.genderData = gender
                                        
                                    }
                                    if let video_quality = profileList["video_quality"] as? String
                                    {
                                         self.video_qualityData = video_quality
                                        
                                    }
                                    if let wifi_only = profileList["wifi_only"] as? String
                                    {
                                       self.wifi_onlyData = wifi_only
                                        
                                    }
                                    if let background_video = profileList["background_video"] as? String
                                    {
                                        self.background_videoData = background_video
                                        
                                    }
                                    if let trainer_updates = profileList["trainer_updates"] as? String
                                    {
                                         self.trainer_updatesData = trainer_updates
                                        
                                    }
                                    if let recommendations = profileList["recommendations"] as? String
                                    {
                                        self.recommendationsData = recommendations
                                        
                                    }
                                    if let enrolled_courses = profileList["enrolled_courses"] as? String
                                    {
                                       self.enrolled_coursesData = enrolled_courses
                                        
                                    }
                                  if let followed_trainers = profileList["followed_trainers"] as? String
                                  {
                                     self.followed_trainersData = followed_trainers
                                    
                                 }
                                if let unread = profileList["unread"] as? String
                                {
                                    self.unreadNotifications = unread
                                    
                                }
                                
                                DispatchQueue.main.async {
                                 
                                    let image = UserDefaults.standard.object(forKey:"userImage") as? String
                                    self.userImg.sd_setImage(with: URL (string: image ?? ""), placeholderImage:
                                        UIImage(named:""))
                                    
                                    self.barButton?.badgeValue = self.unreadNotifications
                                    
                                    let image1 = UIImage(data: try! Data(contentsOf: URL(string:image!)!))
                                    
                                  
                                    let thumb3 = image1?.resize(targetSize: CGSize(width: 35, height: 35))
                                    
                                    
                                    
                                    self.tabBarController!.tabBar.items?[3].selectedImage =
                                        thumb3?.roundedImage.withRenderingMode(.alwaysOriginal)
                                    self.tabBarController!.tabBar.items?[3].image =
                                        thumb3?.roundedImage.withRenderingMode(.alwaysOriginal)
                                    
                                    MobileFixServices.sharedInstance.dissMissLoader()
                                    self.userNameLbl.text = self.nameData
                                    self.enrolledCourseLbl.text = self.enrolled_coursesData
                                    self.followTrainerLbl.text = self.followed_trainersData
                                   
                                    self.userImg.layer.borderWidth = 1
                                    self.userImg.clipsToBounds = true
                                    self.userImg.layer.cornerRadius = self.userImg.frame.size.width/2
                                    self.userImg.layer.masksToBounds = true
                                }
                                

                  
                  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "privateInformation"), object: nil, userInfo: ["email":self.emailData,"phoneNumber":self.phoneData,"gender":self.genderData])
                                
                            }
                            
                        }
                        else
                        {
                            MobileFixServices.sharedInstance.dissMissLoader()
                            self.showToastForAlert(message:message, style: style1)
                        }
                        
                        
                    }
                    
                }
            }
            else
            {
                MobileFixServices.sharedInstance.dissMissLoader()
                showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!, style: style1)
                
            }
            
        }
    
    
    
}
extension ProfileVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate
{

    func openCamera(){
        
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        } else {
            showToastForAlert(message: languageChangeString(a_str:"You don't have camera") ?? "", style: style1)
            
           
            
        }
    }
    func openGallery(){
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let img = info[.editedImage] as? UIImage
        {
            pickedImage = img
        }
        else if let img = info[.originalImage] as? UIImage
        {
            pickedImage = img
        }
        
        print("picked image",pickedImage)
        picker.dismiss(animated: true, completion: nil)
        userImg.image = pickedImage
        pickerImage = pickedImage

        self.userImg.layer.borderWidth = 1
        //self.userImg.layer.masksToBounds = false
        self.userImg.layer.borderColor = UIColor.black.cgColor
        self.userImg.layer.cornerRadius = self.userImg.frame.height/2
        self.userImg.clipsToBounds = true
       // self.userImg.layer.cornerRadius = self.userImg.frame.size.width/2
        self.userImg.layer.masksToBounds = true
        self.userImg.image = pickedImage
        //self.uploadPicture(myPicture: image)
        let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
        self.postAProduct(lang:language , myPicture: pickedImage)
        
    }
    
    func alertController (title: String,msg: String) {
        
        let alert = UIAlertController.init(title:title , message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
 
    
    func postAProduct(lang:String , myPicture: UIImage)
    {
        if Reachability.isConnectedToNetwork()
        {
        //showLoading(view: self.view)
        MobileFixServices.sharedInstance.loader(view: self.view)
        
        let myuserID = UserDefaults.standard.object(forKey: USER_ID) ?? ""
        
        let parameters: [String : Any] = ["api_key":APIKEY,
                                          "lang":lang ,
                                          "user_id" : myuserID
        ]
        print(parameters)
        
        let  url = "\(base_path)services/update_profile_pic"
            //"https://volive.in/mrhow_dev/services/update_profile_pic"
        print(url)
 
            let imageData1 = pickerImage.jpegData(compressionQuality: 0.2)!
            //print(imageData1)
            Alamofire.upload(multipartFormData: { multipartFormData in
            // import image to request
            
            
                multipartFormData.append(imageData1, withName: "profile_pic", fileName: "file.jpg", mimeType: "image/jpeg")
            
            
            for (key, value) in parameters {
                
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
             }
            
        }, to: url,method:.post,
           
           encodingCompletion:
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.responseJSON{ response in
                        
                        print("response data is :\(response)")
                        
                        if let responseData = response.result.value as? Dictionary <String,Any>{
                            
                            let status = responseData["status"] as! Int
                            let message = responseData ["message"] as! String
                            
                          if status == 1{
                                
                                let dic : Dictionary<String,Any> = responseData["data"] as! Dictionary
                                
                                if let profile = dic["profile_pic"] as? String
                                {
                                    let imageStr = base_path+profile
                                    
                                    UserDefaults.standard.set(imageStr, forKey: "userImage")
                                   
                                    let image = UserDefaults.standard.object(forKey: "userImage") as? String
                                    
                                    DispatchQueue.main.async {

                                        self.userImg.sd_setImage(with: URL (string: image ?? ""), placeholderImage:
                                            UIImage(named: ""))
                                       
                                        
                                        let image1 = UIImage(data: try! Data(contentsOf: URL(string:image!)!))
                                        
                                      
                                       let thumb3 = image1?.resize(targetSize: CGSize(width: 35, height: 35))
                                        
                                      
                                        self.tabBarController!.tabBar.items?[3].selectedImage =
                                            thumb3?.roundedImage.withRenderingMode(.alwaysOriginal)
                                        self.tabBarController!.tabBar.items?[3].image =
                                           thumb3?.roundedImage.withRenderingMode(.alwaysOriginal)
                                        
                                       
                                    }
                                    
                                }
                            

                            
                                MobileFixServices.sharedInstance.dissMissLoader()
                            self.showToastForAlert(message: message, style: style1)
                                
                            }else{
                                MobileFixServices.sharedInstance.dissMissLoader()
                            self.showToastForAlert(message: message, style: style1)
                                
                            }
                        }
                        
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    MobileFixServices.sharedInstance.dissMissLoader()
                  
                }
                
        })
        }
        else{
            MobileFixServices.sharedInstance.dissMissLoader()
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!, style: style1)
            
        }
    }
}

extension UIImage {
    
    func resize(targetSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size:targetSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
}



extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvas = CGSize(width: width, height: width)
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}
