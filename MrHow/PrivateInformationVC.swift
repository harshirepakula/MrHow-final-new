//
//  PrivateInformationVC.swift
//  MrHow
//
//  Created by volivesolutions on 16/05/19.
//  Copyright © 2019 volivesolutions. All rights reserved.
//

import UIKit
import Alamofire
import MOLH

class PrivateInformationVC: UIViewController,UITextFieldDelegate{
    
    var email = ""
    var phoneNumber = ""
    var gender = ""
    //var language = ""
    var edit = false
    
    //PICKERVIEW PROPERTIES
    var pickerView : UIPickerView?
    var pickerToolBar : UIToolbar?
    var textfieldCheckValue : Int!
    var genderArray = [String]()
    
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var genderTF: UITextField!
  
    @IBOutlet weak var editBtn: UIBarButtonItem!
    
    @IBOutlet weak var phoneSt: UILabel!
    @IBOutlet weak var emailSt: UILabel!
    
    @IBOutlet weak var genderSt: UILabel!
    
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
        
        self.navigationController?.navigationBar.barTintColor = ThemeColor
        if let aSize = UIFont(name:fontStyle, size: 18) {
            
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: aSize]
            self.navigationItem.title = languageChangeString(a_str: "Private Information")
            print("font changed")
            
        }
        
        self.emailSt.text = languageChangeString(a_str: "Email")
        self.phoneSt.text = languageChangeString(a_str: "Phone")
        self.genderSt.text = languageChangeString(a_str: "Gender")
        
    }
   
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = true
        self.editBtn.title = languageChangeString(a_str: "Edit")
        
        genderArray = [languageChangeString(a_str: "Male"),languageChangeString(a_str: "Female")] as? [String] ?? [""]
        
        genderTF.delegate = self
        self.emailTF.text = self.email
        self.phoneTF.text = self.phoneNumber
        if self.gender == "1"
        {
            self.genderTF.text = languageChangeString(a_str:"Male")
        }
        else if self.gender == "2"
        {
            self.genderTF.text = languageChangeString(a_str:"Female")
        }
        
        emailTF.isUserInteractionEnabled = false
        phoneTF.isUserInteractionEnabled = false
        genderTF.isUserInteractionEnabled = false
        
        if language == "ar"
        {
             self.emailTF.textAlignment = .right
             self.phoneTF.textAlignment = .right
             self.genderTF.textAlignment = .right
             self.emailTF.setPadding(left: -10, right: -10)
             self.phoneTF.setPadding(left: -10, right: -10)
             self.genderTF.setPadding(left: -10, right: -10)
            GeneralFunctions.labelCustom_RTReg(labelName: emailSt, fontSize: 13)
            GeneralFunctions.labelCustom_RTReg(labelName: phoneSt, fontSize: 13)
            GeneralFunctions.labelCustom_RTReg(labelName: genderSt, fontSize: 13)
            editBtn.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "29LTBukra-Regular", size: 16) ?? 10], for: UIControl.State.normal)
            
        }
        else if language == "en"
        {
            self.emailTF.textAlignment = .left
            self.phoneTF.textAlignment = .left
            self.genderTF.textAlignment = .left
            self.emailTF.setPadding(left: 10, right: 10)
            self.phoneTF.setPadding(left: 10, right: 10)
            self.genderTF.setPadding(left: 10, right: 10)
            GeneralFunctions.labelCustom_LTMedium(labelName: emailSt, fontSize: 13)
            GeneralFunctions.labelCustom_LTMedium(labelName: phoneSt, fontSize: 13)
            GeneralFunctions.labelCustom_LTMedium(labelName: genderSt, fontSize: 13)
            editBtn.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 16) ?? 10], for: UIControl.State.normal)
            
        
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(videoOptionsData(_:)), name:  NSNotification.Name(rawValue: "privateInformation"), object: nil)
        
    }
    
    
    @objc func videoOptionsData(_ notification: Notification) {
        if let userEmail = notification.userInfo?["email"] as? String {
            emailTF.text = userEmail
        }
        if let phone = notification.userInfo?["phoneNumber"] as? String {
            phoneTF.text = phone
        }
        if let userGender = notification.userInfo?["gender"] as? String {
            genderTF.text = userGender
        }
        
    }
    
    //MARK:- TextField Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField == genderTF
         {
            self.pickUp(genderTF)
         }
        
    }
    

// MARK: - Back Button
    
    @IBAction func backBarBtnTap(_ sender: Any)
    {
      self.navigationController?.popViewController(animated: true)
        edit = false

    }
    
    
    
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        
      self.tabBarController?.tabBar.isHidden = false
    
    }
  

    
    @IBAction func editBtnTap(_ sender: Any)
    {
       
        if edit == true
        {
            self.editBtn.title = languageChangeString(a_str: "Edit")
            //"Edit"
            emailTF.isUserInteractionEnabled = false
            phoneTF.isUserInteractionEnabled = false
            genderTF.isUserInteractionEnabled = false
            
            emailTF.resignFirstResponder()
            phoneTF.resignFirstResponder()
            genderTF.resignFirstResponder()
            
            if emailTF.text == "" || emailTF.text == nil &&
                phoneTF.text == "" || phoneTF.text == nil &&
                gender ==  ""
            {
               
                self.showToastForAlert (message: languageChangeString(a_str: "All details are required") ?? "",style: style1)
                
                
            }

            if MobileFixServices.sharedInstance.isValidEmail(testStr: self.emailTF.text ?? "") != true
            {
                self.showToastForAlert(message: languageChangeString(a_str: "Please enter valid email") ?? "", style: style1)
                
            }
           
            else{
                     self.editProfile()
            }
             edit = false
            
        }
        else if edit == false
        {
            self.editBtn.title = languageChangeString(a_str: "Save")
            emailTF.isUserInteractionEnabled = true
            phoneTF.isUserInteractionEnabled = true
            genderTF.isUserInteractionEnabled = true
            emailTF.becomeFirstResponder()
            edit = true
            
        }
        
    }
    
    
    // EDIT profile post service call
    
    func editProfile()
    {
        
        //internet connection
        
        if Reachability.isConnectedToNetwork()
        {
            MobileFixServices.sharedInstance.loader(view: self.view)
            
           
           
           
                let editProfile = "\(base_path)services/edit_profile"
            
            let myuserID = UserDefaults.standard.object(forKey: USER_ID) ?? ""
            
            let parameters: Dictionary<String, Any> = ["api_key":APIKEY,"lang": language,"user_id":myuserID,"email":self.emailTF.text ?? "","phone":self.phoneTF.text ?? "","gender":gender]
                
                print(parameters)
                
                Alamofire.request(editProfile, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseJSON { response in
                    if let responseData = response.result.value as? Dictionary<String, Any>{
                        print(responseData)
                        
                        let status = responseData["status"] as! Int
                        let message = responseData["message"] as! String
                        
                        if status == 1
                        {
                           
                            if let response1 = responseData["data"] as? Dictionary<String, AnyObject>
                            {

                                MobileFixServices.sharedInstance.dissMissLoader()
                                
                                if let userEmail = response1["email"] as? String
                                {
                                    self.email = userEmail
                                }
                                if let phone = response1["phone"] as? String
                                {
                                    self.phoneNumber = phone
                                }
                                if let userGender = response1["gender"] as? String
                                {
                                    self.gender = userGender
                                }
                                
                                
                                DispatchQueue.main.async {
                                   
                                    self.emailTF.text = self.email
                                    self.phoneTF.text = self.phoneNumber
                                    if self.gender == "1"
                                    {
                                        self.genderTF.text = languageChangeString(a_str: "Male")
                                    }
                                    else if self.gender == "2"
                                    {
                                        self.genderTF.text = languageChangeString(a_str: "Female")
                                    }
                                    self.showToastForAlert(message: message, style: style1)
            
                                }
                                
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
            
        else
        {
            MobileFixServices.sharedInstance.dissMissLoader()
            showToastForAlert (message: languageChangeString(a_str: "Please ensure you have proper internet connection")!, style: style1)
            
        }
        
    }
    
    
    
    
    
    //   MARK: - Custom PickerView
    func pickUp(_ textField : UITextField){
        
        // UIPickerView
        self.pickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.pickerView?.delegate = self
        self.pickerView?.dataSource = self
        self.pickerView?.backgroundColor = UIColor(red: 247.0 / 255.0, green: 248.0 / 255.0, blue: 247.0 / 255.0, alpha: 1)
        textField.inputView = self.pickerView
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.white
        toolBar.barTintColor = #colorLiteral(red: 0.2913166881, green: 0.8098286986, blue: 0.7646555305, alpha: 1)
        //  toolBar.backgroundColor = UIColor.blue
        
        toolBar.sizeToFit()
        
        let doneButton1 = UIBarButtonItem(title:languageChangeString(a_str: "Done"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePickerView))
        doneButton1.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
        let cancelButton1 = UIBarButtonItem(title:languageChangeString(a_str: "Cancel"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelPickerView))
        cancelButton1.tintColor = #colorLiteral(red: 0.9895833333, green: 1, blue: 1, alpha: 1)
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.items = [cancelButton1, spaceButton, doneButton1]
        //pickerToolBar?.items = [cancelButton1, spaceButton, doneButton1]
        textField.inputAccessoryView = toolBar
        
        
    }
    
    @objc func donePickerView(){
       
        self.genderTF.resignFirstResponder()
        self.genderTF.text = genderArray[(pickerView?.selectedRow(inComponent: 0))!]
        
        if self.genderTF.text == languageChangeString(a_str: "Female")
        {
            self.gender = "2"
            
        }else
        {
            self.gender = "1"
        }
        
    }
    
    
    @objc func cancelPickerView(){
        
        self.genderTF.resignFirstResponder()
        
    }
    
    
  
}

extension PrivateInformationVC : UIPickerViewDataSource,UIPickerViewDelegate{
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
       return self.genderArray.count
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return self.genderArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
         self.genderTF.text = self.genderArray[row]
            
        }
    
}









