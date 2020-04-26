//
//  ContactUsVC.swift
//  MrHow
//
//  Created by volivesolutions on 15/05/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//
import Foundation
import UIKit
import MessageUI
import Alamofire


class ContactUsVC: UIViewController,MFMailComposeViewControllerDelegate {
    
    var emailToSend : String!
     @IBOutlet weak var txt_email           : UITextField!
     @IBOutlet weak var txt_phoneNumber     : UITextField!
     @IBOutlet weak var txt_message         : UITextField!
     @IBOutlet weak var btn_submit         : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        contactUS()
        
        txt_email.setBottomLineBorder()
        txt_phoneNumber.setBottomLineBorder()
        txt_message.setBottomLineBorder()
        
    }
    

    
    // MARK: - Back Button
    
    @IBAction func backBarBtnTap(_ sender: Any)
    {
         self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func submitBtnTap(_ sender: UIButton)
    {


        //TODO:  You should check if we can send email or not
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["you@yoursite.com"])
            mail.setSubject("Email Subject Here")
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            present(mail, animated: true)
        } else {
            print("Application is not able to send an email")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: "mailto:example@email.com")! as URL, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
        }
        
        self.tabBarController?.tabBar.isHidden = true
        
        
    }
    
    // contactus service call
    func contactUS()
    {
        
        if Reachability.isConnectedToNetwork()
        {
            
            MobileFixServices.sharedInstance.loader(view: self.view)
            //languageString = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? ""
            
            let contactUs = "\(base_path)services/contact_email?"
          
            let parameters: Dictionary<String, Any> = [ "api_key" :APIKEY , "lang": "en" ]
            
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
                           self.emailToSend = responceData1["email"] as? String
                            
                        }
                        DispatchQueue.main.async {
                            
                           
                        }
                    }
                    else
                    {
                        MobileFixServices.sharedInstance.dissMissLoader()
                        self.showToastForAlert(message: message,style: style1)
                    }
                }
            }
        }
        else{
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!,style: style1)
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
