//
//  ForgotPasswordVC.swift
//  MrHow
//
//  Created by Dr Mohan Roop on 7/5/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit
import Alamofire
import MOLH

class ForgotPasswordVC: UIViewController
{

    @IBOutlet weak var forgotSt: UILabel!
    @IBOutlet weak var useEmailTF: UITextField!
    
    @IBOutlet weak var submitBtn: UIButton!
    
      let language = UserDefaults.standard.object(forKey: "currentLanguage") as? String ?? "en"
   
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        if language == "ar"
        {
            self.useEmailTF.textAlignment = .right
            self.useEmailTF.setPadding(left: -10, right: -10)
            GeneralFunctions.labelCustom_RTReg(labelName: forgotSt, fontSize: 13)
            GeneralFunctions.buttonCustom_RTBold(buttonName: submitBtn, fontSize: 16)
           
             self.useEmailTF.font = UIFont(name: "29LTBukra-Regular", size: 12)
            GeneralFunctions.textPlaceholderText_RTLight(textFieldName:useEmailTF, strPlaceHolderName: languageChangeString(a_str: "Email Address") ?? "")
            
        }
        else if language == "en"{
            self.useEmailTF.textAlignment = .left
            self.useEmailTF.setPadding(left: 10, right: 10)
            GeneralFunctions.labelCustom_LTReg(labelName: forgotSt, fontSize: 13)
            GeneralFunctions.buttonCustom_LTBold(buttonName: submitBtn, fontSize: 16)
            GeneralFunctions.textPlaceholderText_LTLight(textFieldName:useEmailTF, strPlaceHolderName: languageChangeString(a_str: "Email Address") ?? "")
              self.useEmailTF.font = UIFont(name: "Poppins-Regular", size: 12)
        }
        
        
        self.forgotSt.text = languageChangeString(a_str: "Forgot PassWord")
       //self.useEmailTF.placeholder = languageChangeString(a_str: "Email Address")
       self.submitBtn.setTitle(languageChangeString(a_str: "SUBMIT"), for: UIControl.State.normal)
      
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        
        
    }
    
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }

    
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func submitBtnTap(_ sender: Any)
    {
        forgotPassword()
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func signUpBtnTap(_ sender: Any) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
// forgot password service call
    
  func forgotPassword()
  {
    //internet connection
    
      if Reachability.isConnectedToNetwork()
      {
        MobileFixServices.sharedInstance.loader(view: self.view)
    
         let forgot = "\(base_path)services/forgot_password"
    
    
           let parameters: Dictionary<String, Any> = [ "email":self.useEmailTF.text ?? "","lang":language,"api_key":APIKEY]
    
           print(parameters)
    
         Alamofire.request(forgot, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            if let responseData = response.result.value as? Dictionary<String, Any>{
                 print(responseData)
    
               let status = responseData["status"] as! Int
               let message = responseData["message"] as! String
    
               if status == 1
               {
                
                MobileFixServices.sharedInstance.dissMissLoader()
               
                 self.showToastForAlert(message: message,style: style2)
                print(style2)
         
                }
                else
                   {
                       MobileFixServices.sharedInstance.dissMissLoader()
                       self.showToastForAlert(message: message,style: style2)
                    }
               }
           }
      }
        else
        {
              MobileFixServices.sharedInstance.dissMissLoader()
             showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!,style: style2)
         }
    
    }
    
}
